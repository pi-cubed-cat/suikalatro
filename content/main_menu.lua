local logo = "suika_logo.png"

SMODS.Atlas {
    key = "balatro",
    path = logo,
    px = 333,
    py = 216,
    prefix_config = { key = false }
}

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- DISPLAY VERSION ON MAIN MENU
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

local gameMainMenuRef = Game.main_menu
function Game:main_menu(change_context)
    gameMainMenuRef(self, change_context)
    UIBox({
        definition = {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                colour = {
                    G.C.UI.TRANSPARENT_DARK[1],
                    G.C.UI.TRANSPARENT_DARK[2],
                    G.C.UI.TRANSPARENT_DARK[3],
                    G.C.UI.TRANSPARENT_DARK[4] * 2
                }
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        scale = 0.5,
                        text = tostring('Suikalatro '..SMODS.Mods.suikalatro.version..' (DEMO)'), -- title screen version
                        colour = G.C.UI.TEXT_LIGHT
                    }
                }
            }
        },
        config = {
            align = "tmi",
            bond = "Weak",
            offset = {
                x = 0,
                y = 0
            },
            major = G.ROOM_ATTACH
        }
    })
end

