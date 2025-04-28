//=============================================================================
// PersonaScreenOutfits. Based off PersonaScreenImages
//=============================================================================

class PersonaScreenOutfits extends PersonaScreenBaseWindow;

#exec OBJ LOAD FILE=DeusEx

var PersonaActionButtonWindow btnEquip;
var PersonaActionButtonWindow btnCustom;

var PersonaListWindow         lstOutfits;
var PersonaScrollAreaWindow   winScroll;
var PersonaHeaderTextWindow   winOutfitName;
var PersonaCheckBoxWindow     chkAccessories;
var ViewportWindow            winViewport;

var localized String ShowAccessoriesLabel;
var localized String OutfitsTitleText;
var localized String EquipButtonLabel;
var localized String CustomButtonLabel;

var int rowIDLastEquipped;

var OutfitManager outfitManager;

var int selectedRowId;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

    outfitManager = OutfitManager(Player.OutfitManager);
    if (outfitManager == None)
        return;

	PopulateOutfitsList();
	SetFocusWindow(lstOutfits);

    if (PersonaNavBarWindow(winNavBar).btnOutfits != None)
        PersonaNavBarWindow(winNavBar).btnOutfits.SetSensitivity(False);

	EnableButtons();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	Super.CreateControls();

	CreateTitleWindow(9, 5, OutfitsTitleText);
    CreateViewportWindow();
	CreateOutfitsList();
	CreateOutfitTitle();
	CreateButtons();
    CreateAccessoriesCheckbox();
}

// ----------------------------------------------------------------------
// CreateImageWindow()
// ----------------------------------------------------------------------

function CreateViewportWindow()
{
    winViewport = ViewportWindow(winClient.NewChild(class'ViewportWindow'));
	winViewport.SetPos(15, 20);
	winViewport.SetSize(400, 400);
    //winViewport.SetViewportActor(player);
    winViewport.SetRotation(GetViewportRotation());
    winViewport.SetViewportLocation(GetViewportLocation(),true);
    winViewport.SetFOVAngle(55);
}

function Vector GetViewportLocation()
{
	local Vector loc;

	loc = 65 * Vector(player.Rotation);
    if (player.bForceDuck || player.bCrouchOn || player.bDuck == 1)
        loc.Z = player.BaseEyeHeight + 15;
    else
        loc.Z = player.BaseEyeHeight - 10;
	loc += player.Location;

    return loc;
}

function Rotator GetViewportRotation()
{
	local Rotator rot;

	rot = Player.ViewRotation;
	rot.Yaw += -32768;
    rot.Pitch = 0;
    rot.Roll = 0;

    return rot;
}

// ----------------------------------------------------------------------
// CreateOutfitTitle()
// ----------------------------------------------------------------------

function CreateOutfitTitle()
{
	winOutfitName = PersonaHeaderTextWindow(winClient.NewChild(Class'PersonaHeaderTextWindow'));
	winOutfitName.SetPos(214, 6);
	winOutfitName.SetWidth(200);
	winOutfitName.SetTextAlignments(HALIGN_Right, VALIGN_Center);
}

// ----------------------------------------------------------------------
// CreateOutfitsList()
// ----------------------------------------------------------------------

function CreateOutfitsList()
{
	winScroll = CreateScrollAreaWindow(winClient);
	winScroll.SetPos(417, 21);
	winScroll.SetSize(184, 398);

	lstOutfits = PersonaListWindow(winScroll.clipWindow.NewChild(Class'PersonaListWindow'));
	lstOutfits.EnableMultiSelect(False);
	lstOutfits.EnableAutoExpandColumns(True);
	lstOutfits.SetNumColumns(3);
	lstOutfits.HideColumn(2, True);
	lstOutfits.SetSortColumn(0, True);
	lstOutfits.EnableAutoSort(False);
	lstOutfits.SetColumnWidth(0, 150);
	lstOutfits.SetColumnWidth(1, 34);
	lstOutfits.SetColumnType(2, COLTYPE_Float);
	lstOutfits.SetColumnFont(1, Font'FontHUDWingDings');
}

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	local PersonaButtonBarWindow winActionButtons;

	winActionButtons = PersonaButtonBarWindow(winClient.NewChild(Class'PersonaButtonBarWindow'));
	winActionButtons.SetPos(10, 422);
	winActionButtons.SetWidth(259);
	winActionButtons.FillAllSpace(False);
	
    btnCustom = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnCustom.SetButtonText(CustomButtonLabel);

	btnEquip = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnEquip.SetButtonText(EquipButtonLabel);
}

// ----------------------------------------------------------------------
// CreateShowNotesCheckbox()
// ----------------------------------------------------------------------

function CreateAccessoriesCheckbox()
{
    chkAccessories = PersonaCheckBoxWindow(winClient.NewChild(Class'PersonaCheckBoxWindow'));

    chkAccessories.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 203, 424);
    chkAccessories.SetText(ShowAccessoriesLabel);
}

// ----------------------------------------------------------------------
// PopulateOutfitsList()
// ----------------------------------------------------------------------

function PopulateOutfitsList()
{
    local Outfit O;
	local int rowId, i;

	// First clear the list
	lstOutfits.DeleteAllRows();

    //player.ClientMessage("Populate outfits list");

	// Loop through all the outfits the player currently has in 
	// his/her possession

	for(i = 0; i < outfitManager.numOutfits;i++)
	{
        if (!outfitManager.IsEquippable(i))
            continue;

		O = outfitManager.GetOutfit(i);

        //don't show hidden outfits
        if (O.hidden)
            continue;

		rowId = lstOutfits.AddRow(O.name);

		// Check to see if we need to display *New* in the second column
		//if (image.bPlayerViewedImage == False)
		//	lstOutfits.SetField(rowId, 1, "C");

		// Save the image away
		//lstOutfits.SetRowClientObject(rowId, outfit);
		lstOutfits.SetField(rowId, 0, O.name);
        if (outfitManager.IsEquipped(i))
        {
    		lstOutfits.SetField(rowId, 1, "C");
            rowIDLastEquipped = rowId;
        }

        // Set the outfit number to the second column
        lstOutfits.SetFieldValue(rowId, 2, i);
	}
}

// ----------------------------------------------------------------------
// ListSelectionChanged() 
// ----------------------------------------------------------------------

event bool ListSelectionChanged(window list, int numSelections, int focusRowId)
{
    selectedRowId = focusRowId;

    EnableButtons();

	return True;
}

// ----------------------------------------------------------------------
// FocusEnteredDescendant()
// ----------------------------------------------------------------------

event FocusEnteredDescendant(Window enterWindow)
{
	EnableButtons();
}

// ----------------------------------------------------------------------
// FocusLeftDescendant()
// ----------------------------------------------------------------------

event FocusLeftDescendant(Window leaveWindow)
{
	EnableButtons();
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;

	bHandled = True;

	switch(buttonPressed)
	{
		case btnEquip:
			Equip(int(lstOutfits.GetFieldValue(selectedRowId, 2)));
			break;

		case btnCustom:
            player.invokeuiscreen(class'MenuScreenOutfitChanger');
			break;

		default:
			bHandled = False;
			break;
	}

	if ( !bHandled )
		bHandled = Super.ButtonActivated(buttonPressed);

    //PopulateOutfitsList();
	return bHandled;
}


// ----------------------------------------------------------------------
// ListRowActivated()
//
// User double-clicked on one of the rows, meaning he/she/it wants
// to redefine one of the functions
// ----------------------------------------------------------------------

event bool ListRowActivated(window list, int rowId)
{
    Equip(int(lstOutfits.GetFieldValue(rowId, 2)));
}

// ----------------------------------------------------------------------
// ToggleChanged()
//
// Called when the user clicks on the checkbox
// ----------------------------------------------------------------------

event Bool ToggleChanged(window button, bool bToggleValue)
{
    if (button == chkAccessories)
    {
        outfitManager.noAccessories = !bToggleValue;
        outfitManager.ApplyCurrentOutfit();
    }

}

// ----------------------------------------------------------------------
// EnableButtons()
//
// Sets the state of the Add, Delete, Up and Down buttons
// ----------------------------------------------------------------------

function EnableButtons()
{
    local int index;
        
    index = int(lstOutfits.GetFieldValue(selectedRowId, 2));

	btnEquip.SetSensitivity(!outfitManager.IsEquipped(index));
    if (outfitManager.currOutfit.HasAccessories())
        chkAccessories.Show();
    else
        chkAccessories.Hide();

    chkAccessories.SetToggle(!outfitManager.noAccessories);
	chkAccessories.SetSensitivity(true);
}

// ----------------------------------------------------------------------
// Equip()
// ----------------------------------------------------------------------

function Equip(int index)
{
    outfitManager.EquipOutfit(index);

    //Clear the chevron on the previously equipped outfit
    lstOutfits.SetField(rowIDLastEquipped, 1, "");

    //Set chevron on new outfit
    lstOutfits.SetField(selectedRowId, 1, "C");

    rowIDLastEquipped = selectedRowId;
    
    //PopulateOutfitsList();
    EnableButtons();
}

// ----------------------------------------------------------------------
// SaveSettings()
// ----------------------------------------------------------------------

function SaveSettings()
{
	DestroyImages();
}

// ----------------------------------------------------------------------
// DestroyImages()
//
// Unload texture memory used by the images
// ----------------------------------------------------------------------

function DestroyImages()
{
	local DataVaultImage image;
	local int listIndex;
	local int rowId;

	for(listIndex=0; listIndex<lstOutfits.GetNumRows(); listIndex++)
	{
		rowId = lstOutfits.IndexToRowId(listIndex);

		if (lstOutfits.GetFieldValue(rowId, 2) > 0)
		{
			image = DataVaultImage(lstOutfits.GetRowClientObject(rowId));

			if (image != None)
				image.UnloadTextures(player);
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ShowAccessoriesLabel="Show Accessories"
     OutfitsTitleText="Outfits"
     EquipButtonLabel="Equip"
     CustomButtonLabel="Custom Outfit"
     clientBorderOffsetY=35
     ClientWidth=617
     ClientHeight=439
     clientOffsetX=11
     clientOffsetY=2
     clientTextures(0)=Texture'DeusExUI.UserInterface.ImagesBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.ImagesBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.ImagesBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.ImagesBackground_4'
     clientTextures(4)=Texture'DeusExUI.UserInterface.ImagesBackground_5'
     clientTextures(5)=Texture'DeusExUI.UserInterface.ImagesBackground_6'
     clientBorderTextures(0)=Texture'DeusExUI.UserInterface.ImagesBorder_1'
     clientBorderTextures(1)=Texture'DeusExUI.UserInterface.ImagesBorder_2'
     clientBorderTextures(2)=Texture'DeusExUI.UserInterface.ImagesBorder_3'
     clientBorderTextures(3)=Texture'DeusExUI.UserInterface.ImagesBorder_4'
     clientBorderTextures(4)=Texture'DeusExUI.UserInterface.ImagesBorder_5'
     clientBorderTextures(5)=Texture'DeusExUI.UserInterface.ImagesBorder_6'
     clientTextureRows=2
     clientTextureCols=3
     clientBorderTextureRows=2
     clientBorderTextureCols=3
}
