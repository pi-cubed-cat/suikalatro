G.FUNCS.suikalatro_start_run = function(e, args) 
    G.SETTINGS.paused = true
    if e and e.config.id == 'restart_button' then G.GAME.viewed_back = nil end
    args = args or {}
    G.GAME.selected_back = Back(G.P_CENTERS['b_red'])
    G.E_MANAGER:clear_queue()
    G.FUNCS.wipe_on()
    G.E_MANAGER:add_event(Event({
        no_delete = true,
        func = function()
            G:delete_run()
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        no_delete = true,
        func = function()
            G:start_run(args)
            return true
        end
    }))
    G.FUNCS.wipe_off()
end

G.FUNCS.suika_reset_tutorial = function()
    G.SETTINGS.suikalatro_tutorial_complete = false
    G.SETTINGS.suikalatro_tutorial_progress = nil
end

local Game_start_run_ref = Game.start_run -- reset tutorial if tutorial wasn't completed 
function Game:start_run(args)
    Game_start_run_ref(self, args)
    local saveTable = args.savetext or nil
    if not saveTable and not G.SETTINGS.suikalatro_tutorial_complete then
        G.FUNCS.suika_reset_tutorial()
    end
end

G.FUNCS.suikalatro_tutorial_controller = function()
    if G.F_SKIP_TUTORIAL then
        G.SETTINGS.suikalatro_tutorial_complete = true
        G.SETTINGS.suikalatro_tutorial_progress = nil
        
        return
    end
    G.SETTINGS.suikalatro_tutorial_progress = G.SETTINGS.suikalatro_tutorial_progress or 
    {
        forced_shop = {'c_empress'},
        hold_parts = {},
        completed_parts = {},
    }
    G.SETTINGS.suikalatro_tutorial_progress.forced_boss = 'bl_suika_melon'
    if not G.SETTINGS.paused and (not G.SETTINGS.suikalatro_tutorial_complete) then
        --if not G.SETTINGS.suikalatro_tutorial_progress.completed_parts['secondhand'] then
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.suikalatro_tutorial_progress.completed_parts['intro'] then
                G.SETTINGS.suikalatro_tutorial_progress.section = 'intro'
                G.FUNCS.suikalatro_tutorial_part('intro')
                G.SETTINGS.suikalatro_tutorial_progress.completed_parts['intro']  = true
                G:save_progress()
            end
            if #SuikaLatro.balls >= 6 and G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.suikalatro_tutorial_progress.completed_parts['drop5'] 
            and G.SETTINGS.suikalatro_tutorial_progress.hold_parts['intro'] then
                G.SETTINGS.suikalatro_tutorial_progress.section = 'drop5'
                G.FUNCS.suikalatro_tutorial_part('drop5')
                G.SETTINGS.suikalatro_tutorial_progress.completed_parts['drop5']  = true
                G:save_progress()
            end
            if (G.GAME.current_round.hands_played > 0 or #SuikaLatro.balls >= 12) and G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.suikalatro_tutorial_progress.completed_parts['secondhand']
            then --and G.SETTINGS.suikalatro_tutorial_progress.hold_parts['drop5'] then
                G.SETTINGS.suikalatro_tutorial_progress.section = 'secondhand'
                G.FUNCS.suikalatro_tutorial_part('secondhand')
                G.SETTINGS.suikalatro_tutorial_progress.completed_parts['secondhand']  = true
                G:save_progress()
            end
        --end
        if G.STATE == G.STATES.SHOP and G.shop and G.shop.VT.y < 5 and not G.SETTINGS.suikalatro_tutorial_progress.completed_parts['shop'] then
            G.SETTINGS.suikalatro_tutorial_progress.section = 'shop'
            G.FUNCS.suikalatro_tutorial_part('shop')
            G.SETTINGS.suikalatro_tutorial_progress.completed_parts['shop']  = true
            G:save_progress()
        end
        if G.GAME.round > 1 and G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.suikalatro_tutorial_progress.completed_parts['bigblind'] then
            G.SETTINGS.suikalatro_tutorial_progress.section = 'bigblind'
            G.FUNCS.suikalatro_tutorial_part('bigblind')
            G.SETTINGS.suikalatro_tutorial_progress.completed_parts['bigblind']  = true
            G:save_progress()
        end
        if G.SETTINGS.suikalatro_tutorial_progress.hold_parts['bigblind'] then
            G.SETTINGS.suikalatro_tutorial_complete = true
            G.SETTINGS.suikalatro_tutorial_progress = nil
        end
    end
end

G.FUNCS.suikalatro_tutorial_part = function(_part)
    local step = 1
    G.SETTINGS.paused = true
    if _part == 'intro' then
        step = suikalatro_tutorial_info({
            text_key = 'suika_intro1',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_intro2',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_intro3',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = -2.5, y = -2.5}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_intro4',
            highlight = {
                G.hand,
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 2}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_intro5',
            highlight = {
                G.hand,
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 2}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            hard_set = true,
            text_key = 'suika_intro6',
            highlight = {
                G.deck,
            },
            attach = {major = G.deck, type = 'cm', offset = {x = -3, y = -3}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_intro7',
            highlight = {
                G.hand,
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 2}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_intro8',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 2}},
            step = step,
        })
    elseif _part == 'drop5' then
        step = suikalatro_tutorial_info({
            text_key = 'suika_dropfive1',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = -4, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_dropfive2',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_dropfive3',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_dropfive4',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            highlight = {
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            look = {-1, 0.3},
            no_button = true,
            button_listen = 'run_info',
            snap_to = function() return G.HUD:get_UIE_by_ID('run_info_button') end,
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_dropfive5',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
            highlight = {
                G.HUD:get_UIE_by_ID('run_info_button')
            },
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_dropfive6',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
            highlight = {
                G.HUD:get_UIE_by_ID('run_info_button')
            },
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_dropfive7',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
            highlight = {
                G.HUD:get_UIE_by_ID('run_info_button')
            },
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_dropfive8',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_dropfive9',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_dropfive10',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
    elseif _part == 'secondhand' then
        step = suikalatro_tutorial_info({
            text_key = 'suika_secondhand1',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_secondhand2',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = -3, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_secondhand3',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_secondhand4',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
    elseif _part == 'shop' then
        step = suikalatro_tutorial_info({
            text_key = 'suika_shop1',
            highlight = {
                G.shop_jokers
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = -2, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_shop2',
            highlight = {
                G.shop_jokers
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = -2, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_shop3',
            highlight = {
                G.shop_jokers
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = -2, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_shop4',
            highlight = {
                G.shop_jokers
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = -2, y = 0}},
            step = step,
        })
    elseif _part == 'bigblind' then
        step = suikalatro_tutorial_info({
            text_key = 'suika_bigblind0',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_bigblind1',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_bigblind2',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_bigblind3',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_bigblind4',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = -3, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_bigblind5',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = -3, y = 0}},
            step = step,
        })
        step = suikalatro_tutorial_info({
            text_key = 'suika_bigblind6',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
    end

    
    G.E_MANAGER:add_event(Event({
        blockable = false,
        timer = 'REAL',
        func = function()
            if (G.OVERLAY_TUTORIAL and G.OVERLAY_TUTORIAL.step == step and
            not G.OVERLAY_TUTORIAL.step_complete) or (G.OVERLAY_TUTORIAL.skip_steps) then
                if G.OVERLAY_TUTORIAL.Jimbo then G.OVERLAY_TUTORIAL.Jimbo:remove() end
                if G.OVERLAY_TUTORIAL.content then G.OVERLAY_TUTORIAL.content:remove() end
                G.OVERLAY_TUTORIAL:remove()
                G.OVERLAY_TUTORIAL = nil
                G.SETTINGS.suikalatro_tutorial_progress.hold_parts[_part]=true
                return true
            end
            return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
        end
    }), 'tutorial') 
    G.SETTINGS.paused = false
end

function suikalatro_tutorial_info(args)
    local overlay_colour = {0.32,0.36,0.41,0}
    ease_value(overlay_colour, 4, 0.6, nil, 'REAL', true,0.4)
    G.OVERLAY_TUTORIAL = G.OVERLAY_TUTORIAL or UIBox{
        definition = {n=G.UIT.ROOT, config = {align = "cm", padding = 32.05, r=0.1, colour = overlay_colour, emboss = 0.05}, nodes={
            {n=G.UIT.R, config={align = "tl", minh = G.ROOM.T.h, minw = G.ROOM.T.w}, nodes={
                UIBox_button{label = {localize('b_skip').." >"}, button = "suika_skip_tutorial_section", minw = 1.3, scale = 0.45, colour = G.C.JOKER_GREY}
            }}
        }},
        config = {
            align = "cm",
            offset = {x=0,y=3.2},
            major = G.ROOM_ATTACH,
            bond = 'Weak'
          }
      }
    G.OVERLAY_TUTORIAL.step = G.OVERLAY_TUTORIAL.step or 1
    G.OVERLAY_TUTORIAL.step_complete = false
    local row_dollars_chips = G.HUD:get_UIE_by_ID('row_dollars_chips')
    local align = args.align or "tm"
    local step = args.step or 1
    local attach = args.attach or {major = row_dollars_chips, type = 'tm', offset = {x=0, y=-0.5}}
    local pos = args.pos or {x=attach.major.T.x + attach.major.T.w/2, y=attach.major.T.y + attach.major.T.h/2}
    local button = args.button or {button = localize('b_next'), func = 'tut_next'}
    args.highlight = args.highlight or {}
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
            if G.OVERLAY_TUTORIAL and G.OVERLAY_TUTORIAL.step == step and
            not G.OVERLAY_TUTORIAL.step_complete then
                G.CONTROLLER.interrupt.focus = true
                G.OVERLAY_TUTORIAL.Jimbo = G.OVERLAY_TUTORIAL.Jimbo or Card_Character(pos)
                if type(args.highlight) == 'function' then args.highlight = args.highlight() end
                args.highlight[#args.highlight+1] = G.OVERLAY_TUTORIAL.Jimbo
                G.OVERLAY_TUTORIAL.Jimbo:add_speech_bubble(args.text_key, align, args.loc_vars)
                G.OVERLAY_TUTORIAL.Jimbo:set_alignment(attach)
                if args.hard_set then G.OVERLAY_TUTORIAL.Jimbo:hard_set_VT() end
                G.OVERLAY_TUTORIAL.button_listen = nil
                if G.OVERLAY_TUTORIAL.content then G.OVERLAY_TUTORIAL.content:remove() end
                if args.content then
                    G.OVERLAY_TUTORIAL.content = UIBox{
                        definition = args.content(),
                        config = {
                            align = args.content_config and args.content_config.align or "cm",
                            offset = args.content_config and args.content_config.offset or {x=0,y=0},
                            major = args.content_config and args.content_config.major or G.OVERLAY_TUTORIAL.Jimbo,
                            bond = 'Weak'
                          }
                      }
                    args.highlight[#args.highlight+1] = G.OVERLAY_TUTORIAL.content
                end
                if args.button_listen then G.OVERLAY_TUTORIAL.button_listen = args.button_listen end
                if not args.no_button then G.OVERLAY_TUTORIAL.Jimbo:add_button(button.button, button.func, button.colour, button.update_func, true) end
                G.OVERLAY_TUTORIAL.Jimbo:say_stuff(2*(#(G.localization.misc.tutorial[args.text_key] or {}))+1)
                if args.snap_to then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false, blockable = false,
                        func = function()
                            if G.OVERLAY_TUTORIAL and G.OVERLAY_TUTORIAL.Jimbo and not G.OVERLAY_TUTORIAL.Jimbo.talking then 
                            local _snap_to = args.snap_to()
                            if _snap_to then
                                G.CONTROLLER.interrupt.focus = false
                                G.CONTROLLER:snap_to({node = args.snap_to()})
                            end
                            return true
                            end
                        end
                    }), 'tutorial') 
                end
                if args.highlight then G.OVERLAY_TUTORIAL.highlights = args.highlight end 
                G.OVERLAY_TUTORIAL.step_complete = true
            end
            return not G.OVERLAY_TUTORIAL or G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
        end
    }), 'tutorial') 
    return step+1
end

G.FUNCS.suika_skip_tutorial_section = function(e)
    G.OVERLAY_TUTORIAL.skip_steps = true
    G.SETTINGS.suikalatro_tutorial_complete = true
    G.SETTINGS.suikalatro_tutorial_progress = nil
    if G.OVERLAY_TUTORIAL.Jimbo then G.OVERLAY_TUTORIAL.Jimbo:remove() end
    if G.OVERLAY_TUTORIAL.content then G.OVERLAY_TUTORIAL.content:remove() end
    G.OVERLAY_TUTORIAL:remove()
    G.OVERLAY_TUTORIAL = nil
    G.E_MANAGER:clear_queue('tutorial')
end

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- TUTORIAL DRAWING DIAGRAMS
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

local filesystem = NFS or love.filesystem
local suika_mod_path = SMODS.current_mod

local function load_the_suika(img)
    local full_path = (suika_mod_path.path..'assets/'..img)
    local file_data = assert(NFS.newFileData(full_path))
    local tempimagedata = assert(love.image.newImageData(file_data))
    return (assert(love.graphics.newImage(tempimagedata)))
end

suika_tutorial = {
    gameover = load_the_suika("tutorial/gameover.png"),
    biology = load_the_suika("tutorial/biology.png")
}

local love_draw_ref = love.draw
function love.draw()
    love_draw_ref()
    love.graphics.setColor(1, 1, 1)
    if G.OVERLAY_TUTORIAL and G.OVERLAY_TUTORIAL.step == 2 
    and G.SETTINGS.suikalatro_tutorial_progress.section == 'secondhand' then
        love.graphics.draw(suika_tutorial.gameover, SuikaLatro.screen_w*3/5, SuikaLatro.screen_h*1/5, nil, to_pixels(0.015))
    end
    if G.OVERLAY_TUTORIAL and (G.OVERLAY_TUTORIAL.step == 5 or G.OVERLAY_TUTORIAL.step == 6)
    and G.SETTINGS.suikalatro_tutorial_progress.section == 'bigblind' then
        love.graphics.draw(suika_tutorial.biology, SuikaLatro.screen_w*3/5, SuikaLatro.screen_h*1/5, nil, to_pixels(0.015))
    end
end