/*
	Author: Spunky

	Description:
	Execute CheckNewPlayerExistence DLL function. Need to be executed on server (because of server-side-only dll)

	Parameter(s):
	0: STRING - player SteamID

	Returns:
	Nothing
*/

params["_uid"];

"Economic" callExtension format["[%1]CheckNewPlayerExistance", _uid];
 
 //return
 true