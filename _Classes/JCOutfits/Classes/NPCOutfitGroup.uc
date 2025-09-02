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

var ClassInfo classes[255];
var int numClasses;

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

var SimplePartsList partsList[30];

var private Actor members[50];
var private int numMembers;

function AddMember(Actor A, optional bool bLog)
{
    local int i, k, rando;
    local SimplePart sp;
    local DeusExCarcass C;
    local ScriptedPawn P;

    if (numMembers >= 50)
        return;

    C = DeusExCarcass(A);
    P = ScriptedPawn(A);

    if (P != None && P.augmentiqueData.bRandomized)
        return;

    if (C != None && C.augmentiqueData.bRandomized)
        return;
    
    members[numMembers++] = A;

    for (i = 0; i < ArrayCount(partsList);i++)
    {
        if (partsList[i].numParts == 0)
            continue;

        //Update the members texture data
        rando = GetClassSeed(string(A.class),i);
        if (rando < 0) //Allow for custom seeds
            rando = Rand(partsList[i].numParts);
        else
            rando = rando % partsList[i].numParts;

        if (bLog)
            Log("   Randomising: Part " $ (i+1) $ " to " $ (rando+1) $ " of " $ partsList[i].numParts);
        sp = partsList[i].parts[rando];
        for(k = 0;k < 8;k++)
        {
            if (sp.textures[k] != None)
            {
                if (P != None)
                    P.augmentiqueData.textures[k] = sp.textures[k];
                else if (C != None)
                    C.augmentiqueData.textures[k] = sp.textures[k];
            }
        }
        if (sp.textures[8] != None)
        {
            if (P != None)
                P.augmentiqueData.textures[k] = sp.textures[8];
            else if (C != None)
                C.augmentiqueData.textures[k] = sp.textures[8];
            //Log("Applying " $ sp.textures[8] $ " to " $ P $ " (main)");
        }
    }
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

function int GetClassSeed(string className, int index)
{
    local int i;
    for (i = 0; i < numClasses;i++)
    {
        if (classes[i].className ~= className)
            return classes[i].seeds[index];
    }
    return -1;
}

function bool GetMatchingClass(string className)
{
    local int i;
    for (i = 0; i < numClasses;i++)
    {
        if (classes[i].className ~= className)
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

function ApplyOutfits()
{
    local DeusExCarcass C;
    local ScriptedPawn P;
    local int i,j;

    for (i = 0;i < numMembers;i++)
    {
        C = DeusExCarcass(members[i]);
        P = ScriptedPawn(members[i]);

        if (P != None)
            P.ApplyCurrentOutfit();
        else if (C != None)
            C.ApplyCurrentOutfit();
    }
}
