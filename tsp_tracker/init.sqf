//-- Create bluforce chat
if (isServer) then {tsp_tracker_chat = radioChannelCreate [[0.25, 0.5, 0.8, 1], "Bluforce", "%UNIT_GRP_NAME", [], false]; publicVariable "tsp_tracker_chat"};
addMissionEventHandler ["Map", {params ["_mapIsOpened"]; if (_mapIsOpened) then {[player] call tsp_fnc_tracker_poll}}];  //-- Update on opening map 
while {sleep tsp_cba_tracker_poll; tsp_cba_tracker_poll > 0} do {[player] call tsp_fnc_tracker_poll};                   //-- Auto update