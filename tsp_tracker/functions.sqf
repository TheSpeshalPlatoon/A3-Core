tsp_fnc_tracker_get = {
	params ["_unit"];
	_trackers = (assignedItems _unit) select {getNumber (configFile >> "CfgWeapons" >> _x >> "distance") > 0};
	if (count _trackers > 0) exitWith {_trackers#0}; ""
};

tsp_fnc_tracker_trackable = {
	params ["_unit"];
	if ([_unit] call tsp_fnc_tracker_get == "") exitWith {false};
	if (_unit getVariable ["tsp_tracker_trackable", false]) exitWith {true};
	if (!isPlayer _unit) exitWith {true};
	false
};

tsp_fnc_tracker_marker = {
	params ["_unit", "_text"];
	_marker = createMarkerLocal [str _unit, position _unit];
	_marker setMarkerColorLocal ([side _unit, true] call BIS_fnc_sideColor);  //-- Set color to unit side
	_marker setMarkerTextLocal _text;
	_marker setMarkerTypeLocal (switch (true) do {
		case (vehicle _unit isKindOf "Car"): {"b_mech_inf"};   
		case (vehicle _unit isKindOf "Tank"): {"b_armor"};   
		case (vehicle _unit isKindOf "Ship"): {"b_naval"};    
		case (vehicle _unit isKindOf "Helicopter"): {"b_air"};   
		case (vehicle _unit isKindOf "Plane"): {"b_plane"};   
		default {"b_inf"};
	});
	_marker
};

tsp_fnc_tracker_poll = {
	params ["_unit"]; if (isNil "tsp_tracker_markers") then {tsp_tracker_markers = []}; 
	_tracker = [_unit] call tsp_fnc_tracker_get;
	_distance = getNumber (configFile >> "CfgWeapons" >> _tracker >> "distance");
	if (_tracker == "") exitWith {tsp_tracker_chat radioChannelRemove [_unit]};  //-- Exit if no tracker, and remove radio channel
	if !(_unit in ((radioChannelInfo tsp_tracker_chat)#3)) then {tsp_tracker_chat radioChannelAdd [_unit]};  //-- Add unit to bluforce chat if not in it
	{deleteMarkerLocal _x} forEach tsp_tracker_markers; tsp_tracker_markers = [];  //-- Delete all markers
	
	{  //-- Vehicles
		_trackableUnitsInVehicle = (crew _x) select {[_x] call tsp_fnc_tracker_trackable};  //-- Get all units in vehicle with tracker
		if (count _trackableUnitsInVehicle > 0) then {	
			_text = "";
			{  //-- Construct marker text with multiple groups
				if (_forEachIndex > 0) then {_text = _text + " + "};
				_text = _text + (groupID group _x);	
			} forEach _trackableUnitsInVehicle;
			_marker = [_x, _text] call tsp_fnc_tracker_marker;  //-- Create marker
			tsp_tracker_markers pushBack _marker;  //-- Add marker to marker array to be deleted later
		};
	} forEach (vehicles select {(side _x getFriend side _unit) > 0.6 && (_x distance _unit) < _distance && count crew _x > 0});
	
	{  //-- Infantry
		_marker = [_x, groupID group _x] call tsp_fnc_tracker_marker;  //-- Create marker
		tsp_tracker_markers pushBack _marker;   //-- Add marker to marker array to be deleted later
	} forEach ((_unit nearEntities [["CAManBase"], _distance]) select {(side _x getFriend side _unit) > 0.6 && [_x] call tsp_fnc_tracker_trackable && vehicle _x == _x});
};