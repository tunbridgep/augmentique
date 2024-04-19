//=============================================================================
// OutfitPickup
//=============================================================================
class OutfitPickup extends ClothesRack;

#exec OBJ LOAD FILE=DeusEx

var string PickupMessage;
var string itemArticle;
var string id;

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
            M.Unlock(id);
            Destroy();
        }
    }
}

defaultproperties
{
    bHighlight=true;
}
