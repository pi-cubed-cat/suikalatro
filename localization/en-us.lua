return {
    descriptions = {
        Back={},
        Blind={},
        Edition={},
        Enhanced={
            m_bonus = {
                text={
                    "When merging,",
                },
            },
            m_mult = {
                text={
                    "{C:mult}#1#{} Mult",
                    "when merging",
                },
            },
            m_lucky = {
                text={
                    "When merging,",
                    "{C:green}#1# in #3#{} chance",
                    "for {C:mult}+#2#{} Mult",
                    "{C:green}#1# in #5#{} chance",
                    "to win {C:money}$#4#",
                },
            },
            m_glass={
                text={
                    "{X:mult,C:white} X#1# {} Mult",
                    "{C:green}#2# in #3#{} chance to",
                    "destroy ball on {C:attention}merge{}",
                },
            },
            m_stone = {
                text={
                    "{C:chips}#1#{} Chips",
                    "no rank or suit,",
                    "can merge with",
                    "{C:attention}any rank{},",
                    "is always {C:attention}small{}"
                },
            },
            m_gold={
                text={
                    "{C:money}#1#{} if ball",
                    "is remaining in box",
                    "at end of round",
                },
            },
            m_steel={
                text={
                    "{X:mult,C:white} X#1# {} Mult if",
                    "ball is remaining",
                    "in box,",
                    "{C:attention}Heavy{}"
                },
            },
        },
        Joker={
            j_greedy_joker={
                name="Greedy Joker",
                text={
                    "{C:mult}+#1#{} Mult when",
                    "a {C:diamonds}#2#{} suit",
                    "ball merges",
                },
            },
            j_lusty_joker={
                name="Lusty Joker",
                text={
                    "{C:mult}+#1#{} Mult when",
                    "a {C:hearts}#2#{} suit",
                    "ball merges",
                },
            },
            j_wrathful_joker={
                name="Wrathful Joker",
                text={
                    "{C:mult}+#1#{} Mult when",
                    "a {C:spades}#2#{} suit",
                    "ball merges",
                },
            },
            j_gluttenous_joker={
                name="Gluttonous Joker",
                text={
                    "{C:mult}+#1#{} Mult when",
                    "a {C:clubs}#2#{} suit",
                    "ball merges",
                },
            },
            j_jolly={
                name="Jolly Joker",
                text={
                    "{C:red}+#1#{} Mult if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_zany={
                name="Zany Joker",
                text={
                    "{C:red}+#1#{} Mult if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_mad={
                name="Mad Joker",
                text={
                    "{C:red}+#1#{} Mult if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_crazy={
                name="Crazy Joker",
                text={
                    "{C:red}+#1#{} Mult if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_droll={
                name="Droll Joker",
                text={
                    "{C:red}+#1#{} Mult if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_sly={
                name="Sly Joker",
                text={
                    "{C:chips}+#1#{} Chips if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_wily={
                name="Wily Joker",
                text={
                    "{C:chips}+#1#{} Chips if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_clever={
                name="Clever Joker",
                text={
                    "{C:chips}+#1#{} Chips if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_devious={
                name="Devious Joker",
                text={
                    "{C:chips}+#1#{} Chips if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_crafty={
                name="Crafty Joker",
                text={
                    "{C:chips}+#1#{} Chips if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_half={
                name="Half Joker",
                text={
                    "{C:red}+#1#{} Mult if played",
                    "hand contains no balls",
                    "{C:attention}above halfway{} up the box",
                },
            },
            j_four_fingers={
                name="Four Fingers",
                text={
                    "{C:attention}Flush combos{}",
                    "can be made with",
                    "{C:attention}1 fewer{} ball",
                },
            },
            j_faceless={
                name="Faceless Joker",
                text={
                    "Earn {C:money}$#1#{} if ",
                    "discard contains a",
                    "{C:attention}face card{}",
                },
            },
            j_seance={
                name="Séance",
                text={
                    "If {C:attention}played hand{} contained",
                    "a {C:attention}#1#{}, create a",
                    "random {C:spectral}Spectral{} card",
                    "{C:inactive}(Must have room)",
                },
            },
            j_shortcut={
                name="Shortcut",
                text={
                    "Allows balls to merge",
                    "with the rank {C:attention}1 above{}",
                    "and {C:attention}1 below{}",
                },
            },
            j_lucky_cat = {
                name = "Lucky Cat",
                text = {
                    "This Joker gains {X:mult,C:white} X#1# {} Mult",
                    "every time a {C:attention}Lucky{} ball",
                    "{C:green}successfully{} triggers",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                },
            },
            j_flower_pot={
                name="Flower Pot",
                text={
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand contained a merging",
                    "{C:diamonds}Diamond{} ball, {C:clubs}Club{} ball,",
                    "{C:hearts}Heart{} ball, and {C:spades}Spade{} ball",
                },
            },
            j_duo={
                name="The Duo",
                text={
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_trio={
                name="The Trio",
                text={
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_family={
                name="The Family",
                text={
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_order={
                name="The Order",
                text={
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
            j_tribe={
                name="The Tribe",
                text={
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand contained",
                    "a {C:attention}#2#",
                },
            },
             j_burnt={
                name="Burnt Joker",
                text={
                    "Upgrade the level of",
                    "a random poker combo",
                    "on {C:attention}discard{}",
                },
            },
        },
        Other={
            purple_seal={
                name="Purple Seal",
                text={
                    "Creates 2 {C:tarot}Tarot{} cards",
                    "when {C:attention}discarded",
                    "{C:inactive}(Must have room)",
                },
            },
        },
        Planet={},
        Spectral={},
        Stake={},
        Tag={},
        Tarot={
            c_justice={
                name="Justice",
                text={
                    "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s",
                },
            },
            c_lovers={
                name="The Lovers",
                text={
                    "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s",
                },
            },
            c_devil={
                name="The Devil",
                text={
                    "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s",
                },
            },
            c_chariot={
                name="The Chariot",
                text={
                    "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s",
                },
            },
            c_tower={
                name="The Tower",
                text={
                    "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s",
                },
            },
        },
        Voucher={},
    },
    misc = {
        achievement_descriptions={},
        achievement_names={},
        blind_states={},
        challenge_names={},
        collabs={},
        dictionary={
            b_poker_hands = "Poker Combos",
        },
        high_scores={},
        labels={},
        poker_hand_descriptions={},
        poker_hands={},
        quips={},
        ranks={},
        suits_plural={},
        suits_singular={},
        tutorial={},
        v_dictionary={},
        v_text={},
    },
}