--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- DROPPING BALLS
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

function SuikaLatro.f.drop_ball()
    if G.hand and G.hand.highlighted and #G.hand.highlighted == 1 and SuikaLatro.drop_wait_time > 0.8 then
        if G.hand.highlighted[1]:get_id() <= 3 
        or SMODS.has_enhancement(G.hand.highlighted[1], 'm_stone') then
            SuikaLatro.drop_wait_time = 0.2
        elseif G.hand.highlighted[1]:get_id() <= 6 then
            SuikaLatro.drop_wait_time = 0
        elseif G.hand.highlighted[1]:get_id() <= 9 then
            SuikaLatro.drop_wait_time = -0.3
        else
            SuikaLatro.drop_wait_time = -0.6
        end
        SuikaLatro.next_ball = G.hand.highlighted[1]
        local size_offset = SuikaLatro.next_ball and get_size(SuikaLatro.next_ball.base.id, SuikaLatro.next_ball.config.center.key == 'm_stone') or 10
        if SuikaLatro.walls.leftwall.body:getX() + size_offset + 12 > SuikaLatro.indicator.x then
            SuikaLatro.indicator.x = SuikaLatro.walls.leftwall.body:getX() + size_offset + 12
        elseif SuikaLatro.walls.rightwall.body:getX() - size_offset - 12 < SuikaLatro.indicator.x then
            SuikaLatro.indicator.x = SuikaLatro.walls.rightwall.body:getX() - size_offset - 12
        end
        table.insert(SuikaLatro.balls, Ball(SuikaLatro.indicator.x, SuikaLatro.indicator.y))
        SuikaLatro.indicator.x = SuikaLatro.indicator.x + (math.random() - 0.5) / 50 --makes stacking harder
        
        SMODS.calculate_context({suika_drop_card = true, other_card = G.hand.highlighted[1]})
        
        if not G.hand.highlighted[1].being_destroyed then
            draw_card(G.hand, G.discard, 50, 'down', false, G.hand.highlighted[1])
        end
        G.hand.highlighted[1].ability.played_this_ante = true
        inc_career_stat('c_cards_played', 1)
        G.GAME.cards_played[G.hand.highlighted[1].base.value].total = G.GAME.cards_played[G.hand.highlighted[1].base.value].total + 1
        G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1

        if #G.hand.cards <= G.hand.config.card_limit then
            SMODS.draw_cards(G.hand.config.card_limit - #G.hand.cards + 1)
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                save_run()
                return true
            end
        }))
    end
end

SMODS.Keybind {
    key_pressed = SMODS.current_mod.config.controls.drop,
    event = 'pressed',
    action = function(self)
        SuikaLatro.f.drop_ball()
    end
}

SMODS.Keybind {
    key_pressed = SMODS.current_mod.config.controls.drop_alt,
    event = 'pressed',
    action = function(self)
        SuikaLatro.f.drop_ball()
    end
}