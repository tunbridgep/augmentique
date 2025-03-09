class OutfitCustom extends Outfit;

//We can't save references, so we need to save and load them when we create the object
var travel string partsGroupID;
var travel string partIDs[20];
var travel int numPartIDs;

function PopulateFromSaved(PartsGroup PG)
{
    local int i;
    partsGroup = PG;
    //player.clientMessage("Using PG " $ partsGroupID);

    for (i = 0;i < numPartIDs;i++)
        AddPartFromIDNoUpdate(partIDs[i]);
    //UpdatePartIDsList();
}

function UpdatePartIDsList()
{
    //player.clientMessage("numParts: " $ numParts);
    numPartIDs = 0;
    while (numPartIDs < numParts)
    {
        //player.clientMessage("Updating Part ID List: " $ parts[numPartIDs].partID);
        partIDs[numPartIDs] = parts[numPartIDs].partID;
        numPartIDs++;
    }
    //player.clientMessage("numPartsIDs: " $ numPartIDs);
}

function UpdatePartsGroup(PartsGroup PG)
{
    partsGroup = PG;
    partsGroupID = string(PG.Mesh);
}

function AddPartFromIDNoUpdate(string partID)
{
    Super.AddPartFromID(partID);
    //player.clientmessage("adding part from id " $ partID);
}

function AddPartFromID(string partID)
{
    AddPartFromIDNoUpdate(partID);
    UpdatePartIDsList();
}

function ReplacePart(int type, OutfitPart part)
{
    Super.ReplacePart(type,part);
    UpdatePartIDsList();
}

function ApplyOutfitToActor(Actor A, bool allowAccessories)
{
    hidden = false;
    Super.ApplyOutfitToActor(A,allowAccessories);
}

defaultproperties
{
}
