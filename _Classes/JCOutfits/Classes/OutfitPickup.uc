//=============================================================================
// OutfitPickup
//=============================================================================
class OutfitPickup extends ClothesRack;

#exec OBJ LOAD FILE=DeusEx

var const localized string outfitName;
var const localized string outfitDesc;

var const localized string itemArticle;
var const localized string PickupMessage;

var const string shirtTex;
var const string pantsTex;
var const string trench1Tex;
var const string trench2Tex;
var const string framesTex;
var const string lensesTex;

function Frob(Actor Frobber, Inventory frobWith)
{
    local DeusExPlayer P;
    local OutfitManager M;
    
    P = DeusExPlayer(Frobber);

    if (P != None)
    {
        M = OutfitManager(P.OutfitManager);
        if (M != None)
        {
            P.ClientMessage(PickupMessage @ itemArticle @ ItemName, 'Pickup');
            M.AddOutfit(outfitName,outfitDesc,shirtTex,pantsTex,trench1Tex,trench2Tex,framesTex,lensesTex);
            Destroy();
        }
    }
}

defaultproperties
{
     outfitName="Cool Outfit"
     PickupMessage="You found"
     ItemName="Fashionable Outfit"
     ItemArticle="a"
     bHighlight=True
     PickupMessage="You found"
}
