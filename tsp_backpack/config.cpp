class CfgPatches {
	class tsp_backpack {
		requiredAddons[] = {"ace_interaction"};
		units[] = {};
	};
};

//-- FUNCTIONS
class Extended_PreInit_EventHandlers {class tsp_backpack_functions {init = "[] call compileScript ['\tsp_backpack\functions.sqf']";};};

class CfgVehicles {
	class CAManBase {
	class ACE_SelfActions {
			class ACE_Equipment {
				class tsp_ace_backpack_swap {
					displayName = "Swap Bags"; 
					icon = "tsp_backpack\gui\backpack.paa";
					condition = "(_player getVariable ['tsp_chestpack', []] isNotEqualTo []) && (backpack _player != '')";
					statement = "[_player] spawn tsp_fnc_backpack_swap";
				};
				class tsp_ace_backpack_back: tsp_ace_backpack_swap {displayName = "Put Bag on Back"; condition = "(_player getVariable ['tsp_chestpack', []] isNotEqualTo []) && (backpack _player == '')";};
				class tsp_ace_backpack_chest: tsp_ace_backpack_swap {displayName = "Put Bag on Chest"; condition = "(_player getVariable ['tsp_chestpack', []] isEqualTo []) && (backpack _player != '')";};
			};
		};
	};
};