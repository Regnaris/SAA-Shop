params ["_player", "_didJIP"];
//sleep 5; //Debug only for situation where server = player

//TODO Пропадают очки при сохранении лодаута на дисконнекте | Можно решить на стороне клиента путем изменения профиля Армы ИЛИ Загрузить все вещи в арсенал к каждому ящику
//TODO Сохранение предметов в ящике
//TODO Оптимизация высчитывания цены для списка предметов (в том числе при выборе предметов в арсенале)
//TODO Проверить глобальность ACE арсенала [_box, true, false?]
//TODO Отловить "продажу" предметов, отсутствующих в белом списке
//TODO Написать скрипт сохранения боезапаса техники | http://red-bear.ru/forum/29-568-1
//TODO Ящики с бесплатными лимитированными предметами | Медикаменты, взрывчатка, магазины (aStorage_Med | aStorage_Expl | aStorage_Ammo)
//TODO Личные хранилища (pStorage_Nickname) с предметами и арсеналом с одеждой
//TODO Админ меню (Сделать кнопку "Ввести оплату за контракт". Выплачивать после окончания миссии)
//TODO Зарезервировать слоты для игроков | https://forums.bohemia.net/forums/topic/171360-admin-reserved-slots/
//TODO Вынести интерфейс в функцию (?) и функции отделить

fn_LoadoutsCompare = {
    params ["_oldLoadoutList, _newLoadoutList"];
    _oldLoadoutList = _this select 0; 
    _newLoadoutList = _this select 1;

    _sellList = [] + _oldLoadoutList;
    _buyList = [] + _newLoadoutList;
    for [{_i = 0}, {_i <= count _buyList}, {_i = _i + 1}] do {
        _index = _sellList find (_buyList select _i);
        if (_index > -1) then {
            _buyList set [_i, objNull];
            _buyList = _buyList - [objNull];
            _sellList set [_index, objNull];
            _sellList = _sellList - [objNull];
            _i = _i - 1;
        };
    };
    //Return
    [_sellList, _buyList]
};

fn_LoadoutListCreate = {
    params ["_player"];
    _loadoutList = [primaryWeapon player] + primaryWeaponItems player + primaryWeaponMagazine player + [secondaryWeapon player] + secondaryWeaponItems player + secondaryWeaponMagazine player + [handgunWeapon player] + handgunItems player + handgunMagazine player + itemsWithMagazines player;// + assignedItems player; + [uniform player] + [vest player] + [backpack player];
    _loadoutList sort true; 
    while {_loadoutList select 0 == ""} do {_loadoutList deleteAt 0};
    _loadoutList = _loadoutList - [objNull];
    //Return
    _loadoutList
};

fn_ListCost = {
    _gearcost = 0;
    params ["_itemsList"];
    {
        _index = pricesDB find _x;
        //_gearcost = _gearcost + parseNumber(pricesDB select (_index + 1));
        _index = _index + 1;
        _price = parseNumber(pricesDB select _index);
        if (typeName(_price) == "SCALAR" && _price >= 0) then {
            _gearcost = _gearcost + _price;
        }
    } forEach _itemsList;
    //Return
    _gearcost
};

buyCheck = 0;
_EH_ArsenalOpened = ["ace_arsenal_displayOpened",{
    hint "";
    _buyCost = 0; _sellCost = 0; _canBePurchased = true;
    _displayCash = (_this select 0) ctrlCreate ["CashArsenal", 100];
    _displayCash ctrlSetText format["Your Cash: %1$", cash];
    _displayBuyCost = (_this select 0) ctrlCreate ["BuyCostArsenal", 101];
    _displayBuyCost ctrlSetText format["Buy Cost: %1$", _buyCost];
    _displaySellCost = (_this select 0) ctrlCreate ["SellCostArsenal", 102];
    _displaySellCost ctrlSetText format["Sell Cost: %1$", _sellCost];
    _displayTotalCost = (_this select 0) ctrlCreate ["TotalCostArsenal", 103];
    _displayTotalCost ctrlSetText format["Total Cost: %1$", _buyCost - _sellCost];
    _displayBuyButton = (_this select 0) ctrlCreate ["BuyCheck", 106];
    _displayBuyButton ctrlAddEventHandler ["CheckedChanged", "buyCheck = _this select 1"];
    currentLoadout = getUnitLoadout player;
    currentLoadoutList = [player] call fn_LoadoutListCreate;

    // Add PRICE stat at Page 2
    [[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14], [0,1,2,3,4,5,6,7]], "priceStat", ["price"], "Price", [false, true], [{}, {
        params["_stats", "_config"];

        // _newLoadoutList = [player] call fn_LoadoutListCreate;
        // _comp = [currentLoadoutList, _newLoadoutList] call fn_LoadoutsCompare;
        // _buyCost = [_comp select 1] call fn_ListCost;
        // _displayBuyCost ctrlSetText format["Buy Cost: %1$", _buyCost];
        // _sellCost = [_comp select 0] call fn_ListCost;
        // _displaySellCost ctrlSetText format["Sell Cost: %1$", (_sellCost/5)];
        // _totalCost = _buyCost - (_sellCost/5);
        // if (totalCost < cash) then {_displayTotalCost ctrlSetBackgroundColor [1,0,0,0.4]} else {_displayTotalCost ctrlSetBackgroundColor [0,1,0,0.4]};
        
        _price = 0;
        //_price = pricesDB select (pricesDB find configName(_config) + 1);
        //if (typename (_price) != "SCALAR") then {_price = -1};
        _price
    }, {true}]] call ACE_arsenal_fnc_addStat;
}] call CBA_fnc_addEventHandler;

_EH_ArsenalClose = ["ace_arsenal_displayClosed", {
    _newLoadoutList = [player] call fn_LoadoutListCreate;
    _comp = [currentLoadoutList, _newLoadoutList] call fn_LoadoutsCompare;
    diag_log format ["Count:%1 | #2 SELL LIST:%2", count (_comp select 0), _comp select 0];
    diag_log format ["Count:%1 | #2 BUY LIST:%2", count (_comp select 1), _comp select 1];
    if (buyCheck == 1) then {hint "You bought something"}
    else {
        hint "You bought nothing";
        player setUnitLoadout currentLoadout;
    };
    
}] call CBA_fnc_addEventHandler;

// _EH_ArsenalCargoChanged = ["ace_arsenal_cargoChanged", {
//     params["_display","_item","_addORremove", "_shiftState"];
//     //diag_log format ["Aresnal Cargo: item %1 | addorremove %2 | shiftState %3", _this select 1, _this select 2, _this select 3];
// }] call CBA_fnc_addEventHandler;



/*
// EventHandlers to display player cash on screen when inventory opened
*/
_EH_InventoryOpened = player addEventHandler ["InventoryOpened",
{
    _Rsc_layer = ("ArsenalHUD" call BIS_fnc_rscLayer) cutRsc ["ArsenalCaxhTitle", "PLAIN"];
    _display = uiNamespace getVariable ["ArsenalHUD",displayNull];    // Get layer display
    _control = _display displayCtrl 7001;    // Get display control for cash text
    _uid = getPlayerUID player;
    _cash = missionNamespace getVariable format ["SAA_cash_%1", _uid];// Get current player cash
    diag_log format["[SAA] Cash number from inventory event handler: %1", _cash];
    _control ctrlSetText format["%1 $", _cash];     // Update info in cash text with new information.
}];

_EH_InventoryClosed = player addEventHandler ["InventoryClosed", {
    _Rsc_layer = ("ArsenalHUD" call BIS_fnc_rscLayer) cutRsc ["Clear", "PLAIN"]; // Delete cash layer
}];



/*
 Player initialisation
*/
// [player, format ["Welcome back to Shadec | %1", name player], 50, 50, 45, 1, [], 0, true] spawn BIS_fnc_establishingShot;
cash = 0;
gearcost = 0;
currentLoadout = [];
currentLoadoutList = [];
uid = getPlayerUID player;
//pricesDB = [uid] call Shadec_fnc_db
[uid] remoteExecCall ["Shadec_fnc_GetPlayerCash", 2];

getSavedLoadout = [player, uid];
publicVariableServer "getSavedLoadout";

format ["SAA_loadout_%1", uid] addPublicVariableEventHandler {
	_loadout = _this select 1;
    player setUnitLoadout _loadout;
    currentLoadout = _loadout;
    currentLoadoutList = [player] call fn_LoadoutListCreate;

    getCash = [player, uid];
    publicVariableServer "getCash";
    getCash = nil;
};

format ["SAA_cash_%1", uid] addPublicVariableEventHandler {
	cash = _this select 1;
};

_EH_PlayerKilled = player addEventHandler ["Killed", {
    _unit = _this select 0; 
    // _lostLoadout = [player] call fn_LoadoutListCreate; // Lost loadout
    // _lostCost = [_lostLoadout] call fn_ListCost;       // total cost calculated
    removeAllItemsWithMagazines _unit;
    removeAllWeapons _unit;
    _loadout = getUnitLoadout _unit;
    saveCurrentLoadout = [player, uid, _loadout];
    publicVariableServer "saveCurrentLoadout";
    saveCurrentLoadout = nil;
    titleText ["You were Killed In Action | KIA\nProfessional soldiers are predictable. The world is full of dangerous amateurs.", "BLACK FADED"];
}];

_EH_PlayerRespawn = player addEventHandler ["Respawn", {
	params ["_unit", "_corpse"];
    _loadout = missionNamespace getVariable [format["SAA_loadout_%1", _uid], str(getUnitLoadout "B_Survivor_F")];
    diag_log ["[SAA] Player respawned with corpse: %1", _corpse];
    _unit setUnitLoadout _loadout;
}];