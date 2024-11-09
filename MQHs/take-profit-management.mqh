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
    tp_mode_ATR = 1, //ATR
    tp_mode_Bands = 2, //Bands
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input string tpName0 = "**************************************** Take Profit ****************************************"; //########## TAKE PROFIT ##########
input tp_mode_option tp_mode = 0; //TP Mode
input bool tp_calculate_with_spread = true; //With Spread?
input bool tp_calculate_with_commission = true; //With Commission?
input double tpAtrFactor = 1.0; //TP ATR Factor
input bandsModeOption tpBandsMode = 0; //TP Bands Mode
input int tpBandsPeriod = 20; //TP Bands Period
input double tpBandsDev = 2.0; //TP Bands Dev
double calculateTP(int typeCondition, double slValue, double entry) {
    double value = 0.0;
    double spread = Ask - Bid;
    if(tp_mode == 0) {
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
    } else if(tp_mode == 1) {
        value = tpAtrFactor * iATR(Symbol(), PERIOD_CURRENT, 14, 1);
    } else if(tp_mode == 2) {
        if(typeCondition == 1) {
            if(tpBandsMode == 0) {
                return iBands(Symbol(), PERIOD_CURRENT, tpBandsPeriod, tpBandsDev, 0, PRICE_CLOSE, 0, 1);
            }
            if(tpBandsMode == 1) {
                return iBands(Symbol(), PERIOD_CURRENT, tpBandsPeriod, tpBandsDev, 0, PRICE_CLOSE, MODE_UPPER, 1);
            }
            if(tpBandsMode == 2) {
                return iBands(Symbol(), PERIOD_CURRENT, tpBandsPeriod, tpBandsDev, 0, PRICE_CLOSE, MODE_LOWER, 1);
            }
        } else if(typeCondition == -1) {
            if(tpBandsMode == 0) {
                return iBands(Symbol(), PERIOD_CURRENT, tpBandsPeriod, tpBandsDev, 0, PRICE_CLOSE, 0, 1);
            }
            if(tpBandsMode == 1) {
                return iBands(Symbol(), PERIOD_CURRENT, tpBandsPeriod, tpBandsDev, 0, PRICE_CLOSE, MODE_LOWER, 1);
            }
            if(tpBandsMode == 2) {
                return iBands(Symbol(), PERIOD_CURRENT, tpBandsPeriod, tpBandsDev, 0, PRICE_CLOSE, MODE_UPPER, 1);
            }
        }
    }
    if(typeCondition == 1) {
        return entry + spread + value;
    } else if(typeCondition == -1) {
        return (entry - value);
    }
    return 0.0;
}
//+------------------------------------------------------------------+
