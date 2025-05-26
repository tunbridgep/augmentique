//=============================================================================
// Sodacan.
//=============================================================================
class Sodacan extends DeusExPickup;

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local DeusExPlayer player;
		local Sound BurpSound;
		
		Super.BeginState();

		player = DeusExPlayer(Owner);
		if (player != None)
		{
			player.HealPlayer(2, False);

			//LDDP, 10/25/21: Load sound for burping dynamically.
			if ((Player.FlagBase != None) && (Player.FlagBase.GetBool('LDDPJCIsFemale')))
			{
				BurpSound = Sound(DynamicLoadObject("FemJC.FJCBurp", class'Sound', false));
			}
		}
		
		if (BurpSound == None) BurpSound = sound'MaleBurp';
		
		PlaySound(BurpSound);
		UseOnce();
	}
Begin:
}

defaultproperties
{
     maxCopies=10
     bCanHaveMultipleCopies=True
     bActivatable=True
     ItemName="Soda"
     ItemArticle="some"
     PlayerViewOffset=(X=30.000000,Z=-12.000000)
     PlayerViewMesh=LodMesh'DeusExItems.Sodacan'
     PickupViewMesh=LodMesh'DeusExItems.Sodacan'
     ThirdPersonMesh=LodMesh'DeusExItems.Sodacan'
     LandSound=Sound'DeusExSounds.Generic.MetalHit1'
     Icon=Texture'DeusExUI.Icons.BeltIconSodaCan'
     largeIcon=Texture'DeusExUI.Icons.LargeIconSodaCan'
     largeIconWidth=24
     largeIconHeight=45
     Description="The can is blank except for the phrase 'PRODUCT PLACEMENT HERE.' It is unclear whether this is a name or an invitation."
     beltDescription="SODA"
     Mesh=LodMesh'DeusExItems.Sodacan'
     CollisionRadius=3.000000
     CollisionHeight=4.500000
     Mass=5.000000
     Buoyancy=3.000000
}
