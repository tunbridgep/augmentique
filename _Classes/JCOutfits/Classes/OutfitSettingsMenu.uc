//=============================================================================
// OutfitSettingsMenu
//=============================================================================

class OutfitSettingsMenu expands MenuUIScreenWindow;

var OutfitManager O;

event InitWindow()
{
	Super.InitWindow();

    if (player != None)
    O = OutfitManager(player.outfitManager);
}

function SaveSettings()
{
    super.SaveSettings();
    O.SaveConfig();
}

function ResetToDefaults()
{
    super.ResetToDefaults();
    O.SaveConfig();
}

defaultproperties
{
     choices(0)=Class'Augmentique.MenuChoice_ShowDescriptions'
     choices(1)=Class'Augmentique.MenuChoice_NPCs'
     actionButtons(0)=(Align=HALIGN_Right,Action=AB_OK)
     actionButtons(1)=(Action=AB_Reset)
     Title="Augmentique Settings"
     //ClientWidth=391
     //ClientHeight=480
     //clientTextures(0)=Texture'Augmentique.UserInterface.OptionsScreen_1'
     //clientTextures(1)=Texture'Augmentique.UserInterface.OptionsScreen_2'
     //clientTextures(2)=Texture'Augmentique.UserInterface.OptionsScreen_3'
     //clientTextures(3)=Texture'Augmentique.UserInterface.OptionsScreen_4'
     //textureCols=2
     //helpPosY=426
     ClientWidth=537
     ClientHeight=228
     clientTextures(0)=Texture'DeusExUI.UserInterface.MenuControlsBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.MenuControlsBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.MenuControlsBackground_3'
     textureRows=1
     helpPosY=174
     bHelpAlwaysOn=true
}
