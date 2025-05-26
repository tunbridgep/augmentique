## Intro

This guide is designed to serve as a comprehensive resource to allow mod
authors to add Augmentique support to their mod. It details all of the steps
required in order to integrate the outfits system into your mod as seamlessly
as possible. The mod has been designed to be as modular as possible,
with almost all functionality being held within `Augmentique.u`, with only
minimal changes being required to core game classes. This mod is designed to be
integrated in a way that makes it optional - for users with Augmentique
installed, they will see the Outfits screen. For everyone else, this
functionality will be hidden and the outfits system will be disabled.

`Augmentique.u` is designed to be completely self-contained, and exposes an API
to `DeusEx.u`. This means that it's possible for new versions of `Augmentique.u` to
work with existing mods, even if those mods were only updated to work with a
previous version. **Because of this, it is highly recommended that you do not
include `Augmentique.u` in your own mod. Instead, you should let players know that
it is compatible, but do not include it. This will mean that players who do
not want the functionality can easily avoid it, and will essentially
future-proof your mod in the long term against changes made to future Augmentique
versions.**

**In order to get the full functionality of Augmentique, it is highly
recommended that you also add Lay-D Denton support to your mod. The official
Lay-D Denton technical guide explains how to implement LDDP in an optional way.
With the right integration, users should be able to run Vanilla, LDDP and
Augmentique alongside each other seamlessly, or any combination, without issues.**

*Note: Except where stated, all code edits in this file have been made using an
unedited, vanilla version of the Deus Ex codebase. Edits will be different and
the examples won't be the same in a modded environment.*

## Step-by-step integration

### Copy over files

Copy the provided `OutfitSpawner.uc`, `OutfitSpawner2.uc` and `OutfitManagerBase.uc` files into your
DeusEx classes folder. These must reside in `DeusEx.u` because they are added to maps directly.

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
// ----------------------------------------------------------------------
// Augmentique Setup
// ----------------------------------------------------------------------

var travel OutfitManagerBase outfitManager;
var globalconfig string unlockedOutfits[255];
```

Unless other edits have been made by your mod, in most cases, the code should
end up looking like this:

```
// For closing comptuers if the server quits
var Computers ActiveComputer;

// ----------------------------------------------------------------------
// Augmentique Setup
// ----------------------------------------------------------------------

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
// ----------------------------------------------------------------------
// Augmentique Setup
// CreateOutfitsButton()
// Will shorten the Conversations button to fit it in
// ----------------------------------------------------------------------

//Outfits button
var PersonaNavButtonWindow btnOutfits;

var localized String OutfitsButtonLabel;

//Shortened versions of existing labels
var localized String ImagesButtonLabelShort;
var localized String LogsButtonLabelShort;

function CreateOutfitsButton()
{
    local class<PersonaScreenBaseWindow> test;
    test = class<PersonaScreenBaseWindow>(DynamicLoadObject("Augmentique.PersonaScreenOutfits", class'Class', true));

    //Only create the Outfits button if the outfits window is actually available
    if (test != None)
    {
		btnOutfits   = CreateNavButton(winNavButtons, OutfitsButtonLabel);
		btnImages.SetButtonText(ImagesButtonLabelShort);
		btnLogs.SetButtonText(LogsButtonLabelShort);
    }
} 
```

Unless other edits have been made by your mod, in most cases, the code should
end up looking like this:

```
var localized String ImagesButtonLabel;
var localized String LogsButtonLabel;

// ----------------------------------------------------------------------
// Augmentique Setup
// CreateOutfitsButton()
// Will shorten the Images and Logs button to fit it in
// ----------------------------------------------------------------------

//Outfits button
var PersonaNavButtonWindow btnOutfits;

var localized String OutfitsButtonLabel;

//Shortened versions of existing labels
var localized String ImagesButtonLabelShort;
var localized String LogsButtonLabelShort;

function CreateOutfitsButton()
{
    local class<PersonaScreenBaseWindow> test;
    test = class<PersonaScreenBaseWindow>(DynamicLoadObject("Augmentique.PersonaScreenOutfits", class'Class', true));

    //Only create the Outfits button if the outfits window is actually available
    if (test != None)
    {
		btnOutfits   = CreateNavButton(winNavButtons, OutfitsButtonLabel);
		btnImages.SetButtonText(ImagesButtonLabelShort);
		btnLogs.SetButtonText(LogsButtonLabelShort);
    }
} 

// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------
```

Next, locate the line `btnGoals     = CreateNavButton(winNavButtons,
GoalsButtonLabel);`, and add the following line above
it:

```    
CreateOutfitsButton(); //Augmentique: Added
```

Unless other edits have been made by your mod, in most cases, the code should
end up looking like this:

```
// ----------------------------------------------------------------------
// CreateButtons()
// ----------------------------------------------------------------------

function CreateButtons()
{
	btnLogs      = CreateNavButton(winNavButtons, LogsButtonLabel);
	btnImages    = CreateNavButton(winNavButtons, ImagesButtonLabel);
	btnCons      = CreateNavButton(winNavButtons, ConsButtonLabel);
    CreateOutfitsButton(); //Augmentique: Added
	btnGoals     = CreateNavButton(winNavButtons, GoalsButtonLabel);
	btnSkills    = CreateNavButton(winNavButtons, SkillsButtonLabel);
	btnAugs      = CreateNavButton(winNavButtons, AugsButtonLabel);
	btnHealth    = CreateNavButton(winNavButtons, HealthButtonLabel);
	btnInventory = CreateNavButton(winNavButtons, InventoryButtonLabel);

	Super.CreateButtons();
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
        //Augmentique: Trigger Outfits screen
		case btnOutfits:
            winClass = class<PersonaScreenBaseWindow>(DynamicLoadObject("Augmentique.PersonaScreenOutfits", class'Class'));
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
        
        //Augmentique: Trigger Outfits screen
		case btnOutfits:
            winClass = class<PersonaScreenBaseWindow>(DynamicLoadObject("Augmentique.PersonaScreenOutfits", class'Class'));
			break;

        default:
            bHandled = False;
            break;
```

Finally, add the following properties to the `defaultproperties` section:

```
     ImagesButtonLabelShort="I|&mg"
     LogsButtonLabelShort="|&Log"
     OutfitsButtonLabel="|&Outfits"
```

Unless other edits have been made by your mod, in most cases, the code should
end up looking like this:

```
defaultproperties
{
     InventoryButtonLabel="|&Inventory"
     HealthButtonLabel="|&Health"
     AugsButtonLabel="|&Augs"
     SkillsButtonLabel="|&Skills"
     GoalsButtonLabel="|&Goals/Notes"
     ConsButtonLabel="|&Conversations"
     ImagesButtonLabel="I|&mages"
     LogsButtonLabel="|&Logs"
     ImagesButtonLabelShort="I|&mg"
     LogsButtonLabelShort="|&Log"
     OutfitsButtonLabel="|&Outfits"
}
```
### Edit JCDentonMale.uc

First, add the following code immediately below the class declaration:

```
// ----------------------------------------------------------------------
// Augmentique Setup
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// Timer()
// Augmentique: We need to delay slightly before setting models, to allow mods like LDDP to work properly
// ----------------------------------------------------------------------

function Timer()
{
    Super.Timer();

    //Setup Outfit Manager
    SetupOutfitManager();

    //Apply Current Outfit
    outfitManager.ApplyCurrentOutfit();
}

// ----------------------------------------------------------------------
// ResetPlayerToDefaults()
// Augmentique: When we start a new game, throw away our outfit manager
// ----------------------------------------------------------------------
function ResetPlayerToDefaults()
{
    outfitManager = None;
    Super.ResetPlayerToDefaults();
}

// ----------------------------------------------------------------------
// SetupOutfitManager()
// Augmentique: Setup the outfit manager and restore current outfit
// ----------------------------------------------------------------------

function SetupOutfitManager()
{
    local class<OutfitManagerBase> managerBaseClass;

	// create the Outfit Manager if not found
	if (outfitManager == None || !outfitManager.IsA('OutfitManager'))
    {
        managerBaseClass = class<OutfitManagerBase>(DynamicLoadObject("Augmentique.OutfitManager", class'Class'));
        
        if (managerBaseClass == None)
        {
            outfitManager = new(Self) class'OutfitManagerBase';
        }
        else
        {
            outfitManager = new(Self) managerBaseClass;
        }
    }

    if (outfitManager != None)
    {
        //Call base setup code, required each map load
        outfitManager.Setup(Self);
        
        //Add additional outfits below this line
        //---------------------------------------
        //See docs/mod_integration.pdf for more info
        //---------------------------------------

        //Finish Outfit Setup
        outfitManager.CompleteSetup();
    }
}

```

Unless other edits have been made by your mod, in most cases, the code should
end up looking like this:

```
//=============================================================================
// JCDentonMale.
//=============================================================================
class JCDentonMale extends Human;

// ----------------------------------------------------------------------
// Augmentique Setup
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// Timer()
// Augmentique: We need to delay slightly before setting models, to allow mods like LDDP to work properly
// ----------------------------------------------------------------------

function Timer()
{
    Super.Timer();

    //Setup Outfit Manager
    SetupOutfitManager();

    //Apply Current Outfit
    outfitManager.ApplyCurrentOutfit();
}

// ----------------------------------------------------------------------
// ResetPlayerToDefaults()
// Augmentique: When we start a new game, throw away our outfit manager
// ----------------------------------------------------------------------
function ResetPlayerToDefaults()
{
    outfitManager = None;
    Super.ResetPlayerToDefaults();
}

// ----------------------------------------------------------------------
// SetupOutfitManager()
// Augmentique: Setup the outfit manager and restore current outfit
// ----------------------------------------------------------------------

function SetupOutfitManager()
{
    local class<OutfitManagerBase> managerBaseClass;

	// create the Outfit Manager if not found
	if (outfitManager == None || !outfitManager.IsA('OutfitManager'))
    {
        managerBaseClass = class<OutfitManagerBase>(DynamicLoadObject("Augmentique.OutfitManager", class'Class'));
        
        if (managerBaseClass == None)
        {
            outfitManager = new(Self) class'OutfitManagerBase';
        }
        else
        {
            outfitManager = new(Self) managerBaseClass;
        }
    }

    if (outfitManager != None)
    {
        //Call base setup code, required each map load
        outfitManager.Setup(Self);
        
        //Add additional outfits below this line
        //---------------------------------------
        //See docs/mod_integration.pdf for more info
        //---------------------------------------

        //Finish Outfit Setup
        outfitManager.CompleteSetup();
    }
}

// ----------------------------------------------------------------------
// TravelPostAccept()
// ----------------------------------------------------------------------

event TravelPostAccept()
```

Then, find the `TravelPostAccept` function, which typically looks like this:

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
//Augmentique: Setup outfit manager
SetTimer(0.1,false);
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

    //Augmentique: Setup outfit manager
    SetTimer(0.1,false);
}
```

If your mod has LDDP integration, it will instead look like this:

```
// ----------------------------------------------------------------------
// TravelPostAccept()
// ----------------------------------------------------------------------

event TravelPostAccept()
{
	local DeusExLevelInfo info;
	
	local int i;
	local bool bFemale;
	local Texture TTex;
	local Sound TSound;
	local class<DeusExCarcass> TCarc;
	
	Super.TravelPostAccept();
	
	//LDDP, load and update our female flag accordingly.
	if (FlagBase != None)
	{
		if (bMadeFemale)
		{
			FlagBase.SetBool('LDDPJCIsFemale', true);
			FlagBase.SetExpiration('LDDPJCIsFemale', FLAG_Bool, 0);
			bFemale = true;
		}
		else
		{
			FlagBase.SetBool('LDDPJCIsFemale', false);
			FlagBase.SetExpiration('LDDPJCIsFemale', FLAG_Bool, 0);
		}
		
		if (bRetroMorpheus)
		{
			FlagBase.SetBool('LDDPOGMorpheus', true);
			FlagBase.SetExpiration('LDDPOGMorpheus', FLAG_Bool, 0);
		}
		else
		{
			FlagBase.SetBool('LDDPOGMorpheus', false);
			FlagBase.SetExpiration('LDDPOGMorpheus', FLAG_Bool, 0);
		}

		if (bFemaleUsesMaleInteractions)
		{
			FlagBase.SetBool('LDDPMaleCont4FJC', true);
			FlagBase.SetExpiration('LDDPMaleCont4FJC', FLAG_Bool, 0);
		}
		else
		{
			FlagBase.SetBool('LDDPMaleCont4FJC', false);
			FlagBase.SetExpiration('LDDPMaleCont4FJC', FLAG_Bool, 0);
		}
		
		//LDDP, 10/26/21: This is now outdated due to methodology requirements. See Human.uc for more on this.
		/*if (FlagBase.GetBool('LDDPJCIsFemale'))
		{
			bFemale = true;
		}*/
	}
	
	//LDDP, 10/26/21: Update HUD elements.
	if ((DeusExRootWindow(RootWindow) != None) && (DeusExRootWindow(RootWindow).HUD != None) && (DeusExRootWindow(RootWindow).HUD.Hit != None))
	{
		DeusExRootWindow(RootWindow).HUD.Hit.UpdateAsFemale(bFemale);
	}
	
	//LDDP, 10/26/21: A bunch of annoying bullshit with branching appearance for JC... But luckily, it works well.
	if (bFemale)
	{
		TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex2", class'Texture', false));
		if (TTex != None) MultiSkins[1] = TTex;
		TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex3", class'Texture', false));
		if (TTex != None) MultiSkins[2] = TTex;
		TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex0", class'Texture', false));
		if (TTex != None) MultiSkins[3] = TTex;
		TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex1", class'Texture', false));
		if (TTex != None) MultiSkins[4] = TTex;
		TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex2", class'Texture', false));
		if (TTex != None) MultiSkins[5] = TTex;
		MultiSkins[6] = Texture'DeusExCharacters.Skins.FramesTex4';
		MultiSkins[7] = Texture'DeusExCharacters.Skins.LensesTex5';	
		Mesh = LodMesh'GFM_Trench';
		
		BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight) - 2.0;
		
		TSound = Sound(DynamicLoadObject("FemJC.FJCLand", class'Sound', false));
		if (TSound != None) Land = TSound;
		
		TSound = Sound(DynamicLoadObject("FemJC.FJCJump", class'Sound', false));
		if (TSound != None) JumpSound = TSound;
		
		TSound = Sound(DynamicLoadObject("FemJC.FJCPainSmall", class'Sound', false));
    		if (TSound != None) HitSound1 = TSound;
		
		TSound = Sound(DynamicLoadObject("FemJC.FJCPainMedium", class'Sound', false));
    		if (TSound != None) HitSound2 = TSound;
		
		TSound = Sound(DynamicLoadObject("FemJC.FJCDeath", class'Sound', false));
    		if (TSound != None) Die = TSound;
		
		TCarc = class<DeusExCarcass>(DynamicLoadObject("FemJC.JCDentonFemaleCarcass", class'Class', false));
		if (TCarc != None) CarcassType = TCarc;
		
		switch(PlayerSkin)
		{
			case 0:
				TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex0", class'Texture', false));
				if (TTex != None) MultiSkins[0] = TTex;
			break;
			case 1:
				TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex4", class'Texture', false));
				if (TTex != None) MultiSkins[0] = TTex;
			break;
			case 2:
				TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex5", class'Texture', false));
				if (TTex != None) MultiSkins[0] = TTex;
			break;
			case 3:
				TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex6", class'Texture', false));
				if (TTex != None) MultiSkins[0] = TTex;
			break;
			case 4:
				TTex = Texture(DynamicLoadObject("FemJC.JCDentonFemaleTex7", class'Texture', false));
				if (TTex != None) MultiSkins[0] = TTex;
			break;
		}
	}
	else
	{
		for (i=1; i<ArrayCount(Multiskins); i++)
		{
			MultiSkins[i] = Default.Multiskins[i];
		}
		Mesh = Default.Mesh;
		
		BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight);
		Land = Default.Land;
		JumpSound = Default.JumpSound;
    		HitSound1 = Default.HitSound1;
    		HitSound2 = Default.HitSound2;
    		Die = Default.Die;
		CarcassType = Default.CarcassType;
		
		switch(PlayerSkin)
		{
			case 0:
				MultiSkins[0] = Texture'JCDentonTex0';
			break;
			case 1:
				MultiSkins[0] = Texture'JCDentonTex4';
			break;
			case 2:
				MultiSkins[0] = Texture'JCDentonTex5';
			break;
			case 3:
				MultiSkins[0] = Texture'JCDentonTex6';
			break;
			case 4:
				MultiSkins[0] = Texture'JCDentonTex7';
			break;
		}
	}
    
    //Augmentique: Setup outfit manager
    SetTimer(0.1,false);
}

```

## Update the Maps

Once the code has been updated, it's important to ensure all the outfit pickups are added to the maps.

`t3d` files are provided within the `_Map Patches` folder. Simply load each map in the editor, go to `File->Import Level`. Make sure to select "Import Contents into existing map".

*Note: Some maps will likely crash the editor upon loading. To load them, ensure the Mode setting in the 3D view is set to Map Perp*

## Creating new Outfits

Outfits should be created inside the `SetupOutfitManager` function in `JCDentonMale.uc`, inside the outlined area between the lines:

```
//Add additional outfits between these lines
//See docs/mod_integration.pdf for more info
//---------------------------------------

//---------------------------------------
```

### Adding a new outfit using existing parts

New outfits using existing parts are extremely easy, and can be added with the following code:

```
//Get the GM_Trench mesh group (Trench Coat model)
outfitManager.GetPartsGroup("GM_Trench"); 

//Add Gray Trenchcoat with White Pants outfit
outfitManager.BeginNewOutfit("graytrench", "Gray Trenchcoat with White Pants", "A strange assortment of items thrown together in a hodge-podge of styles");
outfitManager.OutfitAddPartReference("chef_p"); //Add the white chef pants
outfitManager.OutfitAddPartReference("default_s"); //Add the default shirt
outfitManager.OutfitAddPartReference("gray_t"); //Add the gray trench tex

```

The function calls are as follows:

`bool GetPartsGroup(string mesh)`

This function selects a mesh as the current outfit group, which will assign all
future outfits to use that mesh until `GetPartsGroup` is called again. Outfits sharing the same mesh
can share parts, allowing the player to create a custom outfit using any part of
any outfit within the group.

The function arguments are as follows:

1. The name of the mesh. This is usually something like "GM_Trench".

The function will return TRUE if it successfully found a parts group for that
mesh, and false otherwise. This function should return true for most of the
basic meshes in game, such as GM_Trench, GFM_Trench, GM_Suit, etc, but not for
the "fat" or "slim" versions of meshes like GM_Trench_F

*Note: If the mesh is present within the `DeusExCharacters` or `FemJC` groups,
you do not need to specify the full mesh path, and can instead simply use the
name. For example, `DeusExCharacters.GM_Trench` can simply be written as
`GM_Trench`*

Once the parts group is selected, create the outfit using:

`BeginNewOutfit(string id, string name, optional string desc, optional string highlightName, optional string pickupName, optional string pickupMessage, optional string pickupArticle)`

This function sets up a new outfit. All subsequent outfit-related function
calls will apply to this outfit until `BeginNewOutfit` is called again.

The function arguments are as follows:

1. The ID of the outfit. IDs are used to assign pickup boxes to outfits, and to
   determine if outfits are locked or unlocked. Multiple Outfits with the same
   ID can be added, and will unlock together, allowing for alternate styles or
   separate male/female versions of outfits.
2. The Name of the outfit. This will appear in the outfit menu and on outfit
   spawners.
3. (Optional) The outfit description. Will be displayed at the bottom of the
   outfits window.
4. (Optional) The Text displayed when Highlighting the outfit box in the world.
   Leave blank to use the outfit name.
5. (Optional) The Name displayed in the pickup message for the outfit box.
   Leave blank to use the outfit name.
6. (Optional) The Pickup Message displayed for the outfit box. Leave blank to
   use the default, which is "You found %s %s".
7. (Optional) The Pickup Message article for the outfit box. Leave blank to use
   the default, which is "a".

With the pickupname, pickupmessage and pickuparticle arguments omitted, picking
up an outfit will display the message `Picked up a <outfit name>`

Once the outfit has been added, it needs to have some parts assigned to it.
This can be done with the `OutfitAddPartReference` function:

`OutfitAddPartReference(string partID)`

The function arguments are as follows:

1. The ID of the part to be assigned to the outfit.

*Note: To get the ids for the parts you want to use, enable bDebugMode in
DeusEx.ini under [Augmentique.outfitManager], located in your DeusEx System
folder, or in My Documents/Deus Ex/System if using Kenties Deus Exe launcher.
Once that's done, simply go in-game, equip an outfit with the part you want,
and then quit. The name of the outfit along with the ids of all of it's parts
will be listed in DeusEx.log*

Once this is done, the final step is to add an `OutfitSpawner`,
`OutfitSpawner2` or `OutfitSpawner3` to your map, and assign it the id of your
new outfit.

`OutfitSpawner` is generally unused, but can be used if desired: It's a small,
hanging clothes rack. `OutfitSpawner2` is a standard Augmentique outfit box,
and `OutfitSpawner3` is a small accessories box, designed for unlocking
variants of the default trenchcoat outfit with different parts (such as
jewellery).

### Adding a new outfit with new parts on an existing mesh

Adding a new outfit with new parts requires a little more setup. Here's an example of a new outfit with custom textures based on the Hitman Requiem suit:

```
//Get the GM_Suit mesh group
outfitManager.GetPartsGroup("GM_Suit"); 

//Add the suit parts to the mesh group
outfitManager.AddPart(PS_Torso_M,"Requiem Suit",false,"hitman_s",,,,"HitmanTex1","HitmanTex1"); //Torso
outfitManager.AddPart(PS_Legs,"Requiem Pants",false,"hitman_p",,"HitmanTex2"); //Legs

//Add White Hitman Suit
outfitManager.BeginNewOutfit("hitman", "Requiem Suit", "A suit worn by Agent 47 of the Hitman games");
outfitManager.OutfitAddPartReference("hitman_s"); //Add hitman suit
outfitManager.OutfitAddPartReference("hitman_p"); //Add hitman pants

```

Before we can add an outfit with new parts, the parts need to be assigned to the parts group with the following function:

`AddPart(PartSlot slot,string name,bool isAccessory,string id, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm)`

The function arguments are as follows:

1. The part slot used. Each outfit can only have 1 part from each slot, additional parts will override previous ones.

Examples of parts include but are not limited to:

- `PS_Body_M`, for male body textures (such as the NSF Terrorists tactical balaclava/gloves)
- `PS_Glasses`, for eyeglasses and other "eye accessory" textures (only
  available on some models)
- `PS_Torso_F`, for female torso textures (usually used for shirts).
- `PS_Legs`, for leg textures (usually used for pants, leggings, etc).

For a full list of part slots, please see `OutfitManagerBase.uc`

2. The name of the part. This will appear in the Customize Outfit screen.
3. if TRUE, this part will be hidden when the `Show Accessories` checkbox is
   unchecked.
4. The id of the part. Multiple outfits can share the same parts, and parts are
   unlocked for the customisation screen if any unlocked outfit contains the
   part.
5. The texture in Texture Slot 0. This will be applied to `MultiSkins[0]` when
   the outfit is applied. Slot 0 is almost always used for skin textures.
6. The texture in Texture Slot 1. This will be applied to `MultiSkins[1]` when
   the outfit is applied.
7. The texture in Texture Slot 2. This will be applied to `MultiSkins[2]` when
   the outfit is applied.
8. The texture in Texture Slot 3. This will be applied to `MultiSkins[3]` when
   the outfit is applied.
9. The texture in Texture Slot 4. This will be applied to `MultiSkins[4]` when
   the outfit is applied.
10. The texture in Texture Slot 5. This will be applied to `MultiSkins[5]` when
    the outfit is applied.
11. The texture in Texture Slot 6. This will be applied to `MultiSkins[6]` when
    the outfit is applied.
12. The texture in Texture Slot 7. This will be applied to `MultiSkins[7]` when
    the outfit is applied.
13. The texture in the main Texture Slot. This will be applied to `Texture`
    when the outfit is applied.

This table serves as a reference the different texture types used for each
model:

| Model Name      | Slot 1     | Slot 2  | Slot 3   | Slot 4    | Slot 5                       | Slot 6                       | Slot 7         | Main Texture |
|-----------------|------------|---------|----------|-----------|------------------------------|------------------------------|----------------|--------------|
| GM_Trench       | Trenchcoat | Pants   | Skin     | Shirt     | Trenchcoat (extension)       | Glasses Frames               | Glasses Lenses | Nothing      |
| GM_DressShirt_S | Nothing    | Nothing | Pants    | Skin      | Shirt                        | Glasses Frames               | Glasses Lenses | Nothing      |
| GM_Suit         | Pants      | Skin    | Shirt    | Shirt     | Glasses Frames               | Glasses Lenses               | Hat            | Nothing      |
| GM_Jumpsuit     | Pants      | Shirt   | Facemask | Facemask  | GrayMaskTex (Mouth Covering) | Helmet                       | Nothing        | Visor        |
| GM_DressShirt   | Nonthing   | Nothing | Pants    | Skin      | Shirt                        | GrayMaskTex (Mouth Covering) | ???            | Nothing      |
| GFM_Trench      | Trenchcoat | Pants   | Skin     | Shirt     | Trenchcoat                   | Glasses Frames               | Glasses Lenses | Nothing      |
| GFM_SuitSkirt   | Nothing    | Skin    | Legs     | Dress Top | Dress Bottom/Skirt           | Glasses Frames               | Glasses Lenses | Nothing      |
| GFM_Dress       | Legs       | Skirt   | Shirt    | Skirt     | Skin                         | Nothing                      | Skin           | Nothing      |
| GM_ScubaSuit    | Vest       | Suit    | Nothing  | Nothing   | Nothing                      | Nothing                      | Nothing        | Suit         |

## Handling Skin Colours

It is possible to create outfits which reflect the players chosen skin colour.

The mod automatically looks for textures named `<texture>_S[0-4]`, where the
numbers 0-4 represent the available skin colours (white, black, hispanic,
ginger, albino), when given a base texture name.

So for instance, you might add a new outfit with the texture `MyShirtTex1`.
Your mod can additionally contain a texture `MyShirtTex1_S1` for a version
containing dark skin, `MyShirtTex1_S2` for hispanic, etc.

You can then simply add the default texture in the `AddPart` call, like so:

```
outfitManager.AddPart(PS_Torso_M,"Shirt with skin texture",false,"skintex_s",,,,"MyShirtTex1","MyShirtTex1");
```

*Note: It is recommended to include a default version of `MyShirtTex1`, and
not ship a special white skin version `MyShirtTex1_S0` to provide a fallback
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
