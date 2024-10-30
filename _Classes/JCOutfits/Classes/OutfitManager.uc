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
var travel OutfitCustom customOutfit;

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
    GroupTranspose2(bodySlot,bodySlot,slot0,slot1,slot2,slot3,slot4,slot5,slot6,slot7,slot8);
}

function GroupTranspose2(PartSlot bodySlot, PartSlot bodySlot2,optional int slot0,optional int slot1,optional int slot2,optional int slot3,optional int slot4,optional int slot5,optional int slot6,optional int slot7,optional int slot8)
{
    local int i;
    for (i = 0;i < numParts;i++)
    {
        if (PartsList[i].bodySlot == bodySlot)
        {
            currentPartsGroup.AddTransposePart(PartsList[i],bodySlot2,slot0,slot1,slot2,slot3,slot4,slot5,slot6,slot7,slot8);
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
        savedOutfitIndex = -1;
    }

    if (numOutfits != 0)
        return;
    
    PopulateOutfitsList();
}

function SetupCustomOutfit()
{
    local int i;
    if (customOutfit == None)
    {
        customOutfit = new(Self) class'OutfitCustom';
        customOutfit.hidden = true;
        customOutfit.name = "Custom";
    }

    customOutfit.player = player;
    customOutfit.PopulateFromSaved(GetPartsGroupByID(customOutfit.partsGroupID));
    customOutfit.id = "custom";
    customOutfit.index = 0;
    customOutfit.unlocked = true;
    outfits[0] = customOutfit;
    numOutfits++;
}

function SetupOutfitSpawners()
{
    local OutfitSpawner S;
    local Texture T;
    local Actor a;
    local int i;

	foreach player.AllActors(class'OutfitSpawner', S)
    {
        //player.ClientMessage("Found an outfit spawner");
        if (ValidateSpawn(S.id))
        {
            S.outfitManager = self;

            //Set Frob Label
            S.ItemName = sprintf(S.PickupName,GetOutfitNameByID(S.id));

            //Set up texture
            T = findTexture(S.LookupTexture);
            //player.ClientMessage("Setting Skin and Texture to " $ T $ " ("$S.LookupTexture$")");
            if (T != None)
            {
                S.Skin = T;
                S.Texture = T;
            }

            //Set Collision
            S.SetCollision( true, true, false );
        }
        else
        {
            //player.ClientMessage("OutfitManager failed to validate " $ S.id);

            //Destroy objects linked to spawner
            foreach player.AllActors(class'Actor', a)
            {
                for(i = 0;i < 5;i++)
                {
                    if (S.LinkedObjects[i] != "" && S.LinkedObjects[i] == string(a.Name))
                        a.Destroy();
                }
            }


            //Destroy Spawner
            S.Destroy();
        }
    }
}

function SpawnerPickup(OutfitSpawner S)
{
    player.ClientMessage(sprintf(S.PickupMessage,GetOutfitNameByID(S.id)), 'Pickup');
    Unlock(S.id);
    S.Destroy();
}

function PopulateOutfitsList()
{
    //player.clientmessage("Repopulating outfit list");

    //Custom is going to take up slot 0
    numOutfits = 1;

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
    GlobalAddPartL(PS_Body_M,2,false,"default_b","default");
    GlobalAddPartLO(PS_Body_M,2,false,"100%_b","Outfit1_Tex1");
    GlobalAddPartL(PS_Body_M,19,false,"beanie_b","ThugSkin");

    GlobalAddPartL(PS_Body_F,2,false,"default_b","default");
    //GlobalAddPartLO(PS_Body_F,2,false,"100%_b","Outfit1_Tex1",,,"Outfit1_Tex1");
    GlobalAddPartLO(PS_Body_F,2,false,"100%_b","Outfit1_Tex1");

    //Pants
    GlobalAddPartL(PS_Legs,3,false,"default_p","JCDentonTex3");
    GlobalAddPartL(PS_Legs,22,false,"lab_p","PantsTex1");
    GlobalAddPartL(PS_Legs,21,false,"gilbertrenton_p","PantsTex3"); //Also used by Ford Schick
    GlobalAddPartLO(PS_Legs,2,false,"100%_p","Outfit1_Tex1");
    GlobalAddPartLO(PS_Legs,5,false,"paul_p","PantsTex8");
    GlobalAddPartLO(PS_Legs,6,false,"businessman1_p","Businessman1Tex2");
    GlobalAddPartLO(PS_Legs,46,false,"businessman2_p","Businessman2Tex2");
    GlobalAddPartLO(PS_Legs,3,false,"ajacobson_p","AlexJacobsonTex2");
    GlobalAddPartL(PS_Legs,7,false,"mib_p","PantsTex5");
    GlobalAddPartLO(PS_Legs,8,false,"unatco_p","UnatcoTroopTex1");
    GlobalAddPartLO(PS_Legs,11,false,"chef_p","PantsTex10");
    GlobalAddPartLO(PS_Legs,9,false,"mechanic_p","MechanicTex2");
    GlobalAddPartLO(PS_Legs,17,false,"soldier_p","SoldierTex2");
    GlobalAddPartLO(PS_Legs,18,false,"riotcop_p","RiotCopTex1");
    GlobalAddPartLO(PS_Legs,20,false,"nsf_p","TerroristTex2");
    GlobalAddPartLO(PS_Legs,25,false,"mj12_p","MJ12TroopTex1");
    GlobalAddPartLO(PS_Legs,32,false,"carter_p","SamCarterTex2");
    GlobalAddPartLO(PS_Legs,31,false,"sailor_p","SailorTex2");
    GlobalAddPartLO(PS_Legs,21,false,"bum_p","PantsTex4");
    //GlobalAddPartLO(PS_Legs,22,false,"lebedev_p","JuanLebedevTex3");
    GlobalAddPartLO(PS_Legs,37,false,"thug_p","ThugMale2Tex2");
    GlobalAddPartLO(PS_Legs,55,false,"thug2_p","ThugMaleTex3");
    GlobalAddPartL(PS_Legs,7,false,"mib_p","PantsTex5");
    GlobalAddPartL(PS_Legs,20,false,"brown_p","PantsTex7");
    GlobalAddPartL(PS_Legs,20,false,"secretservice_p","SecretServiceTex2");
    GlobalAddPartL(PS_Legs,23,false,"junkie_p","JunkieMaleTex2");
    //Female
    GlobalAddPartL(PS_Legs,3,false,"default_p","JCDentonTex3");
    GlobalAddPartLO(PS_Legs,4,false,"lab_p","ScientistFemaleTex3");
    GlobalAddPartLO(PS_Legs,2,false,"100%_p","Outfit1_Tex1");
    GlobalAddPartLO(PS_Legs,13,false,"goldbrown_p","Outfit2F_Tex3");
    GlobalAddPartLO(PS_Legs,15,false,"matrix_p","Outfit4F_Tex3");
    GlobalAddPartLO(PS_Legs,16,false,"goth_p","Outfit3F_Tex3");
    GlobalAddPartLO(PS_Legs,28,false,"nicolette_p","NicoletteDuClareTex3");
    GlobalAddPartLO(PS_Legs,38,false,"anna_p","PantsTex9");
    GlobalAddPartLO(PS_Legs,39,false,"tiffany_p","TiffanySavageTex2");
    GlobalAddPartLO(PS_Legs,40,false,"sarah_p","SarahMeadTex3");
    GlobalAddPartL(PS_Legs,24,false,"junkie_p2","JunkieFemaleTex2");
    
    //Dress Pants
    GlobalAddPartLO(PS_DressLegs,49,false,"nurse_p","LegsTex1");
    GlobalAddPartLO(PS_DressLegs,19,false,"stockings_p","LegsTex2");
    GlobalAddPartLO(PS_DressLegs,42,false,"hooker_p","Hooker1Tex1");
    GlobalAddPartLO(PS_DressLegs,51,false,"hooker2_p","Hooker2Tex1");

    //Skirts
    GlobalAddPartLO(PS_Skirt,28,false,"nicolette_sk","NicoletteDuClareTex2","NicoletteDuClareTex2");
    GlobalAddPartLO(PS_Skirt,40,false,"sarah_sk","SarahMeadTex2","SarahMeadTex2");
    GlobalAddPartLO(PS_Skirt,42,false,"hooker_sk","Hooker1Tex2","Hooker1Tex2");
    GlobalAddPartLO(PS_Skirt,51,false,"hooker2_sk","Hooker2Tex2","Hooker2Tex2");

    //Shirts etc
    GlobalAddPartLO(PS_Torso_M,3,false,"ajacobson_s","AlexJacobsonTex1");
    GlobalAddPartLO(PS_Torso_M,8,false,"unatco_s","UNATCOTroopTex2");
    GlobalAddPartLO(PS_Torso_M,9,false,"mechanic_s","MechanicTex1");
    GlobalAddPartLO(PS_Torso_M,17,false,"soldier_s","SoldierTex1");
    GlobalAddPartLO(PS_Torso_M,18,false,"riotcop_s","RiotCopTex2");
    GlobalAddPartLO(PS_Torso_M,20,false,"nsf_s","TerroristTex1");
    GlobalAddPartLO(PS_Torso_M,25,false,"mj12_s","MJ12TroopTex2");
    GlobalAddPartLO(PS_Torso_M,32,false,"carter_s","SamCarterTex1");
    GlobalAddPartLO(PS_Torso_M,37,false,"thug_s","ThugMale2Tex1");
    GlobalAddPartLO(PS_Torso_M,53,false,"joegreene_s","JoeGreeneTex1");
    GlobalAddPartLO(PS_Torso_M,54,false,"junkie_s","JunkieMaleTex1");

    //Female
    GlobalAddPartLO(PS_Torso_F,28,false,"nicolette_s","NicoletteDuClareTex1");
    GlobalAddPartLO(PS_Torso_F,38,false,"anna_s","AnnaNavarreTex1");
    GlobalAddPartLO(PS_Torso_F,39,false,"tiffany_s","TiffanySavageTex1");
    GlobalAddPartLO(PS_Torso_F,40,false,"sarah_s","SarahMeadTex1");
    GlobalAddPartLO(PS_Torso_F,40,false,"shea_s","JordanSheaTex1");
    GlobalAddPartLO(PS_Torso_F,42,false,"hooker_s","Hooker1Tex3");
    GlobalAddPartLO(PS_Torso_F,51,false,"hooker2_s","Hooker2Tex3");
    GlobalAddPartLO(PS_Torso_F,54,false,"junkie_s","JunkieFemaleTex1");


    
    //========================================================
    //  GM_Trench
    //========================================================

    BeginNewPartsGroup("GM_Trench", true, false);
    GroupAddParts(PS_Body_M);
    //GroupTranspose(PS_Trench,1,5);
    //GroupTranspose(PS_Torso_M,4);
    GroupTranspose(PS_Legs,2);
    GroupTranspose(PS_Glasses,6,7);
    
    //Add Trenchcoat-only Torsos because they can't be used on other outfits, and other torsos can't be used here
    AddPartL(PS_Torso_M,3,false,"default_s",,,,,"JCDentonTex1");
    AddPartLO(PS_Torso_M,4,false,"lab_s",,,,,"TrenchShirtTex3");
    AddPartLO(PS_Torso_M,2,false,"100%_s",,,,,"Outfit1_Tex1");
    AddPartLO(PS_Torso_M,5,false,"paul_s",,,,,"PaulDentonTex1");
    AddPartLO(PS_Torso_M,21,false,"bum_s",,,,,"TrenchShirtTex1");
    AddPartLO(PS_Torso_M,44,false,"bum2_s",,,,,"TrenchShirtTex2");
    AddPartLO(PS_Torso_M,22,false,"lebedev_s",,,,,"JuanLebedevTex1");
    AddPartLO(PS_Torso_M,23,false,"smuggler_s",,,,,"SmugglerTex1");
    AddPartLO(PS_Torso_M,24,false,"simons_s",,,,,"WaltonSimonsTex1");
    AddPartLO(PS_Torso_M,48,false,"doctor_s",,,,,"DoctorTex1");
    AddPartLO(PS_Torso_M,50,false,"gilbertrenton_s",,,,,"GilbertRentonTex1");
    AddPartLO(PS_Torso_M,52,false,"ford_s",,,,,"FordSchickTex1");
    AddPartLO(PS_Torso_M,55,false,"thug2_s",,,,,"ThugMaleTex1");
    
    //Trenchcoats
    AddPartL(PS_Trench,3,false,"default_t",,"JCDentonTex2",,,,"JCDentonTex2");
    AddPartLO(PS_Trench,4,false,"lab_t",,"LabCoatTex1",,,,"LabCoatTex1");
    AddPartLO(PS_Trench,2,false,"100%_t",,"Outfit1_Tex1",,,,"Outfit1_Tex1");
    AddPartLO(PS_Trench,5,false,"paul_t",,"PaulDentonTex2",,,,"PaulDentonTex2");
    AddPartLO(PS_Trench,21,false,"bum_t",,"BumMaleTex2",,,,"BumMaleTex2");
    AddPartLO(PS_Trench,44,false,"bum2_t",,"BumMale2Tex2",,,,"BumMale2Tex2");
    AddPartLO(PS_Trench,22,false,"lebedev_t",,"JuanLebedevTex2",,,,"JuanLebedevTex2");
    AddPartLO(PS_Trench,23,false,"smuggler_t",,"SmugglerTex2",,,,"SmugglerTex2");
    AddPartLO(PS_Trench,24,false,"simons_t",,"WaltonSimonsTex2",,,,"WaltonSimonsTex2");
    AddPartLO(PS_Trench,45,false,"harleyfilben_t",,"HarleyFilbenTex2",,,,"HarleyFilbenTex2");
    AddPartLO(PS_Trench,50,false,"gilbertrenton_t",,"GilbertRentonTex2",,,,"GilbertRentonTex2");
    AddPartLO(PS_Trench,52,false,"ford_t",,"FordSchickTex2",,,,"FordSchickTex2");
    AddPartLO(PS_Trench,55,false,"thug2_t",,"ThugMaleTex2");

    //Default M
    BeginNewOutfitL("default",0,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("default_t");
    OutfitAddPartReference("default_p");
    OutfitAddPartReference("default_s");
    OutfitAddPartReference("default_g");

    //100% Black Outfit M
    BeginNewOutfitL("100black",2,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("100%_p");
    OutfitAddPartReference("100%_s");
    OutfitAddPartReference("100%_g");
    OutfitAddPartReference("100%_t");

    //100% Black (alt) M
    BeginNewOutfitL("100black",34,"");
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
    
    //Doctor Outfit
    BeginNewOutfitL("doctor",48,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("lab_t");
    OutfitAddPartReference("lab_p");
    OutfitAddPartReference("doctor_s");
    
    //Paul Outfit
    BeginNewOutfitL("paul",5,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("default_g");
    OutfitAddPartReference("paul_p");
    OutfitAddPartReference("paul_t");
    OutfitAddPartReference("paul_s");
    
    //Gilbert Renton Outfit
    BeginNewOutfitL("gilbertrenton",50,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("gilbertrenton_p");
    OutfitAddPartReference("gilbertrenton_t");
    OutfitAddPartReference("gilbertrenton_s");

    //Bum
    BeginNewOutfitL("bum",21,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("bum_p");
    OutfitAddPartReference("bum_t");
    OutfitAddPartReference("bum_s");
    
    //Bum2
    BeginNewOutfitL("bum2",44,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("bum_p");
    OutfitAddPartReference("bum2_t");
    OutfitAddPartReference("bum2_s");

    //Lebedev
    BeginNewOutfitL("lebedev",22,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("sunglasses_g");
    OutfitAddPartReference("nsf_p");
    OutfitAddPartReference("lebedev_t");
    OutfitAddPartReference("lebedev_s");

    //Smugglers Outfit
    BeginNewOutfitL("smug",23,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("mib_p");
    OutfitAddPartReference("smuggler_t");
    OutfitAddPartReference("smuggler_s");
    OutfitAddPartReference("sci_g");

    //Simons Outfit
    BeginNewOutfitL("simons",24,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("mib_p");
    OutfitAddPartReference("sunglasses_g");
    OutfitAddPartReference("simons_s");
    OutfitAddPartReference("simons_t");
    
    //Harley Filben Outfit
    BeginNewOutfitL("harleyfilben",45,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("brown_p");
    OutfitAddPartReference("bum_s");
    OutfitAddPartReference("harleyfilben_t");
    
    //Ford Schick Outfit
    BeginNewOutfitL("ford",52,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("gilbertrenton_p");
    OutfitAddPartReference("ford_s");
    OutfitAddPartReference("ford_t");
    
    //Rook Member Outfit
    BeginNewOutfitL("thug2",55,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("thug2_p");
    OutfitAddPartReference("thug2_s");
    OutfitAddPartReference("thug2_t");

    //========================================================
    //  GFM_Trench
    //========================================================

    BeginNewPartsGroup("GFM_Trench", false, true);
    GroupAddParts(PS_Body_F);
    GroupTranspose(PS_Legs,2);
    GroupTranspose(PS_Glasses,6,7);
    
    //Add Trenchcoat-only Torsos because they can't be used on other outfits, and other torsos can't be used here
    AddPartL(PS_Torso_F,3,false,"default_s",,,,,"default");
    AddPartL(PS_Torso_F,5,false,"default_s2",,,,,"Outfit1F_Tex1");
    AddPartLO(PS_Torso_F,2,false,"100%_s",,,,,"Outfit1_Tex1");
    AddPartLO(PS_Torso_F,4,false,"lab_s",,,,,"TrenchShirtTex3");
    AddPartLO(PS_Torso_F,15,false,"matrix_s",,,,,"Outfit4F_Tex1");
    AddPartLO(PS_Torso_F,16,false,"goth_s",,,,,"Outfit3F_Tex1");

    //Trenchcoats
    AddPartL(PS_Trench,3,false,"default_t",,"default",,,,"default");
    AddPartLO(PS_Trench,4,false,"lab_t",,"ScientistFemaleTex2",,,,"ScientistFemaleTex2");
    AddPartLO(PS_Trench,2,false,"100%_t",,"Outfit1_Tex1",,,,"Outfit1_Tex1");
    AddPartLO(PS_Trench,13,false,"goldbrown_t",,"Outfit2F_Tex2",,,,"Outfit2F_Tex2");
    AddPartLO(PS_Trench,15,false,"matrix_t",,"Outfit4F_Tex2",,,,"Outfit4F_Tex2");
    AddPartLO(PS_Trench,16,false,"goth_t",,"Female4Tex2",,,,"Female4Tex2");

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
    BeginNewOutfitL("100black",2,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("100%_p");
    OutfitAddPartReference("100%_s");
    OutfitAddPartReference("100%_g");
    OutfitAddPartReference("100%_t");

    //100% Black (alt)
    BeginNewOutfitL("100black",34,"");
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
    
    //Gold Brown Outfit
    BeginNewOutfitL("goldbrown",13,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("lab_s");
    OutfitAddPartReference("goldbrown_p");
    OutfitAddPartReference("goldbrown_t");
    OutfitAddPartReference("default_g");
    
    //Matrix Outfit
    BeginNewOutfitL("matrix",15,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("matrix_s");
    OutfitAddPartReference("matrix_p");
    OutfitAddPartReference("matrix_t");
    OutfitAddPartReference("sunglasses_g");
    
    //Goth GF Outfit
    BeginNewOutfitL("goth",16,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("goth_s");
    OutfitAddPartReference("goth_p");
    OutfitAddPartReference("goth_t");
    OutfitAddPartReference("sunglasses_g");

    //========================================================
    //  GFM_SuitSkirt
    //========================================================

    BeginNewPartsGroup("GFM_SuitSkirt", false, true);
    GroupAddParts(PS_Body_F);
    GroupTranspose(PS_Legs,3);
    GroupTranspose2(PS_DressLegs,PS_Legs,3);
    GroupTranspose(PS_Glasses,6,7);
    
    AddPartLO(PS_Torso_F,19,false,"wib_s",,,,,"WIBTex1","WIBTex1");
    AddPartLO(PS_Torso_F,27,false,"maggie_s",,,,,"MaggieChowTex1","MaggieChowTex1");
    AddPartLO(PS_Torso_F,49,false,"nurse_s",,,,,"NurseTex1","NurseTex1");
    
    //WIB Outfit
    BeginNewOutfitL("wib",19,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("stockings_p");
    OutfitAddPartReference("wib_s");
    OutfitAddPartReference("sunglasses_g");
    
    //Maggie Chow's Outfit
    BeginNewOutfitL("maggie",27,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("stockings_p");
    OutfitAddPartReference("maggie_s");
    OutfitAddPartReference("sunglasses_g");

    //Nurse Outfit
    BeginNewOutfitL("nurse",49,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("nurse_p");
    OutfitAddPartReference("nurse_s");


    //========================================================
    //  GFM_Dress
    //========================================================

    BeginNewPartsGroup("GFM_Dress", false, true);
    GroupTranspose(PS_Body_F,7);
    GroupTranspose(PS_Legs,1);
    GroupTranspose2(PS_DressLegs,PS_Legs,1);
    GroupTranspose(PS_Skirt,2,4);
    GroupTranspose(PS_Torso_F,3);
    
    //Torsos
    
    //Nicollette DuClare's outfit
    BeginNewOutfitL("nicolette",28,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("nicolette_p");
    OutfitAddPartReference("nicolette_s");
    OutfitAddPartReference("nicolette_sk");
    
    //Sarah Mead
    BeginNewOutfitL("sarah",40,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("sarah_p");
    OutfitAddPartReference("sarah_s");
    OutfitAddPartReference("sarah_sk");
    
    //Hooker
    BeginNewOutfitL("hooker",42,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("hooker_p");
    OutfitAddPartReference("hooker_s");
    OutfitAddPartReference("hooker_sk");
    
    //Hooker2
    BeginNewOutfitL("hooker2",51,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("hooker2_p");
    OutfitAddPartReference("hooker2_s");
    OutfitAddPartReference("hooker2_sk");

    //========================================================
    //  GFM_TShirtPants
    //========================================================
    
    BeginNewPartsGroup("GFM_TShirtPants", false, true);
    GroupAddParts(PS_Body_F);
    GroupTranspose(PS_Legs,6);
    GroupTranspose(PS_Torso_F,7);
    
    BeginNewOutfitL("anna",38,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("anna_p");
    OutfitAddPartReference("anna_s");
    
    BeginNewOutfitL("tiffany",39,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("tiffany_p");
    OutfitAddPartReference("tiffany_s");
    
    BeginNewOutfitL("shea",41,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("shea_s");
    OutfitAddPartReference("mib_p");
    
    BeginNewOutfitL("junkie",54,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("junkie_s");
    OutfitAddPartReference("junkie_p2");

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
    GroupAddParts(PS_Body_M);
    GroupTranspose(PS_Torso_M,5);
    GroupTranspose(PS_Legs,3);
    GroupTranspose(PS_Glasses,6,7);
    
    //Alex Jacobson Outfit
    BeginNewOutfitL("ajacobson",3,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("ajacobson_s");
    OutfitAddPartReference("ajacobson_p");
    OutfitAddPartReference("sci_g");

    //Thug
    //Beanie Replaces head tex
    BeginNewOutfitL("thug",37,"");
    OutfitAddPartReference("beanie_b");
    OutfitAddPartReference("thug_p");
    OutfitAddPartReference("thug_s");
    
    //Joe Greene Outfit
    BeginNewOutfitL("joegreene",53,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("joegreene_s");
    OutfitAddPartReference("lab_p");
   
    //Junkie
    BeginNewOutfitL("junkie",54,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("junkie_s");
    OutfitAddPartReference("junkie_p");
    
    //========================================================
    //  GM_Suit
    //========================================================

    BeginNewPartsGroup("GM_Suit", true, false);
    GroupAddParts(PS_Body_M);
    GroupTranspose(PS_Legs,1);
    GroupTranspose(PS_Glasses,5,6);

    //Add Suit-only Torsos because they can't be used on other outfits, and other torsos can't be used here
    AddPartLO(PS_Torso_M,6,false,"businessman1_s",,,,"BusinessMan1Tex1","BusinessMan1Tex1");
    AddPartLO(PS_Torso_M,46,false,"businessman2_s",,,,"BusinessMan2Tex1","BusinessMan2Tex1");
    AddPartLO(PS_Torso_M,7,false,"mib_s",,,,"MIBTex1","MIBTex1");
    AddPartLO(PS_Torso_M,30,false,"president_s",,,,"PhilipMeadTex1","PhilipMeadTex1");
    AddPartLO(PS_Torso_M,11,false,"chef_s",,,,"ChefTex1","ChefTex1");
    AddPartLO(PS_Torso_M,31,false,"sailor_s",,,,"SailorTex1","SailorTex1");
    AddPartLO(PS_Torso_M,47,false,"secretservice_s",,,,"SecretServiceTex1","SecretServiceTex1");
    
    //Hat
    //EDIT: These should probably be exclusive to GM_Suit
    AddPartL(PS_Hat,11,true,"chef_h",,,,,,,,"ChefTex3");
    AddPartL(PS_Hat,18,true,"sailor_h","SailorSkin",,,,,,,"SailorTex3");

    //Brown Suit
    BeginNewOutfitL("businessman1",6,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("businessman1_p");
    OutfitAddPartReference("businessman1_s");
    
    //White Business Suit
    BeginNewOutfitL("businessman2",46,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("businessman2_p");
    OutfitAddPartReference("businessman2_s");
    
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
    OutfitAddPartReference("default_g");
    OutfitAddPartReference("chef_p");
    OutfitAddPartReference("chef_s");
    OutfitAddPartReference("chef_h");
    
    //Sailor
    //"Hat" Replaces head tex
    BeginNewOutfitL("sailor",31,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("sailor_p");
    OutfitAddPartReference("sailor_s");
    OutfitAddPartReference("sailor_h");
    
    //Secret Service
    BeginNewOutfitL("secretservice",47,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("sunglasses_g");
    OutfitAddPartReference("secretservice_p");
    OutfitAddPartReference("secretservice_s");
    
    //========================================================
    //  GM_Jumpsuit
    //========================================================

    BeginNewPartsGroup("GM_Jumpsuit", true, false);
    GroupTranspose(PS_Body_M,3);
    GroupTranspose(PS_Legs,1);
    GroupTranspose(PS_Torso_M,2);
    GroupTranspose(PS_Mask,3,4,5);
    //GroupTranspose(PS_Hat,6);

    //Jumpsuit specific helmets
    AddPartL(PS_Hat,10,true,"unatco_h",,,,,,,"UNATCOTroopTex3");
    //AddPartL(PS_Hat,12,true,"soldier_h",,,,"SoldierTex0",,,"SoldierTex3");
    AddPartL(PS_Hat,12,true,"soldier_h",,,,,,,"SoldierTex3");
    AddPartL(PS_Hat,13,true,"mechanic_h",,,,,,,"MechanicTex3");
    AddPartLO(PS_Hat,18,true,"riotcop_h",,,,,,,"RiotCopTex3",,"VisorTex1");
    AddPartL(PS_Hat,16,true,"nsf_h",,,,,,,"GogglesTex1");
    AddPartL(PS_Hat,17,true,"mj12_h",,,,,,"MJ12TroopTex3","MJ12TroopTex4");
    
    //test
    //AddPartLO(PS_Torso_M,31,false,"sailor_s",,,"SailorTex1");
    
    //Masks
    //Can only realistically be used on this model
    //TODO: Either make these not count as accessories (set arg 3 to false), or
    //add in a system whereby we always assign a default texture
    AddPartL(PS_Body_M,9,false,"unatco_b",,,,"MiscTex1JC","MiscTex1JC","GrayMaskTex");
    AddPartL(PS_Body_M,14,false,"strap_b",,,,"SoldierTex0");
    AddPartL(PS_Body_M,15,false,"nsf_b",,,,"TerroristTex0","TerroristTex0","GrayMaskTex");
    
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
    
    //MJ12
    BeginNewOutfitL("mj12",25,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("mj12_p");
    OutfitAddPartReference("mj12_s");
    OutfitAddPartReference("mj12_h");
    
    //Sam Carter Outfit
    BeginNewOutfitL("carter",32,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("carter_s");
    OutfitAddPartReference("carter_p");
    
    //Prisoner Outfit
    //TODO: This is currently just the Mechanic mesh
    BeginNewOutfitL("prisoner",35,"");
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("mechanic_p");
    OutfitAddPartReference("mechanic_s");

    //END
    //CompleteSetup();
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
    customOutfit.UpdatePartsGroup(currOutfit.partsGroup);
    customOutfit.UpdatePartIDsList();
    
    currOutfit = customOutfit;
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
        if (outfits[i].id == id && IsCorrectGender(i))
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

function bool IsCorrectGender(int index)
{
    return outfits[index].partsGroup.IsCorrectGender();
}

function bool IsEquippable(int index)
{
    if (index >= numOutfits)
        return false;
    
    return outfits[index].unlocked && IsCorrectGender(index);
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
                player.ClientMessage("Unlocking " $ id);
                player.unlockedOutfits[i] = id;
                player.SaveConfig();
                break;
            }
        }

        //Unlock any outfits matching this ID
        for (i = 1;i<numOutfits;i++)
        {
            if (outfits[i].id == id)
                outfits[i].SetUnlocked();
        }
    }
}

function CompleteSetup()
{
    local int i;

    //Set unlocked on all outfits which are unlocked
    outfits[0].SetUnlocked();
    Unlock("default");
    for (i = 1;i<numOutfits;i++)
    {
        if (IsUnlocked(outfits[i].id))
            outfits[i].SetUnlocked();
    }
    
    //Setup Custom Outfit
    SetupCustomOutfit();
    
    //Setup Spawners
    SetupOutfitSpawners();

    //If we have no outfit set, equip the default
    //This is hacky
    if (savedOutfitIndex == -1)
    {
        for (i = 1;i<numOutfits;i++)
        {
            if (outfits[i].id == "default" && IsEquippable(i))
            {
                EquipOutfit(i);
                break;
            }
        }
    }

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
    local string CName;
    local string M;

    CName = string(C.Mesh.name);
    ApplyCurrentOutfitToActor(C);
        
    M = defaultMesh;

    if (currOutfit.partsGroup.mesh != None)
        M = string(currOutfit.partsGroup.mesh.name);

    if (CName == ("GM_Trench_Carcass"))
       C.Mesh = findMesh(M $ "_Carcass");
    else if (CName == ("GM_Trench_CarcassB"))
        C.Mesh = findMesh(M $ "_CarcassB");
    else if (CName == ("GM_Trench_CarcassC"))
        C.Mesh = findMesh(M $ "_CarcassC");
    
    if (C.Mesh == None) //In the absolute worst case, just switch back to JC
        C.Mesh = findMesh(defaultMesh $"_Carcass");

    log("CName = " $ CName);
    log("Looking for carcass " $ currOutfit.partsGroup.mesh $ "_Carcass" );
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
    
    //Find a texture in JCOutfits, to allow overriding skins from DX and other mods
    t = Texture(DynamicLoadObject("JCOutfits."$tex$"_S"$player.PlayerSkin, class'Texture', true));

    if (t == None)
        t = Texture(DynamicLoadObject("JCOutfits."$tex, class'Texture', true));

    //Otherwise look for exact texture name
    if (t == None)
        t = Texture(DynamicLoadObject(tex$"_S"$player.PlayerSkin, class'Texture', true));
    
    if (t == None)
        t = Texture(DynamicLoadObject(tex, class'Texture', true));
    
    //Fallback to looking in DeusEx Textures
    if (t == None)
        t = Texture(DynamicLoadObject("DeusExCharacters.Skins."$tex, class'Texture', true));

    if (t == None)
        t = Texture(DynamicLoadObject("DeusExItems.Skins."$tex, class'Texture', true));

    return t;
}

function bool ValidateSpawn(string id)
{
    local int index;

    index = GetOutfitIndexByID(id);

    return index > 0 && !outfits[index].unlocked;
}

defaultproperties
{
    NothingName="Nothing"
    partNames(0)="Cool Sunglasses"
    partNames(1)="Black Bars"
    partNames(2)="Default Skin"
    partNames(3)="Default"
    partNames(4)="Prescription Glasses"
    partNames(5)="Default w/ Jewellery"
    partNames(6)="Reading Glasses"
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
    partNames(17)="Majestic 12 Helmet"
    partNames(18)="Sailor Hat"
    partNames(19)="Beanie"
    partNames(20)="Dirty Brown Pants"
    partNames(21)="Blue Business Pants"
    partNames(22)="Black Business Pants"
    partNames(23)="Soiled Pants (Brown)"
    partNames(24)="Soiled Pants (Blue)"
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
    outfitNames(44)="Unwashed Clothes"
    outfitDescs(44)="Look for a bum."
    outfitNames(45)="Harley Filben's Outfit"
    outfitDescs(45)=""
    outfitNames(46)="White Business Suit"
    outfitDescs(46)="Requiem for a Dream"
    outfitNames(47)="Secret Service Suit"
    outfitDescs(47)=""
    outfitNames(48)="Doctor's Outfit"
    outfitDescs(48)=""
    outfitNames(49)="Nurse Outfit"
    outfitDescs(49)=""
    outfitNames(50)="Gilbert Renton's Outfit"
    outfitDescs(50)=""
    outfitNames(51)="Hooker Outfit (Alt)"
    outfitDescs(51)=""
    outfitNames(52)="Ford Schick's Outfit"
    outfitDescs(52)=""
    outfitNames(53)="Joe Greene's Outfit"
    outfitDescs(53)=""
    outfitNames(54)="Soiled Junkie Clothes"
    outfitDescs(54)=""
    outfitNames(55)="Rook Member Outfit"
    outfitDescs(55)=""
}
