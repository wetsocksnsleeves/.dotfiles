-- Quickfix list: populating it from git, navigating it, and keeping the list's
-- cursor in sync with whatever file you jump to by other means.

local M = {}

local function git_root()
    local dir = vim.fn.expand("%:p:h")
    if dir == "" then dir = assert(vim.uv.cwd()) end

    local result = vim.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }, { text = true }):wait()
    if result.code ~= 0 then
        vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR)
        return nil
    end

    return vim.trim(result.stdout)
end

local function merge_base(root)
    for _, upstream in ipairs({ "origin/master", "origin/main" }) do
        local result = vim.system({ "git", "-C", root, "merge-base", upstream, "HEAD" }, { text = true }):wait()
        if result.code == 0 then
            return vim.trim(result.stdout), upstream
        end
    end

    return nil
end

local function lines_of(result)
    return vim.gsplit(result.code == 0 and result.stdout or "", "\n", { trimempty = true })
end

-- Every file touched since the branch left master, committed or not, plus
-- anything untracked.
function M.changed_files()
    local root = git_root()
    if not root then return false end

    local base, upstream = merge_base(root)
    if not base then
        vim.notify("No origin/master or origin/main to diff against", vim.log.levels.ERROR)
        return false
    end

    local names = {}
    local tracked = vim.system(
        { "git", "-C", root, "diff", "--name-only", "--diff-filter=ACMR", base },
        { text = true }
    ):wait()
    local untracked = vim.system(
        { "git", "-C", root, "ls-files", "--others", "--exclude-standard" },
        { text = true }
    ):wait()

    for _, result in ipairs({ tracked, untracked }) do
        for name in lines_of(result) do
            names[name] = true
        end
    end

    local items = {}
    for name in vim.spairs(names) do
        table.insert(items, { filename = vim.fs.joinpath(root, name), lnum = 1, col = 1, text = name })
    end

    if #items == 0 then
        vim.notify("No changes against " .. upstream, vim.log.levels.WARN)
        return false
    end

    vim.fn.setqflist({}, " ", { title = "Changed vs " .. upstream, items = items })

    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then gitsigns.change_base(base, true) end

    vim.cmd("copen")
    vim.cmd("cfirst")
    return true
end

local function qf_size()
    return vim.fn.getqflist({ size = 0 }).size
end

local function jump(cmd, wrap_cmd)
    if qf_size() == 0 then
        vim.notify("Quickfix list is empty", vim.log.levels.WARN)
        return
    end

    if not pcall(vim.cmd, cmd) then
        pcall(vim.cmd, wrap_cmd)
    end

    vim.cmd("normal! zz")
end

vim.keymap.set("n", "]q", function() jump("cnext", "cfirst") end, { desc = "Next quickfix entry" })
vim.keymap.set("n", "[q", function() jump("cprevious", "clast") end, { desc = "Previous quickfix entry" })
vim.keymap.set("n", "]Q", function() jump("clast", "clast") end, { desc = "Last quickfix entry" })
vim.keymap.set("n", "[Q", function() jump("cfirst", "cfirst") end, { desc = "First quickfix entry" })

-- Empty list fills itself from git, so this is the one key the whole workflow
-- starts from.
vim.keymap.set("n", "<leader>q", function()
    if qf_size() == 0 then
        M.changed_files()
        return
    end

    local open = vim.iter(vim.fn.getwininfo()):any(function(win) return win.quickfix == 1 end)

    if open then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end, { desc = "Toggle quickfix window (populates from git when empty)" })

vim.keymap.set("n", "<leader>Q", function()
    vim.fn.setqflist({}, "r")
    vim.cmd("cclose")
end, { desc = "Clear quickfix list" })

vim.keymap.set("n", "<leader>fq", function()
    require("telescope.builtin").quickfix()
end, { desc = "Find in quickfix list" })

-- Keep the current quickfix entry aligned with the active file without jumping
-- to the entry's saved line or column, so ]q / [q resume from wherever you are.
local group = vim.api.nvim_create_augroup("quickfix_sync", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    desc = "Sync quickfix entry with the active file",
    callback = function(args)
        if vim.bo[args.buf].buftype ~= "" then return end

        local info = vim.fn.getqflist({ id = 0, items = 0, idx = 0 })
        local current = info.items[info.idx]
        if current and current.bufnr == args.buf then return end

        for index, item in ipairs(info.items) do
            if item.bufnr == args.buf then
                vim.fn.setqflist({}, "a", { id = info.id, idx = index })
                return
            end
        end
    end,
})

return M
