--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- FLUSH CALCS AND RANK & SUIT UTILS
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

function get_size(input, stone)
    if stone then
        return 2 * SuikaLatro.ball_sizefactor
    elseif input <= 10 then --number ranked balls
        return input * SuikaLatro.ball_sizefactor
    elseif input > 10 and input < 14 then --face ranked balls
        return 10 * SuikaLatro.ball_sizefactor
    elseif input >= 14 then --aces+
        return 11 * SuikaLatro.ball_sizefactor
    end
end

function SuikaLatro.f.get_base_chips(input, stone)
    if stone then
        return 2
    elseif input <= 10 then
        return 2^(input-1)
    elseif input > 10 and input < 14 then
        return 512
    elseif input >= 14 then
        return 1024
    end
end

function SuikaLatro.f.is_rank(ball, rank)
    if ball.enhancement == 'm_stone' then
        return false
    end 
    return ball.id == rank
end

function SuikaLatro.f.is_face(ball, from_boss)
    if ball.debuff and not from_boss then return end
    if SuikaLatro.f.is_rank(ball, 11) or SuikaLatro.f.is_rank(ball, 12) or SuikaLatro.f.is_rank(ball, 13)
    or next(SMODS.find_card("j_pareidolia")) then
        return true
    end
end

function SuikaLatro.f.is_suit(ball, suit)
    if ball.enhancement == 'm_stone' then
        return false
    end
    if ball.enhancement == "m_wild" then --and not self.debuff then (WILD CARD BEHAVIOUR IS *NOT* COMPLETE.)
        return true
    end
    if next(find_joker('Smeared Joker')) and (ball.suit == 'Hearts' or ball.suit == 'Diamonds') == (suit == 'Hearts' or suit == 'Diamonds') then
        return true
    end
    return ball.suit == suit
end

local function ballsAreTouching(a, b)
    if not (SuikaLatro.f.is_suit(a, b.suit) or SuikaLatro.f.is_suit(b, a.suit)) 
    or a.enhancement == 'm_stone' or b.enhancement == 'm_stone' then 
        return false end -- flushes don't occur with different suits

    local ax, ay = a.body:getX(), a.body:getY()
    local bx, by = b.body:getX(), b.body:getY()

    local dx, dy = ax - bx, ay - by
    local dist2 = dx*dx + dy*dy
    local r = a.size + b.size

    return dist2 <= (r + 10)^2
end

function SuikaLatro.f.find_flush_groups()
    local balls = SuikaLatro.balls
    local visited = {}
    local groups = {}
    SuikaLatro.flush_groups = {}
    for i, ball in ipairs(balls) do
        if not visited[ball] then
            ball.flush_size = 0
            -- start a new group
            local stack = { ball }
            local group = {}
            visited[ball] = true

            while #stack > 0 do
                local current = table.remove(stack)
                table.insert(group, current)

                -- check all other balls for touching of the same suit
                for j, other in ipairs(balls) do
                    if not visited[other] and ballsAreTouching(current, other) then
                        visited[other] = true
                        table.insert(stack, other)
                    end
                end
            end

            -- only store groups with more than 1 ball
            if #group >= 2 then
                table.insert(groups, group)
                for i=1,#group do
                    group[i].flush_size = #group
                end
            end
        end
    end

    SuikaLatro.flush_groups = groups
end

function SuikaLatro.f.pick_carry_balls(num)
    local num_carry_over = num or 2
    G.GAME.SuikaLatro_carryover_balls = {}
    if #SuikaLatro.balls <= num_carry_over then
        for i = 1, num_carry_over do
            for k, ball in ipairs(SuikaLatro.balls) do
                G.GAME.SuikaLatro_carryover_balls[k] = {}
                G.GAME.SuikaLatro_carryover_balls[k].x = ball.body:getX()
                G.GAME.SuikaLatro_carryover_balls[k].y = ball.body:getY()
                G.GAME.SuikaLatro_carryover_balls[k].id = ball.id
                G.GAME.SuikaLatro_carryover_balls[k].suit = ball.suit
                G.GAME.SuikaLatro_carryover_balls[k].enhancement = ball.enhancement
                G.GAME.SuikaLatro_carryover_balls[k].edition = ball.edition
                G.GAME.SuikaLatro_carryover_balls[k].seal = ball.seal
                G.GAME.SuikaLatro_carryover_balls[k].size = ball.size

                G.GAME.SuikaLatro_carryover_balls[k].perma_bonuses = {}
                for kk,vv in pairs(ball.perma_bonuses) do
                    G.GAME.SuikaLatro_carryover_balls[k].perma_bonuses[kk] = v
                end
            end
        end
    else
        local target_list = {}
        for k, ball in ipairs(SuikaLatro.balls) do
            target_list[k] = ball
        end
        for i = 1, num_carry_over do
            local ball, ball_id = pseudorandom_element(target_list, 'suika_carryover')
            target_list[ball_id] = nil
            G.GAME.SuikaLatro_carryover_balls[i] = {}
            G.GAME.SuikaLatro_carryover_balls[i].x = ball.body:getX()
            G.GAME.SuikaLatro_carryover_balls[i].y = ball.body:getY()
            G.GAME.SuikaLatro_carryover_balls[i].id = ball.id
            G.GAME.SuikaLatro_carryover_balls[i].suit = ball.suit
            G.GAME.SuikaLatro_carryover_balls[i].enhancement = ball.enhancement
            G.GAME.SuikaLatro_carryover_balls[i].edition = ball.edition
            G.GAME.SuikaLatro_carryover_balls[i].seal = ball.seal
            G.GAME.SuikaLatro_carryover_balls[i].size = ball.size

            G.GAME.SuikaLatro_carryover_balls[i].perma_bonuses = {}
            for kk,vv in pairs(ball.perma_bonuses) do
                G.GAME.SuikaLatro_carryover_balls[i].perma_bonuses[kk] = v
            end
        end

    end
end