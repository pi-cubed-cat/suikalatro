local filesystem = NFS or love.filesystem
local suika_mod_path = SMODS.current_mod

local gameMainMenuRef = Game.main_menu --code from aikoyori's shenanigans
function Game:main_menu(change_context)
    gameMainMenuRef(self, change_context)
    UIBox({
        definition = {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                colour = G.C.UI.TRANSPARENT_DARK
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        scale = 0.3,
                        text = "Suikalatro v0.2.0 (DEMO)",
                        colour = G.C.UI.TEXT_LIGHT
                    }
                }
            }
        },
        config = {
            align = "tli",
            bond = "Weak",
            offset = {
                x = 0,
                y = 0
            },
            major = G.ROOM_ATTACH
        }
    })
end

local function load_the_suika(img)
    local full_path = (suika_mod_path.path..'assets/'..img)
    local file_data = assert(NFS.newFileData(full_path))
    local tempimagedata = assert(love.image.newImageData(file_data))
    return (assert(love.graphics.newImage(tempimagedata)))
end

love.graphics.setDefaultFilter('nearest', 'nearest')
suika_seals = {
    Red = load_the_suika("seals/red.png"),
    Blue = load_the_suika("seals/blue.png"),
    Gold = load_the_suika("seals/gold.png"),
    Purple = load_the_suika("seals/purple.png"),
}

suika_fronts = {
    m_stone = load_the_suika("fronts/stone.png"),
    Spades = {
        c_base = load_the_suika("fronts/spade/base.png"),
        m_bonus = load_the_suika("fronts/spade/bonus.png"),
        m_mult = load_the_suika("fronts/spade/mult.png"),
        m_lucky = load_the_suika("fronts/spade/lucky.png"),
        m_glass = load_the_suika("fronts/spade/glass.png"),
        m_wild = load_the_suika("fronts/spade/wild.png"),
        m_gold = load_the_suika("fronts/spade/gold.png"),
        m_steel = load_the_suika("fronts/spade/steel.png"),
    },
    Hearts = {
        c_base = load_the_suika("fronts/heart/base.png"),
        m_bonus = load_the_suika("fronts/heart/bonus.png"),
        m_mult = load_the_suika("fronts/heart/mult.png"),
        m_lucky = load_the_suika("fronts/heart/lucky.png"),
        m_glass = load_the_suika("fronts/heart/glass.png"),
        m_wild = load_the_suika("fronts/heart/wild.png"),
        m_gold = load_the_suika("fronts/heart/gold.png"),
        m_steel = load_the_suika("fronts/heart/steel.png"),
    },
    Diamonds = {
        c_base = load_the_suika("fronts/diamond/base.png"),
        m_bonus = load_the_suika("fronts/diamond/bonus.png"),
        m_mult = load_the_suika("fronts/diamond/mult.png"),
        m_lucky = load_the_suika("fronts/diamond/lucky.png"),
        m_glass = load_the_suika("fronts/diamond/glass.png"),
        m_wild = load_the_suika("fronts/diamond/wild.png"),
        m_gold = load_the_suika("fronts/diamond/gold.png"),
        m_steel = load_the_suika("fronts/diamond/steel.png"),
    },
    Clubs = {
        c_base = load_the_suika("fronts/club/base.png"),
        m_bonus = load_the_suika("fronts/club/bonus.png"),
        m_mult = load_the_suika("fronts/club/mult.png"),
        m_lucky = load_the_suika("fronts/club/lucky.png"),
        m_glass = load_the_suika("fronts/club/glass.png"),
        m_wild = load_the_suika("fronts/club/wild.png"),
        m_gold = load_the_suika("fronts/club/gold.png"),
        m_steel = load_the_suika("fronts/club/steel.png"),
    },
}

love.physics.setMeter(64)
SuikaLatro = {
    world = love.physics.newWorld(0, 9.81*64, true),
    world_width = 660, --x
    world_height = 590, --y
    box = {
        width = 550,
        height = 650, 
    },
    walls = { --static objects
        ground = {},
        leftwall = {},
        rightwall = {},
        highleftwall = { invisible = true },
        highrightwall = { invisible = true },
    },
    balls = {}, --dynamic objects
    ball_sizefactor = 15,
    next_ball = nil,
    indicator = {
        x = 0,
        y = -500
    },
    drop_wait_time = 0,
    do_physics = true,
    do_merging = false,
    show_suika = false,
    cut_high_ranks = true,
    f = {}, --functions
    flush_groups = {},
    show_flushes = true,
    lowball = true,
    poker_combos = {
        five_flush = {chips = 40, mult = 2, chips_mod = 20, mult_mod = 2},
        ten_flush = {chips = 80, mult = 7, chips_mod = 20, mult_mod = 4},
        mega_flush = {chips = 150, mult = 15, chips_mod = 50, mult_mod = 5},
        merge_1 = {chips = 5, mult = 1, chips_mod = 10, mult_mod = 1},
        merge_2 = {chips = 5, mult = 2, chips_mod = 10, mult_mod = 2},
        merge_3 = {chips = 10, mult = 2, chips_mod = 15, mult_mod = 2},
        merge_4 = {chips = 10, mult = 3, chips_mod = 15, mult_mod = 3},
        combo_breaker = {chips = 20, mult = 5, chips_mod = 25, mult_mod = 3},
        lowball = {chips = 2, mult = 1, chips_mod = 10, mult_mod = 1},
    },
    triggered_combos = {},
    scoring_suits = {
        ['Hearts'] = 0,
        ['Diamonds'] = 0,
        ['Spades'] = 0,
        ['Clubs'] = 0
    },
}

local get_blind_amount_ref = get_blind_amount
function get_blind_amount(ante)
    return get_blind_amount_ref(ante) * 10
end

assert(SMODS.load_file("content/pokercombos.lua"))()
assert(SMODS.load_file("content/rankoverrides.lua"))()
assert(SMODS.load_file("content/jokers.lua"))()
assert(SMODS.load_file("content/tarots_spectrals_seals.lua"))()
assert(SMODS.load_file("content/blinds.lua"))()

local screen_w, screen_h = love.window.getMode()

local suikaground = SuikaLatro.walls.ground
suikaground.body = love.physics.newBody(SuikaLatro.world, 0, SuikaLatro.box.height/2, "static") --shape anchors to the body from its center
suikaground.shape = love.physics.newRectangleShape(SuikaLatro.box.width, 20) --make a rectangle with a width of arg1 and a height of arg2
suikaground.fixture = love.physics.newFixture(suikaground.body, suikaground.shape) --attach shape to body

local suikaleft = SuikaLatro.walls.leftwall
suikaleft.body = love.physics.newBody(SuikaLatro.world, -1 * SuikaLatro.box.width/2, 0, "static")
suikaleft.shape = love.physics.newRectangleShape(20, SuikaLatro.box.height)
suikaleft.fixture = love.physics.newFixture(suikaleft.body, suikaleft.shape)

local highsuikaleft = SuikaLatro.walls.highleftwall
highsuikaleft.body = love.physics.newBody(SuikaLatro.world, -1 * SuikaLatro.box.width/2, 0, "static")
highsuikaleft.shape = love.physics.newRectangleShape(20, SuikaLatro.box.height*10)
highsuikaleft.fixture = love.physics.newFixture(highsuikaleft.body, highsuikaleft.shape)

local suikaright = SuikaLatro.walls.rightwall
suikaright.body = love.physics.newBody(SuikaLatro.world, SuikaLatro.box.width/2, 0, "static")
suikaright.shape = love.physics.newRectangleShape(20, SuikaLatro.box.height)
suikaright.fixture = love.physics.newFixture(suikaright.body, suikaright.shape)

local highsuikaright = SuikaLatro.walls.highrightwall
highsuikaright.body = love.physics.newBody(SuikaLatro.world, SuikaLatro.box.width/2, 0, "static")
highsuikaright.shape = love.physics.newRectangleShape(20, SuikaLatro.box.height*10)
highsuikaright.fixture = love.physics.newFixture(highsuikaright.body, highsuikaright.shape)

boundary = {}
local boundary_width = 5
boundary.body = love.physics.newBody(SuikaLatro.world, 0, -1*SuikaLatro.box.height/2 + boundary_width/2, "static")
boundary.shape = love.physics.newRectangleShape(SuikaLatro.box.width, boundary_width)

half_boundary = {}
half_boundary.body = love.physics.newBody(SuikaLatro.world, 0, 0 + boundary_width/2, "static")
half_boundary.shape = love.physics.newRectangleShape(SuikaLatro.box.width, boundary_width)

-- Transform pixels into game units (code from the Hot Potato mod's Plinko minigame) 
local function to_game_units(val)
    return val / (G.TILESCALE*G.TILESIZE)
end

local function to_pixels(val)
    return val * (G.TILESCALE*G.TILESIZE)
end

local screen_w, screen_h

local world_T = {x = 0, y = 2.5, w = 7.000, h = 6.195}

local function t_x(x)
    return to_pixels(
        -- offset 0,0 to be relative to the center of the screen, then transform x from pixels to screen units
        to_game_units(screen_w/2) + world_T.x + x / SuikaLatro.world_width * world_T.w
    )
end

local function t_y(y)
    -- same as above
    return to_pixels(to_game_units(screen_h/2) + world_T.y + y / SuikaLatro.world_height * world_T.h)
end

local function t_r(r)
    return to_pixels(r / SuikaLatro.world_height * world_T.h)
end

local function p_to_pixels(x, y)
    return t_x(x), t_y(y)
end

local function poly_to_pixels(x1, y1, x2, y2, x3, y3, x4, y4)
    return t_x(x1), t_y(y1), t_x(x2), t_y(y2), t_x(x3), t_y(y3), t_x(x4), t_y(y4)
end

Ball = Object:extend()

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

function Ball:init(x,y,fixed_properties, rank_delta, combo, fix_enhancement, fix_edition, fix_seal)
    self.body = love.physics.newBody(SuikaLatro.world, x, y, "dynamic")
    self.flush_size = 0
    if not fixed_properties then
        --self.rank = SuikaLatro.next_ball.base.value
        self.id = SuikaLatro.next_ball.base.id
        self.suit = SuikaLatro.next_ball.base.suit
        self.enhancement = SuikaLatro.next_ball.config.center.key
        self.edition = SuikaLatro.next_ball.edition and SuikaLatro.next_ball.edition.key or nil
        self.seal = SuikaLatro.next_ball.seal
        self.size = get_size(self.id, SuikaLatro.next_ball.config.center.key == 'm_stone')
        self.merges = 0
    else
        rank_delta = rank_delta or 0
        --self.rank = fixed_properties.rank + rank_delta
        self.id = fixed_properties.id + rank_delta > 14 and 2 or fixed_properties.id + rank_delta
        self.suit = fixed_properties.suit
        self.enhancement = fix_enhancement or fixed_properties.enhancement
        self.edition = fix_edition or fixed_properties.edition
        self.seal = fix_seal or fixed_properties.seal
        self.size = get_size(self.id, self.enhancement == 'm_stone')
        self.merges = combo or 0
    end
    self.canvas = love.graphics.newCanvas(self.size*2, self.size*2)
    self.shape = love.physics.newCircleShape(self.size)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setRestitution(0.1)
    if self.enhancement == 'm_steel' then
        self.fixture:setDensity(100)
        self.body:resetMassData()
    end
    self.fixture:setUserData(self)
    self.merge_target = nil
    self.remove = false
end

function SuikaLatro.f.enable_suika()
    SuikaLatro.f.drawBG()
    SuikaLatro.show_suika = true
end

function SuikaLatro.f.disable_suika()
    SuikaLatro.show_suika = false
end

function SuikaLatro.f.reset_suika()
    for i = #SuikaLatro.balls, 1, -1 do
        SuikaLatro.balls[i].body:destroy()
        table.remove(SuikaLatro.balls, i)
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

function beginContact(a, b, coll)
    local x, y = coll:getNormal()
    local objA = a:getUserData()
    local objB = b:getUserData()
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
    if objA and objB and objA.id and objB.id then
        if (#SMODS.find_card('j_shortcut') > 0 and ((objA.id == 2 and objB.id == 14 or objA.id == 14 and objB.id == 2) or math.abs(objA.id - objB.id) <= 1))
        or ((objA.id == objB.id or objA.enhancement == 'm_stone' or objB.enhancement == 'm_stone')) then
            if not objA.merge_target and not objB.merge_target and not objB.dont_prod then
                objA.merge_target = objB
                objB.merge_target = objA
                objB.dont_prod = true
            end
        elseif SuikaLatro.drop_wait_time < 0.8 and not SuikaLatro.do_merging and
        (objA and objA == SuikaLatro.balls[#SuikaLatro.balls] and objA.body:getY() + objA.size < boundary.body:getY()
        or objB and objB == SuikaLatro.balls[#SuikaLatro.balls] and objB.body:getY() + objB.size < boundary.body:getY()) then
            G.E_MANAGER:add_event(Event({
                trigger = "immediate",
                func = function()
                    G.STATE = G.STATES.HAND_PLAYED
                    G.STATE_COMPLETE = true
                    end_round()
                    return true
                end,
            }))
        end
    end
end

--SuikaLatro.balls[#SuikaLatro.balls].body:getY()
--SuikaLatro.balls[#SuikaLatro.balls].size
--boundary.body:getY()
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
        end
    end
end

SuikaLatro.world:setCallbacks(beginContact, endContact)

function SuikaLatro.f.enhancement_message(x_, y_, mtype, amt)
    if mtype == 'm_mult' then
        if not amt then amt = 4 end
        attention_text({
            text = "+"..amt,
            scale = 0.5,
            hold = 1,
            major = G.ROOM_ATTACH,
            backdrop_colour = G.C.MULT,
            align = 'cm',
            offset = {x = -20/2 + 20/screen_w * (t_x(x_) + 20*math.random() - 0.5), y = -11.5/2 + 11.5/screen_h * (t_y(y_) + 20*math.random() - 0.5)},
            silent = true
        })
        play_sound('multhit1')
        G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult + amt
        G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
    elseif mtype == 'm_bonus' then
        if not amt then amt = 30 end
        attention_text({
            text = "+"..amt,
            scale = 0.5,
            hold = 1,
            major = G.ROOM_ATTACH,
            backdrop_colour = G.C.CHIPS,
            align = 'cm',
            offset = {x = -20/2 + 20/screen_w * (t_x(x_) + 20*math.random() - 0.5), y = -11.5/2 + 11.5/screen_h * (t_y(y_) + 20*math.random() - 0.5)},
            silent = true
        })
        play_sound('chips1')
        G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips + amt
        G.GAME.current_round.current_hand.chip_text = tostring(G.GAME.current_round.current_hand.chips)
    elseif mtype == 'm_glass' then
        if not amt then amt = 2 end
        attention_text({
            text = 'X'..amt,
            scale = 0.5,
            hold = 1,
            major = G.ROOM_ATTACH,
            backdrop_colour = G.C.MULT,
            align = 'cm',
            offset = {x = -20/2 + 20/screen_w * (t_x(x_) + 20*math.random() - 0.5), y = -11.5/2 + 11.5/screen_h * (t_y(y_) + 20*math.random() - 0.5)},
            silent = true
        })
        play_sound('multhit2')
        G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult * amt
        G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
    elseif mtype == 'm_lucky' then
        if pseudorandom('suika_lucky_mult') < G.GAME.probabilities.normal / 5 then
            attention_text({
                text = "+"..20,
                scale = 0.5,
                hold = 1,
                major = G.ROOM_ATTACH,
                backdrop_colour = G.C.MULT,
                align = 'cm',
                offset = {x = -20/2 + 20/screen_w * (t_x(x_) + 20*math.random() - 0.5), y = -11.5/2 + 11.5/screen_h * (t_y(y_) + 20*math.random() - 0.5)},
                silent = true
            })
            play_sound('multhit1')
            G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult + 20
            G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
        end
        if pseudorandom('suika_lucky_money') < G.GAME.probabilities.normal / 15 then
            attention_text({
                text = "$"..20,
                scale = 0.5,
                hold = 1,
                major = G.ROOM_ATTACH,
                backdrop_colour = G.C.MONEY,
                align = 'cm',
                offset = {x = -20/2 + 20/screen_w * (t_x(x_) + 20*math.random() - 0.5), y = -11.5/2 + 11.5/screen_h * (t_y(y_) + 20*math.random() - 0.5)},
                silent = true
            })
            play_sound('coin3')
            ease_dollars(20, true)
        end
    elseif mtype == 'm_steel' then
        if not amt then amt = 1.5 end
        attention_text({
            text = 'X'..amt,
            scale = 0.5,
            hold = 1,
            major = G.ROOM_ATTACH,
            backdrop_colour = G.C.MULT,
            align = 'cm',
            offset = {x = -20/2 + 20/screen_w * (t_x(x_) + 20*math.random() - 0.5), y = -11.5/2 + 11.5/screen_h * (t_y(y_) + 20*math.random() - 0.5)},
            silent = true
        })
        play_sound('multhit2')
        G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult * amt
        G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
    elseif mtype == 'm_gold' then
        if not amt then amt = 3 end
        attention_text({
            text = "$"..amt,
            scale = 0.5,
            hold = 1,
            major = G.ROOM_ATTACH,
            backdrop_colour = G.C.MONEY,
            align = 'cm',
            offset = {x = -20/2 + 20/screen_w * (t_x(x_) + 20*math.random() - 0.5), y = -11.5/2 + 11.5/screen_h * (t_y(y_) + 20*math.random() - 0.5)},
            silent = true
        })
        play_sound('coin3')
        ease_dollars(amt, true)
    end
end

function SuikaLatro.f.update(dt)
    SuikaLatro.drop_wait_time = SuikaLatro.drop_wait_time + dt
    
    if SuikaLatro.do_physics then
        SuikaLatro.world:update(dt)
        SuikaLatro.f.find_flush_groups()
    end
    --if not G.STATE == G.STATES.GAME_OVER then SuikaLatro.world:update(dt) end
    local size_offset = SuikaLatro.next_ball and (SuikaLatro.next_ball.facing == 'back' and 20 or get_size(SuikaLatro.next_ball.base.id, SuikaLatro.next_ball.config.center.key == 'm_stone')) or 20
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        SuikaLatro.indicator.x = SuikaLatro.indicator.x - 200 * dt
        if SuikaLatro.walls.leftwall.body:getX() + size_offset + 12 > SuikaLatro.indicator.x then
            SuikaLatro.indicator.x = SuikaLatro.walls.leftwall.body:getX() + size_offset + 12
        end
    end
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        SuikaLatro.indicator.x = SuikaLatro.indicator.x + 200 * dt
        if SuikaLatro.walls.rightwall.body:getX() - size_offset - 12 < SuikaLatro.indicator.x then
            SuikaLatro.indicator.x = SuikaLatro.walls.rightwall.body:getX() - size_offset - 12
        end
    end
    if G.GAME then
        G.GAME.SuikaLatro = G.GAME.SuikaLatro or {}
        G.GAME.SuikaLatro.balls = G.GAME.SuikaLatro.balls or {}
    end

    if G.hand and G.hand.highlighted and #G.hand.highlighted == 1 then
        SuikaLatro.next_ball = G.hand.highlighted[1]
    else
        SuikaLatro.next_ball = nil
    end

    if SuikaLatro.do_merging then
        for k, v in ipairs(SuikaLatro.balls) do
            if v.merge_target then
                v.fixture:setMask(1)
                v.merge_target.fixture:setMask(1)
                local delta_x, delta_y = (v.body:getX() - v.merge_target.body:getX()), (v.body:getY() - v.merge_target.body:getY())
                local distance = math.sqrt( ( delta_x )^2 + ( delta_y )^2 )
                if distance > 15*math.sqrt(v.id) then
                    local angle = math.atan2(delta_y, delta_x)
                    v.body:setLinearVelocity(
                    -50000 * dt * math.cos(angle),
                    -50000 * dt * math.sin(angle)
                    )
                else
                    if v.dont_prod then -- only one of the balls creates a new ball
                        SuikaLatro.lowball = false
                        local selected_ball = math.random()
                        local merge_count = math.max(v.merges, v.merge_target.merges) + 1
                        local fixed_enhancement = nil
                        local fixed_edition = nil
                        local fixed_seal = nil
                        if (v.enhancement ~= 'c_base' or v.merge_target.enhancement ~= 'c_base') and (v.enhancement == 'c_base' or v.merge_target.enhancement == 'c_base') then
                            fixed_enhancement = v.enhancement ~= 'c_base' and v.enhancement or v.merge_target.enhancement
                        end
                        if (not v.edition or not v.merge_target.enhancement) and (v.edition or v.merge_target.edition) then
                            fixed_enhancement = v.edition or v.merge_target.edition
                        end
                        if (not v.seal or not v.merge_target.seal) and (v.seal or v.merge_target.seal) then
                            fixed_enhancement = v.seal or v.merge_target.seal
                        end
                        if not ((v.enhancement == 'm_glass' and pseudorandom('suika_glass') < G.GAME.probabilities.normal / 2) or (v.merge_target.enhancement == 'm_glass' and pseudorandom('suika_glass2') < G.GAME.probabilities.normal / 2)) then
                            table.insert(SuikaLatro.balls, Ball(v.body:getX(), v.body:getY(), selected_ball > 0.5 and v.merge_target or v, 1, merge_count, fixed_enhancement, fixed_edition, fixed_seal))
                        else
                            play_sound('glass'..math.random(1, 6), math.random()*0.2 + 0.9,0.4)
                            play_sound('generic1', math.random()*0.2 + 0.9,0.5)
                        end
                        local combo_chips = 0
                        local combo_mult = 0
                        if merge_count == 1 then
                            G.GAME.hands.suika_merge_1.played = G.GAME.hands.suika_merge_1.played + 1
                            SuikaLatro.triggered_combos['suika_merge_1'] = SuikaLatro.triggered_combos['suika_merge_1'] and SuikaLatro.triggered_combos['suika_merge_1'] + 1 or 1
                            combo_chips = G.GAME.hands.suika_merge_1.chips
                            combo_mult = G.GAME.hands.suika_merge_1.mult
                        elseif merge_count == 2 then
                            G.GAME.hands.suika_merge_2.played = G.GAME.hands.suika_merge_2.played + 1
                            SuikaLatro.triggered_combos['suika_merge_2'] = SuikaLatro.triggered_combos['suika_merge_2'] and SuikaLatro.triggered_combos['suika_merge_2'] + 1 or 1
                            combo_chips = G.GAME.hands.suika_merge_2.chips
                            combo_mult = G.GAME.hands.suika_merge_2.mult
                        elseif merge_count == 3 then
                            G.GAME.hands.suika_merge_3.played = G.GAME.hands.suika_merge_3.played + 1
                            SuikaLatro.triggered_combos['suika_merge_3'] = SuikaLatro.triggered_combos['suika_merge_3'] and SuikaLatro.triggered_combos['suika_merge_3'] + 1 or 1
                            combo_chips = G.GAME.hands.suika_merge_3.chips
                            combo_mult = G.GAME.hands.suika_merge_3.mult
                        elseif merge_count == 4 then
                            G.GAME.hands.suika_merge_4.played = G.GAME.hands.suika_merge_4.played + 1
                            SuikaLatro.triggered_combos['suika_merge_4'] = SuikaLatro.triggered_combos['suika_merge_4'] and SuikaLatro.triggered_combos['suika_merge_4'] + 1 or 1
                            combo_chips = G.GAME.hands.suika_merge_4.chips
                            combo_mult = G.GAME.hands.suika_merge_4.mult
                        elseif merge_count >= 5 then
                            G.GAME.hands.suika_combo_breaker.played = G.GAME.hands.suika_combo_breaker.played + 1
                            SuikaLatro.triggered_combos['suika_combo_breaker'] = SuikaLatro.triggered_combos['suika_combo_breaker'] and SuikaLatro.triggered_combos['suika_combo_breaker'] + 1 or 1
                            combo_chips = G.GAME.hands.suika_combo_breaker.chips
                            combo_mult = G.GAME.hands.suika_combo_breaker.mult
                        end
                        
                        if v.enhancement == 'm_wild' then
                            if SuikaLatro.f.is_suit(v, 'Hearts') then SuikaLatro.scoring_suits["Hearts"] = SuikaLatro.scoring_suits["Hearts"] + 1
                            elseif SuikaLatro.f.is_suit(v, 'Diamonds') then SuikaLatro.scoring_suits["Diamonds"] = SuikaLatro.scoring_suits["Diamonds"] + 1
                            elseif SuikaLatro.f.is_suit(v, 'Spades') then SuikaLatro.scoring_suits["Spades"] = SuikaLatro.scoring_suits["Spades"] + 1
                            elseif SuikaLatro.f.is_suit(v, 'Clubs') then SuikaLatro.scoring_suits["Clubs"] = SuikaLatro.scoring_suits["Clubs"] + 1 end
                        end
                        if v.merge_target.enhancement == 'm_wild' then
                            if SuikaLatro.f.is_suit(v.merge_target, 'Hearts') then SuikaLatro.scoring_suits["Hearts"] = SuikaLatro.scoring_suits["Hearts"] + 1
                            elseif SuikaLatro.f.is_suit(v.merge_target, 'Diamonds') then SuikaLatro.scoring_suits["Diamonds"] = SuikaLatro.scoring_suits["Diamonds"] + 1
                            elseif SuikaLatro.f.is_suit(v.merge_target, 'Spades') then SuikaLatro.scoring_suits["Spades"] = SuikaLatro.scoring_suits["Spades"] + 1
                            elseif SuikaLatro.f.is_suit(v.merge_target, 'Clubs') then SuikaLatro.scoring_suits["Clubs"] = SuikaLatro.scoring_suits["Clubs"] + 1 end
                        end
                        if v.enhancement ~= 'm_wild' then
                            if SuikaLatro.f.is_suit(v, 'Hearts') then SuikaLatro.scoring_suits["Hearts"] = SuikaLatro.scoring_suits["Hearts"] + 1
                            elseif SuikaLatro.f.is_suit(v, 'Diamonds') then SuikaLatro.scoring_suits["Diamonds"] = SuikaLatro.scoring_suits["Diamonds"] + 1
                            elseif SuikaLatro.f.is_suit(v, 'Spades') then SuikaLatro.scoring_suits["Spades"] = SuikaLatro.scoring_suits["Spades"] + 1
                            elseif SuikaLatro.f.is_suit(v, 'Clubs') then SuikaLatro.scoring_suits["Clubs"] = SuikaLatro.scoring_suits["Clubs"] + 1 end
                        end
                        if v.merge_target.enhancement ~= 'm_wild' then
                            if SuikaLatro.f.is_suit(v.merge_target, 'Hearts') then SuikaLatro.scoring_suits["Hearts"] = SuikaLatro.scoring_suits["Hearts"] + 1
                            elseif SuikaLatro.f.is_suit(v.merge_target, 'Diamonds') then SuikaLatro.scoring_suits["Diamonds"] = SuikaLatro.scoring_suits["Diamonds"] + 1
                            elseif SuikaLatro.f.is_suit(v.merge_target, 'Spades') then SuikaLatro.scoring_suits["Spades"] = SuikaLatro.scoring_suits["Spades"] + 1
                            elseif SuikaLatro.f.is_suit(v.merge_target, 'Clubs') then SuikaLatro.scoring_suits["Clubs"] = SuikaLatro.scoring_suits["Clubs"] + 1 end
                        end
                        local x_pos = v.body:getX()
                        local y_pos = v.body:getY()
                        local id_ = v.enhancement == 'm_stone' and 2 or v.id
                        local id2_ = v.merge_target.enhancement == 'm_stone' and 2 or v.merge_target.id
                        local self_enhancement = v.enhancement
                        local other_enhancement = v.merge_target.enhancement
                        G.E_MANAGER:add_event(Event({ -- base chips & combo #
                            trigger = 'immediate',
                            blockable = false,
                            func = function()
                                attention_text({
                                    text = tostring(merge_count.."X"),
                                    scale = 0.5 + merge_count/10,
                                    hold = 0.3,
                                    major = G.ROOM_ATTACH,
                                    backdrop_colour = merge_count < 5 and G.C.ORANGE or G.C.RED,
                                    align = 'cm',
                                    offset = {x = -20/2 + 20/screen_w * t_x(x_pos), y = -11.5/2 + 11.5/screen_h * t_y(y_pos)},
                                    silent = true
                                })
                                play_sound('multhit1', math.random()*0.2 + 0.7 + 0.1*merge_count, 0.6 + merge_count/20)

                                G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips + combo_chips + 2^(get_size(id_)/SuikaLatro.ball_sizefactor)/2 + 2^(get_size(id2_)/SuikaLatro.ball_sizefactor)/2
                                G.GAME.current_round.current_hand.chip_text = tostring(G.GAME.current_round.current_hand.chips)
                                G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult + combo_mult
                                G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
                                return true
                            end
                        }))
                        if self_enhancement ~= 'c_base' and self_enhancement ~= 'm_gold' and self_enhancement ~= 'm_steel' then -- enhancements for ball 1
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                blockable = false,
                                delay = 1,
                                func = function()
                                    SuikaLatro.f.enhancement_message(x_pos, y_pos, self_enhancement)
                                    return true
                                end
                            }))
                        end
                        if other_enhancement ~= 'c_base' and other_enhancement ~= 'm_gold' and other_enhancement ~= 'm_steel' then -- enhancements for ball 2
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                blockable = false,
                                delay = 1 + (self_enhancement ~= 'c_base' and 1 or 0),
                                func = function()
                                    SuikaLatro.f.enhancement_message(x_pos, y_pos, other_enhancement)
                                    return true
                                end
                            }))
                        end
                        v.merge_target.remove = true
                        v.remove = true
                    --else
                        --v.merge_target.remove = true
                        --v.remove = true
                    end
                end
            end
        end
    end

    for i = #SuikaLatro.balls, 1, -1 do
        if SuikaLatro.balls[i].remove then
            SuikaLatro.balls[i].body:destroy()
            table.remove(SuikaLatro.balls, i)
        end
    end
end

function SuikaLatro.f.drop_ball()
    if G.hand and G.hand.highlighted and #G.hand.highlighted == 1 and SuikaLatro.drop_wait_time > 0.8 then
        SuikaLatro.drop_wait_time = 0
        SuikaLatro.next_ball = G.hand.highlighted[1]
        local size_offset = SuikaLatro.next_ball and get_size(SuikaLatro.next_ball.base.id, SuikaLatro.next_ball.config.center.key == 'm_stone') or 10
        if SuikaLatro.walls.leftwall.body:getX() + size_offset + 12 > SuikaLatro.indicator.x then
            SuikaLatro.indicator.x = SuikaLatro.walls.leftwall.body:getX() + size_offset + 12
        elseif SuikaLatro.walls.rightwall.body:getX() - size_offset - 12 < SuikaLatro.indicator.x then
            SuikaLatro.indicator.x = SuikaLatro.walls.rightwall.body:getX() - size_offset - 12
        end
        table.insert(SuikaLatro.balls, Ball(SuikaLatro.indicator.x, SuikaLatro.indicator.y))
        SuikaLatro.indicator.x = SuikaLatro.indicator.x + (math.random() + 0.5) / 50 --makes stacking harder
        draw_card(G.hand, G.discard, 50, 'down', false, G.hand.highlighted[1])
        inc_career_stat('c_cards_played', 1)
        G.FUNCS.draw_from_deck_to_hand(1)
        --[[if #G.deck.cards == 0 then
            G.FUNCS.draw_from_deck_to_hand(1)
            G.FUNCS.draw_from_discard_to_deck()
        end]]
    end
end

SMODS.Keybind {
    key_pressed = 'down',
    event = 'pressed',
    action = function(self)
        SuikaLatro.f.drop_ball()
    end
}

SMODS.Keybind {
    key_pressed = 's',
    event = 'pressed',
    action = function(self)
        SuikaLatro.f.drop_ball()
    end
}

function SuikaLatro.f.draw_ball(ball, x_pos, y_pos, size, id, suit, front)
    if type(size) == 'string' then --flipped cards -> hidden nextball
        local x, y = p_to_pixels(x_pos, y_pos)
        love.graphics.setColor(1, 1, 1, 0.5) --indicator
        love.graphics.rectangle("fill", x-t_r(40 + 10*math.sin(love.timer.getTime())), y, 2*t_r(40 + 10*math.sin(love.timer.getTime())), t_y(SuikaLatro.box.height)+t_r(40 + 10*math.sin(love.timer.getTime())))
        
        love.graphics.setColor(1, 1, 1, SuikaLatro.drop_wait_time > 0.8 and 1 or 0.5) 
        love.graphics.circle("fill", x, y, t_r(40 + 10*math.sin(love.timer.getTime())))
        love.graphics.setColor(darken({1, 1, 1}, 0.5)) 
        love.graphics.printf('?', x, y, 200, "center", 0, t_r(40 + 10*math.sin(love.timer.getTime()))/24, t_r(40 + 10*math.sin(love.timer.getTime()))/24, 99, 10.5)
    else
        local color = G.C.SUITS[suit]
        if front == 'm_stone' then
            color = G.C.GREY
        end
        local x, y = p_to_pixels(x_pos, y_pos)
        local angle = 0
        if ball.body then angle = ball.body:getAngle() end
        love.graphics.setColor(color)
        love.graphics.circle("fill", x, y, t_r(size + 1))
        if ball.flush_size then
            love.graphics.setColor(lighten(G.C.SUITS[suit], ball.flush_size >= 5 - SuikaLatro.ff_count and 0.70 or 1))
        else --indicator (won't be in a flush, and can be trans)
            love.graphics.setColor(1, 1, 1, SuikaLatro.drop_wait_time > 0.8 and 1 or 0.5)
        end
        love.graphics.circle("fill", x, y, t_r(size - 2))
        love.graphics.setColor(1, 1, 1, front == 'c_base' and 0.25 or front == 'm_mult' and 0.4 or front == 'm_wild' and 0.6 or 0.75)
        if front == 'm_stone' then
            love.graphics.draw(suika_fronts.m_stone, x, y, angle, t_r(size/24), t_r(size/24), 18, 18)
        else
            love.graphics.draw(suika_fronts[suit][front], x, y, angle, t_r(size/24), t_r(size/24), 18, 18)
        end

        -- rank text
        if front ~= 'm_stone' then
            love.graphics.setColor(darken(color, 0.4))
            local rank = tostring(id)
            if rank == "11" then rank = "J"
            elseif rank == "12" then rank = "Q"
            elseif rank == "13" then rank = "K"
            elseif rank == "14" then rank = "A" end
            love.graphics.printf(rank, x, y, 200, "center", 0, t_r(size/20), t_r(size/20), 99, 10.5)
        end
    end

end

function SuikaLatro.f.draw()
    screen_w, screen_h = love.window.getMode()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    local next_is_stone = nil
    if SuikaLatro.next_ball and SuikaLatro.next_ball.facing == 'front' then
        local i_x, i_y = p_to_pixels(SuikaLatro.indicator.x, SuikaLatro.indicator.y)
        next_is_stone = SuikaLatro.next_ball.config.center.key == 'm_stone'
        love.graphics.setColor(1, 1, 1, 0.5) --indicator
        love.graphics.rectangle("fill", i_x-t_r((get_size(SuikaLatro.next_ball.base.id, next_is_stone))), i_y, 2*t_r((get_size(SuikaLatro.next_ball.base.id, next_is_stone))), t_y(SuikaLatro.box.height)+t_r((get_size(SuikaLatro.next_ball.base.id, next_is_stone))))
    end

    love.graphics.setColor(G.C.RED) --boundary line
    love.graphics.polygon("fill", poly_to_pixels(boundary.body:getWorldPoints(boundary.shape:getPoints())))

    love.graphics.setColor(G.C.GREY, 0.5) --half-boundary line
    love.graphics.polygon("fill", poly_to_pixels(half_boundary.body:getWorldPoints(half_boundary.shape:getPoints())))

    love.graphics.setColor(G.C.BLACK) --grounds
    for k,v in pairs(SuikaLatro.walls) do
        if not v.invisible then
            love.graphics.polygon("fill", poly_to_pixels(v.body:getWorldPoints(v.shape:getPoints())))
        end
    end

    if not SuikaLatro.next_ball then --blank indicator
        love.graphics.setColor(1, 1, 1) 
        local x, y = p_to_pixels(SuikaLatro.indicator.x, SuikaLatro.indicator.y)
        love.graphics.circle("fill", x, y, t_r(10))
    elseif SuikaLatro.next_ball.facing == 'back' then
        SuikaLatro.f.draw_ball(SuikaLatro.next_ball, SuikaLatro.indicator.x, SuikaLatro.indicator.y, "?")
    else
        SuikaLatro.f.draw_ball(SuikaLatro.next_ball, SuikaLatro.indicator.x, SuikaLatro.indicator.y, get_size(SuikaLatro.next_ball.base.id, next_is_stone), SuikaLatro.next_ball.base.id, SuikaLatro.next_ball.base.suit, SuikaLatro.next_ball.config.center.key)
    end
    
    SuikaLatro.ff_count = #SMODS.find_card('j_four_fingers') or 0
    for k, v in ipairs(SuikaLatro.balls) do --fallen balls
        SuikaLatro.f.draw_ball(v, v.body:getX(), v.body:getY(), v.size, v.id, v.suit, v.enhancement)
    end
    
end

function G.UIDEF.suika_main()
    return {n = G.UIT.ROOT, config = {r = 0.1, minw = 7, minh = 10, align = "tm", padding = 0.2, colour = G.C.UI.TRANSPARENT_DARK }, nodes = {
        --[[{n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, }, nodes={
                
            }
        },]]
    }}
end

function SuikaLatro.f.drawBG()
    local menu = nil
    menu = UIBox{
        definition = G.UIDEF.suika_main(),
        config = {align='cm', offset = {x=0,y=G.ROOM.T.y + 2}, major = G.ROOM_ATTACH, bond = 'Weak'}
    }
    return menu
end

G.FUNCS.suika_can_play = function(e)
    if SuikaLatro.balls and #SuikaLatro.balls > 0 then 
        e.config.colour = G.C.BLUE
        e.config.button = 'suika_play'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.suika_play = function(e)
    if G.play and G.play.cards[1] then print("word") return end
    --check the hand first

    stop_use()
    G.hand:unhighlight_all()
    G.GAME.blind.triggered = false
    G.CONTROLLER.interrupt.focus = true
    SuikaLatro.triggered_combos = {}
    SuikaLatro.scoring_suits = {
        ['Hearts'] = 0,
        ['Diamonds'] = 0,
        ['Spades'] = 0,
        ['Clubs'] = 0
    }
    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end
    
    table.sort(G.hand.highlighted, function(a,b) return a.T.x < b.T.x end)

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.STATE = G.STATES.HAND_PLAYED
            G.STATE_COMPLETE = true
            return true
        end
    }))
    inc_career_stat('c_hands_played', 1)
    ease_hands_played(-1)
    delay(0.4)

    SuikaLatro.do_physics = false

    --[[G.GAME.current_round.current_hand.chip_total = 0
    G.GAME.current_round.current_hand.chips = 0
    G.GAME.current_round.current_hand.chip_text = 0
    G.GAME.current_round.current_hand.mult = 0
    G.GAME.current_round.current_hand.mult_text = 0]]

    if G.GAME.blind:press_play() then
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                SMODS.juice_up_blind()
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                return true
            end)
        }))
        delay(0.4)
    end

    SuikaLatro.lowball = true
    -- evaluate flushes
    local has_ff = #SMODS.find_card('j_four_fingers') or 0
    for k,v in pairs(SuikaLatro.flush_groups) do

        if #v >= 5 - has_ff and #v < 10 - has_ff then
            delay(1)
            SuikaLatro.triggered_combos['suika_five_flush'] = SuikaLatro.triggered_combos['suika_five_flush'] and SuikaLatro.triggered_combos['suika_five_flush'] + 1 or 1
            lowball = false
            G.E_MANAGER:add_event(Event({
                func = function()
                    attention_text({
                        text = "5-Flush!",
                        scale = 0.8,
                        hold = 0.3,
                        major = G.ROOM_ATTACH,
                        backdrop_colour = G.C.SUITS[v[1].suit],
                        align = 'cm',
                        offset = {x = -20/2 + 20/screen_w * t_x(v[1].body:getX()), y = -11.5/2 + 11.5/screen_h * t_y(v[1].body:getY())},
                        silent = true
                    })
                    play_sound('chips1', math.random()*0.2 + 0.9, 1)
                    G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips + G.GAME.hands.suika_five_flush.chips
                    G.GAME.current_round.current_hand.chip_text = tostring(G.GAME.current_round.current_hand.chips)
                    G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult + G.GAME.hands.suika_five_flush.mult
                    G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
                    G.GAME.hands.suika_five_flush.played = G.GAME.hands.suika_five_flush.played + 1    
                    for i=1,#v do
                        v[i].flush_size = 0
                    end
                    return true
                end
            }))
        elseif #v >= 10 - has_ff and #v < 15 - has_ff then
            delay(1)
            SuikaLatro.triggered_combos['suika_ten_flush'] = SuikaLatro.triggered_combos['suika_ten_flush'] and SuikaLatro.triggered_combos['suika_ten_flush'] + 1 or 1
            SuikaLatro.triggered_combos['suika_five_flush'] = SuikaLatro.triggered_combos['suika_five_flush'] and SuikaLatro.triggered_combos['suika_five_flush'] + 1 or 1
            lowball = false
            G.E_MANAGER:add_event(Event({
                func = function()
                    attention_text({
                        text = "10-Flush!",
                        scale = 1,
                        hold = 0.3,
                        major = G.ROOM_ATTACH,
                        backdrop_colour = G.C.SUITS[v[1].suit],
                        align = 'cm',
                        offset = {x = -20/2 + 20/screen_w * t_x(v[1].body:getX()), y = -11.5/2 + 11.5/screen_h * t_y(v[1].body:getY())},
                        silent = true
                    })
                    play_sound('chips1', math.random()*0.2 + 0.9, 1)
                    G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips + G.GAME.hands.suika_ten_flush.chips
                    G.GAME.current_round.current_hand.chip_text = tostring(G.GAME.current_round.current_hand.chips)
                    G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult + G.GAME.hands.suika_ten_flush.mult
                    G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
                    G.GAME.hands.suika_ten_flush.played = G.GAME.hands.suika_ten_flush.played + 1
                    for i=1,#v do
                        v[i].flush_size = 0
                    end
                    return true
                end
            }))
        elseif #v >= 15 - has_ff then
            delay(1)
            SuikaLatro.triggered_combos['suika_mega_flush'] = SuikaLatro.triggered_combos['suika_mega_flush'] and SuikaLatro.triggered_combos['suika_mega_flush'] + 1 or 1
            SuikaLatro.triggered_combos['suika_ten_flush'] = SuikaLatro.triggered_combos['suika_ten_flush'] and SuikaLatro.triggered_combos['suika_ten_flush'] + 1 or 1
            SuikaLatro.triggered_combos['suika_five_flush'] = SuikaLatro.triggered_combos['suika_five_flush'] and SuikaLatro.triggered_combos['suika_five_flush'] + 1 or 1
            lowball = false
            G.E_MANAGER:add_event(Event({
                func = function()
                    attention_text({
                        text = "Mega Flush!",
                        scale = 1.2,
                        hold = 0.3,
                        major = G.ROOM_ATTACH,
                        backdrop_colour = G.C.SUITS[v[1].suit],
                        align = 'cm',
                        offset = {x = -20/2 + 20/screen_w * t_x(v[1].body:getX()), y = -11.5/2 + 11.5/screen_h * t_y(v[1].body:getY())},
                        silent = true
                    })
                    play_sound('chips1', math.random()*0.2 + 0.9, 1)
                    G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips + G.GAME.hands.suika_mega_flush.chips
                    G.GAME.current_round.current_hand.chip_text = tostring(G.GAME.current_round.current_hand.chips)
                    G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult + G.GAME.hands.suika_mega_flush.mult
                    G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
                    G.GAME.hands.suika_mega_flush.played = G.GAME.hands.suika_mega_flush.played + 1
                    for i=1,#v do
                        v[i].flush_size = 0
                    end
                    return true
                end
            }))
        end

    end
    G.E_MANAGER:add_event(Event({
        func = function()
            SuikaLatro.show_flushes = false
            for k,v in pairs(SuikaLatro.flush_groups) do
                for i=1,#v do
                    v[i].flush_size = 0
                end
            end
        return true
        end
    }))
    delay(3)
    G.E_MANAGER:add_event(Event({
        func = function()
            SuikaLatro.do_physics = true
            SuikaLatro.do_merging = true
        return true
        end
    }))
    delay(10)
    --[[while not is_stopped do
        local is_stopped = true
        delay(1)
        for k,v in ipairs(SuikaLatro.balls) do
            local a_x, a_y = v.body:getLinearVelocity()
            local speed = math.sqrt(a_x^2 + a_y^2)
            --print(speed)
            if speed > 0.5 then
                is_stopped = false
            end
        end
    end]]
    G.E_MANAGER:add_event(Event({
        func = function()
            SuikaLatro.do_merging = false
            for k,v in ipairs(SuikaLatro.balls) do
                v.merges = 0
            end
            if SuikaLatro.lowball then
                play_sound('chips1', math.random()*0.2 + 0.9, 1)
                SuikaLatro.triggered_combos['suika_lowball'] = SuikaLatro.triggered_combos['suika_lowball'] and SuikaLatro.triggered_combos['suika_lowball'] + 1 or 1
                G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips + G.GAME.hands.suika_lowball.chips
                G.GAME.current_round.current_hand.chip_text = tostring(G.GAME.current_round.current_hand.chips)
                G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult + G.GAME.hands.suika_lowball.mult
                G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
                G.GAME.hands.suika_lowball.played = G.GAME.hands.suika_lowball.played + 1
            end
        return true
        end
    }))
    delay(1)
    G.E_MANAGER:add_event(Event({
        func = function()
            for k,v in ipairs(SuikaLatro.balls) do
                if v.enhancement == 'm_steel' then
                    delay(1)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SuikaLatro.f.enhancement_message(v.body:getX(), v.body:getY(), v.enhancement)
                        return true
                        end
                    }))
                end
            end
            return true
        end
    }))
    delay(2)
    G.E_MANAGER:add_event(Event({
        func = function()
            --G.GAME.current_round.current_hand.chip_total = G.GAME.current_round.current_hand.mult * G.GAME.current_round.current_hand.chips
            --G.GAME.current_round.current_hand.chip_total_text = G.GAME.current_round.current_hand.mult * G.GAME.current_round.current_hand.chips
            return true
        end
    }))
    delay(1)
    G.E_MANAGER:add_event(Event({
        func = function()
            --play_sound('chips2')
            --G.GAME.chips = G.GAME.chips + G.GAME.current_round.current_hand.chip_total
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()

            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.FUNCS.evaluate_play()
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.GAME.hands_played = G.GAME.hands_played + 1
                    G.GAME.current_round.hands_played = G.GAME.current_round.hands_played + 1
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE_COMPLETE = false
                    SuikaLatro.show_flushes = true
                    return true
                end
            }))
            return true
        end)
    }))
end