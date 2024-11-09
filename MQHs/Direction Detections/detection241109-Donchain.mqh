//+------------------------------------------------------------------+
//|                                     detection241109-DonDirchain.mqh |
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

input string detection241109Name = "**************************************** Direction Detection: Donchain ****************************************"; //########## DONCHAIN ##########
input bool isDonDir = false; //Dochain?
input bool showDonDir = false; //Show?
input bool DonDirIsRevese = false; //Reverse?
input int DonDirPeriod = 20; //DonDirchain Period
int lastSideDonDirchain = 0;
bool detection241104_DonDirchain(int tc) {
    if(!isDonDir) {
        return true;
    }
    bool bS = false, sS = false;
    double hst = 0.0, lst = 0.0, mdi = 0.0;
    for(int i = 2; i <= DonDirPeriod + 1; i++) {
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
    if(showDonDir) {
        PlotIndividualLine(hst, clrBlue, 1);
        PlotIndividualLine(lst, clrRed, 1);
        PlotIndividualLine(mdi, clrGold, 1);
    }
    //bS = High[1] > hst;// && lastSideDonDirchain == -1;
   // sS = Low[1] < lst;// && lastSideDonDirchain == 1;
    if(High[1] > hst) {
        lastSideDonDirchain = 1;
    }
    if(Low[1] < lst) {
        lastSideDonDirchain = -1;
    }
    bS = lastSideDonDirchain == 1;
    sS = lastSideDonDirchain == -1;
    if(!DonDirIsRevese) {
        if(tc == 1) {
            return bS;
        } else if(tc == -1) {
            return sS;
        }
    } else if(DonDirIsRevese) {
        if(tc == 1) {
            return sS;
        } else if(tc == -1) {
            return bS;
        }
    }
    return false;
}
//+------------------------------------------------------------------+
