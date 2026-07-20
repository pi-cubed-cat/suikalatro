--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- LOAD BALL FRONTS (SUITS, ENHANCEMENTS, AND SEALS)
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

local filesystem = NFS or love.filesystem
local suika_mod_path = SMODS.current_mod

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

suika_editions = {
    e_foil = load_the_suika("discount_shaders/foil.png"),
    e_holo = load_the_suika("discount_shaders/holo.png"),
    e_polychrome = load_the_suika("discount_shaders/polychrome.png"),
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

suika_debuff_shader = load_the_suika("discount_shaders/debuff.png")