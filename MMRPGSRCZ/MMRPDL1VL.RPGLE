     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate subfile detail records')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMRPDL1VL - MM Repo Details Validation                       *
      *                                                               *
      *  Function: This Program Validates Repo Details entered via    *
      *            the Repurchase agreements subfile.                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 249481             Date 31Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG11193           Date 02May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 08Apr02               *
      *                 CSC011             Date 14Mar02               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 185128             Date 18Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      *                 CAP039             Date 29Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 1June99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  249481 - Fix the dimension of arrays passed to some modules  *
      *           waiting for more than defined here                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE031 - Coupon Fixing for Floating Rate Notes. (Recompile)  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP067 - Repurchase Agreements API.                          *
      *  185128 - DBError 001 when '?' entered for the Depot but      *
      *           Customer is not selected from the selection screen  *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CAP039 - Conversion of SD inputs into modular structure to   *
      *           use as APIs. SECURITY CUSTOMER DETAILS  (recompile) *
      *  CSE006 - Repurchase Agreements.                              *
      *                                                               *
      *****************************************************************
 
     FSECTY     IF   E           K DISK
     F                                     INFSR(*PSSR)
     FINVTP     IF   E           K DISK
     F                                     INFSR(*PSSR)
     FDPTMVDL1  IF   E           K DISK
     F                                     INFSR(*PSSR)
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     D DDDPAD          S              6A
      ** Blank Field Passed to SEDPMVVAL
 
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
      ** Warning error message fields received as parameters
     D     WMsg1       S                   LIKE(#MsgID)
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
     D MSGDATA4        S                   LIKE(#MsgData)
 
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
     D BFZONE        E                     EXTFLD(SEZONE)                                    BUG3122
     D**  Security Details
     D SECTYD        E DS                  EXTNAME(SECTY)
     D**  Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
 
     D W#RDNB          S                   LIKE(BJRDNB)
     D WJDFIN          S                   LIKE(BJDFIN)
     D TJDFIN          S                   LIKE(BJDFIN)
     D NomCcyDec       S              1P 0
     D DADJN           S              1A
      ** Nominal
     D  NOML           S             11P 0
      ** Accrued indicator
     D  ZACIN          S              1A
      ** Day adjustment
     D  ZDADJ          S              3P 0
      ** Actual Difference indicator
     D  ZADIN          S              1A
      ** Coupon rate (trade)
     D TDCR            S             11P 7
      ** Overide Indicator
     D  ZCPOVR         S              1A
      ** Midas Day No Formatted Value Date
     D ValueDate       S              5  0
 
      ** Midas Day No Formatted Value Date
     D MaturDate       S              5  0
 
      ** Main Loan Ccy
     D LoanCcy         S              3
     D ActMode         S              1A
     D DepRef          S              6A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** PORTFOLIO MANAGEMENT DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** MODULE DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
 
     D TranIn        E DS                  EXTNAME(MMRPDDPD)
     D                                     PREFIX(IK:2)
      * Incoming Transaction
 
     D NwRpFilFmt    E DS                  EXTNAME(MMVRPDDPD)
      * Incoming Transaction in File Format
 
     D OKFlagsDS     E DS                  EXTNAME(MMERPDDPD)
      * Error Indicator flags
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The maximum size of the appended error arrays
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
 
     D*XArrayMax       C                   CONST(20)                                          249481
     D XArrayMax       C                   CONST(40)                                          249481
     D FldNamXAr       S             10A   DIM(XArrayMax)
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
     D WFldNmXAr       S             10A   DIM(XArrayMax)
     D WMsgIdxAr       S                   DIM(XArrayMax) LIKE(#MsgId)
     D WMsgDtXar       S                   DIM(XArrayMax) LIKE(#MsgData)
     D
     D Branch          S              3A
     D
     D BenCust         S             10A
     D
     D PortRef         S              4A
     D
      ** Data structure for MULTIBRANCH Indicator using rundat.
     D RUNDAT          DS
     D  RunDate                8     10P 0
     D  MBIN                  13     13
                                                                                              CAP067
     D P#ORDP2         S              6S 0                                                    CAP067
 
     D**** DPBN            S              6S 0                                                CSD027
     D DPBN            S              6                                                       CSD027
     D BFCLASCust      S              1A
 
      ** Spot Rate for Delivery Currency
     D DsRate          S             15S 8
 
      ** Spot Rate for Counter Currency
     D CsRate          S                   LIKE(DsRate)
 
      ** Spot Rate for Euro
     D EsRate          S                   LIKE(DsRate)
 
      ** Numeric Input (also the output)
     D   ZFIELD        S             16A
     D   ZFLD15        S             15  0
 
      ** Number of decimal position
     D   ZADEC         S              1P 0
 
     D CSC011          S              1A   INZ('N')                                           CSC011
     D WProcDate       S                   LIKE(BJRDNB)                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     C
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C
      *                                                                                       CAP067
      ** Determine whether program is running interactively or in batch                       CAP067
      **  ( 0 = batch   1 = interactive)                                                      CAP067
      *                                                                                       CAP067
     C                   CALLB     'ZARTVJOBA'                                                CAP067
     C                   PARM                    @Return           6                          CAP067
     C                   PARM                    @type             1                          CAP067
      *                                                                                       CAP067
      ** Validate Action Code
     C                   CALLB     'MMVACCD'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
     C                   PARM                    MSG5
     C                   PARM                    TranIn
     C                   PARM                    ActMode
     C                   PARM                    DepRef
     C                   PARM                    Branch
     C                   PARM                    NwRpFilFmt
     C
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKACTN'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKACTN'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKACTN'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C
     C     MSG4          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKACTN'
     C                   EVAL      MsgIDArr(Idx) = MSG4
     C                   ENDIF
     C
     C     MSG5          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKACTN'
     C                   EVAL      MsgIDArr(Idx) = MSG5
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKACTN
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   EXSR      RESETERRS
     C
      ** Validate Security Shortname
     C                   CALLB     'MMVSESH'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
     C                   PARM                    MSG5
     C                   PARM                    WMSG1
     C                   PARM                    IKSECT
     C                   PARM                    LoanCcy
     C                   PARM                    ValueDate
     C                   PARM                    MaturDate
     C                   PARM                    IFSECT
     C
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKSECT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKSECT'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKSECT'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C
     C     MSG4          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKSECT'
     C                   EVAL      MsgIDArr(Idx) = MSG4
     C                   ENDIF
     C
     C     MSG5          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKSECT'
     C                   EVAL      MsgIDArr(Idx) = MSG5
     C                   ENDIF
     C
     C     WMSG1         IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'IKSECT'
     C                   EVAL      WMsgIdArr(WIdx) = WMSG1
     C                   ENDIF
     C
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKSECT
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   EXSR      RESETERRS
     C
      ** Validate Value Price
     C                   CALLB     'MMVVLPR'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    IKVALP
     C                   PARM                    IKSECT
     C                   PARM                    IFVALP
     C                   PARM                    ValueDate
     C
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKVALP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKVALP'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKVALP
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C
 
     C                   EXSR      RESETERRS
     C                   MOVE      *BLANKS       @@KEY1
     C                   CLEAR                   SDCUST
     C                   CLEAR                   DSSDY
      *
      ** Access Customer data via access program
      *  (database error handling done in access program)
      *
     C**********         IF        %subst(IKORDP:1:1) = '?'                                   CAP067
      *                                                                                       CAP067
     C     '?'           SCAN      IKORDP                                 01                  CAP067
      *                                                                                       CAP067
     C                   IF        *IN01 = *ON                                                CAP067
      *                                                                                       CAP067
     C                   IF        @type = '1'                                                CAP067
      *                                                                                       CAP067
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      '?'           @AENB             6
     C     SDSECS        PARM      SDSECS        DSSDY
      *                                                                                       CAP067
     C                   IF        BFCUST <> *BLANKS
     C                   EVAL      IKORDP = *BLANKS                                           CAP067
     C                   MOVEL     BFCUST        IKORDP
     C                   MOVEL     BFCUST        @@KEY1                                       CAP067
     C                   ENDIF
      *                                                                                       CAP067
     C                   ELSE                                                                 CAP067
      *                                                                                       CAP067
     C                   MOVEL     *BLANKS       @@KEY1                                       CAP067
      *                                                                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ELSE                                                                 CAP067
      *                                                                                       CAP067
     C                   MOVEL     IKORDP        @@KEY1                                       CAP067
      *                                                                                       CAP067
     C                   ENDIF
      *
     C**********         IF        %subst(IKORDP:1:1) <> '?'                                  CAP067
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C**********         PARM      IKORDP        @@KEY1           10                          CAP067
     C                   PARM                    @@KEY1           10                          CAP067
     C                   PARM      *BLANKS       @@KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
     C*
     C     @@RTCD        IFEQ      *BLANKS
     C                   MOVEL     BBCSSN        P#ORDP           10
     C                   MOVEL     BBCSSN        P#ORDP1          10
     C**********         MOVE      BBCUST        P#ORDP2           6 0                        CAP067
     C                   MOVE      BBCUST        P#ORDP2                                      CAP067
     C                   ELSE
     C                   MOVE      *BLANKS       P#ORDP           10
     C                   MOVE      *BLANKS       P#ORDP1
     C                   MOVE      *BLANKS       P#ORDP2
     C                   MOVE      *BLANKS       BBCSSN
     C                   MOVE      *BLANKS       BBCUST
     C                   ENDIF
     C***********        ENDIF                                                                CAP067
 
     C
      ** Validate Out Depot
     C                   CALLB     'SEVDOUTDP'
     C                   PARM                    ReturnCode
     C                   PARM                    P#ORDP1
     C                   PARM      *BLANKS       DDDPAD
     C                   PARM                    SDSECS
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKORDP
     C                   PARM                    P#ORDP2
 
     C     OKORDP        IFEQ      'N'
 
     C                   Z-ADD     1             I                 2 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   EVAL      FldNameArr(I) = 'IKORDP'
     C                   MOVEA     MsgIDXAr      MsgIDArr(I)
     C                   MOVEA     MsgDtaXar     MsgDtaArr(I)
     C                   ENDIF
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
     C
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKORDP
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C
     C                   ENDIF
     C
     C                   IF        BBCSSN <> *BLANKS
     C                   EVAL      IKORDP = BBCSSN
     C                   MOVE      BBCUST        IFORDP
     C                   ENDIF
     C
     C                   EXSR      RESETERRS
     C                   MOVE      *BLANKS       @@KEY1
     C                   CLEAR                   SDCUST
     C                   CLEAR                   DSSDY
      *
      ** Access Customer data via access program
      *  (database error handling done in access program)
      *
     C**********         IF        %subst(IKCPDP:1:1) = '?'                                   CAP067
      *                                                                                       CAP067
     C     '?'           SCAN      IKCPDP                                 01                  CAP067
      *                                                                                       CAP067
     C                   IF        *IN01 = *ON                                                CAP067
      *                                                                                       CAP067
     C                   IF        @type = '1'                                                CAP067
      *                                                                                       CAP067
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      '?'           @AENB
     C     SDSECS        PARM      SDSECS        DSSDY
      *
     C                   IF        BFCUST <> *BLANKS
     C                   EVAL      IKCPDP = *BLANKS                                           CAP067
     C                   MOVEL     BFCUST        IKCPDP
     C                   MOVEL     BFCUST        @@KEY1                                       CAP067
     C                   ENDIF
      *                                                                                       CAP067
     C                   ELSE                                                                 CAP067
      *                                                                                       CAP067
     C                   MOVEL     *BLANKS       @@KEY1                                       CAP067
      *                                                                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ELSE                                                                 CAP067
      *                                                                                       CAP067
     C                   MOVEL     IKCPDP        @@KEY1                                       CAP067
      *                                                                                       CAP067
     C                   ENDIF
      *
     C**********         IF        %subst(IKCPDP:1:1) <> '?'                                  CAP067
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C**********         PARM      IKCPDP        @@KEY1           10                          CAP067
     C                   PARM                    @@KEY1           10                          CAP067
     C                   PARM      *BLANKS       @@KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
     C*
     C     @@RTCD        IFEQ      *BLANKS
     C                   MOVEL     BBCSSN        P#CPDP           10
     C                   MOVE      BBCSSN        P#ORDP1
     C                   MOVE      BBCUST        P#ORDP2
     C                   ELSE
     C                   MOVE      *BLANKS       P#CPDP           10
     C                   MOVE      *BLANKS       P#ORDP1
     C                   MOVE      *BLANKS       P#ORDP2
     C                   MOVE      *BLANKS       BBCSSN
     C                   MOVE      *BLANKS       BBCUST
     C                   ENDIF
     C**********         ENDIF                                                                CAP067
     C
      ** Validate Counterparty Depot
     C                   CALLB     'SEVDOUTDP'
     C                   PARM                    ReturnCode
     C                   PARM                    P#ORDP1
     C                   PARM      *BLANKS       DDDPAD
     C                   PARM                    SDSECS
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKCPDP
     C                   PARM                    P#ORDP2
 
     C     OKCPDP        IFEQ      'N'
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   EVAL      FldNameArr(I) = 'IKCPDP'
     C                   MOVEA     MsgIDXAr      MsgIDArr(I)
     C                   MOVEA     MsgDtaXar     MsgDtaArr(I)
     C                   ENDIF
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
     C
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKCPDP
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C
     C                   ENDIF
     C
     C                   IF        BBCSSN <> *BLANKS
     C                   EVAL      IKCPDP = BBCSSN
     C                   MOVE      BBCUST        IFCPDP
     C                   ENDIF
 
     C                   EXSR      RESETERRS
 
      ** Validate exchange rate
     C                   CALLB     'MMVEXRT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    IKEXCR
     C                   PARM                    IKSECT
     C                   PARM                    LoanCcy
     C                   PARM                    IFEXCR
     C
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKEXCR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKEXCR'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKEXCR'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKEXCR
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C
     C** Validate Security Nominal Amount if security is a valid security
     C
     C                   IF        OKSECT <> 'N'
     C
     C** Obtain Beneficiary Customer Details for call
      *
      ** Access Customer data via access program
      *  (database error handling done in access program)
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C                   PARM      BenCust       @@KEY1           10
     C                   PARM      *BLANKS       @@KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
     C*
     C*****@RTCD*        IFNE      *BLANKS                                                    185128
     C     @@RTCD        IFNE      *BLANKS                                                    185128
     C                   MOVEL     'BenCust'     DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   EXSR      *PSSR                                        ************
     C                   ENDIF
     C*
     C                   MOVE      BBCUST        DPBN
 
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BBCUST        @SCKY             6
     C     SDSECS        PARM      SDSECS        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     BBCUST        DBKEY
     C                   MOVEL     'SDSECSPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
     C                   MOVE      BFCLAS        BFCLASCust
     C
     C
     C                   CALLB     'SEVDNMLAMT'
     C                   PARM                    ReturnCode
     C                   PARM                    IKNOML
     C                   PARM                    P#ORDP
     C                   PARM                    P#CPDP
     C                   PARM                    PortRef
     C                   PARM                    IKSECT
     C                   PARM                    Branch
     C                   PARM                    DPBN
     C                   PARM                    BFCLASCust
     C                   PARM                    RunDate
     C                   PARM                    S01496
     C                   PARM                    FCR997
     C                   PARM                    CSE007
     C                   PARM                    CEU017
     C                   PARM                    BGN4ST            1
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    OKNOML
     C                   PARM                    W#NOML           11 0
     C                   PARM                    @PCOLF            1
 
     C     OKNOML        IFEQ      'N'
 
     C                   Z-ADD     1             I                 2 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   Eval      FldNameArr(I) = 'IKNOML'
     C                   MOVEA     MsgIDXAr      MsgIDArr(I)
     C                   MOVEA     MsgDtaXar     MsgDtaArr(I)
     C                   ENDIF
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
      *
      *
     C
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKNOML
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C
     C                   ENDIF
      *
     C                   IF        OKNOML <> 'N'
      *
     C     IKSECT        CHAIN     SECTY                              99
     C
     C                   MOVE      W#NOML        ZFLD15
     C
 
     C                   MOVE      NMDP          ZADEC
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   Z-ADD     0             IFNOML
     C                   MOVE      W#NOML        IFNOML
     C                   MOVE      *BLANKS       IKNOML
     C                   MOVE      ZOUT21        IKNOML
     C
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   EXSR      RESETERRS
     C
     C                   IF        OKNOML <> 'N' and OKVALP <> 'N'
     C                             and OKEXCR <> 'N' and OKSECT <> 'N'
     C
     ** Access Investment Details
     C     INVTPK        KLIST
     C                   KFLD                    NMCY
     C                   KFLD                    SITP
     C     INVTPK        CHAIN     INVTPDF                            90
 
     C** Access no of decimal places of Nominal currency
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      NMCY          @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   MOVE      A6NBDP        NomCcyDec
     C                   MOVE      A6NBDP        ZADEC
 
     C                   IF        PROT <> '2' and PROT <> '4' and PROT <> '7'
     C**********         EVAL      W#RDNB = BJRDNB                                            CSC011
     C                   EVAL      W#RDNB = WProcDate                                         CSC011
 
     C                   CALLB     'SEVTACCRIN'
     C                   PARM                    ReturnCode
     C                   PARM      'Y'           Default           1
     C                   PARM      'N'           Validate          1
     C                   PARM      *Blank        DDACIN            1
     C                   PARM      ValueDate     TDVD              5 0
     C                   PARM                    SECTYD
     C                   PARM                    PROT
     C                   PARM      TJDFIN        WJDFIN
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDAcinOK          1
     C                   PARM                    ACIN              1
      *
     C**********         EVAL      BJRDNB = W#RDNB                                            CSC011
     C                   EVAL      BJRDNB = WProcDate                                         CSC011
 
     C                   CALLB     'ZPCINT'
 
     C                   PARM                    SECTYD
     C                   PARM      *BLANK        DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM      W#NOML        NOML
     C                   PARM      DDACIN        ZACIN
     C                   PARM      *ZERO         ZDADJ
     C                   PARM      *BLANK        ZADIN
     C                   PARM      CPNR          TDCR
     C                   PARM      *BLANK        ZCPOVR
     C                   PARM      TJDFIN        WJDFIN
     C                   PARM      ValueDate     ECD               5 0
     C                   PARM                    ZITRA
     C                   PARM                    ZTINA
     C*
     C** Calculate cross currency rate
     C*
     C     ZITRA         MULT      IFEXCR        ZFLD15
 
     C                   MOVE      ZITRA         ZFLD15
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   Z-ADD     0             IFVDIN
     C                   MOVE      ZFLD15        IFVDIN
     C                   MOVE      *BLANKS       IKVDIN
     C                   MOVE      ZOUT21        IKVDIN
     C
     C                   ELSE
     C                   Z-ADD     0             IFVDIN
     C                   Z-ADD     0             ZFLD15
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        IKVDIN
     C
     C                   ENDIF
     C
      *
      ** Set Up Value Date Value. Call ZPRCI to convert to Percentage Price if not already in this
      ** format.
      *
      ** Price/Discount/Yield
      ** Value Date
      *
     C                   MOVE      IFVALP        ZPRCIN           15 8
     C                   MOVE      ValueDate     ZFDATE            5 0
      *
      * Nominal
      *
     C                   Z-ADD     IFNOML        ZNOML            15 0
      *
      ** Calculate PI as a fraction of Nominal
      *
     C     IFNOML        IFNE      0
     C     IFVDIN        DIV       IFNOML        WRKPI            15 9
     C                   ELSE
     C                   Z-ADD     0             WRKPI
     C                   END
 
     C                   EXSR      PRICD
     C*
     C** Set up ZPRC. Multiply ZPRCOT by 10 first as ZPRC has an extra Decimal place
     C                   Z-ADD     0             ZPRC
     C                   MULT      10            ZPRCOT
     C                   MOVE      ZPRCOT        ZPRC
 
 
     C                   CALLB     'ZCNSD'
     C                   PARM      W#NOML        ZNOML            15 0
     C                   PARM                    ZPRC             16 9
     C                   PARM                    SPBS
     C                   PARM                    NMDP
     C                   PARM                    NomCcyDec
 
      * OUTPUTS
 
      **  Consideration
     C                   PARM                    ZCONS            15 0
 
      **  Add consideration to any interest
     C     ZCONS         ADD       ZFLD15        W#VDVL           15 0
     C
     C                   MOVE      W#VDVL        ZFLD15
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   Z-ADD     0             IFVDVL
     C                   MOVE      ZFLD15        IFVDVL
     C                   MOVE      *BLANKS       IKVDVL
     C                   MOVE      ZOUT21        IKVDVL
     C
     ** Set Up Maturity Date Interest if security is interest bearing
 
     C                   IF        PROT <> '2' and PROT <> '4' and PROT <> '7'
 
     C                   CALLB     'ZPCINT'
 
     C                   PARM                    SECTYD
     C                   PARM      *BLANK        DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM      W#NOML        NOML
     C                   PARM      DDACIN        ZACIN
     C                   PARM      *ZERO         ZDADJ
     C                   PARM      *BLANK        ZADIN
     C                   PARM      CPNR          TDCR
     C                   PARM      *BLANK        ZCPOVR
     C                   PARM      TJDFIN        WJDFIN
     C                   PARM      MaturDate     ECD               5 0
     C                   PARM                    ZITRA
     C                   PARM                    ZTINA
     C*
     C** Calculate cross currency rate
     C*
     C     ZITRA         MULT      IFEXCR        ZFLD15
 
     C                   MOVE      ZITRA         ZFLD15
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   Z-ADD     0             IFMDIN
     C                   MOVE      ZFLD15        IFMDIN
     C                   MOVE      *BLANKS       IKMDIN
     C                   MOVE      ZOUT21        IKMDIN
     C
     C                   ELSE
     C                   Z-ADD     0             IFMDIN
     C                   Z-ADD     0             ZFLD15
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        IKMDIN
     C
     C                   END
 
     ** Set Up Maturity Date Value
 
      **  Add consideration to any interest
     C     ZCONS         ADD       ZFLD15        W#VDVL           15 0
     C
     C                   MOVE      W#VDVL        ZFLD15
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   Z-ADD     0             IFMDVL
     C                   MOVE      ZFLD15        IFMDVL
     C                   MOVE      *BLANKS       IKMDVL
     C                   MOVE      ZOUT21        IKMDVL
     C
     C                   ENDIF
     C
     C*
     C** Check that Details have not been changed for Nominal, Value Price,
     C** Exchange Rate and Our depot if Rundate is not equal to Original
     C** Entry date.
     C**********         IF        IKACTN <> 'I'                                              CAP067
     C                   IF        IKACTN <> 'I' and OKFlagsDS = *ALL'Y'                      CAP067
     C     IKDPMV        CHAIN     DPTMVDL1                           89
     C                   IF        *IN89 = *OFF
     C**********         IF        BJRDNB <> ORED                                             CSC011
     C                   IF        WProcDate <> ORED                                          CSC011
     C*
     C**Check Nominal has not changed
     C                   IF        IFNOML <> DPNA
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKNOML'
     C                   MOVE      'MMA0788'     MsgIDArr(Idx)
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKNOML
     C                   PARM      'Error'       ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDIF
     C                   EXSR      RESETERRS
     C*
     C**Check Value Price has not changed
     C                   IF        IFVALP <> MKTP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKVALP'
     C                   MOVE      'MMA0789'     MsgIDArr(Idx)
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKVALP
     C                   PARM      'Error'       ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDIF
     C*
     C**Check Exchange rate had not Changed
     C                   IF        IFEXCR <> DEXRT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKEXCR'
     C                   MOVE      'MMA0790'     MsgIDArr(Idx)
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKEXCR
     C                   PARM      'Error'       ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDIF
     C*
     C**Check Our Depot has not changed
     C                   IF        IFORDP <> DPID
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKVALP'
     C                   MOVE      'MMA0791'     MsgIDArr(Idx)
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKVALP
     C                   PARM      'Error'       ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C                   ENDIF
     C                   RETURN
 
 
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset Error processing indicators                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
 
     C                   RESET                   MSGDATA
 
     C                   EVAL      ReturnCode= *Blanks
 
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode          1
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    LoanCcy
     C                   PARM                    Branch
     C                   PARM                    ValueDate
     C                   PARM                    MaturDate
     C                   PARM                    BenCust
     C                   PARM                    PortRef
     C                   PARM                    ActMode
     C                   PARM                    DepRef
      * Receive Datastructure for Error indicatirs flags
     C                   PARM                    OKFlagsDS
      * Receive Datastructure for Field Name Array
     C                   PARM                    FldNameArr
      * Receive Datastructure for Message ID Array
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwRpFilFmt
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMRPDL1VL'   DBPGM
     C                   OUT       LDA
      *
      ** Read data area - RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check if switchable feature S01496 is switched on.
      *
     C                   MOVE      'N'           S01496            1
 
      *
      **  Access Bank Details via Access Object
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   EVAL      TJDFIN = BJDFIN
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01496'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
     C                   EXSR      *PSSR                                        ************
     C                   ELSE
     C                   MOVE      'Y'           S01496
     C                   END
      *
      ** Check if switchable feature CSE007 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE007'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSE007'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSE007
     C                   ELSE
     C                   MOVE      'N'           CSE007            1
     C                   END
      *
      ** Check if switchable feature CEU017 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU017'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU017'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU017
     C                   ELSE
     C                   MOVE      'N'           CEU017            1
     C                   END
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 905                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If 24X7 Midas availability is installed and support system is                        CSC011
      ** active, used processing date from dataarea SC24X7 as the                             CSC011
      ** rundate.                                                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
     C                   EVAL      WProcDate = S1DATE                                         CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      WProcDate = BJRDNB                                         CSC011
     C                   ENDIF                                                                CSC011
      *
      *
      ** Get Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '007'         DBASE                          * DBERR 007*
     C                   EXSR      *PSSR                                        ************
     C                   END
      *
      ** Access Portfolio Management Details
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE                         ************
     C                   MOVEL     '008'         DBASE                          * DBERR 008*
     C                   EXSR      *PSSR                                        ************
     C                   END
      *
     C                   END
      *
      ***  Define and zeroize the Purchased Interest and Interest
      ***  Adjustment Output fields and Interest work fields.
      *
     C                   Z-ADD     *ZEROS        ZITRA            13 0
     C                   Z-ADD     *ZEROS        ZTINA            13 0
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** DEFAULTING                                                   *
      *****************************************************************
     C     PRICD         BEGSR
      *
      ** Setup Parameter list
      *
      * Cum/Ex ind.
      *
     C     DDACIN        IFEQ      'X'
     C                   MOVE      'X'           SCUMEX            1
     C                   ELSE
     C                   MOVE      'C'           SCUMEX
     C                   END
      *
      ** Calculate % price from yield
      *
     C                   CALLB     'ZPRCI'
     C                   PARM                    ZPRCIN
     C                   PARM                    ZFDATE
     C                   PARM                    SECTYD
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    ZNOML
     C                   PARM                    WRKPI
     C                   PARM                    SCUMEX
     C                   PARM                    BJDFIN
     C                   PARM                    ZYLDOk            1
     C                   PARM                    ZPRCOT           15 8
 
     C                   ENDSR
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
