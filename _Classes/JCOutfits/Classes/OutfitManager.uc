class OutfitManager extends OutfitManagerBase;

#exec OBJ LOAD FILE=DeusEx

var DeusExPlayer player;

var transient Outfit outfits[255];
var transient int numOutfits;

//Used for saving outfit number between maps
//This can be used for other purposes, but better to use currOutfit instead
var travel int savedOutfitIndex;

//Some outfits are special
const CUSTOM_OUTFIT = 0;
const DEFAULT_OUTFIT = 1;
var transient Outfit currOutfit;
var travel OutfitCustom customOutfit;

//Set to true to disable hats/glasses/etc
var travel bool noAccessories;

//Show item descriptions
var globalconfig bool noDescriptions;

//Create a random table, which we use for important NPCs,
//to ensure they retain the same clothing across maps.
var travel int randomTable[1000];
var travel bool bRolledTable;
var transient int iCurrentRand;

//Equip NPCs
var globalconfig int iEquipNPCs;

//Print outfit part names to the console
var globalconfig bool bDebugMode;

//part names
var const localized string partNames[1000];

var const sound PickupSound;            //The sound made when picking up outfit boxes

var transient bool bIsSetup;            //Has the outfit manager been setup for this session

var const localized string MsgOutfitUnlocked;       //Message that tells us we've unlocked an outfit.

//Outfit Information
struct LocalizedOutfitInfo
{
    var const localized string Name;
    var const localized string Desc;
    var const localized string HighlightName;
    var const localized string PickupName;
    var const localized string PickupMessage;
    var const localized string Article;
};

var const LocalizedOutfitInfo outfitInfos[255];

//Custom Outfit Name
var const localized string CustomOutfitName;

//Default Name
var const localized string NothingName;

//Default pickup message
var const localized string DefaultPickupMessage;
var const localized string DefaultPickupMessage2;

//TODO: Replace these with outfit 0
var travel string defaultTextures[8];
var travel string defaultMesh;

var transient OutfitPart PartsList[300];
var transient int numParts;
var transient PartsGroup Groups[50];
var transient int numPartsGroups;
var transient PartsGroup currentPartsGroup;

//New 1.1 stuff! For handling NPC outfits
var transient NPCOutfitGroup NPCGroups[50];
var transient int numNPCOutfitGroups;
var transient int currentNPCOutfitGroup;

//Outfits unlocked this playthrough. Outfits are made permanent after finishing the game.
var travel string unlockedOutfits[255];

var transient bool bSettingsMenuDisabled;
var transient bool bDescriptionsCheckbox;

function bool Installed()
{
    return true;
}

function DebugLog(coerce string text)
{
    if (bDebugMode)
        Log(text);
}

function OutfitPart CreateNewOutfitPart(PartSlot slot,string name,bool isAccessory,string id, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm)
{
    local OutfitPart P;

    if (bIsSetup)
        return None;

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
    GlobalAddPart(slot,outfitInfos[outfitNameIndex].Name,isAccessory,id,t0,t1,t2,t3,t4,t5,t6,t7,tm);
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
    AddPart(slot,outfitInfos[outfitNameIndex].Name,isAccessory,id,t0,t1,t2,t3,t4,t5,t6,t7,tm);
}

function AddPart(PartSlot slot,string name,bool isAccessory,string id, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm)
{
    local OutfitPart P;
    
    if (bIsSetup)
        return;

    P = CreateNewOutfitPart(slot,name,isAccessory,id,t0,t1,t2,t3,t4,t5,t6,t7,tm);

    currentPartsGroup.AddPart(P);
}

function GroupAddParts(PartSlot bodySlot)
{
    local int i;
    
    if (bIsSetup)
        return;

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
    
    if (bIsSetup)
        return;

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
    
    if (bIsSetup)
        return;

    currOutfit.AddPartFromID(partID);
}

function RollTable()
{
    local int i;
    bRolledTable=true;
    for (i = 0;i < ArrayCount(randomTable);i++)
        randomTable[i] = Rand(101);
}

function Setup(DeusExPlayer newPlayer)
{
    local DeusExLevelInfo dxInfo;
    local string t0, t1, t2, t3, t4, t5, t6, t7, mesh;

    if (bIsSetup)
        return;

    if (!bRolledTable)
        RollTable();

    player = newPlayer;
    dxInfo = player.GetLevelInfo();
    player.CarcassType=class'Augmentique.OutfitCarcassPlayer';
    
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
        //Set flag for default outfit
        Player.FlagBase.SetBool('JCOutfits_Equipped_default',true,true,0);
        savedOutfitIndex = -1;
    }

    CopyOverUnlockedOutfits();

    //When we finish the game, or if we're in training, copy our outfits out permanently
    if (dxInfo != None && (dxInfo.missionNumber > 90 || dxInfo.missionNumber == 0))
    {
        DebugLog("Copying over outfits");
        CopyOutfitsToPlayer();
    }
    //else
    //    DebugLog("Not Copying over outfits");

    //if (numOutfits != 0)
    //    return;
    
    PopulateOutfitsList();

    //New 1.1 feature!
    PopulateNPCOutfitsList();

    SetupNPCOutfits();
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
    customOutfit.ResetParts();
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
    local int index;

	foreach player.AllActors(class'OutfitSpawner', S)
    {
        //player.ClientMessage("Found an outfit spawner");
        if (ValidateSpawn(S.id))
        {
            S.outfitManager = self;

            index = GetOutfitIndexByID(S.id);

            //Set Frob Label and such
            //S.ItemName = sprintf(S.PickupName,GetOutfitNameByID(S.id));
            S.ItemName = outfits[index].PickupName;

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
    local int index;
    index = GetOutfitIndexByID(S.id);

    if (index == -1)
        return;

    //Stop percentages being broken when using custom pickup messages
    if (InStr(outfits[index].PickupMessage,"%s") != -1)
    {
        if (outfits[index].PickupArticle != "")
            player.ClientMessage(sprintf(outfits[index].PickupMessage,outfits[index].PickupArticle,outfits[index].PickupName), 'Pickup');
        else
            player.ClientMessage(sprintf(outfits[index].PickupMessage,outfits[index].PickupName), 'Pickup');
    }
    else
        player.ClientMessage(outfits[index].PickupMessage, 'Pickup');
        
    Unlock(S.id);

    //Decorations don't support pickup sounds, so do it here
	player.PlaySound(PickupSound, SLOT_None);

    //Set outfit as new
    outfits[index].bNew = true;

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
    
    //Default "Nothing" accessories/textures
    GlobalAddPart(PS_Glasses,NothingName,true,"nothing_g","none","none");
    GlobalAddPart(PS_Hat,NothingName,true,"nothing_h","none","none");
    GlobalAddPart(PS_Helmet,NothingName,true,"nothing_h","none","none");
    GlobalAddPartL(PS_Body_M,0,false,"default_b","default");
    GlobalAddPartL(PS_Body_F,0,false,"default_b","default");

    //Glasses
    GlobalAddPartL(PS_Glasses,1,true,"default_g","FramesTex4","LensesTex5");
    GlobalAddPartL(PS_Glasses,2,true,"sci_g","FramesTex1","LensesTex1");
    GlobalAddPartL(PS_Glasses,3,true,"100%_g","Outfit1_Tex1","Outfit1_Tex1");
    GlobalAddPartL(PS_Glasses,4,true,"business_g","FramesTex1","LensesTex2");
    GlobalAddPartL(PS_Glasses,5,true,"sunglasses_g","FramesTex2","LensesTex3");
    GlobalAddPartL(PS_Glasses,6,true,"sunglasses2_g","FramesTex2","LensesTex2");
    GlobalAddPartL(PS_Glasses,179,true,"party_g","FramesTex3","BlackMaskTex");
    
    //Masks
    //Masks are body textures that cover the mouth
    //Can only realistically be used on GM_Jumpsuit
    //because no other model supports the "mouth covering" texture.
    GlobalAddPartL(PS_Mask,116,false,"unatco_b","MiscTex1JC","MiscTex1JC","MiscTex1JC");
    GlobalAddPartL(PS_Mask,117,false,"nsf_b","TerroristTex0","TerroristTex0","TerroristTex0");
    GlobalAddPartL(PS_Mask,118,false,"mj12elite_b","MJ12EliteTex0","MJ12EliteTex0","MJ12EliteTex0");

    //Helmets.
    //Jumpsuit and GM_DressShirt_B only
    GlobalAddPartL(PS_Helmet,119,true,"unatco_h",,"UNATCOTroopTex3");
    GlobalAddPartL(PS_Helmet,171,true,"soldier_h2","SoldierTex0","SoldierTex3","none","SoldierTex0"); //Version with chin strap.
    GlobalAddPartL(PS_Helmet,120,true,"soldier_h",,"SoldierTex3");
    GlobalAddPartL(PS_Helmet,121,true,"mechanic_h",,"MechanicTex3");
    GlobalAddPartL(PS_Helmet,122,true,"riotcop_h",,"RiotCopTex3","VisorTex1");
    GlobalAddPartL(PS_Helmet,124,true,"mj12_h",,"MJ12TroopTex4");
    GlobalAddPartL(PS_Helmet,182,true,"mj12_h2",,"MJ12TroopTex4s",,,"none");
    GlobalAddPartL(PS_Helmet,180,true,"mj12elite_h",,"MJ12TroopTex3");
    GlobalAddPartL(PS_Helmet,123,true,"nsf_h",,"GogglesTex1");
    GlobalAddPartL(PS_Helmet,181,true,"visor_h",,"ThugMale3Tex3");

    //Skin Textures
    GlobalAddPartL(PS_Body_M,8,false,"100%_b","Outfit1_Tex1");
    GlobalAddPartL(PS_Body_M,9,false,"beanie_b","ThugSkin");
    GlobalAddPartL(PS_Body_M,10,false,"adam_b","AdamJensenTex0");
    GlobalAddPartL(PS_Body_M,167,false,"bald_b","JCDentonTex0Bald");
    GlobalAddPartL(PS_Body_M,168,false,"agent47_b","HitmanTex0");
    GlobalAddPartL(PS_Body_M,170,false,"blackgloves_b","HarleyFilbenTex0");

    //GlobalAddPartLO(PS_Body_F,2,false,"100%_b","Outfit1_Tex1",,,"Outfit1_Tex1");
    GlobalAddPartL(PS_Body_F,8,false,"100%_b","Outfit1_Tex1");

    //Pants
    GlobalAddPartL(PS_Legs,11,false,"default_p","JCDentonTex3");
    GlobalAddPartL(PS_Legs_M,12,false,"lab_p","PantsTex1");
    GlobalAddPartL(PS_Legs,13,false,"gilbertrenton_p","PantsTex3"); //Also used by Ford Schick and Boat Person
    GlobalAddPartL(PS_Legs,8,false,"100%_p","Outfit1_Tex1");
    GlobalAddPartL(PS_Legs,14,false,"paul_p","PantsTex8"); //Also used by Toby Atanwe and others
    GlobalAddPartL(PS_Legs,15,false,"businessman1_p","Businessman1Tex2");
    GlobalAddPartL(PS_Legs,16,false,"businessman2_p","Businessman2Tex2");
    GlobalAddPartL(PS_Legs,114,false,"chef_p","PantsTex10"); //Also used by Luminous Path members //TODO:
    GlobalAddPartL(PS_Legs,17,false,"ajacobson_p","AlexJacobsonTex2");
    GlobalAddPartL(PS_Legs,18,false,"unatco_p","UnatcoTroopTex1");
    GlobalAddPartL(PS_Legs,19,false,"mechanic_p","MechanicTex2");
    GlobalAddPartL(PS_Legs,20,false,"soldier_p","SoldierTex2");
    GlobalAddPartL(PS_Legs,21,false,"riotcop_p","RiotCopTex1");
    GlobalAddPartL(PS_Legs,22,false,"nsf_p","TerroristTex2");
    GlobalAddPartL(PS_Legs,23,false,"mj12_p","MJ12TroopTex1");
    GlobalAddPartL(PS_Legs,24,false,"carter_p","SamCarterTex2");
    GlobalAddPartL(PS_Legs,25,false,"sailor_p","SailorTex2");
    GlobalAddPartL(PS_Legs,26,false,"bum_p","PantsTex4");
    //GlobalAddPartL(PS_Legs,22,false,"lebedev_p","JuanLebedevTex3"); //Exactly the same as the regular NSF pants
    GlobalAddPartL(PS_Legs,27,false,"thug_p","ThugMale2Tex2");
    GlobalAddPartL(PS_Legs,28,false,"thug2_p","ThugMaleTex3");
    GlobalAddPartL(PS_Legs,29,false,"mib_p","PantsTex5"); //Also used for Butler, and several others
    GlobalAddPartL(PS_Legs,30,false,"brown_p","PantsTex7");
    GlobalAddPartL(PS_Legs,31,false,"secretservice_p","SecretServiceTex2");
    GlobalAddPartL(PS_Legs,32,false,"junkie_p","JunkieMaleTex2");
    GlobalAddPartL(PS_Legs,33,false,"jojo_p","JoJoFineTex2");
    GlobalAddPartLO(PS_Legs,64,false,"thug3_p","ThugMale3Tex2");
    GlobalAddPartL(PS_Legs,34,false,"cop_p","CopTex2");
    GlobalAddPartL(PS_Legs,35,false,"howardstrong_p","HowardStrongTex2");
    GlobalAddPartL(PS_Legs,36,false,"chad_p","ChadTex2");
    //GlobalAddPartLO(PS_Legs,29,false,"dentonclone_p","DentonCloneTex2"); //FAIL, these suck
    GlobalAddPartL(PS_Legs,37,false,"lowclass_p","PantsTex6");
    GlobalAddPartL(PS_Legs,38,false,"lowclass_p2","PantsTex2"); //Also used by Jaime Reyes, and others
    GlobalAddPartL(PS_Legs,39,false,"lowclass2_p","LowerClassMale2Tex2");
    GlobalAddPartL(PS_Legs,40,false,"janitor_p","JanitorTex2");
    GlobalAddPartL(PS_Legs,41,false,"martialartist_p","Male4Tex2");
    GlobalAddPartL(PS_Legs,42,false,"tong_p","TracerTongTex2");
    GlobalAddPartL(PS_Legs,43,false,"hkmilitary_p","HKMilitaryTex2");
    GlobalAddPartL(PS_Legs,44,false,"vp_p","MichaelHamnerTex2");
    GlobalAddPartL(PS_Legs,45,false,"vinny_p","NathanMadisonTex2");
    GlobalAddPartL(PS_Legs,46,false,"page_p","BobPageTex2");
    GlobalAddPartL(PS_Legs,47,false,"gordonquick_p","GordonQuickTex3");
    GlobalAddPartL(PS_Legs,48,false,"redarrow_p","TriadRedArrowTex3");
    GlobalAddPartL(PS_Legs,49,false,"jock_p","JockTex3");
    GlobalAddPartL(PS_Legs,50,false,"maxchen_p","MaxChenTex3");
    GlobalAddPartLO(PS_Legs,35,false,"prisoner_p","PrisonerTex2");
    GlobalAddPartL(PS_Legs,178,false,"midnight_p","MidnightTex2");

    //Female
    GlobalAddPartL(PS_Legs,11,false,"default_p","JCDentonTex3");
    GlobalAddPartL(PS_Legs_F,12,false,"lab_p","ScientistFemaleTex3");
    GlobalAddPartL(PS_Legs,129,false,"goldbrown_p","Outfit2F_Tex3");
    GlobalAddPartL(PS_Legs,130,false,"matrix_p","Outfit4F_Tex3");
    GlobalAddPartL(PS_Legs,131,false,"goth_p","Outfit3F_Tex3");
    GlobalAddPartL(PS_Legs,132,false,"anna_p","PantsTex9");
    GlobalAddPartL(PS_Legs,133,false,"tiffany_p","TiffanySavageTex2");
    
    //TODO: These are female only
    GlobalAddPartL(PS_Legs_F,134,false,"junkie_p2","JunkieFemaleTex2");
    GlobalAddPartL(PS_Legs_F,135,false,"dentonclone_pf","DentonCloneTex2Fem");
    
    //Trenchcoat Torsos
    GlobalAddPartL(PS_Trench_Shirt_M,51,false,"lab_s","TrenchShirtTex3");
    GlobalAddPartL(PS_Trench_Shirt_M,8,false,"100%_s","Outfit1_Tex1");
    GlobalAddPartL(PS_Trench_Shirt_M,52,false,"paul_s","PaulDentonTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,53,false,"bum_s","TrenchShirtTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,54,false,"bum2_s","TrenchShirtTex2");
    GlobalAddPartL(PS_Trench_Shirt,55,false,"lebedev_s","JuanLebedevTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,56,false,"smuggler_s","SmugglerTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,57,false,"simons_s","WaltonSimonsTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,58,false,"doctor_s","DoctorTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,59,false,"manderley_s","JosephManderleyTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,60,false,"gilbertrenton_s","GilbertRentonTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,61,false,"ford_s","FordSchickTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,62,false,"thug2_s","ThugMaleTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,63,false,"gordonquick_s","GordonQuickTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,64,false,"redarrow_s","TriadRedArrowTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,65,false,"jock_s","JockTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,66,false,"jaime_s","JaimeReyesTex1");
    GlobalAddPartL(PS_Trench_Shirt,67,false,"toby_s","TobyAtanweTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,68,false,"garysavage_s","GarySavageTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,69,false,"maxchen_s","MaxChenTex1");
    GlobalAddPartL(PS_Trench_Shirt_F,172,false,"default_s2","Outfit1F_Tex1");
    GlobalAddPartL(PS_Trench_Shirt_F,8,false,"100%_s","Outfit1_Tex1");
    GlobalAddPartL(PS_Trench_Shirt_F,51,false,"lab_s","TrenchShirtTex3");
    GlobalAddPartL(PS_Trench_Shirt,173,false,"matrix_s","Outfit4F_Tex1");
    GlobalAddPartL(PS_Trench_Shirt_F,174,false,"goth_s","Outfit3F_Tex1");
    GlobalAddPartL(PS_Trench_Shirt_M,169,false,"agent47_s","HitmanTex1");
    GlobalAddPartL(PS_Trench_Shirt_M,177,false,"midnight_s","MidnightTex1");
    
    GlobalAddPartL(PS_Trench_Shirt_M,0,false,"default_s","JCDentonTex1");
    GlobalAddPartL(PS_Trench_Shirt_F,0,false,"default_s","FemJC.JCDentonFemaleTex1");
    
    //Trenchcoats
    GlobalAddPartL(PS_Trench_M,70,false,"lab_t","LabCoatTex1","LabCoatTex1");
    GlobalAddPartL(PS_Trench_M,8,false,"100%_t","Outfit1_Tex1","Outfit1_Tex1");
    GlobalAddPartL(PS_Trench,71,false,"paul_t","PaulDentonTex2","PaulDentonTex2");
    GlobalAddPartL(PS_Trench,72,false,"bum_t","BumMaleTex2","BumMaleTex2");
    GlobalAddPartL(PS_Trench,73,false,"bum2_t","BumMale2Tex2","BumMale2Tex2");
    GlobalAddPartL(PS_Trench,74,false,"bum3_t","BumMale3Tex2","BumMale3Tex2");
    GlobalAddPartL(PS_Trench,75,false,"lebedev_t","JuanLebedevTex2","JuanLebedevTex2");
    GlobalAddPartL(PS_Trench,76,false,"smuggler_t","SmugglerTex2","SmugglerTex2");
    GlobalAddPartL(PS_Trench,77,false,"simons_t","WaltonSimonsTex2","WaltonSimonsTex2");
    GlobalAddPartL(PS_Trench,78,false,"harleyfilben_t","HarleyFilbenTex2","HarleyFilbenTex2");
    GlobalAddPartL(PS_Trench,79,false,"gilbertrenton_t","GilbertRentonTex2","GilbertRentonTex2");
    GlobalAddPartL(PS_Trench,80,false,"ford_t","FordSchickTex2","FordSchickTex2");
    GlobalAddPartL(PS_Trench_M,81,false,"thug2_t","ThugMaleTex2");
    GlobalAddPartL(PS_Trench,82,false,"gordonquick_t","GordonQuickTex2","GordonQuickTex2");
    GlobalAddPartL(PS_Trench,83,false,"redarrow_t","TriadRedArrowTex2","TriadRedArrowTex2");
    GlobalAddPartL(PS_Trench_M,84,false,"jock_t","JockTex2");
    GlobalAddPartL(PS_Trench,85,false,"toby_t","TobyAtanweTex2","TobyAtanweTex2");
    GlobalAddPartL(PS_Trench,86,false,"maxchen_t","MaxChenTex2","MaxChenTex2");
    GlobalAddPartL(PS_Trench,87,false,"manderley_t","JosephManderleyTex2","JosephManderleyTex2");
    GlobalAddPartL(PS_Trench,88,false,"gray_t","TrenchCoatTex1","TrenchCoatTex1");
    GlobalAddPartL(PS_Trench_F,70,false,"lab_t","ScientistFemaleTex2","ScientistFemaleTex2");
    GlobalAddPartL(PS_Trench_F,8,false,"100%_t","Outfit1_Tex1","Outfit1_Tex1");
    GlobalAddPartL(PS_Trench,164,false,"goldbrown_t","Outfit2F_Tex2","Outfit2F_Tex2");
    GlobalAddPartL(PS_Trench,165,false,"matrix_t","Outfit4F_Tex2","Outfit4F_Tex2");
    GlobalAddPartL(PS_Trench,166,false,"goth_t","Female4Tex2","Female4Tex2");
    GlobalAddPartL(PS_Trench,176,false,"midnight_t","MidnightTex3","MidnightTex3");
    
    GlobalAddPartL(PS_Trench_M,0,false,"default_t","JCDentonTex2","JCDentonTex2");
    GlobalAddPartL(PS_Trench_F,0,false,"default_t","FemJC.JCDentonFemaleTex2","FemJC.JCDentonFemaleTex2");

    //Dress Pants
    GlobalAddPartL(PS_DressLegs,136,false,"nurse_pf","LegsTex1");
    GlobalAddPartL(PS_DressLegs,137,false,"stockings_pf","LegsTex2");
    GlobalAddPartL(PS_DressLegs,138,false,"hooker_pf","Hooker1Tex1");
    GlobalAddPartL(PS_DressLegs,139,false,"hooker2_pf","Hooker2Tex1");
    GlobalAddPartL(PS_DressLegs,140,false,"alex_pf","Outfit5F_Tex1");
    GlobalAddPartL(PS_DressLegs,141,false,"rachel_pf","RachelMeadTex2");
    GlobalAddPartL(PS_DressLegs,142,false,"business_pf","BusinessWoman1Tex2");
    GlobalAddPartL(PS_DressLegs,143,false,"nicolette_pf","NicoletteDuClareTex3");
    GlobalAddPartL(PS_DressLegs,144,false,"sarah_pf","SarahMeadTex3");
    GlobalAddPartL(PS_DressLegs,145,false,"office_pf","Female2Tex1");
    GlobalAddPartL(PS_DressLegs,146,false,"lowclass2_pf","Female3Tex2");

    //Skirts
    GlobalAddPartL(PS_Skirt,160,false,"nicolette_sk","NicoletteDuClareTex2","NicoletteDuClareTex2");
    GlobalAddPartL(PS_Skirt,161,false,"sarah_sk","SarahMeadTex2","SarahMeadTex2");
    GlobalAddPartL(PS_Skirt,162,false,"hooker_sk","Hooker1Tex2","Hooker1Tex2");
    GlobalAddPartL(PS_Skirt,163,false,"hooker2_sk","Hooker2Tex2","Hooker2Tex2");
    GlobalAddPartL(PS_Skirt,175,false,"alex_sk","Outfit5F_Tex2","Outfit5F_Tex2");

    //Shirts etc
    GlobalAddPartL(PS_Torso_M,89,false,"ajacobson_s","AlexJacobsonTex1");
    GlobalAddPartL(PS_Torso_M,90,false,"unatco_s","UNATCOTroopTex2");
    GlobalAddPartL(PS_Torso_M,91,false,"mechanic_s","MechanicTex1");
    GlobalAddPartL(PS_Torso_M,92,false,"soldier_s","SoldierTex1");
    GlobalAddPartL(PS_Torso_M,93,false,"riotcop_s","RiotCopTex2");
    GlobalAddPartL(PS_Torso_M,55,false,"nsf_s","TerroristTex1");
    GlobalAddPartL(PS_Torso_M,94,false,"mj12_s","MJ12TroopTex2");
    GlobalAddPartL(PS_Torso_M,95,false,"carter_s","SamCarterTex1");
    GlobalAddPartL(PS_Torso_M,96,false,"thug_s","ThugMale2Tex1");
    GlobalAddPartL(PS_Torso_M,97,false,"joegreene_s","JoeGreeneTex1");
    GlobalAddPartL(PS_Torso_M,98,false,"junkie_s","JunkieMaleTex1");
    GlobalAddPartL(PS_Torso_M,99,false,"jojo_s","JoJoFineTex1");
    GlobalAddPartL(PS_Torso_M,100,false,"bartender_s","BartenderTex1");
    GlobalAddPartL(PS_Torso_M,101,false,"cop_s","CopTex1");
    GlobalAddPartL(PS_Torso_M,102,false,"howardstrong_s","HowardStrongTex1");
    GlobalAddPartL(PS_Torso_M,103,false,"adam_s","AdamJensenTex3");
    GlobalAddPartL(PS_Torso_M,104,false,"adam_s2","AdamJensenTex2");
    GlobalAddPartL(PS_Torso_M,63,false,"dentonclone_s","DentonCloneTex3");
    GlobalAddPartL(PS_Torso_M,105,false,"everett_s","MorganEverettTex1");
    GlobalAddPartL(PS_Torso_M,106,false,"boatperson_s","BoatPersonTex1");
    GlobalAddPartL(PS_Torso_M,107,false,"lowclass_s","LowerClassMaleTex1");
    GlobalAddPartL(PS_Torso_M,108,false,"chad_s","ChadTex1");
    GlobalAddPartL(PS_Torso_M,109,false,"janitor_s","JanitorTex1");
    GlobalAddPartL(PS_Torso_M,110,false,"martialartist_s","Male4Tex1");
    GlobalAddPartL(PS_Torso_M,111,false,"tong_s","TracerTongTex1");
    GlobalAddPartL(PS_Torso_M,112,false,"hkmilitary_s","HKMilitaryTex1");
    GlobalAddPartL(PS_Torso_M,113,false,"alex_s","AlexDentonMaleTex2");
    GlobalAddPartLO(PS_Torso_M,35,false,"prisoner_s","PrisonerTex1");
    GlobalAddPartL(PS_Torso_M_B,148,false,"gunther_s","GuntherHermannTex1");
    GlobalAddPartL(PS_Torso_M_B,115,false,"thug3_s","ThugMale3Tex1");

    //Female
    GlobalAddPartL(PS_Torso_F,147,false,"nicolette_s","NicoletteDuClareTex1");
    GlobalAddPartL(PS_Torso_F,148,false,"anna_s","AnnaNavarreTex1");
    GlobalAddPartL(PS_Torso_F,149,false,"tiffany_s","TiffanySavageTex1");
    GlobalAddPartL(PS_Torso_F,150,false,"sarah_s","SarahMeadTex1");
    GlobalAddPartL(PS_Torso_F,151,false,"shea_s","JordanSheaTex1");
    GlobalAddPartL(PS_Torso_F,152,false,"hooker_s","Hooker1Tex3");
    GlobalAddPartL(PS_Torso_F,153,false,"hooker2_s","Hooker2Tex3");
    GlobalAddPartL(PS_Torso_F,154,false,"junkie_s","JunkieFemaleTex1");
    GlobalAddPartL(PS_Torso_F,155,false,"alex_s","Outfit5F_Tex3");
    GlobalAddPartL(PS_Torso_F,156,false,"bum_sf","BumFemaleTex1");
    GlobalAddPartL(PS_Torso_F,157,false,"lowclass_sf","LowerClassFemaleTex1");
    GlobalAddPartL(PS_Torso_F,158,false,"sandrarenton_s","SandraRentonTex1");
    GlobalAddPartL(PS_Torso_F,159,false,"dentonclone_sf","DentonCloneTex3Fem");
    
    //========================================================
    //  GM_Trench
    //========================================================

    //BeginNewPartsGroup("GM_Trench","GM_Trench_Carcass", true, false);
    BeginNewPartsGroup("AMTGM_Trench","GM_Trench_Carcass", true, false);
    GroupAddParts(PS_Body_M);
    GroupTranspose(PS_Trench,1,5);
    GroupTranspose2(PS_Trench_M,PS_Trench,1,5);
    GroupTranspose(PS_Trench_Shirt,4);
    GroupTranspose2(PS_Trench_Shirt_M,PS_Trench_Shirt,4);
    GroupTranspose(PS_Legs,2);
    GroupTranspose2(PS_Legs_M,PS_Legs,2);
    GroupTranspose(PS_Glasses,6,7);
    GroupTranspose2(PS_Mask,PS_Body_M,-1,3);

    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_g");

    //Masks
    /*
    AddDefaultReference("unatco_b");
    AddDefaultReference("nsf_b");
    AddDefaultReference("mj12elite_b");
    */
    
    //Default M
    BeginNewOutfitL("default",0);
    OutfitAddPartReference("default_t");
    OutfitAddPartReference("default_p");
    OutfitAddPartReference("default_s");
    OutfitAddPartReference("party_g");
    OutfitAddPartReference("default_g");

    //100% Black Outfit M
    BeginNewOutfitL("100black",2);
    OutfitAddPartReference("100%_p");
    OutfitAddPartReference("100%_s");
    OutfitAddPartReference("100%_g");
    OutfitAddPartReference("100%_t");

    //100% Black (alt) M
    BeginNewOutfitL("100black",34);
    OutfitAddPartReference("100%_b");
    OutfitAddPartReference("default_p");
    OutfitAddPartReference("default_s");
    OutfitAddPartReference("default_g");
    OutfitAddPartReference("default_t");

    //Labcoat M
    BeginNewOutfitL("labcoat",4);
    OutfitAddPartReference("sci_g");
    OutfitAddPartReference("lab_p");
    OutfitAddPartReference("lab_t");
    OutfitAddPartReference("lab_s");
    
    //Doctor Outfit
    BeginNewOutfitL("doctor",48);
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("lab_t");
    OutfitAddPartReference("lab_p");
    OutfitAddPartReference("doctor_s");
    
    //Paul Outfit
    BeginNewOutfitL("paul",5);
    OutfitAddPartReference("default_g");
    OutfitAddPartReference("paul_p");
    OutfitAddPartReference("paul_t");
    OutfitAddPartReference("paul_s");
    
    //Gary Savage Outfit
    BeginNewOutfitL("garysavage",87);
    OutfitAddPartReference("paul_p");
    OutfitAddPartReference("lab_t");
    OutfitAddPartReference("garysavage_s");
    
    //Gilbert Renton Outfit
    BeginNewOutfitL("gilbertrenton",50);
    OutfitAddPartReference("gilbertrenton_p");
    OutfitAddPartReference("gilbertrenton_t");
    OutfitAddPartReference("gilbertrenton_s");
    
    //Gordon Quick's Outfit
    BeginNewOutfitL("gordonquick",82);
    OutfitAddPartReference("gordonquick_p");
    OutfitAddPartReference("gordonquick_s");
    OutfitAddPartReference("gordonquick_t");
    
    //Hitman Suit
    BeginNewOutfitL("agent47",97);
    OutfitAddPartReference("bald_b");
    OutfitAddPartReference("agent47_b");
    OutfitAddPartReference("agent47_s");
    OutfitAddPartReference("manderley_t");
    OutfitAddPartReference("mib_p");

    //Bum
    BeginNewOutfitL("bum",21);
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("bum_p");
    OutfitAddPartReference("bum_t");
    OutfitAddPartReference("bum_s");
    
    //Bum2
    BeginNewOutfitL("bum2",44);
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("bum_p");
    OutfitAddPartReference("bum2_t");
    OutfitAddPartReference("bum2_s");
    
    //Bum2
    BeginNewOutfitL("bum3",88);
    OutfitAddPartReference("brown_p");
    OutfitAddPartReference("bum3_t");
    OutfitAddPartReference("bum2_s"); //Not a mistake. Bum 2 and 3 have the same shirt

    //Jaime
    BeginNewOutfitL("jaimereyes",85);
    OutfitAddPartReference("lab_t");
    OutfitAddPartReference("jaime_s");
    OutfitAddPartReference("lowclass_p2");

    //Jock
    BeginNewOutfitL("jock",26);
    OutfitAddPartReference("sunglasses2_g");
    OutfitAddPartReference("jock_p");
    OutfitAddPartReference("jock_s");
    OutfitAddPartReference("jock_t");

    //Lebedev
    BeginNewOutfitL("lebedev",22);
    OutfitAddPartReference("sunglasses_g");
    OutfitAddPartReference("nsf_p");
    OutfitAddPartReference("lebedev_t");
    OutfitAddPartReference("lebedev_s");

    //Max Chen
    BeginNewOutfitL("maxchen",89);
    OutfitAddPartReference("maxchen_t");
    OutfitAddPartReference("maxchen_p");
    OutfitAddPartReference("maxchen_s");
    
    //Joseph Manderley
    BeginNewOutfitL("manderley",94);
    OutfitAddPartReference("manderley_s");
    OutfitAddPartReference("manderley_t");
    OutfitAddPartReference("mib_p");

    //Smugglers Outfit
    BeginNewOutfitL("smug",23);
    OutfitAddPartReference("mib_p");
    OutfitAddPartReference("smuggler_t");
    OutfitAddPartReference("smuggler_s");
    OutfitAddPartReference("sci_g");

    //Simons Outfit
    BeginNewOutfitL("simons",24);
    OutfitAddPartReference("mib_p");
    OutfitAddPartReference("sunglasses_g");
    OutfitAddPartReference("simons_s");
    OutfitAddPartReference("simons_t");

    //Red Arrow Outfit
    BeginNewOutfitL("redarrow",83);
    OutfitAddPartReference("redarrow_s");
    OutfitAddPartReference("redarrow_p");
    OutfitAddPartReference("redarrow_t");
    
    //Harley Filben Outfit
    BeginNewOutfitL("harleyfilben",45);
    OutfitAddPartReference("blackgloves_b");
    OutfitAddPartReference("brown_p");
    OutfitAddPartReference("bum_s");
    OutfitAddPartReference("harleyfilben_t");
    
    //Ford Schick Outfit
    BeginNewOutfitL("ford",52);
    OutfitAddPartReference("gilbertrenton_p");
    OutfitAddPartReference("ford_s");
    OutfitAddPartReference("ford_t");
    
    //Rook Member Outfit
    BeginNewOutfitL("thug2",55);
    OutfitAddPartReference("thug2_p");
    OutfitAddPartReference("thug2_s");
    OutfitAddPartReference("thug2_t");
    
    //Terrorist Commander
    BeginNewOutfitL("terroristcommander",96);
    OutfitAddPartReference("gray_t");
    OutfitAddPartReference("lebedev_s");
    OutfitAddPartReference("paul_p");
    
    //Toby Atanwe
    BeginNewOutfitL("toby",86);
    OutfitAddPartReference("paul_p");
    OutfitAddPartReference("toby_t");
    OutfitAddPartReference("toby_s");
    
    //Midnight Trenchcoat
    BeginNewOutfitL("midnight",98);
    OutfitAddPartReference("bald_b");
    OutfitAddPartReference("default_g");
    OutfitAddPartReference("midnight_s");
    OutfitAddPartReference("midnight_t");
    OutfitAddPartReference("midnight_p");

    //========================================================
    //  GFM_Trench
    // SARGE: Now replaced with AMTGFM_Trench
    //========================================================

    BeginNewPartsGroup("AMTGFM_Trench","GFM_Trench_Carcass", false, true);
    GroupAddParts(PS_Body_F);
    GroupTranspose(PS_Trench,1,5);
    GroupTranspose2(PS_Trench_F,PS_Trench,1,5);
    GroupTranspose(PS_Trench_Shirt,4);
    GroupTranspose2(PS_Trench_Shirt_F,PS_Trench_Shirt,4);
    GroupTranspose(PS_Legs,2);
    GroupTranspose2(PS_Legs_F,PS_Legs,2);
    GroupTranspose(PS_Glasses,6,7);
    
    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_g");
    
    //Default
    BeginNewOutfitL("default",0);
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("default_t");
    OutfitAddPartReference("default_p");
    OutfitAddPartReference("default_s");
    OutfitAddPartReference("party_g");
    OutfitAddPartReference("default_g");
    
    //Alternate Fem Jewellery
    BeginNewOutfitL("default",1);
    OutfitAddPartReference("default_b");
    OutfitAddPartReference("default_t");
    OutfitAddPartReference("default_p");
    OutfitAddPartReference("default_s2");
    OutfitAddPartReference("default_g");

    //100% Black Outfit
    BeginNewOutfitL("100black",2);
    OutfitAddPartReference("100%_p");
    OutfitAddPartReference("100%_s");
    OutfitAddPartReference("100%_g");
    OutfitAddPartReference("100%_t");

    //100% Black (alt)
    BeginNewOutfitL("100black",34);
    OutfitAddPartReference("100%_b");
    OutfitAddPartReference("default_p");
    OutfitAddPartReference("default_s");
    OutfitAddPartReference("default_g");
    OutfitAddPartReference("default_t");

    //Lab Coat
    BeginNewOutfitL("labcoat",4);
    OutfitAddPartReference("sci_g");
    OutfitAddPartReference("lab_p");
    OutfitAddPartReference("lab_t");
    OutfitAddPartReference("lab_s");
    
    //Gold Brown Outfit
    BeginNewOutfitL("goldbrown",13);
    OutfitAddPartReference("lab_s");
    OutfitAddPartReference("goldbrown_p");
    OutfitAddPartReference("goldbrown_t");
    OutfitAddPartReference("default_g");
    
    //Matrix Outfit
    BeginNewOutfitL("matrix",15);
    OutfitAddPartReference("matrix_s");
    OutfitAddPartReference("matrix_p");
    OutfitAddPartReference("matrix_t");
    OutfitAddPartReference("sunglasses_g");
    
    //Goth GF Outfit
    BeginNewOutfitL("goth",16);
    OutfitAddPartReference("goth_s");
    OutfitAddPartReference("goth_p");
    OutfitAddPartReference("goth_t");
    OutfitAddPartReference("sunglasses_g");

    //========================================================
    //  GFM_SuitSkirt
    // SARGE: Now replaced with AMTGFM_Trench
    //========================================================

    BeginNewPartsGroup("AMTGFM_SuitSkirt","GFM_SuitSkirt_Carcass", false, true);
    GroupAddParts(PS_Body_F);
    //GroupTranspose(PS_Legs,3);
    //GroupTranspose2(PS_DressLegs,PS_Legs,3);
    //GroupTranspose2(PS_Legs_F,PS_Legs,3);
    GroupTranspose(PS_DressLegs,3);
    GroupTranspose(PS_Glasses,6,7);
    
    //Unique Torsos
    AddPartLO(PS_Torso_F,19,false,"wib_sf",,,,,"WIBTex1","WIBTex1");
    AddPartLO(PS_Torso_F,27,false,"maggie_sf",,,,,"MaggieChowTex1","MaggieChowTex1");
    AddPartLO(PS_Torso_F,49,false,"nurse_sf",,,,,"NurseTex1","NurseTex1");
    AddPartLO(PS_Torso_F,57,false,"vp_sf",,,,,"MargaretWilliamsTex1","MargaretWilliamsTex1");
    AddPartLO(PS_Torso_F,58,false,"rachel_sf",,,,,"RachelMeadTex1","RachelMeadTex1");
    AddPartLO(PS_Torso_F,59,false,"business_sf",,,,,"BusinessWoman1Tex1","BusinessWoman1Tex1");
    AddPartLO(PS_Torso_F,90,false,"secretary_sf",,,,,"SecretaryTex2","SecretaryTex2");
    AddPartLO(PS_Torso_F,92,false,"office_sf",,,,,"Female2Tex2","Female2Tex2");
    AddPartLO(PS_Torso_F,93,false,"maid_sf",,,,,"MaidTex1","MaidTex1");
    AddPartLO(PS_Torso_F,95,false,"lowclass2_sf",,,,,"Female3Tex1","Female3Tex1");
    
    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_g");
    
    //WIB Outfit
    BeginNewOutfitL("wib",19);
    OutfitAddPartReference("stockings_pf");
    OutfitAddPartReference("wib_sf");
    OutfitAddPartReference("sunglasses_g");
    
    //Maggie Chow's Outfit
    BeginNewOutfitL("maggie",27);
    OutfitAddPartReference("stockings_pf");
    OutfitAddPartReference("maggie_sf");
    OutfitAddPartReference("sunglasses_g");

    //Nurse Outfit
    BeginNewOutfitL("nurse",49);
    OutfitAddPartReference("nurse_pf");
    OutfitAddPartReference("nurse_sf");
    
    //Vice President
    BeginNewOutfitL("vicepresident",57);
    OutfitAddPartReference("stockings_pf");
    OutfitAddPartReference("vp_sf");

    //Rachel Mead
    BeginNewOutfitL("meadrachel",58);
    OutfitAddPartReference("rachel_pf");
    OutfitAddPartReference("rachel_sf");

    //Business Woman
    BeginNewOutfitL("businesswoman",59);
    OutfitAddPartReference("business_pf");
    OutfitAddPartReference("business_sf");

    //Secretary
    BeginNewOutfitL("secretary",90);
    OutfitAddPartReference("secretary_sf");
    OutfitAddPartReference("nurse_pf");
    OutfitAddPartReference("business_g");
    
    //Office Lady
    BeginNewOutfitL("office",92);
    OutfitAddPartReference("office_sf");
    OutfitAddPartReference("office_pf");
    
    //Maid
    BeginNewOutfitL("maid",93);
    OutfitAddPartReference("maid_sf");
    OutfitAddPartReference("stockings_pf");
    
    //Lower Class 2
    BeginNewOutfitL("lowclass2",95);
    OutfitAddPartReference("lowclass2_sf");
    OutfitAddPartReference("lowclass2_pf");

    //========================================================
    //  GFM_Dress
    // SARGE: Now replaced with AMTGFM_Dress
    //========================================================

    BeginNewPartsGroup("AMTGFM_Dress","GFM_Dress_Carcass", false, true);
    GroupTranspose(PS_Body_F,7);
    GroupTranspose(PS_Legs,1);
    GroupTranspose2(PS_Legs_F,PS_Legs,1);
    GroupTranspose2(PS_DressLegs,PS_Legs,1);
    GroupTranspose(PS_Skirt,2,4);
    GroupTranspose(PS_Torso_F,3);
    
    //Defaults
    AddDefaultReference("default_b");
    
    //Nicollette DuClare's outfit
    BeginNewOutfitL("nicolette",28);
    OutfitAddPartReference("nicolette_pf");
    OutfitAddPartReference("nicolette_s");
    OutfitAddPartReference("nicolette_sk");
    
    //Sarah Mead
    BeginNewOutfitL("meadsarah",40);
    OutfitAddPartReference("sarah_pf");
    OutfitAddPartReference("sarah_s");
    OutfitAddPartReference("sarah_sk");
    
    //Hooker
    BeginNewOutfitL("hooker",42);
    OutfitAddPartReference("hooker_pf");
    OutfitAddPartReference("hooker_s");
    OutfitAddPartReference("hooker_sk");
    
    //Hooker2
    BeginNewOutfitL("assless",51);
    OutfitAddPartReference("hooker2_pf");
    OutfitAddPartReference("hooker2_s");
    OutfitAddPartReference("hooker2_sk");
    
    //Alex Denton
    BeginNewOutfitL("alex",56);
    OutfitAddPartReference("alex_pf");
    OutfitAddPartReference("alex_s");
    OutfitAddPartReference("alex_sk");

    //========================================================
    //  GFM_TShirtPants
    // SARGE: Now replaced with AMTGFM_TShirtPants
    //========================================================
    
    BeginNewPartsGroup("AMTGFM_TShirtPants","GFM_TShirtPants_Carcass", false, true);
    GroupAddParts(PS_Body_F);
    GroupTranspose(PS_Legs,6);
    GroupTranspose2(PS_Legs_F,PS_Legs,6);
    GroupTranspose(PS_Torso_F,7);
    GroupTranspose2(PS_Mask,PS_Body_F,2,0,-1);
    
    //Defaults
    AddDefaultReference("default_b");
    
    BeginNewOutfitL("anna",38);
    OutfitAddPartReference("anna_p");
    OutfitAddPartReference("anna_s");
    
    BeginNewOutfitL("bum",21);
    OutfitAddPartReference("bum_p");
    OutfitAddPartReference("bum_sf");
    
    BeginNewOutfitL("dentonclone",29);
    OutfitAddPartReference("dentonclone_sf");
    OutfitAddPartReference("dentonclone_pf");
    
    BeginNewOutfitL("tiffany",39);
    OutfitAddPartReference("tiffany_p");
    OutfitAddPartReference("tiffany_s");
    
    BeginNewOutfitL("shea",41);
    OutfitAddPartReference("shea_s");
    OutfitAddPartReference("mib_p");
    
    BeginNewOutfitL("junkie",54);
    OutfitAddPartReference("junkie_s");
    OutfitAddPartReference("junkie_p2");
    
    BeginNewOutfitL("lowclass",60);
    OutfitAddPartReference("lowclass_sf");
    OutfitAddPartReference("lowclass_p");
    
    BeginNewOutfitL("sandrarenton",61);
    OutfitAddPartReference("sandrarenton_s");
    OutfitAddPartReference("mib_p"); //Yes, really!

    //========================================================
    //  GM_ScubaSuit
    //========================================================

    BeginNewPartsGroup("GM_ScubaSuit","GM_ScubaSuit_Carcass", true, true);
    
    //Main Textures
    AddPartLO(PS_Main,33,false,"scuba","none","ScubasuitTex0","ScubasuitTex1","none","none","none","none","none","ScubasuitTex1");

    BeginNewOutfitL("diver",33);
    OutfitAddPartReference("scuba");
    
    //========================================================
    //  GM_DressShirt
    // SARGE: Now replaced with AMTGM_DressShirt
    //========================================================

    BeginNewPartsGroup("AMTGM_DressShirt","GM_DressShirt_Carcass", true, false);
    GroupAddParts(PS_Body_M);
    GroupTranspose(PS_Torso_M,5);
    GroupTranspose(PS_Legs,3);
    GroupTranspose2(PS_Legs_M,PS_Legs,3);
    GroupTranspose(PS_Glasses,6,7);
    GroupTranspose2(PS_Mask,PS_Body_M,-1,4);
    
    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_g");
    
    /*
    //Adam Jensen Outfit
    //TODO: Disabled until a proper Jensen texture is available
    //The textures have multiple Alt versions!
    BeginNewOutfitL("adam",67);
    OutfitAddPartReference("adam_b");
    OutfitAddPartReference("adam_s");
    OutfitAddPartReference("mib_p");
    
    //Adam Jensen Outfit 2
    BeginNewOutfitL("adam",91);
    OutfitAddPartReference("adam_s2");
    OutfitAddPartReference("mib_p");
    */
    
    //Alex Jacobson Outfit
    BeginNewOutfitL("ajacobson",3);
    OutfitAddPartReference("ajacobson_s");
    OutfitAddPartReference("ajacobson_p");
    OutfitAddPartReference("sci_g");
    
    //Bartender Outfit
    BeginNewOutfitL("bartender",63);
    OutfitAddPartReference("paul_p");
    OutfitAddPartReference("bartender_s");
    
    //Boat Person Outfit
    BeginNewOutfitL("boatperson",70);
    OutfitAddPartReference("boatperson_s");
    OutfitAddPartReference("gilbertrenton_p");
    
    //Chad's Outfit
    BeginNewOutfitL("chad",71);
    OutfitAddPartReference("chad_s");
    OutfitAddPartReference("chad_p");
    
    //Cop Outfit
    BeginNewOutfitL("cop",65);
    OutfitAddPartReference("cop_p");
    OutfitAddPartReference("cop_s");
    OutfitAddPartReference("sunglasses2_g");
    
    //Denton Clone
    /*
    BeginNewOutfitL("dentonclone",29);
    OutfitAddPartReference("dentonclone_s");
    OutfitAddPartReference("dentonclone_pf"); //Female legs work for male
    */
    
    //GEP Gun Enjoyer
    BeginNewOutfitL("dentonclone",68);
    OutfitAddPartReference("default_g");
    OutfitAddPartReference("dentonclone_s");
    OutfitAddPartReference("default_p");
    
    //Howard Strong
    BeginNewOutfitL("howardstrong",66);
    OutfitAddPartReference("howardstrong_p");
    OutfitAddPartReference("howardstrong_s");
    OutfitAddPartReference("business_g");
    
    //JoJo Fine
    //Aww, you bad!
    BeginNewOutfitL("jojo",62);
    OutfitAddPartReference("jojo_p");
    OutfitAddPartReference("jojo_s");

    //Thug
    //Beanie Replaces head tex
    BeginNewOutfitL("thug",37);
    OutfitAddPartReference("beanie_b");
    OutfitAddPartReference("thug_p");
    OutfitAddPartReference("thug_s");
    
    //Janitor Outfit
    BeginNewOutfitL("janitor",72);
    OutfitAddPartReference("janitor_s");
    OutfitAddPartReference("janitor_p");
    
    //Joe Greene Outfit
    BeginNewOutfitL("joegreene",53);
    OutfitAddPartReference("joegreene_s");
    OutfitAddPartReference("lab_p");
   
    //Junkie
    BeginNewOutfitL("junkie",54);
    OutfitAddPartReference("junkie_s");
    OutfitAddPartReference("junkie_p");
    
    //Lower Class outfit
    BeginNewOutfitL("lowclass",60);
    OutfitAddPartReference("lowclass_p2");
    OutfitAddPartReference("lowclass_s");
    
    //Morgan Everett
    BeginNewOutfitL("everett",69);
    OutfitAddPartReference("lowclass_p"); //Yep, Everett wears lower class pants :S
    OutfitAddPartReference("everett_s");
    
    //========================================================
    //  GM_DressShirt_B
    // SARGE: Now replaced with GM_DressShirt_BMasked
    //========================================================
    
    BeginNewPartsGroup("GM_DressShirt_BMasked","GM_DressShirt_B_Carcass", true, false);
    GroupAddParts(PS_Torso_M_B);
    GroupTranspose(PS_Body_M,3);
    GroupTranspose(PS_Legs,1);
    GroupTranspose(PS_Helmet,3,4,8,2);
    GroupTranspose(PS_Glasses,5,6);
    GroupTranspose2(PS_Mask,PS_Body_M,3,3,2);
    
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_g");
    AddDefaultReference("nothing_h");
    
    //Thug3
    BeginNewOutfitL("thug3",64);
    OutfitAddPartReference("thug3_p");
    OutfitAddPartReference("thug3_s");
    OutfitAddPartReference("nsf_h");
    OutfitAddPartReference("visor_h");
    
    //Gunther Hermann
    BeginNewOutfitL("gunther",99);
    OutfitAddPartReference("anna_p");
    OutfitAddPartReference("gunther_s");
    
    //========================================================
    //  GM_Suit
    // SARGE: Now replaced with AMTGM_Suit
    //========================================================

    BeginNewPartsGroup("AMTGM_Suit","GM_Suit_Carcass", true, false);
    GroupAddParts(PS_Body_M);
    GroupTranspose(PS_Legs,1);
    GroupTranspose(PS_Glasses,5,6);
    GroupTranspose(PS_Hat,7);
    GroupTranspose2(PS_Mask,PS_Body_M,-1,2);

    //Add Suit-only Torsos because they can't be used on other outfits, and other torsos can't be used here
    AddPartLO(PS_Torso_M,6,false,"businessman1_s",,,,"BusinessMan1Tex1","BusinessMan1Tex1");
    AddPartLO(PS_Torso_M,46,false,"businessman2_s",,,,"BusinessMan2Tex1","BusinessMan2Tex1");
    AddPartLO(PS_Torso_M,7,false,"mib_s",,,,"MIBTex1","MIBTex1");
    AddPartLO(PS_Torso_M,30,false,"president_s",,,,"PhilipMeadTex1","PhilipMeadTex1");
    AddPartLO(PS_Torso_M,11,false,"chef_s",,,,"ChefTex1","ChefTex1");
    AddPartLO(PS_Torso_M,31,false,"sailor_s",,,,"SailorTex1","SailorTex1");
    AddPartLO(PS_Torso_M,47,false,"secretservice_s",,,,"SecretServiceTex1","SecretServiceTex1");
    AddPartLO(PS_Torso_M,57,false,"vp_s",,,,"MichaelHamnerTex1","MichaelHamnerTex1");
    AddPartLO(PS_Torso_M,77,false,"lowclass2_s",,,,"LowerClassMale2Tex1","LowerClassMale2Tex1");
    AddPartLO(PS_Torso_M,78,false,"lumpath_s",,,,"TriadLumPathTex1","TriadLumPathTex1");
    AddPartLO(PS_Torso_M,79,false,"vinny_s",,,,"NathanMadisonTex1","NathanMadisonTex1");
    AddPartLO(PS_Torso_M,80,false,"butler_s",,,,"ButlerTex1","ButlerTex1");
    AddPartLO(PS_Torso_M,81,false,"page_s",,,,"BobPageTex1","BobPageTex1");
    
    //Hat
    //EDIT: These should probably be exclusive to GM_Suit
    AddPartL(PS_Hat,126,true,"chef_h",,,,,,,,"ChefTex3");
    AddPartL(PS_Hat,127,true,"sailor_h","SailorSkin",,,,,,,"SailorTex3");
    AddPartL(PS_Hat,128,true,"ponytail_g",,,,,,,,"PonyTailTex1");
    
    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_g");
    AddDefaultReference("nothing_h");

    //Brown Suit
    BeginNewOutfitL("businessman1",6);
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("businessman1_p");
    OutfitAddPartReference("businessman1_s");
    
    //White Business Suit
    BeginNewOutfitL("businessman2",46);
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("businessman2_p");
    OutfitAddPartReference("businessman2_s");
    
    //Butler Suit
    BeginNewOutfitL("butler",80);
    OutfitAddPartReference("butler_s");
    OutfitAddPartReference("mib_p");
    
    //Lower Class outfit
    BeginNewOutfitL("lowclass2",77);
    OutfitAddPartReference("lowclass2_s");
    OutfitAddPartReference("lowclass2_p");
    
    //MIB Suit
    BeginNewOutfitL("mib",7);
    OutfitAddPartReference("sunglasses_g");
    OutfitAddPartReference("mib_p");
    OutfitAddPartReference("mib_s");
    
    //Luminous Path
    BeginNewOutfitL("lumpath",78);
    OutfitAddPartReference("ponytail_g"); //SARGE: Looks like crap
    OutfitAddPartReference("chef_p");
    OutfitAddPartReference("lumpath_s");
    
    //Presidents Suit (Philip Mead Suit)
    BeginNewOutfitL("meadphilip",30);
    OutfitAddPartReference("sunglasses_g");
    OutfitAddPartReference("mib_p");
    OutfitAddPartReference("president_s");
    
    //Bob Page's Suit
    BeginNewOutfitL("page",81);
    OutfitAddPartReference("page_s");
    OutfitAddPartReference("page_p");
    
    //Chef Outfit
    BeginNewOutfitL("chef",11);
    OutfitAddPartReference("default_g");
    OutfitAddPartReference("chef_p");
    OutfitAddPartReference("chef_s");
    OutfitAddPartReference("chef_h");
    
    //Sailor
    //"Hat" Replaces head tex
    BeginNewOutfitL("sailor",31);
    OutfitAddPartReference("business_g");
    OutfitAddPartReference("sailor_p");
    OutfitAddPartReference("sailor_s");
    OutfitAddPartReference("sailor_h");
    
    //Vinny - Navy Dress Uniform
    BeginNewOutfitL("vinny",79);
    OutfitAddPartReference("vinny_p");
    OutfitAddPartReference("vinny_s");
    
    //Secret Service
    BeginNewOutfitL("secretservice",47);
    OutfitAddPartReference("sunglasses_g");
    OutfitAddPartReference("secretservice_p");
    OutfitAddPartReference("secretservice_s");
    
    //Vice President
    BeginNewOutfitL("vicepresident",57);
    OutfitAddPartReference("vp_p");
    OutfitAddPartReference("vp_s");
    
    //========================================================
    //  GM_Jumpsuit
    // SARGE: Now replaced with AMTMP_Jumpsuit
    //========================================================

    BeginNewPartsGroup("AMTMP_Jumpsuit","GM_Jumpsuit_Carcass", true, false);
    GroupTranspose(PS_Body_M,3);
    GroupTranspose(PS_Legs,1);
    GroupTranspose(PS_Torso_M,2);
    GroupTranspose(PS_Helmet,3,6,8,4,5);
    GroupTranspose2(PS_Mask,PS_Body_M,3,4);
    
    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_h");

    //test
    //AddPartLO(PS_Torso_M,31,false,"sailor_s",,,"SailorTex1");
    
    //Alex Denton
    BeginNewOutfitL("alex",56);
    OutfitAddPartReference("mj12_p");
    OutfitAddPartReference("alex_s");
    
    //Unatco Troop
    BeginNewOutfitL("unatcotroop",8);
    OutfitAddPartReference("unatco_b");
    OutfitAddPartReference("unatco_p");
    OutfitAddPartReference("unatco_s");
    OutfitAddPartReference("unatco_h");
    
    //Mechanic
    BeginNewOutfitL("mechanic",9);
    OutfitAddPartReference("mechanic_p");
    OutfitAddPartReference("mechanic_s");
    OutfitAddPartReference("mechanic_h");
    
    //Soldier
    //Note: Helmet has a custom strap
    BeginNewOutfitL("soldier",17);
    OutfitAddPartReference("soldier_p");
    OutfitAddPartReference("soldier_s");
    OutfitAddPartReference("soldier_h");
    OutfitAddPartReference("soldier_h2");

    //Riot Cop
    BeginNewOutfitL("riotcop",18);
    OutfitAddPartReference("riotcop_p");
    OutfitAddPartReference("riotcop_s");
    OutfitAddPartReference("riotcop_h");
    
    //Hong Kong Police
    BeginNewOutfitL("hkmilitary",75);
    OutfitAddPartReference("hkmilitary_p");
    OutfitAddPartReference("hkmilitary_s");
    
    //Martial Artist
    BeginNewOutfitL("martialartist",73);
    OutfitAddPartReference("martialartist_p");
    OutfitAddPartReference("martialartist_s");
    
    //MJ12
    BeginNewOutfitL("mj12",25);
    OutfitAddPartReference("mj12_p");
    OutfitAddPartReference("mj12_s");
    OutfitAddPartReference("mj12_h");
    
    BeginNewOutfitL("mj12",100);
    OutfitAddPartReference("mj12_p");
    OutfitAddPartReference("mj12_s");
    OutfitAddPartReference("mj12_h2");
    
    //MJ12 Elite
    BeginNewOutfitL("mj122",76);
    OutfitAddPartReference("mj12elite_b");
    OutfitAddPartReference("mj12_p");
    OutfitAddPartReference("mj12_s");
    OutfitAddPartReference("mj12elite_h");

    //NSF Troop
    BeginNewOutfitL("nsf",20);
    OutfitAddPartReference("nsf_b");
    OutfitAddPartReference("nsf_p");
    OutfitAddPartReference("nsf_s");
    OutfitAddPartReference("visor_h");
    OutfitAddPartReference("nsf_h");
    
    //NSF Alt, more equipment/clothing
    BeginNewOutfitL("nsf",43);
    OutfitAddPartReference("nsf_p");
    OutfitAddPartReference("nsf_s");
    
    //Sam Carter Outfit
    BeginNewOutfitL("carter",32);
    OutfitAddPartReference("carter_s");
    OutfitAddPartReference("carter_p");
    
    //Tong
    BeginNewOutfitL("tong",74);
    OutfitAddPartReference("tong_s");
    OutfitAddPartReference("tong_p");
    
    //Prisoner Outfit
    BeginNewOutfitL("prisoner",35);
    OutfitAddPartReference("bald_b");
    OutfitAddPartReference("prisoner_p");
    OutfitAddPartReference("prisoner_s");

    //END
    //CompleteSetup();
}

function ADDNPCHologramOverride(int slot, optional string tex)
{
    local Texture T;

    if (slot > 8 || slot < 0)
        return;

    if (tex == "")
        tex = "PinkMaskTex";

    T = findTexture(tex);

    if (T == None)
        return;

    NPCGroups[currentNPCOutfitGroup].AddOverride(slot,T);
}

function AddNPCOutfitPart(PartSlot part,bool bSkinPart,int slot0, int slot1, int slot2, string tex0, optional string tex1, optional string tex2)
{
    local string slots[9];
    
    if (bIsSetup)
        return;

    if (slot0 >= 0)
        slots[slot0] = tex0;
    if (slot1 >= 0)
        slots[slot1] = tex1;
    if (slot2 >= 0)
        slots[slot2] = tex2;

    _NPCSkin(part,bSkinPart,slots[0],slots[1],slots[2],slots[3],slots[4],slots[5],slots[6],slots[7],slots[8]);
}

function AddNPCFaces(int slot0, int slot1, int slot2, bool bMale, bool generic, bool tactical, bool lowlife, bool triad, bool butler)
{
    if (tactical)
    {
        AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"TerroristTex0","TerroristTex0","TerroristTex0");
        //AddNPCOutfitPart(PS_Body_M,slot0,slot1,slot2,"MJ12EliteTex0","MJ12EliteTex0","MJ12EliteTex0");
        //AddNPCOutfitPart(true,slot0,slot1,slot2,"SecretServiceTex0","SecretServiceTex0","PinkMaskTex");
    }

    if (lowlife)
    {
        if (bMale)
        {
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"BumMaleTex0","BumMaleTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"BumMale2Tex0","BumMale2Tex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"BumMale3Tex0","BumMale3Tex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"JunkieMaleTex0","JunkieMaleTex0","PinkMaskTex");
        }
        else
        {
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"BumFemaleTex0","BumFemaleTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"JunkieFemaleTex0","JunkieFemaleTex0","JunkieFemaleTex0");
        }
    }

    if (generic)
    {
        if (bMale)
        {
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"BartenderTex0","BartenderTex0","PinkMaskTex"); //Also used by Terrorist Commander.  May remove
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"BoatPersonTex0","BoatPersonTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"Businessman2Tex0","Businessman2Tex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"ChefTex0","ChefTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"DoctorTex0","DoctorTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"LowerClassMale2Tex0","LowerClassMale2Tex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"Male1Tex0","Male1Tex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"Male4Tex0NoDots","Male4Tex0NoDots","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"MichaelHamnerTex0","MichaelHamnerTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"MichaelHamnerTex0","MichaelHamnerTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"ScientistMaleTex0","ScientistMaleTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"SkinTex1","SkinTex1","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"SkinTex2","SkinTex2","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"SkinTex3","SkinTex3","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"SkinTex4","SkinTex4","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"ThugMaleTex0","ThugMaleTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"TriadLumPathTex0","TriadLumPathTex0","PinkMaskTex");
            //AddNPCOutfitPart(true,slot0,slot1,slot2,"TriadRedArrowTex0","RedArrowTex0","PinkMaskTex"); //Has a recognisable face tatoo
        }
        else
        {
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"BusinessWoman1Tex0","BusinessWoman1Tex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"Female1Tex0","Female1Tex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"Female2Tex0","Female2Tex0","PinkMaskTex");
            //AddNPCOutfitPart(true,slot0,slot1,slot2,"Female4Tex0","Female4Tex0","PinkMaskTex"); //A bit too distinct
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"Hooker1Tex0","Hooker1Tex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"Hooker2Tex0","Hooker2Tex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"LowerClassFemaleTex0","LowerClassFemaleTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"MaidTex0","MaidTex0","PinkMaskTex");
            //AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"MargaretWilliamsTex0","MargaretWilliamsTex0","PinkMaskTex"); //Completely unused in the vanilla game? //Looks bad on most models
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"NurseTex0","NurseTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"RachelMeadTex0","RachelMeadTex0","PinkMaskTex"); //Completely unused in the vanilla game?
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"SarahMeadTex0","SarahMeadTex0","PinkMaskTex"); //Completely unused in the vanilla game?
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"ScientistFemaleTex0","ScientistFemaleTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"SecretaryTex0","SecretaryTex0","PinkMaskTex");
            AddNPCOutfitPart(PS_Body_F,true,slot0,slot1,slot2,"SkinTex5","SkinTex5","PinkMaskTex");
        }
    }
    if (triad)
    {
        AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"TriadLumPath2Tex0","TriadLumPath2Tex0","PinkMaskTex"); //This has weird hair and shouldn't be used.
    }
    if (butler)
    {
        AddNPCOutfitPart(PS_Body_M,true,slot0,slot1,slot2,"ButlerTex0","ButlerTex0","PinkMaskTex"); //Too old for general use.
    }
}

function AddNPCGlasses(int slot0, int slot1, bool nothing, bool normalGlasses, bool bSunglasses, bool bSilly)
{
    if (nothing)
        AddNPCOutfitPart(PS_Glasses,false,slot0,slot1,-1,"PinkMaskTex","PinkMaskTex"); //Blank Glasses
        
    if (normalGlasses)
    {
        AddNPCOutfitPart(PS_Glasses,false,slot0,slot1,-1,"FramesTex1","LensesTex1");
        AddNPCOutfitPart(PS_Glasses,false,slot0,slot1,-1,"FramesTex1","LensesTex2");
    }

    if (bSunglasses)
    {
        AddNPCOutfitPart(PS_Glasses,false,slot0,slot1,-1,"FramesTex4","LensesTex5");
        AddNPCOutfitPart(PS_Glasses,false,slot0,slot1,-1,"FramesTex2","LensesTex2");
        AddNPCOutfitPart(PS_Glasses,false,slot0,slot1,-1,"FramesTex2","LensesTex3");
    }

    if (bSilly)
        AddNPCOutfitPart(PS_Glasses,false,slot0,slot1,-1,"FramesTex3","BlackMaskTex"); //Red glasses
}

function AddNPCTrenchCoats(bool bMale, bool bFancy, bool bRegular, bool bFilthy)
{
    if (bFancy) //"Upper Class" trench coats.
    {
        _NPCSkin(PS_Trench,false,,"JosephManderleyTex2",,,,"JosephManderleyTex2"); //Joseph Manderley
        _NPCSkin(PS_Trench,false,,"SmugglerTex2",,,,"SmugglerTex2"); //Smugglers Black Suit
    }
    if (bRegular)
    {
        //_NPCSkin(PS_Trench,false,,"PaulDentonTex2",,,,"PaulDentonTex2"); //Paul's Normal Trenchcoat
        //_NPCSkin(PS_Trench,false,,"JCDentonTex2",,,,"JCDentonTex2"); //JC Denton's Coat
        //_NPCSkin(PS_Trench,false,,"MaxChenTex2",,,,"MaxChenTex2"); //Max Chen
        _NPCSkin(PS_Trench,false,,"JuanLebedevTex2",,,,"JuanLebedevTex2"); //Brown Coat
        _NPCSkin(PS_Trench,false,,"TrenchCoatTex1",,,,"TrenchCoatTex1"); //Gray Coat
        _NPCSkin(PS_Trench,false,,"Outfit2F_Tex2",,,,"Outfit2F_Tex2"); //Brown and Gold outfit
        _NPCSkin(PS_Trench,false,,"Outfit4F_Tex2",,,,"Outfit4F_Tex2"); //Matrix outfit
        _NPCSkin(PS_Trench,false,,"Female4Tex2",,,,"Female4Tex2"); //Goth Outfit
        _NPCSkin(PS_Trench,false,,"GilbertRentonTex2",,,,"GilbertRentonTex2");
        _NPCSkin(PS_Trench,false,,"FordSchickTex2",,,,"FordSchickTex2");
        _NPCSkin(PS_Trench,false,,"ThugMale2"); //Thug outfit
    }
    
    if (bFilthy)
    {
        //_NPCSkin(PS_Trench,false,,"HarleyFilbenTex2",,,,"HarleyFilbenTex2");
        _NPCSkin(PS_Trench,false,,"BumMaleTex2",,,,"BumMaleTex2");
        _NPCSkin(PS_Trench,false,,"BumMale2Tex2",,,,"BumMale2Tex2");
        _NPCSkin(PS_Trench,false,,"BumMale3Tex2",,,,"BumMale3Tex2");
    }
}

function AddNPCTrenchShirts(bool bMale, bool bFancy, bool bRegular, bool bTurtlenecks, bool bFilthy, bool bSpecial)
{
    if (bFancy) //"Upper Class" trench shirts.
    {
        _NPCSkin(PS_Trench_Shirt,false,,,,,"WaltonSimonsTex1"); //White Shirt with Black Suit and Black Tie
        _NPCSkin(PS_Trench_Shirt,false,,,,,"DoctorTex1"); //White Shirt with Blue Suit and Red Tie
        _NPCSkin(PS_Trench_Shirt,false,,,,,"JosephManderleyTex1"); //White Shirt with Black Suit and Red Tie
        _NPCSkin(PS_Trench_Shirt,false,,,,,"JaimeReyesTex1"); //Pink Shirt with Black Tie
        _NPCSkin(PS_Trench_Shirt,false,,,,,"GarySavageTex1"); //Blue shirt with tie
        _NPCSkin(PS_Trench_Shirt,false,,,,,"HitmanTex1"); //White shirt with red tie
    }

    if (bRegular)
    {
        _NPCSkin(PS_Trench_Shirt,false,,,,,"GilbertRentonTex1"); //Dirty brown turtleneck
        _NPCSkin(PS_Trench_Shirt,false,,,,,"ThugMaleTex1"); //Punk Rock Shirt
    }

    if (bTurtlenecks)
    {
        _NPCSkin(PS_Trench_Shirt,false,,,,,"TriadRedArrowTex1"); //Blue Turtlenech
        _NPCSkin(PS_Trench_Shirt,false,,,,,"TrenchShirtTex3"); //Yellow zip-up shirt
        //_NPCSkin(PS_Trench_Shirt,false,,,,,"PaulDentonTex1"); //Paul Denton's Turtleneck
        _NPCSkin(PS_Trench_Shirt,false,,,,,"SmugglerTex1"); //Smugglers Trenchcoat
    }

    if (bFilthy)
    {
        _NPCSkin(PS_Trench_Shirt,false,,,,,"TrenchShirtTex1"); //Filthy Bum shirt
        _NPCSkin(PS_Trench_Shirt,false,,,,,"TrenchShirtTex2"); //Filthy Bum shirt
        _NPCSkin(PS_Trench_Shirt,false,,,,,"FordSchickTex1"); //White Shirt
    }

    if (bSpecial)
    {
        _NPCSkin(PS_Trench_Shirt,false,,,,,"Outfit4F_Tex1"); //Matrix Shirt
        _NPCSkin(PS_Trench_Shirt,false,,,,,"JCDentonTex1"); //JCDenton Shirt
        //_NPCSkin(PS_Trench_Shirt,false,,,,,"TobyAtanweTex1"); //Weird techno-shirt??
    }
    
    //_NPCSkin(PS_Trench_Shirt,false,,,,,"TobyAtanweTex1"); //Weird techno-shirt??
    //_NPCSkin(PS_Trench_Shirt,false,,,,,"JuanLebedevTex1"); //NSF Body Armour
    //_NPCSkin(PS_Trench_Shirt,false,,,,,"GordonQuickTex1"); //Bare Chest
    //_NPCSkin(PS_Trench_Shirt,false,,,,,"JockTex1"); //Flight Suit
    //_NPCSkin(PS_Trench_Shirt,false,,,,,"MaxChenTex1"); //Max Chen
    //_NPCSkin(PS_Trench_Shirt,false,,,,,"Outfit4F_Tex1"); //Matrix Shirt
    //_NPCSkin(PS_Trench_Shirt,false,,,,,"JCDentonTex1"); //JCDenton Shirt
    
    //FEMALE
    //_NPCSkin(PS_Trench_Shirt,false,,,,,"Female4Tex1"); //Goth Chest
}

function AddNPCSuitShirts(int slot, int slot2)
{
    AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"BusinessMan1Tex1","BusinessMan1Tex1");
    AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"BusinessMan2Tex1","BusinessMan2Tex1");
    AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"MIBTex1","MIBTex1");
    AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"PhilipMeadTex1","PhilipMeadTex1");
    //AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"ChefTex1","ChefTex1");
    //AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"SailorTex1","SailorTex1");
    AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"SecretServiceTex1","SecretServiceTex1");
    AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"MichaelHamnerTex1","MichaelHamnerTex1");
    AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"LowerClassMale2Tex1","LowerClassMale2Tex1");
    //AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"TriadLumPathTex1","TriadLumPathTex1");
    AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"NathanMadisonTex1","NathanMadisonTex1");
    AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"ButlerTex1","ButlerTex1");
    AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"BobPageTex1","BobPageTex1");
}

function AddNPCShirts(int slot, int slot2, bool bMale, bool bFancy)
{
    if (bMale)
    {
        if (bFancy)
        {
            //SARGE: TODO: Add Male1Tex1, Male2Tex1, and Male3Tex1 shirts and pants to the regular augmentique outfits
            AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"Male1Tex1");
            AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"Male2Tex1");
            AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"Male3Tex1");
            AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"ThugMale2Tex1");
            AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"JoeGreeneTex1");
            AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"BartenderTex1");
            AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"HowardStrongTex1");
            AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"MorganEverettTex1");
        }
        else
        {
            AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"JunkieMaleTex1");
            AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"BoatPersonTex1");
            AddNPCOutfitPart(PS_Torso_M,false,slot,slot2,-1,"LowerClassMaleTex1");
        }
    }
    else
    {
        if (bFancy)
        {
            //SARGE: TODO: Add Female1Tex1, Female2Tex1, and Female3Tex1 shirts and pants to the regular augmentique outfits
            AddNPCOutfitPart(PS_Torso_F,false,slot,slot2,-1,"Female1Tex1");
            //AddNPCOutfitPart(PS_Torso_F,false,slot,slot2,-1,"TiffanySavageTex1");
            AddNPCOutfitPart(PS_Torso_F,false,slot,slot2,-1,"TiffanyGenericTex1");
            AddNPCOutfitPart(PS_Torso_F,false,slot,slot2,-1,"AnnaNavarreGenericTex1");
        }
        else
        {
            //AddNPCOutfitPart(PS_Torso_F,false,slot,-1,-1,"Hooker1Tex3"); //These don't look like bum attire
            //AddNPCOutfitPart(PS_Torso_F,false,slot,-1,-1,"Hooker2Tex3"); //These don't look like bum attire
            AddNPCOutfitPart(PS_Torso_F,false,slot,slot2,-1,"JunkieFemaleTex1");
            AddNPCOutfitPart(PS_Torso_F,false,slot,slot2,-1,"BumFemaleTex1");
            AddNPCOutfitPart(PS_Torso_F,false,slot,slot2,-1,"LowerClassFemaleTex1");
            AddNPCOutfitPart(PS_Torso_F,false,slot,slot2,-1,"SandraRentonTex1");
        }
    }
}

function AddNPCPants(int slot, bool bMale, bool bFancy, bool bRegular, bool bFilthy)
{
    if (bFancy)
    {
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"JCDentonTex3"); //Blue tactical pants
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"PantsTex8"); //Pauls pants
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"Businessman1Tex2"); //Black business pants
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"Businessman2Tex2"); //Black business pants
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"ThugMale2Tex2"); //Black pants with belt
        //AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"PantsTex10"); //Chef pants. Look a little silly!
        //AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"ThugMaleTex3"); //Black pants with chain //DONT USE, they have chains in the pockets which are a bit thuggish.
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"MichaelHamnerTex2"); //Dark-Gray Dress Pants
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"PantsTex5"); //MIB Pants
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"SecretServiceTex2"); //Blue Dress Pants
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"NathanMadisonTex2"); //Navy Dress Pants
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"BobPageTex2"); //Gray Dress Pants
        //AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"SamCarterTex2"); //Military style pants with big boots. Look a little silly on regular people
        //AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"JoJoFineTex2"); //Brown pants with knee pads???
        //AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"HowardStrongTex2"); //Black pants with knee pads???
        //AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"ThugMale3Tex2"); //Black pants with something on the sides??? Has bad stretching. Don't use.
    }
    if (bRegular)
    {
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"PantsTex6"); //Brown casual pants
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"PantsTex2"); //Jeans
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"LowerClass2Male2Tex2"); //Despite being "lower class" thse are quite fancy
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"TriadRedArrowTex3"); //Despite being "lower class" thse are quite fancy
    }
    
    if (bFilthy)
    {
        if (!bMale)
            AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"JunkieFemaleTex2"); //Junkie jeans

        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"PantsTex3"); //Dirty Jeans
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"PantsTex4"); //Ripped jeans
        //AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"ChadTex2"); //Has a weird middle section?
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"PantsTex7"); //Soiled brown pants
        AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"JunkieMale2Tex2"); //Soiled brown pants
    }
        //AddNPCOutfitPart(PS_Legs,false,slot,-1,-1,"GordonQuickTex3"); //Fancy pants with a dragon on them
}

function AddNPCSkirts(int slot0, int slot1)
{
    AddNPCOutfitPart(PS_Legs_F,false,slot0,slot1,-1,"WIBTex1","WIBTex1"); //WIB Dress
    //AddNPCOutfitPart(PS_Legs_F,false,slot0,slot1,-1,"MaggieChowTex1","MaggieChowTex1"); //Maggies Dress
    AddNPCOutfitPart(PS_Legs_F,false,slot0,slot1,-1,"MargaretWilliamsTex1","MargaretWilliamsTex1"); //Fancy blue dress
    AddNPCOutfitPart(PS_Legs_F,false,slot0,slot1,-1,"RachaelMeadTex1","RachaelMeadTex1"); //Bright Orange outfit
    AddNPCOutfitPart(PS_Legs_F,false,slot0,slot1,-1,"BusinessWoman1Tex1","BusinessWoman1Tex1");
    AddNPCOutfitPart(PS_Legs_F,false,slot0,slot1,-1,"SecretaryTex2","SecretaryTex2");
    AddNPCOutfitPart(PS_Legs_F,false,slot0,slot1,-1,"Female2Tex2","Female2Tex2");
    AddNPCOutfitPart(PS_Legs_F,false,slot0,slot1,-1,"Female3Tex1","Female3Tex1");
}

function AddNPCDressLegs(int slot0)
{
    AddNPCOutfitPart(PS_DressLegs,false,slot0,-1,-1,"LegsTex1"); //Brown stockings and high heels
    AddNPCOutfitPart(PS_DressLegs,false,slot0,-1,-1,"LegsTex2"); //Dark Stockings
    AddNPCOutfitPart(PS_DressLegs,false,slot0,-1,-1,"Hooker1Tex1"); //Bare legs with brown shoes
    AddNPCOutfitPart(PS_DressLegs,false,slot0,-1,-1,"Hooker2Tex1"); //Dark black stockings with heels
    //AddNPCOutfitPart(PS_DressLegs,false,slot0,-1,-1,"Outfit5F_Tex1"); //Alex Denton legs
    AddNPCOutfitPart(PS_DressLegs,false,slot0,-1,-1,"RachelMeadTex2"); //Brown legs with bright red shoes
    AddNPCOutfitPart(PS_DressLegs,false,slot0,-1,-1,"BusinessWoman1Tex2"); //Brown legs with heels
    //AddNPCOutfitPart(PS_DressLegs,false,slot0,-1,-1,"NicoletteDuClareTex3");
    AddNPCOutfitPart(PS_DressLegs,false,slot0,-1,-1,"SarahMeadTex3"); //Long socks with heels
    AddNPCOutfitPart(PS_DressLegs,false,slot0,-1,-1,"Female2Tex1");
    AddNPCOutfitPart(PS_DressLegs,false,slot0,-1,-1,"Female3Tex2");
}

function PopulateNPCOutfitsList()
{

    ////FACES

    ////GLASSES

    //Glasses, but not sunglasses
    BeginNPCOutfitGroup();
    AddNPCGroupClass("JaniceReed",true); //Now we can use BindNames too!!
    AddNPCGroupClass("Shannon",true); //Now we can use BindNames too!!
    AddNPCGroupClass("DeusEx.Secretary");
    AddNPCGroupClass("DeusEx.BusinessWoman1");
    AddNPCGroupClass("DeusEx.Nurse");
    AddNPCGroupClass("DeusEx.AlexJacobson");
    AddNPCGroupClass("DeusEx.ScientistFemale");
    AddNPCGroupClass("DeusEx.Female2");
    AddNPCGroupClass("DeusEx.Female3");
    AddNPCGroupClass("DeusEx.JoeGreene",true);
    AddNPCGlasses(6,7,true,true,false,false);
    
    //Glasses, including sunglasses
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.Cop");
    AddNPCGlasses(6,7,true,true,true,false);

    //Sunglasses only
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.ThugMale2");
    AddNPCGlasses(6,7,true,false,true,false);

    //////////////////////////////////////////////////////////
    //                  ---GM_Trench---
    //////////////////////////////////////////////////////////
    
    ////FACES
    
    //Regular Faces
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.Doctor");
    AddNPCGroupClass("DeusEx.ScientistMale");
    AddNPCGroupClass("DeusEx.ThugMale");
    AddNPCGroupClass("DeusEx.TriadRedArrow");
    AddNPCFaces(0,3,-1,true,true,false,false,false,true);

    //Bum Faces
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.BumMale");
    AddNPCGroupClass("DeusEx.BumMale2");
    AddNPCGroupClass("DeusEx.BumMale3");
    AddNPCGroupException("Curly");
    AddNPCGroupException("CharlieFann");
    AddNPCGroupException("ParkBum1");
    AddNPCFaces(0,3,-1,true,true,false,true,false,true);

    ////GLASSES
    
    //Regular Glasses, no sunglasses
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.GilbertRenton",true);
    AddNPCGroupClass("DeusEx.HarleyFilben",true);
    AddNPCGroupClass("DeusEx.JosephManderley",true);
    AddNPCGroupClass("DeusEx.GarySavage",true);
    AddNPCGroupClass("DeusEx.FordSchick",true);
    AddNPCGroupClass("DeusEx.Doctor");
    AddNPCGroupClass("DeusEx.ScientistMale");
    AddNPCGlasses(6,7,true,true,false,false);
    AddNPCHologramOverride(6);
    AddNPCHologramOverride(7);
    
    //Sunglasses only
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.StantonDowd",true);
    AddNPCGroupClass("DeusEx.Jock",true);
    AddNPCGroupClass("DeusEx.WaltonSimons",true);
    AddNPCGroupClass("DeusEx.PaulDenton",true);
    AddNPCGroupClass("DeusEx.ThugMale");
    AddNPCGroupClass("DeusEx.TriadRedArrow");
    AddNPCGlasses(6,7,true,false,true,false);
    AddNPCHologramOverride(6);
    AddNPCHologramOverride(7);
    
    //Sunglasses and silly glasses
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.GordonQuick",true);
    AddNPCGroupClass("DeusEx.MaxChen",true);
    AddNPCGroupClass("DeusEx.Smuggler",true);
    AddNPCGroupClass("DeusEx.TerroristCommander",true);
    AddNPCGlasses(6,7,true,false,true,true);
    AddNPCHologramOverride(6);
    AddNPCHologramOverride(7);
    
    //upper class/fancy
    /*
    BeginNPCOutfitGroup();
    AddNPCTrenchCoats(true,true,false,false);
    AddNPCTrenchShirts(true,false,false,false);
    AddNPCPants(2, true, false, false);
    */
    
    //bum attire
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.BumMale");
    AddNPCGroupClass("DeusEx.BumMale2");
    AddNPCGroupClass("DeusEx.BumMale3");
    //AddNPCGroupException("Curly");
    //AddNPCGroupException("CharlieFann");
    //AddNPCGroupException("ParkBum1");
    AddNPCTrenchCoats(true,false,false,true);
    AddNPCTrenchShirts(true,false,false,false,true,false);
    AddNPCPants(2, true, false, false, true);
    
    //Juan Lebedev and the NSF Commander have a random trenchcoat, but keep their normal
    //gear otherwise.
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.TerroristCommander",true);
    AddNPCGroupClass("DeusEx.JuanLebedev",true);
    AddNPCTrenchCoats(true,false,true,false);
    //AddNPCPants(2, true, true, true, true);
    
    ////SPECIAL CASES
    
    ////Some important NPCs keep their signature trenchcoats,
    ////but everything else is randomised.

    //UPPER CLASS MALES
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.JosephManderley",true);
    AddNPCGroupClass("DeusEx.JaimeReyes",true);
    AddNPCGroupClass("DeusEx.Doctor");
    AddNPCGroupClass("DeusEx.ScientistMale");
    AddNPCTrenchShirts(true,true,false,false,false,false);
    AddNPCPants(2, true, true, false, false);

    //REGULAR MALES
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.StantonDowd",true);
    AddNPCGroupClass("DeusEx.PaulDenton",true);
    AddNPCGroupClass("DeusEx.Smuggler",true);
    AddNPCTrenchShirts(true,false,true,true,false,true);
    AddNPCPants(2, true, true, true, false);
    
    //BUM MALES
    BeginNPCOutfitGroup();
    AddNPCGroupClass("Curly",true);
    AddNPCGroupClass("CharlieFann",true);
    AddNPCGroupClass("DeusEx.GilbertRenton",true);
    AddNPCGroupClass("DeusEx.FordSchick",true);
    AddNPCGroupClass("DeusEx.HarleyFilben",true);
    AddNPCTrenchShirts(true,false,false,false,true,false);
    AddNPCPants(2, true, false, false, true);
    
    //////////////////////////////////////////////////////////
    //                  ---GFM_Trench---
    //////////////////////////////////////////////////////////
    
    //There's only one. ScientistFemale
    //Keep the lab coat, but everything else can change
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.ScientistFemale");
    AddNPCFaces(0,3,-1,false,true,false,false,false,false);
    AddNPCGlasses(6,7,true,true,false,false);
    //AddNPCTrenchShirts(false,true,false,true,false,false);
    //AddNPCPants(2, false, true, false, false);
    
    //////////////////////////////////////////////////////////
    //               ---GFM_TShirtPants---
    //////////////////////////////////////////////////////////
    
    //Glasses, but not sunglasses
    //BeginNPCOutfitGroup();
    //AddNPCGroupClass("DeusEx.Female1");
    //AddNPCGlasses(6,7,true,true,false,false);
    
    //nice attire
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.Female1");
    AddNPCFaces(0,1,2,false,true,false,false,false,false);
    AddNPCShirts(7,-1, false, true);
    AddNPCPants(6, false, false, true, false);

    //bum attire
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.SandraRenton",true);
    AddNPCGroupClass("ParkBumFemale2",true); //Woman in Battery Park
    AddNPCGroupClass("DeusEx.BumFemale");
    AddNPCGroupClass("DeusEx.LowerClassFemale");
    AddNPCGroupClass("DeusEx.JunkieFemale");
    AddNPCFaces(0,1,2,false,true,false,true,false,false);
    AddNPCShirts(7,-1, false, false);
    AddNPCPants(6, false, false, false, true);

    ////SPECIAL CASES
   
    //Some NPCs simply change pants and keep everything else the same
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.JordanShea",true);
    AddNPCPants(6, false, true, false, false);
    
    //////////////////////////////////////////////////////////
    //               ---GM_Suit---
    //////////////////////////////////////////////////////////
    
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.BusinessMan1");
    AddNPCGroupClass("DeusEx.BusinessMan2");
    AddNPCGroupClass("DeusEx.BusinessMan3");
    AddNPCGroupClass("DeusEx.MichaelHamner"); //Antoine actually! (the guy who sells Biocells in the Paris Club)
    AddNPCGroupClass("DeusEx.Butler");
    AddNPCGroupException("Supervisor01"); //Mr Hundly
    //AddNPCGroupClass("DeusEx.Chef");
    //AddNPCGroupClass("DeusEx.MIB");
    AddNPCGroupClass("DeusEx.LowerClassMale2");
    AddNPCFaces(0,2,-1,true,true,false,false,false,true);
    AddNPCGlasses(5,6,true,true,false,false);
    //AddNPCSuitShirts(3,4);
    //AddNPCPants(1,true,true,true,false);

    //Instead of adding shirts and pants separately, instead, create proper outfits
    //consisting of both suits and pants.
    AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"BusinessMan1Tex2","BusinessMan1Tex1","BusinessMan1Tex1");
    AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"BusinessMan2Tex2","BusinessMan2Tex1","BusinessMan2Tex1");
    AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"PantsTex5","MIBTex1","MIBTex1");
    AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"PantsTex5","PhilipMeadTex1","PhilipMeadTex1");
    //AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"ChefTex2","ChefTex1","ChefTex1");
    //AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"SailorTex2","SailorTex1","SailorTex1");
    AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"SecretServiceTex2","SecretServiceTex1","SecretServiceTex1");
    AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"MichaelHamnerTex2","MichaelHamnerTex1","MichaelHamnerTex1");
    AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"LowerClassMale2Tex2","LowerClassMale2Tex1","LowerClassMale2Tex1");
    //AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"TriadLumPathTex2","TriadLumPathTex1","TriadLumPathTex1");
    //AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"NathanMadisonTex2","NathanMadisonTex1","NathanMadisonTex1");
    AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"PantsTex5","ButlerTex1","ButlerTex1");
    //AddNPCOutfitPart(PS_Torso_M,false,1,3,4,"BobPageTex2","BobPageTex1","BobPageTex1"); //Might keep this for bobby page

    ////Special Cases

    //Sailors keep their uniforms, but can have any face, including the faces with a hat
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.Sailor");
    AddNPCFaces(0,2,7,true,true,false,false,false,true);
    AddNPCOutfitPart(PS_Body_M,true,0,2,7,"SailorTex0","SailorTex0","SailorTex3");
    
    //Some people keep their outfits, only randomise their faces.
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.Chef");
    AddNPCFaces(0,2,-1,true,true,false,false,false,true);

    //Triad LumPath are the same, except no old-man butler faces
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.TriadLumPath");
    AddNPCGroupClass("DeusEx.TriadLumPath2");
    AddNPCFaces(0,2,-1,true,true,false,false,false,false);

    //////////////////////////////////////////////////////////
    //               ---GM_DressShirt---
    //////////////////////////////////////////////////////////

    
    ///FACES - Normal Male - GM_DressShirt
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.Male1");
    AddNPCGroupClass("DeusEx.Male2");
    AddNPCGroupClass("DeusEx.Male3");
    AddNPCGroupClass("DeusEx.Bartender");
    AddNPCGroupClass("DeusEx.LowerClassMale");
    AddNPCGroupClass("DeusEx.BoatPerson");
    AddNPCFaces(0,4,-1,true,false,false,true,false,true);

    ///FACES - Bum Male - GM_DressShirt
    BeginNPCOutfitGroup();
    AddNPCGroupClass("SickMan",true); //Battery Park Sick Man (somebody kill me! Anybody!)
    AddNPCGroupClass("DeusEx.JunkieMale");
    AddNPCGroupClass("DeusEx.Bartender");
    AddNPCGroupException("Lenny");
    AddNPCFaces(0,4,-1,true,false,false,true,false,true);

    ///REGULAR MALES
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.Male1");
    AddNPCGroupClass("DeusEx.Male2");
    AddNPCGroupClass("DeusEx.Male3");
    AddNPCGroupClass("DeusEx.Bartender");
    AddNPCGroupClass("DeusEx.LowerClassMale");
    AddNPCGlasses(6, 7, true, true, false, false);
    AddNPCShirts(5,-1, true, true);
    AddNPCPants(3, true, false, true, false);
    
    ///Bums
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.JunkieMale");
    AddNPCGroupClass("DeusEx.BoatPerson");
    AddNPCGlasses(6,7, true, true, false, false);
    AddNPCShirts(5, -1, true, false);
    AddNPCPants(3, true, false, true, false);
    
    //////////////////////////////////////////////////////////
    //               ---GFM_Dress---
    //////////////////////////////////////////////////////////
    
    //Keep the school girl outfit, but swap the face.
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.SarahMead");
    AddNPCFaces(6,7,0,false,true,false,false,false,false);


    //////////////////////////////////////////////////////////
    //               ---GFM_SuitSkirt---
    //////////////////////////////////////////////////////////

    //Most business-women and secretaries and etc will wear standard dresses
    BeginNPCOutfitGroup();
    AddNPCGroupClass("JaniceReed",true); //Now we can use BindNames too!!
    AddNPCGroupClass("Shannon",true); //Now we can use BindNames too!!
    AddNPCGroupClass("DeusEx.Secretary");
    AddNPCGroupClass("DeusEx.BusinessWoman1");
    AddNPCGroupClass("DeusEx.Female2");
    AddNPCGroupClass("DeusEx.Female3");
    AddNPCFaces(0,1,2,false,true,false,false,false,false);
    AddNPCSkirts(4,5);
    AddNPCDressLegs(3);
    
    ////Special Cases

    //Nurses keep their nurse outfit, but change everything else
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.Nurse");
    AddNPCFaces(0,1,2,false,true,false,false,false,false);
    AddNPCDressLegs(3);

    //////////////////////////////////////////////////////////
    //                  ---SPECIAL CASES---
    //////////////////////////////////////////////////////////

    //Cops can have regular faces or the cop face, but should otherwise stay in uniform
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.Cop");
    AddNPCFaces(0,4,-1,true,true,false,false,false,true);
    //Add special cop helmets.
    AddNPCOutfitPart(PS_Hack,true,2,-1,-1,"PinkMaskTex"); //Empty head slot hack.
    AddNPCOutfitPart(PS_Body_M,true,0,2,4,"CopTex0","CopTex0","CopTex0");
    

    //Mechanics can have a helmet, or nothing, and may or may not have a mask on.
    //But keep their uniform as is.
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.Mechanic");
    AddNPCFaces(0,3,4,true,true,false,false,false,true);
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"PinkMaskTex"); //Nothing
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"MechanicTex3"); //Mechanic Helmet
    AddNPCOutfitPart(PS_Helmet,true,6,3,4,"MechanicTex3","MiscTex1","MiscTex1"); //Mechanic Helmet with FaceMask

    //Terrorists have special face gear,
    //but otherwise keep their uniforms as is
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.Terrorist");
    AddNPCGroupException("TerroristLeader"); //Mole People terrorist commander
    AddNPCGroupException("Miguel");
    AddNPCFaces(0,3,4,true,true,false,false,false,false);
    //Add in a few extra nothings to reduce the chances of having them always in tactical gear.
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"PinkMaskTex"); //Nothing
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"PinkMaskTex"); //Nothing
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"PinkMaskTex"); //Nothing
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"PinkMaskTex","TerroristTex0","TerroristTex0"); //Tactical Gear
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"GogglesTex1","TerroristTex0","TerroristTex0"); //Goggles
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"ThugMale3Tex3","TerroristTex0","TerroristTex0"); //Goggles (Red)
    //AddNPCOutfitPart(PS_Helmet,false,6,3,4,"MechanicTex3"); //Mechanic Helm
    //AddNPCOutfitPart(PS_Helmet,false,6,3,4,"MechanicTex3","MiscTex3","MiscTex3"); //Mechanic Helm with Face Mask
    //AddNPCOutfitPart(PS_Helmet,false,6,3,4,"SoldierTex3"); //Soldier Helm
    //AddNPCOutfitPart(PS_Helmet,false,6,3,4,"SoldierTex3","MiscTex3","MiscTex3"); //Soldier Helm with Face Mask
    
    //Miguel and the Mole People terrorist can only change their visors, nothing else
    BeginNPCOutfitGroup();
    AddNPCGroupClass("Miguel",true);
    AddNPCGroupClass("TerroristLeader");
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"PinkMaskTex","TerroristTex0","TerroristTex0"); //Tactical Gear
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"GogglesTex1","TerroristTex0","TerroristTex0"); //Goggles
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"ThugMale3Tex3","TerroristTex0","TerroristTex0"); //Goggles (Red)
    
    //Unatco Troops have special face gear
    //but otherwise keep their uniforms as is
    BeginNPCOutfitGroup();
    AddNPCGroupClass("Scott",true);
    AddNPCGroupClass("DeusEx.UNATCOTroop");
    AddNPCFaces(0,3,4,true,true,true,false,false,false);
    //AddNPCOutfitPart(PS_Helmet,false,6,3,4,"PinkMaskTex"); //Nothing
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"UnatcoTroopTex3"); //Unatco Helm
    AddNPCOutfitPart(PS_Helmet,false,6,3,4,"UnatcoTroopTex3","MiscTex3","MiscTex3"); //Unatco Helm with Face Mask
    
    //Unatco Troop Carcass with no helmet. Only randomise the face
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.UNATCOTroopCarcassDehelm",,true);
    AddNPCFaces(0,3,4,true,true,true,false,false,false);
    AddNPCOutfitPart(PS_Body_M,false,3,4,-1,"MiscTex3","MiscTex3"); //Face Mask
    
    //Thugs have special faces, since they can have a beanie
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.ThugMale2");
    AddNPCFaces(0,4,-1,true,true,true,false,false,false);
    AddNPCOutfitPart(PS_Body_M,true,0,4,-1,"ThugMale2Tex0","ThugMale2Tex0"); //Beanie
    
    //MJ12 Troops simply change faces. No special tactical gear as they will look too much like elites.
    //And now others too
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DeusEx.MJ12Troop");
    AddNPCGroupClass("DeusEx.HKMilitary");
    AddNPCGroupClass("DeusEx.Soldier");
    AddNPCFaces(0,3,4,true,true,false,false,false,false);
    
    //Rock keeps everything except his visor, which can be swapped out
    BeginNPCOutfitGroup();
    AddNPCGroupClass("DrugDealer",true);
    AddNPCOutfitPart(PS_Helmet,false,4,-1,-1,"PinkMaskTex"); //Nothing
    AddNPCOutfitPart(PS_Helmet,false,4,-1,-1,"GogglesTex1"); //Goggles (Yellow)
    AddNPCOutfitPart(PS_Helmet,false,4,-1,-1,"ThugMale3Tex3"); //Goggles (Red)
    
    //Thugs keeps their uniform, but have unique faces
    BeginNPCOutfitGroup();
    AddNPCGroupClass("ThugMale3");
    AddNPCGroupException("Jughead"); //El Ray
    AddNPCFaces(2,3,-1,true,true,true,false,false,false);

    //There are only 2 children and they share the same model...
    BeginNPCOutfitGroup();
    AddNPCGroupClass("Billy",true);
    AddNPCGroupClass("DeusEx.ChildMale");
    AddNPCGroupClass("DeusEx.ChildMale2");
    AddNPCOutfitPart(PS_Body_M,true,0,3,4,"ChildMaleTex0","ChildMaleTex0","PinkMaskTex");
    AddNPCOutfitPart(PS_Body_M,true,0,3,4,"ChildMale2Tex0","ChildMale2Tex0","ChildMale2Tex0");
    AddNPCOutfitPart(PS_Torso_M,false,1,5,-1,"ChildMaleTex1","ChildMaleTex1");
    AddNPCOutfitPart(PS_Torso_M,false,1,5,-1,"ChildMale2Tex1","ChildMale2Tex1");
    AddNPCPants(2, true, false, true, true);
}

//Add a reference that will be added to all outfits for this particular parts group
function AddDefaultReference(string defRef)
{
    
    if (bIsSetup)
        return;

    currentPartsGroup.AddDefaultReference(defRef);
}

function BeginNPCOutfitGroup()
{
    local NPCOutfitGroup G;

    if (bIsSetup)
        return;

    G = new(Self) class'NPCOutfitGroup';

    NPCGroups[numNPCOutfitGroups] = G;
    currentNPCOutfitGroup = numNPCOutfitGroups;
    numNPCOutfitGroups++;
}

function AddNPCGroupException(string classname)
{
    NPCGroups[currentNPCOutfitGroup].AddExceptedClass(classname);
}

function AddNPCGroupClass(string classname, optional bool bUniqueNPC, optional bool bNoCarcass)
{
    local int seeds[30];
    local int i;

    if (bIsSetup)
        return;

    for (i = 0;i < ArrayCount(seeds);i++)
    {
        if (bUniqueNPC)
        {
            seeds[i] = randomTable[iCurrentRand++];
            if (iCurrentRand >= ArrayCount(randomTable))
                iCurrentRand = 0;
        }
        else
            seeds[i] = -1;
    }
    
    NPCGroups[currentNPCOutfitGroup].AddClass(classname,bUniqueNPC,bNoCarcass,seeds);
}

function _NPCSkin(PartSlot part,bool bSkinPart, optional string t0, optional string t1, optional string t2, optional string t3, optional string t4, optional string t5, optional string t6, optional string t7, optional string tm)
{

    if (bIsSetup)
        return;

    NPCGroups[currentNPCOutfitGroup].AddPart(part,bSkinPart,findNPCTexture(t0),findNPCTexture(t1),findNPCTexture(t2),findNPCTexture(t3),findNPCTexture(t4),findNPCTexture(t5),findNPCTexture(t6),findNPCTexture(t7),findNPCTexture(tm));
}

function BeginNewPartsGroup(string mesh, string carcassMesh, bool allowMale, bool allowFemale)
{
    local Mesh M, CM;
    local PartsGroup G;

    if (bIsSetup)
        return;

    M = findMesh(mesh);
    CM = findMesh(carcassMesh);

    //Not a valid mesh, or we already have it.
    if (M == None || GetPartsGroup(mesh))
        return;
    
    G = new(Self) class'PartsGroup';
    G.mesh = M;
    G.carcassMesh = CM;
    G.allowMale = allowMale;
    G.allowFemale = allowFemale;
    G.player = player;

    Groups[numPartsGroups] = G;
    currentPartsGroup = G;
    numPartsGroups++;
}

function bool GetPartsGroup(string mesh)
{
    local int i;
    local Mesh M;

    if (bIsSetup)
        return false;

    M = findMesh(mesh);

    //If we find a group with this mesh already set, use it.
    for (i = 0;i < numPartsGroups;i++)
    {
        if (M == Groups[i].mesh)
        {
            currentPartsGroup = Groups[i];
            return true;
        }
    }

    return false;
}

//Localised version of BeginNewOutfit.
//Only used internally
//Works exactly the same way as BeginOutfit, but automatically looks up the default names/descriptions list
//at the bottom of this file
function BeginNewOutfitL(string id, int nameIndex)
{
    local string n,d,h,p,m,a;

    n = outfitInfos[nameIndex].Name;
    d = outfitInfos[nameIndex].Desc;
    h = outfitInfos[nameIndex].HighlightName;
    p = outfitInfos[nameIndex].PickupName;
    m = outfitInfos[nameIndex].PickupMessage;
    a = outfitInfos[nameIndex].Article;

    BeginNewOutfit(id,n,d,h,p,m,a);
}

function BeginNewOutfit(string id, string name, optional string desc, optional string highlightName, optional string pickupName, optional string pickupMessage, optional string pickupArticle)
{
    local Outfit O;
    local int i;

    if (bIsSetup)
        return;

    O = new(Self) class'Outfit';

    O.id = id;
    O.index = numOutfits;
    O.name = name;
    O.desc = desc;

    if (highlightName == "")
        highlightName = name;

    if (pickupName == "")
        pickupName = name;

    if (pickupArticle == "")
        pickupArticle = "a";
    
    if (pickupArticle == "-") //Hack for "no" article
        pickupArticle = "";

    if (pickupMessage == "" && pickupArticle != "")
        pickupMessage = DefaultPickupMessage;
    else if (pickupMessage == "")
        pickupMessage = DefaultPickupMessage;

    O.PickupMessage = pickupMessage;
    O.PickupName = pickupName;
    O.PickupArticle = pickupArticle;
    O.HighlightName = highlightName;

    O.partsGroup = currentPartsGroup;
    O.player = player;

    outfits[numOutfits++] = O;
    currOutfit = O;

    //Dirty Hack
    //Add default references
    for (i = 0;i < currentPartsGroup.defaultPartsNum;i++)
        OutfitAddPartReference(currentPartsGroup.defaultParts[i]);
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
    local Name flag;
    local int i;

    if (outfits[index].index == currOutfit.index)
        return;

    //Set Flags
    if (player != None && player.rootWindow != None)
    {
        //Set flag for new outfit
        flag = player.rootWindow.StringToName("JCOutfits_Equipped_" $ outfits[index].id);
        Player.FlagBase.SetBool(flag,true,true,0);
        
        //Set flag for old outfit
        flag = player.rootWindow.StringToName("JCOutfits_Equipped_" $ currOutfit.id);
        Player.FlagBase.DeleteFlag(flag,FLAG_Bool);
    }

    //Set the outfit as no longer new
    outfits[index].bNew = false;

    currOutfit = outfits[index];
    savedOutfitIndex = index;

    //If debug mode is on, print the outfit parts to the log file
    if (bDebugMode)
    {
        Log("Augmentique: Equipping outfit " $ currOutfit.Name);
        for (i = 0;i < currOutfit.numParts;i++)
            Log("   Outfit Part: " $ currOutfit.parts[i].name $ " with id " $ currOutfit.parts[i].partId);
    }

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
        if (outfits[i] != None && outfits[i].id == id && IsCorrectGender(i))
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

    //SARGE: Remove this before release!
    if (bDebugMode)
        return true;

    for (i = 0;i < 255 && unlockedOutfits[i] != "";i++)
    {
        if (unlockedOutfits[i] == id)
            return true;
    }
    return false;
}

//Copies over any globally unlocked outfits to the current unlocked outfits list.
//since they are available in all playthroughs
function CopyOverUnlockedOutfits()
{
    local int i;
    
    for (i = 0;i<255;i++)
    {
        if (player.unlockedOutfits[i] != "")
        {
            Unlock(player.unlockedOutfits[i]);
        }
    }
}

//Copies over any unlocked outfits to the global unlocked outfits list.
//Which makes them available in all playthroughs.
//Called when we finish the game
function CopyOutfitsToPlayer()
{
    local int i;
        
    //Log("Copying over outfits:");
    
    //We should already have all the previously unlocked global outfits.
    //So just copy the entire list over
    for (i = 0;i<255;i++)
    {
        //Log("Copying over outfit " $ i $ ":" @ unlockedOutfits[i]);
        player.unlockedOutfits[i] = unlockedOutfits[i];
    }

    player.SaveConfig();
}

function bool IsCorrectGender(int index)
{
    if (index < numOutfits && outfits[index].partsGroup != None)
        return outfits[index].partsGroup.IsCorrectGender();
    return false;
}

function bool IsEquippable(int index)
{
    if (index >= numOutfits)
        return false;
    
    return outfits[index] != None && outfits[index].unlocked && IsCorrectGender(index);
}

function bool IsUnlockedAt(int index)
{
    if (index >= numOutfits)
        return false;
    return outfits[index].unlocked;
}

function Unlock(string id, optional bool bPrintMessage)
{
    local int i;
    if (!IsUnlocked(id))
    {
        //find the first empty spot to put it in
        for (i = 0;i<255;i++)
        {
            if (unlockedOutfits[i] == "")
            {
                //player.ClientMessage("Unlocking " $ id);
                unlockedOutfits[i] = id;
                //player.SaveConfig();
                break;
            }
        }

        //Unlock any outfits matching this ID
        for (i = 1;i<numOutfits;i++)
        {
            if (outfits[i] != None && outfits[i].id == id)
            {
                if (bPrintMessage)
                    player.ClientMessage(sprintf(MsgOutfitUnlocked,outfits[i].name));

                outfits[i].SetUnlocked();
            }
        }
    }
}

function CompleteSetup()
{
    local int i;

    if (bIsSetup)
        return;

    //Set unlocked on all outfits which are unlocked
    Unlock("default");
    for (i = 1;i<numOutfits;i++)
    {
        if (outfits[i] == None)
            continue;

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
            if (outfits[i] != None && outfits[i].id == "default" && IsEquippable(i))
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

    //New 1.1 feature!
    ApplyNPCOutfits();

    bIsSetup = true;
}

function ApplyCurrentOutfit()
{
	local JCDentonMaleCarcass jcCarcass;
	local JCDouble jc;

    if (player == None)
        return;

    //player.ClientMessage("ApplyCurrentOutfit");
    ApplyCurrentOutfitToActor(player);
    
    //Also apply to JC Carcasses and JCDoubles
	// JC Denton Carcass
	foreach player.AllActors(class'JCDentonMaleCarcass', jcCarcass)
    {
        if (jcCarcass != None)
            ApplyCurrentOutfitToActor(jcCarcass);
    }

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

    if (currOutfit != None)
        currOutfit.ApplyOutfitToActor(A,!noAccessories);
}

function Mesh findMesh(string mesh)
{
    local Mesh m;
    m = Mesh(DynamicLoadObject("Augmentique."$mesh, class'Mesh', true));

    if (m == None)
        m = Mesh(DynamicLoadObject(mesh, class'Mesh', true));
    
    if (m == None)
        m = Mesh(DynamicLoadObject("DeusExCharacters."$mesh, class'Mesh', true));
    
    if (m == None)
        m = Mesh(DynamicLoadObject("FemJC."$mesh, class'Mesh', true));

    return m;
}

function Texture findNPCTexture(string tex)
{
    local Texture t;
    
    if (tex == "none" || tex == "")
        return None;
    
    //look in Deus Ex textures first so we don't get skin variants
    if (t == None)
        t = Texture(DynamicLoadObject("DeusExCharacters.Skins."$tex, class'Texture', true));

    if (t == None)
        t = Texture(DynamicLoadObject("DeusExItems.Skins."$tex, class'Texture', true));
    
    //Fallback to looking in Augmentique Textures
    if (t == None)
        t = Texture(DynamicLoadObject("Augmentique."$tex, class'Texture', true));

    return t;
}

function Texture findTexture(string tex)
{
    local Texture t;
    
    if (tex == "skin") //Special keyword to make our skin texture appear in different slots
        return player.multiSkins[0];
    else if (tex == "none" || tex == "")
        //return Texture'DeusExItems.Skins.PinkMaskTex';
        return None;
    
    //Find a texture in Augmentique.u, to allow overriding skins from DX and other mods
    t = Texture(DynamicLoadObject("Augmentique."$tex$"_S"$player.PlayerSkin, class'Texture', true));

    if (t == None)
        t = Texture(DynamicLoadObject("Augmentique."$tex, class'Texture', true));

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

    if (t == None)
        DebugLog("findTexture: Texture " $ tex $ " not found!");

    return t;
}

function bool ValidateSpawn(string id)
{
    local int index;

    index = GetOutfitIndexByID(id);

    return index > 0 && !outfits[index].unlocked;
}

//Allow re-doing the NPC outfits so that we can test things
function RedoNPCOutfits()
{
    local int i;
    local ScriptedPawn P;
    local DeusExCarcass C;
    for (i = 0;i < numNPCOutfitGroups;i++)
        NPCGroups[i].ClearMembers();

    RollTable();
    SetupNPCOutfits(true);
    _ForceApplyNPCOutfits();
}

//Sets up outfits for the actual NPCs in the map, but doesn't apply them yet
function SetupNPCOutfits(optional bool bAllowRedo)
{
    local ScriptedPawn P;
    local DeusExCarcass C;
    local int i;
    local bool match;

    if (bIsSetup && !bAllowRedo)
        return;

    foreach player.AllActors(class'ScriptedPawn', P)
    {
        DebugLog("Processing Actor: " $ P $ " (" $ P.class.name $ ")");
        //Find the first NPC group with a matching class.
        for (i = 0;i < numNPCOutfitGroups;i++)
        {
            match = NPCGroups[i].GetMatchingClass(string(P.class),P.bindName);
            if (match)
            {
                NPCGroups[i].AddMember(P,bDebugMode,bAllowRedo);
                if (NPCGroups[i].IsClassUnique(string(P.class)) || NPCGroups[i].IsClassUnique(P.bindName))
                    P.augmentiqueData.bUnique = true;
            }
        }
        DebugLog("Processed Actor: " $ P $ " (" $ P.augmentiqueData.bUnique $ ")");
    }
    foreach player.AllActors(class'DeusExCarcass', C)
    {
        DebugLog("Processing Actor: " $ C);
        //Find the first NPC group with a matching class.
        for (i = 0;i < numNPCOutfitGroups;i++)
        {
            match = NPCGroups[i].GetMatchingClass(string(C.class));
            if (match)
            {
                NPCGroups[i].AddMember(C,bDebugMode,bAllowRedo);
                if (NPCGroups[i].IsClassUnique(string(C.class)))
                    C.augmentiqueData.bUnique = true;
            }
        }
    }
}

//Internal function to re-apply NPC outfits, no matter what
function private _ForceApplyNPCOutfits()
{
    local int i;
    
    for (i = 0;i < numNPCOutfitGroups;i++)
        NPCGroups[i].ApplyOutfits(iEquipNPCs >= 1, iEquipNPCs >= 2);
}

function ApplyNPCOutfits()
{
    if (bIsSetup)
        return;

    _ForceApplyNPCOutfits();
}

//These need to be here so that they can be used from the other side. This is horrible code!
/*
function static CopyOutfitFromActorToCarcass(Actor A, DeusExCarcass C, optional bool bStrictMode)
{
    class'OutfitCarcassUtils'.static.CopyOutfitFromActorToCarcass(A,C,bStrictMode);
}
function static CopyAugmentiqueDataToPOVCorpse(POVCorpse pov, DeusExCarcass C, optional bool bStrictMode)
{
    class'OutfitCarcassUtils'.static.CopyAugmentiqueDataToPOVCorpse(pov,C,bStrictMode);
}
function static CopyAugmentiqueDataFromPOVCorpse(POVCorpse pov, DeusExCarcass C)
{
    class'OutfitCarcassUtils'.static.CopyAugmentiqueDataFromPOVCorpse(pov,C,bStrictMode);
}
function static ApplyOutfitToCarcass(DeusExCarcass C)
{
    class'OutfitCarcassUtils'.static.CopyOutfitToCarcass(C);
}
*/

function SetOutfitSettingsMenuVisibility(bool bValue, optional bool bShowDescriptionsCheckbox)
{
    bSettingsMenuDisabled = !bValue;
    bDescriptionsCheckbox = bShowDescriptionsCheckbox && !bValue;
    Log("Checkbox: " $ bDescriptionsCheckbox @ bShowDescriptionsCheckbox @ bValue);
}

defaultproperties
{
     savedOutfitIndex=1
     outfitInfos(0)=(Name="JC Denton's Trenchcoat",Article="-",Desc="An old classic. This blue trenchcoat fits well over anything, and gives JC a cool, augmented look")
     outfitInfos(1)=(Name="JC Denton's Trenchcoat (Alt)",Article="-",Desc="JC Denton's Signature Trenchcoat, now with extra jewellery!")
     outfitInfos(2)=(Name="100% Black",PickupMessage="We're 100% Black",HighlightName="???")
     outfitInfos(3)=(Name="Alex Jacobson's Outfit",Article="-",Desc="An outfit adorned with computer parts, keyboards, wires and other tech.")
     outfitInfos(4)=(Name="Lab Coat",Desc="This sleek turtleneck and extra long lab coat are used by scientists and doctors all over the world")
     outfitInfos(5)=(Name="Paul Denton's Outfit",Article="-",Desc="A dark blue trenchcoat matched with an aqua turtleneck gives this outfit a unique and interesting look")
     outfitInfos(6)=(Name="Business Suit (Brown)",Desc="An extremely expensive suit worn by presidents, business people, and the rich elite.")
     outfitInfos(7)=(Name="Business Suit (MIB)",Desc="This stylish black suit was chosen especially for Majestic 12's pharmaceutically-augmented agents to contrast their albino nature.")
     outfitInfos(8)=(Name="UNATCO Combat Uniform",Desc="The standard issue uniform for UNATCO peacekeepers throughout the world, this protective outfit is a significant improvement over the previous UN combat uniform.")
     outfitInfos(9)=(Name="Mechanic Jumpsuit",Desc="This high-visibility orange jumpsuit ensures safety while working in low visibility conditions.")
     outfitInfos(11)=(Name="Chef Outfit",Desc="This all-white clothing and traditional toque is often worn as a symbol of pride by experiened chefs.")
     outfitInfos(13)=(Name="Gold and Brown Business",PickupName="Gold and Brown Business Outfit",Desc="This fashionable gold and brown outfit with matching jacket is a symbol of power and status.")
     outfitInfos(14)=() //Unused???
     outfitInfos(15)=(Name="Matrix Outfit",Desc="")
     outfitInfos(16)=(Name="Goth GF Outfit",Desc="This goth-themed outfit with fishnet shirt is often worn by punk rockers, outcasts, and rebels of all kinds.")
     outfitInfos(17)=(Name="Soldier Outfit",Desc="These green fatigues are standard issue for the American military.")
     outfitInfos(18)=(Name="Riot Gear",Article="some",Desc="Worn during riot control, raids and other dangerous crime-fighting activities, this helmet and body-armor provide a high degree of protection for cops in the field.")
     outfitInfos(19)=(Name="WIB Suit",Desc="This stylish gray suit was chosen especially for Majestic 12's pharmaceutically-augmented agents to contrast their albino nature.")
     outfitInfos(20)=(Name="NSF Sympathiser",PickupName="NSF Uniform",Desc="This tan long-sleeve uniform with body armor serves as the primary combat uniform for the NSF forces across the United States.")
     outfitInfos(21)=(Name="Stained Clothes",Article="some",Desc="These filthy clothes smell disgusting, and look even worse.")
     outfitInfos(22)=(Name="Juan Lebedev's Outfit",Article="-",Desc="A variant of the standard NSF combat uniform sporting an additional brown trench coat.")
     outfitInfos(23)=(Name="Smuggler's Outfit",Article="-",Desc="This expensive outfit matches Smuggler's prices")
     outfitInfos(24)=(Name="FEMA Executive's Outfit",Desc="Designed for augmented agents, this trenchcoat sports access ports and other advanced technology.")
     outfitInfos(25)=(Name="MJ12 Soldier Uniform",Desc="The standard issue for Majestic 12 troops worldwide, this uniform strikes fear and contempt into the hearts of many.")
     outfitInfos(26)=(Name="Jock's Outfit",Article="-",Desc="A sleek flight suit often worn by pilots, aircraft crew, and others.")
     outfitInfos(27)=(Name="Maggie's Outfit",Article="-",Desc="This stylish dragon-themed dress is the height of fashion in Hong Kong.")
     outfitInfos(28)=(Name="Nicolette's Outfit",Article="-",Desc="Adorned with punk iconography, this outfit is sure to get anyone noticed.")
     outfitInfos(29)=(Name="Bare Necessities",Article="some",Desc="A basic covering designed for modesty and not much else.")
     outfitInfos(30)=(Name="Business Suit (Black)",Desc="An extremely expensive suit worn by presidents, business people, and the rich elite.")
     outfitInfos(31)=(Name="Sailor Outfit",Desc="Standard uniform for sailers and deck hands across the world.")
     outfitInfos(32)=(Name="Carter's Outfit",Article="-",Desc="These modified military fatigues with rolled up sleeves are more comfortable than the standard issue uniform.")
     outfitInfos(33)=(Name="SCUBA Suit",Desc="An underwater suit with a self contained breathing apparatus, this suit is used by recreational divers, explorers, scavengers, military, and many others across the world for a variety of underwater purposes.")
     outfitInfos(34)=(Name="100% Black (Alt)")
     outfitInfos(35)=(Name="Prison Uniform",Desc="Standard issue prison uniform, designed to easily distingush inmates from everyone else in the event of an escape.")
     outfitInfos(36)=(Name="100% Black (Augmented Edition)")
     outfitInfos(37)=(Name="Thug Outfit",Desc="This cold-weather outfit is used by mercenaries and criminals alike. Beloved for it's warmth, freedom of movement, and general style.")
     outfitInfos(38)=(Name="Anna Navarre's Outfit",Article="-",Desc="UNATCO employs many augmented agents to provide an advantage for dangerous combat situations. Before the invention of nano-augmentation, agents were surgically modified, often having entire limbs replaced.")
     outfitInfos(39)=(Name="Tiffany Savage's Outfit",Article="-",Desc="This leather and latex outfit is designed to provide maximum dexterity and comfort during wet-work operations.")
     outfitInfos(40)=(Name="School Uniform",Desc="This long-sleeve shirt and dress style uniform is used by many religious and private schools across the world.")
     outfitInfos(41)=(Name="Jordan Shea's Outfit",Article="-",Desc="This sleeveless shirt combined with dress pants is dirty after a long day of work.")
     outfitInfos(42)=(Name="Hooker Outfit",Desc="Colloquially known as a 'hooker' outfit, due to its popularity among strippers, sex workers, and clubgoing women looking for company.")
     outfitInfos(43)=(Name="NSF Sympathiser (Alt)",Article="-",Desc="This tan long-sleeve uniform with body armor serves as the primary combat uniform for the NSF forces across the United States.")
     outfitInfos(44)=(Name="Unwashed Clothes",Article="some",Desc="These dirty unwashed clothes smell awful, and look even worse.")
     outfitInfos(45)=(Name="Harley Filben's Outfit",Article="-",Desc="This signature green jacket has clearly seen better days.")
     outfitInfos(46)=(Name="Business Suit (White)",Desc="An extremely expensive suit worn by presidents, business people, and the rich elite.")
     outfitInfos(47)=(Name="Business Suit (Blue)",Desc="An extremely expensive suit worn by presidents, business people, and the rich elite.")
     outfitInfos(48)=(Name="Doctor's Outfit",Desc="This sleek vest, business shirt and extra long lab coat are used by doctors all over the world")
     outfitInfos(49)=(Name="Nurse's Outfit",Desc="These traditional scrubs have been worn by nurses all over the world for many years.")
     outfitInfos(50)=(Name="Gilbert Renton's Outfit",Article="-",Desc="This dirty shirt and dirty jeans are perfect attire for the owner of a dirty hotel.")
     outfitInfos(51)=(Name="Hooker Outfit (Alt)",Desc="Colloquially known as a 'hooker' outfit, due to its popularity among strippers, sex workers, and clubgoing women looking for company.")
     outfitInfos(52)=(Name="Ford Schick's Outfit",Article="-",Desc="")
     outfitInfos(53)=(Name="Joe Greene's Outfit",Article="-",Desc="A business suit favored by reporters and journalists all over the world.")
     outfitInfos(54)=(Name="Soiled Junkie Clothes",Article="some",Desc="This disgusting clothing reeks of sweat, dirt, and other fowl substances.")
     outfitInfos(55)=(Name="Rook Member Outfit",Desc="This leather jacket, chains, and other tough-guy attire is often worn by punk rockers, outcasts, and rebels of all kinds.")
     outfitInfos(56)=(Name="Alex Denton's Outfit",Article="-",Desc="This unusual purple outfit is the standard attire for all members of the Tarsus Academy.")
     outfitInfos(57)=(Name="Business Suit (Dark Brown)",Desc="An extremely expensive suit worn by presidents, business people, and the rich elite.")
     outfitInfos(58)=(Name="White-Collar Dress (Red)",Desc="A red dress designed to stand out and get noticed around the office.")
     outfitInfos(59)=(Name="White-Collar Dress (Dark Gray)",Desc="This business dress is often worn by secretaries, office workers, and white-collar professionals.")
     outfitInfos(60)=(Name="Low Class Outfit",Desc="")
     outfitInfos(61)=(Name="Sandra Renton's Outfit",Article="-",Desc="These torn and tattered clothes are a staple of someone who has fallen on hard times.")
     outfitInfos(62)=(Name="JoJo's Outfit",Article="-",Desc="This over-the-top spectacle of fake augmentations and metal is designed to intimidate others and to show dominance.")
     outfitInfos(63)=(Name="Bartender Outfit",Desc="A white shirt with a bow tie, this is typical attire for bartenders, hotel clerks, and other service-industry workers")
     outfitInfos(64)=(Name="Tough Guy Outfit") //Unused
     outfitInfos(65)=(Name="Police Uniform",Desc="The standard uniform for beat-cops and police on patrol.")
     outfitInfos(66)=(Name="Howard Strong's Outfit",Article="-")
     outfitInfos(67)=(Name="Adam Jensen's Outfit",Article="-",Desc="A symbol of an era passed, these mechanical augmentations are quickly being replaced with nano-augmentations.")
     outfitInfos(68)=(Name="Average GEPGUN Enjoyer",PickupName="Bare Necessities",Article="some",Desc="What's it like to stand around revving your actuators while the more fashionable agents complete the mission?")
     outfitInfos(69)=(Name="Morgan Everett's Outfit",Article="-")
     outfitInfos(70)=(Name="Boat Person Outfit",Desc="While Singlets and Jeans are often associated with the poor, they are also often worn by physical labourors, unloaders, masonists, and other blue-collar workers.")
     outfitInfos(71)=(Name="Chad's Outfit",Article="-")
     outfitInfos(72)=(Name="Janitor Uniform",Desc="Designed for comfort while cleaning, these overalls are made of a soft, water-resistant material")
     //outfitInfos(73)=(Name="Martial Arts Uniform",Desc="These traditional Kasaya are often worn by ordained buddhist monks and martial artists")
     outfitInfos(73)=(Name="Monk Clothes",Article="some")
     outfitInfos(74)=(Name="Tracer Tong's Outfit",Article="-")
     outfitInfos(75)=(Name="Hong Kong Military Uniform",Desc="These green fatigues are standard issue for the Hong Kong military police.")
     outfitInfos(76)=(Name="MJ12 Elite Uniform",Desc="This modified Majestic 12 uniform is used by elite units on missions critical to maintaining their Totalitarian regime.")
     outfitInfos(77)=(Name="Traditional Attire",Article="some",Desc="Traditional clothing worn by citizens of Hong Kong and other Asian regions.")
     outfitInfos(78)=(Name="Luminous Path Uniform")
     outfitInfos(79)=(Name="Navy Dress Uniform",Desc="Formal dress uniform for Navy officers. Normally used for public events such as parades and ceremonies.")
     outfitInfos(80)=(Name="Butler Uniform",Desc="A black suit with a white shirt, this is typical attire for bartenders, hotel clerks, and other service-industry workers")
     outfitInfos(81)=(Name="Bob Page's Suit",Article="-",Desc="Signature suit of one of the richest men in the world.")
     outfitInfos(82)=(Name="Gordon Quick's Outfit",Article="-")
     outfitInfos(83)=(Name="Red Arrow Uniform")
     outfitInfos(85)=(Name="Jaime's Outfit",Article="-") //!!!
     outfitInfos(86)=(Name="Illuminati Coat")
     outfitInfos(87)=(Name="Vandenberg Scientist Outfit",Desc="A long labcoat over a suit and tie, the signature outfit of X51.")
     outfitInfos(88)=(Name="Old Clothes",Article="some")
     outfitInfos(89)=(Name="Dragon Head's Uniform",Article="the")
     outfitInfos(90)=(Name="White-Collar Dress (Brown)",Desc="This business dress is often worn by secretaries, office workers, and white-collar professionals.")
     outfitInfos(91)=(Name="Adam Jensen's Outfit (Alt)",Article="-",Desc="A symbol of an era passed, these mechanical augmentations are quickly being replaced with nano-augmentations.")
     outfitInfos(92)=(Name="White-Collar Dress (Blue and White)",Desc="This business dress is often worn by secretaries, office workers, and white-collar professionals.")
     outfitInfos(93)=(Name="Maid Outfit",Desc="A formal cleaning uniform worn by servants, assistants and house cleaners.")
     outfitInfos(94)=(Name="Manderley's Outfit",Article="-")
     outfitInfos(95)=(Name="Patterned Dress",Desc="A green dress with a basic pattern, usually worn by lower-middle-class women.")
     outfitInfos(96)=(Name="Terrorist Commander Outfit",Desc="A variant of the standard NSF combat uniform sporting an additional gray trench coat and blue dress pants.")
     outfitInfos(97)=(Name="Hitman Suit",Desc="The signature suit of a silent assassin.")
     
     //1.1 stuff
     outfitInfos(98)=(Name="Midnight Trenchcoat",Desc="A trenchcoat equipped for stealth while also looking extremely stylish")
     outfitInfos(99)=(Name="Gunther's Outfit",Article="-",Desc="UNATCO employs many augmented agents to provide an advantage for dangerous combat situations. Before the invention of nano-augmentation, agents were surgically modified, often having entire limbs replaced.")

     //1.2 stuff
     outfitInfos(100)=(Name="MJ12 Soldier Uniform (Alternate)",Desc="A variant of the MJ12 outfit with a more streamlined helmet for better visibility, but without the tactical goggles or extra protection.")


     //Misc
     partNames(0)="Default"

     //Glasses
     partNames(1)="Slim Sunglasses"
     partNames(2)="Prescription Glasses"
     partNames(3)="Black Bars"
     partNames(4)="Reading Glasses"
     partNames(5)="Aviators"
     partNames(6)="Sunglasses"
     partNames(7)="Tacticool Goggles" //Unused??!!

     //Skin Textures
     partNames(8)="100% Black"
     partNames(9)="Beanie"
     partNames(10)="Jensen"
     partNames(167)="Bald"
     
     //Pants (Male)
     partNames(11)="Blue Tactical Pants with Boots"
     partNames(12)="Tan Business Pants"
     partNames(13)="Dirty Jeans"
     partNames(14)="Dark Blue Dress Pants"
     partNames(15)="Brown Dress Pants"
     partNames(16)="Light Blue Dress Pants"
     partNames(17)="Hackerman Pants"
     partNames(18)="UNATCO Combat Pants"
     partNames(19)="Mechanic's Jumpsuit Pants"
     partNames(20)="Fatigue Pants"
     partNames(21)="Riot Gear Pants"
     partNames(22)="Brown Dress Pants with Boots"
     partNames(23)="MJ12 Combat Pants"
     partNames(24)="Black Military Pants with Boots"
     partNames(25)="Sailor Pants"
     partNames(26)="Ripped Jeans"
     partNames(27)="Black Dress Pants"
     partNames(28)="Black Dress Pants with Boots"
     partNames(29)="Black Dress Pants 2"
     partNames(30)="Soiled Pants"
     partNames(31)="Dark Blue Dress Pants"
     partNames(32)="Dirty Brown Pants"
     partNames(33)="Dirty Grey Pants"
     partNames(34)="Police Uniform Pants"
     partNames(35)="Black Pants with White Socks"
     partNames(36)="Biker Pants"
     partNames(37)="Brown Casual Pants"
     partNames(38)="Jeans"
     partNames(39)="Black Casual Pants"
     partNames(40)="Janitors Pants"
     partNames(41)="Monk's Pants"
     partNames(42)="Green Pants with Boots"
     partNames(43)="Military Fatigues with Boots"
     partNames(44)="Dark Brown Dress Pants"
     partNames(45)="Navy Dress Pants"
     partNames(46)="Gray Dress Pants"
     partNames(47)="Black Pants with Dragon"
     partNames(48)="Sports Pants"
     partNames(49)="Black Aviator Pants"
     partNames(50)="Max Chen's Pants"
     
     //Trench Coat Shirts
     partNames(51)="Beige and Brown Turtleneck"
     partNames(52)="Light Blue Turtleneck"
     partNames(53)="Dirty White and Gray Shirt"
     partNames(54)="Stained White Shirt"
     partNames(55)="NSF Body Armor"
     partNames(56)="Red Turtleneck"
     partNames(57)="Black Vest and Black Tie"
     partNames(58)="Blue Vest and Red Tie"
     partNames(59)="Black Vest and Red Tie"
     partNames(60)="Dirty Green Turtleneck"
     partNames(61)="White Shirt"
     partNames(62)="Punk Shirt"
     partNames(63)="Bare Chest"
     partNames(64)="Dark Blue Turtleneck"
     partNames(65)="Aviator Shirt"
     partNames(66)="Pink Shirt and Black Tie"
     partNames(67)="Toby Atanwe's Shirt"
     partNames(68)="Blue Shirt and Red Tie"
     partNames(69)="Max Chen's Shirt"

     //Trench Coats
     partNames(70)="Lab Coat"
     partNames(71)="Gray and Blue Jacket"
     partNames(72)="Old Brown and Blue Jacket"
     partNames(73)="Old Brown Jacket"
     partNames(74)="Old Blue Jacket"
     partNames(75)="Brown Jacket"
     partNames(76)="Dark Gray Jacket"
     partNames(77)="Cyber Trenchcoat"
     partNames(78)="Tattered Green Jacket"
     partNames(79)="Old Brown and Gray Jacket"
     partNames(80)="Blue Jacket"
     partNames(81)="Tough Guy Leather Jacket"
     partNames(82)="Adorned White Jacket"
     partNames(83)="Red Arrow Jacket"
     partNames(84)="Aviator Jacket"
     partNames(85)="Illuminati Trenchcoat"
     partNames(86)="Dragon Coat"
     partNames(87)="Business Blazer"
     partNames(88)="Gray Jacket"

     //Shirts
     partNames(89)="Hackerman Shirt"
     partNames(90)="UNATCO Combat Vest"
     partNames(91)="Mechanic's Jumpsuit Shirt"
     partNames(92)="Military Fatigues"
     partNames(93)="Riot Gear Tactical Vest"
     partNames(94)="MJ12 Combat Vest"
     partNames(95)="Military Fatigues 2"
     partNames(96)="Woollen Turtleneck"
     partNames(97)="Gray Business Shirt"
     partNames(98)="Soiled Shirt"
     partNames(99)="Fake Body Mod"
     partNames(100)="White Business Shirt"
     partNames(101)="Police Uniform Shirt"
     partNames(102)="Gray Shirt with Waistcoat"
     partNames(103)="Adam Jensen's Body"
     partNames(104)="Adam Jensen's Body (Alt)"
     partNames(105)="Slate Shirt with Waistcoat"
     partNames(106)="Dirty White Singlet"
     partNames(107)="Dirty White Shirt"
     partNames(108)="Headshot Smiley Shirt"
     partNames(109)="Janitors Shirt"
     partNames(110)="Monk's Shirt"
     partNames(111)="Tracer Tong's Shirt"
     partNames(112)="Military Fatigues with Vest"
     partNames(113)="Alex Denton's Shirt"

     //Missed some previously
     partNames(114)="White Dress Pants"
     partNames(115)="Fake Augments" //Placeholder

     //Suit Torsos
     //EDIT: These will just keep their outfit names

     //Jumpsuit Bodies
     partNames(116)="Tactical Face Mask"
     partNames(117)="Tactical Equipment"
     partNames(118)="Elite Tactical Equipment"

     //Jumpsuit Helmets
     partNames(119)="UNATCO Helmet"
     partNames(120)="Military Helmet"
     partNames(121)="Hard Hat"
     partNames(122)="Riot Helmet"
     partNames(123)="Tacticool Goggles (Yellow)"
     partNames(124)="MJ12 Helmet"
     partNames(125)="MJ12 Elite Helmet"

     //Suit Hats
     partNames(126)="Chef Hat"
     partNames(127)="Sailor Hat"
     partNames(128)="Ponytail"

     //FEMALE STUFF

     //Pants
     partNames(129)="Gold Brown Business Pants"
     partNames(130)="Black Tactical Pants with Boots"
     partNames(131)="Goth Pants with Boots"
     partNames(132)="Mechanical Legs"
     partNames(133)="Gray Pants with Leather Boots"
     partNames(134)="Soiled Ripped Jeans"
     partNames(135)="Underwear"

     //Dress Pants
     partNames(136)="Stockings with Brown Shoes"
     partNames(137)="Dark Stockings with Black Shoes"
     partNames(138)="Stockings with Red Shoes"
     partNames(139)="Black Stockings with Black Shoes"
     partNames(140)="Purple Stockings with Black Shoes"
     partNames(141)="Stockings with Red Shoes (No Socks)"
     partNames(142)="Medium Dark Stockings with Black Shoes"
     partNames(143)="Punk Leggings"
     partNames(144)="Thigh High Socks"
     partNames(145)="Gray Shoes"
     partNames(146)="Gray Shoes with Socks"

     //Shirts
     partNames(147)="Punk Top"
     partNames(148)="Augmented Body"
     partNames(149)="Leather Top"
     partNames(150)="School Shirt"
     partNames(151)="White Shirt (Open)"
     partNames(152)="Blue Crop Top"
     partNames(153)="Balconette Bolero"
     partNames(154)="Soiled Tank Top"
     partNames(155)="Alex Denton's Tactical Suit"
     partNames(156)="Torn Top"
     partNames(157)="Blue and White Top"
     partNames(158)="Tattered Top"
     partNames(159)="Basic Bra"

     //Skirts
     partNames(160)="Punk Skirt"
     partNames(161)="Tartan Skirt"
     partNames(162)="Race-Stripe Miniskirt"
     partNames(163)="Black Skirt"

     //SuitSkirt Torsos
     //EDIT: Leave these as the outfits for now

     //Extras
     partNames(168)="Agent 47"
     partNames(169)="White Shirt and Red Tie"
     partNames(170)="Fingerless Gloves"
     partNames(171)="Military Helmet (Chin Strap)"

     //Trench Shirts
     partNames(172)="Necklace"
     partNames(173)="Matrix Shirt"
     partNames(174)="Fishnet Shirt"
     partNames(164)="Dark Brown Jacket"
     partNames(165)="Green Patterned Black Jacket"
     partNames(166)="Red Patterned Black Jacket"
     partNames(175)="Alex Denton's Tactical Suit"
     
     //1.1 stuff
     partNames(176)="Midnight Jacket"
     partNames(177)="Midnight Shirt"
     partNames(178)="Midnight Pants"
     
     partNames(179)="Party Glasses"
     
     partNames(180)="MJ12 Elite Helmet"
     partNames(181)="Tacticool Goggles (Red)"
     

     //1.2 stuff
     partNames(182)="MJ12 Helmet (Slimline)"

     CustomOutfitName="(Custom)"
     NothingName="Nothing"
     DefaultPickupMessage="You found %s %s"
     DefaultPickupMessage2="You found %s"

     PickupSound=Sound'Augmentique.Outfits.BoxPickup'
     iEquipNPCs=1

     MsgOutfitUnlocked="Outfit %s has been unlocked!"
}
