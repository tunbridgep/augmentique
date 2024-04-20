//=============================================================================
// JCDentonMale.
//=============================================================================
class JCDentonMale extends Human;

// ----------------------------------------------------------------------
// TravelPostAccept()
// ----------------------------------------------------------------------

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

        //Re-assign current outfit
        outfitManager.ApplyCurrentOutfit();
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     CarcassType=Class'DeusEx.JCDentonMaleCarcass'
     JumpSound=Sound'DeusExSounds.Player.MaleJump'
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'DeusExSounds.Player.MalePainMedium'
     Land=Sound'DeusExSounds.Player.MaleLand'
     Die=Sound'DeusExSounds.Player.MaleDeath'
     Mesh=LodMesh'DeusExCharacters.GM_Trench'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.JCDentonTex3'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.JCDentonTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.FramesTex4'
     MultiSkins(7)=Texture'DeusExCharacters.Skins.LensesTex5'
}
