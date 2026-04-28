//=============================================================================
// MenuChoice_SelectWeaponSkins
//=============================================================================

class MenuChoice_SelectWeaponSkins extends OutfitMenuChoice;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(S.bSwitchToNewSkins));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	S.bSwitchToNewSkins = bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(S.bSwitchToNewSkins));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="Auto-Switch to newly acquired weapon skins, if holding the same weapon."
     actionText="|&Auto-Switch Weapon Skins"
}
