class OutfitCarcassReplacer extends JCDentonMaleCarcass;

function SetSkin(DeusExPlayer player)
{
    local OutfitManager OM;
    Super.SetSkin(player);
    
    OM = OutfitManager(player.outfitManager);
    OM.ApplyCurrentOutfitToActor(self);
}

defaultproperties
{
}
