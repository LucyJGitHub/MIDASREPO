     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward rates validation')
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module.                                  *
      *                                                               *
      *  FDFWRTVAL - Forward Rates record Validation                  *
      *                                                               *
      *  Function: This Program Validates Forward Rates for Input     *
      *            into the Midas database.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 257192             Date 14Oct08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245294             Date 28Feb07               *
      *                 241919             Date 22Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 235720             Date 20Sep05               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG8233            Date 23Aug05               *
      *                 BUG8141            Date 11Aug05               *
      *                 238595 (Reopen)    Date 03Apr06               *
      *                 238595             Date 14Mar06               *
      *                 BUG4178            Date 07Sep04               *
      *                 BUG3484            Date 01Jul04               *
      *                 CAP084             Date 16Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 213563             Date 06Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 196570             Date 18Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 23Oct00               *
      *                 CAP059             Date 23Oct00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP005  *CREATE    Date 17Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  257192 - If not a valid rate, do not reset to zero.          *
      *  245294 - Issue correct error message when problem with       *
      *           decimal places on the first record                  *
      *  241919 - Recompiled due to changes done to FDVFWRTPD.        *
      *  235720 - New forward rates not calculated - instead set to   *
      *           forward points - when CEU026 is not ON. Fix 232758  *
      *         - JPY is not allowed to have 8 decimal places. Decimal*
      *           places for spot rate is selected based on its diffe-*
      *           rence to the decimal place of the base rate. This   *
      *           selection should be removed. Fix 221384             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8233- Error in Forward Rates upload via File Adapter API  *
      *           (Recompile)                                         *
      *  BUG8141- Recompiled due to changes to FDVFWRTPD              *
      *  238595 (Reopen) - Forward rates are recalculated twice.      *
      *           First forward rate is not updated.                  *
      *  238595 - Recalculate forward rates for 'Out' ccy using       *
      *           EUR/base ccy rate.                                  *
      *  BUG4178 - Rate validation error                              *
      *  BUG3484 - Do not format rates when they are blanks as this   *
      *            causes problems in FDFWRTSIN module.               *
      *  CAP084 - API Wrapper project:-                               *
      *           Include additional error message when the Idx       *
      *           reaches 10.  Also, removed LOOKUP conditions in     *
      *           subroutine UPDATERRS so that the error and warning  *
      *           arrays would not have blank entries in between.     *
      *           Additional routines to format rates for display.    *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  213563 - No MDF tolerance checking on first rate             *
      *  CSC011 - 24x7 Midas Availability                             *
      *  196570 - Patch for Market Data Feed                          *
      *  CSD006 - MDF Changes.                                        *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
      *  CAP005 - Conversion of Citydealer Rates upload to use APIs   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
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
 
      ** Forward Days - signed decimal format.
     D FWDFWDS         DS
     D  DAY                    1     75P 0 INZ(*ZERO)
     D                                     DIM(25)
 
      ** Forward Rates - signed decimal format.
     D FWRFWDS         DS
     D  RAT                    1    175P 8 INZ(*ZERO)
     D                                     DIM(25)
 
      ** Forward Days - alpha format.
     D DYSA            S              5    DIM(25)
 
      ** Forward Days Error Indicators
     D DYSEI           S              1    DIM(25)
 
      ** Forward Rates - alpha format.
     D RTEA            S             14    DIM(25)
 
      ** Forward Rates Error Indicators
     D RTEEI           S              1    DIM(25)
 
      ** Forward Points - alpha format.                                                       CAP059
     D PNFA            S             14    DIM(25)                                            CAP059
                                                                                              CAP059
      ** Forward Points error Indicators                                                      CAP059
     D PNFEI           S              1    DIM(25)                                            CAP059
                                                                                              CAP059
      ** Forward Sign - alpha format.                                                         CAP059
     D SFWA            S              1    DIM(25) INZ(*ZERO)                                 CAP059
                                                                                              CAP059
      ** Forward Sign Error Indicators                                                        CAP059
     D SFWEI           S              1    DIM(25)                                            CAP059
                                                                                              CAP059
      * Incoming Forward Rates record
     D TranIn        E DS                  EXTNAME(FDFWRTPD)
                                                                                              CAP059
      ** Date in DDMMYY/MMDDYY format                                                         CAP059
                                                                                              CAP059
     D WDATEDD         S               D   DATFMT(*DMY)                                       CAP059
     D WDATEMM         S               D   DATFMT(*MDY)                                       CAP059
 
      * Valid Forward Rates record layout
     D ValidFWRT     E DS                  EXTNAME(FDVFWRTPD)
 
      * Forward Rates Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(FDFREXPD)
 
      * Previous Forward Rates Detail in File Format
     D PrvFRFilFmt   E DS                  EXTNAME(FDVFWRTPD)
     D                                     PREFIX(P)                                          CAP059
     D  PrvFR                 80    254P 8 DIM(25)                                            CAP059
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                              CAP059
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CAP059
      ** External DS for General Ledger Details                                               CAP059
                                                                                              CSD006
     D SDMDFC        E DS                  EXTNAME(SDMDFCPD)                                  CSD006
      ** External DS for Market Data Feeds ICD                                                CSD006
                                                                                              CSD006
      ** Forward Points - signed decimal format.                                              CAP059
     D FWPFWDS         DS                                                                     CAP059
     D  arPNT                  1    175P 8 DIM(25) INZ(*ZERO)                                 CAP059
                                                                                              CAP059
      ** Forward Sign                                                                         CAP059
     D FWSFWDS         DS                                                                     CAP059
     D  arSFW                  1     25    DIM(25) INZ(*BLANK)                                CAP059
                                                                                              CAP059
      ** Divisor Table for decimal places.                                                    CAP059
     D NQD             S              9  0 DIM(9) CTDATA PERRCD(1)                            CAP059
                                                                                              CAP059
                                                                                              CSD006
     D TimeStampDS     DS                                                                     CSD006
      ** Timestamp data structure (Century, Year, Month, Day, Hour, Minute and Second)        CSD006
     D WCENT                   1      2  0                                                    CSD006
     D WYEAR                   3      4  0                                                    CSD006
     D WMONTH                  5      6  0                                                    CSD006
     D WDAY                    7      8  0                                                    CSD006
     D WTIME                   9     14  0                                                    CSD006
                                                                                              CSD006
     D TStmpValDS      DS                                                                     CSD006
      ** Timestamp data structure for Validation                                              CSD006
     D WCNTD                   1      2  0                                                    CSD006
     D WDATE                   3      8  0                                                    CSD006
     D  WDAT1                         2  0 OVERLAY (WDATE:1)                                  CSD006
     D  WDAT2                         2  0 OVERLAY (WDATE:3)                                  CSD006
     D  WYRD                          2  0 OVERLAY (WDATE:5)                                  CSD006
     D WTMED                   9     14  0                                                    CSD006
     D WTSTMP                  3     14                                                       CSD006
                                                                                              CSD006
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
      ** External DS for SAR Details                                                          CSC011
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message IDs etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FDEFWRTPD)
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
      ** Update Y/N?                                                                          238595
     D UpdateYN        S              1A                                                      238595
                                                                                              238595
      ** Work field                                                                           CAP059
     D WK13            S             13  8                                                    CAP059
                                                                                              CAP059
      ** Work field for number of points calulation                                           CAP059
     D WWPNT           S             13  8                                                    CAP059
                                                                                              CAP059
      ** Index for the NQD table                                                              CAP059
     D Q               S              1  0                                                    CAP059
                                                                                              CAP059
      ** 'IN' Currency Work Field                                                             CAP059
     D BASINCY         S              1A                                                      CAP059
                                                                                              CAP059
      ** Base Currency Number of decimal places                                               CAP059
     D BNBDP           S              1  0                                                    CAP059
                                                                                              CAP059
      ** Base Currency EMU exchange rate                                                      CAP059
     D BEUER           S             13  8                                                    CAP059
                                                                                              CAP059
      ** Base Currency EMU Mult/Div indicator                                                 CAP059
     D BEUMD           S              1                                                       CAP059
                                                                                              CAP059
      ** No rate is amendable flag                                                            CAP059
     D ALLPROTECT      S              1                                                       CAP059
                                                                                              CAP059
      ** Difference in Number of decimal places between Fwrd Ccy                              CAP059
      ** and Base Ccy                                                                         CAP059
     D*** DiffNDP         S              1  0                                          CAP059 235720
                                                                                              CAP059
      ** Cross exchange rate                                                                  CAP059
     D ZXRATEX         S             13  8 INZ(*ZEROS)                                        CAP059
                                                                                              CAP059
      ** Cross Mult/Div indicator                                                             CAP059
     D ZMDIX           S              1    INZ(*BLANK)                                        CAP059
                                                                                              CAP059
      ** Interest Rate Tolerance Exceeded workfield                                           CSD006
     D WTLEX           S              1A                                                      CSD006
                                                                                              CSD006
      ** Difference between the previous and the new rate                                     CSD006
     D WDIFF           S             13P 8                                                    CSD006
     D*WACTRDIF********S*************13P 8                                             CSD006 196570
     D WACTRDIF        S             29P 8                                                    196570
                                                                                              CSD006
                                                                                              CSD006
     D*** WKFLD12p6       S             12P 6                                          CAP059 235720
     D*** WKFLD12p7       S             12P 7                                          CAP059 235720
     D*** WKFLD12p8       S             12P 8                                          CAP059 235720
                                                                                              CSC011
     D WKFLD13p8       S             13P 8                                                    235720
                                                                                              235720
     D CSC011          S              1A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
                                                                                              CSC011
      ** Workfields used by ZA0920 in formatting rates                                        CAP084
     D WRTCD           S             10                                                       CAP084
     D WAMTNUM         S             13  0                                                    CAP084
     D WNODEC          S              1  0                                                    CAP084
     D WSEPA           S              1                                                       CAP084
     D WAMTCHR         S             14                                                       CAP084
                                                                                              CAP084
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
 
      /COPY WNCPYSRC,FDFWRTV001
 
      * Initial processing to be executed on each call.
 
     C                   EXSR      INIT
 
      * Do Validation
     C                   EXSR      VFWDRATES
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
      /COPY WNCPYSRC,FDFWRTV002
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      /COPY WNCPYSRC,FDFWRTV003
      *
      * Return.
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFWDRATES - Validate Forward Rates Record
      *****************************************************************
     C     VFWDRATES     BEGSR
      *
      * Reset variables updated by this routine.
      *
     C                   EXSR      RESETERRS
     C                   EVAL      WTLEX = 'N'                                                CAP059
      *
      * FIRST ELEMENT OF DAY AND RATE ARRAYS ARE VALIDATED SEPARATELY.
      * =============================================================
      *
     C                   Z-ADD     1             N
      *
      * Validate first number of days
      *
     C                   EXSR      VAL_DAYS
      *
      * Validate first rate
      *
     C                   EXSR      VAL_RATE
      *                                                                                       CAP059
      * If EMU Forward Rates are switched on and Ccy is In, rates are                         CAP059
      * not amendable. Allow blanks in the rate field.                                        CAP059
      *                                                                                       CAP059
     C                   IF        CEU026 = 'N' AND BASINCY = 'N'                             CAP059
     C                             AND RTEA(1) = *BLANKS                                      CAP059
     C                   EVAL      Idx = Idx + 1                                              CAP059
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0052'                                  CAP059
     C                   EVAL      FldNamXAr(Idx) = 'DDRTE1'                                  CAP059
     C                   EVAL      DDRTE1OK = 'N'                                             CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
      * If Ccy = 'Out' and base 'In' recalculate rates if changes                             CAP059
      * have been made (assume rates entered Out/Euro rates)                                  CAP059
                                                                                              CAP059
     C                   IF        S01432 = 'N' AND CEU026 = 'Y'                              CAP059
                                                                                              CAP059
     C                   IF        A6INCY <> 'Y' AND BASINCY = 'Y'                            CAP059
     C                             AND DDCCY <> BKEURO                                        CAP059
                                                                                              CAP059
     C**********                   OR A6INCY = 'Y' AND BJRDNB <= A6TPSD                CAP059 CSC011
     C                             OR A6INCY = 'Y' AND WRunDay <= A6TPSD                      CSC011
     C                             AND BASINCY = 'Y'                                          CAP059
                                                                                              CAP059
     C**********         IF        DDRTE1 <> RTEA(1) AND RTEA(1) <> *BLANK             CAP059 238595
     C                   IF        RAT(1) <> PrvFR(1) AND RTEA(1) <> *BLANK                   238595
     C                             AND UpdateYN <> 'Y'                                        238595
                                                                                              CAP059
      ** Get Cross-Exchange rate                                                              CAP059
                                                                                              CAP059
     C                   CallB     'ZXRATE'                                                   CAP059
     C                   Parm                    RAT(1)                                       CAP059
     C                   Parm                    A6INMD                                       CAP059
     C                   Parm                    BEUER                                        CAP059
     C                   Parm                    BEUMD                                        CAP059
     C                   Parm                    ZXRATEX          13 8                        CAP059
     C                   Parm                    ZMDIX                                        CAP059
                                                                                              CAP059
      * If rate is reciprocal, call ZXRATE again with rates reversed                          CAP059
                                                                                              CAP059
     C                   IF        ZXRATEX < 1                                                CAP059
                                                                                              CAP059
     C                   CallB     'ZXRATE'                                                   CAP059
     C                   Parm                    BEUER                                        CAP059
     C                   Parm                    A6INMD                                       CAP059
     C                   Parm                    RAT(1)                                       CAP059
     C                   Parm                    BEUMD                                        CAP059
     C                   Parm                    ZXRATEX                                      CAP059
     C                   Parm                    ZMDIX                                        CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
     C                   EVAL      RAT(1) = ZXRATEX                                           CAP059
                                                                                              CAP059
     C                   ENDIF                                                                CAP059
     C                   ENDIF                                                                CAP059
     C                   ENDIF                                                                CAP059
      *
      *  If rate is OK, check that it is within 10% of spot rate.
      *
     C     RTEEI(1)      IFNE      'N'
     C     RTEA(1)       ANDNE     *BLANKS                                                    CAP059
      *
     C     RAT(1)        SUB       A6SPRT        WK12             12 8
     C     WK12          IFLT      0
     C                   Z-SUB     WK12          WK12
     C                   ENDIF
     C     WK12          DIV       A6SPRT        DIFF             15 8
      *
     C     DIFF          IFGT      .1
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIDXAr(WIdx) = 'MMA0696'
     C                   EVAL      WFldNmXAr(WIdx) = 'DDRTE1'
     C                   EVAL      RTEEI(1) = 'W'
     C                   ENDIF
     C                   ENDIF
                                                                                              213563
      ** Check if rate does not exceed forward rate tolerance                                 213563
                                                                                              213563
     C     CSD006        IFEQ      'Y'                                                        213563
     C                   IF        (WSETMAX = 'N') AND (DDDFRI <> *BLANK)                     213563
     C                             AND (DDACTN = 'A')                                         213563
     C                   IF        (WTLEX = 'N')                                              213563
                                                                                              213563
      ** Validate against the given tolerance in the MDF ICD                                  213563
     C                   Z-ADD     1             N                                            213563
     C                   EXSR      SrTOLERNCE                                                 213563
     C                   ENDIF                                                                213563
     C                   ENDIF                                                                213563
     C                   ENDIF                                                                213563
                                                                                              CAP084
      ** Format Rate for First rate.                                                          CAP084
     C     RTEEI(1)      IFNE      'N'                                                        257192
     C                   EVAL      WAMTNUM = *ZERO                                            CAP084
     C                   MOVE      RAT(1)        WAMTNUM                                      CAP084
     C                   EXSR      SrFMTDET                                                   CAP084
     C                   MOVE      WAMTCHR       RTEA(1)                                      CAP084
     C                   ENDIF                                                                257192
      *
      * VALIDATE REST OF DATA
      * =====================
      *
     C                   Z-ADD     2             N
      *
     C     N             DOWLE     25
     C     Idx           ANDLE     10
      *
      * If entered, validate number of days
      *
     C     DYSA(N)       IFNE      *BLANKS
     C                   EXSR      VAL_DAYS
     C                   ENDIF
      *
      * If entered, validate rate
      *
     C     RTEA(N)       IFNE      *BLANKS
     C                   EXSR      VAL_RATE
     C                   MOVE      ZFIELD        arPNT(N)                                     CAP059
     C                   ELSE                                                                 CAP059
     C                   MOVE      *BLANKS       arPNT(N)                                     CAP059
     C                   ENDIF
      *
      *  Either both or neither field must be defined
      *
     C     DYSA(N)       IFNE      *BLANKS
     C     DYSEI(N)      ANDNE     'N'
     C     RTEA(N)       ANDEQ     *BLANKS
                                                                                              CAP059
      * If EMU forward rate switched on and Ccy is 'In' rates are not                         CAP059
      * amendable, allow blanks in rate field                                                 CAP059
                                                                                              CAP059
     C                   IF        CEU026 = 'N' AND A6INCY <> 'Y'                             CAP059
                                                                                              CAP059
     C                             OR CEU026 = 'Y' AND A6INCY <> 'Y'                          CAP059
                                                                                              CAP059
     C                             OR CEU026 = 'N' AND A6INCY <> 'N'                          CAP059
                                                                                              CAP059
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0697'
     C                   EXSR      SetRateFld
     C                   EVAL      FldNamXAr (Idx) = RateFld
     C                   EVAL      RTEEI(N) = 'N'
     C                   ENDIF                                                                CAP059
     C                   ENDIF
      *
     C     DYSA(N)       IFEQ      *BLANKS
     C     RTEA(N)       ANDNE     *BLANKS
     C     RTEEI(N)      ANDNE     'N'
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0698'
     C                   EXSR      SetDaysFld
     C                   EVAL      FldNamXAr (Idx) = DaysFld
     C                   EVAL      DYSEI(N) = 'N'
     C                   ENDIF
      *
      * Embedded blanks not allowed
      *
     C     N             IFLT      25
     C     N             ADD       1             O                 2 0
     C     DYSA(N)       IFEQ      *BLANKS
     C     DYSA(O)       ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0699'
     C                   EXSR      SetDaysFld
     C                   EVAL      FldNamXAr (Idx) = DaysFld
     C                   EVAL      DYSEI(N) = 'N'
     C                   ENDIF
     C     RTEA(N)       IFEQ      *BLANKS
     C     RTEA(O)       ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0699'
     C                   EXSR      SetRateFld
     C                   EVAL      FldNamXAr (Idx) = RateFld
     C                   EVAL      RTEEI(N) = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      * Days entry should be greater than previous entry
      *
     C     N             SUB       1             M                 2 0
     C     DAY(N)        IFLE      DAY(M)
     C     DAY(N)        ANDNE     0
     C                   ADD       1             Idx
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0700'
     C                   EXSR      SetDaysFld
     C                   EVAL      FldNamXAr (Idx) = DaysFld
     C                   EVAL      DYSEI(N) = 'N'
     C                   ENDIF
                                                                                              CAP059
      * If EMU Forward Rates On and Ccy is 'In' then rate is blank                            CAP059
      * Bypass this validation                                                                CAP059
                                                                                              CAP059
     C                   IF        CEU026 = 'Y' AND A6INCY  <> 'N'                            CAP059
     C                             AND RAT(N) = *ZEROS                                        CAP059
     C                   MOVE      *BLANK        arSFW(N)                                     CAP059
     C                   ADD       1             N                                            CAP059
     C                   ITER                                                                 CAP059
     C                   ENDIF                                                                CAP059
      *
      *  Check Nth rate is within 10% of N-1th rate
      *
     C                   IF        S01432 = 'N'                                               CAP059
     C     RAT(M)        IFNE      0
     C     RAT(N)        ANDNE     0
     C     RAT(N)        SUB       RAT(M)        WK12             12 8
     C     WK12          IFLT      0
     C                   Z-SUB     WK12          WK12
     C                   ENDIF
     C     WK12          DIV       RAT(M)        DIFF             15 8
     C     DIFF          IFGT      .1
     C                   ADD       1             WIdx
     C                   EVAL      WMsgIDXAr(WIdx) = 'MMA0701'
     C                   EXSR      SetRateFld
     C                   EVAL      WFldNmXAr(WIdx) = RateFld
     C     RTEEI(N)      IFNE      'N'
     C                   EVAL      RTEEI(N) = 'W'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
      * Validation of the sign if Forward Rates Maintenance is on                             CAP059
                                                                                              CAP059
     C                   IF        S01432 = 'Y' AND RTEA(N) <> *BLANKS                        CAP059
                                                                                              CAP059
     C                   IF        SFWA(N) = *BLANK                                           CAP059
     C                   EVAL      SFWA(N) = '+'                                              CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
     C                   IF        SFWA(N) <> '+' AND SFWA(N) <> '-'                          CAP059
     C                   ADD       1             Idx                                          CAP059
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1152'                                  CAP059
     C                   EXSR      SetSignFld                                                 CAP059
     C                   EVAL      FldNamXAr (Idx) = SignFld                                  CAP059
     C                   EVAL      SFWEI(N) = 'N'                                             CAP059
     C                   ELSE                                                                 CAP059
     C                   MOVE      SFWA(N)       arSFW(N)                                     CAP059
     C                   ENDIF                                                                CAP059
     C                   ENDIF                                                                CAP059
     C                                                                                        CAP059
     C                   IF        S01432 = 'Y' AND RTEA(N) = *BLANKS                         CAP059
     C                   MOVE      *BLANK        arSFW(N)                                     CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
      * If Ccy = 'Out' and base 'In' recalculate rates if changes                             CAP059
      * have been made (assume rates entered Out/Euro rates)                                  CAP059
                                                                                              CAP059
B01  C******             IF        CEU026 = 'Y'                                        CAP059 235720
                                                                                              CAP059
B02  C                   IF        A6INCY <> 'Y' AND BASINCY = 'Y'                            CAP059
     C                             AND DDCCY <> BKEURO                                        CAP059
                                                                                              CAP059
     C**********                   OR A6INCY = 'Y' AND BJRDNB <= A6TPSD                CAP059 CSC011
     C                             OR A6INCY = 'Y' AND WRunDay <= A6TPSD                      CSC011
     C                             AND BASINCY = 'Y'                                          CAP059
     C                             AND CEU026 = 'Y'                                           235720
                                                                                              CAP059
B03  C                   IF        S01432 = 'N'                                               CAP059
                                                                                              CAP059
B04  C**********         IF        RTEA(N) <> RTEA(N) AND RTEA(N) <> *BLANK            CAP059 238595
B04  C**********         IF        RTEA(N) <> *BLANK                                          238595
B04  C                   IF        RAT(N) <> PrvFR(N) AND RTEA(N) <> *BLANK                   238595
B04  C                             AND UpdateYN <> 'Y'                                        238595
                                                                                              CAP059
      ** Get Cross-Exchange rate                                                              CAP059
                                                                                              CAP059
     C                   CallB     'ZXRATE'                                                   CAP059
     C                   Parm                    RAT(N)                                       CAP059
     C                   Parm                    A6INMD                                       CAP059
     C                   Parm                    BEUER                                        CAP059
     C                   Parm                    BEUMD                                        CAP059
     C                   Parm                    ZXRATEX                                      CAP059
     C                   Parm                    ZMDIX                                        CAP059
                                                                                              CAP059
      * If rate is reciprocal, call ZXRATE again with rates reversed                          CAP059
                                                                                              CAP059
B05  C                   IF        ZXRATEX < 1                                                CAP059
                                                                                              CAP059
     C                   CallB     'ZXRATE'                                                   CAP059
     C                   Parm                    BEUER                                        CAP059
     C                   Parm                    A6INMD                                       CAP059
     C                   Parm                    RAT(N)                                       CAP059
     C                   Parm                    BEUMD                                        CAP059
     C                   Parm                    ZXRATEX                                      CAP059
     C                   Parm                    ZMDIX                                        CAP059
E05  C                   ENDIF                                                                CAP059
                                                                                              CAP059
     C                   EVAL      RAT(N) = ZXRATEX                                           CAP059
                                                                                              CAP059
E04  C                   ENDIF                                                                CAP059
                                                                                              CAP059
     C                   IF        RAT(N) > *ZERO                                             CAP059
     C                   EVAL      WK12 = RAT(N) - RAT(M)                                     CAP059
     C                                                                                        CAP059
     C                   IF        WK12 < *ZERO                                               CAP059
     C                   Z-SUB     WK12          WK12                                         CAP059
     C                   EVAL      DIFF = WK12 / RAT(M)                                       CAP059
     C                                                                                        CAP059
     C                   IF        DIFF > 0.1                                                 CAP059
     C                   ADD       1             WIdx                                         CAP059
     C                   EVAL      WMsgIDXAr(WIdx) = 'MMA0701'                                CAP059
     C                   EXSR      SetRateFld                                                 CAP059
     C                   EVAL      WFldNmXAr(WIdx) = RateFld                                  CAP059
     C     RTEEI(N)      IFNE      'N'                                                        CAP059
     C                   EVAL      RTEEI(N) = 'W'                                             CAP059
     C                   ENDIF                                                                CAP059
     C                   ENDIF                                                                CAP059
     C                                                                                        CAP059
     C                   ENDIF                                                                CAP059
     C                   ENDIF                                                                CAP059
     C                                                                                        CAP059
X03  C                   ELSE                                                                 CAP059
                                                                                              CAP059
      * If Forward Rates Maintenance is on and points are not zero...                         CAP059
                                                                                              CAP059
     C                   IF        RAT(N) <> *ZERO                                            CAP059
                                                                                              CAP059
      * Calculate new rate from points entered                                                CAP059
                                                                                              CAP059
     C                   EVAL      Q = A6NQDP + 1                                             CAP059
     C                   EVAL      WWPNT = RAT(N) / NQD(Q)                                    CAP059
                                                                                              CAP059
     C                   IF        SFWA(N) = '+'                                              CAP059
     C                   EVAL      RAT(N) = A6INER + WWPNT                                    CAP059
                                                                                              CAP059
     C                   ELSE                                                                 CAP059
                                                                                              CAP059
     C                   EVAL      RAT(N) = A6INER - WWPNT                                    CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
      * Recalculate rate into Ccy against Base                                                CAP059
                                                                                              CAP059
     C                   CallB     'ZXRATE'                                                   CAP059
     C                   Parm                    RAT(N)                                       CAP059
     C                   Parm                    A6INMD                                       CAP059
     C                   Parm                    BEUER                                        CAP059
     C                   Parm                    BEUMD                                        CAP059
     C                   Parm                    ZXRATEX                                      CAP059
     C                   Parm                    ZMDIX                                        CAP059
                                                                                              CAP059
      * If rate is reciprocal, call ZXRATE again with rates reversed                          CAP059
                                                                                              CAP059
     C                   IF        ZXRATEX < 1                                                CAP059
                                                                                              CAP059
     C                   CallB     'ZXRATE'                                                   CAP059
     C                   Parm                    BEUER                                        CAP059
     C                   Parm                    A6INMD                                       CAP059
     C                   Parm                    RAT(N)                                       CAP059
     C                   Parm                    BEUMD                                        CAP059
     C                   Parm                    ZXRATEX                                      CAP059
     C                   Parm                    ZMDIX                                        CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
     C                   EVAL      RAT(N) = ZXRATEX                                           CAP059
                                                                                              CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
E03  C                   ENDIF                                                                CAP059
                                                                                              CAP059
     C* Recalculate rates when no no IN ccy involved OR CEU026 is OFF                         235720
X02  C                   ELSE                                                                 CAP059
                                                                                              CAP059
B03  C                   IF        S01432 = 'Y'                                               CAP059
     C                             AND RAT(N) <> 0                                            CAP059
     C                   EVAL      Q = A6NQDP + 1                                             CAP059
     C                   EVAL      WWPNT = RAT(N) / NQD(Q)                                    CAP059
                                                                                              CAP059
B04  C                   IF        SFWA(N) = '+'                                              CAP059
     C                   EVAL      RAT(N) = RAT(1) + WWPNT                                    CAP059
                                                                                              CAP059
X04  C                   ELSE                                                                 CAP059
                                                                                              CAP059
     C                   EVAL      RAT(N) = RAT(1) - WWPNT                                    CAP059
E04  C                   ENDIF                                                                CAP059
E03  C                   ENDIF                                                                CAP059
                                                                                              CAP059
E02  C                   ENDIF                                                                CAP059
E01  C*******            ENDIF                                                         CAP059 235720
                                                                                              CAP059
     C                   IF        RAT(N) > *ZERO                                             CAP059
     C                   EVAL      WK13 = RAT(N) - RAT(M)                                     CAP059
     C                                                                                        CAP059
     C                   IF        WK13 < *ZERO                                               CAP059
     C                   Z-SUB     WK13          WK13                                         CAP059
     C                   EVAL      DIFF = WK13 / RAT(M)                                       CAP059
     C                                                                                        CAP059
     C                   IF        DIFF > 0.1                                                 CAP059
     C                   ADD       1             WIdx                                         CAP059
     C                   EVAL      WMsgIDXAr(WIdx) = 'MMA0701'                                CAP059
     C                   EXSR      SetRateFld                                                 CAP059
     C                   EVAL      WFldNmXAr(WIdx) = RateFld                                  CAP059
     C     RTEEI(N)      IFNE      'N'                                                        CAP059
     C                   EVAL      RTEEI(N) = 'W'                                             CAP059
     C                   ENDIF                                                                CAP059
     C                   ENDIF                                                                CAP059
     C                                                                                        CAP059
     C                   ENDIF                                                                CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CSD006
      ** Check if rate does not exceed forward rate tolerance                                 CSD006
                                                                                              CSD006
     C     CSD006        IFEQ      'Y'                                                        CSD006
     C                   IF        (WSETMAX = 'N') AND (DDDFRI <> *BLANK)                     CSD006
     C                             AND (DDACTN = 'A')                                         CSD006
     C                   IF        (WTLEX = 'N')                                              CSD006
                                                                                              CSD006
      ** Validate against the given tolerance in the MDF ICD                                  CSD006
                                                                                              CSD006
     C                   EXSR      SrTOLERNCE                                                 CSD006
     C                   ENDIF                                                                CSD006
     C                   ENDIF                                                                CSD006
     C                   ENDIF                                                                CSD006
      *
      ** Format Rate                                                                          CAP084
      *                                                                                      BUG3484
      ** Do not format rate when blanks from display.                                        BUG3484
      *                                                                                      BUG3484
     C     RTEA(N)       IFNE      *BLANKS                                                   BUG3484
     C     RTEEI(N)      ANDNE     'N'                                                        257192
     C                   EVAL      WAMTNUM = *ZERO                                            CAP084
     C                   MOVE      RAT(N)        WAMTNUM                                      CAP084
     C                   IF        S01432 = 'Y'                                               CAP084
     C                   MOVE      arPNT(N)      WAMTNUM                                      CAP084
     C                   ENDIF                                                                CAP084
     C                   EXSR      SrFMTDET                                                   CAP084
     C                   MOVE      WAMTCHR       RTEA(N)                                      CAP084
     C                   ENDIF                                                               BUG3484
      *
     C                   ADD       1             N                 2 0
     C*
     C                   ENDDO
      *                                                                                       CAP084
      ** If error index reaches more than the required for validation,                        CAP084
      ** show additional error message to display on MidasPlus screen.                        CAP084
      *                                                                                       CAP084
     C     Idx           IFGE      10                                                         CAP084
     C                   ADD       1             Idx                                          CAP084
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1314'                                  CAP084
     C                   EXSR      SetDaysFld                                                 CAP084
     C                   EVAL      FldNamXAr (Idx) = DaysFld                                  CAP084
     C                   EVAL      DYSEI(N) = 'N'                                             CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CSD006
     C                   IF        CSD006 = 'Y'                                               CSD006
                                                                                              CSD006
      * Validate the Data Field Timestamp if CSD006 is on.                                    CSD006
                                                                                              CSD006
     C                   EXSR      SrVALSTMP                                                  CSD006
                                                                                              CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CAP084
      ** Move the values back to screen fields.                                               CAP084
     C                   EXSR      SrMOVFLD                                                   CAP084
                                                                                              CSD006
      *
      * Update error info with that produced by this subroutine.
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************                       CSD006
     C/EJECT                                                                                  CSD006
      *****************************************************************                       CSD006
      *                                                               *                       CSD006
      * SrVALSTMP - Validate Time Stamp                               *                       CSD006
      *                                                               *                       CSD006
      *****************************************************************                       CSD006
     C     SrVALSTMP     BEGSR                                                                CSD006
                                                                                              CSD006
     C                   MOVEL     DDDFTS        TStmpValDS                                   CSD006
                                                                                              CSD006
      ** Default Century in timestamp                                                         CSD006
                                                                                              CSD006
     C                   EVAL      WCNTD = 20                                                 CSD006
                                                                                              CSD006
      ** Validate Date and Time if not blank                                                  CSD006
                                                                                              CSD006
     C     WTSTMP        IFNE      *BLANK                                                     CSD006
                                                                                              CSD006
      ** Initialise indicator                                                                 CSD006
                                                                                              CSD006
     C                   EVAL      *IN80 = FALSE                                              CSD006
                                                                                              CSD006
     C     BJDFIN        IFEQ      'D'                                                        CSD006
     C     *DMY          TEST (D)                WDATE                  80                    CSD006
     C                   ELSE                                                                 CSD006
     C     *MDY          TEST (D)                WDATE                  80                    CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
      ** No Error on Date, validate Time                                                      CSD006
                                                                                              CSD006
     C     *IN80         IFEQ      FALSE                                                      CSD006
     C     *HMS          TEST (T)                WTMED                  80                    CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
      ** Error on Date or Time validation, send error message                                 CSD006
                                                                                              CSD006
     C     *IN80         IFEQ      TRUE                                                       CSD006
     C                   EVAL      Idx = Idx + 1                                              CSD006
     C                   EVAL      MsgIDXAr(Idx) = 'FDM0602'                                  CSD006
     C                   EVAL      FldNamXAr(Idx) = 'DDDFTS'                                  CSD006
     C                   EVAL      DDDFTSOK = 'N'                                             CSD006
     C                   ENDIF                                                                CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
      ** Default timestamp to current machine date and time when not entered                  CSD006
                                                                                              CSD006
     C     WTSTMP        IFEQ      *BLANK                                                     CSD006
     C     BJDFIN        IFEQ      'D'                                                        CSD006
     C                   MOVE      *DATE         WDATEDD                                      CSD006
     C                   MOVEL     WDATEDD       WDATE                                        CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVE      *DATE         WDATEMM                                      CSD006
     C                   MOVEL     WDATEMM       WDATE                                        CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   TIME                    WTMED                                        CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   ENDSR                                                                CSD006
      *****************************************************************
     C/EJECT                                                                                  CSD006
      *****************************************************************                       CSD006
      *                                                               *                       CSD006
      * SrTOLERNCE - Validate against the given Tolerance             *                       CSD006
      *                                                               *                       CSD006
      *****************************************************************                       CSD006
     C     SrTOLERNCE    BEGSR                                                                CSD006
                                                                                              CSD006
      ** If a new rate was entered, get difference from the previous value                    CSD006
                                                                                              CSD006
     C                   IF        (RAT(N) <> PrvFR(N)) AND (WTLEX = 'N')                     CSD006
     C                   EVAL      WDIFF = RAT(N) -  PrvFR(N)                                 CSD006
                                                                                              CSD006
      ** Get the actual rate difference of the new rate                                       CSD006
                                                                                              CSD006
     C                   IF        WDIFF < *ZERO                                              CSD006
     C                   Z-SUB     WDIFF         WDIFF                                        CSD006
     C                   IF        RAT(N) <> *ZERO                                            CSD006
     C                   EVAL      WACTRDIF = WDIFF/RAT(N) * 100                              CSD006
     C                   ENDIF                                                                CSD006
 
     C                   ELSE                                                                 CSD006
 
     C                   IF        PrvFR(N) <> *ZERO                                          CSD006
     C                   EVAL      WACTRDIF = WDIFF/PrvFR(N) * 100                            CSD006
     C                   ENDIF                                                                CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
      ** Check against the tolerance                                                          CSD006
                                                                                              CSD006
     C                   IF        WACTRDIF > MDFRTL                                          CSD006
     C                   EVAL      WTLEX = 'Y'                                                CSD006
     C                   ELSE                                                                 CSD006
     C                   EVAL      WTLEX = 'N'                                                CSD006
     C                   ENDIF                                                                CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   ENDSR                                                                CSD006
      *****************************************************************                       CSD006
     C/EJECT
      *****************************************************************
      ** VAL_DAYS - Validate Number of Days
      *****************************************************************
     C     VAL_DAYS      BEGSR
      *
      * Validate and right align no. of days and move from alpha to numeric.
      *
     C                   Z-ADD     5             ZADIG
     C                   Z-ADD     0             ZADEC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DYSA(N)       ZFIELD
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
      * Check that number of days is numeric.
      *
     C     ZRTN          IFEQ      'N'
     C                   ADD       1             Idx
     C     N             IFEQ      1
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0694'
     C                   ELSE
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0702'
     C                   ENDIF
     C                   EXSR      SetDaysFld
     C                   EVAL      FldNamXAr (Idx) = DaysFld
     C                   EVAL      DYSEI(N) = 'N'
     C                   ELSE
      *
      * Check that number of days is positive.
      *
     C                   MOVE      ZFIELD        DAY(N)
      *
     C     DAY(N)        IFLE      0
     C                   ADD       1             Idx
     C     N             IFEQ      1
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0694'
     C                   ELSE
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0702'
     C                   ENDIF
     C                   EXSR      SetDaysFld
     C                   EVAL      FldNamXAr (Idx) = DaysFld
     C                   EVAL      DYSEI(N) = 'N'
     C                   ELSE
      *
      * ... or period date too far in future
      *
     C*****BJRDNB        ADD       DAY(N)        WkLimit           6 0                        CSC011
     C     WRunDay       ADD       DAY(N)        WkLimit           6 0                        CSC011
     C     WkLimit       IFGT      99998
     C                   ADD       1             Idx
     C     N             IFEQ      1
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0694'
     C                   ELSE
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0702'
     C                   ENDIF
     C                   EXSR      SetDaysFld
     C                   EVAL      FldNamXAr (Idx) = DaysFld
     C                   EVAL      DYSEI(N) = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VAL_RATE - Validate Rate
      *****************************************************************
     C     VAL_RATE      BEGSR
                                                                                              CAP059
     C**********         SELECT                                                       CAP059 BUG4178
                                                                                              CAP059
     C**********         WHEN      DiffNDP = 1                                        CAP059 BUG4178
     C**********         Z-ADD     7             ZADIG                                CAP059 BUG4178
     C**********         Z-ADD     6             ZADEC                                CAP059 BUG4178
                                                                                              CAP059
     C**********         WHEN      DiffNDP = 2                                        CAP059 BUG4178
     C**********         Z-ADD     6             ZADIG                                CAP059 BUG4178
     C**********         Z-ADD     7             ZADEC                                CAP059 BUG4178
                                                                                              CAP059
     C**********         OTHER                                                        CAP059 BUG4178
     C                   Z-ADD     5             ZADIG                                        CAP059
     C                   Z-ADD     8             ZADEC                                        CAP059
                                                                                              CAP059
     C**********         ENDSL                                                        CAP059 BUG4178
     C*Make an immediate check on the number of decimal places                                196570
     C                   MOVE      *BLANKS       ZFIELD                                       196570
     C                   MOVE      RTEA(N)       ZFIELD                                       196570
     C                   CALLB     'ZALIGN'                                                   196570
     C                   PARM      *BLANKS       ZRTN              1                          196570
     C                   PARM                    ZFIELD           16                          196570
     C                   PARM                    ZADEC             1 0                        196570
     C                   PARM                    ZADIG             2 0                        196570
      *                                                                                       196570
     C     CEU026        IFEQ      'Y'                                                        196570
     C     ALLPROTECT    ANDEQ     'Y'                                                        196570
     C     RTEA(N)       ANDEQ     *BLANKS                                                    196570
     C                   ELSE                                                                 196570
     C     ZRTN          IFEQ      'N'                                                        196570
     C                   ADD       1             Idx                                          196570
     C*****N****         IFEQ      1                                                   196570 245294
     C**********         EVAL      MsgIDXAr(Idx) = 'MMA0695'                           196570 245294
     C**********         ELSE                                                          196570 245294
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1210'                                  196570
     C**********         ENDIF                                                         196570 245294
     C                   EXSR      SetRateFld                                                 196570
     C                   EVAL      FldNamXAr (Idx) = RateFld                                  196570
     C                   EVAL      RTEEI(N) = 'N'                                             196570
     C************       EXSR      UPDATERRS                                           196570 CAP084
     C                   GOTO      ENDLOOP                                                    196570
     C                   ENDIF                                                                196570
     C                   ENDIF                                                                196570
                                                                                              CAP059
      * If insert and S01432 is on default spot rate into first rate field                    CAP059
                                                                                              CAP059
     C***********        IF        DDACTN = 'I' AND S01432 = 'Y'                              CAP059
     C***********                  AND N = 1                                                  CAP059
     C***********        MOVE      *BLANKS       ZFIELD                                       CAP059
     C***********        MOVE      A6SPRT        ZFIELD                                       CAP059
     C***********        EXSR      ZEDIT                                                      CAP059
     C***********        MOVE      ZFIELD        RTEA(N)                                      CAP059
     C***********        MOVE      ZFIELD        DDRTE1                                       CAP059
     C***********        ENDIF                                                                CAP059
      *
      * Validate and right align rate and move from alpha to numeric.
      *
     C                   Z-ADD     5             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      RTEA(N)       ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
      * Check that rate is numeric
      *
     C     CEU026        IFEQ      'Y'
     C     ALLPROTECT    ANDEQ     'Y'
     C     RTEA(N)       ANDEQ     *BLANKS
     C                   ELSE
     C     ZRTN          IFEQ      'N'
     C                   ADD       1             Idx
     C     N             IFEQ      1
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0695'
     C                   ELSE
     C*******************EVAL      MsgIDXAr(Idx) = 'MMA0703'                                 196570
     C                   EVAL      MsgIDXAr(Idx) = 'MMA1210'                                 196570
     C                   ENDIF
     C                   EXSR      SetRateFld
     C                   EVAL      FldNamXAr (Idx) = RateFld
     C                   EVAL      RTEEI(N) = 'N'
     C                   ELSE
      *
     C                   MOVE      ZFIELD        RAT(N)
      *
      * Check that rate is positive.
      *
      *
     C     RAT(N)        IFLE      0
     C                   ADD       1             Idx
     C     N             IFEQ      1
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0695'
     C                   ELSE
     C                   EVAL      MsgIDXAr(Idx) = 'MMA0703'
     C                   ENDIF
     C                   EXSR      SetRateFld
     C                   EVAL      FldNamXAr (Idx) = RateFld
     C                   EVAL      RTEEI(N) = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CAP059
      *
     C*******************ENDSR                                                                196570
     C     ENDLOOP       ENDSR                                                                196570
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SetDaysFld - Set up days error field when days is in error.
      *****************************************************************
     C     SetDaysFld    BEGSR
     C                   MOVEL     *BLANK        DaysFld          10
     C                   MOVEL     'DDDYS'       DaysFld
      *
      * Add Element number
      *
     C     N             IFLE      9
     C                   MOVE      N             ElementS          1
     C                   EVAL      DaysFld = %Trim(DaysFld) + ElementS
     C                   ELSE
     C                   MOVE      N             ElementL          2
     C                   EVAL      DaysFld = %Trim(DaysFld) + ElementL
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SetRateFld - Set up rate error field when rate is in error.
      *****************************************************************
     C     SetRateFld    BEGSR
     C                   MOVEL     *BLANK        RateFld          10
     C                   MOVEL     'DDRTE'       RateFld
      *
      * Add Element number
      *
     C     N             IFLE      9
     C                   MOVE      N             ElementS
     C                   EVAL      RateFld = %Trim(RateFld) + ElementS
     C                   ELSE
     C                   MOVE      N             ElementL
     C                   EVAL      RateFld = %Trim(RateFld) + ElementL
     C                   ENDIF
     C                   ENDSR
      *****************************************************************                       CAP059
     C/EJECT                                                                                  CAP059
      *****************************************************************                       CAP059
      ** SetSignFld - Set up sign error field when sign is in error.                          CAP059
      *****************************************************************                       CAP059
     C     SetSignFld    BEGSR                                                                CAP059
     C                   MOVEL     *BLANK        SignFld          10                          CAP059
     C                   MOVEL     'DDSFW'       SignFld                                      CAP059
      *                                                                                       CAP059
      * Add Element number                                                                    CAP059
      *                                                                                       CAP059
     C     N             IFLE      9                                                          CAP059
     C                   MOVE      N             ElementS                                     CAP059
     C                   EVAL      SignFld = %Trim(SignFld) + ElementS                        CAP059
     C                   ELSE                                                                 CAP059
     C                   MOVE      N             ElementL                                     CAP059
     C                   EVAL      SignFld = %Trim(SignFld) + ElementL                        CAP059
     C                   ENDIF                                                                CAP059
     C                   ENDSR                                                                CAP059
      *****************************************************************
      /EJECT                                                                                  CAP059
      *****************************************************************                       CAP059
      *                                                               *                       CAP059
      * ZEDIT - Edit an unsigned field                                *                       CAP059
      *                                                               *                       CAP059
      *****************************************************************                       CAP059
     C     ZEDIT         BEGSR                                                                CAP059
                                                                                              CAP059
     C**********         SELECT                                                        CAP059 235720
                                                                                              CAP059
     C**********         WHEN      DiffNDP = 1                                         CAP059 235720
     C**********         Z-ADD     A6SPRT        WKFLD12p6                             CAP059 235720
     C**********         MOVE      WKFLD12p6     ZFIELD                                CAP059 235720
     C**********         EVAL      ZADEC = 6                                           CAP059 235720
                                                                                              CAP059
     C**********         WHEN      DiffNDP = 2                                         CAP059 235720
     C**********         Z-ADD     A6SPRT        WKFLD12p7                             CAP059 235720
     C**********         MOVE      WKFLD12p7     ZFIELD                                CAP059 235720
     C**********         EVAL      ZADEC = 7                                           CAP059 235720
                                                                                              CAP059
     C**********         OTHER                                                         CAP059 235720
     C**********         Z-ADD     A6SPRT        WKFLD12p8                             CAP059 235720
     C**********         MOVE      WKFLD12p8     ZFIELD                                CAP059 235720
     C                   Z-ADD     A6SPRT        WKFLD13p8                                    235720
     C                   MOVE      WKFLD13p8     ZFIELD                                       235720
     C                   EVAL      ZADEC = 8                                                  CAP059
                                                                                              CAP059
     C**********         ENDSL                                                         CAP059 235720
                                                                                              CAP059
     C                   CALLB     'ZEDIT'                                                    CAP059
     C                   PARM                    ZFIELD                                       CAP059
     C                   PARM                    ZADEC                                        CAP059
                                                                                              CAP059
     C**********         SELECT                                                        CAP059 235720
                                                                                              CAP059
     C**********         WHEN      DiffNDP = 1                                         CAP059 235720
     C**********                   AND ZFIELD = '        0.000000'                     CAP059 235720
     C**********         EVAL      ZFIELD = *BLANK                                     CAP059 235720
                                                                                              CAP059
     C**********         WHEN      DiffNDP = 2                                         CAP059 235720
     C**********                   AND ZFIELD = '       0.0000000'                     CAP059 235720
     C**********         EVAL      ZFIELD = *BLANK                                     CAP059 235720
                                                                                              CAP059
     C**********         OTHER                                                         CAP059 235720
     C                   IF        ZFIELD = '      0.00000000'                                CAP059
     C                   EVAL      ZFIELD = *BLANK                                            CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
     C**********         ENDSL                                                         CAP059 235720
                                                                                              CAP059
     C                   ENDSR                                                                CAP059
      *****************************************************************                       CAP059
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
      **Update*error*fields/message*IDs/message data (arrays)**********                       CAP084
      *
     C************       Z-ADD     1             I                 3 0                        CAP084
     C******BLANK*       LOOKUP    FldNameArr(I)                          99                  CAP084
     C******IN99**       IFEQ      '1'                                                        CAP084
     C************       MOVEA     FldNamXAr     FlDNameArr(I)                                CAP084
     C************       MOVEA     MsgIDXAr      MsgIdArr(I)                                  CAP084
     C************       MOVEA     MsgDtaXAr     MsgDtaArr(I)                                 CAP084
     C************       END                                                                  CAP084
      *
      **Set*Error*Index***********************************************                        CAP084
     C************       Z-ADD     1             I                                            CAP084
     C******BLANK*       LOOKUP    FldNameArr(I)                          99                  CAP084
     C*****I******       SUB       1             Idx                                          CAP084
      *
      **Update*warning*fields/message*IDs/message*data*(arrays)*******                        CAP084
      *
     C************       Z-ADD     1             I                                            CAP084
     C******BLANK*       LOOKUP    WFldNamArr(I)                          99                  CAP084
     C******IN99**       IFEQ      '1'                                                        CAP084
     C************       MOVEA     WFldNmXAr     WFldNamArr(I)                                CAP084
     C************       MOVEA     WMsgIDXAr     WMsgIDArr(I)                                 CAP084
     C************       MOVEA     WMsgDtXAr     WMsgDtaArr(I)                                CAP084
     C************       END                                                                  CAP084
      *
      **Set*Warning*Index*********************************************                        CAP084
     C************       Z-ADD     1             I                                            CAP084
     C******BLANK*       LOOKUP    WFldNamArr(I)                          99                  CAP084
     C*****I******       SUB       1             WIdx                                         CAP084
      *
     C                   IF        Widx > 0 OR Idx > 0                                        CAP059
                                                                                              CAP059
      * Update days error indicatos                                                           CAP059
                                                                                              CAP059
     C                   EVAL      DDDYS1OK = DYSEI(1)                                        CAP059
     C                   EVAL      DDDYS2OK = DYSEI(2)                                        CAP059
     C                   EVAL      DDDYS3OK = DYSEI(3)                                        CAP059
     C                   EVAL      DDDYS4OK = DYSEI(4)                                        CAP059
     C                   EVAL      DDDYS5OK = DYSEI(5)                                        CAP059
     C                   EVAL      DDDYS6OK = DYSEI(6)                                        CAP059
     C                   EVAL      DDDYS7OK = DYSEI(7)                                        CAP059
     C                   EVAL      DDDYS8OK = DYSEI(8)                                        CAP059
     C                   EVAL      DDDYS9OK = DYSEI(9)                                        CAP059
     C                   EVAL      DDDY10OK = DYSEI(10)                                       CAP059
     C                   EVAL      DDDY11OK = DYSEI(11)                                       CAP059
     C                   EVAL      DDDY12OK = DYSEI(12)                                       CAP059
     C                   EVAL      DDDY13OK = DYSEI(13)                                       CAP059
     C                   EVAL      DDDY14OK = DYSEI(14)                                       CAP059
     C                   EVAL      DDDY15OK = DYSEI(15)                                       CAP059
     C                   EVAL      DDDY16OK = DYSEI(16)                                       CAP059
     C                   EVAL      DDDY17OK = DYSEI(17)                                       CAP059
     C                   EVAL      DDDY18OK = DYSEI(18)                                       CAP059
     C                   EVAL      DDDY19OK = DYSEI(19)                                       CAP059
     C                   EVAL      DDDY20OK = DYSEI(20)                                       CAP059
     C                   EVAL      DDDY21OK = DYSEI(21)                                       CAP059
     C                   EVAL      DDDY22OK = DYSEI(22)                                       CAP059
     C                   EVAL      DDDY23OK = DYSEI(23)                                       CAP059
     C                   EVAL      DDDY24OK = DYSEI(24)                                       CAP059
     C                   EVAL      DDDY25OK = DYSEI(25)                                       CAP059
                                                                                              CAP059
      * Update rate error indicatos                                                           CAP059
                                                                                              CAP059
     C                   EVAL      DDRTE1OK = RTEEI(1)                                        CAP059
     C                   EVAL      DDRTE2OK = RTEEI(2)                                        CAP059
     C                   EVAL      DDRTE3OK = RTEEI(3)                                        CAP059
     C                   EVAL      DDRTE4OK = RTEEI(4)                                        CAP059
     C                   EVAL      DDRTE5OK = RTEEI(5)                                        CAP059
     C                   EVAL      DDRTE6OK = RTEEI(6)                                        CAP059
     C                   EVAL      DDRTE7OK = RTEEI(7)                                        CAP059
     C                   EVAL      DDRTE8OK = RTEEI(8)                                        CAP059
     C                   EVAL      DDRTE9OK = RTEEI(9)                                        CAP059
     C                   EVAL      DDRT10OK = RTEEI(10)                                       CAP059
     C                   EVAL      DDRT11OK = RTEEI(11)                                       CAP059
     C                   EVAL      DDRT12OK = RTEEI(12)                                       CAP059
     C                   EVAL      DDRT13OK = RTEEI(13)                                       CAP059
     C                   EVAL      DDRT14OK = RTEEI(14)                                       CAP059
     C                   EVAL      DDRT15OK = RTEEI(15)                                       CAP059
     C                   EVAL      DDRT16OK = RTEEI(16)                                       CAP059
     C                   EVAL      DDRT17OK = RTEEI(17)                                       CAP059
     C                   EVAL      DDRT18OK = RTEEI(18)                                       CAP059
     C                   EVAL      DDRT19OK = RTEEI(19)                                       CAP059
     C                   EVAL      DDRT20OK = RTEEI(20)                                       CAP059
     C                   EVAL      DDRT21OK = RTEEI(21)                                       CAP059
     C                   EVAL      DDRT22OK = RTEEI(22)                                       CAP059
     C                   EVAL      DDRT23OK = RTEEI(23)                                       CAP059
     C                   EVAL      DDRT24OK = RTEEI(24)                                       CAP059
     C                   EVAL      DDRT25OK = RTEEI(25)                                       CAP059
                                                                                              CAP059
      * Update Sign error indicatos                                                           CAP059
                                                                                              CAP059
     C                   EVAL      DDSFW1OK = SFWEI(1)                                        CAP059
     C                   EVAL      DDSFW2OK = SFWEI(2)                                        CAP059
     C                   EVAL      DDSFW3OK = SFWEI(3)                                        CAP059
     C                   EVAL      DDSFW4OK = SFWEI(4)                                        CAP059
     C                   EVAL      DDSFW5OK = SFWEI(5)                                        CAP059
     C                   EVAL      DDSFW6OK = SFWEI(6)                                        CAP059
     C                   EVAL      DDSFW7OK = SFWEI(7)                                        CAP059
     C                   EVAL      DDSFW8OK = SFWEI(8)                                        CAP059
     C                   EVAL      DDSFW9OK = SFWEI(9)                                        CAP059
     C                   EVAL      DDSF10OK = SFWEI(10)                                       CAP059
     C                   EVAL      DDSF11OK = SFWEI(11)                                       CAP059
     C                   EVAL      DDSF12OK = SFWEI(12)                                       CAP059
     C                   EVAL      DDSF13OK = SFWEI(13)                                       CAP059
     C                   EVAL      DDSF14OK = SFWEI(14)                                       CAP059
     C                   EVAL      DDSF15OK = SFWEI(15)                                       CAP059
     C                   EVAL      DDSF16OK = SFWEI(16)                                       CAP059
     C                   EVAL      DDSF17OK = SFWEI(17)                                       CAP059
     C                   EVAL      DDSF18OK = SFWEI(18)                                       CAP059
     C                   EVAL      DDSF19OK = SFWEI(19)                                       CAP059
     C                   EVAL      DDSF20OK = SFWEI(20)                                       CAP059
     C                   EVAL      DDSF21OK = SFWEI(21)                                       CAP059
     C                   EVAL      DDSF22OK = SFWEI(22)                                       CAP059
     C                   EVAL      DDSF23OK = SFWEI(23)                                       CAP059
     C                   EVAL      DDSF24OK = SFWEI(24)                                       CAP059
     C                   EVAL      DDSF25OK = SFWEI(25)                                       CAP059
                                                                                              CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * INIT - Inital Processing                                      *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      * Set up days alpha array.
      *
     C                   EVAL      DYSA(1)  = DDDYS1
     C                   EVAL      DYSA(2)  = DDDYS2
     C                   EVAL      DYSA(3)  = DDDYS3
     C                   EVAL      DYSA(4)  = DDDYS4
     C                   EVAL      DYSA(5)  = DDDYS5
     C                   EVAL      DYSA(6)  = DDDYS6
     C                   EVAL      DYSA(7)  = DDDYS7
     C                   EVAL      DYSA(8)  = DDDYS8
     C                   EVAL      DYSA(9)  = DDDYS9
     C                   EVAL      DYSA(10) = DDDY10
     C                   EVAL      DYSA(11) = DDDY11
     C                   EVAL      DYSA(12) = DDDY12
     C                   EVAL      DYSA(13) = DDDY13
     C                   EVAL      DYSA(14) = DDDY14
     C                   EVAL      DYSA(15) = DDDY15
     C                   EVAL      DYSA(16) = DDDY16
     C                   EVAL      DYSA(17) = DDDY17
     C                   EVAL      DYSA(18) = DDDY18
     C                   EVAL      DYSA(19) = DDDY19
     C                   EVAL      DYSA(20) = DDDY20
     C                   EVAL      DYSA(21) = DDDY21
     C                   EVAL      DYSA(22) = DDDY22
     C                   EVAL      DYSA(23) = DDDY23
     C                   EVAL      DYSA(24) = DDDY24
     C                   EVAL      DYSA(25) = DDDY25
      *
      * Set up rates alpha array.
      *
     C                   EVAL      RTEA(1)  = DDRTE1
     C                   EVAL      RTEA(2)  = DDRTE2
     C                   EVAL      RTEA(3)  = DDRTE3
     C                   EVAL      RTEA(4)  = DDRTE4
     C                   EVAL      RTEA(5)  = DDRTE5
     C                   EVAL      RTEA(6)  = DDRTE6
     C                   EVAL      RTEA(7)  = DDRTE7
     C                   EVAL      RTEA(8)  = DDRTE8
     C                   EVAL      RTEA(9)  = DDRTE9
     C                   EVAL      RTEA(10) = DDRT10
     C                   EVAL      RTEA(11) = DDRT11
     C                   EVAL      RTEA(12) = DDRT12
     C                   EVAL      RTEA(13) = DDRT13
     C                   EVAL      RTEA(14) = DDRT14
     C                   EVAL      RTEA(15) = DDRT15
     C                   EVAL      RTEA(16) = DDRT16
     C                   EVAL      RTEA(17) = DDRT17
     C                   EVAL      RTEA(18) = DDRT18
     C                   EVAL      RTEA(19) = DDRT19
     C                   EVAL      RTEA(20) = DDRT20
     C                   EVAL      RTEA(21) = DDRT21
     C                   EVAL      RTEA(22) = DDRT22
     C                   EVAL      RTEA(23) = DDRT23
     C                   EVAL      RTEA(24) = DDRT24
     C                   EVAL      RTEA(25) = DDRT25
      *
      * Set up points alpha array.
      *
     C                   EVAL      PNFA(2)  = DDRTE2
     C                   EVAL      PNFA(3)  = DDRTE3
     C                   EVAL      PNFA(4)  = DDRTE4
     C                   EVAL      PNFA(5)  = DDRTE5
     C                   EVAL      PNFA(6)  = DDRTE6
     C                   EVAL      PNFA(7)  = DDRTE7
     C                   EVAL      PNFA(8)  = DDRTE8
     C                   EVAL      PNFA(9)  = DDRTE9
     C                   EVAL      PNFA(10) = DDRT10
     C                   EVAL      PNFA(11) = DDRT11
     C                   EVAL      PNFA(12) = DDRT12
     C                   EVAL      PNFA(13) = DDRT13
     C                   EVAL      PNFA(14) = DDRT14
     C                   EVAL      PNFA(15) = DDRT15
     C                   EVAL      PNFA(16) = DDRT16
     C                   EVAL      PNFA(17) = DDRT17
     C                   EVAL      PNFA(18) = DDRT18
     C                   EVAL      PNFA(19) = DDRT19
     C                   EVAL      PNFA(20) = DDRT20
     C                   EVAL      PNFA(21) = DDRT21
     C                   EVAL      PNFA(22) = DDRT22
     C                   EVAL      PNFA(23) = DDRT23
     C                   EVAL      PNFA(24) = DDRT24
     C                   EVAL      PNFA(25) = DDRT25
      *                                                                                       CAP059
      * Set up sign alpha array.                                                              CAP059
      *                                                                                       CAP059
     C                   EVAL      SFWA(1)  = DDSFW1                                          CAP059
     C                   EVAL      SFWA(2)  = DDSFW2                                          CAP059
     C                   EVAL      SFWA(3)  = DDSFW3                                          CAP059
     C                   EVAL      SFWA(4)  = DDSFW4                                          CAP059
     C                   EVAL      SFWA(5)  = DDSFW5                                          CAP059
     C                   EVAL      SFWA(6)  = DDSFW6                                          CAP059
     C                   EVAL      SFWA(7)  = DDSFW7                                          CAP059
     C                   EVAL      SFWA(8)  = DDSFW8                                          CAP059
     C                   EVAL      SFWA(9)  = DDSFW9                                          CAP059
     C                   EVAL      SFWA(10) = DDSF10                                          CAP059
     C                   EVAL      SFWA(11) = DDSF11                                          CAP059
     C                   EVAL      SFWA(12) = DDSF12                                          CAP059
     C                   EVAL      SFWA(13) = DDSF13                                          CAP059
     C                   EVAL      SFWA(14) = DDSF14                                          CAP059
     C                   EVAL      SFWA(15) = DDSF15                                          CAP059
     C                   EVAL      SFWA(16) = DDSF16                                          CAP059
     C                   EVAL      SFWA(17) = DDSF17                                          CAP059
     C                   EVAL      SFWA(18) = DDSF18                                          CAP059
     C                   EVAL      SFWA(19) = DDSF19                                          CAP059
     C                   EVAL      SFWA(20) = DDSF20                                          CAP059
     C                   EVAL      SFWA(21) = DDSF21                                          CAP059
     C                   EVAL      SFWA(22) = DDSF22                                          CAP059
     C                   EVAL      SFWA(23) = DDSF23                                          CAP059
     C                   EVAL      SFWA(24) = DDSF24                                          CAP059
     C                   EVAL      SFWA(25) = DDSF25                                          CAP059
      *
      * Set up days error indicator array.
      *
     C                   EVAL      DYSEI(1)  = DDDYS1OK
     C                   EVAL      DYSEI(2)  = DDDYS2OK
     C                   EVAL      DYSEI(3)  = DDDYS3OK
     C                   EVAL      DYSEI(4)  = DDDYS4OK
     C                   EVAL      DYSEI(5)  = DDDYS5OK
     C                   EVAL      DYSEI(6)  = DDDYS6OK
     C                   EVAL      DYSEI(7)  = DDDYS7OK
     C                   EVAL      DYSEI(8)  = DDDYS8OK
     C                   EVAL      DYSEI(9)  = DDDYS9OK
     C                   EVAL      DYSEI(10) = DDDY10OK
     C                   EVAL      DYSEI(11) = DDDY11OK
     C                   EVAL      DYSEI(12) = DDDY12OK
     C                   EVAL      DYSEI(13) = DDDY13OK
     C                   EVAL      DYSEI(14) = DDDY14OK
     C                   EVAL      DYSEI(15) = DDDY15OK
     C                   EVAL      DYSEI(16) = DDDY16OK
     C                   EVAL      DYSEI(17) = DDDY17OK
     C                   EVAL      DYSEI(18) = DDDY18OK
     C                   EVAL      DYSEI(19) = DDDY19OK
     C                   EVAL      DYSEI(20) = DDDY20OK
     C                   EVAL      DYSEI(21) = DDDY21OK
     C                   EVAL      DYSEI(22) = DDDY22OK
     C                   EVAL      DYSEI(23) = DDDY23OK
     C                   EVAL      DYSEI(24) = DDDY24OK
     C                   EVAL      DYSEI(25) = DDDY25OK
      *
      * Set up RATE error indicator array.
      *
     C                   EVAL      RTEEI(1)  = DDRTE1OK
     C                   EVAL      RTEEI(2)  = DDRTE2OK
     C                   EVAL      RTEEI(3)  = DDRTE3OK
     C                   EVAL      RTEEI(4)  = DDRTE4OK
     C                   EVAL      RTEEI(5)  = DDRTE5OK
     C                   EVAL      RTEEI(6)  = DDRTE6OK
     C                   EVAL      RTEEI(7)  = DDRTE7OK
     C                   EVAL      RTEEI(8)  = DDRTE8OK
     C                   EVAL      RTEEI(9)  = DDRTE9OK
     C                   EVAL      RTEEI(10) = DDRT10OK
     C                   EVAL      RTEEI(11) = DDRT11OK
     C                   EVAL      RTEEI(12) = DDRT12OK
     C                   EVAL      RTEEI(13) = DDRT13OK
     C                   EVAL      RTEEI(14) = DDRT14OK
     C                   EVAL      RTEEI(15) = DDRT15OK
     C                   EVAL      RTEEI(16) = DDRT16OK
     C                   EVAL      RTEEI(17) = DDRT17OK
     C                   EVAL      RTEEI(18) = DDRT18OK
     C                   EVAL      RTEEI(19) = DDRT19OK
     C                   EVAL      RTEEI(20) = DDRT20OK
     C                   EVAL      RTEEI(21) = DDRT21OK
     C                   EVAL      RTEEI(22) = DDRT22OK
     C                   EVAL      RTEEI(23) = DDRT23OK
     C                   EVAL      RTEEI(24) = DDRT24OK
     C                   EVAL      RTEEI(25) = DDRT25OK
      *                                                                                       CAP059
      * Set up SIGN error indicator array.                                                    CAP059
      *                                                                                       CAP059
     C                   EVAL      SFWEI(1)  = DDSFW1OK                                       CAP059
     C                   EVAL      SFWEI(2)  = DDSFW2OK                                       CAP059
     C                   EVAL      SFWEI(3)  = DDSFW3OK                                       CAP059
     C                   EVAL      SFWEI(4)  = DDSFW4OK                                       CAP059
     C                   EVAL      SFWEI(5)  = DDSFW5OK                                       CAP059
     C                   EVAL      SFWEI(6)  = DDSFW6OK                                       CAP059
     C                   EVAL      SFWEI(7)  = DDSFW7OK                                       CAP059
     C                   EVAL      SFWEI(8)  = DDSFW8OK                                       CAP059
     C                   EVAL      SFWEI(9)  = DDSFW9OK                                       CAP059
     C                   EVAL      SFWEI(10) = DDSF10OK                                       CAP059
     C                   EVAL      SFWEI(11) = DDSF11OK                                       CAP059
     C                   EVAL      SFWEI(12) = DDSF12OK                                       CAP059
     C                   EVAL      SFWEI(13) = DDSF13OK                                       CAP059
     C                   EVAL      SFWEI(14) = DDSF14OK                                       CAP059
     C                   EVAL      SFWEI(15) = DDSF15OK                                       CAP059
     C                   EVAL      SFWEI(16) = DDSF16OK                                       CAP059
     C                   EVAL      SFWEI(17) = DDSF17OK                                       CAP059
     C                   EVAL      SFWEI(18) = DDSF18OK                                       CAP059
     C                   EVAL      SFWEI(19) = DDSF19OK                                       CAP059
     C                   EVAL      SFWEI(20) = DDSF20OK                                       CAP059
     C                   EVAL      SFWEI(21) = DDSF21OK                                       CAP059
     C                   EVAL      SFWEI(22) = DDSF22OK                                       CAP059
     C                   EVAL      SFWEI(23) = DDSF23OK                                       CAP059
     C                   EVAL      SFWEI(24) = DDSF24OK                                       CAP059
     C                   EVAL      SFWEI(25) = DDSF25OK                                       CAP059
      *
      * Initialize output days and rates
      *
     C                   Z-ADD     *ZERO         DAY
     C                   Z-ADD     *ZERO         RAT
     C                   EVAL      ValidFWRT =  PrvFRFilFmt
      *
      * Access currency data
      * (Database error handling done in access program).
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCCY         @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
                                                                                              CAP059
     C**********         EVAL      DiffNDP = A6NBDP - BNBDP + 4                        CAP059 235720
 
     C                   IF        CAP059 = 'Y' AND                                           CAP059
     C                             CEU026 = 'Y' AND                                           CAP059
     C                             A6INCY = 'Y' AND                                           CAP059
     C**********                   A6TPSD <= BJRDNB                                    CAP059 CSC011
     C                             A6TPSD <= WRunDay                                          CSC011
     C                   EVAL      ALLPROTECT = 'Y'                                           CAP059
     C                   ELSE                                                                 CAP059
     C                   EVAL      ALLPROTECT = 'N'                                           CAP059
     C                   ENDIF                                                                CAP059
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
      * Set up valid forward rates record fields.
      *
     C                   EVAL      FWRECI = 'D'
     C                   EVAL      FWCCY  = DDCCY
 
     C                   EVAL      FWDFW = FWDFWDS
     C                   EVAL      FWRFW = FWRFWDS
 
     C                   EVAL      FWLCD  = BJRDNB
     C***********        EVAL      FWCHTP = 'A'                                               CAP059
     C                   EVAL      FWCHTP = DDACTN                                            CAP059
     C                   EVAL      FWTNLU = 0
     C                   EVAL      FWPFW  = *BLANKS
     C                   IF        S01432 = 'Y'                                               CAP059
     C                   EVAL      FWSFW = FWSFWDS                                            CAP059
     C                   EVAL      FWPNF = FWPFWDS                                            CAP059
     C                   ELSE                                                                 CAP059
     C                   EVAL      FWSFW  = *BLANKS
     C                   EVAL      FWPNF  = *BLANKS
     C                   ENDIF                                                                CAP059
 
      * Update days error indicatos
 
     C                   EVAL      DDDYS1OK = DYSEI(1)
     C                   EVAL      DDDYS2OK = DYSEI(2)
     C                   EVAL      DDDYS3OK = DYSEI(3)
     C                   EVAL      DDDYS4OK = DYSEI(4)
     C                   EVAL      DDDYS5OK = DYSEI(5)
     C                   EVAL      DDDYS6OK = DYSEI(6)
     C                   EVAL      DDDYS7OK = DYSEI(7)
     C                   EVAL      DDDYS8OK = DYSEI(8)
     C                   EVAL      DDDYS9OK = DYSEI(9)
     C                   EVAL      DDDY10OK = DYSEI(10)
     C                   EVAL      DDDY11OK = DYSEI(11)
     C                   EVAL      DDDY12OK = DYSEI(12)
     C                   EVAL      DDDY13OK = DYSEI(13)
     C                   EVAL      DDDY14OK = DYSEI(14)
     C                   EVAL      DDDY15OK = DYSEI(15)
     C                   EVAL      DDDY16OK = DYSEI(16)
     C                   EVAL      DDDY17OK = DYSEI(17)
     C                   EVAL      DDDY18OK = DYSEI(18)
     C                   EVAL      DDDY19OK = DYSEI(19)
     C                   EVAL      DDDY20OK = DYSEI(20)
     C                   EVAL      DDDY21OK = DYSEI(21)
     C                   EVAL      DDDY22OK = DYSEI(22)
     C                   EVAL      DDDY23OK = DYSEI(23)
     C                   EVAL      DDDY24OK = DYSEI(24)
     C                   EVAL      DDDY25OK = DYSEI(25)
 
      * Update rate error indicatos
 
     C                   EVAL      DDRTE1OK = RTEEI(1)
     C                   EVAL      DDRTE2OK = RTEEI(2)
     C                   EVAL      DDRTE3OK = RTEEI(3)
     C                   EVAL      DDRTE4OK = RTEEI(4)
     C                   EVAL      DDRTE5OK = RTEEI(5)
     C                   EVAL      DDRTE6OK = RTEEI(6)
     C                   EVAL      DDRTE7OK = RTEEI(7)
     C                   EVAL      DDRTE8OK = RTEEI(8)
     C                   EVAL      DDRTE9OK = RTEEI(9)
     C                   EVAL      DDRT10OK = RTEEI(10)
     C                   EVAL      DDRT11OK = RTEEI(11)
     C                   EVAL      DDRT12OK = RTEEI(12)
     C                   EVAL      DDRT13OK = RTEEI(13)
     C                   EVAL      DDRT14OK = RTEEI(14)
     C                   EVAL      DDRT15OK = RTEEI(15)
     C                   EVAL      DDRT16OK = RTEEI(16)
     C                   EVAL      DDRT17OK = RTEEI(17)
     C                   EVAL      DDRT18OK = RTEEI(18)
     C                   EVAL      DDRT19OK = RTEEI(19)
     C                   EVAL      DDRT20OK = RTEEI(20)
     C                   EVAL      DDRT21OK = RTEEI(21)
     C                   EVAL      DDRT22OK = RTEEI(22)
     C                   EVAL      DDRT23OK = RTEEI(23)
     C                   EVAL      DDRT24OK = RTEEI(24)
     C                   EVAL      DDRT25OK = RTEEI(25)
                                                                                              CSD006
     C     CSD006        IFEQ      'Y'                                                        CSD006
                                                                                              CSD006
      ** Forward Rate Tolerance Exceeded Flag                                                 CSD006
                                                                                              CSD006
     C                   EVAL      FWTLEX = WTLEX                                             CSD006
                                                                                              CSD006
      ** Data Feed Request Identifier                                                         CSD006
                                                                                              CSD006
     C                   EVAL      FWDTRF = DDDFRI                                            CSD006
                                                                                              CSD006
      ** Timestamp                                                                            CSD006
                                                                                              CSD006
     C                   EVAL      WCENT = WCNTD                                              CSD006
     C                   EVAL      WYEAR = WYRD                                               CSD006
     C     BJDFIN        IFEQ      'D'                                                        CSD006
     C                   EVAL      WDAY = WDAT1                                               CSD006
     C                   EVAL      WMONTH = WDAT2                                             CSD006
     C                   ELSE                                                                 CSD006
     C                   EVAL      WDAY = WDAT2                                               CSD006
     C                   EVAL      WMONTH = WDAT1                                             CSD006
     C                   ENDIF                                                                CSD006
     C                   EVAL      WTIME = WTMED                                              CSD006
                                                                                              CSD006
     C                   MOVEL     TimeStampDS   FWDFTS                                       CSD006
                                                                                              CSD006
      ** Front Office Id                                                                      CSD006
                                                                                              CSD006
     C     RespMode      IFEQ      'S'                                                        CSD006
     C     CAP029        ANDEQ     'Y'                                                        CSD006
     C                   MOVEL     DDCCY         FWFRNT                                       CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   ENDIF                                                                CSD006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAP084
      *                                                               *                       CAP084
      * SrFMTDET - Format Rate Details                                *                       CAP084
      *                                                               *                       CAP084
      *****************************************************************                       CAP084
     C     SrFMTDET      BEGSR                                                                CAP084
                                                                                              CAP084
      ** Format Forward Rates                                                                 CAP084
                                                                                              CAP084
     C                   CALLB     'ZA0920'                                                   CAP084
     C                   PARM      *BLANK        WRTCD                                        CAP084
     C                   PARM                    WAMTNUM                                      CAP084
     C                   PARM      8             WNODEC                                       CAP084
     C                   PARM      '.'           WSEPA                                        CAP084
     C                   PARM      *BLANK        WAMTCHR                                      CAP084
                                                                                              CAP084
      ** Error calling module                                                                 CAP084
                                                                                              CAP084
     C                   IF        WRTCD <> *BLANK                                            CAP084
     C                   MOVEL     'ZA0920  '    DBFILE                                       CAP084
     C                   Z-ADD     904           DBASE                                        CAP084
     C                   MOVEL     '*CALL   '    DBKEY                                        CAP084
     C                   EXSR      *PSSR                                                      CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDSR                                                                CAP084
      *****************************************************************                       CAP084
     C/EJECT                                                                                  CAP084
      *****************************************************************                       CAP084
      *                                                               *                       CAP084
      * SrMOVFLD - Move Rates to Screen Fields                        *                       CAP084
      *                                                               *                       CAP084
      *****************************************************************                       CAP084
     C     SrMOVFLD      BEGSR                                                                CAP084
                                                                                              CAP084
      ** Set up rates screen field                                                            CAP084
                                                                                              CAP084
     C                   EVAL      DDRTE1 = RTEA(1)                                           CAP084
     C                   EVAL      DDRTE2 = RTEA(2)                                           CAP084
     C                   EVAL      DDRTE3 = RTEA(3)                                           CAP084
     C                   EVAL      DDRTE4 = RTEA(4)                                           CAP084
     C                   EVAL      DDRTE5 = RTEA(5)                                           CAP084
     C                   EVAL      DDRTE6 = RTEA(6)                                           CAP084
     C                   EVAL      DDRTE7 = RTEA(7)                                           CAP084
     C                   EVAL      DDRTE8 = RTEA(8)                                           CAP084
     C                   EVAL      DDRTE9 = RTEA(9)                                           CAP084
     C                   EVAL      DDRT10 = RTEA(10)                                          CAP084
     C                   EVAL      DDRT11 = RTEA(11)                                          CAP084
     C                   EVAL      DDRT12 = RTEA(12)                                          CAP084
     C                   EVAL      DDRT13 = RTEA(13)                                          CAP084
     C                   EVAL      DDRT14 = RTEA(14)                                          CAP084
     C                   EVAL      DDRT15 = RTEA(15)                                          CAP084
     C                   EVAL      DDRT16 = RTEA(16)                                          CAP084
     C                   EVAL      DDRT17 = RTEA(17)                                          CAP084
     C                   EVAL      DDRT18 = RTEA(18)                                          CAP084
     C                   EVAL      DDRT19 = RTEA(19)                                          CAP084
     C                   EVAL      DDRT20 = RTEA(20)                                          CAP084
     C                   EVAL      DDRT21 = RTEA(21)                                          CAP084
     C                   EVAL      DDRT22 = RTEA(22)                                          CAP084
     C                   EVAL      DDRT23 = RTEA(23)                                          CAP084
     C                   EVAL      DDRT24 = RTEA(24)                                          CAP084
     C                   EVAL      DDRT25 = RTEA(25)                                          CAP084
                                                                                              CAP084
     C                   ENDSR                                                                CAP084
      *****************************************************************                       CAP084
     C/EJECT                                                                                  CAP084
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Forward Rates information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    ExtData
     C                   PARM                    PrvFRFilFmt                                  CAP059
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C************       PARM                    FldNameArr                                   CAP084
     C************       PARM                    MsgIDArr                                     CAP084
     C************       PARM                    MsgDtaArr                                    CAP084
     C                   PARM                    FldNamXAr                                    CAP084
     C                   PARM                    MsgIDXAr                                     CAP084
     C                   PARM                    MsgDtaXAr                                    CAP084
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C************       PARM                    WFldNamArr                                   CAP084
     C************       PARM                    WMsgIDArr                                    CAP084
     C************       PARM                    WMsgDtaArr                                   CAP084
     C                   PARM                    WFldNmXAr                                    CAP084
     C                   PARM                    WMsgIDXAr                                    CAP084
     C                   PARM                    WMsgDtXAr                                    CAP084
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Forward Rates layout (DS) from/to caller
     C                   PARM                    ValidFWRT
      * Update Y/N?                                                                           238595
     C                   PARM                    UpdateYN                                     238595
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'FDFWRTVAL'   DBPGM
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
 
      ** Check if switchable feature CAP029 is switched on.                                   CSD006
      ** Forward Fx rate and MM Interest Rate API                                             CSD006
      *                                                                                       CSD006
     C                   CALL      'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CAP029'      @SARD             6                          CSD006
      *                                                                                       CSD006
      ** Database Error                                                                       CSD006
      *                                                                                       CSD006
     C     @RTCD         IFNE      *BLANKS                                                    CSD006
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD006
     C                   MOVEL     'CAP029'      DBKEY                                        CSD006
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD006
     C                   MOVEL     '902'         DBASE                                        CSD006
     C                   EXSR      *PSSR                                                      CSD006
     C                   ENDIF                                                                CSD006
     C     @RTCD         IFEQ      *BLANK                                                     CSD006
     C                   MOVE      'Y'           CAP029            1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVE      'N'           CAP029                                       CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
      ** Check if switchable feature CAP059 is switched on.                                   CAP059
      ** Forward Rates APIs                                                                   CAP059
      *                                                                                       CAP059
     C                   CALL      'AOSARDR0'                                                 CAP059
     C                   PARM      *BLANKS       @RTCD                                        CAP059
     C                   PARM      '*VERIFY'     @OPTN                                        CAP059
     C                   PARM      'CAP059'      @SARD             6                          CAP059
      *                                                                                       CAP059
      ** Database Error                                                                       CAP059
      *                                                                                       CAP059
     C     @RTCD         IFNE      *BLANKS                                                    CAP059
     C     @RTCD         ANDNE     '*NRF   '                                                  CAP059
     C                   MOVEL     'CAP059'      DBKEY                                        CAP059
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP059
     C                   MOVEL     '902'         DBASE                                        CAP059
     C                   EXSR      *PSSR                                                      CAP059
     C                   ENDIF                                                                CAP059
     C     @RTCD         IFEQ      *BLANK                                                     CAP059
     C                   MOVE      'Y'           CAP059            1                          CAP059
     C                   ELSE                                                                 CAP059
     C                   MOVE      'N'           CAP059                                       CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
      ** Check if switchable feature CSD006 is switched on.                                   CSD006
      ** Market Data Feeds.                                                                   CSD006
      *                                                                                       CSD006
     C                   CALL      'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
      *                                                                                       CSD006
      ** Database Error                                                                       CSD006
      *                                                                                       CSD006
     C     @RTCD         IFNE      *BLANKS                                                    CSD006
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD006
     C                   MOVEL     'CSD006'      DBKEY                                        CSD006
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD006
     C                   MOVEL     '902'         DBASE                                        CSD006
     C                   EXSR      *PSSR                                                      CSD006
     C                   ENDIF                                                                CSD006
     C     @RTCD         IFEQ      *BLANK                                                     CSD006
     C                   MOVE      'Y'           CSD006            1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVE      'N'           CSD006                                       CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
      ** Check if switchable feature S01432 is switched on.                                   CAP059
      ** Forward Ratess Maintenance.                                                          CAP059
      *                                                                                       CAP059
     C                   CALL      'AOSARDR0'                                                 CAP059
     C                   PARM      *BLANKS       @RTCD                                        CAP059
     C                   PARM      '*VERIFY'     @OPTN                                        CAP059
     C                   PARM      'S01432'      @SARD             6                          CAP059
      *                                                                                       CAP059
      ** Database Error                                                                       CAP059
      *                                                                                       CAP059
     C     @RTCD         IFNE      *BLANKS                                                    CAP059
     C     @RTCD         ANDNE     '*NRF   '                                                  CAP059
     C                   MOVEL     'S01432'      DBKEY                                        CAP059
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP059
     C                   MOVEL     '902'         DBASE                                        CAP059
     C                   EXSR      *PSSR                                                      CAP059
     C                   ENDIF                                                                CAP059
     C     @RTCD         IFEQ      *BLANK                                                     CAP059
     C                   MOVE      'Y'           S01432            1                          CAP059
     C                   ELSE                                                                 CAP059
     C                   MOVE      'N'           S01432                                       CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
      ** Access Market Data Feed if switchable CSD006 is installed.                           CSD006
                                                                                              CSD006
     C                   IF        CSD006 = 'Y'                                               CSD006
     C                   CALLB     'AOMDFCR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*FIRST '     @OPTN                                        CSD006
     C     SDMDFC        PARM      SDMDFC        DSSDY                                        CSD006
                                                                                              CSD006
     C                   IF        @RTCD <> *Blanks                                           CSD006
     C                   MOVEL     'SDMDFCPD'    DBFILE                                       CSD006
     C                   MOVEL     '080'         DBASE                                        CSD006
     C                   MOVEL     @OPTN         DBKEY                                        CSD006
     C                   EXSR      *PSSR                                                      CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
      ** Check if the Forward Rate Tolerance is set to maximum (999.99)                       CSD006
                                                                                              CSD006
     C     MDFRTL        IFEQ      999.99                                                     CSD006
     C                   MOVE      'Y'           WSETMAX           1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVE      'N'           WSETMAX                                      CSD006
     C                   ENDIF                                                                CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CAP059
      ** Check if switchable feature CEU026 is switched on.                                   CAP059
      *                                                                                       CAP059
     C                   CALLB     'AOSARDR0'                                                 CAP059
     C                   PARM      *BLANKS       @RTCD                                        CAP059
     C                   PARM      '*VERIFY'     @OPTN                                        CAP059
     C                   PARM      'CEU026'      @SARD             6                          CAP059
      *                                                                                       CAP059
      ** DATABASE ERROR                                                                       CAP059
      *                                                                                       CAP059
     C     @RTCD         IFNE      *BLANKS                                                    CAP059
     C     @RTCD         ANDNE     '*NRF   '                                                  CAP059
     C                   MOVEL     'CEU026'      DBKEY                                        CAP059
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP059
     C                   MOVEL     '902'         DBASE                                        CAP059
     C                   EXSR      *PSSR                                                      CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
     C     @RTCD         IFEQ      *BLANK                                                     CAP059
     C                   MOVE      'Y'           CEU026            1                          CAP059
     C                   ELSE                                                                 CAP059
     C                   MOVE      'N'           CEU026                                       CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        S1SUPP = LIBR                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 903                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CAP059
      ** Retrieve details about the base currency code                                        CAP059
      *                                                                                       CAP059
     C                   CALLB     'AOCURRR0'                                                 CAP059
     C                   PARM      *BLANK        @RTCD             7                          CAP059
     C                   PARM      '*KEY    '    @OPTN             7                          CAP059
     C                   PARM      BJCYCD        @KEY              3                          CAP059
     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP059
      *                                                                                       CAP059
     C                   EVAL      BNBDP = A6NBDP                                             CAP059
     C                   EVAL      BEUER = A6EUER                                             CAP059
     C                   EVAL      BEUMD = A6EUMD                                             CAP059
      *                                                                                       CAP059
     C                   IF        CEU026 = 'Y'                                               CAP059
      *                                                                                       CAP059
      * Check for whether the base currency is an 'IN' currency and                           CAP059
      * past its transition start date                                                        CAP059
      *                                                                                       CAP059
     C**********         IF        A6INCY = 'Y' AND A6TPSD <= BJRDNB                   CAP059 CSC011
     C                   IF        A6INCY = 'Y' AND A6TPSD <= WRunDay                         CSC011
     C                   EVAL      BASINCY = 'Y'                                              CAP059
     C                   ELSE                                                                 CAP059
     C                   EVAL      BASINCY = 'N'                                              CAP059
     C                   ENDIF                                                                CAP059
      *                                                                                       CAP059
      * Check for EURO currency name                                                          CAP059
      *                                                                                       CAP059
     C**********         CALLB     'AOGELRR0'                                          CAP059 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR'      @RTCD                                        CAP059
     C                   PARM      '*FIRST'      @OPTN                                        CAP059
     C*****SDGELR        PARM      SDGELR        DSFDY                                 CAP059 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *                                                                                       CAP059
      * Initialise Forward Rates for a EURO Base or 'IN' Currency Base                        CAP059
      * or 'OUT' Base                                                                         CAP059
      *                                                                                       CAP059
     C                   CALL      'DL4130'                                                   CAP059
     C                   PARM                    BJCYCD                                       CAP059
     C                   PARM                    BKEURO                                       CAP059
     C                   PARM                    BASINCY                                      CAP059
     C                   PARM      'Y'           INITN             1                          CAP059
     C                   PARM      *BLANKS       RCODE             7                          CAP059
     C                   ENDIF                                                                CAP059
      *                                                                                       CAP059
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FDFWRTV004
 
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
(c) Finastra International Limited 2001
**  NQD - Divisor Table for Decimal Places                                                    CAP059
000000001                                                                                     CAP059
000000010                                                                                     CAP059
000000100                                                                                     CAP059
000001000                                                                                     CAP059
000010000                                                                                     CAP059
000100000                                                                                     CAP059
001000000                                                                                     CAP059
010000000                                                                                     CAP059
100000000                                                                                     CAP059
