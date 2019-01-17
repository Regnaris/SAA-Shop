/*
	Author: Borland

	Description:
	Comparing two loadouts: NEW and OLD to prevent situation, when player replace item in inventory in arsenal and get full refund.
	Function find all OLD items in NEW, if they exist = player buy in addition, if not all of them = trying to selling.

	Parameter(s):
	0: ARRAY of ARRAYS - player old loadout in array format
    1: ARRAY of ARRAYS - player new loadout in array format

	Returns:
	BOOL - all of OLD items exist in NEW loadout.
*/

params ["_oldLoadoutList, _newLoadoutList"];
_oldList = [] + _this select 0; //Add an empty array to create unique array
_newList = [] + _this select 1;
_noSelling = true;
if ((count _oldList) > (count _newList)) then {_noSelling = false}
else {
	{
		_index = _newList find _x;
		if (_index == -1) exitWith {_noSelling = false};
		_newList set [_index, objNull];
		_newList = _newList - [objNull];
	} forEach _oldList;
};
//Return
_noSelling