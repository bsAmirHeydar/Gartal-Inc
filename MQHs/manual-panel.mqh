//+------------------------------------------------------------------+
//|                                                 manual-panel.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
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
enum direction {
    buy = 1, //Buy
    // neutral = 0,
    sell = -1, //Sell
    off = 10 //OFF
};
enum manualTypeOption {
    market = 0, //Merket
    limit = -1, //Limit
    stop = 1 //Stop
};
input string manualName0 = "---------------------------------------------------------------------------------------------------- Manual Panel ----------------------------------------------------------------------------------------------------"; //#################### MANUAL PANEL ####################
input direction manualDirection = 10; //Direction
input manualTypeOption manualType = 0; //Type
input double manualTrigger = 0.0; //Trigger Price
input color manualTriggerColor = clrBlack; //Trigger Color
input double manualStop = 0.0; //Ending Price
input color manualStopColor = clrPurple; //Ending Color
input double manualTP = 0.0; //Manual TP
input color manualTPColor = clrGreenYellow; //TP Color
input bool closeAllTP = true; //Close All in TP
input double manualSL = 0.0; //Manual SL
input color manualSLColor = clrDarkRed; //SL Color
input bool closeAllSL = false; //Close All in SL
//input string manualTriggerName0 = "**************************************** Trigger Setting ****************************************"; //########## MANUAL TRIGGER ##########
//input double manualTriggerPrice = 0.0; //Manual Trigger Price
//input direction manualNewDirection = 10; //New Direction
//input double manualNewTP = 0.0; //Manual New TP
//input double manualNewSL = 0.0; //Manual New SL
int lastDirection = -10, lastType = -10;//, lastNewDirection = -10;
double lastStop, lastTP, lastSL, lastTrigger;
bool permission = false, execute = false;
#include "order-management.mqh"
#include "indicator-management.mqh"

bool manualRun(int tc) {
    if(manualDirection == 10) {
        return true;
    }
    bool bS = false, sS = false;
    if(lastType != manualType) {
        lastType = manualType;
        permission = true;
        execute = false;
    }
    if(lastTrigger != manualTrigger) {
        lastTrigger = manualTrigger;
        permission = true;
        execute = false;
    }
    if(lastDirection != manualDirection) {
        lastDirection = manualDirection;
        permission = true;
        execute = false;
    }
    if(lastStop != manualStop) {
        lastStop = manualStop;
        permission = true;
    }
    if(lastTP != manualTP) {
        lastTP = manualTP;
        permission = true;
    }
    if(lastSL != manualSL) {
        lastSL = manualSL;
        permission = true;
    }
    if(manualType == 0) {
        execute = true;
    } else if(manualType == -1 && !execute) {
        if(manualDirection == 1) {
            if(manualTrigger != 0.0) {
                PlotIndividualLine(manualTrigger, manualTriggerColor, 0, 0);
                if(Bid <= manualTrigger) {
                    execute = true;
                }
            }
        } else if(manualDirection == -1) {
            if(manualTrigger != 0.0) {
                PlotIndividualLine(manualTrigger, manualTriggerColor, 0, 0);
                if(Bid >= manualTrigger) {
                    execute = true;
                }
            }
        }
    } else if(manualType == 1 && !execute) {
        if(manualDirection == 1) {
            if(manualTrigger != 0.0) {
                PlotIndividualLine(manualTrigger, manualTriggerColor, 0, 0);
                if(Bid >= manualTrigger) {
                    execute = true;
                }
            }
        } else if(manualDirection == -1) {
            if(manualTrigger != 0.0) {
                PlotIndividualLine(manualTrigger, manualTriggerColor, 0, 0);
                if(Bid <= manualTrigger) {
                    execute = true;
                }
            }
        }
    }
    if(manualDirection == 1 && permission) {
        PlotIndividualLine(manualStop, manualStopColor, 0, 0);
        PlotIndividualLine(manualTP, manualTPColor, 0, 0);
        PlotIndividualLine(manualSL, manualSLColor, 0, 0);
        if(execute) {
            bS = true;
            if(manualStop != 0.0 && Bid >= manualStop) {
                bS = false;
                permission = false;
            }
            if(manualTP != 0.0 && Bid >= manualTP) {
                bS = false;
                permission = false;
                if(closeAllTP) {
                    closeWholeOrder(1);
                }
            }
            if(manualSL != 0.0 && Bid <= manualSL) {
                bS = false;
                permission = false;
                if(closeAllSL) {
                    closeWholeOrder(1);
                }
            }
        }
    } else if(manualDirection == -1 && permission) {
        PlotIndividualLine(manualStop, manualStopColor, 0, 0);
        PlotIndividualLine(manualTP, manualTPColor, 0, 0);
        PlotIndividualLine(manualSL, manualSLColor, 0, 0);
        if(execute) {
            sS = true;
            if(manualStop != 0.0 && Bid <= manualStop) {
                sS = false;
                permission = false;
            }
            if(manualTP != 0.0 && Bid <= manualTP) {
                sS = false;
                permission = false;
                if(closeAllTP) {
                    closeWholeOrder(-1);
                }
            }
            if(manualSL != 0.0 && Bid >= manualSL) {
                sS = false;
                permission = false;
                if(closeAllSL) {
                    closeWholeOrder(-1);
                }
            }
        }
    } //else if(manualDirection == 0) {
    // bS = true;
    //sS = true;
    //  }
    if(tc == 1) {
        return bS;
    } else if(tc == -1) {
        return sS;
    }
    return false;
}
//+------------------------------------------------------------------+
