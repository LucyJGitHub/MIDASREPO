     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate a/c with institution detail')        *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVACIS02 - Validate Account with Institution                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15279           Date 08Nov07               *
      *                 BUG15242           Date 05Nov07               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184179             Date 05Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSW200             Date 21Aug00               *
      *                 CFT008  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15279 - Error exist in pay currency                       *
      *  BUG15242 - No validation for Account with Institution field  *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184179 - When transaction type = 'BO' allow '/' as first     *
      *           character as account.                               *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CSW200 - SWIFT 2000 enhancements                             *
      *  CFT008 - Funds Transfer addition of MT102 messages           *
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      * OK Flags for first screen
     D OKFlagDs1     E DS                  EXTNAME(FTE102S1PD)
 
      * OK Flags for Second screen
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)
 
      * OK Flags for first screen - header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
      * OK Flags for Second screen - header
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External Data structure to hold the outgoing record format
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
     D CFT004          S              1    INZ('N')
 
     D PType           S                   LIKE(PRtcd)
 
     D RespMode        S              1
 
     D DDSName         S             10
 
     D PAcct           S             35
 
     D WValid          S              1    INZ('Y')
 
     D PIbanInd        S             10
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Initialise
      *
     C                   EVAL      Idx    = 0
     C                   EVAL      WIx   = 0
     C                   EVAL      OKaI35 = 'Y'
     C                   EVAL      OKaI11 = 'Y'
     C                   EVAL      PAWiTp = *Blanks
     C                   EVAL      PIbanInd  = *Blanks
     C                   EVAL      PType = *Blanks
     C                   EVAL      PRtcd = *Blanks
      *
      ** Main processing
      *
     C                   EXSR      VALIDATE
      *
     C                   IF        OKai35 = 'Y'
      *
     C                   SELECT
     C                   WHEN      PType = 'IBAN'
     C                   EVAL      PAwiTp = 'I'
     C                   WHEN      PType = '*LEDGER'
     C                   EVAL      PAwiTp = 'G'
     C                   WHEN      PType = '*NOSTRO'
     C                   EVAL      PAwiTp = 'F'
     C                   WHEN      PType = '*RETAIL'
     C                   EVAL      PAwiTp = 'R'
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDATE - Main validation processing                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:  Validate1, Validate2                                  *
      *                                                               *
      *****************************************************************
      *
     C     VALIDATE      BEGSR
      *
      ** 1st validation case: Beneficiary contains a valid account number
      *
     C                   IF        PBenTtd = 'F' OR PBenttd = 'G' OR
     C                             PBenTtd = 'R' OR PBenttd = 'I'
     C                   EVAL      WValid = 'Y'
     C                   ELSE
     C                   EVAL      WValid = 'N'
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      HPcctTYP = 'BO'
     C                   EXSR      Validate1
     C                   WHEN      HPcctTYP = 'BI' AND WValid = 'Y'
     C                   EXSR      Validate1
     C                   OTHER
     C                   EXSR      Validate2
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDATE1 - Main validation processing                        *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls:  ValAcct                                               *
      *                                                               *
      *****************************************************************
      *
     C     VALIDATE1     BEGSR
      *
     C                   IF        PAccI35 <> *Blanks
      *
      ** Check to see if single slash or double (or none - error)
      *
     C                   SELECT
     C                   WHEN      %SUBST(PAcci35:1:1) <> '/'
     C                   EVAL      OkAi35 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0313'
     C                   EVAL      RetCodeIn = 'Error'
     C
     C*******************WHEN      %SUBST(PAcci35:1:1) = '/' AND                184179
     C*******************          %SUBST(PAcci35:2:1) <> '/'                   184179
     C*******************EVAL      PAcct = %SUBST(PAcci35:2)                    184179
     C*******************EXSR      ValAcct                                      184179
     C*******************IF        PIbanInd = '*INVALID'                        184179
     C*******************EVAL      OkAi35 = 'N'                                 184179
     C*******************EVAL      Idx = Idx + 1                                184179
     C*******************EVAL      FldNamXAr(Idx) = DDSName                     184179
     C*******************EVAL      MsgIdXAr(Idx) = 'RFV0314'                    184179
     C*******************EVAL      RetCodeIn = 'Error'                          184179
     C*******************ENDIF                                                  184179
      *
      ** If the second field is entered the user may enter a SWIFT BIC
      ** or a cust no or shortname that has a BIC assigned
      *
     C                   WHEN      %SUBST(PAcci35:1:2) = '//'
      *
     C                   CALLB     'FTVBCCC01'
     C                   PARM      'DETAIL'      RetCodeOut
     C                   PARM                    PaccI35
     C                   PARM                    PaccI11
     C                   Parm                    DDSName                        CSW200
      *
     C                   SELECT
      *
     C                   WHEN      RetCodeOut = '*INVALIDCC'
     C                   MOVE      'N'           OKAI35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0113'     MsgIdXAr(Idx)
      *
     C                   WHEN      RetCodeOut = '*DIGITERR'
     C                   MOVE      'N'           OKAI35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0119'     MsgIdXAr(Idx)
      *
     C                   WHEN      RetCodeOut = '*11ERROR'
     C                   MOVE      'N'           OKAI11
     C                   ADD       1             Idx
     C****************   MOVEL     DDSName       FldNamXAr(Idx)                 CAP084
     C                   MOVEL     'PACCI11'     FldNamXAr(Idx)                 CAP084
     C                   MOVEL     'RFV0120'     MsgIdXAr(Idx)
      *
     C                   WHEN      RetCodeOut = '*BLANKERR'
     C                   MOVE      'N'           OKAI35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0366'     MsgIdXAr(Idx)
      *
     C                   ENDSL
     C                   ENDSL
      *
     C**********         ELSE                                                      BUG15242 BUG15279
     C**********         MOVE      'N'           OKAI35                            BUG15242 BUG15279
     C**********         ADD       1             Idx                               BUG15242 BUG15279
     C**********         MOVEL     DDSName       FldNamXAr(Idx)                    BUG15242 BUG15279
     C**********         MOVEL     'RFV0366'     MsgIdXAr(Idx)                     BUG15242 BUG15279
      **********                                                                   BUG15242 BUG15279
     C                   ENDIF
      *
      ** If second (11 long field) entered - check it
      *
     C                   IF        PAccI11 <> *Blanks AND PAcci35 = *Blanks
      *
     C                   EVAL      Pacct = PAccI11
     C                   EXSR      ValAcct
      *
      ** IF not customer number or shortname then it has to be B.I.C
      *
     C                   IF        PType = '*CUSTNO' OR
     C                             PType = '*SHNAME'
      *
     C                   CALLB     'FTVBCCC01'
     C                   PARM      'DETAIL'      RetCodeOut
     C                   PARM                    PaccI35
     C                   PARM                    PaccI11
     C                   Parm                    DDSName                        CSW200
      *
     C                   SELECT
      *
     C                   WHEN      RetCodeOut = '*INVALIDCC'
     C                   MOVE      'N'           OKAI35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0113'     MsgIdXAr(Idx)
      *
     C                   WHEN      RetCodeOut = '*DIGITERR'
     C                   MOVE      'N'           OKAI35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0119'     MsgIdXAr(Idx)
      *
     C                   WHEN      RetCodeOut = '*11ERROR'
     C                   MOVE      'N'           OKAI11
     C                   ADD       1             Idx
     C****************** MOVEL     DDSName       FldNamXAr(Idx)                 CAP084
     C                   MOVEL     'PACCI11'     FldNamXAr(Idx)                 CAP084
     C                   MOVEL     'RFV0120'     MsgIdXAr(Idx)
      *
     C                   WHEN      RetCodeOut = '*BLANKERR'
     C                   MOVE      'N'           OKAI35
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0366'     MsgIdXAr(Idx)
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDATE2 - Main validation processing                        *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls:  ValAcct                                               *
      *                                                               *
      *****************************************************************
      *
     C     VALIDATE2     BEGSR
      *
      ** Otherwise if the benficiary field does not contain a valid account
      ** identifier and the transfer type is 'BI' and GOP Flag is not 'Y' th
      ** this field is needed for payment so must be valid account identifie
      *
     C                   IF        HPcctTYP = 'BI'  AND
     C                             PGOPFlg <> 'Y'
      *
     C                   EVAL      PAcct = PAcci35
     C                   EXSR      ValAcct
      *
     C                   IF        WValid = 'N'
     C                   EVAL      OkAi35 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0115'
     C                   EVAL      RetCodeIn = 'Error'
 
     C                   Else
 
     C                   If        %Subst(PAcci35:1:1) = '/'
     C                   Eval      PAcci35 = %Subst(PAcci35:2)
     C                   Endif
 
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAcct  - Checks for valid account                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
      *
     C     ValAcct       BEGSR
      *
     C                   EVAL      PType = *Blanks
     C                   EVAL      WValid = 'Y'
     C                   EVAL      PIbanInd = *blanks
      *
     C                   IF        CFT004 = 'Y'
      *
      ** Validate Account
      *
     C                   EVAL      PType = HPcctTyp
      *
     C                   CALLB     'FTVIBNB01'
     C                   Parm      *blanks       PRtcd            10
     C                   Parm                    PType
     C                   Parm                    Pacct
      *
     C                   IF        PRtcd = *Blanks
     C                   EVAL      PType = 'IBAN'
     C                   ENDIF
     C                   IF        PRtcd = '*NOTIBAN'
     C                   EVAL      PIbanInd = '*NOTIBAN'
     C                   ENDIF
     C                   IF        PRtcd = '*INVALIDOT' OR
     C                             PRtcd = '*INVALIDIN'
     C                   EVAL      PIbanInd = '*INVALID'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PType <> 'IBAN'
      *
      ** Validate Account
      *
     C                   CALLB     'AOACCTV1'
     C                   PARM      *Blanks       PRtcd            10            B:Return code
     C                   PARM                    PType                          I:A/c ID
     C                   PARM                    PAcct            35            I:A/c Currency
     C                   PARM      *Blanks       DSSDY                          I:A/c code
     C                   ENDIF
      *
      ** Invalid Account
      *
     C                   IF        PType <> 'IBAN' and
     C                             PType <> '*NOSTRO'  and
     C                             PType <> '*RETAIL'  and
     C                             PType <> '*LEDGER' or
     C                             PRtcd <> *Blanks
     C                   EVAL      Wvalid = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
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
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
      *
      ** Screen fields
      *
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName
     C                   PARM                    OKFlagDs1
     C                   PARM                    OKFlagDS2
     C                   PARM                    OKFlagHs1
     C                   PARM                    OKFlagHs2
      *
      ** Access SAR file to see if CFT004 is present
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CFT004'      @SARD             6
     C                   PARM                    DSFDY
      *
     C                   IF        @RTCD = *Blank
     C                   EVAL      CFT004 = 'Y'
     C                   ELSE
      *
     C                   IF        @RTCD = '*NRF'
     C                   EVAL      CFT004 = 'N'
     C                   ELSE
      *
      ** Database Error
      *
     C                   EVAL      DBKey  =  CFT004
     C                   EVAL      DBFile = 'AOSARDR0'
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      Dbase  = 1
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = '*Inzsr'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Program, module and procedure names for database error processing.*
      ** The following /COPY sets these values, and also defines LDA as    *
      ** an external data area                                             *
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR                                                  *** InzEnd ***
      *
      *****************************************************************
      /EJECT
      **********************************************************************
 
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
