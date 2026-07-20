function SuikaLatro.f.try_game_over()
    if not MP or not MP.LOBBY.code then
        end_round()
    else
        if MP.is_pvp_boss() then
            G.E_MANAGER:add_event(Event({
                trigger = "immediate",
                func = function()
                    MP.ACTIONS.play_hand(G.GAME.chips, 0)
                    -- For now, never advance to next round
                    attention_text({
                        scale = 0.8,
                        text = localize("k_wait_enemy"),
                        hold = 10,
                        align = "cm",
                        offset = { x = 0, y = -1.5 },
                        major = G.play,
                    })
                    if G.hand.cards[1] and G.STATE == G.STATES.HAND_PLAYED then
                        SuikaLatro.MP_funcs.eval_hand_and_jokers()
                        G.FUNCS.draw_from_hand_to_discard()
                    end
                    return true
                end,
            }))
        else
            MP.ACTIONS.fail_round(1)
            end_round()
        end
    end
end

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- MERGING CHECKS AND COLLISION SOUNDS
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

function beginContact(a, b, coll)
    local x, y = coll:getNormal()
    local objA = a:getUserData()
    local objB = b:getUserData()
    if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.HAND_PLAYED or G.STATE == G.STATES.DRAW_TO_HAND then -- collision sounds
        if objA and objA.id and objB and objB.id then
            local a_x, a_y = objA.body:getLinearVelocity()
            local b_x, b_y = objB.body:getLinearVelocity()
            local a_speed = math.sqrt(a_x^2 + a_y^2)
            local b_speed = math.sqrt(b_x^2 + b_y^2)
            play_sound('tarot2', math.random()*0.2 + 0.9 - math.min(0.9, 1/(math.max(a_speed, b_speed) + 0.01)), math.max(a_speed, b_speed)/200)
        elseif objA and objA.id then
            local a_x, a_y = objA.body:getLinearVelocity()
            local speed = math.sqrt(a_x^2 + a_y^2)
            play_sound('tarot2', math.random()*0.2 + 0.9 - math.min(0.9,1/speed + 0.01), speed/200)
        elseif objB and objB.id then
            local a_x, a_y = objB.body:getLinearVelocity()
            local speed = math.sqrt(a_x^2 + a_y^2)
            play_sound('tarot2', math.random()*0.2 + 0.9 - math.min(0.9,1/speed + 0.01), speed/200)
        end
    end
    if objA and objB and objA.id and objB.id then -- merging / game over
        if (#SMODS.find_card('j_shortcut') > 0 and ((objA.id == 2 and objB.id == 14 or objA.id == 14 and objB.id == 2) or math.abs(objA.id - objB.id) <= 1))
        or ((objA.id == objB.id or objA.enhancement == 'm_stone' or objB.enhancement == 'm_stone')) then
            if not objA.merge_target and not objB.merge_target and not objB.dont_prod then
                objA.merge_target = objB
                objB.merge_target = objA
                objB.dont_prod = true
            end
        end
        if SuikaLatro.drop_wait_time < 0.8 and not SuikaLatro.do_merging and
        (objA and objA == SuikaLatro.balls[#SuikaLatro.balls] and objA.body:getY() + objA.size < boundary.body:getY()
        or objB and objB == SuikaLatro.balls[#SuikaLatro.balls] and objB.body:getY() + objB.size < boundary.body:getY()) then
            G.E_MANAGER:add_event(Event({
                trigger = "immediate",
                func = function()
                    G.STATE = G.STATES.HAND_PLAYED
                    G.STATE_COMPLETE = true
                    SuikaLatro.f.try_game_over()
                    return true
                end,
            }))
        end
    end
end

function endContact(a, b, coll)
	local x, y = coll:getNormal()
	local objA = a:getUserData()
	local objB = b:getUserData()
    if not SuikaLatro.do_merging and objA and objB and objA.merge_target and objB.merge_target then
        if objA.merge_target == objB and objB.merge_target == objA then
            objA.merge_target = nil
            objB.merge_target = nil
            objA.dont_prod = nil
            objB.dont_prod = nil
            --objA.fixture:setMask()
            --objB.fixture:setMask()
        end
    end
end