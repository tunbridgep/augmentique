class OutfitManager extends OutfitManagerBase;

#exec OBJ LOAD FILE=DeusEx

struct Outfit
{
    var travel localized string outfitName;
    var travel localized string outfitDesc;

    //Clothing Textures
    var travel string shirtTex;
    var travel string pantsTex;
    
    //Trench Coat Textures
    var travel string trenchTex1;           //Trenchcoat shoulders and chest
    var travel string trenchTex2;           //Trenchcoat collar, and trim
    
    //Glasses Textures
    var travel string framesTex;
    var travel string lensesTex;
    
    //first-person arm tex
    //var travel string firstPersonArmTex;
};

var DeusExPlayer player;

var travel Outfit outfits[99];
var travel int numOutfits;
//var travel Outfit currentOutfit;
var travel int currentOutfitIndex;

//Names for the default JC Denton outfit
var const localized string defaultOutfitName;
var const localized string defaultOutfitDesc;

function Setup(DeusExPlayer newPlayer)
{
    local string sh, pa, tr1, tr2, fra, len;

    player = newPlayer;
    //If we have no outfit #0, create one based on the players current skin (should be JC's default outfit).
    if (numOutfits == 0)
    {
        sh = "DeusExCharacters.Skins." $ string(player.MultiSkins[4].name);
        pa = "DeusExCharacters.Skins." $ string(player.MultiSkins[2].name);
        tr1 = "DeusExCharacters.Skins." $ string(player.MultiSkins[1].name);
        tr2 = "DeusExCharacters.Skins." $ string(player.MultiSkins[5].name);
        fra = "DeusExCharacters.Skins." $ string(player.MultiSkins[6].name);
        len = "DeusExCharacters.Skins." $ string(player.MultiSkins[7].name);

        AddOutfit(defaultOutfitName,defaultOutfitDesc,sh,pa,tr1,tr2,fra,len);
    }
}

function AddOutfit(string n, string d, string shirt, string pants, string trench1, string trench2, optional string frames, optional string lenses)
{
    outfits[numOutfits].outfitName = n;
    outfits[numOutfits].outfitDesc = d;
    outfits[numOutfits].shirtTex = shirt;
    outfits[numOutfits].pantsTex = pants;
    outfits[numOutfits].trenchTex1 = trench1;
    outfits[numOutfits].trenchTex2 = trench2;
    outfits[numOutfits].framesTex = frames;
    outfits[numOutfits].lensesTex = lenses;

    numOutfits++;
    EquipOutfit(numOutfits-1);
}

function string GetOutfitName(int index)
{
    
    if (index >= numOutfits)
        return "";

    return outfits[index].outfitName;
}

function EquipOutfit(int index)
{
    local Outfit of;
    
    if (index >= numOutfits)
        return;
    
    player.ClientMessage("shirtTex: " $ outfits[index].shirtTex);
    player.ClientMessage("pantaloons: " $ outfits[index].pantsTex);

    currentOutfitIndex = index;
    /*
    of = outfits[index];
    currentOutfit.outfitName = of.outfitName;
    currentOutfit.outfitDesc = of.outfitDesc;

    currentOutfit.shirtTex = of.shirtTex;
    currentOutfit.pantsTex = of.pantsTex;
    currentOutfit.trenchTex1 = of.trenchTex1;
    currentOutfit.trenchTex2 = of.trenchTex2;
    currentOutfit.framesTex = of.framesTex;
    currentOutfit.lensesTex = of.lensesTex;
    */

    ApplyCurrentOutfit();
}

function Outfit GetOutfit(int index)
{
    return outfits[index];
}

function bool IsEquipped(int index)
{
    return index == currentOutfitIndex;
}

function ApplyCurrentOutfit()
{
    local Outfit currentOutfit;
    currentOutfit = outfits[currentOutfitIndex];

    //Set Shirt Tex
    SetTexture(4,currentOutfit.shirtTex);

    //Set Pants Tex
    SetTexture(2,currentOutfit.pantsTex);
    
    //Set Trenchcoat Tex
    SetTexture(1,currentOutfit.trenchTex1);
    SetTexture(5,currentOutfit.trenchTex2);

    //Set Glasses Tex
    SetTexture(6,currentOutfit.framesTex);
    SetTexture(7,currentOutfit.lensesTex);

    player.ClientMessage("Equipping " $ currentOutfit.outfitName);
}

function SetTexture(int slot, string tex)
{
    local Texture t;
    t = Texture(DynamicLoadObject(tex, class'Texture', true));

    if (t != None)
        player.MultiSkins[slot] = t;
}

defaultproperties
{
    defaultOutfitName="JC Denton's Classic Trenchcoat"
    defaultOutfitDesc="An old classic. This blue trenchcoat fits well over anything, and gives JC a cool, augmented look"
}
