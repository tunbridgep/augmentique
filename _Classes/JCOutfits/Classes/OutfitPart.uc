class OutfitPart extends Object;

var string partID;                      //What name are we giving this part?
var string name;                        //The name of the part
var Texture textures[9];                //Textures for this part. MultiSkins0-7 and then main texture
var int bodySlot;                       //Which area of the body is this part being applied to
var bool isAccessory;                   //Whether or not this part is an accessory
var int index;                          //Index in it's Parts Group
var bool unlocked;                      //Is this part unlocked?
var OutfitPart original;                //If a new version was created when transposing, link to the older one

function Unlock()
{
    unlocked = true;
    if (original != None)
        original.unlocked = true;
}

defaultproperties
{
}
