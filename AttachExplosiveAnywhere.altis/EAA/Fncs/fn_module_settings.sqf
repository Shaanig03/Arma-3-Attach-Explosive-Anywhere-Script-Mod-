if (!isServer) exitWith {};

params [
	["_logic", objNull, [objNull]],		// Argument 0 is module logic
	["_units", [], [[]]],				// Argument 1 is a list of affected units (affected by value selected in the 'class Units' argument))
	["_activated", true, [true]]		// True when the module was activated, false when it is deactivated (i.e., synced triggers are no longer active)
];

private _explosive_classes = _logic getVariable "EAA_explosive_classes";
// compile string to array
if (typeName _explosive_classes == "STRING") then {
	_explosive_classes = [] call (compile _explosive_classes);
};
private _explosive_attachRange = _logic getVariable "EAA_explosiveAttachRange";
if (typeName _explosive_attachRange == "STRING") then {_explosive_attachRange = parseNumber(_explosive_attachRange)};


missionNamespace setVariable ["EAA_explosive_classes", _explosive_classes, true];
missionNamespace setVariable ["EAA_explosiveAttachRange", _explosive_attachRange, true];
missionNamespace setVariable ["EAA_explosiveWallDamage", _logic getVariable "EAA_explosiveWallDamage", true];

missionNamespace setVariable ["EAA_txt_cannot_deactivate_attaching_explosive", _logic getVariable "EAA_txt_cannot_deactivate_attaching_explosive", true];
missionNamespace setVariable ["EAA_txt_player_doesnt_have_this_explosive", _logic getVariable "EAA_txt_player_doesnt_have_this_explosive", true];
missionNamespace setVariable ["EAA_txt_cannot_attach_to_this_position", _logic getVariable "EAA_txt_cannot_attach_to_this_position", true];
missionNamespace setVariable ["EAA_txt_indicator_object_doesnt_exist", _logic getVariable "EAA_txt_indicator_object_doesnt_exist", true];

missionNamespace setVariable ["EAA_action_txt", _logic getVariable "EAA_action_txt", true];
missionNamespace setVariable ["EAA_action_txt_touchOff", _logic getVariable "EAA_action_txt_touchOff", true];











