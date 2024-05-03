class MenuChoice_PrevOutfit extends MenuUIChoiceAction;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
    local OutfitManager M;
    M = OutfitManager(player.outfitManager);
    GoToPrevOutfit();
	return True;
}

//Gets the previous equippable outfit
function GoToPrevOutfit()
{
    local int next;
    local OutfitManager M;
    M = OutfitManager(player.outfitManager);
    next = M.currOutfit.index;

    do
    {
        next--;
        if (next < 0)
            next = M.numOutfits - 1;
    }
    until (M.IsEquippable(next) || next == M.currOutfit.index);

	actionText = M.GetOutfit(next).name;
    M.EquipOutfit(next);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="Set your Current Outfit"
     actionText="Prev Outfit"
     Action=MA_Custom
}
