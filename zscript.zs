version "4.11"

// Base Classes
#include "zscript/undeadzeratul/base/Mixins.zs"
#include "zscript/undeadzeratul/base/BaseCounter.zs"
#include "zscript/undeadzeratul/base/BaseWeaponStatusOverride.zs"


// Event Handlers
#include "zscript/undeadzeratul/handlers/HHXHandler.zs"


// HUD Elements
#include "zscript/undeadzeratul/elements/UZAmmoCounters.zs"
#include "zscript/undeadzeratul/elements/UZArmour.zs"
#include "zscript/undeadzeratul/elements/UZBackground.zs"
#include "zscript/undeadzeratul/elements/UZCompass.zs"
#include "zscript/undeadzeratul/elements/UZDrawHelmet.zs"
#include "zscript/undeadzeratul/elements/UZEKG.zs"
#include "zscript/undeadzeratul/elements/UZEncumbrance.zs"
#include "zscript/undeadzeratul/elements/UZFullInventory.zs"
#include "zscript/undeadzeratul/elements/UZHeartbeat.zs"
#include "zscript/undeadzeratul/elements/UZInventory.zs"
#include "zscript/undeadzeratul/elements/UZItemAdditions.zs"
#include "zscript/undeadzeratul/elements/UZKeys.zs"
#include "zscript/undeadzeratul/elements/UZMugshot.zs"
#include "zscript/undeadzeratul/elements/UZObjectDescription.zs"
#include "zscript/undeadzeratul/elements/UZPosition.zs"
#include "zscript/undeadzeratul/elements/UZRadsuit.zs"
#include "zscript/undeadzeratul/elements/UZRespirator.zs"
#include "zscript/undeadzeratul/elements/UZSquadStatus.zs"
#include "zscript/undeadzeratul/elements/UZToasty.zs"
#include "zscript/undeadzeratul/elements/UZWeaponHelp.zs"
#include "zscript/undeadzeratul/elements/UZWeaponSprite.zs"
#include "zscript/undeadzeratul/elements/UZWeaponStash.zs"
// #include "zscript/undeadzeratul/elements/UZWeaponStatus.zs"
#include "zscript/undeadzeratul/elements/UZWoundCounter.zs"


// Stat Counters
#include "zscript/undeadzeratul/elements/counters/UZAggroCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZAirCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZAirToxicityCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZAlcoholCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZBerserkCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZBerserkCooldownCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZBloodBagCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZBloodLossCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZBloodPressureCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZBluesCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZBurnCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZCurseCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZEnergyCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZFatigueCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZFireDouseCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZFragCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZHeartrateCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZHeatCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZHurtFloorCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZHydroCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZIncapCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZLevelKillsCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZLevelSecretsCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZLivesCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZMercBucksCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZPlayerToxicityCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZSecondFleshCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZSickCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZSpeedCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZStimCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZStripCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZStunnedCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZTargetDistanceCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZTargetHeatCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZTargetShieldCounter.zs"
#include "zscript/undeadzeratul/elements/counters/UZTissueDamageCounter.zs"


// Item Overrides
#include "zscript/undeadzeratul/overrides/items/UZPersonalShieldGeneratorOverride.zs"
#include "zscript/undeadzeratul/overrides/items/UZArmourOverride.zs"
#include "zscript/undeadzeratul/overrides/items/UZBloodBagOverride.zs"
#include "zscript/undeadzeratul/overrides/items/UZGyroStabilizerOverride.zs"


// Overlay Overrides
#include "zscript/undeadzeratul/overrides/overlays/UZRadsuitOverride.zs"


// Weapon Overrides
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZBlooperOverride.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZBFG9000Override.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZBrontornisOverride.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZBossRifleOverride.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZHunterOverride.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZLiberatorOverride.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZPistolOverride.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZSlayerOverride.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZRevolverOverride.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZRocketLauncherOverride.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZSmgOverride.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZThunderbusterOverride.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZVulcanetteOverride.zs"
#include "zscript/undeadzeratul/overrides/weapons/vanilla/UZZM66Override.zs"

#include "zscript/undeadzeratul/overrides/weapons/fda/UZAltisOverride.zs"

#include "zscript/undeadzeratul/overrides/weapons/icarus/UZPD42Override.zs"

#include "zscript/undeadzeratul/overrides/weapons/peppergrinder/UZGreelyOverride.zs"

#include "zscript/undeadzeratul/overrides/weapons/radtech/UZObrozzOverride.zs"