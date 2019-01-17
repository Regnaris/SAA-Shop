/*
	Author: Borland

	Description:
	Calculate total cost of given loadout;

	Parameter(s):
	0: STRING - player SteamID
    1: ARRAY of STRINGS - player new loadout in array format

	Returns:
	BOOL - all of OLD items exist in NEW loadout.
*/

params ["_uid, _loadoutList"];
_uid = _this select 0;
_list = [] + _this select 1;
_costList = [];
cost = 0;
{
	cost =  cost + parseNumber([_x, _uid] call Shadec_fnc_GetItemPrice);
	_costList pushBack cost;
} forEach _list;

//Return
cost