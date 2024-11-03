//+------------------------------------------------------------------+
//|                                           detection241103-MA.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
#include "../public-tools.mqh"
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
input string maCrossName =  "**************************************** Direction Detection: Moving Average Cross ****************************************"; //########## MOVING AVERAGE CROSS ##########
input bool isMaCross = false; //MA Cross?
input MA_mode_option maSmallMode = 2; //Fast MA mode
input bool isHmaSmall = false; //Fast -> HMA?
input ENUM_TIMEFRAMES maSmallTF = PERIOD_CURRENT; //Fast MA Time Frame
input source maSmallSource = 0; //Fast MA Source
input int maSmallPeriod = 40; //Fast MA period
input MA_mode_option maBigMode = 2; //Slow MA mode
input bool isHmaBig = false; //Slow -> HMA?
input ENUM_TIMEFRAMES maBigTF = PERIOD_CURRENT; //Slow MA Time Frame
input source maBigSource = 0; //Slow MA Source
input int maBigPeriod = 100; //Slow MA period
bool detection241103_MA(int tc, int shift) {
    if(!isMaCross) {
        return true;
    }
    bool bS = false, sS = false;
    double maBig = 0.0, maSmall = 0.0;
    if(isHmaBig) {
        maBig = HMA(maBigPeriod, shift + 1, ConvertSource(maBigSource), maBigTF);
    } else
        maBig = iMA(Symbol(), maBigTF, maBigPeriod, 0, ConvertToMAType(maBigMode), ConvertSource(maBigSource), shift + 1);
    if(isHmaSmall) {
        maSmall = HMA(maSmallPeriod, shift + 1, ConvertSource(maSmallSource), maSmallTF);
    } else
        maSmall = iMA(Symbol(), maSmallTF, maSmallPeriod, 0, ConvertToMAType(maSmallMode), ConvertSource(maSmallSource), shift + 1);
    bS = maSmall > maBig;
    sS = maSmall < maBig;
    if(bS) {
        PlotIndividualLine(maSmall, clrGreen, shift + 1, maSmallTF);
        PlotIndividualLine(maBig, clrGreen, shift + 1, maBigTF);
    } else if(sS) {
        PlotIndividualLine(maSmall, clrRed, shift + 1, maSmallTF);
        PlotIndividualLine(maBig, clrRed, shift + 1, maBigTF);
    }
    if(tc == 1) {
        return bS;
    } else if(tc == -1) {
        return sS;
    }
    return false;
}
//+------------------------------------------------------------------+
void forground_MaCross() {
    static datetime  lastTime = 0;
    if(lastTime == iTime(Symbol(), maBigTF, 0))
        return;
    lastTime = iTime(Symbol(), maBigTF, 0);
    if(isMaCross) {
        detection241103_MA(0, 0);
    }
}
//+------------------------------------------------------------------+
