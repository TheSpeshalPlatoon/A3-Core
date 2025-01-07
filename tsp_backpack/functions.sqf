tsp_fnc_backpack_swap = {
	params ["_unit"]; [backpack _unit, _unit getVariable ["tsp_chestpack", []]] params ["_backpack", "_chestpack"];

	//-- Backpack to chestpack
	if (_backpack isNotEqualTo "") then {
		_model = createSimpleObject [_backpack, [0,0,0]];
		_model attachTo [_unit, [0,0,-0.5], "Spine3", true];
		[_model, [180,0,0]] call BIS_fnc_setObjectRotation;
		_unit setVariable ["tsp_chestpack", [_backpack, backpackItems _unit, _model]];
		removeBackpack _unit;
		_unit forceWalk true;
	} else {_unit setVariable ["tsp_chestpack", []]; _unit forceWalk false};
	
	//-- Chestpack to backpack
	if (_chestpack isNotEqualTo []) then {
		_chestpack params ["_class", "_items", "_model"];
		_unit addBackpack _class;
		{_unit addItemToBackpack _x} forEach _items;
		deleteVehicle _model;
	};

	[5, 2, 5] spawn tsp_fnc_shake;
	_unit playAction "Gear";
};