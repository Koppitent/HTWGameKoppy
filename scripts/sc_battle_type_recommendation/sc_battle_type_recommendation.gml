function sc_battle_type_recommendation(enemy_type_chances) {
/// @description Provides type recommendations for the current battle based on enemy deck
/// @param enemy_type_chances Array of enemy type percentages
/// @return Struct with battle recommendations

var battle_rec = {
    recommended_types: [],
    avoid_types: [],
    key_weaknesses: [],
    battle_warnings: []
};

var type_names = ["Normal", "Grass", "Fire", "Water", "Electric", "Flying", 
                  "Fighting", "Psychic", "Fairy", "Ground", "Rock", "Bug", 
                  "Poison", "Ice", "Dragon", "Steel", "Ghost", "Dark"];

var primary_enemy_types = [];
for (var i = 0; i < 18; i++) {
    if (enemy_type_chances[i] >= 75) {
        array_push(primary_enemy_types, i);
    }
}

var recommended_against_enemy = [];
for (var i = 0; i < array_length(primary_enemy_types); i++) {
    var enemy_type = primary_enemy_types[i];
    
    for (var j = 0; j < 18; j++) {
        if (sc_type_bonus(j, -1, enemy_type, -1)) {
            var already_listed = false;
            for (var k = 0; k < array_length(recommended_against_enemy); k++) {
                if (recommended_against_enemy[k] == j) {
                    already_listed = true;
                    break;
                }
            }
            if (!already_listed) {
                array_push(recommended_against_enemy, j);
            }
        }
    }
}

for (var i = 0; i < array_length(recommended_against_enemy); i++) {
    array_push(battle_rec.recommended_types, {
        type: recommended_against_enemy[i],
        name: type_names[recommended_against_enemy[i]]
    });
}

var avoid_against_enemy = [];
for (var i = 0; i < array_length(primary_enemy_types); i++) {
    var enemy_type = primary_enemy_types[i];
    
    for (var j = 0; j < 18; j++) {
        if (sc_type_bonus(enemy_type, -1, j, -1)) {
            var already_listed = false;
            for (var k = 0; k < array_length(avoid_against_enemy); k++) {
                if (avoid_against_enemy[k] == j) {
                    already_listed = true;
                    break;
                }
            }
            if (!already_listed) {
                array_push(avoid_against_enemy, j);
            }
        }
    }
}

for (var i = 0; i < array_length(avoid_against_enemy); i++) {
    array_push(battle_rec.avoid_types, {
        type: avoid_against_enemy[i],
        name: type_names[avoid_against_enemy[i]]
    });
}

var player_has_recommended = false;
var player_has_vulnerable = false;

for (var i = 0; i < ob_main.maindeck_used_total; i++) {
    var card_id_temp = ob_main.main_card_id[i];
    if (card_id_temp != -1) {
        var saved_card_id = (variable_instance_exists(self, "card_id")) ? card_id : -1;
        var saved_card_shiny = (variable_instance_exists(self, "card_shiny")) ? card_shiny : false;
        var saved_card_type_a = (variable_instance_exists(self, "card_type_a")) ? card_type_a : -1;
        var saved_card_type_b = (variable_instance_exists(self, "card_type_b")) ? card_type_b : -1;
        
        card_id = card_id_temp;
        card_shiny = false;
        
        sc_pokelist();
        var type_a = card_type_a;
        var type_b = card_type_b;
        
        if (saved_card_id != -1) card_id = saved_card_id;
        if (variable_instance_exists(self, "card_shiny")) card_shiny = saved_card_shiny;
        if (saved_card_type_a != -1) card_type_a = saved_card_type_a;
        if (saved_card_type_b != -1) card_type_b = saved_card_type_b;
        
        for (var j = 0; j < array_length(recommended_against_enemy); j++) {
            if (type_a == recommended_against_enemy[j] || type_b == recommended_against_enemy[j]) {
                player_has_recommended = true;
            }
        }
        
        for (var j = 0; j < array_length(avoid_against_enemy); j++) {
            if (type_a == avoid_against_enemy[j] || type_b == avoid_against_enemy[j]) {
                player_has_vulnerable = true;
                array_push(battle_rec.key_weaknesses, {
                    type: avoid_against_enemy[j],
                    name: type_names[avoid_against_enemy[j]]
                });
            }
        }
        
    }
}

if (!player_has_recommended && array_length(recommended_against_enemy) > 0) {
    array_push(battle_rec.battle_warnings, "WARNING: No super effective types in deck!");
}

if (player_has_vulnerable && array_length(avoid_against_enemy) > 0) {
    array_push(battle_rec.battle_warnings, "CAUTION: Vulnerable types detected in deck!");
}

if (array_length(primary_enemy_types) == 0) {
    array_push(battle_rec.battle_warnings, "Unknown enemy composition - be prepared for anything!");
}

return battle_rec;
}
