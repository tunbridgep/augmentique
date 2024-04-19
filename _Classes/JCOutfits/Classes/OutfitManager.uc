class OutfitManager extends OutfitManagerBase;

#exec OBJ LOAD FILE=DeusEx

struct Outfit
{
    var string name;
    var string desc;

    var string id;       //Unique identifier for each outfit

    //TODO: Use this rather than checking the array constantly
    //var bool unlocked;

    //Meshes
    var string mesh;

    //Textures
    var string tex1;
    var string tex2;
    var string tex3;
    var string tex4;
    var string tex5;
    var string tex6;
    var string tex7;
    
    //first-person arm tex
    //var travel string firstPersonArmTex;
};

var DeusExPlayer player;

var Outfit outfits[255];
var int numOutfits;
//var travel Outfit currentOutfit;
var travel int currentOutfitIndex;

//Names for the default JC Denton outfit
var const localized string defaultOutfitNames[255];
var const localized string defaultOutfitDescs[255];
var Texture defaultTextures[8];
var Mesh defaultMesh;

function Setup(DeusExPlayer newPlayer)
{
    local string t1, t2, t3, t4, t5, t6, t7, mesh;

    player = newPlayer;

    //Set up default outfit
    defaultTextures[0] = player.default.MultiSkins[0];
    defaultTextures[1] = player.default.MultiSkins[1];
    defaultTextures[2] = player.default.MultiSkins[2];
    defaultTextures[3] = player.default.MultiSkins[3];
    defaultTextures[4] = player.default.MultiSkins[4];
    defaultTextures[5] = player.default.MultiSkins[5];
    defaultTextures[6] = player.default.MultiSkins[6];
    defaultTextures[7] = player.default.MultiSkins[7];
    defaultMesh = player.default.Mesh;

    //Make sure the default outfit is always unlocked
    Unlock("default");

    //This sucks, but I can't think of a better way to do this
                //id                //Mesh                  //Textures
    AddOutfit("default",,           ,                       ,"default","default","default","default","default","default","default");
    AddOutfit("100black",,          ,                       ,"Outfit1F_Tex1","Outfit1F_Tex1","Outfit1F_Tex1","Outfit1F_Tex1","Outfit1F_Tex1","Outfit1F_Tex1","Outfit1F_Tex1");
    AddOutfit("ajacobson",,         ,"GM_DressShirt_S"      ,,,"AlexJacobsonTex2","skin","AlexJacobsonTex1","FramesTex1","LensesTex1");
    AddOutfit("labcoat",,           ,                       ,"LabCoatTex1","PantsTex1",,"TrenchShirtTex3","LabCoatTex1","FramesTex1","LensesTex1");
    AddOutfit("paul",,              ,                       ,"PaulDentonTex2","PantsTex8",,"PaulDentonTex1","PaulDentonTex2","GrayMaskTex","BlackMaskTex");
    AddOutfit("suit",,              ,"GM_Suit"              ,"Businessman1Tex2","skin","Businessman1Tex1","Businessman1Tex1","GrayMaskTex","BlackMaskTex",);
    AddOutfit("suit2",,             ,"GM_Suit"              ,"PantsTex5","skin","MIBTex1","MIBTex1","FramesTex2","LensesTex3",);
}

function AddOutfit(string id, optional string n, optional string d, optional string mesh, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7)
{
    local int i;
    for (i = 0;i < numOutfits;i++)
    {
        if (outfits[i].id == id)
            return;
    }

    outfits[numOutfits].id = id;

    if (n == "")
        outfits[numOutfits].name = defaultOutfitNames[numOutfits];
    else
        outfits[numOutfits].name = n;
    if (d == "")
        outfits[numOutfits].desc = defaultOutfitDescs[numOutfits];
    else
        outfits[numOutfits].desc = d;

    //TODO: Convert these to use actual meshes/textutrs, rather than having to look them up each time we switch
    outfits[numOutfits].mesh = mesh;
    outfits[numOutfits].tex1 = t1;
    outfits[numOutfits].tex2 = t2;
    outfits[numOutfits].tex3 = t3;
    outfits[numOutfits].tex4 = t4;
    outfits[numOutfits].tex5 = t5;
    outfits[numOutfits].tex6 = t6;
    outfits[numOutfits].tex7 = t7;

    numOutfits++;
    //EquipOutfit(numOutfits-1);
}

function string GetOutfitName(int index)
{
    
    if (index >= numOutfits)
        return "";

    return outfits[index].name;
}

function string GetOutfitID(int index)
{
    
    if (index >= numOutfits)
        return "";

    return outfits[index].id;
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

function int GetOutfitIndexByID(string id)
{
    local int i;
    for(i = 0;i<numOutfits;i++)
        if (outfits[i].id == id)
            return i;
    return -1;
}

function bool IsEquipped(int index)
{
    return index == currentOutfitIndex;
}

function bool IsUnlocked(string id)
{
    local int i;
    for (i = 0;i < 255 && player.unlockedOutfits[i] != "";i++)
    {
        if (player.unlockedOutfits[i] == id)
            return true;
    }
    return false;
}

function bool IsUnlockedAt(int index)
{
    local int i;
    local string id;

    if (index > numOutfits)
        return false;

    id = outfits[index].id;

    return IsUnlocked(id);
}

function Unlock(string id)
{
    local int i;
    if (!IsUnlocked(id))
    {
        //find the first empty spot to put it in
        for (i = 0;i<255;i++)
        {
            if (player.unlockedOutfits[i] == "")
            {
                player.unlockedOutfits[i] = id;
                return;
            }
        }
    }
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

    player.ClientMessage("Equipping " $ currentOutfit.name);
}

function SetMesh(string mesh)
{
    local Mesh m;

    m = findMesh(mesh);

    if (m != None && mesh != "")
        player.Mesh = m;
    else
        player.Mesh = defaultMesh;
}

function SetTexture(int slot, string tex)
{
    local Texture t;

    if (tex == "skin") //Special keyword to make our skin texture appear in different slots
    {
        player.multiSkins[slot] = player.multiSkins[0];
        return;
    }
    else if (tex == "none" || tex == "")
    {
        player.multiSkins[slot] = Texture'DeusExItems.Skins.PinkMaskTex';
        return;
    }

    t = FindTexture(tex);

    if (t != None)
        player.MultiSkins[slot] = t;
    else
        player.MultiSkins[slot] = defaultTextures[slot];
}

function Mesh findMesh(string mesh)
{
    local Mesh m;
    m = Mesh(DynamicLoadObject("JCOutfits."$mesh, class'Mesh', true));
    
    if (m == None)
        m = Mesh(DynamicLoadObject("DeusExCharacters."$mesh, class'Mesh', true));

    if (m == None)
        m = Mesh(DynamicLoadObject(mesh, class'Mesh', true));

    return m;
}

function Texture findTexture(string tex)
{
    local Texture t;

    t = Texture(DynamicLoadObject("JCOutfits."$tex, class'Texture', true));
    
    if (t == None)
        t = Texture(DynamicLoadObject("DeusExCharacters.Skins."$tex, class'Texture', true));

    if (t == None)
        t = Texture(DynamicLoadObject("DeusExItems.Skins."$tex, class'Texture', true));

    if (t == None)
        t = Texture(DynamicLoadObject(tex, class'Texture', true));

    return t;
}

function SetupSpawner(OutfitSpawner S)
{
    local OutfitPickup pickup;
    local int index;

    index = GetOutfitIndexByID(S.id);

    if (index != -1)
    {
        pickup = S.Spawn(class'OutfitPickup',,, S.Location);
        pickup.id = S.id;
        pickup.itemName = outfits[index].name;
        pickup.pickupMessage = S.pickupMessage;
        pickup.Mesh = S.Mesh;
        player.ClientMessage("Added new pickup with id " $ S.id);
    }
    S.Destroy();
}

defaultproperties
{
    defaultOutfitNames(0)="JC Denton's Classic Trenchcoat"
    defaultOutfitDescs(0)="An old classic. This blue trenchcoat fits well over anything, and gives JC a cool, augmented look"
    defaultOutfitNames(1)="100% Black Outfit"
    defaultOutfitDescs(1)="The outfit of choice for malkavians"
    defaultOutfitNames(2)="Alex Jacobson's Outfit"
    defaultOutfitDescs(2)="Used by hackers everywhere!"
    defaultOutfitNames(3)="Lab Coat"
    defaultOutfitDescs(3)="Discovery Awaits!"
    defaultOutfitNames(4)="Paul Denton's Outfit"
    defaultOutfitDescs(4)="Seeing Double!"
    defaultOutfitNames(5)="Fancy Suit"
    defaultOutfitDescs(5)="For very special agents!"
    defaultOutfitNames(6)="MIB Black Suit"
    defaultOutfitDescs(6)="For very special agents!"
}
