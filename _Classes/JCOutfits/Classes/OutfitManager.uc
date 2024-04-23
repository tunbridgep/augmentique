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
    var Texture tex0;
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

    //Accessories
    var int accessorySlots[9]; //bool arrays are not allowed

    //LDDP Support
    var bool allowMale;
    var bool allowFemale;
};

var DeusExPlayer player;

var Outfit outfits[255];
var int numOutfits;
var int currOutfit;

var travel int currentOutfitIndex;

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
    local string t0, t1, t2, t3, t4, t5, t6, t7, mesh;

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
    }
        
    if (numOutfits != 0)
        return;
    
    SetupDefaultOutfit();

    //player.clientmessage("Repopulating outfit list");

    //This sucks, but I can't think of a better way to do this

    ////Default Outfits
    
    //Alternate Fem Jewellery
    BeginNewOutfitL("default",1,"",false,true);
    SetOutfitTextures("default","default","default","Outfit1F_Tex1","default","default","default");

    ////Multi-Gender

    //100% Black
    BeginNewOutfitL("100black",2,"",true,true);
    SetOutfitTextures("Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1");

    //100% Black Alternate
    BeginNewOutfitL("100black",34,"",true,true);
    SetOutfitBodyTex("Outfit1_Tex1");

    //Labcoat M & F
    BeginNewOutfitL("labcoat",4,"",true,false);
    SetOutfitTextures("LabCoatTex1","PantsTex1","skin","TrenchShirtTex3","LabCoatTex1","FramesTex1","LensesTex1");
    BeginNewOutfitL("labcoat",4,"",false,true);
    SetOutfitMesh("GFM_Trench");
    SetOutfitTextures("ScientistFemaleTex2","ScientistFemaleTex3","skin","TrenchShirtTex3","ScientistFemaleTex2","FramesTex1","LensesTex2");
    
    //Diver
    BeginNewOutfitL("diver",33,"",true,true);
    SetOutfitTextures("ScubasuitTex0","ScubasuitTex1","none","none","none","none","none");
    SetOutfitMainTex("ScubasuitTex1");
    SetOutfitMesh("GM_Scubasuit");
    SetOutfitDisableAccessories();
    
    ////Male Outfits

    //Alex Jacobson Outfit
    BeginNewOutfitL("ajacobson",3,"",true,false);
    SetOutfitTextures("none","none","AlexJacobsonTex2","skin","AlexJacobsonTex1","FrameTex1","LensesTex1");
    SetOutfitMesh("GM_DressShirt_S");
    
    //Paul Outfit
    BeginNewOutfitL("paul",5,"",true,false);
    SetOutfitTextures("PaulDentonTex2","PantsTex8",,"PaulDentonTex1","PaulDentonTex2","default","default");

    //Brown Suit
    BeginNewOutfitL("suit",6,"",true,false);
    SetOutfitTextures("Businessman1Tex2","skin","Businessman1Tex1","Businessman1Tex1","FramesTex1","LensesTex2");
    SetOutfitAccessorySlots(0,1,1,1,1,1,0,0,1);
    SetOutfitMesh("GM_Suit");
    
    //MIB Suit
    BeginNewOutfitL("suit2",7,"",true,false);
    SetOutfitTextures("PantsTex5","skin","MIBTex1","MIBTex1","FramesTex2","LensesTex3");
    SetOutfitAccessorySlots(1,1,1,1,1,1,0,0,1);
    SetOutfitMesh("GM_Suit");
    
    //Presidents Suit
    BeginNewOutfitL("suit3",30,"",true,false);
    SetOutfitTextures("PantsTex5","skin","PhilipMeadTex1","PhilipMeadTex1","FramesTex2","LensesTex3");
    SetOutfitAccessorySlots(1,1,1,1,1,1,0,0,1);
    SetOutfitMesh("GM_Suit");
    
    //Unatco Troop
    BeginNewOutfitL("unatcotroop",8,"",true,false);
    SetOutfitTextures("UNATCOTroopTex1","UNATCOTroopTex2","skin","none","GrayMaskTex","UNATCOTroopTex3");
    SetOutfitMesh("GM_Jumpsuit");
    
    //Mechanic
    BeginNewOutfitL("unatcotroop",9,"",true,false);
    SetOutfitTextures("MechanicTex2","MechanicTex1","skin","none","GrayMaskTex","MechanicTex3");
    SetOutfitMesh("GM_Jumpsuit");
    
    //Chef
    BeginNewOutfitL("chef",11,"",true,false);
    SetOutfitTextures("PantsTex10","skin","ChefTex1","ChefTex1","GrayMaskTex","BlackMaskTex","ChefTex3");
    SetOutfitMesh("GM_Suit");
    
    //Soldier
    BeginNewOutfitL("soldier",17,"",true,false);
    SetOutfitTextures("SoldierTex2","SoldierTex1","skin","none","GrayMaskTex","SoldierTex3");
    SetOutfitMesh("GM_Jumpsuit");
    
    //Riot Cop
    BeginNewOutfitL("riotcop",18,"",true,false);
    SetOutfitTextures("RiotCopTex1","RiotCopTex2","skin","none","GrayMaskTex","RiotCopTex3");
    SetOutfitMainTex("VisorTex1");
    SetOutfitMesh("GM_Jumpsuit");
    
    //NSF Troop
    BeginNewOutfitL("nsf",20,"",true,false);
    SetOutfitTextures("TerroristTex2","TerroristTex1","TerroristTex0","none","graymasktex","GogglesTex1");
    SetOutfitAccessorySlots(0,1,1,1,2,0,0,0,0);
    SetOutfitMesh("GM_Jumpsuit");
    
    //Bum
    BeginNewOutfitL("bum",21,"",true,false);
    SetOutfitTextures("BumMaleTex2","PantsTex4","skin","TrenchShirtTex1","BumMaleTex2","FramesTex1","LensesTex2");

    //Lebedev
    BeginNewOutfitL("lebedev",22,"",true,false);
    SetOutfitTextures("JuanLebedevTex2","JuanLebedevTex3","skin","JuanLebedevTex1","JuanLebedevTex2","default","default");

    //Smugglers Outfit
    BeginNewOutfitL("smug",23,"",true,false);
    SetOutfitTextures("SmugglerTex2","PantsTex5","skin","SmugglerTex1","SmugglerTex2","FramesTex1","LensesTex1");

    //Simons Outfit
    BeginNewOutfitL("simons",24,"",true,false);
    SetOutfitTextures("WaltonSimonsTex2","PantsTex5","skin","WaltonSimonsTex1","WaltonSimonsTex2","FramesTex2","LensesTex3");

    //MJ12 Outfit
    BeginNewOutfitL("mj12",25,"",true,false);
    SetOutfitTextures("MJ12TroopTex1","MJ12TroopTex2","skin","none","MJ12TroopTex3","MJ12TroopTex4","none");
    SetOutfitAccessorySlots(1,1,1,1,1,1,0,0,1);
    SetOutfitMesh("GM_Jumpsuit");

    //MJ12 Outfit
    BeginNewOutfitL("carter",32,"",true,false);
    SetOutfitTextures("SamCarterTex2","SamCarterTex1","skin","none","none","none","none");
    SetOutfitDisableAccessories();
    SetOutfitMesh("GM_Jumpsuit");
    
    //Prisoner
    BeginNewOutfitL("prisoner",35,"",true,false);
    SetOutfitTextures("MechanicTex2","MechanicTex1","skin","none","GrayMaskTex","MechanicTex3");
    SetOutfitMesh("GM_Jumpsuit");

    ////Female Outfits

    //Gold Brown Outfit
    BeginNewOutfitL("goldbrown",13,"",false,true);
    SetOutfitTextures("Outfit2F_Tex2","Outfit2F_Tex3","skin","TrenchShirtTex3","Outfit2F_Tex2","default","default");
    
    //Matrix Outfit
    BeginNewOutfitL("matrix",15,"",false,true);
    SetOutfitTextures("Outfit4F_Tex2","Outfit4F_Tex3","skin","Outfit4F_Tex1","Outfit4F_Tex2","FramesTex2","LensesTex3");
    
    //Goth GF Outfit
    BeginNewOutfitL("goth",16,"",false,true);
    SetOutfitTextures("Female4Tex2","Outfit3F_Tex3","skin","Outfit3F_Tex1","Female4Tex2","FramesTex2","LensesTex3");
    
    //WIB Outfit
    BeginNewOutfitL("wib",19,"",false,true);
    SetOutfitTextures("none","skin","LegsTex2","WIBTex1","WIBTex1","FramesTex2","LensesTex3");
    SetOutfitMesh("GFM_SuitSkirt");

    //Maggie Outfit
    BeginNewOutfitL("maggie",27,"",false,true);
    SetOutfitTextures("none","skin","LegsTex2","MaggieChowTex1","MaggieChowTex1","FramesTex2","LensesTex3");
    SetOutfitMesh("GFM_SuitSkirt");

    //Nicolette Outfit
    BeginNewOutfitL("nicolette",28,"",false,true);
    SetOutfitTextures("NicoletteDuClareTex3","NicoletteDuClareTex2","NicoletteDuClareTex1","NicoletteDuClareTex2","skin","FramesTex2","skin");
    SetOutfitDisableAccessories();
    SetOutfitMesh("GFM_Dress");
}

//Localised version of BeginNewOutfit.
//Only used internally
//Works exactly the same way as BeginOutfit, but automatically looks up the default names/descriptions list
//at the bottom of this file
function BeginNewOutfitL(string id, int nameIndex, string preview, bool male, bool female)
{
    local string n,d;

    n = defaultOutfitNames[nameIndex];
    d = defaultOutfitDescs[nameIndex];

    BeginNewOutfit(id,n,d,preview,male,female);
}

function BeginNewOutfit(string id, string n, string d, string preview, bool male, bool female)
{
    currOutfit = numOutfits;
    //player.ClientMessage("Starting new outfit with id " $ id);
    outfits[currOutfit].allowMale = male;
    outfits[currOutfit].allowFemale = female;

    outfits[currOutfit].id = id;

    outfits[currOutfit].name = n;
    outfits[currOutfit].desc = d;
    
    outfits[currOutfit].tex0 = findTexture(defaultTextures[0]);
    outfits[currOutfit].tex1 = findTexture(defaultTextures[1]);
    outfits[currOutfit].tex2 = findTexture(defaultTextures[2]);
    outfits[currOutfit].tex3 = findTexture(defaultTextures[3]);
    outfits[currOutfit].tex4 = findTexture(defaultTextures[4]);
    outfits[currOutfit].tex5 = findTexture(defaultTextures[5]);
    outfits[currOutfit].tex6 = findTexture(defaultTextures[6]);
    outfits[currOutfit].tex7 = findTexture(defaultTextures[7]);

    SetOutfitAccessorySlots(1,1,1,1,1,1,1,0,0);
    
    numOutfits++;

    //TEST DEBUG. REMOVE LATER
    //Unlock(id);
}

function SetOutfitMesh(string mesh)
{
    outfits[currOutfit].mesh = findMesh(mesh);
}

function SetOutfitTextures(optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional int accessoriesOffset)
{
    outfits[currOutfit].tex1 = findTexture(t1);
    outfits[currOutfit].tex2 = findTexture(t2);
    outfits[currOutfit].tex3 = findTexture(t3);
    outfits[currOutfit].tex4 = findTexture(t4);
    outfits[currOutfit].tex5 = findTexture(t5);
    outfits[currOutfit].tex6 = findTexture(t6);
    outfits[currOutfit].tex7 = findTexture(t7);
}

//Set slots to 0 to hide them, 1 to show them, and 2 to replace them with our skin tex when we are in "accessories off" mode
function SetOutfitAccessorySlots(int tm,int t0, int t1, int t2, int t3, int t4, int t5, int t6, int t7)
{
    outfits[currOutfit].accessorySlots[0] = t0;
    outfits[currOutfit].accessorySlots[1] = t1;
    outfits[currOutfit].accessorySlots[2] = t2;
    outfits[currOutfit].accessorySlots[3] = t3;
    outfits[currOutfit].accessorySlots[4] = t4;
    outfits[currOutfit].accessorySlots[5] = t5;
    outfits[currOutfit].accessorySlots[6] = t6;
    outfits[currOutfit].accessorySlots[7] = t7;
    outfits[currOutfit].accessorySlots[8] = tm;
}

function SetOutfitDisableAccessories()
{
    SetOutfitAccessorySlots(1,1,1,1,1,1,1,1,1);
}

function SetOutfitMainTex(string tm)
{
    outfits[currOutfit].texM = findTexture(tm);
}

function SetOutfitBodyTex(string t0)
{
    //Texture 0 is special and should always default to skin
    if (t0 == "")
        t0 = "skin";
    outfits[currOutfit].tex0 = findTexture(t0);
}

function SetupDefaultOutfit()
{
    outfits[0].allowMale = true;
    outfits[0].allowFemale = true;
    outfits[0].id = "default";
    
    outfits[0].name = defaultOutfitNames[0];
    outfits[0].desc = defaultOutfitDescs[0];
    
    outfits[0].tex0 = findTexture(defaultTextures[0]);
    outfits[0].tex1 = findTexture(defaultTextures[1]);
    outfits[0].tex2 = findTexture(defaultTextures[2]);
    outfits[0].tex3 = findTexture(defaultTextures[3]);
    outfits[0].tex4 = findTexture(defaultTextures[4]);
    outfits[0].tex5 = findTexture(defaultTextures[5]);
    outfits[0].tex6 = findTexture(defaultTextures[6]);
    outfits[0].tex7 = findTexture(defaultTextures[7]);
    outfits[0].texM = None;
    
    outfits[0].mesh = findMesh(defaultMesh);
    
    SetOutfitAccessorySlots(0,1,1,1,1,1,1,0,0);

    Unlock("default");
    numOutfits++;
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

function int GetOutfitIndexByID(string id)
{
    local int i;
    for (i = 0;i < 255 && player.unlockedOutfits[i] != "";i++)
        if (outfits[i].id == id)
            return i;

    return -1;
}

function string GetOutfitID(int index)
{
    
    if (index >= numOutfits)
        return "";

    return outfits[index].id;
}

function bool HasAccessories(int index)
{
    local int i;
    if (index >= numOutfits)
        return false;

    for (i = 0;i < 9;i++)
    {
        if (outfits[index].accessorySlots[i] != 1)
            return true;
    }
    return false;
}

function EquipOutfit(int index)
{
    if (index >= numOutfits)
        return;
    
    currentOutfitindex = index;
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

    if (!IsEquippable(currentOutfitIndex))
        return;

    //Set Mesh
    SetMesh(currentOutfitIndex);

    //Set Textures
    SetTexture(currentOutfitIndex,0);
    SetTexture(currentOutfitIndex,1);
    SetTexture(currentOutfitIndex,2);
    SetTexture(currentOutfitIndex,3);
    SetTexture(currentOutfitIndex,4);
    SetTexture(currentOutfitIndex,5);
    SetTexture(currentOutfitIndex,6);
    SetTexture(currentOutfitIndex,7);
    
    //Set model texture
    SetMainTexture(currentOutfitIndex);

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
    if (noAccessories && HasAccessories(index))
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
    if (noAccessories && currentOutfit.accessorySlots[slot] != 1)
    {
        if (currentOutfit.accessorySlots[slot] == 0)
            player.MultiSkins[slot] = Texture'DeusExItems.Skins.PinkMaskTex';
        else if (currentOutfit.accessorySlots[slot] == 2)
            player.MultiSkins[slot] = findTexture(defaultTextures[0]);
        return;
    }

    //This fucking sucks
    //TODO: Use an array instead!
    switch (slot)
    {
        case 0:
            tex = currentOutfit.tex0;
            break;
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
        m = Mesh(DynamicLoadObject(mesh, class'Mesh', true));
    
    if (m == None)
        m = Mesh(DynamicLoadObject("DeusExCharacters."$mesh, class'Mesh', true));

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
        t = Texture(DynamicLoadObject(tex, class'Texture', true));
    
    if (t == None)
        t = Texture(DynamicLoadObject("DeusExCharacters.Skins."$tex, class'Texture', true));

    if (t == None)
        t = Texture(DynamicLoadObject("DeusExItems.Skins."$tex, class'Texture', true));

    return t;
}

function bool IsFemale()
{
    return player.FlagBase != None && player.FlagBase.GetBool('LDDPJCIsFemale');
}

//Functions called by spawners
function bool ValidateSpawn(string id)
{
    local int index;
    index = GetOutfitIndexByID(id);
    return index > -1 && IsCorrectGender(index) && !IsUnlocked(id);
}

defaultproperties
{
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
    defaultOutfitNames(21)="Stained Clothes"
    defaultOutfitDescs(21)="Look for a bum."
    defaultOutfitNames(22)="Juan Lebedev's Outfit"
    defaultOutfitDescs(22)="So fine it'll make you want to kill your boss"
    defaultOutfitNames(23)="Smuggler's Outfit"
    defaultOutfitDescs(23)="This expensive outfit matches Smuggler's Prices"
    defaultOutfitNames(24)="FEMA Executive's Outfit"
    defaultOutfitDescs(24)="Just because you work behind a desk doesn't mean you can't be fashionable"
    defaultOutfitNames(25)="MJ12 Soldier Outfit"
    defaultOutfitDescs(25)="The sort of outfit you can take over the world in"
    defaultOutfitNames(26)="Jock's Outfit"
    defaultOutfitDescs(26)=""
    defaultOutfitNames(27)="Maggie's Outfit"
    defaultOutfitDescs(27)=""
    defaultOutfitNames(28)="Nicolette's Outfit"
    defaultOutfitDescs(28)=""
    defaultOutfitNames(29)="JC Clone Outfit"
    defaultOutfitDescs(29)=""
    defaultOutfitNames(30)="Presidential Suit"
    defaultOutfitDescs(30)=""
    defaultOutfitNames(31)="Sailor Outfit"
    defaultOutfitDescs(31)=""
    defaultOutfitNames(32)="Carter's Outfit"
    defaultOutfitDescs(32)=""
    defaultOutfitNames(33)="Scuba Suit"
    defaultOutfitDescs(33)=""
    defaultOutfitNames(34)="100% Black (Alt)"
    defaultOutfitDescs(34)="OMG! It's just like the memes!"
    defaultOutfitNames(35)="Prison Uniform"
    defaultOutfitDescs(35)=""
}
