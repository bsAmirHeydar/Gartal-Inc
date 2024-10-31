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
int Ticket = 1;
class organization_orders {
  private:
    int key_ticket;
    int ticket;
    double entry;

  public:
    int liveTicket;
    bool status;
    //int orderModel;
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

    void newOrder(int input_key_ticket, bool isReal, double vol, double volume_factor, int order_type, double inputEntry, double inputSL, double inputTP) {
        // if(OrderSelect(OrdersTotal() - 1, SELECT_BY_POS, MODE_TRADES)) {
        ticket = Ticket;
        Ticket += 1;
        key_ticket = input_key_ticket;
        if(key_ticket != -1) {
            insertSubTicket(key_ticket, ticket);
        }
        type = order_type;
        entry = inputEntry;
        ArrayResize(sl, 1, 0);
        sl[0] = inputSL;
        ArrayResize(tp, 1, 0);
        tp[0] = inputTP;
        trail_trigger = inputEntry;
        add_vol_trigger = inputEntry;
        //printf(ticket + ":  " + trail_trigger);
        status = true;
        trail_count = 0;
        add_vol_count = 0;
        add_vol_mode_first = false;
        add_vol_mode_final = false;
        is_trail_in_this_candle = false;
        sl_Value = MathAbs(entry - sl[0]);
        //printf("input Entry: " + DoubleToString(inputEntry));
        //printf("SL[0]: " + DoubleToString(sl[0]));
        //printf("SL Value: " + IntegerToString(ticket) + "         " + DoubleToString(sl_Value));
        volume = vol;
        volFactor = volume_factor;
        //orderModel = order_model;
        commission = (volFactor * volume) * commissionPerLot;
    }

    double getTrailTriggerPrice() {
        return trail_trigger;
    }
    void modifyTrailTrigger(double input_trail_trigger) {
        trail_trigger = input_trail_trigger;
        //printf("Ticket " + IntegerToString(ticket) + " : " + "new Trigger : " + DoubleToString(trail_trigger));
    }
    double getAddVolTriggerPrice() {
        return add_vol_trigger;
    }
    void modifyAddVolTrigger(double input_add_vol_trigger) {
        add_vol_trigger = input_add_vol_trigger;
    }
    void newSL(double slNew) {
        if(OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) {
            ArrayResize(sl, ArraySize(sl) + 1, 0);
            sl[ArraySize(sl) - 1] = slNew;
        }
    }
    void newTP() {
        if(OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES)) {
            ArrayResize(tp, ArraySize(tp) + 1, 0);
            tp[ArraySize(tp) - 1] = OrderTakeProfit();
        }
    }
    void setTicket() {
        if(OrderSelect(OrdersTotal() - 1, SELECT_BY_POS, MODE_TRADES)) {
            liveTicket = OrderTicket();
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
    bool isKey(int input_ticket) {
        for(int i = 0; i < ArraySize(order); i++) {
            if(order[i].GetKeyTicket() == input_ticket && order[i].status) {
                return true;
            }
        }
        return false;
    }
    double equityProfit() {
        double pointValue = CalculatePointValue();  // محاسبه Pip Value
        if(type == OP_BUY) {
            return ((Bid - entry) / Point) * pointValue - commission;
        } else if(type == OP_SELL) {
            return ((entry - Ask) / Point) * pointValue - commission;
        }
        return 0;
    }
    void checkCloseGhostOrder() {
        double pointValue = CalculatePointValue();  // محاسبه Pip Value
        if(type == OP_BUY) {
            if(Bid >= tp[ArraySize(tp) - 1]) { //TP for Buy
                //double sl_point = sl_value / Point;
                profit = ((Bid - entry) / Point) * pointValue - commission;
                sum_commission += commission;
                newRec(ticket, type, ghostMode, profit, volumeFactor);
                status = false;
            } else if(Bid <= sl[ArraySize(sl) - 1]) {
                profit = ((Bid - entry) / Point) * pointValue - commission;
                sum_commission += commission;
                newRec(ticket, type, ghostMode, profit, volumeFactor);
                status = false;
            }
        } else if(type == OP_SELL) {
            if(Ask <= tp[ArraySize(tp) - 1]) {
                profit = ((entry - Ask) / Point) * pointValue - commission;
                sum_commission += commission;
                newRec(ticket, type, ghostMode, profit, volumeFactor);
                status = false;
            } else if(Ask >= sl[ArraySize(sl) - 1]) {
                profit = ((entry - Ask) / Point) * pointValue - commission;
                sum_commission += commission;
                newRec(ticket, type, ghostMode, profit, volumeFactor);
                status = false;
            }
        }
    }

    void checkExecuteOrder() {
        if(type != OP_BUY && type != OP_SELL && status) {
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
organization_orders order[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int orderIndex(int ticket) {
    for(int i = 0; i < ArraySize(order); i++) {
        if(order[i].GetTicketOrder() == ticket) {
            return i;
        }
    }
    return -1;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int findIndexFromLiveTicket(int ticket) {
    for(int i = 0; i < ArraySize(order); i++) {
        if(order[i].liveTicket == ticket) {
            return i;
        }
    }
    return -1;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void new_order_for_organization(int keyTicket, bool isReal, double vol, double volume_factor, int order_type, double inputEntry, double inputSL, double inputTP) {
    ArrayResize(order, ArraySize(order) + 1, 0);
    order[ArraySize(order) - 1].newOrder(keyTicket, isReal, vol, volume_factor, order_type, inputEntry, inputSL, inputTP);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void off_all_trail() {
    for(int i = 0; i < ArraySize(order); i++) {
        order[i].is_trail_in_this_candle = false;
    }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int count_keyTicket(int type_condition) {
    int counter = 0;
    for(int i = 0; i < ArraySize(order); i++) {
        if(order[i].GetKeyTicket() == -1 && order[i].status) {
            if((type_condition == 1 && order[i].type == OP_BUY) || (type_condition == -1 && order[i].type == OP_SELL)) {
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
void insertSubTicket(int keyTicket, int subTicket) {
    ArrayResize(order[orderIndex(keyTicket)].result_related_ticket, ArraySize(order[orderIndex(keyTicket)].result_related_ticket)+1);
    order[orderIndex(keyTicket)].result_related_ticket[ArraySize(order[orderIndex(keyTicket)].result_related_ticket) - 1] = subTicket;
}

//+------------------------------------------------------------------+
void c1lean_closed_orders(int ticket) {
    //for(int i = 0; i < ArraySize(order); i++) {
    //if(order[i].status) {
    //if(OrderSelect(order[i].GetTicketOrder(), SELECT_BY_TICKET, MODE_HISTORY)) {
    printf("Clean Close Order " + IntegerToString(ticket) + "Successfully!");
    order[orderIndex(ticket)].status = false;
}
//+------------------------------------------------------------------+
void checkGhostOrders() {
    sumEquityOpenOrders = 0.0;
    for(int i = 0; i < ArraySize(order); i++) {
        if(order[i].status) {
            sumEquityOpenOrders += order[i].equityProfit();
        }
    }
    for(int i = 0; i < ArraySize(order); i++) {
        if(order[i].status) {
            order[i].checkExecuteOrder();
            order[i].checkCloseGhostOrder();
        }
    }
}
//+------------------------------------------------------------------+
double calculateCommission() {
    double commission = 0.0;
    for(int i = 0; i < ArraySize(order); i++) {
        if(!order[i].ghostMode) {
            commission += order[i].commission;
        }
    }
    return commission;
}
//+------------------------------------------------------------------+
