--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- STATIC PHYSICS OBJECTS
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

SuikaLatro.screen_w, SuikaLatro.screen_h = love.window.getMode()

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

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- BOX BACKDROP
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

function G.UIDEF.suika_main()
    return {n = G.UIT.ROOT, config = {r = 0.1, minw = 7, minh = 10, align = "tm", padding = 0.2, colour = G.C.UI.TRANSPARENT_DARK }, nodes = {
    }}
end

function SuikaLatro.f.drawBG()
    SuikaLatro.BG = UIBox{
        definition = G.UIDEF.suika_main(),
        config = {align='cm', offset = {x=0,y=G.ROOM.T.y + SuikaLatro.world_T.y - 0.5}, major = G.ROOM_ATTACH, bond = 'Weak'}
    }
    SuikaLatro.BG:recalculate()
end