class MenuChoice_OutfitSlot0 extends MenuUIChoiceAction;

var const int slot;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
    local OutfitManager M;
    M = OutfitManager(player.outfitManager);
    SetSlot(M);
	return True;
}

function SetSlot(OutfitManager M)
{
    M.EquipCustomOutfit();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="Set Outfit Slot 0"
     actionText="Set Slot 0"
     Action=MA_Custom
}
