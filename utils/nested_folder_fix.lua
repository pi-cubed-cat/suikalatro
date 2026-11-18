-- code from Larswijn
-- safe-guard against nested folders (unapplied lovely patches)
local lovely_dir_items = NFS.getInfo(SMODS.current_mod.path .. "lovely") and NFS.getDirectoryItems(SMODS.current_mod.path .. "lovely")
local should_have_lovely = (lovely_dir_items and #lovely_dir_items > 0)
if should_have_lovely then
    -- if we have detected a `lovely.toml` file or a non-empty `lovely` directory (assumption that it contains lovely patches)
    assert(SMODS.current_mod.lovely, "Failed to detect lovely patches.\nMake sure your Suikalatro folder is not 'nested' (there should be a bunch of files in the folder and not just another folder).\n\n\n")
end