function sc_type_analysis() {
/// @description Analyzes the player's deck for type effectiveness against known enemy decks
/// @return Array with analysis results

var analysis_result = {
    deck_types: [],
    missing_coverage: [],
    weak_against: [],
    strong_against: [],
    recommendations: []
};

// Initialize type counters for player's deck
var player_types = array_create(18, 0);

// Count types in player's deck (using deck card instances if available)
if (instance_exists(ob_deckbuild)) {
    // Use existing card instances from deck builder
    for (var i = 0; i < ob_deckbuild.deck_build_used_total; i++) {
        if (variable_instance_exists(ob_deckbuild, "deck_card_used") && 
            instance_exists(ob_deckbuild.deck_card_used[i])) {
            var card_inst = ob_deckbuild.deck_card_used[i];
            var type_a = card_inst.card_type_a;
            var type_b = card_inst.card_type_b;
            
            player_types[type_a]++;
            if (type_b >= 0 && type_b != type_a) {
                player_types[type_b]++;
            }
        }
    }
} else {
    // OTHERWISE: analyze deck data from ob_main (for battle context)
    for (var i = 0; i < ob_main.maindeck_used_total; i++) {
        var card_id_temp = ob_main.main_card_id[i];
        if (card_id_temp != -1) {
            // Save current context variables if they exist
            var saved_card_id = (variable_instance_exists(self, "card_id")) ? card_id : -1;
            var saved_card_shiny = (variable_instance_exists(self, "card_shiny")) ? card_shiny : false;
            var saved_card_type_a = (variable_instance_exists(self, "card_type_a")) ? card_type_a : -1;
            var saved_card_type_b = (variable_instance_exists(self, "card_type_b")) ? card_type_b : -1;
            
            // Set up temporary context for sc_pokelist
            card_id = card_id_temp;
            card_shiny = false;
            
            // Get card types using the pokelist script
            sc_pokelist();
            var type_a = card_type_a;
            var type_b = card_type_b;
            
            // Restore original context if variables existed
            if (saved_card_id != -1) card_id = saved_card_id;
            if (variable_instance_exists(self, "card_shiny")) card_shiny = saved_card_shiny;
            if (saved_card_type_a != -1) card_type_a = saved_card_type_a;
            if (saved_card_type_b != -1) card_type_b = saved_card_type_b;
            
            player_types[type_a]++;
            if (type_b >= 0 && type_b != type_a) {
                player_types[type_b]++;
            }
            
        }
    }
}

// Store deck types for display
for (var i = 0; i < 18; i++) {
    if (player_types[i] > 0) {
        array_push(analysis_result.deck_types, {
            type: i,
            count: player_types[i]
        });
    }
}

// Analyze coverage against all types
var type_names = ["Normal", "Grass", "Fire", "Water", "Electric", "Flying", 
                  "Fighting", "Psychic", "Fairy", "Ground", "Rock", "Bug", 
                  "Poison", "Ice", "Dragon", "Steel", "Ghost", "Dark"];

var coverage = array_create(18, false);

// Check what types the player can effectively attack
for (var i = 0; i < 18; i++) {
    if (player_types[i] > 0) {
        // Check what this type is effective against
        for (var j = 0; j < 18; j++) {
            if (sc_type_bonus(i, -1, j, -1)) {
                coverage[j] = true;
            }
        }
    }
}

// Find missing coverage
for (var i = 0; i < 18; i++) {
    if (!coverage[i]) {
        array_push(analysis_result.missing_coverage, {
            type: i,
            name: type_names[i]
        });
    }
}

// Analyze what the player is weak against
var weaknesses = array_create(18, 0);
for (var i = 0; i < 18; i++) {
    if (player_types[i] > 0) {
        // Check what types are effective against this type
        for (var j = 0; j < 18; j++) {
            if (sc_type_bonus(j, -1, i, -1)) {
                weaknesses[j] += player_types[i];
            }
        }
    }
}

// Store significant weaknesses
for (var i = 0; i < 18; i++) {
    if (weaknesses[i] > 0) {
        array_push(analysis_result.weak_against, {
            type: i,
            name: type_names[i],
            severity: weaknesses[i]
        });
    }
}

// Generate recommendations
if (array_length(analysis_result.missing_coverage) > 0) {
    array_push(analysis_result.recommendations, "Add coverage for: " + string(array_length(analysis_result.missing_coverage)) + " types");
}

if (array_length(analysis_result.weak_against) > 3) {
    array_push(analysis_result.recommendations, "Consider more defensive typing");
}

if (array_length(analysis_result.deck_types) < 3) {
    array_push(analysis_result.recommendations, "Add more type diversity");
}

return analysis_result;
}
