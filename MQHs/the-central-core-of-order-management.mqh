//+------------------------------------------------------------------+
//|                         the-central-core-of-order-management.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link "https://www.mql5.com"
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//[0]: group ticket order
//[1]: main and sub ticket order
class organization_orders {
  private:
    int key_ticket;
    int ticket;
    double entry;

  public:
    bool status;
    int orderModel;
    int type;
    int result_related_ticket[];
    bool is_trail_in_this_candle;
    int add_vol_count;
    int trail_count;
    bool add_vol_mode_first;
    bool add_vol_mode_final;
    double sl[];
    double tp[];
    double trail_trigger;
    double add_vol_trigger;
    double sl_Value;
    bool ghostMode;
    double commission;
    double profit;
    double volume;
    double volFactor;


    organization_orders(void) {
    }

    void newOrder(int input_key_ticket, bool isReal, double vol, double volume_factor, int order_model) {
        if(OrderSelect(OrdersTotal() - 1, SELECT_BY_POS, MODE_TRADES)) {
            ticket = OrderTicket();
            key_ticket = input_key_ticket;
            type = OrderType();
            entry = OrderOpenPrice();
            ArrayResize(sl, 1, 0);
            sl[0] = OrderStopLoss();
            ArrayResize(tp, 1, 0);
            tp[0] = OrderTakeProfit();
            trail_trigger = OrderOpenPrice();
            add_vol_trigger = OrderOpenPrice();
            //printf(ticket + ":  " + trail_trigger);
            status = true;
            trail_count = 0;
            add_vol_count = 0;
            add_vol_mode_first = false;
            add_vol_mode_final = false;
            is_trail_in_this_candle = false;
            sl_Value = MathAbs(entry - sl[0]);
            volume = vol;
            volFactor = volume_factor;
            orderModel = order_model;
            commission = (volFactor * volume) * commissionPerLot;
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
    int GetKeyTicket() {
        return key_ticket;
    }
    int GetTicketOrder() {
        return ticket;
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
    void sub_ticket_list(int input_key_ticket) {
        for(int i = 0; i < ArraySize(order_status_list); i++) {
            if(order_status_list[i].GetKeyTicket() == input_key_ticket && order_status_list[i].status) {
                ArrayResize(result_related_ticket, ArraySize(result_related_ticket) + 1, 0);
                result_related_ticket[ArraySize(result_related_ticket) - 1] = order_status_list[i].GetTicketOrder();
            }
        }
    }
    bool isKey(int input_ticket) {
        for(int i = 0; i < ArraySize(order_status_list); i++) {
            if(order_status_list[i].GetKeyTicket() == input_ticket && order_status_list[i].status) {
                return true;
            }
        }
        return false;
    }
    void checkGhostOrder() {
        double pointValue = CalculatePointValue();  // محاسبه Pip Value
        if(type == OP_BUY) {
            if(Bid >= tp[ArraySize(tp) - 1]) { //TP for Buy
                //double sl_point = sl_value / Point;
                profit = ((Bid - entry) / Point) * pointValue - commission;
                status = false;
            } else if(Bid <= sl[ArraySize(sl) - 1]) {
                profit = ((Bid - entry) / Point) * pointValue - commission;
                status = false;
            }
        } else if(type == OP_SELL) {
            if(Ask <= tp[ArraySize(tp) - 1]) {
                profit = ((entry - Ask) / Point) * pointValue - commission;
                status = false;
            } else if(Ask >= sl[ArraySize(sl) - 1]) {
                profit = ((entry - Ask) / Point) * pointValue - commission;
                status = false;
            }
        }
    }
    void checkExecuteOrder() {
        if(type != OP_BUY && type != OP_SELL) {
            if(type == OP_BUYLIMIT) {
                if(Ask <= entry) {
                    entry = Ask;
                    type = OP_BUY;
                }
            }
            if(type == OP_BUYSTOP) {
                if(Ask >= entry) {
                    entry = Ask;
                    type = OP_BUY;
                }
            }
            if(type == OP_SELLLIMIT) {
                if(Bid >= entry) {
                    entry = Bid;
                    type = OP_SELL;
                }
            }
            if(type == OP_SELLSTOP) {
                if(Bid <= entry) {
                    entry = Bid;
                    type = OP_SELL;
                }
            }
        }
    }
};
organization_orders order_status_list[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
void new_order_for_organization(int keyTicket, bool isReal, double vol, double volume_factor, int order_model) {
    ArrayResize(order_status_list, ArraySize(order_status_list) + 1, 0);
    order_status_list[ArraySize(order_status_list) - 1].newOrder(keyTicket, isReal, vol, volume_factor, order_model);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void off_all_trail() {
    for(int i = 0; i < ArraySize(order_status_list); i++) {
        order_status_list[i].is_trail_in_this_candle = false;
    }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int count_keyTicket(int type_condition) {
    int counter = 0;
    for(int i = 0; i < ArraySize(order_status_list); i++) {
        if(order_status_list[i].GetKeyTicket() == -1 && order_status_list[i].status) {
            if((type_condition == 1 && order_status_list[i].type == OP_BUY) || (type_condition == -1 && order_status_list[i].type == OP_SELL)) {
                counter += 1;
            }
        }
    }
    //printf("KeyTicket Count: " + IntegerToString(counter));
    return counter;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void clean_closed_orders(int ticket) {
    //for(int i = 0; i < ArraySize(order_status_list); i++) {
    //if(order_status_list[i].status) {
    //if(OrderSelect(order_status_list[i].GetTicketOrder(), SELECT_BY_TICKET, MODE_HISTORY)) {
    printf("Clean Close Order " + IntegerToString(ticket) + "Successfully!");
    order_status_list[check_order_status_list_index(ticket)].status = false;
}
//+------------------------------------------------------------------+
