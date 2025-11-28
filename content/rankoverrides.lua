for _, v in ipairs({ 2, 3, 4, 5, 6, 7, 8, 9, 10 }) do
    SMODS.Rank:take_ownership(v..'',
        {
        nominal = (2^v)/2
        },
        true
    )
end

for _, v in ipairs({ 'Jack', 'Queen', 'King' }) do
    SMODS.Rank:take_ownership(v..'',
        {
        nominal = (2^10)/2
        },
        true
    )
end

SMODS.Rank:take_ownership('Ace',
    {
    nominal = (2^11)/2
    },
    true
)

SMODS.Enhancement:take_ownership('m_stone',
    {
    config = {bonus = 2}
    },
    true
)