function SuikaLatro.is_flint_active()
    if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind.key == 'bl_flint'
    and not G.GAME.blind.disabled then
        G.GAME.blind:juice_up()
        play_sound('cancel', 1, 0.5)
        play_sound('highlight1', 1, 0.1)
        return 0.5
    else 
        return 1
    end
end