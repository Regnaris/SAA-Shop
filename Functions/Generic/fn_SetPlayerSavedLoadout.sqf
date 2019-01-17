/*
	Author: Hadwig

	Description:
	Execute SetPlayerSavedLoadout DLL function. Need to be executed on server (because of server-side-only dll)

	Parameter(s):
	0: STRING - player SteamID
    1: ARRAT - player current loadout in getUnitLoadout/setUnitLoadout format

	Returns:
	Nothing
*/

params["_uid", "_gear"];

profileNamespace setVariable [format ["SAA_loadout_%1", _uid], _gear];

//Return
true