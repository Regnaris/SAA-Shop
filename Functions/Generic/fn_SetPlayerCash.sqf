/*
	Author: Hadwig

	Description:
	Sets player cash in server profile namespace

	Parameter(s):
	0: STRING - player SteamID
    1: NUMBER - new player cash value

	Returns:
	Nothing
*/

params["_uid", "_cash"];

profileNamespace setVariable [format ["SAA_cash_%1", _uid], _cash];

//Return
true