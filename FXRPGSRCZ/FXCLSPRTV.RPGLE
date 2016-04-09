     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX CLS pay-in schedule retrieve')                *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXCLSPRTV - CLS Pay-in Schedule Retrieve                     *
      *                                                               *
      *  Function:  This module retrieves the Pay-in schedule from    *
      *             the database. As it does so, it validates the     *
      *             key fields: Action code, Currency, Nostro, Value  *
      *             date, Sequence number, Profit Centre and 'Time    *
      *             difference from CET'.                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSC054             Date 23Feb12               *
      *  Prev Amend No. CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 235339             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8433            Date 20Jul05               *
      *                 BUG8503            Date 14Sep05               *
      *                 BUG8270            Date 26Aug05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG5671            Date 31Jan05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 02Jul03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 193563             Date 30Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 187923             Date 20Dec00               *
      *                 187730             Date 15Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186964             Date 24Nov00               *
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC054 - Period End Adjustments                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  235339 - Only check for Effective date if CCY is valid.      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8433- Not to validate sequence no. if second pass         *
      *           (confirm complete).                                 *
      *  BUG8503 -Sequence number is zero during plaback.             *
      *  BUG8270 - TD1417 - CLSP:Incorrect error message for          *
      *            duplicate CLSP in EL System.                       *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG5671- Add Sequence number to detail record (recompile)    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  193563 - Database error due to array index out-of-range for  *
      *           warning message 'FXM3038'. Add 1 to WI.             *
      *  187923 - 2 tier authorisation for CLS pay-in schedules       *
      *  187730 - Allow enquiry of deleted CLS pay-in schedules       *
      *  186964 - Value date must not be prior to Effective date      *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFXCLSPSHL0IF   E           K DISK    INFSR(*PSSR)
     FPRONO     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(PRONOHHF)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF:ACCNTACF)
 
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
     FFXCLSPSDL3IF   E           K DISK    INFSR(*PSSR)                                       CAP084
     F                                     PREFIX(D_)                                         CAP084
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
 
     D*PSysVal1        C                   CONST('OMEIndicator')                       CAP086 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      *
      ** Data structure to separate time difference field
 
     D PNB             DS
     D  @PB                    1     40P 0
     D                                     DIM(5)
      *
      ** Data structure used to divide projected nostro balances field
      ** into subfields representing daily balances
 
     D PND             DS
     D  @PD                    1     15P 0
     D                                     DIM(5)
      *
      ** Data structure used to separate dates received from LF/PRONO
      ** into separate fields
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Bank Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** External DS for Branch Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External DS for Currency Details
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      ** External DS for Nostro Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** External DS for Module Details
 
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      *
      ** External DS for Profit Centre Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** First DS for Access Programs, Long Data Structure
 
     D CurrCLSHed    E DS                  EXTNAME(FXCLSPSH)
      *
      ** Current CLS Pay-in Schedule-Header in file format
 
     D OKClsPSHD     E DS                  EXTNAME(FXECLSPHPD)
                                                                                              CSD015
      ** 24X7 status data area                                                                CSD015
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD015
                                                                                              CSD015
      ** SD data area                                                                         CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD015
                                                                                              CSD015
      ** External DS for SAR details                                                          CSD015
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD015
     D  #LCD         E                     EXTFLD(LCD)                                        CSD015
                                                                                              CSD015
      ** External DS for Compliance Watch Transaction Details                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      *
      ** Error indicators - Header
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WI              S              3P 0
 
      ** CLS Sequence field - numeric
     D WCLSSEQ         S              2  0
 
     D***P@ACCDCD        S              4A                                                    CGL029
     D P@ACCD          S             10A                                                      CGL029
     D P@ACSN          S              2A
     D P@BRCD          S              3A
     D P@CSSN          S             10A
     D P@CUST          S              6A
     D P@CYCD          S              3A
     D P@NONB          S              2A
     D P@PNOI          S              1A
 
      ** Parameter used for ZALIGN
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
 
                                                                                              CSD015
     D CSC011          S              1                                                       CSD015
     D CSD015          S              1                                                       CSD015
     D WFuncType       S              8                                                       CSD015
     D WIdntifier      S             40                                                       CSD015
     D WIden1          S              5                                                       CSD015
     D WIden2          S              2                                                       CSD015
     D WBranch         S              3                                                       CSD015
     D PSard           S              6                                                       CSC015
     D PFunc           S              8                                                       CSC015
     D PRetCode        S              7                                                       CSD015
     D POption         S              7                                                       CSD015
     D UpdateYN        S              1                                                      BUG8433
                                                                                              CAP084
      ** Parameters for SFC000026                                                             CAP084
     D PUser           S             10A                                                      CAP084
                                                                                              CAP086
     D PRtCd           S              7A                                                      CAP086
     D P@OP01          S             20A                                                      CAP086
     D P@VL01          S            200A                                                      CAP086
     D P@OP02          S             20A                                                      CAP086
     D P@VL02          S            200A                                                      CAP086
     D P@OP03          S             20A                                                      CAP086
     D P@VL03          S            200A                                                      CAP086
     D P@OP04          S             20A                                                      CAP086
     D P@VL04          S            200A                                                      CAP086
     D P@OP05          S             20A                                                      CAP086
     D P@VL05          S            200A                                                      CAP086
     D P@OP06          S             20A                                                      CAP086
     D P@VL06          S            200A                                                      CAP086
     D P@OP07          S             20A                                                      CAP086
     D P@VL07          S            200A                                                      CAP086
     D P@OP08          S             20A                                                      CAP086
     D P@VL08          S            200A                                                      CAP086
     D P@OP09          S             20A                                                      CAP086
     D P@VL09          S            200A                                                      CAP086
     D P@OP10          S             20A                                                      CAP086
     D P@VL10          S            200A                                                      CAP086
                                                                                              CAP086
      ** Define variable for switchable CAP086                                                CAP086
     D*CSC024***       S              1A                                               CAP086 CSC054
     D*WOMEInd**       S              1A                                               CAP086 CSC054
     D CSC054          S              1A                                                      CSC054
     D WPEAInd         S              1A                                                      CSC054
     D CLAUTH          S              1A                                                      CAP086
                                                                                              CAP086
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      ** Perform initialisation to clear outputs
      *
     C                   EXSR      INIT
      *
      ** Validate Action Code, Currency, Nostro, Value Date, Sequence,
      ** Profit Centre
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     CLSACTOK      IFEQ      'N'
     C     CLSCCYOK      OREQ      'N'
     C     CLSNSTOK      OREQ      'N'
     C     CLSVDTOK      OREQ      'N'
     C     CLSSEQOK      OREQ      'N'
     C     CLSPRFOK      OREQ      'N'
     C     CLSTMDOK      OREQ      'N'
     C                   RETURN
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C     CLSACT        IFEQ      'E'
     C                   EXSR      VALACE
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'X' *
      *  *--------------------------------*
      *
     C     CLSACT        IFEQ      'X'
     C                   EXSR      VALACX
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *
     C     CLSACT        IFEQ      'I'
     C                   EXSR      VALACI
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C     CLSACT        IFEQ      'A'
     C                   EXSR      VALACA
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C     CLSACT        IFEQ      'D'
     C                   EXSR      VALACD
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
      *
     C     CLSACTOK      IFEQ      'N'
     C     CLSCCYOK      OREQ      'N'
     C     CLSNSTOK      OREQ      'N'
     C     CLSVDTOK      OREQ      'N'
     C     CLSSEQOK      OREQ      'N'
     C     CLSPRFOK      OREQ      'N'
     C     CLSTMDOK      OREQ      'N'
     C                   RETURN
     C                   ENDIF
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
      *
      ** Access Security Checking
      ** Access Security Checking - for Single branching
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      ACSSEC
      *
      ** If multibranching
      *
     C                   ELSE
     C                   EXSR      ACSSEM
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      SETFLD
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - Validation of Action Code and Header fields
      *****************************************************************
     C     VAL           BEGSR
      *
      ** Check action code is valid.
      *
     C     CLSACT        IFNE      'I'
     C     CLSACT        ANDNE     'A'
     C     CLSACT        ANDNE     'D'
     C     CLSACT        ANDNE     'E'
     C     CLSACT        ANDNE     'X'
     C                   MOVE      'N'           CLSACTOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3001'     MsgIdArr(Ix)
     C                   ENDIF
      *
      ** Currency Code Validation :
      ** Check that currency code is not blank and it must be a valid
      ** currency on SDCURRPD
      *
     C     CLSCCY        IFEQ      *BLANKS
     C                   MOVE      'N'           CLSCCYOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSCCY'      FldNameArr(Ix)
     C                   MOVEL     'FXM3002'     MsgIdArr(Ix)
     C                   ELSE
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C     CLSCCY        PARM      CLSCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** If does not exist on currency details file, then issue error msg
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           CLSCCYOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSCCY'      FldNameArr(Ix)
     C                   MOVEL     'FXM3003'     MsgIdArr(Ix)
     C                   ELSE
      *
      ** If ccy entered is not a CLS currency
      *
     C     A6CLSC        IFNE      'Y'
     C                   MOVE      'N'           CLSCCYOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSCCY'      FldNameArr(Ix)
     C                   MOVEL     'FXM3004'     MsgIdArr(Ix)
     C                   ENDIF
     C                   Z-ADD     A6NBDP        WNBDP
     C                   ENDIF
     C                   ENDIF
      *
      ** Nostro Code Validation:
      ** Nostro code must be a valid nostro and must exist on SDNOSTPD.
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       P@CUST
     C     CLSCCY        PARM      CLSCCY        P@CYCD
     C                   PARM      *BLANKS       P@ACCD
     C                   PARM      *BLANKS       P@ACSN
     C     CLSNST        PARM      CLSNST        P@NONB
     C                   PARM      *BLANKS       P@BRCD
     C                   PARM      *BLANKS       P@CSSN
     C                   PARM      *BLANKS       P@PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           CLSNSTOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSNST'      FldNameArr(Ix)
     C                   MOVEL     'FXM3005'     MsgIdArr(Ix)
     C                   ELSE
      *
      ** Must be CLS dummy nostro
      *
     C     A7CLSD        IFNE      'Y'
     C                   MOVE      'N'           CLSNSTOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSNST'      FldNameArr(Ix)
     C                   MOVEL     'FXM3006'     MsgIdArr(Ix)
     C                   ENDIF
     C                   MOVE      A7BRCD        WBRCD             3
     C                   MOVE      A7MPGT        WMPGT             1
     C                   ENDIF
      *
      ** Value Date validation:
      ** Value date must not be blanks
      *
     C     CLSACT        IFEQ      'I'
     C     CLSACT        OREQ      'A'
     C     CLSVDT        IFEQ      *BLANKS
     C                   MOVE      'N'           CLSVDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSVDT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3007'     MsgIdArr(Ix)
      *
      ** Value date must be numeric
      *
     C                   ELSE
     C                   TESTN                   CLSVDT               9899
     C     *IN98         IFEQ      '0'
     C     *IN99         ANDEQ     '0'
     C                   MOVE      'N'           CLSVDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSVDT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3008'     MsgIdArr(Ix)
      *
      ** Must be in valid date format
      *
     C                   ELSE
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      CLSVDT        Date              6
     C                   PARM                    BJDFIN
     C                   PARM                    DayNumber         5 0
     C     RetCodeOut    IFNE      *BLANKS
     C                   MOVE      'N'           CLSVDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSVDT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3009'     MsgIdArr(Ix)
     C                   ELSE
      *
      ** Issue warning msg if value date is different from today
      *
     C     DayNumber     IFGT      BJRDNB
     C                   ADD       1             WI
     C                   MOVEL     'CLSVDT'      WFldNamArr(WI)
     C                   MOVEL     'FXM3010'     WMsgIdArr(WI)
     C                   ENDIF
      *                                                                                       186964
      ** Value date must not be prior to Effective date of currency                           186964
      *                                                                                       186964
     C     CLSCCYOK      IFNE      'N'                                                        235339
     C     DayNumber     IFLT      A6EFDT                                                     186964
     C                   MOVE      'N'           CLSVDTOK                                     186964
     C                   ADD       1             Ix                                           186964
     C                   MOVEL     'CLSVDT'      FldNameArr(Ix)                               186964
     C                   MOVEL     'FXM3039'     MsgIdArr(Ix)                                 186964
     C                   ENDIF                                                                186964
     C                   ENDIF                                                                235339
      *                                                                                       186964
     C                   ENDIF
      *
      ** Using the Ccy and dummy nostro code, chain to PRONO
      *
     C     CLSCCYOK      IFEQ      'Y'
     C     CLSNSTOK      ANDEQ     'Y'
     C                   MOVE      CLSCCY        KCCYD
     C                   MOVE      CLSNST        KNOSN
     C     KEYPRN        CHAIN     PRONOPNF                           90
      *
      ** Value date must be one of the projected nostro dates.
      ** Otherwise if back-valued, get Projected Nostro Balance of
      ** first PNB date. If forward-dated but a holiday, show warning
      ** and get the Projected Nostro Balance of the previous PNB date.
      *
     C                   IF        NOT *IN90 AND
     C                             RECI = 'D'
     C                   Z-ADD     1             X                 3 0
     C     DayNumber     IFGE      BJRDNB
     C     DayNumber     LOOKUP    @PD(X)                                 91
     C                   ELSE
     C                   EVAL      *IN91 = *ON
     C                   ADD       1             WI
     C                   MOVEL     'CLSVDT'      WFLDNamArr(WI)
     C                   MOVEL     'FXM3037'     WMsgIdArr(WI)
     C                   ENDIF
     C                   IF        NOT *IN91
     C     DayNumber     IFLT      @PD(5)
     C                   ADD       1             WI                                           193563
     C                   MOVEL     'CLSVDT'      WFLDNamArr(WI)
     C                   MOVEL     'FXM3038'     WMsgIdArr(WI)
     C                   Z-ADD     5             X
     C     X             DOWGT     1
     C     @PD(X)        ANDGT     DayNumber
     C                   SUB       1             X
     C                   ENDDO
     C                   MOVE      @PB(X)        WCLNBL
     C                   IF        WCLNBL < *ZERO
     C                   Z-SUB     WCLNBL        WCLNBL
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CLSVDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSVDT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3011'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ELSE
     C     DayNumber     IFLT      BJRDNB
     C                   EVAL      X = 1
     C                   ENDIF
     C                   MOVE      @PB(X)        WCLNBL           15 0
     C                   IF        WCLNBL < *ZERO
     C                   Z-SUB     WCLNBL        WCLNBL
     C                   ENDIF
     C                   ENDIF
      *
      ** Combination of Ccy and Dummy nostro must exist on PRONO
      *
     C                   ELSE
     C                   MOVE      'N'           CLSVDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSVDT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3012'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **  Sequence number validation
      *
     C     CLSSEQ        IFNE      *BLANKS
      *
      ** Sequence number must be blank for insert
      *
     C     CLSACT        IFEQ      'I'
     C     CLAUTH        ANDNE     'Y'                                                       BUG8270
     C     CLSACT        OREQ      'I'                                                       BUG8270
     C     CLAUTH        ANDNE     'Y'                                                       BUG8270
     C     CLSACT        OREQ      'I'                                                       BUG8270
     C*****CSC024        ANDNE     'Y'                                                BUG8270 CSC054
     C     CSC054        ANDNE     'Y'                                                        CSC054
     C     CLSACT        OREQ      'I'                                                       BUG8433
     C     UpdateYN      ANDNE     'Y'                                                       BUG8433
     C                   MOVE      'N'           CLSSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSSEQ'      FldNameArr(Ix)
     C                   MOVEL     'FXM3013'     MsgIdArr(Ix)
      *
      ** Sequence number should be numeric for non-insert
      *
     C                   ELSE
     C                   TESTN                   CLSSEQ               9899
     C     *IN98         IFEQ      '0'
     C     *IN99         ANDEQ     '0'
     C                   MOVE      'N'           CLSSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSSEQ'      FldNameArr(Ix)
     C                   MOVEL     'FXM3014'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      ** Generate next available sequence number if action is insert
      *
     C                   ELSE
     C     CLSACT        IFEQ      'I'
     C     CLSCCYOK      IFEQ      'Y'
     C     CLSNSTOK      ANDEQ     'Y'
     C     CLSVDTOK      ANDEQ     'Y'
     C                   MOVE      CLSCCY        KCCYD
     C                   MOVE      CLSNST        KNSTN
     C                   MOVE      DayNumber     KVDAT
     C     KYPSHS        SETGT     FXCLSPSHL0
     C                   READP     FXCLSPSHL0                             90
      *
      ** If record found and ccy, nostro code and value date are the
      ** same, add 1 to sequence number, otherwise, sequence number
      ** should be 1.
      *
     C     *IN90         IFEQ      '0'
     C     KCCYD         ANDEQ     PYCCY
     C     KNSTN         ANDEQ     PYNOST
     C     KVDAT         ANDEQ     PYVALD
     C                   EVAL      WCLSSEQ = PYSEQN + 1
     C                   ELSE
     C                   Z-ADD     1             WCLSSEQ
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CLSSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSSEQ'      FldNameArr(Ix)
     C                   MOVEL     'FXM3015'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      ** Profit Centre Validation
      *
     C     CLSPRF        IFEQ      *BLANKS
      *
      ** If PCA is on, profit centre is mandatory.  On insert, this
      ** should be defaulted.
      *
     C     BGN0ST        IFEQ      'Y'
     C/COPY WNCPYSRC,FXH00217
     C     CLSACT        IFEQ      'I'
     C     CLSNSTOK      ANDEQ     'Y'
     C                   MOVE      A7LPR         P@NONB
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       P@CUST
     C                   PARM      CLSCCY        P@CYCD
     C                   PARM      *BLANKS       P@ACCD
     C                   PARM      *BLANKS       P@ACSN
     C                   PARM                    P@NONB
     C                   PARM      *BLANKS       P@BRCD
     C                   PARM      *BLANKS       P@CSSN
     C                   PARM      *BLANKS       P@PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      A7CUST        KCUSN
     C                   MOVE      A7CYCD        KCCYD
     C                   MOVE      A7ACCD        KACOD
     C                   MOVE      A7ACSN        KACSN
     C                   MOVE      A7BRCD        KBRCD
      *
      ** Retrieve the profit centre on ACCNT file to be defaulted
      *
     C     KYACCT        CHAIN     ACCNTABF                           90
     C     *IN90         IFEQ      '0'
     C                   MOVE      PRFC          CLSPRF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Profit centre should not be blank if Analytical acctng is on
      *
     C     CLSPRF        IFEQ      *BLANKS
     C                   MOVE      'N'           CLSPRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSPRF'      FldNameArr(Ix)
     C                   MOVEL     'FXM3016'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Must be a valid profit centre on profit centre file
      *
     C                   ELSE
     C                   CALLB     'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C     CLSPRF        PARM      CLSPRF        @PCCD             4
     C     SDPRFC        PARM      SDPRFC        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           CLSPRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSPRF'      FldNameArr(Ix)
     C                   MOVEL     'FXM3017'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      ** Local time difference from CET validation:
      *
     C                   IF        CLSTMD = *BLANKS
     C                   IF        CLSCCYOK = 'Y' AND
     C                             CLSNSTOK = 'Y'
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WBRCD         @BRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           CLSTMDOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSTMD'      FldNameArr(Ix)
     C                   MOVEL     'FXM3018'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     A8TDCE        CLSTMD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       WTIME             4
     C                   MOVE      CLSTMD        WCHAR             1
     C                   Z-ADD     4             W                 1 0
     C     WCHAR         DOWEQ     *BLANK
     C     1             SUBST     CLSTMD:W      WCHAR
     C                   SUB       1             W
     C                   ENDDO
     C     WCHAR         IFEQ      '+'
     C     W             ANDNE     *ZERO
     C     WCHAR         OREQ      '-'
     C     W             ANDNE     *ZERO
     C     W             SUBST     CLSTMD:1      WTIME
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WTIME         ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      4             ZADIG
      *
     C     ZALIGNOK      IFEQ      'N'
     C                   MOVE      'N'           CLSTMDOK
     C                   ELSE
     C     2             SUBST     ZFIELD:13     WHRST             2
     C                   MOVE      WHRST         WHOUR             2 0
     C                   MOVE      ZFIELD        WMINS             2 0
      *
      ** Check for HH:MM format
      *
     C     WHOUR         IFGE      0
     C     WHOUR         ANDLE     23
     C     WMINS         ANDGE     0
     C     WMINS         ANDLE     59
     C                   MOVEL     WHOUR         WTIME
     C                   MOVE      WMINS         WTIME
     C                   MOVEL     WTIME         CLSTMD
     C                   MOVE      WCHAR         CLSTMD
     C                   ELSE
     C                   MOVE      'N'           CLSTMDOK
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      'N'           CLSTMDOK
     C                   ENDIF
      *
      ** If CLS time is not valid, issue error msgs
      *
     C                   IF        CLSTMDOK = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'CLSTMD'      FldNameArr(Ix)
     C                   MOVEL     'FXM3025'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - Validation of Action Code 'E'
      *****************************************************************
     C     VALACE        BEGSR
      *
      ** Check record exists on LF/FXCLSPSHL0 and is live
      *
     C                   MOVE      CLSCCY        KCCYD
     C                   MOVE      CLSNST        KNSTN
 
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      CLSVDT        Date              6
     C                   PARM                    BJDFIN
     C                   PARM                    DayNumber         5 0
 
     C                   MOVE      DayNumber     KVDAT
     C                   MOVE      CLSSEQ        KSEQN
     C     KYPSHF        CHAIN     FXCLSPSHL0                         90
     C     *IN90         IFEQ      '1'
     C******IN90*        OREQ      '0'                                                        187730
     C*****PYRECI        ANDNE     'D'                                                        187730
     C                   MOVE      'N'           CLSCCYOK
     C                   MOVE      'N'           CLSNSTOK
     C                   MOVE      'N'           CLSVDTOK
     C                   MOVE      'N'           CLSSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNAmeArr(Ix)
     C                   MOVEL     'FXM3019'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACX - Validation of Action Code 'X'
      *****************************************************************
     C     VALACX        BEGSR
      *
      ** Check record exists on LF/FXCLSPSHL0 and is live
      *
     C                   MOVE      CLSCCY        KCCYD
     C                   MOVE      CLSNST        KNSTN
 
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      CLSVDT        Date              6
     C                   PARM                    BJDFIN
     C                   PARM                    DayNumber         5 0
 
     C                   MOVE      DayNumber     KVDAT
     C                   MOVE      CLSSEQ        KSEQN
     C     KYPSHF        CHAIN     FXCLSPSHL0                         90
     C     *IN90         IFEQ      '1'
     C     *IN90         OREQ      '0'
     C     PYRECI        ANDNE     'D'
     C                   MOVE      'N'           CLSCCYOK
     C                   MOVE      'N'           CLSNSTOK
     C                   MOVE      'N'           CLSVDTOK
     C                   MOVE      'N'           CLSSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3019'     MsgIdArr(Ix)
      *
      ** Authorise Pay-in Schedule flag must be 'N'
      *
     C                   ELSE
     C     PYSNTF        IFNE      'N'
     C                   MOVE      'N'           CLSACTOK
     C                   MOVE      'N'           CLSCCYOK
     C                   MOVE      'N'           CLSNSTOK
     C                   MOVE      'N'           CLSVDTOK
     C                   MOVE      'N'           CLSSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3020'     MsgIdArr(Ix)
     C                   ELSE                                                                 187923
      *                                                                                       187923
      ** Authorising user must not be same as inserting/amending user                         187923
      *                                                                                       187923
     C                   EXSR      SrGetUser                                                  CAP084
                                                                                              CAP084
     C*****PSUser        IFEQ      PYUSER                                              187923 CAP084
     C                   IF        PUser = PYUSER                                             CAP084
                                                                                              CAP086
     C                   IF        CLAUTH = 'Y'  AND                                          CAP086
     C**********                   WOMEInd = 'Y' AND                                   CAP086 CSC054
     C*********                    CSC024 = 'Y'                                        CAP086 CSC054
     C                             WPEAInd = 'Y' AND                                          CSC054
     C                             CSC054 = 'Y'                                               CSC054
                                                                                              CAP086
      ***Bypass*validation*if*from*replay*and*in*OME*system                            CAP086 CSC054
      ** Bypass validation if from replay and in PEA system                                   CSC054
                                                                                              CAP086
     C                   ELSE                                                                 CAP086
                                                                                              CAP086
     C                   MOVE      'N'           CLSACTOK                                     187923
     C                   MOVE      'N'           CLSCCYOK                                     187923
     C                   MOVE      'N'           CLSNSTOK                                     187923
     C                   MOVE      'N'           CLSVDTOK                                     187923
     C                   MOVE      'N'           CLSSEQOK                                     187923
     C                   ADD       1             Ix                                           187923
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)                               187923
     C                   MOVEL     'FXM3040'     MsgIdArr(Ix)                                 187923
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP084
     C                   ELSE                                                                 CAP084
                                                                                              CAP084
      ** Do not allow authorisation if there are no detail records                            CAP084
                                                                                              CAP084
     C     KYPSHF        CHAIN     FXCLSPSDL3                         81                      CAP084
     C                   IF        *IN81 = *ON                                                CAP084
     C                   EVAL      CLSACTOK = 'N'                                             CAP084
     C                   EVAL      CLSCCYOK = 'N'                                             CAP084
     C                   EVAL      CLSNSTOK = 'N'                                             CAP084
     C                   EVAL      CLSVDTOK = 'N'                                             CAP084
     C                   EVAL      CLSSEQOK = 'N'                                             CAP084
     C                   ADD       1             Ix                                           CAP084
     C                   EVAL      FldNameArr(Ix) = 'CLSACT'                                  CAP084
     C                   EVAL      MsgIdArr(Ix) = 'FXM3043'                                   CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDIF                                                                187923
      *                                                                                       187923
     C                   ENDIF
     C                   ENDIF
      *
      ** If the CLSP transaction exists in the hit list, setup error message                  CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
     C                   IF        (CSC011 = 'N' OR CSC011 = 'Y'                              CSD015
     C                             AND LIBR = S1MAIN)                                         CSD015
     C                   EVAL      WFuncType = 'FXCLSPSH'                                     CSD015
     C                   MOVEL     PYVALD        WIDEN1                                       CSD015
     C                   MOVEL     PYSEQN        WIDEN2                                       CSD015
     C                   EVAL      WIdntifier = PYCCY + PYNOST +                              CSD015
     C                             WIDEN1 + WIDEN2                                            CSD015
     C                   EVAL      WBranch = A7BRCD                                           CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
     C                   IF        %FOUND(SDCWHTL1) AND W3TREL <> 'Y'                         CSD015
     C                   MOVE      'N'           CLSACTOK                                     CSD015
     C                   MOVE      'N'           CLSCCYOK                                     CSD015
     C                   MOVE      'N'           CLSNSTOK                                     CSD015
     C                   MOVE      'N'           CLSVDTOK                                     CSD015
     C                   MOVE      'N'           CLSSEQOK                                     CSD015
     C                   EVAL      Ix = Ix + 1                                                CSD015
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)                               CSD015
     C                   EVAL      MsgIdArr(Ix) = 'MMM0797'                                   CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C     EVALAX        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - Validation of Action Code 'A'
      *****************************************************************
     C     VALACA        BEGSR
      *
      ** Check record exists on LF/FXCLSPSHL0 and is live
      *
     C                   MOVE      CLSCCY        KCCYD
     C                   MOVE      CLSNST        KNSTN
     C                   MOVE      DayNumber     KVDAT
     C                   MOVE      CLSSEQ        KSEQN
     C     KYPSHF        CHAIN     FXCLSPSHL0                         90
     C     *IN90         IFEQ      '1'
     C     *IN90         OREQ      '0'
     C     PYRECI        ANDNE     'D'
     C                   MOVE      'N'           CLSCCYOK
     C                   MOVE      'N'           CLSNSTOK
     C                   MOVE      'N'           CLSVDTOK
     C                   MOVE      'N'           CLSSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3019'     MsgIdArr(Ix)
      *
      ** Authorise Pay-in Schedule flag must be 'N'
      *
     C                   ELSE
     C     PYSNTF        IFNE      'N'
     C                   MOVE      'N'           CLSACTOK
     C                   MOVE      'N'           CLSCCYOK
     C                   MOVE      'N'           CLSNSTOK
     C                   MOVE      'N'           CLSVDTOK
     C                   MOVE      'N'           CLSSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3021'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - Validation of Action Code 'D'
      *****************************************************************
     C     VALACD        BEGSR
      *
      ** Check record exists on LF/FXCLSPSHL0 and is live
      *
     C                   MOVE      CLSCCY        KCCYD
     C                   MOVE      CLSNST        KNSTN
 
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      CLSVDT        Date              6
     C                   PARM                    BJDFIN
     C                   PARM                    DayNumber         5 0
 
     C                   MOVE      DayNumber     KVDAT
     C                   MOVE      CLSSEQ        KSEQN
     C     KYPSHF        CHAIN     FXCLSPSHL0                         90
     C     *IN90         IFEQ      '1'
     C     *IN90         OREQ      '0'
     C     PYRECI        ANDNE     'D'
     C                   MOVE      'N'           CLSCCYOK
     C                   MOVE      'N'           CLSNSTOK
     C                   MOVE      'N'           CLSVDTOK
     C                   MOVE      'N'           CLSSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3019'     MsgIdArr(Ix)
     C                   ELSE
      *
      ** Issue warning msg if schedule was already authorise
      *
     C                   IF        PYSNTF = 'Y'
     C                   ADD       1             WI
     C                   MOVEL     'CLSACT'      WFLDNamArr(WI)
     C                   MOVEL     'FXM3030'     WMsgIdArr(WI)
     C                   ENDIF
      *
      ** Pay-in schedule cannot be deleted if already posted
      *
     C     PYPOST        IFEQ      'Y'
     C                   MOVE      'N'           CLSACTOK
     C                   MOVE      'N'           CLSCCYOK
     C                   MOVE      'N'           CLSNSTOK
     C                   MOVE      'N'           CLSVDTOK
     C                   MOVE      'N'           CLSSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3035'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - Validation of Action Code 'I'
      *****************************************************************
     C     VALACI        BEGSR
      *
      ** Check record does not exists on LF/FXCLSPSHL0
      *
     C                   MOVE      CLSCCY        KCCYD
     C                   MOVE      CLSNST        KNSTN
     C                   MOVE      DayNumber     KVDAT
     C                   MOVE      CLSSEQ        KSEQN
     C     KYPSHF        CHAIN     FXCLSPSHL0                         90
     C     *IN90         IFEQ      '0'
     C                   MOVE      'N'           CLSCCYOK
     C                   MOVE      'N'           CLSNSTOK
     C                   MOVE      'N'           CLSVDTOK
     C                   MOVE      'N'           CLSSEQOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3022'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSEC - Access Security Checking - Single Branching
      *****************************************************************
     C     ACSSEC        BEGSR
      *
      ** Validate action codes for user
      *
     C                   CALL      'ZVACTU'
     C                   PARM      CLSACT        ZACTN             1
     C                   PARM                    ERR               1 0
      *
      ** This action code invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           CLSACTOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3023'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      * ACSSEM - Access Security Checking - Multi-Branching
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      ** If insertion
      ** Set up the booking branch code field with default value
      *
     C     CLSACT        IFEQ      'I'
      *
     C                   MOVE      BRC           ZBR
     C                   ELSE
     C                   IF        CLSCCYOK = 'Y' AND
     C                             CLSNSTOK = 'Y'
     C                   MOVE      WBRCD         ZBR
     C                   ENDIF
     C                   ENDIF
      *
      ** Check that the branch code exists on SDBRCHPD
      *
     C     CLSACT        IFEQ      'I'
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WBRCD         @BRCA             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           CLSACTOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3023'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     A8BRCD        ZBR
     C                   ENDIF
     C                   ENDIF
      *
      ** If valid branch on insert then check user authority to
      ** action/branch, also if not insert.
      *
     C     CLSACT        IFEQ      'I'
     C     @RTCD         ANDEQ     *BLANKS
     C     CLSACT        ORNE      'I'
     C                   CALL      'ZVACTBU'
     C                   PARM      CLSACT        ZACTN             1
     C                   PARM                    ZBR               3
     C                   PARM                    ERR               1 0
      *
      ** no valid action codes for user/branch combination
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           CLSACTOK
      *
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3023'     MsgIdArr(Ix)
     C                   ENDIF
      *
      * this action code invalid for user/branch combination
      *
     C     ERR           IFEQ      2
     C                   MOVE      'N'           CLSACTOK
     C                   ADD       1             Ix
     C                   MOVEL     'CLSACT'      FldNameArr(Ix)
     C                   MOVEL     'FXM3023'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETFLD - Set Header file fields
      *****************************************************************
     C     SETFLD        BEGSR
      *
      ** Set file fields if no errors on all screen fields for insert
      *
     C     CLSACT        IFEQ      'I'
     C     CLSCCYOK      IFEQ      'Y'
     C     CLSNSTOK      ANDEQ     'Y'
     C     CLSVDTOK      ANDEQ     'Y'
     C     CLSSEQOK      ANDEQ     'Y'
     C     CLSPRFOK      ANDEQ     'Y'
     C     CLSTMDOK      ANDEQ     'Y'
     C                   MOVE      CLSCCY        PYCCY
     C                   MOVE      CLSNST        PYNOST
     C                   MOVE      DayNumber     PYVALD
     C                   IF        CLSACT = 'I' AND                                          BUG8503
     C                             CLAUTH = 'Y' AND                                          BUG8503
     C**********                   CSC024 = 'Y'                                       BUG8503 CSC054
     C                             CSC054 = 'Y'                                               CSC054
     C                   ELSE                                                                BUG8503
     C                   MOVE      WCLSSEQ       CLSSEQ
     C                   ENDIF                                                               BUG8503
     C                   MOVE      CLSSEQ        PYSEQN
     C                   MOVE      CLSPRF        PYPRFC
     C                   MOVEL     CLSTMD        PYTIMD
      *
      ** Nostro Balance Total
      *
     C                   IF        @PB(X) < *ZERO
     C                   Z-ADD     WCLNBL        PYNSBP
     C                   Z-ADD     *ZERO         PYNSBR
     C                   ELSE
     C                   Z-ADD     WCLNBL        PYNSBR
     C                   Z-ADD     *ZERO         PYNSBP
     C                   ENDIF
      *
      ** If action is insert, zeroise total pay and receive
      *
     C                   Z-ADD     0             PYTOTP
     C                   Z-ADD     0             PYTOTR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CAP084
      *****************************************************************                       CAP084
      *  SrGetUser - Get web browser user                             *                       CAP084
      *****************************************************************                       CAP084
     C     SrGetUser     BEGSR                                                                CAP084
                                                                                              CAP084
     C                   CALL      'SFC000026'                                                CAP084
     C                   PARM      *BLANKS       PUser                                        CAP084
                                                                                              CAP084
     C                   IF        PUser = *BLANKS                                            CAP084
     C                   EVAL      PUser = PSUser                                             CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDSR                                                                CAP084
      *****************************************************************                       CAP084
     C/EJECT
      *****************************************************************
      * INIT - Clear Output fields
      *****************************************************************
     C     INIT          BEGSR
      *
     C                   CLEAR                   CurrCLSHed
     C                   MOVEL     'Y'           CLSACTOK
     C                   MOVEL     'Y'           CLSCCYOK
     C                   MOVEL     'Y'           CLSNSTOK
     C                   MOVEL     'Y'           CLSVDTOK
     C                   MOVEL     'Y'           CLSSEQOK
     C                   MOVEL     'Y'           CLSPRFOK
     C                   MOVEL     'Y'           CLSTMDOK
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (Front office Transaction Interface)
      * Mode = '      ' (Not front office Transaction Interface)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Screen Action Code
     C                   PARM                    CLSACT            1
      *
      * Screen ccy code
     C                   PARM                    CLSCCY            3
      *
      * Screen nostro
     C                   PARM                    CLSNST            2
      *
      * Screen value date
     C                   PARM                    CLSVDT            6
      *
      * Screen sequence number
     C                   PARM                    CLSSEQ            2
      *
      * Screen Profit Centre
     C                   PARM                    CLSPRF            4
      *
      * Screen 'Time difference from CET'
     C                   PARM                    CLSTMD            5
                                                                                              CAP086
      * Automatic Authorisation flag                                                          CAP086
     C                   PARM                    CLAUTH                                       CAP086
      *                                                                                      BUG8433
     C                   PARM                    UpdateYN                                    BUG8433
      *
      * Outputs
      *
     C                   PARM                    OKClsPSHD
      *
      * Field Name Array
     C                   PARM                    FldNameArr
      *
      * Message ID Array
     C                   PARM                    MsgIdArr
      *
      * Message Data Array
     C                   PARM                    MsgDtaArr
      *
      * Array Index
     C                   PARM                    Ix
      *
      * Warning Field Name Array
     C                   PARM                    WFldNamArr
      *
      * Message ID Array
     C                   PARM                    WMsgIdArr
      *
      * Message Data Array
     C                   PARM                    WMsgDtaArr
      *
      * Array Index
     C                   PARM                    WI
      *
      * CLS Pay-in schedule in file format - Header
     C                   PARM                    CurrCLSHed
      *
      * No. of decimal places
     C                   PARM                    WNBDP             1 0
      *
      * Multiple Pay-in generated by time indicator
     C                   PARM                    WMPGT
      *
      ** Initialize program name
      *
     C                   MOVEL     'FXCLSPRTV'   DBPGM
      *
      ** Key Lists
      *
     C     KEYPRN        KLIST
     C                   KFLD                    KCCYD             3
     C                   KFLD                    KNOSN             2 0
      *
     C     KYPSHF        KLIST
     C                   KFLD                    KCCYD             3
     C                   KFLD                    KNSTN             2
     C                   KFLD                    KVDAT             5 0
     C                   KFLD                    KSEQN             2 0
      *
     C     KYPSHS        KLIST
     C                   KFLD                    KCCYD
     C                   KFLD                    KNSTN             2
     C                   KFLD                    KVDAT             5 0
      *
     C     KYACCT        KLIST
     C**********         KFLD                    KCUSN             6 0                        CSD027
     C                   KFLD                    KCUSN             6                          CSD027
     C                   KFLD                    KCCYD
     C**********         KFLD                    KACOD             4 0                        CGL029
     C                   KFLD                    KACOD            10 0                        CGL029
     C                   KFLD                    KACSN             2 0
     C                   KFLD                    KBRCD             3
      *
     C     KCwFld        KLIST                                                                CSD015
     C                   KFLD                    WFuncType                                    CSD015
     C                   KFLD                    WIdntifier                                   CSD015
     C                   KFLD                    WBranch                                      CSD015
      *                                                                                       CSD015
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
      *
      **  Access the SDSTAT Data Area.                                                        CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      **  Access SAR details to see if CSD015 is switched on.                                 CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSD015'      PSARD                                        CSD015
     C     SCSARD        PARM      *BLANKS       DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *BLANKS                                         CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> '*NRF'                                         CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 906                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
      ** Check if transactions are being monitored by Compliance Watch.                       CSD015
     C                   CALL      'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*KEY   '     POption                                      CSD015
     C                   PARM      'DEALING '    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS AND                                    CSD015
     C                             PRetCode <> '*NRF'                                         CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'DEALING'                                          CSD015
     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBase = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CSC011 is switched on.                                 CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSC011'      PSARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *BLANKS                                         CSD015
                                                                                              CSD015
     C                   EVAL      CSC011 = 'Y'                                               CSD015
     C                   IN        SC24X7                                                     CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> '*NRF'                                         CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CSC011'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 903                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CAP086 CSC054
      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
                                                                                              CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PretCode                                     CAP086
     C                   PARM      '*VERIFY'     POption                                      CAP086
     C**********         PARM      'CSC024'      PSARD                                 CAP086 CSC054
     C                   PARM      'CSC054'      PSARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRetCode <> *BLANKS  AND                                   CAP086
     C                             PRetCode <> '*NRF   '                                      CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C**********         EVAL      DBKey  = 'CSC024'                                   CAP086 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 908                                               CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C*********          EVAL      CSC024 = 'N'                                        CAP086 CSC054
     C**********         EVAL      WOMEInd = 'N'                                       CAP086 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                              CAP086
     C                   IF        PRetCode = *BLANKS                                         CAP086
     C**********         EVAL      CSC024 = 'Y'                                        CAP086 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
                                                                                              CAP086
      ** Access System values                                                                 CAP086
                                                                                              CAP086
     C                   CALL      'AOSVALR0'                                                 CAP086
     C                   PARM      *BLANKS       PRtCd                                        CAP086
     C                   PARM      PSysVal1      P@OP01                                       CAP086
     C                   PARM      *BLANKS       P@VL01                                       CAP086
     C                   PARM      *BLANKS       P@OP02                                       CAP086
     C                   PARM      *BLANKS       P@VL02                                       CAP086
     C                   PARM      *BLANKS       P@OP03                                       CAP086
     C                   PARM      *BLANKS       P@VL03                                       CAP086
     C                   PARM      *BLANKS       P@OP04                                       CAP086
     C                   PARM      *BLANKS       P@VL04                                       CAP086
     C                   PARM      *BLANKS       P@OP05                                       CAP086
     C                   PARM      *BLANKS       P@VL05                                       CAP086
     C                   PARM      *BLANKS       P@OP06                                       CAP086
     C                   PARM      *BLANKS       P@VL06                                       CAP086
     C                   PARM      *BLANKS       P@OP07                                       CAP086
     C                   PARM      *BLANKS       P@VL07                                       CAP086
     C                   PARM      *BLANKS       P@OP08                                       CAP086
     C                   PARM      *BLANKS       P@VL08                                       CAP086
     C                   PARM      *BLANKS       P@OP09                                       CAP086
     C                   PARM      *BLANKS       P@VL09                                       CAP086
     C                   PARM      *BLANKS       P@OP10                                       CAP086
     C                   PARM      *BLANKS       P@VL10                                       CAP086
                                                                                              CAP086
     C                   IF        PRtCd <> *BLANKS                                           CAP086
     C                   EVAL      DBFile = 'SDSVALPD'                                        CAP086
     C                   EVAL      DBKEy = '*KEY   '                                          CAP086
     C                   EVAL      DBase = 908                                                CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
     C                   IF        P@VL01 = 'Y'                                               CAP086
     C**********         EVAL      WOMEInd = 'Y'                                       CAP086 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCode                                     CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRetCode <> *BLANKS AND                                    CSD083
     C                             PRetCode <> '*NRF'                                         CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSD083
     C                   EVAL      DBASE  = 909                                               CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRetCode = *BLANKS                                         CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C/COPY WNCPYSRC,FXH00218
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
