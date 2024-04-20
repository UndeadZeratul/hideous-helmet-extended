class UZStenMk2Override : UZSmgOverride {
    
    override void Init(HCStatusbar sb) {
        super.Init(sb);

        weaponName = 'HDStenMk2';
    }

    override bool ShouldDrawChamberedRound(HDWeapon wpn) {
        return GetChamberedRounds(wpn) > 0;
    }

    override void DrawWeaponStatus(HCStatusBar sb, HDWeapon wpn, int posX, int posY, float scale, HUDFont hudFont, int fontColor, float fontScale) {
        super.DrawWeaponStatus(sb, wpn, posX, posY, scale, hudFont, fontColor, fontScale);

        // Draw Heat Bar
        DrawMagazineRounds(
            sb, wpn,
            wpn.weaponStatus[6],
            55 - 5, // HDSTEN_OVERHEAT - 5
            ShouldDrawMagRoundsPrecise(wpn, GetMagRoundsPrecision(wpn)),
            Color(255, sb.sbColour.r, sb.sbColour.g, sb.sbColour.b),
            posX,
            posY - (8 * scale),
            scale,
            hudFont,
            fontColor,
            fontScale,
            sb.DI_SCREEN_CENTER_BOTTOM
        );
    }
}
