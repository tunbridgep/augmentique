class MenuChoice_OutfitSlot0 extends MenuUIChoiceAction;

var const int slot;
var OutfitManager M;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
    local Outfit O;
    local OutfitPart P1, P2;
    local int index;
    M.EquipCustomOutfit();
    O = M.currOutfit;
    P1 = O.GetPartOfType(slot);
    if (P1 != None)
    {
        P2 = O.partsGroup.GetNextPartOfType(slot,P1.index);
        O.ReplacePart(slot,P2);
        UpdateButtonText();
    }
    M.ApplyCurrentOutfit();
	return True;
}

function InitWindow()
{
    Super.initWindow();
    M = OutfitManager(player.outfitManager);
    UpdateButtonText();
}

function UpdateButtonText()
{
    local OutfitPart P;
    P = M.currOutfit.GetPartOfType(slot);
    if (P != None)
        btnAction.SetButtonText(P.name);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="Set Outfit Slot 0"
     actionText="Set Slot 0"
     Action=MA_Custom
}
