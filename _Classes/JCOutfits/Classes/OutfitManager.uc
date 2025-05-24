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

//part names
var const localized string partNames[255];

//add default parts - horrible hack
var string defaultParts[50];
var int defaultPartsNum;

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

var OutfitPart PartsList[300];
var int numParts;
var PartsGroup Groups[50];
var int numPartsGroups;
var PartsGroup currentPartsGroup;

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
    
    //Default "Nothing" accessories
    GlobalAddPart(PS_Glasses,NothingName,true,"nothing_g","none","none");
    GlobalAddPart(PS_Hat,NothingName,true,"nothing_h","none","none");
    GlobalAddPart(PS_Mask,NothingName,true,"nothing_m","none","none");

    //Glasses
    GlobalAddPartL(PS_Glasses,0,true,"default_g","FramesTex4","LensesTex5");
    GlobalAddPartL(PS_Glasses,4,true,"sci_g","FramesTex1","LensesTex1");
    GlobalAddPartL(PS_Glasses,1,true,"100%_g","Outfit1_Tex1","Outfit1_Tex1");
    GlobalAddPartL(PS_Glasses,6,true,"business_g","FramesTex1","LensesTex2");
    GlobalAddPartL(PS_Glasses,8,true,"sunglasses_g","FramesTex2","LensesTex3");
    GlobalAddPartL(PS_Glasses,26,true,"sunglasses2_g","FramesTex2","LensesTex2");
    GlobalAddPartL(PS_Glasses,25,true,"visor_g","ThugMale3Tex3","ThugMale3Tex3");

    //Skin Textures
    GlobalAddPartL(PS_Body_M,2,false,"default_b","default");
    GlobalAddPartLO(PS_Body_M,2,false,"100%_b","Outfit1_Tex1");
    GlobalAddPartL(PS_Body_M,19,false,"beanie_b","ThugSkin");
    GlobalAddPartLO(PS_Body_M,67,false,"adam_b","AdamJensenTex0");

    GlobalAddPartL(PS_Body_F,2,false,"default_b","default");
    //GlobalAddPartLO(PS_Body_F,2,false,"100%_b","Outfit1_Tex1",,,"Outfit1_Tex1");
    GlobalAddPartLO(PS_Body_F,2,false,"100%_b","Outfit1_Tex1");

    //Pants
    GlobalAddPartL(PS_Legs,3,false,"default_p","JCDentonTex3");
    GlobalAddPartL(PS_Legs,22,false,"lab_p","PantsTex1");
    GlobalAddPartL(PS_Legs,21,false,"gilbertrenton_p","PantsTex3"); //Also used by Ford Schick and Boat Person
    GlobalAddPartLO(PS_Legs,2,false,"100%_p","Outfit1_Tex1");
    GlobalAddPartLO(PS_Legs,5,false,"paul_p","PantsTex8"); //Also used by Toby Atanwe and others
    GlobalAddPartLO(PS_Legs,6,false,"businessman1_p","Businessman1Tex2");
    GlobalAddPartLO(PS_Legs,46,false,"businessman2_p","Businessman2Tex2");
    GlobalAddPartLO(PS_Legs,3,false,"ajacobson_p","AlexJacobsonTex2");
    GlobalAddPartLO(PS_Legs,8,false,"unatco_p","UnatcoTroopTex1");
    GlobalAddPartLO(PS_Legs,11,false,"chef_p","PantsTex10"); //Also used by Luminous Path members
    GlobalAddPartLO(PS_Legs,9,false,"mechanic_p","MechanicTex2");
    GlobalAddPartLO(PS_Legs,17,false,"soldier_p","SoldierTex2");
    GlobalAddPartLO(PS_Legs,18,false,"riotcop_p","RiotCopTex1");
    GlobalAddPartLO(PS_Legs,20,false,"nsf_p","TerroristTex2");
    GlobalAddPartLO(PS_Legs,25,false,"mj12_p","MJ12TroopTex1");
    GlobalAddPartLO(PS_Legs,32,false,"carter_p","SamCarterTex2");
    GlobalAddPartLO(PS_Legs,31,false,"sailor_p","SailorTex2");
    GlobalAddPartLO(PS_Legs,21,false,"bum_p","PantsTex4");
    //GlobalAddPartLO(PS_Legs,22,false,"lebedev_p","JuanLebedevTex3"); //Exactly the same as the regular NSF pants
    GlobalAddPartLO(PS_Legs,37,false,"thug_p","ThugMale2Tex2");
    GlobalAddPartLO(PS_Legs,55,false,"thug2_p","ThugMaleTex3");
    GlobalAddPartL(PS_Legs,7,false,"mib_p","PantsTex5"); //Also used for Butler, and several others
    GlobalAddPartL(PS_Legs,20,false,"brown_p","PantsTex7");
    GlobalAddPartL(PS_Legs,20,false,"secretservice_p","SecretServiceTex2");
    GlobalAddPartL(PS_Legs,23,false,"junkie_p","JunkieMaleTex2");
    GlobalAddPartLO(PS_Legs,62,false,"jojo_p","JoJoFineTex2");
    GlobalAddPartLO(PS_Legs,64,false,"thug3_p","ThugMale3Tex2");
    GlobalAddPartLO(PS_Legs,65,false,"cop_p","CopTex2");
    GlobalAddPartLO(PS_Legs,66,false,"howardstrong_p","HowardStrongTex2");
    GlobalAddPartLO(PS_Legs,71,false,"chad_p","ChadTex2");
    //GlobalAddPartLO(PS_Legs,29,false,"dentonclone_p","DentonCloneTex2"); //FAIL, these suck
    GlobalAddPartLO(PS_Legs,60,false,"lowclass_p","PantsTex6");
    GlobalAddPartLO(PS_Legs,60,false,"lowclass_p2","PantsTex2"); //Also used by Jaime Reyes, and others
    GlobalAddPartLO(PS_Legs,77,false,"lowclass2_p","LowerClassMale2Tex2");
    GlobalAddPartLO(PS_Legs,72,false,"janitor_p","JanitorTex2");
    GlobalAddPartLO(PS_Legs,73,false,"martialartist_p","Male4Tex2");
    GlobalAddPartLO(PS_Legs,74,false,"tong_p","TracerTongTex2");
    GlobalAddPartLO(PS_Legs,75,false,"hkmilitary_p","HKMilitaryTex2");
    GlobalAddPartLO(PS_Legs,57,false,"vp_p","MichaelHamnerTex2");
    GlobalAddPartLO(PS_Legs,79,false,"vinny_p","NathanMadisonTex2");
    GlobalAddPartLO(PS_Legs,81,false,"page_p","BobPageTex2");
    GlobalAddPartLO(PS_Legs,82,false,"gordonquick_p","GordonQuickTex3");
    GlobalAddPartLO(PS_Legs,83,false,"redarrow_p","TriadRedArrowTex3");
    GlobalAddPartLO(PS_Legs,26,false,"jock_p","JockTex3");
    GlobalAddPartLO(PS_Legs,89,false,"maxchen_p","MaxChenTex3");
    //Female
    GlobalAddPartL(PS_Legs,3,false,"default_p","JCDentonTex3");
    GlobalAddPartLO(PS_Legs,4,false,"lab_pf","ScientistFemaleTex3");
    GlobalAddPartLO(PS_Legs,2,false,"100%_p","Outfit1_Tex1");
    GlobalAddPartLO(PS_Legs,13,false,"goldbrown_p","Outfit2F_Tex3");
    GlobalAddPartLO(PS_Legs,15,false,"matrix_p","Outfit4F_Tex3");
    GlobalAddPartLO(PS_Legs,16,false,"goth_p","Outfit3F_Tex3");
    GlobalAddPartLO(PS_Legs,38,false,"anna_p","PantsTex9");
    GlobalAddPartLO(PS_Legs,39,false,"tiffany_p","TiffanySavageTex2");
    GlobalAddPartL(PS_Legs,24,false,"junkie_p2","JunkieFemaleTex2");
    GlobalAddPartLO(PS_Legs,29,false,"dentonclone_pf","DentonCloneTex2Fem");
    
    //Dress Pants
    GlobalAddPartLO(PS_DressLegs,49,false,"nurse_p","LegsTex1");
    GlobalAddPartLO(PS_DressLegs,19,false,"stockings_p","LegsTex2");
    GlobalAddPartLO(PS_DressLegs,42,false,"hooker_p","Hooker1Tex1");
    GlobalAddPartLO(PS_DressLegs,51,false,"hooker2_p","Hooker2Tex1");
    GlobalAddPartLO(PS_DressLegs,56,false,"alex_p","Outfit5F_Tex1");
    GlobalAddPartLO(PS_DressLegs,58,false,"rachel_p","RachelMeadTex2");
    GlobalAddPartLO(PS_DressLegs,59,false,"business_p","BusinessWoman1Tex2");
    GlobalAddPartLO(PS_DressLegs,28,false,"nicolette_p","NicoletteDuClareTex3");
    GlobalAddPartLO(PS_DressLegs,40,false,"sarah_p","SarahMeadTex3");
    GlobalAddPartLO(PS_DressLegs,92,false,"office_p","Female2Tex1");

    //Skirts
    GlobalAddPartLO(PS_Skirt,28,false,"nicolette_sk","NicoletteDuClareTex2","NicoletteDuClareTex2");
    GlobalAddPartLO(PS_Skirt,40,false,"sarah_sk","SarahMeadTex2","SarahMeadTex2");
    GlobalAddPartLO(PS_Skirt,42,false,"hooker_sk","Hooker1Tex2","Hooker1Tex2");
    GlobalAddPartLO(PS_Skirt,51,false,"hooker2_sk","Hooker2Tex2","Hooker2Tex2");
    GlobalAddPartLO(PS_Skirt,56,false,"alex_sk","Outfit5F_Tex2","Outfit5F_Tex2");

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
    GlobalAddPartLO(PS_Torso_M,62,false,"jojo_s","JoJoFineTex1");
    GlobalAddPartLO(PS_Torso_M,63,false,"bartender_s","BartenderTex1");
    GlobalAddPartLO(PS_Torso_M,64,false,"thug3_s","ThugMale3Tex1");
    GlobalAddPartLO(PS_Torso_M,65,false,"cop_s","CopTex1");
    GlobalAddPartLO(PS_Torso_M,66,false,"howardstrong_s","HowardStrongTex1");
    GlobalAddPartLO(PS_Torso_M,67,false,"adam_s","AdamJensenTex3");
    GlobalAddPartLO(PS_Torso_M,67,false,"adam_s2","AdamJensenTex2");
    GlobalAddPartLO(PS_Torso_M,29,false,"dentonclone_s","DentonCloneTex3");
    GlobalAddPartLO(PS_Torso_M,69,false,"everett_s","MorganEverettTex1");
    GlobalAddPartLO(PS_Torso_M,70,false,"boatperson_s","BoatPersonTex1");
    GlobalAddPartLO(PS_Torso_M,60,false,"lowclass_s","LowerClassMaleTex1");
    GlobalAddPartLO(PS_Torso_M,71,false,"chad_s","ChadTex1");
    GlobalAddPartLO(PS_Torso_M,72,false,"janitor_s","JanitorTex1");
    GlobalAddPartLO(PS_Torso_M,73,false,"martialartist_s","Male4Tex1");
    GlobalAddPartLO(PS_Torso_M,74,false,"tong_s","TracerTongTex1");
    GlobalAddPartLO(PS_Torso_M,75,false,"hkmilitary_s","HKMilitaryTex1");
    GlobalAddPartLO(PS_Torso_M,56,false,"alex_s","AlexDentonMaleTex2");

    //Female
    GlobalAddPartLO(PS_Torso_F,28,false,"nicolette_s","NicoletteDuClareTex1");
    GlobalAddPartLO(PS_Torso_F,38,false,"anna_s","AnnaNavarreTex1");
    GlobalAddPartLO(PS_Torso_F,39,false,"tiffany_s","TiffanySavageTex1");
    GlobalAddPartLO(PS_Torso_F,40,false,"sarah_s","SarahMeadTex1");
    GlobalAddPartLO(PS_Torso_F,40,false,"shea_s","JordanSheaTex1");
    GlobalAddPartLO(PS_Torso_F,42,false,"hooker_s","Hooker1Tex3");
    GlobalAddPartLO(PS_Torso_F,51,false,"hooker2_s","Hooker2Tex3");
    GlobalAddPartLO(PS_Torso_F,54,false,"junkie_s","JunkieFemaleTex1");
    GlobalAddPartLO(PS_Torso_F,56,false,"alex_s","Outfit5F_Tex3");
    GlobalAddPartLO(PS_Torso_F,21,false,"bum_sf","BumFemaleTex1");
    GlobalAddPartLO(PS_Torso_F,60,false,"lowclass_sf","LowerClassFemaleTex1");
    GlobalAddPartLO(PS_Torso_F,61,false,"sandrarenton_s","SandraRentonTex1");
    GlobalAddPartLO(PS_Torso_F,29,false,"dentonclone_sf","DentonCloneTex3Fem");
    
    //========================================================
    //  GM_Trench
    //========================================================

    BeginNewPartsGroup("GM_Trench", true, false);
    GroupAddParts(PS_Body_M);
    //GroupTranspose(PS_Trench,1,5);
    //GroupTranspose(PS_Torso_M,4);
    GroupTranspose(PS_Legs,2);
    GroupTranspose(PS_Glasses,6,7);

    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_g");
    
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
    AddPartLO(PS_Torso_M,82,false,"gordonquick_s",,,,,"GordonQuickTex1");
    AddPartLO(PS_Torso_M,83,false,"redarrow_s",,,,,"TriadRedArrowTex1");
    AddPartLO(PS_Torso_M,26,false,"jock_s",,,,,"JockTex1");
    AddPartLO(PS_Torso_M,85,false,"jaime_s",,,,,"JaimeReyesTex1");
    AddPartLO(PS_Torso_M,86,false,"toby_s",,,,,"TobyAtanweTex1");
    AddPartLO(PS_Torso_M,87,false,"garysavage_s",,,,,"GarySavageTex1");
    AddPartLO(PS_Torso_M,89,false,"maxchen_s",,,,,"MaxChenTex1");
    AddPartLO(PS_Torso_M,94,false,"manderley_s",,,,,"JosephManderleyTex1");
    
    //Trenchcoats
    AddPartL(PS_Trench,3,false,"default_t",,"JCDentonTex2",,,,"JCDentonTex2");
    AddPartLO(PS_Trench,4,false,"lab_t",,"LabCoatTex1",,,,"LabCoatTex1");
    AddPartLO(PS_Trench,2,false,"100%_t",,"Outfit1_Tex1",,,,"Outfit1_Tex1");
    AddPartLO(PS_Trench,5,false,"paul_t",,"PaulDentonTex2",,,,"PaulDentonTex2");
    AddPartLO(PS_Trench,21,false,"bum_t",,"BumMaleTex2",,,,"BumMaleTex2");
    AddPartLO(PS_Trench,44,false,"bum2_t",,"BumMale2Tex2",,,,"BumMale2Tex2");
    AddPartLO(PS_Trench,88,false,"bum3_t",,"BumMale3Tex2",,,,"BumMale3Tex2");
    AddPartLO(PS_Trench,22,false,"lebedev_t",,"JuanLebedevTex2",,,,"JuanLebedevTex2");
    AddPartLO(PS_Trench,23,false,"smuggler_t",,"SmugglerTex2",,,,"SmugglerTex2");
    AddPartLO(PS_Trench,24,false,"simons_t",,"WaltonSimonsTex2",,,,"WaltonSimonsTex2");
    AddPartLO(PS_Trench,45,false,"harleyfilben_t",,"HarleyFilbenTex2",,,,"HarleyFilbenTex2");
    AddPartLO(PS_Trench,50,false,"gilbertrenton_t",,"GilbertRentonTex2",,,,"GilbertRentonTex2");
    AddPartLO(PS_Trench,52,false,"ford_t",,"FordSchickTex2",,,,"FordSchickTex2");
    AddPartLO(PS_Trench,55,false,"thug2_t",,"ThugMaleTex2");
    AddPartLO(PS_Trench,82,false,"gordonquick_t",,"GordonQuickTex2",,,,"GordonQuickTex2");
    AddPartLO(PS_Trench,83,false,"redarrow_t",,"TriadRedArrowTex2",,,,"TriadRedArrowTex2");
    AddPartLO(PS_Trench,26,false,"jock_t",,"JockTex2",,,,);
    AddPartLO(PS_Trench,85,false,"toby_t",,"TobyAtanweTex2",,,,"TobyAtanweTex2");
    AddPartLO(PS_Trench,89,false,"maxchen_t",,"MaxChenTex2",,,,"MaxChenTex2");
    AddPartLO(PS_Trench,94,false,"manderley_t",,"JosephManderleyTex2",,,,"JosephManderleyTex2");

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
    GroupTranspose(PS_Legs,2);
    GroupTranspose(PS_Glasses,6,7);
    
    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_g");
    
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
    OutfitAddPartReference("lab_pf");
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
    GroupTranspose(PS_DressLegs,3);
    GroupTranspose(PS_Glasses,6,7);
    
    //Unique Torsos
    AddPartLO(PS_Torso_F,19,false,"wib_s",,,,,"WIBTex1","WIBTex1");
    AddPartLO(PS_Torso_F,27,false,"maggie_s",,,,,"MaggieChowTex1","MaggieChowTex1");
    AddPartLO(PS_Torso_F,49,false,"nurse_s",,,,,"NurseTex1","NurseTex1");
    AddPartLO(PS_Torso_F,57,false,"vp_sf",,,,,"MargaretWilliamsTex1","MargaretWilliamsTex1");
    AddPartLO(PS_Torso_F,58,false,"rachel_s",,,,,"RachelMeadTex1","RachelMeadTex1");
    AddPartLO(PS_Torso_F,59,false,"business_s",,,,,"BusinessWoman1Tex1","BusinessWoman1Tex1");
    AddPartLO(PS_Torso_F,90,false,"secretary_s",,,,,"SecretaryTex2","SecretaryTex2");
    AddPartLO(PS_Torso_F,92,false,"office_s",,,,,"Female2Tex2","Female2Tex2");
    AddPartLO(PS_Torso_F,93,false,"maid_s",,,,,"MaidTex1","MaidTex1");
    
    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_g");
    
    //WIB Outfit
    BeginNewOutfitL("wib",19);
    OutfitAddPartReference("stockings_p");
    OutfitAddPartReference("wib_s");
    OutfitAddPartReference("sunglasses_g");
    
    //Maggie Chow's Outfit
    BeginNewOutfitL("maggie",27);
    OutfitAddPartReference("stockings_p");
    OutfitAddPartReference("maggie_s");
    OutfitAddPartReference("sunglasses_g");

    //Nurse Outfit
    BeginNewOutfitL("nurse",49);
    OutfitAddPartReference("nurse_p");
    OutfitAddPartReference("nurse_s");
    
    //Vice President
    BeginNewOutfitL("vicepresident",57);
    OutfitAddPartReference("stockings_p");
    OutfitAddPartReference("vp_sf");

    //Rachel Mead
    BeginNewOutfitL("meadrachel",58);
    OutfitAddPartReference("rachel_p");
    OutfitAddPartReference("rachel_s");

    //Business Woman
    BeginNewOutfitL("businesswoman",59);
    OutfitAddPartReference("business_p");
    OutfitAddPartReference("business_s");

    //Secretary
    BeginNewOutfitL("secretary",90);
    OutfitAddPartReference("secretary_s");
    OutfitAddPartReference("nurse_p");
    OutfitAddPartReference("business_g");
    
    //Office Lady
    BeginNewOutfitL("office",92);
    OutfitAddPartReference("office_s");
    OutfitAddPartReference("office_p");
    
    //Maid
    BeginNewOutfitL("maid",93);
    OutfitAddPartReference("maid_s");
    OutfitAddPartReference("stockings_p");

    //========================================================
    //  GFM_Dress
    //========================================================

    BeginNewPartsGroup("GFM_Dress", false, true);
    GroupTranspose(PS_Body_F,7);
    GroupTranspose(PS_Legs,1);
    GroupTranspose2(PS_DressLegs,PS_Legs,1);
    GroupTranspose(PS_Skirt,2,4);
    GroupTranspose(PS_Torso_F,3);
    
    //Defaults
    AddDefaultReference("default_b");
    
    //Nicollette DuClare's outfit
    BeginNewOutfitL("nicolette",28);
    OutfitAddPartReference("nicolette_p");
    OutfitAddPartReference("nicolette_s");
    OutfitAddPartReference("nicolette_sk");
    
    //Sarah Mead
    BeginNewOutfitL("meadsarah",40);
    OutfitAddPartReference("sarah_p");
    OutfitAddPartReference("sarah_s");
    OutfitAddPartReference("sarah_sk");
    
    //Hooker
    BeginNewOutfitL("hooker",42);
    OutfitAddPartReference("hooker_p");
    OutfitAddPartReference("hooker_s");
    OutfitAddPartReference("hooker_sk");
    
    //Hooker2
    BeginNewOutfitL("assless",51);
    OutfitAddPartReference("hooker2_p");
    OutfitAddPartReference("hooker2_s");
    OutfitAddPartReference("hooker2_sk");
    
    //Alex Denton
    BeginNewOutfitL("alex",56);
    OutfitAddPartReference("alex_p");
    OutfitAddPartReference("alex_s");
    OutfitAddPartReference("alex_sk");

    //========================================================
    //  GFM_TShirtPants
    //========================================================
    
    BeginNewPartsGroup("GFM_TShirtPants", false, true);
    GroupAddParts(PS_Body_F);
    GroupTranspose(PS_Legs,6);
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
    BeginNewOutfitL("adam",67);
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
    BeginNewOutfitL("dentonclone",29);
    OutfitAddPartReference("dentonclone_s");
    OutfitAddPartReference("dentonclone_pf"); //Female legs work for male
    
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
    AddPartL(PS_Hat,11,true,"chef_h",,,,,,,,"ChefTex3");
    AddPartL(PS_Hat,18,true,"sailor_h","SailorSkin",,,,,,,"SailorTex3");
    AddPartL(PS_Hat,29,true,"ponytail_g",,,,,,,,"PonyTailTex1");
    
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
    BeginNewOutfitL("lowclass",77);
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

    //Jumpsuit specific helmets
    AddPartL(PS_Hat,10,true,"unatco_h",,,,,,,"UNATCOTroopTex3");
    AddPartL(PS_Hat,12,true,"soldier_h",,,,"SoldierTex0",,,"SoldierTex3");
    //AddPartL(PS_Hat,12,true,"soldier_h",,,,,,,"SoldierTex3");
    AddPartL(PS_Hat,13,true,"mechanic_h",,,,,,,"MechanicTex3");
    AddPartLO(PS_Hat,18,true,"riotcop_h",,,,,,,"RiotCopTex3",,"VisorTex1");
    AddPartL(PS_Hat,16,true,"nsf_h",,,,,,,"GogglesTex1");
    AddPartL(PS_Hat,17,true,"mj12_h",,,,,,"MJ12TroopTex3","MJ12TroopTex4");
    AddPartL(PS_Hat,27,true,"mj12elite_h",,,,,,"MJ12EliteTex3","MJ12EliteTex3");
    
    //Defaults
    AddDefaultReference("default_b");
    AddDefaultReference("nothing_m");
    AddDefaultReference("nothing_h");

    //test
    //AddPartLO(PS_Torso_M,31,false,"sailor_s",,,"SailorTex1");
    
    //Masks
    //Can only realistically be used on this model
    //TODO: Either make these not count as accessories (set arg 3 to false), or
    //add in a system whereby we always assign a default texture
    AddPartL(PS_Body_M,9,false,"unatco_b",,,,"MiscTex1JC","MiscTex1JC","GrayMaskTex");
    AddPartL(PS_Body_M,15,false,"nsf_b",,,,"TerroristTex0","TerroristTex0","GrayMaskTex");
    AddPartL(PS_Body_M,28,false,"mj12elite_b",,,,"MJ12EliteTex0","MJ12EliteTex0","GrayMaskTex");
    
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
     savedOutfitIndex=1
     outfitInfos(0)=(Name="JC Denton's Trenchcoat",Desc="An old classic. This blue trenchcoat fits well over anything, and gives JC a cool, augmented look")
     outfitInfos(1)=(Name="JC Denton's Trenchcoat (Alt)",Desc="JC Denton's Signature Trenchcoat, now with extra jewellery!")
     outfitInfos(2)=(Name="100% Black",Desc="The outfit of choice for Malkavians",PickupMessage="We're 100% Black",HighlightName="???")
     outfitInfos(3)=(Name="Alex Jacobson's Outfit",Desc="Used by hackers everywhere!")
     outfitInfos(4)=(Name="Lab Coat",Desc="Discovery Awaits!")
     outfitInfos(5)=(Name="Paul Denton's Outfit")
     outfitInfos(6)=(Name="Fancy Suit",Desc="For very special agents")
     outfitInfos(7)=(Name="MIB Black Suit",Desc="For very special agents")
     outfitInfos(8)=(Name="UNATCO Combat Uniform")
     outfitInfos(9)=(Name="Mechanic Jumpsuit")
     outfitInfos(11)=(Name="Chef Outfit",Desc="Something about cooking, IDK") //!!!
     outfitInfos(13)=(Name="Gold and Brown Business")
     outfitInfos(14)=(Name="Goth GF Outfit")
     outfitInfos(15)=(Name="Matrix Outfit",Desc="This outfit is considered one of the classic three. From the immortal Trinity, if you will...")
     outfitInfos(16)=(Name="Goth GF Outfit") //!!!
     outfitInfos(17)=(Name="Soldier Outfit")
     outfitInfos(18)=(Name="Riot Gear")
     outfitInfos(19)=(Name="WIB Suit",Desc="Dressed to kill")
     outfitInfos(20)=(Name="NSF Sympathiser",Desc="For the people!")
     outfitInfos(21)=(Name="Stained Clothes")
     outfitInfos(22)=(Name="Juan Lebedev's Outfit")
     outfitInfos(23)=(Name="Smuggler's Outfit",Desc="This expensive outfit matches Smuggler's prices")
     outfitInfos(24)=(Name="FEMA Executive's Outfit",Desc="Just because you work behind a desk doesn't mean you can't be fashionable")
     outfitInfos(25)=(Name="MJ12 Soldier Uniform")
     outfitInfos(26)=(Name="Jock's Outfit")
     outfitInfos(27)=(Name="Maggie's Outfit")
     outfitInfos(28)=(Name="Nicolette's Outfit")
     outfitInfos(29)=(Name="JC Clone Outfit")
     outfitInfos(30)=(Name="Presidential Suit")
     outfitInfos(31)=(Name="Sailor Outfit")
     outfitInfos(32)=(Name="Carter's Outfit")
     outfitInfos(33)=(Name="SCUBA Suit")
     outfitInfos(34)=(Name="100% Black (Alt)",Desc="OMG! It's just like the memes!")
     outfitInfos(35)=(Name="Prison Uniform")
     outfitInfos(36)=(Name="100% Black (Augmented Edition)")
     outfitInfos(37)=(Name="Thug Outfit")
     outfitInfos(38)=(Name="Anna Navarre's Outfit")
     outfitInfos(39)=(Name="Tiffany Savage's Outfit")
     outfitInfos(40)=(Name="Sarah Mead's Outfit")
     outfitInfos(41)=(Name="Jordan Shea's Outfit")
     outfitInfos(42)=(Name="Hooker Outfit")
     outfitInfos(43)=(Name="NSF Sympathiser (Alt)")
     outfitInfos(44)=(Name="Unwashed Clothes")
     outfitInfos(45)=(Name="Harley Filben's Outfit")
     outfitInfos(46)=(Name="White Business Suit")
     outfitInfos(47)=(Name="Secret Service Suit")
     outfitInfos(48)=(Name="Doctor's Outfit")
     outfitInfos(49)=(Name="Nurse's Outfit")
     outfitInfos(50)=(Name="Gilbert Renton's Outfit")
     outfitInfos(51)=(Name="Hooker Outfit (Alt)")
     outfitInfos(52)=(Name="Ford Schick's Outfit")
     outfitInfos(53)=(Name="Joe Greene's Outfit")
     outfitInfos(54)=(Name="Soiled Junkie Clothes")
     outfitInfos(55)=(Name="Rook Member Outfit")
     outfitInfos(56)=(Name="Alex Denton's Outfit",Desc="Say the line, JC!")
     outfitInfos(57)=(Name="Vice President's Outfit")
     outfitInfos(58)=(Name="Rachel Mead's Outfit")
     outfitInfos(59)=(Name="Business Outfit",Desc="Show them you mean business!")
     outfitInfos(60)=(Name="Low Class Outfit")
     outfitInfos(61)=(Name="Sandra Renton's Outfit")
     outfitInfos(62)=(Name="NSF Leader Outfit") //!!!
     outfitInfos(63)=(Name="Bartender Outfit")
     outfitInfos(64)=(Name="Tough Guy Outfit")
     outfitInfos(65)=(Name="Police Uniform")
     outfitInfos(66)=(Name="Howard Strong's Outfit")
     outfitInfos(67)=(Name="Adam Jensen's Outfit")
     outfitInfos(68)=(Name="Average GEPGUN Enjoyer",Desc="What's it like to stand around revving your actuators while the more fashionable agents complete the mission?")
     outfitInfos(69)=(Name="Morgan Everett's Outfit")
     outfitInfos(70)=(Name="Boat Person Outfit")
     outfitInfos(71)=(Name="Chad's Outfit")
     outfitInfos(72)=(Name="Janitor Uniform")
     outfitInfos(73)=(Name="Martial Arts Uniform")
     outfitInfos(74)=(Name="Tracer Tong's Outfit")
     outfitInfos(75)=(Name="Hong Kong Military Uniform")
     outfitInfos(76)=(Name="MJ12 Elite Uniform",Desc="Give me Deus Ex")
     outfitInfos(77)=(Name="Citizens Attire")
     outfitInfos(78)=(Name="Luminous Path Uniform")
     outfitInfos(79)=(Name="Navy Dress Uniform")
     outfitInfos(80)=(Name="Butler Uniform")
     outfitInfos(81)=(Name="Bob Page's Signature Suit")
     outfitInfos(82)=(Name="Gordon Quick's Outfit")
     outfitInfos(83)=(Name="Red Arrow Uniform")
     outfitInfos(85)=(Name="Jaime's Outfit") //!!!
     outfitInfos(86)=(Name="Illuminati Coat")
     outfitInfos(87)=(Name="Vandenberg Scientist Outfit")
     outfitInfos(88)=(Name="Old Clothes")
     outfitInfos(89)=(Name="Dragon Head's Uniform")
     outfitInfos(90)=(Name="Secretary's Outfit")
     outfitInfos(91)=(Name="Adam Jensen's Outfit (Alt)")
     outfitInfos(92)=(Name="Office Worker's Outfit")
     outfitInfos(93)=(Name="Maid Outfit")
     outfitInfos(94)=(Name="Manderley's Outfit")
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
     partNames(25)="Tech Visor"
     partNames(26)="Dark Glasses"
     partNames(27)="MJ12 Elite Helmet"
     partNames(28)="MJ12 Elite Tacticool Gear"
     partNames(29)="Ponytail"
     CustomOutfitName="(Custom)"
     NothingName="Nothing"
}
