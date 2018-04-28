     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Date Offset Calculation')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000983  - Fees and Charges : Calculates the default        *
      *              payment and settlement dates according to the    *
      *              defaults payment date offset code.               *
      *                                                               *
      *  Function:  This module shall calculate the default payment   *
      *             date and settlement date that is to be applied    *
      *             to the Funds Transfer transaction.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG433             Date 02Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CFT009  *CREATE    Date 29Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG433 - Recompiled due to change in FTPDOCPD                *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * FT Payment Date Offset Codes. Key = Code
     FFTPDOCL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *  97 : General Chain Indicator                                 *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      *  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Entry parameters
     D P_OffsetCde     S                   Like(PYDTOC)
     D P_SettDate      S              6
     D P_PayDate       S                   Like(P_SettDate)
 
      * Work Variables
     D  WTimeDS        DS
     D  CurrTime                       T   Inz(*SYS)
     D  WHours                 1      2  0
     D  WMinutes               4      5  0
     D  WSeconds               7      8  0
 
     D  WTimeDSX       DS
     D  WTime                  1      6  0
     D  WHoursX                1      2  0
     D  WMinutesX              3      4  0
     D  WSecondsX              5      6  0
 
     D W_Today         S                   Like(BJRDNB)
 
     D P_SettWork      S              5  0
     D P_PayWork       S              5  0
 
     D P_SettWork6     S              6  0
     D P_PayWork6      S              6  0
 
     D ErrorFlag       S              1
 
      * Day Count Variables
     D  ZDayNo         S              5  0
     D  ZCCy           S              3
     D  ZNRDYS         S              7  0
     D  Day_Count      S                   Like(ZNRDYS)
     D  Day_Number     S                   Like(ZDayNo)
     D  Days_Fwd       S                   Like(ZNRDYS)
     D  SettDateLoc    S                   Like(ZCcy)
     D  PayDateLoc     S                   Like(ZCcy)
     D  Location       S                   Like(ZCcy)
     D  HolInd         S              1
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   Time                    CurrTime
 
      * Format WTime
     C                   Eval      WHoursX = Whours
     C                   Eval      WMinutesX = WMinutes
     C                   Eval      WSecondsX = WSeconds
 
 
      * Get details for payment charge offset code.
     C     P_OffsetCde   Chain     FTPDOCL0                           97
     C                   If        P_OffsetCde = *Blanks OR
     C                             *In97
     C                   Return
     C                   Endif
 
      * If the local start time is not entered, default this time to be midnight.
     C                   If        LSTTIM = 0
     C                   Eval      LSTTIM = 000001
     C                   Endif
 
     C                   IF        P_SettDate <> *Zeros  And
     C                             P_SettDate <> *Blanks
      * Convert the settlement date and payment date to Midas dates (5,0)
     C                   CallB     'ZDATE1'
     C                   Parm                    P_SettDate
     C                   Parm      *Zeros        P_SettWork
     C                   Parm                    BJDFIN
     C                   Parm      *Blank        ErrorFlag
 
     C                   If        ErrorFlag = 'Y'
     C                   Eval      DbFile = 'ZDATE1  '
     C                   Eval      DBase = 1
     C                   Eval      DBkey = 'P_SettDate'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Else
     C                   Z-add     BJRDNB        P_SettWork
     C                   Endif
 
 
     C                   IF        P_PayDate <> *Zeros  And
     C                             P_PayDate <> *Blanks
     C                   CallB     'ZDATE1'
     C                   Parm                    P_PayDate
     C                   Parm      *Zeros        P_PayWork
     C                   Parm                    BJDFIN
     C                   Parm      *Blank        ErrorFlag
 
     C                   If        ErrorFlag = 'Y'
     C                   Eval      DbFile = 'ZDATE1  '
     C                   Eval      DBase = 1
     C                   Eval      DBkey = 'P_PayDate'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Else
     C                   Z-add     BJRDNB        P_PayWork
     C                   Endif
 
      ** Set up the actual number of days to move forward, by adding
      ** on non-working days to the number of days.
 
      ** Settle offset before cut off
     C                   Eval      ZDAYNO = W_Today
     C                   Eval      ZNRDYS = BCOSDO
     C                   Eval      ZCCY = SettCcy
     C                   Eval      Location = SettDateLoc
     C                   ExSr      Count_Days
     C                   Eval      BCOSDO = Days_Fwd
      ** Settle offset after cut off
     C                   Eval      ZDAYNO = W_Today
     C                   Eval      ZNRDYS = ACOSDO
     C                   Eval      ZCCY = SettCcy
     C                   Eval      Location = SettDateLoc
     C                   ExSr      Count_Days
     C                   Eval      ACOSDO = Days_Fwd
      ** Payment offset before cut off
     C                   Eval      ZDAYNO = W_Today
     C                   Eval      ZNRDYS = BCOPDO
     C                   Eval      ZCCY = SettCcy
     C                   Eval      Location = PayDateLoc
     C                   ExSr      Count_Days
     C                   Eval      BCOPDO = Days_Fwd
      ** Payment offset after cut off
     C                   Eval      ZDAYNO = W_Today
     C                   Eval      ZNRDYS = ACOPDO
     C                   Eval      ZCCY = SettCcy
     C                   Eval      Location = PayDateLoc
     C                   ExSr      Count_Days
     C                   Eval      ACOPDO = Days_Fwd
 
     C                   Select
 
      * 1. Before start time
      * 2. After start time but before end time
     C                   WHEN      WTime > LSTTIM   and
     C                             WTime <= LCUTOF
 
     C                   If        P_SettWork >= W_Today
     C                   Eval      P_PayWork = P_SettWork + BCOPDO
     C                   Eval      P_SettWork = P_SettWork + BCOSDO
     C                   Else
     C                   Eval      P_SettWork = W_Today + BCOSDO
     C                   Eval      P_PayWork  = W_Today + BCOPDO
     C                   Endif
 
      * 3. After end time but < 23:99:99
 
     C                   Other
 
     C                   If        P_SettWork >= W_Today
     C                   Eval      P_PayWork  = P_SettWork + ACOPDO
     C                   Eval      P_SettWork = P_SettWork + ACOSDO
     C                   Else
     C                   Eval      P_SettWork = W_Today + ACOSDO
     C                   Eval      P_PayWork  = W_Today + ACOPDO
     C                   Endif
 
     C                   EndSl
 
      ** Check for non-working days for the dates selected. If the date
      ** falls on a holiday, add one to it until it is a working day for
      ** the currency.
 
      ** Settlement currency
 
     C                   If        SettCcy <> *Blanks
     C                   CallB     'ZCHKH'
     C                   Parm                    P_SettWork
     C                   Parm                    SettCcy
     C                   Parm                    SettDateLoc
     C                   Parm      *Blanks       HolInd            1
 
      ** Check to see if the date is a working day. If not, add a day
      ** until it is.
 
     C                   DoW       HolInd <> 'W'
     C                   Eval      P_SettWork = P_SettWork + 1
     C                   CallB     'ZCHKH'
     C                   Parm                    P_SettWork
     C                   Parm                    SettCcy
     C                   Parm                    SettDateLoc
     C                   Parm      *Blanks       HolInd
     C                   EndDo
     C                   EndIf
 
      ** Payment currency
 
     C                   If        PayCcy <> *Blanks
     C                   CallB     'ZCHKH'
     C                   Parm                    P_PayWork
     C                   Parm                    PayCcy
     C                   Parm                    PayDateLoc
     C                   Parm      *Blanks       HolInd
 
      ** Check to see if the date is a working day. If not, add a day
      ** until it is.
 
     C                   DoW       HolInd <> 'W'
     C                   Eval      P_PayWork = P_PayWork + 1
     C                   CallB     'ZCHKH'
     C                   Parm                    P_PayWork
     C                   Parm                    PayCcy
     C                   Parm                    PayDateLoc
     C                   Parm      *Blanks       HolInd
     C                   EndDo
     C                   EndIf
 
      * Convert work fields bank to 6,0
     C                   CallB     'ZDATE2'
     C                   Parm                    P_SettWork
     C                   Parm                    BJDFIN
     C                   Parm      *Zeros        P_SettWork6
     C                   Parm      *Blanks       Dummy             7
 
     C                   CallB     'ZDATE2'
     C                   Parm                    P_PayWork
     C                   Parm                    BJDFIN
     C                   Parm      *Zeros        P_PayWork6
     C                   Parm      *Blanks       Dummy             7
 
      * Move new settlement and paydates back to character values for return
     C                   Movel     P_SettWork6   P_SettDate
     C                   Movel     P_PayWork6    P_PayDate
 
     C                   Return
 
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Entry parameters:
     C     *Entry        Plist
      *
      ** Return Code (10A)
     C                   Parm                    RetCodeIn
      ** Payment Date Offset Code (5A)
     C                   Parm                    P_OffsetCde
      ** Settlement Date (6A) : From Screen Field
     C                   Parm                    P_SettDate
      ** Payment Date (6A) : From Screen Field
     C                   PARM                    P_PayDate
      ** Settlement currency (3A) : From Screen Field
     C                   PARM                    SettCcy           3
      ** Payment currency (3A) : From Screen Field
     C                   PARM                    PayCcy            3
      ** Settle Date Location Code (3A)
     C                   PARM                    SettDateLoc
      ** Pay Date Location Code (3A)
     C                   PARM                    PayDateLoc
 
      * Initialise program name
     C                   Eval      DBPGM = PsProcPgm
 
      * Get current Midas run date from SDBANKPD
     C                   CallB     'AOBANKR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDBANK        Parm      SDBANK        DSSDY
      *
      * Database error
     C                   If        @Rtcd <> *Blanks
     C                   Eval      DbFile = 'SDBANKPD'
     C                   Eval      DBase = 1
     C                   Eval      DBkey = @Optn
     C                   Exsr      *PSSR
     C                   Endif
 
      * Save todays date
     C                   Eval      W_Today = BJRDNB
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      **********************************************************************
      **                                                                  **
      ** Count_Days - SR to calculate any number of working days forward  **
      **              in any currency.                                    **
      **              Holidays file accessed by access object.            **
      **                                                                  **
      ** Input :                                                          **
      **                                                                  **
      **                                                                  **
      **********************************************************************
     C     Count_Days    BegSr                                                  *** ZDATE3 ***
 
      ** Clear count of number of days added, define Day_Number and
      ** zero the number of days forward.
 
     C                   Z-add     0             Day_Count
     C                   Z-add     ZDayNo        Day_Number
     C                   Z-add     0             Days_Fwd
 
      ** Move the date forward by the number of working days required.
 
     C                   DoW       Day_Count < ZNRDYS And Day_Count <= 99999
 
     C                   If        ZCcy <> *Blanks
     C                   CallB     'ZCHKH'
     C                   Parm                    Day_Number
     C                   Parm                    SettCcy
     C                   Parm                    Location
     C                   Parm      *Blanks       HolInd
     C                   EndIf
 
      ** If the day is a working day, count it.
 
     C                   If        HolInd = 'W'
     C                   Eval      Day_Count = Day_Count + 1
     C                   EndIf
 
      ** Add one to the day number.
 
     C                   Eval      Day_Number = Day_Number + 1
     C                   IF        Day_Number = 99999
     C                   Leave
     C                   Endif
 
     C                   EndDo
 
      ** Work out the number of days forward actually required to give
      ** the number of working days forward requested.
 
     C                   Eval      Days_Fwd = Day_Number - W_Today
 
     C                   EndSr
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
