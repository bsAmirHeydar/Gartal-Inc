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
enum assetCalculate {
    assetByEquity = 0, //Equity
    assetByBalance = 1, //Balance
};
input string iniNone = "----- INITIALIZE -----";
input assetCalculate assetModeDayTP = 0;
input float assetDayTP = 500.0; //Asset $ TP Day
input assetCalculate assetModeDaySL = 0;
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
    if(currentDay == lastDay) {
        if((((assetModeDayTP == 0 && AccountEquity() >= iniBalance + assetDayTP) || (assetModeDayTP == 1 &&  AccountBalance() >= iniBalance + assetDayTP))
                || ((assetModeDaySL == 0 && AccountEquity() <= iniBalance - assetDaySL) || (assetModeDaySL == 1 && AccountBalance() <= iniBalance - assetDaySL)))
                && mManagePermission) {
            CloseTrades(1);
            CloseTrades(-1);
            mManagePermission = false;
        }
    } else {
        lastDay = currentDay;
        mManagePermission = true;
        iniBalance = AccountBalance();
    }
    Comment(mManagePermission);
}
//+------------------------------------------------------------------+
