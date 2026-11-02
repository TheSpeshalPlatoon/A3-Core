class CfgPatches {
    class tsp_core {requiredAddons[] = {"cba_common", "3DEN", "A3_Data_F_Decade_Loadorder"}; units[] = {"tsp_holder"};};
	/*class tsp_earplug {requiredAddons[] = {}; units[] = {};};
	class tsp_chvd {requiredAddons[] = {}; units[] = {};};
	class tsp_crash {requiredAddons[] = {}; units[] = {};};
	class tsp_light {requiredAddons[] = {"A3_Weapons_F"}; units[]={}; ammo[]= {"FlareBase", "F_40mm_White", "Flare_82mm_AMOS_White", "Sh_155mm_AMOS"};};
	class tsp_immerse {requiredAddons[] = {}; units[] = {};};
	class tsp_faction {requiredAddons[] = {}; units[] = {};};*/
};

#include "\a3\ui_f\hpp\definecommongrids.inc"
#include "scripts\chvd.hpp"
#include "scripts\gui.hpp"

class Extended_PreInit_EventHandlers {class tsp_core {init = "[] call compileScript ['\tsp_core\initFramework.sqf']";};};
class CfgFunctions {class A3 {class effects {file = "tsp_core\crash";};};};  //-- Remove fn_effectKilled to disable RHS custom crash scripts

class CfgVehicles {  //-- Weapon holder that doesn't act as shield, used by throw func, animate sling
    class WeaponHolderSimulated;
    class tsp_holder: WeaponHolderSimulated {isGround = false; model = "tsp_core\data\holder.p3d"; class ACE_Actions {class ACE_MainActions {distance = 0; condition = "false"};};};
    class Man; class CAManBase: Man {
		class ACE_SelfActions {
			class ACE_Equipment	{
				class tsp_ace_earplug_insert {
					displayName = "Use Earplugs"; icon = "\z\ace\addons\hearing\UI\ACE_earplugs_x_ca.paa";
					condition = "!isNil 'tsp_earplug_inserted' && 'ACE_EarPlugs' in items player && !(missionNameSpace getVariable ['tsp_earplug_inserted', false])";
					statement = "call tsp_fnc_earplug_toggle"; exceptions[] = {"isNotInside", "isNotSitting"};
				};
				class tsp_ace_earplug_remove: tsp_ace_earplug_insert {displayName = "Remove Earplugs"; condition = "!isNil 'tsp_earplug_inserted' && soundVolume < 1 && (missionNameSpace getVariable ['tsp_earplug_inserted', false])";};
			};
		};
	};
};

class CfgAmmo {  //-- For brighter/longer flares
    class FlareCore;
    class FlareBase: FlareCore {timeToLive = 999;};
    class F_40mm_White: FlareBase {timeToLive = 999;};
    class Flare_82mm_AMOS_White: FlareCore {timeToLive = 999;};
};

class CfgMovesBasic {
    class default;
    class DefaultDie;
    class ManActions {
        tsp_common_stop[] = {"tsp_common_stop","Gesture"};
        tsp_common_stop_instant[] = {"tsp_common_stop","Gesture"};
        tsp_common_stop_right[] = {"tsp_common_stop_right","Gesture"};	
        tsp_common_stop_left[] = {"tsp_common_stop_left","Gesture"};
    };
};
class CfgGesturesMale {
    skeletonName = "OFP2_ManSkeleton";
    class Default {};
    class States {
        class GestureNod;		
        class tsp_common_stop: GestureNod {
            mask = "empty";
            interpolationSpeed = 5;
            showHandGun = 0;
            rightHandIKCurve[] = {1}; 
            leftHandIKCurve[] = {1};
            canPullTrigger = 1;
            enableBinocular = 1;
            enableMissile = 1;
            enableOptics = 1;
            disableWeapons = 0;
            disableWeaponsLong = 0;
        };	
        class tsp_common_stop_instant: tsp_common_stop {interpolationSpeed = 99999; speed = 99999; showHandGun = 1;};	
        class tsp_common_stop_right: tsp_common_stop {rightHandIKCurve[] = {0,0,0.5,1}; leftHandIKCurve[] = {1};};	
        class tsp_common_stop_left: tsp_common_stop {rightHandIKCurve[] = {1}; leftHandIKCurve[] = {0,0,0.5,1};};
    };
    class BlendAnims {
        rightArmHead[] = {
            "head",1,"neck1",1,"neck",1,
            "RightShoulder", 1, "RightArm", 1, "RightArmRoll", 1, "RightForeArm", 1, "RightForeArmRoll", 1, "RightHand", 1, 
            "RightHandThumb1", 1, "RightHandThumb2", 1, "RightHandThumb3", 1,
            "RightHandIndex1", 1, "RightHandIndex2", 1, "RightHandIndex3", 1, 
            "RightHandMiddle1", 1, "RightHandMiddle2", 1, "RightHandMiddle3", 1, 
            "RightHandRing", 1, "RightHandRing1", 1, "RightHandRing2", 1, "RightHandRing3", 1, 
            "RightHandPinky1", 1, "RightHandPinky2", 1, "RightHandPinky3", 1
        };
        rightArm[] = {
            "RightShoulder", 1, "RightArm", 1, "RightArmRoll", 1, "RightForeArm", 1, "RightForeArmRoll", 1, "RightHand", 1, 
            "RightHandThumb1", 1, "RightHandThumb2", 1, "RightHandThumb3", 1,
            "RightHandIndex1", 1, "RightHandIndex2", 1, "RightHandIndex3", 1, 
            "RightHandMiddle1", 1, "RightHandMiddle2", 1, "RightHandMiddle3", 1, 
            "RightHandRing", 1, "RightHandRing1", 1, "RightHandRing2", 1, "RightHandRing3", 1, 
            "RightHandPinky1", 1, "RightHandPinky2", 1, "RightHandPinky3", 1
        };
        leftArm[] = {
            "LeftShoulder", 1, "LeftArm", 1, "LeftArmRoll", 1, "LeftForeArm", 1, "LeftForeArmRoll", 1, "LeftHand", 1, 
            "LeftHandThumb1", 1, "LeftHandThumb2", 1, "LeftHandThumb3", 1,
            "LeftHandIndex1", 1, "LeftHandIndex2", 1, "LeftHandIndex3", 1, 
            "LeftHandMiddle1", 1, "LeftHandMiddle2", 1, "LeftHandMiddle3", 1, 
            "LeftHandRing", 1, "LeftHandRing1", 1, "LeftHandRing2", 1, "LeftHandRing3", 1, 
            "LeftHandPinky1", 1, "LeftHandPinky2", 1, "LeftHandPinky3", 1
        };
        leftArmSpine[] = {
            "LeftShoulder", 1, "LeftArm", 1, "LeftArmRoll", 1, "LeftForeArm", 1, "LeftForeArmRoll", 1, "LeftHand", 1, 
            "LeftHandThumb1", 1, "LeftHandThumb2", 1, "LeftHandThumb3", 1,
            "LeftHandIndex1", 1, "LeftHandIndex2", 1, "LeftHandIndex3", 1, 
            "LeftHandMiddle1", 1, "LeftHandMiddle2", 1, "LeftHandMiddle3", 1, 
            "LeftHandRing", 1, "LeftHandRing1", 1, "LeftHandRing2", 1, "LeftHandRing3", 1, 
            "LeftHandPinky1", 1, "LeftHandPinky2", 1, "LeftHandPinky3", 1,
            "neck", 1, "neck1", 1, "head", 1, "Spine", 1, "Spine1", 1, "Spine2", 1, "Spine3", 1, "pelvis", "MaskStart"
        };
        leftArmHead[] = {
            "LeftShoulder", 1, "LeftArm", 1, "LeftArmRoll", 1, "LeftForeArm", 1, "LeftForeArmRoll", 1, "LeftHand", 1, 
            "LeftHandThumb1", 1, "LeftHandThumb2", 1, "LeftHandThumb3", 1,
            "LeftHandIndex1", 1, "LeftHandIndex2", 1, "LeftHandIndex3", 1, 
            "LeftHandMiddle1", 1, "LeftHandMiddle2", 1, "LeftHandMiddle3", 1, 
            "LeftHandRing", 1, "LeftHandRing1", 1, "LeftHandRing2", 1, "LeftHandRing3", 1, 
            "LeftHandPinky1", 1, "LeftHandPinky2", 1, "LeftHandPinky3", 1,
            "neck", 0.5, "MaskStart"
        };
        bothArmsSpine[] = {
            "RightShoulder", 1, "RightArm", 1, "RightArmRoll", 1, "RightForeArm", 1, "RightForeArmRoll", 1, "RightHand", 1, 
            "RightHandThumb1", 1, "RightHandThumb2", 1, "RightHandThumb3", 1,
            "RightHandIndex1", 1, "RightHandIndex2", 1, "RightHandIndex3", 1, 
            "RightHandMiddle1", 1, "RightHandMiddle2", 1, "RightHandMiddle3", 1, 
            "RightHandRing", 1, "RightHandRing1", 1, "RightHandRing2", 1, "RightHandRing3", 1, 
            "RightHandPinky1", 1, "RightHandPinky2", 1, "RightHandPinky3", 1,
            "LeftShoulder", 1, "LeftArm", 1, "LeftArmRoll", 1, "LeftForeArm", 1, "LeftForeArmRoll", 1, "LeftHand", 1, 
            "LeftHandThumb1", 1, "LeftHandThumb2", 1, "LeftHandThumb3", 1,
            "LeftHandIndex1", 1, "LeftHandIndex2", 1, "LeftHandIndex3", 1, 
            "LeftHandMiddle1", 1, "LeftHandMiddle2", 1, "LeftHandMiddle3", 1, 
            "LeftHandRing", 1, "LeftHandRing1", 1, "LeftHandRing2", 1, "LeftHandRing3", 1, 
            "LeftHandPinky1", 1, "LeftHandPinky2", 1, "LeftHandPinky3", 1,
            "neck", 1, "neck1", 1, "head", 1, "Spine", 1, "Spine1", 1, "Spine2", 1, "Spine3", 1, "pelvis", "MaskStart"
        };
        bothArms[] = {
            "RightShoulder", 1, "RightArm", 1, "RightArmRoll", 1, "RightForeArm", 1, "RightForeArmRoll", 1, "RightHand", 1, 
            "RightHandThumb1", 1, "RightHandThumb2", 1, "RightHandThumb3", 1,
            "RightHandIndex1", 1, "RightHandIndex2", 1, "RightHandIndex3", 1, 
            "RightHandMiddle1", 1, "RightHandMiddle2", 1, "RightHandMiddle3", 1, 
            "RightHandRing", 1, "RightHandRing1", 1, "RightHandRing2", 1, "RightHandRing3", 1, 
            "RightHandPinky1", 1, "RightHandPinky2", 1, "RightHandPinky3", 1,
            "LeftShoulder", 1, "LeftArm", 1, "LeftArmRoll", 1, "LeftForeArm", 1, "LeftForeArmRoll", 1, "LeftHand", 1, 
            "LeftHandThumb1", 1, "LeftHandThumb2", 1, "LeftHandThumb3", 1,
            "LeftHandIndex1", 1, "LeftHandIndex2", 1, "LeftHandIndex3", 1, 
            "LeftHandMiddle1", 1, "LeftHandMiddle2", 1, "LeftHandMiddle3", 1, 
            "LeftHandRing", 1, "LeftHandRing1", 1, "LeftHandRing2", 1, "LeftHandRing3", 1, 
            "LeftHandPinky1", 1, "LeftHandPinky2", 1, "LeftHandPinky3", 1
        };
        bothArmsHead[] = {
            "RightShoulder", 1, "RightArm", 1, "RightArmRoll", 1, "RightForeArm", 1, "RightForeArmRoll", 1, "RightHand", 1, 
            "RightHandThumb1", 1, "RightHandThumb2", 1, "RightHandThumb3", 1,
            "RightHandIndex1", 1, "RightHandIndex2", 1, "RightHandIndex3", 1, 
            "RightHandMiddle1", 1, "RightHandMiddle2", 1, "RightHandMiddle3", 1, 
            "RightHandRing", 1, "RightHandRing1", 1, "RightHandRing2", 1, "RightHandRing3", 1, 
            "RightHandPinky1", 1, "RightHandPinky2", 1, "RightHandPinky3", 1,
            "LeftShoulder", 1, "LeftArm", 1, "LeftArmRoll", 1, "LeftForeArm", 1, "LeftForeArmRoll", 1, "LeftHand", 1, 
            "LeftHandThumb1", 1, "LeftHandThumb2", 1, "LeftHandThumb3", 1,
            "LeftHandIndex1", 1, "LeftHandIndex2", 1, "LeftHandIndex3", 1, 
            "LeftHandMiddle1", 1, "LeftHandMiddle2", 1, "LeftHandMiddle3", 1, 
            "LeftHandRing", 1, "LeftHandRing1", 1, "LeftHandRing2", 1, "LeftHandRing3", 1, 
            "LeftHandPinky1", 1, "LeftHandPinky2", 1, "LeftHandPinky3", 1,
            "neck", 0.9, "MaskStart"
        };
        readyPistol[] = {
            "RightShoulder", 1, "RightArm", 1, "RightArmRoll", 1, "RightForeArm", 1, "RightForeArmRoll", 1, "RightHand", 1, 
            "LeftShoulder", 1, "LeftArm", 1, "LeftArmRoll", 1, "LeftForeArm", 1, "LeftForeArmRoll", 1, "LeftHand", 1
        };
        readyPistolSpine[] = {
            "RightShoulder", 1, "RightArm", 1, "RightArmRoll", 1, "RightForeArm", 1, "RightForeArmRoll", 1, "RightHand", 1, 
            "LeftShoulder", 1, "LeftArm", 1, "LeftArmRoll", 1, "LeftForeArm", 1, "LeftForeArmRoll", 1, "LeftHand", 1,
            "neck", 1, "neck1", 1, "head", 1, "Spine", 1, "Spine1", 1, "Spine2", 1, "Spine3", 1, "pelvis", "MaskStart"
        };
        weapon[] = {"weapon", 1};
        weaponSpine[] = {"weapon", 1, "neck", 1, "neck1", 1, "Spine", 1, "Spine1", 0.1};	
        weaponLeftArm[] = {
            "weapon", 1,
            "LeftShoulder", 1, "LeftArm", 1, "LeftArmRoll", 1, "LeftForeArm", 1, "LeftForeArmRoll", 1, "LeftHand", 1, 
            "LeftHandThumb1", 1, "LeftHandThumb2", 1, "LeftHandThumb3", 1,
            "LeftHandIndex1", 1, "LeftHandIndex2", 1, "LeftHandIndex3", 1, 
            "LeftHandMiddle1", 1, "LeftHandMiddle2", 1, "LeftHandMiddle3", 1, 
            "LeftHandRing", 1, "LeftHandRing1", 1, "LeftHandRing2", 1, "LeftHandRing3", 1, 
            "LeftHandPinky1", 1, "LeftHandPinky2", 1, "LeftHandPinky3", 1
        };
        weaponLeftArmHead[] = {
            "weapon", 1,
            "LeftShoulder", 1, "LeftArm", 1, "LeftArmRoll", 1, "LeftForeArm", 1, "LeftForeArmRoll", 1, "LeftHand", 1, 
            "LeftHandThumb1", 1, "LeftHandThumb2", 1, "LeftHandThumb3", 1,
            "LeftHandIndex1", 1, "LeftHandIndex2", 1, "LeftHandIndex3", 1, 
            "LeftHandMiddle1", 1, "LeftHandMiddle2", 1, "LeftHandMiddle3", 1, 
            "LeftHandRing", 1, "LeftHandRing1", 1, "LeftHandRing2", 1, "LeftHandRing3", 1, 
            "LeftHandPinky1", 1, "LeftHandPinky2", 1, "LeftHandPinky3", 1,
            "neck", 0.5, "MaskStart"
        };
        upperTorsoWeak[] = {
            "neck", 1, "neck1", 1, "Spine", 1, "Spine1", 0.1,
            "RightShoulder", 1, "RightArm", 1, "RightArmRoll", 1, "RightForeArm", 1, "RightForeArmRoll", 1, "RightHand", 1, 
            "LeftShoulder", 1, "LeftArm", 1, "LeftArmRoll", 1, "LeftForeArm", 1, "LeftForeArmRoll", 1, "LeftHand", 1
        };

    };
};

class ctrlStatic;
class Cfg3DEN {  //-- I WANT BIGGER CODING BOXES
    class Attributes {
        class Default;
        class Title: Default {class Controls {class Title;};};
        class Edit: Title {class Controls: Controls {class Title; class Value;};};
        class EditMulti3: Edit {class Controls: Controls {class Background; class Title; class Value;};};
        class EditMulti5: EditMulti3 {
            h = "6 * 5 * (pixelH * pixelGrid * 0.50)";
            class Controls: Controls {
                class Background: Background {h = "5.1 * 5 * (pixelH * pixelGrid * 0.50)";};
                class Title: Title {h = "5.5 * 5 * (pixelH * pixelGrid * 0.50)";};
                class Value: Value {h = "4.5 * 5 * (pixelH * pixelGrid * 0.50)";};
            };
        };
        class EditCodeMulti3: EditMulti3 {
            h = "57.5 * (pixelH * pixelGrid * 0.50)";
            class Controls: Controls {
                class Background: Background {h = "55.5 * (pixelH * pixelGrid * 0.50)";};
                class Title: Title {h = "57.5 * (pixelH * pixelGrid * 0.50)";};
                class Value: Value {h = "52.5 * (pixelH * pixelGrid * 0.50) - (pixelH * pixelGrid * 0.50)";};
            };
        };
        class EditCodeMulti5: EditMulti5 {
            h = "75 * (pixelH * pixelGrid * 0.50)";
            class Controls: Controls {
                class Background: Background {h = "73 * (pixelH * pixelGrid * 0.50)";};
                class Title: Title {h = "75 * (pixelH * pixelGrid * 0.50)";};
                class Value: Value {h = "69 * (pixelH * pixelGrid * 0.50)";};
            };
        };
    };
};
