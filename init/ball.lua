--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- BALL INIT
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

Ball = Object:extend()

function Ball:init(x,y,fixed_properties, rank_delta, combo, fix_enhancement, fix_edition, fix_seal, fix_size, perma_bonuses, debuffed)
    self.body = love.physics.newBody(SuikaLatro.world, x, y, "dynamic")
    self.flush_size = 0
    if not fixed_properties then -- next ball
        --self.rank = SuikaLatro.next_ball.base.value
        self.id = SuikaLatro.next_ball.base.id
        self.suit = SuikaLatro.next_ball.base.suit
        self.enhancement = SuikaLatro.next_ball.config.center.key
        self.edition = SuikaLatro.next_ball.edition and SuikaLatro.next_ball.edition.key or nil
        self.seal = SuikaLatro.next_ball.seal
        self.size = get_size(self.id, SuikaLatro.next_ball.config.center.key == 'm_stone')
        self.merges = 0
        self.debuff = SuikaLatro.next_ball.debuff
        
        self.perma_bonuses = {}
        local perma_bonus_all = {
            'perma_bonus',      -- permanent chips, from vanilla
            'perma_mult',
            'perma_x_chips',
            'perma_x_mult',

            'perma_h_chips',
            'perma_h_mult',
            'perma_h_x_chips',
            'perma_h_x_mult',

            'perma_p_dollars',  -- money on scoring
            'perma_h_dollars',  -- money on held at end of round (like gold cards)

            'perma_repetitions', -- retriggers in any context
        }
        for k,v in pairs(perma_bonus_all) do
            if SuikaLatro.next_ball.ability[v] then
                self.perma_bonuses[v] = SuikaLatro.next_ball.ability[v]
            end
        end
    else -- after merged balls
        rank_delta = rank_delta or 0
        --self.rank = fixed_properties.rank + rank_delta
        self.id = fixed_properties.id + rank_delta > 14 and 2 or fixed_properties.id + rank_delta or 2
        self.suit = fixed_properties.suit or pseudorandom_element({'Spades', 'Clubs', 'Diamonds', 'Hearts'})
        self.enhancement = fix_enhancement or fixed_properties.enhancement or 'c_base'
        self.edition = fix_edition or fixed_properties.edition or nil
        self.seal = fix_seal or fixed_properties.seal or nil
        self.size = get_size(self.id, self.enhancement == 'm_stone')
        self.merges = combo or 0
        self.perma_bonuses = {}
        self.debuff = debuffed or fixed_properties.debuff or false
        if perma_bonuses then
            for k,v in pairs(perma_bonuses) do
                self.perma_bonuses[k] = v
            end
        end
    end
    
    self.canvas = love.graphics.newCanvas(self.size*2, self.size*2)
    self.shape = love.physics.newCircleShape(self.size)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setRestitution(SuikaLatro.bounciness)
    if self.enhancement == 'm_steel' and not self.debuff then
        self.fixture:setDensity(100)
        self.body:resetMassData()
    end
    self.fixture:setUserData(self)
    self.merge_target = nil
    self.remove = false
end