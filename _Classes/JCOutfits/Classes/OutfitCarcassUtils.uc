class OutfitCarcassUtils extends Object abstract;

function static CopyOutfitFromActorToCarcass(Actor A, DeusExCarcass C, optional bool bStrictMode)
{
    local ScriptedPawn S;
    
    if (C == None || !C.augmentiqueData.bRandomized)
        return;

    S = ScriptedPawn(A);

    //Strict mode only copies over the original data.
    //Used when the model is in an invalid state (such as HDTP)
    if (S != None && bStrictMode)
    {
        C.augmentiqueData.textures[0] = S.augmentiqueData.textures[0];
        C.augmentiqueData.textures[1] = S.augmentiqueData.textures[1];
        C.augmentiqueData.textures[2] = S.augmentiqueData.textures[2];
        C.augmentiqueData.textures[3] = S.augmentiqueData.textures[3];
        C.augmentiqueData.textures[4] = S.augmentiqueData.textures[4];
        C.augmentiqueData.textures[5] = S.augmentiqueData.textures[5];
        C.augmentiqueData.textures[6] = S.augmentiqueData.textures[6];
        C.augmentiqueData.textures[7] = S.augmentiqueData.textures[7];
        C.augmentiqueData.textures[8] = S.augmentiqueData.textures[8];
        C.augmentiqueData.bRandomized = S.augmentiqueData.bRandomized;
    }
    else if (S != None)
    {
        C.augmentiqueData.textures[0] = S.MultiSkins[0];
        C.augmentiqueData.textures[1] = S.MultiSkins[1];
        C.augmentiqueData.textures[2] = S.MultiSkins[2];
        C.augmentiqueData.textures[3] = S.MultiSkins[3];
        C.augmentiqueData.textures[4] = S.MultiSkins[4];
        C.augmentiqueData.textures[5] = S.MultiSkins[5];
        C.augmentiqueData.textures[6] = S.MultiSkins[6];
        C.augmentiqueData.textures[7] = S.MultiSkins[7];
        C.augmentiqueData.textures[8] = S.Texture;
        C.augmentiqueData.bRandomized = S.augmentiqueData.bRandomized;
    }
    C.ApplyCurrentOutfit();
}

function static CopyAugmentiqueDataToPOVCorpse(POVCorpse pov, DeusExCarcass C, optional bool bStrictMode)
{
    if (C == None || !C.augmentiqueData.bRandomized)
        return;

    //Strict mode only copies over the original data.
    //Used when the model is in an invalid state (such as HDTP)
    if (pov != None && bStrictMode)
    {
        pov.augmentiqueData.textures[0] = c.augmentiqueData.textures[0];
        pov.augmentiqueData.textures[1] = c.augmentiqueData.textures[1];
        pov.augmentiqueData.textures[2] = c.augmentiqueData.textures[2];
        pov.augmentiqueData.textures[3] = c.augmentiqueData.textures[3];
        pov.augmentiqueData.textures[4] = c.augmentiqueData.textures[4];
        pov.augmentiqueData.textures[5] = c.augmentiqueData.textures[5];
        pov.augmentiqueData.textures[6] = c.augmentiqueData.textures[6];
        pov.augmentiqueData.textures[7] = c.augmentiqueData.textures[7];
        pov.augmentiqueData.textures[8] = c.augmentiqueData.textures[8];
    }
    else if (pov != None)
    {
        pov.augmentiqueData.textures[0] = c.multiskins[0];
        pov.augmentiqueData.textures[1] = c.multiskins[1];
        pov.augmentiqueData.textures[2] = c.multiskins[2];
        pov.augmentiqueData.textures[3] = c.multiskins[3];
        pov.augmentiqueData.textures[4] = c.multiskins[4];
        pov.augmentiqueData.textures[5] = c.multiskins[5];
        pov.augmentiqueData.textures[6] = c.multiskins[6];
        pov.augmentiqueData.textures[7] = c.multiskins[7];
        pov.augmentiqueData.textures[8] = c.Texture;
        pov.augmentiqueData.bRandomized = c.augmentiqueData.bRandomized;
    }
}

function static CopyAugmentiqueDataFromPOVCorpse(POVCorpse pov, DeusExCarcass C)
{
    C.augmentiqueData.textures[0] = pov.augmentiqueData.textures[0];
    C.augmentiqueData.textures[1] = pov.augmentiqueData.textures[1];
    C.augmentiqueData.textures[2] = pov.augmentiqueData.textures[2];
    C.augmentiqueData.textures[3] = pov.augmentiqueData.textures[3];
    C.augmentiqueData.textures[4] = pov.augmentiqueData.textures[4];
    C.augmentiqueData.textures[5] = pov.augmentiqueData.textures[5];
    C.augmentiqueData.textures[6] = pov.augmentiqueData.textures[6];
    C.augmentiqueData.textures[7] = pov.augmentiqueData.textures[7];
    C.augmentiqueData.textures[8] = pov.augmentiqueData.textures[8];
    C.augmentiqueData.bRandomized = pov.augmentiqueData.bRandomized;
    C.ApplyCurrentOutfit();
}

function static ApplyOutfitToCarcass(DeusExCarcass C)
{
    local int i;

    if (C == None || !C.augmentiqueData.bRandomized)
        return;
    
    //Log("Doing carcass stuff");

    for (i = 0;i < 8;i++)
        if (C.augmentiqueData.textures[i] != None)
            C.multiskins[i] = C.augmentiqueData.textures[i];
    if (C.augmentiqueData.textures[8] != None)
        C.Texture = C.augmentiqueData.textures[8];
}

