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
input string non1_time = "** Section 1 **";
input int start_hour = 1; //Start Hour 1
input int start_minute = 30; //Start Hinute 1
input int end_hour = 23; //End Hour 1
input int end_minute = 55; //End Minute 1
input int close_hour = 23; //close hour 1
input int close_minute = 55; // close minute 1
input int start_hour1 = 1; //Start Hour 1
input int start_minute1 = 30; //Start Hinute 1
input int end_hour1 = 23; //End Hour 1
input int end_minute1 = 55; //End Minute 1
input int close_hour1 = 23; //close hour 1
input int close_minute1 = 55; // close minute 1
input string non2_time2 = "** Section 2 **";
input int start_hour2 = 1; //Start Hour 2
input int start_minute2 = 30; //Start Hinute 2
input int end_hour2 = 23; //End Hour 2
input int end_minute2 = 55; //End Minute 2
input int close_hour2 = 23; //close hour 2
input int close_minute2 = 55; // close minute 2
input string non2_time3 = "** Section 3 **";
input int start_hour3 = 1; //Start Hour 3
input int start_minute3 = 30; //Start Hinute 3
input int end_hour3 = 23; //End Hour 3
input int end_minute3 = 55; //End Minute 3
input int close_hour3 = 23; //close hour 3
input int close_minute3 = 55; // close minute 3
class timeSectionManage {
  public:
    int start5;
    timeSectionManage(void);
    ~timeSectionManage(void);
};
//+------------------------------------------------------------------+
