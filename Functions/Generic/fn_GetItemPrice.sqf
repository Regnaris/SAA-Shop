/*
	Author: Hadwig

	Description:
	Execute GetItemPrice DLL function. Need to be executed on server (because of server-side-only dll)

	Parameter(s):
	0: STRING - item class name

	Returns:
	NUMBER - price of item
*/

params["_item", "_uid"]; 
_price = "Economic" callExtension format["[%1|%2]GetItemPrice", _item, _uid];

// Сделать загрузку всех цен на сервер при инициализации.

//Return 
_price