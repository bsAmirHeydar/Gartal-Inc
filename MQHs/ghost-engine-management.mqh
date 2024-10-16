//+------------------------------------------------------------------+
//|                                      ghost-engine-management.mqh |
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
double sumEquityOpenOrders;
bool buyIsReal = true, sellIsReal = true;
double sumProfit;
double initialBalance = AccountBalance();

class resultLevel2 {
  public:
    int ticket;
    bool ghostMode;
    double profit;
    double balance;
    double equity;
    double factor;
    resultLevel2(void) {
    }
    void record(int input_ticket, bool input_ghostMode, double input_profit, double input_factor) {
        ticket = input_ticket;
        ghostMode = input_ghostMode;
        profit = input_profit;
        factor = input_factor;
        equity = initialBalance + sumProfit + sumEquityOpenOrders;
        sumProfit += profit;
        balance = initialBalance + sumProfit;
    }
    ~resultLevel2(void) {}
};
//+------------------------------------------------------------------+
resultLevel2 records[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void newRec(int input_ticket, bool input_ghostMode, double input_profit, double input_factor) {
    ArrayResize(records, ArraySize(records) + 1);
    records[ArraySize(records) - 1].record(input_ticket, input_ghostMode, input_profit, input_factor);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Factor(int i) {
    return records[ArraySize(records) - i].factor;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Balance(int i) {
    return records[ArraySize(records) - i].balance;
}
//+------------------------------------------------------------------+
double Profit(int i) {
    return records[ArraySize(records) - i].profit;
}
//+------------------------------------------------------------------+
double Equity(int i) {
    return records[ArraySize(records) - i].equity;
}
//+------------------------------------------------------------------+
