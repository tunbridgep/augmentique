## Intro

This guide is designed to serve as a comprehensive resource to allow mod
authors to add JC Outfits support to their mod. It details all of the steps
required in order to integrate the outfits system into your mod as seamlessly
as possible. The Outfits mod has been designed to be as modular as possible,
with almost all functionality being held within `JCOutfits.u`, with only
minimal changes being required to core game classes. This mod is designed to be
integrated in a way that makes it optional - for users with JC Outfits
installed, they will see the Outfits screen. For everyone else, this
functionality will be hidden and the outfits system will be disabled.

`JCOutfits.u` is designed to be completely self-contained, and exposes an API
to `DeusEx.u`. This means that it's possible for new versions of `JCOutfits.u` to
work with existing mods, even if those mods were only updated to work with a
previous version. **Because of this, it is highly recommended that you do not
include `JCOutfits.u` in your own mod. Instead, you should let players know that
it is compatible, but do not include it. This will mean that players who do
not want the functionality can easily avoid it, and will essentially
future-proof your mod in the long term against changes made to future Outfits
versions.**

*Note: All code edits in this file have been made using an unedited, vanilla
version of the Deus Ex codebase. Edits will be different and the examples won't
be the same in a modded environment.*

## Step-by-step integration

### Copy over files

Copy the provided `OutfitSpawner.uc`, `OutfitSpawner2.uc` and `OutfitManagerBase.uc` files into your
DeusEx classes folder.

### Edit DeusExPlayer.uc

The first edit should be made to `DeusExPlayer.uc`

First, locate the end of list of variables. It will usually be immediately
followed by a list of native functions.

Here's a snippet of what the end of the variable list looks like:

```
// For closing comptuers if the server quits
var Computers ActiveComputer;

// native Functions
native(1099) final function string GetDeusExVersion();
native(2100) final function ConBindEvents();
```

The following code needs to be inserted between the end of the variables and
the start of the native functions

```
// OUTFIT STUFF
var travel OutfitManagerBase outfitManager;
var globalconfig string unlockedOutfits[255];
```

Unless other edits have been made by your mod, in most cases, the code should
end up looking like this:

```
// For closing comptuers if the server quits
var Computers ActiveComputer;

// OUTFIT STUFF
var travel OutfitManagerBase outfitManager;
var globalconfig string unlockedOutfits[255];

// native Functions
native(1099) final function string GetDeusExVersion();
native(2100) final function ConBindEvents();
```

### Edit PersonaNavBarWindow.uc

Locate the start of the functions, which usually looks like this:

```
var localized String ImagesButtonLabel;
var localized String LogsButtonLabel;

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------
```

And insert the following code after the final variables, but before the start
of the functions:

```
//Sarge: Outfits Stuff
var PersonaNavButtonWindow btnOutfits;

var localized String ConsButtonLabelShort; //Sarge: Added
var localized String OutfitsButtonLabel;
```

Unless other edits have been made by your mod, in most cases, the code should
end up looking like this:

```
var localized String ImagesButtonLabel;
var localized String LogsButtonLabel;

//Sarge: Outfits Stuff
var PersonaNavButtonWindow btnOutfits;

var localized String ConsButtonLabelShort; //Sarge: Added
var localized String OutfitsButtonLabel;

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------
```

Next, locate the line `Super.CreateButtons()`, and add the following line above
it:

```    
CreateOutfitsButton();                  //Sarge: Added
```

Unless other edits have been made by your mod, in most cases, the code should
end up looking like this:

```
    btnAugs      = CreateNavButton(winNavButtons, AugsButtonLabel);
    btnHealth    = CreateNavButton(winNavButtons, HealthButtonLabel);
    btnInventory = CreateNavButton(winNavButtons, InventoryButtonLabel);

    CreateOutfitsButton();                  //Sarge: Added
    
    Super.CreateButtons();
}
```

Add the following code anywhere in the file (it is recommended to place it
right below the CreateButtons function):

```
// ----------------------------------------------------------------------
// CreateOutfitsButton()
// Will shorten the Conversations button to fit it in
// ----------------------------------------------------------------------

function CreateOutfitsButton()
{
    local class<PersonaScreenBaseWindow> test;
    test = class<PersonaScreenBaseWindow>(DynamicLoadObject("JCOutfits.PersonaScreenOutfits", class'Class'));

    //Only create the Outfits button if the outfits window is actually available
    if (test != None)
    {
        btnOutfits   = CreateNavButton(winNavButtons, OutfitsButtonLabel);
        btnCons.SetButtonText(ConsButtonLabelShort);
    }
}
```

Next, locate the following lines in the `ButtonActivated` function:

```
		case btnImages:
			winClass = Class'PersonaScreenImages';
			break;

		case btnLogs:
			winClass = Class'PersonaScreenLogs';
			break;

        default:
            bHandled = False;
            break;
```

Add the following code between the `btnLogs` case and the `default` case:

```
        //Sarge: Add new button for Outfits
		case btnOutfits:
            winClass = class<PersonaScreenBaseWindow>(DynamicLoadObject("JCOutfits.PersonaScreenOutfits", class'Class'));
			break;
```

Unless other edits have been made by your mod, in most cases, the code should
end up looking like this:

```
		case btnImages:
			winClass = Class'PersonaScreenImages';
			break;

		case btnLogs:
			winClass = Class'PersonaScreenLogs';
			break;
        
        //Sarge: Add new button for Outfits
		case btnOutfits:
            winClass = class<PersonaScreenBaseWindow>(DynamicLoadObject("JCOutfits.PersonaScreenOutfits", class'Class'));
			break;

        default:
            bHandled = False;
            break;
```

Finally, add the following two properties to the `defaultproperties` section:

```
     OutfitsButtonLabel="|&Outfits"
     ConsButtonLabelShort="|&Conv."
```

Unless other edits have been made by your mod, in most cases, the code should
end up looking like this:

```
     ConsButtonLabel="|&Conversations"
     ImagesButtonLabel="I|&mages"
     LogsButtonLabel="|&Logs"
     OutfitsButtonLabel="|&Outfits"
     ConsButtonLabelShort="|&Conv."
}
```
### Edit JCDentonMale.uc

First, find the `TravelPostAccept` function, which typically looks like this:

```
event TravelPostAccept()
{
	local DeusExLevelInfo info;

	Super.TravelPostAccept();

	switch(PlayerSkin)
	{
		case 0:	MultiSkins[0] = Texture'JCDentonTex0'; break;
		case 1:	MultiSkins[0] = Texture'JCDentonTex4'; break;
		case 2:	MultiSkins[0] = Texture'JCDentonTex5'; break;
		case 3:	MultiSkins[0] = Texture'JCDentonTex6'; break;
		case 4:	MultiSkins[0] = Texture'JCDentonTex7'; break;
	}
}
```

Insert the following lines at the end of the function:

```
//SARGE: Setup outfit manager
SetTimer(0.5,false);
```

Unless other edits have been made by your mod, in most cases, the code should
end up looking like this:

```
event TravelPostAccept()
{
	local DeusExLevelInfo info;

	Super.TravelPostAccept();

	switch(PlayerSkin)
	{
		case 0:	MultiSkins[0] = Texture'JCDentonTex0'; break;
		case 1:	MultiSkins[0] = Texture'JCDentonTex4'; break;
		case 2:	MultiSkins[0] = Texture'JCDentonTex5'; break;
		case 3:	MultiSkins[0] = Texture'JCDentonTex6'; break;
		case 4:	MultiSkins[0] = Texture'JCDentonTex7'; break;
	}

    //SARGE: Setup outfit manager
    SetTimer(0.5,false);
}
```

Finally, copy the following code below the `TravelPostAccept` function:

```
// ----------------------------------------------------------------------
// Timer()
// SARGE: We need to delay slightly before setting models, to allow mods like LDDP to work properly
// ----------------------------------------------------------------------

function Timer()
{
    Super.Timer();
    SetupOutfitManager();
}


// ----------------------------------------------------------------------
// ResetPlayerToDefaults()
// SARGE: When we start a new game, throw away our outfit manager
// ----------------------------------------------------------------------
function ResetPlayerToDefaults()
{
    outfitManager = None;
    Super.ResetPlayerToDefaults();
}

// ----------------------------------------------------------------------
// SetupOutfitManager()
// SARGE: Setup the outfit manager and restore current outfit
// ----------------------------------------------------------------------

function SetupOutfitManager()
{
    local class<OutfitManagerBase> managerBaseClass;

	// create the Outfit Manager if not found
	if (outfitManager == None)
    {
        //ClientMessage("Outfit Manager successfully created");
	    //outfitManager = new(Self) class'OutfitManager';
        managerBaseClass = class<OutfitManagerBase>(DynamicLoadObject("JCOutfits.OutfitManager", class'Class'));
        outfitManager = new(Self) managerBaseClass;
    }

    if (outfitManager != None)
    {
        //ClientMessage("Outfit Manager successfully inited");

        //Call base setup code, required each map load
        outfitManager.Setup(Self);
        
        //Add additional outfits below this line
        //---------------------------------------
        //See docs/mod_integration.pdf for more info
        //---------------------------------------

        //Re-assign current outfit
        outfitManager.ApplyCurrentOutfit();
    }
}
```

## Creating new Outfits

New outfits can be added quite easily, using the following code:

```
//MIB Suit
BeginNewOutfit("suit2","MIB Suit","Suit worn by MIBs","",true,false);
SetOutfitTextures("PantsTex5","skin","MIBTex1","MIBTex1","FramesTex2","LensesTex3");
SetOutfitAccessorySlots(1,1,1,1,1,1,0,0,1);
SetOutfitMesh("GM_Suit");
```

The possible function calls are as follows:

`BeginNewOutfit(string id, string n, string d, string preview, bool male, bool female)`

This function sets up a new outfit. All subsequent outfit-related function
calls will apply to this outfit until a `BeginNewOutfit` is called again.

The function arguments are as follows:

1. The ID of the outfit. Multiple Outfits with the same ID can be added, and
   will unlock together, allowing for alternate styles or separate male/female
   versions of outfits.
2. The Name of the outfit. This will appear in the outfit menu and on outfit
   spawners.
3. The outfit description. Currently unused but may be implemented in the
   future.
4. The preview image texture. This is used to show an image preview of the
   outfit in the outfits window.
5. Allow Males. This determines if Males can use the outfit. If playing as a
   female, any outfit spawners containing this item will be deleted and it
   won't appear in the Outfits menu.
6. Allow Females (LDDP). This determines if Lady Denton can use the outfit. If
   playing as a male, any outfit spawners containing this item will be deleted
   and it won't appear in the Outfits menu.

*Note: Allow Males and Allow Females can both be set to true to allow a fully
multi-gendered outfit. This is usually not recommended, as it's often better to
create 2 separate outfits with the same ID to allow using different meshes and
textures, but for some cases such as the scuba gear, creating a single outfit
with male and female both set to true is much easier.*

`SetOutfitMesh(string Mesh)`

This function simply sets the mesh for a given outfit. When equipping it,
the players mesh will be updated to the mesh specified.

*Note: If the mesh is present within the `DeusExCharacters` or `FemJC` groups,
you do not need to specify the full mesh path, and can instead simply use the
name. For example, `DeusExCharacters.GM_Trench` can simply be written as
`GM_Trench`*

*Note: If this function is omitted for a given outfit, it will use the default
model, which is `GM_Trench` for males and `GFM_Trench` for females.*

`SetOutfitTextures(optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7)`

This function determines which textures will be set on the player when an
outfit is equipped.

These are equivalent to slots 1-7 on the model.

Slot 0 (which is normally used for skin textures) is set using a different
function:

`SetOutfitBodyTex(string t0)`

Additionally, each model also allows a "main" texture, which is used
occasionally by some models (such as for the visor for the riot cop).

`SetOutfitMainTex(string tm)`

This table serves as a reference the different texture types used for each
model:

| Model Name      | Slot 1     | Slot 2  | Slot 3   | Slot 4    | Slot 5                       | Slot 6                       | Slot 7         | Main Texture |
|-----------------|------------|---------|----------|-----------|------------------------------|------------------------------|----------------|--------------|
| GM_Trench       | Trenchcoat | Pants   | Skin     | Shirt     | Trenchcoat                   | Glasses Frames               | Glasses Lenses | Nothing      |
| GM_DressShirt_S | Nothing    | Nothing | Pants    | Skin      | Shirt                        | Glasses Frames               | Glasses Lenses | Nothing      |
| GM_Suit         | Pants      | Skin    | Shirt    | Shirt     | Glasses Frames               | Glasses Lenses               | Hat            | Nothing      |
| GM_Jumpsuit     | Pants      | Shirt   | Facemask | Facemask  | GrayMaskTex (Mouth Covering) | Helmet                       | Nothing        | Visor        |
| GM_DressShirt   | Nonthing   | Nothing | Pants    | Skin      | Shirt                        | GrayMaskTex (Mouth Covering) | ???            | Nothing      |
| GFM_Trench      | Trenchcoat | Pants   | Skin     | Shirt     | Trenchcoat                   | Glasses Frames               | Glasses Lenses | Nothing      |
| GFM_SuitSkirt   | Nothing    | Skin    | Legs     | Dress Top | Dress Bottom/Skirt           | Glasses Frames               | Glasses Lenses | Nothing      |
| GFM_Dress       | Legs       | Skirt   | Shirt    | Skirt     | Skin                         | Nothing                      | Skin           | Nothing      |
| GM_ScubaSuit    | Vest       | Suit    | Nothing  | Nothing   | Nothing                      | Nothing                      | Nothing        | Suit         |

### Handling Accessories

Each outfit allows "accessories" to be toggled on and off. Accessories include things like glasses, hats, etc.

To completely disable the accessories feature for a specific outfit, the following function can be used:

`SetOutfitDisableAccessories()`

Additionally, texture slots can be associated with the accessories checkbox using the following function:

`SetOutfitAccessorySlots(int t0, int t1, int t2, int t3, int t4, int t5, int t6, int t7, int tm)`

The arguments are as follows:

1. t0 refers to the skin texture. Generally you don't want to change this
   unless you have a replacement
2. t1-t7 refer to the model skin texture slots 1-7
3. tm refers to the main texture on the model.

Each argument should have the value `0` if the particular texture is to be
hidden while accessories are toggled off. The value `1` specifies that it
should be visible always. Using a value of `2` is a special case, and will
replace the given texture slot with the players skin texture. This is used for
replacing the skin texture to add hats, beanies, etc when accessories are
toggled on, and replacing them with the default skin without. A value of `2`
should only be used in very specific circumstances.

By default, outfits will disable texture slots 6 and 7 and the main texture
when accessories are disabled, which corresponds to the glasses on the
`GM_Trench` and `GFM_Trench` models.

Here's an example use case:

In this example, model slots 5-7 are hidden when accessories are turned off.

`SetOutfitAccessorySlots(1,1,1,1,1,0,0,0,1);`

The `SetOutfitDisableAccessories()` function is equivalent to `SetOutfitAccessorySlots(1,1,1,1,1,1,1,1,1)`

## Outfit Creation Example

It is recommended to add any additional outfits at the end of the
`SetupOutfitManager` function, before the `ApplyCurrentOutfit();` line. For
example:

```
// ----------------------------------------------------------------------
// SetupOutfitManager()
// SARGE: Setup the outfit manager and restore current outfit
// ----------------------------------------------------------------------

function SetupOutfitManager()
{
    local class<OutfitManagerBase> managerBaseClass;

	// create the Outfit Manager if not found
	if (outfitManager == None)
    {
        //ClientMessage("Outfit Manager successfully created");
	    //outfitManager = new(Self) class'OutfitManager';
        managerBaseClass = class<OutfitManagerBase>(DynamicLoadObject("JCOutfits.OutfitManager", class'Class'));
        outfitManager = new(Self) managerBaseClass;
    }

    if (outfitManager != None)
    {
        //ClientMessage("Outfit Manager successfully inited");

        //Call base setup code, required each map load
        outfitManager.Setup(Self);

        //Add additional outfits below this line
        //---------------------------------------
        //MIB Suit
        BeginNewOutfit("suit2","MIB Suit","Suit worn by MIBs","",true,false);
        SetOutfitTextures("PantsTex5","skin","MIBTex1","MIBTex1","FramesTex2","LensesTex3");
        SetOutfitAccessorySlots(1,1,1,1,1,1,0,0,1);
        SetOutfitMesh("GM_Suit");
        //---------------------------------------

        //Re-assign current outfit
        outfitManager.ApplyCurrentOutfit();
    }
}

```

## Handling Skin Colours

It is possible to create outfits which reflect the players chosen skin colour.

The mod automatically looks for textures named `<texture>_S[0-4]`, where the
numbers 0-4 represent the available skin colours (white, black, hispanic,
ginger, albino), when given a base texture name.

So for instance, you might add a new outfit with the texture `MyShirtTex01`.
Your mod can additionally contain a texture `MyShirtTex01_S1` for a version
containing dark skin, `MyShirtTex_S2` for hispanic, etc.

You can then simply add the default texture in the AddOutfit call, like so:

```
outfitManager.AddOutfit("myOutfit","My Cool Outfit","previewTex",true,false,"GM_Suit","PantsTex10","skin","MyShirtTex01","MyShirtTex02","GrayMaskTex","BlackMaskTex","MyShirtTex03",6);
```

*Note: It is recommended to include a default version of `MyShirtTex01`, and
not ship a special white skin version `MyShirtTex01_S0` to provide a fallback
in case someone is using a mod that provides additional skin colours. This way,
any request for an invalid variant texture will default to the basic white
version. This can be done for other skin colours instead, if desired. As long
as one skin colour is the "default" texture, it should always work in some
capacity.*

Don't forget to include these textures in your mod, via the usual `#exec`
statements, for example:

```
//Goth GF Outfit
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex1.bmp"                                NAME="Outfit3F_Tex1"               GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex1_S1.bmp"                             NAME="Outfit3F_Tex1_S1"            GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex1_S2.bmp"                             NAME="Outfit3F_Tex1_S2"            GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex1_S3.bmp"                             NAME="Outfit3F_Tex1_S3"            GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex1_S4.bmp"                             NAME="Outfit3F_Tex1_S4"            GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex2.pcx"                                NAME="Outfit3F_Tex2"               GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex3.bmp"                                NAME="Outfit3F_Tex3"               GROUP="Outfits"
```
