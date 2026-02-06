class UZBerserkOverlay {
    int time;
    int lifetime;
    string graphic;
    Vector2 pos;
    double scale;

    static UZBerserkOverlay create(int time, int lifetime, string graphic, Vector2 pos, double scale) {
        let ret = new ('UZBerserkOverlay');

        if (ret) {
            ret.time = time;
            ret.lifetime = lifetime;
            ret.graphic = graphic;
            ret.pos = pos;
            ret.scale = scale;
        }

        return ret;
    }
}

class UZBerserkOverride : HCItemOverride {

    private transient CVar _enabled;

    private transient Array<UZBerserkOverlay> overlays;
    
    override void Init(HCStatusbar sb) {
        Priority     = 2;
        OverrideType = HCOVERRIDETYPE_ITEM;
    }

    override bool CheckItem(Inventory item) {
        return (!_enabled || _enabled.GetBool()) && item.GetClassName() == "HDZerk";
    }

    override void Tick(HCStatusbar sb) {
        if (!_enabled) _enabled = CVar.GetCVar("uz_hhx_berserk_enabled", sb.CPlayer);

        Array<UZBerserkOverlay> newOverlays;
        newOverlays.clear();
        
        forEach(overlay : overlays) if (Level.time - overlay.time < overlay.lifetime) newOverlays.push(overlay);

        if (!crandom[hhxrand](0, newOverlays.size() * 35)) {
            let overlay = UZBerserkOverlay.create(
                Level.time,
                crandom[hhxrand](35, 105),
                "KILL"..crandom[hhxrand](1, 4),
                (crandom[hhxrand](0, sb.horizontalResolution), crandom[hhxrand](0, sb.verticalResolution)),
                cfrandom[hhxrand](0.5, 4.0)
            );

            if (overlay) {
                newOverlays.push(overlay);
            }
        }

        overlays.move(newOverlays);
    }

	override void DrawHUDStuff(HCStatusbar sb, Inventory item, int hdFlags, int gzFlags) {
        forEach (overlay : overlays) {
            sb.drawImage(
                overlay.graphic,
                overlay.pos,
                flags: sb.DI_ITEM_CENTER,
                alpha: 1.0 - ((Level.time - overlay.time) / max(1.0, double(overlay.lifetime))),
                scale: (overlay.scale, overlay.scale)
            );
        }
    }
}