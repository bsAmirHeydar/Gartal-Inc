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
input string check_candle_color_check_non = "-----check candle color check-----";
input bool is_check_candle_color_check = false; //ON/OFF
input bool is_check_last_candle_color_check = true; //Last Candle Color
input int check_candle_color_check_count_check = 3; //count check
bool check_last_candle_color_check_buy_signal, check_last_candle_color_check_sell_signal;
bool check_last_candle_color_check(int type_condition) {
    if(!is_check_last_candle_color_check) {
        return true;
    }
    check_last_candle_color_check_buy_signal = false;
    check_last_candle_color_check_sell_signal = false;
    if(type_condition == 1) {
        if(Close[1] > Open[1]) {
            check_last_candle_color_check_buy_signal = true;
        }
    } else if(type_condition) {
        if(Close[1] < Open[1]) {
            check_last_candle_color_check_sell_signal = true;
        }
    }
    if(!is_check_last_candle_color_check) {
        return true;
    } else if(type_condition == 1) {
        return check_last_candle_color_check_buy_signal;
    } else if(type_condition == -1) {
        return check_last_candle_color_check_sell_signal;
    } else {
        return false;
    }
}
bool check_candle_color_check_buy_signal, check_candle_color_check_sell_signal;
bool check_candle_color_check(int type_condition) {
    if(!is_check_candle_color_check) {
        return true;
    }
    check_candle_color_check_buy_signal = false;
    check_candle_color_check_sell_signal = false;
    if(type_condition == 1) {
        for(int i = 2; i < check_candle_color_check_count_check + 2; i++) {
            if(Close[i] < Open[i]) {
                check_candle_color_check_buy_signal = true;
            }
        }
        return (is_check_candle_color_check && check_candle_color_check_buy_signal) || !is_check_candle_color_check;
    } else if(type_condition == -1) {
        for(int i = 2; i < check_candle_color_check_count_check + 2; i++) {
            if(Close[i] > Open[i]) {
                check_candle_color_check_sell_signal = true;
            }
        }
        return (is_check_candle_color_check && check_candle_color_check_sell_signal) || !is_check_candle_color_check;
    } else {
        return false;
    }
}
input string check_candle_color_check_non2 = "-----Vas Candle Pro-----";
input bool is_candle_vas = false; //ON/OFF
//input bool is_check_last_candle_color_check = true; //Last Candle Color
input int coutVasCandle = 3; //count check

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool detection241009detection_candle_vas(int typeCondition) {
    if(!is_candle_vas) {
        return true;
    }
    bool buySignal = true, sellSignal = true;
    for(int i = 2; i <= coutVasCandle + 1; i++) {
        if(!(Close[i] < Open[i])) {
            buySignal = false;
            break;
        }
    }
    for(int i = 2; i <= coutVasCandle + 1; i++) {
        if(!(Close[i] > Open[i])) {
            sellSignal = false;
            break;
        }
    }
    if(typeCondition == 1) {
        return buySignal;
    } else if(typeCondition == -1) {
        return sellSignal;
    } else {
        return false;
    }
}
//+------------------------------------------------------------------+
