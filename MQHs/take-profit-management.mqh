//+------------------------------------------------------------------+
//|                                       take-profit-management.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
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
enum tp_mode_option {
    tp_mode_simple = 0,
    tp_mode_ATR = 1
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input tp_mode_option tp_mode = 0;
input bool tp_calculate_with_spread = false;
input bool tp_calculate_with_commission = false;
double calculateTP(int typeCondition, double slValue) {
    double value = 0.0;
    if(tp_calculate_with_spread) {
        slValue += (Ask - Bid);
    }
    if(tp_mode == 0) {
        value = slValue * tp_factor;
    }
    if(typeCondition == 1) {
        return Bid + value;
    } else if(typeCondition == -1) {
        return (Bid - value) + (Ask - Bid);
    }
    return 0.0;
}
//+------------------------------------------------------------------+
