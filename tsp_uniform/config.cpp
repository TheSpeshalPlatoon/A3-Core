class CfgPatches {
	class tsp_uniform {
		requiredAddons[] = {"cba_common", "ace_interaction"};
		units[] = {};
	};
};

//-- FUNCTIONS
class Extended_PostInit_EventHandlers {class tsp_uniform_functions {init = "[] call compileScript ['\tsp_uniform\functions.sqf']";};};

//-- ACE ACTIONS
class CfgVehicles {
	class CAManBase {
		class ACE_Actions {
			class ACE_MainActions {
				class tsp_uniform_action_steal {
					displayName = "Steal Uniform";
					icon = "tsp_uniform\gui\shirt.paa";
					condition = "uniform _target != '' && (!alive _target || lifeState _target == 'INCAPACITATED') && !('body' in uniform _target)";  //-- Mod enabled, has uniform and is uncon/dead
					statement = "[_player, _target] spawn tsp_fnc_uniform_steal";
				};
			};
		};
	};
};