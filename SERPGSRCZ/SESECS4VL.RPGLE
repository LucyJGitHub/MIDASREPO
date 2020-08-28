     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities input validation controller 4')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS4VL - Securities Input Validation Controller 4         *
      *                                                               *
      *  Function: This module validates Securities fields for        *
      *            Screen 4 input into the Midas database.            *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD000091           Date 16May13               *
      *                 AR947093           Date 26Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 AR875871           Date 06Dec11               *
      *                 AR864546           Date 24Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031  *CREATE    Date 19Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  AR875871 - Cannot insert in FRN info tab when base rate is   *
      *             blank and contractual spread is non-blank         *
      *  AR864546 - A Serious Midas Error encountered in Securities   *
      *             Maintenance FRN tab                               *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Securities screen 4 details from incoming transaction
      ** - screen format
     D NwSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)
      *
      ** Security screen 2 details retrieved from file - screen format
     D CrSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)
     D                                     PREFIX(O:1)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Securities screen 4 error indicators
     D SEESEC4       E DS                  EXTNAME(SEESEC4PD)
      *                                                                                       CRE073
      ** Externally described DS for SAR details                                              CRE073
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE073
     D  QQLCD        E                     EXTFLD(LCD)                                        CRE073
      *                                                                                       CRE073
      ** Externally described DS for Base Rate Code                                           CRE073
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                                  CRE073
      *                                                                                       CRE073
      ** DS for Access Objects - long data structure                                          CRE073
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CRE073
      *                                                                                       CRE073
      ** DS for Contractual Spread Rate                                                       CRE073
     D ArCNP           S             12A   DIM(10)                                            CRE073
      *                                                                                       CRE073
      ** DS for Contractual Spread Indicator                                                  CRE073
     D ArCNG           S              1A   DIM(10)                                            CRE073
      *                                                                                       CRE073
      ** DS for Rounding Method                                                               CRE073
     D ArRDM           S              7A   DIM(10)                                            CRE073
      *                                                                                       CRE073
      ** DS for Rounding Fractional/Decimal                                                   CRE073
     D ArRDF           S              4A   DIM(10)                                            CRE073
      *                                                                                       CRE073
      ** DS for Rate/Spread                                                                   CRE073
     D ArSPRD          S             12A   DIM(10)                                            CRE073
      *                                                                                       CRE073
      ** DS for Calculated Spread Rate                                                        CRE073
     D ArCalcSPR       S             11  7 DIM(10)                                            CRE073
      *                                                                                       CRE073
      ** DS for Numeric Contractual Spread                                                    CRE073
     D TMCNSP          S             11  7 DIM(10)                                            CRE073
      *                                                                                       CRE073
      ** DS for Base Rate Code                                                                CRE073
     D ArBRCD          S              2A   DIM(10)                                            CRE073
      *                                                                                       CRE073
      ** DS for Applicable Date                                                               CRE073
     D ArAPDT          S              6A   DIM(10)                                            CRE073
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIdx            S              3P 0
      *
      ** Index for arrays of error message ids, etc.
     D Ix              S              3P 0
      *
      ** Response Mode, received as a parameter from the common header
     D PRespMode       S              1A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     D PMode           S              6A
      *
      ** Redisplay screen
     D PReDsp          S              1A
      *
      ** Standing data
     D BJRDNB          S              5P 0
     D BJDFIN          S              1A
      *                                                                                       CRE073
     D CRE073          S              1A                                                      CRE073
     D X               S              2  0                                                    CRE073
     D Inx             S              3  0                                                    CRE073
     D Indx            S              3  0                                                    CRE073
     D PRtCd           S              7A                                                      CRE073
     D POptn           S              7A                                                      CRE073
     D PSard           S              6A                                                      CRE073
     D PPROT           S              1A                                                      CRE073
     D PCycd           S              3A                                                      CRE073
     D PBsrc           S              2A                                                      CRE073
     D PBaserate       S             11  7                                                    CRE073
     D PFinalRate      S             11P 7                                                  AR847249
     D PDDBase         S             12A                                                      CRE073
     D PDDBaseCD       S              2A                                                      CRE073
     D PFixRate        S             12A                                                      CRE073
     D PModule         S              6A                                                      CRE073
     D PCurset         S              2  0                                                    CRE073
     D DDDCSPOK        S              1A                                                      CRE073
     D DDDCSGOK        S              1A                                                      CRE073
     D DDRDMTOK        S              1A                                                      CRE073
     D DDRDFDOK        S              1A                                                      CRE073
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** M A I N  P R O C E S S I N G
      ** ============================
      *
      ** Validate Applicable Date.
      *
     C                   EXSR      SRVAppDat
      *
      ** Validate Base Rate Code
      *
     C                   EXSR      SRVBRCD
      *                                                                                       CRE073
      ** CRE073 related fields should be validated if CRE073 is ON                            CRE073
      **  and Processing type is 3 or 8                                                       CRE073
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y' AND                                           CRE073
     C                             (PPROT = '3' OR PPROT = '8')                               CRE073
     C                   EVAL      PModule = 'SECU  '                                         CRE073
      *                                                                                       CRE073
      ** Load CRE073 Fields to Array and Validate                                             CRE073
      *                                                                                       CRE073
     C                   EXSR      SRLoadArr                                                  CRE073
     C                   EXSR      SRValidate                                                 CRE073
     C                   ELSE                                                                 CRE073
      *
      ** Validate Spread Rate
      *
     C                   EXSR      SRVSprdRt
      *
      ** Validate Spread Indicator
      *
     C                   EXSR      SRVSprdIn
     C                   ENDIF                                                                CRE073
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAppDat - Validate Applicable Date                         *
      *                                                               *
      *****************************************************************
 
     C     SRVAppDat     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSAPPDT'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 4 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE4ScnFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** Date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 4 error indicators
     C                   PARM                    SEESEC4
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *                                                                                     AR875871
      ** Interest Rate Rounding enhancement                                                 AR875871
     C                   PARM                    CRE073                                     AR875871
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBRCD - Validate Base Rate Code                            *
      *                                                               *
      *****************************************************************
      *
     C     SRVBRCD       BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSBASRC'
      *                             =========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMode
      *
      ** Securities screen 4 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE4ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 4 error indicators
     C                   PARM                    SEESEC4
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSprdRt - Validate Spread Rate.                            *
      *                                                               *
      *****************************************************************
 
     C     SRVSprdRt     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSSPDRAT'
      *                             ==========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 4 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE4ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 4 error indicators
     C                   PARM                    SEESEC4
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSprdIn - Validate Spread Indicator                        *
      *                                                               *
      *****************************************************************
 
     C     SRVSprdIn     BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
 
     C                   CALLB     'SEVSSPRDIN'
      *                             ==========
      ** INPUT
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 4 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE4ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 4 error indicators
     C                   PARM                    SEESEC4
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
      *                                                                                       CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRLoadArr - Load CRE073 fields to array                      *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
                                                                                              CRE073
     C     SRLoadArr     BEGSR                                                                CRE073
      *                                                                                       CRE073
     C                   CLEAR                   ArAPDT                                       CRE073
     C                   CLEAR                   ArBRCD                                       CRE073
     C                   CLEAR                   ArCNP                                        CRE073
     C                   CLEAR                   ArCNG                                        CRE073
     C                   CLEAR                   ArRDM                                        CRE073
     C                   CLEAR                   ArRDF                                        CRE073
      *                                                                                       CRE073
      ** Load Applicable Date                                                                 CRE073
      *                                                                                       CRE073
     C                   MOVE      DDAD01        ArAPDT(1)                                    CRE073
     C                   MOVE      DDAD02        ArAPDT(2)                                    CRE073
     C                   MOVE      DDAD03        ArAPDT(3)                                    CRE073
     C                   MOVE      DDAD04        ArAPDT(4)                                    CRE073
     C                   MOVE      DDAD05        ArAPDT(5)                                    CRE073
     C                   MOVE      DDAD06        ArAPDT(6)                                    CRE073
     C                   MOVE      DDAD07        ArAPDT(7)                                    CRE073
     C                   MOVE      DDAD08        ArAPDT(8)                                    CRE073
     C                   MOVE      DDAD09        ArAPDT(9)                                    CRE073
     C                   MOVE      DDAD10        ArAPDT(10)                                   CRE073
      *                                                                                       CRE073
      ** Load Base Rate Code                                                                  CRE073
      *                                                                                       CRE073
     C                   MOVE      DDBR01        ArBRCD(1)                                    CRE073
     C                   MOVE      DDBR02        ArBRCD(2)                                    CRE073
     C                   MOVE      DDBR03        ArBRCD(3)                                    CRE073
     C                   MOVE      DDBR04        ArBRCD(4)                                    CRE073
     C                   MOVE      DDBR05        ArBRCD(5)                                    CRE073
     C                   MOVE      DDBR06        ArBRCD(6)                                    CRE073
     C                   MOVE      DDBR07        ArBRCD(7)                                    CRE073
     C                   MOVE      DDBR08        ArBRCD(8)                                    CRE073
     C                   MOVE      DDBR09        ArBRCD(9)                                    CRE073
     C                   MOVE      DDBR10        ArBRCD(10)                                   CRE073
      *                                                                                       CRE073
      ** Load Contractual Spread                                                              CRE073
      *                                                                                       CRE073
     C                   MOVE      DDCNP01       ArCNP(1)                                     CRE073
     C                   MOVE      DDCNP02       ArCNP(2)                                     CRE073
     C                   MOVE      DDCNP03       ArCNP(3)                                     CRE073
     C                   MOVE      DDCNP04       ArCNP(4)                                     CRE073
     C                   MOVE      DDCNP05       ArCNP(5)                                     CRE073
     C                   MOVE      DDCNP06       ArCNP(6)                                     CRE073
     C                   MOVE      DDCNP07       ArCNP(7)                                     CRE073
     C                   MOVE      DDCNP08       ArCNP(8)                                     CRE073
     C                   MOVE      DDCNP09       ArCNP(9)                                     CRE073
     C                   MOVE      DDCNP10       ArCNP(10)                                    CRE073
      *                                                                                       CRE073
      ** Load Contractual Spread Indicator                                                    CRE073
      *                                                                                       CRE073
     C                   MOVE      DDCNG01       ArCNG(1)                                     CRE073
     C                   MOVE      DDCNG02       ArCNG(2)                                     CRE073
     C                   MOVE      DDCNG03       ArCNG(3)                                     CRE073
     C                   MOVE      DDCNG04       ArCNG(4)                                     CRE073
     C                   MOVE      DDCNG05       ArCNG(5)                                     CRE073
     C                   MOVE      DDCNG06       ArCNG(6)                                     CRE073
     C                   MOVE      DDCNG07       ArCNG(7)                                     CRE073
     C                   MOVE      DDCNG08       ArCNG(8)                                     CRE073
     C                   MOVE      DDCNG09       ArCNG(9)                                     CRE073
     C                   MOVE      DDCNG10       ArCNG(10)                                    CRE073
      *                                                                                       CRE073
      ** Load Rounding Method array                                                           CRE073
      *                                                                                       CRE073
     C                   MOVE      DDRDM01       ArRDM(1)                                     CRE073
     C                   MOVE      DDRDM02       ArRDM(2)                                     CRE073
     C                   MOVE      DDRDM03       ArRDM(3)                                     CRE073
     C                   MOVE      DDRDM04       ArRDM(4)                                     CRE073
     C                   MOVE      DDRDM05       ArRDM(5)                                     CRE073
     C                   MOVE      DDRDM06       ArRDM(6)                                     CRE073
     C                   MOVE      DDRDM07       ArRDM(7)                                     CRE073
     C                   MOVE      DDRDM08       ArRDM(8)                                     CRE073
     C                   MOVE      DDRDM09       ArRDM(9)                                     CRE073
     C                   MOVE      DDRDM10       ArRDM(10)                                    CRE073
      *                                                                                       CRE073
      ** Load Validate Rounding Fraction/Decimal                                              CRE073
      *                                                                                       CRE073
     C                   MOVE      DDRDF01       ArRDF(1)                                     CRE073
     C                   MOVE      DDRDF02       ArRDF(2)                                     CRE073
     C                   MOVE      DDRDF03       ArRDF(3)                                     CRE073
     C                   MOVE      DDRDF04       ArRDF(4)                                     CRE073
     C                   MOVE      DDRDF05       ArRDF(5)                                     CRE073
     C                   MOVE      DDRDF06       ArRDF(6)                                     CRE073
     C                   MOVE      DDRDF07       ArRDF(7)                                     CRE073
     C                   MOVE      DDRDF08       ArRDF(8)                                     CRE073
     C                   MOVE      DDRDF09       ArRDF(9)                                     CRE073
     C                   MOVE      DDRDF10       ArRDF(10)                                    CRE073
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRErrorFlags - Set Error Flags                               *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
      *                                                                                       CRE073
     C     SRErrorFlags  BEGSR                                                                CRE073
      *                                                                                       CRE073
     C                   SELECT                                                               CRE073
     C                   WHEN      X = 1                                                      CRE073
     C                   MOVE      DDDCSPOK      OKCNP01                                      CRE073
     C                   MOVE      DDDCSGOK      OKCNG01                                      CRE073
     C                   MOVE      DDRDMTOK      OKRDM01                                      CRE073
     C                   MOVE      DDRDFDOK      OKRDF01                                      CRE073
     C                   WHEN      X = 2                                                      CRE073
     C                   MOVE      DDDCSPOK      OKCNP02                                      CRE073
     C                   MOVE      DDDCSGOK      OKCNG02                                      CRE073
     C                   MOVE      DDRDMTOK      OKRDM02                                      CRE073
     C                   MOVE      DDRDFDOK      OKRDF02                                      CRE073
     C                   WHEN      X = 3                                                      CRE073
     C                   MOVE      DDDCSPOK      OKCNP03                                      CRE073
     C                   MOVE      DDDCSGOK      OKCNG03                                      CRE073
     C                   MOVE      DDRDMTOK      OKRDM03                                      CRE073
     C                   MOVE      DDRDFDOK      OKRDF03                                      CRE073
     C                   WHEN      X = 4                                                      CRE073
     C                   MOVE      DDDCSPOK      OKCNP04                                      CRE073
     C                   MOVE      DDDCSGOK      OKCNG04                                      CRE073
     C                   MOVE      DDRDMTOK      OKRDM04                                      CRE073
     C                   MOVE      DDRDFDOK      OKRDF04                                      CRE073
     C                   WHEN      X = 5                                                      CRE073
     C                   MOVE      DDDCSPOK      OKCNP05                                      CRE073
     C                   MOVE      DDDCSGOK      OKCNG05                                      CRE073
     C                   MOVE      DDRDMTOK      OKRDM05                                      CRE073
     C                   MOVE      DDRDFDOK      OKRDF05                                      CRE073
     C                   WHEN      X = 6                                                      CRE073
     C                   MOVE      DDDCSPOK      OKCNP06                                      CRE073
     C                   MOVE      DDDCSGOK      OKCNG06                                      CRE073
     C                   MOVE      DDRDMTOK      OKRDM06                                      CRE073
     C                   MOVE      DDRDFDOK      OKRDF06                                      CRE073
     C                   WHEN      X = 7                                                      CRE073
     C                   MOVE      DDDCSPOK      OKCNP07                                      CRE073
     C                   MOVE      DDDCSGOK      OKCNG07                                      CRE073
     C                   MOVE      DDRDMTOK      OKRDM07                                      CRE073
     C                   MOVE      DDRDFDOK      OKRDF07                                      CRE073
     C                   WHEN      X = 8                                                      CRE073
     C                   MOVE      DDDCSPOK      OKCNP08                                      CRE073
     C                   MOVE      DDDCSGOK      OKCNG08                                      CRE073
     C                   MOVE      DDRDMTOK      OKRDM08                                      CRE073
     C                   MOVE      DDRDFDOK      OKRDF08                                      CRE073
     C                   WHEN      X = 9                                                      CRE073
     C                   MOVE      DDDCSPOK      OKCNP09                                      CRE073
     C                   MOVE      DDDCSGOK      OKCNG09                                      CRE073
     C                   MOVE      DDRDMTOK      OKRDM09                                      CRE073
     C                   MOVE      DDRDFDOK      OKRDF09                                      CRE073
     C                   WHEN      X = 10                                                     CRE073
     C                   MOVE      DDDCSPOK      OKCNP10                                      CRE073
     C                   MOVE      DDDCSGOK      OKCNG10                                      CRE073
     C                   MOVE      DDRDMTOK      OKRDM10                                      CRE073
     C                   MOVE      DDRDFDOK      OKRDF10                                      CRE073
     C                   ENDSL                                                                CRE073
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRValidate - Validate CRE073 Interest Rounding Fields        *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
      *                                                                                       CRE073
     C     SRValidate    BEGSR                                                                CRE073
      *                                                                                       CRE073
     C                   EVAL      X = 1                                                      CRE073
     C                   EVAL      Inx = 1                                                    CRE073
     C                   DOW       X <= 10                                                    CRE073
     C                   EXSR      SRVCSpdSn                                                  CRE073
      *                                                                                       CRE073
     C                   IF        DDDCSPOK <> 'N'                                            CRE073
     C                   EXSR      SRVRndMtd                                                  CRE073
     C                   EXSR      SRVRndFrDc                                                 CRE073
      *                                                                                       CRE073
      ** If no error, Calculate Spread Rate                                                   CRE073
      *                                                                                       CRE073
     C                   IF        DDDCSPOK <> 'N' AND                                        CRE073
     C                             DDDCSGOK <> 'N' AND                                        CRE073
     C                             DDRDMTOK <> 'N' AND                                        CRE073
     C                             DDRDFDOK <> 'N'                                            CRE073
     C                   EXSR      SRGetBseRate                                               CRE073
     C                   EXSR      SRCalcSpread                                               CRE073
     C                   EXSR      SRSetValidDta                                              CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   EXSR      SRErrorFlags                                               CRE073
     C                   EVAL      X = X + 1                                                  CRE073
     C                   ENDDO                                                                CRE073
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRVCSpdSn - Validate Contractual Spread and Indicator        *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
      *                                                                                       CRE073
     C     SRVCSpdSn     BEGSR                                                                CRE073
      *                                                                                       CRE073
      ** Validate Contractual Spread against Applicable Date                                  CRE073
      *                                                                                       CRE073
     C                   IF        ArCNP(X) <> *BLANKS AND                                    CRE073
     C                             ArAPDT(X) = *BLANKS                                        CRE073
     C                   EXSR      SRResetErrs                                                CRE073
     C                   EVAL      FldNamXAr(Inx) = 'DDCNSP' + %CHAR(X)                       CRE073
     C                   MOVE      'USR9035'     MsgIDXAr(Inx)                                CRE073
     C                   MOVE      'N'           DDDCSPOK                                     CRE073
     C                   EXSR      SRUpdatErrs                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      'Y'           DDDCSPOK                                     CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   IF        DDDCSPOK <> 'N'                                            CRE073
     C                   EXSR      SRResetErrs                                                CRE073
     C                   CALL      'ZAVCSPSG'                                                 CRE073
      *                                                                                       CRE073
      ** Input                                                                                CRE073
      *                                                                                       CRE073
     C                   PARM      *BLANKS       RetCodeOut                                   CRE073
     C                   PARM      *BLANKS       PDDBase                                      CRE073
     C**********         PARM      *BLANKS       PDDBaseCD                           CRE073 AR864546
     C                   PARM                    ArBRCD(X)                                  AR864546
     C                   PARM      *BLANKS       PFixRate                                     CRE073
     C                   PARM                    ArCNP(X)                                     CRE073
     C                   PARM                    ArCNG(X)                                     CRE073
      *                                                                                       CRE073
      ** Output                                                                               CRE073
      *                                                                                       CRE073
     C                   PARM      *ZEROS        TMCNSP(X)                                    CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      X             PCurset                                      CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM      *ZEROS        Indx                                         CRE073
     C                   PARM                    DDDCSPOK                                     CRE073
     C                   PARM                    DDDCSGOK                                     CRE073
      *                                                                                       CRE073
     C                   IF        RetCodeOut <> *BLANKS                                      CRE073
     C                   EXSR      SRUpdatErrs                                                CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRVRndMtd - Validate Rounding Method                         *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
                                                                                              CRE073
     C     SRVRndMtd     BEGSR                                                                CRE073
      *                                                                                       CRE073
     C                   EXSR      SRResetErrs                                                CRE073
     C                   CALL      'ZAVRNDMT'                                                 CRE073
      *                                                                                       CRE073
      ** Input                                                                                CRE073
      *                                                                                       CRE073
     C                   PARM      *BLANKS       RetCodeOut                                   CRE073
     C                   PARM                    ArRDM(X)                                     CRE073
     C                   PARM                    ArCNP(X)                                     CRE073
     C                   PARM                    ArRDF(X)                                     CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      X             PCurset                                      CRE073
      *                                                                                       CRE073
      ** Output                                                                               CRE073
      *                                                                                       CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM      *ZEROS        Indx                                         CRE073
     C                   PARM                    DDRDMTOK                                     CRE073
      *                                                                                       CRE073
     C                   IF        RetCodeOut <> *BLANKS                                      CRE073
     C                   EXSR      SRUpdatErrs                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *                                                                                       CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRVRndFrDc - Validate Rounding Fraction/Decimal              *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
                                                                                              CRE073
     C     SRVRndFrDc    BEGSR                                                                CRE073
      *                                                                                       CRE073
     C                   EXSR      SRResetErrs                                                CRE073
     C                   CALL      'ZAVRNDFD'                                                 CRE073
      *                                                                                       CRE073
      ** Input                                                                                CRE073
      *                                                                                       CRE073
     C                   PARM      *BLANKS       RetCodeOut                                   CRE073
     C                   PARM                    ArRDF(X)                                     CRE073
     C                   PARM                    ArCNP(X)                                     CRE073
     C                   PARM                    ArRDM(X)                                     CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      X             PCurset                                      CRE073
      *                                                                                       CRE073
      ** Output                                                                               CRE073
      *                                                                                       CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM      *ZEROS        Indx                                         CRE073
     C                   PARM                    DDRDFDOK                                     CRE073
      *                                                                                       CRE073
     C                   IF        RetCodeOut <> *BLANKS                                      CRE073
     C                   EXSR      SRUpdatErrs                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRCalcSpread - Calculate new Spread Rate based on the        *                       CRE073
      *                 rounding rules                                *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
     C     SRCalcSpread  BEGSR                                                                CRE073
      *                                                                                       CRE073
     C                   CALL      'ZACALCSPRT'                                               CRE073
     C                   PARM      *BLANKS       RetCodeOut                                   CRE073
     C                   PARM                    PBaserate                                    CRE073
     C                   PARM                    TMCNSP(X)                                    CRE073
     C                   PARM                    ArCNG(X)                                     CRE073
     C                   PARM                    ArRDM(X)                                     CRE073
     C                   PARM                    ArRDF(X)                                     CRE073
      *                                                                                       CRE073
      ** Output Calculated Rate/Spread                                                        CRE073
      *                                                                                       CRE073
     C                   PARM      *ZEROS        ArCalcSPR(X)                                 CRE073
     C                   PARM      *ZERO         PFinalRate                                 AR847249
      *                                                                                       CRE073
     C                   IF        RetCodeOut <> *BLANKS                                      CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C**********         IF        PFinalRate <= 0 AND                             AR847249 AR947093
     C**********                   ArRDM(X) <> *BLANKS                             AR847249 AR947093
     C**********         EVAL      DDRDMTOK = 'N'                                  AR847249 AR947093
     C**********         EVAL      FldNamXAr(1) = 'DDRDMT' + %CHAR(X)              AR847249 AR947093
     C**********         EVAL      MsgIDXAr(1)  = 'USS0015'                        AR847249 AR947093
      **********                                                                   AR847249 AR947093
     C**********         EVAL      MsgDtaXAr(1) = %EDITC(PFinalRate:'J')           AR847249 AR947093
     C**********         EXSR      SRUpdatErrs                                     AR847249 AR947093
     C**********         ENDIF                                                     AR847249 AR947093
                                                                                            AR847249
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRSetValidDta - Set Valid CRE073 data to valid file          *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
     C     SRSetValidDta BEGSR                                                                CRE073
      *                                                                                       CRE073
     C                   SELECT                                                               CRE073
     C                   WHEN      X = 1                                                      CRE073
     C                   IF        ArCalcSPR(1) <> 0                                          CRE073
     C                   IF         ArCNG(1) <> 'P'                                           CRE073
     C                   EVAL      DDBS01 = %CHAR(%ABS(ArCalcSPR(1)))                         CRE073
     C                   EVAL      S1BS01 = %ABS(ArCalcSPR(1))                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS01 = %CHAR(ArCalcSPR(1))                               CRE073
     C                   EVAL      S1BS01 = ArCalcSPR(1)                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS01 = *BLANKS                                           CRE073
     C                   EVAL      S1BS01 = 0                                                 CRE073
     C                   ENDIF                                                                CRE073
     C                   IF        ArCalcSPR(1) < 0                                           CRE073
     C                   IF        ArCNG(1) = 'A'                                             CRE073
     C                   MOVE      'S'           DDSI01                                       CRE073
     C                   ELSEIF    ArCNG(1) = 'S'                                             CRE073
     C                   MOVE      'A'           DDSI01                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(1)      DDSI01                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(1)      DDSI01                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   MOVE      DDSI01        S1SI01                                       CRE073
     C                   Z-ADD     TMCNSP(1)     S1CNP01                                      CRE073
     C                   MOVE      ArCNG(1)      S1CNG01                                      CRE073
     C                   MOVE      ArRDM(1)      S1RDM01                                      CRE073
     C                   MOVE      ArRDF(1)      S1RDF01                                      CRE073
     C                   WHEN      X = 2                                                      CRE073
     C                   IF        ArCalcSPR(2) <> 0                                          CRE073
     C                   IF         ArCNG(2) <> 'P'                                           CRE073
     C                   EVAL      DDBS02 = %CHAR(%ABS(ArCalcSPR(2)))                         CRE073
     C                   EVAL      S1BS02 = %ABS(ArCalcSPR(2))                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS02 = %CHAR(ArCalcSPR(2))                               CRE073
     C                   EVAL      S1BS02 = ArCalcSPR(2)                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS02 = *BLANKS                                           CRE073
     C                   EVAL      S1BS02 = 0                                                 CRE073
     C                   ENDIF                                                                CRE073
     C                   IF        ArCalcSPR(2) < 0                                           CRE073
     C                   IF        ArCNG(2) = 'A'                                             CRE073
     C                   MOVE      'S'           DDSI02                                       CRE073
     C                   ELSEIF    ArCNG(2) = 'S'                                             CRE073
     C                   MOVE      'A'           DDSI02                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(2)      DDSI02                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(2)      DDSI02                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   MOVE      DDSI02        S1SI02                                       CRE073
     C                   Z-ADD     TMCNSP(2)     S1CNP02                                      CRE073
     C                   MOVE      ArCNG(2)      S1CNG02                                      CRE073
     C                   MOVE      ArRDM(2)      S1RDM02                                      CRE073
     C                   MOVE      ArRDF(2)      S1RDF02                                      CRE073
     C                   WHEN      X = 3                                                      CRE073
     C                   IF        ArCalcSPR(3) <> 0                                          CRE073
     C                   IF         ArCNG(3) <> 'P'                                           CRE073
     C                   EVAL      DDBS03 = %CHAR(%ABS(ArCalcSPR(3)))                         CRE073
     C                   EVAL      S1BS03 = %ABS(ArCalcSPR(3))                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS03 = %CHAR(ArCalcSPR(3))                               CRE073
     C                   EVAL      S1BS03 = ArCalcSPR(3)                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS03 = *BLANKS                                           CRE073
     C                   EVAL      S1BS03 = 0                                                 CRE073
     C                   ENDIF                                                                CRE073
     C                   IF        ArCalcSPR(3) < 0                                           CRE073
     C                   IF        ArCNG(3) = 'A'                                             CRE073
     C                   MOVE      'S'           DDSI03                                       CRE073
     C                   ELSEIF    ArCNG(3) = 'S'                                             CRE073
     C                   MOVE      'A'           DDSI03                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(3)      DDSI03                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(3)      DDSI03                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   MOVE      DDSI03        S1SI03                                       CRE073
     C                   Z-ADD     TMCNSP(3)     S1CNP03                                      CRE073
     C                   MOVE      ArCNG(3)      S1CNG03                                      CRE073
     C                   MOVE      ArRDM(3)      S1RDM03                                      CRE073
     C                   MOVE      ArRDF(3)      S1RDF03                                      CRE073
     C                   WHEN      X = 4                                                      CRE073
     C                   IF        ArCalcSPR(4) <> 0                                          CRE073
     C                   IF         ArCNG(4) <> 'P'                                           CRE073
     C                   EVAL      DDBS04 = %CHAR(%ABS(ArCalcSPR(4)))                         CRE073
     C                   EVAL      S1BS04 = %ABS(ArCalcSPR(4))                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS04 = %CHAR(ArCalcSPR(4))                               CRE073
     C                   EVAL      S1BS04 = ArCalcSPR(4)                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS04 = *BLANKS                                           CRE073
     C                   EVAL      S1BS04 = 0                                                 CRE073
     C                   ENDIF                                                                CRE073
     C                   IF        ArCalcSPR(4) < 0                                           CRE073
     C                   IF        ArCNG(4) = 'A'                                             CRE073
     C                   MOVE      'S'           DDSI04                                       CRE073
     C                   ELSEIF    ArCNG(4) = 'S'                                             CRE073
     C                   MOVE      'A'           DDSI04                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(4)      DDSI04                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(4)      DDSI04                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   MOVE      DDSI04        S1SI04                                       CRE073
     C                   Z-ADD     TMCNSP(4)     S1CNP04                                      CRE073
     C                   MOVE      ArCNG(4)      S1CNG04                                      CRE073
     C                   MOVE      ArRDM(4)      S1RDM04                                      CRE073
     C                   MOVE      ArRDF(4)      S1RDF04                                      CRE073
     C                   WHEN      X = 5                                                      CRE073
     C                   IF        ArCalcSPR(5) <> 0                                          CRE073
     C                   IF         ArCNG(5) <> 'P'                                           CRE073
     C                   EVAL      DDBS05 = %CHAR(%ABS(ArCalcSPR(5)))                         CRE073
     C                   EVAL      S1BS05 = %ABS(ArCalcSPR(5))                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS05 = %CHAR(ArCalcSPR(5))                               CRE073
     C                   EVAL      S1BS05 = ArCalcSPR(5)                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS05 = *BLANKS                                           CRE073
     C                   EVAL      S1BS05 = 0                                                 CRE073
     C                   ENDIF                                                                CRE073
     C                   IF        ArCalcSPR(5) < 0                                           CRE073
     C                   IF        ArCNG(5) = 'A'                                             CRE073
     C                   MOVE      'S'           DDSI05                                       CRE073
     C                   ELSEIF    ArCNG(5) = 'S'                                             CRE073
     C                   MOVE      'A'           DDSI05                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(5)      DDSI05                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(5)      DDSI05                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   MOVE      DDSI05        S1SI05                                       CRE073
     C                   Z-ADD     TMCNSP(5)     S1CNP05                                      CRE073
     C                   MOVE      ArCNG(5)      S1CNG05                                      CRE073
     C                   MOVE      ArRDM(5)      S1RDM05                                      CRE073
     C                   MOVE      ArRDF(5)      S1RDF05                                      CRE073
     C                   WHEN      X = 6                                                      CRE073
     C                   IF        ArCalcSPR(6) <> 0                                          CRE073
     C                   IF         ArCNG(6) <> 'P'                                           CRE073
     C                   EVAL      DDBS06 = %CHAR(%ABS(ArCalcSPR(6)))                         CRE073
     C                   EVAL      S1BS06 = %ABS(ArCalcSPR(6))                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS06 = %CHAR(ArCalcSPR(6))                               CRE073
     C                   EVAL      S1BS06 = ArCalcSPR(6)                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS06 = *BLANKS                                           CRE073
     C                   EVAL      S1BS06 = 0                                                 CRE073
     C                   ENDIF                                                                CRE073
     C                   IF        ArCalcSPR(6) < 0                                           CRE073
     C                   IF        ArCNG(6) = 'A'                                             CRE073
     C                   MOVE      'S'           DDSI06                                       CRE073
     C                   ELSEIF    ArCNG(6) = 'S'                                             CRE073
     C                   MOVE      'A'           DDSI06                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(6)      DDSI06                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(6)      DDSI06                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   MOVE      DDSI06        S1SI06                                       CRE073
     C                   Z-ADD     TMCNSP(6)     S1CNP06                                      CRE073
     C                   MOVE      ArCNG(6)      S1CNG06                                      CRE073
     C                   MOVE      ArRDM(6)      S1RDM06                                      CRE073
     C                   MOVE      ArRDF(6)      S1RDF06                                      CRE073
     C                   WHEN      X = 7                                                      CRE073
     C                   IF        ArCalcSPR(7) <> 0                                          CRE073
     C                   IF         ArCNG(7) <> 'P'                                           CRE073
     C                   EVAL      DDBS07 = %CHAR(%ABS(ArCalcSPR(7)))                         CRE073
     C                   EVAL      S1BS07 = %ABS(ArCalcSPR(7))                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS07 = %CHAR(ArCalcSPR(7))                               CRE073
     C                   EVAL      S1BS07 = ArCalcSPR(7)                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS07 = *BLANKS                                           CRE073
     C                   EVAL      S1BS07 = 0                                                 CRE073
     C                   ENDIF                                                                CRE073
     C                   IF        ArCalcSPR(7) < 0                                           CRE073
     C                   IF        ArCNG(7) = 'A'                                             CRE073
     C                   MOVE      'S'           DDSI07                                       CRE073
     C                   ELSEIF    ArCNG(7) = 'S'                                             CRE073
     C                   MOVE      'A'           DDSI07                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(7)      DDSI07                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(7)      DDSI07                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   MOVE      DDSI07        S1SI07                                       CRE073
     C                   Z-ADD     TMCNSP(7)     S1CNP07                                      CRE073
     C                   MOVE      ArCNG(7)      S1CNG07                                      CRE073
     C                   MOVE      ArRDM(7)      S1RDM07                                      CRE073
     C                   MOVE      ArRDF(7)      S1RDF07                                      CRE073
     C                   WHEN      X = 8                                                      CRE073
     C                   IF        ArCalcSPR(8) <> 0                                          CRE073
     C                   IF         ArCNG(8) <> 'P'                                           CRE073
     C                   EVAL      DDBS08 = %CHAR(%ABS(ArCalcSPR(8)))                         CRE073
     C                   EVAL      S1BS08 = %ABS(ArCalcSPR(8))                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS08 = %CHAR(ArCalcSPR(8))                               CRE073
     C                   EVAL      S1BS08 = ArCalcSPR(8)                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS08 = *BLANKS                                           CRE073
     C                   EVAL      S1BS08 = 0                                                 CRE073
     C                   ENDIF                                                                CRE073
     C                   IF        ArCalcSPR(8) < 0                                           CRE073
     C                   IF        ArCNG(8) = 'A'                                             CRE073
     C                   MOVE      'S'           DDSI08                                       CRE073
     C                   ELSEIF    ArCNG(8) = 'S'                                             CRE073
     C                   MOVE      'A'           DDSI08                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(8)      DDSI08                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(8)      DDSI08                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   MOVE      DDSI08        S1SI08                                       CRE073
     C                   Z-ADD     TMCNSP(8)     S1CNP08                                      CRE073
     C                   MOVE      ArCNG(8)      S1CNG08                                      CRE073
     C                   MOVE      ArRDM(8)      S1RDM08                                      CRE073
     C                   MOVE      ArRDF(8)      S1RDF08                                      CRE073
     C                   WHEN      X = 9                                                      CRE073
     C                   IF        ArCalcSPR(9) <> 0                                          CRE073
     C                   IF         ArCNG(9) <> 'P'                                           CRE073
     C                   EVAL      DDBS09 = %CHAR(%ABS(ArCalcSPR(9)))                         CRE073
     C                   EVAL      S1BS09 = %ABS(ArCalcSPR(9))                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS09 = %CHAR(ArCalcSPR(9))                               CRE073
     C                   EVAL      S1BS09 = ArCalcSPR(9)                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS09 = *BLANKS                                           CRE073
     C                   EVAL      S1BS09 = 0                                                 CRE073
     C                   ENDIF                                                                CRE073
     C                   IF        ArCalcSPR(9) < 0                                           CRE073
     C                   IF        ArCNG(9) = 'A'                                             CRE073
     C                   MOVE      'S'           DDSI09                                       CRE073
     C                   ELSEIF    ArCNG(9) = 'S'                                             CRE073
     C                   MOVE      'A'           DDSI09                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(9)      DDSI09                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(9)      DDSI09                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   MOVE      DDSI09        S1SI09                                       CRE073
     C                   Z-ADD     TMCNSP(9)     S1CNP09                                      CRE073
     C                   MOVE      ArCNG(9)      S1CNG09                                      CRE073
     C                   MOVE      ArRDM(9)      S1RDM09                                      CRE073
     C                   MOVE      ArRDF(9)      S1RDF09                                      CRE073
     C                   WHEN      X = 10                                                     CRE073
     C                   IF        ArCalcSPR(10) <> 0                                         CRE073
     C                   IF         ArCNG(10) <> 'P'                                          CRE073
     C                   EVAL      DDBS10 = %CHAR(%ABS(ArCalcSPR(10)))                        CRE073
     C                   EVAL      S1BS10 = %ABS(ArCalcSPR(10))                               CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS10 = %CHAR(ArCalcSPR(10))                              CRE073
     C                   EVAL      S1BS10 = ArCalcSPR(10)                                     CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      DDBS10 = *BLANKS                                           CRE073
     C                   EVAL      S1BS10 = 0                                                 CRE073
     C                   ENDIF                                                                CRE073
     C                   IF        ArCalcSPR(10) < 0                                          CRE073
     C                   IF        ArCNG(10) = 'A'                                            CRE073
     C                   MOVE      'S'           DDSI10                                       CRE073
     C                   ELSEIF    ArCNG(10) = 'S'                                            CRE073
     C                   MOVE      'A'           DDSI10                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(10)     DDSI10                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      ArCNG(10)     DDSI10                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   MOVE      DDSI10        S1SI10                                       CRE073
     C                   Z-ADD     TMCNSP(10)    S1CNP10                                      CRE073
     C                   MOVE      ArCNG(10)     S1CNG10                                      CRE073
     C                   MOVE      ArRDM(10)     S1RDM10                                      CRE073
     C                   MOVE      ArRDF(10)     S1RDF10                                      CRE073
     C                   ENDSL                                                                CRE073
                                                                                            AR847249
      ** Display warning when final spread is negative                                      AR847249
                                                                                            AR847249
     C                   IF        X > 0 AND                                                AR847249
     C                             ArCalcSPR(X) < 0                                         AR847249
     C                   EVAL      DDDCSGOK = 'W'                                           AR847249
     C                   EVAL      WMsgIDXAr(1) = 'USS0016'                                 AR847249
     C**********         EVAL      WMsgDtXAr(1) = %EDITC(ArCalcSPR(X):'J')         AR847249 MD000091
     C                   EVAL      MsgDtaTmp = %EDITC(ArCalcSPR(X):'J')                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(1) = LenStr + %TRIM(MsgDtaTmp)                 MD000091
     C                   EVAL      WFldNmXAr(1) = 'DDCNSG' + %CHAR(X)                       AR847249
                                                                                            AR847249
     C                   EXSR      SRUpdatErrs                                              AR847249
     C                   ENDIF                                                              AR847249
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRGetBseRate - Get Base Rate equivalent of input Base Rate   *                       CRE073
      *                 Code                                          *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
                                                                                              CRE073
     C     SRGetBseRate  BEGSR                                                                CRE073
      *                                                                                       CRE073
     C                   IF        ArBRCD(X) <> *BLANKS                                       CRE073
     C                   CALLB     'AOBSRTR0'                                                 CRE073
     C                   PARM      '*MSG   '     PRtcd                                        CRE073
     C                   PARM      '*KEY   '     POptn                                        CRE073
     C                   PARM      S1NMCY        PCycd                                        CRE073
     C                   PARM      ArBRCD(X)     PBsrc                                        CRE073
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        CRE073
     C                   Z-ADD     BACBSR        PBaseRate                                    CRE073
     C                   ELSE                                                                 CRE073
     C                   Z-ADD     0             PBaseRate                                    CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
     C                   ENDSR                                                                CRE073
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErrs - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *                                                               *
      *****************************************************************
 
     C     SRResetErrs   BEGSR
 
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdatErrs - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
 
     C     SRUpdatErrs   BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     FldNamXar     FldNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Error Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FLDNAMEARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             Idx
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(Ix)
     C                   MOVE      *BLANKS       MSGIDARR(Ix)
     C                   MOVE      *BLANKS       MSGDTAARR(Ix)
     C                   Eval      Idx = ArrayMax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFldNamArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(Ix)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(Ix)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Warning Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFLDNAMARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             WIdx
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(Ix)
     C                   MOVE      *BLANKS       WMSGIDARR(Ix)
     C                   MOVE      *BLANKS       WMSGDTAARR(Ix)
     C                   EVAL      WIdx = ArrayMax - 1
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** Securities screen 4 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE4ScnFmt
      *
      ** Security screen 4 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE4ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Midas run date number
     C                   PARM                    BJRDNB
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdX
      *
      ** Securities screen 4 error indicators
     C                   PARM                    SEESEC4
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *                                                                                       CRE073
      ** Processing Type                                                                      CRE073
      *                                                                                       CRE073
     C                   PARM                    PPROT                                        CRE073
      *
      ** Check if CRE073 is installed                                                         CRE073
      *                                                                                       CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRtCd                                        CRE073
     C                   PARM      '*VERIFY'     POptn                                        CRE073
     C                   PARM      'CRE073'      PSard                                        CRE073
     C     SCSARD        PARM      SCSARD        DSSDY                                        CRE073
      *                                                                                       CRE073
     C                   IF        PRtCd = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   IF        PRtCd <> '*NRF   '                                         CRE073
     C                   EVAL      DBKey  = 'CRE073'                                          CRE073
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBase  = 1                                                 CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
