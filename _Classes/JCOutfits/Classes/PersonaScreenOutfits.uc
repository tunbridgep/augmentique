//=============================================================================
// PersonaScreenOutfits. Based off PersonaScreenImages
//=============================================================================

class PersonaScreenOutfits extends PersonaScreenBaseWindow;

#exec OBJ LOAD FILE=DeusEx

var PersonaActionButtonWindow btnEquip;
var PersonaActionButtonWindow btnEdit;
var PersonaActionButtonWindow btnChangeCamera;
var PersonaActionButtonWindow btnSettings;

var PersonaListWindow         lstOutfits;
var PersonaScrollAreaWindow   winScroll;
var PersonaHeaderTextWindow   winOutfitName;
var PersonaCheckBoxWindow     chkAccessories;
var PersonaCheckBoxWindow     chkDescriptions;
var ViewportWindow            winViewport;

var PersonaActionButtonWindow   btnSlotsNext[23];
var PersonaActionButtonWindow   btnSlotsPrev[23];
var PersonaHeaderTextWindow     txtSlots[23];
var PersonaHeaderTextWindow     txtDescription;

var PersonaActionButtonWindow   btnModelVariantNext;
var PersonaActionButtonWindow   btnModelVariantPrev;
var PersonaHeaderTextWindow     txtModelVariant;

var localized String ChangeCameraLabel;
var localized String ShowAccessoriesLabel;
var localized String ShowDescriptionsLabel;
var localized String MiniModeLabel;
var localized String OutfitsTitleText;
var localized String EquipButtonLabel;
var localized String EditButtonLabel;
var localized String SettingsButtonLabel;
var localized String NewLabel;
var localized String ModelVariantLabel;
var localized String PartButtonNames[23];

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

var transient bool bMiniMode;

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
    CreateModelVariantButton();
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
    CreatePartButton(0);
    CreatePartButton(1);
    CreatePartButton(2);
    CreatePartButton(3);
    CreatePartButton(4);
    CreatePartButton(5);
    CreatePartButton(6);
    CreatePartButton(7);
    CreatePartButton(8);
    CreatePartButton(9);
    CreatePartButton(10);
    CreatePartButton(11);
    CreatePartButton(12);
    CreatePartButton(13);
    CreatePartButton(14);
    CreatePartButton(15);
    CreatePartButton(16);
    CreatePartButton(17);
    CreatePartButton(18);
    CreatePartButton(19);
    CreatePartButton(20);
    CreatePartButton(21);
    CreatePartButton(22);
    UpdateOutfitPartButtons();
}

function UpdateOutfitPartButtons()
{
    customButtonCount = 0;
    UpdateModelVariantsButtons();
    UpdateOutfitPartButton(0,"");
    UpdateOutfitPartButton(1,PartButtonNames[0]);
    UpdateOutfitPartButton(2,PartButtonNames[0]);
    UpdateOutfitPartButton(3,PartButtonNames[1]);
    UpdateOutfitPartButton(4,PartButtonNames[6]);
    UpdateOutfitPartButton(5,PartButtonNames[8]);
    UpdateOutfitPartButton(6,PartButtonNames[7]);
    UpdateOutfitPartButton(7,PartButtonNames[9]);
    UpdateOutfitPartButton(8,PartButtonNames[2]);
    UpdateOutfitPartButton(9,PartButtonNames[2]);
    UpdateOutfitPartButton(10,PartButtonNames[2]);
    UpdateOutfitPartButton(11,PartButtonNames[3]);
    UpdateOutfitPartButton(12,PartButtonNames[3]);
    UpdateOutfitPartButton(13,PartButtonNames[3]);
    UpdateOutfitPartButton(14,PartButtonNames[3]);
    UpdateOutfitPartButton(15,PartButtonNames[3]);
    UpdateOutfitPartButton(16,PartButtonNames[3]);
    UpdateOutfitPartButton(17,PartButtonNames[5]);
    UpdateOutfitPartButton(18,PartButtonNames[4]);
    UpdateOutfitPartButton(19,PartButtonNames[4]);
    UpdateOutfitPartButton(20,PartButtonNames[4]);
    UpdateOutfitPartButton(21,PartButtonNames[4]);
    UpdateOutfitPartButton(22,PartButtonNames[10]);
}

function UpdateModelVariantsButtons()
{
    //SARGE: I have no idea why this is required...
    local OutfitManager O;
    local int count;
    O = outfitManager;

    //Only show when we're in edit mode and our outfit has multiple body types
    if (O != None && O.currOutfit == O.customOutfit && bEditMode)
    {
        count = O.currOutfit.partsGroup.NumMeshes();
        if (count > 1)
        {
            btnModelVariantPrev.SetPos(customButtonStartOffsetX,customButtonStartOffsetY + (customButtonCount * customButtonAddPerButtonY));
            btnModelVariantNext.SetPos(customButtonStartOffsetX + 30,customButtonStartOffsetY + (customButtonCount * customButtonAddPerButtonY));
            txtModelVariant.SetPos(customButtonStartOffsetX + 60,customButtonStartOffsetY + (customButtonCount * customButtonAddPerButtonY) + 2);
            txtModelVariant.SetText(ModelVariantLabel $ ":" @ O.currOutfit.partsGroup.GetMeshMenuName(O.currOutfit.groupMeshID));
            btnModelVariantNext.Show();
            btnModelVariantPrev.Show();
            txtModelVariant.Show();
            customButtonCount++;
        }
        else
        {
            btnModelVariantNext.Hide();
            btnModelVariantPrev.Hide();
            txtModelVariant.Hide();
        }
    }
    AskParentForReconfigure();
}

function SetNextModelVariant(optional bool bPrevious)
{
    local OutfitManager O;
    local int id, count;
    O = outfitManager;

    if (O != None && O.customOutfit == O.currOutfit)
    {
        if (bPrevious)
            id = O.customOutfit.groupMeshID - 1;
        else
            id = O.customOutfit.groupMeshID + 1;
        count = outfitManager.customOutfit.partsGroup.NumMeshes();

        //Wrap around
        if (id >= count)
            id = 0;
        if (id < 0)
            id = count - 1;
        
        O.customOutfit.groupMeshID = id;
    
        O.EquipCustomOutfit();
        O.ApplyCurrentOutfit();
    }
}

function UpdateOutfitPartButton(int id, string label)
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
            txtSlots[id].SetText(label $ ":" @ O.currOutfit.GetPartOfType(id).name);
            customButtonCount++;
            return;
        }
    }

    btnSlotsPrev[id].Hide();
    btnSlotsNext[id].Hide();
    txtSlots[id].Hide();
}

function PersonaActionButtonWindow CreateModelVariantButton()
{
    btnModelVariantNext = PersonaActionButtonWindow(winClient.NewChild(class'PersonaActionButtonWindow'));
    //btnModelVariantNext.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 208, 25);
    btnModelVariantNext.SetButtonText(">");
    
    btnModelVariantPrev = PersonaActionButtonWindow(winClient.NewChild(class'PersonaActionButtonWindow'));
    //btnModelVariantPrev.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 248, 25);
    btnModelVariantPrev.SetButtonText("<");
            
    txtModelVariant = PersonaHeaderTextWindow(winClient.NewChild(class'PersonaHeaderTextWindow'));
    //txtModelVariant.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 210, 25+20);
	txtModelVariant.SetTextAlignments(HALIGN_Right, VALIGN_Top);
    txtModelVariant.SetText("");
    //UpdateModelVariantsButtons();
    btnModelVariantNext.Hide();
    btnModelVariantPrev.Hide();
    txtModelVariant.Hide();
}

function PersonaActionButtonWindow CreatePartButton(int partID)
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
	winActionButtons.SetWidth(359);
	winActionButtons.FillAllSpace(False);

    btnSettings = PersonaActionButtonWindow(winActionButtons.NewChild(Class'PersonaActionButtonWindow'));
    btnSettings.SetButtonText(SettingsButtonLabel);
    
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
    chkAccessories.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 23, 424);
    chkAccessories.SetText(ShowAccessoriesLabel);

    chkDescriptions = PersonaCheckBoxWindow(winClient.NewChild(Class'PersonaCheckBoxWindow'));
    chkDescriptions.SetWindowAlignments(HALIGN_Right, VALIGN_Top, 223, 424);
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
    //UpdateModelVariantsButtons();
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
    //UpdateModelVariantsButtons();
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
    //UpdateModelVariantsButtons();
    AskParentForReconfigure();
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool ButtonActivated( Window buttonPressed )
{
	local bool bHandled;
    local int i;

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

		case btnModelVariantNext:
            SetNextModelVariant();
            UpdateOutfitPartButtons();
            break;
		
        case btnModelVariantPrev:
            SetNextModelVariant(true);
            UpdateOutfitPartButtons();
            break;
		
        case btnChangeCamera:
            bCameraChange = !bCameraChange;
            winViewport.SetViewportLocation(GetViewportLocation(),true);
            break;
		
        case btnSettings:
            player.InvokeUIScreen(class'OutfitSettingsMenu');
			break;
		default:
			bHandled = False;
            break;
	}

    for (i = 0;i < ArrayCount(btnSlotsPrev);i++) 
    {
        if (buttonPressed == btnSlotsPrev[i])
        {
            PrevCustomOutfitSlot(i);
            bHandled = true;
        }
    }
    
    for (i = 0;i < ArrayCount(btnSlotsNext);i++) 
    {
        if (buttonPressed == btnSlotsNext[i])
        {
            NextCustomOutfitSlot(i);
            bHandled = true;
        }
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
    
    if (outfitManager != None && outfitManager.bSettingsMenuDisabled)
        btnSettings.Hide();
    else
        btnSettings.Show();
    
    if (outfitManager != None && outfitManager.bDescriptionsCheckbox)
    {
        chkDescriptions.Show();
        chkDescriptions.SetToggle(!outfitManager.noDescriptions);
        chkDescriptions.SetSensitivity(true);
    }
    else
        chkDescriptions.Hide();
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
    //UpdateModelVariantsButtons();
    //PopulateOutfitsList();

    //Update description text
    if (!outfitManager.noDescriptions)
        txtDescription.SetText(outfitManager.currOutfit.Desc);

    EnableButtons();
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
     SettingsButtonLabel="Settings"
     ChangeCameraLabel="Change View"
     ModelVariantLabel="Body Type"
     NewLabel="(New)"
     PartButtonNames(0)="Skin"
     PartButtonNames(1)="Main"
     PartButtonNames(2)="Coat"
     PartButtonNames(3)="Torso"
     PartButtonNames(4)="Legs"
     PartButtonNames(5)="Skirt"
     PartButtonNames(6)="Glasses"
     PartButtonNames(7)="Helmet"
     PartButtonNames(8)="Hat"
     PartButtonNames(9)="Mask"
     PartButtonNames(10)="Ponytail"
     clientBorderOffsetY=35
     ClientWidth=617
     ClientHeight=439
     clientOffsetX=11
     clientOffsetY=2
     clientTextures(0)=Texture'DeusExUI.UserInterface.ImagesBackground_1'
     clientTextures(1)=Texture'DeusExUI.UserInterface.ImagesBackground_2'
     clientTextures(2)=Texture'DeusExUI.UserInterface.ImagesBackground_3'
     clientTextures(3)=Texture'DeusExUI.UserInterface.ImagesBackground_4'
     clientTextures(4)=Texture'Augmentique.UserInterface.OutfitsBackground_5'
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
