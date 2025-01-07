class CfgPatches {
	class tsp_medical {
		requiredAddons[] = {"cba_common", "tsp_core", "A3_Weapons_F", "ace_medical"};  //"ace_interaction", "ace_medical_treatment"
		units[] = {};
	};
};

//-- FUNCTIONS
class Extended_PreInit_EventHandlers {class tsp_medical_cba {init = "[] call compileScript ['\tsp_medical\cba.sqf']";};}; 
class Extended_PostInit_EventHandlers {
	class tsp_medical_functions {init = "[] call compileScript ['\tsp_medical\functions.sqf']";}; 
	class tsp_medical_init {init = "['ace_medical_woundReceived', {if (isPlayer (_this#0) && local (_this#0)) then {_this call tsp_fnc_medical_hit}}] call CBA_fnc_addEventHandler;";};
	class tsp_medical_key {init = "['ace_unconscious', {if (isPlayer (_this#0) && local (_this#0)) then {[] spawn tsp_fnc_medical_wake}}] call CBA_fnc_addEventHandler;";};
};

//-- ITEMS
class CfgWeapons {
	class ItemCore;
	class MedikitItem;
	class InventoryFirstAidKitItem_Base_F;
	class InventoryItem_Base_F;
	class FirstAidKit: ItemCore {
		displayName = "First Aid Kit";
		picture = "\tsp_medical\gui\firstaidkit.paa";
		model = "tsp_medical\firstaidkit.p3d";
		class itemInfo: InventoryFirstAidKitItem_Base_F {mass = 8; type = 401; scope = 0;};
	};	
    class Medikit: ItemCore {
		picture = "\tsp_medical\gui\medikit.paa";
		class itemInfo: MedikitItem {mass = 160;};
	};
	class tsp_ifak: FirstAidKit {
		displayName = "Individual First Aid Kit";
		descriptionShort = "Use to treat wounds. Contains more items that regular First Aid Kit";
		picture = "\A3\Weapons_F\Items\data\UI\gear_FirstAidKit_CA.paa";
		model = "A3\Weapons_F\Ammo\mag_FirstAidkit.p3d";
        class itemInfo: InventoryFirstAidKitItem_Base_F {mass = 20;};
	};
};

//-- ACE ACTIONS
class CfgVehicles {  //-- Interaction menu items for vanilla FAK
	class CAManBase {
		class ACE_Actions {
			class ACE_MainActions {
				class tsp_medical_heal {
					displayName = "Heal";
					icon = "tsp_medical\gui\heal.paa";
					condition = "missionNameSpace getVariable ['ace_medical_disabled', false] && ('FirstAidKit' in items _target || 'FirstAidKit' in items _player || 'tsp_ifak' in items _target || 'tsp_ifak' in items _player) && (count ((getAllHitPointsDamage _target)#2 select {_x > 0.25}) > 0) && alive _target";
					statement = "_player action ['HealSoldier', _target]";
				};
			};
		};
		class ACE_SelfActions {
			class tsp_ace_medical_heal {
				displayName = "Heal Self";
				icon = "tsp_medical\gui\heal.paa";
				condition = "missionNameSpace getVariable ['ace_medical_disabled', false] && ('FirstAidKit' in items _player || 'tsp_ifak' in items _player) && (count ((getAllHitPointsDamage _player)#2 select {_x > 0.25}) > 0)";
				statement = "_player action ['HealSoldierSelf', _player]";
			};
		};
	};
};
class ace_medical_treatment_actions {  //-- New Medical menu
	class Tourniquet;
	//class BasicBandage {treatmentTime = "0.5 * (_this call ace_medical_treatment_fnc_getBandageTime)";};
	//class ElasticBandage: BasicBandage {treatmentTime = "0.3 * (_this call ace_medical_treatment_fnc_getBandageTime)";};
	//class PackingBandage: BasicBandage {treatmentTime = "0.3 * (_this call ace_medical_treatment_fnc_getBandageTime)";};
	//class QuikClot: BasicBandage {treatmentTime = "0.3 * (_this call ace_medical_treatment_fnc_getBandageTime)";};
	class tsp_ace_medical_fak: Tourniquet {
		allowedSelections[] = {"All"};
		allowSelfTreatment = 1;
		animationMedic = "";
		animationMedicProne = "";
		animationMedicSelf = "";
		animationMedicSelfProne = "";		
		callbackFailure = "";
		callbackProgress = "";
		callbackStart = "";
		callbackSuccess = "[_this#0, 'FirstAidKit', tsp_cba_medical_fak] call tsp_fnc_medical_open";
		category = "examine";
		condition = "true";
		consumeItem = 0;
		displayName = "Open First Aid Kit";
		displayNameProgress = "Opening...";
		icon = "";
		items[] = {"FirstAidKit"};
		litter[] = {};
		medicRequired = 0;
		treatmentLocations = 0;
		treatmentTime = 0.1;
		treatmentTimeSelfCoef = 1;
	};
	class tsp_ace_medical_medikit: tsp_ace_medical_fak {
		callbackSuccess = "[(_this#0), 'Medikit', tsp_cba_medical_medikit] call tsp_fnc_medical_open";
		displayName = "Open Medikit";
		items[] = {"Medikit"};
	};		
	class tsp_ace_medical_ifak: tsp_ace_medical_fak {
		callbackSuccess = "[(_this#0), 'tsp_ifak', tsp_cba_medical_ifak] call tsp_fnc_medical_open";
		displayName = "Open Individual First Aid Kit";
		items[] = {"tsp_ifak"};
	};
};
class ACE_Medical_Actions {  //-- Old Medical menu
	class Advanced {
		class Tourniquet;
		class tsp_ace_medical_fak: Tourniquet {
			allowedSelections[] = {"All"};
			allowSelfTreatment = 1;
			animationMedic = "";
			animationMedicProne = "";
			animationMedicSelf = "";
			animationMedicSelfProne = "";		
			callbackFailure = "";
			callbackProgress = "";
			callbackStart = "";
			callbackSuccess = "[_this#0, 'FirstAidKit', tsp_cba_medical_fak] call tsp_fnc_medical_open";
			category = "examine";
			condition = "true";
			consumeItem = 0;
			displayName = "Open First Aid Kit";
			displayNameProgress = "Opening...";
			icon = "";
			items[] = {"FirstAidKit"};
			litter[] = {};
			medicRequired = 0;
			treatmentLocations = 0;
			treatmentTime = 0.1;
			treatmentTimeSelfCoef = 1;
		};
		class tsp_ace_medical_medikit: tsp_ace_medical_fak {
			callbackSuccess = "[(_this#0), 'Medikit', tsp_cba_medical_medikit] call tsp_fnc_medical_open";
			displayName = "Open Medikit";
			items[] = {"Medikit"};
		};		
		class tsp_ace_medical_ifak: tsp_ace_medical_fak {
			callbackSuccess = "[(_this#0), 'tsp_ifak', tsp_cba_medical_ifak] call tsp_fnc_medical_open";
			displayName = "Open Individual First Aid Kit";
			items[] = {"tsp_ifak"};
		};
	};
};
class CfgActions {  //-- Remove scroll menu options
    class None;
    class Heal: None {show = false;};
    class HealSoldier: None {show = false;};
    class HealSoldierSelf: None {show = false;};
    class FirstAid: None {show = false;};
    class UnloadUnconsciousUnits: None {show = false;};
    class UnloadFromDriver: None {show = false;};
    class UnloadFromPilot: None {show = false;};
    class UnloadFromCargo: None {show = false;};
    class UnloadFromCommander: None {show = false;};
    class UnloadFromGunner: None {show = false;};
    class UnloadFromTurret: None {show = false;};
};