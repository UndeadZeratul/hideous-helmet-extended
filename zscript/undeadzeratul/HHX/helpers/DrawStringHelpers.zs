extend struct HHX {

    static void drawString(HCStatusbar sb, HUDFont font, string text, Vector2 pos, int flags = 0, int fontColor = Font.CR_UNTRANSLATED, double scale = 1.0) {
        let easterEggs = CVar.GetCVar("uz_hhx_eastereggs_enabled", sb.CPlayer);

        // If Easter Eggs are enabled or it's April 1st, nice.
        if (
            (easterEggs && easterEggs.GetBool())
            || SystemTime.Format("%m-%d", SystemTime.Now()) == "04-01"
        ) {
            text.replace("69", "nice");
            text.replace("6.9", "ni.ce");
        }

        sb.DrawString(font, text, pos, flags, fontColor, scale: (scale, scale));
    }
}