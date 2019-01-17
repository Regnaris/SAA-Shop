/*
	Author: Hadwig

	Description:
	Broadcast player cash to missionNamespace

	Parameter(s):
	0: STRING - player SteamID

	Returns:
	NUMBER - player cash
*/

params["_uid"];
private "_cash";

// Get cash from profileNamespace on server with default 0
_cash = profileNamespace getVariable [format["SAA_cash_%1", _uid], 99];
diag_log format ["[SAA] Cash from profile namespace %1", _cash];

//Assign to mission namespace and broadcast
missionNamespace setVariable [format["SAA_cash_%1", _uid], _cash, true];