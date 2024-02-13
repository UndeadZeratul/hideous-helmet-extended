// Uses 'hdconst' since we use these in tandem with Matt's values.

// I assume we can derive Miles by keeping time as 1, unlike with 'HDCONST_MPSTOKPH'.
// Constant from https://calculator-converter.com/meters-to-miles.htm . - [FDA]
const HDCONST_METERTOMILE = 0.000621371192;

// 1000 metres = 1 kilometer. 
// It's probably redundant to have metric as constants, but it makes the math
// easier to understand.  - [FDA]
const HDCONST_METERTOKILOMETER = 0.001;