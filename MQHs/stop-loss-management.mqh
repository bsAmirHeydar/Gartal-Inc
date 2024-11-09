//+------------------------------------------------------------------+
//|                                         stop-loss-management.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
#include "public-tools.mqh"
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
double rouletteSL;
enum sl_mode_option {
    sl_mode_candle = 0, //HiLo
    sl_mode_fix_point = 1, //Fix Point
    sl_mode_ATR = 2, //ATR
    sl_mode_roulette = 3, //Roulette Strategy
    sl_mode_bands = 4, //Bands
    sl_mode_donchain_median = 5, //Median Donchain
    sl_mode_donchain = 6, //Donchain
};
input string sl_non0 = "**************************************** Stop Loss ****************************************"; //########## STOP LOSS ##########
input sl_mode_option sl_mode = 0; //SL Mode
input double sl_candle_factor = 1; //Candle Factor
input double slAtrFactor = 1.0; //ATR Factor
input bandsModeOption SLbandsMode = 0; //Bands Mode
input int SLBandsPeriod = 20; //Bands Period
input double SLBandsDeviation = 2.0; //Bands Deviation
input int SLDonchainPeriod = 20; //Donchain Period

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calculateSL(int typeCondition, double slValue, double entry) {
    double value = 0.0;
    if(sl_mode == 0) {
        value = sl_candle_factor * slValue;
    } else if(sl_mode == 2) {
        value = slAtrFactor * iATR(Symbol(), PERIOD_CURRENT, 14, 0);
    } else if(sl_mode == 3) {
        return rouletteSL;
    } else if(sl_mode == 4) {
        if(typeCondition == 1) {
            if(SLbandsMode == 0) {
                return iBands(Symbol(), PERIOD_CURRENT, SLBandsPeriod, SLBandsDeviation, 0, PRICE_CLOSE, 0, 1);
            }
            if(SLbandsMode == 1) {
                return iBands(Symbol(), PERIOD_CURRENT, SLBandsPeriod, SLBandsDeviation, 0, PRICE_CLOSE, MODE_UPPER, 1);
            }
            if(SLbandsMode == 2) {
                return iBands(Symbol(), PERIOD_CURRENT, SLBandsPeriod, SLBandsDeviation, 0, PRICE_CLOSE, MODE_LOWER, 1);
            }
        } else if(typeCondition == -1) {
            if(SLbandsMode == 0) {
                return iBands(Symbol(), PERIOD_CURRENT, SLBandsPeriod, SLBandsDeviation, 0, PRICE_CLOSE, 0, 1);
            }
            if(SLbandsMode == 1) {
                return iBands(Symbol(), PERIOD_CURRENT, SLBandsPeriod, SLBandsDeviation, 0, PRICE_CLOSE, MODE_LOWER, 1);
            }
            if(SLbandsMode == 2) {
                return iBands(Symbol(), PERIOD_CURRENT, SLBandsPeriod, SLBandsDeviation, 0, PRICE_CLOSE, MODE_UPPER, 1);
            }
        }
    } else if(sl_mode == 5) {
        double hst = 0.0, lst = 0.0;
        for(int i = 1; i <= SLDonchainPeriod; i++) {
            if(hst == 0) {
                hst = High[i];
            }
            if(lst == 0) {
                lst = Low[i];
            }
            if(High[i] > hst) {
                hst = High[i];
            }
            if(Low[i] < lst) {
                lst = Low[i];
            }
        }
        return lst + (hst - lst) / 2;
    } else if(sl_mode == 6) {
        double hst = 0.0, lst = 0.0;
        for(int i = 1; i <= SLDonchainPeriod; i++) {
            if(hst == 0) {
                hst = High[i];
            }
            if(lst == 0) {
                lst = Low[i];
            }
            if(High[i] > hst) {
                hst = High[i];
            }
            if(Low[i] < lst) {
                lst = Low[i];
            }
        }
        if(typeCondition == 1) {
            return hst;
        } else if(typeCondition == -1) {
            return lst;
        }
    }
    if(typeCondition == 1) {
        return entry - value;
    } else if(typeCondition == -1) {
        return entry + value;
    }
    return 0;
}
//+------------------------------------------------------------------+
