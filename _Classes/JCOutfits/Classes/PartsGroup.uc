class PartsGroup extends Object;

var Mesh mesh;                          //Which mesh is this parts group associated with?
var bool allowMale;                     //Whether or not males are allowed to use parts from this group
var bool allowFemale;                   //Whether or not females are allowed to use parts from this group

var OutfitPart PartsList[300];
var int numOutfitParts;

var DeusExPlayer player;
var OutfitManager manager;

function int CountPartType(int type, optional bool unlockedOnly)
{
    local int i,c;
    for (i = 0;i < numOutfitParts;i++)
    {
        if (PartsList[i].bodySlot == type)
            if (!unlockedonly || (CheckUnlock(i) && IsCorrectGender()))
                c++;
    }
    return c;
}

function bool CheckUnlock(int i)
{
    return PartsList[i].unlocked || (PartsList[i].original != None && PartsList[i].original.unlocked);
}

function OutfitPart GetNextPartOfType(int type, int start)
{
    local int i;

    i = start;
    do
    {
        i++;
        if (i >= numOutfitParts)
            i = 0;
    }
    until (i == start || (PartsList[i].bodySlot == type && CheckUnlock(i) && IsCorrectGender()))

    return PartsList[i];
}

function OutfitPart GetPreviousPartOfType(int type, int start)
{
    local int i;

    i = start;
    do
    {
        i--;
        if (i < 0)
            i = numOutfitParts - 1;
    }
    until (i == start || (PartsList[i].bodySlot == type && CheckUnlock(i) && IsCorrectGender()))

    return PartsList[i];
}

function bool IsCorrectGender()
{
    return (allowMale && !IsFemale()) || (allowFemale && IsFemale());
}

function bool IsFemale()
{
    return player.FlagBase != None && player.FlagBase.GetBool('LDDPJCIsFemale');
}

function AddPart(OutfitPart P)
{
    local int i;

    //If it already exists in the parts list, replace it
    for (i  = 0;i < numOutfitParts;i++)
    {
        if (PartsList[i].partID == P.partid)
        {
            PartsList[i] = P;
            P.index = i;
            return;
        }
    }

    PartsList[numOutfitParts] = P;
    P.index = numOutfitParts;
    numOutfitParts++;
}

//Add a part and move the texture slots around
function AddTransposePart(OutfitPart P,int bodySlot,int slot0, int slot1, int slot2, int slot3, int slot4, int slot5, int slot6, int slot7, int slot8)
{
    local OutfitPart P2;
    local int i;

    //We need to add a new part, rather than manipulating the reference
    P2 = new(Self) class'OutfitPart';

    P2.partID = P.partID;
    P2.name = P.name;
    P2.bodySlot = bodySlot;
    P2.isAccessory = P.isAccessory;
    P2.original = P;
    
    /*
    for (i = 0;i < 9;i++)
        P2.textures[i] = P.textures[i];
    */
            
    //player.ClientMessage("TEX: " $ P.textures[0] @ P.textures[1] @ P.textures[2]);

    //now move the textures around
    if (slot0 > 0) P2.textures[slot0] = P.textures[0];
    if (slot1 > 0) P2.textures[slot1] = P.textures[1];
    if (slot2 > 0) P2.textures[slot2] = P.textures[2];
    if (slot3 > 0) P2.textures[slot3] = P.textures[3];
    if (slot4 > 0) P2.textures[slot4] = P.textures[4];
    if (slot5 > 0) P2.textures[slot5] = P.textures[5];
    if (slot6 > 0) P2.textures[slot6] = P.textures[6];
    if (slot7 > 0) P2.textures[slot7] = P.textures[7];
    if (slot8 > 0) P2.textures[slot8] = P.textures[8];
    
    //player.ClientMessage("NEWTEX: " $ P2.textures[0] @ P2.textures[1] @ P2.textures[2] @ P2.textures[3] @ P2.textures[4] @ P2.textures[5] @ P2.textures[6] @ P2.textures[7] @ P2.textures[8]);

    AddPart(P2);
}

function OutfitPart GetPartWithID(string ID)
{
    local int i;
    for (i = 0;i < numOutfitParts;i++)
    {
        if (PartsList[i].partID == id)
            return PartsList[i];
    }
    return None;
}

defaultproperties
{
}
