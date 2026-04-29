//=============================================================================
// SARGE: WeaponSkinManager
// Manages displaying, unlocking, and selecting weapon skins
//=============================================================================

class WeaponSkinManager extends WeaponSkinManagerBase;

//SARGE: Weapon skin system
struct WeaponSkin
{
    //We can't use arrays in defaultproperties
    //This is AWFUL!!
    //var string textures[8];
    //var string texturesHDTP[8];
    var string tex0;
    var string tex1;
    var string tex2;
    var string tex3;
    var string tex4;
    var string tex5;
    var string tex6;
    var string tex7;
    var string hdtpTex0;
    var string hdtpTex1;
    var string hdtpTex2;
    var string hdtpTex3;
    var string hdtpTex4;
    var string hdtpTex5;
    var string hdtpTex6;
    var string hdtpTex7;
    var string tex03rd;
    var string tex13rd;
    var string tex23rd;
    var string tex33rd;
    var string tex43rd;
    var string tex53rd;
    var string tex63rd;
    var string tex73rd;
    var string hdtpTex03rd;
    var string hdtpTex13rd;
    var string hdtpTex23rd;
    var string hdtpTex33rd;
    var string hdtpTex43rd;
    var string hdtpTex53rd;
    var string hdtpTex63rd;
    var string hdtpTex73rd;
    var string fomodTex0;
    var string fomodTex1;
    var string fomodTex2;
    var string fomodTex3;
    var string fomodTex4;
    var string fomodTex5;
    var string fomodTex6;
    var string fomodTex7;
    var string fomodTex03rd;
    var string fomodTex13rd;
    var string fomodTex23rd;
    var string fomodTex33rd;
    var string fomodTex43rd;
    var string fomodTex53rd;
    var string fomodTex63rd;
    var string fomodTex73rd;
    var string mainTexture;
    var string hdtpMainTexture;
    var string fomodMainTexture;
    var string mainTexture3rd;
    var string hdtpMainTexture3rd;
    var string fomodMainTexture3rd;
    var string skinName;
    var string id;
    var bool bUnlocked;
    var string weaponClass;
    var string ownerClasses[10];
    var int numOwnerClasses;
    var string beltIconTex;
    var string largeIconTex;
};

struct ProjectileSkin
{
    var string id;
    var string texes[9];
    var string hdtpTexes[9];
    var string fomodTexes[9];
};

var private const localized string WeaponSkinNames[255]; //SARGE: Allow localization
var private transient WeaponSkin WeaponSkins[255];
var private transient int numWeaponSkins;
var private transient int currentWeaponSkin;
var private transient DeusExPlayer player;

var private transient bool bInited;

var const localized string msgDefault;
var const localized string msgUnlocked;

var travel string unlockedWeaponSkins[255];      //SARGE: The ids of unlocked weapon skins
var globalconfig string unlockedWeaponSkinsGlobal[255];  //SARGE: the ids of unlocked weapon skins from previous playthroughs.

var private transient ProjectileSkin ProjectileSkins[255];
var private transient int numProjectileSkins;
var private transient int currentProjectileSkin;

var globalconfig bool bSwitchToNewSkins;

const SKIN_PREFIX = "Augmentique.WeaponSkins.";

function Init(DeusExPlayer newPlayer)
{
    local DeusExLevelInfo dxInfo;

    if (bInited)
        return;

    player = newPlayer;
    currentWeaponSkin = -1;
    currentProjectileSkin = -1;
    dxInfo = player.GetLevelInfo();
    
    ////AssaultGun

    //Lemon-Lime Assault Gun
    AddSkinL("lemonlime","DeusEx.WeaponAssaultGun",4);
    AddSkinTex(1,SKIN_PREFIX $ "AssaultGunLemonLime1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "AssaultGunLemonLime3rd");
    Add3rdSkinTex(1,SKIN_PREFIX $ "AssaultGunLemonLime3rd");
    
    //UNATCO Assault Gun
    AddSkinL("unatco","DeusEx.WeaponAssaultGun",2);
    AddSkinOwnerClass("DeusEx.UNATCOTroop");
    AddSkinTex(1,SKIN_PREFIX $ "AssaultGunUNATCO1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "AssaultGunUNATCO3rd");
    Add3rdSkinTex(1,SKIN_PREFIX $ "AssaultGunUNATCO3rd");
    
    //MJ12 Assault Gun
    AddSkinL("mj12","DeusEx.WeaponAssaultGun",7);
    AddSkinOwnerClass("DeusEx.MJ12Troop");
    AddSkinOwnerClass("DeusEx.MJ12Elite");
    AddSkinOwnerClass("DeusEx.MJ12Elite2");
    AddSkinTex(1,SKIN_PREFIX $ "AssaultGunMJ121");
    Add3rdSkinTex(0,SKIN_PREFIX $ "AssaultGunMJ123rd");
    Add3rdSkinTex(1,SKIN_PREFIX $ "AssaultGunMJ123rd");
    
    //HK Assault Gun
    AddSkinL("hongkong","DeusEx.WeaponAssaultGun",9);
    AddSkinOwnerClass("DeusEx.HKMilitary");
    AddSkinTex(1,SKIN_PREFIX $ "AssaultGunHK1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "AssaultGunHK3rd");
    Add3rdSkinTex(1,SKIN_PREFIX $ "AssaultGunHK3rd");

    ////Assault Shotgun
    
    //UNATCO Assault Shotgun
    AddSkinL("unatco","DeusEx.WeaponAssaultShotgun",2);
    AddSkinOwnerClass("DeusEx.UNATCOTroop");
    AddSkinTex(0,SKIN_PREFIX $ "AssaultShotgunUNATCO1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "AssaultShotgunUNATCO3rd");
    Add3rdSkinTex(1,SKIN_PREFIX $ "AssaultShotgunUNATCO3rd");

    //Smugglers Special
    AddSkinL("smuggler","DeusEx.WeaponAssaultShotgun",5);
    AddSkinTex(0,SKIN_PREFIX $ "SmugglerShotgun1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "SmugglerShotgun3rd");
    Add3rdSkinTex(1,SKIN_PREFIX $ "SmugglerShotgun3rd");
    
    //MJ12 Assault Shotgun
    AddSkinL("mj12","DeusEx.WeaponAssaultShotgun",7);
    AddSkinOwnerClass("DeusEx.MJ12Troop");
    AddSkinOwnerClass("DeusEx.MJ12Elite");
    AddSkinOwnerClass("DeusEx.MJ12Elite2");
    AddSkinTex(0,SKIN_PREFIX $ "MJ12AssaultShotgun1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "MJ12AssaultShotgun3rd");
    Add3rdSkinTex(1,SKIN_PREFIX $ "MJ12AssaultShotgun3rd");

    ////Baton

    //Riot Gear
    AddSkinL("riot","DeusEx.WeaponBaton",8);
    AddSkinOwnerClass("DeusEx.RiotCop");
    AddSkinTex(0,SKIN_PREFIX $ "RiotPoliceBaton1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "RiotPoliceBaton3rd");
    
    ////Combat Knife

    //HK
    AddSkinL("hongkong","DeusEx.WeaponCombatKnife",9);
    AddSkinOwnerClass("DeusEx.HKMilitary");
    AddSkinTex(0,SKIN_PREFIX $ "CombatKnifeHK1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "CombatKnifeHK3rd");
    
    ////Flamethrower (Flammenwerfer)

    //HK
    AddSkinL("hongkong","DeusEx.WeaponFlamethrower",9);
    AddSkinOwnerClass("DeusEx.HKMilitary");
    AddSkinTex(2,SKIN_PREFIX $ "FlamethrowerHK1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "FlamethrowerHK3rd");
    
    ////LAM

    //Green
    AddSkinL("green","DeusEx.WeaponLAM",10);
    AddSkinTex(1,SKIN_PREFIX $ "GreenLAM1");
    AddSkinTex(3,SKIN_PREFIX $ "GreenLAM1");
    //Add3rdSkinTex(0,SKIN_PREFIX $ "GreenLAM3rd");
    //Add3rdSkinTex(1,SKIN_PREFIX $ "GreenLAM3rd");

    AddProjectileSkin("green","DeusEx.WeaponLAM");
    AddProjectileSkinTex(0,SKIN_PREFIX $ "GreenLAM3rd");
    AddProjectileSkinTex(1,SKIN_PREFIX $ "GreenLAM3rd");
    
    ////GEPGUN

    //Hotpink
    AddSkinL("hotpink","DeusEx.WeaponGEPGun",11);
    AddSkinTex(1,SKIN_PREFIX $ "HotpinkGEPGun1");
    AddSkinTex(0,SKIN_PREFIX $ "HotpinkGEPGun1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "HotpinkGEPGun3rd");
    Add3rdSkinTex(1,SKIN_PREFIX $ "HotpinkGEPGun3rd");
    Add3rdSkinTex(2,SKIN_PREFIX $ "HotpinkGEPGun3rd");
    
    AddProjectileSkin("hotpink","DeusEx.WeaponGEPGun");
    AddProjectileSkinTex(0,SKIN_PREFIX $ "PinkRocket");
    
    ////Pepper

    //Riot Gear
    AddSkinL("riot","DeusEx.WeaponPepperGun",8);
    AddSkinOwnerClass("DeusEx.RiotCop");
    AddSkinTex(3,SKIN_PREFIX $ "RiotPolicePepperGun1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "RiotPolicePepperGun3rd");

    ////Pistol

    //Chrome Pistol
    AddSkinL("chrome","DeusEx.WeaponPistol",0);
    AddSkinTex(3,SKIN_PREFIX $ "ChromePistol1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "ChromePistol3rd");
    
    //Golden Gun
    AddSkinL("goldengun","DeusEx.WeaponPistol",1);
    AddSkinTex(3,SKIN_PREFIX $ "goldengun1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "goldengun3rd");
    
    //UNATCO Pistol
    AddSkinL("unatco","DeusEx.WeaponPistol",2);
    AddSkinOwnerClass("DeusEx.UNATCOTroop");
    AddSkinTex(3,SKIN_PREFIX $ "UNATCOPistol1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "UNATCOPistol3rd");
    
    //Riot Police Pistol
    AddSkinL("riot","DeusEx.WeaponPistol",8);
    AddSkinOwnerClass("DeusEx.RiotCop");
    AddSkinTex(3,SKIN_PREFIX $ "RiotPolicePistol1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "RiotPolicePistol3rd");
    
    ////Crossbow

    //Black Crossbow
    AddSkinL("black","DeusEx.WeaponMiniCrossbow",3);
    AddSkinOwnerClass("DeusEx.ScubaDiver");
    AddSkinTex(1,SKIN_PREFIX $ "BlackCrossbow1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "BlackCrossbow3rd");
    
    ////EMP Grenade

    //Hotpink
    AddSkinL("hotpink","DeusEx.WeaponEMPGrenade",12);
    AddSkinTex(2,SKIN_PREFIX $ "HotPinkEMP1");
    Add3rdSkinTex(1,SKIN_PREFIX $ "HotPinkEMP3rd");

    AddProjectileSkin("hotpink","DeusEx.WeaponEMPGrenade");
    AddProjectileSkinTex(1,SKIN_PREFIX $ "HotPinkEMP3rd");
    
    ////Sawed Off

    //Hotpink
    AddSkinL("hotpink","DeusEx.WeaponSawedOffShotgun",11);
    AddSkinTex(1,SKIN_PREFIX $ "HotpinkShotgun1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "HotpinkShotgun3rd");
    Add3rdSkinTex(1,SKIN_PREFIX $ "HotpinkShotgun3rd");
    
    ////Stealth Pistol

    //Black Stealth Pistol
    AddSkinL("black","DeusEx.WeaponStealthPistol",3);
    AddSkinTex(2,SKIN_PREFIX $ "BlackStealthPistol1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "BlackStealthPistol3rd");
    Add3rdSkinTex(1,SKIN_PREFIX $ "BlackStealthPistol3rd");
    
    //JoJo Fine Stealth Pistol
    AddSkinL("jojofine","DeusEx.WeaponStealthPistol",6);
    AddSkinOwnerClass("DeusEx.JoJoFine");
    AddSkinTex(2,SKIN_PREFIX $ "JoJosPistol");
    Add3rdSkinTex(0,SKIN_PREFIX $ "JoJosPistol3rd");
    Add3rdSkinTex(1,SKIN_PREFIX $ "JoJosPistol3rd");
    
    ////Rifle
    AddSkinL("mj12","DeusEx.WeaponRifle",7);
    AddSkinOwnerClass("DeusEx.MJ12Troop");
    AddSkinOwnerClass("DeusEx.MJ12Elite");
    AddSkinOwnerClass("DeusEx.MJ12Elite2");
    AddSkinTex(1,SKIN_PREFIX $ "MJ12SniperRifle1");
    AddSkinTex(7,SKIN_PREFIX $ "MJ12SniperRifle1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "MJ12SniperRifle3rd");
    Add3rdSkinTex(1,SKIN_PREFIX $ "MJ12SniperRifle3rd");
    
    ////Plasma Rifle
    AddSkinL("mj12","DeusEx.WeaponPlasmaRifle",7);
    AddSkinOwnerClass("DeusEx.MJ12Troop");
    AddSkinOwnerClass("DeusEx.MJ12Elite");
    AddSkinOwnerClass("DeusEx.MJ12Elite2");
    AddSkinTex(0,SKIN_PREFIX $ "MJ12PlasmaRifle1");
    //AddSkinTex(1,SKIN_PREFIX $ "MJ12PlasmaRifleSFX");
    Add3rdSkinTex(1,SKIN_PREFIX $ "MJ12PlasmaRifle3rd");
    //Add3rdSkinTex(3,SKIN_PREFIX $ "MJ12PlasmaRifleSFX");
    
    ////Sword

    //Hotpink
    AddSkinL("hotpink","DeusEx.WeaponSword",11);
    AddSkinTex(1,SKIN_PREFIX $ "HotPinkSword1");
    AddSkinTex(8,SKIN_PREFIX $ "HotPinkSwordEnv"); //Reflection
    Add3rdSkinTex(0,SKIN_PREFIX $ "HotPinkSword3rd");

    //Log("WeaponSkinManager: Inited");

    //Refresh the unlock state from the stored data
    SyncFromStoredData();
    
    //When we finish the game, or if we're in training, copy our weapon skins out permanently
    if (dxInfo != None && (dxInfo.missionNumber > 90 || dxInfo.missionNumber == 0))
        CopyUnlocksToConfig();

    //RefreshAllWeapons();

    bInited = true;
}

//Detect HDTP model using mesh path. Disgusting
function static bool IsHDTP(Actor wep)
{
    return InStr(caps(string(wep.Mesh)),"HDTPITEMS.") == 0;
}

function static bool IsFomod(Actor wep)
{
    return InStr(caps(string(wep.Mesh)),"FOMOD.") == 0;
}

function ApplyWeaponSkin(DeusExWeapon wep, bool firstPerson)
{
    local int i;

    for(i = 0;i < 8;i++)
    {
        if (firstPerson)
        {
            //Log(wep.currentWeaponSkin @ "Skin: " $ wep.skinTextures[i]);
            if (wep.multiSkins[i] == None)
                wep.multiSkins[i] = wep.skinTextures[i];
        }
        else
        {
            //Log(wep.currentWeaponSkin @ "Skin: " $ wep.skinTextures3rd[i]);
            if (wep.multiSkins[i] == None)
                wep.multiSkins[i] = wep.skinTextures3rd[i];
        }
    }

    if (firstPerson)
    {
        //Log(wep.currentWeaponSkin @ "Skin: " $ wep.Skin);
        if (wep.Skin == None)
            wep.Skin = wep.skinTextures[0];
        if (wep.Texture == None)
            wep.Texture = wep.skinTextures[8];
    }
    else
    {
        //Log(wep.currentWeaponSkin @ "Skin: " $ wep.Skin);
        if (wep.Skin == None)
            wep.Skin = wep.skinTextures3rd[0];
        if (wep.Texture == None)
            wep.Texture = wep.skinTextures3rd[8];
    }
}

//AUGMENTIQUE: Once our weapons are created, we need to update their skins
function UpdateWeaponSkinsForPawn(ScriptedPawn P)
{
    local Inventory I;
    
    if (DeusExWeapon(P.Weapon) != None)
        SetDefaultSkin(DeusExWeapon(P.Weapon),P);

    I = P.Inventory;
    while (I != None)
    {
        if (I.IsA('DeusExWeapon'))
            SetDefaultSkin(DeusExWeapon(I),P);

        I = I.Inventory;
    }
}

//Unlocks skins when searching carcasses for items we can't pick up
function GetSkinFromCarcass(DeusExPlayer P, DeusExWeapon weapon, DeusExCarcass carc)
{
    local WeaponSkinDisplayItem temp;

    //Log("GetSkinFromCarcass:" @ weapon.currentWeaponSkin @ IsUnlocked(weapon));

    if (weapon == None || carc == None)
        return;

    if (weapon.currentWeaponSkin != "default" && weapon.currentWeaponSkin != "" && !IsUnlocked(weapon))
    {
        if (UnlockSkin(weapon))
        {
            //Create a temp object for the new item
            temp = carc.spawn(class'WeaponSkinDisplayItem',,, carc.Location);

            if (temp != None)
            {

                //Show the new icon
                //carc.PlaySound(weapon.CopyModsSound,SLOT_None,0.8);
                carc.AddReceivedItem(P,temp,1);
                
                //Destroy it
                temp.Destroy();
                temp = None;
            }
        }
    }
}

function RefreshAllWeapons()
{
    local DeusExWeapon W;
    local DeusExProjectile PR;
    local Pawn P;

    if (player == None)
        return;
        
    //Refresh all weapons in the map
	foreach player.AllActors(class'DeusExWeapon', W)
    {
        UpdateWeaponSkinTextures(W);
        ApplyWeaponSkin(W,false);
    }
    
    //Refresh all projectiles in the map
	foreach player.AllActors(class'DeusExProjectile', PR)
    {
        UpdateProjectileSkinTextures(PR);
        ApplyProjectileSkin(PR);
    }

    P = player.Level.PawnList;
    while (P != None)
    {
        if (P.IsA('ScriptedPawn'))
        {
            //Log("WHO THE FUCKING FUCK!!!" @ P);
            //ScriptedPawn(P).UpdateWeaponSkins();
            UpdateWeaponSkinsForPawn(ScriptedPawn(P));
        }
        P = P.nextPawn;
    }
}

//Special localized version of AddSkin
function private AddSkinL(string id, string className, int skinNameIndex, optional bool bUnlocked)
{
    AddSkin(id, className, default.WeaponSkinNames[skinNameIndex], bUnlocked);
}

function AddSkin(string id, string className, string skinName, optional bool bUnlocked)
{
    numWeaponSkins++;
    currentWeaponSkin++;
    WeaponSkins[currentWeaponSkin].id = id $ "_" $ className;
    WeaponSkins[currentWeaponSkin].weaponClass = className;
    WeaponSkins[currentWeaponSkin].skinName = skinName;
    if (bUnlocked)
        UnlockSkinByID(id $ "_" $ className,true);
}

function AddProjectileSkin(string id, string className)
{
    if (numProjectileSkins >= 255)
        return;
    
    numProjectileSkins++;
    currentProjectileSkin++;
    ProjectileSkins[currentProjectileSkin].id = id $ "_" $ className;
}

function AddSkinOwnerClass(string ownerClass)
{
    local int num;
    num = WeaponSkins[currentWeaponSkin].numOwnerClasses;

    if (num == 10)
        return;
    
    //Log("Adding owner class " $ num @ ownerClass $ " for skin " $ weaponSkins[currentWeaponSkin].id);
    WeaponSkins[currentWeaponSkin].ownerClasses[num] = ownerClass;
    WeaponSkins[currentWeaponSkin].numOwnerClasses++;
}

/*
function AddSkinMapName(string mapName, optional string tag)
{
}
*/

function ApplyProjectileSkinFrom(DeusExWeapon wep, DeusExProjectile proj)
{
    if (wep == none || proj == none)
        return;

    proj.currentWeaponSkin = wep.currentWeaponSkin;
    UpdateProjectileSkinTextures(proj);
    ApplyProjectileSkin(proj);
}

function ApplyProjectileSkin(DeusExProjectile proj)
{
    local int i;
    
    //Dirty hack for LAMs
    if (LAM(proj) != None)
    {
        LAM(proj).lightSkinTex = proj.skinTextures[1];
        return;
    }

    for(i = 0;i < 8;i++)
    {
        if (proj.multiSkins[i] == None)
            proj.multiSkins[i] = proj.skinTextures[i];
    }

    //Log(wep.currentWeaponSkin @ "Skin: " $ wep.Skin);
    if (proj.Skin == None)
        proj.Skin = proj.skinTextures[0];
    if (LAM(proj) != None)
    if (proj.Texture == None)
        proj.Texture = proj.skinTextures[8];

}

function bool CheckOwnerClasses(int id, Actor owner)
{
    local int i;

    for (i = 0;i < WeaponSkins[id].numOwnerClasses;i++)
    {
        if (WeaponSkins[id].ownerClasses[i] ~= string(Owner.Class) || WeaponSkins[id].ownerClasses[i] ~= (string(Owner.Class)$"Carcass"))
            return true;
    }
    return false;
}

function SetDefaultSkin(DeusExWeapon weapon, Actor Owner)
{
    local int i;
    local bool bOwnerCheck;

    if (Owner == None || Owner.IsA('PlayerPawn'))
        return;

    //Log("SetDefaultSkin: " $ weapon @ Owner);

    weapon.currentWeaponSkin = "default";
    UpdateWeaponSkinTextures(weapon);
    ApplyWeaponSkin(weapon,false);

    for (i=0;i < numWeaponSkins;i++)
    {
        bOwnerCheck = CheckOwnerClasses(i,Owner);

        //Log(" - Checking: " $ WeaponSkins[i].id $ ", " $ WeaponSkins[i].skinName @ "for" @ Owner);
        //Log("   -> " $ /*Caps(WeaponSkins[i].ownerClass) @ Caps(string(Owner.Class))*/bOwnerCheck);
        //Log("   -> " $ Caps(WeaponSkins[i].weaponClass) @ Caps(string(weapon.Class)));
        //Weapon Class and Skin Owner matches
        if (bOwnerCheck && WeaponSkins[i].weaponClass ~= string(weapon.Class))
        {
            weapon.currentWeaponSkin = WeaponSkins[i].id;
            //Log("   -> MATCH!" @ weapon.currentWeaponSkin);
            UpdateWeaponSkinTextures(weapon);
            ApplyWeaponSkin(weapon,false);
        }
    }
    //Log("---");
}

function private bool IsUnlocked(DeusExWeapon weapon)
{
    return IsIDUnlocked(weapon.currentWeaponSkin $ "_" $ string(weapon.Class));
}

function private bool IsIDUnlocked(string id)
{
    local int i;

    for (i = 0;i < ArrayCount(unlockedWeaponSkins);i++)
    {
        if (unlockedWeaponSkins[i] == id)
            return true;
    }
    return false;
}

function bool UnlockSkin(DeusExWeapon weapon, optional bool bNoMessage)
{
    if (weapon != None)
        return UnlockSkinByID(weapon.currentWeaponSkin,false,weapon.itemName);
    return false;
}

//Returns FALSE if the skin is already unlocked
function bool UnlockSkinByID(string id, optional bool bNoMessage, optional string messageExtra)
{
    local int i;
    local string msg;

    if (id == "")
        return false;

    Log("UnlockSkinById: " $ id);

    if (!IsIDUnlocked(id))
    {
        //Find somewhere to put it
        for (i = 0;i < ArrayCount(unlockedWeaponSkins);i++)
        {
            if (unlockedWeaponSkins[i] == "")
            {
                unlockedWeaponSkins[i] = id;
                break;
            }
        }
        
        //Then set it to unlocked
        for (i = 0;i < numWeaponSkins;i++)
        {
            if (WeaponSkins[i].id == id)
            {
                WeaponSkins[i].bUnlocked = true;

                if (!bNoMessage)
                {
                    msg = sprintf(msgUnlocked,WeaponSkins[i].skinName);
                    if (messageExtra != "")
                        msg = msg @ "[" $ messageExtra $ "]";

                    player.ClientMessage(msg);
                }

                break;
            }
        }
        return true;
    }
    return false;
}

//Transfer the skin from the weapon we just picked up to our current weapon
function TransferSkin(DeusExWeapon wep)
{
    local DeusExWeapon PW;
    
    PW = DeusExWeapon(player.Weapon);

    //If the items match, and our weapon is using the default skin, swap it.
    if (PW != None && PW.Class == wep.Class && bSwitchToNewSkins/* && PW.currentWeaponSkin == "default"*/)
    {
        //wep.PlaySound(wep.CopyModsSound,SLOT_None,0.8);
        PW.currentWeaponSkin = wep.currentWeaponSkin;
        UpdateWeaponSkinTextures(PW);
    }
}

//Done as part of init and no other time
function private SyncFromStoredData()
{
    local int i, j;
       
    //Copy over unlocks from config
    for (i = 0;i < ArrayCount(unlockedWeaponSkinsGlobal); i++)
        UnlockSkinByID(unlockedWeaponSkinsGlobal[i]);

    //Set "bUnlocked" on anything we've unlocked
    for (i = 0;i < ArrayCount(unlockedWeaponSkins);i++)
    {
        for (j = 0;j < numWeaponSkins;j++)
        {
            if (WeaponSkins[j].id == unlockedWeaponSkins[i])
                WeaponSkins[j].bUnlocked = true;
        }
    }
}

function private CopyUnlocksToConfig()
{
    local int i;
    for (i = 0;i < ArrayCount(unlockedWeaponSkins); i++)
        unlockedWeaponSkinsGlobal[i] = unlockedWeaponSkins[i];
}

function AddSkinIcons(string beltIconTex, string largeIconTex)
{
    WeaponSkins[currentWeaponSkin].beltIconTex = beltIconTex;
    WeaponSkins[currentWeaponSkin].largeIconTex = largeIconTex;
}

function AddSkinTex(int texNum, string tex)
{
    switch (texNum)
    {
        case 0: WeaponSkins[currentWeaponSkin].tex0 = tex; break;
        case 1: WeaponSkins[currentWeaponSkin].tex1 = tex; break;
        case 2: WeaponSkins[currentWeaponSkin].tex2 = tex; break;
        case 3: WeaponSkins[currentWeaponSkin].tex3 = tex; break;
        case 4: WeaponSkins[currentWeaponSkin].tex4 = tex; break;
        case 5: WeaponSkins[currentWeaponSkin].tex5 = tex; break;
        case 6: WeaponSkins[currentWeaponSkin].tex6 = tex; break;
        case 7: WeaponSkins[currentWeaponSkin].tex7 = tex; break;
        case 8: WeaponSkins[currentWeaponSkin].mainTexture = tex; break;
    }
}

function Add3rdSkinTex(int texNum, string tex)
{
    switch (texNum)
    {
        case 0: WeaponSkins[currentWeaponSkin].tex03rd = tex; break;
        case 1: WeaponSkins[currentWeaponSkin].tex13rd = tex; break;
        case 2: WeaponSkins[currentWeaponSkin].tex23rd = tex; break;
        case 3: WeaponSkins[currentWeaponSkin].tex33rd = tex; break;
        case 4: WeaponSkins[currentWeaponSkin].tex43rd = tex; break;
        case 5: WeaponSkins[currentWeaponSkin].tex53rd = tex; break;
        case 6: WeaponSkins[currentWeaponSkin].tex63rd = tex; break;
        case 7: WeaponSkins[currentWeaponSkin].tex73rd = tex; break;
        case 8: WeaponSkins[currentWeaponSkin].mainTexture3rd = tex; break;
    }
}

function AddProjectileSkinTex(int texNum, string tex)
{
    ProjectileSkins[currentProjectileSkin].texes[texNum] = tex;
}

function private bool IsSkinValidForWeapon(int skinIndex, DeusExWeapon wep, bool bCheckUnlocked, bool bMatchSelected)
{
    if (wep == None)
        return false;

    //SARGE: Hacky fix
    if (WeaponSkins[skinIndex].id == (wep.currentWeaponSkin $ "_" $ string(wep.Class)))
        wep.currentWeaponSkin = wep.currentWeaponSkin $ "_" $ string(wep.Class);

    //Log("IsSkinValidForWeapon:" @ WeaponSkins[skinIndex].weaponClass $ "," @ string(wep.Class));
    //Log("   ->" @ WeaponSkins[skinIndex].bUnlocked||!bCheckUnlocked $ "," @ (!bMatchSelected || WeaponSkins[skinIndex].id == wep.currentWeaponSkin));
    //Log("Total: " $ (WeaponSkins[skinIndex].bUnlocked||!bCheckUnlocked) && string(wep.Class) == WeaponSkins[skinIndex].weaponClass && (!bMatchSelected || WeaponSkins[skinIndex].id == wep.currentWeaponSkin));
    //Log("   for" @ wep.currentWeaponSkin);
    return (WeaponSkins[skinIndex].bUnlocked||!bCheckUnlocked||class'OutfitManager'.default.bDebugMode) && string(wep.Class) == WeaponSkins[skinIndex].weaponClass && (!bMatchSelected || WeaponSkins[skinIndex].id == wep.currentWeaponSkin);
}

function private bool GetFirstValidSkinForWeapon(DeusExWeapon wep, bool bMatchSelected, out int index)
{
    local int i;

    index = -1;

    //Search through all the skins in the list, return the first one that matches the id and weapon class.
    for (i = 0;i < numWeaponSkins;i++)
    {
        if (IsSkinValidForWeapon(i,wep,false,bMatchSelected))
        {
            index = i;
            return true;
        }
    }
    return false;
}

//Gets a texture, or a backup texture if the first one fails, or a backup texture if the second one fails
function private Texture GetTexture3(string tex, string alternative, string alternative2, bool first, bool second, optional bool debug)
{
    local Texture TTex;

    //Dirty hack
    if (alternative == "Engine.S_Inventory")
        alternative = "";

    if (first)
        TTex = Texture(DynamicLoadObject(tex, class'Texture', !debug));
    else if (second)
        TTex = Texture(DynamicLoadObject(alternative, class'Texture', !debug));
    if (TTex == None)
        TTex = Texture(DynamicLoadObject(alternative2, class'Texture', !debug));
    //log("Getting tex: " $ tex $ ", " $ alternative $ ", " $ first);
	return TTex;
}

//Probably not needed...
function private Texture GetTexture(string tex, optional bool debug)
{
    local Texture TTex;
    TTex = Texture(DynamicLoadObject(tex, class'Texture', !debug));
    return TTex;
}

//SARGE: Updates the weapon skin texture array
//This is a fucking garbage function
function UpdateWeaponSkinTextures(DeusExWeapon wep)
{
    local bool hdtp, fomod;
    local WeaponSkin skin;
    local int index;
    local Texture texes[9], tex3rds[9];
    local bool bMeshCheck;

    //Bad skin time.
    if (wep == None/* || wep.currentWeaponSkin == ""*/)
        return;

    //SARGE: We intend to support HDTP/FOMOD in the future, but for now, just ignore any non-default model meshes.
    hdtp = IsHDTP(wep);
    fomod = IsFomod(wep);
    //bMeshCheck = wep.Mesh == wep.default.PlayerViewMesh || wep.Mesh == wep.default.ThirdPersonMesh || wep.Mesh == wep.default.PickupViewMesh;
    bMeshCheck = !hdtp && !fomod;

    //Log("Weapon Skin Updating for:" @ wep @ wep.currentWeaponSkin);

    //Special case for default skin - don't even bother searching.
    if (wep.currentWeaponSkin == "default" || !bMeshCheck)
    {
        wep.skinTextures[0] = None;
        wep.skinTextures[1] = None;
        wep.skinTextures[2] = None;
        wep.skinTextures[3] = None;
        wep.skinTextures[4] = None;
        wep.skinTextures[5] = None;
        wep.skinTextures[6] = None;
        wep.skinTextures[7] = None;
        wep.skinTextures[8] = None;
        
        wep.skinTextures3rd[0] = None;
        wep.skinTextures3rd[1] = None;
        wep.skinTextures3rd[2] = None;
        wep.skinTextures3rd[3] = None;
        wep.skinTextures3rd[4] = None;
        wep.skinTextures3rd[5] = None;
        wep.skinTextures3rd[6] = None;
        wep.skinTextures3rd[7] = None;
        wep.skinTextures3rd[8] = None;
    }
    else if (GetFirstValidSkinForWeapon(wep,true,index))
    {
        skin = WeaponSkins[index];

        texes[0] = GetTexture3(skin.fomodTex0,skin.hdtpTex0,skin.tex0,fomod,hdtp);
        texes[1] = GetTexture3(skin.fomodTex1,skin.hdtpTex1,skin.tex1,fomod,hdtp);
        texes[2] = GetTexture3(skin.fomodTex2,skin.hdtpTex2,skin.tex2,fomod,hdtp);
        texes[3] = GetTexture3(skin.fomodTex3,skin.hdtpTex3,skin.tex3,fomod,hdtp);
        texes[4] = GetTexture3(skin.fomodTex4,skin.hdtpTex4,skin.tex4,fomod,hdtp);
        texes[5] = GetTexture3(skin.fomodTex5,skin.hdtpTex5,skin.tex5,fomod,hdtp);
        texes[6] = GetTexture3(skin.fomodTex6,skin.hdtpTex6,skin.tex6,fomod,hdtp);
        texes[7] = GetTexture3(skin.fomodTex7,skin.hdtpTex7,skin.tex7,fomod,hdtp);
        texes[8] = GetTexture3(skin.fomodMainTexture,skin.hdtpMainTexture,skin.mainTexture,fomod,hdtp);
        
        tex3rds[0] = GetTexture3(skin.fomodTex03rd,skin.hdtpTex03rd,skin.tex03rd,fomod,hdtp);
        tex3rds[1] = GetTexture3(skin.fomodTex13rd,skin.hdtpTex13rd,skin.tex13rd,fomod,hdtp);
        tex3rds[2] = GetTexture3(skin.fomodTex23rd,skin.hdtpTex23rd,skin.tex23rd,fomod,hdtp);
        tex3rds[3] = GetTexture3(skin.fomodTex33rd,skin.hdtpTex33rd,skin.tex33rd,fomod,hdtp);
        tex3rds[4] = GetTexture3(skin.fomodTex43rd,skin.hdtpTex43rd,skin.tex43rd,fomod,hdtp);
        tex3rds[5] = GetTexture3(skin.fomodTex53rd,skin.hdtpTex53rd,skin.tex53rd,fomod,hdtp);
        tex3rds[6] = GetTexture3(skin.fomodTex63rd,skin.hdtpTex63rd,skin.tex63rd,fomod,hdtp);
        tex3rds[7] = GetTexture3(skin.fomodTex73rd,skin.hdtpTex73rd,skin.tex73rd,fomod,hdtp);
        tex3rds[8] = GetTexture3(skin.fomodMainTexture3rd,skin.hdtpMainTexture3rd,skin.mainTexture3rd,fomod,hdtp);

        //SARGE: Massive horrible hardcoded mess follows!
        wep.SkinTextures[0] = texes[0];
        wep.SkinTextures[1] = texes[1];
        wep.SkinTextures[2] = texes[2];
        wep.SkinTextures[3] = texes[3];
        wep.SkinTextures[4] = texes[4];
        wep.SkinTextures[5] = texes[5];
        wep.SkinTextures[6] = texes[6];
        wep.SkinTextures[7] = texes[7];
        wep.SkinTextures[8] = texes[4];
        
        wep.SkinTextures3rd[0] = tex3rds[0];
        wep.SkinTextures3rd[1] = tex3rds[1];
        wep.SkinTextures3rd[2] = tex3rds[2];
        wep.SkinTextures3rd[3] = tex3rds[3];
        wep.SkinTextures3rd[4] = tex3rds[4];
        wep.SkinTextures3rd[5] = tex3rds[5];
        wep.SkinTextures3rd[6] = tex3rds[6];
        wep.SkinTextures3rd[7] = tex3rds[7];
        wep.SkinTextures3rd[8] = tex3rds[8];
    }

    //Apply belt and inventory icon changes as well.
    if (skin.beltIconTex != "")
        wep.skinBeltIconTex = GetTexture(skin.beltIconTex);
    if (skin.largeIconTex != "")
        wep.skinBeltIconTex = GetTexture(skin.largeIconTex);
        
    //ApplyWeaponSkin(wep);
}

function UpdateProjectileSkinTextures(DeusExProjectile proj)
{
    local bool hdtp, fomod;
    local ProjectileSkin skin;
    local int index;
    local int i;
    local Texture texes[9];
    local bool bMeshCheck;

    //Bad skin time.
    if (proj == None)
        return;

    Log("UpdateProjectileSkinTextures:" @ proj.currentWeaponSkin);

    //SARGE: We intend to support HDTP/FOMOD in the future, but for now, just ignore any non-default model meshes.
    hdtp = IsHDTP(proj);
    fomod = IsFomod(proj);
    bMeshCheck = !hdtp && !fomod;

    if (proj.currentWeaponSkin == "default" || !bMeshCheck)
    {
        Log("Applying default projectile skin");
        for (i = 0;i < 9;i++)
            proj.skinTextures[i] = None;
    }
    else if (GetProjectileSkin(proj.currentWeaponSkin, index))
    {
        Log("Applying projectile skin: " $ proj.currentWeaponSkin @ index);
        skin = ProjectileSkins[index];

        for (i = 0;i < 9;i++)
            proj.skinTextures[i] = GetTexture3(skin.fomodTexes[i],skin.hdtpTexes[i],skin.texes[i],fomod,hdtp);
    }
}

function bool GetProjectileSkin(string id, out int index)
{
    local int i;
    
    Log("Projectile skin Search: " $ id);
    for (i = 0; i < numProjectileSkins;i++)
    {
        Log(i $ "   -> " $ id @ projectileSkins[i].id @ projectileSkins[i].id ~= id);
        if (projectileSkins[i].id != "" && projectileSkins[i].id ~= id)
        {
            index = i;
            return true;
        }
    }
    return false;
}

function int GetSkinCountFor(DeusExWeapon wep, optional bool bCountLocked)
{
    local int i, ret;
    
    //Always return the "default" skin.
    ret = 1;

    for (i = 0;i < numWeaponSkins;i++)
    {
        if ((WeaponSkins[i].bUnlocked || bCountLocked || class'OutfitManager'.default.bDebugMode) && WeaponSkins[i].weaponClass == string(wep.Class))
            ret++;
    }

    return ret;
}

function string GetSkinName(DeusExWeapon wep)
{
    local int index;

    if (GetFirstValidSkinForWeapon(wep,true,index))
        return WeaponSkins[index].skinName;
    return msgDefault;
}

function SelectNextSkin(DeusExWeapon wep)
{
    local int i;
    local bool bFound;
    
    //wep.PlaySound(wep.CopyModsSound,SLOT_None,0.8);

    if (wep.currentWeaponSkin == "default")
        bFound = true;
            
    //Log("FirstFound:" @ bFound @ numWeaponSkins);

    //Search through all the skins in the list, until we reach the one matching our id. Then, find the next valid one.
    for (i = 0;i < numWeaponSkins;i++)
    {
        //First, we're just searching for our existing one
        if (!bFound && IsSkinValidForWeapon(i,wep,true,true))
        {
            bFound = true;
            continue;
        }

        if (bFound && IsSkinValidForWeapon(i,wep,true,false))
        {
            //Log("Awooga!" @ WeaponSkins[i].id);
            wep.currentWeaponSkin = WeaponSkins[i].id;
            UpdateWeaponSkinTextures(wep);
            return;
        }
    }

    //If there were no next ones, set to the default skin
    wep.currentWeaponSkin = "default";
    UpdateWeaponSkinTextures(wep);
}

function SelectPreviousSkin(DeusExWeapon wep)
{
    local int i;
    local bool bFound;
                        
    //wep.PlaySound(wep.CopyModsSound,SLOT_None,0.8);

    if (wep.currentWeaponSkin == "default")
        bFound = true;

    //Search through all the skins in the list, until we reach the one matching our id. Then, find the next valid one.
    for (i = numWeaponSkins - 1;i >= 0;i--)
    {
        //First, we're just searching for our existing one
        if (!bFound && IsSkinValidForWeapon(i,wep,true,true))
        {
            bFound = true;
            continue;
        }

        if (bFound && IsSkinValidForWeapon(i,wep,true,false))
        {
            wep.currentWeaponSkin = WeaponSkins[i].id;
            UpdateWeaponSkinTextures(wep);
            return;
        }
    }
        
    //No skin found and we're at the start, so find the highest value skin
    if (wep.currentWeaponSkin == "default")
    {
        for (i = 0;i < numWeaponSkins;i++)
            if (IsSkinValidForWeapon(i,wep,true,false))
                wep.currentWeaponSkin = WeaponSkins[i].id;
    }
    else
        wep.currentWeaponSkin = "default";
    
    UpdateWeaponSkinTextures(wep);
}

defaultproperties
{
    msgDefault="Default"
    msgUnlocked="%d Skin Unlocked!"
    weaponSkinNames(0)="Stainless Steel"
    weaponSkinNames(1)="Golden Gun"
    weaponSkinNames(2)="UNATCO Special Issue"
    weaponSkinNames(3)="Tactical Gear"
    weaponSkinNames(4)="Lemon Lime"
    weaponSkinNames(5)="Smuggler's Special"
    weaponSkinNames(6)="JoJo's Fine Stealth Pistol"
    weaponSkinNames(7)="MJ12 Special Issue"
    weaponSkinNames(8)="Riot Gear"
    weaponSkinNames(9)="Hong Kong Military Gear"
    weaponSkinNames(10)="Green Eggs and LAM"
    weaponSkinNames(11)="Hot Pink"
    weaponSkinNames(12)="EMPink"
    bSwitchToNewSkins=true
}
