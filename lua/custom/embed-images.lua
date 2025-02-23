local M = {}

-- Function to detect the platform
-- probably unused in this branch
M.get_os = function()
    local os_name = vim.loop.os_uname().sysname
    if os_name == "Windows_NT" then
        return "Windows"
    elseif os_name == "Linux" then
        -- Check if running in WSL
        local wsl_version = io.popen("grep -i microsoft /proc/version"):read("*a")
        if wsl_version ~= "" then
            return "WSL2"
        end
    end
    return os_name
end

-- Function to save clipboard image and insert the path in the markdown file
M.insert_image_from_clipboard = function()
    -- Get the full path of the current markdown file

    local file_path = vim.fn.expand("%:p")
    local dir_path = vim.fn.fnamemodify(file_path, ":h") .. "/.img" -- Directory to save the image
    local image_name = os.date("%Y-%m-%d-%H-%M-%S") .. ".png"       -- Unique name for the image
    local image_path = dir_path .. "/" .. image_name                -- Full path for the image

    -- Create the .img directory if it doesn't exist
    vim.fn.mkdir(dir_path, "p")

    -- Call the PowerShell script to save the clipboard image to the image path
    local powershell_command = string.format(
        [[powershell.exe -ExecutionPolicy Bypass -File "C:\\Users\\olive\\scripts\\save_clipboard_image.ps1" "%s"]],
        image_path
    )
    local result = vim.fn.system(powershell_command)

    -- Check if the PowerShell command was successful
    if vim.v.shell_error ~= 0 then
        print("Error saving the clipboard image. Make sure an image is in the clipboard.")
        return
    end

    -- Insert the relative path of the image into the markdown file
    local relative_path = ".img/" .. image_name
    local markdown_image_syntax = string.format("![Image](%s)", relative_path)
    vim.api.nvim_put({ markdown_image_syntax }, "c", false, true)

    -- Confirm image saved successfully
    print("Image saved to: " .. image_path)
end

return M
