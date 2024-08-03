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

class HHXHandler : EventHandler {
    Array<HHXLineTraceData> data;

    override void OnRegister() {
        data.Reserve(MAXPLAYERS);
    }

    override void WorldTick() {
        for (int i = 0; i < MAXPLAYERS; i++) {
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

                let hhxData = data[i] ? data[i] : HHXLineTraceData(new('HHXLineTraceData'));
                data[i] = hhxData.Update(traceData);
            }
        }
    }
}