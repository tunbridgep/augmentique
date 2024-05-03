//=============================================================================
// MenuScreenOutfitChanger
//=============================================================================

class MenuScreenOutfitChanger expands MenuUIScreenWindow;

// ----------------------------------------------------------------------
// CreateChoices()
// ----------------------------------------------------------------------

function CreateChoices()
{
	local int choiceIndex;
	local MenuUIChoice newChoice;
    local OutfitManager M;
    
    M = OutfitManager(player.outfitManager);

	// Loop through the Menu Choices and create the appropriate buttons
	for(choiceIndex=0; choiceIndex<arrayCount(choices); choiceIndex++)
	{
		if (choices[choiceIndex] != None)
		{
            if (choiceCount < 2 || M.currOutfit.partsGroup.CountPartType(choiceCount-2) > 0)
            {
                newChoice = MenuUIChoice(winClient.NewChild(choices[choiceIndex]));
                newChoice.SetPos(choiceStartX, choiceStartY + (choiceCount * choiceVerticalGap) - newChoice.buttonVerticalOffset);
            }
			choiceCount++;
		}
	}
}

function SaveSettings()
{
    Super.SaveSettings();
	player.SaveConfig();
}

defaultproperties
{
     choices(0)=Class'JCOutfits.MenuChoice_PrevOutfit'
     choices(1)=Class'JCOutfits.MenuChoice_NextOutfit'
     choices(2)=Class'JCOutfits.MenuChoice_OutfitSlot0'
     choices(3)=Class'JCOutfits.MenuChoice_OutfitSlot1'
     choices(4)=Class'JCOutfits.MenuChoice_OutfitSlot2'
     choices(5)=Class'JCOutfits.MenuChoice_OutfitSlot3'
     choices(6)=Class'JCOutfits.MenuChoice_OutfitSlot4'
     choices(7)=Class'JCOutfits.MenuChoice_OutfitSlot5'
     choices(8)=Class'JCOutfits.MenuChoice_OutfitSlot6'
     choices(9)=Class'JCOutfits.MenuChoice_OutfitSlot7'
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
