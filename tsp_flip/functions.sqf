tsp_fnc_flip_torque = {
    params ["_unit", "_veh", "_numberOfFlippers", ["_liftableMassUnit", tsp_cba_flip_liftable], ["_quantityExponent", tsp_cba_flip_exponent], ["_playersNeeded", tsp_cba_flip_players]];
    _massRequired = getMass _veh;                                                   //-- systemChat ("Required:" + str _massRequired);
    _massWeCanLift = _liftableMassUnit * (_numberOfFlippers ^ _quantityExponent);  //-- systemChat ("We Can lift:" + str _massWeCanLift);  
    _massToUse = _massWeCanLift min _massRequired;                                //-- Cap it at vehicle mass so we dont send it to the moon
    if (_numberOfFlippers >= _playersNeeded) then {_massToUse = _massRequired};  //-- If we have enough ppl, then we should flip the whole way
    _veh addTorque (_unit vectorModelToWorld [_massToUse^1.25, 0, 0]);          //-- _mass^1.25 will flip all vehicles evenly, most of the time        
};

tsp_fnc_flip_action = {
    params ["_unit", "_veh", ["_end", time + 2], ["_og", _this#1 getVariable ["numberOfFlippers", 0] == 0]];
    _veh setVariable ["numberOfFlippers", (_veh getVariable ["numberOfFlippers", 0]) + 1, true];
    [_unit, "tsp_flip"] remoteExec ["playMove", 0];
    waitUntil {animationState _unit == "tsp_flip" || time > _end}; sleep 1.5;  //-- Time to add more flippers
    [_unit, "amovpknlmstpsnonwnondnon"] remoteExec ["playMoveNow", 0];
    if (!_og) exitWith {};
    [[_unit, _veh, _veh getVariable "numberOfFlippers"], tsp_fnc_flip_torque] remoteExec ["call", _veh];
    _veh setVariable ["numberOfFlippers", 0, true];
};