     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX CLS Pay-in Schedule Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXCLSPSIN - CLS Pay-in Schedule Input                        *
      *                                                               *
      *  Function:  This new program will allow entry of CLS Pay-in   *
      *             schedule if switchable feature CDL008 is on.      *
      *             For each currency, nostro, value date and seq. no,*
      *             the user will be able to input pay-in schedules   *
      *             as provided by the CLS Bank.  For each currency   *
      *             on the payment schedule, the branch will be       *
      *             either a net payer or a net receiver.  Users will *
      *             be able to fund their transactions as either one  *
      *             net payment or as a series of payments at timed   *
      *             intervals.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG8433            Date 20Jul05               *
      *  Prev Amend No. CAP086             Date 08Jun05               *
      *                 BUG5671            Date 31Jan05               *
      *                 CSC022             Date 24Feb04               *
      *                 CSC023             Date 28Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 02Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 14Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189658             Date 06Feb01               *
      *                 187923             Date 20Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187252             Date 04Dec00               *
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG8433- Not to validate sequence no. if second pass         *
      *           (confirm complete) in FXCLSPRTV.                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG5671- Add Sequence number to detail record                *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CSC023 - SBMJOB output queue must be *JOBD.                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *  CPK014 - Submit jobs with user *JOBD                         *
      *  189658 - CLS Pay-in schedule can be input without a time     *
      *  187923 - 2 tier authorisation for CLS pay-in schedules       *
      *           (Recompiled)                                        *
      *  187252 - F6 to authorise CLS pay-in schedules                *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
     D Cmd1            C                   CONST('SBMJOB CMD(CALL PGM(DLC6316) +
     D                                           PARM(''')
     D*Cmd2******      C                   CONST(''')) JOB(DLC6316) +                         CPK014
     D***********                                JOBQ(MBKGQ)')                                CPK014
                                                                                              CPK014
     D*Cmd2******      C                   CONST(''')) JOB(DLC6316) +                  CPK014 CSC023
     D***********                                JOBQ(MBKGQ) JOBD(MBATCH) +            CPK014 CSC023
     D***********                                USER(*JOBD)')                         CPK014 CSC023
     D Cmd2            C                   CONST(''')) JOB(DLC6316) +                         CSC023
     D                                           JOBQ(MBKGQ) JOBD(MBATCH) +                   CSC023
     D                                           USER(*JOBD) OUTQ(*JOBD)')                    CSC023
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Command for QCMDEXC
 
     D NewHedScFil   E DS                  EXTNAME(FXVCLSPHPD)
     D                                     PREFIX(VH)
      * New Pay-in Schedule Header in file format
 
     D NewDetScFil   E DS                  EXTNAME(FXVCLSPDPD)
     D                                     PREFIX(VD)
      * New Pay-in Schedule Detail in file format
 
     D NewHedSCScr   E DS                  EXTNAME(FXCLSPHPD)
     D                                     PREFIX(NH)
      * New CLS Pay-in schedule header in screen format
 
     D NewDetSCScr   E DS                  EXTNAME(FXCLSPDPD)
     D                                     PREFIX(ND)
      * New CLS Pay-in schedule detail in screen format
 
     D CurHedScFil   E DS                  EXTNAME(FXCLSPSH)
     D                                     PREFIX(HF)
      * Current Pay-in Schedule Header in file format
 
     D CurDetScFil   E DS                  EXTNAME(FXCLSPSD)
     D                                     PREFIX(DF)
      * Current Pay-in Schedule Detail in file format
 
     D CurHedSCScr   E DS                  EXTNAME(FXCLSPHPD)
     D                                     PREFIX(HS)
      * Current CLS Pay-in schedule header in screen format
 
     D CurDetSCScr   E DS                  EXTNAME(FXCLSPDPD)
     D                                     PREFIX(DS)
      * Current CLS Pay-in schedule detail in screen format
 
     D OKClsPSHD     E DS                  EXTNAME(FXECLSPHPD)
     D                                     PREFIX(H)
      * Error indicators for header screen
 
     D OKClsPSDT     E DS                  EXTNAME(FXECLSPDPD)
     D                                     PREFIX(D)
      * Error indicators for detail screen
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas Modules Details Accessed via Access Program
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** External DS for Dealing Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
                                                                                              CSC022
      ** External DS for SAR Details                                                          CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
                                                                                              CSC022
      ** Jobs Handling Commitment Control                                                     CSC022
     D SCCMTJOB      E DS           256    EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITARR               4    103                                                       CSC022
                                                                                              CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D COMITJOB        S             10A   DIM(10)                                            CSC022
 
     D/COPY QWINDSRC,FXCLSPDTA
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Parameter/indicator for determining if a blank time was                              189658
      ** entered, and Count for number of subfile records/payments                            189658
     D @NoTime         S              1A                                                      189658
     D WBLANK          S              1A                                                      189658
     D WCountSfl       S              3S 0                                                    189658
                                                                                              189658
      ** Parameters for FXCLSPRED                                                             CAP084
     D PRdFwd          S              1A                                                      CAP084
     D PRdBck          S              1A                                                      CAP084
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D CSC022          S              1A   INZ('N')                                           CSC022
     D CNT             S              3  0                                                    CSC022
     D COMITSKIP       S              1A                                                      CSC022
     D PRtCd           S              7A                                                      CSC022
     D POptn           S              7A                                                      CSC022
     D PSard           S              6A                                                      CSC022
     D UpdateYN        S              1A                                                     BUG8433
      **                                                                                      CSC022
     D PAuth           S              1A                                                      CAP086
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FXCLSPS001
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      /COPY WNCPYSRC,FXCLSPS002
      *
      ** Read Next Browse Subfile Record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      SRRDNB
     C                   ENDIF
      *
      ** Display CLS Pay-in Schedule details screen
      *
     C                   DOW       @SCRN = 'M'
     C                   EXSR      SRSCRN
     C                   ENDDO
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   ENDIF
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      SRUPDT
     C                   ENDIF
      *
      /COPY WNCPYSRC,FXCLSPS003
 
      * Terminate Program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FXCLSPS004
 
      /EJECT
      *****************************************************************
      * SRSCRN - Process Screen: Main Details
      *****************************************************************
     C     SRSCRN        BEGSR
      *
      ** Write/Read Display Screen
      *
     C                   EXSR      SRDSPD
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKClsPSHD
     C                   MOVE      *ALL'Y'       OKClsPSDT
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** CK/3 - End Program
      *
     C     @KeyP         CASEQ     '03'          SRENDP
                                                                                              CAP084
      ** CK/7 - Read Previous Record                                                          CAP084
                                                                                              CAP084
     C     @KeyP         CASEQ     '07'          SRROLL                                       CAP084
                                                                                              CAP084
      ** CK/8 - Read Next Record                                                              CAP084
                                                                                              CAP084
     C     @KeyP         CASEQ     '08'          SRROLL                                       CAP084
      *
      ** CK/11 - Toggle - Pay/Rcv screens
      *
     C     @KeyP         CASEQ     '11'          SRPYRC
      *
      ** CK/12 - Cancel on Main Details Screen
      *
     C     @KeyP         CASEQ     '12'          SRCANC
      *
      ** CK/15 - Build Browse
      *
     C     @KeyP         CASEQ     '15'          SRBRWS
      *
      ** Validate Input to Main Details Screen
      *
     C                   CAS                     SRVALD
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVALD  - Validate Input to Main Details Screen
      *****************************************************************
     C     SRVALD        BEGSR
      *
      ** Retrieve header details
      *
     C                   IF        @ScreenInd = 'I'
     C                   EXSR      SRRTVD
      *
      ** Convert file fields to screen fields if action is not insert
      *
     C                   IF        HSCLSACT = 'A' OR
     C                             HSCLSACT = 'D' OR
     C                             HSCLSACT = 'X' OR
     C                             HSCLSACT = 'E'
     C                   IF        RetCodeOut = *BLANKS AND
     C                             OKClsPSHD = 'YYYYYYYYYYYY'
     C                   EVAL      NHCLSACT = HSCLSACT
     C                   EXSR      SRCONV
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If fields are valid and action code is 'I'
      *
     C                   IF        HSCLSACT = 'I' AND
     C                             OKClsPSHD = 'YYYYYYYYYYYY'
      *
     C                   IF        @ScreenInd = 'I'
     C     HFPYNSBP      IFGT      *ZERO
     C                   MOVE      'P'           @PayRcv           1
     C                   ELSE
     C                   MOVE      'R'           @PayRcv
     C                   ENDIF
     C                   ENDIF
      *
      ** Execute SRCONV so that defaulted nostro balance will be converted
      ** from file format to screen format
      *
     C                   EVAL      NHCLSACT = HSCLSACT
     C                   MOVE      HSCLSTOR      WCLSTOR          18
     C                   MOVE      HSCLSTOP      WCLSTOP          18
     C                   EXSR      SRCONV
     C                   MOVE      WCLSTOR       HSCLSTOR
     C                   MOVE      WCLSTOP       HSCLSTOP
      *
      ** Re-output screen
      *
     C                   IF        @ScreenInd = 'I'
     C                   EVAL      @ScreenInd = 'D'
     C                   EVAL      @SflAction = 'BS'
     C                   EVAL      WriteOnly = 'N'
     C                   EVAL      @Scrn = 'M'
     C                   GOTO      EVAL@M
     C                   ENDIF
     C                   MOVE      'N'           WERROR            1
      *
      ** Retrieve one record from subfile ("RC" Read Change)
      *
     C                   IF        @PayRcv = 'P'
     C                   Eval      @SflAction = 'RC'
      *
     C                   EXSR      SRDSPD
      *
      ** Initialise total amount to zero if first read on subfile is blanks
      *
     C                   IF        @SflAction = 'RC'  AND
     C                             DSCLSTIM = *BLANKS AND
     C                             DSCLSAMT = *BLANKS
     C                   Z-ADD     0             HFPYTOTP
     C                   ENDIF
      *                                                                                       189658
      ** Initialise indicator for determining if any of the schedules                         189658
      ** has a blank time, and counter for num. of sfl records/payments                       189658
      *                                                                                       189658
     C                   EVAL      WBLANK = 'N'                                               189658
     C                   Z-ADD     *ZERO         WCountSfl                                    189658
      *
      ** Validate Record retrieved from subfile until SFLEOF equal Y and
      ** screen not blanks
      *
     C     @SflEof       DOWEQ     'N'
     C     DSCLSTIM      IFNE      *BLANKS
     C     DSCLSAMT      ORNE      *BLANKS
     C                   MOVE      'V'           WVLDCNF
     C                   ADD       1             WCountSfl                                    189658
      *
     C                   EXSR      SRCLSV
      *
      ** If CLS amount or CLS time is in error, screen should be redisplayed
      *
     C                   IF        DCLSTIMOK = 'N' OR
     C                             DCLSAMTOK = 'N'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
      *                                                                                       189658
      ** If blank time was entered, seton indicator                                           189658
      *                                                                                       189658
     C                   IF        @NoTime = 'Y'                                              189658
     C                   EVAL      WBLANK = 'Y'                                               189658
     C                   ENDIF                                                                189658
     C                   ENDIF
      *
      ** Retrieve one record from subfile ("RC" Read Next Change)
      *
     C                   Eval      @SflAction = 'UC'
      *
     C                   EXSR      SRDSPD
      *
     C                   EndDo
     C                   ELSE
     C                   MOVE      'V'           WVLDCNF
     C                   EXSR      SRCLSV
     C                   IF        HCLSTOROK = 'N'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      ** If detail fields are valid, redisplay screen for confirmation
      ** and total amount
      *
     C                   IF        WERROR  = 'N'
      *
      ** At least one valid pay-in schedule must be entered for pay
      *
     C                   IF        HFPYTOTP = *ZEROS  AND
     C                             @PayRcv = 'P'
     C                   Z-ADD     1             Idx
     C                   MOVEL     'CLSTOP'      FldNameArr(1)
     C                   MOVEL     'FXM3034'     MsgIdArr(1)
     C                   MOVE      'N'           DCLSTIMOK
     C                   MOVE      'N'           DCLSAMTOK
     C                   MOVE      'N'           HCLSTOPOK
     C                   EVAL      @SCRN = 'M'
     C                   ELSE
      *                                                                                       189658
      ** If a schedule with a blank time was entered, there should only                       189658
      ** be one payment on the schedule and Multiple pay-in generated                         189658
      ** by time on the nostro should be 'N'                                                  189658
      *                                                                                       189658
     C                   IF        @PayRcv = 'P' AND WBLANK = 'Y' AND                         189658
     C                             WCountSfl > 1 OR                                           189658
     C                             @PayRcv = 'P' AND WBLANK = 'Y' AND                         189658
     C                             A7MPGT = 'Y'                                               189658
     C                   Z-ADD     1             Idx                                          189658
     C                   MOVEL     'CLSTIM'      FldNameArr(1)                                189658
     C                   MOVEL     'FXM3041'     MsgIdArr(1)                                  189658
     C                   MOVE      'N'           DCLSTIMOK                                    189658
     C                   MOVE      'N'           DCLSAMTOK                                    189658
     C                   MOVE      'N'           HCLSTOPOK                                    189658
     C                   EVAL      @SCRN = 'M'                                                189658
     C                   ELSE                                                                 189658
     C                   EVAL      @SCRN = 'C'
     C                   ENDIF
      *                                                                                       189658
     C                   ENDIF                                                                189658
      *                                                                                       189658
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   ENDIF
      *
     C                   EVAL      @SflAction = 'RS'
      *
      * and not rollup/rolldown
      * move to srupdt
      *
     C                   ENDIF
      *
      ** If fields valid and action code is 'A', 'D', 'X', 'E'
      *
     C                   IF        RetCodeOut = *BLANKS AND
     C                             OKClsPSHD = 'YYYYYYYYYYYY'
     C                   IF        HSCLSACT = 'A' OR
     C                             HSCLSACT = 'D' OR
     C                             HSCLSACT = 'X' OR
     C                             HSCLSACT = 'E'
      *
     C                   IF        HFPYTOTP > *ZEROS
     C                   EVAL      @PayRcv = 'P'
     C                   ELSE
     C                   EVAL      @PayRcv = 'R'
     C                   ENDIF
      *
     C                   IF        @ScreenInd = 'I'
     C                   EVAL      @ScreenInd = 'D'
     C                   IF        HSCLSACT = 'A'
     C                   EVAL      WriteOnly = 'N'
     C                   ELSE
     C                   EVAL      WriteOnly = 'Y'
     C                   ENDIF
     C                   EVAL      @SflAction = 'BS'
     C                   EVAL      @SCRN  = 'M'
     C                   GOTO      EVAL@M
     C                   ENDIF
     C                   MOVE      'N'           WERROR            1
      *
      ** If Action is Amend and Authorise Pay-in Flag is 'N'
      *
     C                   IF        HSCLSACT = 'A' AND
     C                             HSCLSSFL = 'N'
      *
      ** Retrieve one record from subfile ("RC" Read Change)
      *
     C                   IF        @PayRcv = 'P'
     C                   Eval      @SflAction = 'RC'
      *
     C                   EXSR      SRDSPD
      *
      ** Initialise total amount to zero if first read on subfile is blanks
      *
     C                   IF        @SflAction = 'RC'  AND
     C                             DSCLSTIM = *BLANKS AND
     C                             DSCLSAMT = *BLANKS
     C                   Z-ADD     0             HFPYTOTP
     C                   ENDIF
      *                                                                                       189658
      ** Initialise indicator for determining if any of the schedules                         189658
      ** has a blank time, and counter for num. of sfl records/payments                       189658
      *                                                                                       189658
     C                   EVAL      WBLANK = 'N'                                               189658
     C                   Z-ADD     *ZERO         WCountSfl                                    189658
      *
      ** Validate Record retrieved from subfile until SFLEOF equal Y
      ** and screen equal to blanks
      *
     C     @SflEof       DOWEQ     'N'
     C     DSCLSTIM      IFNE      *BLANKS
     C     DSCLSAMT      ORNE      *BLANKS
     C                   MOVE      'V'           WVLDCNF
     C                   ADD       1             WCountSfl                                    189658
      *
     C                   EXSR      SRCLSV
      *
      ** If CLS amount or CLS time is in error, screen should be redisplayed
      *
     C                   IF        DCLSTIMOK = 'N' OR
     C                             DCLSAMTOK = 'N'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
      *                                                                                       189658
      ** If blank time was entered, seton indicator                                           189658
      *                                                                                       189658
     C                   IF        @NoTime = 'Y'                                              189658
     C                   EVAL      WBLANK = 'Y'                                               189658
     C                   ENDIF                                                                189658
     C                   ENDIF
      *
      ** Retrieve one record from subfile ("RC" Read Next Change)
      *
     C                   Eval      @SflAction = 'UC'
      *
     C                   EXSR      SRDSPD
      *
     C                   EndDo
     C                   Else
     C                   MOVE      'V'           WVLDCNF
     C                   EXSR      SRCLSV
     C                   IF        HCLSTOROK = 'N'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        WERROR = 'N'
      *
      ** At least one valid pay-in schedule must be entered for pay
      *
     C                   IF        HFPYTOTP = *ZEROS  AND
     C                             @PayRcv = 'P'
     C                   Z-ADD     1             Idx
     C                   MOVEL     'CLSTOP'      FldNameArr(1)
     C                   MOVEL     'FXM3034'     MsgIdArr(1)
     C                   MOVE      'N'           DCLSTIMOK
     C                   MOVE      'N'           DCLSAMTOK
     C                   MOVE      'N'           HCLSTOPOK
     C                   EVAL      @SCRN = 'M'
     C                   ELSE
      *                                                                                       189658
      ** If a schedule with a blank time was entered, there should only                       189658
      ** be one payment on the schedule and Multiple pay-in generated                         189658
      ** by time on the nostro should be 'N'                                                  189658
      *                                                                                       189658
     C                   IF        @PayRcv = 'P' AND WBLANK = 'Y' AND                         189658
     C                             WCountSfl > 1 OR                                           189658
     C                             @PayRcv = 'P' AND WBLANK = 'Y' AND                         189658
     C                             A7MPGT = 'Y'                                               189658
     C                   Z-ADD     1             Idx                                          189658
     C                   MOVEL     'CLSTIM'      FldNameArr(1)                                189658
     C                   MOVEL     'FXM3041'     MsgIdArr(1)                                  189658
     C                   MOVE      'N'           DCLSTIMOK                                    189658
     C                   MOVE      'N'           DCLSAMTOK                                    189658
     C                   MOVE      'N'           HCLSTOPOK                                    189658
     C                   EVAL      @SCRN = 'M'                                                189658
     C                   ELSE                                                                 189658
     C                   EVAL      @SCRN = 'C'
     C                   ENDIF
      *                                                                                       189658
     C                   ENDIF                                                                189658
      *
     C                   ELSE
     C                   EVAL      @SCRN = 'M'
     C                   ENDIF
     C                   EVAL      @SflAction = 'RS'
     C                   ENDIF
      *
      ** If Action is delete
      *
     C                   IF        HSCLSACT = 'D'
      *
     C                   IF        @KeyP = '10'
      *
      ** Call Validation module to map data into fields
      *
     C                   EVAL      WVLDCNF = 'M'
     C                   EXSR      SRCLSV
     C                   EVAL      @SCRN = 'U'
     C                   ENDIF
      *
     C                   GOTO      EVAL@M
     C                   ENDIF
      *
      ** If Action code is authorise
      *
     C                   IF        HSCLSACT = 'X'
     C                   IF        HSCLSSFL = 'N'
      *
      ** and F6 was pressed                                                                   187252
      *                                                                                       187252
     C***********        IF        @KeyP = *BLANKS                                            187252
     C                   IF        @KeyP = '06'                                               187252
      *
      ** Call Validation module to map data into fields
      *
     C                   EVAL      WVLDCNF = 'M'
     C                   EXSR      SRCLSV
     C                   EXSR      SRUPDT
      *
     C                   EVAL      Cmd = Cmd1 + A7MPGT + Cmd2
     C                   CALL      'QCMDEXC'
     C************       PARM                    Cmd              64                          CPK014
     C************       PARM      64            CommandLen       15 5                        CPK014
     C                   PARM                    Cmd              89                          CPK014
     C                   PARM      89            CommandLen       15 5                        CPK014
     C                   ENDIF
     C                   ELSE
     C                   EVAL      @SflAction = 'BS'
     C                   ENDIF
     C                   ENDIF
      *
     C     HSCLSACT      IFEQ      'E'
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ENDIF
     C                   MOVE      'BS'          @SflAction
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C
      *----------------------------------------------------------------
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBRWS - Build Browse Subfile
      *****************************************************************
     C     SRBRWS        BEGSR
      *
      ** Reset Read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ** Build Browse subfile
      *
     C                   CALLB     'FXCLSPBRW'
      *
      ** Input Parameters
      ** Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Action Code
     C                   PARM                    HSCLSACT
      *
      * Currency code
     C                   PARM                    HSCLSCCY
      *
      * Nostro Code
     C                   PARM                    HSCLSNST
      *
      * Value date
     C                   PARM                    HSCLSVDT
      *
      * Sequence number
     C                   PARM                    HSCLSSEQ
      *
      * No. of decimal places
     C                   PARM                    A6NBDP            1 0
      *
      * Build Sub-file
     C                   PARM      'Y'           @BDSFLB           1
      *
      * Read Subfile Record
     C                   PARM      *BLANK        @RDSFLB           1
      *
      ** Output Parameters
      ** Error Message
      *
     C                   PARM      *BLANK        @ERRMS            7
      *
      ** Option selected
     C                   PARM      *BLANK        @OPSEL            1
      *
      ** Currency selected
     C                   PARM      *BLANK        @OPCcy            3
      *
      * Nostro selected
     C                   PARM      *BLANK        @OPNST            2
      *
      * Value Date selected
     C                   PARM      *BLANK        @OPVDT            6
      *
      * Sequence number selected
     C                   PARM      *BLANK        @OPSEQ            2
      *
      * Function Keys
     C                   PARM      '0'           @INKCB            1
      * to be remove if browse module were already created
     C                   PARM      '0'           @INKLB            1
      *
      * If CK/3 taken in browse, end program
      *
     C     @INKCB        IFEQ      '1'
     C                   EXSR      SRENDP
     C                   GOTO      EBLDBR
     C                   ENDIF
      *
      ** If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@M
     C                   GOTO      EBLDBR
     C                   ENDIF
      *
      * If CK/12 not taken in browse
      * Read next browse subfile record
      *
     C     @INKLB        IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   GOTO      EBLDBR
     C                   ELSE
     C                   MOVE      'RS'          @SflAction
     C                   ENDIF
      *
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRDNB - Read Next Browse Subfile Record
      *****************************************************************
     C     SRRDNB        BEGSR
      *
      ** Read Next Subfile record
      *
     C                   CALLB     'FXCLSPBRW'
      *
      ** Input Parameters
      ** Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Action Code
     C                   PARM                    HSCLSACT
      *
      * Currency code
     C                   PARM                    HSCLSCCY
      *
      * Nostro Code
     C                   PARM                    HSCLSNST
      *
      * Value date
     C                   PARM                    HSCLSVDT
      *
      * Sequence number
     C                   PARM                    HSCLSSEQ
      *
      * No. of decimal places
     C                   PARM                    A6NBDP
      *
      * Build Sub-file
     C                   PARM      *BLANK        @BDSFLB
      *
      * Read Subfile Record
     C                   PARM      'Y'           @RDSFLB
      *
      ** Output Parameters
      ** Error Message
      *
     C                   PARM      *BLANK        @ERRMS
      *
      ** Option selected
     C                   PARM      *BLANK        @OPSEL
      *
      ** Currency selected
     C                   PARM      *BLANK        @OPCcy
      *
      * Nostro selected
     C                   PARM      *BLANK        @OPNST
      *
      * Value Date selected
     C                   PARM      *BLANK        @OPVDT
      *
      * Sequence number selected
     C                   PARM      *BLANK        @OPSEQ
      *
      * Command keys
     C                   PARM      '0'           @INKCB
     C                   PARM      '0'           @INKLB
      *
      * If Ccy, nostro, value date and sequence read from subfile
      *
     C     @OPCCY        IFNE      *BLANK
     C     @OPNST        ANDNE     *BLANK
     C     @OPVDT        ANDNE     *BLANK
     C     @OPSEQ        ANDNE     *BLANK
      *
      * Retrieve CLS schedule details
      *
     C                   MOVEL     @OPSEL        HSCLSACT
     C                   MOVEL     @OPCCY        HSCLSCCY
     C                   MOVEL     @OPNST        HSCLSNST
     C                   MOVEL     @OPVDT        HSCLSVDT
     C                   MOVEL     @OPSEQ        HSCLSSEQ
      *
      ** Set field and function key status on main details screen
      ** (according to action code)
      *
     C     @OPSEL        IFEQ      'I'
     C     @OPSEL        OREQ      'A'
     C                   EVAL      WRITEONLY = 'N'
     C                   ELSE
     C                   EVAL      WRITEONLY = 'Y'
     C                   ENDIF
      *
      ** Put the deal on the main details screen
      *
     C                   EXSR      SRRTVD
     C                   IF        OKClsPSHD = 'YYYYYYYYYYYY'
     C                   EVAL      @ScreenInd = 'D'
     C                   EVAL      @SflAction = 'BS'
     C                   ENDIF
     C                   EVAL      NHCLSACT = HSCLSACT
     C                   EXSR      SRCONV
      *
     C                   IF        HFPYTOTP > *ZEROS
     C                   EVAL      @PayRcv = 'P'
     C                   ELSE
     C                   EVAL      @PayRcv = 'R'
     C                   ENDIF
      *
      ** Else, reset read next browse subfile record
      *
     C                   ELSE
     C                   MOVEL     *BLANK        @RDNB
     C                   ENDIF
      *
      ** Go to main details screen
      *
     C                   MOVE      'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRTVD - Retrieve Pay-in Schedule Details
      *****************************************************************
     C     SRRTVD        BEGSR
      *
      * Retrieve Pay-in Schedule details and validate fields
      *
     C                   CALLB     'FXCLSPRTV'
      *
      * Inputs
      * Return code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    HSCLSACT
      *
      * Screen ccy code
     C                   PARM                    HSCLSCCY
      *
      * Screen nostro
     C                   PARM                    HSCLSNST
      *
      * Screen value date
     C                   PARM                    HSCLSVDT
      *
      * Screen sequence number
     C                   PARM                    HSCLSSEQ
      *
      * Screen Profit Centre
     C                   PARM                    HSCLSPRF
      *
      * Screen 'Time difference from CET'
     C                   PARM                    HSCLSTMD
                                                                                              CAP086
      * Automatic Authorisation                                                               CAP086
     C                   PARM                    PAuth                                        CAP086
      *                                                                                      BUG8433
     C                   PARM                    UpdateYN                                    BUG8433
      *
      * Outputs
      * Okay flags
      *
     C                   PARM                    OKClsPSHD
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * Warning Array index (3P0) from/to caller
     C                   PARM      *ZERO         WIdx
      *
      * CLS Pay-in schedule in file format - Header
     C                   PARM                    CurHedScFil
      *
      * No. of decimal places
     C                   PARM                    A6NBDP
      *
      * Multiple Pay-in generated by time indicator
     C                   PARM                    A7MPGT            1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCONV - Convert CLS Pay-in schedule maintenance from         *
      *          file format fields to screen format                  *
      *****************************************************************
     C     SRCONV        BEGSR
      *
      * Call program to fill screen fields with data from FXCLSPCVT
      *
     C                   CALLB     'FXCLSPCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Current Pay-in Schedule Header in file format
     C                   PARM                    CurHedScFil
      *
      * Outputs
      * Current Pay-in Schedule header in screen format
      *
     C                   PARM                    NewHedSCScr
      *
      * Update 'Current' Pay-in Schedule detail in screen fmt
      *
     C                   MOVEL     NewHedScScr   CurHedSCScr
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDSPD - Display CLS Pay-in schedule maintenance              *
      *****************************************************************
     C     SRDSPD        BEGSR
     C                   CallB     'FXCLSPDSP'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    @PayRcv
     C                   PARM                    @ScreenInd        1
     C                   PARM                    CurHedSCScr
     C                   PARM                    CurDetSCScr
     C                   PARM                    OkClsPSHD
     C                   PARM                    OkClsPSDT
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    WMsgDtaArr
      *
      ** Output Parameters
      *
     C                   PARM      *BLANKS       @KeyP             2
     C                   PARM                    WriteOnly
     C                   Parm                    @SflAction        2
     C                   Parm                    @SFLEOF           1
     C                   Parm                    A6NBDP
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCLSV - Validate CLS Pay-in schedule maintenance             *
      *****************************************************************
     C     SRCLSV        BEGSR
      *
     C                   CallB     'FXCLSPVAL'
     C                   PARM                    RespMode
     C                   PARM                    HSCLSACT
     C                   PARM                    @PayRcv
     C                   PARM                    WVLDCNF           1
     C                   PARM                    CurHedSCFil
     C                   PARM                    DSCLSTIM
     C                   PARM                    DSCLSAMT
     C                   PARM                    HSCLSTOR
     C                   PARM                    @SflAction
     C                   PARM                    OKClsPSHD
     C                   PARM                    OKClsPSDT
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    NewHedScFil
     C                   PARM                    NewDetScFil
     C                   PARM                    @NoTime                                      189658
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - Process Screen: Confirmation of Input
      *          evoked for inserts, Amends & Authorisations
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   MOVE      *ALL'Y'       OkClsPSHD
     C                   MOVE      *ALL'Y'       OkClsPSDT
     C                   EVAL      NHCLSACT = HSCLSACT
     C                   EXSR      SRCONV
     C                   EVAL      WVLDCNF = 'C'
      *
      * Validate CLS Pay-in schedule details
      *
     C                   EXSR      SRCLSV
      *
      * If schedule is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = '*ANY'
     C                   EVAL      WMsgIdArr(WIdx) = 'FXM3032'
     C                   ENDIF
      *
      * Write/Read Display Screen
      *
     C                   Eval      WriteOnly = 'Y'
     C     @PayRcv       IFEQ      'P'
     C                   MOVE      'CP'          @SflAction
     C                   ENDIF
     C                   EXSR      SRDSPD
      *
      * Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKClsPSHD
     C                   MOVE      *ALL'Y'       OKClsPSDT
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - End Program
      *
     C     @KeyP         CASEQ     '03'          SRENDP
      *
      ** CK/11 - Toggle - Pay/Rcv screens
      *
     C     @KeyP         CASEQ     '11'          SRPYRC
      *
      * CK/12 - Cancel on Confirmation Screen
      *
     C     @KeyP         CASEQ     '12'          SRCANC
      *
      * Exit Confirmation Screen
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPYRC - Toggle from Pay-Receive screen
      *****************************************************************
     C     SRPYRC        BEGSR
      *
     C                   IF        @PayRcv = 'P'
     C                   EVAL      @PayRcv = 'R'
     C                   ELSE
     C                   EVAL      @PayRcv = 'P'
     C                   ENDIF
      *
     C                   EVAL      @Scrn = 'M'
     C                   EVAL      @SflAction = 'BS'
     C                   MOVEL     *BLANK        NewDetSCScr
     C                   MOVEL     *BLANK        CurDetSCScr
     C                   CLEAR                   NewDetSCFil
     C                   CLEAR                   CurDetSCFil
     C                   MOVEL     *BLANKS       HSCLSTOP
     C                   MOVEL     *BLANKS       HSCLSTOR
     C                   MOVEL     *BLANKS       NHCLSTOP
     C                   MOVEL     *BLANKS       NHCLSTOR
     C                   Z-ADD     *ZEROS        HFPYTOTP
     C                   Z-ADD     *ZEROS        HFPYTOTR
     C                   Z-ADD     *ZEROS        VHCLTOTP
     C                   Z-ADD     *ZEROS        VHCLTOTR
     C                   MOVE      'N'           WriteOnly
     C                   MOVE      'D'           @ScreenInd
     C                   MOVE      'M'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCANC - Cancel on Confirmation Screen
      *****************************************************************
     C     SRCANC        BEGSR
      *
      ** Return to main details screen if not coming from confirmation scrn
      *
     C                   IF        @SCRN = 'M'
     C                   MOVEL     'I'           @ScreenInd
      *
      * Initialize field status on main details screen
      *
     C                   MOVEL     *BLANK        NewHedSCScr
     C                   MOVEL     *BLANK        NewDetSCScr
     C                   MOVEL     *BLANK        CurHedSCScr
     C                   MOVEL     *BLANK        CurDetSCScr
     C                   ELSE
     C                   MOVE      'N'           WriteOnly
     C                   MOVE      'D'           @ScreenInd
     C                   MOVE      'M'           @SCRN
     C     @PayRcv       IFEQ      'P'
     C                   MOVE      'CP'          @SflAction
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@M - Send a Message to main details screen
      *****************************************************************
     C     SNDM@M        BEGSR
      *
      ** If error msg not blanks
      *
     C     @ERRMS        IFEQ      'FXM3023'
     C                   MOVE      'N'           HCLSACTOK
     C                   END
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - Exit from Confirmation Screen
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * If no errors in validation
      *
     C     Idx           IFEQ      *ZERO
      *
      * Continue with updates
      *
     C                   MOVEL     'U'           @SCRN
      *
      * Else, Return to main details screen
      *
     C                   ELSE
     C                   MOVEL     'M'           @SCRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPDT - Updates CLS Pay-in Schedule
      *****************************************************************
     C     SRUPDT        BEGSR
      *
      ***If*enter*pressed,*update*header*and*detail*file                                      187252
      ** If enter/F6/F10 pressed, update header and detail file                               187252
      *
     C                   IF        RetCodeOut = *BLANKS
      *
     C                   CALLB     'FXCLSPUPD'
     C                   PARM                    RetCodeOut
     C                   PARM                    HSCLSACT
     C                   PARM                    @PayRcv
     C                   PARM                    NewHedScFil
     C                   PARM                    NewDetScFil
     C                   PARM      'H'           @HdrDtl           1
     C                   PARM      'N'           UpdOthr           1
      *
     C                   IF        RetCodeOut = *BLANKS
     C                   IF        HSCLSACT = 'I' AND
     C                             @PAYRCV = 'P' OR
     C                             HSCLSACT = 'A' AND
     C                             @PAYRCV = 'P'
     C                   Eval      @SflAction = 'RD'
      *
     C                   EXSR      SRDSPD
      *
      ** Update Allocation file format via validate module
      *
     C     @SFLEOF       DoWEq     'N'
     C     DSCLSTIM      IFNE      *BLANKS
     C*****DSCLSAMT      ANDNE     *BLANKS                                                    189658
     C     DSCLSAMT      ORNE      *BLANKS                                                    189658
      *
      ** Call validation module only if screen not blank, otherwise skip
      *
     C                   EVAL      WVLDCNF = 'V'
     C                   EXSR      SRCLSV
      *
      ** Insert/Update one record to Allocation file
      *
     C                   CallB     'FXCLSPUPD'
     C                   PARM                    RetCodeOut
     C                   PARM                    HSCLSACT
     C                   PARM                    @PayRcv
     C                   PARM                    NewHedScFil
     C                   PARM                    NewDetScFil
     C                   PARM      'D'           @HdrDtl
     C                   PARM      'N'           UpdOthr
     C                   ENDIF
      *
      ** Retrieve one record from subfile ("RC" Read next sfl entry)
      *
     C                   Eval      @SFLAction = 'RC'
     C                   EXSR      SRDSPD
      *
     C                   EndDo
      *
      ** Insert/Update/Delete record whichever is necessary
      *
     C     HSCLSACT      IFEQ      'A'
     C                   CallB     'FXCLSPUPD'
     C                   PARM                    RetCodeOut
     C                   PARM                    HSCLSACT
     C                   PARM                    @PayRcv
     C                   PARM                    NewHedScFil
     C                   PARM                    NewDetScFil
     C                   PARM      'D'           @HdrDtl
     C                   PARM      'Y'           UpdOthr
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Insert/Update shadow files
      *
     C                   IF        RetCodeOut = *BLANKS
     C                   IF        HSCLSACT = 'I' OR
     C                             HSCLSACT = 'A' OR
     C                             HSCLSACT = 'D'
     C                   CallB     'FXCLSPUPD'
     C                   PARM                    RetCodeOut
     C                   PARM                    HSCLSACT
     C                   PARM                    @PayRcv
     C                   PARM                    NewHedScFil
     C                   PARM                    NewDetScFil
     C                   PARM      'S'           @HdrDtl
     C                   PARM      'N'           UpdOthr
     C                   ENDIF
     C                   ENDIF
      *
     C                   If        RetCodeOut <> *Blank And
     C                             RetCodeOut <> '*RECUPD'
     C                   Eval      @SCRN = 'T'
     C                   Eval      @SflEof = 'Y'
     C                   If        CSC022 = 'N'                                               CSC022
     C                   Rolbk
     C                   ELSE                                                                 CSC022
     C                   If        COMITSKIP <> 'Y'                                           CSC022
     C                   Rolbk                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Exsr      *PSSR
     C                   Else
     C                   If        CSC022 = 'N'                                               CSC022
     C                   Commit
     C                   ELSE                                                                 CSC022
     C                   If        COMITSKIP <> 'Y'                                           CSC022
     C                   Commit                                                               CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Endif
      *
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
      *
     C
     C     RetCodeOut    IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'FXM3036'     MsgIdArr(1)
     C                   ENDIF
     C
      *
      ** Blank the main details screen
      *
     C                   MOVEL     *BLANK        NewHedSCScr
     C                   MOVEL     *BLANK        NewDetSCScr
     C                   MOVEL     *BLANK        CurHedSCScr
     C                   MOVEL     *BLANK        CurDetSCScr
     C                   EVAL      @ScreenInd = 'I'
      *
      * If Records are still to be read from the subfile, Read them
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * Else, Return to main details screen
      *
     C                   MOVEL     'M'           @SCRN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRENDP - End Program
      *****************************************************************
     C     SRENDP        BEGSR
      *
      * Issue rollback to clear any possible updates in window function
      *
     C     BGWDPR        IFEQ      'Y'
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   END
      *
     C                   MOVEL     'T'           @SCRN
     C                   ENDSR
      *****************************************************************                       CAP084
      /EJECT                                                                                  CAP084
      *****************************************************************                       CAP084
      * SRROLL - Roll Forwards and Backwards Through The File         *                       CAP084
      *****************************************************************                       CAP084
     C     SrRoll        BEGSR                                                                CAP084
                                                                                              CAP084
      ** Default action code to enquiry if not valid                                          CAP084
                                                                                              CAP084
     C                   IF        HSCLSACT <> 'E' AND                                        CAP084
     C                             HSCLSACT <> 'A' AND                                        CAP084
     C                             HSCLSACT <> 'D' AND                                        CAP084
     C                             HSCLSACT <> 'X'                                            CAP084
     C                   EVAL      HSCLSACT = 'E'                                             CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
      ** Read next(if F8) or previous(if F7) record on Deals file                             CAP084
                                                                                              CAP084
     C                   IF        @KeyP = '07'                                               CAP084
     C                   EVAL      PRdFwd = *BLANK                                            CAP084
     C                   EVAL      PRdBck = 'Y'                                               CAP084
     C                   ELSE                                                                 CAP084
     C                   EVAL      PRdFwd = 'Y'                                               CAP084
     C                   EVAL      PRdBck = *BLANK                                            CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   CALLB     'FXCLSPRED'                                                CAP084
                                                                                              CAP084
      ** Input Parameters:                                                                    CAP084
                                                                                              CAP084
      ** Return Code                                                                          CAP084
     C                   PARM      *BLANKS       RetCodeOut                                   CAP084
      ** Action Code                                                                          CAP084
     C                   PARM                    HSCLSACT                                     CAP084
      ** Currency code                                                                        CAP084
     C                   PARM                    HSCLSCCY                                     CAP084
      ** Nostro Code                                                                          CAP084
     C                   PARM                    HSCLSNST                                     CAP084
      ** Value date                                                                           CAP084
     C                   PARM                    HSCLSVDT                                     CAP084
      ** Sequence number                                                                      CAP084
     C                   PARM                    HSCLSSEQ                                     CAP084
      ** Read Forwards                                                                        CAP084
     C                   PARM                    PRdFwd                                       CAP084
      ** Read Backwards                                                                       CAP084
     C                   PARM                    PRdBck                                       CAP084
                                                                                              CAP084
      ** Output Parameters :                                                                  CAP084
                                                                                              CAP084
      ** Error meassage                                                                       CAP084
     C                   PARM                    @ERRMS                                       CAP084
      ** Currency read                                                                        CAP084
     C                   PARM                    @OPCCY                                       CAP084
      ** Nostro Number read                                                                   CAP084
     C                   PARM                    @OPNST                                       CAP084
      ** Value Date read                                                                      CAP084
     C                   PARM                    @OPVDT                                       CAP084
      ** CLS Sequence Number read                                                             CAP084
     C                   PARM                    @OPSEQ                                       CAP084
                                                                                              CAP084
      ** If error message returned from read, send it to detail screen                        CAP084
                                                                                              CAP084
     C                   IF        @ERRMS <> *BLANKS                                          CAP084
     C                   EXSR      SNDM@M                                                     CAP084
     C                   GOTO      ESrRoll                                                    CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
      ** If deal was read, retrieve deal details                                              CAP084
                                                                                              CAP084
     C                   IF        @OPCCY <> *BLANKS AND                                      CAP084
     C                             @OPNST <> *BLANKS AND                                      CAP084
     C                             @OPVDT <> *BLANKS AND                                      CAP084
     C                             @OPSEQ <> *BLANKS                                          CAP084
     C                   EVAL      HSCLSACT = @OPSEL                                          CAP084
     C                   EVAL      HSCLSCCY = @OPCCY                                          CAP084
     C                   EVAL      HSCLSNST = @OPNST                                          CAP084
     C                   EVAL      HSCLSVDT = @OPVDT                                          CAP084
     C                   EVAL      HSCLSSEQ = @OPSEQ                                          CAP084
                                                                                              CAP084
     C                   EXSR      SRRTVD                                                     CAP084
                                                                                              CAP084
      ** Put the deal on the main details screen                                              CAP084
                                                                                              CAP084
     C                   EVAL      WRITEONLY = 'Y'                                            CAP084
     C                   EVAL      @ScreenInd = 'D'                                           CAP084
     C                   MOVE      'M'           @SCRN                                        CAP084
     C                   EVAL      NHCLSACT = HSCLSACT                                        CAP084
     C                   EXSR      SRCONV                                                     CAP084
                                                                                              CAP084
     C                   IF        HFPYTOTP > *ZEROS                                          CAP084
     C                   EVAL      @PayRcv = 'P'                                              CAP084
     C                   ELSE                                                                 CAP084
     C                   EVAL      @PayRcv = 'R'                                              CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C     ESrRoll       ENDSR                                                                CAP084
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'FXCLSPSIN'   DBPGM
      *
      ** Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Dealing Details
      *
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRtCd                                        CSC022
     C                   PARM      '*VERIFY'     POptn                                        CSC022
     C                   PARM      'CSC022'      PSard                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        PRtCd = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   IN        SCCMTJOB                                                   CSC022
     C                   Z-ADD     1             CNT                                          CSC022
     C                   MOVEL     *BLANKS       COMITSKIP                                    CSC022
     C                   MOVEA     COMITARR      COMITJOB                                     CSC022
     C     COMITNUM      IFGT      0                                                          CSC022
     C     CNT           DOWLE     COMITNUM                                                   CSC022
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                              CSC022
     C                   MOVEL     'Y'           COMITSKIP                                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ADD       1             CNT                                          CSC022
     C                   ENDDO                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
      ** Database error                                                                       CSC022
                                                                                              CSC022
     C                   IF        PRtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 903                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      *
      ** Start on Main Details Screen
      *
     C                   MOVEL     'M'           @SCRN             1
      *
      ** Initialize field and function key status on main details screen
      *
     C                   EVAL      @ScreenInd = 'I'
     C                   CLEAR                   NewHedScFil
     C                   CLEAR                   NewDetScFil
     C                   CLEAR                   NewHedScScr
     C                   CLEAR                   NewDetScScr
     C                   CLEAR                   CurHedScFil
     C                   CLEAR                   CurDetScFil
     C                   CLEAR                   CurHedScScr
     C                   CLEAR                   CurDetScScr
      *
      ** Parameter list for Validation module
      *
     C     PFXCLSVAL     PList
     C                   PARM                    RespMode
     C                   PARM                    @PayRcv
     C                   PARM                    WVLDCNF           1
     C                   PARM                    CurHedSCFil
     C                   PARM                    DSCLSTIM
     C                   PARM                    DSCLSAMT
     C                   PARM                    HSCLSTOR
     C                   PARM                    OKClsPSHD
     C                   PARM                    OKClsPSDT
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx               3 0
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx              3 0
     C                   PARM                    NewHedScFil
     C                   PARM                    NewDetScFil
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,FXCLSPSIC2
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
