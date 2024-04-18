class OutfitManager extends OutfitManagerBase;

#exec OBJ LOAD FILE=DeusEx

struct Outfit
{
    var travel localized string outfitName;
    var travel localized string outfitDesc;

    //Meshes
    var travel string mesh;

    //Textures
    var travel string tex1;
    var travel string tex2;
    var travel string tex3;
    var travel string tex4;
    var travel string tex5;
    var travel string tex6;
    var travel string tex7;
    
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
    local string t1, t2, t3, t4, t5, t6, t7, mesh;

    player = newPlayer;
    //If we have no outfit #0, create one based on the players current skin (should be JC's default outfit).
    if (numOutfits == 0)
    {
        //TODO: Fix this
        t1 = "DeusExCharacters.Skins." $ string(player.MultiSkins[1].name);
        t2 = "DeusExCharacters.Skins." $ string(player.MultiSkins[2].name);
        //t3 = "DeusExCharacters.Skins." $ string(player.MultiSkins[3].name); //T3 is a skin texture, skip it
        t4 = "DeusExCharacters.Skins." $ string(player.MultiSkins[4].name);
        t5 = "DeusExCharacters.Skins." $ string(player.MultiSkins[5].name);
        t6 = "DeusExCharacters.Skins." $ string(player.MultiSkins[6].name);
        t7 = "DeusExCharacters.Skins." $ string(player.MultiSkins[7].name);
        mesh = "DeusExCharacters." $ string(player.Mesh.name);

        AddOutfit(defaultOutfitName,defaultOutfitDesc,mesh,t1,t2,t3,t4,t5,t6,t7);
    }
}

function AddOutfit(string n, string d, string mesh, string t1, string t2, string t3, string t4, string t5, optional string t6, optional string t7)
{
    outfits[numOutfits].outfitName = n;
    outfits[numOutfits].outfitDesc = d;
    outfits[numOutfits].mesh = mesh;
    outfits[numOutfits].tex1 = t1;
    outfits[numOutfits].tex2 = t2;
    outfits[numOutfits].tex3 = t3;
    outfits[numOutfits].tex4 = t4;
    outfits[numOutfits].tex5 = t5;
    outfits[numOutfits].tex6 = t6;
    outfits[numOutfits].tex7 = t7;

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

    currentOutfitIndex = index;
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

    //Set Textures
    SetTexture(1,currentOutfit.tex1);
    SetTexture(2,currentOutfit.tex2);
    SetTexture(3,currentOutfit.tex3);
    SetTexture(4,currentOutfit.tex4);
    SetTexture(5,currentOutfit.tex5);
    SetTexture(6,currentOutfit.tex6);
    SetTexture(7,currentOutfit.tex7);

    //Set Mesh
    SetMesh(currentOutfit.mesh);

    player.ClientMessage("Equipping " $ currentOutfit.outfitName);
}

function SetMesh(string mesh)
{
    local LodMesh m;
    m = LodMesh(DynamicLoadObject(mesh, class'LodMesh', true));

    if (m != None)
        player.Mesh = m;
}

function SetTexture(int slot, string tex)
{
    local Texture t;

    if (tex == "Skin") //Special keyword to make our skin texture appear in different slots
    {
        player.multiSkins[slot] = player.multiSkins[0];
        return;
    }

    t = Texture(DynamicLoadObject(tex, class'Texture', true));

    if (t != None)
        player.MultiSkins[slot] = t;
    else
        player.MultiSkins[slot] = Texture'DeusExItems.Skins.PinkMaskTex';
}

defaultproperties
{
    defaultOutfitName="JC Denton's Classic Trenchcoat"
    defaultOutfitDesc="An old classic. This blue trenchcoat fits well over anything, and gives JC a cool, augmented look"
}
