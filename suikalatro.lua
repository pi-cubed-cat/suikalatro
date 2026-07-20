--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- DEFINE A WHOLE LOTTA BULLSHIT
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

love.physics.setMeter(64)
SuikaLatro = {
    world = love.physics.newWorld(0, 9.81*64, true),
    world_T = {x = 0, y = 15, w = 7.000, h = 6.195},
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
    bounciness = 0.1,
    next_ball = nil,
    indicator = {
        x = 0,
        y = -500
    },
    drop_wait_time = 0,
    do_physics = true,
    do_merging = false,
    cut_high_ranks = true,
    f = {}, --functions
    flush_groups = {},
    show_flushes = true,
    lowball = true,
    poker_combos = {
        five_flush = {chips = 40, mult = 4, chips_mod = 25, mult_mod = 2},
        ten_flush = {chips = 80, mult = 7, chips_mod = 35, mult_mod = 3},
        mega_flush = {chips = 150, mult = 15, chips_mod = 50, mult_mod = 5},
        merge_1 = {chips = 5, mult = 1, chips_mod = 0, mult_mod = 1},
        merge_2 = {chips = 5, mult = 2, chips_mod = 5, mult_mod = 2},
        merge_3 = {chips = 10, mult = 2, chips_mod = 10, mult_mod = 2},
        merge_4 = {chips = 10, mult = 3, chips_mod = 15, mult_mod = 3},
        combo_breaker = {chips = 20, mult = 5, chips_mod = 20, mult_mod = 3},
        lowball = {chips = 2, mult = 1, chips_mod = 25, mult_mod = 4},
    },
    triggered_combos = {},
    scoring_suits = {
        ['Hearts'] = 0,
        ['Diamonds'] = 0,
        ['Spades'] = 0,
        ['Clubs'] = 0
    },
    retrig = {},
    play_wait_time = 0,
}

-- 10X blind ante
local get_blind_amount_ref = get_blind_amount
function get_blind_amount(ante)
    return get_blind_amount_ref(ante) * 10
end

assert(SMODS.load_file("content/pokercombos.lua"))()
assert(SMODS.load_file("content/jokers.lua"))()
assert(SMODS.load_file("content/tarots_spectrals_seals.lua"))()
assert(SMODS.load_file("content/blinds.lua"))()
assert(SMODS.load_file("content/vouchers.lua"))()
assert(SMODS.load_file("content/decks.lua"))()
assert(SMODS.load_file("content/boosters.lua"))()
assert(SMODS.load_file("content/modicon.lua"))()
assert(SMODS.load_file("content/main_menu.lua"))()
assert(SMODS.load_file("content/tutorial.lua"))()
assert(SMODS.load_file("content/config_menu.lua"))()

assert(SMODS.load_file("utils/rankoverrides.lua"))()
assert(SMODS.load_file("utils/particles.lua"))()
assert(SMODS.load_file("utils/poker_combo_utils.lua"))()
assert(SMODS.load_file("utils/ball_utils.lua"))()

assert(SMODS.load_file("init/ball_front_loading.lua"))()
assert(SMODS.load_file("init/static_objects_definitions.lua"))()
assert(SMODS.load_file("init/ball.lua"))()
assert(SMODS.load_file("init/saving_loading_enabling.lua"))()
assert(SMODS.load_file("init/collisions.lua"))()
assert(SMODS.load_file("init/ball_scoring.lua"))()
assert(SMODS.load_file("init/update.lua"))()
assert(SMODS.load_file("init/ball_dropping.lua"))()
assert(SMODS.load_file("init/draw.lua"))()
assert(SMODS.load_file("init/rewrite_evaluate_play.lua"))()

if next(SMODS.find_mod("Multiplayer")) then
    assert(SMODS.load_file("compat/multiplayer.lua"))()
end

SuikaLatro.world:setCallbacks(beginContact, endContact)