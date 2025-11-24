local filesystem = NFS or love.filesystem
local suika_mod_path = SMODS.current_mod

local function load_the_suika(img)
    local full_path = (suika_mod_path.path..'assets/suiticons/'..img)
    local file_data = assert(NFS.newFileData(full_path))
    local tempimagedata = assert(love.image.newImageData(file_data))
    return (assert(love.graphics.newImage(tempimagedata)))
end

love.graphics.setDefaultFilter('nearest', 'nearest')
suikas = {
    Spades = load_the_suika("spade.png"),
    Hearts = load_the_suika("heart.png"),
    Diamonds = load_the_suika("diamond.png"),
    Clubs = load_the_suika("club.png"),
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
    },
    balls = {}, --dynamic objects
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
        five_flush = {chips = 20, mult = 2},
        ten_flush = {chips = 70, mult = 7},
        mega_flush = {chips = 150, mult = 15},
        merge_1 = {chips = 5, mult = 1},
        merge_2 = {chips = 5, mult = 2},
        merge_3 = {chips = 10, mult = 2},
        merge_4 = {chips = 10, mult = 3},
        combo_breaker = {chips = 20, mult = 5},
        lowball = {chips = 2, mult = 1},
    },
}


local screen_w, screen_h = love.window.getMode()

local suikaground = SuikaLatro.walls.ground
suikaground.body = love.physics.newBody(SuikaLatro.world, 0, SuikaLatro.box.height/2, "static") --shape anchors to the body from its center
suikaground.shape = love.physics.newRectangleShape(SuikaLatro.box.width, 20) --make a rectangle with a width of arg1 and a height of arg2
suikaground.fixture = love.physics.newFixture(suikaground.body, suikaground.shape) --attach shape to body

local suikaleft = SuikaLatro.walls.leftwall
suikaleft.body = love.physics.newBody(SuikaLatro.world, -1 * SuikaLatro.box.width/2, 0, "static")
suikaleft.shape = love.physics.newRectangleShape(20, SuikaLatro.box.height)
suikaleft.fixture = love.physics.newFixture(suikaleft.body, suikaleft.shape)

local suikaright = SuikaLatro.walls.rightwall
suikaright.body = love.physics.newBody(SuikaLatro.world, SuikaLatro.box.width/2, 0, "static")
suikaright.shape = love.physics.newRectangleShape(20, SuikaLatro.box.height)
suikaright.fixture = love.physics.newFixture(suikaright.body, suikaright.shape)

boundary = {}
local boundary_width = 5
boundary.body = love.physics.newBody(SuikaLatro.world, 0, -1*SuikaLatro.box.height/2 + boundary_width/2, "static")
boundary.shape = love.physics.newRectangleShape(SuikaLatro.box.width, boundary_width)

-- Transform pixels into game units: 
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

function get_size(input)
    return input * 10
end

function Ball:init(x,y,fixed_properties, rank_delta, combo)
    self.body = love.physics.newBody(SuikaLatro.world, x, y, "dynamic")
    self.flush_size = 0
    if not fixed_properties then
        --self.rank = SuikaLatro.next_ball.base.value
        self.id = SuikaLatro.next_ball.base.id
        self.suit = SuikaLatro.next_ball.base.suit
        self.size = get_size(SuikaLatro.next_ball.base.id)
        self.enhancement = SuikaLatro.next_ball.config.center.key
        self.edition = SuikaLatro.next_ball.edition and SuikaLatro.next_ball.edition.key or nil
        self.merges = 0
    else
        rank_delta = rank_delta or 0
        --self.rank = fixed_properties.rank + rank_delta
        self.id = fixed_properties.id + rank_delta
        self.suit = fixed_properties.suit
        self.size = get_size(fixed_properties.id + rank_delta)
        self.enhancement = fixed_properties.enhancement
        self.edition = fixed_properties.edition
        self.merges = combo or 0
    end
    self.shape = love.physics.newCircleShape(self.size)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setRestitution(0.1)
    self.fixture:setUserData(self)
    self.merge_target = nil
    self.remove = false
end

function SuikaLatro.f.enable_suika()
    SuikaLatro.f.drawBG()
    show_suika = true
end

function SuikaLatro.f.disable_suika()
    SuikaLatro.f.drawBG(true)
    show_suika = false
end

function SuikaLatro.f.reset_suika()
    for i = #SuikaLatro.balls, 1, -1 do
        SuikaLatro.balls[i].body:destroy()
        table.remove(SuikaLatro.balls, i)
    end
end

local function ballsAreTouching(a, b)
    if a.suit ~= b.suit then return false end -- flushes don't occur with different suits

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

    for i, ball in ipairs(balls) do
        if not visited[ball] then
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
    if objA and objB and objA.id and objB.id and objA.id == objB.id then
        if not objA.merge_target and not objB.merge_target and not objA.dont_prod then
            objA.merge_target = objB
            objB.merge_target = objA
            objB.dont_prod = true
        end --put gameover function here
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
        end
    end
end

--[[function endContact(a, b, coll)
    local x, y = coll:getNormal()
    local objA = a:getUserData()
    local objB = b:getUserData()
    if objA and objB and objA.suit and objB.suit and objA.suit == objB.suit then
        print("no longer touching :(")
    end
end]]

SuikaLatro.world:setCallbacks(beginContact, endContact)

function SuikaLatro.f.update(dt)
    SuikaLatro.drop_wait_time = SuikaLatro.drop_wait_time + dt
    
    if SuikaLatro.do_physics then
        SuikaLatro.world:update(dt)
        SuikaLatro.f.find_flush_groups()
    end
    --if not G.STATE == G.STATES.GAME_OVER then SuikaLatro.world:update(dt) end
    local size_offset = SuikaLatro.next_ball and get_size(SuikaLatro.next_ball.base.id) or 10
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
                        table.insert(SuikaLatro.balls, Ball(v.body:getX(), v.body:getY(), selected_ball > 0.5 and v.merge_target or v, 1, merge_count))
                        
                        attention_text({
                            text = tostring(merge_count.."X"),
                            scale = 0.5 + merge_count/10,
                            hold = 0.3,
                            major = G.ROOM_ATTACH,
                            backdrop_colour = merge_count < 4 and G.C.ORANGE or G.C.RED,
                            align = 'cm',
                            offset = {x = -20/2 + 20/screen_w * t_x(v.body:getX()), y = -11.5/2 + 11.5/screen_h * t_y(v.body:getY())},
                            silent = true
                        })
                        play_sound('multhit1', math.random()*0.2 + 0.7 + 0.1*merge_count, 0.6 + merge_count/20)
                        local combo_chips = 0
                        local combo_mult = 0
                        if merge_count == 1 then
                            combo_chips = SuikaLatro.poker_combos.merge_1.chips
                            combo_mult = SuikaLatro.poker_combos.merge_1.mult
                        elseif merge_count == 2 then
                            combo_chips = SuikaLatro.poker_combos.merge_2.chips
                            combo_mult = SuikaLatro.poker_combos.merge_2.mult
                        elseif merge_count == 3 then
                            combo_chips = SuikaLatro.poker_combos.merge_3.chips
                            combo_mult = SuikaLatro.poker_combos.merge_3.mult
                        elseif merge_count == 4 then
                            combo_chips = SuikaLatro.poker_combos.merge_4.chips
                            combo_mult = SuikaLatro.poker_combos.merge_4.mult
                        elseif merge_count >= 5 then
                            combo_chips = SuikaLatro.poker_combos.combo_breaker.chips
                            combo_mult = SuikaLatro.poker_combos.combo_breaker.mult
                        end
                        G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips + combo_chips + 2^(v.id)
                        G.GAME.current_round.current_hand.chip_text = tostring(G.GAME.current_round.current_hand.chips)
                        G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult + combo_mult
                        G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)

                        v.merge_target.remove = true
                        v.remove = true
                    else
                        v.merge_target.remove = true
                        v.remove = true
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
        local size_offset = SuikaLatro.next_ball and get_size(SuikaLatro.next_ball.base.id) or 10
        if SuikaLatro.walls.leftwall.body:getX() + size_offset + 12 > SuikaLatro.indicator.x then
            SuikaLatro.indicator.x = SuikaLatro.walls.leftwall.body:getX() + size_offset + 12
        elseif SuikaLatro.walls.rightwall.body:getX() - size_offset - 12 < SuikaLatro.indicator.x then
            SuikaLatro.indicator.x = SuikaLatro.walls.rightwall.body:getX() - size_offset - 12
        end
        table.insert(SuikaLatro.balls, Ball(SuikaLatro.indicator.x, SuikaLatro.indicator.y))
        SuikaLatro.indicator.x = SuikaLatro.indicator.x + (math.random() + 0.5) / 50 --makes stacking harder
        G.FUNCS.discard_cards_from_highlighted(nil, true)
        G.FUNCS.draw_from_deck_to_hand(1)
        if #G.deck.cards == 0 then
            G.FUNCS.draw_from_deck_to_hand(1)
            G.FUNCS.draw_from_discard_to_deck()
        end
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

function SuikaLatro.f.draw()
    screen_w, screen_h = love.window.getMode()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    if SuikaLatro.next_ball then
        local i_x, i_y = p_to_pixels(SuikaLatro.indicator.x, SuikaLatro.indicator.y)
        love.graphics.setColor(1, 1, 1, 0.5) --indicator
        love.graphics.rectangle("fill", i_x-t_r((get_size(SuikaLatro.next_ball.base.id))), i_y-t_r((get_size(SuikaLatro.next_ball.base.id))), 2*t_r((get_size(SuikaLatro.next_ball.base.id))), t_y(SuikaLatro.box.height)+t_r((get_size(SuikaLatro.next_ball.base.id))))
    end

    love.graphics.setColor(G.C.RED) --boundary line
    love.graphics.polygon("fill", poly_to_pixels(boundary.body:getWorldPoints(boundary.shape:getPoints())))

    love.graphics.setColor(G.C.BLACK) --grounds
    for k,v in pairs(SuikaLatro.walls) do
        love.graphics.polygon("fill", poly_to_pixels(v.body:getWorldPoints(v.shape:getPoints())))
    end

    if not SuikaLatro.next_ball then --blank indicator
        love.graphics.setColor(1, 1, 1) 
        local x, y = p_to_pixels(SuikaLatro.indicator.x, SuikaLatro.indicator.y)
        love.graphics.circle("fill", x, y, t_r(10))
    else 
        local n_r = G.C.SUITS[SuikaLatro.next_ball.base.suit][1] --filled indicator
        local n_g = G.C.SUITS[SuikaLatro.next_ball.base.suit][2]
        local n_b = G.C.SUITS[SuikaLatro.next_ball.base.suit][3]
        local x, y = p_to_pixels(SuikaLatro.indicator.x, SuikaLatro.indicator.y)
        love.graphics.setColor(n_r, n_g, n_b, SuikaLatro.drop_wait_time > 0.8 and 1 or 0.5)
        love.graphics.circle("fill", x, y, t_r(get_size(SuikaLatro.next_ball.base.id)+1))
        love.graphics.setColor(1, 1, 1, SuikaLatro.drop_wait_time > 0.8 and 1 or 0.5)
        love.graphics.circle("fill", x, y, t_r((get_size(SuikaLatro.next_ball.base.id))-2))
        love.graphics.setColor(n_r, n_g, n_b, SuikaLatro.drop_wait_time > 0.8 and 0.25 or 0.1)
        love.graphics.draw(suikas[SuikaLatro.next_ball.base.suit], x, y, 0, t_r(get_size(SuikaLatro.next_ball.base.id)/24), t_r(get_size(SuikaLatro.next_ball.base.id)/24), 18, 18)
        love.graphics.setColor(n_r, n_g, n_b, SuikaLatro.drop_wait_time > 0.8 and 1 or 0.5)
        love.graphics.printf(tostring(SuikaLatro.next_ball.base.id), x, y, 200, "center", 0, t_r(SuikaLatro.next_ball.base.id/2), t_r(SuikaLatro.next_ball.base.id/2), 99, 10.5)
    end
    
    for k, v in ipairs(SuikaLatro.balls) do --fallen balls
        if v.id then
            local r_r = G.C.SUITS[v.suit][1]
            local r_g = G.C.SUITS[v.suit][2]
            local r_b = G.C.SUITS[v.suit][3]
            local x, y = p_to_pixels(v.body:getX(), v.body:getY())
            local angle = v.body:getAngle()
            love.graphics.setColor(r_r, r_g, r_b)
            love.graphics.circle("fill", x, y, t_r(v.size + 1))
            love.graphics.setColor(lighten(G.C.SUITS[v.suit], v.flush_size >= 5 and 0.70 or 1))
            love.graphics.circle("fill", x, y, t_r(v.size - 2))
            love.graphics.setColor(r_r, r_g, r_b, 0.25)
            love.graphics.draw(suikas[v.suit], x, y, angle, t_r(v.size/24), t_r(v.size/24), 18, 18)
            love.graphics.setColor(r_r, r_g, r_b)
            love.graphics.printf(tostring(v.id), x, y, 200, "center", 0, t_r(v.id/2), t_r(v.id/2), 99, 10.5)
        end
    end
    
end

function G.UIDEF.suika_main()
    return {n = G.UIT.ROOT, config = {r = 0.1, minw = 7, minh = 10, align = "tm", padding = 0.2, colour = G.C.UI.TRANSPARENT_DARK }, nodes = {
        --[[{n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, }, nodes={
                
            }
        },]]
    }}
end

function SuikaLatro.f.drawBG(remove)
    local menu = nil
    if not remove then
        menu = UIBox{
            definition = G.UIDEF.suika_main(),
            config = {align='cm', offset = {x=0,y=G.ROOM.T.y + 2}, major = G.ROOM_ATTACH, bond = 'Weak'}
        }
    end
    return menu
end

G.FUNCS.suika_can_play = function(e)
    if SuikaLatro.balls and #SuikaLatro.balls > 0 then 
        e.config.colour = G.C.GREEN
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
    G.GAME.blind.triggered = false
    G.CONTROLLER.interrupt.focus = true

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
    for k,v in pairs(SuikaLatro.flush_groups) do

        if #v >= 5 then
            delay(1)
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
                    local flush_chips = SuikaLatro.poker_combos.five_flush.chips
                    local flush_mult = SuikaLatro.poker_combos.five_flush.mult
                    G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips + flush_chips
                    G.GAME.current_round.current_hand.chip_text = G.GAME.current_round.current_hand.chip_text + flush_chips
                    G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult + flush_mult
                    G.GAME.current_round.current_hand.mult_text = G.GAME.current_round.current_hand.mult_text + flush_mult
                            
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
        return true
        end
    }))
    if SuikaLatro.lowball then
        local low_chips = SuikaLatro.poker_combos.lowball.chips
        local low_mult = SuikaLatro.poker_combos.lowball.mult
        play_sound('chips1', math.random()*0.2 + 0.9, 1)
        G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips + low_chips
        G.GAME.current_round.current_hand.chip_text = G.GAME.current_round.current_hand.chip_text + low_chips
        G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult + low_mult
        G.GAME.current_round.current_hand.mult_text = G.GAME.current_round.current_hand.mult_text + low_mult
    end

    delay(2)
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.current_round.current_hand.chip_total = G.GAME.current_round.current_hand.mult * G.GAME.current_round.current_hand.chips
            G.GAME.current_round.current_hand.chip_total_text = G.GAME.current_round.current_hand.mult * G.GAME.current_round.current_hand.chips
            return true
        end
    }))
    delay(1)
    G.E_MANAGER:add_event(Event({
        func = function()
            play_sound('chips2')
            G.GAME.chips = G.GAME.chips + G.GAME.current_round.current_hand.chip_total
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()

            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    --G.FUNCS.evaluate_play()
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
                    G.FUNCS.chip_UI_set()
                    G.GAME.current_round.current_hand.chip_total = 0
                    G.GAME.current_round.current_hand.chips = 0
                    G.GAME.current_round.current_hand.chip_text = 0
                    G.GAME.current_round.current_hand.mult = 0
                    G.GAME.current_round.current_hand.mult_text = 0
                    return true
                end
            }))
            return true
        end)
    }))
end