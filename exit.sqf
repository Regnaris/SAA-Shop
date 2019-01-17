//_players = allPlayers - entities "HeadlessClient_F";
_players = call BIS_fnc_listPlayers;
_playersList = [];
_loadoutList = [];
{
	_playersList set [count _playersList, (getPlayerUID _x)];
	_loadoutList set [count _loadoutList, (getUnitLoadout _x)];
	[(getPlayerUID _x),(getUnitLoadout _x)] call Shadec_fnc_SetPlayerSavedLoadout;
} forEach _players;