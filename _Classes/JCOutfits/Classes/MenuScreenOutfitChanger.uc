//=============================================================================
// MenuScreenOutfitChanger
//=============================================================================

class MenuScreenOutfitChanger expands MenuUIScreenWindow;

function SaveSettings()
{
    Super.SaveSettings();
	player.SaveConfig();
}

defaultproperties
{
     choices(0)=Class'JCOutfits.MenuChoice_PrevOutfit'
     choices(1)=Class'JCOutfits.MenuChoice_NextOutfit'
     //choices(2)=Class'JCOutfits.MenuChoice_OutfitSlot0'
     choices(2)=Class'JCOutfits.MenuChoice_OutfitSlot1'
     choices(3)=Class'JCOutfits.MenuChoice_OutfitSlot2'
     choices(4)=Class'JCOutfits.MenuChoice_OutfitSlot3'
     choices(5)=Class'JCOutfits.MenuChoice_OutfitSlot4'
     choices(6)=Class'JCOutfits.MenuChoice_OutfitSlot5'
     choices(7)=Class'JCOutfits.MenuChoice_OutfitSlot6'
     choices(8)=Class'JCOutfits.MenuChoice_OutfitSlot7'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_OK)
     Title="Outfit Switcher Test"
     ClientWidth=391
     ClientHeight=480
     clientTextures(0)=Texture'HDTPDecos.UserInterface.HDTPOptionsScreen_1'
     clientTextures(1)=Texture'HDTPDecos.UserInterface.HDTPOptionsScreen_2'
     clientTextures(2)=Texture'HDTPDecos.UserInterface.HDTPOptionsScreen_3'
     clientTextures(3)=Texture'HDTPDecos.UserInterface.HDTPOptionsScreen_4'
     textureCols=2
     bHelpAlwaysOn=True
     helpPosY=426
}
