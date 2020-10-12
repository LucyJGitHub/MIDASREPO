     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments Schedule - Validations screen')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LERPSC1VL - Midas LE Repayments Schedule - Validations       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD038257           Date 13Apr16               *
      *                 CLE154             Date 02Aug12               *
      *                 CLE164             Date 18Aug14               *
      *                 MD025679A          Date 12May14               *
      *                 MD022695           Date 03Oct13               *
      *                 AR740107           Date 21Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241648             Date 31Aug06               *
      *                 239754             Date 03May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 240408             Date 14Jun06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 20Sep03               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5863            Date 14Feb04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4960            Date 22Dec04               *
      *                 BUG4351            Date 12Oct04               *
      *                 BUG4351            Date 23Sep04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP079  *CREATE    Date 08Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD038257 - Incorrect Default value for Auto settle indicator *
      *           - Get the value of auto settle indicator of the     *
      *             loan instead of the Lending ICD default value     *
      *  CLE154 - Loan Repayment Schedule Enhancement                 *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  MD025679A - API - OLPOSOA Locking Issue Performance Update   *
      *  MD022695 - Auto Settlement valid values validation issue     *
      *  AR740107 - Maturity changed equal to repayment date requires *
      *             warning message. Additional validation added      *
      *             between Maturity and Next Repayment date.         *
      *             (Child: AR740108)                                 *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  241648 - Allow repayment schedule wtih value date on maturity*
      *           date.                                               *
      *  239754 - If multi-ccy rollover is "Y" for a loan, allow      *
      *           repayment schedule to be inserted for future valued *
      *           MC change.                                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240408 - Apply 207629 to Lending APIs                        *
      *           Check System Value LoanCustOriginPurch to decide if *
      *           original borrower should be input as the customer of*
      *           a Part Purchased, instead of 'Purchased From' num.  *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2: *
      *           Allow repayments in facility currency.              *
      *  CAP086 - Introduce Auto Authorization to the API's           *
      *           without it                                          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5863 - Index of Warning errors array (WId) should be      *
      *            reset to zero to prevent array index out of range. *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4960 - Unable to enter repayment schedule with settlement *
      *            method 04.                                         *
      *  BUG4351 - Index of Warning errors array WFldNmXAr should be  *
      *            different to the index for WFldNamArr.             *
      *  BUG4351 - Remove the use of work fields to suppress warning  *
      *            errors being re-displayed when data unchanged.     *
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
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
      ***  Customer Lending Facility file
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
     F                                     PREFIX(FC_)
      *
     FLOAMS     IF   E           K DISK    INFSR(*PSSR)
      ***  Loan Amendments Retrieval Index
     F                                     RENAME(LOAMSDKF:LOAMSD)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSZ1F)
     F                                     PREFIX(LO_)
      *
      /COPY WNCPYSRC,LERPSCV101
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
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
      *
     D***SDCLND**      E DS                  EXTNAME(SDCLNDPD)                       CLE164 MD038257
      ****Customer*Lending*ICD*******************************                        CLE164 MD038257
      *******************************************************                        CLE164 MD038257
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
                                                                                              CAP086
      ** Interface Data Format Definition File format                                         CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
                                                                                              CAP086
      *
     D OKFlagsDS     E DS                  EXTNAME(LEERPSCPD)
      ***  Flags to indicate whether transaction fields are valid
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D KWFAC           DS
      ***  Key DB Error on facility file
     D**K@CNUM**               1      6  0                                                    CSD027
     D  K@CNUM                 1      6                                                       CSD027
     D  K@FACT                 8     10  0
     D  K@FCNO                12     13  0
     D  K@RCTP                15     15
      *
      ***  Data structure for assign appropriate decimal places to amount.
     D                 DS
     D  WAMT0                  1     13  0
     D  WAMT1                  1     13  1
     D  WAMT2                  1     13  2
     D  WAMT3                  1     13  3
     D  WAMT4                  1     13  4
     D  WAMT5                  1     13  5
     D  WAMT6                  1     13  6
      *
      ***  Data structure for assign appropriate decimal places to amount.
     D                 DS
     D  W#MT0                  1     13  0
     D  W#MT1                  1     13  1
     D  W#MT2                  1     13  2
     D  W#MT3                  1     13  3
     D  W#MT4                  1     13  4
     D  W#MT5                  1     13  5
     D  W#MT6                  1     13  6
      *
     D Idx             S              3P 0
      ***  Index for arrays of of error message ids etc
      *
     D WId             S              3P 0
     D WIdx            S              3P 0                                                   BUG4351
      ***  Index for arrays of of warning message ids etc
      *
     D RespMode        S              1A
      ***  Response Mode, received as a parameter from the common header
      *
     D POWR            S              7  3 DIM(7) CTDATA PERRCD(1)              Ccy conversion
      ***  Currency conversion
     D WPARM           DS                                                                     CLE036
      ***  Data structure to hold input parameter for AOSVALR0                                CLE036
     D  WPARM1                 1      5                                                       CLE036
     D  WPARM2                 6     10                                                       CLE036
     D  WPARM3                11     15                                                       CLE036
     D  WPARM4                16     20                                                       CLE036
     D WPARML          S             20A   INZ('LoanCustOriginPurch')                         240408
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
      /COPY WNCPYSRC,LERPSCV102
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      /COPY WNCPYSRC,LERPSCV103
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
     C                   ENDIF
      *
      ***  Set the processing type parameter
      *
     C                   MOVEL     CL_PTYP       PTypFilCLOAN
      *                                                                                      BUG4960
      ***  Set the branch type parameter                                                     BUG4960
      *                                                                                      BUG4960
     C                   MOVEL     CL_BRCA       BrcaFilCLOAN                                BUG4960
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
      /COPY WNCPYSRC,LERPSCV104
     C                   EXSR      SRCUST
      /COPY WNCPYSRC,LERPSCV105
      *
      ***  Validate the value date
      *
      /COPY WNCPYSRC,LERPSCV106
     C     Idx           IFEQ      *ZERO
     C                   EXSR      SRVDAT
     C                   ENDIF
      /COPY WNCPYSRC,LERPSCV107
      *
      ***  Validate the currency
      *
      /COPY WNCPYSRC,LERPSCV108
     C     Idx           IFEQ      *ZERO
     C                   EXSR      SRCURR
     C                   ENDIF
      /COPY WNCPYSRC,LERPSCV109
      *
      ***  Validate the amount
      *
      /COPY WNCPYSRC,LERPSCV110
     C     Idx           IFEQ      *ZERO
     C                   EXSR      SRSAMT
     C                   ENDIF
      /COPY WNCPYSRC,LERPSCV111
      *
     C                   ENDIF
      *
      ***  Validate the auto settlement indicator
      *
      /COPY WNCPYSRC,LERPSCV112
     C                   EXSR      SRAUTO
      /COPY WNCPYSRC,LERPSCV113
      *                                                                                       CLE154
      ***  Validate repayment type                                                            CLE154
      *                                                                                       CLE154
     C                   IF        CLE154 = 'Y'                                               CLE154
     C                   EXSR      SRREPT                                                     CLE154
     C                   ENDIF                                                                CLE154
      *
      ***  Move the screen fields to valid file
      *
      /COPY WNCPYSRC,LERPSCV114
     C     Idx           IFEQ      *ZERO
     C                   EXSR      SRMVFLD
     C                   ENDIF
      /COPY WNCPYSRC,LERPSCV115
      *
      ***  Update error information with that received back
      ***  from each validation module.
      *
     C                   EXSR      UPDATERRS
      *
      ***  Save the key reference for warning
      *
     C                   MOVEL     DDLNRF        SaveDDLNRF        6
     C                   MOVEL     DDVDAT        SaveDDVDAT        6
     C                   MOVEL     DDSEQN        SaveDDSEQN        3
      *
      ***  Return
      *    ======
     C                   RETURN
      *
      ***  Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,LERPSCV116
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRMVFLD - Move the screen fields to valid file              *
      *****************************************************************
     C     SRMVFLD       BEGSR
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'X'
     C                   MOVE      DDLNRF        RPLNRF
     C                   MOVE      BBCUST        RPCNUM
     C                   MOVEL     WVDAYN        RPVDAT
     C                   MOVEL     DDCURR        RPCCY
      *
     C     CL_REPT       IFNE      3
     C     CLE154        ANDEQ     'N'                                                        CLE154
     C     CL_REPT       ORNE      3                                                          CLE154
     C     DDREPT        ANDEQ     ' '                                                        CLE154
     C     CLE154        ANDEQ     'Y'                                                        CLE154
     C     DDREPT        ORNE      '3'                                                        CLE154
     C     DDREPT        ANDNE     ' '                                                        CLE154
     C     CLE154        ANDEQ     'Y'                                                        CLE154
     C                   Z-ADD     WLAMT         RPPRAM
     C                   ENDIF
     C     CL_REPT       IFNE      1
     C     CLE154        ANDEQ     'N'                                                        CLE154
     C     CL_REPT       ORNE      1                                                          CLE154
     C     DDREPT        ANDEQ     ' '                                                        CLE154
     C     CLE154        ANDEQ     'Y'                                                        CLE154
     C     DDREPT        ORNE      '1'                                                        CLE154
     C     DDREPT        ANDNE     ' '                                                        CLE154
     C     CLE154        ANDEQ     'Y'                                                        CLE154
     C                   Z-ADD     WLAMT         RPTAMT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVEL     DDSEQN        RPLASN
     C                   MOVEL     DDAUTO        RPAUTO
      *
     C                   MOVEL     DDSPI1        RPSPI1
     C                   MOVEL     DDSPI2        RPSPI2
     C                   MOVEL     DDSPI3        RPSPI3
      *
      /COPY WNCPYSRC,LERPSCV117
      *                                                                                       CLE154
     C                   IF        CLE154 = 'Y'                                               CLE154
     C                   IF        DDREPT = ' '                                               CLE154
     C                   MOVEL     CL_REPT       RPREPT                                       CLE154
     C                   ELSE                                                                 CLE154
     C                   MOVEL     DDREPT        RPREPT                                       CLE154
     C                   ENDIF                                                                CLE154
     C                   ENDIF                                                                CLE154
      *                                                                                       CLE154
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
     C                   MOVE      CL_CNUM       WLCNOA                                       240408
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
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRVDAT - Validate the value date                             *
      *****************************************************************
     C     SRVDAT        BEGSR
      *
      ***  Value date should not be blanks
      *
     C     DDVDAT        IFEQ      *BLANKS
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LES0105'     MsgIDXAr(Idx)
     C                   GOTO      ENDVDAT
     C                   ENDIF
      *
      ***  Value date should be numeric and in valid date format
      *
     C                   MOVEL     DDVDAT        WFLD7N            6 0
     C                   MOVEL     WFLD7N        WFLD6A            6
     C     DDVDAT        IFNE      WFLD6A
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LES0105'     MsgIDXAr(Idx)
     C                   GOTO      ENDVDAT
     C                   ENDIF
      *
     C                   MOVE      DDVDAT        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
      *
     C     ZERR          IFNE      *BLANKS
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LES0105'     MsgIDXAr(Idx)
     C                   GOTO      ENDVDAT
     C                   ENDIF
      *
     C                   Z-ADD     ZDAYNO        WVDAYN            5 0
      *
      ***  If action is Insert
      *
     C     DDACTN        IFEQ      'I'
      *
      ***  Value date should not be earlier than start date and not later
      ***  than maturity date
      *
     C     WVDAYN        IFLE      CL_VDAT
     C     CL_LPFI       ANDEQ     *BLANKS                                                    CLE106
     C     WVDAYN        ORLE      CL_VDAT                                                    CLE106
     C     CL_LPFI       ANDEQ     'A'                                                        CLE106
     C     WVDAYN        ORLT      CL_VDAT                                                    CLE106
     C     CL_MDAT       ORGT      0
     C*****WVDAYN        ANDGE     CL_MDAT                                                    241648
     C     WVDAYN        ANDGT     CL_MDAT                                                    241648
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LES0106'     MsgIDXAr(Idx)
     C                   GOTO      ENDVDAT
     C                   ENDIF
      *                                                                                     AR740107
      ** If Value date is amended to be equal to Maturity date                              AR740107
      ** generate a warning message.                                                        AR740107
      *                                                                                     AR740107
     C     WVDAYN        IFEQ      CL_MDAT                                                  AR740107
     C                   MOVE      'W'           DDVDATOK                                   AR740107
     C                   ADD       1             WId                                        AR740107
     C                   MOVEL     'DDVDAT'      WFldNmXAr(WId)                             AR740107
     C                   MOVEL     'LES0615'     WMsgIDXAr(WId)                             AR740107
     C                   ENDIF                                                              AR740107
      *
      ***  Extra validation for value date
      *
      ***  Calculate Back value limit
      *
     C     BJRDNB        SUB       BJBVPD        WBKLIM            5 0
      *
     C     CLE003        IFEQ      'N'
      *
     C     CL_SLID       IFLT      WBKLIM
     C     WVDAYN        ANDLT     CL_SLID
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LES0111'     MsgIDXAr(Idx)
     C                   GOTO      ENDVDAT
     C                   ENDIF
      *
     C     WVDAYN        IFLT      WBKLIM
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LES0111'     MsgIDXAr(Idx)
     C                   GOTO      ENDVDAT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  If CLE014 is on, value date must not be between multi-currency
      ***  rollover date and the working date after it.
      *
     C     CLE014        IFEQ      'Y'
     C     CL_RLDT       ANDNE     *ZERO
      *
     C                   MOVE      'B'           K@RCDT
     C     K@LOAN        CHAIN(N)  CLOANCKF                           99
      *
     C     *IN99         IFEQ      *OFF
     C     CL_NCCY       ANDNE     *BLANKS
     C     CL_NCCY       ANDNE     CL_CCY
      *
     C                   Z-ADD     CL_RLDT       ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   Z-ADD     1             ZNRDYS
      *
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0          InputDay
     C                   PARM                    ZNRDYS            2 0          DaysFwd
     C                   PARM                    ZDYNBR            5 0          OutputDay
     C                   PARM                    ZCCY              3            Currency
     C                   PARM                    ZLOC              3            Location
      *
     C     WVDAYN        IFGT      CL_RLDT
     C     WVDAYN        ANDLT     ZDYNBR
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LES0138'     MsgIDXAr(Idx)
     C                   GOTO      ENDVDAT
     C                   ENDIF
      *
      ***  Back-valued repayment schedule is prohibited if rollover
      ***  details exists
      *
     C     CL_RLDT       IFLT      BJRDNB
     C     WVDAYN        ANDLT     BJRDNB
     C     WVDAYN        ANDGT     CL_RLDT
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LES0139'     MsgIDXAr(Idx)
     C                   GOTO      ENDVDAT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ENDVDAT       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRCURR - Validate the currency code                          *
      *****************************************************************
     C     SRCURR        BEGSR
      *
      ***  Entry in Currency field is mandatory
      *
     C     DDCURR        IFEQ      *BLANKS
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCURR'      FldNamXAr(Idx)
     C                   MOVEL     'LES0175'     MsgIDXAr(Idx)
     C                   GOTO      ENDCURR
     C                   ELSE
      *
      ***  Must be a valid currency
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C     DDCURR        PARM      DDCURR        @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         IFEQ      '*NOSEL'
     C                   MOVE      *BLANKS       DDCURR
     C                   ENDIF
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCURR'      FldNamXAr(Idx)
     C                   MOVEL     'LES0188'     MsgIDXAr(Idx)
     C                   GOTO      ENDCURR
     C                   ENDIF
     C                   ENDIF
      *
      ***  Must equal currency of related loan - if multi ccy rollover
      ***  is not allowed
      *
     C     DDCURROK      IFEQ      'Y'
     C     CL_MCRA       IFNE      'Y'
     C     CLE014        ANDNE     'Y'
     C     CLE014        OREQ      'Y'
     C     FREPAY        ANDEQ     'N'                                                        CLE036
     C     CLE014        OREQ      'Y'                                                        239754
     C     CL_MCRA       ANDNE     'Y'                                                        239754
      *
     C     DDCURR        IFNE      CL_CCY
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCURR'      FldNamXAr(Idx)
     C                   MOVEL     'LES0189'     MsgIDXAr(Idx)
     C                   GOTO      ENDCURR
     C                   ENDIF
      *
     C                   ELSE
      *
     C     CLE014        IFNE      'Y'
     C     FREPAY        OREQ      'Y'                                                        CLE036
      *
      ***  If Loan allows multicurrency rollover, then repayment
      ***  schedule should be in facility currency
      *
      ***  Access facility 'A' record
      *
     C                   MOVE      CL_FCUS       K@CNUM
     C                   MOVE      CL_FTYP       K@FACT
     C                   MOVE      CL_FSEQ       K@FCNO
     C                   MOVE      'A'           K@RCTP
      *
     C     K@FAC         CHAIN(N)  FCLTY                              99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'FCLTY'       DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     KWFAC         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     DDCURR        IFNE      FC_FCCY
     C     FREPAY        ANDNE     'Y'                                                        CLE036
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCURR'      FldNamXAr(Idx)
     C                   MOVEL     'LES0187'     MsgIDXAr(Idx)
     C                   GOTO      ENDCURR
     C                   ELSE                                                                 CLE036
     C     DDCURR        IFNE      CL_CCY                                                     CLE036
     C     DDCURR        ANDNE     FC_FCCY                                                    CLE036
     C     FREPAY        ANDEQ     'Y'                                                        CLE036
     C                   MOVE      'N'           DDCURROK                                     CLE036
     C                   ADD       1             Idx                                          CLE036
     C                   MOVEL     'DDCURR'      FldNamXAr(Idx)                               CLE036
     C                   MOVEL     'LES0193'     MsgIDXAr(Idx)                                CLE036
     C                   GOTO      ENDCURR                                                    CLE036
     C                   ENDIF                                                                CLE036
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     ENDCURR       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRSAMT - Validate the amount                                 *
      *****************************************************************
     C     SRSAMT        BEGSR
      *
      ***  Entry in Amount field is mandatory
      *
     C     DDSAMT        IFEQ      *BLANKS
     C     CLE154        IFEQ      'Y'                                                        CLE154
     C     DDREPT        ANDEQ     '2'                                                        CLE154
     C                   MOVE      'Y'           DDSAMTOK                                     CLE154
     C                   Z-ADD     *ZEROS        WLAMT                                        CLE154
     C                   GOTO      ENDSAMT                                                    CLE154
     C                   ENDIF                                                                CLE154
     C                   MOVE      'N'           DDSAMTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSAMT'      FldNamXAr(Idx)
     C                   MOVEL     'LES0190'     MsgIDXAr(Idx)
     C                   GOTO      ENDSAMT
     C                   ELSE
      *
     C     DDSAMTOK      IFEQ      'Y'
      *
      ***  Amount should use the correct number of decimal
      *
     C                   Z-ADD     *ZEROS        WLAMT            13 0
     C                   MOVE      *BLANKS       ZFIELD           16
     C                   MOVE      DDSAMT        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     13            SUB       A6NBDP        ZADIG
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM      *BLANKS       ZRVAL            16
      *
     C                   MOVE      ZRVAL         WLAMT
      *
     C     @RTCD         IFNE      *BLANKS
     C     WLAMT         OREQ      0
     C                   MOVE      'N'           DDSAMTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSAMT'      FldNamXAr(Idx)
     C                   MOVEL     'LES0192'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Must be less or equal the outstanding principal of the related
      ***  loan, taking into account all manual repayment and repayment
      ***  schedule entered against it
      *
     C     DDSAMTOK      IFEQ      'Y'
     C                   MOVE      DDSEQN        WSEQN             3 0
     C                   Z-ADD     CL_CPAM       WPRIN            13 0
     C                   MOVE      *OFF          *IN07
      *
     C     DDVDAT        IFNE      *BLANKS
     C                   MOVE      DDVDAT        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
      *
     C                   Z-ADD     ZDAYNO        WDAT              5 0
      *
     C     CL_LNRF       SETLL     LOAMS
     C**********         READ      LOAMS                                  07               MD025679A
     C     CL_LNRF       READE     LOAMS                                  07               MD025679A
     C     *IN07         DOWEQ     *OFF
      *
     C     LO_RECI       IFEQ      'D'
     C     LO_LNRF       ANDEQ     CL_LNRF
      *
     C     LO_AMTP       IFEQ      'MR'
     C     LO_AMTP       OREQ      'RE'
     C     LO_AUTO       ANDEQ     'Y'
                                                                                              CLE134
     C     LO_AMTP       OREQ      'RE'                                                       CLE134
     C     LO_AUTO       ANDEQ     'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
                                                                                              CLE134
     C     LO_AMTP       OREQ      'PF'
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'X'
     C     LO_LASN       ANDNE     WSEQN
     C     LO_VDAT       ANDEQ     WVDAYN
     C     DDACTN        OREQ      'X'
     C     LO_LASN       ANDEQ     WSEQN
     C     LO_VDAT       ANDNE     WVDAYN
     C     DDACTN        OREQ      'X'
     C     LO_LASN       ANDNE     WSEQN
     C     LO_VDAT       ANDNE     WVDAYN
      *
      ***  Convert all previous repayments into loan currency amount and
      ***  deduct from principal outstanding, if loan currency does not
      ***  equal facility currency.
      *
     C     CL_CCY        IFNE      CL_FCCY
     C     LO_AMTP       IFEQ      'RE'
      *
      ***  Loan currency
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      CL_CCY        @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     CL_CCY        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     A6NBDP        W#DP1             1 0
      *
      ***  Base currency
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      BJCYCD        @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     BJCYCD        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      A6MDIN        WMDIN             1
     C                   Z-ADD     A6SPRT        WSPRT            13 8
      *
      ***  Facility currency
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      LO_CCY        @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     LO_CCY        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        WNBDP             1 0
     C                   MOVE      A6MDIN        ZMDI1             1
     C                   Z-ADD     A6SPRT        ZRATE1           13 8
     C                   MOVE      WMDIN         ZMDI2             1
     C                   Z-ADD     WSPRT         ZRATE2           13 8
      *
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
      *
     C                   Z-ADD     LO_PRAM       W#20             20 0
      *
      ***  If currencies have same number of decimal places need to
      ***  obtain one more decimal place for rounding purposes
      *
     C     W#DP1         IFEQ      WNBDP
     C                   Z-ADD     5             W#DP
     C     W#20          MULT      POWR(W#DP)    W#20
     C                   ENDIF
      *
     C     A6MDIN        IFEQ      'M'
     C     W#20          MULT      ZRATEX        W#20
     C                   ELSE
     C     W#20          DIV       ZRATEX        W#20
     C                   ENDIF
      *
      ***  Convert new amount in base currency to loan currency
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      CL_CCY        @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     5             DBASE                          * DBERR 005 *
     C                   MOVEL     CL_CCY        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      A6MDIN        ZMDI1
     C                   Z-ADD     A6SPRT        ZRATE1
     C                   MOVE      WMDIN         ZMDI2
     C                   Z-ADD     WSPRT         ZRATE2
      *
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
      *
     C     A6MDIN        IFEQ      'M'
     C     W#20          DIV       ZRATEX        W#20
     C                   ELSE
     C     W#20          MULT      ZRATEX        W#20
     C                   ENDIF
      *
      ***  If the number of decimal places between loan ccy and facility
      ***  ccy are not equal, need to drop or add decimal places before
      ***  deducting from outstanding principal
      *
     C                   Z-ADD     W#20          WAMT0
      *
     C     WNBDP         IFGT      A6NBDP
      *
     C     WNBDP         SUB       A6NBDP        W#NBDP            1 0
      *
     C                   SELECT
      *
     C     W#NBDP        WHENEQ    1
     C                   Z-ADD(H)  WAMT1         WNAMT
     C     WPRIN         SUB       WNAMT         WPRIN
      *
     C     W#NBDP        WHENEQ    2
     C                   Z-ADD(H)  WAMT2         WNAMT
     C     WPRIN         SUB       WNAMT         WPRIN
      *
     C     W#NBDP        WHENEQ    3
     C                   Z-ADD(H)  WAMT3         WNAMT
     C     WPRIN         SUB       WNAMT         WPRIN
      *
     C     W#NBDP        WHENEQ    4
     C                   Z-ADD(H)  WAMT4         WNAMT
     C     WPRIN         SUB       WNAMT         WPRIN
      *
     C     W#NBDP        WHENEQ    5
     C                   Z-ADD(H)  WAMT5         WNAMT
     C     WPRIN         SUB       WNAMT         WPRIN
      *
     C                   ENDSL
      *
     C                   ELSE
      *
     C     WNBDP         IFLT      A6NBDP
      *
     C     A6NBDP        SUB       WNBDP         W#DP              1 0
     C                   ADD       4             W#DP
      *
     C     WAMT0         MULT      POWR(W#DP)    WNAMT
     C     WPRIN         SUB       WNAMT         WPRIN
      *
     C                   ELSE
      *
      ***  If the same number of decimal places need to round last digit
      *
     C                   SELECT
      *
     C     A6NBDP        WHENEQ    1
     C                   Z-ADD(H)  WAMT2         W#MT1
     C                   Z-ADD     W#MT0         WNAMT
     C     WPRIN         SUB       WNAMT         WPRIN
      *
     C     A6NBDP        WHENEQ    2
     C                   Z-ADD(H)  WAMT3         W#MT2
     C                   Z-ADD     W#MT0         WNAMT
     C     WPRIN         SUB       WNAMT         WPRIN
      *
     C     A6NBDP        WHENEQ    3
     C                   Z-ADD(H)  WAMT4         W#MT3
     C                   Z-ADD     W#MT0         WNAMT
     C     WPRIN         SUB       WNAMT         WPRIN
      *
     C     A6NBDP        WHENEQ    4
     C                   Z-ADD(H)  WAMT5         W#MT4
     C                   Z-ADD     W#MT0         WNAMT
     C     WPRIN         SUB       WNAMT         WPRIN
      *
     C     A6NBDP        WHENEQ    5
     C                   Z-ADD(H)  WAMT6         W#MT5
     C                   Z-ADD     W#MT0         WNAMT
     C     WPRIN         SUB       WNAMT         WPRIN
      *
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C     WPRIN         SUB       LO_PRAM       WPRIN
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     LO_AMTP       IFEQ      'PI'
     C     LO_AMTP       OREQ      'PT'
     C     LO_VDAT       IFLE      WDAT
     C                   ADD       LO_PRAM       WPRIN
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C**********         READ      LOAMS                                  07               MD025679A
     C     CL_LNRF       READE     LOAMS                                  07               MD025679A
     C                   ENDDO
      *
      ***  Need to convert screen amount into loan amount before deducting
      ***  from outstanding principal
      *
     C                   Z-ADD     WLAMT         W#LAMT           13 0
      *
     C     DDCURR        IFNE      CL_CCY
     C     DDCURROK      ANDEQ     'Y'
      *
      ***  Loan currency
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      CL_CCY        @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     6             DBASE                          * DBERR 006 *
     C                   MOVEL     CL_CCY        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     A6NBDP        W#DP1
      *
      ***  Base ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      BJCYCD        @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     7             DBASE                          * DBERR 007 *
     C                   MOVEL     BJCYCD        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      A6MDIN        WMDIN
     C                   Z-ADD     A6SPRT        WSPRT
      *
      ***  Screen ccy - facility ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      DDCURR        @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     8             DBASE                          * DBERR 008 *
     C                   MOVEL     DDCURR        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        WNBDP
     C                   MOVE      A6MDIN        ZMDI1
     C                   Z-ADD     A6SPRT        ZRATE1
     C                   MOVE      WMDIN         ZMDI2
     C                   Z-ADD     WSPRT         ZRATE2
      *
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
      *
      ***  Remove any decimal places
      *
     C                   MOVE      *BLANKS       ZFIELD           16
     C                   MOVE      DDSAMT        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     13            SUB       A6NBDP        ZADIG
      *
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM      *BLANKS       ZRVAL            16
      *
     C                   MOVE      ZRVAL         W#20
      *
      ***  If currencies have same number of decimal places need to
      ***  obtain one more decimal place for rounding purposes
      *
     C     W#DP1         IFEQ      WNBDP
     C                   Z-ADD     5             W#DP
     C     W#20          MULT      POWR(W#DP)    W#20
     C                   ENDIF
      *
     C     A6MDIN        IFEQ      'M'
     C     W#20          MULT      ZRATEX        W#20
     C                   ELSE
     C     W#20          DIV       ZRATEX        W#20
     C                   ENDIF
      *
      ***  Convert new amount in base currency to loan currency
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      CL_CCY        @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     9             DBASE                          * DBERR 009 *
     C                   MOVEL     CL_CCY        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      A6MDIN        ZMDI1
     C                   Z-ADD     A6SPRT        ZRATE1
     C                   MOVE      WMDIN         ZMDI2
     C                   Z-ADD     WSPRT         ZRATE2
      *
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
      *
     C     A6MDIN        IFEQ      'M'
     C     W#20          DIV       ZRATEX        W#20
     C                   ELSE
     C     W#20          MULT      ZRATEX        W#20
     C                   ENDIF
      *
      ***  If the number of decimal places between loan ccy and facility
      ***  ccy are not equal, need to drop or add decimal places before
      ***  deducting from outstanding principal
      *
     C                   Z-ADD     W#20          WAMT0
      *
     C     WNBDP         IFGT      A6NBDP
      *
     C     WNBDP         SUB       A6NBDP        W#NBDP
      *
     C                   SELECT
      *
     C     W#NBDP        WHENEQ    1
     C                   Z-ADD(H)  WAMT1         WNAMT            13 0
      *
     C     W#NBDP        WHENEQ    2
     C                   Z-ADD(H)  WAMT2         WNAMT
      *
     C     W#NBDP        WHENEQ    3
     C                   Z-ADD(H)  WAMT3         WNAMT
      *
     C     W#NBDP        WHENEQ    4
     C                   Z-ADD(H)  WAMT4         WNAMT
      *
     C     W#NBDP        WHENEQ    5
     C                   Z-ADD(H)  WAMT5         WNAMT
      *
     C                   ENDSL
      *
     C                   ELSE
      *
     C     WNBDP         IFLT      A6NBDP
      *
     C     A6NBDP        SUB       WNBDP         W#DP
     C                   ADD       4             W#DP
      *
     C     WAMT0         MULT      POWR(W#DP)    WNAMT
      *
     C                   ELSE
      *
      ***  If the same number of decimal places need to round last digit
      *
     C                   SELECT
      *
     C     A6NBDP        WHENEQ    1
     C                   Z-ADD(H)  WAMT2         W#MT1
     C                   Z-ADD     W#MT0         WNAMT
      *
     C     A6NBDP        WHENEQ    2
     C                   Z-ADD(H)  WAMT3         W#MT2
     C                   Z-ADD     W#MT0         WNAMT
      *
     C     A6NBDP        WHENEQ    3
     C                   Z-ADD(H)  WAMT4         W#MT3
     C                   Z-ADD     W#MT0         WNAMT
      *
     C     A6NBDP        WHENEQ    4
     C                   Z-ADD(H)  WAMT5         W#MT4
     C                   Z-ADD     W#MT0         WNAMT
      *
     C     A6NBDP        WHENEQ    5
     C                   Z-ADD(H)  WAMT6         W#MT5
     C                   Z-ADD     W#MT0         WNAMT
      *
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     WNAMT         WLAMT
     C                   ENDIF
      *
     C     DDACTN        IFNE      'X'
     C     WLAMT         IFGT      WPRIN
     C     WLAMT         ANDNE     WAMNT
     C*****WESAMT        IFEQ      *BLANKS                                                   BUG4351
     C*****WESAMT        OREQ      'Y'                                                       BUG4351
     C*****WLAMT         ANDNE     WSLAMT                                                    BUG4351
     C**********         Z-ADD     WLAMT         WSLAMT           13 0                       BUG4351
     C**********         MOVE      'Y'           WESAMT                                      BUG4351
     C                   MOVE      'W'           DDSAMTOK
     C                   ADD       1             WId
     C                   MOVEL     'DDSAMT'      WFldNmXAr(WId)
     C                   MOVEL     'LES0157'     WMsgIDXAr(WId)
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
     C                   Z-ADD     WLAMT         WAMNT            13 0
     C                   Z-ADD     W#LAMT        WLAMT
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     ENDSAMT       ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRAUTO - Validate the auto settlement indicator              *
      *****************************************************************
     C     SRAUTO        BEGSR
      *
     C     DDAUTO        IFEQ      *BLANK
     C**********         MOVE      CL_AUTO       DDAUTO                                       CLE164
     C**********         EVAL      DDAUTO = BPDASI                                   CLE164 MD038257
     C                   MOVE      CL_AUTO       DDAUTO                              CLE164 MD038257
     C                   ELSE
     C     DDAUTO        IFNE      'Y'
     C     DDAUTO        ANDNE     'N'
                                                                                              CLE134
     C     CLE134        IFNE      'Y'                                                        CLE134
     C*****CLE134        OREQ      'Y'                                               CLE134 MD022695
     C*****DDAUTO        ANDNE     'C'                                               CLE134 MD022695
     C                   MOVE      'N'           DDAUTOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUTO'      FldNamXAr(Idx)
     C                   MOVEL     'LES0061'     MsgIDXAr(Idx)
     C                   ELSE                                                               MD022695
     C                   IF        DDAUTO <> 'C'                                            MD022695
     C                   MOVE      'N'           DDAUTOOK                                   MD022695
     C                   ADD       1             Idx                                        MD022695
     C                   MOVEL     'DDAUTO'      FldNamXAr(Idx)                             MD022695
     C                   MOVEL     '5046116'     MsgIDXAr(Idx)                              MD022695
     C                   ENDIF                                                              MD022695
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDIF
     C                   ENDIF
      *
     C                   If        CLE134 = 'Y'                                               CLE164
     C                   MOVEL     CL_LTYP       NPDCL             1                          CLE164
                                                                                              CLE164
     C                   If        NPDCL <> 'X' and                                           CLE164
     C                             NPDCL <> 'Y' and                                           CLE164
     C                             NPDCL <> 'Z' and                                           CLE164
     C                             CL_AUTO = 'C' and                                          CLE164
     C                             DDAUTO = 'Y'                                               CLE164
                                                                                              CLE164
     C                   ADD       1             WIdx                                         CLE164
     C                   EVAL      WFldNamArr(Widx) = 'DDAUTO'                                CLE164
     C                   EVAL      WMsgIDArr(Widx) = '5047385'                                CLE164
                                                                                              CLE164
     C                   Endif                                                                CLE164
                                                                                              CLE164
     C                   If        (CL_AUTO = 'Y' or                                          CLE164
     C                             CL_AUTO = 'N') and                                         CLE164
     C                             DDAUTO = 'C'                                               CLE164
     C                                                                                        CLE164
     C                   ADD       1             Idx                                          CLE164
     C                   EVAL      FldNamXAr(idx) = 'DDAUTO'                                  CLE164
     C                   EVAL      MsgIDXAr(Idx) = '5047386'                                  CLE164
                                                                                              CLE164
     C                   Endif                                                                CLE164
     C                   Endif                                                                CLE164
                                                                                              CLE164
     C                   ENDSR
      *****************************************************************                       CLE154
      /EJECT                                                                                  CLE154
      *****************************************************************                       CLE154
      *  SRREPT - Validate repayment type                             *                       CLE154
      *****************************************************************                       CLE154
     C     SRREPT        BEGSR                                                                CLE154
                                                                                              CLE154
     C                   IF        DDREPT = *BLANKS                                           CLE154
     C                   GOTO      ENDREPT                                                    CLE154
     C                   ENDIF                                                                CLE154
                                                                                              CLE154
     C                   IF        DDREPT <> '1' AND                                          CLE154
     C                             DDREPT <> '2' AND                                          CLE154
     C                             DDREPT <> '3'                                              CLE154
     C                   ADD       1             Idx                                          CLE154
     C                   MOVEL     'DDREPT'      FldNamXAr(Idx)                               CLE154
     C                   MOVEL     'LEL0155'     MsgIDXAr(Idx)                                CLE154
     C                   ENDIF                                                                CLE154
                                                                                              CLE154
     C                   IF        CL_WTRT <> 0 AND                                           CLE154
     C                             CL_WTIN <> ' ' AND                                         CLE154
     C                             DDREPT = '3'                                               CLE154
     C                   ADD       1             Idx                                          CLE154
     C                   MOVEL     'DDREPT'      FldNamXAr(Idx)                               CLE154
     C                   MOVEL     'LEL0155'     MsgIDXAr(Idx)                                CLE154
     C                   ENDIF                                                                CLE154
                                                                                              CLE154
     C     ENDREPT       ENDSR                                                                CLE154
      *****************************************************************
     C/EJECT
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
                                                                                             BUG5863
      ** Reset Index of Warning errors.                                                      BUG5863
                                                                                             BUG5863
     C                   EVAL      WId = *ZERO                                               BUG5863
      *
      ***  Reset warning flags
      *
     C     SaveDDLNRF    IFNE      DDLNRF
     C     SaveDDVDAT    ORNE      DDVDAT
     C     SaveDDSEQN    ORNE      DDSEQN
      *
     C**********         MOVEL     *BLANKS       WESAMT            1                         BUG4351
      *
     C                   ENDIF
      *
      /COPY WNCPYSRC,LERPSCV118
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
     C*****I****         SUB       1             WId                                         BUG4351
     C     I             SUB       1             WIdx                                        BUG4351
      *
      /COPY WNCPYSRC,LERPSCV119
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
      ***  Details screen 1
     C                   PARM                    TranInScr
      *
      * Customer Extra Data file data                                                         CAP086
     C                   PARM                    InfData                                      CAP086
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
     C************       PARM                    WId                                         BUG4351
     C                   PARM                    WIdx                                        BUG4351
      *
      ***  Valid Repayment layout (DS) from/to caller
     C                   PARM                    ValidRpSc
      *
      ***  Processing type in CLOANCL file
     C                   PARM                    PTypFilCLOAN      2
      *                                                                                      BUG4960
      ***  Branch in CLOANCL file                                                            BUG4960
     C                   PARM                    BrcaFilCLOAN      3                         BUG4960
      *
      ***  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LERPSC1VL'   DBPGM
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
      ***  Check Feature is installed
      *
     C                   MOVE      'N'           CLE003            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE003
     C                   END
      *
     C                   MOVE      'N'           CLE014            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014
     C                   END
     C                   MOVE      'N'           CLE036            1                          CLE036
     C                   CALLB     'AOSARDR0'                                                 CLE036
     C                   PARM      *BLANK        @RTCD                                        CLE036
     C                   PARM      '*VERIFY'     @OPTN                                        CLE036
     C                   PARM      'CLE036'      @SARD                                        CLE036
      *                                                                                       CLE036
     C     @RTCD         IFEQ      *BLANKS                                                    CLE036
     C                   MOVE      'Y'           CLE036                                       CLE036
     C                   END                                                                  CLE036
      *                                                                                       CLE154
     C                   MOVE      'N'           CLE154            1                          CLE154
     C                   CALLB     'AOSARDR0'                                                 CLE154
     C                   PARM      *BLANK        @RTCD                                        CLE154
     C                   PARM      '*VERIFY'     @OPTN                                        CLE154
     C                   PARM      'CLE154'      @SARD                                        CLE154
      *                                                                                       CLE154
     C     @RTCD         IFEQ      *BLANKS                                                    CLE154
     C                   MOVE      'Y'           CLE154                                       CLE154
     C                   END                                                                  CLE154
      *                                                                                       CLE036
     C                   MOVE      'N'           CLE134            1                          CLE134
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANK        @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
                                                                                              CLE134
     C     @RTCD         IFEQ      *BLANKS                                                    CLE134
     C                   MOVE      'Y'           CLE134                                       CLE134
     C                   END                                                                  CLE134
                                                                                              CLE134
      ** Access System Values file SDSVALPD                                                   CLE036
      *                                                                                       CLE036
     C                   EVAL      WPARM = *BLANKS                                            CLE036
     C                   EVAL      WPARM1 = 'Facil'                                           CLE036
     C                   EVAL      WPARM2 = 'ityCc'                                           CLE036
     C                   EVAL      WPARM3 = 'yRepa'                                           CLE036
     C                   EVAL      WPARM4 = 'yment'                                           CLE036
     C                   EVAL      SVALK1 = WPARM                                             CLE036
      *                                                                                       240408
      ** Check System Value: Use Original Borrower or Purchased From?                         240408
      ** Set up parameter so access object checks LoanCustOriginPurch                         240408
     C                   MOVEL     WPARML        SVALK2                                       240408
      ** Call Access Object                                                                   CLE036
     C                   CALL      'AOSVALR0'                                                 CLE036
     C                   PARM                    RTNCDE            7                          CLE036
     C                   PARM                    SVALK1           20                          CLE036
     C                   PARM                    SVAL1           200                          CLE036
     C                   PARM                    SVALK2           20                          CLE036
     C                   PARM                    SVAL2           200                          CLE036
     C                   PARM                    SVALK3           20                          CLE036
     C                   PARM                    SVAL3           200                          CLE036
     C                   PARM                    SVALK4           20                          CLE036
     C                   PARM                    SVAL4           200                          CLE036
     C                   PARM                    SVALK5           20                          CLE036
     C                   PARM                    SVAL5           200                          CLE036
     C                   PARM                    SVALK6           20                          CLE036
     C                   PARM                    SVAL6           200                          CLE036
     C                   PARM                    SVALK7           20                          CLE036
     C                   PARM                    SVAL7           200                          CLE036
     C                   PARM                    SVALK8           20                          CLE036
     C                   PARM                    SVAL8           200                          CLE036
     C                   PARM                    SVALK9           20                          CLE036
     C                   PARM                    SVAL9           200                          CLE036
     C                   PARM                    SVALK0           20                          CLE036
     C                   PARM                    SVAL10          200                          CLE036
      *                                                                                       CLE036
      ** If the system value is not found then issue a database error                         CLE036
      ** unless batch mode, in which case default value to 'P'                                CLE036
      *                                                                                       CLE036
     C     RTNCDE        IFNE      *BLANKS                                                    CLE036
     C     *LOCK         IN        LDA                                                        CLE036
     C                   MOVEL     'SDSVALPD'    DBFILE                                       CLE036
     C                   Z-ADD     32            DBASE                                        CLE036
     C                   MOVEL     'SVALK1'      DBKEY                                        CLE036
     C                   OUT       LDA                                                        CLE036
     C                   EXSR      *PSSR                                                      CLE036
     C                   ELSE                                                                 CLE036
     C                   MOVEL     SVAL1         WRK01             1                          CLE036
     C     WRK01         IFEQ      'Y'                                                        CLE036
     C                   MOVE      'Y'           FREPAY            1                          CLE036
     C                   ELSE                                                                 CLE036
     C                   MOVE      'N'           FREPAY                                       CLE036
     C                   ENDIF                                                                CLE036
     C                   ENDIF                                                                CLE036
      * If the system value is not found then default value to 'P'                            240408
     C     RTNCDE        IFNE      '        '                                                 240408
     C                   MOVE      'P'           PPCUST                                       240408
     C                   ELSE                                                                 240408
      * Isolate the first character of SVAL1 which = 'P' or 'O'.                              240408
     C                   MOVEL     SVAL2         WRK01             1                          240408
     C     WRK01         IFEQ      'O'                                                        240408
     C                   MOVE      'O'           PPCUST            1                          240408
     C                   ELSE                                                                 240408
     C                   MOVE      'P'           PPCUST                                       240408
     C                   ENDIF                                                                240408
     C                   ENDIF                                                                240408
      *******************************************************************            CLE164 MD038257
     C****Access*Customer*Lending*ICD*via*access*program*****************            CLE164 MD038257
      *******************************************************************            CLE164 MD038257
     C**********         CALL      'AOCLNDR0'                                        CLE164 MD038257
     C**********         PARM      *BLANKS       @RTCD                               CLE164 MD038257
     C**********         PARM      '*FIRST '     @OPTN                               CLE164 MD038257
     C*****SDCLND        PARM      SDCLND        DSSDY                               CLE164 MD038257
     C*****@RTCD         IFNE      *BLANKS                                           CLE164 MD038257
     C**********         MOVEL     'SDCLNDPD'    DBFILE                              CLE164 MD038257
     C**********         Z-ADD     10            DBASE                               CLE164 MD038257
     C**********         MOVEL     @OPTN         DBKEY                               CLE164 MD038257
     C**********         EXSR      *PSSR                                             CLE164 MD038257
     C**********         ENDIF                                                       CLE164 MD038257
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
      ***  Key list for Facility
      *
     C     K@FAC         KLIST
     C**********         KFLD                    K@CNUM            6 0                        CSD027
     C                   KFLD                    K@CNUM            6                          CSD027
     C                   KFLD                    K@FACT            3 0
     C                   KFLD                    K@FCNO            2 0
     C                   KFLD                    K@RCTP            1
      *
      *
      ***  set the message file
      *
     C                   EVAL      #MsgFile = 'LERMSGF'
      *
      ***  Program, module and procedure names for database error processing.
      ***  =================================================================
      ***  The following /COPY sets these values, and also defines LDA as
      ***  an external data area
      *
      /COPY WNCPYSRC,LERPSCV120
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
**  POWR -- USED IN CURRENCY CONVERSION(FACILITY)
0000001
0000010
0000100
0001000
0010000
0100000
1000000
