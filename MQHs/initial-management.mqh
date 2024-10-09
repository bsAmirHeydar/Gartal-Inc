//+------------------------------------------------------------------+
//|                                           initial-management.mqh |
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
input string iniNone = "----- INITIALIZE -----";
input float assetDayTP = 500.0; //Asset $ TP Day
input float assetDaySL = 150.0; //Asset $ SL Day

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool mManagePermission;
int lastDay = -1;
double iniBalance;
void Initialize() {
    datetime serverTime = TimeCurrent();
    int currentDay = TimeDay(serverTime);
    if(currentDay != lastDay) {
        if(AccountEquity() + assetDayTP >= iniBalance && mManagePermission) {
            CloseTrades(1);
            CloseTrades(-1);
            mManagePermission = false;
        }
    } else {
        lastDay = currentDay;
        mManagePermission = true;
        iniBalance = AccountBalance();
    }
}
//+------------------------------------------------------------------+
