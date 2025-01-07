class CfgPatches {
	class tsp_tracker {
		requiredAddons[] = {"cba_common", "ace_interaction"};
		units[] = {};
	};
};

//-- FUNCTIONS
class Extended_PreInit_EventHandlers {class tsp_tracker_cba {init = "['tsp_cba_tracker_poll', 'SLIDER',	['Tracker Polling Rate', 'How often markers are updated.'],	'TSP Core', [0, 120, 10], false] call CBA_fnc_addSetting;";};}; 
class Extended_PostInit_EventHandlers {
	class tsp_tracker_functions {init = "[] call compileScript ['\tsp_tracker\functions.sqf']";}; 
	class tsp_tracker_init {init = "['CBA_settingsInitialized', {[] spawn compileScript ['\tsp_tracker\init.sqf']}] call CBA_fnc_addEventHandler;";};
};

//-- ITEMS
class CfgWeapons {
	class ItemGPS;
	class tsp_fbcb2: ItemGPS {displayName = "FBCB2 Tracker"; picture = "\tsp_tracker\gui\fbcb2_ui.paa"; model = "A3\Props_F_Exp_A\Military\Equipment\Tablet_02_F.p3d"; distance = 12000;};
	class tsp_trijatta: tsp_fbcb2 {displayName = "Trijatta BFT"; picture = "\tsp_tracker\gui\trijatta_ui.paa"; model = "tsp_tracker\trijatta.p3d"; distance = 10000;};
	class tsp_track24: tsp_fbcb2 {displayName = "Track24"; picture = "\tsp_tracker\gui\track24_ui.paa"; model = "tsp_tracker\track24.p3d"; distance = 8000;};
	class ItemCore;
	class UavTerminal_base: ItemCore {distance = 12000;};
};

//-- ACE ACTIONS
class CfgVehicles {
	class CAManBase {
		class ACE_SelfActions {
			class tsp_ace_tracker_on {
				displayName = "Turn On Tracker";
				icon = "tsp_tracker\gui\tracker_on.paa";
				condition = "!(_player getVariable ['tsp_tracker_trackable', false]) && [_player] call tsp_fnc_tracker_get != '' && visibleMap";  //-- Tracker off and has tracker && visibleMap
				statement = "_player setVariable ['tsp_tracker_trackable', true, true]; [player] call tsp_fnc_tracker_poll";
				exceptions[] = {"isNotInside", "isNotSitting", "notOnMap"};
			};
			class tsp_ace_tracker_off: tsp_ace_tracker_on {
				displayName = "Turn Off Tracker";
				icon = "tsp_tracker\gui\tracker_off.paa";
				condition = "(_player getVariable ['tsp_tracker_trackable', false]) && [_player] call tsp_fnc_tracker_get != '' && visibleMap";  //-- Tracker on and has tracker
				statement = "_player setVariable ['tsp_tracker_trackable', false, true]; [player] call tsp_fnc_tracker_poll";
			};
		};
	};
};