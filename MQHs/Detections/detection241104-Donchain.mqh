//+------------------------------------------------------------------+
//|                                     detection241104-Donchain.mqh |
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
input string detection241104Name = "**************************************** Detection: Donchain ****************************************"; //########## DONCHAIN ##########
input bool isDon = false; //Donchain?
input run_option donRunGround = 0; //Run Ground
input int donPeriod = 55; //Donchain Period
int lastSideDonchain = 0;
bool detection241104_Donchain(int tc) {
    if(!isDon) {
        return true;
    }
    bool bS = false, sS = false;
    double hst = 0.0, lst = 0.0, mdi = 0.0;
    if(donRunGround == 0) {
        for(int i = 1; i <= donPeriod; i++) {
            if(hst == 0) {
                hst = High[i];
            }
            if(lst == 0) {
                lst = Low[i];
            }
            if(High[i] > hst) {
                hst = High[i];
            }
            if(Low[i] < lst) {
                lst = Low[i];
            }
        }
        mdi = lst + (hst - lst) / 2;
        static datetime  lastTime = 0;
        if(lastTime != Time[0]) {
            PlotIndividualLine(hst, clrBlue, 1);
            PlotIndividualLine(lst, clrRed, 1);
            PlotIndividualLine(mdi, clrGold, 1);
            lastTime = Time[0];
        }
        bS = Bid > hst;// && lastSideDonchain == -1;
        sS = Bid < lst;// && lastSideDonchain == 1;
        if(Bid > hst) {
            lastSideDonchain = 1;
        }
        if(Bid < lst) {
            lastSideDonchain = -1;
        }
    } else if(donRunGround == 1) {
        for(int i = 2; i <= donPeriod + 1; i++) {
            if(hst == 0) {
                hst = High[i];
            }
            if(lst == 0) {
                lst = Low[i];
            }
            if(High[i] > hst) {
                hst = High[i];
            }
            if(Low[i] < lst) {
                lst = Low[i];
            }
        }
        mdi = lst + (hst - lst) / 2;
        PlotIndividualLine(hst, clrBlue, 1);
        PlotIndividualLine(lst, clrRed, 1);
        PlotIndividualLine(mdi, clrGold, 1);
        bS = Close[1] > hst;// && lastSideDonchain == -1;
        sS = Close[1] < lst;// && lastSideDonchain == 1;
        if(Close[1] > hst) {
            lastSideDonchain = 1;
        }
        if(Close[1] < lst) {
            lastSideDonchain = -1;
        }
    }
    //Comment(lastSideDonchain);
    if(tc == 1) {
        return bS;
    } else if(tc == -1) {
        return sS;
    }
    return false;
}
//+------------------------------------------------------------------+
