//+------------------------------------------------------------------+
//|                                    capital-add-volume-engine.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
#property strict
#include "order-management.mqh"
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
enum add_volume_trigger_concept_option{
    add_volume_trigger_concept_simple = 0, //Simple
    add_volume_trigger_concept_advanve = 1, //Advanve: PullBack
};
enum add_volume_trigger_mode_option{
    add_volume_trigger_none = 0, //No Add Volume
    add_volume_trigger_fix_point = 1, //Fix Point
    add_volume_trigger_fix_tp = 2, //Fix TP
    add_volume_trigger_ATR = 3, //ATR
    add_volume_trigger_MA = 4, //MA
    add_volume_trigger_band = 5, //Bollinger Band
};
enum add_volume_SL_mode_option{
    add_volume_SL_none = 0, //No Add Volume
    add_volume_SL_fix_point = 1, //Fix Point
    add_volume_SL_fix_tp = 2, //Fix TP
    add_volume_SL_ATR = 3, //ATR
    add_volume_SL_MA = 4, //MA
    add_volume_SL_band = 5, //Bollinger Band
};

input string add_volume_engine_non0 = "-----Add Volume Engine-----";
input int add_volume_max_step = 0; //Max step
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


void capital_add_volume()
{
    
}