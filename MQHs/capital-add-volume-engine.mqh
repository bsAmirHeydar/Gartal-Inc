//+------------------------------------------------------------------+
//|                                    capital-add-volume-engine.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property strict
#include "entry-management.mqh"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum add_volume_MA_mode_option {
    add_volume_MA_sma_mode  = 0,   // SMA
    add_volume_MA_ema_mode  = 1,   // EMA
    add_volume_MA_smma_mode = 2,   // SMMA
    add_volume_MA_lwma_mode = 3    // LWMA
};
enum add_volume_trigger_concept_option {
    add_volume_trigger_concept_simple = 0, //Simple
    add_volume_trigger_concept_advanve = 1, //Advanve: PullBack
};
enum add_volume_trigger_mode_option {
    add_volume_trigger_none = 0, //No Add Volume
    add_volume_trigger_fix_point = 1, //Fix Point
    add_volume_trigger_fix_tp = 2, //Fix TP
    add_volume_trigger_ATR = 3, //ATR
    add_volume_trigger_MA = 4, //MA
    add_volume_trigger_band = 5, //Bollinger Band
};
enum add_volume_SL_mode_option {
    add_volume_SL_none = 0, //No Add Volume
    add_volume_SL_fix_point = 1, //Fix Point
    add_volume_SL_fix_tp = 2, //Fix TP
    add_volume_SL_ATR = 3, //ATR
    add_volume_SL_MA = 4, //MA
    add_volume_SL_band = 5, //Bollinger Band
};
enum add_volume_add_vol_mode_option {
    add_volume_add_vol_none = 0, //Same Risk
    add_volume_add_vol_from_profit = 1, //From Profit
    add_volume_add_vol_logarithmic = 2, //Logarithmic
    add_volume_add_vol_subtractive = 3, //Subtractive
};
enum add_volume_filter_for_add_option {
    add_volume_filter_for_add_none = 0, //Non Filter
};
input string add_volume_engine_non0 = "-----Add Volume Engine-----";
input int add_volume_max_step = 0; //Max step
input bool add_volume_same_group_order = true; //Same Order Group
input bool add_volume_group_trail = true; //Group Trail
input bool add_volume_group_tp = true; //Group TP
input entry_engine_mode_filter_option add_volume_entry_mode = 0; //Entry Mode
input add_volume_filter_for_add_option add_volume_filter_for_add = 0; //Filter for Add Volume
input add_volume_add_vol_mode_option add_volume_add_vol_mode = 0; //Volume Mode for Add
input string add_volume_trigger_non0 = "-** Add Volume Trigger **-";
input add_volume_trigger_concept_option add_volume_trigger_concept = 0; //Trigger Concept
input add_volume_trigger_mode_option add_volume_trigger_mode = 0; //Trigger Mode
input int add_volume_trigger_fix_point = 20; //fix point trigger
input double add_volume_trigger_fix_tp = 2.0; //fix tp trigger
input double add_volume_trigger_ATR_factor = 2.0; //ATR factor trigger
input ENUM_TIMEFRAMES add_volume_trigger_ATR_timeframe = PERIOD_CURRENT; //ATR timeframe trigger
input int add_volume_trigger_ATR_period = 14; //ATR period trigger
input ENUM_TIMEFRAMES add_volume_trigger_MA_timeframe = PERIOD_CURRENT; //MA time frame trigger
input add_volume_MA_mode_option add_volume_trigger_MA_mode = 0; //MA mode trigger
input int add_volume_trigger_MA_period = 14; //MA period trigger
input string add_volume_SL_non0 = "-** Add Volume SL **-";
input add_volume_SL_mode_option add_volume_SL_mode = 0; //SL Mode
input int add_volume_SL_fix_point = 20; //fix point SL
input double add_volume_SL_fix_tp = 2.0; //fix tp SL
input double add_volume_SL_ATR_factor = 2.0; //ATR factor SL
input ENUM_TIMEFRAMES add_volume_SL_ATR_timeframe = PERIOD_CURRENT; //ATR timeframe SL
input int add_volume_SL_ATR_period = 14; //ATR period SL
input ENUM_TIMEFRAMES add_volume_SL_MA_timeframe = PERIOD_CURRENT; //MA time frame SL
input add_volume_MA_mode_option add_volume_SL_MA_mode = 0; //MA mode SL
input int add_volume_SL_MA_period = 14; //MA period SL

double add_volume_buy_orders[1][5], add_volume_sell_orders[1][5];
//[0]: ticket
//[1]: first entry
//[2]: first SL
//[3]: last trigger
//[4]: last SL
double calculate_new_volume() {
    return 1.0;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void add_volume_clean_group() {
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void capital_add_volume(int type_condition) {
    if(type_condition == 1) {
        if(add_volume_add_vol_mode != 0) {
            if(add_volume_add_vol_mode == 1) {
            } else if(add_volume_add_vol_mode == 2) {
            } else if(add_volume_add_vol_mode == 3) {
            } else if(add_volume_add_vol_mode == 4) {
            } else if(add_volume_add_vol_mode == 5) {
            }
        }
    } else if(type_condition == -1) {
        if(add_volume_add_vol_mode != 0) {
            if(add_volume_add_vol_mode == 1) {
            } else if(add_volume_add_vol_mode == 2) {
            } else if(add_volume_add_vol_mode == 3) {
            } else if(add_volume_add_vol_mode == 4) {
            } else if(add_volume_add_vol_mode == 5) {
            }
        }
    }
    buy_entry_condition = false;
    sell_entry_condition = false;
    buy_volume_factor = calculate_new_volume();
    sell_volume_factor = calculate_new_volume();
    buy_entry_price = Bid;
    sell_entry_price = Bid;
    buy_sl_price = Low[1];
    sell_sl_price = High[1];
    run_engin_entry();
}
//+------------------------------------------------------------------+
