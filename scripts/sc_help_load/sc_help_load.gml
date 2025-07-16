// sc_help_load - Loads the help data 
// Simple array-based implementation

// GAME OVERVIEW & GOALS
help_data[0,0] = "Your goal is to become Crystal League Champion! Travel through 8 gym leaders in major cities, then face the Elite Four and Champion. Each victory makes you stronger and unlocks new areas to explore!";
help_data[0,1] = true; // activated
help_data[0,2] = "0"; // image index in sp_help sprite sheet

// DECK BUILDING BASICS
help_data[1,0] = "To build your deck, click on the deck area on the left side of the main menu. Here you can add Pokemon cards and berries to create your battle deck. Click on cards and berries from your collection into your deck slots to customize your strategy.";
help_data[1,1] = true;
help_data[1,2] = "1"; // image index in sp_help sprite sheet

// COMBAT BASICS
help_data[2,0] = "Combat basics: You start each battle with Hit Points (HP). Attack enemy Pokemon to deal damage. Damage = Your Attack - Enemy Defense. Unopposed attacks hit the enemy directly, reducing their HP while increasing yours!";
help_data[2,1] = true;
help_data[2,2] = "2"; // image index in sp_help sprite sheet

// DRAW POINTS SYSTEM
help_data[3,0] = "Draw points are gained each turn and let you draw cards. Press [A] to spend 1 draw point for a berry, [D] to spend 2 draw points for a Pokemon. Manage your draw points wisely to get the cards you need!";
help_data[3,1] = true;
help_data[3,2] = "3"; // image index in sp_help sprite sheet

// BATTLE RULES
help_data[4,0] = "Important battle rules: You get 5 Draw Points on your first turn, then 2 DP each turn after. Pokemon cannot attack on the first turn they're played. Position matters - place Pokemon strategically to block or attack!";
help_data[4,1] = true;
help_data[4,2] = "4"; // image index in sp_help sprite sheet

// PLAYING POKEMON CARDS
help_data[5,0] = "To play a Pokemon card, you must first place a berry of the same type on the field. For example, place a Fire berry before playing a Fire Pokemon. Click on the berry from your hand, then click on an empty field slot. Then you can play your Pokemon on that berry.";
help_data[5,1] = true;
help_data[5,2] = "5"; // image index in sp_help sprite sheet

// TYPE ADVANTAGES
help_data[6,0] = "Type advantages give you extra damage. Fire beats Grass, Water beats Fire, Grass beats Water. Learn the type chart! You can see it by pressing the key [S]";
help_data[6,1] = true;
help_data[6,2] = "6"; // image index in sp_help sprite sheet

// KEYBOARD SHORTCUTS
help_data[7,0] = "Useful keyboard shortcuts: [Tab] = Sort hand cards, [S] = View type chart, [W] = Auto-attack, [Enter] = End turn, [A] = Draw berry (1 DP), [D] = Draw Pokemon (2 DP). Learn these to play faster!";
help_data[7,1] = true;
help_data[7,2] = "7"; // image index in sp_help sprite sheet

// MAP EVENTS
help_data[8,0] = "On the main map, you'll see 2-3 event options at each location. These can be battles, card packs, berries, level-ups, or other rewards. Click on one to choose that event - you can only pick one option per area before moving to the next location.";
help_data[8,1] = true;
help_data[8,2] = "8"; // image index in sp_help sprite sheet

// LEVEL UP EVENTS
help_data[9,0] = "Level Up events let you upgrade your Pokemon cards for $100 plus additional cost per level. Select a Pokemon from your deck to permanently increase its HP, Attack, and Defense stats. Higher level Pokemon are stronger in battle!";
help_data[9,1] = true;
help_data[9,2] = "9"; // image index in sp_help sprite sheet

// EVOLUTION EVENTS
help_data[10,0] = "Evolution events cost $500 and transform your Pokemon into a different species. Place a Pokemon card in the event slot to evolve it randomly into one of 8 possible evolutions. This can completely change your Pokemon's abilities and stats!";
help_data[10,1] = true;
help_data[10,2] = "10"; // image index in sp_help sprite sheet

// GLYPH EVENTS
help_data[11,0] = "Glyph events cost $300 and add special abilities to your Pokemon. Each Pokemon can hold up to 3 glyphs that provide various bonuses like extra damage, defense, or special effects. Choose glyphs that complement your strategy!";
help_data[11,1] = true;
help_data[11,2] = "11"; // image index in sp_help sprite sheet

// TRIBUTE EVENTS
help_data[12,0] = "Tribute events let you transfer innate power between two Pokemon. Place two Pokemon in the slots - the first will lose 1 innate point while the second gains 1 innate point. Higher innate power makes Pokemon stronger and more reliable!";
help_data[12,1] = true;
help_data[12,2] = "12"; // image index in sp_help sprite sheet

// MULTI-BERRY BONUS
help_data[13,0] = "When you win battles, you get money rewards. Having multiple different berry types in your deck gives you a multi-berry bonus - extra percentage money on top of your base reward. Diversify your berry collection for more profit!";
help_data[13,1] = true;
help_data[13,2] = "13"; // image index in sp_help sprite sheet

// Filter nur aktivierte Items
var active_count = 0;
for (var i = 0; i < 14; i++) {
    if (help_data[i,1] == true) {
        help_active_items[active_count,0] = help_data[i,0]; // description
        help_active_items[active_count,1] = help_data[i,2]; // picture
        active_count++;
    }
}

help_total_items = active_count;
help_current_index = 0;
