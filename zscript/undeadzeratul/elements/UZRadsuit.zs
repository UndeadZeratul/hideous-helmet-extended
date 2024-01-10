class UZRadsuit : HUDElement {

    private transient CVar _ref;
    private transient CVar _enabled;

    override void Init(HCStatusbar sb) {
        ZLayer = -2;
        Namespace = "radsuit";
    }

    override void Tick(HCStatusbar sb) {
        if (!_ref) _ref         = CVar.GetCVar("uz_hhx_radsuit_ref", sb.CPlayer);
        if (!_enabled) _enabled = CVar.GetCVar("uz_hhx_radsuit_enabled", sb.CPlayer);
    }

    override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {

        // Only render if we're wearing a Radsuit
        if (
            !_enabled.GetBool()
            || !sb.hpl.CountInv('WornRadsuit')
        ) return;

        // Get the Radsuit Replacement Graphic
        string ref = _ref.GetString();

        // Get the current HUD Scaling value
        Vector2 hudScale = sb.GetHUDScale();

        // Store the raw dimensions of the Background Image
        int bgWidth;
        int bgHeight;
        [bgWidth, bgHeight] = TexMan.GetSize(TexMan.CheckForTexture(ref));

        // Calculate the proper scaling value based on the raw dimensions between the Background Image and the screen
        Double scaleX = 1. / bgWidth / hudScale.x * Screen.GetWidth();
        Double scaleY = 1. / bgHeight / hudScale.y * Screen.GetHeight();

        Vector2 bgScale = ((Double(bgWidth) / Double(bgHeight)) - Screen.GetAspectRatio()) < 0 ? (scaleX, scaleX) : (scaleY, scaleY);

        sb.DrawImage(
            ref,
            (0, 0),
            sb.DI_SCREEN_CENTER_BOTTOM,
            scale: bgScale
        );
    }
}
