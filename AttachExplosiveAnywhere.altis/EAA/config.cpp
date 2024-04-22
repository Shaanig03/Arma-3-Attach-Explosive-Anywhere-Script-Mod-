class CfgPatches
{
	class EAA
	{
		units[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = { "A3_Modules_F", "A3_Data_F_Enoch_Loadorder"};
		author = "UnknownBird";
	};
};
class CfgSounds
{
	sounds[] = {}; // OFP required it filled, now it can be empty or absent depending on the game's version

	#include "sounds.sqf"
};
class CfgFunctions 
{
	#include "fncs.sqf"
};

class CfgFactionClasses
{
	class NO_CATEGORY;
	class SNG_EAA: NO_CATEGORY
	{
		displayName = "Attach Explosives Anywhere";
	};
};

class CfgVehicles
{
	// modules 
	//--------------------------------------------------------------------------
	class Logic;
	class Module_F : Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e. text input field)
			class Combo;				// Default combo box (i.e. drop-down menu)
			class Checkbox;				// Default checkbox (returned value is Boolean)
			class CheckboxNumber;		// Default checkbox (returned value is Number)
			class ModuleDescription;	// Module description
			class Units;				// Selection of units on which the module is applied
		};

		// Description base classes (for more information see below):
		class ModuleDescription
		{
			class AnyBrain;
		};
	};
	
	class SNG_Module_EAA : Module_F
	{
		// Standard object definitions:
		scope = 2;										// Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "Attach Explosive Anywhere Settings";				// Name displayed in the menu
		icon = "iconModule";	// Map icon. Delete this entry to use the default icon.
		category = "SNG_EAA";
		//
		function = "EAA_fnc_module_settings";	// Name of function triggered once conditions are met
		functionPriority = 0;				// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		isGlobal = 0;						// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 1;				// 1 for module waiting until all synced triggers are activated
		isDisposable = 1;					// 1 if modules is to be disabled once it is activated (i.e. repeated trigger activation will not work)
		is3DEN = 0;							// 1 to run init function in Eden Editor as well
		curatorCanAttach = 0;				// 1 to allow Zeus to attach the module to an entity
		curatorInfoType = ""; // Menu displayed when the module is placed or double-clicked on by Zeus

		// 3DEN Attributes Menu Options
		canSetArea = 0;						// Allows for setting the area values in the Attributes menu in 3DEN
		canSetAreaShape = 0;				// Allows for setting "Rectangle" or "Ellipse" in Attributes menu in 3DEN
		canSetAreaHeight = 0;				// Allows for setting height or Z value in Attributes menu in 3DEN
		class AttributeValues
		{
			// This section allows you to set the default values for the attributes menu in 3DEN
			size3[] = { 1, 1, -1 };		// 3D size (x-axis radius, y-axis radius, z-axis radius)
			isRectangle = 0;				// Sets if the default shape should be a rectangle or ellipse
		};

		// Module attributes (uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific):
		class Attributes : AttributesBase
		{
			// Arguments shared by specific module type (have to be mentioned in order to be present):
			class Units : Units
			{
				property = "SNG_Module_Strings";
			};
			
			class EAA_explosive_classes : Edit
			{
				displayName = "Explosive Classes:";
				tooltip = "explosive magazine classes";
				property = "SNG_Module_EAA_EAA_explosive_classes";
				// Default text for the input box:
				defaultValue = "[""SatchelCharge_Remote_Mag"",""DemoCharge_Remote_Mag""]"; // Because this is an expression, one must have a string within a string to return a string
			};
			class EAA_explosiveAttachRange : Edit
			{
				displayName = "Explosive Attach Range:";
				tooltip = "attach range";
				property = "SNG_Module_EAA_explosiveAttachRange";
				// Default text for the input box:
				defaultValue = """3.5"""; // Because this is an expression, one must have a string within a string to return a string
			};
			class EAA_explosiveWallDamage : Checkbox
			{
				displayName = "Explosive Wall Damage:";
				tooltip = "do setDamage 1 to the wall if planted to a wall";
				property = "SNG_Module_EAA_EAA_explosiveWallDamage";
				// Default text for the input box:
				defaultValue = true; // Because this is an expression, one must have a string within a string to return a string
			};
			
			
			class EAA_txt_cannot_deactivate_attaching_explosive : Edit
			{
				displayName = "message (ignore this) (deactivating attaching explosive)";
				tooltip = "";
				property = "SNG_Module_EAA_EAA_txt_cannot_deactivate_attaching_explosive";
				// Default text for the input box:
				defaultValue = """cannot deactivate attaching explosive"""; // Because this is an expression, one must have a string within a string to return a string
			};
			class EAA_txt_player_doesnt_have_this_explosive : Edit
			{
				displayName = "message (player doesn't have explosive)";
				tooltip = "";
				property = "SNG_Module_EAA_EAA_txt_player_doesnt_have_this_explosive";
				// Default text for the input box:
				defaultValue = """player doesn't have this explosive"""; // Because this is an expression, one must have a string within a string to return a string
			};
			class EAA_txt_cannot_attach_to_this_position : Edit
			{
				displayName = "message (cannot attach to this position)";
				tooltip = "";
				property = "SNG_Module_EAA_EAA_txt_cannot_attach_to_this_position";
				// Default text for the input box:
				defaultValue = """cannot attach explosive to this position"""; // Because this is an expression, one must have a string within a string to return a string
			};
			class EAA_txt_indicator_object_doesnt_exist : Edit
			{
				displayName = "message (error, attaching explosive doesn't exist)";
				tooltip = "";
				property = "SNG_Module_EAA_EAA_txt_indicator_object_doesnt_exist";
				// Default text for the input box:
				defaultValue = """attaching explosive / indicator object doesn't exist"""; // Because this is an expression, one must have a string within a string to return a string
			};
			class EAA_action_txt : Edit
			{
				displayName = "action text (Attach <explosive name>)";
				tooltip = "";
				property = "SNG_Module_EAA_EAA_action_txt";
				// Default text for the input box:
				defaultValue = """Attach %2"""; // Because this is an expression, one must have a string within a string to return a string
			};
			class EAA_action_txt_touchOff : Edit
			{
				displayName = "action text (detonate explosives)";
				tooltip = "";
				property = "SNG_Module_EAA_EAA_action_txt_touchOff";
				// Default text for the input box:
				defaultValue = """Touch off %1 bomb(s)"""; // Because this is an expression, one must have a string within a string to return a string
			};
			class ModuleDescription : ModuleDescription {}; // Module description should be shown last
		};

		// Module description (must inherit from base class, otherwise pre-defined entities won't be available)
		class ModuleDescription : ModuleDescription
		{
			description = "only some settings, not required to function attaching explosives";	// Short description, will be formatted as structured text
			sync[] = { "LocationArea_F" };				// Array of synced entities (can contain base classes)

			class LocationArea_F
			{
				description[] = { // Multi-line descriptions are supported
					"First line",
					"Second line"
				};
				position = 1;	// Position is taken into effect
				direction = 1;	// Direction is taken into effect
				optional = 1;	// Synced entity is optional
				duplicate = 1;	// Multiple entities of this type can be synced
				synced[] = { "BluforUnit", "AnyBrain" };	// Pre-defined entities like "AnyBrain" can be used (see the table below)
			};

			class BluforUnit
			{
				description = "Short description";
				displayName = "Any BLUFOR unit";	// Custom name
				icon = "iconMan";					// Custom icon (can be file path or CfgVehicleIcons entry)
				side = 1;							// Custom side (determines icon color)
			};
		};
	};
};


