// script should only execute for players
if (!hasInterface) exitWith {};


// wait until config loads
waitUntil {!isNil "EAA_config_loaded"};

// wait until player initializes
waitUntil {!isNull player && player == player};

// (local variables)
EAA_action_txts = []; // added action texts
EAA_attachModeEnabled = false; // attach mode enabled?
EAA_attachExplosiveIndex = -1; // attaching explosive index
EAA_attachIndicatorObject = objNull; // indicator object which the attaching explosive is shown to the attaching point
EAA_canAttach = false; // can attach?
EAA_raycastInfo = []; // raycasts when the player is in attach mode
EAA_placingExplosive = false;

// condition to enter attach mode
EAA_cond_enterAttachMode =
"
	if (count _this > 0) then {
		_target =_this select 0;
		_text =_this select 4;
		
		_explosive_id = EAA_action_txts find _text;
		if (_explosive_id == -1) then {
			if (EAA_attachModeEnabled) then {
				[] call EAA_fnc_disableAttachMode;
			};
		} else {
			_attachMode = [_target, _explosive_id] call EAA_fnc_attachMode;
		};
	};
	
";

// ui event handlers that checks the action menu
inGameUISetEventHandler ["PrevAction", EAA_cond_enterAttachMode];
inGameUISetEventHandler ["NextAction", EAA_cond_enterAttachMode];
inGameUISetEventHandler ["Action", "
	
	
	if (EAA_attachModeEnabled) then {
		_text =_this select 4;
		if (_text == ""Deactivate mine"") then {
			systemChat EAA_txt_cannot_deactivate_attaching_explosive;
			true
		};
	};
	if (EAA_placingExplosive) then {
		true
	};
"];


// player init 
private _EAA_init = 
{
	params ["_player"];
	
	// add actions
	{
		// get explosive picture & displayName
		_picture = getText(configfile >> "CfgMagazines" >> _x >> "picture");
		_displayName = getText (configfile >> "CfgMagazines" >> _x >> "displayName");
		
		// create action text
		_action_txt = format [EAA_action_txt, _picture, _displayName];
		EAA_action_txts pushBack _action_txt;
		
		// add action 
		_player addAction [_action_txt, {
			_player =_this select 0;
			_args =_this select 2;
			
			// exit if cannot attach
			if (!EAA_canAttach) exitWith {systemChat EAA_txt_cannot_attach_to_this_position};
			
			// exit if indicator object is null
			if (isNull EAA_attachIndicatorObject) exitWith {systemChat EAA_txt_indicator_object_doesnt_exist};
			
			// get explosive index
			_args params ["_explosiveIndex"];
			
			// get explosive class
			_explosiveClass = EAA_explosive_classes select _explosiveIndex;

			_mags = magazines _player;
			
			// exit if explosive was removed from the player's inventory
			if (!(_explosiveClass in _mags)) exitWith {systemChat EAA_txt_player_doesnt_have_this_explosive};
			
			// get plant position & direction before disabling attach mode
			EAA_plantPos = getPosASL EAA_attachIndicatorObject;
			EAA_plantDir = [vectorDir EAA_attachIndicatorObject, vectorUp EAA_attachIndicatorObject];
			
			
			EAA_attachingObject = (EAA_raycastInfo select 0) select 3;
			
			// disable attach mode
			[] call EAA_fnc_disableAttachMode;
			
			// play put down animation
			_player playActionNow "putdown";
			EAA_placingExplosive = true;
			[_player, _explosiveClass] spawn {
				_player =_this select 0;
				_explosiveClass =_this select 1;
				
				sleep 0.7;
				// exit if player is dead or doesn't exist
				if (!alive _player) exitWith {};
				
				// exit if explosive was removed from the player's inventory
				_mags = magazines _player;
				if (!(_explosiveClass in _mags)) exitWith {systemChat EAA_txt_player_doesnt_have_this_explosive};
				
				// remove explosive from player inventory
				_player removeMagazine _explosiveClass;
				
				// update explosives player has
				private _mags = magazines _player;
				private _explosiveIDS = [];
				// check for explosives in inventory
				{
					// check if player has any explosive class
					if (_x in _mags) then {
						// push explosive index
						_explosiveIDS pushBack _forEachIndex;
					};
				} forEach EAA_Explosive_Classes;
					
				// store the explosive ids which the player has
				_player setVariable ["EAA_EI", _explosiveIDS];
				
				
				
				// get indicator object class
				_explosiveObjectClass = getText (configfile >> "CfgMagazines" >> _explosiveClass >> "ammo");
				
				// create explosive
				_explosive = _explosiveObjectClass createVehicle EAA_plantPos;
				_explosive setPosASL EAA_plantPos;
				_explosive setVectorDirAndUp EAA_plantDir;
				
				// store explosive as variable to detonate it
				_explosives = _player getVariable ["EAA_explosives", []];
				_explosives pushBack [_explosive, EAA_attachingObject];
				_player setVariable ["EAA_explosives", _explosives];
				
				if (!isNull EAA_attachingObject) then {
					if (getObjectType EAA_attachingObject == 8) then {
						[_explosive, EAA_attachingObject] call BIS_fnc_attachToRelative;
					};
					
				};
				
				
				EAA_placingExplosive = false;
				
				// play plant sound if defined
				if (EAA_plantSound != "") then {
				
					// play sound for all players nearby
					[[_explosive],{
						params ["_explosive"];
						
						if (player distance _explosive <= 50) then {
							_explosive say3D [EAA_plantSound, 50];
						};
						
					}] remoteExec ["bis_fnc_call", 0];
				};
				
				// attach 
			};
			
		}, [_forEachIndex], 12, false, true, "", (format ["alive _target && [_target, %1] call EAA_fnc_cond_show_attachAction", _forEachIndex])];
	} forEach EAA_explosive_classes;
	
		
		// detonate action
		EAA_action_touchOff = _player addAction [EAA_action_txt_touchOff, {
			_player =_this select 0;
			_args =_this select 2;
			
			// get planted explosives
			_explosives = _player getVariable ["EAA_explosives", []];
			
			// loop through each planted explosive
			{
				_x params ["_x_explosive","_x_attachedObject"];
				
				// detonate 
				_x_explosive setDamage 1;
				
				// set wall damage (if enabled)
				if (!isNull _x_attachedObject && EAA_explosiveWallDamage) then {
					
					private _objectClass = getText(configfile >> "CfgVehicles" >> (typeOf _x_attachedObject) >> "vehicleClass");
					
					// if object class is a wall
					if (_objectClass == "Structures_Walls") then {
						// set wall damage
						[_x_attachedObject] spawn {
							_x_attachedObject =_this select 0;
							sleep 0.1;
							_x_attachedObject setDamage 1;
						};
					};
				};
				
			} forEach _explosives;
			
			
			_player setVariable ["EAA_explosives", []];
			
		}, [_forEachIndex], 12, false, true, "", (format ["alive _target && {_explosive =_x select 0; (!isNull _explosive && mineActive _explosive)} count (_target getVariable [""EAA_explosives"", []]) > 0", _forEachIndex])];
		
	// explosive inventory check 
	[_player] spawn {
		params ["_player"];
		
		while {alive _player} do {
			// get mags
			private _mags = magazines _player;
				
			private _explosiveIDS = [];
			
			// check for explosives in inventory
			{
				// check if player has any explosive class
				if (_x in _mags) then {
					// push explosive index
					_explosiveIDS pushBack _forEachIndex;
				};
			} forEach EAA_Explosive_Classes;
				
			// store the explosive ids which the player has
			_player setVariable ["EAA_EI", _explosiveIDS];
	
			// update touch off text 
			_player setUserActionText [EAA_action_touchOff, (format [EAA_action_txt_touchOff, {_explosive =_x select 0; (!isNull _explosive && mineActive _explosive)} count (_player getVariable ["EAA_explosives", []])])];
			sleep 1;
		};
		
		[] call EAA_fnc_disableAttachMode;
		player setVariable ["EAA_explosives", []];
		EAA_placingExplosive = false;
		
		//EAA_attachModeEnabled = false;
		//EAA_attachExplosiveIndex = -1;
		//EAA_canAttach = false;
	};
};
[player] call _EAA_init;
player addEventHandler ["Respawn", _EAA_init];