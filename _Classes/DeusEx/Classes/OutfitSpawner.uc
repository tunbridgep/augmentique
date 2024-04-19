//=============================================================================
// OutfitSpawner
// Spawns an outfit, or does nothing depending on if the outfits mod is installed.
//=============================================================================
class OutfitSpawner extends DeusExPickup;

var(JCOutfits) const string id; //IDs of the outfit to spawn
var(JCOutfits) const string ItemName;
var(JCOutfits) const int style;

function BeginPlay()
{
}

defaultproperties
{
     ItemName="Fashionable Outfit"
     PickupMessage="You found"
     ItemArticle="a"
     Mesh=LodMesh'DeusExDeco.ClothesRack'
     CollisionRadius=13.000000
     CollisionHeight=24.750000
     bCollideWorld=False
     style=0;
}
