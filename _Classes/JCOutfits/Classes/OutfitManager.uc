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

//part names
var const localized string partNames[1000];

//add default parts - horrible hack
var transient string defaultParts[50];
var transient int defaultPartsNum;

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

//TODO: Replace these with outfit 0
var travel string defaultTextures[8];
var travel string defaultMesh;

var transient OutfitPart PartsList[300];
var transient int numParts;
var transient PartsGroup Groups[50];
var transient int numPartsGroups;
var transient PartsGroup currentPartsGroup;

//Outfits unlocked this playthrough. Outfits are made permanent after finishing the game.
var travel string unlockedOutfits[255];

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
    local DeusExLevelInfo dxInfo;
    local string t0, t1, t2, t3, t4, t5, t6, t7, mesh;

    player = newPlayer;
    dxInfo = player.GetLevelInfo();
    player.CarcassType=class'Augmentique.OutfitCarcassReplacer';
    
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
        //Log("Copying over outfits");
        CopyOutfitsToPlayer();
    }
    //else
    //    Log("Not Copying over outfits");

    //if (numOutfits != 0)
    //    return;
    
    PopulateOutfitsList();
    defaultPartsNum = 0;
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

    //Stop percentages being broken when using custom pickup messages
    if (InStr(outfits[index].PickupMessage,"%s") != -1)
        player.ClientMessage(sprintf(outfits[index].PickupMessage,outfits[index].PickupArticle,outfits[index].PickupName), 'Pickup');
    else
        player.ClientMessage(outfits[index].PickupMessage, 'Pickup');
        
    Unlock(S.id);

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
    GlobalAddPart(PS_Mask,NothingName,true,"nothing_m","none","none");
    GlobalAddPartL(PS_Body_M,0,false,"default_b","default");
    GlobalAddPartL(PS_Body_F,0,false,"default_b","default");

    //Glasses
    GlobalAddPartL(PS_Glasses,1,true,"default_g","FramesTex4","LensesTex5");
    GlobalAddPartL(PS_Glasses,2,true,"sci_g","FramesTex1","LensesTex1");
    GlobalAddPartL(PS_Glasses,3,true,"100%_g","Outfit1_Tex1","Outfit1_Tex1");
    GlobalAddPartL(PS_Glasses,4,true,"business_g","FramesTex1","LensesTex2");
    GlobalAddPartL(PS_Glasses,5,true,"sunglasses_g","FramesTex2","LensesTex3");
    GlobalAddPartL(PS_Glasses,6,true,"sunglasses2_g","FramesTex2","LensesTex2");
    GlobalAddPartL(PS_Glasses,7,true,"visor_g","ThugMale3Tex3","ThugMale3Tex3");

    //Skin Textures
    GlobalAddPartL(PS_Body_M,8,false,"100%_b","Outfit1_Tex1");
    GlobalAddPartL(PS_Body_M,9,false,"beanie_b","ThugSkin");
    GlobalAddPartL(PS_Body_M,10,false,"adam_b","AdamJensenTex0");

    //GlobalAddPartLO(PS_Body_F,2,false,"100%_b","Outfit1_Tex1",,,"Outfit1_Tex1");
    GlobalAddPartL(PS_Body_F,2,false,"100%_b","Outfit1_Tex1");

    //Pants
    GlobalAddPartL(PS_Legs,11,false,"default_p","JCDentonTex3");
    GlobalAddPartL(PS_Legs_M,12,false,"lab_p","PantsTex1");
    GlobalAddPartL(PS_Legs,13,false,"gilbertrenton_p","PantsTex3"); //Also used by Ford Schick and Boat Person
    GlobalAddPartL(PS_Legs,3,false,"100%_p","Outfit1_Tex1");
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
    //GlobalAddPartLO(PS_Legs,64,false,"thug3_p","ThugMale3Tex2");
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
    GlobalAddPartL(PS_Trench_Shirt,161,false,"default_s2","Outfit1F_Tex1");
    GlobalAddPartL(PS_Trench_Shirt_F,8,false,"100%_s","Outfit1_Tex1");
    GlobalAddPartL(PS_Trench_Shirt_F,51,false,"lab_s","TrenchShirtTex3");
    GlobalAddPartL(PS_Trench_Shirt,162,false,"matrix_s","Outfit4F_Tex1");
    GlobalAddPartL(PS_Trench_Shirt_F,163,false,"goth_s","Outfit3F_Tex1");
    
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
    GlobalAddPartL(PS_Skirt,164,false,"alex_sk","Outfit5F_Tex2","Outfit5F_Tex2");

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
    //GlobalAddPartL(PS_Torso_M,115,false,"thug3_s","ThugMale3Tex1");
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

    BeginNewPartsGroup("GM_Trench", true, false);
    GroupAddParts(PS_Body_M);
    GroupTranspose(PS_Trench,1,5);
    GroupTranspose2(PS_Trench_M,PS_Trench,1,5);
    GroupTranspose(PS_Trench_Shirt,4);
    GroupTranspose2(PS_Trench_Shirt_M,PS_Trench_Shirt,4);
    GroupTranspose(PS_Legs,2);
    GroupTranspose2(PS_Legs_M,PS_Legs,2);
    GroupTranspose(PS_Glasses,6,7);

    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_g");
    
    //Default M
    BeginNewOutfitL("default",0);
    OutfitAddPartReference("default_t");
    OutfitAddPartReference("default_p");
    OutfitAddPartReference("default_s");
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

    //========================================================
    //  GFM_Trench
    //========================================================

    BeginNewPartsGroup("GFM_Trench", false, true);
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
    //========================================================

    BeginNewPartsGroup("GFM_SuitSkirt", false, true);
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
    //========================================================

    BeginNewPartsGroup("GFM_Dress", false, true);
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
    //========================================================
    
    BeginNewPartsGroup("GFM_TShirtPants", false, true);
    GroupAddParts(PS_Body_F);
    GroupTranspose(PS_Legs,6);
    GroupTranspose2(PS_Legs_F,PS_Legs,6);
    GroupTranspose(PS_Torso_F,7);
    
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

    BeginNewPartsGroup("GM_ScubaSuit", true, true);
    
    //Main Textures
    AddPartLO(PS_Main,33,false,"scuba","none","ScubasuitTex0","ScubasuitTex1","none","none","none","none","none","ScubasuitTex1");

    BeginNewOutfitL("diver",33);
    OutfitAddPartReference("scuba");
    
    //========================================================
    //  GM_DressShirt
    //========================================================

    BeginNewPartsGroup("GM_DressShirt", true, false);
    GroupAddParts(PS_Body_M);
    GroupTranspose(PS_Torso_M,5);
    GroupTranspose(PS_Legs,3);
    GroupTranspose2(PS_Legs_M,PS_Legs,3);
    GroupTranspose(PS_Glasses,6,7);
    
    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_g");
    
    //Adam Jensen Outfit
    //TODO: Investigate making this better
    //The textures have multiple Alt versions!
    BeginNewOutfitL("adam",67);
    OutfitAddPartReference("adam_b");
    OutfitAddPartReference("adam_s");
    OutfitAddPartReference("mib_p");
    
    //Adam Jensen Outfit 2
    BeginNewOutfitL("adam",91);
    OutfitAddPartReference("adam_s2");
    OutfitAddPartReference("mib_p");
    
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
    
    /*
    //Thug3
    //TODO: Fix
    BeginNewPartsGroup("GM_DressShirt_B", true, false);
    GroupTranspose(PS_Body_M,3);
    GroupTranspose(PS_Torso_M,0);
    GroupTranspose(PS_Legs,1);
    GroupTranspose(PS_Glasses,4,5);
    
    BeginNewOutfitL("thug3",64);
    OutfitAddPartReference("thug3_p");
    OutfitAddPartReference("thug3_s");
    OutfitAddPartReference("visor_g");
    */
    
    //========================================================
    //  GM_Suit
    //========================================================

    BeginNewPartsGroup("GM_Suit", true, false);
    GroupAddParts(PS_Body_M);
    GroupTranspose(PS_Legs,1);
    GroupTranspose(PS_Glasses,5,6);
    GroupTranspose(PS_Hat,7);

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
    //========================================================

    BeginNewPartsGroup("GM_Jumpsuit", true, false);
    GroupTranspose(PS_Body_M,3);
    GroupTranspose(PS_Legs,1);
    GroupTranspose(PS_Torso_M,2);
    GroupTranspose(PS_Mask,3,4,5);
    GroupTranspose(PS_Hat,6);
    
    //Masks
    //Can only realistically be used on this model
    //TODO: Either make these not count as accessories (set arg 3 to false), or
    //add in a system whereby we always assign a default texture
    AddPartL(PS_Body_M,116,false,"unatco_b",,,,"MiscTex1JC","MiscTex1JC","GrayMaskTex");
    AddPartL(PS_Body_M,117,false,"nsf_b",,,,"TerroristTex0","TerroristTex0","GrayMaskTex");
    AddPartL(PS_Body_M,118,false,"mj12elite_b",,,,"MJ12EliteTex0","MJ12EliteTex0","GrayMaskTex");

    //Jumpsuit specific helmets
    AddPartL(PS_Hat,119,true,"unatco_h",,,,,,,"UNATCOTroopTex3");
    AddPartL(PS_Hat,120,true,"soldier_h",,,,"SoldierTex0","PinkMaskTex","PinkMaskTex","SoldierTex3","PinkMaskTex");
    //AddPartL(PS_Hat,120,true,"soldier_h",,,,,,,"SoldierTex3");
    AddPartL(PS_Hat,121,true,"mechanic_h",,,,,,,"MechanicTex3");
    AddPartL(PS_Hat,122,true,"riotcop_h",,,,,,,"RiotCopTex3",,"VisorTex1");
    AddPartL(PS_Hat,123,true,"nsf_h",,,,,,,"GogglesTex1");
    AddPartL(PS_Hat,124,true,"mj12_h",,,,,,"MJ12TroopTex3","MJ12TroopTex4");
    AddPartL(PS_Hat,125,true,"mj12elite_h",,,,,,"MJ12EliteTex3","MJ12EliteTex3");
    
    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_m");
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
    //TODO: This is currently just the Mechanic mesh
    /*
    BeginNewOutfitL("prisoner",35);
    OutfitAddPartReference("mechanic_p");
    OutfitAddPartReference("mechanic_s");
    */

    //END
    //CompleteSetup();
}

//Add a reference that will be added to all outfits for this particular parts group
function AddDefaultReference(string defRef)
{
    defaultParts[defaultPartsNum] = defRef;
    defaultPartsNum++;
}

function BeginNewPartsGroup(string mesh, bool allowMale, bool allowFemale)
{
    local int i;
    local PartsGroup G;
    local Mesh M;

    M = findMesh(mesh);

    //Reset the default parts list
    defaultPartsNum = 0;

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

function BeginNewOutfit(string id, string name, string desc, optional string highlightName, optional string pickupName, optional string pickupMessage, optional string pickupArticle)
{
    local Outfit O;
    local int i;
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

    if (pickupMessage == "")
        pickupMessage = "You found %s %s";

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
    for (i = 0;i < defaultPartsNum;i++)
        OutfitAddPartReference(defaultParts[i]);
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

    //SARGE: Remove this before release!
    //return true;

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
    return outfits[index].partsGroup.IsCorrectGender();
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

function Unlock(string id)
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
}

function ApplyCurrentOutfit()
{
	local JCDentonMaleCarcass jcCarcass;
	local JCDouble jc;

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
     savedOutfitIndex=1
     outfitInfos(0)=(Name="JC Denton's Trenchcoat",Desc="An old classic. This blue trenchcoat fits well over anything, and gives JC a cool, augmented look")
     outfitInfos(1)=(Name="JC Denton's Trenchcoat (Alt)",Desc="JC Denton's Signature Trenchcoat, now with extra jewellery!")
     outfitInfos(2)=(Name="100% Black",PickupMessage="We're 100% Black",HighlightName="???")
     outfitInfos(3)=(Name="Alex Jacobson's Outfit",Desc="An outfit adorned with computer parts, keyboards, wires and other tech.")
     outfitInfos(4)=(Name="Lab Coat",Desc="This sleek turtleneck and extra long lab coat are used by scientists and doctors all over the world")
     outfitInfos(5)=(Name="Paul Denton's Outfit",Desc="A dark blue trenchcoat matched with an aqua turtleneck gives this outfit a unique and interesting look")
     outfitInfos(6)=(Name="Business Suit (Brown)",Desc="An extremely expensive suit worn by presidents, business people, and the rich elite.")
     outfitInfos(7)=(Name="Business Suit (MIB)",Desc="This stylish black suit was chosen especially for Majestic 12's pharmaceutically-augmented agents to contrast their albino nature.")
     outfitInfos(8)=(Name="UNATCO Combat Uniform",Desc="The standard issue uniform for UNATCO peacekeepers throughout the world, this protective outfit is a significant improvement over the previous UN combat uniform.")
     outfitInfos(9)=(Name="Mechanic Jumpsuit",Desc="This high-visibility orange jumpsuit ensures safety while working in low visibility conditions.")
     outfitInfos(11)=(Name="Chef Outfit",Desc="This all-white clothing and traditional toque is often worn as a symbol of pride by experiened chefs.")
     outfitInfos(13)=(Name="Gold and Brown Business",Desc="This fashionable gold and brown outfit with matching jacket is a symbol of power and status.")
     outfitInfos(14)=() //Unused???
     outfitInfos(15)=(Name="Matrix Outfit",Desc="")
     outfitInfos(16)=(Name="Goth GF Outfit",Desc="This goth-themed outfit with fishnet shirt is often worn by punk rockers, outcasts, and rebels of all kinds.")
     outfitInfos(17)=(Name="Soldier Outfit",Desc="These green fatigues are standard issue for the American military.")
     outfitInfos(18)=(Name="Riot Gear",Desc="Worn during riot control, raids and other dangerous crime-fighting activities, this helmet and body-armor provide a high degree of protection for cops in the field.")
     outfitInfos(19)=(Name="WIB Suit",Desc="This stylish gray suit was chosen especially for Majestic 12's pharmaceutically-augmented agents to contrast their albino nature.")
     outfitInfos(20)=(Name="NSF Sympathiser",Desc="This tan long-sleeve uniform with body armor serves as the primary combat uniform for the NSF forces across the United States.")
     outfitInfos(21)=(Name="Stained Clothes",Desc="These filthy clothes smell disgusting, and look even worse.")
     outfitInfos(22)=(Name="Juan Lebedev's Outfit",Desc="A variant of the standard NSF combat uniform sporting an additional brown trench coat.")
     outfitInfos(23)=(Name="Smuggler's Outfit",Desc="This expensive outfit matches Smuggler's prices")
     outfitInfos(24)=(Name="FEMA Executive's Outfit",Desc="Designed for augmented agents, this trenchcoat sports access ports and other advanced technology.")
     outfitInfos(25)=(Name="MJ12 Soldier Uniform",Desc="The standard issue for Majestic 12 troops worldwide, this uniform strikes fear and contempt into the hearts of many.")
     outfitInfos(26)=(Name="Jock's Outfit",Desc="A sleek flight suit often worn by pilots, aircraft crew, and others.")
     outfitInfos(27)=(Name="Maggie's Outfit",Desc="This stylish dragon-themed dress is the height of fashion in Hong Kong.")
     outfitInfos(28)=(Name="Nicolette's Outfit",Desc="Adorned with punk iconography, this outfit is sure to get anyone noticed.")
     outfitInfos(29)=(Name="JC Clone Outfit",Desc="A basic covering designed for modesty and not much else.")
     outfitInfos(30)=(Name="Business Suit (Black)",Desc="An extremely expensive suit worn by presidents, business people, and the rich elite.")
     outfitInfos(31)=(Name="Sailor Outfit",Desc="Standard uniform for sailers and deck hands across the world.")
     outfitInfos(32)=(Name="Carter's Outfit",Desc="These modified military fatigues with rolled up sleeves are more comfortable than the standard issue uniform.")
     outfitInfos(33)=(Name="SCUBA Suit",Desc="An underwater suit with a self contained breathing apparatus, this suit is used by recreational divers, explorers, scavengers, military, and many others across the world for a variety of underwater purposes.")
     outfitInfos(34)=(Name="100% Black (Alt)")
     outfitInfos(35)=(Name="Prison Uniform",Desc="Standard issue prison uniform, designed to easily distingush inmates from everyone else in the event of an escape.")
     outfitInfos(36)=(Name="100% Black (Augmented Edition)")
     outfitInfos(37)=(Name="Thug Outfit",Desc="This cold-weather outfit is used by mercenaries and criminals alike. Beloved for it's warmth, freedom of movement, and general style.")
     outfitInfos(38)=(Name="Anna Navarre's Outfit",Desc="UNATCO employs many augmented agents to provide an advantage for dangerous combat situations. Before the invention of nano-augmentation, agents were surgically modified, often having entire limbs replaced.")
     outfitInfos(39)=(Name="Tiffany Savage's Outfit",Desc="This leather and latex outfit is designed to provide maximum dexterity and comfort during wet-work operations.")
     outfitInfos(40)=(Name="School Uniform",Desc="This long-sleeve shirt and dress style uniform is used by many religious and private schools across the world.")
     outfitInfos(41)=(Name="Jordan Shea's Outfit",Desc="This sleeveless shirt combined with dress pants is dirty after a long day of work.")
     outfitInfos(42)=(Name="Hooker Outfit",Desc="Colloquially known as a 'hooker' outfit, due to its popularity among strippers, sex workers, and clubgoing women looking for company.")
     outfitInfos(43)=(Name="NSF Sympathiser (Alt)",Desc="This tan long-sleeve uniform with body armor serves as the primary combat uniform for the NSF forces across the United States.")
     outfitInfos(44)=(Name="Unwashed Clothes",Desc="These dirty unwashed clothes smell awful, and look even worse.")
     outfitInfos(45)=(Name="Harley Filben's Outfit",Desc="This signature green jacket has clearly seen better days.")
     outfitInfos(46)=(Name="Business Suit (White)",Desc="An extremely expensive suit worn by presidents, business people, and the rich elite.")
     outfitInfos(47)=(Name="Business Suit (Blue)",Desc="An extremely expensive suit worn by presidents, business people, and the rich elite.")
     outfitInfos(48)=(Name="Doctor's Outfit",Desc="This sleek vest, business shirt and extra long lab coat are used by doctors all over the world")
     outfitInfos(49)=(Name="Nurse's Outfit",Desc="These traditional scrubs have been worn by nurses all over the world for many years.")
     outfitInfos(50)=(Name="Gilbert Renton's Outfit",Desc="This dirty shirt and dirty jeans are perfect attire for the owner of a dirty hotel.")
     outfitInfos(51)=(Name="Hooker Outfit (Alt)",Desc="Colloquially known as a 'hooker' outfit, due to its popularity among strippers, sex workers, and clubgoing women looking for company.")
     outfitInfos(52)=(Name="Ford Schick's Outfit",Desc="")
     outfitInfos(53)=(Name="Joe Greene's Outfit",Desc="A business suit favored by reporters and journalists all over the world.")
     outfitInfos(54)=(Name="Soiled Junkie Clothes",Desc="This disgusting clothing reeks of sweat, dirt, and other fowl substances.")
     outfitInfos(55)=(Name="Rook Member Outfit",Desc="This leather jacket, chains, and other tough-guy attire is often worn by punk rockers, outcasts, and rebels of all kinds.")
     outfitInfos(56)=(Name="Alex Denton's Outfit",Desc="This unusual purple outfit is the standard attire for all members of the Tarsus Academy.")
     outfitInfos(57)=(Name="Business Suit (Dark Brown)",Desc="An extremely expensive suit worn by presidents, business people, and the rich elite.")
     outfitInfos(58)=(Name="White-Collar Dress (Red)",Desc="A red dress designed to stand out and get noticed around the office.")
     outfitInfos(59)=(Name="White-Collar Dress (Dark Gray)",Desc="This business dress is often worn by secretaries, office workers, and white-collar professionals.")
     outfitInfos(60)=(Name="Low Class Outfit",Desc="")
     outfitInfos(61)=(Name="Sandra Renton's Outfit",Desc="These torn and tattered clothes are a staple of someone who has fallen on hard times.")
     outfitInfos(62)=(Name="JoJo's Outfit",Desc="This over-the-top spectacle of fake augmentations and metal is designed to intimidate others and to show dominance.")
     outfitInfos(63)=(Name="Bartender Outfit",Desc="A white shirt with a bow tie, this is typical attire for bartenders, hotel clerks, and other service-industry workers")
     outfitInfos(64)=(Name="Tough Guy Outfit") //Unused
     outfitInfos(65)=(Name="Police Uniform",Desc="The standard uniform for beat-cops and police on patrol.")
     outfitInfos(66)=(Name="Howard Strong's Outfit")
     outfitInfos(67)=(Name="Adam Jensen's Outfit",Desc="A symbol of an era passed, these mechanical augmentations are quickly being replaced with nano-augmentations.")
     outfitInfos(68)=(Name="Average GEPGUN Enjoyer",Desc="What's it like to stand around revving your actuators while the more fashionable agents complete the mission?")
     outfitInfos(69)=(Name="Morgan Everett's Outfit")
     outfitInfos(70)=(Name="Boat Person Outfit",Desc="While Singlets and Jeans are often associated with the poor, they are also often worn by physical labourors, unloaders, masonists, and other blue-collar workers.")
     outfitInfos(71)=(Name="Chad's Outfit")
     outfitInfos(72)=(Name="Janitor Uniform",Desc="Designed for comfort while cleaning, these overalls are made of a soft, water-resistant material")
     //outfitInfos(73)=(Name="Martial Arts Uniform",Desc="These traditional Kasaya are often worn by ordained buddhist monks and martial artists")
     outfitInfos(73)=(Name="Martial Arts Uniform")
     outfitInfos(74)=(Name="Tracer Tong's Outfit")
     outfitInfos(75)=(Name="Hong Kong Military Uniform",Desc="These green fatigues are standard issue for the Hong Kong military police.")
     outfitInfos(76)=(Name="MJ12 Elite Uniform",Desc="This modified Majestic 12 uniform is used by elite units on missions critical to maintaining their Totalitarian regime.")
     outfitInfos(77)=(Name="Traditional Attire",Desc="Traditional clothing worn by citizens of Hong Kong and other Asian regions.")
     outfitInfos(78)=(Name="Luminous Path Uniform")
     outfitInfos(79)=(Name="Navy Dress Uniform",Desc="Formal dress uniform for Navy officers. Normally used for public events such as parades and ceremonies.")
     outfitInfos(80)=(Name="Butler Uniform",Desc="A black suit with a white shirt, this is typical attire for bartenders, hotel clerks, and other service-industry workers")
     outfitInfos(81)=(Name="Bob Page's Suit",Desc="Signature suit of one of the richest men in the world.")
     outfitInfos(82)=(Name="Gordon Quick's Outfit")
     outfitInfos(83)=(Name="Red Arrow Uniform")
     outfitInfos(85)=(Name="Jaime's Outfit") //!!!
     outfitInfos(86)=(Name="Illuminati Coat")
     outfitInfos(87)=(Name="Vandenberg Scientist Outfit",Desc="A long labcoat over a suit and tie, the signature outfit of X51.")
     outfitInfos(88)=(Name="Old Clothes")
     outfitInfos(89)=(Name="Dragon Head's Uniform")
     outfitInfos(90)=(Name="White-Collar Dress (Brown)",Desc="This business dress is often worn by secretaries, office workers, and white-collar professionals.")
     outfitInfos(91)=(Name="Adam Jensen's Outfit (Alt)",Desc="A symbol of an era passed, these mechanical augmentations are quickly being replaced with nano-augmentations.")
     outfitInfos(92)=(Name="White-Collar Dress (Blue and White)",Desc="This business dress is often worn by secretaries, office workers, and white-collar professionals.")
     outfitInfos(93)=(Name="Maid Outfit",Desc="A formal cleaning uniform worn by servants, assistants and house cleaners.")
     outfitInfos(94)=(Name="Manderley's Outfit")
     outfitInfos(95)=(Name="Traditional Dress",Desc="Traditional clothing worn by citizens of Hong Kong and other Asian regions.")
     outfitInfos(96)=(Name="Terrorist Commander Outfit",Desc="A variant of the standard NSF combat uniform sporting an additional gray trench coat.")

     //Misc
     partNames(0)="Default"

     //Glasses
     partNames(1)="Slim Sunglasses"
     partNames(2)="Prescription Glasses"
     partNames(3)="Black Bars"
     partNames(4)="Reading Glasses"
     partNames(5)="Aviators"
     partNames(6)="Sunglasses"
     partNames(7)="Tacticool Goggles"

     //Skin Textures
     partNames(8)="100% Black"
     partNames(9)="Beanie"
     partNames(10)="Jensen"
     
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
     partNames(66)="White Shirt and Black Tie"
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
     partNames(76)="Gray Jacket"
     partNames(77)="Cyber Trenchcoat"
     partNames(78)="Tattered Green Jacket"
     partNames(79)="Old Gray Jacket"
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
     partNames(115)="Thug3 Shirt" //Placeholder

     //Suit Torsos
     //EDIT: These will just keep their outfit names

     //Jumpsuit Bodies
     partNames(116)="Tactical Face Mask"
     partNames(117)="Tactical Equipment"
     partNames(118)="Elite Tactical Equipment"

     //Jumpsuit Helmets
     partNames(119)="UNATCO Helmet"
     partNames(120)="Military Helmet"
     partNames(120)="Military Helmet"
     partNames(121)="Hard Hat"
     partNames(122)="Riot Helmet"
     partNames(123)="Tacticool Goggles"
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
     partNames(164)="Alex Denton's Tactical Suit"

     //Trench Shirts
     partNames(161)="Necklace"
     partNames(162)="Matrix Shirt"
     partNames(163)="Fishnet Shirt"
     partNames(164)="Dark Brown Jacket"
     partNames(165)="Green Patterned Black Jacket"
     partNames(166)="Red Patterned Black Jacket"

     //SuitSkirt Torsos
     //EDIT: Leave these as the outfits for now

     CustomOutfitName="(Custom)"
     NothingName="Nothing"
}
