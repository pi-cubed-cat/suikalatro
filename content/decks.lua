SMODS.Back:take_ownership( 'abandoned', {
    apply = function(self, back)
        G.GAME.starting_params.no_6 = true
    end,
}, false)

SMODS.Back:take_ownership( 'erratic', {}, false)

SMODS.Back:take_ownership( 'checkered', {}, false)