class AllOutfits expands Object abstract;

// ===========================================================================================================
// Import Textures used by the JC Outfits Mod
// ===========================================================================================================

////Boxes
#exec TEXTURE IMPORT FILE="Textures\Boxes\BoxTex1.pcx"                                             NAME="BoxTex1"                     GROUP="Boxes"
#exec TEXTURE IMPORT FILE="Textures\Boxes\AccBoxTex1.pcx"                                          NAME="AccBoxTex1"                  GROUP="Boxes"

////Outfits

//Multi-Gender

//100% Black outfit
#exec TEXTURE IMPORT FILE="Textures\100% Black\Tex1.bmp"                                           NAME="Outfit1_Tex1"                GROUP="Outfits"

//Female Textures

//Alternate Trenchcoat Jewellery Texture
#exec TEXTURE IMPORT FILE="Textures\Female\Alternate Trenchcoat\Tex1.bmp"                          NAME="Outfit1F_Tex1"               GROUP="Outfits"

//Gold and Brown Business
//#exec TEXTURE IMPORT FILE="Textures\Female\Gold & Brown Business\Tex1.pcx"                         NAME="Outfit2F_Tex1"               GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Gold & Brown Business\Tex2.pcx"                         NAME="Outfit2F_Tex2"               GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Gold & Brown Business\Tex3.bmp"                         NAME="Outfit2F_Tex3"               GROUP="Outfits"

//Goth GF Outfit
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex1.bmp"                                NAME="Outfit3F_Tex1"               GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex1_S1.bmp"                             NAME="Outfit3F_Tex1_S1"            GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex1_S2.bmp"                             NAME="Outfit3F_Tex1_S2"            GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex1_S3.bmp"                             NAME="Outfit3F_Tex1_S3"            GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex1_S4.bmp"                             NAME="Outfit3F_Tex1_S4"            GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex2.pcx"                                NAME="Outfit3F_Tex2"               GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Goth GF Outfit\Tex3.bmp"                                NAME="Outfit3F_Tex3"               GROUP="Outfits"

//Matrix Outfit
#exec TEXTURE IMPORT FILE="Textures\Female\Matrix Outfit\Tex1.bmp"                                 NAME="Outfit4F_Tex1"               GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Matrix Outfit\Tex2.pcx"                                 NAME="Outfit4F_Tex2"               GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Female\Matrix Outfit\Tex3.bmp"                                 NAME="Outfit4F_Tex3"               GROUP="Outfits"

//Import Vanilla Textures with new Skins and Circuitry added

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\TerroristTex0_S0.bmp"                          NAME="TerroristTex0"                        GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\TerroristTex0_S1.bmp"                          NAME="TerroristTex0_S1"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\TerroristTex0_S2.bmp"                          NAME="TerroristTex0_S2"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\TerroristTex0_S3.bmp"                          NAME="TerroristTex0_S3"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\TerroristTex0_S4.bmp"                          NAME="TerroristTex0_S4"                     GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\MiscTex1JC_S0.bmp"                             NAME="MiscTex1JC"                           GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\MiscTex1JC_S1.bmp"                             NAME="MiscTex1JC_S1"                        GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\MiscTex1JC_S2.bmp"                             NAME="MiscTex1JC_S2"                        GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\MiscTex1JC_S3.bmp"                             NAME="MiscTex1JC_S3"                        GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\MiscTex1JC_S3.bmp"                             NAME="MiscTex1JC_S3"                        GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SailorSkin_S0.bmp"                             NAME="SailorSkin"                           GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SailorSkin_S1.bmp"                             NAME="SailorSkin_S1"                        GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SailorSkin_S2.bmp"                             NAME="SailorSkin_S2"                        GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SailorSkin_S3.bmp"                             NAME="SailorSkin_S3"                        GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SailorSkin_S4.bmp"                             NAME="SailorSkin_S4"                        GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\ThugSkin_S0.bmp"                               NAME="ThugSkin"                             GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\ThugSkin_S1.bmp"                               NAME="ThugSkin_S1"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\ThugSkin_S2.bmp"                               NAME="ThugSkin_S2"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\ThugSkin_S3.bmp"                               NAME="ThugSkin_S3"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\ThugSkin_S4.bmp"                               NAME="ThugSkin_S4"                          GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SoldierTex0_S0.bmp"                            NAME="SoldierTex0"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SoldierTex0_S1.bmp"                            NAME="SoldierTex0_S1"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SoldierTex0_S2.bmp"                            NAME="SoldierTex0_S2"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SoldierTex0_S3.bmp"                            NAME="SoldierTex0_S3"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SoldierTex0_S4.bmp"                            NAME="SoldierTex0_S4"                       GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SamCarterTex1_S0.bmp"                          NAME="SamCarterTex1"                        GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SamCarterTex1_S1.bmp"                          NAME="SamCarterTex1_S1"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SamCarterTex1_S2.bmp"                          NAME="SamCarterTex1_S2"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SamCarterTex1_S3.bmp"                          NAME="SamCarterTex1_S3"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SamCarterTex1_S4.bmp"                          NAME="SamCarterTex1_S4"                     GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\AnnaNavarreTex1_S0.bmp"                        NAME="AnnaNavarreTex1"                      GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\AnnaNavarreTex1_S1.bmp"                        NAME="AnnaNavarreTex1_S1"                   GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\AnnaNavarreTex1_S2.bmp"                        NAME="AnnaNavarreTex1_S2"                   GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\AnnaNavarreTex1_S3.bmp"                        NAME="AnnaNavarreTex1_S3"                   GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\AnnaNavarreTex1_S4.bmp"                        NAME="AnnaNavarreTex1_S4"                   GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Businesswoman1Tex2_S0.bmp"                     NAME="Businesswoman1Tex2"                   GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Businesswoman1Tex2_S1.bmp"                     NAME="Businesswoman1Tex2_S1"                GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Businesswoman1Tex2_S2.bmp"                     NAME="Businesswoman1Tex2_S2"                GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Businesswoman1Tex2_S3.bmp"                     NAME="Businesswoman1Tex2_S3"                GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Businesswoman1Tex2_S4.bmp"                     NAME="Businesswoman1Tex2_S4"                GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\DentonCloneTex2Fem_S0.bmp"                     NAME="DentonCloneTex2Fem"                   GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\DentonCloneTex2Fem_S1.bmp"                     NAME="DentonCloneTex2Fem_S1"                GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\DentonCloneTex2Fem_S2.bmp"                     NAME="DentonCloneTex2Fem_S2"                GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\DentonCloneTex2Fem_S3.bmp"                     NAME="DentonCloneTex2Fem_S3"                GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\DentonCloneTex2Fem_S4.bmp"                     NAME="DentonCloneTex2Fem_S4"                GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\DentonCloneTex3Fem_S0.bmp"                     NAME="DentonCloneTex3Fem"                   GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\DentonCloneTex3Fem_S1.bmp"                     NAME="DentonCloneTex3Fem_S1"                GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\DentonCloneTex3Fem_S2.bmp"                     NAME="DentonCloneTex3Fem_S2"                GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\DentonCloneTex3Fem_S3.bmp"                     NAME="DentonCloneTex3Fem_S3"                GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\DentonCloneTex3Fem_S4.bmp"                     NAME="DentonCloneTex3Fem_S4"                GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female2Tex1_S0.bmp"                            NAME="Female2Tex1"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female2Tex1_S1.bmp"                            NAME="Female2Tex1_S1"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female2Tex1_S2.bmp"                            NAME="Female2Tex1_S2"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female2Tex1_S3.bmp"                            NAME="Female2Tex1_S3"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female2Tex1_S4.bmp"                            NAME="Female2Tex1_S4"                       GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female3Tex2_S0.bmp"                            NAME="Female3Tex2"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female3Tex2_S1.bmp"                            NAME="Female3Tex2_S1"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female3Tex2_S2.bmp"                            NAME="Female3Tex2_S2"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female3Tex2_S3.bmp"                            NAME="Female3Tex2_S3"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female3Tex2_S4.bmp"                            NAME="Female3Tex2_S4"                       GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female4Tex3_S0.bmp"                            NAME="Female4Tex3"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female4Tex3_S1.bmp"                            NAME="Female4Tex3_S1"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female4Tex3_S2.bmp"                            NAME="Female4Tex3_S2"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female4Tex3_S3.bmp"                            NAME="Female4Tex3_S3"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Female4Tex3_S4.bmp"                            NAME="Female4Tex3_S4"                       GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker1Tex1_S0.bmp"                            NAME="Hooker1Tex1"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker1Tex1_S1.bmp"                            NAME="Hooker1Tex1_S1"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker1Tex1_S2.bmp"                            NAME="Hooker1Tex1_S2"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker1Tex1_S3.bmp"                            NAME="Hooker1Tex1_S3"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker1Tex1_S4.bmp"                            NAME="Hooker1Tex1_S4"                       GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker1Tex3_S0.bmp"                            NAME="Hooker1Tex3"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker1Tex3_S1.bmp"                            NAME="Hooker1Tex3_S1"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker1Tex3_S2.bmp"                            NAME="Hooker1Tex3_S2"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker1Tex3_S3.bmp"                            NAME="Hooker1Tex3_S3"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker1Tex3_S4.bmp"                            NAME="Hooker1Tex3_S4"                       GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker2Tex1_S0.bmp"                            NAME="Hooker2Tex1"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker2Tex1_S1.bmp"                            NAME="Hooker2Tex1_S1"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker2Tex1_S2.bmp"                            NAME="Hooker2Tex1_S2"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker2Tex1_S3.bmp"                            NAME="Hooker2Tex1_S3"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker2Tex1_S4.bmp"                            NAME="Hooker2Tex1_S4"                       GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker2Tex3_S0.bmp"                            NAME="Hooker2Tex3"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker2Tex3_S1.bmp"                            NAME="Hooker2Tex3_S1"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker2Tex3_S2.bmp"                            NAME="Hooker2Tex3_S2"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker2Tex3_S3.bmp"                            NAME="Hooker2Tex3_S3"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\Hooker2Tex3_S4.bmp"                            NAME="Hooker2Tex3_S4"                       GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LegsTex1_S0.bmp"                               NAME="LegsTex1"                             GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LegsTex1_S1.bmp"                               NAME="LegsTex1_S1"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LegsTex1_S2.bmp"                               NAME="LegsTex1_S2"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LegsTex1_S3.bmp"                               NAME="LegsTex1_S3"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LegsTex1_S4.bmp"                               NAME="LegsTex1_S4"                          GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LegsTex2_S0.bmp"                               NAME="LegsTex2"                             GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LegsTex2_S1.bmp"                               NAME="LegsTex2_S1"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LegsTex2_S2.bmp"                               NAME="LegsTex2_S2"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LegsTex2_S3.bmp"                               NAME="LegsTex2_S3"                          GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LegsTex2_S4.bmp"                               NAME="LegsTex2_S4"                          GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\NicoletteDuClareTex1_S0.bmp"                   NAME="NicoletteDuclareTex1"                 GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\NicoletteDuClareTex1_S1.bmp"                   NAME="NicoletteDuclareTex1_S1"              GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\NicoletteDuClareTex1_S2.bmp"                   NAME="NicoletteDuclareTex1_S2"              GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\NicoletteDuClareTex1_S3.bmp"                   NAME="NicoletteDuclareTex1_S3"              GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\NicoletteDuClareTex1_S4.bmp"                   NAME="NicoletteDuclareTex1_S4"              GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\NicoletteDuClareTex3_S0.bmp"                   NAME="NicoletteDuclareTex3"                 GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\NicoletteDuClareTex3_S1.bmp"                   NAME="NicoletteDuclareTex3_S1"              GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\NicoletteDuClareTex3_S2.bmp"                   NAME="NicoletteDuclareTex3_S2"              GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\NicoletteDuClareTex3_S3.bmp"                   NAME="NicoletteDuclareTex3_S3"              GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\NicoletteDuClareTex3_S4.bmp"                   NAME="NicoletteDuclareTex3_S4"              GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SandraRentonTex1_S0.bmp"                       NAME="SandraRentonTex1"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SandraRentonTex1_S1.bmp"                       NAME="SandraRentonTex1_S1"                  GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SandraRentonTex1_S2.bmp"                       NAME="SandraRentonTex1_S2"                  GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SandraRentonTex1_S3.bmp"                       NAME="SandraRentonTex1_S3"                  GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SandraRentonTex1_S4.bmp"                       NAME="SandraRentonTex1_S4"                  GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\RachelMeadTex2_S0.bmp"                         NAME="RachelMeadTex2"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\RachelMeadTex2_S1.bmp"                         NAME="RachelMeadTex2_S1"                    GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\RachelMeadTex2_S2.bmp"                         NAME="RachelMeadTex2_S2"                    GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\RachelMeadTex2_S3.bmp"                         NAME="RachelMeadTex2_S3"                    GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\RachelMeadTex2_S4.bmp"                         NAME="RachelMeadTex2_S4"                    GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SarahMeadTex1_S0.bmp"                          NAME="SarahMeadTex1"                        GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SarahMeadTex1_S1.bmp"                          NAME="SarahMeadTex1_S1"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SarahMeadTex1_S2.bmp"                          NAME="SarahMeadTex1_S2"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SarahMeadTex1_S3.bmp"                          NAME="SarahMeadTex1_S3"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SarahMeadTex1_S4.bmp"                          NAME="SarahMeadTex1_S4"                     GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SarahMeadTex3_S0.bmp"                          NAME="SarahMeadTex3"                        GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SarahMeadTex3_S1.bmp"                          NAME="SarahMeadTex3_S1"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SarahMeadTex3_S2.bmp"                          NAME="SarahMeadTex3_S2"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SarahMeadTex3_S3.bmp"                          NAME="SarahMeadTex3_S3"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\SarahMeadTex3_S4.bmp"                          NAME="SarahMeadTex3_S4"                     GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\ScientistFemaleTex3_S0.bmp"                    NAME="ScientistFemaleTex3"                  GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\ScientistFemaleTex3_S1.bmp"                    NAME="ScientistFemaleTex3_S1"               GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\ScientistFemaleTex3_S2.bmp"                    NAME="ScientistFemaleTex3_S2"               GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\ScientistFemaleTex3_S3.bmp"                    NAME="ScientistFemaleTex3_S3"               GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\ScientistFemaleTex3_S4.bmp"                    NAME="ScientistFemaleTex3_S4"               GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LowerClassFemaleTex1_S0.bmp"                   NAME="LowerClassFemaleTex1"                 GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LowerClassFemaleTex1_S1.bmp"                   NAME="LowerClassFemaleTex1_S1"              GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LowerClassFemaleTex1_S2.bmp"                   NAME="LowerClassFemaleTex1_S2"              GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LowerClassFemaleTex1_S3.bmp"                   NAME="LowerClassFemaleTex1_S3"              GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\LowerClassFemaleTex1_S4.bmp"                   NAME="LowerClassFemaleTex1_S4"              GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\JordanSheaTex1_S0.bmp"                         NAME="JordanSheaTex1"                       GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\JordanSheaTex1_S1.bmp"                         NAME="JordanSheaTex1_S1"                    GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\JordanSheaTex1_S2.bmp"                         NAME="JordanSheaTex1_S2"                    GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\JordanSheaTex1_S3.bmp"                         NAME="JordanSheaTex1_S3"                    GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\JordanSheaTex1_S4.bmp"                         NAME="JordanSheaTex1_S4"                    GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\JunkieFemaleTex1_S0.bmp"                       NAME="JunkieFemaleTex1"                     GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\JunkieFemaleTex1_S1.bmp"                       NAME="JunkieFemaleTex1_S1"                  GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\JunkieFemaleTex1_S2.bmp"                       NAME="JunkieFemaleTex1_S2"                  GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\JunkieFemaleTex1_S3.bmp"                       NAME="JunkieFemaleTex1_S3"                  GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\JunkieFemaleTex1_S4.bmp"                       NAME="JunkieFemaleTex1_S4"                  GROUP="Outfits"

#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\TiffanySavageTex1_S0.bmp"                      NAME="TiffanySavageTex1"                    GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\TiffanySavageTex1_S1.bmp"                      NAME="TiffanySavageTex1_S1"                 GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\TiffanySavageTex1_S2.bmp"                      NAME="TiffanySavageTex1_S2"                 GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\TiffanySavageTex1_S3.bmp"                      NAME="TiffanySavageTex1_S3"                 GROUP="Outfits"
#exec TEXTURE IMPORT FILE="Textures\Vanilla Reskins\TiffanySavageTex1_S4.bmp"                      NAME="TiffanySavageTex1_S4"                 GROUP="Outfits"

defaultproperties
{
}
