//+------------------------------------------------------------------+
//|                            detection241009-candle-management.mqh |
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
enum candleReversModeOption {
    ONE_OF_CANDLES = 0, //One of Candles
    VAS = 1, //VAS
};
input string check_candle_color_check_non = "**************************************** Detection: Candlestick ****************************************"; //########## CANDLESTICK ##########

input bool isLastCandle = true; //Last Candle Same Color?
input bool isReverseCandle = false; //Exitstance of Reverse Candles?
input candleReversModeOption candleReversMode = 0; //Reverse Candle Calculator Mode
input int counterReverseCandle = 3; //Counter
//bool check_last_candle_color_check_buy_signal, check_last_candle_color_check_sell_signal;
bool check_last_candle_color_check(int type_condition) {
    if(!isLastCandle) {
        return true;
    }
    bool buySignal = false;
    bool sellSignal = false;
    if(type_condition == 1) {
        if(Close[1] > Open[1]) {
            return true;
        }
    } else if(type_condition) {
        if(Close[1] < Open[1]) {
            return true;
        }
    }
    if(type_condition == 1)
        return buySignal;
    else if(type_condition == -1)
        return sellSignal;
    return false;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool check_candle_color_check(int type_condition) {
    if(!isReverseCandle || !(candleReversMode == 0)) {
        return true;
    }
    bool buySignal = false;
    bool sellSignal = false;
    if(type_condition == 1) {
        for(int i = 2; i < counterReverseCandle + 2; i++) {
            if(Close[i] < Open[i]) {
                return true;
            }
        }
    } else if(type_condition == -1) {
        for(int i = 2; i < counterReverseCandle + 2; i++) {
            if(Close[i] > Open[i]) {
                return true;
            }
        }
    }
    return false;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool detection241009detection_candle_vas(int typeCondition) {
    if(!isReverseCandle || !(candleReversMode == 1)) {
        return true;
    }
    bool buySignal = true, sellSignal = true;
    for(int i = 2; i <= counterReverseCandle + 1; i++) {
        if(!(Close[i] < Open[i])) {
            return false;
        }
    }
    for(int i = 2; i <= counterReverseCandle + 1; i++) {
        if(!(Close[i] > Open[i])) {
            return false;
        }
    }
    if(typeCondition == 1) {
        return buySignal;
    } else if(typeCondition == -1) {
        return sellSignal;
    }
    return false;
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
