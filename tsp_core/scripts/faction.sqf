["tsp_param_faction", "CHECKBOX", "Faction", "Scripted faction loadouts", "TSP Core", false] call tsp_fnc_setting;

tsp_fnc_faction = {  //-- Check if type exists in CfgLoadouts and apply it
	params ["_unit", "_loadout", ["_force", false], ["_anim", animationState (_this#0)]];
	if (!isNil "BIS_fnc_arsenal_center" || !isNil "ace_arsenal_center") exitWith {};  //-- Dont apply to arsenal when new unit created (like in 3DEN)
	if (!_force && (_unit getVariable ["saved3DENInventory", false] || _unit get3DENAttribute 'ReceiveRemoteTargets' isEqualTo [true] || vehicleReceiveRemoteTargets _unit)) exitWith {};  //-- Dont overwrite custom loadouts
	
	_loadout = missionNamespace getVariable [_loadout, [configfile >> "CfgLoadouts" >> _loadout, "", [missionConfigFile >> _loadout, "", ""] call BIS_fnc_returnConfigEntry] call BIS_fnc_returnConfigEntry];
	if (_loadout != "") then {_unit setUnitLoadout (_unit call compile _loadout)}; 
	if (_force && _loadout == "" && isClass (configFile >> "CfgVehicles" >> (_this#1))) then {_unit setUnitLoadout (_this#1)};
	_goggles = goggles _unit;

	if ("NoVoice" in getArray (configFile >> "CfgVehicles" >> typeOf _unit >> "identityTypes")) then {_unit spawn {sleep 0.1; _this setSpeaker "NoVoice"}};  //-- Force NoVoice
	if (_loadout != "") then {[_unit, _goggles] spawn {sleep 0.1; (_this#0) addGoggles (_this#1)}};  //-- Force add goggles
	if (is3DEN && _loadout != "" && vehicle _unit == _unit) then {_unit switchMove _anim};  //-- Set anim as setUnitLoadout resets anim
};

if (is3DEN && tsp_param_faction) then {[missionNamespace, 'arsenalPreOpen', {(_this#1) set3DENAttribute ['ReceiveRemoteTargets', true]}] call BIS_fnc_addScriptedEventHandler};  //-- If loadout edited, set flag so it doesn't get changed back
if (is3DEN && tsp_param_faction) then {["ace_arsenal_displayOpened", {ace_arsenal_center set3DENAttribute ['ReceiveRemoteTargets', true]}] call CBA_fnc_addEventHandler};
if (isServer && tsp_param_faction) then {addMissionEventHandler ["EntityCreated", {params ["_unit"]; if (_unit isKindOf "CAManBase") then {[_unit, typeOf _unit] call tsp_fnc_faction}}]};
if (isServer && tsp_param_faction) then {{[_x, typeOf _x] call tsp_fnc_faction} forEach (allUnits select {!isPlayer _x})};
[] spawn {waitUntil {!isNull (findDisplay 46) && time > 1}; if (tsp_param_faction) then {[player, typeOf player] call tsp_fnc_faction}};  //-- I dont even fucking know, fuck arma's cancer initialization BS