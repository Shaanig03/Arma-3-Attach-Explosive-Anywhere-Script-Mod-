params ["_player","_explosiveIndex"];

if (EAA_attachExplosiveIndex != _explosiveIndex) then {
	// delete previous indicator object
	if (!isNull EAA_attachIndicatorObject) then {
		deleteVehicle EAA_attachIndicatorObject;
	};
	
	// get indicator object class
	_explosiveClass = EAA_explosive_classes select _explosiveIndex;
	_explosiveObjectClass = getText (configfile >> "CfgMagazines" >> _explosiveClass >> "ammo");
	
	// create new indicator object 
	EAA_attachIndicatorObject = _explosiveObjectClass createVehicleLocal (getPos player);
	EAA_attachIndicatorObject setPos (getPos player);
	EAA_attachIndicatorObject allowDamage false;
	
	EAA_attachExplosiveIndex = _explosiveIndex;
};

if (!EAA_attachModeEnabled) then {
	EAA_attachModeEnabled = true;
	
	[_player] spawn {
		_player =_this select 0;
		
		while {alive _player && EAA_attachModeEnabled} do {
			if (!isNull EAA_attachIndicatorObject) then {
				// raycast positions
				private _raycast_start = eyePos _player;  
				private _raycast_end = (_raycast_start vectorAdd (getCameraViewDirection _player vectorMultiply 100));
				
				// raycast
				_raycastInfo = lineIntersectsSurfaces [_raycast_start, _raycast_end, _player, EAA_attachIndicatorObject, true, 1, "FIRE"]; 
				EAA_raycastInfo = _raycastInfo;
				// if any objects/ground were hit
				if (count _raycastInfo > 0) then {
					_hitInfo =_raycastInfo select 0;
					
					_hitInfo params ["_hitPoint","_surfaceNormal","_intersectObject","_parentObject"];
					
					
					
					if ((ASLToAGL _hitPoint) distance _player <= EAA_explosiveAttachRange) then {
						if (!isNull _parentObject) then {
							if (!(_parentObject isKindOf "Man")) then {
								EAA_canAttach = true;
							} else {
								EAA_canAttach = false;
							};
						} else {
							// if attaching to terrain
							EAA_canAttach = true;
						};
						
						EAA_attachIndicatorObject setPosASL _hitPoint;
						EAA_attachIndicatorObject setVectorUp _surfaceNormal;
						
					} else {
						EAA_canAttach = false;
					};
					
					
				
					
				} else {
					EAA_canAttach = false;
				};
				if (EAA_canAttach) then {
					EAA_attachIndicatorObject hideObject false;
				} else {
					hideObject EAA_attachIndicatorObject;
					EAA_attachIndicatorObject setPosASL [0,0,0];
				};
			};
			sleep 0.005;
		};
		
		if (!isNull EAA_attachIndicatorObject) then {deleteVehicle EAA_attachIndicatorObject};
	};
};

/*

if (EAA_attachExplosiveIndex != _explosiveIndex) then {
	// delete existing indicator object
	if (!isNull EAA_attachIndicatorObject) then {deleteVehicle EAA_attachIndicatorObject};
	
	// get indicator object class
	private _explosiveClass = EAA_Explosive_Classes select _explosiveIndex;
	private _explosiveObjectClass = getText (configfile >> "CfgMagazines" >> _explosiveClass >> "ammo");
	
	// create new indicator object
	EAA_attachIndicatorObject = _explosiveObjectClass createVehicleLocal (getPos player);
	EAA_attachIndicatorObject allowDamage false;
	

	
	// set explosive index
	EAA_attachExplosiveIndex = _explosiveIndex;
};


// enable object indicator
if (!EAA_attachModeEnabled) then {
	[_player] spawn {
		_player =_this select 0;
		
		while {alive _player && EAA_attachModeEnabled} do {
			// raycast
			private _beg = eyePos _player;  
			private _endV = (_beg vectorAdd (getCameraViewDirection _player vectorMultiply 100)); 
			private _lines = lineIntersectsSurfaces [_beg, _endV, _player, EAA_attachIndicatorObject, true, 1, "FIRE"]; 
			
			// if raycast hits something
			if (count _lines > 0) then {
				_line =_lines select 0;
				_line params ["_point","_surfaceNormal","_intersectObject","_parentObject"];
				
				if (!isNull EAA_attachIndicatorObject) then {
					EAA_attachIndicatorObject setPosASL _point;
					EAA_attachIndicatorObject setVectorUp _surfaceNormal;
				};
			};
			
			sleep 0.05;
		};
		
	
	};
};*/