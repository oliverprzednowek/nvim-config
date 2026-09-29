-- Run: nvim --headless -u NONE -l tests/ai.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter")
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/codecompanion.nvim")
local api = vim.api
local ai = require("custom.ai")
local count = 0
local function eq(actual, expected, label)
	assert(vim.deep_equal(actual, expected), label .. ": " .. vim.inspect(actual))
	count = count + 1
end
local function buffer(ft, commentstring, lines, row, col)
	vim.cmd("enew!")
	vim.bo.filetype, vim.bo.commentstring = ft, commentstring
	api.nvim_buf_set_lines(0, 0, -1, false, lines)
	api.nvim_win_set_cursor(0, { row or 1, col or 0 })
end
for _, case in ipairs({
	{ "java", "// %s", { "// gippity implement this" }, "implement this" },
	{ "python", "# %s", { "# gippity: simplify this" }, "simplify this" },
	{ "lua", "-- %s", { "-- gippity fix this" }, "fix this" },
	{ "c", "/* %s */", { "// gippity fix this" }, "fix this" },
	{ "c", "/* %s */", { "/* gippity fix this */" }, "fix this" },
	{
		"c",
		"/* %s */",
		{ "/**", " * gippity explain this", " * and simplify it", " */" },
		"explain this\nand simplify it",
		2,
		4,
	},
	{ "lua", "-- %s", { "--[[ gippity fix", "this ]]" }, "fix\nthis", 1, 12 },
	{ "lua", "-- %s", { "--[=[ gippity fix this ]=]" }, "fix this", 1, 12 },
	{ "sh", "# %s", { "# gippity fix this" }, "fix this" },
	{ "html", "<!-- %s -->", { "<!-- gippity fix this -->" }, "fix this" },
	{ "vim", '" %s', { '" gippity fix this' }, "fix this" },
	{ "lua", "-- %s", { "-- gippity" }, nil },
	{ "lua", "-- %s", { "-- gippityish not a command" }, nil },
	{ "lua", "-- %s", { "-- @gippity not a command" }, nil },
	{ "lua", "-- %s", { 'local s = "-- gippity not a comment"' }, nil, 1, 20 },
	{ "python", "# %s", { 'text = """', "# gippity still a string", '"""' }, nil, 2 },
}) do
	buffer(case[1], case[2], case[3], case[5], case[6])
	eq(ai.comment_prompt(), case[4], case[1] .. ": " .. case[3][1])
end
local request, prompt
package.loaded["codecompanion.interactions.inline"] = {
	new = function(args)
		request = args
		return {
			prompt = function(_, value)
				prompt = value
			end,
		}
	end,
}
vim.ui.input = function(_, cb)
	cb("simplify it")
end
buffer("lua", "-- %s", { "-- gippity return 2", "return 1" })
ai.comment()
eq(request.placement, "replace", "comment placement")
eq(request.buffer_context.end_line, 2, "full file target")
assert(prompt:find("#{buffer}", 1, true) and prompt:find("return 2", 1, true))
eq(api.nvim_get_current_line(), "-- gippity return 2", "comment is not removed before review")
request = nil
vim.cmd("normal! jV")
ai.inline()
eq(request.buffer_context.start_line, 2, "selection starts on line 2")
eq(request.buffer_context.end_line, 2, "selection ends on line 2")
eq(request.buffer_context.lines, { "return 1" }, "only selected code is target")
assert(prompt:find("#{buffer}", 1, true))
request = nil
vim.ui.input = function(_, cb)
	cb(nil)
end
ai.inline()
eq(request, nil, "cancel does not submit")
vim.notify = function() end
vim.ui.input = function(_, cb)
	api.nvim_buf_set_lines(0, 0, 1, false, { "-- changed during prompt" })
	cb("edit it")
end
ai.inline()
eq(request, nil, "changed source does not submit stale range")
print("PASS: " .. count .. " comment, context, selection, and cancellation checks")
