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
enum dayOfWeek {
    Sunday,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Staurday
};
//Inputs
input string non0_time = "---------------------------------------------------------------------------------------------------- Time Management ----------------------------------------------------------------------------------------------------"; //#################### TIME MANAGEMENT ####################
input dayOfWeek Day1 = 1;
input dayOfWeek Day2 = 2;
input dayOfWeek Day3 = 3;
input dayOfWeek Day4 = 4;
input dayOfWeek Day5 = 5;
input string non1_time0 = "**************************************** Section 0 ****************************************"; //########## SECTION 0 ##########
input int start_hour = 1; //Start Hour 0
input int start_minute = 30; //Start Hinute 0
input int end_hour = 23; //End Hour 0
input int end_minute = 55; //End Minute 0
input int close_hour = 23; //close hour 0
input int close_minute = 55; // close minute 0
input string non1_time1 = "**************************************** Section 1 ****************************************"; //########## SECTION 1 ##########
input bool isSection1 = false;
input int start_hour1 = 1; //Start Hour 1
input int start_minute1 = 30; //Start Hinute 1
input int end_hour1 = 23; //End Hour 1
input int end_minute1 = 55; //End Minute 1
input int close_hour1 = 23; //close hour 1
input int close_minute1 = 55; // close minute 1
input string non2_time2 = "**************************************** Section 2 ****************************************"; //########## SECTION 2 ##########
input bool isSection2 = false;
input int start_hour2 = 1; //Start Hour 2
input int start_minute2 = 30; //Start Hinute 2
input int end_hour2 = 23; //End Hour 2
input int end_minute2 = 55; //End Minute 2
input int close_hour2 = 23; //close hour 2
input int close_minute2 = 55; // close minute 2
input string non2_time3 = "**************************************** Section 3 ****************************************"; //########## SECTION 3 ##########
input bool isSection3 = false;
input int start_hour3 = 1; //Start Hour 3
input int start_minute3 = 30; //Start Hinute 3
input int end_hour3 = 23; //End Hour 3
input int end_minute3 = 55; //End Minute 3
input int close_hour3 = 23; //close hour 3
input int close_minute3 = 55; // close minute 3
input string non2_time4 = "**************************************** Section 4 ****************************************"; //########## SECTION 4 ##########
input bool isSection4 = false;
input int start_hour4 = 1; //Start Hour 4
input int start_minute4 = 30; //Start Hinute 4
input int end_hour4 = 23; //End Hour 4
input int end_minute4 = 55; //End Minute 4
input int close_hour4 = 23; //close hour 4
input int close_minute4 = 55; // close minute 4
input string non2_time5 = "**************************************** Section 5 ****************************************"; //########## SECTION 5 ##########
input bool isSection5 = false;
input int start_hour5 = 1; //Start Hour 5
input int start_minute5 = 30; //Start Hinute 5
input int end_hour5 = 23; //End Hour 5
input int end_minute5 = 55; //End Minute 5
input int close_hour5 = 23; //close hour 5
input int close_minute5 = 55; // close minute 5
input string non2_time6 = "**************************************** Section 6 ****************************************"; //########## SECTION 6 ##########
input bool isSection6 = false;
input int start_hour6 = 1; //Start Hour 6
input int start_minute6 = 30; //Start Hinute 6
input int end_hour6 = 23; //End Hour 6
input int end_minute6 = 55; //End Minute 6
input int close_hour6 = 23; //close hour 6
input int close_minute6 = 55; // close minute 6
input string non2_time7 = "**************************************** Section 7 ****************************************"; //########## SECTION 7 ##########
input bool isSection7 = false;
input int start_hour7 = 1; //Start Hour 7
input int start_minute7 = 30; //Start Hinute 7
input int end_hour7 = 23; //End Hour 7
input int end_minute7 = 55; //End Minute 7
input int close_hour7 = 23; //close hour 7
input int close_minute7 = 55; // close minute 7
input string non2_time8 = "**************************************** Section 8 ****************************************"; //########## SECTION 8 ##########
input bool isSection8 = false;
input int start_hour8 = 1; //Start Hour 8
input int start_minute8 = 30; //Start Hinute 8
input int end_hour8 = 23; //End Hour 8
input int end_minute8 = 55; //End Minute 8
input int close_hour8 = 23; //close hour 8
input int close_minute8 = 55; // close minute 8
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool inTime() {
    datetime serverTime = TimeCurrent();
    int currentHour = TimeHour(serverTime);
    int currentMinute = TimeMinute(serverTime);
    int currentDay = TimeDay(serverTime);
    int currentDayOfWeek = TimeDayOfWeek(serverTime);
    if(
        currentDayOfWeek != Day1 &&
        currentDayOfWeek != Day2 &&
        currentDayOfWeek != Day3 &&
        currentDayOfWeek != Day4 &&
        currentDayOfWeek != Day5
    ) {
        return false;
    }
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
    if(isSection4) {
        if((currentHour > start_hour4 || (currentHour == start_hour4 && currentMinute > start_minute4)) &&
                (currentHour < end_hour4 || (currentHour == end_hour4 && currentMinute < end_minute4)) ) {
            return true;
        }
    }
    if(isSection5) {
        if((currentHour > start_hour5 || (currentHour == start_hour5 && currentMinute > start_minute5)) &&
                (currentHour < end_hour5 || (currentHour == end_hour5 && currentMinute < end_minute5)) ) {
            return true;
        }
    }
    if(isSection6) {
        if((currentHour > start_hour6 || (currentHour == start_hour6 && currentMinute > start_minute6)) &&
                (currentHour < end_hour6 || (currentHour == end_hour6 && currentMinute < end_minute6)) ) {
            return true;
        }
    }
    if(isSection7) {
        if((currentHour > start_hour7 || (currentHour == start_hour7 && currentMinute > start_minute7)) &&
                (currentHour < end_hour7 || (currentHour == end_hour7 && currentMinute < end_minute7)) ) {
            return true;
        }
    }
    if(isSection8) {
        if((currentHour > start_hour8 || (currentHour == start_hour8 && currentMinute > start_minute8)) &&
                (currentHour < end_hour8 || (currentHour == end_hour8 && currentMinute < end_minute8)) ) {
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
    if(isSection4) {
        if(currentHour == close_hour4 && currentMinute == close_minute4) {
            return true;
        }
    }
    if(isSection5) {
        if(currentHour == close_hour5 && currentMinute == close_minute5) {
            return true;
        }
    }
    if(isSection6) {
        if(currentHour == close_hour6 && currentMinute == close_minute6) {
            return true;
        }
    }
    if(isSection7) {
        if(currentHour == close_hour7 && currentMinute == close_minute7) {
            return true;
        }
    }
    if(isSection8) {
        if(currentHour == close_hour8 && currentMinute == close_minute8) {
            return true;
        }
    }
    return false;
}
//+------------------------------------------------------------------+
