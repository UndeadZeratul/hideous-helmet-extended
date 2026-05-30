class UZToasty : HUDElement {

    private transient HHXHandler _handler;
    
    private transient HHXToastyData _data;

    private transient CVar _enabled;

    override void Init(HCStatusbar sb) {
        ZLayer = 100;
        Namespace = "toasty";
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
}
