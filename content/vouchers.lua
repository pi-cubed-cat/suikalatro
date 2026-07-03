SMODS.Voucher:take_ownership('observatory',
    {
        config = { extra = { Xmult = 1.5 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.Xmult } }
        end,
        calculate = function(self, card, context)
            if context.other_consumeable and context.other_consumeable.ability.set == 'Planet' then
                return {
                    x_mult = card.ability.extra.Xmult,
                    message_card = context.other_consumeable
                }
            end
        end,
    }, true
)