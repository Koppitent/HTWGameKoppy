function sc_draw_type_analysis_overlay() {
/// @description Draws the type analysis overlay in battles
/// @return void

if (!instance_exists(ob_control)) return;

var cam_x = camera_get_view_x(view_camera[0]);
var cam_y = camera_get_view_y(view_camera[0]);

// Only show if player has analysis enabled and is their turn
if (ob_control.battler_turn != 1 || !ob_main.show_type_analysis) return;

// Get enemy type information from cards currently on the battlefield
var enemy_types_on_field = [];
var enemy_type_counts = [];
for (var i = 0; i < 18; i++) {
    enemy_type_counts[i] = 0;
}

// Check enemy card spaces (spaces 0-4 are enemy spaces)
var enemy_cards_found = 0;
for (var i = 0; i < 5; i++) {
    if (variable_instance_exists(ob_control, "card_space_id") && 
        array_length(ob_control.card_space_id) > i &&
        ob_control.card_space_id[i].occupy_id != -1) {
        
        var enemy_card = ob_control.card_space_id[i].occupy_id;
        if (instance_exists(enemy_card) && enemy_card.card_enemy) {
            enemy_cards_found++;
            var card_type_a = enemy_card.card_type_a;
            var card_type_b = enemy_card.card_type_b;
            
            if (card_type_a >= 0 && card_type_a < 18) {
                enemy_type_counts[card_type_a]++;
                var found = false;
                for (var j = 0; j < array_length(enemy_types_on_field); j++) {
                    if (enemy_types_on_field[j] == card_type_a) {
                        found = true;
                        break;
                    }
                }
                if (!found) array_push(enemy_types_on_field, card_type_a);
            }
            
            if (card_type_b >= 0 && card_type_b < 18 && card_type_b != card_type_a) {
                enemy_type_counts[card_type_b]++;
                var found = false;
                for (var j = 0; j < array_length(enemy_types_on_field); j++) {
                    if (enemy_types_on_field[j] == card_type_b) {
                        found = true;
                        break;
                    }
                }
                if (!found) array_push(enemy_types_on_field, card_type_b);
            }
        }
    }
}

// If no enemy cards on field, fall back to predicted enemy deck composition
var enemy_chances = [];
if (enemy_cards_found == 0) {
    for (var i = 0; i < 18; i++) {
        if (variable_instance_exists(ob_control, "enemy_type_chance")) {
            enemy_chances[i] = ob_control.enemy_type_chance[i];
        } else {
            enemy_chances[i] = 0;
        }
    }
} else {
    // Convert counts to percentages
    for (var i = 0; i < 18; i++) {
        enemy_chances[i] = (enemy_type_counts[i] / enemy_cards_found) * 100;
    }
}

var battle_rec = sc_battle_type_recommendation(enemy_chances);

// Draw semi-transparent background
var overlay_x = cam_x + 10;
var overlay_y = cam_y + 30;
var overlay_w = 200;
var overlay_h = 120;

sc_drawrectangle(overlay_x, overlay_y, overlay_x + overlay_w, overlay_y + overlay_h, 
                global.color_black, global.color_black, 1, 0.8, 0.9, 0);

// Draw title with data source
draw_set_font(fn_m6x11);
draw_set_halign(fa_left);
var title_text = "Typ-Analyse";
if (enemy_cards_found > 0) {
    title_text += " (Feld: " + string(enemy_cards_found) + " Karten)";
} else {
    title_text += " (Deck-Vorhersage)";
}
sc_drawtext(overlay_x + 5, overlay_y + 5, title_text, global.color_friendly, global.color_black, 1, 1, 0, -1);

// Draw recommended types
draw_set_font(fn_m3x6);
var text_y = overlay_y + 20;

if (enemy_cards_found == 0 && array_length(battle_rec.recommended_types) == 0) {
    // No information available
    sc_drawtext(overlay_x + 5, text_y, "Keine Informationen über", global.color_white, global.color_black, 1, 1, 0, -1);
    text_y += 10;
    sc_drawtext(overlay_x + 5, text_y, "Gegner-Pokemon verfügbar.", global.color_white, global.color_black, 1, 1, 0, -1);
    text_y += 15;
    sc_drawtext(overlay_x + 5, text_y, "Warte bis Gegner", global.color_white, global.color_black, 1, 1, 0, -1);
    text_y += 10;
    sc_drawtext(overlay_x + 5, text_y, "Karten spielt.", global.color_white, global.color_black, 1, 1, 0, -1);
} else if (array_length(battle_rec.recommended_types) > 0) {
    sc_drawtext(overlay_x + 5, text_y, "Empfohlen:", global.color_friendly, global.color_black, 1, 1, 0, -1);
    text_y += 10;
    
    for (var i = 0; i < min(3, array_length(battle_rec.recommended_types)); i++) {
        var type_info = battle_rec.recommended_types[i];
        // Draw type icon
        draw_sprite_general(sp_sheet, 0, 16*(type_info.type+1), 16*5, 12, 11, 
                          overlay_x + 8, text_y, 1, 1, 0, c_white, c_white, c_white, c_white, 1);
        // Draw type name
        sc_drawtext(overlay_x + 22, text_y, type_info.name, global.color_white, global.color_black, 1, 1, 0, -1);
        text_y += 12;
    }
}

// Draw types to avoid
if (array_length(battle_rec.avoid_types) > 0) {
    sc_drawtext(overlay_x + 5, text_y, "Vermeiden:", global.color_damage, global.color_black, 1, 1, 0, -1);
    text_y += 10;
    
    for (var i = 0; i < min(2, array_length(battle_rec.avoid_types)); i++) {
        var type_info = battle_rec.avoid_types[i];
        // Draw type icon
        draw_sprite_general(sp_sheet, 0, 16*(type_info.type+1), 16*5, 12, 11, 
                          overlay_x + 8, text_y, 1, 1, 0, c_white, c_white, c_white, c_white, 0.6);
        // Draw type name
        sc_drawtext(overlay_x + 22, text_y, type_info.name, global.color_damage, global.color_black, 1, 1, 0, -1);
        text_y += 12;
    }
}

// Draw warnings
if (array_length(battle_rec.battle_warnings) > 0) {
    for (var i = 0; i < min(2, array_length(battle_rec.battle_warnings)); i++) {
        sc_drawtext(overlay_x + 5, text_y, battle_rec.battle_warnings[i], global.color_damage, global.color_black, 1, 1, 0, -1);
        text_y += 10;
    }
}

// Toggle instruction
sc_drawtext(overlay_x + 5, overlay_y + overlay_h - 12, "[T] Analyse ein/aus", global.color_white, global.color_black, 0.7, 0.7, 0, -1);
}
