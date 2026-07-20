--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- PIXEL TO GAME UNITS TRANSFORM FUNCTIONS
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

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

local function poly_to_pixels(x1, y1, x2, y2, x3, y3, x4, y4)
    return t_x(x1), t_y(y1), t_x(x2), t_y(y2), t_x(x3), t_y(y3), t_x(x4), t_y(y4)
end

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- DRAWING
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

local stencil_x = 0
local stencil_y = 0
local stencil_size = 1

local function stencil_func()
    love.graphics.circle("fill", stencil_x, stencil_y, t_r(stencil_size))
end

function SuikaLatro.f.draw_ball(ball, x_pos, y_pos, size, id, suit, front, seal, edition, debuff)
    if type(size) == 'string' then --flipped cards -> hidden nextball
        local x, y = p_to_pixels(x_pos, y_pos)
        love.graphics.setColor(1, 1, 1, 0.5) --indicator
        love.graphics.rectangle("fill", x-t_r(40 + 10*math.sin(love.timer.getTime())), y, 2*t_r(40 + 10*math.sin(love.timer.getTime())), t_y(SuikaLatro.box.height)+t_r(40 + 10*math.sin(love.timer.getTime())))
        
        love.graphics.setColor(1, 1, 1, SuikaLatro.drop_wait_time > 0.8 and 1 or 0.5) 
        love.graphics.circle("fill", x, y, t_r(40 + 10*math.sin(love.timer.getTime())))
        love.graphics.setColor(darken({1, 1, 1}, 0.5)) 
        love.graphics.printf('?', x, y, 200, "center", 0, t_r(40 + 10*math.sin(love.timer.getTime()))/24, t_r(40 + 10*math.sin(love.timer.getTime()))/24, 99, 10.5)
    else
        -- main ball body
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
            love.graphics.setColor(darken(lighten(G.C.SUITS[suit], ball.flush_size >= 5 - SuikaLatro.ff_count and 0.70 or 1), debuff and 0.3 or 0))
        else --indicator (won't be in a flush, and can be trans)
            love.graphics.setColor(darken({1, 1, 1}, debuff and 0.3 or 0), SuikaLatro.drop_wait_time > 0.8 and 1 or 0.5)
        end
        love.graphics.circle("fill", x, y, t_r(size - 2))
        love.graphics.setColor(1, 1, 1, front == 'c_base' and 0.25 or front == 'm_mult' and 0.4 or front == 'm_wild' and 0.6 or 0.75)
        if front == 'm_stone' then
            love.graphics.draw(suika_fronts.m_stone, x, y, angle, t_r(size/24), t_r(size/24), 18, 18)
        else
            love.graphics.draw(suika_fronts[suit][front], x, y, angle, t_r(size/24), t_r(size/24), 18, 18)
        end

        -- editions
        if edition and suika_editions[edition] then
            love.graphics.setColor(1, 1, 1)
            local old_blend_mode = love.graphics.getBlendMode()
            stencil_x, stencil_y, stencil_size = x, y, size
            love.graphics.stencil(stencil_func, "replace", 1)
            love.graphics.setStencilTest("greater", 0)
            love.graphics.setBlendMode("multiply", "premultiplied")
            love.graphics.draw(suika_editions[edition], x, y, 0, t_r(size/100), t_r(size/100), 136.5, 183)
            love.graphics.setBlendMode(old_blend_mode)
            love.graphics.setStencilTest()
        end

        -- seals
        if seal and suika_seals[seal] then
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(suika_seals[seal], x, y, angle, t_r(size/40), t_r(size/40), 46, 46)
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

        -- 'debuffed' cross
        if debuff then
            love.graphics.setColor(1, 1, 1, 0.4)
            love.graphics.draw(suika_debuff_shader, x, y, 0, t_r(size/26), t_r(size/26), 18, 18)
        end
    end

end

function SuikaLatro.f.draw()
    SuikaLatro.screen_w, SuikaLatro.screen_h = love.window.getMode()
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

    if #SMODS.find_card('j_half') > 0 then
        love.graphics.setColor(G.C.GREY, 0.5) --half-boundary line
        love.graphics.polygon("fill", poly_to_pixels(half_boundary.body:getWorldPoints(half_boundary.shape:getPoints())))
    end

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
        SuikaLatro.f.draw_ball(SuikaLatro.next_ball, SuikaLatro.indicator.x, SuikaLatro.indicator.y, get_size(SuikaLatro.next_ball.base.id, next_is_stone), SuikaLatro.next_ball.base.id, SuikaLatro.next_ball.base.suit, SuikaLatro.next_ball.config.center.key, SuikaLatro.next_ball.seal, (SuikaLatro.next_ball.edition and SuikaLatro.next_ball.edition.key or nil), SuikaLatro.next_ball.debuff)
    end
    
    SuikaLatro.f.particles_draw()

    SuikaLatro.ff_count = #SMODS.find_card('j_four_fingers') or 0
    for k, v in ipairs(SuikaLatro.balls) do --fallen balls
        SuikaLatro.f.draw_ball(v, v.body:getX(), v.body:getY(), v.size, v.id, v.suit, v.enhancement, v.seal, v.edition, v.debuff)
    end
    
end