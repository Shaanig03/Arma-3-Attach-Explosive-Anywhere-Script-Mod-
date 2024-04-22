params ["_player","_explosiveID"];

private _r = false;
private _explosive_ids = _player getVariable ["EAA_EI", []];

if (_explosiveID in _explosive_ids) then {
	_r = true;
	_r
};

_r