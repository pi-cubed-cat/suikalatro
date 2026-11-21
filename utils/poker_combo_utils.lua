function SuikaLatro.set_hand_usage(hand)
    local hand_label = hand
    hand = hand:gsub("%s+", "")
    if G.GAME.hand_usage[hand] then
        G.GAME.hand_usage[hand].count = G.GAME.hand_usage[hand].count + 1
    else
        G.GAME.hand_usage[hand] = {count = 1, order = hand_label}
    end
end

function SuikaLatro.f.score_poker_combo(poker_combo, contains_only)
    SuikaLatro.triggered_combos[poker_combo] = SuikaLatro.triggered_combos[poker_combo] and SuikaLatro.triggered_combos[poker_combo] + 1 or 1
    if not contains_only then
        local flint = SuikaLatro.is_flint_active()
        update_hand_text({immediate = true, nopulse = true, delay = 0}, {handname = localize(poker_combo, 'poker_hands'), level=G.GAME.hands[poker_combo].level})
        SuikaLatro.f.score('+chips', G.GAME.hands[poker_combo].chips * flint)
        SuikaLatro.f.score('+mult', G.GAME.hands[poker_combo].mult * flint)
        SuikaLatro.set_hand_usage(poker_combo)
        G.GAME.hands[poker_combo].played = G.GAME.hands[poker_combo].played + 1  
        G.GAME.last_scoring_combo = poker_combo
        
        if poker_combo ~= 'suika_lowball' then
            SuikaLatro.lowball = false
        end
    end
end

local new_round_ref = new_round
function new_round()
    for k, v in pairs(G.GAME.hands) do 
        v.been_last_this_round = nil
    end
    new_round_ref()
end