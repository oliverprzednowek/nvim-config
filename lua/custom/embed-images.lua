local M = {}

-- Function to save clipboard image and insert the path in the markdown file
M.insert_image_from_clipboard = function()
    local file_path = vim.fn.expand("%:p")
    local dir_path = vim.fn.fnamemodify(file_path, ":h") .. "/.img"
    local image_name = os.date("%Y-%m-%d-%H-%M-%S") .. ".png"
    local image_path = dir_path .. "/" .. image_name

    -- Create the .img directory if it doesn't exist
    vim.fn.mkdir(dir_path, "p")

    -- Try using wl-paste first (Wayland), fallback to xclip (X11)
    local save_cmd = string.format(
        [[bash -c 'if command -v wl-paste >/dev/null; then wl-paste --type image/png > "%s"; elif command -v xclip >/dev/null; then xclip -selection clipboard -t image/png -o > "%s"; else exit 1; fi']],
        image_path, image_path
    )

    local result = vim.fn.system(save_cmd)

    if vim.v.shell_error ~= 0 or vim.fn.filereadable(image_path) == 0 then
        print("Error saving the clipboard image. Make sure an image is in the clipboard and that xclip or wl-paste is installed.")
        return
    end

    local relative_path = ".img/" .. image_name
    local markdown_image_syntax = string.format("![Image](%s)", relative_path)
    vim.api.nvim_put({ markdown_image_syntax }, "c", false, true)

    print("Image saved to: " .. image_path)
end

return M
