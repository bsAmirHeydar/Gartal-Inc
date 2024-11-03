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
    tp_mode_simple = 0, //Candle
    tp_mode_ATR = 1 //ATR
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input string tpName0 = "**************************************** Take Profit ****************************************"; //########## TAKE PROFIT ##########
input tp_mode_option tp_mode = 0; //TP Mode
input bool tp_calculate_with_spread = true; //With Spread?
input bool tp_calculate_with_commission = true; //With Commission?
double calculateTP(int typeCondition, double slValue, double entry) {
    double value = 0.0;
    double spread = Ask - Bid;
    if(tp_calculate_with_spread) {
        slValue += 1 * spread;
    }
    if(tp_mode == 0) {
        value = slValue * tp_factor;
        //if(typeCondition == -1) {
        //value -= spread;
        //}
    }
    if(tp_calculate_with_spread)
        slValue -= 1 * spread;
    double commission = 0.0;
    double tpDollar = risk * tp_factor;
    if(tp_calculate_with_commission) {
        double vol = volume(slValue + spread, typeCondition);
        commission = vol * commissionPerLot;
        //printf("$" + CalculatePointValue());
        double tpPoint = (tpDollar / (CalculatePointValue() * vol)) * Point;
        double commissionPoint = (commission / (CalculatePointValue() * vol)) * Point;
        //printf("probebly +Commission: " + DoubleToString((commission / CalculatePointValue())) + "$" );
        value = tpPoint + commissionPoint;
    }
    if(typeCondition == 1) {
        return entry + spread + value;
    } else if(typeCondition == -1) {
        return (entry - value);
    }
    return 0.0;
}
//+------------------------------------------------------------------+
