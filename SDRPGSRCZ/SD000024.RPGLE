     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Populate AML Acc Holdings Details Import')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000024 - Populate AML Account Holdings Details             *
      *             Import Table                                      *
      *                                                               *
      *  Function:  This program will populate the AML Account        *
      *             holdings details import table.                    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD033670           Date 23Jun15               *
      *                 MD032254           Date 23Jun15               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3031            Date 03Jun02               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CSD017  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033670 - BNI SG Midas to SAM Interface File Duplicate Data *
      *  MD032254 - Customer not found. Used the Customer Branch      *
      *             instead of the Account Branch.                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3031 - Compliance Watch AML export data corrections       *
      *            (Recompile)                                        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F***SDAHOLPD  IF A E             DISK    INFSR(*PSSR)                                  MD033670
     FSDAHOLL0  IF A E           K DISK    INFSR(*PSSR)                                     MD033670
                                                                                            MD032254
     FSDCUSTL0  IF   E           K DISK    INFSR(*PSSR)                                     MD032254
      *                                                                                     MD032254
      ** Customer Details File                                                              MD032254
      *                                                                                     MD032254
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  AccountDetails
     D PAccDetls     E DS                  EXTNAME(ACCNTAB)
 
      **  Switchable Feature Details                                                        MD032254
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(C_)                     MD032254
                                                                                            MD032254
      **  Short Access Object Data Structure                                                MD032254
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD032254
                                                                                            MD032254
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameter
     D PMode           S              1
 
     D*WkTemp***       S              6                                                       CGL029
     D WkTemp          S             12                                                       CGL029
     D WkTemp1         S              9
     D*WkTemp2**       S              9                                                       CGL029
     D WkTemp2         S             15                                                       CGL029
      ** Access Object Parameters                                                           MD032254
     D PRtCd           S              7A                                                    MD032254
     D POptn           S              7A                                                    MD032254
     D PSARD           S              6A                                                    MD032254
                                                                                            MD032254
      ** Switchable Features                                                                MD032254
     D CGP001          S              1A                                                    MD032254
                                                                                            MD032254
     D KYCUCD          S             20A                                                    MD033670
     D KYACNO          S             30A                                                    MD033670
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      **  Fill up fields for SDAHOLPD.
 
     C*******************MOVEL     CNUM          X4CUCD                                      BUG3031
     C                   MOVE      CNUM          CNUMA             6                         BUG3031
     C                   If        CGP001 = 'Y'                                             MD032254
     C     CNUM          Chain     @BBREBG                                                  MD032254
     C                   Eval      X4CUCD = BBBRCD + '-' + BBCUST                           MD032254
     C                   Else                                                               MD032254
     C                   Eval      X4CUCD = CNUM                                            MD032254
     C                   Endif                                                              MD032254
     C**********         EVAL      X4CUCD = BRCA + '-' + CNUMA                      BUG3031 MD032254
 
     C                   MOVEL     ACOD          WkTemp
     C                   MOVE      ACSQ          WkTemp
     C*******************EVAL      WKTemp1 = BRCA + X4CUCD                                   BUG3031
     C                   EVAL      WKTemp1 = BRCA + CNUMA                                    BUG3031
     C                   EVAL      WkTemp2 = CCY  + WkTemp
     C                   EVAL      X4ACNO = WkTemp1 + WkTemp2
 
     C                   EVAL      X4BRCA = BRCA
 
     C                   IF        PMode  = 'A'
     C                   EVAL      X4ACTN = 'I'
     C                   ELSE
     C                   EVAL      X4ACTN = CHTP
     C                   ENDIF
 
     C                   CLEAR                   KYCUCD                                     MD032254
     C                   CLEAR                   KYACNO                                     MD032254
     C                   EVAL      KYCUCD = X4CUCD                                          MD032254
     C                   EVAL      KYACNO = X4ACNO                                          MD032254
      *                                                                                     MD033670
     C     KYHOLP        CHAIN     SDAHOLL0                                                 MD033670
     C                   IF        NOT %FOUND(SDAHOLL0)                                     MD033670
      *                                                                                     MD033670
     C                   WRITE     SDAHOLD0
 
     C                   ENDIF                                                              MD033670
                                                                                            MD033670
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    Pmode
     C                   PARM                    PAccDetls
 
     C     KYHOLP        KLIST                                                              MD033670
     C                   KFLD                    KYCUCD                                     MD033670
     C                   KFLD                    KYACNO                                     MD033670
                                                                                            MD033670
                                                                                            MD032254
      ** Check if CGP001 is enabled.                                                        MD032254
                                                                                            MD032254
     C                   EVAL      CGP001 = 'N'                                             MD032254
                                                                                            MD032254
     C                   CALL      'AOSARDR0'                                               MD032254
     C                   PARM      *BLANKS       PRtCd                                      MD032254
     C                   PARM      '*VERIFY'     POptn                                      MD032254
     C                   PARM      'CGP001'      PSARD                                      MD032254
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD032254
                                                                                            MD032254
     C                   IF        PRtCd = *BLANKS                                          MD032254
     C                   EVAL      CGP001 = 'Y'                                             MD032254
     C                   ELSE                                                               MD032254
                                                                                            MD032254
     C                   IF        PRtCd <> '*NRF   '                                       MD032254
     C     *LOCK         IN        LDA                                                      MD032254
     C                   EVAL      DBFile = 'SCSARDPD'                                      MD032254
     C                   EVAL      DBKey = 'CGP001'                                         MD032254
     C                   EVAL      DBase = 1                                                MD032254
     C                   OUT       LDA                                                      MD032254
     C                   EVAL      *INU7 = *ON                                              MD032254
     C                   EVAL      *INU8 = *ON                                              MD032254
     C                   EXSR      *PSSR                                                    MD032254
     C                   ENDIF                                                              MD032254
                                                                                            MD032254
     C                   ENDIF                                                              MD032254
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2002
