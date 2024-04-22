// exit if not server
if (!isServer) exitWith {};

if (isNil "EAA_explosive_classes") then {
	// explosive classes
	EAA_explosive_classes = 
	[
		"SatchelCharge_Remote_Mag",
		"DemoCharge_Remote_Mag"
	];
};
publicVariable "EAA_explosive_classes";


if (isNil "EAA_explosiveAttachRange") then {EAA_explosiveAttachRange = 5};
publicVariable "EAA_explosiveAttachRange";

if (isNil "EAA_explosiveWallDamage") then {EAA_explosiveWallDamage = true};
publicVariable "EAA_explosiveWallDamage";


if (isNil "EAA_plantSound") then {EAA_plantSound = "eaa_plant_sound"};
publicVariable "EAA_plantSound";

// texts 
if (isNil "EAA_txt_cannot_deactivate_attaching_explosive") then {EAA_txt_cannot_deactivate_attaching_explosive = "cannot deactivate attaching explosive"};
publicVariable "EAA_txt_cannot_deactivate_attaching_explosive";
if (isNil "EAA_txt_player_doesnt_have_this_explosive") then {EAA_txt_player_doesnt_have_this_explosive = "player doesn't have this explosive"};
publicVariable "EAA_txt_player_doesnt_have_this_explosive";
if (isNil "EAA_txt_cannot_attach_to_this_position") then {EAA_txt_cannot_attach_to_this_position = "cannot attach explosive to this position"};
publicVariable "EAA_txt_cannot_attach_to_this_position";
if (isNil "EAA_txt_indicator_object_doesnt_exist") then {EAA_txt_indicator_object_doesnt_exist = "attaching explosive / indicator object doesn't exist"};
publicVariable "EAA_txt_indicator_object_doesnt_exist";


if (isNil "EAA_action_txt") then {EAA_action_txt = "Attach %2" };
publicVariable "EAA_action_txt";

if (isNil "EAA_action_txt_touchOff") then {EAA_action_txt_touchOff = "Touch off %1 bomb(s)" };
publicVariable "EAA_action_txt_touchOff";


// action text
// EAA_action_txt = "<img image='%1'/><t color=''>Attach %2</t>";



EAA_config_loaded = true;
publicVariable "EAA_config_loaded";

