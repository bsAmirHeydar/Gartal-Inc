//+------------------------------------------------------------------+
//|                         the-central-core-of-order-management.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//[0]: group ticket order
//[1]: main and sub ticket order
class organization_orders {
private:
    int key_ticket;
    int ticket;
    int type;
    double entry;
    double sl[];
    double tp[];
public:
    organization_orders(void);
    
    void organization(int input_key_ticket, int input_ticket) {
        ticket = input_ticket;
        key_ticket = input_key_ticket;
        if(OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) {
            type = OrderType();
            entry = OrderOpenPrice();
            ArrayResize(sl, 1, 0);
            sl[0] = OrderStopLoss();
            ArrayResize(tp, 1, 0);
            tp[0] = OrderTakeProfit();
        }
    }

    // متدی برای دریافت مقدار
    int GetKeyOrder() {
        return key_ticket;
    }
    int GetTicketOrder() {
        return ticket;
    }
};
organization_orders order_status_list[];
//+------------------------------------------------------------------+
