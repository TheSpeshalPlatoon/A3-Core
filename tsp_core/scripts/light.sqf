["tsp_param_brightness", "SLIDER", "Brighter Night", "", "TSP Light", [0,10,0.3], {if (isServer) then {[] call tsp_fnc_light_night}}] call tsp_fnc_setting;
["tsp_cba_light_shaft", "SLIDER", "Light Shafts", "", "TSP Light", [0,5,1], {"LightShafts" ppEffectAdjust [0.1*tsp_cba_light_shaft,0.5*tsp_cba_light_shaft,0.5*tsp_cba_light_shaft,0.9*tsp_cba_light_shaft]}] call tsp_fnc_setting;
["tsp_cba_light_muzzle", "SLIDER", "Muzzle Flash Brightness", "How intense muzzle flashes are.", "TSP Light", [0, 10, 0.07]] call tsp_fnc_setting;
["tsp_cba_light_tracer", "SLIDER", "Tracer Brightness", "How intense tracers are.", "TSP Light", [0, 3, 0.3], {}, false] call tsp_fnc_setting;

["tsp_cba_light_flare_intensity", "SLIDER", "Brightness", "How intense the flare is.", ["TSP Light", "Flare"], [0, 1000000, 200000]] call tsp_fnc_setting;
["tsp_cba_light_flare_fluctuation", "SLIDER", "Fluctuation", "How much the intensity fluctuates over time.", ["TSP Light", "Flare"], [0, 1000000, 100000]] call tsp_fnc_setting;
["tsp_cba_light_flare_altitude", "SLIDER", "Cutoff Altitude", "Kill flare when this close to the ground.", ["TSP Light", "Flare"], [10, 100, 10]] call tsp_fnc_setting;
["tsp_cba_light_flare_size", "SLIDER", "Size", "Size of the lens flare.", ["TSP Light", "Flare"], [0, 1000, 10]] call tsp_fnc_setting;
["tsp_cba_light_flare_distance", "SLIDER", "Distance", "How far the lens flare can been seen from.", ["TSP Light", "Flare"], [0, 12000, 8000]] call tsp_fnc_setting;
["tsp_cba_light_flare_time", "SLIDER", "Time", "How long the flare will last in seconds.", ["TSP Light", "Flare"], [0, 600, 240]] call tsp_fnc_setting;
["tsp_cba_light_flare_velocity", "SLIDER", "Velocity", "How slowly the flare descends.", ["TSP Light", "Flare"], [0, 10, 10]] call tsp_fnc_setting;
["tsp_cba_light_flare_jitter", "SLIDER", "Jitter", "Flare movement in air.", ["TSP Light", "Flare"], [0, 10, 1]] call tsp_fnc_setting;
["tsp_cba_light_flare_sound", "CHECKBOX", "Sound", "Enables pop and burning sounds.", ["TSP Light", "Flare"], true] call tsp_fnc_setting;

tsp_fnc_light_night = {  //-- tsp_param_brightness = 1; [] call tsp_fnc_light_night;
	params [["_brightness", tsp_param_brightness], ["_colour", [0.5,0.7,1]]];
	if (isNil "tsp_night_light") then {tsp_night_light = "#lightpoint" createVehicle [0,0,0]};  //-- Initial call only
	tsp_night_light setLightAttenuation [1e+011,150,4.31918e-005,4.31918e-005];
	tsp_night_light setLightBrightness _brightness; 
	tsp_night_light setLightDayLight false;
	tsp_night_light setLightAmbient _colour;
};

tsp_fnc_light_flare = {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle", ["_timeStop", time + tsp_cba_light_flare_time], ["_altitudeStop", tsp_cba_light_flare_altitude]];
	if (getNumber(configFile >> 'CfgAmmo' >> (typeOf _projectile) >> 'brightness') < 10) exitWith {}; sleep 3;
	if (tsp_cba_light_flare_sound && local _projectile) then {playSound3D [tsp_path + "data\sounds\pop.ogg", _projectile, false, getPosASL _projectile, 3, 1, 5000]};
	if (tsp_cba_light_flare_sound && local _projectile) then {_projectile spawn {while {sleep 10; alive _this} do {playSound3D [tsp_path + "data\sounds\burn.ogg", _this, false, getPosASL _this, 1, 1, 50]}}};

	_fake = createVehicleLocal ["Land_PencilGreen_F", getPos _projectile, [], 0, "CAN_COLLIDE"]; _projectile attachTo [_fake, [0,0,0]];	
	getArray(configFile >> "CfgAmmo" >> typeOf _projectile >> "lightColor") params ["_r","_g","_b","_a"];;
	_light = "#lightpoint" createVehicleLocal [0,0,0]; _light attachTo [_fake, [0, 0, 0]]; 
	_light setLightAmbient [_r,_g,_b]; _light setLightColor [_r,_g,_b];	_light setLightUseFlare true; 
	_light setLightFlareMaxDistance tsp_cba_light_flare_distance; _light setLightFlareSize tsp_cba_light_flare_size;

	if ((getPos _fake)#2 < _altitudeStop) then {_altitudeStop = -1};  //-- Dont kill flare if shot straight at ground
	while {sleep 0.1 + random 0.1; time < _timeStop && (getPos _fake)#2 > _altitudeStop} do {
		_fake setVelocity [random selectRandom [tsp_cba_light_flare_jitter, -tsp_cba_light_flare_jitter], random selectRandom [tsp_cba_light_flare_jitter], -tsp_cba_light_flare_velocity]; 
		_light setLightIntensity tsp_cba_light_flare_intensity + random tsp_cba_light_flare_fluctuation;
	};

	{if (!isNull _x) then {_x setPos [0,0,0]; deleteVehicle _x}} forEach [_projectile, _fake, _light];  //-- Set pos to stop/move the sound instantly
};

tsp_fnc_light_muzzle = {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
	if (getNumber (configFile >> "CfgWeapons" >> (_unit weaponAccessories currentWeapon _unit)#0 >> "ItemInfo" >> "soundTypeIndex") == 1) exitWith {};
	_barrel = (ASLtoATL eyePos _unit vectorAdd ((_unit weaponDirection (currentWeapon _unit)) vectorMultiply 2)) vectorAdd [0, 0, -0.1];
	_light = "#lightpoint" createVehicleLocal _barrel; _light setLightColor [1,0.8,0.5]; _light setLightAmbient [1,0.8,0.5];
	_light setLightBrightness (if ((_unit weaponAccessories currentWeapon _unit)#0 != "") then {tsp_cba_light_muzzle/1.5} else {tsp_cba_light_muzzle}); 
	sleep 0.1; deleteVehicle _light;
};

tsp_fnc_light_tracer_old = {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle", ["_colour", [1,0.3,0.3]]];	sleep 0.01;
	_every = getNumber (configFile >> "CfgMagazines" >> _magazine >> "tracersEvery");
  	_last = getNumber (configFile >> "CfgMagazines" >> _magazine >> "lastRoundsTracer");
	if (_every + _last == 0) exitWith {};
	if !(((_unit ammo currentWeapon _unit) + 1) <= _last || (_every > 0 && {((_unit ammo currentWeapon _unit) + 1) mod _every == 0})) exitWith {};
	if ("yellow" in toLower str _projectile) then {_colour = [1,1,0.3]};
	if ("green" in toLower str _projectile) then {_colour = [0.3,1,0.3]};
	_light = "#lightpoint" createVehicleLocal (getPos _projectile); _light attachTo [_projectile, [0,0,0]]; _light setLightColor _colour; _light setLightAmbient _colour; 
	_light setLightUseFlare true; _light setLightFlareSize 1; _light setLightFlareMaxDistance 1000; _light setLightBrightness tsp_cba_light_tracer; _light setLightDayLight false;
	_end = time + getNumber (configFile >> "CfgAmmo" >> _ammo >> "tracerEndTime");
	waitUntil {!alive _projectile || time > _end}; deleteVehicle _light;
};

tsp_fnc_light_tracer = {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle", ["_colour", [1,0.3,0.3]]];	sleep 0.01;  
	_every = getNumber (configFile >> "CfgMagazines" >> _magazine >> "tracersEvery");
  	_last = getNumber (configFile >> "CfgMagazines" >> _magazine >> "lastRoundsTracer");
	if (_every + _last == 0) exitWith {};
	_multiplier = getNumber (configFile >> "CfgWeapons" >> _weapon >> "multiplier");
	_count = (_unit ammo _muzzle) + _multiplier;
	_mod = if (_every > 0) then {_count mod _every} else {-1};
	_condition = if (_mod != -1) then {_mod == (_last mod _every)} else {false};
	if !(_condition || _every == 1 || _count <= _last) exitWith {};
	if ("yellow" in toLower str _projectile) then {_colour = [1,1,0.3]};
	if ("green" in toLower str _projectile) then {_colour = [0.3,1,0.3]};
	_caliber = getNumber (configFile >> "CfgAmmo" >> _ammo >> "caliber");
	_light = "#lightpoint" createVehicleLocal (getPos _projectile); _light attachTo [_projectile, [0,0,0]]; _light setLightColor _colour; _light setLightAmbient _colour; 
	_light setLightUseFlare true; _light setLightFlareSize 1; _light setLightFlareMaxDistance 1000; _light setLightBrightness (tsp_cba_light_tracer*(_caliber min 1.5)); _light setLightDayLight false;
	_end = time + getNumber (configFile >> "CfgAmmo" >> _ammo >> "tracerEndTime");
	waitUntil {!alive _projectile || time > _end}; deleteVehicle _light;
};

addMissionEventHandler ["EntityCreated", {params ["_entity"]; if (tsp_cba_light_muzzle > 0) then {_entity addEventHandler ["Fired", {_this spawn tsp_fnc_light_muzzle}]}}];
addMissionEventHandler ["EntityCreated", {params ["_entity"]; if (tsp_cba_light_tracer > 0) then {_entity addEventHandler ["Fired", {_this spawn tsp_fnc_light_tracer}]}}];
addMissionEventHandler ["EntityCreated", {params ["_entity"]; if (tsp_cba_light_flare_intensity > 0) then {_entity addEventHandler ["Fired", {_this spawn tsp_fnc_light_flare}]}}];

[] spawn {waitUntil {isDedicated || !isNull (findDisplay 46)}; [] call tsp_fnc_light_night};

//ai fullauto
//smoke launchers
//flares
//muzzle
//tracers
//explosions
//150Rnd_762x54_Box
["aimpoint","footstepr","footstepl","rightfoot","leftfoot","aiming_axis","spine3","weapon","head_axis","pilot","head","rearm","rearm2","granat","righthandmiddle1","granat2","lefthandmiddle1","camera","lelbow","lwrist","relbow","rwrist","rfemur","lfemur","lknee","rknee","rankle","lankle","lelbow_axis","relbow_axis","rknee_axis","lknee_axis","righthand","lefthand","launcher","neck","pelvis","leaning_axis","leftshoulder","rightshoulder","leftforearm","rightforearm","leftforearmroll","rightforearmroll","proxy:\a3\characters_f\proxies\weapon.001","proxy:\a3\characters_f\proxies\pistol.001","proxy:\a3\characters_f\proxies\binoculars.001","proxy:\a3\characters_f\proxies\launcher.001","bubbleseffect","bubblesdir","water_surface","leftupleg","leftleg","rightupleg","rightleg"]