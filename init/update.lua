--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- UPDATE HOOK (merging, timers, indicator movement, flush calcs, physics, ball removing)
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

--SuikaLatro.world:setCallbacks(beginContact, endContact)

local suika_mod_path = SMODS.current_mod

function SuikaLatro.f.update(dt)
    if SuikaLatro.BG then SuikaLatro.BG:remove() end
    SuikaLatro.f.drawBG()

    SuikaLatro.drop_wait_time = SuikaLatro.drop_wait_time + dt

    if SuikaLatro.do_physics and not (#G.E_MANAGER.queues.base > 1 and SuikaLatro.do_merging) then
        SuikaLatro.world:update(dt)
        SuikaLatro.f.find_flush_groups()
    end

    SuikaLatro.f.particles_update(dt)

    --if not G.STATE == G.STATES.GAME_OVER then SuikaLatro.world:update(dt) end
    local size_offset = SuikaLatro.next_ball and (SuikaLatro.next_ball.facing == 'back' and 20 or get_size(SuikaLatro.next_ball.base.id, SuikaLatro.next_ball.config.center.key == 'm_stone')) or 20
    if love.keyboard.isDown(suika_mod_path.config.controls.cursor_left) or love.keyboard.isDown(suika_mod_path.config.controls.cursor_left_alt) then
        SuikaLatro.indicator.x = SuikaLatro.indicator.x - 200 * dt
        if SuikaLatro.walls.leftwall.body:getX() + size_offset + 12 > SuikaLatro.indicator.x then
            SuikaLatro.indicator.x = SuikaLatro.walls.leftwall.body:getX() + size_offset + 12
        end
    end
    if love.keyboard.isDown(suika_mod_path.config.controls.cursor_right) or love.keyboard.isDown(suika_mod_path.config.controls.cursor_right_alt) then
        SuikaLatro.indicator.x = SuikaLatro.indicator.x + 200 * dt
        if SuikaLatro.walls.rightwall.body:getX() - size_offset - 12 < SuikaLatro.indicator.x then
            SuikaLatro.indicator.x = SuikaLatro.walls.rightwall.body:getX() - size_offset - 12
        end
    end

    if G.hand and G.hand.highlighted and #G.hand.highlighted == 1 then
        SuikaLatro.next_ball = G.hand.highlighted[1]
    else
        SuikaLatro.next_ball = nil
    end

    if not SuikaLatro.do_merging then
        SuikaLatro.play_wait_time = 0
        for k, v in ipairs(SuikaLatro.balls) do
            if v.merge_target then
                v.fixture:setMask()
                v.merge_target.fixture:setMask()
            end
        end
    else -- if do_merging
        for k, v in ipairs(SuikaLatro.balls) do
            if v.merge_target then
                v.fixture:setMask(1)
                v.merge_target.fixture:setMask(1)
                local delta_x, delta_y = (v.body:getX() - v.merge_target.body:getX()), (v.body:getY() - v.merge_target.body:getY())
                local distance = math.sqrt( ( delta_x )^2 + ( delta_y )^2 )
                if distance > 15*math.sqrt(v.id) then -- this should be changed to be based on v.size, but it works for now
                    local angle = math.atan2(delta_y, delta_x)
                    v.body:setLinearVelocity(
                    -50000 * 1/60 * math.cos(angle),
                    -50000 * 1/60 * math.sin(angle)
                    )
                else
                    if v.dont_prod then -- only one of the balls creates a new ball
                        SuikaLatro.play_wait_time = 0
                        SuikaLatro.lowball = false

                        local selected_ball = math.random()
                        local merge_count = math.max(v.merges, v.merge_target.merges) + 1

                        local _x, _y = v.body:getX(), v.body:getY()
                        local col_suits = { G.C.SUITS[v.suit], G.C.SUITS[v.merge_target.suit] }
                        SuikaLatro.f.explode_particles(_x, _y, 20 * merge_count, col_suits, 0.2)

                        --SuikaLatro.f.create_dummy_card(v)
                        --SuikaLatro.f.create_dummy_card(v.merge_target)
                        
                        local fixed_enhancement = nil
                        local fixed_edition = nil
                        local fixed_seal = nil
                        local perma_bonus_table = {}
                        if v.perma_bonuses then
                            for k,v in pairs(v.perma_bonuses) do
                                perma_bonus_table[k] = v
                            end
                        end 
                        if v.merge_target.perma_bonuses then
                            for k,v in pairs(v.merge_target.perma_bonuses) do
                                if not perma_bonus_table[k] then
                                    perma_bonus_table[k] = v
                                elseif v > perma_bonus_table[k] then
                                    perma_bonus_table[k] = v
                                end
                            end
                        end 
                        
                        if (v.enhancement ~= 'c_base' or v.merge_target.enhancement ~= 'c_base') and (v.enhancement == 'c_base' or v.merge_target.enhancement == 'c_base') then
                            fixed_enhancement = v.enhancement ~= 'c_base' and v.enhancement or v.merge_target.enhancement
                        end
                        if (not v.edition or not v.merge_target.edition) and (v.edition or v.merge_target.edition) then
                            fixed_edition = v.edition or v.merge_target.edition
                        end
                        if (not v.seal or not v.merge_target.seal) and (v.seal or v.merge_target.seal) then
                            fixed_seal = v.seal or v.merge_target.seal
                        end

                        local self_debuff = v.debuff
                        local other_debuff = v.merge_target.debuff
                        local self_enhancement = not self_debuff and v.enhancement or nil
                        local other_enhancement = not other_debuff and v.merge_target.enhancement or nil

                        if not ((self_enhancement == 'm_glass' and pseudorandom('suika_glass') < G.GAME.probabilities.normal / 2) or (other_enhancement == 'm_glass' and pseudorandom('suika_glass2') < G.GAME.probabilities.normal / 2)) then
                            table.insert(SuikaLatro.balls, Ball(v.body:getX(), v.body:getY(), selected_ball > 0.5 and v.merge_target or v, 1, merge_count, fixed_enhancement, fixed_edition, fixed_seal, nil, perma_bonus_table, (v.debuff and v.merge_target.debuff and true) or false))
                        else
                            play_sound('glass'..math.random(1, 6), math.random()*0.2 + 0.9,0.4)
                            play_sound('generic1', math.random()*0.2 + 0.9,0.5)
                            SMODS.calculate_context({balls_shattered = true, other_balls = {v, v.merge_target}})
                        end
                        
                        if self_enhancement == 'm_wild' then
                            if SuikaLatro.f.is_suit(v, 'Hearts') then SuikaLatro.scoring_suits["Hearts"] = SuikaLatro.scoring_suits["Hearts"] + 1
                            elseif SuikaLatro.f.is_suit(v, 'Diamonds') then SuikaLatro.scoring_suits["Diamonds"] = SuikaLatro.scoring_suits["Diamonds"] + 1
                            elseif SuikaLatro.f.is_suit(v, 'Spades') then SuikaLatro.scoring_suits["Spades"] = SuikaLatro.scoring_suits["Spades"] + 1
                            elseif SuikaLatro.f.is_suit(v, 'Clubs') then SuikaLatro.scoring_suits["Clubs"] = SuikaLatro.scoring_suits["Clubs"] + 1 end
                        end
                        if other_enhancement == 'm_wild' then
                            if SuikaLatro.f.is_suit(v.merge_target, 'Hearts') then SuikaLatro.scoring_suits["Hearts"] = SuikaLatro.scoring_suits["Hearts"] + 1
                            elseif SuikaLatro.f.is_suit(v.merge_target, 'Diamonds') then SuikaLatro.scoring_suits["Diamonds"] = SuikaLatro.scoring_suits["Diamonds"] + 1
                            elseif SuikaLatro.f.is_suit(v.merge_target, 'Spades') then SuikaLatro.scoring_suits["Spades"] = SuikaLatro.scoring_suits["Spades"] + 1
                            elseif SuikaLatro.f.is_suit(v.merge_target, 'Clubs') then SuikaLatro.scoring_suits["Clubs"] = SuikaLatro.scoring_suits["Clubs"] + 1 end
                        end
                        if self_enhancement ~= 'm_wild' then
                            if SuikaLatro.f.is_suit(v, 'Hearts') then SuikaLatro.scoring_suits["Hearts"] = SuikaLatro.scoring_suits["Hearts"] + 1
                            elseif SuikaLatro.f.is_suit(v, 'Diamonds') then SuikaLatro.scoring_suits["Diamonds"] = SuikaLatro.scoring_suits["Diamonds"] + 1
                            elseif SuikaLatro.f.is_suit(v, 'Spades') then SuikaLatro.scoring_suits["Spades"] = SuikaLatro.scoring_suits["Spades"] + 1
                            elseif SuikaLatro.f.is_suit(v, 'Clubs') then SuikaLatro.scoring_suits["Clubs"] = SuikaLatro.scoring_suits["Clubs"] + 1 end
                        end
                        if other_enhancement ~= 'm_wild' then
                            if SuikaLatro.f.is_suit(v.merge_target, 'Hearts') then SuikaLatro.scoring_suits["Hearts"] = SuikaLatro.scoring_suits["Hearts"] + 1
                            elseif SuikaLatro.f.is_suit(v.merge_target, 'Diamonds') then SuikaLatro.scoring_suits["Diamonds"] = SuikaLatro.scoring_suits["Diamonds"] + 1
                            elseif SuikaLatro.f.is_suit(v.merge_target, 'Spades') then SuikaLatro.scoring_suits["Spades"] = SuikaLatro.scoring_suits["Spades"] + 1
                            elseif SuikaLatro.f.is_suit(v.merge_target, 'Clubs') then SuikaLatro.scoring_suits["Clubs"] = SuikaLatro.scoring_suits["Clubs"] + 1 end
                        end

                        v.x = v.body:getX()
                        v.y = v.body:getY()
                        
                        SuikaLatro.f.eval_merge_ball_scoring_effects(merge_count, v, v.merge_target, false)
                        
                        SuikaLatro.retrig[v] = {}
                        SuikaLatro.retrig[v.merge_target] = {}
                        if v.seal and v.seal == 'Red' then
                            SuikaLatro.retrig[v][#SuikaLatro.retrig[v]+1] = 'Red'
                        end
                        if v.merge_target.seal and v.merge_target.seal == 'Red' then
                            SuikaLatro.retrig[v.merge_target][#SuikaLatro.retrig[v.merge_target]+1] = 'Red'
                        end
                        SMODS.calculate_context({suika_ball_merge_repetition = true, other_ball = v})
                        SMODS.calculate_context({suika_ball_merge_repetition = true, other_ball = v.merge_target})
                        
                        if v.debuff then SuikaLatro.retrig[v] = {} end
                        if v.merge_target.debuff then SuikaLatro.retrig[v.merge_target] = {} end

                        for i = 1, math.max(#SuikaLatro.retrig[v], #SuikaLatro.retrig[v.merge_target]) do
                            SuikaLatro.play_wait_time = 0
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    SuikaLatro.play_wait_time = 0
                                    if SuikaLatro.retrig[v][i] == "Red" then
                                        SuikaLatro.f.seal_message(v.x, v.y, "Red")
                                    elseif SuikaLatro.retrig[v][i] then
                                        SuikaLatro.f.score_message_joker({
                                            retriggers = 1,
                                            obj = SuikaLatro.retrig[v][i],
                                            obj_type = 'card',
                                            juice_card = SuikaLatro.retrig[v][i],
                                        })
                                    end
                                    if SuikaLatro.retrig[v.merge_target][i] == "Red" then
                                        SuikaLatro.f.seal_message(v.x, v.y, "Red")
                                    elseif SuikaLatro.retrig[v.merge_target][i] then
                                        SuikaLatro.f.score_message_joker({
                                            retriggers = 1,
                                            obj = SuikaLatro.retrig[v.merge_target][i],
                                            obj_type = 'card',
                                            juice_card = SuikaLatro.retrig[v.merge_target][i],
                                        })
                                    end
                                    SuikaLatro.f.eval_merge_ball_scoring_effects(nil, v, v.merge_target, true, #SuikaLatro.retrig[v] > 0, #SuikaLatro.retrig[v.merge_target] > 0)
                                return true
                                end
                            }))
                        end

                        --[[for i=1,2 do
                            scoring_list[i].pos = {
                                x = x_pos,
                                y = y_pos,
                            }
                            SMODS.calculate_context({suika_individual = true, other_ball = scoring_list[i]})
                        end]]
                        v.merge_target.remove = true
                        v.remove = true
                    --else
                        --v.merge_target.remove = true
                        --v.remove = true
                    end
                end
            end
        end
        if #G.E_MANAGER.queues.base <= 1 then
            SuikaLatro.play_wait_time = SuikaLatro.play_wait_time + dt
        end
        if SuikaLatro.do_merging and SuikaLatro.play_wait_time > 3 then
            SuikaLatro.play_wait_time = 0
            G.FUNCS.suika_play_pt2()
        end
        
    end

    for i = #SuikaLatro.balls, 1, -1 do
        if SuikaLatro.balls[i].remove then
            SuikaLatro.balls[i].body:destroy()
            table.remove(SuikaLatro.balls, i)
        end
    end
end