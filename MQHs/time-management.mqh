//+------------------------------------------------------------------+
//|                                              time-management.mqh |
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
//Inputs
input string non0_time = "-----Time Management-----";
input string non1_time0 = "** Section 0 **";
input int start_hour = 1; //Start Hour 0
input int start_minute = 30; //Start Hinute 0
input int end_hour = 23; //End Hour 0
input int end_minute = 55; //End Minute 0
input int close_hour = 23; //close hour 0
input int close_minute = 55; // close minute 0
input string non1_time1 = "** Section 1 **";
input bool isSection1 = false;
input int start_hour1 = 1; //Start Hour 1
input int start_minute1 = 30; //Start Hinute 1
input int end_hour1 = 23; //End Hour 1
input int end_minute1 = 55; //End Minute 1
input int close_hour1 = 23; //close hour 1
input int close_minute1 = 55; // close minute 1
input string non2_time2 = "** Section 2 **";
input bool isSection2 = false;
input int start_hour2 = 1; //Start Hour 2
input int start_minute2 = 30; //Start Hinute 2
input int end_hour2 = 23; //End Hour 2
input int end_minute2 = 55; //End Minute 2
input int close_hour2 = 23; //close hour 2
input int close_minute2 = 55; // close minute 2
input string non2_time3 = "** Section 3 **";
input bool isSection3 = false;
input int start_hour3 = 1; //Start Hour 3
input int start_minute3 = 30; //Start Hinute 3
input int end_hour3 = 23; //End Hour 3
input int end_minute3 = 55; //End Minute 3
input int close_hour3 = 23; //close hour 3
input int close_minute3 = 55; // close minute 3
class timeSectionManage {
  public:
    float sectionTP;
    float sectionSL;

    timeSectionManage(void);
    ~timeSectionManage(void);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool inTime() {
    datetime serverTime = TimeCurrent();
    int currentHour = TimeHour(serverTime);
    int currentMinute = TimeMinute(serverTime);
    int currentDay = TimeDay(serverTime);
    if((currentHour > start_hour || (currentHour == start_hour && currentMinute > start_minute)) &&
            (currentHour < end_hour || (currentHour == end_hour && currentMinute < end_minute)) ) {
        return true;
    }
    if(isSection1) {
        if((currentHour > start_hour1 || (currentHour == start_hour1 && currentMinute > start_minute1)) &&
                (currentHour < end_hour1 || (currentHour == end_hour1 && currentMinute < end_minute1)) ) {
            return true;
        }
    }
    if(isSection2) {
        if((currentHour > start_hour2 || (currentHour == start_hour2 && currentMinute > start_minute2)) &&
                (currentHour < end_hour2 || (currentHour == end_hour2 && currentMinute < end_minute2)) ) {
            return true;
        }
    }
    if(isSection3) {
        if((currentHour > start_hour3 || (currentHour == start_hour3 && currentMinute > start_minute3)) &&
                (currentHour < end_hour3 || (currentHour == end_hour3 && currentMinute < end_minute3)) ) {
            return true;
        }
    }
    return false;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool closeTime() {
    datetime serverTime = TimeCurrent();
    int currentHour = TimeHour(serverTime);
    int currentMinute = TimeMinute(serverTime);
    int currentDay = TimeDay(serverTime);
    if(currentHour == close_hour && currentMinute == close_minute) {
        return true;
    }
    if(isSection1) {
        if(currentHour == close_hour1 && currentMinute == close_minute1) {
            return true;
        }
    }
    if(isSection2) {
        if(currentHour == close_hour2 && currentMinute == close_minute2) {
            return true;
        }
    }
    if(isSection3) {
        if(currentHour == close_hour3 && currentMinute == close_minute3) {
            return true;
        }
    }
    return false;
}
//+------------------------------------------------------------------+
