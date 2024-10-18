//+------------------------------------------------------------------+
//|                                                   main-ghost.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
#include "../ghost-engine-management.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input string ghostNon0 = "@@@@@@@@@@     GHOST MODELING     @@@@@@@@@@"; //#########   ghost modeling (LEVEL 2)   #########
input bool livePermission = true; //Are all transactions real?


#include "ghost241016-simple-loss.mqh"
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
void ghostEngine() {
    if(livePermission) {
        buyIsReal = true;
        sellIsReal = true;
    } else {
        buyIsReal = ghost241016_simple_loss(1);
        sellIsReal = ghost241016_simple_loss(-1);
    }
}
//+------------------------------------------------------------------+
