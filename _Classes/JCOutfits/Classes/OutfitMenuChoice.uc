//=============================================================================
// OutfitMenuChoice
//=============================================================================

class OutfitMenuChoice extends MenuChoice_EnabledDisabled;

var OutfitManager O;
var WeaponSkinManager S;

event InitWindow()
{
	Super.InitWindow();

    if (player != None)
    {
        O = OutfitManager(player.outfitManager);
        S = WeaponSkinManager(player.weaponSkinManager);
    }
}
