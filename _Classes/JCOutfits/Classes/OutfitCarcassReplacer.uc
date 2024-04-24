class OutfitCarcassReplacer extends JCDentonMaleCarcass;

function SetSkin(DeusExPlayer player)
{
    local OutfitManager OM;
    
    OM = OutfitManager(player.outfitManager);

    if (OM != None)
        OM.UpdateCarcass(Self);
}

