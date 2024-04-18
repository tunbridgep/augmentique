class OutfitManager extends Object;

struct Outfit
{
    var travel string tex1;                 //Trenchcoat texture
    var travel string tex2;                 //Shirt texture
    var travel string tex3;                 //Pants texture
};

var DeusExPlayer player;

//This should be called in ResetPlayerToDefaults, and TravelPostAccept
function SetPlayer(DeusExPlayer newPlayer)
{
    player = newPlayer;
}

function EquipOutfit(Outfit of)
{

}
