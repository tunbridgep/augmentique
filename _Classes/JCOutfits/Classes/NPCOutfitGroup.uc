//Simple NPC Handling.
//NPCs don't care about "outfits", they
//will simply equip randomly from their parts list.
class NPCOutfitGroup extends Object;

struct ClassInfo
{
    var string className;
    var bool bUniqueNPC;
    var int Seeds[30];
};

var ClassInfo classes[100];
var int numClasses;
var string exceptedClasses[100];
var int numExcepted;

struct SimplePart
{
    var bool bSkinPart;                          //Whether or not this part changes a characters skin in some way. Parts that change skins are disallowed for certain characters.
    var Texture textures[9];                //Textures for this part. MultiSkins0-7 and then main texture
};

struct SimplePartsList
{
    var int slot;
    var int numParts;
    var SimplePart parts[50];
};

struct HologramOverride
{
    var int slot;
    var Texture tex;
};

var SimplePartsList partsList[30];
var HologramOverride overrides[10];
var private int numOverrides;

var private Actor members[50];
var private int numMembers;

function ClearMembers()
{
    numMembers = 0;
}

function AddOverride(int slot, Texture tex)
{
    if (numOverrides >= ArrayCount(overrides))
        return;

    overrides[numOverrides].slot = slot;
    overrides[numOverrides].tex = tex;
    numOverrides++;
}

function AddMember(Actor A, optional bool bLog, optional bool bAllowRepeats)
{
    local int i, k, rando, seed, bUnique;
    local SimplePart sp;
    local DeusExCarcass C;
    local ScriptedPawn P;

    if (numMembers >= 50)
        return;

    C = DeusExCarcass(A);
    P = ScriptedPawn(A);

    if (P != None && P.augmentiqueData.bRandomized && !bAllowRepeats)
        return;

    if (C != None && C.augmentiqueData.bRandomized && !bAllowRepeats)
        return;
    
    members[numMembers++] = A;
    
    //Set their carcass
    //if (P != None)
    //    P.CarcassType=class'Augmentique.OutfitCarcass';

    for (i = 0; i < ArrayCount(partsList);i++)
    {
        if (partsList[i].numParts == 0)
            continue;
        
        GetClassInfo(string(A.class),i,seed,bUnique);

        //Update the members texture data
        if (seed < 0) //Allow for custom seeds
            rando = Rand(partsList[i].numParts);
        else
            rando = seed % partsList[i].numParts;

        if (bLog)
            Log("   Randomising: Part " $ (i+1) $ " to " $ (rando+1) $ " of " $ partsList[i].numParts $ " (slot " $ i $ ")");
        sp = partsList[i].parts[rando];

        //Don't apply skin parts to unique NPCs
        if (bUnique == 1 && sp.bSkinPart)
            continue;

        for(k = 0;k < 9;k++)
        {
            if (sp.textures[k] != None)
            {
                if (P != None)
                    P.augmentiqueData.textures[k] = sp.textures[k];
                else if (C != None)
                    C.augmentiqueData.textures[k] = sp.textures[k];
            }
        }
    }
        
    //If it's a hologram, apply the hologram overrides
    if (A.Style == STY_Translucent)
    {
        if (bLog)
            Log("Applying overrides: " $ numOverrides);
        for(k = 0;k < numOverrides;k++)
        {
            if (P != None)
                P.augmentiqueData.textures[overrides[k].slot] = overrides[k].tex;
            if (C != None)
                C.augmentiqueData.textures[overrides[k].slot] = overrides[k].tex;
        }
    }
}

function AddExceptedClass(string className)
{
    exceptedClasses[numExcepted++] = className;
}

function AddClass(string className, optional bool bUniqueNPC, optional bool bNoCarcass, optional int seeds[30])
{
    local int i;
    classes[numClasses].className = className;
    classes[numClasses].bUniqueNPC = bUniqueNPC;

    for (i = 0;i < 30;i++)
        classes[numClasses].seeds[i] = seeds[i];

    //Log("Adding class: " $ className);
    numClasses++;
    if (!bNoCarcass)
    {
        AddClass(className$"Carcass",bUniqueNPC,true,seeds);
        //GMDX Support
        //AddClass(className$"Carcass2",bUniqueNPC,true);
        //AddClass(className$"CarcassBeheaded",bUniqueNPC,true);
    }
}

function GetClassInfo(string className, int index, out int seed, out int bUnique)
{
    local int i;
    for (i = 0; i < numClasses;i++)
    {
        if (classes[i].className ~= className)
        {
            seed = classes[i].seeds[index];
            bUnique = int(classes[i].bUniqueNPC);
        }
    }
}

function bool IsClassUnique(string className)
{
    local int i;
    for (i = 0; i < numClasses;i++)
    {
        //Log("IsClassUnique: " $ className $ ", checking against " $ classes[i].className $ ": " $ classes[i].className ~= className);
        if (classes[i].className ~= className)
            return classes[i].bUniqueNPC;
    }
    return false;
}

function bool GetMatchingClass(string s1, optional string s2)
{
    local int i;

    //first check for exceptions
    for (i = 0; i < numExcepted;i++)
    {
        if (exceptedClasses[i] ~= s1 || (s2 != "" && exceptedClasses[i] ~= s2))
            return false;
    }

    for (i = 0; i < numClasses;i++)
    {
        if (classes[i].className ~= s1 || (s2 != "" && classes[i].className ~= s2))
            return true;
    }
    return false;
}

function AddPart(int slot, bool bSkinPart, optional Texture t0, optional Texture t1, optional Texture t2, optional Texture t3, optional Texture t4, optional Texture t5, optional Texture t6, optional Texture t7, optional Texture t8)
{
    local int num;
    local SimplePartsList P;
    //Log("Added Part: " $ t0 @ t1 @ t2 @ t3 @t4 @ t5 @ t6 @ t7 @ t8);
    num = partsList[slot].numParts;
    partsList[slot].parts[num].textures[0] = t0;
    partsList[slot].parts[num].textures[1] = t1;
    partsList[slot].parts[num].textures[2] = t2;
    partsList[slot].parts[num].textures[3] = t3;
    partsList[slot].parts[num].textures[4] = t4;
    partsList[slot].parts[num].textures[5] = t5;
    partsList[slot].parts[num].textures[6] = t6;
    partsList[slot].parts[num].textures[7] = t7;
    partsList[slot].parts[num].textures[8] = t8;
    partsList[slot].parts[num].bSkinPart = bSkinPart;
    partsList[slot].numParts++;
}

function ApplyOutfits(bool bAllowRandomise, bool bAllowUnique)
{
    local DeusExCarcass C;
    local ScriptedPawn P;
    local int i,j;

    for (i = 0;i < numMembers;i++)
    {
        //Log("ApplyOutfits to: " $ members[i] @ bAllowUnique);
        C = DeusExCarcass(members[i]);
        P = ScriptedPawn(members[i]);

        if (P != None)
        {
            P.augmentiqueData.bRandomized = false;
            //Log("Unique: " $ P.augmentiqueData.bUnique);
            if (bAllowRandomise && (bAllowUnique || !P.augmentiqueData.bUnique))
                P.augmentiqueData.bRandomized = true;
            if (!P.bCloakOn)
                P.ApplyCurrentOutfit();
        }
        else if (C != None)
        {
            C.augmentiqueData.bRandomized = false;
            //Log("Unique: " $ C.augmentiqueData.bUnique);
            if (bAllowRandomise && (bAllowUnique || !C.augmentiqueData.bUnique))
                C.augmentiqueData.bRandomized = true;
            C.ApplyCurrentOutfit();
        }
    }
}
