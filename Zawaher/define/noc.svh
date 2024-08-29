`ifndef cache_defs
`define cache_defs

typedef enum logic [2:0]{ 

    IDLE,
    DECODE,
    NOCR1,
    NOCR2,
    NOCR3,
    NOCR4,
    WAIT_READY
    
} nocr_states_e;

`endif 