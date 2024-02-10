# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]


### Changed

-   Update Build Scripts.

## [v0.8.4] - 2024-02-05

### Added

-   Add more example HUD Screenshots, made by the community.

### Changed

-   Add counts to FullInventory HUD Element.
-   Update Build Scripts.

## [v0.8.3] - 2024-01-19

### Changed

-   Add safety check for getting font for HUD Elements.

## [v0.8.2] - 2024-01-18

### Added

-   Add Tissue Damage Counter HUD Element.

### Changed

-   Fix Aggro Counter value format.

## [v0.8.1] - 2024-01-13

### Changed

-   Fix EKG loop logic.

## [v0.8.0] - 2024-01-09

### Added

-   Add ability to configure how many bars the EKG will track/render.
-   Add support for Cozi's Offworld Wares' Intox Tokens to BAC Stat Counter.
-   Add Squad Status HUD Element.
-   Add Font, Font Color, & Font Scaling CVARs to all relevant HUD Elements.
-   Add Speed Counter HUD Element.
-   Add Armour Strip Counter HUD Element.
-   Added various fluid units to Blood Loss Counter.
-   Add Level Kills Counter HUD Element.
-   Add Level Secrets Counter HUD Element.

### Changed

-   Rename Stat Counter icons, add missing ones for placeholders.
-   Fix EKG, Encumbrance, & Weapon Sprite scaling issues.
-   Add Weapon Sprite scaling options back to Options Menu.

## [v0.7.0] - 2023-10-07

### Added

-   Add TedTheDragon's personal HUD preset (#63).
-   Add Weapon Help Text HUD Element (#65).
-   Add Object Description HUD Element (#65).

## [v0.6.0] - 2023-08-25

### Added

-   Add BAC Counter HUD Element.
-   Add Blood Pressure Counter HUD Element.
-   Added missing DoomNukem Credits.
-   Add UaS Respirator Overlay HUD Element (#58).
-   Add Air Stat Counter HUD Element (#59).
-   Add Merchant's MercBucks Counter HUD Element (#60).

## [v0.5.1] - 2023-06-14

### Changed

-   Fix "Always Visible" Option Menu Label.

## [v0.5.0] - 2023-06-14

### Added

-   Added a superfluous amount of stat counters (#51):
    -   Aggravated Damage
    -   Berserk Cooldown
    -   Blood Loss
    -   Burns
    -   Archvile Curses
    -   Fire Douse
    -   Frag Shards
    -   Heartrate
    -   Heat
    -   Incap
    -   Second Flesh

### Changed

-   Add safety check for another Hideous Helmet Wound Counter CVAR.

## [v0.4.1] - 2023-05-28

### Changed

-   Add safety check for another Hideous Helmet Wound Counter CVAR.

## [v0.4.0] - 2023-05-27

### Added

-   Add Blood Bag Counter HUD Element (#32).
-   Add Radsuit Overlay override (#33).
-   Add new common Base Counter HUD Element (#43).
-   Add Fatigue Counter HUD Element (#44).
-   Add Stunned Counter HUD Element (#45).

### Changed

-   Fix Hard Dependency on Hideous Helmet (#34).
-   Organize UDV Backgrounds & Radsuit Graphics (#37).
-   Clean up Armour HUD Element Offsets (#39).

## [v0.3.1] - 2023-04-11

### Changed

-   Add missing TEXTURES lumps to the PK3.

## [v0.3.0] - 2023-04-11

### Added

-   Add Blues Counter HUD Element.

### Changed

-   Use string comparison for classname checks to remove hard dependencies.
-   Fix Armour Menus relying on AmmoCounters to be enabled.
-   Use WAN Sneaking Suit's own durability stat.
-   Update Armour/Helmet Overrides for latest HUDCore.
-   Refine Preset defaults, console commands, refactor CVARs, etc.

## [v0.2.0] - 2023-04-08

### Added

-   Add Shieldcore to Armour HUD Element (#16).
-   Add Stim Counter HUD Element (#17).
-   Add Berserk Counter HUD Element (#18).

### Changed

-   Fixed Ammo Counters & Weapon Stash scaling issues in the automap.
-   Fix issues with WoundCounter HUD Element when running without Hideous Helmet.
-   Fix Gyro Stabilizer (#15).

## [v0.1.0] - 2023-03-03

### Added

-   Added Swampyrad's Resident Evil 1 HUD Preset.
-   Added automatic scaling options to HUD Background Element.

### Changed

-   Added ability to scale Full Inventory & Ammo Counters per item.
-   Update CVAR names from overlay to background.
-   Refine "Gridlike" HUD Elements.
-   Adjust WeaponStash CVAR values.
-   Adjust scaling logic to support newly added auto-scaling options.
-   Extend Position CVAR Options.

## [v0.0.3] - 2023-02-28

### Changed

-   Fix graphics folder naming convention.

## [v0.0.2] - 2023-02-27

### Changed

-   Added credits for UDV assets.
-   Added Weapon Stash HUD Element.
-   Added ability to scale keys offsets individually.
-   Added ability to scale Full Inventory & Ammo Counters per row/column.

## [v0.0.1] - 2023-02-24

### Added

-   Initial Release.

[Unreleased]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.8.4...HEAD

[v0.8.4]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.8.3..v0.8.4

[v0.8.3]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.8.2..v0.8.3

[v0.8.2]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.8.1..v0.8.2

[v0.8.1]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.8.0..v0.8.1

[v0.8.0]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.7.0..v0.8.0

[v0.7.0]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.6.0..v0.7.0

[v0.6.0]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.5.1..v0.6.0

[v0.5.1]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.5.0..v0.5.1

[v0.5.0]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.4.1..v0.5.0

[v0.4.1]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.4.0..v0.4.1

[v0.4.0]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.3.1..v0.4.0

[v0.3.1]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.3.0..v0.3.1

[v0.3.0]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.2.0..v0.3.0

[v0.2.0]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.1.0..v0.2.0

[v0.1.0]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.0.3..v0.1.0

[v0.0.3]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.0.2..v0.0.3

[v0.0.2]: https://github.com/UndeadZeratul/hideous-helmet-extended/compare/v0.0.1..v0.0.2

[v0.0.1]: https://github.com/UndeadZeratul/hideous-helmet-extended/releases/tag/v0.0.1
