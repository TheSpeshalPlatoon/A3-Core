tsp_fnc_menu_music = {sleep 1.5; _song = selectRandom _this; playMusic _song; titleText ["\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" + (getText(configFile >> 'CfgMusic' >> _song >> 'name')), "PLAIN", 4]};

tsp_fnc_menu_slides = {
	params ["_slides", ["_slidesCut", []], ["_slideUse", []]]; waitUntil {time > 0}; //-- _slidesCut will be edited, _slides will remain unedited
	#include "\a3\Missions_F_Tacops\Functions\fn_TO_AnimatedOpening.inc"
	while {true} do {
		if (count _slidesCut == 0) then {_slidesCut = +_slides; _slidesCut deleteAt (_slidesCut findIf {_x isEqualTo _slideUse});};
		_slideUse = selectRandom _slidesCut; tsp_slideUse = _slideUse;      //-- Needs to be big boy variable cause bis_fnc_animatedScreen is stinky
		_slidesCut deleteAt (_slidesCut findIf {_x isEqualTo _slideUse});  //-- Delete last used slide, to make sure they dont repeat
		[[
			[0,{
				[MODE_BLACKIN,2,false] call bis_fnc_animatedScreen;
				[MODE_LAYER_CREATE,1,(tsp_slideUse#0),nil,nil,1] call bis_fnc_animatedScreen;
				[MODE_LAYER_CREATE,2,(tsp_slideUse#1),nil,nil,1] call bis_fnc_animatedScreen;
				[MODE_LAYER_ANIMATE,1,8,nil,1.1] call bis_fnc_animatedScreen;
				[MODE_LAYER_ANIMATE,2,8,nil,1.2] call bis_fnc_animatedScreen;
			}],
			[6,{[MODE_BLACKOUT,2,false] call bis_fnc_animatedScreen}],
			[8,{[MODE_RESET,[true,true]] call bis_fnc_animatedScreen}]
		], 0, ""] spawn BIS_fnc_animatedOpening;
		waitUntil {sleep 1; !(missionNamespace getVariable ["BIS_fnc_eventTimeline_playing", true])};  //-- Wait until slide is over
	};
};

if !(allDisplays isEqualTo [findDisplay 0]) exitWith {};  //-- If not main menu, exit
tsp_menu_tracks = ["thisIsWar_8bit", "thisIsWar_apex", "thisIsWar_metal", "thisIsWar_marksman", "noTime", "unknownEnemy", "intoTheSun"];
tsp_menu_images = [
	["\tsp_menu\img\01_b.paa", "\tsp_menu\img\01_f.paa"], ["\tsp_menu\img\02_b.paa", "\tsp_menu\img\02_f.paa"],
	["\tsp_menu\img\03_b.paa", "\tsp_menu\img\03_f.paa"], ["\tsp_menu\img\04_b.paa", "\tsp_menu\img\04_f.paa"],
	["\tsp_menu\img\05_b.paa", "\tsp_menu\img\05_f.paa"], ["\tsp_menu\img\06.paa", "\tsp_menu\img\06.paa"],
	["\tsp_menu\img\07.paa", "\tsp_menu\img\07.paa"], ["\tsp_menu\img\08.paa", "\tsp_menu\img\08.paa"],
	["\tsp_menu\img\09.paa", "\tsp_menu\img\09.paa"], ["\tsp_menu\img\10.paa", "\tsp_menu\img\10.paa"],
	["\tsp_menu\img\11.paa", "\tsp_menu\img\11.paa"]
];
//if (isClass (configFile >> "CfgPatches" >> "a2_burke")) then {};  //-- WW2
tsp_menu_tracks spawn tsp_fnc_menu_music; addMusicEventHandler ["MusicStop", {tsp_menu_tracks spawn tsp_fnc_menu_music}];
[tsp_menu_images] spawn tsp_fnc_menu_slides;