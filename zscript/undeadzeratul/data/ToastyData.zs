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
