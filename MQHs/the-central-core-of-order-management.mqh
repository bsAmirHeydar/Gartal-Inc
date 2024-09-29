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
    double trail_trigger;
    int trail_count;
    double add_vol_trigger;
    int add_vol_count;
    bool status;
public:
    organization_orders(void) {
    }

    void newOrder(int input_key_ticket) {
        if(OrderSelect(OrdersTotal() - 1, SELECT_BY_POS, MODE_TRADES)) {
            ticket = OrderTicket();
            key_ticket = input_key_ticket;
            type = OrderType();
            entry = OrderOpenPrice();
            ArrayResize(sl, 1, 0);
            sl[0] = OrderStopLoss();
            ArrayResize(tp, 1, 0);
            tp[0] = OrderTakeProfit();
            trail_trigger = entry;
            add_vol_trigger = entry;
            status = true;
            trail_count = 0;
            add_vol_count = 0;
        }
    }
    double getTrailTriggerPrice() {
        return trail_trigger;
    }
    void modifyTrailTrigger(double input_trail_trigger) {
        trail_trigger = input_trail_trigger;
    }
    double getAddVolTriggerPrice() {
        return add_vol_trigger;
    }
    void modifyAddVolTrigger(double input_add_vol_trigger) {
        add_vol_trigger = input_add_vol_trigger;
    }
    void newSL() {
        if(OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) {
            ArrayResize(sl, ArraySize(sl) + 1, 0);
            sl[ArraySize(sl) - 1] = OrderStopLoss();
        }
    }
    void newTP() {
        if(OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) {
            ArrayResize(tp, ArraySize(tp) + 1, 0);
            tp[ArraySize(tp) - 1] = OrderTakeProfit();
        }
    }
    // متدی برای دریافت مقدار
    int GetKeyOrder() {
        return key_ticket;
    }
    int GetTicketOrder() {
        return ticket;
    }
    double getSLValue() {
        if(type == OP_BUY) {
            return (entry - sl[0]);// * Point;
        } else if(type == OP_SELL) {
            return (sl[0] - entry);// * Point;
        } else {
            return -1;
        }
    }
    void delObject() {
        status = false;
    }
    bool check_trail_counter(int max_trail_count) {
        if(trail_count < max_trail_count) {
            return true;
        } else {
            return false;
        }
    }
    void plusTrailCounter() {
        trail_count += 1;
    }
    void plusAddVolCounter() {
        add_vol_count += 1;
    }
};
organization_orders order_status_list[];
int check_order_status_list_index(int ticket) {
    for(int i = 0; i < ArraySize(order_status_list); i++) {
        if(order_status_list[i].GetTicketOrder() == ticket) {
            return i;
        }
    }
    return -1;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void new_order_for_organization(int keyTicket) {
    ArrayResize(order_status_list, ArrayRange(order_status_list, 0) + 1, 0);
    order_status_list[ArraySize(order_status_list) - 1].newOrder(keyTicket);
}
//+------------------------------------------------------------------+
