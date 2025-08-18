function sc_battle_warning_display() {
/// @description Display battle warning information in German
//————————————————————————————————————————————————————————————————————————————————————————————————————

// Check for battle warnings and format German message
var warning_result = sc_battle_warning_check();
var has_warning = warning_result.has_warnings;

if (has_warning) {
    // Format the warning message for German players
    var display_msg = "KRITISCHE DECK-PROBLEME:\n";
    
    // Combine all warning messages
    for (var i = 0; i < array_length(warning_result.warning_messages); i++) {
        display_msg += warning_result.warning_messages[i];
        if (i < array_length(warning_result.warning_messages) - 1) {
            display_msg += "\n";
        }
    }
    
    display_msg += "\n\nEmpfehlung: Deck überarbeiten!";
    
    return display_msg;
}

return "";
}
