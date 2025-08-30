//=============================================================================
// OutfitMenuChoice
//=============================================================================

class OutfitMenuChoice extends MenuChoice_EnabledDisabled;

var OutfitManager O;

event InitWindow()
{
	Super.InitWindow();

    if (player != None)
    O = OutfitManager(player.outfitManager);
}
