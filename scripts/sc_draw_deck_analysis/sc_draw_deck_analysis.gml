function sc_draw_deck_analysis() {
/// @description Draws deck analysis in the deck building screen
/// @return void

if (!instance_exists(ob_deckbuild)) return;
if (!ob_main.show_deck_analysis) return;

var analysis = sc_type_analysis();

// Position the analysis panel
var analysis_x = screen_deck_x + 220;
var analysis_y = screen_main_y + 10;
var analysis_w = 180;
var analysis_h = 160;

// Draw background
sc_drawrectangle(analysis_x, analysis_y, analysis_x + analysis_w, analysis_y + analysis_h, 
                global.color_black, global.color_white, 1, 0.7, 0.8, 0);

// Title
draw_set_font(fn_m6x11);
draw_set_halign(fa_left);
sc_drawtext(analysis_x + 5, analysis_y + 5, "Deck Analysis", global.color_friendly, global.color_black, 1, 1, 0, -1);

draw_set_font(fn_m3x6);
var text_y = analysis_y + 20;

// Show deck types
if (array_length(analysis.deck_types) > 0) {
    sc_drawtext(analysis_x + 5, text_y, "Types in Deck:", global.color_white, global.color_black, 1, 1, 0, -1);
    text_y += 10;
    
    var types_per_line = 6;
    var type_x = analysis_x + 8;
    var line_count = 0;
    
    for (var i = 0; i < array_length(analysis.deck_types); i++) {
        var type_info = analysis.deck_types[i];
        
        // Draw type icon
        draw_sprite_general(sp_sheet, 0, 16*(type_info.type+1), 16*5, 12, 11, 
                          type_x, text_y, 1, 1, 0, c_white, c_white, c_white, c_white, 1);
        
        // Draw count
        sc_drawtext(type_x + 13, text_y + 8, string(type_info.count), global.color_white, global.color_black, 0.8, 0.8, 0, -1);
        
        type_x += 20;
        line_count++;
        
        if (line_count >= types_per_line) {
            text_y += 15;
            type_x = analysis_x + 8;
            line_count = 0;
        }
    }
    
    if (line_count > 0) text_y += 15;
    text_y += 5;
}

// Show missing coverage
if (array_length(analysis.missing_coverage) > 0) {
    sc_drawtext(analysis_x + 5, text_y, "No Coverage Against:", global.color_damage, global.color_black, 1, 1, 0, -1);
    text_y += 10;
    
    var types_per_line = 8;
    var type_x = analysis_x + 8;
    var line_count = 0;
    
    for (var i = 0; i < min(16, array_length(analysis.missing_coverage)); i++) {
        var type_info = analysis.missing_coverage[i];
        
        // Draw type icon with reduced opacity
        draw_sprite_general(sp_sheet, 0, 16*(type_info.type+1), 16*5, 12, 11, 
                          type_x, text_y, 1, 1, 0, c_white, c_white, c_white, c_white, 0.6);
        
        type_x += 15;
        line_count++;
        
        if (line_count >= types_per_line) {
            text_y += 13;
            type_x = analysis_x + 8;
            line_count = 0;
        }
    }
    
    if (line_count > 0) text_y += 13;
    text_y += 5;
}

// Show recommendations
if (array_length(analysis.recommendations) > 0) {
    sc_drawtext(analysis_x + 5, text_y, "Recommendations:", global.color_friendly, global.color_black, 1, 1, 0, -1);
    text_y += 10;
    
    for (var i = 0; i < min(3, array_length(analysis.recommendations)); i++) {
        sc_drawtext(analysis_x + 8, text_y, "• " + analysis.recommendations[i], global.color_white, global.color_black, 0.9, 0.9, 0, -1);
        text_y += 12;
    }
}

// Deck quality indicator
var deck_quality = "Average";
var quality_color = global.color_white;

if (array_length(analysis.missing_coverage) <= 3 && array_length(analysis.deck_types) >= 4) {
    deck_quality = "Excellent";
    quality_color = global.color_friendly;
} else if (array_length(analysis.missing_coverage) > 10 || array_length(analysis.deck_types) <= 2) {
    deck_quality = "Needs Work";
    quality_color = global.color_damage;
}

sc_drawtext(analysis_x + 5, analysis_y + analysis_h - 15, "Quality: " + deck_quality, quality_color, global.color_black, 1, 1, 0, -1);
}
