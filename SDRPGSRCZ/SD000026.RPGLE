     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Populate acct history dets import table')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000026 - Populate Account History Details Import Table     *
      *                                                               *
      *  Function:  This program will export details of the Midas     *
      *             account movements into the Anti-Money Laundering  *
      *             (AML) database.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 BUG3031            Date 03Jun02               *
      *                 CGL029             Date 01Sep03               *
      *                 CSD017  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG3031 - Compliance Watch AML export data corrections       *
      *            (Recompile)                                        *
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
 
     FSDAHISPD  IF A E             DISK    INFSR(*PSSR)
      ** Midas AML Account History Details
 
     FAPOSTPD   IF   E             DISK    INFSR(*PSSR)
      ** Midas GL Account Postings Details
 
     FEODPOPD   IF   E             DISK    INFSR(*PSSR)
      ** Midas GL COB Postings Details
     F                                     RENAME(APOSTPDF:EODPOPDF)
 
     FSDAMLML1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas AML PF/SDAMLMPD by Retail Transaction Type
 
     FSDAMLML2  IF   E           K DISK    INFSR(*PSSR)
      ** Midas AML PF/SDAMLMPD by Deal Type / Deal Subtype
     F                                     RENAME(SDAMLMD0:SDAMLMD2)
 
     FSDBRCHL5  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Branch Codes by Customer Number
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Loans File
     F                                     IGNORE(CLOANZ1F)
 
     FMLOAN     IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE New Matured Loans
     F                                     RENAME(CLOANHHF:MLOANHHF)
     F                                     RENAME(CLOANCLF:MLOANCLF)
     F                                     RENAME(CLOANCKF:MLOANCKF)
     F                                     IGNORE(CLOANZ1F)
 
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
 
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
      ** External DS for Compliance Watch Configuration Data File
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External DS for Account Code Details File
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for Branch Code Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
     D/COPY WNCPYSRC,SDH00142
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry list parameters
     D PMode           S              1A
 
      ** Standard parameters
     D PRetCode        S              7A
     D POption         S              7A
     D***PAcCod*         S              4A                                                    CGL029
     D PAcCod          S             10A                                                      CGL029
     D PBRCA           S              3A
     D PCcyCde         S              3A
 
      ** KLIST work variables for LF/SDAMLML2
     D KTRAT           S              5A
     D KDealType       S              2A   INZ('  ')
     D KDealSType      S              2A   INZ('  ')
 
      ** KLIST work variables for LF/CLOAN and LF/MLOAN
     D*KTRef****       S              6  0                                                    CLE148
     D KTRef           S              6                                                       CLE148
     D KRcdT           S              1A
 
      ** Parameters for ZACVTDATE
     D PInDate         S              5
     D POutDate        S               D
     D PCvtdDate       S             10
 
      ** Parameters for ZCCYCN
     D PInAmt          S             15P 0
     D PFrCcy          S              3A
     D PToCcy          S              3A
     D PFrSRt          S             13P 8
     D PToSRt          S             13P 8
     D PFrMDI          S              1A
     D PToMDI          S              1A
     D PFrNDP          S              1P 0
     D PToNDP          S              1P 0
     D PToAmt          S             15P 0
     D PCXRt           S             13P 8
     D PCMDI           S              1A
 
      ** Parameters for ZACVTAMT
     D PNtvAmt         S             15A
     D PNtvCcy         S              3A
     D POutAmt         S             18  3
     D PCvtAmt         S             16A
 
      ** Parameter for ZAAMLSETRE
     D*POrdCust*       S              6S 0                                                    CSD027
     D POrdCust        S              6                                                       CSD027
     D*PBenefit*       S              6S 0                                                    CSD027
     D PBenefit        S              6                                                       CSD027
     D WWRACT          S             20A
     D WWRCTY          S              2A
     D WWRBNK          S             20A
     D WWRCDE          S             11A
     D WWPACT          S             20A
     D WWPCTY          S              2A
     D WWPBNK          S             20A
     D WWPCDE          S             11A
     D WWDACT          S             35A
     D WWDCTY          S              2A
     D WWDBNK          S             20A
 
      ** Working Variables
     D WFld1           S              1A
     D WFld2           S              2A
     D WFld5           S              5A
     D WFld6           S              6A
     D WFLD9           S              9A
     D WFld10          S             10A
     D WRecFound       S              1A   INZ('N')
     D WKey            S              6A
     D WCNUM           S              6A
     D***WACOD**         S              4A                                                    CGL029
     D WACOD           S             10A                                                      CGL029
     D WACSQ           S              2A
     D WDSTTmp         S              2A
     D/COPY WNCPYSRC,SDH00143
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read through all Midas postings in APOSTPD if PMode is 'A'
      ** otherwise read through in EODPOPD.
 
     C                   IF        PMode = 'A'
     C                   READ      APOSTPD                                01
     C                   ELSE
     C                   READ      EODPOPD                                01
     C                   ENDIF
 
     C                   DOW       *IN01 = *OFF
 
      ** Process details of each record
 
     C                   EXSR      SRProcDets
 
      ** Read next record
 
     C                   IF        PMode = 'A'
     C                   READ      APOSTPD                                01
     C                   ELSE
     C                   READ      EODPOPD                                01
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcDets - Process details before inserting record          *
      *                                                               *
      *****************************************************************
 
     C     SrProcDets    BEGSR
 
      ** Access branch details (LF/SDBRCHL5)
 
     C                   MOVE      CNUM          WKey
     C     WKey          CHAIN     SDBRCHL5
 
      ** If Account Export Indicator is 'A' or is 'C' and no record is
      ** found in access to LF/SDBRCHL5
 
     C                   IF        W1AEIN = 'A' OR
     C                             W1AEIN = 'C' AND NOT %FOUND(SDBRCHL5)
 
      ** Retrieve account code details
 
     C                   MOVEL     ACOD          PAcCod
     C                   EXSR      SrRtvACCO
 
 
      ** Populate the AML Account History Details
      ** ========================================
 
      ** Trans_ID
     C                   EVAL      X6TRID = *ZERO
 
      ** Acc_Num
     C                   MOVE      CNUM          WCNUM
     C                   MOVE      ACOD          WACOD
     C                   MOVE      ACSQ          WACSQ
     C                   EVAL      X6ACNO = BRCA + WCNUM + CCY +
     C                             WACOD + WACSQ
 
      ** Branch_Code
     C                   EVAL      X6BRCA = BRCA
 
      ** Acc_Type
     C                   MOVEL     ACOD          X6ATYP
 
      ** Midas_Account_Subtype
     C                   EVAL      X6MAST = A5ACST
 
      ** Midas_Account_Type
     C                   EVAL      X6MATP = ATYP
 
      ** Midas_Account_Section
     C                   EVAL      X6MASC = A5ACSC
 
      ** Trans_Date
     C                   CLEAR                   X6TRDT
     C                   IF        PSTD <> 0
     C                   MOVE      PSTD          PInDate
     C                   EXSR      SrCvtDate
     C                   EVAL      X6TRDT = PCvtdDate
     C                   ENDIF
 
      ** Trans_Type
     C                   EVAL      X6TRTP = *BLANKS
 
      ** Amount
     C                   EVAL      PInAmt = PSTA
     C                   EXSR      SrCvtAmt
     C                   EVAL      X6AMNT = POutAmt
     C                   IF        DRCR = 1
     C                   Z-SUB     X6AMNT        X6AMNT
     C                   ENDIF
 
      ** Midas_Movement_Ccy
     C                   EVAL      X6MMCY = W1ACCY
 
      ** Midas_Posting_Amount
     C                   EVAL      PNtvAmt = *BLANKS
     C                   EVAL      PNtvCcy = CCY
     C                   MOVE      PSTA          PNtvAmt
     C                   EXSR      SRFmtAmt
     C                   EVAL      X6MPAM = POutAmt
      *
     C                   IF        DRCR = 1
     C                   Z-SUB     X6MPAM        X6MPAM
     C                   ENDIF
 
      ** Midas_Posting_Ccy
     C                   EVAL      X6MPCY = CCY
 
      ** Classification
     C                   EVAL      X6CLAS = *BLANKS
 
      ** Worker_Code
     C                   EVAL      X6WKRC = *BLANKS
 
      ** Origin_Account
     C                   EVAL      X6OACT = *BLANKS
 
      ** Origin_Code
     C                   EVAL      X6OCDE = *BLANKS
 
      ** Checked_Mkr
     C                   EVAL      X6CMKR = 'N'
 
      ** Pay_Rec_Mkr
     C                   IF        SETDAT <= BJRDNB AND SETDAT <> 0
     C                   EVAL      X6PMKR = 'Y'
     C                   ELSE
     C                   EVAL      X6PMKR = 'N'
     C                   ENDIF
 
      ** Trans_Desc
     C                   EVAL      X6TDES = PNAR
 
      ** Orig_Country
     C                   EVAL      X6OCTY = *BLANKS
 
      ** Dest_Country
     C                   EVAL      X6DCTY = *BLANKS
 
      ** Dest_Account
     C                   EVAL      X6DACT = *BLANKS
 
      ** Stock_Ticker, Stock_Exchange and Stock_Quantity
     C                   IF        SPOS = '  GE-ST'
     C                   EVAL      X6STTK = TICKER
     C                   EVAL      X6STEX = EXCHNG
     C                   EVAL      X6STQT = NOMINL
     C                   ELSE
     C                   EVAL      X6STTK = *BLANKS
     C                   EVAL      X6STEX = *BLANKS
     C                   EVAL      X6STQT = *ZERO
     C                   ENDIF
 
      ** Fee_Percent
     C                   EVAL      X6FPER = FEEPCT
 
      ** Fee_Value
     C                   EVAL      PInAmt = FEEVAL
     C                   EXSR      SrCvtAmt
     C                   EVAL      X6FVAL = POutAmt
 
      ** Midas_Fee_Value
     C                   EVAL      PNtvAmt = *BLANKS
     C                   EVAL      PNtvCcy = CCY
     C                   MOVE      FEEVAL        PNtvAmt
     C                   EXSR      SRFmtAmt
     C                   EVAL      X6MFVL = POutAmt
 
      ** Orig_Bank
     C                   EVAL      X6OBNK = *BLANKS
 
      ** Dest_Bank
     C                   EVAL      X6DBNK = *BLANKS
 
      ** New_Acc_Ind
     C                   EVAL      X6NAIN = 'N'
 
      ** Settlement_Amount
     C                   EVAL      X6SAMT = *ZEROS
 
      ** Settlement_Date
     C                   CLEAR                   X6SDAT
     C                   IF        SPOS = '  GE-LE' AND SETDAT <> 0
     C                   MOVE      SETDAT        PInDate
     C                   EXSR      SrCvtDate
     C                   EVAL      X6SDAT = PCvtdDate
     C                   ENDIF
 
      ** Trade_Identifier
     C                   EVAL      X6MTID = *BLANKS
 
      ** Midas_Transaction_Type
     C                   EVAL      X6MTTP = *BLANKS
 
      ** Action
     C                   EVAL      X6ACTN = 'I'
 
      ** Start_Date
     C                   CLEAR                   X6STDT
 
      ** Loan_Principal
     C                   EVAL      X6OPRI = *ZEROS
 
 
      ** Process Trans_Type, Trade_Identifier and
      ** Midas_Transacation_Type
      ** (Note 1 of OD)
     C                   EXSR      SrDetail1
 
      ** Process Origin_Account, Origin_Code, Orig_Country,
      ** Dest_Country, Dest_Account, Orig_Bank and Dest_Bank
      ** (Note 2 of OD)
     C                   EXSR      SrDetail2
 
      ** Process Start_Date and Loan_Principal
      ** (Note 4 of OD)
     C                   EXSR      SrDetail3
 
      ** Write to AML Account History Details Import Table (SDAHISPD)
     C                   WRITE     SDAHISD0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDetail1 -  Process Trans_Type, Trade_Identifier and         *
      *              Midas_Transacation_Type                          *
      *                                                               *
      *****************************************************************
 
     C     SrDetail1     BEGSR
 
      ** Initialise work variables
 
     C                   EVAL      KDealType = *BLANKS
     C                   EVAL      KDealSType = *BLANKS
     C                   EVAL      X6MTID = *BLANKS
     C                   EVAL      WFld1 = *BLANKS
     C                   EVAL      WFld5 = *BLANKS
     C                   EVAL      WFld6 = *BLANKS
     C                   EVAL      WFld10 = *BLANKS
 
      ** Check if first 6 characters of SPOS are numberic
     C                   EVAL      WFld6 = %SUBST(SPOS:1:6)
     C     '0123456789'  CHECK     WFld6                                  02
 
     C/COPY WNCPYSRC,SDH00144
 
      ** Cases of Sources of Postings
      ** ============================
 
     C                   SELECT
 
      ** Batch Input Postings
     C                   WHEN      *IN02 = *OFF
     C                   EVAL      X6MTID = WFld6
 
      ** Dealing
     C                   WHEN      SPOS = '  GE-DL'
     C                   EVAL      KDealType = %SUBST(OTTP:1:2)
     C                   EVAL      KDealSType = %SUBST(OTST:1:2)
     C                   EVAL      WFld6 = %SUBST(OTRF:1:6)
     C                   EVAL      X6MTID = 'DL-' + WFld6
 
      ** Customer Lending
     C                   WHEN      SPOS = '  GE-LE'
     C                   MOVEL     OTRF          WFld1
 
     C                   IF        WFld1 = *BLANKS
     C                   MOVEL     CNUM          WFld6
     C                   EVAL      WFld5 = %SUBST(OTRF:2:5)
     C                   EVAL      X6MTID = 'LE-' + WFld6 + WFld5
     C                   ELSE
     C                   EVAL      KDealType = %SUBST(OTTP:1:2)
     C                   EVAL      KDealSType = %SUBST(OTST:1:2)
     C                   EVAL      WFld6 = %SUBST(OTRF:1:6)
     C                   EVAL      X6MTID = 'LE-' + WFld6
     C                   ENDIF
 
      ** Funds Transfer
     C                   WHEN      SPOS = '  GE-FT'
     C                   EVAL      KDealType = %SUBST(OTTP:1:2)
     C                   EVAL      KDealSType = %SUBST(OTST:1:2)
     C                   EVAL      X6MTID = 'FT-' + OTRF
 
      ** Securities Trading
     C                   WHEN      SPOS = '  GE-ST'
     C                   EVAL      KDealType = %SUBST(OTTP:9:2)
     C                   EVAL      WFld6 = %SUBST(OTRF:1:6)
 
     C                   SELECT
     C                   WHEN      WFld6 = '000000'
     C                   IF        KDealType <> *BLANKS
     C                   EVAL      X6MTID = 'ST-' + WFld6
     C                   ENDIF
 
     C                   WHEN      KDealType = 'TP' OR KDealType = 'TS'
     C                   EVAL      X6MTID = 'ST-' + WFld6
 
     C                   OTHER
     C                   EVAL      WFld10 = %SUBST(OTST:1:10)
     C                   EVAL      X6MTID = 'ST-' + WFld10 + WFld6
     C                   ENDSL
 
      ** Futures and Options
     C                   WHEN      SPOS = '  GE-FF'
     C                   EVAL      WFld6 = %SUBST(OTRF:1:6)
     C                   EVAL      X6MTID = 'FF-' + WFld6
 
      ** Retail Customer Exchanges
     C                   WHEN      SPOS = '  GE-CE'
     C                   EVAL      WFld6 = %SUBST(OTRF:1:6)
     C                   EVAL      X6MTID = 'CE-' + WFld6
 
      ** Retail Standing Orders
     C                   WHEN      SPOS = '  GE-SO'
     C                   EVAL      WFld6 = %SUBST(OTRF:1:5)
     C                   EVAL      X6MTID = 'SO-' + WFld6
 
      ** Sweep Processing
     C                   WHEN      SPOS = '  GE-SP'
     C                   EVAL      WFld6 = %SUBST(OTRF:1:6)
     C                   EVAL      X6MTID = 'SP-' + WFld6
 
      ** Amount Accruals
     C                   WHEN      SPOS = '  GE-AA'
     C                   EVAL      WFld6 = %SUBST(OTRF:1:6)
     C                   EVAL      X6MTID = 'AA-' + WFld6
 
      ** Teller Transaction
     C                   WHEN      SPOS = '  GE-TT'
     C                   EVAL      WFld9 = %SUBST(PNAR:7:9)
     C                   EVAL      X6MTID = 'TT-' + WFld9
 
      ** European Monetary Unit (EMU)
     C                   WHEN      SPOS = 'GE-GLEU'
     C                   EVAL      X6MTID = 'GLEU'
 
      ** Income and Expense
     C                   WHEN      SPOS = ' GE-IER'
     C                   EVAL      X6MTID = 'IER'
 
      ** Other possible source of postings
     C                   WHEN      SPOS = '  GE-FI' OR
     C                             SPOS = '  GE-HM' OR
     C                             SPOS = '  GE-MG' OR
     C                             SPOS = '  GE-NA' OR
     C                             SPOS = '  GE-SC' OR
     C                             SPOS = '  GE-FA' OR
     C                             SPOS = '  GE-SF' OR
     C                             SPOS = '  GE-IC' OR
     C                             SPOS = '  GE-PM' OR
     C                             SPOS = '  GE-FU' OR
     C                             SPOS = '  GE-FR' OR
     C                             SPOS = '  GE-SR' OR
     C                             SPOS = '  GE-XB' OR
     C                             SPOS = '  GE-XF' OR
     C                             SPOS = '  GE-PC'
     C                   EVAL      WFld2 = %SUBST(SPOS:6:2)
     C                   EVAL      X6MTID = WFld2
 
     C                   ENDSL
 
     ** Determine AML Transaction Type
     ** ==============================
 
     C                   EVAL      WRecFound = 'N'
 
     C                   IF        TRAT <> 0
     C                   MOVE      TRAT          KTRAT
     C     KTRAT         CHAIN     SDAMLML1
     C                   IF        %FOUND(SDAMLML1)
     C                   EVAL      WRecFound = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        TRAT = 0 OR
     C                             WRecFound = 'N'
     C     KAnMap        CHAIN     SDAMLML2
     C                   IF        %FOUND(SDAMLML2)
     C                   EVAL      WRecFound = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WRecFound = 'N'
     C                   EVAL      WDSTTmp = KDealStype
     C                   EVAL      KDealSType = '**'
     C     KAnMap        CHAIN     SDAMLML2
     C                   IF        %FOUND(SDAMLML2)
     C                   EVAL      WRecFound = 'Y'
     C                   ENDIF
     C                   EVAL      KDealSType = WDSTTmp
     C                   ENDIF
 
     C                   IF        WRecFound = 'Y'
     C                   EVAL      X6TRTP = W6AMLT
     C                   ELSE
     C                   EVAL      X6TRTP = *BLANKS
     C                   ENDIF
 
     ** Determine Midas Transaction Type
     ** ================================
 
     C                   IF        KDealType <> *BLANKS
     C                   EVAL      X6MTTP = KDealType + ' ' + KDealSType
     C                   ELSE
     C                   MOVE      TRAT          X6MTTP
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDetail2 -  Process Origin_Account, Origin_Code,             *
      *              Orig_Country, Dest_Country, Dest_Account,        *
      *              Orig_Bank and Dest_Bank                          *
      *                                                               *
      *****************************************************************
 
     C     SrDetail2     BEGSR
 
     C                   IF        ATYP = 'N' OR
     C                             ATYP = 'R'
 
     C                   SELECT
     C                   WHEN      SPOS = '  GE-DL' OR
     C                             SPOS = '  GE-LE' OR
     C                             SPOS = '  GE-FT' OR
     C                             SPOS = '  GE-ST' OR
     C                             SPOS = '  GE-FF'
     C                   IF        DRCR = 0 AND VOIN = 0 OR
     C                             DRCR = 1 AND VOIN = 1
     C                   EVAL      X6OACT = RORACT
     C                   EVAL      X6OCDE = RORCDE
     C                   EVAL      X6OCTY = RORCTY
     C                   EVAL      X6OBNK = RORBNK
     C                   EVAL      X6DACT = *BLANKS
     C                   EVAL      X6DCTY = *BLANKS
     C                   EVAL      X6DBNK = *BLANKS
     C                   ELSE
     C                   EVAL      X6OACT = PORACT
     C                   EVAL      X6OCDE = PORCDE
     C                   EVAL      X6OCTY = PORCTY
     C                   EVAL      X6OBNK = PORBNK
     C                   EVAL      X6DACT = DSTACT
     C                   EVAL      X6DCTY = DSTCTY
     C                   EVAL      X6DBNK = DSTBNK
     C                   ENDIF
 
     C                   WHEN      SPOS = '  GE-CE' OR
     C                             SPOS = '  GE-SO' OR
     C                             SPOS = '  GE-SP' OR
     C                             SPOS = '  GE-FA' OR
     C                             SPOS = '  GE-SF' OR
     C                             SPOS = '  GE-IC' OR
     C                             SPOS = '  GE-TT' OR
     C                             SPOS = '  GE-FU' OR
     C                             SPOS = '  GE-RC' OR
     C                             SPOS = '  GE-PM' OR
     C                             SPOS = '  GE-FI' OR
     C                             SPOS = '  GE-HM' OR
     C                             SPOS = '  GE-MG' OR
     C                             SPOS = '  GE-NA' OR
     C                             SPOS = '  GE-SC' OR
     C                             SPOS = '  GE-AA'
 
      ** Access Branch Details
     C                   MOVE      BRCA          PBRCA
     C                   EXSR      SrRtvBrch
 
     C                   IF        DRCR = 0
     C                   EVAL      POrdCust = CNUM
     C                   MOVE      A8BICN        PBenefit
     C                   ELSE
     C                   MOVE      A8BICN        POrdCust
     C                   EVAL      PBenefit = CNUM
     C                   ENDIF
 
      ** Call ZAAMLSETRE
     C                   CALL      'ZAAMLSETRE'
     C                   PARM                    POrdCust
     C                   PARM                    PBenefit
     C                   PARM                    WWRACT
     C                   PARM                    WWRCTY
     C                   PARM                    WWRBNK
     C                   PARM                    WWRCDE
     C                   PARM                    WWPACT
     C                   PARM                    WWPCTY
     C                   PARM                    WWPBNK
     C                   PARM                    WWPCDE
     C                   PARM                    WWDACT
     C                   PARM                    WWDCTY
     C                   PARM                    WWDBNK
 
     C                   IF        DRCR = 0
     C                   EVAL      X6OACT = WWRACT
     C                   EVAL      X6OCDE = WWRCDE
     C                   EVAL      X6OCTY = WWRCTY
     C                   EVAL      X6OBNK = WWRBNK
     C                   EVAL      X6DACT = *BLANKS
     C                   EVAL      X6DCTY = *BLANKS
     C                   EVAL      X6DBNK = *BLANKS
     C                   ELSE
     C                   EVAL      X6OACT = WWPACT
     C                   EVAL      X6OCDE = WWPCDE
     C                   EVAL      X6OCTY = WWPCTY
     C                   EVAL      X6OBNK = WWPBNK
     C                   EVAL      X6DACT = WWDACT
     C                   EVAL      X6DCTY = WWDCTY
     C                   EVAL      X6DBNK = WWDBNK
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDetail3 - Process Start_Date and Loan_Principal             *
      *                                                               *
      *****************************************************************
 
     C     SrDetail3     BEGSR
 
      ** Customer Lending
     C                   IF        SPOS = '  GE-LE'
     C                   MOVEL     OTRF          WFld1
 
      ** Loan related
     C                   IF        WFld1 <> *BLANKS
     C                   EVAL      WFld6 = %SUBST(OTRF:1:6)
     C                   MOVE      WFld6         KTRef
     C                   EVAL      KRcdT = 'A'
 
     C     KLoan         CHAIN     CLOAN
     C                   IF        %FOUND(CLOAN)
     C                   MOVE      VDAT          PInDate
     C                   EXSR      SrCvtDate
     C                   EVAL      X6STDT = PCvtdDate
     C                   EVAL      KRcdT = 'B'
 
     C     KLoan         CHAIN     CLOAN
     C                   IF        %FOUND(CLOAN)
     C                   EVAL      PInAmt = OPAM
     C                   EXSR      SrCvtAmt
     C                   EVAL      X6OPRI = POutAmt
 
      ** Issue database error if chain fails
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = WFld6
     C                   EVAL      DBFILE = 'CLOAN'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
 
     C     KLoan         CHAIN     MLOAN
     C                   IF        %FOUND(MLOAN)
     C                   MOVE      VDAT          PInDate
     C                   EXSR      SrCvtDate
     C                   EVAL      X6STDT = PCvtdDate
     C                   EVAL      KRcdT = 'B'
 
     C     KLoan         CHAIN     MLOAN
     C                   IF        %FOUND(MLOAN)
     C                   EVAL      PInAmt = OPAM
     C                   EXSR      SrCvtAmt
     C                   EVAL      X6OPRI = POutAmt
 
      ** Issue database error if chain fails
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = WFld6
     C                   EVAL      DBFILE = 'MLOAN'
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C                   CLEAR                   X6STDT
     C                   EVAL      X6OPRI = *ZEROS
     C                   ENDIF
     C                   ENDIF
 
      ** Facility related
     C                   ELSE
     C                   CLEAR                   X6STDT
     C                   EVAL      X6OPRI = *ZEROS
     C                   ENDIF
 
      ** Other Source of Postings
     C                   ELSE
     C                   CLEAR                   X6STDT
     C                   EVAL      X6OPRI = *ZEROS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRtvACCO - Retrieve Account Code Details File                *
      *                                                               *
      *****************************************************************
 
     C     SrRtvACCO     BEGSR
 
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PAcCod
     C     SDACOD        PARM      SDACOD        DSSDY
 
      ** If no record is found, issue database error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PAcCod
     C                   EVAL      DBFILE = 'SDACODPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRtvBrch - Access Branch Details                             *
      *                                                               *
      *****************************************************************
 
     C     SrRtvBrch     BEGSR
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBRCA
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRtvCWCD - Retrieve Compliance Watch Configuration Data      *
      *             File                                              *
      *                                                               *
      *****************************************************************
 
     C     SrRtvCWCD     BEGSR
 
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
      ** If no return code is not blank, issue database error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDCWCDPD'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRtvCurr - Access Currency Details                           *
      *                                                               *
      *****************************************************************
 
     C     SrRtvCurr     BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCcyCde
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** If no return code is not blank, issue database error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCcyCde
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCvtDate - Convert dates                                     *
      *                                                               *
      *****************************************************************
     C     SrCvtDate     BEGSR
 
     C                   CALLB     'ZACVTDATE'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    PInDate
     C                   PARM                    POutDate
     C                   PARM                    PCvtdDate
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrCvtAmt - Convert amounts                                    *
      *                                                               *
      *****************************************************************
     C     SrCvtAmt      BEGSR
 
      ** Set 'From' Currency ('To' details were set on SR/*INZSR).
 
     C                   EVAL      PFrCcy = CCY
 
      ** Access 'From' Currency Details.
 
     C                   EVAL      PCcyCde = PFrCcy
     C                   EXSR      SrRtvCurr
     C                   EVAL      PFrSRt = A6SPRT
     C                   EVAL      PFrMDI = A6MDIN
     C                   EVAL      PFrNDP = A6NBDP
 
      ** Get the Input Amount equivalent in 'To' Currency.
 
     C                   CALLB     'ZCCYCN'
     C                   PARM                    PInAmt
     C                   PARM                    PFrCcy
     C                   PARM                    PToCcy
     C                   PARM                    PFrSRt
     C                   PARM                    PToSRt
     C                   PARM                    PFrMDI
     C                   PARM                    PToMDI
     C                   PARM                    PFrNDP
     C                   PARM                    PToNDP
     C                   PARM                    PToAmt
     C                   PARM                    PCXRt
     C                   PARM                    PCMDI
 
      ** PToAmt is in monetary storage format so lets call ZACVTAMT
      ** to get its numerical value.
 
     C                   EVAL      PNtvAmt = *BLANKS
     C                   EVAL      PNtvCcy = PtoCcy
     C                   MOVE      PToAmt        PNtvAmt
     C                   EXSR      SRFmtAmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SRFMTAMT - Formats amounts from 0 dec to 18,3                 *
      *                                                               *
      *****************************************************************
 
     C     SRFmtAmt      BEGSR
 
     C                   CALLB     'ZACVTAMT'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    PNtvCcy
     C                   PARM                    PNtvAmt
     C                   PARM                    POutAmt
     C                   PARM                    PCvtAmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
 
      ** Access Bank Details to retrieve Midas rundate
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST  '    POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If no return code is not blank, issue database error
 
     C                   IF        PRetCode <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,SDH00145
 
      ** Access the Compliance Watch Configuration data file (SDCWCDPD)
 
     C                   EXSR      SrRtvCWCD
 
      ** Access 'To' Currency Details (used by SR/SrCvtAmt).
 
     C                   EVAL      PToCcy = W1ACCY
 
     C                   EVAL      PCcyCde = PToCcy
     C                   EXSR      SrRtvCurr
     C                   EVAL      PToSRt = A6SPRT
     C                   EVAL      PToMDI = A6MDIN
     C                   EVAL      PToNDP = A6NBDP
 
      ** KLIST for LF/CLOAN and LF/MLOAN
 
     C     KLoan         KLIST
     C                   KFLD                    KTRef
     C                   KFLD                    KRcdT
 
      ** KLIST for LF/SDAMLML2
 
     C     KAnMap        KLIST
     C                   KFLD                    KDealType
     C                   KFLD                    KDealSType
 
     C                   ENDSR
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2002
