class OutfitManager extends OutfitManagerBase;

#exec OBJ LOAD FILE=DeusEx

var DeusExPlayer player;

var Outfit outfits[255];
var int numOutfits;

//Used for saving outfit number between maps
//This can be used for other purposes, but better to use currOutfit instead
var travel int savedOutfitIndex;

//Some outfits are special
const CUSTOM_OUTFIT = 0;
const DEFAULT_OUTFIT = 1;
var Outfit currOutfit;
var Outfit customOutfit;

//Set to true to disable hats/glasses/etc
var travel bool noAccessories;

//Names for the default JC Denton outfit
var const localized string partNames[255];
var const localized string outfitNames[255];
var const localized string outfitDescs[255];
var const localized string CustomOutfitName;
var const localized string NothingName;

//TODO: Replace these with outfit 0
var travel string defaultTextures[8];
var travel string defaultMesh;

var OutfitPart PartsList[300];
var int numParts;
var PartsGroup Groups[50];
var int numPartsGroups;
var PartsGroup currentPartsGroup;

//custom outfit stuff
//Horrible hack
var travel string customPartIDs[20];
var travel int customPartsNum;
var travel string customPartsGroupID;

enum PartSlot
{
    PS_Body,
    PS_Trench,
    PS_Torso,
    PS_Legs,
    PS_Glasses,
    PS_Hat,
    PS_Main,             //Main model texture
    PS_Mask
};

function OutfitPart CreateNewOutfitPart(PartSlot slot,string name,bool isAccessory,string id, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm)
{
    local OutfitPart P;

    P = new(Self) class'OutfitPart';

    P.partID = id;
    P.name = name;
    P.bodySlot = slot;
    P.isAccessory = isAccessory;

    if (t0 == "default") t0 = defaultTextures[0];
    if (t1 == "default") t1 = defaultTextures[1];
    if (t2 == "default") t2 = defaultTextures[2];
    if (t3 == "default") t3 = defaultTextures[3];
    if (t4 == "default") t4 = defaultTextures[4];
    if (t5 == "default") t5 = defaultTextures[5];
    if (t6 == "default") t6 = defaultTextures[6];
    if (t7 == "default") t7 = defaultTextures[7];

    P.textures[0] = findTexture(t0);
    P.textures[1] = findTexture(t1);
    P.textures[2] = findTexture(t2);
    P.textures[3] = findTexture(t3);
    P.textures[4] = findTexture(t4);
    P.textures[5] = findTexture(t5);
    P.textures[6] = findTexture(t6);
    P.textures[7] = findTexture(t7);
    P.textures[8] = findTexture(tm);

    return P;
}

//Localised version of GlobalAddPart.
//Only used internally
//Works exactly the same way as GlobalAddPart, but automatically looks up the default names/descriptions list
//at the bottom of this file
function GlobalAddPartL(PartSlot slot,int partNameIndex,bool isAccessory,string id, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm)
{
    GlobalAddPart(slot,partNames[partNameIndex],isAccessory,id,t0,t1,t2,t3,t4,t5,t6,t7,tm);
}

//Localised version of GlobalAddPart.
//Only used internally
//Works exactly the same way as GlobalAddPartL, but automatically looks up the default names/descriptions list
//at the bottom of this file
//Uses the outfit names list rather than the parts list
function GlobalAddPartLO(PartSlot slot,int outfitNameIndex,bool isAccessory,string id, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm)
{
    GlobalAddPart(slot,outfitNames[outfitNameIndex],isAccessory,id,t0,t1,t2,t3,t4,t5,t6,t7,tm);
}

function GlobalAddPart(PartSlot slot,string name,bool isAccessory,string id, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm)
{
    local OutfitPart P;
    
    P = CreateNewOutfitPart(slot,name,isAccessory,id,t0,t1,t2,t3,t4,t5,t6,t7,tm);

    PartsList[numParts] = P;
    P.index = numParts;
    numParts++;
}

//Localised version of AddPart.
//Only used internally
//Works exactly the same way as AddPart, but automatically looks up the default names/descriptions list
//at the bottom of this file
function AddPartL(PartSlot slot,int partNameIndex,bool isAccessory,string id, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm)
{
    AddPart(slot,partNames[partNameIndex],isAccessory,id,t0,t1,t2,t3,t4,t5,t6,t7,tm);
}

//Localised version of AddPart.
//Only used internally
//Works exactly the same way as AddPartL, but automatically looks up the default names/descriptions list
//at the bottom of this file
//Uses the outfit names list rather than the parts list
function AddPartLO(PartSlot slot,int outfitNameIndex,bool isAccessory,string id, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm)
{
    AddPart(slot,outfitNames[outfitNameIndex],isAccessory,id,t0,t1,t2,t3,t4,t5,t6,t7,tm);
}

function AddPart(PartSlot slot,string name,bool isAccessory,string id, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm)
{
    local OutfitPart P;
    
    P = CreateNewOutfitPart(slot,name,isAccessory,id,t0,t1,t2,t3,t4,t5,t6,t7,tm);

    currentPartsGroup.AddPart(P);
}

function GroupAddParts(PartSlot bodySlot)
{
    local int i;
    for (i = 0;i < numParts;i++)
    {
        if (PartsList[i].bodySlot == bodySlot)
            currentPartsGroup.AddPart(PartsList[i]);
    }
}

function GroupTranspose(PartSlot bodySlot,optional int slot0,optional int slot1,optional int slot2,optional int slot3,optional int slot4,optional int slot5,optional int slot6,optional int slot7,optional int slot8)
{
    local int i;
    for (i = 0;i < numParts;i++)
    {
        if (PartsList[i].bodySlot == bodySlot)
        {
            currentPartsGroup.AddTransposePart(PartsList[i],slot0,slot1,slot2,slot3,slot4,slot5,slot6,slot7,slot8);
        }
    }
}

function OutfitAddPartReference(string partID)
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
    
    SetupCustomOutfit();
    PopulateOutfitsList();
    SetupOutfitSpawners();
}

function SetupCustomOutfit()
{
    if (customOutfit == None)
    {
        customOutfit = new(Self) class'Outfit';
        customOutfit.id = "custom";
        customOutfit.name = "Custom";
        customOutfit.index = 0;
        customOutfit.hidden = true;
    }
    outfits[0] = customOutfit;
    numOutfits++;
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

    //========================================================
    //  Populate Global Parts List
    //========================================================

    ////Add Global Parts

    //Glasses
    //GlobalAddPart(PS_Glasses,NothingName,true,"nothing","none","none");
    GlobalAddPartL(PS_Glasses,0,true,"default_g","FramesTex4","LensesTex5");
    GlobalAddPartL(PS_Glasses,4,true,"sci_g","FramesTex1","LensesTex1");
    GlobalAddPartL(PS_Glasses,1,true,"100%_g","Outfit1_Tex1","Outfit1_Tex1");
    GlobalAddPartL(PS_Glasses,6,true,"business_g","FramesTex1","LensesTex2");
    GlobalAddPartL(PS_Glasses,8,true,"sunglasses_g","FramesTex2","LensesTex3");

    //Skin Textures
    GlobalAddPartL(PS_Body,2,false,"default_b","default");
    GlobalAddPartLO(PS_Body,2,false,"100%_b","Outfit1_Tex1");

    //Pants
    GlobalAddPartL(PS_Legs,3,false,"default_p","JCDentonTex3");
    GlobalAddPartLO(PS_Legs,4,false,"lab_p","PantsTex1");
    GlobalAddPartLO(PS_Legs,2,false,"100%_p","Outfit1_Tex1");
    GlobalAddPartLO(PS_Legs,5,false,"paul_p","PantsTex8");
    GlobalAddPartLO(PS_Legs,6,false,"businessman1_p","Businessman1Tex2");
    GlobalAddPartLO(PS_Legs,3,false,"ajacobson_p","AlexJacobsonTex2");
    GlobalAddPartL(PS_Legs,7,false,"mib_p","PantsTex5");
    GlobalAddPartLO(PS_Legs,8,false,"unatco_p","UnatcoTroopTex1");
    GlobalAddPartLO(PS_Legs,11,false,"chef_p","PantsTex10");
    GlobalAddPartLO(PS_Legs,9,false,"mechanic_p","MechanicTex2");
    GlobalAddPartLO(PS_Legs,17,false,"soldier_p","SoldierTex2");
    GlobalAddPartLO(PS_Legs,17,false,"riotcop_p","RiotCopTex1");
    GlobalAddPartLO(PS_Legs,20,false,"nsf_p","TerroristTex2");

    //Shirts etc
    GlobalAddPartLO(PS_Torso,3,false,"ajacobson_s","AlexJacobsonTex1");
    GlobalAddPartLO(PS_Torso,8,false,"unatco_s","UNATCOTroopTex2");
    GlobalAddPartLO(PS_Torso,9,false,"mechanic_s","MechanicTex1");
    GlobalAddPartLO(PS_Torso,17,false,"soldier_s","SoldierTex1");
    GlobalAddPartLO(PS_Torso,18,false,"riotcop_s","RiotCopTex2");
    GlobalAddPartLO(PS_Torso,20,false,"nsf_s","TerroristTex1");

    //Hat
    //EDIT: These should probably be exclusive to GM_Suit
    GlobalAddPartL(PS_Hat,11,true,"chef_h","ChefTex3");
    
    //========================================================
    //  GM_Trench
    //========================================================

    BeginNewPartsGroup("GM_Trench", true, false);
    GroupAddParts(PS_Body);
    //GroupTranspose(PS_Trench,1,5);
    //GroupTranspose(PS_Torso,4);
    GroupTranspose(PS_Legs,2);
    GroupTranspose(PS_Glasses,6,7);
    
    //Add Trenchcoat-only Torsos because they can't be used on other outfits, and other torsos can't be used here
    AddPartL(PS_Torso,3,false,"default_s",,,,,"JCDentonTex1");
    AddPartLO(PS_Torso,4,false,"lab_s",,,,,"TrenchShirtTex3");
    AddPartLO(PS_Torso,2,false,"100%_s",,,,,"Outfit1_Tex1");
    AddPartLO(PS_Torso,5,false,"paul_s",,,,,"PaulDentonTex1");
    
    //Trenchcoats
    AddPartL(PS_Trench,3,false,"default_t",,"JCDentonTex2",,,,"JCDentonTex2");
    AddPartLO(PS_Trench,4,false,"lab_t",,"LabCoatTex1",,,,"LabCoatTex1");
    AddPartLO(PS_Trench,2,false,"100%_t",,"Outfit1_Tex1",,,,"Outfit1_Tex1");
    AddPartLO(PS_Trench,5,false,"paul_t",,"PaulDentonTex2",,,,"PaulDentonTex2");

    //Default M
    BeginNewOutfitL("default",0,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("default_t");
    OutfitAddPartReference("default_p");
    OutfitAddPartReference("default_s");
    OutfitAddPartReference("default_g");

    //100% Black Outfit M
    BeginNewOutfitL("100%black",2,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("100%_p");
    OutfitAddPartReference("100%_s");
    OutfitAddPartReference("100%_g");
    OutfitAddPartReference("100%_t");

    //100% Black (alt) M
    BeginNewOutfitL("100%black2",34,"");
    OutfitAddPartReference("100%_b");
    OutfitAddPartReference("default_p");
    OutfitAddPartReference("default_s");
    OutfitAddPartReference("default_g");
    OutfitAddPartReference("default_t");

    //Labcoat M
    BeginNewOutfitL("labcoat",4,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("sci_g");
    OutfitAddPartReference("lab_p");
    OutfitAddPartReference("lab_t");
    OutfitAddPartReference("lab_s");
    
    //Paul Outfit
    BeginNewOutfitL("paul",5,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("default_g");
    OutfitAddPartReference("paul_p");
    OutfitAddPartReference("paul_t");
    OutfitAddPartReference("paul_s");


/*
    //========================================================
    //  GFM_Trench
    //========================================================

    BeginNewPartsGroup("GFM_Trench", false, true);
    
    //Legs
    AddPartL(PS_Legs,3,false,"default_p",,,"default");
    AddPartLO(PS_Legs,4,false,"lab_p",,,"ScientistFemaleTex3");

    //Shirts
    AddPartL(PS_Torso,3,false,"default_s",,,,,"default");
    AddPartL(PS_Torso,5,false,"default_s2",,,,,"Outfit1F_Tex1");
    AddPartLO(PS_Torso,2,false,"100%_s",,,,,"Outfit1_Tex1");
    AddPartLO(PS_Torso,4,false,"lab_s",,,,,"TrenchShirtTex3");

    //Trenchcoats
    AddPartL(PS_Trench,3,false,"default_t",,"default",,,,"default");
    AddPartLO(PS_Trench,4,false,"lab_t",,"ScientistFemaleTex2",,,,"ScientistFemaleTex2");
    AddPartLO(PS_Trench,2,false,"100%_t",,"Outfit1_Tex1",,,,"Outfit1_Tex1");

    //Default
    BeginNewOutfitL("default",0,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("default_t");
    OutfitAddPartReference("default_p");
    OutfitAddPartReference("default_s");
    OutfitAddPartReference("default_g");
    
    //Alternate Fem Jewellery
    BeginNewOutfitL("default",1,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("default_t");
    OutfitAddPartReference("default_p");
    OutfitAddPartReference("default_s2");
    OutfitAddPartReference("default_g");

    //100% Black Outfit
    BeginNewOutfitL("100%black",2,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("100%_p");
    OutfitAddPartReference("100%_s");
    OutfitAddPartReference("100%_g");
    OutfitAddPartReference("100%_t");

    //100% Black (alt)
    BeginNewOutfitL("100%black2",34,"");
    OutfitAddPartReference("100%_b");
    OutfitAddPartReference("default_p");
    OutfitAddPartReference("default_s");
    OutfitAddPartReference("default_g");
    OutfitAddPartReference("default_t");

    //Lab Coat
    BeginNewOutfitL("labcoat",4,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("sci_g");
    OutfitAddPartReference("lab_p");
    OutfitAddPartReference("lab_t");
    OutfitAddPartReference("lab_s");
*/

    //========================================================
    //  GM_ScubaSuit
    //========================================================

    BeginNewPartsGroup("GM_ScubaSuit", true, true);
    
    //Main Textures
    AddPartLO(PS_Main,33,false,"scuba","none","ScubasuitTex0","ScubasuitTex1","none","none","none","none","none","ScubasuitTex1");

    BeginNewOutfitL("diver",33,"");
    OutfitAddPartReference("scuba");
    
    //========================================================
    //  GM_DressShirt
    //========================================================

    BeginNewPartsGroup("GM_DressShirt", true, false);
    GroupAddParts(PS_Body);
    GroupTranspose(PS_Torso,5);
    GroupTranspose(PS_Legs,3);
    GroupTranspose(PS_Glasses,6,7);
    
    
    BeginNewOutfitL("ajacobson",3,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("ajacobson_s");
    OutfitAddPartReference("ajacobson_p");
    OutfitAddPartReference("sci_g");
    
    //========================================================
    //  GM_Suit
    //========================================================

    BeginNewPartsGroup("GM_Suit", true, false);
    GroupAddParts(PS_Body);
    GroupTranspose(PS_Legs,1);
    GroupTranspose(PS_Glasses,5,6);
    GroupTranspose(PS_Hat,7);

    //Add Suit-only Torsos because they can't be used on other outfits, and other torsos can't be used here
    AddPartLO(PS_Torso,3,false,"businessman1_s",,,,"BusinessMan1Tex1","BusinessMan1Tex1");
    AddPartLO(PS_Torso,7,false,"mib_s",,,,"MIBTex1","MIBTex1");
    AddPartLO(PS_Torso,30,false,"president_s",,,,"PhilipMeadTex1","PhilipMeadTex1");
    AddPartLO(PS_Torso,11,false,"chef_s",,,,"ChefTex1","ChefTex1");

    //Brown Suit
    BeginNewOutfitL("businessman1",6,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("businessman1_p");
    OutfitAddPartReference("businessman1_s");
    
    //MIB Suit
    BeginNewOutfitL("mib",7,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("sunglasses_g");
    OutfitAddPartReference("mib_p");
    OutfitAddPartReference("mib_s");
    
    //Presidents Suit (Philip Mead Suit)
    BeginNewOutfitL("meadphilip",30,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("sunglasses_g");
    OutfitAddPartReference("mib_p");
    OutfitAddPartReference("president_s");
    
    //Chef Outfit
    BeginNewOutfitL("chef",11,"");
    OutfitAddPartReference("default_b");
    //OutfitAddPartReference("business_g");
    OutfitAddPartReference("chef_p");
    OutfitAddPartReference("chef_s");
    OutfitAddPartReference("chef_h");
    
    //========================================================
    //  GM_Jumpsuit
    //========================================================

    BeginNewPartsGroup("GM_Jumpsuit", true, false);
    GroupTranspose(PS_Body,3);
    GroupTranspose(PS_Legs,1);
    GroupTranspose(PS_Torso,2);
    GroupTranspose(PS_Mask,3,4,5);
    //GroupTranspose(PS_Hat,6);

    //Jumpsuit specific helmets
    AddPartL(PS_Hat,10,true,"unatco_h",,,,,,,"UNATCOTroopTex3");
    //AddPartL(PS_Hat,12,true,"soldier_h",,,,"SoldierTex0",,,"SoldierTex3");
    AddPartL(PS_Hat,12,true,"soldier_h",,,,,,,"SoldierTex3");
    AddPartL(PS_Hat,13,true,"mechanic_h",,,,,,,"MechanicTex3");
    AddPartL(PS_Hat,18,true,"riotcop_h",,,,,,,"RiotCopTex3",,"VisorTex1");
    AddPartL(PS_Hat,16,true,"nsf_h",,,,,,,"GogglesTex1");
    
    //Masks
    //Can only realistically be used on this model
    //TODO: Either make these not count as accessories (set arg 3 to false), or
    //add in a system whereby we always assign a default texture
    AddPartL(PS_Body,9,false,"unatco_b",,,,"MiscTex1JC","MiscTex1JC","GrayMaskTex");
    AddPartL(PS_Body,14,false,"strap_b",,,,"SoldierTex0");
    AddPartL(PS_Body,15,false,"nsf_b",,,,"TerroristTex0","TerroristTex0","GrayMaskTex");
    
    //Unatco Troop
    BeginNewOutfitL("unatcotroop",8,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("unatco_b");
    OutfitAddPartReference("unatco_p");
    OutfitAddPartReference("unatco_s");
    OutfitAddPartReference("unatco_h");
    
    //Mechanic
    BeginNewOutfitL("mechanic",9,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("mechanic_p");
    OutfitAddPartReference("mechanic_s");
    OutfitAddPartReference("mechanic_h");
    
    //Soldier
    //Note: Helmet has a custom strap
    BeginNewOutfitL("soldier",17,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("strap_b");
    OutfitAddPartReference("soldier_p");
    OutfitAddPartReference("soldier_s");
    OutfitAddPartReference("soldier_h");

    //Riot Cop
    BeginNewOutfitL("riotcop",18,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("riotcop_p");
    OutfitAddPartReference("riotcop_s");
    OutfitAddPartReference("riotcop_h");

    //NSF Troop
    BeginNewOutfitL("nsf",20,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("nsf_b");
    OutfitAddPartReference("nsf_p");
    OutfitAddPartReference("nsf_s");
    OutfitAddPartReference("nsf_h");
    
    //NSF Alt, more equipment/clothing
    BeginNewOutfitL("nsf",43,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("nsf_p");
    OutfitAddPartReference("nsf_s");

    //END
    CompleteSetup();

    ////Default Outfits
    
    /*
    
    ////Male Outfits
    
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
    G.player = player;

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

    n = outfitNames[nameIndex];
    d = outfitDescs[nameIndex];

    //BeginNewOutfit(id,n,d,preview,male,female);
    BeginNewOutfit2(id,n,d,preview);
}

function BeginNewOutfit2(string id, string name, string desc, string preview)
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

function PartsGroup GetPartsGroupByID(string id)
{
    local int i;
    local Mesh M;

    M = findMesh(id);

    for (i = 0;i < numPartsGroups;i++)
    {
        if (Groups[i].Mesh == M)
            return Groups[i];
    }
    return None;
}

function EquipOutfit(int index)
{
    currOutfit = outfits[index];
    savedOutfitIndex = index;
    ApplyCurrentOutfit();
}

function EquipCustomOutfit()
{
    local int i;
    if (savedOutfitIndex == 0)
        return;
    
    currOutfit.CopyPartsListTo(customOutfit);
    customOutfit.name = currOutfit.name @ CustomOutfitName;
    currOutfit = customOutfit;
    currOutfit.hidden = false;

    //Save the custom outfit parts
    for (i = 0;i < customOutfit.numParts;i++)
        customPartIDs[i] = customOutfit.Parts[i].partId;
    
    savedOutfitIndex = 0;
    ApplyCurrentOutfit();
}

function Outfit GetOutfit(int index)
{
    
    if (index >= numOutfits)
        return None;

    return outfits[index];
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
    if (index >= numOutfits)
        return false;
    
    return outfits[index].unlocked && IsCorrectGender(index);
    return true;
}

function bool IsCorrectGender(int index)
{
    return (outfits[index].partsGroup.allowMale && !IsFemale()) || (outfits[index].partsGroup.allowFemale && IsFemale());
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
    if (index >= numOutfits)
        return false;
    return outfits[index].unlocked;
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

        //Unlock any outfits matching this ID
        for (i = 2;i<numOutfits;i++)
        {
            if (outfits[i].id == id)
                outfits[i].SetUnlocked();
        }
    }
}

function CompleteSetup()
{
    local int i;

    //Set unlocked on all outfits
    outfits[0].SetUnlocked();
    outfits[1].SetUnlocked();
    for (i = 2;i<numOutfits;i++)
    {
        if (IsUnlocked(outfits[i].id))
            outfits[i].SetUnlocked();
    }

    //recreate custom outfit from the saved list of ids
    customOutfit.hidden = customPartsNum == 0;
    customOutfit.partsGroup = GetPartsGroupByID(customPartsGroupID);

    for (i = 0;i < customPartsNum;i++)
        customOutfit.AddPartFromID(customPartIDs[i]);
    
    //set current outfit to the outfit that was previously saved
    currOutfit = outfits[savedOutfitIndex];

    //Apply our current outfit
    ApplyCurrentOutfit();
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
    NothingName="Nothing"
    partNames(0)="Cool Sunglasses"
    partNames(1)="Black Bars"
    partNames(2)="Default Skin"
    partNames(3)="Default"
    partNames(4)="Scientist Glasses"
    partNames(5)="Default w/ Jewellery"
    partNames(6)="Business Glasses"
    partNames(7)="Black Suit Pants"
    partNames(8)="Cool Shades"
    partNames(9)="UNATCO Combat Mask"
    partNames(10)="UNATCO Combat Helmet"
    partNames(11)="Chef's Hat"
    partNames(12)="Soldier's Helmet"
    partNames(13)="Mechanic's Hard Hat"
    partNames(14)="Helmet Strap"
    partNames(15)="Tacticool Gear"
    partNames(16)="Tacticool Goggles"
    savedOutfitIndex=1
    CustomOutfitName="(Custom)"
    outfitNames(0)="JC Denton's Trenchcoat"
    outfitDescs(0)="An old classic. This blue trenchcoat fits well over anything, and gives JC a cool, augmented look"
    outfitNames(1)="JC Denton's Trenchcoat (Alt)"
    outfitDescs(1)="JC Denton's Signature Trenchcoat, now with extra jewellery!"
    outfitNames(2)="100% Black"
    outfitDescs(2)="The outfit of choice for malkavians"
    outfitNames(3)="Alex Jacobson's Outfit"
    outfitDescs(3)="Used by hackers everywhere!"
    outfitNames(4)="Lab Coat"
    outfitDescs(4)="Discovery Awaits!"
    outfitNames(5)="Paul Denton's Outfit"
    outfitDescs(5)="Seeing Double!"
    outfitNames(6)="Fancy Suit"
    outfitDescs(6)="For very special agents!"
    outfitNames(7)="MIB Black Suit"
    outfitDescs(7)="For very special agents!"
    outfitNames(8)="UNATCO Combat Uniform"
    outfitDescs(8)=""
    outfitNames(9)="Mechanic Jumpsuit"
    outfitDescs(9)=""
    outfitNames(11)="Chef Outfit"
    outfitDescs(11)="Something about cooking, IDK"
    outfitNames(13)="Gold and Brown Business"
    outfitDescs(13)=""
    outfitNames(14)="Goth GF Outfit"
    outfitDescs(14)=""
    outfitNames(15)="Matrix Outfit"
    outfitDescs(15)="This outfit is considered one of the classic three. From the immortal Trinity, if you will..."
    outfitNames(16)="Goth GF Outfit"
    outfitDescs(16)=""
    outfitNames(17)="Soldier Outfit"
    outfitDescs(17)=""
    outfitNames(18)="Riot Gear"
    outfitDescs(18)=""
    outfitNames(19)="WIB Suit"
    outfitDescs(19)="Dressed to Kill"
    outfitNames(20)="NSF Sympathiser"
    outfitDescs(20)="For the people!"
    outfitNames(21)="Stained Clothes"
    outfitDescs(21)="Look for a bum."
    outfitNames(22)="Juan Lebedev's Outfit"
    outfitDescs(22)="So fine it'll make you want to kill your boss"
    outfitNames(23)="Smuggler's Outfit"
    outfitDescs(23)="This expensive outfit matches Smuggler's Prices"
    outfitNames(24)="FEMA Executive's Outfit"
    outfitDescs(24)="Just because you work behind a desk doesn't mean you can't be fashionable"
    outfitNames(25)="MJ12 Soldier Outfit"
    outfitDescs(25)="The sort of outfit you can take over the world in"
    outfitNames(26)="Jock's Outfit"
    outfitDescs(26)=""
    outfitNames(27)="Maggie's Outfit"
    outfitDescs(27)=""
    outfitNames(28)="Nicolette's Outfit"
    outfitDescs(28)=""
    outfitNames(29)="JC Clone Outfit"
    outfitDescs(29)=""
    outfitNames(30)="Presidential Suit"
    outfitDescs(30)=""
    outfitNames(31)="Sailor Outfit"
    outfitDescs(31)=""
    outfitNames(32)="Carter's Outfit"
    outfitDescs(32)=""
    outfitNames(33)="Scuba Suit"
    outfitDescs(33)=""
    outfitNames(34)="100% Black (Alt)"
    outfitDescs(34)="OMG! It's just like the memes!"
    outfitNames(35)="Prison Uniform"
    outfitDescs(35)=""
    outfitNames(36)="100% Black (Ultimate Edition)"
    outfitDescs(36)=""
    outfitNames(37)="Thug Outfit"
    outfitDescs(37)=""
    outfitNames(38)="Anna Navarre's Outfit"
    outfitDescs(38)=""
    outfitNames(39)="Tiffany Savage's Outfit"
    outfitDescs(39)=""
    outfitNames(40)="Sarah Mead's Outfit"
    outfitDescs(40)=""
    outfitNames(41)="Jordan Shea's Outfit"
    outfitDescs(41)=""
    outfitNames(42)="Hooker Outfit"
    outfitDescs(42)=""
    outfitNames(43)="NSF Sympathiser (Alt)"
    outfitDescs(43)=""
}
