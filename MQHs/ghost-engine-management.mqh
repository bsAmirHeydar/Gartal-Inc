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
double volumeFactor = 1.0;

class resultLevel2 {
  public:
    int ticket;
    int type;
    bool ghostMode;
    double profit;
    double balance;
    double equity;
    double factor;
    resultLevel2(void) {
    }
    void record(int input_ticket, int inputType, bool input_ghostMode, double input_profit, double input_factor) {
        ticket = input_ticket;
        type = inputType;
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
void newRec(int input_ticket, int input_type, bool input_ghostMode, double input_profit, double input_factor) {
    ArrayResize(records, ArraySize(records) + 1);
    records[ArraySize(records) - 1].record(input_ticket, input_type, input_ghostMode, input_profit, input_factor);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Factor(int orderType, int i) {
    if(ArraySize(records) >= i) {
        if(orderType == 0) {
            return records[ArraySize(records) - i].factor;
        } else if(orderType == 1) {
            if(lastRec(1, i) != -1) {
                return records[lastRec(1, i)].factor;
            } else {
                return 0.0;
            }
        } else if(orderType == -1) {
            if(lastRec(-1, i) != -1) {
                return records[lastRec(-1, i)].factor;
            } else {
                return 0.0;
            }
        } else {
            return 0.0;
        }
    } else {
        return 0.0;
    }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Type(int i) {
    if(ArraySize(records) >= i) {
        return records[ArraySize(records) - i].type;
    } else {
        return -1001;
    }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Balance(int orderType, int i) {
    if(ArraySize(records) >= i) {
        if(orderType == 0) {
            return records[ArraySize(records) - i].balance;
        } else if(orderType == 1) {
            if(lastRec(1, i) != -1) {
                return records[lastRec(1, i)].balance;
            } else {
                return 0.0;
            }
        } else if(orderType == -1) {
            if(lastRec(-1, i) != -1) {
                return records[lastRec(-1, i)].balance;
            } else {
                return 0.0;
            }
        } else {
            return 0.0;
        }
    } else {
        return 0.0;
    }
}
//+------------------------------------------------------------------+
double Profit(int orderType, int i) {
    if(ArraySize(records) >= i) {
        if(orderType == 0) {
            return records[ArraySize(records) - i].profit;
        } else if(orderType == 1) {
            if(lastRec(1, i) != -1) {
                return records[lastRec(1, i)].profit;
            } else {
                return 0.0;
            }
        } else if(orderType == -1) {
            if(lastRec(-1, i) != -1) {
                return records[lastRec(-1, i)].profit;
            } else {
                return 0.0;
            }
        } else {
            return 0.0;
        }
    } else {
        return 0.0;
    }
}
//+------------------------------------------------------------------+
double Equity(int orderType, int i) {
    if(ArraySize(records) >= i) {
        if(orderType == 0) {
            return records[ArraySize(records) - i].equity;
        } else if(orderType == 1) {
            if(lastRec(1, i) != -1) {
                return records[lastRec(1, i)].equity;
            } else {
                return 0.0;
            }
        } else if(orderType == -1) {
            if(lastRec(-1, i) != -1) {
                return records[lastRec(-1, i)].equity;
            } else {
                return 0.0;
            }
        } else {
            return 0.0;
        }
    } else {
        return 0.0;
    }
}
//+------------------------------------------------------------------+
int lastRec(int orderType, int shift) {
    int k = 0;
    for(int i = ArraySize(records) - 1; i >= 0; i--) {
        if((orderType == 1 && records[i].type == OP_BUY) || (orderType == -1 && records[i].type == OP_SELL)) {
            k++;
            if(k == shift) {
                return i;
            }
        }
    }
    return -1;
}
//+------------------------------------------------------------------+
