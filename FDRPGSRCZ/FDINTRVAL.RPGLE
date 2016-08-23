     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM Int. Rates Validation')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module.                                   *
      *                                                               *
      *  FDINTRVAL - MM Interest Rates record Validation              *
      *                                                               *
      *  Function: This Program Validates MM Interest Rates for       *
      *            input into the Midas database.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR851109           Date 11Mar15               *
      *  Prev Amend No. MD030904           Date 08Oct14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196570             Date 18Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 01May01               *
      *                 CAP058             Date 01May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP005  *CREATE    Date 17Oct98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR851109 - Cannot enter -ve rates. Applied for MD033488.     *
      *  MD030904 - Serious midas error encountered when all fields   *
      *             were inputted with invalid data. Stop validation  *
      *             when too many errors are encountered.             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  196570 - Patch for Market Data Feed                          *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP058 - Full API for Money Market Interest Rates            *
      *  CAP005 - Conversion of Citydealer Rates upload to use APIs   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
                                                                                CSD006
      ** MDF Request Details by Request Id                                      CSD006
     FSDMDFRL1  IF   E           K DISK    INFSR(*PSSR)                         CSD006
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** Borrowing Rates - alpha format.
     D BORRA           S             12    DIM(21)
 
      ** Borrowing Rates Error Indicators
     D BORREI          S              1    DIM(21)
 
      ** Lending Rates - alpha format.
     D LENDA           S             12    DIM(21)
 
      ** Lending Rates Error Indicators
     D LENDEI          S              1    DIM(21)
 
 
      * Incoming MM Interest Rates record
     D*TranIn1***    E DS                  EXTNAME(FDINTR1PD)                   CAP058
     D*TranIn2***    E DS                  EXTNAME(FDINTR2PD)                   CAP058
     D TranIn        E DS                  EXTNAME(FDINTRPD)                    CAP058
 
 
      * Valid MM Interest Rates record layout
      ** Borrowing Rates
     D ValidINTR     E DS                  EXTNAME(FDVINTRPD)
     D  @@BR                  31    156P 7
     D                                     DIM(21)
      ** Lending Rates
     D  @@LR                 157    282P 7
     D                                     DIM(21)
                                                                                CAP058
      ** Previous Interest Rates Detail in File Format                          CAP058
     D PrvIRFilFmt   E DS                  EXTNAME(FDVINTRPD)                   CAP058
     D                                     PREFIX(P)                            CAP058
      ** Borrow Rates                                                           CAP058
     D  PrvBR                 31    156P 7                                      CAP058
     D                                     DIM(21)                              CAP058
      ** Lending Rates                                                          CAP058
     D  PrvLR                157    282P 7                                      CAP058
     D                                     DIM(21)                              CAP058
 
 
      * MM Interest Rates Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(FDIREXPD)
                                                                                CAP058
      ** Interest Rates Validation Workfields                                   CAP058
     D ValWrkFlds    E DS                  EXTNAME(FDWINTRPD)                   CAP058
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
                                                                                CSD006
     D SDMDFC        E DS                  EXTNAME(SDMDFCPD)                    CSD006
      ** External DS for Market Data Feeds ICD                                  CSD006
                                                                                CSD006
     D SDMAPC        E DS                  EXTNAME(SDMAPCPD)                    CSD006
      ** External DS for Market Data Feeds Mapping Codes                        CSD006
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                CAP058
     D TimeStampDS     DS                                                       CAP058
      ** Timestamp data structure (Century, Year, Month, Day, Hour, Minute      CAP058
      ** and Second)                                                            CAP058
     D WCENT                   1      2  0                                      CAP058
     D WYEAR                   3      4  0                                      CAP058
     D WMONTH                  5      6  0                                      CAP058
     D WDAY                    7      8  0                                      CAP058
     D WTIME                   9     14  0                                      CAP058
                                                                                CAP058
     D TStmpValDS      DS                                                       CAP058
      ** Timestamp data structure for Validation                                CAP058
     D WCNTD                   1      2  0                                      CAP058
     D WDATE                   3      8  0                                      CAP058
     D  WDAT1                         2  0 OVERLAY (WDATE:1)                    CAP058
     D  WDAT2                         2  0 OVERLAY (WDATE:3)                    CAP058
     D  WYRD                          2  0 OVERLAY (WDATE:5)                    CAP058
     D WTMED                   9     14  0                                      CAP058
     D WTSTMP                  3     14                                         CAP058
                                                                                CAP058
     D SysTmeDtDS      DS                                                       CAP058
      ** Current system time and date                                           CAP058
     D WSTMEDTE                1     12S 0                                      CAP058
     D WSYSTIME                1      6S 0                                      CAP058
     D WSYSDATE                7     12S 0                                      CAP058
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                AR851109
      ** External DS for dealing details                                                    AR851109
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FDEINTRPD)
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
                                                                                CAP058
      ** Previous Borrow and Lending Rates                                      CAP058
     D WPRVBRC         S             12A                                        CAP058
     D WPRVBRN         S             11P 7                                      CAP058
     D WPRVLEC         S             12A                                        CAP058
     D WPRVLEN         S             11P 7                                      CAP058
                                                                                CAP058
      ** Interest Rate Tolerance Exceeded workfield                             CSD006
     D WTLEX           S              1A                                        CSD006
                                                                                CAP058
      ** Date in DDMMYY/MMDDYY format                                           CAP058
     D WDATEDD         S               D   DATFMT(*DMY)                         CAP058
     D WDATEMM         S               D   DATFMT(*MDY)                         CAP058
                                                                                CAP058
      ** Difference between the previous and the new rate                       CAP058
     D WDIFF           S             13P 8                                      CAP058
     D*WACTRDIF********S*************15P 8                                      CAP058        196570
     D WACTRDIF        S             29P 8                                                    196570
                                                                                CAP058
      ** Workfields used by ZA0920 in formatting rates                          CAP058
     D WRTCD           S             10                                         CAP058
     D WAMTNUM         S             13  0                                      CAP058
     D WNODEC          S              1  0                                      CAP058
     D WSEPA           S              1                                         CAP058
     D WAMTCHR         S             14                                         CAP058
                                                                                CAP058
      ** Mapping Code                                                           CSD006
     D PMAPCD          S             32                                         CSD006
                                                                                CAP058
      ** Mode of operation                                                      CAP058
     D ModeOfOp        S              6A                                        CAP058
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,FDINTRV001
 
      * Initial processing to be executed on each call.
 
     C                   EXSR      INIT
                                                                                CAP058
      ** Validate Inputs                                                        CAP058
                                                                                CAP058
     C                   EXSR      SrVALINPUT                                   CAP058
      *****************************************************************         CAP058
      **Do*Validation**************************************************         CAP058
      *****************************************************************         CAP058
     C***********        EXSR      VINTRATES                                    CAP058
 
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
      /COPY WNCPYSRC,FDINTRV002
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
 
      /COPY WNCPYSRC,FDINTRV003
      *
      * Return.
      *
     C                   RETURN
      *****************************************************************         CAP058
      /EJECT                                                                    CAP058
      *****************************************************************         CAP058
      *                                                               *         CAP058
      * SrVALINPUT - Validate Inputs                                  *         CAP058
      *                                                               *         CAP058
      *****************************************************************         CAP058
     C     SrVALINPUT    BEGSR                                                  CAP058
                                                                                CAP058
      ** Reset variables updated by this routine.                               CAP058
                                                                                CAP058
     C                   EXSR      RESETERRS                                    CAP058
                                                                                CSD006
      ** Validate MDF screen field only when CSD006 is On.                      CSD006
                                                                                CSD006
     C     CSD006        IFEQ      'Y'                                          CSD006
                                                                                CSD006
      ** Validate Data Request Id                                               CSD006
                                                                                CSD006
     C                   EXSR      SrVALDRID                                    CSD006
                                                                                CSD006
      ** Validate Time Stamp                                                    CSD006
                                                                                CSD006
     C                   EXSR      SrVALSTMP                                    CSD006
     C                   ENDIF                                                  CSD006
                                                                                CAP058
      ** Validate Interest Rates                                                CAP058
                                                                                CAP058
     C                   EXSR      VINTRATES                                    CAP058
                                                                                CAP058
      ** Update error info with that produced by this subroutine.               CAP058
                                                                                CAP058
     C                   EXSR      UPDATERRS                                    CAP058
                                                                                CAP058
     C                   ENDSR                                                  CAP058
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VINTRATES - Validate Interest Rates
      *****************************************************************
     C     VINTRATES     BEGSR
      *****************************************************************         CAP058
      **Reset*variables*updated*by*this*routine.***********************         CAP058
      *****************************************************************         CAP058
     C***********        EXSR      RESETERRS                                    CAP058
     C                   EVAL      WTLEX = 'N'                                  CSD006
      *
      ** Validate all 21 borrow and lend rates
      *
     C                   Z-ADD     1             N                 2 0
      *
     C     N             DOWLE     21
     C*****Idx***        ANDLE     10                                           CAP058
     C     Idx           ANDLE     10                                                       MD030904
      *
      * Borrowing rate must be defined
      * ==============================
      *
                                                                                CAP058
      ** For years 2 to 10, default to previous borrow rate if not entered      CAP058
                                                                                CAP058
     C     N             IFGT      12                                           CAP058
     C     BORRA(N)      ANDEQ     *BLANK                                       CAP058
     C                   IF        (BORREI(N-1) = 'Y')                          CAP058
     C                   MOVEL     WPRVBRC       BORRA(N)                       CAP058
     C                   Z-ADD     WPRVBRN       @@BR(N)                        CAP058
     C                   ENDIF                                                  CAP058
     C                   ELSE                                                   CAP058
     C     BORRA(N)      IFEQ      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'FDM0492'
     C                   MOVEL     'DDBR      '  RateFld          10
     C                   EXSR      SetRateFld
     C                   EVAL      FldNamXAr (Idx) = RateFld
     C                   EVAL      BORREI(N) = 'N'
     C                   ELSE
      *
      * Validate and right align borrowing rate
      * and move from alpha to numeric.
      *
     C                   Z-ADD     4             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      BORRA(N)      ZFIELD
      *
     C**********         CALLB     'ZALIGN'                                                 AR851109
     C**********         PARM      *BLANKS       ZRTN              1                        AR851109
     C**********         PARM                    ZFIELD           16                        AR851109
     C**********         PARM                    ZADEC             1 0                      AR851109
     C**********         PARM                    ZADIG             2 0                      AR851109
                                                                                            AR851109
     C                   CALLB     'ZA0841'                                                 AR851109
     C                   PARM      *BLANK        RetCodeOut                                 AR851109
     C                   PARM                    ZFIELD           16                        AR851109
     C                   PARM                    ZADEC             3 0                      AR851109
     C                   PARM                    ZADIG             3 0                      AR851109
     C                   PARM      'N'           @@MTID            1                        AR851109
     C                   PARM      *ZERO         @@ERCD            1 0                      AR851109
     C                   PARM      *ZERO         @@AMT            15 0                      AR851109
     C                   PARM                    BNDCSP                                     AR851109
      *
      * Check that rate is numeric.
      *
     C*****ZRTN*         IFEQ      'N'                                                      AR851109
     C     @@ERCD        IFEQ      1                                                        AR851109
     C     @@ERCD        OREQ      2                                                        AR851109
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'FDM0494'
     C                   MOVEL     'DDBR      '  RateFld
     C                   EXSR      SetRateFld
     C                   EVAL      FldNamXAr (Idx) = RateFld
     C                   EVAL      BORREI(N) = 'N'
     C                   ELSE
      *
      * Check that rate is positive.
      *
     C**********         MOVE      ZFIELD        @@BR(N)                                    AR851109
     C                   MOVE      @@AMT         @@BR(N)                                    AR851109
      *
     C*****@@BR(N)       IFLE      0                                            CAP058
     C*****@@BR(N)       IFLT      0                                                 CAP058 AR851109
     C**********         ADD       1             Idx                                        AR851109
     C**********         EVAL      MsgIDXAr(Idx) = 'FDM0494'                                AR851109
     C**********         MOVEL     'DDBR      '  RateFld                                    AR851109
     C**********         EXSR      SetRateFld                                               AR851109
     C**********         EVAL      FldNamXAr (Idx) = RateFld                                AR851109
     C**********         EVAL      BORREI(N) = 'N'                                          AR851109
     C**********         ELSE                                                        CAP058 AR851109
                                                                                CAP058
      ** Format Rate                                                            CAP058
                                                                                CAP058
     C                   EVAL      WAMTNUM = *ZERO                              CAP058
     C                   MOVE      @@BR(N)       WAMTNUM                        CAP058
     C                   EXSR      SrFMTDET                                     CAP058
     C                   MOVE      WAMTCHR       BORRA(N)                       CAP058
     C**********         ENDIF                                                              AR851109
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * Lending rate must be defined
      * ============================
      *                                                                         CAP058
                                                                                CAP058
      ** For years 2 to 10, default to previous lending rate if not entered     CAP058
                                                                                CAP058
     C     N             IFGT      12                                           CAP058
     C     LENDA(N)      ANDEQ     *BLANK                                       CAP058
     C                   IF        (LENDEI(N-1) = 'Y')                          CAP058
     C                   MOVEL     WPRVLEC       LENDA(N)                       CAP058
     C                   Z-ADD     WPRVLEN       @@LR(N)                        CAP058
     C                   ENDIF                                                  CAP058
     C                   ELSE                                                   CAP058
     C     LENDA(N)      IFEQ      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'FDM0492'
     C                   MOVEL     'DDLR      '  RateFld
     C                   EXSR      SetRateFld
     C                   EVAL      FldNamXAr (Idx) = RateFld
     C                   EVAL      LENDEI(N) = 'N'
     C                   ELSE
      *
      * Validate and right align lending rate
      * and move from alpha to numeric.
      *
     C                   Z-ADD     4             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      LENDA(N)      ZFIELD
      *
     C**********         CALLB     'ZALIGN'                                                 AR851109
     C**********         PARM      *BLANKS       ZRTN              1                        AR851109
     C**********         PARM                    ZFIELD           16                        AR851109
     C**********         PARM                    ZADEC             1 0                      AR851109
     C**********         PARM                    ZADIG             2 0                      AR851109
      *                                                                                     AR851109
     C                   CALLB     'ZA0841'                                                 AR851109
     C                   PARM      *BLANK        RetCodeOut                                 AR851109
     C                   PARM                    ZFIELD           16                        AR851109
     C                   PARM                    ZADEC             3 0                      AR851109
     C                   PARM                    ZADIG             3 0                      AR851109
     C                   PARM      'N'           @@MTID            1                        AR851109
     C                   PARM      *ZERO         @@ERCD            1 0                      AR851109
     C                   PARM      *ZERO         @@AMT            15 0                      AR851109
     C                   PARM                    BNDCSP                                     AR851109
      *
      * Check that rate is numeric.
      *
     C*****ZRTN*         IFEQ      'N'                                                      AR851109
     C     @@ERCD        IFEQ      1                                                        AR851109
     C     @@ERCD        OREQ      2                                                        AR851109
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'FDM0494'
     C                   MOVEL     'DDLR      '  RateFld
     C                   EXSR      SetRateFld
     C                   EVAL      FldNamXAr (Idx) = RateFld
     C                   EVAL      LENDEI(N) = 'N'
     C                   ELSE
      *
      * Check that rate is positive.
      *
     C**********         MOVE      ZFIELD        @@LR(N)                                    AR851109
     C                   MOVE      @@AMT         @@LR(N)                                    AR851109
      *
     C*****@@LR(N)       IFLE      0                                            CAP058
     C*****@@LR(N)       IFLT      0                                                 CAP058 AR851109
     C**********         ADD       1             Idx                                        AR851109
     C**********         EVAL      MsgIDXAr(Idx) = 'FDM0494'                                AR851109
     C**********         MOVEL     'DDLR      '  RateFld                                    AR851109
     C**********         EXSR      SetRateFld                                               AR851109
     C**********         EVAL      FldNamXAr (Idx) = RateFld                                AR851109
     C**********         EVAL      LENDEI(N) = 'N'                                          AR851109
     C**********         ELSE                                                        CAP058 AR851109
                                                                                CAP058
      ** Format Rate                                                            CAP058
                                                                                CAP058
     C                   EVAL      WAMTNUM = *ZERO                              CAP058
     C                   MOVE      @@LR(N)       WAMTNUM                        CAP058
     C                   EXSR      SrFMTDET                                     CAP058
     C                   MOVE      WAMTCHR       LENDA(N)                       CAP058
     C**********         ENDIF                                                              AR851109
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  CAP058
      *
      ** When spot days are 1, the spot/next must be the same as
      ** tomorrow/next.
      *
     C     A6SPDY        IFEQ      1
     C     N             ANDEQ     3
     C     @@BR(2)       ANDNE     @@BR(3)
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'FDM0495'
     C                   MOVEL     'DDBR      '  RateFld
     C                   EXSR      SetRateFld
     C                   EVAL      FldNamXAr (Idx) = RateFld
     C                   EVAL      BORREI(N) = 'N'
     C                   ENDIF
     C     A6SPDY        IFEQ      1
     C     N             ANDEQ     3
     C     @@LR(2)       ANDNE     @@LR(3)
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'FDM0495'
     C                   MOVEL     'DDLR      '  RateFld
     C                   EXSR      SetRateFld
     C                   EVAL      FldNamXAr (Idx) = RateFld
     C                   EVAL      LENDEI(N) = 'N'
     C                   ENDIF
      *
      ** The lend rate must be greater or equal to the borrow rate
      *
     C     BORREI(N)     IFNE      'N'
     C     LENDEI(N)     ANDNE     'N'
     C     @@LR(N)       ANDLT     @@BR(N)
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'FDM0493'
     C                   MOVEL     'DDLR      '  RateFld
     C                   EXSR      SetRateFld
     C                   EVAL      FldNamXAr (Idx) = RateFld
     C                   EVAL      LENDEI(N) = 'N'
     C                   ENDIF
                                                                                CSD006
      ** Check if rate does not exceed interest rate tolerance                  CSD006
                                                                                CSD006
     C     CSD006        IFEQ      'Y'                                          CSD006
     C                   IF        (WSETMAX = 'N') AND (DDDTFR <> *BLANK)       CSD006
     C                             AND (DDACTN = 'A')                           CSD006
     C                   IF        (WTLEX = 'N')                                CSD006
                                                                                CSD006
      ** Validate against the given tolerance in the MDF ICD                    CSD006
                                                                                CSD006
     C                   EXSR      SrTOLERNCE                                   CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** Save previous borrow and lend rates if no errors                       CAP058
                                                                                CAP058
     C                   MOVE      *BLANK        WPRVBRC                        CAP058
     C                   Z-ADD     *ZEROS        WPRVBRN                        CAP058
     C                   MOVE      *BLANK        WPRVLEC                        CAP058
     C                   Z-ADD     *ZEROS        WPRVLEN                        CAP058
                                                                                CAP058
     C     BORREI(N)     IFEQ      'Y'                                          CAP058
     C                   MOVEL     BORRA(N)      WPRVBRC                        CAP058
     C                   Z-ADD     @@BR(N)       WPRVBRN                        CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
     C     LENDEI(N)     IFEQ      'Y'                                          CAP058
     C                   MOVEL     LENDA(N)      WPRVLEC                        CAP058
     C                   Z-ADD     @@LR(N)       WPRVLEN                        CAP058
     C                   ENDIF                                                  CAP058
      *
     C                   ADD       1             N
      *
     C                   ENDDO
                                                                                CAP058
      ** Move the values back to screen fields, so that defaulted values        CAP058
      ** would also be displayed                                                CAP058
                                                                                CAP058
     C                   EXSR      SrMOVFLD                                     CAP058
      *****************************************************************         CAP058
      **Update*error*info*with*that*produced*by*this*subroutine.*******         CAP058
      *****************************************************************         CAP058
     C***********        EXSR      UPDATERRS                                    CAP058
      *
     C                   ENDSR
      *****************************************************************         CAP058
      /EJECT                                                                    CAP058
      *****************************************************************         CAP058
      *                                                               *         CAP058
      * SrFMTDET - Format Interest Rate Details                       *         CAP058
      *                                                               *         CAP058
      *****************************************************************         CAP058
     C     SrFMTDET      BEGSR                                                  CAP058
                                                                                CAP058
      ** Format Borrow/Lending Rates                                            CAP058
                                                                                CAP058
     C                   CALLB     'ZA0920'                                     CAP058
     C                   PARM      *BLANK        WRTCD                          CAP058
     C                   PARM                    WAMTNUM                        CAP058
     C                   PARM      7             WNODEC                         CAP058
     C                   PARM      '.'           WSEPA                          CAP058
     C                   PARM      *BLANK        WAMTCHR                        CAP058
                                                                                CAP058
      ** Error calling module                                                   CAP058
                                                                                CAP058
     C                   IF        WRTCD <> *BLANK                              CAP058
     C                   MOVEL     'ZA0920  '    DBFILE                         CAP058
     C                   Z-ADD     5             DBASE                          CAP058
     C                   MOVEL     '*CALL   '    DBKEY                          CAP058
     C                   EXSR      *PSSR                                        CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
     C                   ENDSR                                                  CAP058
      *****************************************************************         CAP058
     C/EJECT                                                                    CAP058
      *****************************************************************         CAP058
      *                                                               *         CAP058
      * SrMOVFLD - Move Rates to Screen Fields                        *         CAP058
      *                                                               *         CAP058
      *****************************************************************         CAP058
     C     SrMOVFLD      BEGSR                                                  CAP058
                                                                                CAP058
      ** Set up borrowing rates screen field                                    CAP058
                                                                                CAP058
     C                   EVAL      DDBR01 = BORRA(1)                            CAP058
     C                   EVAL      DDBR02 = BORRA(2)                            CAP058
     C                   EVAL      DDBR03 = BORRA(3)                            CAP058
     C                   EVAL      DDBR04 = BORRA(4)                            CAP058
     C                   EVAL      DDBR05 = BORRA(5)                            CAP058
     C                   EVAL      DDBR06 = BORRA(6)                            CAP058
     C                   EVAL      DDBR07 = BORRA(7)                            CAP058
     C                   EVAL      DDBR08 = BORRA(8)                            CAP058
     C                   EVAL      DDBR09 = BORRA(9)                            CAP058
     C                   EVAL      DDBR10 = BORRA(10)                           CAP058
     C                   EVAL      DDBR11 = BORRA(11)                           CAP058
     C                   EVAL      DDBR12 = BORRA(12)                           CAP058
     C                   EVAL      DDBR13 = BORRA(13)                           CAP058
     C                   EVAL      DDBR14 = BORRA(14)                           CAP058
     C                   EVAL      DDBR15 = BORRA(15)                           CAP058
     C                   EVAL      DDBR16 = BORRA(16)                           CAP058
     C                   EVAL      DDBR17 = BORRA(17)                           CAP058
     C                   EVAL      DDBR18 = BORRA(18)                           CAP058
     C                   EVAL      DDBR19 = BORRA(19)                           CAP058
     C                   EVAL      DDBR20 = BORRA(20)                           CAP058
     C                   EVAL      DDBR21 = BORRA(21)                           CAP058
                                                                                CAP058
      ** Set up lending rates screen field                                      CAP058
                                                                                CAP058
     C                   EVAL      DDLR01 = LENDA(1)                            CAP058
     C                   EVAL      DDLR02 = LENDA(2)                            CAP058
     C                   EVAL      DDLR03 = LENDA(3)                            CAP058
     C                   EVAL      DDLR04 = LENDA(4)                            CAP058
     C                   EVAL      DDLR05 = LENDA(5)                            CAP058
     C                   EVAL      DDLR06 = LENDA(6)                            CAP058
     C                   EVAL      DDLR07 = LENDA(7)                            CAP058
     C                   EVAL      DDLR08 = LENDA(8)                            CAP058
     C                   EVAL      DDLR09 = LENDA(9)                            CAP058
     C                   EVAL      DDLR10 = LENDA(10)                           CAP058
     C                   EVAL      DDLR11 = LENDA(11)                           CAP058
     C                   EVAL      DDLR12 = LENDA(12)                           CAP058
     C                   EVAL      DDLR13 = LENDA(13)                           CAP058
     C                   EVAL      DDLR14 = LENDA(14)                           CAP058
     C                   EVAL      DDLR15 = LENDA(15)                           CAP058
     C                   EVAL      DDLR16 = LENDA(16)                           CAP058
     C                   EVAL      DDLR17 = LENDA(17)                           CAP058
     C                   EVAL      DDLR18 = LENDA(18)                           CAP058
     C                   EVAL      DDLR19 = LENDA(19)                           CAP058
     C                   EVAL      DDLR20 = LENDA(20)                           CAP058
     C                   EVAL      DDLR21 = LENDA(21)                           CAP058
                                                                                CAP058
     C                   ENDSR                                                  CAP058
      *****************************************************************         CAP058
     C/EJECT                                                                    CSD006
      *****************************************************************         CSD006
      *                                                               *         CSD006
      * SrVALDRID - Validate Data Request Id                          *         CSD006
      *                                                               *         CSD006
      *****************************************************************         CSD006
     C     SrVALDRID     BEGSR                                                  CSD006
                                                                                CSD006
      ** Initialise API Request type workfield                                  CSD006
                                                                                CSD006
     C                   EVAL      WAPIT = *BLANK                               CSD006
                                                                                CSD006
      ** If the Request Data Id is entered, check to Request Details File       CSD006
      ** if existing                                                            CSD006
                                                                                CSD006
     C     DDDTFR        IFNE      *BLANK                                       CSD006
                                                                                CSD006
     C     DDDTFR        CHAIN     SDMDFRL1                           81        CSD006
                                                                                CSD006
      ** Access Market Data Feed Mapping Code to get the Request type           CSD006
                                                                                CSD006
     C     *IN81         IFEQ      FALSE                                        CSD006
     C                   CALL      'AOMAPCR0'                                   CSD006
     C                   PARM      *BLANK        @RTCD                          CSD006
     C                   PARM      '*KEY   '     @OPTN                          CSD006
     C                   PARM      MRMAPC        PMAPCD                         CSD006
     C     SDMAPC        PARM      SDMAPC        DSFDY                          CSD006
                                                                                CSD006
      ** Database error                                                         CSD006
                                                                                CSD006
     C     @RTCD         IFNE      *BLANKS                                      CSD006
     C                   MOVEL     'SDMAPCPD'    DBFILE                         CSD006
     C                   Z-ADD     4             DBASE                          CSD006
     C                   MOVEL     MRMAPC        DBKEY                          CSD006
     C                   EXSR      *PSSR                                        CSD006
     C                   ELSE                                                   CSD006
     C                   EVAL      WAPIT = MCAPIT                               CSD006
     C                   ENDIF                                                  CSD006
     C                   ELSE                                                   CSD006
                                                                                CSD006
      ** Else, Data Request Id not found send warning message                   CSD006
                                                                                CSD006
     C                   EVAL      WIdx = WIdx + 1                              CSD006
     C                   EVAL      WMsgIDXAr(WIdx) = 'FDM0603'                  CSD006
     C                   EVAL      WFldNmXAr(WIdx) = 'DDDFTS'                   CSD006
     C                   EVAL      DDDTFROK = 'N'                               CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
     C                   ENDSR                                                  CSD006
      *****************************************************************         CSD006
     C/EJECT                                                                    CSD006
      *****************************************************************         CSD006
      *                                                               *         CSD006
      * SrVALSTMP - Validate Time Stamp                               *         CSD006
      *                                                               *         CSD006
      *****************************************************************         CSD006
     C     SrVALSTMP     BEGSR                                                  CSD006
                                                                                CSD006
     C                   MOVEL     DDDFTS        TStmpValDS                     CSD006
                                                                                CSD006
      ** Default Century in timestamp                                           CSD006
                                                                                CSD006
     C                   EVAL      WCNTD = 20                                   CSD006
                                                                                CSD006
      ** Validate Date and Time if not blank                                    CSD006
                                                                                CSD006
     C     WTSTMP        IFNE      *BLANK                                       CSD006
                                                                                CSD006
      ** Initialise indicator                                                   CSD006
                                                                                CSD006
     C                   EVAL      *IN80 = FALSE                                CSD006
                                                                                CSD006
     C     BJDFIN        IFEQ      'D'                                          CSD006
     C     *DMY          TEST (D)                WDATE                  80      CSD006
     C                   ELSE                                                   CSD006
     C     *MDY          TEST (D)                WDATE                  80      CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** No Error on Date, validate Time                                        CSD006
                                                                                CSD006
     C     *IN80         IFEQ      FALSE                                        CSD006
     C     *HMS          TEST (T)                WTMED                  80      CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** Error on Date or Time validation, send error message                   CSD006
                                                                                CSD006
     C     *IN80         IFEQ      TRUE                                         CSD006
     C                   EVAL      Idx = Idx + 1                                CSD006
     C                   EVAL      MsgIDXAr(Idx) = 'FDM0602'                    CSD006
     C                   EVAL      FldNamXAr(Idx) = 'DDDFTS'                    CSD006
     C                   EVAL      DDDFTSOK = 'N'                               CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** Default timestamp to current machine date and time when not entered    CSD006
                                                                                CSD006
     C     WTSTMP        IFEQ      *BLANK                                       CSD006
     C     DDDTFR        ANDNE     *BLANK                                       CSD006
     C                   TIME                    WSTMEDTE                       CSD006
     C     BJDFIN        IFEQ      'D'                                          CSD006
     C     *DMY          MOVE      WSYSDATE      WDATEDD                        CSD006
     C                   MOVEL     WDATEDD       WDATE                          CSD006
     C                   ELSE                                                   CSD006
     C     *MDY          MOVE      WSYSDATE      WDATEMM                        CSD006
     C                   MOVEL     WDATEMM       WDATE                          CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
     C                   MOVEL     WSYSTIME      WTMED                          CSD006
                                                                                CSD006
      ** Format timestamp for display                                           CSD006
                                                                                CSD006
     C                   EVAL      DDDFTS = '20' + WTSTMP                       CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
     C                   ENDSR                                                  CSD006
      *****************************************************************         CSD006
     C/EJECT                                                                    CSD006
      *****************************************************************         CSD006
      *                                                               *         CSD006
      * SrTOLERNCE - Validate against the given Tolerance             *         CSD006
      *                                                               *         CSD006
      *****************************************************************         CSD006
     C     SrTOLERNCE    BEGSR                                                  CSD006
                                                                                CSD006
      ** If a new rate was entered, get difference from the previous value      CSD006
                                                                                CSD006
     C                   IF        (@@BR(N) <> PrvBR(N)) AND (WTLEX = 'N')      CSD006
     C                   EVAL      WDIFF = @@BR(N) -  PrvBR(N)                  CSD006
                                                                                CSD006
      ** If negative, make it positive                                          CSD006
                                                                                CSD006
     C                   IF        WDIFF < *ZERO                                CSD006
     C                   Z-SUB     WDIFF         WDIFF                          CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** Get the actual rate difference of the new rate by dividing             CSD006
      ** the difference to that of the previous rate and multiply by            CSD006
      ** 100 to get the actual rate percentage difference                       CSD006
                                                                                CSD006
     C                   IF        PrvBr(N) = 0                                               196570
     C                   EVAL      WACTRDIF = 99                                              196570
     C                   ELSE                                                                 196570
      ** Get absolute value of original rate                                                AR851109
     C                   IF        PrvBR(N) < 0                                             AR851109
     C                   Z-SUB     PrvBR(N)      PrvBR(N)                                   AR851109
     C                   ENDIF                                                              AR851109
     C                   EVAL      WACTRDIF = (WDIFF/PrvBR(N)) * 100            CSD006
     C                   ENDIF                                                                196570
                                                                                CSD006
      ** Check against the tolerance                                            CSD006
                                                                                CSD006
     C                   IF        WACTRDIF > MDIRTL                            CSD006
     C                   EVAL      WTLEX = 'Y'                                  CSD006
     C                   ELSE                                                   CSD006
     C                   EVAL      WTLEX = 'N'                                  CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** If a new rate was entered, get difference from the previous value      CSD006
                                                                                CSD006
     C                   IF        (@@LR(N) <> PrvLR(N)) AND (WTLEX ='N')       CSD006
     C                   EVAL      WDIFF = @@LR(N) -  PrvLR(N)                  CSD006
                                                                                CSD006
      ** If negative, make it positive                                          CSD006
                                                                                CSD006
     C                   IF        WDIFF < *ZERO                                CSD006
     C                   Z-SUB     WDIFF         WDIFF                          CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** Get the actual rate difference of the new rate by dividing             CSD006
      ** the difference to that of the previous rate and multiply by            CSD006
      ** 100  to get the actual rate percentage difference                      CSD006
                                                                                CSD006
     C                   IF        PrvLR(N) <> 0                                            AR851109
      ** Get absolute value of original rate                                                AR851109
     C                   IF        PrvLR(N) < 0                                             AR851109
     C                   Z-SUB     PrvLR(N)      PrvLR(N)                                   AR851109
     C                   ENDIF                                                              AR851109
     C                   EVAL      WACTRDIF = (WDIFF/PrvLR(N)) * 100            CSD006
     C                   ELSE                                                               AR851109
      ** ensure tolerance is exceed as percentage tolerance exceeded                        AR851109
      ** infinitely big                                                                     AR851109
     C                   EVAL      WACTRDIF = MDIRTL +1                                     AR851109
     C                   ENDIF                                                              AR851109
                                                                                CSD006
      ** Check against the tolerance                                            CSD006
                                                                                CSD006
     C                   IF        WACTRDIF > MDIRTL                            CSD006
     C                   EVAL      WTLEX = 'Y'                                  CSD006
     C                   ELSE                                                   CSD006
     C                   EVAL      WTLEX = 'N'                                  CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
     C                   ENDSR                                                  CSD006
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SetRateFld - Set up rate error field when rate is in error.
      *****************************************************************
     C     SetRateFld    BEGSR
      *
      * Add Element number
      *
     C                   MOVE      N             ElementL          2
     C                   EVAL      RateFld = %Trim(RateFld) + ElementL
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
                                                                                CAP058
      ** Move back error indicators                                             CAP058
                                                                                CAP058
     C                   EVAL      DDBR01OK = BORREI(1)                         CAP058
     C                   EVAL      DDBR02OK = BORREI(2)                         CAP058
     C                   EVAL      DDBR03OK = BORREI(3)                         CAP058
     C                   EVAL      DDBR04OK = BORREI(4)                         CAP058
     C                   EVAL      DDBR05OK = BORREI(5)                         CAP058
     C                   EVAL      DDBR06OK = BORREI(6)                         CAP058
     C                   EVAL      DDBR07OK = BORREI(7)                         CAP058
     C                   EVAL      DDBR08OK = BORREI(8)                         CAP058
     C                   EVAL      DDBR09OK = BORREI(9)                         CAP058
     C                   EVAL      DDBR10OK = BORREI(10)                        CAP058
     C                   EVAL      DDBR11OK = BORREI(11)                        CAP058
     C                   EVAL      DDBR12OK = BORREI(12)                        CAP058
     C                   EVAL      DDBR13OK = BORREI(13)                        CAP058
     C                   EVAL      DDBR14OK = BORREI(14)                        CAP058
     C                   EVAL      DDBR15OK = BORREI(15)                        CAP058
     C                   EVAL      DDBR16OK = BORREI(16)                        CAP058
     C                   EVAL      DDBR17OK = BORREI(17)                        CAP058
     C                   EVAL      DDBR18OK = BORREI(18)                        CAP058
     C                   EVAL      DDBR19OK = BORREI(19)                        CAP058
     C                   EVAL      DDBR20OK = BORREI(20)                        CAP058
     C                   EVAL      DDBR21OK = BORREI(21)                        CAP058
                                                                                CAP058
     C                   EVAL      DDLR01OK = LENDEI(1)                         CAP058
     C                   EVAL      DDLR02OK = LENDEI(2)                         CAP058
     C                   EVAL      DDLR03OK = LENDEI(3)                         CAP058
     C                   EVAL      DDLR04OK = LENDEI(4)                         CAP058
     C                   EVAL      DDLR05OK = LENDEI(5)                         CAP058
     C                   EVAL      DDLR06OK = LENDEI(6)                         CAP058
     C                   EVAL      DDLR07OK = LENDEI(7)                         CAP058
     C                   EVAL      DDLR08OK = LENDEI(8)                         CAP058
     C                   EVAL      DDLR09OK = LENDEI(9)                         CAP058
     C                   EVAL      DDLR10OK = LENDEI(10)                        CAP058
     C                   EVAL      DDLR11OK = LENDEI(11)                        CAP058
     C                   EVAL      DDLR12OK = LENDEI(12)                        CAP058
     C                   EVAL      DDLR13OK = LENDEI(13)                        CAP058
     C                   EVAL      DDLR14OK = LENDEI(14)                        CAP058
     C                   EVAL      DDLR15OK = LENDEI(15)                        CAP058
     C                   EVAL      DDLR16OK = LENDEI(16)                        CAP058
     C                   EVAL      DDLR17OK = LENDEI(17)                        CAP058
     C                   EVAL      DDLR18OK = LENDEI(18)                        CAP058
     C                   EVAL      DDLR19OK = LENDEI(19)                        CAP058
     C                   EVAL      DDLR20OK = LENDEI(20)                        CAP058
     C                   EVAL      DDLR21OK = LENDEI(21)                        CAP058
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * INIT - Inital Processing                                      *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
                                                                                CAP058
      ** If amend move previous details to the valid file to include            CAP058
      ** unchanged details.                                                     CAP058
                                                                                CAP058
     C                   IF        (DDACTN = 'A')                               CAP058
     C                   EVAL      ValidINTR = PrvIRFilFmt                      CAP058
     C                   ENDIF                                                  CAP058
      *
      * Set up borrowing rates alpha array.
      *
     C                   EVAL      BORRA(1)  = DDBR01
     C                   EVAL      BORRA(2)  = DDBR02
     C                   EVAL      BORRA(3)  = DDBR03
     C                   EVAL      BORRA(4)  = DDBR04
     C                   EVAL      BORRA(5)  = DDBR05
     C                   EVAL      BORRA(6)  = DDBR06
     C                   EVAL      BORRA(7)  = DDBR07
     C                   EVAL      BORRA(8)  = DDBR08
     C                   EVAL      BORRA(9)  = DDBR09
     C                   EVAL      BORRA(10) = DDBR10
     C                   EVAL      BORRA(11) = DDBR11
     C                   EVAL      BORRA(12) = DDBR12
     C                   EVAL      BORRA(13) = DDBR13
     C                   EVAL      BORRA(14) = DDBR14
     C                   EVAL      BORRA(15) = DDBR15
     C                   EVAL      BORRA(16) = DDBR16
     C                   EVAL      BORRA(17) = DDBR17
     C                   EVAL      BORRA(18) = DDBR18
     C                   EVAL      BORRA(19) = DDBR19
     C                   EVAL      BORRA(20) = DDBR20
     C                   EVAL      BORRA(21) = DDBR21
      *
      * Set up lending rates alpha array.
      *
     C                   EVAL      LENDA(1)  = DDLR01
     C                   EVAL      LENDA(2)  = DDLR02
     C                   EVAL      LENDA(3)  = DDLR03
     C                   EVAL      LENDA(4)  = DDLR04
     C                   EVAL      LENDA(5)  = DDLR05
     C                   EVAL      LENDA(6)  = DDLR06
     C                   EVAL      LENDA(7)  = DDLR07
     C                   EVAL      LENDA(8)  = DDLR08
     C                   EVAL      LENDA(9)  = DDLR09
     C                   EVAL      LENDA(10) = DDLR10
     C                   EVAL      LENDA(11) = DDLR11
     C                   EVAL      LENDA(12) = DDLR12
     C                   EVAL      LENDA(13) = DDLR13
     C                   EVAL      LENDA(14) = DDLR14
     C                   EVAL      LENDA(15) = DDLR15
     C                   EVAL      LENDA(16) = DDLR16
     C                   EVAL      LENDA(17) = DDLR17
     C                   EVAL      LENDA(18) = DDLR18
     C                   EVAL      LENDA(19) = DDLR19
     C                   EVAL      LENDA(20) = DDLR20
     C                   EVAL      LENDA(21) = DDLR21
      *
      * Set up borrowing rates error indicator array.
      *
     C                   EVAL      BORREI(1)  = DDBR01OK
     C                   EVAL      BORREI(2)  = DDBR02OK
     C                   EVAL      BORREI(3)  = DDBR03OK
     C                   EVAL      BORREI(4)  = DDBR04OK
     C                   EVAL      BORREI(5)  = DDBR05OK
     C                   EVAL      BORREI(6)  = DDBR06OK
     C                   EVAL      BORREI(7)  = DDBR07OK
     C                   EVAL      BORREI(8)  = DDBR08OK
     C                   EVAL      BORREI(9)  = DDBR09OK
     C                   EVAL      BORREI(10) = DDBR10OK
     C                   EVAL      BORREI(11) = DDBR11OK
     C                   EVAL      BORREI(12) = DDBR12OK
     C                   EVAL      BORREI(13) = DDBR13OK
     C                   EVAL      BORREI(14) = DDBR14OK
     C                   EVAL      BORREI(15) = DDBR15OK
     C                   EVAL      BORREI(16) = DDBR16OK
     C                   EVAL      BORREI(17) = DDBR17OK
     C                   EVAL      BORREI(18) = DDBR18OK
     C                   EVAL      BORREI(19) = DDBR19OK
     C                   EVAL      BORREI(20) = DDBR20OK
     C                   EVAL      BORREI(21) = DDBR21OK
      *
      * Set up lending rates error indicator array.
      *
     C                   EVAL      LENDEI(1)  = DDLR01OK
     C                   EVAL      LENDEI(2)  = DDLR02OK
     C                   EVAL      LENDEI(3)  = DDLR03OK
     C                   EVAL      LENDEI(4)  = DDLR04OK
     C                   EVAL      LENDEI(5)  = DDLR05OK
     C                   EVAL      LENDEI(6)  = DDLR06OK
     C                   EVAL      LENDEI(7)  = DDLR07OK
     C                   EVAL      LENDEI(8)  = DDLR08OK
     C                   EVAL      LENDEI(9)  = DDLR09OK
     C                   EVAL      LENDEI(10) = DDLR10OK
     C                   EVAL      LENDEI(11) = DDLR11OK
     C                   EVAL      LENDEI(12) = DDLR12OK
     C                   EVAL      LENDEI(13) = DDLR13OK
     C                   EVAL      LENDEI(14) = DDLR14OK
     C                   EVAL      LENDEI(15) = DDLR15OK
     C                   EVAL      LENDEI(16) = DDLR16OK
     C                   EVAL      LENDEI(17) = DDLR17OK
     C                   EVAL      LENDEI(18) = DDLR18OK
     C                   EVAL      LENDEI(19) = DDLR19OK
     C                   EVAL      LENDEI(20) = DDLR20OK
     C                   EVAL      LENDEI(21) = DDLR21OK
      *
      * Initialize output borrowing and lending rates
      *
     C                   Z-ADD     *ZERO         @@BR
     C                   Z-ADD     *ZERO         @@LR
      *
      * Access currency data
      * (Database error handling done in access program).
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCCY         @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
     C     SETUPVALID    BEGSR
      *
      * Set up valid MM interest rates record fields.
      *
     C                   EVAL      FYRCID = 'HW'
     C                   EVAL      FYCCY  = DDCCY
 
     C***********        EVAL      FYCHTP = 'A'                                 CAP058
     C                   EVAL      FYCHTP = DDACTN                              CAP058
     C                   EVAL      FYLCD  = BJRDNB
 
      * Update borrowing rates error indicatos
 
     C                   EVAL      DDBR01OK = BORREI(1)
     C                   EVAL      DDBR02OK = BORREI(2)
     C                   EVAL      DDBR03OK = BORREI(3)
     C                   EVAL      DDBR04OK = BORREI(4)
     C                   EVAL      DDBR05OK = BORREI(5)
     C                   EVAL      DDBR06OK = BORREI(6)
     C                   EVAL      DDBR07OK = BORREI(7)
     C                   EVAL      DDBR08OK = BORREI(8)
     C                   EVAL      DDBR09OK = BORREI(9)
     C                   EVAL      DDBR10OK = BORREI(10)
     C                   EVAL      DDBR11OK = BORREI(11)
     C                   EVAL      DDBR12OK = BORREI(12)
     C                   EVAL      DDBR13OK = BORREI(13)
     C                   EVAL      DDBR14OK = BORREI(14)
     C                   EVAL      DDBR15OK = BORREI(15)
     C                   EVAL      DDBR16OK = BORREI(16)
     C                   EVAL      DDBR17OK = BORREI(17)
     C                   EVAL      DDBR18OK = BORREI(18)
     C                   EVAL      DDBR19OK = BORREI(19)
     C                   EVAL      DDBR20OK = BORREI(20)
     C                   EVAL      DDBR21OK = BORREI(21)
 
      * Update lending rates error indicatos
 
     C                   EVAL      DDLR01OK = LENDEI(1)
     C                   EVAL      DDLR02OK = LENDEI(2)
     C                   EVAL      DDLR03OK = LENDEI(3)
     C                   EVAL      DDLR04OK = LENDEI(4)
     C                   EVAL      DDLR05OK = LENDEI(5)
     C                   EVAL      DDLR06OK = LENDEI(6)
     C                   EVAL      DDLR07OK = LENDEI(7)
     C                   EVAL      DDLR08OK = LENDEI(8)
     C                   EVAL      DDLR09OK = LENDEI(9)
     C                   EVAL      DDLR10OK = LENDEI(10)
     C                   EVAL      DDLR11OK = LENDEI(11)
     C                   EVAL      DDLR12OK = LENDEI(12)
     C                   EVAL      DDLR13OK = LENDEI(13)
     C                   EVAL      DDLR14OK = LENDEI(14)
     C                   EVAL      DDLR15OK = LENDEI(15)
     C                   EVAL      DDLR16OK = LENDEI(16)
     C                   EVAL      DDLR17OK = LENDEI(17)
     C                   EVAL      DDLR18OK = LENDEI(18)
     C                   EVAL      DDLR19OK = LENDEI(19)
     C                   EVAL      DDLR20OK = LENDEI(20)
     C                   EVAL      DDLR21OK = LENDEI(21)
                                                                                CAP058
     C                   EVAL      FYEX01 = DDEX01                              CAP058
     C                   EVAL      FYEX02 = DDEX02                              CAP058
     C                   EVAL      FYEX03 = DDEX03                              CAP058
     C                   EVAL      FYEX04 = DDEX04                              CAP058
     C                   EVAL      FYEX05 = DDEX05                              CAP058
     C                   EVAL      FYEX06 = DDEX06                              CAP058
     C                   EVAL      FYEX07 = DDEX07                              CAP058
     C                   EVAL      FYEX08 = DDEX08                              CAP058
     C                   EVAL      FYEX09 = DDEX09                              CAP058
     C                   EVAL      FYEX10 = DDEX10                              CAP058
     C                   EVAL      FYEX11 = DDEX11                              CAP058
     C                   EVAL      FYEX12 = DDEX12                              CAP058
     C                   EVAL      FYEX13 = DDEX13                              CAP058
     C                   EVAL      FYEX14 = DDEX14                              CAP058
     C                   EVAL      FYEX15 = DDEX15                              CAP058
     C                   EVAL      FYEX16 = DDEX16                              CAP058
     C                   EVAL      FYEX17 = DDEX17                              CAP058
     C                   EVAL      FYEX18 = DDEX18                              CAP058
     C                   EVAL      FYEX19 = DDEX19                              CAP058
     C                   EVAL      FYEX20 = DDEX20                              CAP058
     C                   EVAL      FYEX21 = DDEX21                              CAP058
                                                                                CAP058
     C     CSD006        IFEQ      'Y'                                          CSD006
                                                                                CSD006
      ** Interest Rate Exceeded Indicator                                       CSD006
                                                                                CSD006
     C                   EVAL      FYTLEX = WTLEX                               CSD006
                                                                                CSD006
      ** Data Feed Request Identifier                                           CSD006
                                                                                CSD006
     C                   EVAL      FYDTFR = DDDTFR                              CSD006
                                                                                CSD006
      ** Borrowing/Lending Timestamps                                           CSD006
                                                                                CSD006
     C                   EVAL      WCENT = WCNTD                                CSD006
     C                   EVAL      WYEAR = WYRD                                 CSD006
     C     BJDFIN        IFEQ      'D'                                          CSD006
     C                   EVAL      WDAY = WDAT1                                 CSD006
     C                   EVAL      WMONTH = WDAT2                               CSD006
     C                   ELSE                                                   CSD006
     C                   EVAL      WDAY = WDAT2                                 CSD006
     C                   EVAL      WMONTH = WDAT1                               CSD006
     C                   ENDIF                                                  CSD006
     C                   EVAL      WTIME = WTMED                                CSD006
                                                                                CSD006
     C                   SELECT                                                 CSD006
     C     WAPIT         WHENEQ    'B'                                          CSD006
     C                   MOVEL     TimeStampDS   FYBOTS                         CSD006
     C     WAPIT         WHENEQ    'L'                                          CSD006
     C                   MOVEL     TimeStampDS   FYLETS                         CSD006
     C                   OTHER                                                  CSD006
     C                   MOVEL     TimeStampDS   FYBOTS                         CSD006
     C                   MOVEL     TimeStampDS   FYLETS                         CSD006
     C                   ENDSL                                                  CSD006
     C                   ENDIF                                                  CSD006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
     C                   PARM                    ModeOfOp                       CAP058
      * MM Interest Rates information (DS) from source system
     C***********        PARM                    TranIn1                        CAP058
     C***********        PARM                    TranIn2                        CAP058
     C                   PARM                    TranIn                         CAP058
     C                   PARM                    ExtData
     C                   PARM                    PrvIRFilFmt                    CAP058
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid MM Interest Rates layout (DS) from/to caller
     C                   PARM                    ValidINTR
     C                   PARM                    ValWrkFlds                     CAP058
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'FDINTRVAL'   DBPGM
     C                   OUT       LDA
      *
      * Access Bank details via access program
      * (database error handling done in access program).
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *  Set up the name of the MSGF from which the message handler will
      *  obtain the messages.
      *
     C                   EVAL      #MsgFile = 'DRSMM'
                                                                                CSD006
      ** Access Market Data Feed if switchable CSD006 is installed.             CSD006
                                                                                CSD006
     C                   IF        CSD006 = 'Y'                                 CSD006
     C                   CALL      'AOMDFCR0'                                   CSD006
     C                   PARM      *BLANKS       @RTCD                          CSD006
     C                   PARM      '*FIRST '     @OPTN                          CSD006
     C     SDMDFC        PARM      SDMDFC        DSSDY                          CSD006
                                                                                CSD006
     C                   IF        @RTCD <> *Blanks                             CSD006
     C                   MOVEL     'SDMDFCPD'    DBFILE                         CSD006
     C                   Z-ADD     3             DBASE                          CSD006
     C                   MOVEL     @OPTN         DBKEY                          CSD006
     C                   EXSR      *PSSR                                        CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** Check if the Interest Rate Tolerance is set to maximum (999.99)        CSD006
                                                                                CSD006
     C     MDIRTL        IFEQ      999.99                                       CSD006
     C                   MOVE      'Y'           WSETMAX           1            CSD006
     C                   ELSE                                                   CSD006
     C                   MOVE      'N'           WSETMAX                        CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CSD006
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FDINTRV004
 
      ** Get Dealing ICD                                                                    AR851109
      *                                                                                     AR851109
     C                   CALLB     'AODEALR1'                                               AR851109
     C                   PARM      '*DBERR '     @RTCD             7                        AR851109
     C                   PARM      '*FIRST '     @OPTN             7                        AR851109
     C     SDDEAL        PARM      SDDEAL        DSFDY                                      AR851109
      *                                                                                     AR851109
      * Database error                                                                      AR851109
      *                                                                                     AR851109
     C     @RTCD         IFNE      *BLANKS                                                  AR851109
     C                   MOVEL     'SDDEALPD'    DBFILE                       ************  AR851109
     C                   MOVEL     '900'         DBASE                        * DBERR 901*  AR851109
     C                   MOVEL     @OPTN         DBKEY                        ************  AR851109
     C                   EXSR      *PSSR                                                    AR851109
     C                   ENDIF                                                              AR851109
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
