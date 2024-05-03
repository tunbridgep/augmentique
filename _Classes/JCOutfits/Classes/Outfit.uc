class Outfit extends Object;

var string id;
var string name;

var PartsGroup partsGroup;

var OutfitPart parts[20];
var int numParts;

var DeusExPlayer player;

var int index;                                  //The position in the master outfits list

function CopyTo(Outfit O)
{
    local int i;

    O.id = id;
    O.name = name;
    O.partsGroup = partsGroup;
    O.numParts = numParts;
    O.player = player;
    O.index = index;

    for (i = 0;i < numParts;i++)
        O.parts[i] = parts[i];
}

function AddPartFromID(string partID)
{
    local OutfitPart P;
    P = partsGroup.GetPartWithID(partID);

    if (P != None)
        parts[numParts++] = P;
}

function bool HasAccessories()
{
    local int i;
    for (i = 0;i < numParts;i++)
    {
        if (parts[i].isAccessory)
            return true;
    }
    return false;
}

function bool IsNullTexture(Texture T)
{
    return T == None || T == Texture'DeusExItems.Skins.PinkMaskTex';
}

function ApplyOutfitToActor(Actor A, bool allowAccessories)
{
    local int i,s;
    local Texture T;
    
    A.mesh = partsGroup.Mesh;

    //Remove existing textures
    for (i = 1;i < 9;i++)
        A.MultiSkins[i] = Texture'DeusExItems.Skins.PinkMaskTex';

    //Apply new textures from each part
    for (i = 0;i < numParts;i++)
    {
        for (s = 1;s < 8;s++)
        {
            T = parts[i].textures[s];

            //don't add any accessory textures if accessories are turned off
            if (parts[i].isAccessory && !allowAccessories)
                continue;

            //skip null textures
            if (IsNullTexture(T))
                continue;

            A.MultiSkins[s] = T;
        }
    }
}
