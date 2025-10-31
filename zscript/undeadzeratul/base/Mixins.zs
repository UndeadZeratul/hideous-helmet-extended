mixin class UZBetterDrawBar {
    void BetterDrawBar(HCStatusbar sb, name fgName, name bgName, double ratio, Vector2 pos, int flags = 0, int direction = 0, Vector2 scale = (1.0, 1.0), double alpha = 1.0) {

        // Get registered textures for both foreground and background assets
        TextureID fgTex = TexMan.CheckForTexture(fgName, TexMan.TYPE_MISCPATCH);
        TextureID bgTex = TexMan.CheckForTexture(bgName, TexMan.TYPE_MISCPATCH);

        // Calculate Positions & Dimensions of ClipRect
        Vector2 fgSize = TexMan.GetScaledSize(fgTex);
        Vector2 bgSize = TexMan.GetScaledSize(bgTex);

        Vector2 fgPos = pos + GetAlignOffs(fgSize, flags, scale);
        Vector2 bgPos = pos + GetAlignOffs(bgSize, flags, scale);

        // If Vertical
        if (direction & 2) {
            fgSize = (fgSize.x, fgSize.y * ratio);
            bgSize = (bgSize.x, bgSize.y * (1.0 - ratio));

            // If Flipped
            if (direction & 1) {
                bgPos += (0, fgSize.y * scale.y);
            } else {
                fgPos += (0, bgSize.y * scale.y);
            }

        // If Horizontal
        } else {
            fgSize = (fgSize.x * ratio, fgSize.y);
            bgSize = (bgSize.x * (1.0 - ratio), bgSize.y);

            // If Flipped
            if (direction & 1) {
                fgPos += (bgSize.x * scale.x, 0);
            } else {
                bgPos += (fgSize.x * scale.x, 0);
            }
        }

        // Set Clip Rect and draw Background Image
        sb.SetClipRect(bgPos.x, bgPos.y, bgSize.x * scale.x, bgSize.y * scale.y, flags);
        sb.DrawImage(bgName, pos, flags, scale: scale, translation: int(flags&sb.DI_TRANSLATABLE ? sb.hpl.translation : 0));
        sb.ClearClipRect();

        // Set Clip Rect and draw Foreground Image
        sb.SetClipRect(fgPos.x, fgPos.y, fgSize.x * scale.x, fgSize.y * scale.y, flags);
        sb.DrawImage(fgName, pos, flags, scale: scale, translation: int(flags&sb.DI_TRANSLATABLE ? sb.hpl.translation : 0));
        sb.ClearClipRect();
    }

    private Vector2 GetAlignOffs(Vector2 size, int flags, Vector2 scale) {
        // Filter in only the Horizontal/Vertical Alignment flags, separately
        let xAlign = flags&(StatusBar.DI_ITEM_LEFT|StatusBar.DI_ITEM_HCENTER|StatusBar.DI_ITEM_RIGHT);
        let yAlign = flags&(StatusBar.DI_ITEM_TOP|StatusBar.DI_ITEM_VCENTER|StatusBar.DI_ITEM_BOTTOM);

        // Calculate the alignment flags into offsets based on the size of the texture
        let xOffs = xAlign == StatusBar.DI_ITEM_RIGHT ? -size.x : xAlign == StatusBar.DI_ITEM_HCENTER ? -(size.x / 2.0) : 0.0;
        let yOffs = yAlign == StatusBar.DI_ITEM_BOTTOM ? -size.y : yAlign == StatusBar.DI_ITEM_VCENTER ? -(size.y / 2.0) : 0.0;

        // Return the offsets based on the provided scaling ratio
        return (xOffs * scale.x, yOffs * scale.y);
    }
}