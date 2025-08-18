/// @description Auto-Typanalyse System - Vollständige Funktionsübersicht
//————————————————————————————————————————————————————————————————————————————————————————————————————
/*
AUTO-TYPANALYSE SYSTEM - FUNKTIONSÜBERSICHT
===========================================

Das implementierte Auto-Typanalyse System bietet folgende Hauptfunktionen:

1. KAMPF-EMPFEHLUNGEN (Taste T im Kampf)
   - Zeigt empfohlene Typen gegen den aktuellen Gegner
   - Warnt vor Typen, die vermieden werden sollten
   - Analysiert Gegner-Deck-Zusammensetzung in Echtzeit
   - Overlay mit Typ-Symbolen und deutschen Beschreibungen

2. DECK-ANALYSE (Taste T im Deck-Builder)
   - Überprüft Deck-Zusammensetzung auf vollständige Typ-Abdeckung
   - Identifiziert fehlende wichtige Typen
   - Bewertet Deck-Qualität (Ausgezeichnet/Gut/Schwach)
   - Gibt spezifische Verbesserungsvorschläge
   - Standardmäßig deaktiviert, um Überlappungen zu vermeiden

3. KAMPF-WARNUNGEN (Vor Kampfbeginn)
   - Verhindert Kämpfe mit kritischen Deck-Problemen
   - Überprüft auf schwere Typ-Benachteiligungen
   - Warnt vor unausgewogener Deck-Zusammensetzung
   - Deutsche Warntexte mit Ja/Nein-Bestätigung

VERWENDETE SCRIPTE:
==================
- sc_type_analysis.gml: Kern-Analyse des Spieler-Decks
- sc_battle_type_recommendation.gml: Kampf-spezifische Empfehlungen
- sc_draw_type_analysis_overlay.gml: Kampf-Overlay-Anzeige
- sc_draw_deck_analysis.gml: Deck-Builder-Integration
- sc_battle_warning_check.gml: Warnungen vor Kampfbeginn
- sc_battle_warning_display.gml: Deutsche Warnmeldungen

STEUERUNG:
==========
- Taste T: Typ-Analyse im Kampf ein-/ausschalten
- Taste T: Deck-Analyse im Deck-Builder ein-/ausschalten
- Visueller Indikator zeigt Status an (Kampf und Deck-Builder)
- Grün = EIN, Weiß = AUS
- Vollständiges Overlay/Panel nur bei aktivierter Analyse
- Beide Analysen standardmäßig getrennt steuerbar

INTEGRATION:
============
- ob_main: Hauptsteuerung und Warnungen
- ob_control: Kampf-Interface mit Overlay
- ob_deckbuild: Deck-Analyse-Anzeige
- sc_textbox: Deutsche Warnmeldungen (ID 60)

Das System nutzt die vorhandene Typ-Effektivitäts-Logik (sc_type_bonus)
und erweitert sie um intelligente Analyse und Empfehlungsfunktionen.
*/
