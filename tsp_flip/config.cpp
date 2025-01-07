class CfgPatches {
	class tsp_flip {
		requiredAddons[] = {"cba_common", "tsp_core", "ace_interaction"};
		units[] = {};
	};
};

//-- FUNCTIONS
class Extended_PreInit_EventHandlers {class tsp_flip {init = "[] call compileScript ['\tsp_flip\cba.sqf']";};}; 
class Extended_PostInit_EventHandlers {class tsp_flip_functions {init = "[] call compileScript ['\tsp_flip\functions.sqf']";};};

//-- ACTIONS
class tsp_flip {
	displayName = "Flip"; icon = "tsp_flip\gui\flip.paa"; 
	condition = "tsp_cba_flip && !(_target getVariable ['numberOfFlippers', 0] > 0) && ((tsp_cba_flip_upsidedown && (vectorUp _target) select 2 < 0) || !tsp_cba_flip_upsidedown)";
	statement = "[_player, _target] spawn tsp_fnc_flip_action";
};
class CfgVehicles {
	class LandVehicle;
	class Car: LandVehicle {class ACE_Actions {class ACE_MainActions {class tsp_flip: tsp_flip {};};};};
	class Tank: LandVehicle	{class ACE_Actions {class ACE_MainActions {class tsp_flip: tsp_flip {};};};};
    //class Quadbike_01_base_F {class ACE_Actions {class ACE_MainActions {class ace_interaction_flip {condition = "false";};};};};
	//class Kart_01_Base_F {class ACE_Actions {class ACE_MainActions {class ace_interaction_flip {condition = "false";};};};};
	class StaticWeapon {class ACE_Actions {class ACE_MainActions {class ace_interaction_flip {displayName = "Set Up Weapon";};};};};  //-- Renamed to avoid confusion (since original is "Flip")
};

//-- ANIMATIONS
class CfgMovesBasic {class default; class DefaultDie; class ManActions {tsp_flip = "tsp_flip";};};
class CfgMovesMaleSdr: CfgMovesBasic {
    class States {
		class CutSceneAnimationBase;
		class Acts_TerminalOpen;
		class tsp_flip: Acts_TerminalOpen {
			interpolateTo[] = {"amovpknlmstpsnonwnondnon", 100, "Unconscious", 0.02};
			interpolateFrom[] = {"amovpknlmstpsnonwnondnon", 100};
			interpolationSpeed = 1;
		};
	};
};