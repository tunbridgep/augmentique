//=============================================================================
// MenuChoice_NPCs
//=============================================================================

class MenuChoice_NPCs extends OutfitMenuChoice;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(O.iEquipNPCs);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	O.iEquipNPCs = GetValue();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(O.iEquipNPCs);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     enumText(0)="Disabled"
     enumText(1)="Generic"
     enumText(2)="All NPCs"
     HelpText="Equips NPCs with outfits. Allow custom outfits for only generic NPCs or for generic and unique NPCs. Takes effect on loading a new map."
     actionText="|&NPC Fashion"
}
