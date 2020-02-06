     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas TI SDHOLPD Trigger - CVPF Calendars')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI000106 - Midas TI Trigger program                          *
      *                                                               *
      *  Function:  This program updates/adds/deletes a record in     *
      *             CVPF for Calendars                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Called By: SCTRIGGER                                         *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 240547             Date 28Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG4499             Date 02Nov04               *
      *                 BG3697  *CREATE    Date 23May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  240547 - Local runday calendar updated even when not local   *
      *           currency.                                           *
      *  BG4499 - Local runday calendar not being updated             *
      *  BG3697 - Convert TI SQL triggers to RPG                      *
      *                                                               *
      *****************************************************************
 
     FSDHOLL3   IF   E           K DISK
     FSDHOLL9   IF   E           K DISK                                                       BG4499
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D Parm1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A
 
     D Parm2           DS
     D  LENG                   1      4B 0
 
     DHOLFormat      E DS                  ExtName(SDHOLPD)
     D HOLDIY                 17    382
 
      ** External data structure for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for location details
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
 
      ** External data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
      * 'Before' variables for SQL key details
     D KCVYOC          S              9  0
     D KCVCCY          S              3
     D KCVCCYN         S              3
     D KCVCNA          S              2
 
      * Intermediate variables for CVPF
     D WCVYOC          S              9  0
     D WCVCCY          S              3
     D WCVCCYN         S              3
     D WCVCLD          S             35
     D WCVDIW          S              7
     D WCVDIY          S            366    Varying
     D WCVDOO          S              9  0
     D WCVCNA          S              2
     D WCVYNA          S              1
 
      * Work variables
     D HOLARR          S              1    DIM(366)
     D DIYARR          S              1    DIM(366)
     D DIYARR2         S              1    DIM(366)
     D StdWorkD        S              1    DIM(7)
     D TestYr          S              5  0
     D TestYr2         S              2  0
     D YearNo          S              4  0
     D Day             S              3  0
     D WorkFld         S              5  1
     D WorkFract       S              1  1
     D @KEY            S              3
     D EndEvent        S              1
     D LRDProcessed    S              1
     D DeleteFlag      S              1
     D TestYoC         S              9  0
      ********************************************************************
     C/EJECT
      ********************************************************************
 
      * Entry parameters
 
     C     *ENTRY        PLIST
     C                   Parm                    Parm1
     C                   Parm                    Parm2
 
      * Recover before and after image
     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     Parm1:OffSet  I#BIMG         4000
 
     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     Parm1:OffSet  I#AIMG         4000
      *
      **Get*after*image*                                                                      BG4499
      * Get after image for inserts, before image for deletes and amends                      BG4499
      * (for key details)                                                                     BG4499
     C                   If        TrgEvent <> '2'                                            BG4499
     C                   Eval      HOLFormat = I#AIMG
     C                   Else                                                                 BG4499
     C                   Eval      HOLFormat = I#BIMG                                         BG4499
     C                   EndIf                                                                BG4499
 
      * Set SQL return code, and flags to control loop
     C                   Eval      SQLCOD = 0
     C                   Eval      LRDProcessed  = ' '
     C                   Eval      EndEvent = 'Y'
     C                   Eval      DeleteFlag = ' '
 
      * Get currency and default location from SDBANKPD
     C                   Call      'AOBANKR0'
     C                   Parm      '*MSG   '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDBANK        Parm      SDBANK        DSSDY
 
     C                   If        @RTCD <> *BLANK
     C                   ExSR      *PSSR
     C                   EndIf
 
      * Trigger event types:
      * '1'=Insert, '2'=Delete, '3'=Update
      *
      **Set*up*key*details*for*amends*and*deletes:*                                           BG4499
     C*********          If        TrgEvent <> '1'                                            BG4499
      * Set up key details                                                                    BG4499
     C                   ExSR      SetKList
     C*********          EndIf                                                                BG4499
      *                                                                                       BG4499
      * If inserting a location calendar, check to see if a country                           BG4499
      * calendar already exists                                                               BG4499
     C                   If        DGLCCD <> '***'                                            BG4499
     C                             and TrgEvent = '1'                                         BG4499
     C/EXEC SQL                                                                               BG4499
     C+ Select CVYOC                                                                          BG4499
     C+ into :TestYoC                                                                         BG4499
     C+ from CVPF                                                                             BG4499
     C+ where CVYOC = :KCVYOC                                                                 BG4499
     C+ and  CVCCY  = '   '                                                                   BG4499
     C+ and  CVCNA  = :KCVCNA                                                                 BG4499
     C+ and  CVCCYN = :KCVCCYN                                                                BG4499
     C/END-EXEC                                                                               BG4499
      *                                                                                       BG4499
      * If found, change event type to 'amend'.                                               BG4499
     C                   If        TestYoC = KCVYOC                                           BG4499
     C                   Eval      TrgEvent = '3'                                             BG4499
     C                   EndIf                                                                BG4499
     C                   EndIf                                                                BG4499
      *                                                                                       BG4499
      * Get after image for amends                                                            BG4499
     C                   If        TrgEvent = '3'                                             BG4499
     C                   Eval      HOLFormat = I#AIMG                                         BG4499
     C                   EndIf                                                                BG4499
      *
      * Set up CVPF details (not needed for deletes):
     C                   If        TrgEvent <> '2'
     C                   ExSR      SetVar
     C                   EndIf
 
      * Insert
     C                   If        TrgEvent = '1'
     C                   DoU       EndEvent = 'Y'
     C/EXEC SQL
     C+ Insert into CVPF (
     C+ CVYOC,
     C+ CVCCY,
     C+ CVCCYN,
     C+ CVCLD,
     C+ CVDIW,
     C+ CVDIY,
     C+ CVDOO,
     C+ CVCNA,
     C+ CVYNA,
     C+ DUALACTION,
     C+ CUSER,
     C+ AUSER
     C+ )
     C+ VALUES(
     C+ :WCVYOC,
     C+ :WCVCCY,
     C+ :WCVCCYN,
     C+ :WCVCLD,
     C+ :WCVDIW,
     C+ :WCVDIY,
     C+ :WCVDOO,
     C+ :WCVCNA,
     C+ :WCVYNA,
     C+ ' ',
     C+ 0,
     C+ 0
     C+  )
     C/END-EXEC
      *
      * Check for successful completion
     C                   If        SQLCOD <> 0
     C                   ExSR      *PSSR
     C                   EndIf
      *
      * If not already processed, check for local run day calendar
     C                   If        LRDProcessed = 'Y'
     C                   Eval      EndEvent = 'Y'
     C                   Else
      *
      * If the currency is local currency, a local run day calendar is required
     C                   If        DGCYCD = BJLCCY
     C                   Eval      LRDProcessed  = 'Y'
     C                   Eval      EndEvent = 'N'
     C                   Eval      WCVCCY   = '   '
     C                   Eval      WCVCCYN  = 'AAA'
     C                   Eval      WCVCNA = '  '
     C                   Eval      WCVCLD = 'Local Run Day'
     C                   Eval      WCVYNA = 'N'
      *
      * Check to see if it already exists (could be set up by either a currency
      * or location calendar)
     C/EXEC SQL
     C+ Select CVYOC
     C+ into :TestYoC
     C+ from CVPF
     C+ where CVYOC = :WCVYOC
     C+ and  CVCCY  = :WCVCCY
     C+ and  CVCNA  = :WCVCNA
     C+ and  CVCCYN = :WCVCCYN
     C/END-EXEC
      *
      * If found, set flag to exit loop.
     C                   If        TestYoC = WCVYOC
     C                   Eval      EndEvent = 'Y'
      *
      **If*found,*and*this*is*a*location*calendar,*overwrite*existing*record.**               BG4499
     C***************    If        DGLCCD <> '***'                                            BG4499
     C*/EXEC*SQL**************************                                                    BG4499
     C*+*Update*CVPF*set******************                                                    BG4499
     C*+*CVCLD**=*:WCVCLD,****************                                                    BG4499
     C*+*CVDIW**=*:WCVDIW,****************                                                    BG4499
     C*+*CVDIY**=*:WCVDIY,****************                                                    BG4499
     C*+*CVDOO**=*:WCVDOO,****************                                                    BG4499
     C*+*CVYNA**=*:WCVYNA*****************                                                    BG4499
     C*+*where*CVYOC*=*:WCVYOC************                                                    BG4499
     C*+*and**CVCCY**=*:WCVCCY************                                                    BG4499
     C*+*and**CVCNA**=*:WCVCNA************                                                    BG4499
     C*+*and**CVCCYN*=*:WCVCCYN***********                                                    BG4499
     C*/END-EXEC**************************                                                    BG4499
      *********                                                                               BG4499
      **Check*for successful completion                                                       BG4499
     C*********          If        SQLCOD <> 0                                                BG4499
     C*********          ExSR      *PSSR                                                      BG4499
     C*********          EndIf                                                                BG4499
     C*********          EndIf                                                                BG4499
      *********                                                                               BG4499
      **Reset*SQL return code                                                                 BG4499
     C*********          Eval      SQLCOD = 0                                                 BG4499
     C                   EndIf
      *
      * If local runday calendar already processed, set flag to exit loop
     C                   Else
     C                   Eval      EndEvent = 'Y'
     C                   EndIf
     C                   EndIf
 
     C                   EndDo
     C                   EndIf
      *
      * Delete
     C                   If        TrgEvent = '2'
      *
      * If a currency calendar, just delete.  If a location calendar,
      * check whether all the location calendars for the local currency
      * have been deleted before deleting.  Only delete the local run day                     BG4499
      * calendar if all calendars for that year have been deleted.                            BG4499
      **have*been*deleted.**In*either*case,*leave*the*local*run*day*                          BG4499
      **calendar.**                                                                           BG4499
     C                   If        DGLCCD = '***'
     C                   Eval      DeleteFlag = 'Y'
     C                   Else
      *
      * Check whether all location calendars have been deleted.                               BG4499
     C     HolKey        KList
     C                   KFld                    KeyCCY            3
     C                   KFld                    KeyYear           4
     C                   Eval      KeyCCY  = DGCYCD
     C                   Eval      KeyYear = DGYRNB
 
     C     HolKey        SetLL     SDHOLL3
     C                   DoW       *In99 = *Off
     C     HolKey        READE     SDHOLL3                                99
     C***********        If        DGCYCD <> '***'                                            BG4499
     C                   If        DGLCCD <> '***'                                            BG4499
     C                   Leave
     C                   EndIf
     C                   EndDo
      *
      * If all location calendars for the local currency have been deleted,
      * delete the (single) TI country calendar.
     C                   If        *In99 = *On
     C                   Eval      DeleteFlag = 'Y'
     C                   EndIf
     C                   EndIf
 
     C                   If        DeleteFlag = 'Y'
     C/EXEC SQL
     C+ Delete from CVPF
     C+ where CVYOC = :KCVYOC
     C+ and CVCCY  = :KCVCCY
     C+ and CVCCYN = :KCVCCYN
     C+ and CVCNA  = :KCVCNA
     C/END-EXEC
      *
      * Check for successful completion
     C                   If        SQLCOD <> 0
     C                   ExSR      *PSSR
     C                   EndIf
      *                                                                                       BG4499
      * Check if all calendars for that year have been deleted.                               BG4499
     C     DGYRNB        SetLL     SDHOLL9                                                    BG4499
     C                   If        not %Equal                                                 BG4499
     C/EXEC SQL                                                                               BG4499
     C+ Delete from CVPF                                                                      BG4499
     C+ where CVYOC = :KCVYOC                                                                 BG4499
     C+ and CVCCY  = '   '                                                                    BG4499
     C+ and CVCCYN = 'AAA'                                                                    BG4499
     C+ and CVCNA  = '   '                                                                    BG4499
     C/END-EXEC                                                                               BG4499
     C                   EndIf                                                                BG4499
     C                   EndIf
      *
     C                   EndIf
      *
      * Update
     C                   If        TrgEvent = '3'
     C                   DoU       EndEvent = 'Y'
     C/EXEC SQL
     C+ Update CVPF set
     C+ CVYOC  = :WCVYOC,
     C+ CVCCY  = :WCVCCY,
     C+ CVCCYN = :WCVCCYN,
     C+ CVCLD  = :WCVCLD,
     C+ CVDIW  = :WCVDIW,
     C+ CVDIY  = :WCVDIY,
     C+ CVDOO  = :WCVDOO,
     C+ CVCNA  = :WCVCNA,
     C+ CVYNA  = :WCVYNA
     C+ where CVYOC = :KCVYOC
     C+ and  CVCCY  = :KCVCCY
     C+ and  CVCCYN = :KCVCCYN
     C+ and  CVCNA  = :KCVCNA
     C/END-EXEC
      *
      * Check for successful completion
     C                   If        SQLCOD <> 0
     C                   ExSR      *PSSR
     C                   EndIf
      *
      * If not already processed, check for Local Run Day Calendar
     C                   If        LRDProcessed = 'Y'
     C                   Eval      EndEvent = 'Y'
     C                   Else
      *                                                                                       BG4499
      * Only change the local runday calendar if this is the default                          BG4499
      * location calendar or, if there is no default location, if this                        BG4499
      * is a currency calendar.                                                               BG4499
     C                   If        DGCYCD = BJLCCY and
     C                             DGLCCD = BJSLCD or                                         BG4499
     C                             DGCYCD = BJLCCY and                                        240547
     C                             BJSLCD = '   ' and                                         BG4499
     C                             DGLCCD = '***'                                             BG4499
     C***********                  DGLCCD <> '***' and                                        BG4499
     C***********                  DGLCCD = BJSLCD                                            BG4499
      *
      * Set up variables
     C                   Eval      LRDProcessed  = 'Y'
     C                   Eval      EndEvent = 'N'
     C                   Eval      KCVCCY   = '   '
     C                   Eval      KCVCCYN  = 'AAA'
     C                   Eval      KCVCNA = ' '
     C                   Eval      WCVCCY   = '   '
     C                   Eval      WCVCCYN  = 'AAA'
     C                   Eval      WCVCNA = '  '
     C                   Eval      WCVCLD = 'Local Run Day'
      *
      * If local runday calendar already processed, set flag to exit loop
     C                   Else
     C                   Eval      EndEvent = 'Y'
     C                   EndIf
     C                   EndIf
 
     C                   EndDo
     C                   EndIf
 
     C                   SetOn                                        LR
     C                   Return
 
      ********************************************************************
      /EJECT
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SetKList - Set Key list
      ********************************************************************
     C     SetKList      BegSR
 
      * First get some details from the currency file
     C                   Call      'AOCURRR0'
     C                   Parm      '*MSG   '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      DGCYCD        @KEY
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        @RTCD <> *BLANK
     C                   ExSR      *PSSR
     C                   EndIf
 
     C                   MoveL     DGYRNB        YearNo
     C                   Eval      KCVYOC = YearNo - 1900
 
      * If the location code is '***', this is a currency calendar.
     C                   If        DGLCCD = '***'
     C                   Eval      KCVCCY = DGCYCD
     C                   MoveL     A6ISON        KCVCCYN
     C                   Eval      KCVCNA = '  '
     C                   Else
      *
      * Else this is a Country (or location) calendar.
      * Note: TI can only have one location calendar.
     C                   Call      'AOLOCNR0'
     C                   Parm      '*MSG   '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      DGLCCD        @KEY
     C     SDLOCN        Parm      SDLOCN        DSFDY
 
     C                   If        @RTCD <> *BLANK
     C                   ExSR      *PSSR
     C                   EndIf
      *
     C                   Eval      KCVCCY = '   '
     C                   Eval      KCVCCYN = 'AAA'
     C                   Eval      KCVCNA = DVCNCD
     C                   EndIf
 
     C                   EndSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
 
      ********************************************************************
      * SetVar  - Set variables
      ********************************************************************
     C     SetVar        BegSR
      *
      * Initialise variable length field
     C                   Eval      %Len(WCVDIY) = 366
 
      * First get some details from the currency file
     C                   Call      'AOCURRR0'
     C                   Parm      '*MSG   '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      DGCYCD        @KEY
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        @RTCD <> *BLANK
     C                   ExSR      *PSSR
     C                   EndIf
      *
     C                   MoveL     DGYRNB        YearNo
     C                   Eval      WCVYOC = YearNo - 1900
 
      * If the location code is '***', this is a currency calendar.
      * Set variables accordingly.
     C                   If        DGLCCD = '***'
     C                   Eval      WCVCCY = DGCYCD
     C                   MoveL     A6ISON        WCVCCYN
     C                   Eval      WCVCLD = A6MACD
     C                   Eval      WCVCNA = '  '
     C                   Eval      WCVYNA = 'N'
      *
      * Else.... this is a Country (or location) calendar
      * Note: TI can only have one location calendar, so this will be
      * the last one entered.....
     C                   Else
     C                   Eval      WCVCCY = '   '
     C                   Eval      WCVCCYN = 'AAA'
     C                   Call      'AOLOCNR0'
     C                   Parm      '*MSG   '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      DGLCCD        @KEY
     C     SDLOCN        Parm      SDLOCN        DSFDY
 
     C                   If        @RTCD <> *BLANK
     C                   ExSR      *PSSR
     C                   EndIf
     C                   Eval      WCVCLD = DVLCNM
     C                   Eval      WCVCNA = DVCNCD
     C                   Eval      WCVYNA = 'Y'
      *
     C                   EndIf
      *
      * Standard working days
     C                   Eval      StdWorkD = *All'Y'
     C                   If        A6MONH = 'Y'
     C                   Eval      StdWorkD(1) = 'N'
     C                   EndIf
     C                   If        A6TUEH = 'Y'
     C                   Eval      StdWorkD(2) = 'N'
     C                   EndIf
     C                   If        A6WEDH = 'Y'
     C                   Eval      StdWorkD(3) = 'N'
     C                   EndIf
     C                   If        A6THUH = 'Y'
     C                   Eval      StdWorkD(4) = 'N'
     C                   EndIf
     C                   If        A6FRIH = 'Y'
     C                   Eval      StdWorkD(5) = 'N'
     C                   EndIf
     C                   If        A6SATH = 'Y'
     C                   Eval      StdWorkD(6) = 'N'
     C                   EndIf
     C                   If        A6SUNH = 'Y'
     C                   Eval      StdWorkD(7) = 'N'
     C                   EndIf
     C                   MoveA     StdWorkD      WCVDIW
      *
      * Days in year
     C                   Eval      DIYARR = *All'Y'
     C                   MoveA     HOLDIY        HOLARR
     C                   Eval      Day = 0
     C                   DoU       Day = 366
     C                   Eval      Day = Day + 1
     C                   If        HOLARR(Day) = 'X'
     C                   Eval      DIYARR(Day) = 'N'
     C                   EndIf
     C                   EndDo
 
      * In a non-leap year, we need to drop Feb 29th.  If the last
      * two digits of (year * 25) = 0, then this is a leap year
      * (this program will fail in 2400.  Shame.)
     C                   MoveA     DIYARR        DIYARR2
     C                   MoveL     DGYRNB        YearNo
     C                   Eval      TestYr = YearNo * 25
     C                   Move      TestYr        TestYr2
     C                   If        TestYr2 <> *Zeros
     C                   MoveA     DIYARR(61)    DIYARR2(60)
     C                   Eval      %Len(WCVDIY) = 365
     C                   EndIf
     C                   MoveA     DIYARR2       WCVDIY
 
      * Day of the week on which 1st Jan falls.  If you divide the
      * Midas run day by 7, the remainder is always the same for
      * each day of the week, as below.
     C                   Eval      WorkFld = DGJDNB/7
     C                   Move      WorkFld       WorkFract
     C                   Select
     C                   When      WorkFract = 0.4
     C                   Eval      WCVDOO = 0
     C                   When      WorkFract = 0.5
     C                   Eval      WCVDOO = 1
     C                   When      WorkFract = 0.7
     C                   Eval      WCVDOO = 2
     C                   When      WorkFract = 0.8
     C                   Eval      WCVDOO = 3
     C                   When      WorkFract = 0.0
     C                   Eval      WCVDOO = 4
     C                   When      WorkFract = 0.1
     C                   Eval      WCVDOO = 5
     C                   When      WorkFract = 0.2
     C                   Eval      WCVDOO = 6
     C                   EndSl
 
     C                   EndSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
 
     C                   SetOn                                        LR
     C                   Return
 
     C                   EndSR
 
      **---------------------------------------------------------------
      *****************************************************************
