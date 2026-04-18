//=============================================================================
// PersonaInfoWindow
//=============================================================================

class PersonaInfoWindow expands PersonaBaseWindow;

var PersonaScrollAreaWindow      winScroll;
var TileWindow                   winTile;
var PersonaHeaderTextWindow      winTitle;
var PersonaNormalLargeTextWindow winText;			// Last text

var int textVerticalOffset;

//AUGMENTIQUE - Weapon Skin Selection
var localized string msgSkinNext;
var localized string msgSkinPrev;
var localized string msgSkinName;
var PersonaNormalLargeTextWindow winSkinName;
var PersonaActionButtonWindow buttonNextSkin;
var PersonaActionButtonWindow buttonPrevSkin;
var Inventory skinWeapon;

// ----------------------------------------------------------------------
// AUGMENTIQUE: AddSkinsButtons()
// ----------------------------------------------------------------------

function AddSkinsButtons(DeusExWeapon wep)
{
    local PersonaButtonBarWindow skinBtnWin;
	if (wep != None)
	{
        winSkinName = SetText(sprintf(msgSkinName,player.WeaponSkinManager.GetSkinName(wep)));
		skinBtnWin = PersonaButtonBarWindow(winTile.NewChild(class'PersonaButtonBarWindow'));
		skinBtnWin.SetWidth(32);
		skinBtnWin.FillAllSpace(false);
		
        buttonNextSkin = PersonaActionButtonWindow(skinBtnWin.NewChild(class'PersonaActionButtonWindow'));
        buttonNextSkin.SetButtonText(msgSkinNext);

		buttonPrevSkin = PersonaActionButtonWindow(skinBtnWin.NewChild(class'PersonaActionButtonWindow'));
        buttonPrevSkin.SetButtonText(msgSkinPrev);

		skinWeapon = wep;
		AddLine();
	}
}

function UpdateSkinName()
{
    local DeusExWeapon wep;
    wep = DeusExWeapon(skinWeapon);

    if (winSkinName != None && wep != None)
        winSkinName.SetText(sprintf(msgSkinName,player.WeaponSkinManager.GetSkinName(wep)));
}

function bool ButtonActivated (Window buttonPressed)
{
    local bool bHandled;

	if (Super.ButtonActivated(buttonPressed))
		return true;

	bHandled = true;

    switch(buttonPressed)
    {
		case buttonPrevSkin:
            DeusExWeapon(skinWeapon).SelectPreviousSkin();
            UpdateSkinName();
            break;
		case buttonNextSkin:
            DeusExWeapon(skinWeapon).SelectNextSkin();
            UpdateSkinName();
            break;
		default:
			bHandled = false;
			break;
    }

    return bHandled;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

event InitWindow()
{
	Super.InitWindow();

	CreateControls();
}

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateControls()
{
	winTitle = PersonaHeaderTextWindow(NewChild(Class'PersonaHeaderTextWindow'));
	winTitle.SetTextMargins(2, 1);

	winScroll = PersonaScrollAreaWindow(NewChild(Class'PersonaScrollAreaWindow'));

	winTile = TileWindow(winScroll.ClipWindow.NewChild(Class'TileWindow'));
	winTile.SetOrder(ORDER_Down);
	winTile.SetChildAlignments(HALIGN_Full, VALIGN_Top);
	winTile.MakeWidthsEqual(True);
	winTile.MakeHeightsEqual(False);
	winTile.SetMargins(4, 1);
	winTile.SetMinorSpacing(0);
	winTile.SetWindowAlignments(HALIGN_Full, VALIGN_Top);
}

// ----------------------------------------------------------------------
// SetTitle()
//
// Assume that if we're setting the title we're looking at another
// item and to clear the existing contents.
// ----------------------------------------------------------------------

function SetTitle(String newTitle)
{
	Clear();
	winTitle.SetText(newTitle);
}

// ----------------------------------------------------------------------
// SetText()
// ----------------------------------------------------------------------

function PersonaNormalLargeTextWindow SetText(String newText)
{
	winText = PersonaNormalLargeTextWindow(winTile.NewChild(Class'PersonaNormalLargeTextWindow'));

	winText.SetTextMargins(0, 0);
	winText.SetWordWrap(True);
	winText.SetTextAlignments(HALIGN_Left, VALIGN_Top);
	winText.SetText(newText);

	return winText;
}

// ----------------------------------------------------------------------
// AppendText()
// ----------------------------------------------------------------------

function AppendText(String newText)
{
	if (winText != None)
		winText.AppendText(newText);
	else
		SetText(newText);
}

// ----------------------------------------------------------------------
// AddInfoItem()
// ----------------------------------------------------------------------

function PersonaInfoItemWindow AddInfoItem(coerce String newLabel, coerce String newText, optional bool bHighlight)
{
	local PersonaInfoItemWindow winItem;

	winItem = PersonaInfoItemWindow(winTile.NewChild(Class'PersonaInfoItemWindow'));
	winItem.SetItemInfo(newLabel, newText, bHighlight);

	return winItem;
}

// ----------------------------------------------------------------------
// AddLine()
// ----------------------------------------------------------------------

function AddLine()
{
	winTile.NewChild(Class'PersonaInfoLineWindow');
}

// ----------------------------------------------------------------------
// Clear()
// ----------------------------------------------------------------------

function Clear()
{
	winTitle.SetText("");	
	winTile.DestroyAllChildren();
}

// ----------------------------------------------------------------------
// ConfigurationChanged()
// ----------------------------------------------------------------------

function ConfigurationChanged()
{
	local float qWidth, qHeight;

	if (winTitle != None)
	{
		winTitle.QueryPreferredSize(qWidth, qHeight);
		winTitle.ConfigureChild(0, 0, width, qHeight);
	}

	if (winScroll != None)
	{
		winScroll.QueryPreferredSize(qWidth, qHeight);
		winScroll.ConfigureChild(0, textVerticalOffset, width, height - textVerticalOffset);
	}
}

// ----------------------------------------------------------------------
// ChildRequestedReconfiguration()
// ----------------------------------------------------------------------

function bool ChildRequestedReconfiguration(window child)
{
	ConfigurationChanged();

	return True;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     textVerticalOffset=20
     msgSkinNext="Next"
     msgSkinPrev="Prev"
     msgSkinName="Current Skin: %s"
}
