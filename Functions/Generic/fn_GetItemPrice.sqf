/*
	Author: Hadwig

	Description:
	Gets item price from misson config

	Parameter(s):
	0: STRING - item class name

	Returns:
	NUMBER - price of item
*/

params["_item", "_uid"]; 

_price = ("SAA_Items" >> (_item) >> "price") call BIS_fnc_getCfgData;

//Return 
_price