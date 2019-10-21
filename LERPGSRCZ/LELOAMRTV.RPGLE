     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan amendments retrieve files')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELOAMRTV - Loan Amendment Retrieve (with action code versus *
      *              file keys validation)                            *
      *                                                               *
      *  Function:  This module retrieves a loan amendment from       *
      *             the database. As it does so, it validates the     *
      *             action code and loan amendment reference          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD021423E          Date 12Sep13               *
      *                 MD000091           Date 09May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244148             Date 30Mar07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 09May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10671           Date 23Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 BUG8241            Date 23Aug05               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE030             Date 01Oct02
      *                 CAP075  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD021423E - Deal date should be the deal date of the OL      *
      *              Pay instruction should be defaulted from receipt *
      *              instruction of the OL                            *
      *  MD000091 - Event Codes Substitution                          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSC054 - Period End Adjustments                              *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  244148 - Serious Midas Error occur in LOAM PI.  Initialise   *
      *           parameter LoanDetsB.                                *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10671- Auto generated error on completion of agented loan *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndication Manager                                 *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  BUG8241- OME RPG patch for delivery                          *
      *  CAP086 - Introduce Auto Authorization to the API's           *
      *           without it                                          *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP075 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ***  Loan Amendments by front office id
     FLELOAMLB  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSDKF:LOAMFOIDF)
      *
      ***  Midas LE Loan Amendments File
     FLOAMS     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(LOAMSDKF)
      ***  Midas LE Loan Amendments Extension File                                            CRE073
     FCLOAMQL0  IF   E           K DISK    INFSR(*PSSR)                                       CRE073
      *
      ***  Midas LE Loans Detail Files
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(LO_)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
      *
      ***  Midas LE Customer Lending Facility
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(FCLTYFMF:FCLTYFNF)
     F                                     PREFIX(FA_)
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
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **----------------------------------------------------------------
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
     D*PSysVal1        C                   CONST('OMEIndicator')                      BUG8241 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ***  Loan Details 'A' Format
     D LoanDetsA     E DS                  EXTNAME(CLOAN:CLOANCLF)
     D                                     PREFIX(LO_)
      *
      ***  Loan Details 'B' Format
     D LoanDetsB     E DS                  EXTNAME(CLOAN:CLOANCKF)
     D                                     PREFIX(LO_)
     D LB_RECI       E                     EXTFLD(RECI)
     D LB_LNRF       E                     EXTFLD(LNRF)
     D LB_RCDT       E                     EXTFLD(RCDT)
     D LB_MRIN       E                     EXTFLD(MRIN)
     D LB_ORED       E                     EXTFLD(ORED)
     D LB_LCD        E                     EXTFLD(LCD)
     D LB_CHTP       E                     EXTFLD(CHTP)
     D LB_TNLU       E                     EXTFLD(TNLU)
     D LB_FRNT       E                     EXTFLD(FRNT)
     D LB_AFRT       E                     EXTFLD(AFRT)
     D LB_REPA       E                     EXTFLD(REPA)
     D LB_TMST       E                     EXTFLD(TMST)
      *
      ***  Facility Details 'A' Format
     D FacilityA     E DS                  EXTNAME(FCLTY:FCLTYFMF)
     D                                     PREFIX(FA_)
      *
      ***  Facility Details 'B' Format
     D FacilityB     E DS                  EXTNAME(FCLTY:FCLTYFNF)
     D                                     PREFIX(FA_)
     D FB_RECI       E                     EXTFLD(RECI)
     D FB_CNUM       E                     EXTFLD(CNUM)
     D FB_FACT       E                     EXTFLD(FACT)
     D FB_FCNO       E                     EXTFLD(FCNO)
     D FB_RCTP       E                     EXTFLD(RCTP)
     D FB_ORED       E                     EXTFLD(ORED)
     D FB_LCD        E                     EXTFLD(LCD)
     D FB_CHTP       E                     EXTFLD(CHTP)
     D FB_TNLU       E                     EXTFLD(TNLU)
     D FB_FRNT       E                     EXTFLD(FRNT)
     D FB_AFRT       E                     EXTFLD(AFRT)
     D FB_REPA       E                     EXTFLD(REPA)
     D FB_STMP       E                     EXTFLD(STMP)
      *
      ***  Loan Amendment in File Format
     D LoamFilFmt    E DS                  EXTNAME(LOAMSDK)
      *
      ** Loan Amendment Extension in File Format                                              CRE073
     D LoamFilXFmt   E DS                  EXTNAME(LEVLOAMPD)                                 CRE073
                                                                                              CRE073
      ***  Error Indicators
     D LOAM_OK       E DS                  EXTNAME(LEELOAMPD)
      *
      ** Short Data Structure                                                                BUG8241
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    BUG8241
                                                                                             BUG8241
      ** Switchable feature details                                                          BUG8241
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG8241
     D  SCLCD        E                     EXTFLD(LCD)                                       BUG8241
                                                                                             BUG8241
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Ix              S              3P 0
                                                                                             BUG8241
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
     D PRetCode        S              7A                                                     BUG8241
     D POption         S              7A                                                     BUG8241
     D PSard           S              6A                                                     BUG8241
     D P@OP01          S             20A                                                     BUG8241
     D P@VL01          S            200A                                                     BUG8241
     D P@OP02          S             20A                                                     BUG8241
     D P@VL02          S            200A                                                     BUG8241
     D P@OP03          S             20A                                                     BUG8241
     D P@VL03          S            200A                                                     BUG8241
     D P@OP04          S             20A                                                     BUG8241
     D P@VL04          S            200A                                                     BUG8241
     D P@OP05          S             20A                                                     BUG8241
     D P@VL05          S            200A                                                     BUG8241
     D P@OP06          S             20A                                                     BUG8241
     D P@VL06          S            200A                                                     BUG8241
     D P@OP07          S             20A                                                     BUG8241
     D P@VL07          S            200A                                                     BUG8241
     D P@OP08          S             20A                                                     BUG8241
     D P@VL08          S            200A                                                     BUG8241
     D P@OP09          S             20A                                                     BUG8241
     D P@VL09          S            200A                                                     BUG8241
     D P@OP10          S             20A                                                     BUG8241
     D P@VL10          S            200A                                                     BUG8241
                                                                                             BUG8241
     D*CSC024***       S              1A                                              BUG8241 CSC054
     D*WOMEInd**       S              1A                                              BUG8241 CSC054
     D CSC054          S              1A                                                      CSC054
     D WPEAInd         S              1A                                                      CSC054
                                                                                             BUG8241
     D CLE106          S              1A                                                    BUG10671
 
     D wLoanAlpha      S              1A                                                      CLE148
     D PLNRF           S              6A                                                      CLE148
     D PValid          S              6A                                                      CLE148
     D PChkDigit       S              1A                                                      CLE148
     D PData           S              2A                                                      CLE148
      *                                                                                       CLE148
     D RTNCDE          S              7A                                                      CLE148
     D SVALK1          S             20A                                                      CLE148
     D SVAL1           S            200A                                                      CLE148
     D SVALK2          S             20A                                                      CLE148
     D SVAL2           S            200A                                                      CLE148
     D SVALK3          S             20A                                                      CLE148
     D SVAL3           S            200A                                                      CLE148
     D SVALK4          S             20A                                                      CLE148
     D SVAL4           S            200A                                                      CLE148
     D SVALK5          S             20A                                                      CLE148
     D SVAL5           S            200A                                                      CLE148
     D SVALK6          S             20A                                                      CLE148
     D SVAL6           S            200A                                                      CLE148
     D SVALK7          S             20A                                                      CLE148
     D SVAL7           S            200A                                                      CLE148
     D SVALK8          S             20A                                                      CLE148
     D SVAL8           S            200A                                                      CLE148
     D SVALK9          S             20A                                                      CLE148
     D SVAL9           S            200A                                                      CLE148
     D SVALK0          S             20A                                                      CLE148
     D SVAL10          S            200A                                                      CLE148
     D CobMode         S              1A                                                   MD021423E
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      /EJECT
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *inzsr  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** ¦ Note that this module uses logic-cycle processing; it will ¦
      ** ¦ repeat the main processing until 'return' is specified.    ¦
      ** ¦ It will also only execute the *INZSR once, on activation,  ¦
      ** ¦ not every time it is called.                               ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      * Initialisation
     C                   EXSR      Reset
                                                                                              CAP086
      ** If the mode is 'Front Office Transaction Interface'                                  CAP086
      ** Do authorisations are required                                                       CAP086
                                                                                              CAP086
     C                   IF        ModeofOp = *BLANKS                                         CAP086
     C                   EVAL      LO_AUTH  = *BLANKS                                         CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      *
      ***  If the mode is 'FRONT OFFICE'
      ***  validate front office transaction id & get amendment details
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
      *
      ***  Carry out no further validation if errors have occurred.
     C     Ix            IFGT      0
     C                   RETURN
     C                   ENDIF
     C                   ELSE
      *
      **  Validate loan amendment key details & get amendment details
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
     C     Ix            IFGT      0
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** Access Security checking
     C                   EXSR      ACCESS
      *
      **  Carry out no further validation if errors have occurred.
     C                   IF        DDACTNOK = 'N'
     C                   RETURN
     C                   ENDIF
      *
      **  If the action code is 'I', reset the loan amendment record
      **  output parameter
     C                   IF        DDACTN = 'I'
     C                   CLEAR                   LoamFilFmt
     C                   CLEAR                   LoamFilXFmt                                  CRE073
     C                   ENDIF
      *
      **  Return
     C                   RETURN
      *****************************************************************
      /EJECT
      ********************************************************************
      * Reset - Clear outputs
      ********************************************************************
     C     Reset         BEGSR
      *
      *
      ***  Clear outputs
     C                   CLEAR                   LoamFilFmt
     C                   CLEAR                   LoanDetsA
     C                   CLEAR                   LoanDetsB                                    244148
     C                   CLEAR                   FacilityA
     C                   MOVE      *ALL'Y'       LOAM_OK
     C                   CLEAR                   LoamFilXFmt                                  CRE073
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - Validation for front office transaction interface
      *****************************************************************
     C     VFRNT         BEGSR
      *
      ** Action code must be I, E, A, X or R or Q (CLE030)
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'X'
     C     DDACTN        ANDNE     'R'
     C     DDACTN        ANDNE     'Q'                                                        CLE030
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEA0021'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      ***  Error if front office transaction ID is blank
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEA1512'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      **  Access loan amendment with front office transaction ID
     C     FOTRID        CHAIN     LOAMFOIDF                          99
      *
      **  If insert
     C     DDACTN        IFEQ      'I'
      *
      **  Front office transaction ID can't be already present
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEA1514'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ELSE
      *
      **  If not insert, front office transaction ID must be present
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEA1513'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      **  If not insert, update Midas loan amendment key fields
     C                   MOVEL     LNRF          DDLOAN
     C                   MOVEL     LASN          DDSEQN
     C                   MOVEL     *BLANKS       DDVDAT
      *
     C     VDAT          IFNE      *ZERO
     C                   CALLB     'ZDATE2'
     C                   PARM      VDAT          ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATE         DDVDAT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Entry is a valid number
     C                   MOVE      DDLOAN        WKLNR
     C                   MOVE      'A'           WRCDT
      *
      ** Get loan details
     C                   EXSR      GetLoan
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - Validation of loan amendment key details
      *****************************************************************
     C     VAL           BEGSR
      *
      ** Action code must be I, A, X, E or R
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'X'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'R'
     C     DDACTN        ANDNE     'Q'                                                        CLE030
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEA1511'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'N'                                           CLE148
      *
      ** Validate loan number
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZALIGNok          1
     C                   PARM      DDLOAN        ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
      *
      ** Entry is not a valid number
     C     ZALIGNok      IFEQ      'N'
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLOAN'      FldNameArr(Ix)
     C                   MOVEL     'LEA0025'     MsgIdArr(Ix)
      *
      ** If called from screen input, allow validation of all key fields
     C                   ENDIF
      *                                                                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLOAN                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
      *                                                                                       CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
      *                                                                                       CLE148
     C     PValid        IFNE      *BLANKS                                                    CLE148
     C                   MOVEL     'N'           DDLOANOK                                     CLE148
     C                   ADD       1             Ix                                           CLE148
     C                   MOVEL     'DDLOAN'      FldNameArr(Ix)                               CLE148
     C                   MOVEL     '5045549'     MsgIdArr(Ix)                                 CLE148
     C**********         MOVEL     PDATA         MsgDtaArr(Ix)                       CLE148 MD000091
     C                   EVAL      BLen = %Len(%Trim(PDATA))                                MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(PDATA)                     MD000091
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   ENDIF                                                                CLE148
      *
      ** Entry is a valid number
     C                   MOVE      DDLOAN        WKLNR
     C                   MOVE      'A'           WRCDT
      *
      ** Number must be greater than zero
     C*****WKLNR         IFLE      0                                                          CLE148
     C     WKLNR         IFLE      *BLANKS                                                    CLE148
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLOAN'      FldNameArr(Ix)
     C                   MOVEL     'LEA0030'     MsgIdArr(Ix)
      *
      ** If called from screen input, allow validation of all key fields
     C                   ENDIF
      *
      ** Get loan details
     C                   EXSR      GetLoan
      *
      ** Amendment type must be valid, if entered - must be entered if insert
     C     DDATYP        IFNE      *BLANKS
 
     C     DDATYP        IFNE      'PI'
     C     DDATYP        ANDNE     'SC'
     C     DDATYP        ANDNE     'BC'
     C     DDATYP        ANDNE     'SA'
     C     DDATYP        ANDNE     'LS'
     C     DDATYP        ANDNE     'PD'
     C     DDATYP        ANDNE     'PT'                                                       CLE106
     C     DDATYP        ANDNE     'PF'                                                       CLE106
      *
      * Cannot insert a 'past due'
     C     DDACTN        OREQ      'I'
     C     DDATYP        ANDEQ     'PD'
      *
     C                   MOVE      'N'           DDATYPOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDATYP'      FldNameArr(Ix)
     C                   MOVEL     'LEA0183'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate value date if entered
     C                   MOVEL     DDVDAT        NUM7              7 0
     C                   MOVEL     NUM7          ALF6              6
      *
     C     DDVDAT        IFEQ      ALF6
     C                   CALLB     'ZDATE1'
     C                   PARM      DDVDAT        ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt           1
     C                   PARM                    ErrorFlag         1
     C                   ENDIF
      *
     C                   IF        DDVDAT <> ALF6 OR ErrorFlag = 'Y'
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'LEA0105'     MsgIdArr(Ix)
      *
      ** If called from screen input, allow validation of all key fields
     C                   ENDIF
      *
      ** Check if sequence no. is numeric
     C     DDACTN        IFNE      'I'
     C                   MOVEL     DDSEQN        NUM4              4 0
     C                   MOVEL     NUM4          ALF3              3
      *
     C     DDSEQN        IFNE      ALF3
     C     DDSEQN        OREQ      '000'
     C                   MOVE      'N'           DDSEQNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSEQN'      FldNameArr(Ix)
     C                   MOVEL     'LEA0031'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate sequence number
     C     DDACTN        IFNE      'I'
     C     DDSEQN        ANDEQ     *BLANK
     C                   MOVE      'N'           DDSEQNOK
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDSEQN'
     C                   MOVEL     'LEA0107'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'I'
     C     DDSEQN        ANDNE     *BLANK
                                                                                             BUG8241
      ***Allow*entry*for*Amendment*Seq.*No.*for*Insert*if*CSC024*is                   BUG8241 CSC054
      ***switched*on*and*running*on*OME*system.                                       BUG8241 CSC054
      ** Allow entry for Amendment Seq. No. for Insert if CSC054 is                           CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                             BUG8241
     C*****CSC024        IFNE      'Y'                                                BUG8241 CSC054
     C*****WOMEInd       ORNE      'Y'                                                BUG8241 CSC054
     C     CSC054        IFNE      'Y'                                                        CSC054
     C     CobMode       ANDNE     'Y'                                                     MD021423E
     C     WPEAInd       ORNE      'Y'                                                        CSC054
     C     CobMode       ANDNE     'Y'                                                     MD021423E
                                                                                             BUG8241
     C                   MOVE      'N'           DDSEQNOK
     C                   ADD       1             Ix
     C                   EVAL      FldNameArr(Ix) = 'DDSEQN'
     C**********         MOVEL     'LEA0108'     MsgIdArr(Ix)                                 CLE106
     C                   MOVEL     'LEA1614'     MsgIdArr(Ix)                                 CLE106
     C                   ENDIF                                                               BUG8241
                                                                                             BUG8241
     c**********         IF        CSC024 = 'Y' AND                                   BUG8241 CSC054
     c**********                   WOMEInd = 'Y'                                      BUG8241 CSC054
     C                   IF        CSC054 = 'Y' AND                                           CSC054
     C                             WPEAInd = 'Y'                                              CSC054
     C                   MOVE      DDLOAN        WKLNR                                       BUG8241
     C                   MOVE      ZDAYNO        WKVDT                                       BUG8241
     C                   MOVE      DDSEQN        WKLSN                                       BUG8241
                                                                                             BUG8241
     C     KLAKEY        CHAIN     LOAMS                                                     BUG8241
     C                   IF        %FOUND(LOAMS)                                             BUG8241
     C                   MOVE      'N'           DDACTNOK                                    BUG8241
     C                   EVAL      Ix = Ix + 1                                               BUG8241
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                              BUG8241
     C                   MOVEL     'LEA1525'     MsgIdArr(Ix)                                BUG8241
     C                   ENDIF                                                               BUG8241
     C                   ENDIF                                                               BUG8241
                                                                                             BUG8241
     C                   ENDIF
      *
      ** Chain to loan amendments file if not insert
     C     DDACTN        IFNE      'I'
     C                   MOVE      DDLOAN        WKLNR
     C                   MOVE      ZDAYNO        WKVDT
     C                   MOVE      DDSEQN        WKLSN
      *
     C     KLAKEY        CHAIN     LOAMS                              99
      *
     C     *IN99         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     RECI          ANDNE     'R'
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEA0176'     MsgIdArr(Ix)
                                                                                              CRE073
     C                   ELSE                                                                 CRE073
                                                                                              CRE073
      ** Chain to Loan Amendments Extension File                                              CRE073
                                                                                              CRE073
     C     KLAKEY        CHAIN     CLOAMQL0                           99                      CRE073
                                                                                              CRE073
     C     *IN99         IFEQ      '0'                                                        CRE073
     C                   MOVEL     LoamFilFmt    LoamFilXFmt                                  CRE073
     C                   Z-ADD     AMCNSP        LACNSP                                       CRE073
     C                   MOVEL     AMCNSG        LACNSG                                       CRE073
     C                   MOVEL     AMRDMT        LARDMT                                       CRE073
     C                   MOVEL     AMRDFD        LARDFD                                       CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GETLOAN - Get loan details
      *****************************************************************
     C     GETLOAN       BEGSR
      *
     C     KLKEY         CHAIN     CLOANCLF                           99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLOAN'      FldNameArr(Ix)
     C                   MOVEL     'LEA0025'     MsgIdArr(Ix)
     C                   GOTO      EXGET
     C                   ENDIF
      *
      ** Chain to Loans detail B to get additional information
      ** if CEU020 is on
     C     CEU020        IFEQ      'Y'
     C                   MOVE      'B'           WRCDT
     C     KLKEY         CHAIN     CLOANCKF                           99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLOAN'      FldNameArr(Ix)
     C                   MOVEL     'LEA1515'     MsgIdArr(Ix)
     C                   GOTO      EXGET
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANKS       LO_NCCY
     C                   ENDIF
      *
     C                   IF        CLE106 = 'Y' AND                                         BUG10671
     C**********                   LO_PTFC <> *ZEROS  AND                           BUG10671 CSD027A
     C                             LO_PTFC <> *BLANKS AND                                    CSD027A
     C                             LO_PTFT <> *ZEROS  AND                                   BUG10671
     C                             LO_PTFN <> *ZEROS                                        BUG10671
     C**********         Z-ADD     LO_PTFC       WFCNM                              BUG10671 CSD027A
     C                   MOVE      LO_PTFC       WFCNM                                       CSD027A
     C                   Z-ADD     LO_PTFT       WFACT                                      BUG10671
     C                   Z-ADD     LO_PTFN       WFNUM                                      BUG10671
     C                   ELSE                                                               BUG10671
     C**********         Z-ADD     LO_FCUS       WFCNM                                        CSD027
     C                   EVAL      WFCNM  = LO_FCUS                                           CSD027
     C                   Z-ADD     LO_FTYP       WFACT
     C                   Z-ADD     LO_FSEQ       WFNUM
     C                   ENDIF                                                              BUG10671
     C                   MOVE      'A'           WFRTP
      *
      *  Get facility details
     C     KFCLT         CHAIN     FCLTY                              99
     C                   IF        *IN99 = '0'
     C                   MOVE      'B'           WFRTP
     C     KFCLT         CHAIN     FCLTY                              99
     C                   ELSE
     C                   MOVE      'N'           DDLOANOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLOAN'      FldNameArr(Ix)
     C                   MOVEL     'LEA1516'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     EXGET         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACCESS - Access security checking
      *****************************************************************
     C     ACCESS        BEGSR
      *
      ** Check user/action/branch authority
     C     RespMode      IFEQ      'S'
      *
      ** For single branch system, check if user is authorised to the
      ** action
     C     BGMBIN        IFEQ      'N'
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFNE      0
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEA0302'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** For multibranching system, branch code on loans file (if insert)
      ** or loan amendments file (if not insert) must be valid for the user
     C     BGMBIN        IFEQ      'Y'
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM      LO_BRCA       @ZBR              3
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEA0303'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     @ERR          IFEQ      2
     C                   MOVE      'N'           DDACTNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEA0304'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
     C     *ENTRY        PLIST
      *
      ***  INPUTS
      *    ======
      * Return code
     C                   PARM                    RetCodeOut
 
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM                    ModeofOp          6
 
      * Response mode
     C                   PARM                    RespMode          1
 
      * Action Code
     C                   PARM                    DDACTN            1
 
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
 
      * Loan Number / Value Date / Sequence
     C                   PARM                    DDLOAN            6
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDSEQN            3
     C                   PARM                    DDATYP            2
 
      * Where called from
     C                   PARM                    CallModCod        3
 
      * Features
     C                   PARM                    CEU020            1
     C                   PARM                    CLE030            1                          CLE030
 
      * Multi-branching/date format indicators
     C                   PARM                    BGMBIN            1
     C                   PARM                    BJDFIN            1
      *
      ***  OUTPUTS
      *    =======
      * Current Loan Amendment in file format, plus Loan/facility details
     C                   PARM                    LoamFilFmt
     C                   PARM                    LoanDetsA
     C                   PARM                    LoanDetsB
     C                   PARM                    FacilityA
     C                   PARM                    FacilityB
 
      * Error Indicators
     C                   PARM                    LOAM_OK
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
     C                   PARM                    LoamFilXFmt                                  CRE073
     C                   PARM                    CobMode                                   MD021423E
      *
      ***  Initialise program name
     C                   MOVEL     'LELOAMRTV'   DBPGM
      *
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                           BUG8241 CSC054
      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
                                                                                             BUG8241
     C                   CALLB     'AOSARDR0'                                                BUG8241
     C                   PARM      *BLANKS       PRetCode                                    BUG8241
     C                   PARM      '*VERIFY'     POption                                     BUG8241
     C**********         PARM      'CSC024'      PSard                                BUG8241 CSC054
     C                   PARM      'CSC054'      PSard                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG8241
                                                                                             BUG8241
     C                   IF        PRetCode <> *BLANKS AND                                   BUG8241
     C                             PRetCode <> '*NRF   '                                     BUG8241
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG8241
     C**********         EVAL      DBKey  = 'CSC024'                                  BUG8241 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 1                                                BUG8241
     C                   EXSR      *PSSR                                                     BUG8241
     C                   ENDIF                                                               BUG8241
                                                                                             BUG8241
     C**********         EVAL      CSC024 = 'N'                                       BUG8241 CSC054
     C**********         EVAL      WOMEInd = 'N'                                      BUG8241 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                             BUG8241
     C                   IF        PRetCode = *BLANKS                                        BUG8241
     C**********         EVAL      CSC024 = 'Y'                                       BUG8241 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
                                                                                             BUG8241
      ** Access System values                                                                BUG8241
                                                                                             BUG8241
     C                   CALL      'AOSVALR0'                                                BUG8241
     C                   PARM      *BLANKS       PRetCode                                    BUG8241
     C                   PARM      PSysVal1      P@OP01                                      BUG8241
     C                   PARM      *BLANKS       P@VL01                                      BUG8241
     C                   PARM      *BLANKS       P@OP02                                      BUG8241
     C                   PARM      *BLANKS       P@VL02                                      BUG8241
     C                   PARM      *BLANKS       P@OP03                                      BUG8241
     C                   PARM      *BLANKS       P@VL03                                      BUG8241
     C                   PARM      *BLANKS       P@OP04                                      BUG8241
     C                   PARM      *BLANKS       P@VL04                                      BUG8241
     C                   PARM      *BLANKS       P@OP05                                      BUG8241
     C                   PARM      *BLANKS       P@VL05                                      BUG8241
     C                   PARM      *BLANKS       P@OP06                                      BUG8241
     C                   PARM      *BLANKS       P@VL06                                      BUG8241
     C                   PARM      *BLANKS       P@OP07                                      BUG8241
     C                   PARM      *BLANKS       P@VL07                                      BUG8241
     C                   PARM      *BLANKS       P@OP08                                      BUG8241
     C                   PARM      *BLANKS       P@VL08                                      BUG8241
     C                   PARM      *BLANKS       P@OP09                                      BUG8241
     C                   PARM      *BLANKS       P@VL09                                      BUG8241
     C                   PARM      *BLANKS       P@OP10                                      BUG8241
     C                   PARM      *BLANKS       P@VL10                                      BUG8241
                                                                                             BUG8241
     C                   IF        PRetCode  <> *BLANKS                                      BUG8241
     C                   EVAL      DBFile = 'SDSVALPD'                                       BUG8241
     C                   EVAL      DBKEy = '*KEY   '                                         BUG8241
     C                   EVAL      DBase = 2                                                 BUG8241
     C                   EXSR      *PSSR                                                     BUG8241
     C                   ENDIF                                                               BUG8241
     C                   IF        P@VL01 = 'Y'                                              BUG8241
     C**********         EVAL      WOMEInd = 'Y'                                      BUG8241 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                               BUG8241
     C                   ENDIF                                                               BUG8241
                                                                                             BUG8241
      ** Check if enhancement Syndications Manager is enabled                               BUG10671
                                                                                            BUG10671
     C                   CALLB     'AOSARDR0'                                               BUG10671
     C                   PARM      *BLANKS       PRetCode                                   BUG10671
     C                   PARM      '*VERIFY'     POption                                    BUG10671
     C                   PARM      'CLE106'      PSard                                      BUG10671
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG10671
                                                                                            BUG10671
     C                   IF        PRetCode <> *BLANKS AND                                  BUG10671
     C                             PRetCode <> '*NRF   '                                    BUG10671
     C                   EVAL      DBFile = 'SCSARDPD'                                      BUG10671
     C                   EVAL      DBKey  = 'CLE106'                                        BUG10671
     C                   EVAL      DBase  = 1                                               BUG10671
     C                   EXSR      *PSSR                                                    BUG10671
     C                   ENDIF                                                              BUG10671
                                                                                            BUG10671
     C                   EVAL      CLE106 = 'N'                                             BUG10671
     C                   IF        PRetCode = *BLANKS                                       BUG10671
     C                   EVAL      CLE106 = 'Y'                                             BUG10671
     C                   ENDIF                                                              BUG10671
                                                                                            BUG10671
      *                                                                                       CLE148
      ** Check System Value: LoanAlphaAllow                                                   CLE148
      *                                                                                       CLE148
     C                   EVAL      SVALK1 = 'LoanAlphaAllow'                                  CLE148
      *                                                                                       CLE148
     C                   CALL      'AOSVALR0'                                                 CLE148
     C                   PARM                    RTNCDE                                       CLE148
     C                   PARM                    SVALK1                                       CLE148
     C                   PARM                    SVAL1                                        CLE148
     C                   PARM                    SVALK2                                       CLE148
     C                   PARM                    SVAL2                                        CLE148
     C                   PARM                    SVALK3                                       CLE148
     C                   PARM                    SVAL3                                        CLE148
     C                   PARM                    SVALK4                                       CLE148
     C                   PARM                    SVAL4                                        CLE148
     C                   PARM                    SVALK5                                       CLE148
     C                   PARM                    SVAL5                                        CLE148
     C                   PARM                    SVALK6                                       CLE148
     C                   PARM                    SVAL6                                        CLE148
     C                   PARM                    SVALK7                                       CLE148
     C                   PARM                    SVAL7                                        CLE148
     C                   PARM                    SVALK8                                       CLE148
     C                   PARM                    SVAL8                                        CLE148
     C                   PARM                    SVALK9                                       CLE148
     C                   PARM                    SVAL9                                        CLE148
     C                   PARM                    SVALK0                                       CLE148
     C                   PARM                    SVAL10                                       CLE148
      *                                                                                       CLE148
      ** If the system value is not found then issue a database error                         CLE148
      *                                                                                       CLE148
     C                   IF        RTNCDE <> *BLANKS                                          CLE148
     C                   EVAL      DBFile = 'SDSVALPD'                                        CLE148
     C                   EVAL      DBKey  = '*FIRST  '                                        CLE148
     C                   EVAL      DBase  = 3                                                 CLE148
     C                   EXSR      *PSSR                                                      CLE148
      *                                                                                       CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     SVAL1         wLoanAlpha                                   CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C     P_LELOANISO   PLIST                                                                CLE148
      *                                                                                       CLE148
      ** Loan Number (Input)                                                                  CLE148
      *                                                                                       CLE148
     C                   PARM                    PLNRF                                        CLE148
      *                                                                                       CLE148
      ** Validity Flags (Output)                                                              CLE148
      *                                                                                       CLE148
     C                   PARM                    PValid                                       CLE148
      *                                                                                       CLE148
      ** Check Digit (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PChkDigit                                    CLE148
     C                   PARM                    PData                                        CLE148
      *
      ***  Key Lists
     C     KLKEY         KLIST
     C**********         KFLD                    WKLNR             6 0                        CLE148
     C                   KFLD                    WKLNR             6                          CLE148
     C                   KFLD                    WRCDT             1
      *
     C     KLAKEY        KLIST
     C**********         KFLD                    WKLNR             6 0                        CLE148
     C                   KFLD                    WKLNR             6                          CLE148
     C                   KFLD                    WKVDT             5 0
     C                   KFLD                    WKLSN             3 0
      *
     C     KFCLT         KLIST
     C**********         KFLD                    WFCNM             6 0                        CSD027
     C                   KFLD                    WFCNM             6                          CSD027
     C                   KFLD                    WFACT             3 0
     C                   KFLD                    WFNUM             2 0
     C                   KFLD                    WFRTP             1
      *
     C                   ENDSR
      ********************************************************************
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
(c) Finastra International Limited 2002
