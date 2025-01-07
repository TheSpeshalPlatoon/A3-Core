tsp_fnc_medical_open = {
    params ["_unit", "_item", "_contents", ["_self", player]]; if ([_self, _item, true] call BIS_fnc_hasItem) then {_unit = _self};  //-- Open mine first before opening others    
    switch (_item) do {  //-- Play zip/rip sound depending on item, and also garbage
        case "tsp_ifak": {playSound3D ["tsp_medical\snd\rip.ogg", _unit, false, getPosASL _unit, 4.9, 1, 20]; [getPos _unit, ["MedicalGarbage_01_FirstAidKit_F"]] call tsp_fnc_decal};
        case "firstaidkit": {playSound3D ["tsp_medical\snd\zip.ogg", _unit, false, getPosASL _unit, 4.9, 1, 20]; [getPos _unit, ["MedicalGarbage_01_FirstAidKit_F"]] call tsp_fnc_decal};
        default {playSound3D ["tsp_medical\snd\zip.ogg", _unit, false, getPosASL _unit, 4.9, 1, 20]};  //-- Just zip for medikit
    };
    _unit removeItem _item; _self playAction "Gear";  //-- Remove it and play animation
    //-- If fits, then add to backpack, else, put anywhere
    {_x params ["_item", "_amount"]; for "_i" from 1 to _amount do {if (_unit canAddItemToBackpack _item) then {_unit addItemToBackpack _item} else {_unit addItem _item}}} forEach _contents;
};

tsp_fnc_medical_hit = {
    params ["_unit", "_damage", "_instigator", "_type"]; if (missionNameSpace getVariable ["ace_medical_disabled", false]) exitWith {};

    [([headgear _unit] call tsp_fnc_hitpoint_armor) > 5, ([vest _unit] call tsp_fnc_hitpoint_armor) > 5] params ["_helmet", "_vest"];
	(_unit getVariable ["ace_medical_bodyPartDamage", [0,0,0,0,0,0]]) params ["_headT","_torsoT","_armLT","_armRT","_legLT","_legRT"];
    _head = if (count (_damage select {_x#1 == "Head"}) > 0) then {(_damage select {_x#1 == "Head"})#0#0} else {0};  //-- Impulse damage
    _torso = if (count (_damage select {_x#1 == "Body"}) > 0) then {(_damage select {_x#1 == "Body"})#0#0} else {0};  //-- Impulse damage
    _armL = if (count (_damage select {_x#1 == "LeftArm"}) > 0) then {(_damage select {_x#1 == "LeftArm"})#0#0} else {0};  //-- Impulse damage
    _armR = if (count (_damage select {_x#1 == "RightArm"}) > 0) then {(_damage select {_x#1 == "RightArm"})#0#0} else {0};  //-- Impulse damage
    _legL = if (count (_damage select {_x#1 == "LeftLeg"}) > 0) then {(_damage select {_x#1 == "LeftLeg"})#0#0} else {0};  //-- Impulse damage
    _legR = if (count (_damage select {_x#1 == "RightLeg"}) > 0) then {(_damage select {_x#1 == "RightLeg"})#0#0} else {0};  //-- Impulse damage

    if (_helmet && _head > 0.1 && _head < 2) then {_headT = _headT + tsp_cba_medical_helmet};  //-- If has helmet and shot in the head, add more damage (Cause they are OP)
    if (_vest && _torso > 0.1 && _torso < 2) then {_torsoT = _torsoT + tsp_cba_medical_vest};  //-- If has vest and shot in the torso, add more damage (Cause they are OP)
    
    if (_headT > tsp_cba_medical_total_head) exitWith {_unit setDamage 1};  //-- Total Death
    if (_torsoT > tsp_cba_medical_total_torso) exitWith {_unit setDamage 1};  //-- Total Death
    if ((_armLT+_armRT+_legLT+_legRT) > tsp_cba_medical_total_limbs) exitWith {_unit setDamage 1};  //-- Total Death
    if (_head > tsp_cba_medical_impulse_head) exitWith {_unit setDamage 1};  //-- Impulse Death
    if (_torso > tsp_cba_medical_impulse_torso) exitWith {_unit setDamage 1};  //-- Impulse Death
    if ((_armL+_armR+_legL+_legR) > tsp_cba_medical_impulse_limbs) exitWith {_unit setDamage 1};  //-- Impulse Death
    
    //systemChat ("TOTAL > HEAD: " + str _headT + " > TORSO: " + str _torsoT + " > LIMBS: " + str (_armLT+_armRT+_legLT+_legRT));
    //systemChat ("IMPULSE > HEAD: " + str _head + " > TORSO: " + str _torso + " > LIMBS: " + str (_armL+_armR+_legL+_legR));
};

tsp_fnc_medical_wake = {
    sleep 3; (uiNamespace getVariable 'ace_common_dlgDisableMouse') displayAddEventHandler ['KeyDown', {
        params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
        if !(_key == 57 && (lifeState _x == "UNCONSCIOUS" || _x getVariable ["ACE_isUnconscious", false])) exitWith {};
        if (isNil "tsp_medical_firstTap") exitWith {[] spawn {tsp_medical_firstTap = true; sleep 0.3; tsp_medical_firstTap = nil}};  //-- Double tap
        if (time - tsp_medical_last < tsp_cba_medical_wake_spam) exitWith {}; tsp_medical_last = time; 
        if (random 1 < tsp_cba_medical_wake_chance) then {[name playa, "Waking Up..."] spawn tsp_fnc_hint; [playa] spawn tsp_fnc_wake} else {[name playa, "Trying to wake up..."] spawn tsp_fnc_hint};
    }];
};