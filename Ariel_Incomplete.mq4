//+------------------------------------------------------------------+
//| This MQL is generated by Expert Advisor Builder                  |
//|                http://sufx.core.t3-ism.net/ExpertAdvisorBuilder/ |
//|                                                                  |
//|  In no event will author be liable for any damages whatsoever.   |
//|                      Use at your own risk.                       |
//|                                                                  |
//|   Modified by Lucas Liew                                         |                                                                 
//|                                                                  |
//+------------------- DO NOT REMOVE THIS HEADER --------------------+

   /* 
      
      ARIEL - SIMPLE TURTLE BOT
   
      ARIEL ENTRY RULES:
      Long: 
      When closing price is equal to or crosses Donchian(20) upper bound from the bottom.
      SMA(40) is greater than SMA(80). This indicates that we are in a up trend.
      
      Short: When closing price is equal to or crosses Donchian(20) lower bound from the top. 
      SMA(40) is less than SMA(80). This indicates that we are in a down trend.
      
      ARIEL EXIT RULES:
      Profit-Taking Exit 1: Exit the long trade when closing price is equal to or crosses Donchian(10) lower bound from the top.
      Profit-Taking Exit 1: Exit the short trade when closing price is equal to or crosses Donchian(10) upper bound from the bottom.
      Stop Loss Exit: Exit trade when closing price travelled 1 ATR in the adverse direction.
   
      ARIEL POSITION SIZING RULE:
      1% of Capital risked per trade
      
      10 TDLs in Total. Good Luck!
   */

#define SIGNAL_NONE 0
#define SIGNAL_BUY   1
#define SIGNAL_SELL  2
#define SIGNAL_CLOSEBUY 3
#define SIGNAL_CLOSESELL 4

#property copyright "Expert Advisor Builder"
#property link      "http://sufx.core.t3-ism.net/ExpertAdvisorBuilder/"

extern int MagicNumber = 00003;
extern bool SignalMail = False;
extern double Lots = 1.0;
extern int Slippage = 3;
extern bool UseStopLoss = True;
extern int StopLoss = 0;
extern bool UseTakeProfit = False;
extern int TakeProfit = 0;
extern bool UseTrailingStop = False;
extern int TrailingStop = 0;
extern bool isSizingOn = True;
extern int Risk = 1;

// TDL 10: Declare Extern Variables











int P = 1;
int Order = SIGNAL_NONE;
int Total, Ticket, Ticket2;
double StopLossLevel, TakeProfitLevel, StopLevel;
bool isYenPair;

// TDL 9: Declare variables







//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int init() {
   
   if(Digits == 5 || Digits == 3 || Digits == 1)P = 10;else P = 1; // To account for 5 digit brokers
   if(Digits == 3 || Digits == 2) isYenPair = True; // To account for Yen Pairs


   return(0);
}
//+------------------------------------------------------------------+
//| Expert initialization function - END                             |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit() {
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function - END                           |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert start function                                            |
//+------------------------------------------------------------------+
int start() {

   Total = OrdersTotal();
   Order = SIGNAL_NONE;

   //+------------------------------------------------------------------+
   //| Variable Setup                                                   |
   //+------------------------------------------------------------------+

   // TDL 1: Initialise Donchian indicators (Hint: Create 8 variables. 4 for entries and 4 for exits. You need to import the Donchian indicator using iCustom)
   
 
 
 
 
 
 
 
 
    
   // TDL 2: Initialise MAs
   




   // TDL 3: Calculate ATR(20)
   





   // TDL 4: Initialise Closing Price Variables
   



   
   // TDL 8: Declare Stop Loss
   
   StopLoss = ; 
   // Note that StopLoss need to be initialised before the Sizing Algo as we are using this value there
   // Hint: Divide the Stop Loss amount by (P * Point) to convert it to pips.
   
   // Sizing Algo (2% risked per trade)
   if (isSizingOn == true) {
      Lots = Risk * 0.01 * AccountBalance() / (MarketInfo(Symbol(),MODE_LOTSIZE) * StopLoss * P * Point); // Sizing Algo based on account size
      if(isYenPair == true) Lots = Lots * 100; // Adjust for Yen Pairs
      Lots = NormalizeDouble(Lots, 2); // Round to 2 decimal place
   }

   StopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL) + MarketInfo(Symbol(), MODE_SPREAD); // Defining minimum StopLevel

   if (StopLoss < StopLevel) StopLoss = StopLevel;
   if (TakeProfit < StopLevel) TakeProfit = StopLevel;

   //+------------------------------------------------------------------+
   //| Variable Setup - END                                             |
   //+------------------------------------------------------------------+

   //Check position
   bool IsTrade = False;

   for (int i = 0; i < Total; i ++) {
      Ticket2 = OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderType() <= OP_SELL &&  OrderSymbol() == Symbol()) {
         IsTrade = True;
         if(OrderType() == OP_BUY) {
            //Close

            //+------------------------------------------------------------------+
            //| Signal Begin(Exit Buy)                                           |
            //+------------------------------------------------------------------+

            /* 
            ARIEL EXIT RULES:
            Profit-Taking Exit 1: Exit the long trade when closing price is equal to or crosses Donchian(10) lower bound from the top.
            Profit-Taking Exit 1: Exit the short trade when closing price is equal to or crosses Donchian(10) upper bound from the bottom.
            Stop Loss Exit: Exit trade when closing price travelled 1 ATR in the adverse direction
            */
            
            // TDL 6: Add exit rule for long trades
            
            if() Order = SIGNAL_CLOSEBUY; // Rule to EXIT a Long trade

            //+------------------------------------------------------------------+
            //| Signal End(Exit Buy)                                             |
            //+------------------------------------------------------------------+

            if (Order == SIGNAL_CLOSEBUY) {
               Ticket2 = OrderClose(OrderTicket(), OrderLots(), Bid, Slippage, MediumSeaGreen);
               if (SignalMail) SendMail("[Signal Alert]", "[" + Symbol() + "] " + DoubleToStr(Bid, Digits) + " Close Buy");
               IsTrade = False;
               continue;
            }
            //Trailing stop
            if(UseTrailingStop && TrailingStop > 0) {                 
               if(Bid - OrderOpenPrice() > P * Point * TrailingStop) {
                  if(OrderStopLoss() < Bid - P * Point * TrailingStop) {
                     Ticket2 = OrderModify(OrderTicket(), OrderOpenPrice(), Bid - P * Point * TrailingStop, OrderTakeProfit(), 0, MediumSeaGreen);
                     continue;
                  }
               }
            }
         } else {
            

            //+------------------------------------------------------------------+
            //| Signal Begin(Exit Sell)                                          |
            //+------------------------------------------------------------------+

            // TDL 7: Add exit rule for short trades
   
            if () Order = SIGNAL_CLOSESELL; // Rule to EXIT a Short trade

            //+------------------------------------------------------------------+
            //| Signal End(Exit Sell)                                            |
            //+------------------------------------------------------------------+

            if (Order == SIGNAL_CLOSESELL) {
               Ticket2 = OrderClose(OrderTicket(), OrderLots(), Ask, Slippage, DarkOrange);
               if (SignalMail) SendMail("[Signal Alert]", "[" + Symbol() + "] " + DoubleToStr(Ask, Digits) + " Close Sell");               
               IsTrade = False;
               continue;
            }
            //Trailing stop
            if(UseTrailingStop && TrailingStop > 0) {                 
               if((OrderOpenPrice() - Ask) > (P * Point * TrailingStop)) {
                  if((OrderStopLoss() > (Ask + P * Point * TrailingStop)) || (OrderStopLoss() == 0)) {
                     Ticket2 = OrderModify(OrderTicket(), OrderOpenPrice(), Ask + P * Point * TrailingStop, OrderTakeProfit(), 0, DarkOrange);
                     continue;
                  }
               }
            }
         }
      }
   }

   //+------------------------------------------------------------------+
   //| Signal Begin(Entries)                                            |
   //+------------------------------------------------------------------+

      /*
      ARIEL ENTRY RULES:
      Long: 
      When closing price is equal to or crosses Donchian(20) upper bound from the bottom.
      SMA(40) is greater than SMA(80). This indicates that we are in a up trend.
      
      Short: When closing price is equal to or crosses Donchian(20) lower bound from the top. 
      SMA(40) is less than SMA(80). This indicates that we are in a down trend.
      */
   
   // TDL 5: Add all entry rules
   
      if () Order = SIGNAL_BUY; // Rule to ENTER a Long trade
   
      if () Order = SIGNAL_SELL; // Rule to ENTER a Short trade

   //+------------------------------------------------------------------+
   //| Signal End                                                       |
   //+------------------------------------------------------------------+

   //Buy
   if (Order == SIGNAL_BUY) {
      if(!IsTrade) {
         //Check free margin
         if (AccountFreeMargin() < (1000 * Lots)) {
            Print("We have no money. Free Margin = ", AccountFreeMargin());
            return(0);
         } 

         if (UseStopLoss) StopLossLevel = Ask - StopLoss * Point * P; else StopLossLevel = 0.0;
         if (UseTakeProfit) TakeProfitLevel = Ask + TakeProfit * Point * P; else TakeProfitLevel = 0.0;

         Ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, Slippage, StopLossLevel, TakeProfitLevel, "Buy(#" + MagicNumber + ")", MagicNumber, 0, DodgerBlue);
         if(Ticket > 0) {
            if (OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES)) {
				Print("BUY order opened : ", OrderOpenPrice());
                if (SignalMail) SendMail("[Signal Alert]", "[" + Symbol() + "] " + DoubleToStr(Ask, Digits) + " Open Buy");
			   
			} else {
				Print("Error opening BUY order : ", GetLastError());
			}
         }
         return(0);
      }
   }

   //Sell
   if (Order == SIGNAL_SELL) {
      if(!IsTrade) {
         //Check free margin
         if (AccountFreeMargin() < (1000 * Lots)) {
            Print("We have no money. Free Margin = ", AccountFreeMargin());
            return(0);
         }

         if (UseStopLoss) StopLossLevel = Bid + StopLoss * Point * P; else StopLossLevel = 0.0;
         if (UseTakeProfit) TakeProfitLevel = Bid - TakeProfit * Point * P; else TakeProfitLevel = 0.0;

         Ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, Slippage, StopLossLevel, TakeProfitLevel, "Sell(#" + MagicNumber + ")", MagicNumber, 0, DeepPink);
         if(Ticket > 0) {
            if (OrderSelect(Ticket, SELECT_BY_TICKET, MODE_TRADES)) {
				Print("SELL order opened : ", OrderOpenPrice());
                if (SignalMail) SendMail("[Signal Alert]", "[" + Symbol() + "] " + DoubleToStr(Bid, Digits) + " Open Sell");
	
			} else {
				Print("Error opening SELL order : ", GetLastError());
			}
         }
         return(0);
      }
   }


   return(0);
}
//+------------------------------------------------------------------+

