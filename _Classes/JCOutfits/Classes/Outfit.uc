class Outfit extends Object;

var travel string id;
var travel string name;
var travel string desc;
var travel string pickupName;
var travel string pickupMessage;
var travel string pickupArticle;
var travel string highlightName;

var PartsGroup partsGroup;

var OutfitPart parts[20];
var int numParts;

var DeusExPlayer player;

var int index;                                  //The position in the master outfits list
var travel bool hidden;                         //The outfit will not be shown in the list
var bool unlocked;                              //Has this outfit been unlocked?
var bool bNew;                                  //Sort to the top when we open the outfits menu if we haven't equipped this yet

//Set our outfit unlocked, and unlock all parts
function SetUnlocked()
{
    local int i;
    unlocked = true;
    for (i = 0;i < numParts;i++)
        parts[i].Unlock();
    //player.ClientMessage("Unlocking " $ name);
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

//Returns the last part of a given type
function OutfitPart GetPartOfType(int type)
{
    local int i;
    local OutfitPart P;
    for (i = 0;i < numParts;i++)
    {
        if (parts[i].bodySlot == type)
            P = parts[i];
    }
        
    return P;
}

function CopyPartsListTo(Outfit O)
{
    local int i;

    O.UpdatePartsGroup(partsGroup);
    O.numParts = numParts;

    for (i = 0;i < numParts;i++)
        O.parts[i] = parts[i];
}

function UpdatePartsGroup(PartsGroup PG)
{
    partsGroup = PG;
}

//Remove all parts from an outfit.
//Really only used by Custom...
function ResetParts()
{
    numParts = 0;
}

function AddPartFromID(string partID)
{
    local OutfitPart P;
    local int i;
    P = partsGroup.GetPartWithID(partID);

    if (numParts >= 20)
    {
        player.ClientMessage("Warning: Outfit " $ id $ " could not add part " $ partID $ " because the parts array is full");
        return;
    }


    if (P != None)
        parts[numParts++] = P;
    else
        player.ClientMessage("Warning: Outfit " $ id $ " could not find part with id " $ partID);
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
    local DeusExCarcass C;
    
    if (A.IsA('DeusExCarcass'))
    {
        //Log("partsGroup.carcassMesh: " $ partsGroup.carcassMesh);
        C = DeusExCarcass(A);
        DeusExCarcass(A).mesh = partsGroup.carcassMesh;
        DeusExCarcass(A).mesh2 = LodMesh(DynamicLoadObject(string(partsGroup.carcassMesh) $ "B", class'LodMesh', true));
        DeusExCarcass(A).mesh3 = LodMesh(DynamicLoadObject(string(partsGroup.carcassMesh) $ "C", class'LodMesh', true));
    }
    else
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
            //Log("Applying texture " $ T $ " to slot " $ s);

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

defaultproperties
{
}
