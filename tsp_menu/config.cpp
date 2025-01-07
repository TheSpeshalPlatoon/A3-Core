class CfgPatches {
	class tsp_menu {
		requiredAddons[] = {"A3_Map_Altis", "A3_Map_Enoch", "A3_Map_Malden", "A3_Map_Stratis", "A3_Map_Tanoabuka", "A3_Map_VR"};
		units[] = {};
	};
};

//-- FUNCTIONS
class CfgFunctions {class tsp_menu {class functions {class init {file = "tsp_menu\init.sqf"; postInit = true;};};};};

//-- MUSIC
class CfgMusic {
	class thisIsWar_8bit {name = "ArmA - This is War (8-Bit)"; sound[] = {"tsp_menu\snd\thisIsWar_8bit.ogg", db - 4, 1.0};};
	class thisIsWar_apex {name = "ArmA - This is War (APEX Remix)"; sound[] = {"tsp_menu\snd\thisIsWar_apex.ogg", db + 0, 1.0};};
	class thisIsWar_metal {name = "ArmA - This is War (Metal Cover)"; sound[] = {"tsp_menu\snd\thisIsWar_metal.ogg", db + 0, 1.0};};
	class thisIsWar_marksman {name = "ArmA - This is War (Marksman Remix)"; sound[] = {"tsp_menu\snd\thisIsWar_marksman.ogg", db + 0, 1.0};};
	class noTime {name = "DENOI - No Time"; sound[] = {"tsp_menu\snd\noTime.ogg", db + 0, 1.0};};
	class unknownEnemy {name = "ArmA - An Unknown Enemy"; sound[] = {"tsp_menu\snd\unknownEnemy.ogg", db + 0, 1.0};};
	class intoTheSun {name = "DENOI - Into The Sun"; sound[] = {"tsp_menu\snd\intoTheSun.ogg", db + 0, 1.0};};
};

//-- MAIN MENU
class RscStandardDisplay;
class RscControlsGroupNoScrollbars;
class RscControlsGroupNoHScrollbars;
class RscDisplayMain: RscStandardDisplay {
	class controls {
		//-- REMOVE SPOTLIGHTS
		class Spotlight1 {};
		class Spotlight2 {};
		class Spotlight3 {};
		class SpotlightNext {};
		class SpotlightPrev {};
		class BackgroundSpotlightRight {};
		class BackgroundSpotlightLeft {};
		class BackgroundSpotlight {};

		//-- ADD LINKS TO BOTTOM RIGHT
		class InfoMods: RscControlsGroupNoHScrollbars {class Controls;};
        class InfoNews: InfoMods {
            class Controls: Controls {
                class Background;
                class BackgroundIcon;
                class Icon;
                class News;
                class Button;
            };
        };
		class tsp_menu_website: InfoNews {
            idc = 81090; y = "safezoneY + safezoneH - (3 * 2 + 1) * (pixelH * pixelGrid * 2) - 4 * (4 * pixelH)";
            class Controls: Controls {
                class Background: Background {};
                class BackgroundIcon: BackgroundIcon {};
                class Icon: Icon {text = "\tsp_menu\gui\tsp.paa";};
                class CurrentVersionInfo: News {text = "Website";};
                class Button: Button {tooltip = "Visit the TSP Website:"; url = "https://thespeshalplatoon.com";};
            };
        };
		class tsp_menu_teamspeak: InfoNews {
            idc = 81091; y = "safezoneY + safezoneH - (4 * 2 + 1) * (pixelH * pixelGrid * 2) - 5 * (4 * pixelH)";
            class Controls: Controls {
                class Background: Background {};
                class BackgroundIcon: BackgroundIcon {};
                class Icon: Icon {text = "\tsp_menu\gui\ts.paa";};
                class CurrentVersionInfo: News {text = "Teamspeak";};
                class Button: Button {tooltip = "Connect to the TSP TeamSpeak:"; url = "ts3server://ts.thespeshalplatoon.com";};
            };
        };

		//-- ADD SERVER JOIN BUTTONS UNDER MULTIPLAYER
		class GroupSingleplayer: RscControlsGroupNoScrollbars {class Controls;};
		class GroupMultiplayer: GroupSingleplayer {
			h = "(6 *   1.5) * (pixelH * pixelGrid * 2)";
			class Controls: Controls {
				class ApexProtocol;
				class tsp_menu_asia1: ApexProtocol {
					text = "TSP Asia 1"; tooltip = "asia.thespeshalplatoon.com:2302";
					//onButtonClick = "connectToServer ['asia.thespeshalplatoon.com', 2302, 'password']";
					onButtonClick = "[_this, 'asia.thespeshalplatoon.com', '2302', 'password'] execVM '\tsp_menu\kk_connect.sqf';";
				 	y = "(3 * 1.5) * (pixelH * pixelGrid * 2) + (pixelH)";
				};
				class tsp_menu_asia2: tsp_menu_asia1 {
					text = "TSP Asia 2"; tooltip = "asia.thespeshalplatoon.com:2312";
					onButtonClick = "connectToServer ['asia.thespeshalplatoon.com', 2302, 'password']";
				 	y = "(4 * 1.5) * (pixelH * pixelGrid * 2) + (pixelH)";
				};
				class tsp_menu_eu: tsp_menu_asia1 {
					text = "TSP EU"; tooltip = "eu.thespeshalplatoon.com:2302";
					onButtonClick = "connectToServer ['eu.thespeshalplatoon.com', 2302, 'password']";
				 	y = "(5 * 1.5) * (pixelH * pixelGrid * 2) + (pixelH)";
				};
			};
		};
	};
};