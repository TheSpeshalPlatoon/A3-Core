tsp_fnc_sector_automate = {
	{
		if !(triggerText _x in getMissionLayers) then {continue};
		[triggerText _x] call tsp_fnc_sector_save;
		_x setTriggerActivation [triggerActivation _x#0, triggerActivation _x#1, true];
		_x setTriggerStatements [triggerStatements _x#0 + " && isServer", "['" + triggerText _x + "'] call tsp_fnc_sector_load", "['" + triggerText _x + "'] call tsp_fnc_sector_save"];
	} forEach allMissionObjects "EmptyDetector";
};

tsp_fnc_sector_save = {	
	params ["_layer", ["_sectorData", []]];	

	{_x setVariable ["layer", _layer]} foreach (getMissionLayerEntities _layer#0);  //-- Set variable on each object
	{{_x setVariable ["layer", "!"]} foreach (getMissionLayerEntities _x#0)} foreach (getMissionLayers select {"!" in _x});  //-- !Exceptions

	if (tsp_sector_info findIf {_x#0 == _layer} == -1) then {tsp_sector_info pushBack [_layer, true]};  //-- If sector not in tsp_sector_info, add it
	if (count (tsp_sector_info select {_x#0 == _layer && _x#1}) == 0) exitWith {};  //-- CANT SAVE CAUSE ITS NOT LOADED
	tsp_sector_info set [tsp_sector_info findIf {_x#0 == _layer}, [_layer, false]]; publicVariable "tsp_sector_info";  //-- Set status to false

	_entities = allMissionObjects "All" select {_x getVariable "layer" == _layer && alive _x && vehicle _x == _x};
	if !("@" in _layer) then {{_sectorData pushback ([_x] call tsp_fnc_sector_saveEntity)} foreach _entities};
	if !("@" in _layer) then {{{deletevehicle _x} forEach crew _x; deletevehicle _x} foreach _entities};
	if ("@" in _layer) then {{_return = [_x, simulationEnabled _x]; _x enableSimulation false; _x hideObjectGlobal true; _sectorData pushback _return} foreach _entities};  //-- Simple layers

	missionNamespace setVariable ["layer_" + _layer, _sectorData];  //-- Create variable named after sector and save data to sector variable
};

tsp_fnc_sector_load = {
	params ["_layer", ["_force", false]];
	if ((count (tsp_sector_info select {_x#0 == _layer && _x#1}) > 0) && !_force) exitWith {};  //-- CANT LOAD CAUSE IT ALREADY EXISTS
	if !("@" in _layer) then {{[_x, objNull, objNull, _layer] call tsp_fnc_sector_loadEntity} forEach (missionNameSpace getVariable "layer_" + _layer)};  //-- Create stuffs, reassign layer variable
	if ("@" in _layer) then {{_x params ["_unit", "_sim"]; _unit enableSimulation _sim; _unit hideObjectGlobal false} forEach (missionNameSpace getVariable "layer_" + _layer)};  //-- Simple layers
	tsp_sector_info set [tsp_sector_info findIf {_x#0 == _layer}, [_layer, true]]; publicVariable "tsp_sector_info";  //-- Set status to true
};

tsp_fnc_sector_saveEntity = {
	params ["_entity", ["_seatData", []], ["_crewData", []]];
	{  //-- For all live crew
		_x params ["_unit", "_role", "_cargoIndex", "_turretIndex"];
		_crewData pushback ([_unit, [_role, _cargoIndex, _turretIndex]] call tsp_fnc_sector_saveEntity);
	} forEach ((fullCrew _entity) select {alive (_x#0)});
	private _entityData = [
		typeOf _entity,                   					      //-- 0:  Classname
		getPosWorld _entity,                   					  //-- 1:  Position
		[vectorDir _entity, vectorUp _entity],  				  //-- 2:  Direction
		simulationEnabled _entity,       					      //-- 3:  Simulation
		isDamageAllowed _entity,                                  //-- 4:  Damage
		damage _entity,                                           //-- 5:  Health
		getUnitLoadout _entity,                                   //-- 6:  Loadout
		unitPos _entity,                                          //-- 7:  Stance
		group _entity,									          //-- 8:  Group
		leader group _entity == _entity,                          //-- 9:  Leader?
		_entity getVariable ["init", {}],                         //-- 10: Init Code
		behaviour _entity,                                        //-- 11: Behaviour
		getAllHitPointsDamage _entity,                            //-- 12: Hitpoints
		[_entity] call BIS_fnc_getVehicleCustomization,           //-- 13: Vehicle Appearence
		locked _entity,                                           //-- 14: Vehicle Locks
		getPylonMagazines _entity,                                //-- 15: Vehicle Pylons
		_entity ammo (currentWeapon _entity),                     //-- 16: Vehicle Ammo
		fuel _entity,                                             //-- 17: Vehicle Fuel
		face _entity,                                             //-- 18: Face
		speaker _entity,                                          //-- 19: Voice
		name _entity,                                             //-- 20: Name
		vehicleVarName _entity,                                   //-- 21: Variable
		_seatData,                                                //-- 22: Seat
		_crewData                                                 //-- 23: Crew
	];
	_entityData
};

tsp_fnc_sector_loadEntity = {
	params ["_entityData", ["_vehicle", objNull], ["_entity", objNull], ["_layer", ""]];
	_entityData params ["_classname", "_position", "_direction", "_simulation", "_damage", "_health", "_loadout", "_stance", "_group", "_leader", "_init", "_behaviour", "_hitpoints", "_vehicleAppearence", "_vehicleLock", "_vehiclePylons", "_vehicleAmmo", "_vehicleFuel", "_face", "_voice", "_name", "_varName", "_seatData", "_crewData"];

	if (_classname isKindOf "Man") then {  //-- For dudes
		if (_group isEqualTo grpNull) then {_group = createGroup ([east,west,resistance,civilian]#getNumber (configFile >> "CfgVehicles" >> _classname >> "side"))};  //-- In case group deleted somehow
		_entity = _group createUnit [_classname, [0,0,0], [], 0, "CAN_COLLIDE"];
		_entity enableSimulation false;
		_entity allowDamage false;
		_entity setUnitPos _stance;
		_entity setBehaviour _behaviour;
		_entity setSpeaker _voice;
		_entity setName _name;
		[_entity, _face] remoteExec ["setFace", 0, _entity];
		[_entity, _loadout] spawn {sleep 0.5; _this#0 setUnitLoadout _this#1};  //-- Sleep so that this loadout overwrites any other script that sets loadout (like faction.sqf)
		if (_leader) then {_entity spawn {sleep 3; group _this selectLeader _this}};  //-- Sleep cause group members may not exist
		if ("Garrison" in groupId group _entity) then {_entity disableAI "PATH"};
		if ("Civilian" in groupId group _entity) then {doStop _entity};
	} else {  //-- For vehicles
		_entity = createVehicle [_classname, [0,0,0], [], 0, "NONE"]; 
		_entity enableSimulation false; 
		_entity allowDamage false;
		{_entity setPylonLoadout ["pylon"+str (_forEachIndex+1), _x]} forEach _vehiclePylons;
		[_entity, _vehicleAppearence#0, _vehicleAppearence#1] call BIS_fnc_initVehicle;
		_entity lock _vehicleLock;
		//_entity setVehicleAmmo _vehicleAmmo;  //-- This dont work right, idk why
		_entity setFuel _vehicleFuel;
		_entity spawn {sleep 3; if (speed _this < 1) then {_this call tsp_fnc_sector_vehicle}};  //-- Sleep so that this doesnt run if it doesnt need to
	};	
	[_entity, _simulation, _damage] spawn {sleep 0.1; (_this#0) enableSimulation (_this#1); sleep 0.1; (_this#0) allowDamage (_this#2)};  //-- Sleep so that vehicle doesnt fucking explode
	
	//-- Shared Properties (Dudes and vehicles)
	_entity setDamage _health;
	_entity setVectorDirAndUp _direction;
	_entity setPosWorld _position;  //-- So That We Get That 100% Placement Accuracy Boii
	{_entity setHitPointDamage [_x, (_hitpoints#2) select _forEachIndex]} forEach (_hitpoints#0);  //-- Set health
	if (_varName != "") then {missionNamespace setVariable [_varName, _entity, true]};
	_entity setVariable ["init", _init];  //-- Return init code to unit so we can take it again later
	_entity spawn _init;  //-- Run init code

	//-- Passengers and drivers and stuff
	if (_seatData isNotEqualTo []) then {
		_seatData params ["_role", "_cargoIndex", "_turretPath"];
		if (_role == "driver") then {_entity moveInDriver _vehicle}; 
		if (_role == "commander") then {_entity moveInCommander _vehicle};
		if (_role == "gunner") then {_entity moveInGunner _vehicle};
		if (_role in ["turret", "Turret"]) then {_entity moveInTurret [_vehicle, _turretPath]};
		if (_role == "cargo") then {_entity moveInCargo [_vehicle, _cargoIndex]};
	};
	if (_crewData isNotEqualTo []) then {{[_x, _entity, objNull, _layer] call tsp_fnc_sector_loadEntity} foreach _crewData};	

	_entity setVariable ["layer", _layer];
	_entity  //-- Return Unit Variable Name
};

tsp_fnc_sector_variable = {if (missionNameSpace getVariable [_this, objNull] isEqualTo objNull) then {tsp_debug} else {missionNameSpace getVariable _this}};
tsp_fnc_sector_check = {(tsp_sector_info select {_x#0 == _this})#0#1};
tsp_fnc_sector_vehicle = {_grp = group driver _this; _grp addWaypoint [getPosWorld _this, 999, 0]; _grp copyWaypoints _grp; deleteWaypoint [_grp, 0]; _grp copyWaypoints _grp};
tsp_fnc_sector_vehicle2 = {_grp = group driver _this; _wp = _grp addWaypoint [position _this, 2, 0]; _wp setWaypointType "GETOUT"; _wp = _grp addWaypoint [position _this, 2, 1]; _wp setWaypointType "GETIN NEAREST"};
tsp_fnc_sector_clear = {  //-- ["sector_airfield_gate_close", "", sector_airfield_gate_close] call tsp_fnc_sector_clear
	params ["_sector", ["_layer", ""], ["_trigger", objNull], ["_distance", 0], ["_amount", 0], ["_sides", [independent, east]]]; if !(_sector call tsp_fnc_sector_check) exitWith {false};
	count (allUnits select {(_layer == "" || _x getVariable ["layer", ""] == _layer) && ((_distance == 0 && _x inArea _trigger) || (_x distance _trigger < _distance)) && (side _x in _sides)}) <= _amount
};

if (isNil "tsp_sector_info") then {tsp_sector_info = []};  //-- Dont initialize when JIP
{missionNameSpace setVariable [("sector_"+triggerText _x), _x, true]} forEach allMissionObjects "EmptyDetector";  //-- Name all triggers sector_x

waitUntil {isDedicated || !isNull (findDisplay 46)};

if (isServer) then {isNil {call tsp_fnc_sector_automate}};  //-- Only server can create sectors, isNil because must be unscheduled sleep for scripts to run on units/objects before saving
player addEventHandler ["GetInMan", {params ["_unit", "_role", "_vehicle"]; _vehicle setVariable ["layer", nil, true]}];  //-- Legitimate salvage