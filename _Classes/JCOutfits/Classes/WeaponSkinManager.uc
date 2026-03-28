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

const SKIN_PREFIX = "Augmentique.WeaponSkins.";

function Init(DeusExPlayer newPlayer)
{
    if (bInited)
        return;

    player = newPlayer;
    currentWeaponSkin = -1;
    
    //Pistol Skins
    AddSkin("goldengun","DeusEx.WeaponPistol");
    AddSkinTex(3,SKIN_PREFIX $ "goldengun1");
    Add3rdSkinTex(0,SKIN_PREFIX $ "goldengun3rd");
    //UnlockSkin("goldengun");

    //Log("WeaponSkinManager: Inited");

    //Refresh the unlock state from the stored data
    SyncFromStoredData();

    //RefreshAllWeapons();

    bInited = true;
}

function ApplyWeaponSkin(DeusExWeapon Wep)
{
    local int i;

    if (wep.Mesh == wep.PlayerViewMesh)
    {
        for (i = 0;i < 8;i++)
            if (wep.multiSkins[i] != Texture'PinkMaskTex' && wep.skinTextures[i] != None)
                wep.multiSkins[i] = wep.skinTextures[i];
    }
    else
    {
        for (i = 0;i < 8;i++)
            if (wep.multiSkins[i] != Texture'PinkMaskTex' && wep.skinTextures3rd[i] != None)
                wep.multiSkins[i] = wep.skinTextures3rd[i];
    }

}

function RefreshAllWeapons()
{
    local DeusExWeapon W;

    if (player == None)
        return;

    //Refresh all weapons in the map
	foreach player.AllActors(class'DeusExWeapon', W)
    {
        //Log("Updating skin for " $ W $ " with skin " $ W.currentWeaponSkin);
        UpdateWeaponSkinTextures(W);
    }
}

function private AddSkin(string id, string className, optional bool bUnlocked)
{
    numWeaponSkins++;
    currentWeaponSkin++;
    WeaponSkins[currentWeaponSkin].id = id;
    WeaponSkins[currentWeaponSkin].weaponClass = className;
    WeaponSkins[currentWeaponSkin].skinName = default.WeaponSkinNames[currentWeaponSkin];
    if (bUnlocked)
        UnlockSkin(id);
}

function private bool IsUnlocked(string id)
{
    local int i;

    for (i = 0;i < ArrayCount(unlockedWeaponSkins);i++)
    {
        if (unlockedWeaponSkins[i] == id)
            return true;
    }
    return false;
}

//Returns FALSE if the skin is already unlocked
function bool UnlockSkin(string id, optional bool bNoMessage)
{
    local int i;

    if (id == "")
        return false;

    if (!IsUnlocked(id))
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
                WeaponSkins[i].bUnlocked = true;
        }

        if (!bNoMessage)
            player.ClientMessage(sprintf(msgUnlocked,WeaponSkins[i].skinName));
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
    if (PW != None && PW.Class == wep.Class && PW.currentWeaponSkin == "default")
    {
        wep.PlaySound(wep.CopyModsSound,SLOT_None,0.8);
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
        UnlockSkin(unlockedWeaponSkinsGlobal[i]);

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

function private AddSkinTex(int texNum, string tex)
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

function private Add3rdSkinTex(int texNum, string tex)
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

function private bool IsSkinValidForWeapon(int skinIndex, DeusExWeapon wep, bool bCheckUnlocked, bool bMatchSelected)
{
    //Log("IsSkinValidForWeapon:" @ WeaponSkins[skinIndex].weaponClass $ "," @ string(wep.Class));
    //Log("   ->" @ WeaponSkins[skinIndex].bUnlocked||!bCheckUnlocked $ "," @ (!bMatchSelected || WeaponSkins[skinIndex].id == wep.currentWeaponSkin));
    //Log("Total: " $ (WeaponSkins[skinIndex].bUnlocked||!bCheckUnlocked) && string(wep.Class) == WeaponSkins[skinIndex].weaponClass && (!bMatchSelected || WeaponSkins[skinIndex].id == wep.currentWeaponSkin));
    //Log("   for" @ wep.currentWeaponSkin);
    return (WeaponSkins[skinIndex].bUnlocked||!bCheckUnlocked) && string(wep.Class) == WeaponSkins[skinIndex].weaponClass && (!bMatchSelected || WeaponSkins[skinIndex].id == wep.currentWeaponSkin);
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

//Detect HDTP model using mesh path. Disgusting
function private bool IsHDTP(DeusExWeapon wep)
{
    return InStr(caps(string(wep.Mesh)),"HDTPItems.") == 0;
}

function private bool IsFomod(DeusExWeapon wep)
{
    return InStr(caps(string(wep.Mesh)),"FOMOD.") == 0;
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

//SARGE: Updates the weapon skin texture array
//This is a fucking garbage function
function UpdateWeaponSkinTextures(DeusExWeapon wep)
{
    local bool hdtp, fomod;
    local WeaponSkin skin;
    local int index;

    //Bad skin time.
    if (wep.currentWeaponSkin == "")
        return;

    //Log("Weapon Skin Updating for:" @ wep @ wep.currentWeaponSkin);

    //Special case for default skin - don't even bother searching.
    if (wep.currentWeaponSkin == "default")
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
        return;
    }

    if (GetFirstValidSkinForWeapon(wep,true,index))
    {
        skin = WeaponSkins[index];
        hdtp = IsHDTP(wep);
        fomod = IsFomod(wep);

        //SARGE: Massive horrible hardcoded mess follows!
        wep.SkinTextures[0] = GetTexture3(skin.fomodTex0,skin.hdtpTex0,skin.tex0,fomod,hdtp);
        wep.SkinTextures[1] = GetTexture3(skin.fomodTex1,skin.hdtpTex1,skin.tex1,fomod,hdtp);
        wep.SkinTextures[2] = GetTexture3(skin.fomodTex2,skin.hdtpTex2,skin.tex2,fomod,hdtp);
        wep.SkinTextures[3] = GetTexture3(skin.fomodTex3,skin.hdtpTex3,skin.tex3,fomod,hdtp);
        wep.SkinTextures[4] = GetTexture3(skin.fomodTex4,skin.hdtpTex4,skin.tex4,fomod,hdtp);
        wep.SkinTextures[5] = GetTexture3(skin.fomodTex5,skin.hdtpTex5,skin.tex5,fomod,hdtp);
        wep.SkinTextures[6] = GetTexture3(skin.fomodTex6,skin.hdtpTex6,skin.tex6,fomod,hdtp);
        wep.SkinTextures[7] = GetTexture3(skin.fomodTex7,skin.hdtpTex7,skin.tex7,fomod,hdtp);
        
        wep.SkinTextures[8] = GetTexture3(skin.fomodMainTexture,skin.hdtpMainTexture,skin.mainTexture,fomod,hdtp);
        
        wep.SkinTextures3rd[0] = GetTexture3(skin.fomodTex03rd,skin.hdtpTex03rd,skin.tex03rd,fomod,hdtp);
        wep.SkinTextures3rd[1] = GetTexture3(skin.fomodTex13rd,skin.hdtpTex13rd,skin.tex13rd,fomod,hdtp);
        wep.SkinTextures3rd[2] = GetTexture3(skin.fomodTex23rd,skin.hdtpTex23rd,skin.tex23rd,fomod,hdtp);
        wep.SkinTextures3rd[3] = GetTexture3(skin.fomodTex33rd,skin.hdtpTex33rd,skin.tex33rd,fomod,hdtp);
        wep.SkinTextures3rd[4] = GetTexture3(skin.fomodTex43rd,skin.hdtpTex43rd,skin.tex43rd,fomod,hdtp);
        wep.SkinTextures3rd[5] = GetTexture3(skin.fomodTex53rd,skin.hdtpTex53rd,skin.tex53rd,fomod,hdtp);
        wep.SkinTextures3rd[6] = GetTexture3(skin.fomodTex63rd,skin.hdtpTex63rd,skin.tex63rd,fomod,hdtp);
        wep.SkinTextures3rd[7] = GetTexture3(skin.fomodTex73rd,skin.hdtpTex73rd,skin.tex73rd,fomod,hdtp);
        
        wep.SkinTextures3rd[8] = GetTexture3(skin.fomodMainTexture3rd,skin.hdtpMainTexture3rd,skin.mainTexture3rd,fomod,hdtp);

        ApplyWeaponSkin(wep);
    }
}

function int GetSkinCountFor(DeusExWeapon wep, optional bool bCountLocked)
{
    local int i, ret;
    
    //Always return the "default" skin.
    ret = 1;

    for (i = 0;i < numWeaponSkins;i++)
    {
        if ((WeaponSkins[i].bUnlocked || bCountLocked) && WeaponSkins[i].weaponClass == string(wep.Class))
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
    
    wep.PlaySound(wep.CopyModsSound,SLOT_None,0.8);

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
                        
    wep.PlaySound(wep.CopyModsSound,SLOT_None,0.8);

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
    msgUnlocked="%s Skin Unlocked!"
    weaponSkinNames(0)="Golden Gun"
}
