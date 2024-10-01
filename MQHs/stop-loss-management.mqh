//+------------------------------------------------------------------+
//|                                         stop-loss-management.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
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
enum sl_mode_option {
    sl_mode_candle = 0, //Candle
    sl_mode_fix_point = 1, //Fix Point
    sl_mode_ATR = 2, //ATR
};
input string sl_non0 = "-----SL Management-----";
input sl_mode_option sl_mode = 0;
input double sl_candle_factor = 1;
double calculateSL(int typeCondition, double slValue) {
    double value = 0.0;
    if(sl_mode == 0) {
        value = sl_candle_factor * slValue;
    }
    if(typeCondition == 1) {
        return Close[1] - value;
    } else if(typeCondition == -1) {
        return Close[1] + value;
    }
    return 0;
}
//+------------------------------------------------------------------+
