//=============================================================================
// OutfitPickup
//=============================================================================
class OutfitPickup extends ClothesRack;

#exec OBJ LOAD FILE=DeusEx

var const localized string outfitName;
var const localized string outfitDesc;

var const localized string itemArticle;
var const localized string PickupMessage;

var const string tex1;
var const string tex2;
var const string tex3;
var const string tex4;
var const string tex5;
var const string tex6;
var const string tex7;
var const string outfitMesh;

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
            M.AddOutfit(outfitName,outfitDesc,outfitMesh,tex1,tex2,tex3,tex4,tex5,tex6,tex7);
            Destroy();
        }
    }
}

defaultproperties
{
     outfitName="Cool Outfit"
     outfitMesh="DeusExCharacters.GM_Trench"
     PickupMessage="You found"
     ItemName="Fashionable Outfit"
     ItemArticle="a"
     bHighlight=True
     PickupMessage="You found"
}
