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
//+------------------------------------------------------------------+\
enum FVGpositionModeOption {
    normalWithoutRange__fvg = 0,
    justRange__fvg = 1,
    all__fvg = 2,
};
input string fvgPositionName = "Direction --- ** FVG Position Average ** ---";
input bool isFvgPositionAverage = false; // ?
input FVGpositionModeOption FVGpositionMode = 1; //FVG Mode
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
bool FVGbuySignal = false, FVGsellSignal = false;
bool detection241028_FVG_position_average(int typeCondition, int shift) {
    if(!isFvgPositionAverage) {
        return true;
    }
    int fvgCount = 30;
    if(typeCondition == 0) {
        FVGbuySignal = false;
        FVGsellSignal = false;
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
        //Comment(ArraySize(fvgDownRecords)  + "\n" + averageFvgDown + "\n" + lst);
        //dotDraw(averageFvgUp, 1);
        FVGbuySignal = hst >= averageFvgUp && averageFvgUp != 0.0;
        if(FVGbuySignal) {
            PlotIndividualLine(averageFvgUp, clrGreen, shift + 1);
            FillArea(Low[shift + 1], averageFvgUp, C'21,174,185', shift + 1, "fvg Up");
        }
        FVGsellSignal = lst <= averageFvgDown && averageFvgDown != 0.0;
        if(FVGsellSignal) {
            PlotIndividualLine(averageFvgDown, clrRed, shift + 1);
            FillArea(High[shift + 1], averageFvgDown, clrBrown, shift + 1, "fvg Down");
        }
    } else {
        if(FVGpositionMode == 0) {
            if(FVGbuySignal && FVGsellSignal) {
                return false;
            }
            if(typeCondition == 1) {
                return FVGbuySignal;
            } else if(typeCondition == -1) {
                return FVGsellSignal;
            }
        } else if(FVGpositionMode == 1) {
            if(FVGbuySignal && FVGsellSignal) {
                return true;
            }
        } else if(FVGpositionMode == 2) {
            if(FVGbuySignal && FVGsellSignal) {
                return true;
            }
            if(typeCondition == 1) {
                return FVGbuySignal;
            } else if(typeCondition == -1) {
                return FVGsellSignal;
            }
        }
    }
    return false;
}
//+------------------------------------------------------------------+
