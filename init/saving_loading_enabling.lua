--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- ENABLING, SAVING, AND LOADING
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

function SuikaLatro.f.enable_suika()
    SuikaLatro.world_T.y = 15
    --SuikaLatro.f.drawBG()
    --SuikaLatro.show_suika = true
    G.E_MANAGER:add_event(Event({
        trigger = "ease",
        ease = 'quad',
        delay = 1,
        ref_table = SuikaLatro.world_T,
        ref_value = "y",
        ease_to = 2.5,
    }))
end

function SuikaLatro.f.disable_suika()
    --if not G.STATE == G.STATES.BLIND_SELECT and not G.STATE == G.STATES.ROUND_EVAL then
        SuikaLatro.world_T.y = 2.5
        G.E_MANAGER:add_event(Event({
            trigger = "ease",
            ease = 'quad',
            delay = 1,
            ref_table = SuikaLatro.world_T,
            ref_value = "y",
            ease_to = 15,
        }))
    --end
end

function SuikaLatro.f.reset_suika(carry_over)
    for i = #SuikaLatro.balls, 1, -1 do
        SuikaLatro.balls[i].body:destroy()
        table.remove(SuikaLatro.balls, i)
    end
    if carry_over and G.GAME.SuikaLatro_carryover_balls then
        for k,v in ipairs(G.GAME.SuikaLatro_carryover_balls) do
            table.insert(SuikaLatro.balls, Ball(v.x, v.y, v, 0, 0, nil, nil, nil, v.size))
        end
    end
end

local save_run_ref = save_run --save balls too!
function save_run()
    G.GAME.SuikaLatro_ball_sizefactor = SuikaLatro.ball_sizefactor
    G.GAME.SuikaLatro_bounciness = SuikaLatro.bounciness
    
    G.GAME.SuikaLatro_balls = {}
    for k, ball in ipairs(SuikaLatro.balls) do
        G.GAME.SuikaLatro_balls[k] = {}
        G.GAME.SuikaLatro_balls[k].x = ball.body:getX()
        G.GAME.SuikaLatro_balls[k].y = ball.body:getY()
        G.GAME.SuikaLatro_balls[k].id = ball.id
        G.GAME.SuikaLatro_balls[k].suit = ball.suit
        G.GAME.SuikaLatro_balls[k].enhancement = ball.enhancement
        G.GAME.SuikaLatro_balls[k].edition = ball.edition
        G.GAME.SuikaLatro_balls[k].seal = ball.seal
        G.GAME.SuikaLatro_balls[k].size = ball.size
        G.GAME.SuikaLatro_balls[k].debuff = ball.debuff

        G.GAME.SuikaLatro_balls[k].perma_bonuses = {}
        for kk,vv in pairs(ball.perma_bonuses) do
            G.GAME.SuikaLatro_balls[k].perma_bonuses[kk] = v
        end
    end
    save_run_ref()
end

local Game_start_run_ref = Game.start_run 
function Game:start_run(args)
    Game_start_run_ref(self, args)
    SuikaLatro.f.reset_suika()
    SuikaLatro.do_merging = false
    
    for k,v in pairs(G.GAME.hands) do 
        if not string.find(k, 'suika') then
            SMODS.PokerHand:take_ownership(k,
                { visible = function(self) return false end },
            true)
        end
    end

    -- continuing run stuff 
    if G.STATE == G.STATES.SELECTING_HAND then
        SuikaLatro.world_T.y = 2.5
    end
    SuikaLatro.ball_sizefactor = G.GAME.SuikaLatro_ball_sizefactor or 15
    SuikaLatro.bounciness = G.GAME.SuikaLatro_bounciness or 0.1
    if G.GAME.SuikaLatro_balls then
        for k,v in ipairs(G.GAME.SuikaLatro_balls) do
            table.insert(SuikaLatro.balls, Ball(v.x, v.y, v, 0, 0, nil, nil, nil, v.size))
        end
    end
end

local new_round_ref = new_round
function new_round()
    SuikaLatro.f.enable_suika()
    SuikaLatro.f.reset_suika(true)
    new_round_ref()
end