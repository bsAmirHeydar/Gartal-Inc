//+------------------------------------------------------------------+
//|                                     detection241024-roulette.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
#include "../public-tools.mqh"
#include "../stop-loss-management.mqh"
#include "../order-management.mqh"
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
enum rouletteModeOption {
    Trend = 0,
    Consolidation = 1,
};
input string detection241024Name = "--- detection241024-roulette ---";
input bool isDetectionRoulette = false;
input rouletteModeOption rouletteMode = 0; //Roulette Mode
input bool isHedge = false; //Close Order before Open
input int detection241024MAperiod = 50; //MA Period
input MA_mode_option detection241024MAmode = 0; //MA Mode
input double detection241024SmallATRfactor = 3.0; //Small ATR Factor
input double detection241024BigATRfactor = 5.0; //Big ATR Factor
bool detection241024_roulette(int typeCondition) {
    if(!isDetectionRoulette) {
        return true;
    }
    double ma = iMA(Symbol(), PERIOD_CURRENT, detection241024MAperiod, 0, ConvertToMAType(detection241024MAmode), PRICE_CLOSE, 1);
    double smallChannelValue = detection241024SmallATRfactor * iATR(Symbol(), PERIOD_CURRENT, 14, 1);
    double bigChannelValue = detection241024BigATRfactor * iATR(Symbol(), PERIOD_CURRENT, 14, 1);
    double upperBig = ma + bigChannelValue;
    double upperSmall = ma + smallChannelValue;
    double lowerBig = ma - bigChannelValue;
    double lowerSmall = ma - smallChannelValue;
    bool buySignal = false;
    bool sellSignal = false;
    if(Close[1] < Open[1] && (Close[1] > upperSmall && Close[1] < upperBig)) {
        if(rouletteMode == 0) {
            buySignal = true;
        } else if(rouletteMode == 1) {
            sellSignal = true;
        }
    } else if(Close[1] > Open[1] && (Close[1] < lowerSmall && Close[1] > lowerBig)) {
        if(rouletteMode == 0) {
            sellSignal = true;
        } else if(rouletteMode == 1) {
            buySignal = true;
        }
    }
    if(rouletteMode == 0) { //Trend
        if(buySignal) {
            rouletteSL = lowerSmall;
        } else if(sellSignal) {
            rouletteSL = upperSmall;
        }
    } else if(rouletteMode == 1) { //Consolidation
        if(buySignal) {
            rouletteSL = Close[1] - (upperSmall - Close[1]);
        } else if(sellSignal) {
            rouletteSL = Close[1] + (Close[1] - lowerSmall);
        }
    }
    if(typeCondition == 1) {
        if(!isHedge) {
           // closeWholeOrder(-1);
        }
        return buySignal;
    } else if(typeCondition == -1) {
        if(!isHedge) {
            //closeWholeOrder(1);
        }
        return sellSignal;
    }
    return false;
}
//+------------------------------------------------------------------+
double rouletteExit(int which, int typeRoulette) { //1:SL, 2:TP
    if(typeRoulette == 0) { //Trend
    } else if(typeRoulette == 1) { //Consolidation
    }
    return 0.0;
}
//+------------------------------------------------------------------+
