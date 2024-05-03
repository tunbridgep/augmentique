class PartsGroup extends Object;

var Mesh mesh;                          //Which mesh is this parts group associated with?
var bool allowMale;                     //Whether or not males are allowed to use parts from this group
var bool allowFemale;                   //Whether or not females are allowed to use parts from this group

var OutfitPart PartsList[300];
var int numOutfitParts;

function AddPart(OutfitPart P)
{
    PartsList[numOutfitParts++] = P;
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
