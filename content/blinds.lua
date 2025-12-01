SMODS.Blind:take_ownership('ox',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('arm',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('club',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('psychic',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('goad',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('window',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('eye',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('mouth',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('plant',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('serpent',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('head',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('pillar',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('tooth',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('flint',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('mark',
    {
    boss = { min = 6 },
    },
    true
)

SMODS.Blind:take_ownership('final_leaf',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Atlas({
    key = 'suikablind',
    path = 'blinds.png',
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
    px = 34,
    py = 34
})

SMODS.Blind {
        key = "melon",
        loc_txt = {
            name = 'The Melon',
            text = {
                "Bigger balls",
            }
        },
        dollars = 5,
        mult = 2,
        pos = { x = 0, y = 0 },
        atlas = 'suikablind',
        boss = { min = 1 },
        boss_colour = HEX("50bf7c"),
        calculate = function(self, blind, context)
            if context.setting_blind then
                SuikaLatro.ball_sizefactor = 15
            end
        end,
        disable = function(self)
            SuikaLatro.ball_sizefactor = 12
        end,
        defeat = function(self)
            SuikaLatro.ball_sizefactor = 12
        end
    }