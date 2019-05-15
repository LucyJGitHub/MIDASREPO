     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL MT942 File Extract')                          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001421 - Midas GL MT942 File Extract                       *
      *                                                               *
      *  Function: This program extracts data from Posting file to    *
      *            MGx942PD                                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR787620           Date 10Jun11               *
      *                 CRE075             Date 06Dec10               *
      *                 AR676213           Date 19Nov10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26608           Date 17Nov09               *
      *                 BUG23742           Date 26May09               *
      *                 BUG23284           Date 13Mar09               *
      *                 BUG22687           Date 06Feb09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 216937             Date 28Apr03               *
      *                 CRE008             Date 23May02               *
      *                 CGL013  *CREATE    Date 31Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,GLH00170                                 *
      *             WNCPYSRC,GLH00171                                 *
      *             WNCPYSRC,GLH00172                                 *
      *             WNCPYSRC,GLH00173                                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *             (Child: AR676229)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26608 - External Extract Program not called for other     *
      *             networks                                          *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input (Recompile)                       *
      *  BUG23284 - Wrong Field 61 subfield 6 for SWIFT               *
      *  BUG22687 - Various error on MT94x generation                 *
      *  CER030 - Multicash German Feature                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216937 - If GA account, include source account (recompile)   *
      *  CRE008 - Cash Management                                     *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
 
     FGLNW94L5  UF   E           K DISK    COMMIT         INFSR(*PSSR)
      ** Midas GL Network Accounts - MT94x - Live/Accnt+Dst.
 
     FGLPOSTL0  UF   E           K DISK    COMMIT         INFSR(*PSSR)
     F                                     PREFIX(GL)
      ** Midas GL Posting sorted by Network Account, Message Type, destination.
 
     FGLNWKAPD  IF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL Network Activity Control File.
                                                                                              CRE008
     FREGAHLJ2  IF   E           K DISK                   INFSR(*PSSR)                        CRE008
      ** Midas RE Group Account Hierarchy Links                                               CRE008
 
     FMGF942PD  O    E             DISK    COMMIT         INFSR(*PSSR)
      ** Midas MG MT942 Generation Extract - Account Detail.
 
     FMGX942PD  O    E             DISK    COMMIT         INFSR(*PSSR)
      ** Midas MG MT942 Generation Extract - Posting Detail.
 
     FGL001421AUO    E             PRINTER USROPN         INFSR(*PSSR)
      ** Midas GL MT942 File Extract - Audit Report.
 
      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access Network Account (LF/GLNW94L5)                              *
      * 28 - Access Postings        (LF/GLPOSTL0)                              *
      * 29 - Access Group Account   (LF/REGAHLJ2)                              *              CRE008
      * 40 - General Error                                                     *
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*
 
      *========================================================================*
      ** Automatically included D-specs
      ** ==============================
 
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Manually included D-specs
      ** =========================
 
      ** Named constants
      ** ---------------
 
      ** Arrays and Data Structures
      ** --------------------------
 
     D GLMR94        E DS                  EXTNAME(GLMR94PD)
      **  Data Structure for GL MT941/942 Messages Requests.
 
     D GLposting     E DS                  EXTNAME(GLPOSTPD) PREFIX(GL)
      **  Data Structure for Posting detail in General Ledger format.
     D   EXMGADI1    E                     EXTFLD(MGADI1)                       Additional Inf 1
     D   EXMGADI2    E                     EXTFLD(MGADI2)                       Additional Inf 2
     D   EXMGADI3    E                     EXTFLD(MGADI3)                       Additional Inf 3
     D   EXMGADI4    E                     EXTFLD(MGADI4)                       Additional Inf 4
     D   EXMGADI5    E                     EXTFLD(MGADI5)                       Additional Inf 5
     D   EXMGADI6    E                     EXTFLD(MGADI6)                       Additional Inf 6
     D   EXMGAERI    E                     EXTFLD(MGAERI)                       ERI Indicator
 
     D MGposting     E DS                  EXTNAME(MGX940PD)
      **  Data Structure for Posting detail in Message Genration Format.
     D QQACD1        E                     EXTFLD(QQACCD)                                     CGL029
     D/COPY WNCPYSRC,GLH00381
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data Structure for Bank Details.
 
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      **  Data Structure for Network Details.
 
     D GLACCNT       E DS                  EXTNAME(ACCNTAB)
      **  Data Structure for Account Details.
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  Data Structure for Customer Details.
                                                                                              CRE008
     D SDCMAN        E DS                  EXTNAME(SDCMANPD)                                  CRE008
      ** External DS for cash management details                                              CRE008
                                                                                              CRE008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE008
     D                                     PREFIX(X_)                                         CRE008
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  First DS for access programs, long data structure.
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, short data structure.
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      **  Third DS for access programs, very long data structure.
 
      ** Define an array for the non generated messages number
      ** contained in the DsCUST data structure
      *
     D  BBNGEN         S              3A   DIM(15)
     D                                     BASED(Pointer1)
     D  Pointer1       S               *   INZ(%Addr(BBNG01))
 
      ** Declared variables
      ** ------------------
 
     D MsgGenDate      S              5  0                                      Msg Generation Date
     D MsgGenTime      S              6  0                                      Msg Generation Time
 
     D KeyNWRK         S                   LIKE(N4NWRK)                         Network
     D KeyBRCA         S                   LIKE(N4BRCA)                         Branch Code - Alpha
     D KeyCNUM         S                   LIKE(N4CNUM)                         Customer number
     D KeyCCY          S                   LIKE(N4CCY)                          Currency code
     D KeyACOD         S                   LIKE(N4ACCD)                         Account code
     D KeyACSQ         S                   LIKE(N4ACSQ)                         Account sequence num
     D KeyNATY         S                   LIKE(N4NATY)                         Network Account Type
     D KeyDSTN         S                   LIKE(N4DSTN)                         Destination
     D KeyMTPY         S                   LIKE(GLMGMTPY)                       Message Type
 
     D P@RTCD          S              7A                                        Return Code
     D P@SARD          S              6A                                        Sar           CRE008
     D P@OPTN          S              7A                                        Option
     D P@RETL          S             10A                                        Retail Number
     D P@CNUM          S              6A                                        Customer
     D P@CUCD          S              3A                                        Currency
     D*P@ACCD***       S              4A                                        Account code  CGL029
     D P@ACCD          S             10A                                                      CGL029
     D P@ACSQ          S              2A                                        Account Sequence
     D P@BRCA          S              3A                                        Branch Code
     D P@NWRK          S              6A                                        Network
     D P@KEY1          S             10A                                        Customer
     D P@KYST          S              7A                                        Key Status
 
     D CRE008          S              1A                                                      CRE008
     D WkDebitAmn      S             15P 0                                      Debit Amount
     D WkNbDebit       S             10U 0                                      Nb of Debit
     D WkCredtAmn      S             15P 0                                      Credit Amount
     D WkNbCredt       S             10U 0                                      Nb of Credit
 
     D WkErrRpt        S              1A   INZ('N')                             Error Reported
     D X               S              5U 0                                      Working Index
      *                                                                                       CER030
      ** Parameters for EDEXET program                                                        CER030
      *                                                                                       CER030
     D*PRtcd****       S              7A                                             CER030 BUG22687
     D PRtcd           S             10A                                                    BUG22687
     D PMsgTyp         S              3A                                                      CER030
      *                                                                                       CER030
     D/COPY WNCPYSRC,GLH00170
 
      ** Input Specs
      ** -----------
 
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode                     Return code
     C                   PARM                    GLMR94                         Message Request
     C                   PARM                    MsgGenDate                     Msg Generation Date
     C                   PARM                    MsgGenTime                     Msg Generation Time
 
      ** Initialize working fields.
 
     C                   EXSR      $InitWkFld
 
     C                   DO
 
      ** Check if the network is active
 
     C                   EXSR      $ChkNwrk
 
     C   40              LEAVE
 
      ** Retrieve Network Account details.
 
     C                   EXSR      $RtvNwrkAc
 
     C   40              LEAVE
 
      ** Retrieve Account Details.
 
     C                   EXSR      $RtvAccnt
 
     C   40              LEAVE
 
      ** Check if the customer allows MT942 generation.
 
     C                   EXSR      $ChkCust
 
     C   40              LEAVE
 
      ** Process Posting Details
 
     C                   EXSR      $MGX942PD
 
     C   40              LEAVE
 
      ** Check if the MT942 should be generated even there is no movement
 
     C                   IF        N42GNM = 'N'                                 gen. even no mvnts
     C                             AND WkNbDebit = *ZEROS                       Nb of Debit
     C                             AND WkNbCredt = *ZEROS                       Nb of Credit
 
     C                   EVAL      ReturnCode = 'NO MOVT'
 
     C                   ELSE
 
      ** Process Account Details
 
     C                   EXSR      $MGF942PD
 
     C   40              LEAVE
 
      ** Update Network Account details.
 
     C                   EXSR      $GLNW94PD
 
     C   40              LEAVE
 
     C                   ENDIF
 
     C                   ENDDO
 
     C   40              ROLBK
 
      ** End of processing
     C/COPY WNCPYSRC,GLH00382
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *========================================================================*
      * $InitWkFld: Initialize working fields.                                 *
      *------------------------------------------------------------------------*
 
     C     $InitWkFld    BEGSR
      *    ----------    -----
 
     C                   EVAL      ReturnCode = *Blanks                         Return code
     C                   EVAL      MsgGenDate = *ZEROS                          Msg Generation Date
     C                   EVAL      MsgGenTime = *ZEROS                          Msg Generation Time
 
     C                   EVAL      *IN40 = *OFF                                 General Indicator
 
     C                   EVAL      WkDebitAmn = *ZEROS                          Debit Amount
     C                   EVAL      WkNbDebit  = *ZEROS                          Nb of Debit
     C                   EVAL      WkCredtAmn = *ZEROS                          Credit Amount
     C                   EVAL      WkNbCredt  = *ZEROS                          Nb of Credit
 
      ** Load key fields
 
     C                   EVAL      KeyNWRK = MRNWRK                             Network
     C                   EVAL      KeyBRCA = MRBRCA                             Branch
     C                   EVAL      KeyCNUM = MRCNUM                             Customer
     C                   EVAL      KeyCCY  = MRCCY                              Currency
     C                   EVAL      KeyACOD = MRACCD                             Account Code
     C                   EVAL      KeyACSQ = MRACSQ                             Account Sequence
     C                   EVAL      KeyNATY = MRNATY                             Net. Account Type
     C                   EVAL      KeyDSTN = MRDSTN                             Destination
     C                   EVAL      KeyMTPY = MRMTPY                             Message Type
 
     C     @InitWkFld    ENDSR
      *    --------      -----
 
      *========================================================================*
      * $ChkNwrk: Check if the Network is active.                              *
      *------------------------------------------------------------------------*
 
     C     $ChkNwrk      BEGSR
      *    --------      -----
 
      **  Check if the Network exists.
 
     C                   CALLB     'AONWRKR1'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      MRNWRK        P@NWRK                         Network
     C     SDNWRK        PARM      SDNWRK        DSLDY
 
      ** Add the issue on the audit report.
 
     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Network ' + %TRIM(MRNWRK) +
     C                                      ' does not exist'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @ChkNwrk
     C                   ENDIF
 
      **  Check if the Network authorizes MT942.
 
     C                   IF        EDM942 <> 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Network ' + %TRIM(MRNWRK) +
     C                                      ' does not authorize MT942'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @ChkNwrk
     C                   ENDIF
 
      **  Check if the network is active.
 
     C     MRNWRK        CHAIN     GLNWKAPD                           99
 
     C                   IF        *IN99
     C                             OR NOT *IN99 AND MTSSTS <> 'A'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Network ' + %TRIM(MRNWRK) + ' is +
     C                                       not active'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @ChkNwrk
     C                   ENDIF
 
      *    ---------     -----
     C     @ChkNwrk      ENDSR
 
      *========================================================================*
      * $RtvNwrkAc: Retrieve Network Account Details.                          *
      *------------------------------------------------------------------------*
 
     C     $RtvNwrkAc    BEGSR
      *    ----------    -----
 
     C     KeyNwrkAc     CHAIN     GLNW94L5                           27
     C                   IF        *IN27
     C                             OR N4G942 <> 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Network Account for MT942 not +
     C                                       found'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   ENDIF
 
     C     @RtvNwrkAc    ENDSR
      *    ----------    -----
 
      *========================================================================*
      * $RtvAccnt: Retrieve Account details.                                   *
      *------------------------------------------------------------------------*
 
     C     $RtvAccnt     BEGSR
      *    ---------     -----
 
     C                   MOVE      MRCNUM        P@CNUM                         Customer
     C                   MOVE      MRACCD        P@ACCD                         Account code
     C                   MOVE      MRACSQ        P@ACSQ                         Account Sequence
 
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      *BLANKS       P@RETL                         Retail Number
     C                   PARM                    P@CNUM                         Customer
     C                   PARM      MRCCY         P@CUCD                         Currency
     C                   PARM                    P@ACCD                         Account code
     C                   PARM                    P@ACSQ                         Account Sequence
     C                   PARM      MRBRCA        P@BRCA                         Branch Code
     C     GLACCNT       PARM      GLACCNT       DSSDY
 
      ** Add the issue on the audit report.
 
     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Midas Account Detail not found'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   ENDIF
 
      *    ---------     -----
     C     @RtvAccnt     ENDSR
 
      *========================================================================*
      * $ChkCust: Check if the customer allows MT942 generation.               *
      *------------------------------------------------------------------------*
 
     C     $ChkCust      BEGSR
      *    --------      -----
 
     C                   MOVEL(P)  MRCNUM        P@KEY1                         Customer
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM                    P@KEY1                         Customer
     C                   PARM                    P@KYST                         Key Status
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Add the issue on the audit report.
 
     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Customer ' + %TRIM(P@KEY1) +
     C                                      ' not found'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @ChkCust
     C                   ENDIF
 
      ** Add the issue on the audit report.
 
     C     '942'         LOOKUP    BBNGEN                                 99
     C                   IF        *IN99
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Customer ' + %TRIM(P@KEY1) +
     C                                      ' does not allow MT942 generation'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   ENDIF
 
      *    ---------     -----
     C     @ChkCust      ENDSR
 
      *========================================================================*
      * $MGX942PD: Extract Posting Details                                     *
      *------------------------------------------------------------------------*
 
     C     $MGX942PD     BEGSR
      *    ---------     -----
 
      ** Read Postings for this Network Account.
 
     C     KeyPost       SETLL     GLPOSTD0
     C     KeyPost       READE     GLPOSTD0                               28
 
     C                   DOW       NOT *IN28 AND NOT *IN40
 
      ** Report only movements with a value date less or equal to the run date,
      ** and not yet flagged as processed.
 
     C                   IF        GLMGPROC <> 'Y'
 
      ** Calculate the Debit and Credit details
 
     C                   IF        GLDRCR = 0                                   Debit
     C                   EVAL      WkNbDebit = WkNbDebit + 1                    Nb of Debit
     C                   EVAL      WkDebitAmn = WkDebitAmn + GLPSTA             Debit Amount
     C                   ELSE                                                   Credit
     C                   EVAL      WkNbCredt = WkNbCredt + 1                    Nb of Credit
     C                   EVAL      WkCredtAmn = WkCredtAmn + GLPSTA             Credit Amount
     C                   ENDIF
 
      ** Report posting detail if the posting amount is equal to or greater than floor limit.
 
     C                   IF        GLDRCR = 0                                   Debit
     C                             AND GLPSTA >= MR2FLD                         Floor Limit Debit
     C                             OR GLDRCR = 1                                Credit
     C                             AND GLPSTA >= MR2FLC                         Floor Limit Credit
 
      ** If Extended narrative is allowed for the Network.
 
     C                   IF        EDENRA = 'Y'
     C                   EVAL      EXMGADI1 =  GLMGADI1                         Additional Inf 1
     C                   EVAL      EXMGADI2 =  GLMGADI2                         Additional Inf 2
     C                   EVAL      EXMGADI3 =  GLMGADI3                         Additional Inf 3
     C                   EVAL      EXMGADI4 =  GLMGADI4                         Additional Inf 4
     C                   EVAL      EXMGADI5 =  GLMGADI5                         Additional Inf 5
     C                   EVAL      EXMGADI6 =  GLMGADI6                         Additional Inf 6
     C                   EVAL      EXMGAERI =  GLMGAERI                         ERI Indicator
     C                   ELSE
     C                   EVAL      EXMGADI1 =  *BLANKS                          Additional Inf 1
     C                   EVAL      EXMGADI2 =  *BLANKS                          Additional Inf 2
     C                   EVAL      EXMGADI3 =  *BLANKS                          Additional Inf 3
     C                   EVAL      EXMGADI4 =  *BLANKS                          Additional Inf 4
     C                   EVAL      EXMGADI5 =  *BLANKS                          Additional Inf 5
     C                   EVAL      EXMGADI6 =  *BLANKS                          Additional Inf 6
     C                   EVAL      EXMGAERI =  *BLANKS                          ERI Indicator
     C                   ENDIF
 
      ** Format the posting details
 
     C                   CALLB     'GL001432'                           99
     C                   PARM      *BLANKS       ReturnCode                     Return Code
     C                   PARM                    GLPosting                      GL Posting Detail
     C                   PARM      *BLANKS       MGPosting                      MG Posting Detail
 
     C                   IF        ReturnCode = 'PSSR_ERROR'
     C                             OR *IN99 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,GLH00383
      *                                                                                       CER030
     C                   EVAL      MGTRAT = *ZEROS                                            CER030
     C                   EVAL      PRtcd = *BLANKS                                            CER030
     C                   EVAL      *IN99 = *OFF                                               CER030
      *                                                                                       CER030
     C**********         IF        EDMCNW = 'Y' AND                                  CER030 BUG23284
     C**********         IF        (EDMCNW = 'Y' OR MGNWRK ='SWIFT') AND           BUG23284 BUG26608
     C**********                   (EDEXET <> *BLANKS AND                            CER030 BUG26608
     C                   IF        (EDEXET <> *BLANKS AND                                   BUG26608
     C                             EDEXET <> '*NONE')                                         CER030
     C                   EVAL      PMsgTyp = '942'                                            CER030
      *                                                                                       CER030
     C                   CALL      EDEXET                               99                    CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM                    PMsgTyp                                      CER030
     C                   PARM                    GLPosting                                    CER030
     C                   PARM                    MGPosting                                    CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      *                                                                                       CER030
     C                   IF        PRtcd = 'PSSR_ERROR'                                       CER030
     C                             OR *IN99 = *ON                                             CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
 
     C/COPY WNCPYSRC,GLH00171
     C                   IF        ReturnCode = *BLANKS
     C                             AND PRtcd = *BLANKS                                        CER030
     C/COPY WNCPYSRC,GLH00172
 
      ** Add record in MT942 Generation Extract - Posting Detail
 
     C                   WRITE     MGX942D0
 
     C                   ELSE
 
      ** Add the issue on the audit report.
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Posting extract failed'
     C                   DUMP
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @MGX942PD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   SELECT
 
      ** Re-extract postings from last statement
 
     C                   WHEN      GLRECI = 'P'                                 Posting
     C                             AND N42RPL <> 'Y'                            Re-extract flag
     C                   EVAL      GLMGPROC = 'Y'                               Flagged as Processed
 
      ** Re-extract shadow posting
 
     C                   WHEN      GLRECI = 'S'                                 Shadow Posting
     C                             AND N42RAS <> 'Y'                            Re-extract flag
     C                   EVAL      GLMGPROC = 'Y'                               Flagged as Processed
     C                   ENDSL
 
     C                   UPDATE    GLPOSTD0
 
     C                   ENDIF
 
      ** Read Next Posting for this Network Account.
 
     C     KeyPost       READE     GLPOSTD0                               28
 
     C                   ENDDO
 
      *    ---------     -----
     C     @MGX942PD     ENDSR
 
      *========================================================================*
      * $MGF942PD: Extract Account Details                                     *
      *------------------------------------------------------------------------*
 
     C     $MGF942PD     BEGSR
      *    ---------     -----
 
     C                   CLEAR                   MGF942D0
 
     C                   EVAL      MGNWRK = MRNWRK                              Network
     C                   EVAL      MGBRCA = MRBRCA                              Branch Code - Alpha
     C                   EVAL      MGCNUM = MRCNUM                              Customer number
     C                   EVAL      MGCCY  = MRCCY                               Currency code
     C                   EVAL      MGACCD = MRACCD                              Account code
     C                   EVAL      MGACSQ = MRACSQ                              Account sequence num
     C                   EVAL      MGNATY = MRNATY                              Network Account Type
     C                   EVAL      MGDSTN = MRDSTN                              Destination
     C                   SELECT                                                 Msg Creation Status
     C                   WHEN      MRSORQ = 'MT920'                             Request from MT920
     C                   EVAL      MGDMST = ED2SER                              External Request Def
     C                   EVAL      MGIMIR = MRIMIR                              Incoming MIR
     C                   WHEN      MRSORQ = 'MANUAL'                            Manual Request
     C                   EVAL      MGDMST = ED2SMR                              Manual Request Def.
     C                   OTHER                                                  Scheduled request
     C                   EVAL      MGDMST = ED2SGS                              External Request Def
     C                   ENDSL
     C                   EVAL      MGRREF = MRRREF                              Related Reference Nb
     C                   EVAL      MGRNWK = MRRNWK                              Requested Network
     C                   EVAL      MGACNO = ACNO                                Retail account numbe
     C                   EVAL      MGIBAN = IBAN                                IBAN
     C                   EVAL      MGFL25 = MRFL25                              MT920 Account Id.
      *                                                                                       CRE008
      *  If Cash Management feature is installed and the account is                           CRE008
      *  a part of a group account hierarchy, use group account narrative                     CRE008
      *  instead                                                                              CRE008
     C                   IF        CRE008 = 'Y'                                               CRE008
     C     KeyAcntBl     Chain     REGAHLJ2                           29                      CRE008
     C                   Endif                                                                CRE008
      *                                                                                       CRE008
     C                   SELECT
     C                   WHEN      CRE008 = 'Y' And                                           CRE008
     C                             *IN29 = *OFF                                               CRE008
     C                   EVAL      MGMIO1 = CMTXTG                                            CRE008
     C                   EVAL      MGMIO2 = %subst(CMTXTG:66:65)                              CRE008
     C                   EVAL      MGMIO3 = %subst(CMTXTG:131:65)                             CRE008
     C                   EVAL      MGMIO4 = %subst(CMTXTG:196:5)                              CRE008
     C                   EVAL      MGMIO5 = *blanks                                           CRE008
     C                   EVAL      MGMIO6 = *blanks                                           CRE008
     C                   WHEN      MRSORQ = 'MANUAL'                            Manual Requests
     C                   EVAL      MGMIO1 = MRMIO1                              Manual Prod Msg leve
     C                   EVAL      MGMIO2 = MRMIO2                              Manual Prod Msg leve
     C                   EVAL      MGMIO3 = MRMIO3                              Manual Prod Msg leve
     C                   EVAL      MGMIO4 = MRMIO4                              Manual Prod Msg leve
     C                   EVAL      MGMIO5 = MRMIO5                              Manual Prod Msg leve
     C                   EVAL      MGMIO6 = MRMIO6                              Manual Prod Msg leve
     C                   OTHER                                                  Other requests
     C                   EVAL      MGMIO1 = N42MI1                              Default MT942 messag
     C                   EVAL      MGMIO2 = N42MI2                              Default MT942 messag
     C                   EVAL      MGMIO3 = N42MI3                              Default MT942 messag
     C                   EVAL      MGMIO4 = N42MI4                              Default MT942 messag
     C                   EVAL      MGMIO5 = N42MI5                              Default MT942 messag
     C                   EVAL      MGMIO6 = N42MI6                              Default MT942 messag
     C                   ENDSL
     C                   EVAL      MGSTNO = N42LSP + 1                          Last Statement Page
     C                   EVAL      MGDFLM = MR2FLD                              Debit Floor Limit
     C                   EVAL      MGCFLM = MR2FLC                              Credit Floor Limit
     C                   EVAL      MGNBDB = WkNbDebit                           Number of Debit Post
     C                   EVAL      MGSMDB = WkDebitAmn                          Sum of Debit Posting
     C                   EVAL      MGNBCR = WkNbCredt                           Number of Credit Pos
     C                   EVAL      MGSMCR = WkCredtAmn                          Sum of Crebit Postin
 
     C                   WRITE     MGF942D0
 
      *    ---------     -----
     C     @MGF942PD     ENDSR
 
      *========================================================================*
      * $GLNW94PD: Update Network Account details.                             *
      *------------------------------------------------------------------------*
 
     C     $GLNW94PD     BEGSR
      *    ---------     -----
 
      ** Process MT942 Details.
 
     C                   EVAL      N42LSP = N42LSP + 1                          Last Statement Page
     C                   EVAL      N42LSD = BJRDNB                              Last Statement Date
     C                   TIME                    N42LST                         Last Statement Time
     C                   EVAL      N42LDN = WkNbDebit                           Number of Debit Post
     C                   EVAL      N42LDA = WkDebitAmn                          Sum of Debit Posting
     C                   EVAL      N42LCN = WkNbCredt                           Number of Credit Pos
     C                   EVAL      N42LCA = WkCredtAmn                          Sum of Crebit Postin
 
     C                   UPDATE    GLNW94D0
 
     C                   EVAL      MsgGenDate = N42LSD                          Msg Generation Date
     C                   EVAL      MsgGenTime = N42LST                          Msg Generation Time
 
      *    ---------     -----
     C     @GLNW94PD     ENDSR
 
      *========================================================================*
      * $AuditRpt: Report issues                                               *
      *------------------------------------------------------------------------*
 
     C     $AuditRpt     BEGSR
      *    ---------     -----
 
     C                   OPEN      GL001421AU
     C                   WRITE     HEADAU
     C                   WRITE     SUBTL
     C                   WRITE     DETAIL
     C                   WRITE     ENDRPT
     C                   CLOSE     GL001421AU
 
     C                   EVAL      ReturnCode = 'ERROR'
     C                   EVAL      WkErrRpt = 'Y'                               Error Reported
 
      *    ---------     -----
     C     @AuditRpt     ENDSR
 
      *========================================================================*
      * *INSZR: Initial Sub-routine                                            *
      *------------------------------------------------------------------------*
 
     C     *INZSR        BEGSR
      *    ------        -----
 
      ** Initialise Copyright Array
 
     C                   MOVEA     CPY@          CPY@@            80
 
      ** Initialise LDA.
 
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBpgm
     C                   OUT       LDA
 
      ** Retrieve Bank details.
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDBANK        PARM      SDBANK        DSFDY
                                                                                              CRE008
      ** Check if feature CRE008 (Cash Management feature) is installed                       CRE008
                                                                                              CRE008
     C                   EVAL      CRE008 = 'N'                                               CRE008
                                                                                              CRE008
     C                   CALLB     'AOSARDR0'                                                 CRE008
     C                   PARM      *BLANKS       P@RTCD                         Return Code   CRE008
     C                   PARM      '*VERIFY'     P@OPTN                         Option        CRE008
     C                   PARM      'CRE008 '     P@SARD                         Feature Ref.  CRE008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE008
                                                                                              CRE008
     C                   IF        P@RTCD = *BLANKS                                           CRE008
     C                   EVAL      CRE008 = 'Y'                                               CRE008
                                                                                              CRE008
      *  Access Cash Management ICD                                                           CRE008
     C                   CALLB     'AOCMANR0'                                                 CRE008
     C                   PARM      *BLANKS       P@RTCD                                       CRE008
     C                   PARM      '*FIRST  '    P@OPTN                                       CRE008
     C     SDCMAN        PARM      SDCMAN        DSSDY                                        CRE008
                                                                                              CRE008
     C                   ENDIF                                                                CRE008
     C/COPY WNCPYSRC,GLH00384
 
      ** Key to access Network Account.
 
     C     KeyNwrkAc     KLIST
     C                   KFLD                    KeyNWRK                        Network
     C                   KFLD                    KeyBRCA                        Branch Code - Alpha
     C                   KFLD                    KeyCNUM                        Customer number
     C                   KFLD                    KeyCCY                         Currency code
     C                   KFLD                    KeyACOD                        Account code
     C                   KFLD                    KeyACSQ                        Account sequence num
     C                   KFLD                    KeyNATY                        Network Account Type
     C                   KFLD                    KeyDSTN                        Destination
 
      ** Key to access Posting details.
 
     C     KeyPost       KLIST
     C                   KFLD                    KeyNWRK                        Network
     C                   KFLD                    KeyBRCA                        Branch Code - Alpha
     C                   KFLD                    KeyCNUM                        Customer number
     C                   KFLD                    KeyCCY                         Currency code
     C                   KFLD                    KeyACOD                        Account code
     C                   KFLD                    KeyACSQ                        Account sequence num
     C                   KFLD                    KeyNATY                        Network Account Type
     C                   KFLD                    KeyDSTN                        Destination
     C                   KFLD                    KeyMTPY                        Message Type
                                                                                              CRE008
     C     KeyAcntBl     KLIST                                                                CRE008
     C                   KFLD                    KeyCNUM                                      CRE008
     C                   KFLD                    KeyCCY                                       CRE008
     C                   KFLD                    KeyACOD                                      CRE008
     C                   KFLD                    KeyACSQ                                      CRE008
     C                   KFLD                    KeyBRCA                                      CRE008
 
     C/COPY WNCPYSRC,GLH00173
      *    ------        -----
     C     @INZSR        ENDSR
 
      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
 
     C     *PSSR         BEGSR
      *    -----         -----
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      ReturnCode = 'PSSR_ERROR'
     C                   ENDIF
 
     C                   DUMP
     C                   ROLBK
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
 
     C                   RETURN
 
      *    -----         -----
     C     @PSSR         ENDSR
 
      *========================================================================*
**CTDATA CPY@
(c) Finastra International Limited 2002
