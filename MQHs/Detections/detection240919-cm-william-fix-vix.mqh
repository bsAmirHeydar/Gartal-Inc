//+------------------------------------------------------------------+
//|                           detection240919-cm-william-fix-vix.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
#include "../indicator-management.mqh"

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
input string non2 = "-----detection240919-cm-william-fix-vix-----";
input bool is_alert3 = false; //Alert 3 SAFE
input bool is_alert4 = false; //Alert 4 Aggressive
int str = 3; //Entry Price Action Strength--Close > X Bars Back
int ltLB = 40; //Long-Term Look Back Current Bar Has To Close Below This Value OR Medium Term
int mtLB = 14; //Medium-Term Look Back Current Bar Has To Close Below This Value OR Long Term
int pd = 22; //LookBack Period Standard Deviation High
int lb = 50; //Look Back Period Percentile High
int bbl = 20; //Bollinger Band Length
double mult = 2.0; //Bollinger Band Standard Deviation Up
double ph = 0.85; //Highest Percentile



bool upRange_Aggr,filtered_up,filtered_down, filtered_Aggr_up, downRange_Aggr, filtered_Aggr_down, orange_buy, orange_sell, upRange, downRange;
double wvf_up, wvf_low, range_high, range_low, upper_band, lower_band, sDev_buy, sDev_sell;
bool alert1_buy, alert1_sell, alert2_buy, alert2_sell, alert3_buy, alert3_sell, alert4_buy, alert4_sell;
bool detection240919_cm_william_fix_vix_buy_signal, detection240919_cm_william_fix_vix_sell_signal;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool detection240919_cm_william_fix_vix(int type)
  {
   if(!is_alert3 && !is_alert4)
     {
      return true;
     }
   wvf_up = wvf(1,pd, 1);
   wvf_low = wvf(-1,pd, 1);
//lowerBand = midLine - sDev
// upperBand = midLine + sDev
   upper_band = band(1,mult, bbl, pd,1, 1);
   lower_band = band(-1,mult, bbl, pd, 1, -1);
//upRange = low > low[1] and close > high[1]
//Filtered Bar Criteria
//upRange = low > low[1] and close > high[1]
   upRange = Low[1] > Low[2] && Close[1] > High[2];
//upRange_Aggr = close > close[1] and close > open[1]
   upRange_Aggr = Close[1] > Close[2] && Close[1] > Open[2];
//downRange = high < high[1] and close < low[1]
   downRange = High[1] < High[2] && Close[1] < Low[2];
//downRange_Aggr = close < close[1] and close < open[1]
   downRange_Aggr = Close[1] < Close[2] && Close[1] < Open[2];
//rangeHigh = (highest(wvstdf, lb)) * ph
   range_high = highest_wvf(1, lb,pd, 1) * ph;
//rangeLow = (lowest(wvf_, lb)) * ph
   range_low = lowest_wvf(-1, lb,pd, 1) * ph;
// filtered_Aggr = (wvf[1] >= upperBand[1] or wvf[1] >= rangeHigh[1]) and not (wvf < upperBand and wvf < rangeHigh)
   filtered_Aggr_up = (wvf(1,pd, 2) >=   band(1,mult, bbl, pd, 2, 1) ||
                       wvf(1,pd, 2) >= highest_wvf(1, lb, pd, 2) * ph) && !(wvf(1,pd, 1) < upper_band && wvf(1,pd, 1) < range_high);
   filtered_Aggr_down = (wvf(-1,pd, 2) <= band(-1,mult, bbl, pd, 2, -1) ||
                         wvf(-1,pd, 2) <= lowest_wvf(-1, lb, pd, 2) * ph) && !(wvf(-1,pd, 1) > lower_band && wvf(-1,pd, 1) > range_low);
//filtered = ((wvf[1] >= upperBand[1] or wvf[1] >= rangeHigh[1]) and (wvf < upperBand and wvf < rangeHigh))
   filtered_up = (wvf(1,pd, 2) >=   band(1,mult, bbl,pd, 2, 1) ||
                  wvf(1,pd, 2) >= highest_wvf(1, lb, pd, 2) * ph) && (wvf(1,pd, 1) < upper_band && wvf(1,pd, 1) < range_high);
//filtered_Aggr_ = (wvf_[1] <= lowerBand_[1] or wvf_[1] <= rangeLow[1]) and not (wvf_ > lowerBand_ and wvf_ > rangeLow)
   filtered_down = (wvf(-1,pd, 2) <= band(-1,mult, bbl,pd, 2, -1) ||
                    wvf(-1,pd, 2) <= lowest_wvf(-1, lb, pd, 2) * ph) && (wvf(-1,pd, 1) > lower_band && wvf(-1,pd, 1) > range_low);
// alert1 = wvf >= upperBand or wvf >= rangeHigh ? 1 : 0
   alert1_buy = wvf(1,pd, 1) >= upper_band || wvf(1,pd,1) >= range_high;
   alert1_sell = wvf(-1,pd, 1) <= lower_band || wvf(-1,pd, 1) <= range_low;
// alert2 = (wvf[1] >= upperBand[1] or wvf[1] >= rangeHigh[1]) and (wvf < upperBand and wvf < rangeHigh) ? 1 : 0
   alert2_buy = (wvf(1,pd, 2) >= band(1,mult, bbl, pd, 2, 1) || wvf(1,pd, 2) >= highest_wvf(1, lb, pd, 2) * ph) && (wvf(1,pd, 1) < upper_band && wvf(1,pd, 1) < range_high);
   alert2_sell = (wvf(-1,pd, 2) <= band(-1,mult, bbl, pd,2,-1) || wvf(-1,pd, 2) <= lowest_wvf(-1, lb, pd,2) * ph) && (wvf(-1,pd, 1) > lower_band && wvf(-1,pd, 1) > range_low);
// alert3 = upRange and close > close[str] and (close < close[ltLB] or close < close[mtLB]) and filtered ? 1 : 0
   alert3_buy = upRange && Close[1] > Close[str + 1] && (Close[1] < Close[ltLB + 1] || Close[1] < Close[mtLB + 1]) && filtered_up;
//alert3_ = downRange and close < close[str] and (close > close[ltLB] or close > close[mtLB]) and filtered_ ? 1 : 0
   alert3_sell = downRange && Close[1] < Close[str + 1] && (Close[1] > Close[ltLB + 1] || Close[1] > Close[mtLB + 1]) && filtered_down;
// alert4 = upRange_Aggr and close > close[str] and (close < close[ltLB] or close < close[mtLB]) and filtered_Aggr ? 1 : 0
   alert4_buy = upRange_Aggr && Close[1] > Close[str + 1] && (Close[1] < Close[ltLB + 1] || Close[1] < Close[mtLB + 1]) && filtered_Aggr_up;
//alert4_ = downRange_Aggr and close < close[str] and (close > close[ltLB] or close > close[mtLB]) and filtered_Aggr_ ? 1 : 0
   alert4_sell = downRange_Aggr && Close[1] < Close[str + 1] && (Close[1] > Close[ltLB + 1] || Close[1] > Close[mtLB + 1]) && filtered_Aggr_down ;
   detection240919_cm_william_fix_vix_buy_signal = ((is_alert3 && is_alert4) && (alert3_buy || alert4_buy)) || (is_alert3 && !is_alert4 && alert3_buy) || (is_alert4 && !is_alert3 && alert4_buy) || (!is_alert3 && !is_alert4);
   detection240919_cm_william_fix_vix_sell_signal = ((is_alert3 && is_alert4) && (alert3_sell || alert4_sell)) || (is_alert3 && !is_alert4 && alert3_sell) || (is_alert4 && !is_alert3 && alert4_sell) || (!is_alert3 && !is_alert4);
   if(type == 1)
     {
      if(detection240919_cm_william_fix_vix_buy_signal)
        {
         //dotDraw(High[1], 1);
         return true;
        }
      else
         return false;
     }
   else
      if(type == -1)
        {
         if(detection240919_cm_william_fix_vix_sell_signal)
           {
            //dotDraw(Low[1], 1);
            return true;
           }
         else
            return false;
        }
      else
         return false;
  }
//+------------------------------------------------------------------+
