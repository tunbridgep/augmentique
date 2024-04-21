//=============================================================================
// OutfitSpawner
// Spawns an outfit, or does nothing depending on if the outfits mod is installed.
//=============================================================================
class OutfitSpawner extends DeusExDecoration;

var(JCOutfits) const string id; //IDs of the outfit to spawn
var(JCOutfits) const string itemArticle;
var(JCOutfits) const string PickupMessage;
var(JCOutfits) const string AlternateTexture;

function Timer()
{
    local DeusExPlayer P;
    P = DeusExPlayer(GetPlayerPawn());
    //if (P == None || P.OutfitManager == None)
        //Destroy();
}

function PostPostBeginPlay()
{
    SetTimer(0.5, True);
    Super.PostPostBeginPlay();
    SetTexture();
}

function SetTexture()
{
    local Texture tex;
    if (AlternateTexture != "")
    {
        tex = Texture(DynamicLoadObject(AlternateTexture, class'Texture', false));
        if (tex != None)
            Texture = tex;
    }
}

function Frob(Actor Frobber, Inventory frobWith)
{
    local DeusExPlayer P;
    
    P = DeusExPlayer(Frobber);
    if (P != None && P.OutfitManager != None)
    {
        P.ClientMessage(PickupMessage @ itemArticle @ P.OutfitManager.GetOutfitNameByID(id), 'Pickup');
        P.OutfitManager.Unlock(id);
        Destroy();
    }
}

defaultproperties
{
     bPushable=False
     FragType=Class'DeusEx.PaperFragment'
     Texture=Texture'ClothesRackTex1'
     PickupViewMesh=LodMesh'DeusExDeco.ClothesRack'
     Mesh=LodMesh'DeusExDeco.ClothesRack'
     ItemName="Fashionable Outfit"
     PickupMessage="You found"
     ItemArticle="a"
     bHighlight=True
     CollisionRadius=13.000000
     CollisionHeight=48.750000
     Mass=60.000000
     Buoyancy=70.000000
     //Physics=PHYS_Falling
}
