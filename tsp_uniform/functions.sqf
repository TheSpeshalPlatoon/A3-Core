tsp_fnc_uniform_steal = {
    params ["_unit", "_target"];
    [uniform _unit, uniformItems _unit, uniform _target, uniformItems _target] params ["_unitUniform", "_unitItems", "_targetUniform", "_targetItems"];  //-- Get details early so we can use them later
    
    _unit playAction "PlayerCrouch"; sleep 0.5; _unit playAction "Gear";  //--   //-- Crouch animation, then gear animation

    //-- Drop _unit uniform and add items back
    _ground = createVehicle ["GroundWeaponHolder", getPosATL _unit, [], 0, "CAN_COLLIDE"];
    _ground addItemCargoGlobal [_unitUniform, 1];
    _uniformOnFloor = ((everyContainer _ground)#0)#1;
    {_uniformOnFloor addItemCargoGlobal [_x, 1]} forEach _unitItems;
    removeUniform _unit; removeUniform _target;
    
    _unit forceAddUniform _targetUniform; {_unit addItemToUniform _x} forEach _targetItems;  //-- Give _unit targets's uniform annd add items back
};