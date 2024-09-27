//+------------------------------------------------------------------+
//|                                              Sample-Template.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//Tools
#include "order-management.mqh"
#include "indicator-management.mqh"
#include "entry-management.mqh"
#include "exit-management.mqh"
#include "major-technical-management.mqh"
#include "time-management.mqh"
//Detections
#include "detection240919-ssl-hybrid-SSL2.mqh"
#include "detection240919-cm-william-fix-vix.mqh"
#include "detection240919-minor-reverse-ind.mqh"
#include "detection240921-MA-cross.mqh"
#include "detection240923-blackFlag-FTS.mqh"
#include "detection240923-MACD-SMA.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
//---
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//---
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void detection_tick() {
//+------------------------------------------------------------------+
//| Detection CODE                                                   |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| END CODE                                                         |
//+------------------------------------------------------------------+
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void detection_candle() {
//+------------------------------------------------------------------+
//| Detection CODE                                                   |
//+------------------------------------------------------------------+
   WilderATR(detection240923_blackFlag_FTS_ATR_period);
   detection240923_blackFlag_FTS(0);
   buy_entry_condition = detection240919_ssl_hybrid_SSL2(1)
                         && detection240919_cm_william_fix_vix(1)
                         && major_technical_management(1)
                         && detection240919_minor_reverse_ind(1)
                         && detection240921_MA_cross(1)
                         && detection240923_blackFlag_FTS(1)
                         && detection240923_MACD_SMA(1)
                         && check_candle_color_check(1)
                         && check_last_candle_color_check(1);
   sell_entry_condition = detection240919_ssl_hybrid_SSL2(-1)
                          && detection240919_cm_william_fix_vix(-1)
                          && major_technical_management(-1)
                          && detection240919_minor_reverse_ind(-1)
                          && detection240921_MA_cross(-1)
                          && detection240923_blackFlag_FTS(-1)
                          && detection240923_MACD_SMA(-1)
                          && check_candle_color_check(-1)
                          && check_last_candle_color_check(-1);
   buy_entry_price = Bid;
   sell_entry_price = Bid;
   buy_sl_price = Low[1];
   sell_sl_price = High[1];
//+------------------------------------------------------------------+
//| END CODE                                                         |
//+------------------------------------------------------------------+
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void detection() {
   trail_engine_check_clean_orders(1);
   trail_engine_check_clean_orders(-1);
   buy_type = 0;
   sell_type = 0;
   buy_entry_price = 0.0;
   sell_entry_price = 0.0;
   buy_sl_price = 0.0;
   sell_sl_price = 0.0;
   buy_tp_price = 0.0;
   sell_tp_price = 0.0;
   buy_exit_condition = false;
   sell_exit_condition = false;
   buy_entry_condition = false;
   sell_entry_condition = false;
   detection_tick();
   static datetime  lastTime = 0;
   if(lastTime == Time[0])
      return;
   lastTime = Time[0];
   detection_candle();
   capital_trail_engine(1);
   capital_trail_engine(-1);
   run_engin_entry();
   run_engine_exit();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick() {
//---
   datetime serverTime = TimeCurrent();
   int currentHour = TimeHour(serverTime);
   int currentMinute = TimeMinute(serverTime);
   if(currentHour == close_hour && currentMinute == close_minute) {
      CloseTrades(1);
      CloseTrades(-1);
   }
   if(
      (currentHour < end_hour || (currentHour == end_hour && currentMinute < end_minute))
      && (currentHour > start_hour || (currentHour == start_hour && currentMinute > start_minute))
   ) {
      detection();
   }
}
//+------------------------------------------------------------------+
