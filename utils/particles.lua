-- Transform pixels into game units (code from the Hot Potato mod's Plinko minigame) 
function to_game_units(val)
    return val / (G.TILESCALE*G.TILESIZE)
end

function to_pixels(val)
    return val * (G.TILESCALE*G.TILESIZE)
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

local function t_r(r)
    return to_pixels(r / SuikaLatro.world_height * SuikaLatro.world_T.h)
end

local function p_to_pixels(x, y)
    return t_x(x), t_y(y)
end


SuikaLatro.particles = {}
function SuikaLatro.f.explode_particles(x, y, number, colours, size)
    for i = 1, number do
        local direction = 2*math.pi*math.random()
        local vel_direction = 2*math.pi*math.random()
        local speed = 8 + 6*math.random()
        local rand_col = pseudorandom_element(colours) or G.C.RED
        table.insert(SuikaLatro.particles, { 
            colour = lighten(rand_col, 0.5*math.random()), 
            pos = {x = x, y = y}, 
            vel = {x = speed*math.cos(vel_direction), y = speed*math.sin(vel_direction)},
            scale = (size or 1)*(math.random() + 1), 
            direction = direction,
            spinning_speed = 2*math.pi*(math.random() - 0.5),
        })
    end
end

function SuikaLatro.f.particles_update(dt)
    SuikaLatro.f.particles_move(dt)
end

function SuikaLatro.f.particles_move(dt)
    local y_accel = 15
    for k, v in ipairs(SuikaLatro.particles) do
        v.pos.x = v.pos.x + to_pixels(v.vel.x * dt)
        v.pos.y = v.pos.y + to_pixels(v.vel.y * dt)
        v.direction = v.direction + v.spinning_speed * dt
        v.vel.y = v.vel.y + y_accel * dt
        v.scale = v.scale - v.scale * dt
        if v.pos.y > SuikaLatro.screen_h * 1.1 then
            table.remove(SuikaLatro.particles, k)
        end
        if v.scale <= 0 then
            table.remove(SuikaLatro.particles, k)
        end
    end
end

function SuikaLatro.f.particles_draw()
    for k, v in ipairs(SuikaLatro.particles) do
        local scale = to_pixels(v.scale)
        love.graphics.push()
        love.graphics.setColor(v.colour[1], v.colour[2], v.colour[3], 1)                
        love.graphics.translate(scale/2 + v.pos.x, scale/2 + v.pos.y)
        love.graphics.rotate(v.direction)
        
        love.graphics.rectangle('fill', -scale/2, -scale/2, scale, scale) -- origin in the middle
        love.graphics.pop()
    end
end