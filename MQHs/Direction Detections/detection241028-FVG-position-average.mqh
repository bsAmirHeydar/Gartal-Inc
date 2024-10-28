//+------------------------------------------------------------------+
//|                         detection241028-FVG-position-average.mqh |
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
input string fvgPositionName = "Direction --- ** FVG Position Average ** ---";
input bool isFvgPositionAverage = false; // ?
class fvgPosition {
  public:
    double price;
    ~fvgPosition(void) {}
};
fvgPosition fvgUpRecords[];
fvgPosition fvgDownRecords[];
void checkNewFVG(int shift) {
    double multiple = 0.25;
    double atr = iATR(Symbol(), PERIOD_CURRENT, 200, shift + 1) * multiple;
    if(Low[shift + 1] > High[shift + 3] && Close[shift + 2] > High[shift + 3] && Low[shift + 1] - High[shift + 3] > atr) {
        int lastArrayUp = ArraySize(fvgUpRecords);
        ArrayResize(fvgUpRecords, lastArrayUp + 1);
        fvgUpRecords[lastArrayUp].price = High[shift + 3];
    }
    if(High[shift + 1] < Low[shift + 3] && Close[shift + 2] < Low[shift + 3] && Low[shift + 3] - High[shift + 1] > atr) {
        int lastArrayDown = ArraySize(fvgDownRecords);
        ArrayResize(fvgDownRecords, lastArrayDown + 1);
        fvgDownRecords[lastArrayDown].price = Low[shift + 3];
    }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double averageFvgUp = 0.0;
double averageFvgDown = 0.0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool detection241028_FVG_position_average(int typeCondition, int shift) {
    if(!isFvgPositionAverage) {
        return true;
    }
    int fvgCount = 30;
    bool buySignal = false, sellSignal = false;
    if(typeCondition == 0) {
        checkNewFVG(shift);
        if(ArraySize(fvgUpRecords) >= fvgCount) {
            int lastArrayUp = ArraySize(fvgUpRecords) - 1;
            double sumFVG = 0.0;
            for(int i = lastArrayUp; i > lastArrayUp - fvgCount; i--) {
                if(i >= 0) {
                    sumFVG += fvgUpRecords[i].price;
                }
            }
            averageFvgUp = sumFVG / fvgCount;
        }
        if(ArraySize(fvgDownRecords) >= fvgCount) {
            int lastArrayDown = ArraySize(fvgDownRecords) - 1;
            double sumFVG = 0.0;
            for(int i = lastArrayDown; i > lastArrayDown - fvgCount; i--) {
                if(i >= 0) {
                    sumFVG += fvgDownRecords[i].price;
                }
            }
            averageFvgDown = sumFVG / fvgCount;
        }
        double hst = High[iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, 5, shift + 1)];
        double lst = Low[iLowest(Symbol(), PERIOD_CURRENT, MODE_LOW, 5, shift + 1)];
        Comment(ArraySize(fvgDownRecords)  + "\n" + averageFvgDown + "\n" + lst);
        //dotDraw(averageFvgUp, 1);
        buySignal = hst >= averageFvgUp && averageFvgUp != 0.0;
        if(buySignal) {
            PlotIndividualLine(averageFvgUp, clrGreen, shift + 1);
            FillArea(Low[shift + 1], averageFvgUp, clrNavy, shift + 1, "fvg Up");
        }
        sellSignal = lst <= averageFvgDown && averageFvgDown != 0.0;
        if(sellSignal) {
            PlotIndividualLine(averageFvgDown, clrRed, shift + 1);
            FillArea(High[shift + 1], averageFvgDown, clrBrown, shift + 1, "fvg Down");
        }
    }
    return false;
}
//+------------------------------------------------------------------+
