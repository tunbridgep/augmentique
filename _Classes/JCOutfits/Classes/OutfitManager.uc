class OutfitManager extends OutfitManagerBase;

#exec OBJ LOAD FILE=DeusEx

var DeusExPlayer player;

var Outfit outfits[255];
var int numOutfits;

//Used for saving outfit number between maps
//This can be used for other purposes, but better to use currOutfit instead
var travel int savedOutfitIndex;

//Some outfits are special
const DEFAULT_OUTFIT = 0;
var Outfit currOutfit;
var Outfit customOutfit;

//Set to true to disable hats/glasses/etc
var travel bool noAccessories;

//Names for the default JC Denton outfit
var const localized string defaultOutfitNames[255];
var const localized string defaultOutfitDescs[255];

//TODO: Replace these with outfit 0
var travel string defaultTextures[8];
var travel string defaultMesh;

var PartsGroup Groups[50];
var int numPartsGroups;
var PartsGroup currentPartsGroup;

enum PartSlot
{
    PS_Body,
    PS_Trench,
    PS_Torso,
    PS_Legs,
    PS_Glasses,
    PS_Hat
};

function AddPart(PartSlot slot,string name,bool isAccessory,string id, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7)
{
    local OutfitPart P;

    P = new(Self) class'OutfitPart';

    P.partID = id;
    P.bodySlot = slot;
    p.isAccessory = isAccessory;

    if (t1 == "default") t1 = defaultTextures[1];
    if (t2 == "default") t2 = defaultTextures[2];
    if (t3 == "default") t3 = defaultTextures[3];
    if (t4 == "default") t4 = defaultTextures[4];
    if (t5 == "default") t5 = defaultTextures[5];
    if (t6 == "default") t6 = defaultTextures[6];
    if (t7 == "default") t7 = defaultTextures[7];

    P.textures[1] = findTexture(t1);
    P.textures[2] = findTexture(t2);
    P.textures[3] = findTexture(t3);
    P.textures[4] = findTexture(t4);
    P.textures[5] = findTexture(t5);
    P.textures[6] = findTexture(t6);
    P.textures[7] = findTexture(t7);
    //P.textures[8] = findTexture(t8);

    currentPartsGroup.AddPart(P);
}

function OutfitAddPart(string partID)
{
    currOutfit.AddPartFromID(partID);
}

function Setup(DeusExPlayer newPlayer)
{
    local string t0, t1, t2, t3, t4, t5, t6, t7, mesh;

    player = newPlayer;
    player.CarcassType=class'JCOutfits.OutfitCarcassReplacer';
    
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
        defaultMesh = string(player.Mesh.name);
        //Set flag for default outfit
        Player.FlagBase.SetBool('JCOutfits_Equipped_default',true,true,0);
    }

    if (numOutfits != 0)
        return;
    
    PopulateOutfitsList();
    SetupOutfitSpawners();
}

function SetupOutfitSpawners()
{
    local OutfitSpawner S;

	foreach player.AllActors(class'OutfitSpawner', S)
    {
        //player.ClientMessage("Found an outfit spawner");
        if (ValidateSpawn(S.id))
        {
            if (S.PickupName == "")
                S.ItemName = GetOutfitNameByID(S.id);
            else
                S.ItemName = S.PickupName;

            S.outfitManager = self;
        }
        else
        {
            //player.ClientMessage("OutfitManager failed to validate");
            S.Destroy();
        }
    }
}

function SpawnerPickup(OutfitSpawner S)
{
    player.ClientMessage(S.PickupMessage @ S.itemArticle @ S.ItemName , 'Pickup');
    Unlock(S.id);
    S.Destroy();
}

function PopulateOutfitsList()
{
    //player.clientmessage("Repopulating outfit list");

    //This sucks, but I can't think of a better way to do this
    
    ////Add Parts to the Parts List
    BeginNewPartsGroup("GM_Trench", true, false);
    AddPart(PS_Trench,"JC's Trenchie",false,"default_t","default",,,,"default");
    AddPart(PS_Legs,"JC's Trenchie",false,"default_p",,"default");
    AddPart(PS_Torso,"Jc's Trenchie",false,"default_s",,,,"default");
    AddPart(PS_Glasses,"JC's Glassies",true,"default_g",,,,,,"default","default");
    AddPart(PS_Trench,"Lab Coat",false,"lab_t","LabCoatTex1",,,,"LabCoatTex1");
    BeginNewOutfit2("default","Default Outfit","");
    OutfitAddPart("default_t");
    OutfitAddPart("default_p");
    OutfitAddPart("default_s");
    OutfitAddPart("default_g");
    BeginNewOutfit2("defaultL","Default Outfit w/ Lab Coat","");
    OutfitAddPart("default_p");
    OutfitAddPart("default_s");
    OutfitAddPart("default_g");
    OutfitAddPart("lab_t");

    ////Default Outfits
    
    /*
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
    
    //100% Black Combined
    //BUT Keep the glasses tex normal, so we get eye glows
    BeginNewOutfitL("100black",36,"",true,true);
    SetOutfitTextures("Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1","Outfit1_Tex1","default","default");
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
    SetOutfitFirstPersonTextures("ScubasuitTex1");
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
    SetOutfitTextures("UNATCOTroopTex1","UNATCOTroopTex2","MiscTex1JC","MiscTex1JC","GrayMaskTex","UNATCOTroopTex3");
    SetOutfitAccessorySlots(1,1,1,1,2,0,0,0,1);
    SetOutfitMesh("GM_Jumpsuit");
    
    //Mechanic
    BeginNewOutfitL("mechanic",9,"",true,false);
    SetOutfitTextures("MechanicTex2","MechanicTex1","skin","none","GrayMaskTex","MechanicTex3");
    SetOutfitMesh("GM_Jumpsuit");
    
    //Chef
    BeginNewOutfitL("chef",11,"",true,false);
    SetOutfitTextures("PantsTex10","skin","ChefTex1","ChefTex1","GrayMaskTex","BlackMaskTex","ChefTex3");
    SetOutfitMesh("GM_Suit");
    
    //Soldier
    BeginNewOutfitL("soldier",17,"",true,false);
    SetOutfitTextures("SoldierTex2","SoldierTex1","SoldierTex0","none","GrayMaskTex","SoldierTex3");
    SetOutfitAccessorySlots(1,1,1,1,2,0,0,0,1);
    SetOutfitMesh("GM_Jumpsuit");
    
    //Riot Cop
    BeginNewOutfitL("riotcop",18,"",true,false);
    SetOutfitTextures("RiotCopTex1","RiotCopTex2","skin","none","GrayMaskTex","RiotCopTex3");
    SetOutfitMainTex("VisorTex1");
    SetOutfitMesh("GM_Jumpsuit");
    
    //NSF Troop
    BeginNewOutfitL("nsf",20,"",true,false);
    SetOutfitTextures("TerroristTex2","TerroristTex1","TerroristTex0","TerroristTex0","graymasktex","GogglesTex1");
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

    //Sam Carter Outfit
    BeginNewOutfitL("carter",32,"",true,false);
    SetOutfitTextures("SamCarterTex2","SamCarterTex1","skin","none","none","none","none");
    SetOutfitDisableAccessories();
    SetOutfitMesh("GM_Jumpsuit");
    
    //Sailor
    //"Hat" Replaces head tex
    BeginNewOutfitL("sailor",31,"",true,false);
    SetOutfitTextures("SailorTex2","skin","SailorTex1","SailorTex1","GrayMaskTex","BlackMaskTex","SailorTex3");
    SetOutfitBodyTex("SailorSkin");
    SetOutfitAccessorySlots(1,2,1,1,1,1,0,0,0);
    SetOutfitMesh("GM_Suit");
    
    //Prisoner Outfit
    BeginNewOutfitL("prisoner",35,"",true,false);
    SetOutfitTextures("MechanicTex2","MechanicTex1","skin","none","GrayMaskTex","MechanicTex3");
    SetOutfitMesh("GM_Jumpsuit");
    
    //Thug
    //Beanie Replaces head tex
    BeginNewOutfitL("thug",37,"",true,false);
    SetOutfitTextures("none","none","ThugMale2Tex2","skin","ThugMale2Tex1","GrayMaskTex","BlackMaskTex");
    SetOutfitBodyTex("ThugSkin");
    SetOutfitAccessorySlots(1,2,1,1,1,1,1,1,1);
    SetOutfitMesh("GM_DressShirt");

    ////Female Outfits

    //Gold Brown Outfit
    BeginNewOutfitL("goldbrown",13,"",false,true);
    SetOutfitTextures("Outfit2F_Tex2","Outfit2F_Tex3","skin","TrenchShirtTex3","Outfit2F_Tex2","default","default");
    
    //Matrix Outfit
    BeginNewOutfitL("matrix",15,"",false,true);
    SetOutfitTextures("Outfit4F_Tex2","Outfit4F_Tex3","skin","Outfit4F_Tex1","Outfit4F_Tex2","FramesTex2","LensesTex3");
    
    //Goth GF Outfit
    BeginNewOutfitL("goth",16,"",false,true);
    SetOutfitTextures("Female4Tex2","Outfit3F_Tex3","skin","Outfit3F_Tex1","Outfit3F_Tex2","FramesTex2","LensesTex3");
    
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
    SetOutfitTextures("NicoletteDuClareTex3","NicoletteDuClareTex2","NicoletteDuClareTex1","NicoletteDuClareTex2","skin","none","skin");
    SetOutfitDisableAccessories();
    SetOutfitMesh("GFM_Dress");

    //Anna Navarre's Outfit
    BeginNewOutfitL("anna",38,"",false,true);
    SetOutfitTextures("none","none","GrayMaskTex","BlackMaskTex","skin","PantsTex9","AnnaNavarreTex1");
    SetOutfitDisableAccessories(); //Note: Possible Ponytail abailable in Slot 2
    SetOutfitMesh("GFM_TShirtPants");
    
    //Tiffany Savage's Outfit
    BeginNewOutfitL("tiffany",39,"",false,true);
    SetOutfitTextures("none","none","GrayMaskTex","BlackMaskTex","skin","TiffanySavageTex2","TiffanySavageTex1");
    SetOutfitDisableAccessories(); //Note: Possible Ponytail abailable in Slot 2
    SetOutfitMesh("GFM_TShirtPants");
    
    //Sarah Mead's Outfit
    BeginNewOutfitL("sarah",40,"",false,true);
    SetOutfitTextures("SarahMeadTex3","SarahMeadTex2","SarahMeadTex1","SarahMeadTex2","none","skin","skin");
    SetOutfitDisableAccessories();
    SetOutfitMesh("GFM_Dress");
    
    //Jordan Shea's Outfit
    BeginNewOutfitL("jordan",41,"",false,true);
    SetOutfitTextures("none","none","GrayMaskTex","BlackMaskTex","skin","PantsTex5","JordanSheaTex1");
    SetOutfitDisableAccessories(); //Note: Possible Ponytail abailable in Slot 2
    SetOutfitMesh("GFM_TShirtPants");
    
    //Hooker Outfit
    BeginNewOutfitL("hooker2",42,"",false,true);
    SetOutfitTextures("Hooker2Tex1","Hooker2Tex2","Hooker2Tex3","Hooker2Tex2","none","none","skin");
    SetOutfitDisableAccessories();
    SetOutfitMesh("GFM_Dress");
    */
}

function BeginNewPartsGroup(string mesh, bool allowMale, bool allowFemale)
{
    local int i;
    local PartsGroup G;
    local Mesh M;

    M = findMesh(mesh);

    //If we find a group with this mesh already set, use it.
    for (i = 0;i < numPartsGroups;i++)
    {
        if (M == Groups[i].mesh)
        {
            currentPartsGroup = Groups[i];
            return;
        }
    }
    
    G = new(Self) class'PartsGroup';
    G.mesh = M;
    G.allowMale = allowMale;
    G.allowFemale = allowFemale;

    Groups[numPartsGroups] = G;
    currentPartsGroup = G;
    numPartsGroups++;
}

//Localised version of BeginNewOutfit.
//Only used internally
//Works exactly the same way as BeginOutfit, but automatically looks up the default names/descriptions list
//at the bottom of this file
function BeginNewOutfitL(string id, int nameIndex, string preview)
{
    local string n,d;

    n = defaultOutfitNames[nameIndex];
    d = defaultOutfitDescs[nameIndex];

    //BeginNewOutfit(id,n,d,preview,male,female);
    BeginNewOutfit2(id,n,preview);
}

function BeginNewOutfit2(string id, string name, string preview)
{
    local Outfit O;
    O = new(Self) class'Outfit';

    O.id = id;
    O.index = numOutfits;
    O.name = name;
    O.partsGroup = currentPartsGroup;
    O.player = player;

    outfits[numOutfits++] = O;
    currOutfit = O;
}

function BeginNewOutfit(string id, string n, string d, string preview, bool male, bool female)
{
}

function EquipOutfit(int index)
{
    currOutfit = outfits[index];
    savedOutfitIndex = index;
    ApplyCurrentOutfit();
}

function EquipCustomOutfit()
{
    if (savedOutfitIndex == -1)
        return;

    currOutfit.CopyTo(customOutfit);
    currOutfit = customOutfit;
    currOutfit.id = "custom";
    currOutfit.name = "Custom Outfit";
    currOutfit.index = -1;
    currOutfit = customOutfit;
    
    savedOutfitIndex = -1;
    ApplyCurrentOutfit();
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
    for (i = 0;i < numOutfits;i++)
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

function Outfit GetOutfit(int index)
{
    return outfits[index];
}

function bool IsEquipped(int index)
{
    return index == currOutfit.index;
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
    /*
    if (index >= numOutfits)
        return false;
    
    return IsUnlocked(outfits[index].id) && IsCorrectGender(index);
    */
    return true;
}

function bool IsCorrectGender(int index)
{
    //return (outfits[index].allowMale && !IsFemale()) || (outfits[index].allowFemale && IsFemale());
    return true;
}

//Checks if any outfit matching the ID is assigned to the right gender
function bool IDGenderCheck(string id)
{
    /*
    local int i;
    for (i = 0;i<numOutfits;i++)
        if (IsCorrectGender(i))
            return true;
    return false;
    */
}

function bool IsUnlockedAt(int index)
{
    return true;
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
                //player.ClientMessage("Unlocking " $ id);
                player.unlockedOutfits[i] = id;
                player.SaveConfig();
                return;
            }
        }
    }
}

function ApplyCurrentOutfit()
{
	local JCDentonMaleCarcass jcCarcass;
	local JCDouble jc;
    local Name flag;

    //Set flag for new outfit
    //flag = player.rootWindow.StringToName("JCOutfits_Equipped_" $ outfits[currentOutfitIndex].id);
    //Player.FlagBase.SetBool(flag,true,true,0);

    //player.ClientMessage("ApplyCurrentOutfit");
    ApplyCurrentOutfitToActor(player);
    
    //Also apply to JC Carcasses and JCDoubles
	// JC Denton Carcass
	foreach player.AllActors(class'JCDentonMaleCarcass', jcCarcass)
		break;

	if (jcCarcass != None)
         UpdateCarcass(jcCarcass);

	// JC's stunt double
	foreach player.AllActors(class'JCDouble', jc)
		break;

	if (jc != None)
        ApplyCurrentOutfitToActor(jc);
}

//Apply our current outfit
function ApplyCurrentOutfitToActor(Actor A)
{
    //if (!IsEquippable(currOutfit.index))
    //    return;

    currOutfit.ApplyOutfitToActor(A,!noAccessories);
}

function UpdateCarcass(DeusExCarcass C)
{
    /*
    local string CName;
    local string M;

    CName = string(C.Mesh.name);
    ApplyCurrentOutfitToActor(C);
        
    M = defaultMesh;

    if (outfits[currentOutfitIndex].mesh != None)
        M = string(outfits[currentOutfitIndex].mesh.name);

    if (CName == ("GM_Trench_Carcass"))
       C.Mesh = findMesh(M $ "_Carcass");
    else if (CName == ("GM_Trench_CarcassB"))
        C.Mesh = findMesh(M $ "_CarcassB");
    else if (CName == ("GM_Trench_CarcassC"))
        C.Mesh = findMesh(M $ "_CarcassC");
    
    if (C.Mesh == None) //In the absolute worst case, just switch back to JC
        C.Mesh = findMesh(defaultMesh $"_Carcass");

    log("CName = " $ CName);
    log("Looking for carcass " $ outfits[currentOutfitIndex].mesh $ "_Carcass" );
    */
}

function Mesh findMesh(string mesh)
{
    local Mesh m;
    m = Mesh(DynamicLoadObject("JCOutfits."$mesh, class'Mesh', true));

    if (m == None)
        m = Mesh(DynamicLoadObject(mesh, class'Mesh', true));
    
    if (m == None)
        m = Mesh(DynamicLoadObject("DeusExCharacters."$mesh, class'Mesh', true));
    
    if (m == None)
        m = Mesh(DynamicLoadObject("FemJC."$mesh, class'Mesh', true));

    return m;
}

function Texture findTexture(string tex)
{
    local Texture t;
    
    if (tex == "skin") //Special keyword to make our skin texture appear in different slots
        return player.multiSkins[0];
    else if (tex == "none" || tex == "")
        //return Texture'DeusExItems.Skins.PinkMaskTex';
        return None;
    
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

function bool ValidateSpawn(string id)
{
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
    defaultOutfitNames(36)="100% Black (Ultimate Edition)"
    defaultOutfitDescs(36)=""
    defaultOutfitNames(37)="Thug Outfit"
    defaultOutfitDescs(37)=""
    defaultOutfitNames(38)="Anna Navarre's Outfit"
    defaultOutfitDescs(38)=""
    defaultOutfitNames(39)="Tiffany Savage's Outfit"
    defaultOutfitDescs(39)=""
    defaultOutfitNames(40)="Sarah Mead's Outfit"
    defaultOutfitDescs(40)=""
    defaultOutfitNames(41)="Jordan Shea's Outfit"
    defaultOutfitDescs(41)=""
    defaultOutfitNames(42)="Hooker Outfit"
    defaultOutfitDescs(42)=""
}
