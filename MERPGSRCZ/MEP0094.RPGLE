     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management                                   *
      *                                                               *
      *  MEP0094   - STP Repair Function. Repair Settlement value     *
      *              date depending on the Currency                   *
      *                                                               *
      *  Function:  This Repair function checks the Settlement date   *
      *             on the message (field 32A) and the adjust it      *
      *             according to the message currency.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 15Nov11               *
      *  Last Amend No. HVB015  *CREATE    Date 15Nov11               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP Enhancements to Midas Plus level.     *
      *  HVB015 - STP Repair - Adjust value date based on Message     *
      *           currency.                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** List of Main currencies and the day when payment can be made
     FFTMCCYP0  IF   E           K DISK
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

      /COPY MECPYSRC,ME1100_ILE
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *?External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      *?External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      *? Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D PCRIT         E DS                  EXTNAME(MEGNCRPD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D  WUFDDT                 1    256
     D  WUMTAG                 1      5
     D  WUFDIN                 6      6
     D  WUTGCK                 6    256
     D  WUTGVL                 7    256
     D  WUACCO                 7     30
     D  WUCNUM                 7     12  0
     D  WUCNUA                 7     12
     D  WUCURR                13     15
     D  WUACCD                16     25  0
     D  WUACCA                16     25
     D  WUACSQ                26     27  0
     D  WUACSA                26     27
     D  WUBRCA                28     30
     D  WUORIG                31    256
     D  LINE1                 31     65
     D  LINE2                 66    100
     D  LINE3                101    135
     D  LINE4                136    170
     D  LINE5                171    205
     D  SLASH                 31     31
     D  WUO                   31    256
      *
      *?Work Variables
     D W_Today         S                   Like(BJRDNB)

     D P_SettWork      S              5  0
     D W_SettWork      S              5  0
     D P_PayWork       S              5  0

     D P_SettWork6     S              6
     D P_SettWork6N    S              6  0

     D ErrorFlag       S              1

      *?Day Count Variables
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

      *?Data Structure to change date format
     D  DateFormat     DS
     D  WDay                   1      2
     D  WMonth                 3      4
     D  WYear                  5      6

      *?Entry parameters

      *?INPUT TAG DESCRIPTION - Data to be
     D  P#RPP1         DS
     D  FLAG1                  1      1  0
     D  P_SettDate            26     31
     D  SettCcy               32     34
     D  Set_Ammount           35     50
     D  REST1                 51    251

      *?REPAIRED TAG DESCRIPTION - Repaired data
     D  P#RPP2         DS
     D  FLAG2                  1      1  0
     D  P_SettDateOut         26     31
     D  REST2                 32    251

     D DIGITS          C                   CONST('0123456789')
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


      *
     C                   If        P_SettDate <> *Zeros  And
     C                             SettCcy <> *Blanks
      *
      ** The date in field 32A is in YYMMDD format.  This date needs to be converted
      *  date format of the system.
     C                   Eval      WYear = %Subst(P_SettDate:1:2)
     C                   Eval      WMonth = %Subst(P_SettDate:3:2)
     C                   Eval      WDay = %Subst(P_SettDate:5:2)
      *
     C                   If        BJDFIN = 'M'
     C                   Eval      P_SettWork6 = WMonth + WDay + WYear
     C                   Else
     C                   Eval      P_SettWork6 = WDay + WMonth + WYear
     C                   EndIf
      *
      *  Convert the settlement date and payment date to Midas dates (5,0)
     C                   CallB     'ZDATE1'
     C                   Parm                    P_SettWork6
     C                   Parm      *Zeros        P_SettWork
     C                   Parm                    BJDFIN
     C                   Parm      *Blank        ErrorFlag
      *
     C                   If        ErrorFlag = 'Y'
     C                   Eval      DbFile = 'ZDATE1  '
     C                   Eval      DBase = 2
     C                   Eval      DBkey = 'P_SettDate'
     C                   Exsr      *PSSR
     C                   Endif
      *
      ** Store the date
     C                   Z-ADD     P_SettWork    W_SettWork
      *
     C                   ExSr      SRNextWD
      *
      ** Check if the date changed
     C     P_SettWork    IfNe      W_SettWork
      *
      ** Convert work fields back to 6,0
     C                   CallB     'ZDATE2'
     C                   Parm                    P_SettWork
     C                   Parm                    BJDFIN
     C                   Parm      *Zeros        P_SettWork6N
     C                   Parm      *Blanks       Dummy             7
      *
     C                   Move      *Blanks       P_SettWork6
     C                   Move      P_SettWork6N  P_SettWork6
      *
      ** The date in field 32A is in YYMMDD format.  The calculated date needs to
      *  converted back to this format.
     C                   If        BJDFIN = 'M'
     C                   Eval      WMonth = %Subst(P_SettWork6:1:2)
     C                   Eval      WDay = %Subst(P_SettWork6:3:2)
     C                   Eval      WYear = %Subst(P_SettWork6:5:2)
     C                   Else
     C                   Eval      WDay = %Subst(P_SettWork6:1:2)
     C                   Eval      WMonth = %Subst(P_SettWork6:3:2)
     C                   Eval      WYear = %Subst(P_SettWork6:5:2)
     C                   EndIf
      *
     C                   Eval      P_SettDateOut = WYear + WMonth + WDay
      *
     C                   MOVEL     '*MAP'        P#RETN
      *
     C                   Endif
      *
     C                   Endif
      *  Exit program
     C                   SETON                                        LR
      *
     C                   Return
      **
      *****************************************************************
      *  SRNextWD   - Find the next working day                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRNextWD      BEGSR
      *
      ** Get currency details - Spot days
     C                   Exsr      SRCurr
      *
      ** Set default location for holiday check by program ZFWDT
     C                   Eval      SettDateLoc = '***'
      *
      ** If back value then change the date to today's date
     C     P_SettWork    IfLT      W_Today
     C                   Z-ADD     W_Today       InputDate
     C                   Else
     C                   Z-ADD     P_SettWork    InputDate
     C                   Endif
      *
      ** Check if the Message currency is one of the main currencies
     C     SettCcy       Chain     FTMCCYD0                           92
     C     *IN92         IfEq      *OFF
      *  It is one of the main currencies
      *
     C                   SELECT
      *
      ** Today  - No adjustment required
     C     FTTDAY        WhenEq    'Y'
      ** Check if date is holiday and if so move to date to next working date
     C                   Z-ADD     0             DaysFwd
      *
      ** Next day  - Move date by one working day
     C     FTNDAY        WhenEq    'Y'
     C                   Z-ADD     1             DaysFwd
      *
      ** Spot days - Move to Spot date
     C     FTSDAY        WhenEq    'Y'
     C                   Z-ADD     A6SPDY        DaysFwd
      *
     C                   EndSl
      *
     C                   Else
      ** Not a main currency - add Spot days to value date
     C                   Z-ADD     A6SPDY        DaysFwd
      *
     C                   EndIf
      *
     C                   ExSr      SRFWDate
      *
     C                   Z-ADD     OutPutDate    P_SettWork
      *
     C                   EndSr
      *
      *****************************************************************
      *  SRCurr     - Get Currency Details                            *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCurr        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    SettCCy
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * Database error
     C                   If        @Rtcd <> *Blanks
     C                   Eval      DbFile = 'SDCURRPD'
     C                   Eval      DBase = 3
     C                   Eval      DBkey = @Optn
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      *  SRFWDate   - Get next forward date                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      *****************************************************************
     C     SRFWDate      BEGSR
      *
     C                   CallB     'ZFWDT'
     C                   Parm                    InputDate         5 0
     C                   Parm                    DaysFwd           2 0
     C                   Parm                    OutPutDate        5 0
     C                   Parm                    SettCCy
     C                   Parm                    SettDateLoc
      *
     C                   EndSr
      *
      /EJECT
      *****************************************************************
      *  INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      *?Entry parameters:
     C     *Entry        Plist
      *
      *  Return Code
     C                   Parm                    P#RETN            7
      *  General Details
     C                   Parm                    PHEAD
      *  Message Details
     C                   Parm                    PDATA
      *  Message Details
     C                   PARM                    PDAT2
     C                   PARM                    P#RPP1
     C                   PARM                    P#RPP2
     C                   PARM                    PCRIT

      *?Initialise program name
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
      ********************************************************************
      /EJECT
      *****************************************************************
      *  Program, module and procedure names for database error processing.
      *  =================================================================
      *  The following /COPY sets these values, and also defines LDA as
      *  an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2011
