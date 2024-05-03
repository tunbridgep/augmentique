class PartsGroup extends Object;

var Mesh mesh;                          //Which mesh is this parts group associated with?
var bool allowMale;                     //Whether or not males are allowed to use parts from this group
var bool allowFemale;                   //Whether or not females are allowed to use parts from this group

var OutfitPart PartsList[300];
var int numOutfitParts;

var DeusExPlayer player;

function int CountPartType(int type)
{
    local int i,c;
    for (i = 0;i < numOutfitParts;i++)
    {
        if (PartsList[i].bodySlot == type)
            c++;
    }
    return c;
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
    until (i == start || PartsList[i].bodySlot == type)

    return PartsList[i];
}

function AddPart(OutfitPart P)
{
    PartsList[numOutfitParts] = P;
    P.index = numOutfitParts;
    numOutfitParts++;
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
