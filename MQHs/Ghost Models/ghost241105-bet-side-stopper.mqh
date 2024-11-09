//+------------------------------------------------------------------+
//|                                 ghost241105-bet-side-stopper.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
#include "../ghost-engine-management.mqh"
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
input bool isBetSideStopper = false; //Bet Side Stopper (1 Profit)
bool betSideStopper(int tc) {
    if(!isBetSideStopper) {
        return true;
    }
    bool bS = true, sS = true;
    if(Type(1) == OP_BUY) {
        sS = true;
        if(Profit(0,1) > 0) {
            bS = false;
        }
    } else if(Type(1) == OP_SELL) {
        bS = true;
        if(Profit(0,1) > 0) {
            sS = false;
        }
    } else {
        return false;
    }
    if(tc == 1) {
        return bS;
    } else if(tc == -1) {
        return sS;
    }
    return false;
}
//+------------------------------------------------------------------+
