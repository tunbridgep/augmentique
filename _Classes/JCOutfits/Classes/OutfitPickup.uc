//=============================================================================
// OutfitPickup
//=============================================================================
class OutfitPickup extends Pickup;

var const localized string outfitName;
var const localized string outfitDesc;

var const string shirtTex;
var const string pantsTex;
var const string trench1Tex;
var const string trench2Tex;
var const string framesTex;
var const string lensesTex;

/*
function bool HandlePickupQuery(inventory Item)
{
    local Pawn P;
    local OutfitManager M;
    
    P = Pawn(Owner);

    if (P != None)
    {
    	P.ClientMessage(Item.PickupMessage @ Item.itemArticle @ Item.itemName, 'Pickup');
	
        foreach AllObjects(class'OutfitManager', M)
        {
            P.clientMessage("Found an OutfitManager");
            M.AddOutfit(outfitName,outfitDesc,shirtTex,pantsTex,trench1Tex,trench2Tex,framesTex,lensesTex);
        }
        return true;
    }
	
    return Inventory.HandlePickupQuery(Item);
}
*/

function AddOutfit(OutfitManager M)
{
    M.AddOutfit(outfitName,outfitDesc,shirtTex,pantsTex,trench1Tex,trench2Tex,framesTex,lensesTex);
}

defaultproperties
{
     outfitName="Cool Outfit"
     PickupMessage="You found"
     ItemName="Fashionable Outfit"
     bBlockSight=True
     Mesh=LodMesh'DeusExDeco.BoxMedium'
     PlayerViewMesh=LodMesh'DeusExDeco.BoxMedium'
     PickupViewMesh=LodMesh'DeusExDeco.BoxMedium'
     ThirdPersonMesh=LodMesh'DeusExDeco.BoxMedium'
     CollisionRadius=42.000000
     CollisionHeight=50.000000
     Mass=80.000000
     Buoyancy=90.000000
     ItemArticle="a"
     bStatic=False
     bTravel=True
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
