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
        Spectral = {
            c_sigil = {
                text = {
                    "Draw #1# cards to hand,",
                    "then convert all",
                    "cards in hand to a",
                    "single random {C:attention}suit",
                },
            },
            c_ouija = {
                text = {
                    "Draw #1# cards to hand,",
                    "then convert all cards",
                    "in hand to a single",
                    "random {C:attention}rank",
                    "{C:red}-1{} hand size",
                },
            },
        },
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
        tutorial={
            suika_intro1 = {
                "Welcome to {E:1,C:green}Suikalatro{}!",
                "It's time for you",
                "to have a ball~!"
            },
            suika_intro2 = {
                "In this world, instead of using playing",
                "cards and making poker hands to",
                "score, you need to {C:attention}drop balls{} and",
                "make {C:attention}'Poker Combos'{}!",
            },
            suika_intro3 = {
                "This white dot here is your {C:attention}cursor{}.",
                "This is where the balls you select will",
                "drop from, into the {C:attention}box{} below.",
            },
            suika_intro4 = {
                "Your hand size has gotten smaller!",
                "Anyways, try selecting {C:attention}exactly one{}",
                "card from your hand.",
            },
            suika_intro5 = {
                "You may notice that cards of higher {C:attention}rank{}",
                "give {C:attention}exponentially more{} {C:chips}chips{}, but their",
                "balls are {C:attention}much larger{}!",
            },
            suika_intro6 = {
                "Check out your new {C:attention}deck{}!",
                "Can you spot the differences?",
            },
            suika_intro7 = {
                "Use the {C:attention}A{} and {C:attention}D{} keys or",
                "{C:attention}LEFT ARROW{} and {C:attention}RIGHT ARROW{} keys",
                "to move the selected",
                "ball left and right!",
            },
            suika_intro8 = {
                "Use the {C:attention}S{} key or {C:attention}DOWN ARROW{}",
                "key to {C:attention}drop{} the ball. Try",
                "dropping some balls into the box!",
            },
            
            suika_dropfive1 = {
                "Hey... why aren't any of",
                "the balls merging yet?",
            },
            suika_dropfive2 = {
                "Well, merging them at the {C:attention}right time{}",
                "is critical to your {C:attention}score{}!",
            },
            suika_dropfive3 = {
                "Balls of the same rank will",
                "only {C:attention}merge{} together",
                "after you {C:blue}Play Hand{}.",
            },
            suika_dropfive4 = {
                "Check out the new {C:attention}Poker Combos{}",
                "tab in Run Info!",
            },
            suika_dropfive5 = {
                "The Poker Combos with",
                "a {C:tarot}purple background{}",
                "are calculated {C:attention}first{}!",
            },
            suika_dropfive6 = {
                "This category involves checking for",
                "contiguous groups of balls of the",
                "{C:attention}same suit{} in the box.",
            },
            suika_dropfive7 = {
                "The Poker Combos with",
                "an {C:attention}orange background{}",
                "are calculated afterwards,",
                "and {C:attention}merging occurs!{}",
            },
            suika_dropfive8 = {
                "From however your box of balls",
                "may cascade, you may score {C:attention}multiple{}",
                "poker combos in one hand...",
            },
            suika_dropfive9 = {
                "...and maybe even the same",
                "poker combo multiple times!",
            },
            suika_dropfive10 = {
                "Try fill your box with balls,",
                "then press {C:blue}Play Hand{}! Keep",
                "in mind the {C:attention}Poker Combos{}!",
            },
            
            suika_secondhand1 = {
                "Be careful not to fill",
                "your box too much!",
            },
            suika_secondhand2 = {
                "If a ball touches another ball ",
                "whilst it is {C:attention}entirely above{}",
                "the red line, it's {E:1,C:red}game over{}!",
            },
            suika_secondhand3 = {
                "Make sure your balls are",
                "dropped properly in order ",
                "to let them merge together",
                "and make room!",
            },
            suika_secondhand4 = {
                "Oh, and balls won't",
                "fall out of the box.",
                "Trust me, I've tried.",
            },

            suika_shop1 = {
                "Check out this {C:tarot}The Empress{} card!",
            },
            suika_shop2 = {
                "Enhancements on cards will",
                "affect the balls they drop.",
            },
            suika_shop3 = {
                "Some enhancements have {C:attention}new effects{}!",
                "Most of the {C:tarot}Tarot{} cards can have",
                "their ability applied to {C:attention}an additional card{}.",
            },
            suika_shop4 = {
                "Let's take the card into",
                "the Blind for a whirl."
            },

            suika_bigblind1 = {
                "In vanilla Balatro, card like",
                "Mult and Bonus cards",
                "activate in the played hand",
                "from {C:attention}left to right{}.",
            },
            suika_bigblind2 = {
                "In Suikalatro, instead",
                "their effects activate",
                "whenever the ball {C:attention}merges{}!",
            },
            suika_bigblind3 = {
                "So every time a pair of balls {C:attention}merge{},",
                "think of it like {C:attention}two playing cards{}",
                "{C:attention}scoring at the same time{}!",
            },
            suika_bigblind4 = {
                "When a ball with an enhancement merges",
                "with an {C:attention}unenhanced ball{}, the 'child' ball is",
                "{C:attention}guaranteed{} to have the enhancement!",
            },
            suika_bigblind5 = {
                "Two balls of {C:attention}different enhancements{} merging",
                "results in the 'child' ball having a {C:attention}random",
                "enhancement{} from either of its 'parents'.",
            },
            suika_bigblind6 = {
                "Take advantage of these facts ",
                "to create glorious cascades!",
            },
        },
        v_dictionary={},
        v_text={},
    },
}