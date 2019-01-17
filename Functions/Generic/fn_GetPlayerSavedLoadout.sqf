/*
	Author: Hadwig

	Description:
	Gets player loadout form server profileNamespace and broadcast it in missionNamespace

	Parameter(s):
	0: STRING - player SteamID

	Returns:
	STRING - player saved loadout in getUnitLoadout/setUnitLoadout format
*/

params["_uid"];

_gear = profileNamespace getVariable [format["SAA_loadout_%1", _uid], str(getUnitLoadout "B_Survivor_F")];
missionNamespace setVariable [format["SAA_loadout_%1", _uid], _gear, true];