class UZToasty : HUDElement {

    private transient HHXHandler _handler;
    
    private transient HHXToastyData _data;

    private transient CVar _enabled;

    // private transient float _minTics;
    // private transient float _maxTics;
    // private transient float _slideInStart;
    // private transient float _slideInEnd;
    // private transient float _slideOutStart;
    // private transient float _slideOutEnd;

    override void Init(HCStatusbar sb) {
        ZLayer = 100;
        Namespace = "toasty";

        // _minTics       = TICRATE;
        // _maxTics       = 3 * TICRATE;
        // _slideInStart  = _minTics;
        // _slideInEnd    = _minTics + (TICRATE * 0.5);
        // _slideOutStart = _maxTics - (TICRATE * 0.5);
        // _slideOutEnd   = _maxTics;
    }

    override void Tick(HCStatusbar sb) {
        if (!_handler) _handler = HHXHandler(EventHandler.Find('HHXHandler'));

        if (!_enabled) _enabled = CVar.GetCVar('uz_hhx_eastereggs_enabled', sb.CPlayer);

        // If for whatever reason we don't have a playerpawn, quit.
        if (!sb.hpl) return;

        // If we still don't have either of these, or we don't have easter eggs enabled and it's not April 1st, quit.
        if (!(_handler && _data && ((_enabled && _enabled.GetBool()) || SystemTime.Format("%m-%d", SystemTime.Now()) == "04-01"))) return;

        // Get a new copy of the Toasty Data
        let newData = _handler.toastyData[sb.hpl.PlayerNumber()];
        if ((!_data && newData) || (_data && newData && _data.deathTic != newData.deathTic)) _data = newData;

        // If we've taken enough fire damage or have enough burns, TOASTY!
        if ((_data.hotDamage > 50 || _data.burnCount > 50) && Level.time - _data.deathTic == TICRATE) S_StartSound("hhx/ui/toasty", CHAN_VOICE, CHANF_LOCAL);
    }

    // override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {

    //     if (
    //         !_handler
    //         || !_data
    //     ) return;
    //     let ticsSince     = Level.time - _data.deathTic + ticFrac;
    //     let slideInRatio  = clamp((ticsSince - _slideInStart) / (_slideInEnd - _slideInStart), 0.0, 1.0);
    //     let slideOutRatio = 1.0 - clamp((ticsSince - _slideOutStart) / (_slideOutEnd - _slideOutStart), 0.0, 1.0);

    //     // If suffered mostly fire damage or was mostly burned at the time of death, do the thing
    //     if ((_data.hotDamage > 50 || _data.burnCount > 50) && ticsSince >= _minTics && ticsSince <= _maxTics) {
    //         Console.PrintF("Hot Damage Taken: ".._data.hotDamage..", Burn Count: ".._data.burnCount);
    //         let toastyTex = TexMan.CheckForTexture("TOASTY");
    //         let toastyTexSize = TexMan.GetScaledSize(toastyTex);

    //         // Calculate X-Offset to slide in/out TOASTY graphic
    //         let xOff = (ticsSince > _slideInStart && ticsSince < _slideInEnd)
    //             ? slideInRatio * toastyTexSize.x
    //             : (ticsSince > _slideInEnd && ticsSince < _slideOutStart)
    //                 ? toastyTexSize.x
    //                 : (ticsSince > _slideOutStart && ticsSince < _slideOutEnd)
    //                     ? slideOutRatio * toastyTexSize.x
    //                     : 0.0;

    //         // Draw the TOASTY
    //         sb.DrawImage(
    //             TexMan.GetName(toastyTex),
    //             (-xOff, 0.0),
    //             // sb.DI_SCREEN_CENTER|sb.DI_ITEM_CENTER
    //             sb.DI_SCREEN_RIGHT_BOTTOM|sb.DI_ITEM_LEFT_BOTTOM
    //         );
    //     }
    // }
}
