["tsp_param_role", "CHECKBOX", "Role Selection", "", ["TSP Core", "Mission"], true] call tsp_fnc_setting;
["tsp_param_roleStart", "CHECKBOX", "Role Selection on Start", "", ["TSP Core", "Mission"], true] call tsp_fnc_setting;
["tsp_param_roleCheck", "CHECKBOX", "Role Gear Checking", "", ["TSP Core", "Mission"], false] call tsp_fnc_setting;

tsp_fnc_role = {  //-- Open the role selection screen
	params [["_force", false], ["_factions", missionNameSpace getVariable ["tsp_roles", getMissionConfigValue "tsp_roles"]], ["_display", findDisplay 46 createDisplay "RscDisplayEmpty"]];
	if (_force && count _factions > 0) then {_display displayAddEventHandler ["KeyDown", {_this#1 == 1 && !(_this#3)}]; titleCut ["", "BLACK OUT", 0.01]};  //-- Prevent ESC

	_factions = (_factions select {call compile (_x#2)});  //-- Only show roles where condition is true
	_offset = (0.0375 * (count _factions max 8)) + 0.0375;
	_width = 0.075 * (count _factions max 8);  //-- Total width of menu based on number of available factions

	_title = _display ctrlCreate ["RscText", 9998]; _h = 0.042; _y = 0.6; _title ctrlSetPosition [(1.0-_width)*0.5,((1.0-_h)*0.5)-_y,_width,_h];
	_title ctrlSetFont "PuristaMedium"; _title ctrlSetText "ROLE SELECTION"; _title ctrlSetBackgroundColor [11/100,50/100,20/100,0.9]; _title ctrlCommit 0;	
	
	_box = _display ctrlCreate ["RscText", 9998]; _h = 0.1; _y = 0.525; _box ctrlSetPosition [(1.0-_width)*0.5,((1.0-_h)*0.5)-_y,_width,_h];
	_box ctrlSetBackgroundColor [0,0,0,0.7]; _box ctrlCommit 0;
	
	tsp_role_roles = []; 
	tsp_role_trees = []; 
	tsp_role_pictures = [];

	{  //-- Create tree, picture and invisible button for each faction, hide all but the first
		_x params ["_name", "_icon", "_side", "_children"]; 
		
		_offset = _offset - 0.075;  //-- Move it along so faction icons are next to eachother
		
		_picture = _display ctrlCreate ["RscPicture", -1]; _w = 0.051; _h = 0.07; _y = 0.525; _picture ctrlSetPosition [((1.0-_w)*0.5)-_offset,((1.0-_h)*0.5)-_y,_w,_h];
		_picture ctrlSetText _icon; _picture ctrlSetFade (if (_forEachIndex == 0) then {0} else {0.5}); _picture ctrlCommit 0; tsp_role_pictures pushBack _picture;

		_button = _display ctrlCreate ["tsp_invisible", 9998]; _w = 0.061; _h = 0.08; _y = 0.525; _button ctrlSetPosition [((1.0-_w)*0.5)-_offset,((1.0-_h)*0.5)-_y,_w,_h];
		_button ctrlSetBackgroundColor [0,0,0,0]; _button ctrlSetTooltip _name; _button ctrlCommit 0;
		_button ctrlAddEventHandler ["buttonClick", {
			params ["_control", ["_tree", _this#0 getVariable "tree"], ["_picture", _this#0 getVariable "picture"]]; 
			{_x ctrlSetFade 0.5; _x ctrlCommit 0} forEach tsp_role_pictures; _picture ctrlSetFade 0; _picture ctrlCommit 0;  //-- Picture opacity
			{_x ctrlShow false; _x tvSetCurSel [-1]} forEach tsp_role_trees; _tree ctrlShow true;                           //-- Hide/show trees
		}];

		_tree = _display ctrlCreate ["tsp_treeview", 9998]; _h = 1.05; _y = -0.053; _tree ctrlSetPosition [(1.0-_width)*0.5,((1.0-_h)*0.5)-_y,_width,_h];
		_tree ctrlSetBackgroundColor [0,0,0,0.7]; _tree ctrlShow (_forEachIndex == 0); _tree ctrlCommit 0; tsp_role_trees pushBack _tree;
		{[_tree, _x, [], _name, _name] call tsp_fnc_role_recursive} forEach _children; tvExpandAll _tree;  //-- Populate the tree with groups and roles

		_button setVariable ["tree", _tree]; _button setVariable ["picture", _picture];  //-- Needed so buttonClick handler above cant access these variables
	} forEach _factions;

	_button = _display ctrlCreate ["RscButtonMenu", 9998]; _h = 0.042; _y = -0.602; _button ctrlSetPosition [(1.0-_width)*0.5,((1.0-_h)*0.5)-_y,_width,_h];
	_button ctrlSetText "CONTINUE"; _button ctrlSetFont "PuristaLight"; _button ctrlEnable false; _button ctrlCommit 0;
	_button setVariable ["display", _display]; _button ctrlAddEventHandler ["buttonClick", {params ["_control"]; _control getVariable "display" closeDisplay 1}];

	while {_display isNotEqualTo displayNull} do {{_x call tsp_fnc_role_poll} forEach tsp_role_roles; if (player getVariable ["role", ""] != "") then {_button ctrlEnable true}};
	if (_force) then {titleCut ["", "BLACK IN", 3]};
};

tsp_fnc_role_recursive = {  //-- Constucts the actual treeview with the groups and units, also populates tsp_role_roles
	params ["_tree", "_item", ["_parent", []], ["_parentName", ""], ["_faction", ""], ["_index", 0]];
	if (count _item == 3) then {  //-- If item is a category
		_item params ["_name", "_icon", "_children"];
		_branch = _tree tvAdd [_parent, _name]; _tree tvSetPicture [_parent+[_branch], if ("marker" in _icon) then {"\A3\ui_f\data\map\"+_icon} else {_icon}]; 
		if ("marker" in _icon) then {_tree tvSetPictureColor [_parent+[_branch], [playerSide] call BIS_fnc_sideColor]};
		{[_tree, _x, _parent+[_branch], _name, _faction, _forEachIndex] call tsp_fnc_role_recursive} forEach _children;
	} else {  //-- If item is a role
		_item params ["_name", "_loadout", "_arsenal", "_icon", ["_code", ""], ["_uid", (_faction+_parentName+(_item#0)+(str count tsp_role_roles)) regexReplace [" ",""]]]; 
		if (_index == 0) then {tsp_role_leader = _uid};  //-- Make first unit leader, global var for next recursion
		_leaf = _tree tvAdd [_parent, _name]; _tree tvSetPicture [_parent+[_leaf], "\A3\ui_f\data\map\vehicleicons\"+_icon];
		tsp_role_roles pushBack [_tree, _parent+[_leaf], _name, _loadout, _arsenal, _code, _uid, tsp_role_leader, _parentName];
	};
};

tsp_fnc_role_poll = {  //-- Select role if available and is currently selected, also other poll stuff
	params ["_tree", "_leaf", "_name", "_loadout", "_arsenal", "_code", "_roleId", "_leadId", "_parentName"];
	if (tvCurSel _tree isEqualTo _leaf && [_roleId, _leadId] call tsp_fnc_role_available) then {  //-- If selected and available
		missionNameSpace setVariable [player getVariable ["role", "doesntmatterwhatshere"], nil, true];  //-- Set current role (if any) to unnoccupied
		missionNameSpace setVariable [_roleId, getPlayerUID player, true];  //-- Assign new role
		player setVariable ["role", _roleId, true];  //-- Just for reference to get player role
		{[player, _x, true] call tsp_fnc_faction} forEach (if (typeName _loadout == "STRING") then {[_loadout]} else {_loadout});  //-- To support multiple different unit fallbacks
		tsp_arsenal = [player, _arsenal] call tsp_fnc_role_arsenal;
		if (_code != "") then {player call compile _code};
		_groups = allGroups select {groupId _x == _parentName}; 
		if (count _groups > 0) exitWith {[player] join (_groups#0); ["AddGroupMember", [_groups#0, player]] remoteExec ["BIS_fnc_dynamicGroups", 0]};
		_group = createGroup [playerSide, true]; _group setGroupIdGlobal [_parentName]; [player] join _group;
		["RegisterGroup", [_group, leader _group, [nil, _parentName, false]]] remoteExec ["BIS_fnc_dynamicGroups", 0];
		_group spawn {sleep 2; _this setVariable ["BIS_dg_ins", [player] call BIS_fnc_getUnitInsignia, true]; {["OnPlayerGroupChanged", [_x, _this]] call BIS_fnc_dynamicGroups} forEach units _this}
	};
	_tree tvSetText [_leaf, _name+(if ([_roleId, _roleId] call tsp_fnc_role_available) then {""} else {" ["+name(missionNameSpace getVariable _roleId call BIS_fnc_getUnitByUID)+"]"})];  //-- If occupied
	_tree tvSetColor [_leaf, [1,1,1, if ([_roleId, _leadId] call tsp_fnc_role_available) then {1} else {0.5}]];  //-- Opacity based on availability
};

tsp_fnc_role_available = {  //-- Check if fole is available
	params ["_roleId", "_leadId", ["_occupant", missionNameSpace getVariable [_this#0, ""] call BIS_fnc_getUnitByUID], ["_leader", missionNameSpace getVariable [_this#1, ""] call BIS_fnc_getUnitByUID]];
	if (_occupant in (allPlayers+playableUnits) && _occupant getVariable ["role", ""] isEqualTo _roleId) exitWith {false};  //-- Occupied
	if (_roleId != _leadId && !(_leader in (allPlayers+playableUnits) && _leader getVariable ["role", ""] isEqualTo _leadId)) exitWith {false};  //-- No leader
	true
};

tsp_fnc_role_arsenal = {  //-- [player, ["soc_raider","west_leader","myGun"]] call tsp_fnc_role_arsenal;
	params ["_unit", ["_data", []], ["_data1", []], ["_data2", []], ["_data3", []], ["_data4", []]];  //-- _data1, _data2, data3 and _data4 - poor man's recursion
	{if ("ACE" in _x) then {_data3 pushBack _x; continue}; _data1 = _data1+(missionNameSpace getVariable [_x, getMissionConfigValue [_x, [_x]]])} forEach _data;    //-- If _x is variable/config, get data, else just add the item [_x]
	{if ("ACE" in _x) then {_data3 pushBack _x; continue}; _data2 = _data2+(missionNameSpace getVariable [_x, getMissionConfigValue [_x, [_x]]])} forEach _data1;  //-- If _x is variable/config, get data, else just add the item [_x]
	{if ("ACE" in _x) then {_data3 pushBack _x; continue}; _data3 = _data3+(missionNameSpace getVariable [_x, getMissionConfigValue [_x, [_x]]])} forEach _data2; //-- If _x is variable/config, get data, else just add the item [_x]
	{if ("ACE" in _x) then {_data4 pushBack _x; continue}; _data4 = _data4+(missionNameSpace getVariable [_x, getMissionConfigValue [_x, [_x]]])} forEach _data3; //-- If _x is variable/config, get data, else just add the item [_x]
	flatten _data4;
};

tsp_fnc_role_check = {  //-- Gear restriction
	params ["_unit", ["_distance", 50], ["_arsenal", missionNameSpace getVariable ["tsp_arsenal", []]]];
	if (hmd _unit != "" && [headgear _unit] call tsp_fnc_hitpoint_armor < 1 && !isNil "tsp_fnc_blood_helmet") then {
		[_unit, false, [-0.1,-0.7,1], "", hmd _unit, "", [[0,0,0], [0,0,0]]] call tsp_fnc_blood_helmet;
	};
	if (tsp_param_roleCheck) then {
		if !(((primaryWeaponItems _unit)#2) in _arsenal) then {_unit removePrimaryWeaponItem ((primaryWeaponItems _unit)#2); systemchat "Removed Attachment."};  //-- Scopes
		if !(uniform _unit in _arsenal) then {removeUniform _unit; systemchat "Removed Uniform."};  //-- Uniform			
		if !(vest _unit in _arsenal) then {removeVest _unit; systemchat "Removed Vest."};          //-- Vest
		if (([[_unit] call BIS_fnc_getRespawnPositions, _unit] call BIS_fnc_nearestPosition) distance _unit > _distance) then {continue};
		if !(hmd _unit in _arsenal) then {_unit unassignItem (hmd _unit); _unit removeItem (hmd _unit); systemchat "Removed NVG."};   //-- NVGs			
		if !(primaryWeapon _unit in _arsenal) then {_unit removeWeapon (primaryWeapon _unit); systemchat "Removed Weapon."};         //-- Weapon		
		if !(secondaryWeapon _unit in _arsenal) then {_unit removeWeapon (secondaryWeapon _unit); systemchat "Removed Launcher."};  //-- Rocket
		if !(handgunWeapon _unit in _arsenal) then {_unit removeWeapon (handgunWeapon _unit); systemchat "Removed Pistol."};       //-- Pistol		
		if !(binocular _unit in _arsenal) then {_unit removeweapon (binocular _unit); systemchat "Removed Binoculars."};          //-- Binoculars
		if !(headgear _unit in _arsenal) then {removeHeadgear _unit; systemchat "Removed Headgear."};                            //-- Headgear
		if !(goggles _unit in _arsenal) then {removeGoggles _unit; systemchat "Removed Facewear."};                             //-- Facewear	
		if !(backpack _unit in _arsenal) then {removeBackpack _unit; systemchat "Removed Restricted Backpack."};               //-- Backpack
	};	
};

tsp_fnc_role_vehicle = {  //-- Vehicle restriction
	params ["_vehicle", ["_condition", {true}]]; _vehicle setVariable ["role_condition", _condition];
	_vehicle addEventHandler ["GetIn", {
		params ["_vehicle", "_role", "_unit", "_turret"];
		if (_role != "driver" || (_unit call (_vehicle getVariable "role_condition"))) exitWith {};
		moveOut _x; "You are not allowed to operate this vehicle." remoteExec ["systemChat", _unit];
	}];
};

if (isServer) then {["Initialize", [true]] call BIS_fnc_dynamicGroups};
waitUntil {!isNull (findDisplay 46)};
{player addEventHandler [_x, {params ["_unit"]; [_unit] call tsp_fnc_role_check}]} forEach ["Take", "Put", "InventoryClosed", "InventoryOpened"];
[missionNamespace, "arsenalClosed", {[_unit] call tsp_fnc_role_check}] call BIS_fnc_addScriptedEventHandler;
if (hasInterface) then {["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups};