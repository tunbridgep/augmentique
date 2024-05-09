class MenuChoice_OutfitSlot0 extends MenuUIChoiceAction;

var const int slot;
var OutfitManager M;

var const localized string NothingText;

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
    AskParentForReconfigure();
	return True;
}

function InitWindow()
{
    Super.initWindow();
    M = OutfitManager(player.outfitManager);
    UpdateButtonText();
}

function ConfigurationChanged()
{
    UpdateButtonText();
    Super.ConfigurationChanged();
}

function UpdateButtonText()
{
    local OutfitPart P;
    P = M.currOutfit.GetPartOfType(slot);
    if (P != None)
        btnAction.SetButtonText(P.name);
    else
        btnAction.SetButtonText(NothingText);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="Set Outfit Slot 0"
     actionText="Set Slot 0"
     Action=MA_Custom
     NothingText="Nothing"
}
