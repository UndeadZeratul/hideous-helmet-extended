class UZHDArmourStats {
    // The "Equipment Slot".  0 = body, 1 = head, 2 = boots
    transient int slot;

    // The worn layer, used to sort by outermost armour
    transient int wornlayer;

    // The foreground image to render
    transient string fg;

    // The background image to render
    transient string bg;

    // The current armour durability
    transient int durability;

    // The armour's maximum durability
    transient int maxDurability;

    // The Durability font color
    transient int fontColor;

    // The offsets of the rendered graphic
    transient Vector2 offsets;

    // The offsets of the armour durability
    transient Vector2 durOffsets;

    // The visual scale of the armour slot
    transient float scale;

    // The alignment flags for the rendered graphic
    transient int flags;

    static UZHDArmourStats Create(int slot, int wornlayer, string fg, string bg, int durability, int maxDurability, int fontColor, Vector2 offsets, Vector2 durOffsets, float scale, int flags) {
        UZHDArmourStats stats = UZHDArmourStats(New("UZHDArmourStats"));

        if (stats) {
            stats.slot = slot;
            stats.wornlayer = wornlayer;
            stats.fg = fg;
            stats.bg = bg;
            stats.durability = durability;
            stats.maxDurability = maxDurability;
            stats.fontColor = fontColor;
            stats.offsets = offsets;
            stats.durOffsets = durOffsets;
            stats.scale = scale;
            stats.flags = flags;
        }

        return stats;
    }
}
