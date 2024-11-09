//+------------------------------------------------------------------+
//|                                        detection241109-Bands.mqh |
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
input string detection241109NameBand = "**************************************** Detection: Bands ****************************************"; //########## BANDS ##########
input bool isBands = false; //Bands?
input int DBandsPeriod = 20; //Bands Period
input double DBandsDev = 2.0; //Bands Dev
bool detection241109_Bands(int tc) {
    if(!isBands) {
        return true;
    }
    bool bS = false, sS = false;
    double bMedian = iBands(Symbol(), PERIOD_CURRENT, DBandsPeriod, DBandsDev, 0, PRICE_CLOSE, 0, 1);
    double bUpper = iBands(Symbol(), PERIOD_CURRENT, DBandsPeriod, DBandsDev, 0, PRICE_CLOSE, MODE_UPPER, 1);
    double bLower = iBands(Symbol(), PERIOD_CURRENT, DBandsPeriod, DBandsDev, 0, PRICE_CLOSE, MODE_LOWER, 1);
    double bUpperMedian = bMedian + (bUpper - bMedian) / 2;
    double bLowerMedian = bMedian - (bMedian - bLower) / 2;
    bS = Close[1] < bLowerMedian;
    sS = Close[1] > bUpperMedian;
    if(tc == 1) {
        return bS;
    } else if(tc == -1) {
        return sS;
    }
    return false;
}
//+------------------------------------------------------------------+
