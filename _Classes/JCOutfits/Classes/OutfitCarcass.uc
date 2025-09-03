//Carcass replacer used by Augmentique.
class OutfitCarcass extends DeusExCarcass;

function CopyOutfitFrom(Actor A)
{
    local ScriptedPawn S;
    S = ScriptedPawn(A);

    //GMDX Specific Code
    if (S != None && IsHDTP())
    {
        augmentiqueData.textures[0] = S.augmentiqueData.textures[0];
        augmentiqueData.textures[1] = S.augmentiqueData.textures[1];
        augmentiqueData.textures[2] = S.augmentiqueData.textures[2];
        augmentiqueData.textures[3] = S.augmentiqueData.textures[3];
        augmentiqueData.textures[4] = S.augmentiqueData.textures[4];
        augmentiqueData.textures[5] = S.augmentiqueData.textures[5];
        augmentiqueData.textures[6] = S.augmentiqueData.textures[6];
        augmentiqueData.textures[7] = S.augmentiqueData.textures[7];
        augmentiqueData.textures[8] = S.augmentiqueData.textures[8];
        augmentiqueData.bRandomized = S.augmentiqueData.bRandomized;
    }
    else if (S != None)
    {
        augmentiqueData.textures[0] = S.MultiSkins[0];
        augmentiqueData.textures[1] = S.MultiSkins[1];
        augmentiqueData.textures[2] = S.MultiSkins[2];
        augmentiqueData.textures[3] = S.MultiSkins[3];
        augmentiqueData.textures[4] = S.MultiSkins[4];
        augmentiqueData.textures[5] = S.MultiSkins[5];
        augmentiqueData.textures[6] = S.MultiSkins[6];
        augmentiqueData.textures[7] = S.MultiSkins[7];
        augmentiqueData.textures[8] = S.Texture;
        augmentiqueData.bRandomized = S.augmentiqueData.bRandomized;
    }
    ApplyCurrentOutfit();
}

function InitFor(Actor Other)
{
    Mesh = Mesh(DynamicLoadObject(Other.mesh$"_Carcass", class'Mesh', true));
    Mesh2 = Mesh(DynamicLoadObject(Other.mesh$"_CarcassB", class'Mesh', true));
    Mesh3 = Mesh(DynamicLoadObject(Other.mesh$"_CarcassC", class'Mesh', true));

    super.InitFor(Other);

    multiskins[0] = Other.multiskins[0];
    multiskins[1] = Other.multiskins[1];
    multiskins[2] = Other.multiskins[2];
    multiskins[3] = Other.multiskins[3];
    multiskins[4] = Other.multiskins[4];
    multiskins[5] = Other.multiskins[5];
    multiskins[6] = Other.multiskins[6];
    multiskins[7] = Other.multiskins[7];
    Texture = Other.Texture;
}
