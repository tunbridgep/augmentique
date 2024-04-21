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
    
    //"Main" Texture
    var Texture texM;
    
    //first-person arm tex
    //var travel string firstPersonArmTex;

    //Which texture number is the start of the accessories
    //This determines which textures to toggle.
    var int accessoriesOffset;

    //LDDP Support
    var bool allowMale;
    var bool allowFemale;
};

var DeusExPlayer player;

var Outfit outfits[255];
var int numOutfits;
//var travel Outfit currentOutfit;
var travel string currentOutfitID;

//Set to true to disable hats/glasses/etc
var travel bool noAccessories;

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
        Unlock("unatcotroop");
    
        //player.clientmessage(defaultMesh);
    }
        
    if (numOutfits != 0)
        return;
        
    //player.clientmessage("Repopulating outfit list");

    //This sucks, but I can't think of a better way to do this
                //id        //male,female       //Mesh                  //Textures
    //Default Outfits
    AddOutfitL("default",0,"",true,true            ,                       ,,"default","default","default","default","default","default","default");
    AddOutfitL("altfem1",1,"",false,true           ,                       ,,"default","default","default","Outfit1F_Tex1","default","default","default");

    //Multi-Gender
    AddOutfitL("100black",2,"",true,true           ,                       ,,"Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1");
    AddOutfitL("labcoat",4,"",true,false           ,                       ,,"LabCoatTex1","PantsTex1",,"TrenchShirtTex3","LabCoatTex1","FramesTex1","LensesTex1");
    AddOutfitL("labcoat",4,"",false,true           ,"GFM_Trench"           ,,"ScientistFemaleTex2","ScientistFemaleTex3","skin","TrenchShirtTex3","ScientistFemaleTex2","FramesTex1","LensesTex2");

    //Male Outfits
    AddOutfitL("ajacobson",3,"",true,false         ,"GM_DressShirt_S"      ,,"none","none","AlexJacobsonTex2","skin","AlexJacobsonTex1","FramesTex1","LensesTex1");
    AddOutfitL("paul",5,"",true,false              ,                       ,,"PaulDentonTex2","PantsTex8",,"PaulDentonTex1","PaulDentonTex2","default","default");
    AddOutfitL("suit",6,"",true,false              ,"GM_Suit"              ,,"Businessman1Tex2","skin","Businessman1Tex1","Businessman1Tex1","FramesTex1","LensesTex2",,5);
    AddOutfitL("suit2",7,"",true,false             ,"GM_Suit"              ,,"PantsTex5","skin","MIBTex1","MIBTex1","FramesTex2","LensesTex3",,5);
    AddOutfitL("unatcotroop",8,"",true,false       ,"GM_Jumpsuit"          ,,"UNATCOTroopTex1","UNATCOTroopTex2","skin","none","GrayMaskTex","UNATCOTroopTex3",);
    AddOutfitL("mechanic",9,"",true,false          ,"GM_Jumpsuit"          ,,"MechanicTex2","MechanicTex1","skin","none","GrayMaskTex","MechanicTex3",);
    AddOutfitL("chef",11,"",true,false             ,"GM_Suit"              ,,"PantsTex10","skin","ChefTex1","ChefTex1","GrayMaskTex","BlackMaskTex","ChefTex3");
    AddOutfitL("soldier",17,"",true,false          ,"GM_Jumpsuit"          ,,"SoldierTex2","SoldierTex1","skin","none","GrayMaskTex","SoldierTex3",);
    AddOutfitL("riotcop",18,"",true,false          ,"GM_Jumpsuit"          ,"VisorTex1","RiotCopTex1","RiotCopTex2","skin","none","GrayMaskTex","RiotCopTex3");
    AddOutfitL("nsf",20,"",true,false              ,"GM_Jumpsuit"          ,,"TerroristTex2","TerroristTex1","skin","none","none","GogglesTex1");

    //Female Outfits
    AddOutfitL("goldbrown",13,"",false,true        ,                       ,,"Outfit2F_Tex2","Outfit2F_Tex3","skin","TrenchShirtTex3","Outfit2F_Tex2","default","default");
    AddOutfitL("matrix",15,"",false,true           ,                       ,,"Outfit4F_Tex2","Outfit4F_Tex3","skin","Outfit4F_Tex1","Outfit4F_Tex2","FramesTex2","LensesTex3");
    AddOutfitL("goth",16,"",false,true             ,                       ,,"Female4Tex2","Outfit3F_Tex3","skin","Outfit3F_Tex1","Female4Tex2","FramesTex2","LensesTex3",);
    AddOutfitL("wib",19,"",false,true              ,"GFM_SuitSkirt"        ,,"none","skin","LegsTex2","WIBTex1","WIBTex1","FramesTex2","LensesTex3",);
}

//Localised version of AddOutfit.
//Only used internally
//Works exactly the same way as AddOutfit, but automatically looks up the default names/descriptions list
//at the bottom of this file
function AddOutfitL(string id, int nameIndex, string preview, bool male, bool female, optional string mesh, optional string tm, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional int accessoriesOffset)
{
    local string n,d;

    n = defaultOutfitNames[nameIndex];
    d = defaultOutfitDescs[nameIndex];

    AddOutfit(id,n,d,preview,male,female,mesh,tm,t1,t2,t3,t4,t5,t6,t7,accessoriesOffset);
}

function AddOutfit(string id, string n, string d, string preview, bool male, bool female, optional string mesh, optional string tm, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional int accessoriesOffset)
{
    local int i;

    //Disallow adding new outfits with the same ID, unless they are made for a different gender
    for (i = 0;i < numOutfits;i++)
    {
        if (outfits[i].id == id && (outfits[i].allowMale == male || outfits[i].allowFemale == female))
            return;
    }

    outfits[numOutfits].allowMale = male;
    outfits[numOutfits].allowFemale = female;

    outfits[numOutfits].id = id;

    outfits[numOutfits].name = n;
    outfits[numOutfits].desc = d;

    outfits[numOutfits].mesh = findMesh(mesh);
    outfits[numOutfits].tex1 = findTexture(t1);
    outfits[numOutfits].tex2 = findTexture(t2);
    outfits[numOutfits].tex3 = findTexture(t3);
    outfits[numOutfits].tex4 = findTexture(t4);
    outfits[numOutfits].tex5 = findTexture(t5);
    outfits[numOutfits].tex6 = findTexture(t6);
    outfits[numOutfits].tex7 = findTexture(t7);
    outfits[numOutfits].texM = findTexture(tm);
    
    //Set accessories offset
    if (accessoriesOffset == 0)
        accessoriesOffset = 6;
    outfits[numOutfits].accessoriesOffset = accessoriesOffset;

    numOutfits++;
    //EquipOutfit(numOutfits-1);
        
    //TEST DEBUG. REMOVE LATER
    Unlock(id);
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
    
    currentOutfitID = outfits[index].id;
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
        if (outfits[i].id == id && IsCorrectGender(i))
            return i;
    return -1;
}

function bool IsEquipped(string id)
{
    return id == currentOutfitID;
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
    
    return IsUnlocked(outfits[index].id) && IsCorrectGender(index);
}

function bool IsCorrectGender(int index)
{
    return (outfits[index].allowMale && !IsFemale()) || (outfits[index].allowFemale && IsFemale());
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

    local int index;
    index = GetOutfitIndexByID(currentOutfitID);

    if (!IsEquippable(index))
        return;

    //Set Mesh
    SetMesh(index);

    //Set Textures
    SetTexture(index,1);
    SetTexture(index,2);
    SetTexture(index,3);
    SetTexture(index,4);
    SetTexture(index,5);
    SetTexture(index,6);
    SetTexture(index,7);
    
    //Set model texture
    SetMainTexture(index);

    //player.ClientMessage("ApplyCurrentOutfit");
}

function SetMesh(int index)
{
    local Mesh mesh;
    mesh = outfits[index].mesh;

    if (mesh != None)
        player.Mesh = mesh;
    else
    {
        player.Mesh = findMesh(defaultMesh);
        //player.ClientMessage("Setting to default mesh: " $ defaultMesh);
    }
}

function SetMainTexture(int index)
{
    local Texture tex;

    //If we're hiding accessories, simply set it to the pink tex
    if (noAccessories)
    {
        player.Texture = Texture'DeusExItems.Skins.PinkMaskTex';
        return;
    }
            
    tex = outfits[index].texM;
    
    player.Texture = tex;
}


function SetTexture(int index,int slot)
{
    local Texture tex;
    local Outfit currentOutfit;
    currentOutfit = outfits[index];


    //If we're hiding accessories, simply set it to the pink tex
    if (noAccessories && slot >= currentOutfit.accessoriesOffset && slot < currentOutfit.accessoriesOffset + 2)
    {
        player.MultiSkins[slot] = Texture'DeusExItems.Skins.PinkMaskTex';
        return;
    }

    //This fucking sucks
    //TODO: Use an array instead!
    switch (slot)
    {
        case 1:
            tex = currentOutfit.tex1;
            break;
        case 2:
            tex = currentOutfit.tex2;
            break;
        case 3:
            tex = currentOutfit.tex3;
            break;
        case 4:
            tex = currentOutfit.tex4;
            break;
        case 5:
            tex = currentOutfit.tex5;
            break;
        case 6:
            tex = currentOutfit.tex6;
            break;
        case 7:
            tex = currentOutfit.tex7;
            break;
    }

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
    
    //First, search for a skinned version. See the Readme for more info
    t = Texture(DynamicLoadObject("JCOutfits."$tex$"_S"$player.PlayerSkin, class'Texture', true));

    if (t == None)
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
    currentOutfitID="default"
    defaultOutfitNames(0)="JC Denton's Trenchcoat"
    defaultOutfitDescs(0)="An old classic. This blue trenchcoat fits well over anything, and gives JC a cool, augmented look"
    defaultOutfitNames(1)="JC Denton's Trenchcoat (Alt)"
    defaultOutfitDescs(1)="JC Denton's Signature Trenchcoat, now with extra jewellery!"
    defaultOutfitNames(2)="100% Black"
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
    defaultOutfitNames(8)="UNATCO Combat Uniform"
    defaultOutfitDescs(8)=""
    defaultOutfitNames(9)="Mechanic Jumpsuit"
    defaultOutfitDescs(9)=""
    defaultOutfitNames(11)="Chef Outfit"
    defaultOutfitDescs(11)="Something about cooking, IDK"
    defaultOutfitNames(13)="Gold and Brown Business"
    defaultOutfitDescs(13)=""
    defaultOutfitNames(14)="Goth GF Outfit"
    defaultOutfitDescs(14)=""
    defaultOutfitNames(15)="Matrix Outfit"
    defaultOutfitDescs(15)="This outfit is considered one of the classic three. From the immortal Trinity, if you will..."
    defaultOutfitNames(16)="Goth GF Outfit"
    defaultOutfitDescs(16)=""
    defaultOutfitNames(17)="Soldier Outfit"
    defaultOutfitDescs(17)=""
    defaultOutfitNames(18)="Riot Gear"
    defaultOutfitDescs(18)=""
    defaultOutfitNames(19)="WIB Suit"
    defaultOutfitDescs(19)="Dressed to Kill"
    defaultOutfitNames(20)="NSF Sympathiser"
    defaultOutfitDescs(20)="For the people!"
}
