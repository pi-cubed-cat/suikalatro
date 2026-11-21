function SuikaLatro.f.create_playing_card(card_init, area, skip_materialize, silent, colours, skip_emplace)
    card_init = card_init or {}
    card_init.front = card_init.front or pseudorandom_element(G.P_CARDS, pseudoseed('front'))
    card_init.center = card_init.center or G.P_CENTERS.c_base

    local _area = area or G.hand
    local card = Card(_area.T.x, _area.T.y, G.CARD_W, G.CARD_H, card_init.front, card_init.center, {playing_card = G.playing_card})

    if area and not skip_emplace then area:emplace(card) end
    if not skip_materialize then card:start_materialize(colours, silent) end

    return card
end

local card_draw_ref = Card.draw
function Card:draw(layer)
    if self.states.dummy_card then 
        if (layer == 'card' or layer == 'both') and self.area == G.hand then 
            if self.children.focused_ui then self.children.focused_ui:draw() end
        end

        add_to_drawhash(self)
        self:draw_boundingrect()
    return end
    return card_draw_ref(self, layer)
end

function SuikaLatro.f.create_dummy_card(ball)
    local suit = ball.suit
    local id = ball.id
    local card_abbrev_suit = string.upper(string.sub(suit, 1, -#(suit)))
    local card_abbrev_rank = id..''
    if id >= 10 and id <= 14 then
        if id == 10 then card_abbrev_rank = 'T'
        elseif id == 11 then card_abbrev_rank = 'J'
        elseif id == 12 then card_abbrev_rank = 'Q'
        elseif id == 13 then card_abbrev_rank = 'K'
        elseif id == 14 then card_abbrev_rank = 'A'
        end
    end
    local dummy_card = SuikaLatro.f.create_playing_card({
        front = G.P_CARDS[card_abbrev_suit..'_'..card_abbrev_rank],
        center = G.P_CENTERS.c_base}, 
        { T = {x = G.CURSOR.T.x - 1.5 - G.CARD_W/2, y = G.CURSOR.T.y - 1 - G.CARD_W/2 } }, 
        true, nil, {G.C.SECONDARY_SET.Enhanced}, true
    )

    if ball.enhancement ~= 'c_base' then
        dummy_card:set_ability(ball.enhancement, true)
    end
    if ball.edition then
        dummy_card:set_edition(ball.edition, true, true)
    end
    if ball.seal then
        dummy_card:set_seal(ball.seal, true, true)
    end
    if ball.debuff then
        dummy_card.debuff = true
    end
    for kk,vv in pairs(ball.perma_bonuses) do
        dummy_card.ability[kk] = vv
    end

    dummy_card.T.h = dummy_card.T.h*0.71*(1)/1.5
    dummy_card.T.w = dummy_card.T.w*(1)/1.5
    dummy_card.states.dummy_card = true -- invisible, but will show tooltip
    dummy_card.states.drag.can = false
    dummy_card.states.hover.can = true

    return dummy_card
end

local function t_x(x)
    return to_pixels(
        -- offset 0,0 to be relative to the center of the screen, then transform x from pixels to screen units
        to_game_units(SuikaLatro.screen_w/2) + SuikaLatro.world_T.x + x / SuikaLatro.world_width * SuikaLatro.world_T.w
    )
end

local function t_y(y)
    -- same as above
    return to_pixels(to_game_units(SuikaLatro.screen_h/2) + SuikaLatro.world_T.y + y / SuikaLatro.world_height * SuikaLatro.world_T.h)
end

function SuikaLatro.f.eval_ball_hovering()
    if G.STATE == G.STATES.SELECTING_HAND and not G.GAME.suika_hide_box then
        for k, v in ipairs(SuikaLatro.balls) do
            local delta_x, delta_y = (t_x(v.body:getX()) - love.mouse.getX()), (t_y(v.body:getY()) - love.mouse.getY())
            local distance = math.sqrt( ( delta_x )^2 + ( delta_y )^2 )
            if distance < 0.5*(to_pixels(v.size))^0.55 then
                if not v.hover_card then
                    v.hover_card = SuikaLatro.f.create_dummy_card(v)
                end
            elseif v.hover_card then
                v.hover_card:remove()
                v.hover_card = nil
            end
            if v.hover_card then
                v.hover_card.T.x = G.CURSOR.VT.x - 1.5 - v.hover_card.VT.w/2
                v.hover_card.T.y = G.CURSOR.VT.y - 1 - v.hover_card.VT.h/2
            end
        end
    end
end

--[====[function suika_ball_hover(self)
    play_sound('paper1', math.random()*0.2 + 0.9, 0.35)

    self.ability_UIBox_table = suika_generate_UIBox_ability_table(self)
    self.config.h_popup = G.UIDEF.suika_ball_h_popup(self)
    --self.config.h_popup_config = align_h_popup(self)
end

function suika_ball_remove_UI(self)
    self.ability_UIBox_table = nil
    self.config.h_popup = nil
    self.config.h_popup_config = nil
    self.no_ui = true
end

function suika_generate_UIBox_ability_table(self, vars_only)
    local card_type, hide_desc = self.enhancement ~= "c_base" and "Enhanced" or "Default", nil
    local loc_vars = nil
    local main_start, main_end = nil,nil
    local no_badge = nil
    
    if self.debuff then
        loc_vars = { debuffed = true, playing_card = true, value = SuikaLatro.f.get_value_from_id(self.id), suit = self.suit, colour = G.C.SUITS[self.suit] }
    else
        local bonus_chips = SuikaLatro.f.get_enhancement_effect(self).bonus + (self.perma_bonuses.perma_bonus or 0)
        loc_vars = { playing_card = true, value = SuikaLatro.f.get_value_from_id(self.id), suit = self.suit, colour = G.C.SUITS[self.suit],
            nominal_chips = self.id and SuikaLatro.f.get_base_chips(self.id, self.enhancement == 'm_stone') or nil,
            bonus_chips = bonus_chips ~= 0 and bonus_chips or nil,
        }
    end
    if vars_only then return loc_vars, main_start, main_end end
    local badges = {}
    if card_type ~= 'Default' or self.debuff then
        badges.card_type = card_type
    end
    if self.edition then
        if G.P_CENTERS[self.edition].config.card_limit then
            badges[#badges + 1] = SMODS.Edition.get_card_limit_key(self)
        else
            badges[#badges + 1] = (self.edition == 'e_holo' and 'holographic' or 'e_'..self.edition)
        end
    end
    if self.seal then badges[#badges + 1] = string.lower(self.seal)..'_seal' end
    
    return generate_card_ui(self, nil, loc_vars, card_type, badges, hide_desc, main_start, main_end, self)
end

function G.UIDEF.suika_ball_h_popup(ball)
    if ball.ability_UIBox_table then
        local AUT = ball.ability_UIBox_table
        local debuffed = ball.debuff
        local card_type = ball.enhancement ~= "c_base" and "Enhanced" or "Default"
        local card_type_colour = G.C.SUITS[ball.suit]
        local card_type_text_colour = G.C.GREY
        local card_type_background = 
            (card_type == 'Enhanced' or card_type == 'Default') and darken(G.C.BLACK, 0.1) or
            (debuffed and darken(G.C.BLACK, 0.1)) or 
            (card_type_colour and darken(G.C.BLACK, 0.1)) or
            {0, 1, 1, 1}

        local outer_padding = 0.05

        if card_type == 'Enhanced' then card_type = localize{type = 'name_text', key = ball.enhancement, set = 'Enhanced'} end
        card_type = (debuffed and card_type ~= 'Enhanced') and localize('k_debuffed') or card_type

        local disp_type, is_playing_card = 
                card_type ~= 'Default' or debuffed,
                card_type == 'Enhanced' or card_type == 'Default'

        local info_boxes = {}
        local badges = {}

        local obj = card.config.center
        if AUT.badges.card_type or AUT.badges.force_rarity then
            if obj and (obj.set_card_type_badge or obj.type and obj.type.set_card_type_badge) then
                if obj.type and type(obj.type.set_card_type_badge) == 'function' then
                    obj.type:set_card_type_badge(obj, card, badges)
                end
                if type(obj.set_card_type_badge) == 'function' then
                    obj:set_card_type_badge(card, badges)
                end
            else
                badges[#badges + 1] = create_badge(card_type, card_type_colour, card_type_text_colour, 1.2)
            end
        end
        if obj and obj.set_badges and type(obj.set_badges) == 'function' then
            obj:set_badges(card, badges)
        end
        if AUT.badges then
            for k, v in ipairs(AUT.badges) do
            if v:sub(v:len()-14) == '_SMODS_INTERNAL' then
                if v:sub(1, 9) == 'negative_' then v = 'negative' else v = v:sub(1, v:find('_', v:find('_')+1)-1) end
            end
            badges[#badges + 1] = create_badge(localize(v, "labels"), get_badge_colour(v), SMODS.get_badge_text_colour(v))
            end
        end

        AUT.main.background_colour = AUT.main.background_colour or AUT.box_colours and AUT.box_colours[1] or nil
        local multi_boxes = {}
        if AUT.multi_box then
            for i, box in ipairs(AUT.multi_box) do
                box.background_colour = box.background_colour or AUT.box_colours and AUT.box_colours[i+1] or nil
                if AUT.box_starts and AUT.box_starts[i] then table.insert(box, 1, AUT.box_starts[i]) end
                if AUT.box_ends and AUT.box_ends[i] then table.insert(box, AUT.box_ends[i]) end
                multi_boxes[#multi_boxes+1] = desc_from_rows(box)
            end
        end
            local prototype_obj = card.config.center or card.config.tag
            if prototype_obj and prototype_obj.pools then
                for k, v in pairs(SMODS.ObjectTypes) do
                    if prototype_obj.pools[v.key] and type(v.set_badges) == "function" then
                        v:set_badges(card, badges)
                    end
                end
            end
        if AUT.info then
            for k, v in ipairs(AUT.info) do
                info_boxes[#info_boxes+1] =
                {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
                        info_tip_from_rows(v, v.name),
                    }}
                }}
            end
        end

        local cols
        if #info_boxes <= 3 then
            cols = 1
        elseif #info_boxes <= 10 then
            cols = 2
        elseif #info_boxes <= 24 then
            cols = 3
        else
            cols = 4
        end
        local nodes_per_col = math.ceil(#info_boxes/cols)
        local info_cols = {}
        for i = 0, cols-1 do
            local col = {}
            for j = 1, nodes_per_col do
                local info_box = info_boxes[i*nodes_per_col+j]
                if info_box then
                    table.insert(col, info_box)
                else break end
            end
            table.insert(info_cols, {n=G.UIT.C, config = {align="cm"}, nodes = col})
        end
        info_boxes = {{n=G.UIT.R, config = {align="cm", padding = 0.05, card_pos = card.T.x }, nodes = info_cols}}
        local ret_val = {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={
            {n=G.UIT.C, config={align = "cm", func = 'show_infotip',object = Moveable(),ref_table = next(info_boxes) and info_boxes or nil}, nodes={
                {n=G.UIT.R, config={padding = outer_padding, r = 0.12, colour = lighten(G.C.JOKER_GREY, 0.5), emboss = 0.07}, nodes={
                    {n=G.UIT.R, config={align = "cm", padding = 0.07, r = 0.1, colour = adjust_alpha(card_type_background, 0.8)}, nodes={
                    name_from_rows(AUT.name, is_playing_card and G.C.WHITE or nil),
                    desc_from_rows(AUT.main),
                    badges[1] and {n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=badges} or nil,
                    }}
                }}
            }},
        }}
        if multi_boxes[1] then
            for i=1, #ret_val.nodes[1].nodes[1].nodes[1].nodes do -- find the main box
                if ret_val.nodes[1].nodes[1].nodes[1].nodes[i] and ret_val.nodes[1].nodes[1].nodes[1].nodes[i].config and ret_val.nodes[1].nodes[1].nodes[1].nodes[i].config.main_box_flag then
                    for j=#multi_boxes, 1, -1 do -- add the extra boxes
                        table.insert(ret_val.nodes[1].nodes[1].nodes[1].nodes, i+1, multi_boxes[j])
                    end
                    break
                end
            end
            
        end
        
        return ret_val
    end
end]====]
