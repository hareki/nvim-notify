-- The number a buffer's highlight groups end in. Neovim never frees a highlight group, so a number
-- per buffer (the buffer's own) grows the group table with every notification until E849. A buffer
-- takes the number of one that is gone instead, which bounds the groups by the notification
-- buffers alive at once.
local M = {}

---@type integer[] The buffer holding each number
local owners = {}

---@param buffer integer
---@return integer
function M.of(buffer)
  local free
  for id, owner in ipairs(owners) do
    if owner == buffer then
      return id
    end
    if not free and not vim.api.nvim_buf_is_valid(owner) then
      free = id
    end
  end
  free = free or #owners + 1
  owners[free] = buffer
  return free
end

return M
