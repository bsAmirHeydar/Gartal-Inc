//+------------------------------------------------------------------+
//|                              factor241016-martingle and anti.mqh |
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
enum capital_management_mode_filter_option {
    capital_management_none = 0, //Normal
    capital_management_add_volume = 1, //Add volume
    capital_management_reduce_volume = 2, //Reduce volume
};

//input string non_entry0 = "-----Capital Management-----";
//input capital_management_mode_filter_option capital_man5agement_mode = 0;
input string martingleTitr = "----- Martingle & Anti Management -----";
input double martingleFactor = 1.0; //Logarithmic Martingle Factor
input int martingleInProfit = 1; //+ Volume Factor (Win)
input int martingleInLoss = 1; //- Volume Factor (Loss)
input int maxInProfitStep = 20; //Max Step in (Win)
input int maxInLossStep = 20; //Max Step in (Loss)
input bool martingleResetCounter = false; //Reset Volume Factor in (Win)
int martingleCounter;
double martingleRun() {
    return MathPow(martingleFactor, (-martingleCounter));
}
//+------------------------------------------------------------------+
