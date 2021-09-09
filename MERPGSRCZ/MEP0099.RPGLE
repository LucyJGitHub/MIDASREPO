     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management                                   *
      *                                                               *
      *  MEP0099   - STP Check Function. Check if the value date      *
      *              is holiday in the message currency               *
      *                                                               *
      *  Function:  This Check Function checks the value date on the  *
      *             message and returns 'TRUE' if it falls on a       *
      *             holiday according to the message currency.        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 15Nov11               *
      *  Last Amend No. HVB020  *CREATE    Date 15Dec11               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP Enhancements to Midas Plus level.     *
      *  HVB020 -   TB Check Function - Check if Value date falls on  *
      *             holiday.                                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *  Message parts file for currency of payment
     FMEINMPL1  IF   E           K DISK
      *
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

      *? Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D PCRIT         E DS                  EXTNAME(MEGNCRPD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      *?Entry parameters
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

     D P_SettWork6     S              6
     D P_SettWork6N    S              6  0

     D  SettDateLoc    S              3
     D  HolInd         S              1
     D  P_SettDate     S              6
     D  SettCcy        S              3

     D ErrorFlag       S              1

      *?Data Structure to change date format
     D  DateFormat     DS
     D  WDay                   1      2
     D  WMonth                 3      4
     D  WYear                  5      6


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

     C                   Z-ADD     PHMSGR        KPMSGR
     C                   Z-ADD     PHPART        KPKPRT

      * Get currency and Payment date of the message
     C     KINMP         CHAIN     @INMPL1                            91
      *
      * When message not found - skip the rest of processing
      *
     C     *IN91         IfEq      *OFF
      *
     C                   Eval      P_SettDate = MPSVDT
     C                   Eval      SettCcy = MPCYCD
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
      ** Check if the date falls on holiday of the currency
     C                   CallB     'ZCHKH'
     C                   Parm                    InputDate         5 0
     C                   Parm                    SettCcy
     C                   Parm                    SettDateLoc
     C                   Parm      *Blanks       HolInd
      *
     C                   If        HolInd <> 'W'
     C                   MoveL     'T'           P#RETN
     C                   Endif
      *
     C                   Endif
     C                   Endif
      *  Exit program
     C                   SETON                                        LR
      *
     C                   Return
      **
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
     C     *LIKE         DEFINE    WUTGCK        P@IN

      *?Entry parameters:
     C     *Entry        Plist
      *  Return Code
     C                   Parm                    P#RETN            7
      *
     C     WUFDDT        PARM                    P@IN
      *
     C                   PARM                    P#PTTN           32
     C                   PARM                    GDOPER            2
      *  General Details
     C                   Parm                    PHEAD
      *  Message Details
     C                   Parm                    PDATA
      *  Message Details
     C                   PARM                    PDAT2
     C                   PARM                    PCRIT

      *?Initialise program name
     C                   Eval      DBPGM = PsProcPgm

      * If true put T
     C                   MOVEL     'F'           P#RETN

      *  Key list to access MEINMPPD
     C     KINMP         KLIST
     C                   KFLD                    KPMSGR            8 0
     C                   KFLD                    KPKPRT            3 0
      *
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
