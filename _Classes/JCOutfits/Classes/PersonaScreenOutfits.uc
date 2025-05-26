//=============================================================================
// PersonaScreenOutfits. Based off PersonaScreenImages
//=============================================================================

class PersonaScreenOutfits extends PersonaScreenBaseWindow;

#exec OBJ LOAD FILE=DeusEx

var PersonaActionButtonWindow btnEquip;
var PersonaActionButtonWindow btnEdit;
var PersonaActionButtonWindow btnChangeCamera;

var PersonaListWindow         lstOutfits;
var PersonaScrollAreaWindow   winScroll;
var PersonaHeaderTextWindow   winOutfitName;
var PersonaCheckBoxWindow     chkAccessories;
var PersonaCheckBoxWindow     chkDescriptions;
var ViewportWindow            winViewport;

var PersonaActionButtonWindow   btnSlotsNext[19];
var PersonaActionButtonWindow   btnSlotsPrev[19];
var PersonaHeaderTextWindow     txtSlots[19];
var PersonaHeaderTextWindow     txtDescription;

var localized String ChangeCameraLabel;
var localized String ShowAccessoriesLabel;
var localized String ShowDescriptionsLabel;
var localized String OutfitsTitleText;
var localized String EquipButtonLabel;
var localized String EditButtonLabel;
var localized String NewLabel;

//The offset for the start of the buttons
var int customButtonStartOffsetX;
var int customButtonStartOffsetY;
var int customButtonAddPerButtonY;
var int customButtonCount;

var transient int rowIDLastEquipped;

var OutfitManager outfitManager;

var transient int selectedRowId;
var transient bool bCameraChange;
var transient bool bEditMode;

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

    if (!outfitManager.noDescriptions)
        txtDescription.SetText(outfitManager.currOutfit.Desc);
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
    CreateCheckboxes();
    CreateOutfitPartButtons();
    CreateDescriptionTextArea();
}

// ----------------------------------------------------------------------
// CreateOutfitPartButtons()
// ----------------------------------------------------------------------

function CreateOutfitPartButtons()
{
    customButtonStartOffsetX = 20;
    customButtonStartOffsetY = 25;
    customButtonAddPerButtonY = 20;
    CreatePartButton(0,"Skin");
    CreatePartButton(1,"Skin");
    CreatePartButton(2,"Coat");
    CreatePartButton(3,"Coat");
    CreatePartButton(4,"Coat");
    CreatePartButton(5,"Torso");
    CreatePartButton(6,"Torso");
    CreatePartButton(7,"Torso");
    CreatePartButton(8,"Torso");
    CreatePartButton(9,"Torso");
    CreatePartButton(10,"Legs");
    CreatePartButton(11,"Legs");
    CreatePartButton(12,"Legs");
    CreatePartButton(13,"Legs");
    CreatePartButton(14,"Skirt");
    CreatePartButton(15,"Glasses");
    CreatePartButton(16,"Helmet");
    CreatePartButton(17,"Main");
    CreatePartButton(18,"Mask");
    UpdateOutfitPartButtons();
}

function UpdateOutfitPartButtons()
{
    customButtonCount = 0;
    UpdateOutfitPartButton(0);
    UpdateOutfitPartButton(1);
    UpdateOutfitPartButton(2);
    UpdateOutfitPartButton(3);
    UpdateOutfitPartButton(4);
    UpdateOutfitPartButton(5);
    UpdateOutfitPartButton(6);
    UpdateOutfitPartButton(7);
    UpdateOutfitPartButton(8);
    UpdateOutfitPartButton(9);
    UpdateOutfitPartButton(10);
    UpdateOutfitPartButton(11);
    UpdateOutfitPartButton(12);
    UpdateOutfitPartButton(13);
    UpdateOutfitPartButton(14);
    UpdateOutfitPartButton(15);
    UpdateOutfitPartButton(16);
    UpdateOutfitPartButton(17);
    UpdateOutfitPartButton(18);
    UpdateOutfitPartButton(19);
}

function UpdateOutfitPartButton(int id)
{
    //SARGE: I have no idea why this is required...
    local OutfitManager O;
    local int count;
    O = outfitManager;

    //Only show when we're on the custom outfit and in edit mode
    if (O != None && O.currOutfit != None && O.currOutfit == O.customOutfit && bEditMode)
    {

        count = O.currOutfit.partsGroup.CountPartType(id,true);

        //Only show the part button if it's for a valid outfit part.
        if (count > 1)
        {
            btnSlotsPrev[id].SetPos(customButtonStartOffsetX,customButtonStartOffsetY + (customButtonCount * customButtonAddPerButtonY));
            btnSlotsNext[id].SetPos(customButtonStartOffsetX + 30,customButtonStartOffsetY + (customButtonCount * customButtonAddPerButtonY));
            btnSlotsPrev[id].Show();
            btnSlotsNext[id].Show();
            txtSlots[id].SetPos(customButtonStartOffsetX + 60,customButtonStartOffsetY + (customButtonCount * customButtonAddPerButtonY) + 2);
            txtSlots[id].Show();
            txtSlots[id].SetText(O.currOutfit.GetPartOfType(id).name);
            customButtonCount++;
            return;
        }
    }

    btnSlotsPrev[id].Hide();
    btnSlotsNext[id].Hide();
    txtSlots[id].Hide();
}

function PersonaActionButtonWindow CreatePartButton(int partID, string label)
{
    local PersonaActionButtonWindow newBtn;
    local PersonaHeaderTextWindow newTxt;

    newBtn = PersonaActionButtonWindow(winClient.NewChild(class'PersonaActionButtonWindow'));
    newBtn.SetButtonText("<");
    newBtn.Hide();

    btnSlotsPrev[partID] = newBtn;

    newBtn = PersonaActionButtonWindow(winClient.NewChild(class'PersonaActionButtonWindow'));
    newBtn.SetButtonText(">");
    newBtn.Hide();
    
    btnSlotsNext[partID] = newBtn;
    
    newTxt = PersonaHeaderTextWindow(winClient.NewChild(class'PersonaHeaderTextWindow'));

    txtSlots[partID] = newTxt;
}

// ----------------------------------------------------------------------
// CreateViewportWindow()
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
    {
        if (bCameraChange)
            loc.Z = player.BaseEyeHeight - 15;
        else
            loc.Z = player.BaseEyeHeight + 15;
    }
    else if (bCameraChange)
        loc.Z = player.BaseEyeHeight - 55;
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
	lstOutfits.SetNumColumns(4);
	lstOutfits.HideColumn(2, True);
	lstOutfits.HideColumn(3, True);
	lstOutfits.SetSortColumn(0, True);
	lstOutfits.EnableAutoSort(False);
	lstOutfits.SetColumnWidth(0, 140);
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
    
    btnChangeCamera = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnChangeCamera.SetButtonText(ChangeCameraLabel);
	
    btnEdit = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnEdit.SetButtonText(EditButtonLabel);

	btnEquip = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
	btnEquip.SetButtonText(EquipButtonLabel);
}

// ----------------------------------------------------------------------
// CreateCheckboxes()
// ----------------------------------------------------------------------

function CreateCheckboxes()
{
    chkAccessories = PersonaCheckBoxWindow(winClient.NewChild(Class'PersonaCheckBoxWindow'));
    chkAccessories.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 203, 424);
    chkAccessories.SetText(ShowAccessoriesLabel);
    
    chkDescriptions = PersonaCheckBoxWindow(winClient.NewChild(Class'PersonaCheckBoxWindow'));
    chkDescriptions.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 23, 424);
    chkDescriptions.SetText(ShowDescriptionsLabel);
}

function CreateDescriptionTextArea()
{
    txtDescription = PersonaHeaderTextWindow(winClient.NewChild(class'PersonaHeaderTextWindow'));
    txtDescription.SetWindowAlignments(HALIGN_Left, VALIGN_Bottom, 65, 20);
	txtDescription.SetSize(300, 300);
    txtDescription.SetTextAlignments(HALIGN_Center, VALIGN_Bottom);
    txtDescription.SetWordWrap(true);
}

// ----------------------------------------------------------------------
// PopulateOutfitsList()
// ----------------------------------------------------------------------

function PopulateOutfitsList()
{
    local Outfit O;
	local int rowId, i;
    local string sortName;

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

		rowId = lstOutfits.AddRow(O.Name);

        if (O.bNew)
            lstOutfits.SetField(rowId, 0, O.name @ NewLabel);

        if (outfitManager.IsEquipped(i))
        {
    		lstOutfits.SetField(rowId, 1, "C");
            rowIDLastEquipped = rowId;
        }

        // Set the outfit number to the second column
        lstOutfits.SetFieldValue(rowId, 2, i);
        
        // Set up the third column for sorting

        //Custom always goes to the top,
        //New are below it
        if (i == 0)
            sortName = "000000" $ O.Name;
        else if (O.bNew)
            sortName = "000001" $ O.Name;
        else if (i == 1) //default
            sortName = "000002" $ O.Name;
        else
            sortName = O.name;
        
        lstOutfits.SetField(rowId, 3, sortName);
	}
    
    //Sort by name
    lstOutfits.SetSortColumn(3, false);
    lstOutfits.Sort();
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
// EquipCustomOutfit()
// ----------------------------------------------------------------------

function EquipCustomOutfit()
{
    outfitManager.EquipCustomOutfit();
    outfitManager.ApplyCurrentOutfit();
    PopulateOutfitsList();
    UpdateOutfitPartButtons();
    txtDescription.SetText("");
}

// ----------------------------------------------------------------------
// PrevCustomOutfitSlot()
// ----------------------------------------------------------------------

function PrevCustomOutfitSlot(int slot)
{
    local Outfit O;
    local OutfitPart P1, P2;
    local int index;

    outfitManager.EquipCustomOutfit();
    O = outfitManager.currOutfit;
    P1 = O.GetPartOfType(slot);
    if (P1 != None)
    {
        P2 = O.partsGroup.GetPreviousPartOfType(slot,P1.index);
        O.ReplacePart(slot,P2);
    }
    outfitManager.ApplyCurrentOutfit();
    PopulateOutfitsList();
    UpdateOutfitPartButtons();
    AskParentForReconfigure();
}
// ----------------------------------------------------------------------
// NextCustomOutfitSlot()
// ----------------------------------------------------------------------

function NextCustomOutfitSlot(int slot)
{
    local Outfit O;
    local OutfitPart P1, P2;
    local int index;

    outfitManager.EquipCustomOutfit();
    O = outfitManager.currOutfit;
    P1 = O.GetPartOfType(slot);
    if (P1 != None)
    {
        P2 = O.partsGroup.GetNextPartOfType(slot,P1.index);
        O.ReplacePart(slot,P2);
    }
    outfitManager.ApplyCurrentOutfit();
    PopulateOutfitsList();
    UpdateOutfitPartButtons();
    AskParentForReconfigure();
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

		case btnEdit:
            outfitManager.noAccessories = false;
            bEditMode = !bEditMode;
            EquipCustomOutfit();
            EnableButtons();
            break;
		
        case btnChangeCamera:
            bCameraChange = !bCameraChange;
            winViewport.SetViewportLocation(GetViewportLocation(),true);
            break;

        case btnSlotsPrev[0]: PrevCustomOutfitSlot(0); break;
        case btnSlotsPrev[1]: PrevCustomOutfitSlot(1); break;
        case btnSlotsPrev[2]: PrevCustomOutfitSlot(2); break;
        case btnSlotsPrev[3]: PrevCustomOutfitSlot(3); break;
        case btnSlotsPrev[4]: PrevCustomOutfitSlot(4); break;
        case btnSlotsPrev[5]: PrevCustomOutfitSlot(5); break;
        case btnSlotsPrev[6]: PrevCustomOutfitSlot(6); break;
        case btnSlotsPrev[7]: PrevCustomOutfitSlot(7); break;
        case btnSlotsPrev[8]: PrevCustomOutfitSlot(8); break;
        case btnSlotsPrev[9]: PrevCustomOutfitSlot(9); break;
        case btnSlotsPrev[10]: PrevCustomOutfitSlot(10); break;
        case btnSlotsPrev[11]: PrevCustomOutfitSlot(11); break;
        case btnSlotsPrev[12]: PrevCustomOutfitSlot(12); break;
        case btnSlotsPrev[13]: PrevCustomOutfitSlot(13); break;
        case btnSlotsPrev[14]: PrevCustomOutfitSlot(14); break;
        case btnSlotsPrev[15]: PrevCustomOutfitSlot(15); break;
        case btnSlotsPrev[16]: PrevCustomOutfitSlot(16); break;
        case btnSlotsPrev[17]: PrevCustomOutfitSlot(17); break;
        case btnSlotsPrev[18]: PrevCustomOutfitSlot(18); break;

        case btnSlotsNext[0]: NextCustomOutfitSlot(0); break;
        case btnSlotsNext[1]: NextCustomOutfitSlot(1); break;
        case btnSlotsNext[2]: NextCustomOutfitSlot(2); break;
        case btnSlotsNext[3]: NextCustomOutfitSlot(3); break;
        case btnSlotsNext[4]: NextCustomOutfitSlot(4); break;
        case btnSlotsNext[5]: NextCustomOutfitSlot(5); break;
        case btnSlotsNext[6]: NextCustomOutfitSlot(6); break;
        case btnSlotsNext[7]: NextCustomOutfitSlot(7); break;
        case btnSlotsNext[8]: NextCustomOutfitSlot(8); break;
        case btnSlotsNext[9]: NextCustomOutfitSlot(9); break;
        case btnSlotsNext[10]: NextCustomOutfitSlot(10); break;
        case btnSlotsNext[11]: NextCustomOutfitSlot(11); break;
        case btnSlotsNext[12]: NextCustomOutfitSlot(12); break;
        case btnSlotsNext[13]: NextCustomOutfitSlot(13); break;
        case btnSlotsNext[14]: NextCustomOutfitSlot(14); break;
        case btnSlotsNext[15]: NextCustomOutfitSlot(15); break;
        case btnSlotsNext[16]: NextCustomOutfitSlot(16); break;
        case btnSlotsNext[17]: NextCustomOutfitSlot(17); break;
        case btnSlotsNext[18]: NextCustomOutfitSlot(18); break;

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
    else if (button == chkDescriptions)
    {
        outfitManager.noDescriptions = !bToggleValue;
        if (bToggleValue)
            txtDescription.SetText(outfitManager.currOutfit.Desc);
        else
            txtDescription.SetText("");

        outfitManager.SaveConfig();
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
    if (outfitManager.currOutfit.HasAccessories() && !bEditMode)
        chkAccessories.Show();
    else
        chkAccessories.Hide();

    chkAccessories.SetToggle(!outfitManager.noAccessories);
	chkAccessories.SetSensitivity(true);
    
    chkDescriptions.SetToggle(!outfitManager.noDescriptions);
	chkDescriptions.SetSensitivity(true);
}

// ----------------------------------------------------------------------
// Equip()
// ----------------------------------------------------------------------

function Equip(int index)
{
    bEditMode = false;
    //player.ClientMessage("Index: " $ index);
    outfitManager.EquipOutfit(index);

    //Clear the chevron on the previously equipped outfit
    lstOutfits.SetField(rowIDLastEquipped, 1, "");

    //Set chevron on new outfit
    lstOutfits.SetField(selectedRowId, 1, "C");

    rowIDLastEquipped = selectedRowId;
    
    UpdateOutfitPartButtons();
    //PopulateOutfitsList();

    //Update description text
    if (!outfitManager.noDescriptions)
        txtDescription.SetText(outfitManager.currOutfit.Desc);

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
     ShowDescriptionsLabel="Show Descriptions"
     OutfitsTitleText="Outfits"
     EquipButtonLabel="Equip"
     EditButtonLabel="Customize Outfit"
     ChangeCameraLabel="Change View"
     NewLabel="(New)"
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
