class Outfit extends Object;

var string id;
var string name;

var PartsGroup partsGroup;

var OutfitPart parts[20];
var int numParts;

var DeusExPlayer player;

var int index;                                  //The position in the master outfits list
var bool hidden;                                //The outfit will not be shown in the list
var bool unlocked;                              //Has this outfit been unlocked?

//Set our outfit unlocked, and unlock all parts
function SetUnlocked()
{
    local int i;
    unlocked = true;
    for (i = 0;i < numParts;i++)
        parts[i].unlocked = true;
    player.ClientMessage("Unlocking " $ name);
}

function ReplacePart(int type, OutfitPart part)
{
    local int i;
    for (i = 0;i < numParts;i++)
    {
        if (parts[i].bodySlot == type)
            parts[i] = part;
    }
}

function OutfitPart GetPartOfType(int type)
{
    local int i;
    for (i = 0;i < numParts;i++)
    {
        if (parts[i].bodySlot == type)
            return parts[i];
    }
        
    return None;
}

function CopyPartsListTo(Outfit O)
{
    local int i;

    O.partsGroup = partsGroup;
    O.numParts = numParts;

    for (i = 0;i < numParts;i++)
        O.parts[i] = parts[i];
}

function AddPartFromID(string partID)
{
    local OutfitPart P;
    P = partsGroup.GetPartWithID(partID);

    if (P != None)
        parts[numParts++] = P;
    else
        player.ClientMessage("Warning: Outfit could not find part with id " $ partID);
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
    A.Texture = Texture'DeusExItems.Skins.PinkMaskTex';
    for (i = 0;i < 8;i++)
        A.MultiSkins[i] = Texture'DeusExItems.Skins.PinkMaskTex';

    //Apply new textures from each part
    for (i = 0;i < numParts;i++)
    {
        for (s = 0;s < 9;s++)
        {
            T = parts[i].textures[s];

            //don't add any accessory textures if accessories are turned off
            if (parts[i].isAccessory && !allowAccessories)
                continue;

            //skip null textures
            if (IsNullTexture(T))
                continue;

            if (s == 8)
                A.Texture = T;
            else
                A.MultiSkins[s] = T;
        }
    }
}
