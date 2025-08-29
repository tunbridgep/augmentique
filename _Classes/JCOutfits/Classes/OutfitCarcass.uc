//Carcass replacer used by Augmentique.
class OutfitCarcass extends DeusExCarcass;

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
