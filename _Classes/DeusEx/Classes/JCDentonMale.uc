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
        
        //Add additional outfits between these lines
        //See docs/mod_integration.pdf for more info
        //---------------------------------------

        //---------------------------------------

        //Finish Outfit Setup
        outfitManager.CompleteSetup();
    }
}

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

// ----------------------------------------------------------------------
// RenderOverlays()
// render our in-hand object
// ----------------------------------------------------------------------

//LDDP, 10/26/21: Imported from FemJC.u. This is for swapping female hand textures.
simulated event RenderOverlays( canvas Canvas )
{
	local int i;
	local Texture OldMultiskins[8], TTex;
	
	if ((FlagBase != None) && (FlagBase.GetBool('LDDPJCIsFemale')))
	{
		if ((inHand != None) && (inHand.Mesh == inHand.PlayerViewMesh))
		{
        		for (i=0;i<8;i++)
        		{
        	   		OldMultiskins[i] = InHand.Multiskins[i];
        	    		
        	    		if (inHand.GetMeshTexture(i) == Texture'WeaponHandsTex')
        	    		{
					switch(PlayerSkin)
					{
						case 0:
							TTex = Texture(DynamicLoadObject("FemJC.WeaponHandsTex0Fem", class'Texture', false));
							if (TTex != None) inHand.Multiskins[i] = TTex;
						break;
						case 1:
							TTex = Texture(DynamicLoadObject("FemJC.WeaponHandsTex4Fem", class'Texture', false));
							if (TTex != None) inHand.Multiskins[i] = TTex;
						break;
						case 2:
							TTex = Texture(DynamicLoadObject("FemJC.WeaponHandsTex5Fem", class'Texture', false));
							if (TTex != None) inHand.Multiskins[i] = TTex;
						break;
						case 3:
							TTex = Texture(DynamicLoadObject("FemJC.WeaponHandsTex6Fem", class'Texture', false));
							if (TTex != None) inHand.Multiskins[i] = TTex;
						break;
						case 4:
							TTex = Texture(DynamicLoadObject("FemJC.WeaponHandsTex7Fem", class'Texture', false));
							if (TTex != None) inHand.Multiskins[i] = TTex;
						break;
					}
        	    		}
        	    		else if (inHand.GetMeshTexture(i) == Texture'MiniCrossbowTex1')
        	    		{
					switch(PlayerSkin)
					{
						case 0:
							TTex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex0Fem", class'Texture', false));
							if (TTex != None) inHand.Multiskins[i] = TTex;
						break;
						case 1:
							TTex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex4Fem", class'Texture', false));
							if (TTex != None) inHand.Multiskins[i] = TTex;
						break;
						case 2:
							TTex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex5Fem", class'Texture', false));
							if (TTex != None) inHand.Multiskins[i] = TTex;
						break;
						case 3:
							TTex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex6Fem", class'Texture', false));
							if (TTex != None) inHand.Multiskins[i] = TTex;
						break;
						case 4:
							TTex = Texture(DynamicLoadObject("FemJC.MiniCrossbowTex7Fem", class'Texture', false));
							if (TTex != None) inHand.Multiskins[i] = TTex;
						break;
					}
            			}
        		}
		}
    	}
    	
    	Super.RenderOverlays(Canvas);
    	
	if ((FlagBase != None) && (FlagBase.GetBool('LDDPJCIsFemale')))
	{
    		if ((inHand != None) && (inHand.Mesh == inHand.PlayerViewMesh))
    		{
        		for (i=0;i<8;i++)
        		{
        	    		InHand.Multiskins[i] = OldMultiskins[i];
			}
        	}
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
