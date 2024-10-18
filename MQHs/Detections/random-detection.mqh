//+------------------------------------------------------------------+
//|                                             random-detection.mqh |
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
input bool isRandomDetection = false;
bool randDetection(int typeCondition) {
    if(!isRandomDetection) {
        return true;
    }
    int signal = rand();
    bool buySignal = signal > (32767 / 2);
    bool sellSignal = signal < (32767 / 2);
    if(typeCondition == 1) {
        return buySignal;
    } else if(typeCondition == -1) {
        return sellSignal;
    } else {
        return false;
    }
}
//+------------------------------------------------------------------+
