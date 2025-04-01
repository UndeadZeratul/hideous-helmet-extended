class HHXLineTraceData {
    int hitType;

    double distance;

    Actor hitActor;
    Line hitLine;
    Sector hitSector;

    HHXLineTraceData Update(FLineTraceData newData) {
        hitType   = newData.hitType;
        distance  = newData.distance;
        hitActor  = newData.hitActor;
        hitLine   = newData.hitLine;
        hitSector = newData.hitSector;

        return self;
    }
}

class HHXToastyData {
    int deathTic;
    
    int hotDamage;
    int burnCount;
    
    HHXToastyData Update(int deathTic = -1, int hotDamage = -1, int burnCount = -1) {
        if (deathTic >= 0) self.deathTic  = deathTic;
        if (hotDamage >= 0) self.hotDamage = hotDamage;
        if (burnCount >= 0) self.burnCount = burnCount;

        return self;
    }
}

class HHXHandler : EventHandler {
    Array<HHXLineTraceData> lineTraceData;
    Array<HHXToastyData> toastyData;

    override void OnRegister() {
        lineTraceData.Reserve(MAXPLAYERS);
        toastyData.Reserve(MAXPLAYERS);
    }

    override void WorldTick() {
        for (int i = 0; i < MAXPLAYERS; i++) HandleLineTraceData(i);
    }

    override void WorldThingDamaged(WorldEvent e) {

        // If thing doesn't exist, quit.
        if (!e.thing) return;

        // If thing isn't a PlayerPawn, quit.
        let hdp = HDPlayerPawn(e.thing);
        if (!hdp) return;

        // If damage type isn't from fire/heat, quit.
        let damageType = e.damageType;
		HDMath.ProcessSynonyms(damageType);
        if (damageType != 'hot') return;

        for (int i = 0; i < MAXPLAYERS; i++) {
            if (PlayerInGame[i] && PLAYERS[i].mo == hdp) {
                let currDamage = toastyData[i] ? toastyData[i].hotDamage : 0;
                HandleToastyData(i, hotDamage: currDamage + e.damage, burnCount: hdp.burnCount);
            }
        }
    }

    override void WorldThingRevived(WorldEvent e) {

        // If thing doesn't exist, quit.
        if (!e.thing) return;

        // If thing isn't a PlayerPawn, quit.
        let hdp = HDPlayerPawn(e.thing);
        if (!hdp) return;

        for (int i = 0; i < MAXPLAYERS; i++) if (PlayerInGame[i] && PLAYERS[i].mo == hdp) HandleToastyData(i, 0, 0, 0);
    }

    override void WorldThingDied(WorldEvent e) {

        // If thing doesn't exist, quit.
        if (!e.thing) return;

        // If thing isn't a PlayerPawn, quit.
        let hdp = HDPlayerPawn(e.thing);
        if (!hdp) return;

        for (int i = 0; i < MAXPLAYERS; i++) if (PlayerInGame[i] && PLAYERS[i].mo == hdp) HandleToastyData(i, deathTic: Level.time);
    }

    override void PlayerRespawned(PlayerEvent e) {
        HandleToastyData(e.playerNumber, 0, 0, 0);
    }

    override void RenderOverlay(RenderEvent e) {

        let data = toastyData[ConsolePlayer];
        let enabled = CVar.GetCVar('uz_hhx_eastereggs_enabled', PLAYERS[ConsolePlayer]);

        if (
            !(
                data
                && data.deathTic > 0
                && (
                    (enabled && enabled.GetBool())
                    || SystemTime.Format("%m-%d", SystemTime.Now()) == "04-01"
                )
            )
        ) return;
        
        let minTics       = TICRATE;
        let maxTics       = 3 * TICRATE;
        let slideInStart  = minTics;
        let slideInEnd    = minTics + (TICRATE * 0.5);
        let slideOutStart = maxTics - (TICRATE * 0.5);
        let slideOutEnd   = maxTics;
        
        let ticsSince     = Level.time - data.deathTic + e.FracTic;
        let slideInRatio  = clamp((ticsSince - slideInStart) / (slideInEnd - slideInStart), 0.0, 1.0);
        let slideOutRatio = 1.0 - clamp((ticsSince - slideOutStart) / (slideOutEnd - slideOutStart), 0.0, 1.0);


        // If suffered enough fire damage or was burned enough at the time of death, do the thing
        if ((data.hotDamage > 30 || data.burnCount > 30) && ticsSince >= minTics && ticsSince <= maxTics) {

            let toastyTex = TexMan.CheckForTexture("TOASTY");
            let toastyTexSize = TexMan.GetScaledSize(toastyTex);

            // Calculate X-Offset to slide in/out TOASTY graphic
            let xOff = (ticsSince > slideInStart && ticsSince < slideInEnd)
                ? slideInRatio * toastyTexSize.x
                : (ticsSince > slideInEnd && ticsSince < slideOutStart)
                    ? toastyTexSize.x
                    : (ticsSince > slideOutStart && ticsSince < slideOutEnd)
                        ? slideOutRatio * toastyTexSize.x
                        : 0.0;

            // Draw the TOASTY
            StatusBar.DrawImage(
                TexMan.GetName(toastyTex),
                (-xOff, 0.0),
                StatusBar.DI_SCREEN_RIGHT_BOTTOM|StatusBar.DI_ITEM_LEFT_BOTTOM
            );
        }
    }

    protected void HandleLineTraceData(int i) {
        FLineTraceData traceData;

        let plr = HDPlayerPawn(players[i].mo);

        if (plr) {
            plr.LineTrace(
                plr.angle,
                1024 * HDCONST_ONEMETRE,
                plr.pitch,
                flags: TRF_NOSKY,
                offsetz: plr.height * HDCONST_EYEHEIGHT,
                data: traceData
            );

            let data = lineTraceData[i] ? lineTraceData[i] : HHXLineTraceData(new('HHXLineTraceData'));
            lineTraceData[i] = data.Update(traceData);
        }
    }

    protected void HandleToastyData(int i, int deathTic = -1, int hotDamage = -1, int burnCount = -1) {
        let data = toastyData[i] ? toastyData[i] : HHXToastyData(new('HHXToastyData'));
        toastyData[i] = data.Update(deathTic, hotDamage, burnCount);
    }
}