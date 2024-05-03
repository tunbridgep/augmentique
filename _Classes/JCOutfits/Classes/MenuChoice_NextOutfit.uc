class MenuChoice_NextOutfit extends MenuUIChoiceAction;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
    local OutfitManager M;
    M = OutfitManager(player.outfitManager);
    GoToNextOutfit();
	return True;
}

//Gets the next equippable outfit
function GoToNextOutfit()
{
    local int next;
    local OutfitManager M;
    M = OutfitManager(player.outfitManager);
    next = M.currOutfit.index;

    do
    {
        next++;
        if (next >= M.numOutfits)
            next = 0;
    }
    until (M.IsEquippable(next) || next == M.currOutfit.index);

	actionText = M.GetOutfitName(next);
    M.EquipOutfit(next);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     HelpText="Set your Current Outfit"
     actionText="Next Outfit"
     Action=MA_Custom
}
