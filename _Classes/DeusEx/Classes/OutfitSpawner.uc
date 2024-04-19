//=============================================================================
// OutfitSpawner
// Spawns an outfit, or does nothing depending on if the outfits mod is installed.
//=============================================================================
class OutfitSpawner extends DeusExPickup;

var(JCOutfits) const string id; //ID of the outfit to spawn
var(JCOutfits) const string ItemName;
var(JCOutfits) const int style;

function BeginPlay()
{
    /*
    local class<OutfitPickupBase> objectClass;
    local OutfitPickupBase obj;

    objectClass = class<OutfitPickupBase>(DynamicLoadObject("JCOutfits.OutfitPickup", class'Class'));
    obj = spawn(objectclass,,, Location);
    obj.id = id;
    obj.itemName = itemName;
    obj.itemArticle = itemArticle;
    obj.PickupMessage = PickupMessage;
    Destroy();
    */
}

defaultproperties
{
     id="This needs an ID"
     ItemName="Fashionable Outfit"
     PickupMessage="You found"
     ItemArticle="a"
     Mesh=LodMesh'DeusExDeco.ClothesRack'
     CollisionRadius=13.000000
     CollisionHeight=24.750000
     bCollideWorld=False
     style=0;
}
