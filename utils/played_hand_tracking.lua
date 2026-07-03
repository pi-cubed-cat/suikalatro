function SuikaLatro.set_hand_usage(hand)
    local hand_label = hand
    hand = hand:gsub("%s+", "")
    if G.GAME.hand_usage[hand] then
        G.GAME.hand_usage[hand].count = G.GAME.hand_usage[hand].count + 1
    else
        G.GAME.hand_usage[hand] = {count = 1, order = hand_label}
    end
end