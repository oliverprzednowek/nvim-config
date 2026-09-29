local M = {}
local api = vim.api

local function warn(message)
	vim.notify(message, vim.log.levels.WARN, { title = "CodeCompanion" })
end

local function source_buffer()
	if vim.bo.buftype ~= "" then
		warn("Open a source file first.")
		return false
	end
	return true
end

-- Strip delimiters literally; comment syntax can contain Lua pattern characters.
local function unwrap(text, template)
	local opening, closing = template:match("^(.-)%%s(.-)$")
	if not opening then
		return
	end
	opening, closing = vim.trim(opening), vim.trim(closing)
	text = vim.trim(text)
	if opening == "" or text:sub(1, #opening) ~= opening then
		return
	end
	if closing ~= "" and text:sub(-#closing) ~= closing then
		return
	end
	return vim.trim(text:sub(#opening + 1, closing == "" and -1 or -#closing - 1))
end

function M.comment_prompt()
	local pos = api.nvim_win_get_cursor(0)
	local line = api.nvim_get_current_line()
	local text, first_line
	-- Tree-sitter recognizes block comments and rejects strings containing comment text.
	local parsed = pcall(function()
		vim.treesitter.get_parser(0):parse()
	end)
	if parsed then
		for _, col in ipairs({ pos[2], (line:find("%S") or 1) - 1 }) do
			local ok, node = pcall(vim.treesitter.get_node, { pos = { pos[1] - 1, col } })
			if ok then
				while node do
					if node:type():lower():find("comment", 1, true) then
						text = vim.treesitter.get_node_text(node, 0)
						first_line = node:start() + 1
					end
					node = node:parent()
				end
			end
			if text then
				break
			end
		end
		if not text then
			return nil
		end
	end
	local templates = { vim.bo.commentstring }
	if text then
		-- Try complete block delimiters before shorter line-comment prefixes.
		templates = {
			"/** %s */",
			"/* %s */",
			"<!-- %s -->",
			"--[[ %s ]]",
			"// %s",
			"-- %s",
			"# %s",
			"; %s",
			vim.bo.commentstring,
		}
		local equals = text:match("^%-%-%[(=*)%[")
		if equals then
			table.insert(templates, 1, "--[" .. equals .. "[%s]" .. equals .. "]")
		end
	end
	for _, template in ipairs(templates) do
		local body = unwrap(text or line, template)
		if body then
			body = body:gsub("^%*%s*", ""):gsub("\n%s*%*%s?", "\n")
			local instruction = body:match("^gippity%s+(.+)$") or body:match("^gippity:%s*(.+)$")
			if instruction and vim.trim(instruction) ~= "" then
				return vim.trim(instruction), first_line or pos[1]
			end
		end
	end
end

local function capture()
	if not source_buffer() then
		return
	end
	local context = require("codecompanion.utils.context").get()
	if vim.fn.mode() == "\22" then
		warn("Use a character or line selection instead of a rectangular selection.")
		return
	end
	local selected = context.is_visual
	if not selected then
		context.lines = api.nvim_buf_get_lines(0, 0, -1, false)
		context.start_line, context.start_col = 1, 1
		context.end_line, context.end_col = #context.lines, #context.lines[#context.lines]
		context.is_visual, context.is_normal = true, false
	end
	context.code = table.concat(context.lines, "\n")
	return { context = context, selected = selected, tick = api.nvim_buf_get_changedtick(0) }
end

local function submit(snapshot, instruction)
	local ctx = snapshot.context
	if not api.nvim_buf_is_valid(ctx.bufnr) or api.nvim_buf_get_changedtick(ctx.bufnr) ~= snapshot.tick then
		warn("The source changed while you were prompting. Invoke the shortcut again.")
		return
	end
	local inline = require("codecompanion.interactions.inline").new({
		buffer_context = ctx,
		placement = "replace",
		opts = { stop_context_insertion = not snapshot.selected },
	})
	if not inline then
		return
	end
	local target = snapshot.selected
			and "Change only the selected code. Return the complete replacement for that selection."
		or "Edit the supplied current file. Return the complete updated file, preserving unrelated code."
	inline:prompt("#{buffer} " .. target .. "\n" .. instruction)
end

function M.inline()
	local snapshot = capture()
	if not snapshot then
		return
	end
	-- Freeze the selection before vim.ui.input leaves Visual mode.
	if snapshot.selected then
		api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
	end
	vim.ui.input({ prompt = "Edit current " .. (snapshot.selected and "selection" or "file") .. ": " }, function(input)
		if input and vim.trim(input) ~= "" then
			submit(snapshot, input)
		end
	end)
end

function M.comment()
	if not source_buffer() then
		return
	end
	local instruction, line = M.comment_prompt()
	if not instruction then
		warn("Put the cursor on a comment starting with 'gippity', followed by an instruction.")
		return
	end
	local snapshot = capture()
	if snapshot then
		submit(
			snapshot,
			string.format(
				"Follow the gippity instruction at line %d. Remove that instruction comment in the proposed edit.\n%s",
				line,
				instruction
			)
		)
	end
end

local function attach(chat, context, refresh)
	chat.buffer_context = context
	local renderer = require("codecompanion.interactions.shared.editor_context.buffer").new({ Chat = chat })
	for _, item in ipairs(chat.context_items or {}) do
		if item.bufnr == context.bufnr then
			item.opts = item.opts or {}
			item.opts.sync_all = true
			item.opts.sync_diff = false
			if refresh then
				renderer:chat_render({ bufnr = context.bufnr }, { sync_all = true })
			end
			return
		end
	end
	renderer:chat_render({ bufnr = context.bufnr, params = "all" })
end

function M.chat(refresh)
	local cc = require("codecompanion")
	if vim.bo.filetype == "codecompanion" then
		if not refresh then
			return cc.toggle_chat()
		end
		local chat = cc.buf_get_chat(api.nvim_get_current_buf())
		if chat and chat.buffer_context and api.nvim_buf_is_valid(chat.buffer_context.bufnr) then
			attach(chat, chat.buffer_context, true)
		end
		return
	end
	if not source_buffer() then
		return
	end
	local context = require("codecompanion.utils.context").get()
	local chat = cc.last_chat()
	if not chat then
		chat = cc.chat({ context = context, auto_submit = false, stop_context_insertion = true })
	else
		chat.ui:open()
	end
	if chat then
		attach(chat, context, refresh)
	end
end

return M
