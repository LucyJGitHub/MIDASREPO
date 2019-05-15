     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments schedule - validations')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LERPSCVAL - Midas LE Repayments Schedule - Validations       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE154             Date 02Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240408             Date 14Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP079   *CREATE   Date 08Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  240408 - Apply 207629 to Lending APIs                        *
      *           Check System Value LoanCustOriginPurch to decide if *
      *           original borrower should be input as the customer of*
      *           a Part Purchased, instead of 'Purchased From' num.  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      ***  FILES
      *    =====
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loans details file
     F                                     IGNORE(CLOANHHF:CLOANZ1F)
     F                                     PREFIX(CL_)
      *
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D XArrayMax       C                   CONST(40)
      ***  The maximum size of the appended error arrays
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D ExtData       E DS                  EXTNAME(LERPEXPD)
      ***  LE (RPSC) Extra Data - File (D/B) format
      *
     D FldNamXAr       S             10A   DIM(XArrayMax)
      ***  Array of Fields in error.
      *
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
      ***  Array of error message IDs
      *
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ***  Array of error message data.
      *
     D WFldNmXAr       S             10A   DIM(XArrayMax)
      ***  Array of Fields with warnings.
      *
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
      ***  Array of warning message IDs
      *
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ***  Array of warning message data.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ***  External DS for customer details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  First DS for access programs, long data structure
      *
     D ValidRpSc     E DS                  EXTNAME(LEVRPSCPD)
      ***  Valid Repayment schedule in file format
     D TranInScr     E DS                  EXTNAME(LERPSCPD)
      ***  Incoming Transaction
      *
     D RpScFilFmt    E DS                  EXTNAME(LOAMSDK) PREFIX(@@)
      * (Current) Midas Loan amendments in file format
      *
     D OKFlagsDS     E DS                  EXTNAME(LEERPSCPD)
      ***  Flags to indicate whether transaction fields are valid
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
      ***  Index for arrays of of error message ids etc
      *
     D WId             S              3P 0
      ***  Index for arrays of of warning message ids etc
      *
     D RespMode        S              1A
      ***  Response Mode, received as a parameter from the common header
     D WPARM           S             20A   INZ('LoanCustOriginPurch')                         240408
      *
      ** +--------------------------------------+
      ** ¦ Rename fields                        ¦
      ** ¦ =============                        ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *
      ***  Validation for screen details
      *    =============================
      *
      ***  Access the related loan
      ***  Loan must exist on Loans file as live
      *
     C                   MOVE      DDLNRF        K@LNRF
     C                   MOVE      'A'           K@RCDT
      *
     C     K@LOAN        CHAIN(N)  CLOAN                              99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLNRF'      FldNamXAr(Idx)
     C                   MOVEL     'LES0025'     MsgIDXAr(Idx)
     C**************     GOTO      EVAL
     C                   ENDIF
      *
      ***  Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
      ***  For Authorisation of a Complete Repayment, validate as Insert
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'X'
     C     @@ASTS        ANDEQ     'C'
      *
      ***  Validate the customer number
      *
     C                   EXSR      SRCUST
      *
      ***  Validate the value date
      *
     C     DDCUSTOK      IFEQ      'Y'
     C                   EXSR      SRVDAT
     C                   ENDIF
      *
      ***  Validate the currency
      *
     C     DDCUSTOK      IFEQ      'Y'
     C     DDVDATOK      ANDEQ     'Y'
     C                   EXSR      SRCURR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  Move the screen fields to valid file
      *
     C                   EXSR      SRMVFLD
      *
      ***  Update error information with that received back
      ***  from each validation module.
      *
     C                   EXSR      UPDATERRS
      *
      ***  Save the key reference for warning
      *
     C                   MOVEL     DDLNRF        SaveDDLNRF        6
      *
      ***  Return
      *    ======
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRMVFLD - Move the screen fields to valid file              *
      *****************************************************************
     C     SRMVFLD       BEGSR
      *
     C                   MOVEL     DDSPI1        RPSPI1
     C                   MOVEL     DDSPI2        RPSPI2
     C                   MOVEL     DDSPI3        RPSPI3
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRCUST - Validate the customer number                        *
      *****************************************************************
     C     SRCUST        BEGSR
      *
      ***  Customer must exist in Customer File
      *
     C     DDCUST        IFEQ      *BLANKS
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'LES0178'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDCUSTOK      IFEQ      'Y'
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C     DDCUST        PARM      DDCUST        @CUST            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         IFEQ      '*NOSEL'
     C                   MOVE      *BLANKS       DDCUST
     C                   ENDIF
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'LES0034'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  Customer must not be a parent
      *
     C     DDCUSTOK      IFEQ      'Y'
     C     BBPAIN        ANDEQ     'P'
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'LES0036'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Entered customer must equal customer in related loan
      *
     C     DDCUSTOK      IFEQ      'Y'
      *                                                                                       240408
     C     CL_PTYP       IFEQ      64                                                         240408
     C     CL_PTYP       OREQ      65                                                         240408
     C     CL_PTYP       OREQ      68                                                         240408
     C     CL_PTYP       OREQ      71                                                         240408
      *If the loan is a Participation Purchased, & System Value                               240408
      * LoanCustOriginPurch = 'O', use Original Borrower:                                     240408
     C     PPCUST        IFEQ      'O'                                                        240408
     C                   MOVE      CL_OLNO       WLCNOA                                       240408
      * Else, use 'Purchased from' customer number.                                           240408
     C                   ELSE                                                                 240408
     C                   MOVE      CL_CNUM       WLCNOA            6                          240408
     C                   ENDIF                                                                240408
      * Else, loan is not a Part Purchased:                                                   240408
     C                   ELSE                                                                 240408
     C                   MOVE      CL_CNUM       WLCNOA            6
     C                   ENDIF                                                                240408
     C     BBCUST        IFNE      WLCNOA
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'LES0104'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     BBCHID        WCHID             9
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRVDAT - Validate the value date                             *
      *****************************************************************
     C     SRVDAT        BEGSR
      *
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRCURR - Validate the currency code                          *
      *****************************************************************
     C     SRCURR        BEGSR
      *
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module.                     *
      *****************************************************************
      *
     C     RESETERRS     BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ***  Reset error & warning fields/message IDs/message data (arrays)
      *
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
      *
      ***  Reset warning flags
      *
     C     SaveDDLNRF    IFNE      DDLNRF
      *    Add hereafter the warning flag
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module.                     *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      ***  Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      ***  Set Error Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      ***  Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      ***  Set Warning Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WId
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ***  Response mode (1A), from source system common header
     C                   PARM                    RespMode
      *
      ***  Loan details screen 1
     C                   PARM                    TranInScr
      *
      ***  Extended data
     C                   PARM                    ExtData
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    WId
      *
      ***  Valid Loan CL layout (DS) from/to caller
     C                   PARM                    ValidRpSc
      *
      ***  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LERPSCVAL'   DBPGM
     C                   OUT       LDA
      *
      ***  Define working fields
      *
      *
      ***  Access Bank details via access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Determine whether program is running interactively or in batch
      ***   ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RTCD
     C                   PARM                    PMODE             1
      *
      ***  Key list for CLOAN
      *
     C     K@LOAN        KLIST
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF            6                          CLE148
     C                   KFLD                    K@RCDT            1
      *
      ***  set the message file
      *
     C                   EVAL      #MsgFile = 'LERMSGF'
      *                                                                                       240408
      ** Check System Value: Use Original Borrower or Purchased From?                         240408
      ** Set up parameter so access object checks LoanCustOriginPurch                         240408
     C                   MOVEL     WPARM         SVALK1                                       240408
      * Call Access object:                                                                   240408
     C                   CALL      'AOSVALR0'                                                 240408
     C                   PARM                    RTNCDE            7                          240408
     C                   PARM                    SVALK1           20                          240408
     C                   PARM                    SVAL1           200                          240408
     C                   PARM                    SVALK2           20                          240408
     C                   PARM                    SVAL2           200                          240408
     C                   PARM                    SVALK3           20                          240408
     C                   PARM                    SVAL3           200                          240408
     C                   PARM                    SVALK4           20                          240408
     C                   PARM                    SVAL4           200                          240408
     C                   PARM                    SVALK5           20                          240408
     C                   PARM                    SVAL5           200                          240408
     C                   PARM                    SVALK6           20                          240408
     C                   PARM                    SVAL6           200                          240408
     C                   PARM                    SVALK7           20                          240408
     C                   PARM                    SVAL7           200                          240408
     C                   PARM                    SVALK8           20                          240408
     C                   PARM                    SVAL8           200                          240408
     C                   PARM                    SVALK9           20                          240408
     C                   PARM                    SVAL9           200                          240408
     C                   PARM                    SVALK0           20                          240408
     C                   PARM                    SVAL10          200                          240408
      * If the system value is not found then default value to 'P'                            240408
     C     RTNCDE        IFNE      '        '                                                 240408
     C                   MOVE      'P'           PPCUST                                       240408
     C                   ELSE                                                                 240408
      * Isolate the first character of SVAL1 which = 'P' or 'O'.                              240408
     C                   MOVEL     SVAL1         WRK01             1                          240408
     C     WRK01         IFEQ      'O'                                                        240408
     C                   MOVE      'O'           PPCUST            1                          240408
     C                   ELSE                                                                 240408
     C                   MOVE      'P'           PPCUST                                       240408
     C                   ENDIF                                                                240408
     C                   ENDIF                                                                240408
      *
      ***  Program, module and procedure names for database error processing.
      ***  =================================================================
      ***  The following /COPY sets these values, and also defines LDA as
      ***  an external data area
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
