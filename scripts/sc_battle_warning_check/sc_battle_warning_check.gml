function sc_battle_warning_check() {
/// @description Checks if the player's deck has significant weaknesses for the upcoming battle
/// @return Struct with warning information

var warning_info = {
    has_warnings: false,
    warning_messages: [],
    severity: 0  // 0=none, 1=minor, 2=major, 3=critical
};

if (!variable_global_exists("global_enemy_type_chance")) {
    return warning_info;
}

var enemy_chances = [];
for (var i = 0; i < 18; i++) {
    enemy_chances[i] = global.global_enemy_type_chance[i];
}

var battle_rec = sc_battle_type_recommendation(enemy_chances);

if (array_length(battle_rec.battle_warnings) > 0) {
    warning_info.has_warnings = true;
    warning_info.severity = max(warning_info.severity, 2);
    
    for (var i = 0; i < array_length(battle_rec.battle_warnings); i++) {
        array_push(warning_info.warning_messages, battle_rec.battle_warnings[i]);
    }
}

var deck_analysis = sc_type_analysis();

// Warning for too few types
if (array_length(deck_analysis.deck_types) <= 2) {
    warning_info.has_warnings = true;
    warning_info.severity = max(warning_info.severity, 1);
    array_push(warning_info.warning_messages, "Low type diversity - only " + string(array_length(deck_analysis.deck_types)) + " types in deck");
}

// Warning for too many missing coverages
if (array_length(deck_analysis.missing_coverage) >= 12) {
    warning_info.has_warnings = true;
    warning_info.severity = max(warning_info.severity, 2);
    array_push(warning_info.warning_messages, "Poor type coverage - missing " + string(array_length(deck_analysis.missing_coverage)) + " type advantages");
}

// Check if player has many vulnerable types against this specific enemy
var vulnerability_count = 0;
for (var i = 0; i < array_length(battle_rec.key_weaknesses); i++) {
    vulnerability_count++;
}

if (vulnerability_count >= 3) {
    warning_info.has_warnings = true;
    warning_info.severity = max(warning_info.severity, 3);
    array_push(warning_info.warning_messages, "CRITICAL: Multiple vulnerable types against this enemy!");
}

// Check for insufficient deck size
if (ob_main.maindeck_used_total < ob_main.maindeck_size_min_full) {
    warning_info.has_warnings = true;
    warning_info.severity = max(warning_info.severity, 3);
    array_push(warning_info.warning_messages, "CRITICAL: Deck too small - need at least " + string(ob_main.maindeck_size_min_full) + " cards");
}

return warning_info;
}
