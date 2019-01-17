// Server initialization

"getCash" addPublicVariableEventHandler {
    _pcid = owner (_this select 1 select 0);
	_uid = _this select 1 select 1;
    cash = [_uid] call Shadec_fnc_GetPlayerCash;
    _pcid publicVariableClient "cash";
    cash = nil;
};

"setCash" addPublicVariableEventHandler {
    _pcid = owner (_this select 1 select 0);
	_uid = _this select 1 select 1;
    _change = _this select 1 select 2;
    _cash = [_uid] call Shadec_fnc_GetPlayerCash;
    _cash = _cash + _change; // Check: cash and change are NUMBERS (not strings)
};

"getSavedLoadout" addPublicVariableEventHandler {
    _pcid = owner (_this select 1 select 0);
	_uid = _this select 1 select 1;
	loadout = parseSimpleArray([_uid] call Shadec_fnc_GetPlayerSavedLoadout);
    _pcid publicVariableClient "loadout";
    loadout = nil;
};

"saveCurrentLoadout" addPublicVariableEventHandler {
    _uid = _this select 1 select 1;
    _gear = _this select 1 select 2;
    [_uid, _gear] call Shadec_fnc_SetPlayerSavedLoadout;
};

//Player connect handler
_EH_PlayerConnected = addMissionEventHandler ["PlayerConnected",
{
    params["_id", "_uid", "_name", "_jip", "_owner"];
	diag_log format ["[SAA] CLIENT CONNECTED. UID:%2 | PNAME:%3", _uid, _name];
    [_uid] call Shadec_fnc_GetPlayerSavedLoadout
}];

_EH_PlayerDisconnected = addMissionEventHandler ["HandleDisconnect",
    {
        _unit = _this select 0;
        _pcid = _this select 1;
        _uid = _this select 2;
        _pname = _this select 3;
        _loadout = getUnitLoadout _unit;
        //diag_log format ["PLAYER DISCONNECTED, LOADOUT:%1", _loadout];
        [_uid, _loadout] call Shadec_fnc_SetPlayerSavedLoadout;
        //deleteVehicle _unit;
        false;
}];



pricesDB = "
    UK3CB_BAF_L1A1,UK3CB_BAF_L1A1_Wood,UK3CB_BAF_H_Mk6_DPMW_F
";

listArsenal = pricesDB splitString ",";
arsenalItems = [];
{
    _flag = false;
    if (_flag) then { arsenalItems pushBack _x };
    _flag = !_flag;
} forEach listArsenal;

// Arsenal Init
diag_log format ["listArsenal: %1", listArsenal];
diag_log format ["Arsenal: %1", arsenalItems];
[Arsenal1, arsenalItems, true] call ace_arsenal_fnc_initBox;