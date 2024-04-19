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
    var Mesh mesh;

    //Textures
    var Texture tex1;
    var Texture tex2;
    var Texture tex3;
    var Texture tex4;
    var Texture tex5;
    var Texture tex6;
    var Texture tex7;
    
    //first-person arm tex
    //var travel string firstPersonArmTex;

    //LDDP Support
    var bool allowMale;
    var bool allowFemale;
};

var DeusExPlayer player;

var Outfit outfits[255];
var int numOutfits;
//var travel Outfit currentOutfit;
var travel int currentOutfitIndex;

//Names for the default JC Denton outfit
var const localized string defaultOutfitNames[255];
var const localized string defaultOutfitDescs[255];

//TODO: Replace these with outfit 0
var travel string defaultTextures[8];
var travel string defaultMesh;

function Setup(DeusExPlayer newPlayer)
{
    local string t1, t2, t3, t4, t5, t6, t7, mesh;

    player = newPlayer;
    
    if (defaultMesh == "")
    {
        //Set up defaults
        defaultTextures[0] = string(player.MultiSkins[0]);
        defaultTextures[1] = string(player.MultiSkins[1]);
        defaultTextures[2] = string(player.MultiSkins[2]);
        defaultTextures[3] = string(player.MultiSkins[3]);
        defaultTextures[4] = string(player.MultiSkins[4]);
        defaultTextures[5] = string(player.MultiSkins[5]);
        defaultTextures[6] = string(player.MultiSkins[6]);
        defaultTextures[7] = string(player.MultiSkins[7]);
        defaultMesh = string(player.Mesh);
            
        //Make sure the default outfit is always unlocked
        Unlock("default");
        Unlock("altfem1");
        Unlock("mechanic");
        Unlock("mechanic2");
    }

    numOutfits = 0;

    //This sucks, but I can't think of a better way to do this
                //id    //male/female                   //Mesh                  //Textures
    AddOutfit("default",true,true,,                     ,                       ,"default","default","default","default","default","default","default");
    AddOutfit("altfem1",false,true,,                    ,                       ,"default","default","default","Outfit1F_Tex1","default","default","default");
    AddOutfit("100black",true,true,,                    ,                       ,"Outfit100B","Outfit100B","Outfit100B","Outfit100B","Outfit100B","Outfit100B","Outfit100B");
    AddOutfit("ajacobson",true,false,,                  ,"GM_DressShirt_S"      ,,,"AlexJacobsonTex2","skin","AlexJacobsonTex1","FramesTex1","LensesTex1");
    AddOutfit("labcoat",true,false,,                    ,                       ,"LabCoatTex1","PantsTex1",,"TrenchShirtTex3","LabCoatTex1","FramesTex1","LensesTex1");
    AddOutfit("paul",true,false,,                       ,                       ,"PaulDentonTex2","PantsTex8",,"PaulDentonTex1","PaulDentonTex2","GrayMaskTex","BlackMaskTex");
    AddOutfit("suit",true,false,,                       ,"GM_Suit"              ,"Businessman1Tex2","skin","Businessman1Tex1","Businessman1Tex1","GrayMaskTex","BlackMaskTex",);
    AddOutfit("suit2",true,false,,                      ,"GM_Suit"              ,"PantsTex5","skin","MIBTex1","MIBTex1","FramesTex2","LensesTex3",);
    AddOutfit("unatcotroop",true,false,,                ,"GM_Jumpsuit"          ,"UNATCOTroopTex1","UNATCOTroopTex2","skin","skin","GrayMaskTex","UNATCOTroopTex3",);
    AddOutfit("unatcotroop2",true,false,,               ,"GM_Jumpsuit"          ,"UNATCOTroopTex1","UNATCOTroopTex2","skin","skin","GrayMaskTex",,); //No Helmet
    AddOutfit("mechanic",true,false,,                   ,"GM_Jumpsuit"          ,"MechanicTex2","MechanicTex1","skin","none","GrayMaskTex","MechanicTex3",);
    AddOutfit("mechanic2",true,false,,                  ,"GM_Jumpsuit"          ,"MechanicTex2","MechanicTex1","skin","none","GrayMaskTex",,);
}

function AddOutfit(string id, bool male, bool female, optional string n, optional string d, optional string mesh, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7)
{
    local int i;
    for (i = 0;i < numOutfits;i++)
    {
        if (outfits[i].id == id)
            return;
    }

    outfits[numOutfits].allowMale = male;
    outfits[numOutfits].allowFemale = female;

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
    outfits[numOutfits].mesh = findMesh(mesh);
    outfits[numOutfits].tex1 = findTexture(t1);
    outfits[numOutfits].tex2 = findTexture(t2);
    outfits[numOutfits].tex3 = findTexture(t3);
    outfits[numOutfits].tex4 = findTexture(t4);
    outfits[numOutfits].tex5 = findTexture(t5);
    outfits[numOutfits].tex6 = findTexture(t6);
    outfits[numOutfits].tex7 = findTexture(t7);

    numOutfits++;
    //EquipOutfit(numOutfits-1);
}

function string GetOutfitName(int index)
{
    
    if (index >= numOutfits)
        return "";

    return outfits[index].name;
}

function string GetOutfitNameByID(string id)
{
    local int index;
    index = GetOutfitIndexByID(id);

    if (index == -1)
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

function bool IsEquippable(int index)
{
    if (index >= numOutfits)
        return false;
    
    return IsUnlocked(outfits[index].id) && ((outfits[index].allowMale && !IsFemale()) || (outfits[index].allowFemale && IsFemale()));
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
    //player.ClientMessage("Unlocking " $ id);
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

    //Clear model texture
    //TODO: Fix this to work properly
    player.Texture = None;

    //player.ClientMessage("ApplyCurrentOutfit: Equipping " $ currentOutfit.name);
}

function SetMesh(Mesh mesh)
{
    if (mesh != None)
        player.Mesh = mesh;
    else
    {
        player.Mesh = findMesh(defaultMesh);
        //player.ClientMessage("Setting to default mesh: " $ defaultMesh);
    }
}

function SetTexture(int slot, Texture tex)
{
    if (tex != None)
        player.MultiSkins[slot] = tex;
    else
        player.MultiSkins[slot] = findTexture(defaultTextures[slot]);
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
    
    if (tex == "skin") //Special keyword to make our skin texture appear in different slots
        return player.multiSkins[0];
    else if (tex == "none" || tex == "")
        return Texture'DeusExItems.Skins.PinkMaskTex';

    t = Texture(DynamicLoadObject("JCOutfits."$tex, class'Texture', true));
    
    if (t == None)
        t = Texture(DynamicLoadObject("DeusExCharacters.Skins."$tex, class'Texture', true));

    if (t == None)
        t = Texture(DynamicLoadObject("DeusExItems.Skins."$tex, class'Texture', true));

    if (t == None)
        t = Texture(DynamicLoadObject(tex, class'Texture', true));

    return t;
}

function bool IsFemale()
{
    return player.FlagBase != None && player.FlagBase.GetBool('LDDPJCIsFemale');
}

defaultproperties
{
    defaultOutfitNames(0)="JC Denton's Classic Trenchcoat"
    defaultOutfitDescs(0)="An old classic. This blue trenchcoat fits well over anything, and gives JC a cool, augmented look"
    defaultOutfitNames(1)="JC Denton's Classic Trenchcoat (Alternate)"
    defaultOutfitDescs(1)="JC Denton's Signature Trenchcoat, now with extra jewellery!"
    defaultOutfitNames(2)="100% Black Outfit"
    defaultOutfitDescs(2)="The outfit of choice for malkavians"
    defaultOutfitNames(3)="Alex Jacobson's Outfit"
    defaultOutfitDescs(3)="Used by hackers everywhere!"
    defaultOutfitNames(4)="Lab Coat"
    defaultOutfitDescs(4)="Discovery Awaits!"
    defaultOutfitNames(5)="Paul Denton's Outfit"
    defaultOutfitDescs(5)="Seeing Double!"
    defaultOutfitNames(6)="Fancy Suit"
    defaultOutfitDescs(6)="For very special agents!"
    defaultOutfitNames(7)="MIB Black Suit"
    defaultOutfitDescs(7)="For very special agents!"
    defaultOutfitNames(8)="UNATCO Standard BDU"
    defaultOutfitDescs(8)=""
    defaultOutfitNames(9)="UNATCO Standard BDU (No Helmet)"
    defaultOutfitDescs(9)=""
    defaultOutfitNames(10)="Mechanics Outfit"
    defaultOutfitDescs(10)=""
    defaultOutfitNames(11)="Mechanics Outfit (No Helmet)"
    defaultOutfitDescs(11)=""
}
