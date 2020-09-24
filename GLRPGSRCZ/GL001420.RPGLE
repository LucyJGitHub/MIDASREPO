     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL MT941 File Extract')                          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001420 - Midas GL MT941 File Extract                       *
      *                                                               *
      *  Function: This program extracts data from Posting file to    *
      *            MGx941PD                                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. 223783             Date 28May12               *
      *  Prev Amend No. 222088             Date 28May12               *
      *                 216936             Date 28May12               *
      *                 212319             Date 28May12               *
      *                 CMG008             Date 20Feb20               *
      *                 MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 AR676213           Date 19Nov10               *
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
      *                 CGL013  *CREATE    Date 23Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  223783 - Applied for AR973615 (Child: AR973617) (Recompile)  *
      *  222088 - Conditioning of CM narrative should account for     *
      *           details on heirarchy, not ICD.                      *
      *         - Applied for AR973615 (Child: AR973617)              *
      *  216936 - Text from CM ICD should not be present on           *
      *           statement for top accounts.                         *
      *         - Applied for AR973615 (Child: AR973617)              *
      *  212319 - Default text for Zero Balance account not reported  *
      *           on statements.                                      *
      *         - Applied for AR973615 (Child: AR973617).             *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *           (Child: AR676229)                                   *
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

     FGLACBTL0  IF   E           K DISK                   INFSR(*PSSR)
      ** Midas GL Account Balances Today.

     FPRONO     IF   E           K DISK                   INFSR(*PSSR)
     F                                     PREFIX(PR)
      ** Midas GL Projected Nostro Balances.

     FGLRSACL0  IF   E           K DISK                   INFSR(*PSSR)
     F                                     RENAME(GLRSACD0:RSGLRSACD0)
     F                                     PREFIX(RS)
      ** Midas GL MT94x Used Account Movements
                                                                                              212319
     FREZSHLL1  IF   E           K DISK                   INFSR(*PSSR)                        212319
      ** Midas RE Group Account Hierarchy Links                                               212319
                                                                                              222088
     FREGAHDL0  IF   E           K DISK                   INFSR(*PSSR)                        222088
      ** Midas RE Group Account Hierarchy Details                                             222088

     FGLFFAML0  IF   E           K DISK                   INFSR(*PSSR)
     F                                     RENAME(GLFFAMD0:FFGLFFAMD0)
     F                                     PREFIX(FF)
      ** Midas GL MT94x FF Used Account Movements

     FMEMOSM1   IF   E           K DISK    USROPN         INFSR(*PSSR)
     F                                     PREFIX(FM_)
      ** Midas FF Retail Shadow Balances

     FPRONOM1   IF   E           K DISK    USROPN         INFSR(*PSSR)
     F                                     PREFIX(FP_)
      ** Midas FF Projected Nostro Balances

     FREGAHLJ2  IF   E           K DISK                   INFSR(*PSSR)                        CRE008
      ** Midas RE Group Account Hierarchy Links                                               CRE008
                                                                                              CRE008
     FMGF941PD  O    E             DISK    COMMIT         INFSR(*PSSR)
      ** Midas MG MT941 Generation Extract - Account Detail.

     FMGY941PD  O    E             DISK    COMMIT         INFSR(*PSSR)
      ** Midas MG MT941 Gen. Extract File - Forw. Balance.

     FGLRSACPD  O    E             DISK    COMMIT         INFSR(*PSSR)
     F                                     PREFIX(RS)
      ** Midas GL MT94x Used Account Movements

     FGLFFAMPD  O    E             DISK    COMMIT         INFSR(*PSSR)
     F                                     PREFIX(FF)
      ** Midas GL MT94x FF Used Account Movements

     FGL001420AUO    E             PRINTER USROPN         INFSR(*PSSR)
      ** Midas GL MT941 File Extract - Audit Report.

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 21 - Audit report overflow indicator                                   *
      * 27 - Access Network Account (LF/GLNW94L5)                              *
      * 28 - Access Postings        (LF/GLPOSTL0)                              *
      * 29 - Access Used Movements  (LF/GLRSACL0)                              *
      * 30 - Access FF Used Movements  (LF/GLFFAML0)                           *
      * 31 - Access Group Accounts  (LF/REGAHLJ2)                              *              CRE008
      * 35 - Access CM A/C /Hierarchy (LF/REGAHDL0)                            *              222088
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

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data Structure for Bank Details.

     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      **  Data Structure for Network Details.

     D GLACCNT       E DS                  EXTNAME(ACCNTAB)
      **  Data Structure for Account Details.

     D MEMOS         E DS                  EXTNAME(MEMOS)    PREFIX(ME)
      **  Data Structure for RE Shadow Balances.

     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACD1        E                     EXTFLD(QQACCD)                                     CGL029
      **  Data Structure for SD Nostro details.

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  Data Structure for Customer Details.

     D MMOD          E DS                  EXTNAME(MMODF)    DTAARA(MMOD)
     D                                                       PREFIX(Mo_)
      **  Data Structure for Midas SD Module
                                                                                              CRE008
     D SDCMAN        E DS                  EXTNAME(SDCMANPD)                                  CRE008
      ** External DS for cash management details                                              CRE008

     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SS)
      **  Data Structure for Switchable features descriptions.

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  First DS for access programs, long data structure.

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, short data structure.

     D DSLDY         E DS                  EXTNAME(DSLDY)
      **  Third DS for access programs, very long data structure.

     D FwrDtBal        DS                  OCCURS (999)
      ** Multi-occurence data structure keep the Foward Value Date and Balance.
     D  FwrDate                       5  0 INZ(*ZEROS)                          Forward Value Date
     D  FwrBal                       15  0 INZ(*ZEROS)                          Forward Balance

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
     D P@OPTN          S              7A                                        Option
     D P@SARD          S              6A                                        Sar           CRE008
     D P@RETL          S             10A                                        Retail Number
     D P@CNUM          S              6A                                        Customer
     D P@CUCD          S              3A                                        Currency
     D*P@ACCD***       S              4A                                        Account code  CGL029
     D P@ACCD          S             10A                                                      CGL029
     D P@ACSQ          S              2A                                        Account Sequence
     D P@BRCA          S              3A                                        Branch Code
     D P@KEY1          S             10A                                        Customer
     D P@KYST          S              7A                                        Key Status
     D P@NWRK          S              6A                                        Network
     D P@RETLN         S             10  0                                      Retail Number
     D*P@CNUMN**       S              6  0                                      Customer      CSD027
     D P@CNUMN         S              6                                         Customer      CSD027
     D*P@ACCDN**       S              4  0                                      Account code  CGL029
     D P@ACCDN         S             10  0                                                    CGL029
     D P@ACSQN         S              2  0                                      Account Sequence
     D P@NONB          S              2A                                        Nostro No
     D P@CSSN          S             10A                                        Cust ShortName
     D P@PNOI          S              1A                                        Prime Nost Ind

     D CRE008          S              1A                                                      CRE008
     D WkDebitAmn      S             15P 0                                      Debit Amount
     D WkNbDebit       S             10U 0                                      Nb of Debit
     D WkCredtAmn      S             15P 0                                      Credit Amount
     D WkNbCredt       S             10U 0                                      Nb of Credit

     D WkPrjAvail      S              1A                                        Projected Avail
     D WkPrjLedger     S             15P 0                                      Projected LDBL
     D WkPrjClear      S             15P 0                                      Projected CLBL
     D WkClosLDBL      S             15P 0                                      Closing Ledger Bal.

     D WkNostNumb      S              2S 0                                      Nostro Number
     D                                     BASED(Pointer2)
     D  Pointer2       S               *   INZ(%Addr(A7NONB))

     D ProjNostBal     S             15P 0                                      Projected Nostro Bal
     D                                     BASED(Pointer3)
     D  Pointer3       S               *   INZ(%Addr(PRPNB))

     D WkNbFwrDt       S              5U 0 INZ(1)                               Nb. Foward Date
     D WkErrRpt        S              1A   INZ('N')                             Error Reported

     D X               S              5U 0                                      Working Index

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

      ** Check if the customer allows MT941 generation.

     C                   EXSR      $ChkCust

     C   40              LEAVE

      ** Extract Data

     C                   EXSR      $ExtData

     C   40              LEAVE

      ** Check if the MT941 should be generated even there is no movement

     C                   IF        N41GNM = 'N'                                 gen. even no mvnts
     C                             AND WkNbDebit = *ZEROS                       Nb of Debit
     C                             AND WkNbCredt = *ZEROS                       Nb of Credit

     C                   EVAL      ReturnCode = 'NO MOVT'

     C                   ELSE

      ** Process MT941 message

      ** Process Account Details

     C                   EXSR      $MGF941PD

     C   40              LEAVE

      ** Process Forward Balance

     C                   EXSR      $MGY941PD

     C   40              LEAVE

      ** Update Network Account details.

     C                   EXSR      $GLNW94PD

     C   40              LEAVE

     C                   ENDIF

     C                   ENDDO

     C   40              ROLBK

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

     C                   EVAL      WkPrjAvail = 'N'                             Projected Available
     C                   EVAL      WkPrjLedger= *ZEROS                          Projected LDBL
     C                   EVAL      WkPrjClear = *ZEROS                          Projected CLBL
     C                   EVAL      WkClosLDBL = *ZEROS                          Closing Ledger Bal.

     C     1             DO        WkNbFwrDt     X
     C     X             OCCUR     FwrDtBal
     C                   EVAL      FwrDate = *ZEROS                             Forward Date
     C                   EVAL      FwrBal  = *ZEROS                             Forward Balance
     C                   ENDDO
     C                   EVAL      WkNbFwrDt = 1                                Foward Balance
     C     WkNbFwrDt     OCCUR     FwrDtBal

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

      **  Check if the Network exist.

     C                   CALLB     'AONWRKR1'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      MRNWRK        P@NWRK                         Network
     C     SDNWRK        PARM      SDNWRK        DSLDY

      ** Add the issue on the audit report.

     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Network ' + %TRIM(MRNWRK) +
     C                                       'does not exist'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @ChkNwrk
     C                   ENDIF

      **  Check if the Network authorize MT941

     C                   IF        EDM941 <> 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Network ' + %TRIM(MRNWRK) +
     C                                       'does not authorize MT941'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @ChkNwrk
     C                   ENDIF

      **  Check if the network is active

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
     C                             OR N4G941 <> 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Network Account for MT941 not +
     C                                       found'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   ENDIF

     C     @RtvNwrkAc    ENDSR
      *    ----------    -----

      *========================================================================*
      * $RtvAccnt: Retrieve Account details                                    *
      *------------------------------------------------------------------------*

     C     $RtvAccnt     BEGSR
      *    ---------     -----

     C                   MOVE      N4CNUM        P@CNUM                         Customer
     C                   MOVE      N4ACCD        P@ACCD                         Account code
     C                   MOVE      N4ACSQ        P@ACSQ                         Account Sequence

     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      *BLANKS       P@RETL                         Retail Number
     C                   PARM                    P@CNUM                         Customer
     C                   PARM      N4CCY         P@CUCD                         Currency
     C                   PARM                    P@ACCD                         Account code
     C                   PARM                    P@ACSQ                         Account Sequence
     C                   PARM      N4BRCA        P@BRCA                         Branch Code
     C     GLACCNT       PARM      GLACCNT       DSSDY

      ** Add the issue on the audit report.

     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Midas Account Detail not found'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   GOTO      @RtvAccnt
     C                   ENDIF

      ** Retrieve Projected Ledger and Cleared balances

      ** By default, the current Ledger and Cleared balances.

      **   Due to the possibity to update the account balance during I/C,
      **   retrieve the balance before I/C.

     C     KeyAcntBl     CHAIN     GLACBTL0                           99

      **   Ps. The process does not check *IN99 because if the record does not exist,
      **       it will use the information from ACCNTAB.

     C                   EVAL      WkPrjLedger = LDBL                           Projected LDBL
     C                   EVAL      WkPrjClear  = CLBL                           Projected CLBL

      ** Retail account.

     C                   CALL      'AOMEMSR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      *ZEROS        P@RETLN                        Retail Number
     C                   PARM      N4CNUM        P@CNUMN                        Customer
     C                   PARM      N4CCY         P@CUCD                         Currency
     C                   PARM      N4ACCD        P@ACCDN                        Account code
     C                   PARM      N4ACSQ        P@ACSQN                        Account Sequence
     C                   PARM      N4BRCA        P@BRCA                         Branch Code
     C     MEMOS         PARM      MEMOS         DSFDY

     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      WkPrjAvail = 'Y'                             Projected Available
     C                   EVAL      WkPrjLedger = MELDBLN                        Projected LDBL
     C                   EVAL      WkPrjClear  = MECLBLN                        Projected CLBL

      ** If MM Module is installed, retrieve FF balances and update projected balances.

     C                   IF        Mo_FFFL = 'Y'
     C                   OPEN      MEMOSM1
     C     KeyFFProj     SETLL     MEMOSM1
     C     KeyFFProj     READE     MEMOSM1                                99
     C                   DOW       NOT *IN99
     C                   IF        FM_RECI = 'D'
     C                   EVAL      WkPrjLedger = WkPrjLedger + FM_LDBL          Projected LDBL
     C                   EVAL      WkPrjClear  = WkPrjClear  + FM_CLBL          Projected CLBL
     C                   ENDIF
     C     KeyFFProj     READE     MEMOSM1                                99
     C                   ENDDO
     C                   CLOSE     MEMOSM1
     C                   ENDIF

     C                   GOTO      @RtvAccnt
     C                   ENDIF

      ** Nostro account.

     C                   IF        ATYP = 'N'

      ** Retrieve Nostro Code

     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM                    P@CNUM                         Customer
     C                   PARM                    P@CUCD                         Currency
     C                   PARM                    P@ACCD                         Account code
     C                   PARM                    P@ACSQ                         Account Sequence
     C                   PARM      *BLANKS       P@NONB                         Nostro No
     C                   PARM                    P@BRCA                         Branch Code
     C                   PARM      *BLANKS       P@CSSN                         Cust ShortName
     C                   PARM      *BLANKS       P@PNOI                         Prime Nost Ind
     C     SDNOST        PARM      SDNOST        DSFDY

     C                   IF        P@RTCD = *BLANKS

     C     KeyPrjNost    CHAIN     PRONO                              99
     C                   IF        NOT *IN99
     C                   EVAL      WkPrjAvail = 'Y'                             Projected Available
     C                   EVAL      WkPrjLedger = ProjNostBal                    Projected LDBL
     C                   EVAL      WkPrjClear  = ProjNostBal                    Projected CLBL

      ** If MM Module is installed, retrieve FF balances and update projected balances.

     C                   IF        Mo_FFFL = 'Y'
     C                   OPEN      PRONOM1
     C     KeyPrjNost    SETLL     PRONOM1
     C     KeyPrjNost    READE     PRONOM1                                99
     C                   DOW       NOT *IN99
     C                   IF        FP_RECI = 'D'
     C                   EVAL      WkPrjLedger = WkPrjLedger + FP_PNBL          Projected LDBL
     C                   EVAL      WkPrjClear  = WkPrjClear  + FP_PNBL          Projected CLBL
     C                   ENDIF
     C     KeyPrjNost    READE     PRONOM1                                99
     C                   ENDDO
     C                   CLOSE     PRONOM1
     C                   ENDIF

     C                   GOTO      @RtvAccnt
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      *    ---------     -----
     C     @RtvAccnt     ENDSR

      *========================================================================*
      * $ChkCust: Check if the customer allows MT941 generation.               *
      *------------------------------------------------------------------------*

     C     $ChkCust      BEGSR
      *    --------      -----

     C                   MOVEL(P)  N4CNUM        P@KEY1                         Customer

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

     C     '941'         LOOKUP    BBNGEN                                 99
     C                   IF        *IN99
     C                   EVAL      *IN40 = *ON
     C                   EVAL      PRCMNT = 'Customer ' + %TRIM(P@KEY1) +
     C                                      ' does not allow MT941 generation'
     C                   EXSR      $AuditRpt                                    Report Issue
     C                   ENDIF

      *    ---------     -----
     C     @ChkCust      ENDSR

      *========================================================================*
      * $ExtData: Extract Data                                                 *
      *------------------------------------------------------------------------*

     C     $ExtData      BEGSR
      *    --------      -----

      ** Read Postings for this Network Account.

     C     KeyPost       SETLL     GLPOSTD0
     C     KeyPost       READE     GLPOSTD0                               28

     C                   DOW       NOT *IN28

      ** Report only movements with a posting date less or equal to the run date,
      ** and not yet flagged as processed.

     C                   IF        GLMGPROC <> 'Y'

      ** Calculate the Debit and Credit details.

     C                   IF        GLDRCR = 0                                   Debit
     C                   EVAL      WkNbDebit = WkNbDebit + 1                    Nb of Debit
     C                   EVAL      WkDebitAmn = WkDebitAmn + GLPSTA             Debit Amount
     C                   ELSE                                                   Credit
     C                   EVAL      WkNbCredt = WkNbCredt + 1                    Nb of Credit
     C                   EVAL      WkCredtAmn = WkCredtAmn + GLPSTA             Credit Amount
     C                   ENDIF

     C                   SELECT

      ** Re-extract postings from last statement

     C                   WHEN      GLRECI = 'P'                                 Posting
     C                             AND N41RPL <> 'Y'                            Re-extract flag
     C                   EVAL      GLMGPROC = 'Y'                               Flagged as Processed

      ** Re-extract shadow posting

     C                   WHEN      GLRECI = 'S'                                 Shadow Posting
     C                             AND N41RAS <> 'Y'                            Re-extract flag
     C                   EVAL      GLMGPROC = 'Y'                               Flagged as Processed
     C                   ENDSL

     C                   ENDIF

      ** Retrieve closing ledger balance.

      ** This balance will be used to calculate the closing Legder balance for account
      ** with account type not retail nor Nostro.
      ** For the Retail Account, the balances are held in MEMOS.
      ** For the Nostro Account, the balances are held in PRONO.

      ** For General Ledger account, the value date should be the run date

     C                   IF        GLRECI = 'S'
     C                             AND GLPSTD < BJDNWD

     C                   IF        GLDRCR = 0                                   Debit
     C                   EVAL      WkClosLDBL = WkClosLDBL + GLPSTA
     C                   ELSE                                                   Credit
     C                   EVAL      WkClosLDBL = WkClosLDBL - GLPSTA
     C                   ENDIF

     C                   ENDIF

      ** Retrieve balance by value date in the future

     C                   IF        GLVALD >= BJDNWD

      ** Initialize the first Forward Date to the first Posting Valur Date greater than run day

     C                   IF        FwrDate = *ZEROS
     C                   EVAL      FwrDate = GLVALD
     C                   ENDIF

      ** Totalize movement by value date

     C                   IF        GLVALD > FwrDate                             Next Foward Date
     C                   EVAL      WkNbFwrDt = WkNbFwrDt + 1
     C     WkNbFwrDt     OCCUR     FwrDtBal
     C                   EVAL      FwrDate = GLVALD
     C                   ENDIF

     C                   IF        GLDRCR = 0                                   Debit
     C                   EVAL      FwrBal = FwrBal + GLPSTA
     C                   ELSE                                                   Credit
     C                   EVAL      FwrBal = FwrBal - GLPSTA
     C                   ENDIF
     C                   ENDIF

     C                   UPDATE    GLPOSTD0

      ** Read Next Posting for this Network Account.

     C     KeyPost       READE     GLPOSTD0                               28

     C                   ENDDO

      *    --------      -----
     C     @ExtData      ENDSR

      *========================================================================*
      * $MGF941PD: Extract Account Details                                     *
      *------------------------------------------------------------------------*

     C     $MGF941PD     BEGSR
      *    ---------     -----

     C                   CLEAR                   MGF941D0

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
     C                   EVAL      MGDMST = ED1SER                              External Request Def
     C                   EVAL      MGIMIR = MRIMIR                              Incoming MIR
     C                   WHEN      MRSORQ = 'MANUAL'                            Manual Request
     C                   EVAL      MGDMST = ED1SMR                              Manual Request Def.
     C                   OTHER                                                  Scheduled request
     C                   EVAL      MGDMST = ED1SGS                              External Request Def
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
     C     KeyAcntBl     Chain     REGAHLJ2                           31                      CRE008
     C     KeyAcntBg     Chain     REZSHLL1                           36                      212319
     C                   IF        *IN31 = *OFF                                               222088
     C     CLHIER        CHAIN     REGAHDL0                           35                      222088
     C                   IF        *IN35 = *ON                                                222088
     C                   EXSR      *PSSR                                                      222088
     C                   ENDIF                                                                222088
     C                   ENDIF                                                                222088
     C                   Endif                                                                CRE008
      *                                                                                       CRE008
     C                   SELECT
     C                   WHEN      CRE008 = 'Y' And                                           212319
     C                             *IN36 = *OFF                                               212319
     C                   EVAL      MGMIO1 = CMTXTZ                                            212319
     C                   EVAL      MGMIO2 = %subst(CMTXTZ:66:65)                              212319
     C                   EVAL      MGMIO3 = %subst(CMTXTZ:131:65)                             212319
     C                   EVAL      MGMIO4 = %subst(CMTXTZ:196:5)                              212319
     C                   EVAL      MGMIO5 = *blanks                                           212319
     C                   EVAL      MGMIO6 = *blanks                                           212319
     C                   WHEN      CRE008 = 'Y' And                                           CRE008
     C                             *IN31 = *OFF                                               CRE008
     C                             AND CLCCAT <> 'T'                                          216936
     C                             AND GDTOPB = 'Y'                                           222088
     C                             OR  CRE008 = 'Y'                                           222088
     C                             AND *IN31 = *OFF                                           222088
     C                             AND CLCCAT = 'T'                                           222088
     C                             AND GDTOPB = 'N'                                           222088
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
     C                   EVAL      MGMIO1 = N41MI1                              Default MT941 messag
     C                   EVAL      MGMIO2 = N41MI2                              Default MT941 messag
     C                   EVAL      MGMIO3 = N41MI3                              Default MT941 messag
     C                   EVAL      MGMIO4 = N41MI4                              Default MT941 messag
     C                   EVAL      MGMIO5 = N41MI5                              Default MT941 messag
     C                   EVAL      MGMIO6 = N41MI6                              Default MT941 messag
     C                   ENDSL
     C                   EVAL      MGSTNO = N41LSP + 1                          Last Statement Page
     C                   EVAL      MGLSDT = N41LSD                              Last Statement Date
     C                   EVAL      MGOBAL = N41LCB                              Opening Balance
     C                   EVAL      MGNBDB = WkNbDebit                           Number of Debit Post
     C                   EVAL      MGSMDB = WkDebitAmn                          Sum of Debit Posting
     C                   EVAL      MGNBCR = WkNbCredt                           Number of Credit Pos
     C                   EVAL      MGSMCR = WkCredtAmn                          Sum of Crebit Postin

     C                   IF        WkPrjAvail = 'Y'
     C                   EVAL      MGCBBF = WkPrjLedger                         Clos.Bal.- Booked
     C                   EVAL      MGCBAF = WkPrjClear                          Clos.Bal.- Available
     C                   ELSE
     C                   EVAL      MGCBBF = WkClosLDBL + LDBL                   Clos.Bal.- Booked
     C                   EVAL      MGCBAF = WkClosLDBL + CLBL                   Clos.Bal.- Available
     C                   ENDIF

     C                   WRITE     MGF941D0

      *    ---------     -----
     C     @MGF941PD     ENDSR

      *========================================================================*
      * $MGY941PD: Forward Balance                                             *
      *------------------------------------------------------------------------*

     C     $MGY941PD     BEGSR
      *    ---------     -----

     C                   CLEAR                   MGY941D0

     C                   EVAL      MGNWRK = MRNWRK                              Network
     C                   EVAL      MGBRCA = MRBRCA                              Branch Code - Alpha
     C                   EVAL      MGCNUM = MRCNUM                              Customer number
     C                   EVAL      MGCCY  = MRCCY                               Currency code
     C                   EVAL      MGACCD = MRACCD                              Account code
     C                   EVAL      MGACSQ = MRACSQ                              Account sequence num
     C                   EVAL      MGNATY = MRNATY                              Network Account Type
     C                   EVAL      MGDSTN = MRDSTN                              Destination

     C                   EVAL      MGFAMT = MGCBAF                              Available Fund

     C     1             DO        WkNbFwrDt     X
     C     X             OCCUR     FwrDtBal
     C                   IF        FwrDate <> *ZEROS
     C                   EVAL      MGFVDT = FwrDate                             Forward Date
     C                   EVAL      MGFAMT = MGFAMT + FwrBal                     Forward Balance
     C                   WRITE     MGY941D0
     C                   ENDIF
     C                   ENDDO

      *    ---------     -----
     C     @MGY941PD     ENDSR

      *========================================================================*
      * $GLNW94PD: Update Network Account details.                             *
      *------------------------------------------------------------------------*

     C     $GLNW94PD     BEGSR
      *    ---------     -----

      ** Process MT941 Details.

     C                   EVAL      N41LSP = N41LSP + 1                          Last statement page
     C                   EVAL      N41LSD = BJRDNB                              Last Statement Date
     C                   TIME                    N41LST                         Last Statement Time
     C                   EVAL      N41LDN = WkNbDebit                           Last sum of DB Numbe
     C                   EVAL      N41LDA = WkDebitAmn                          Last sum of DB Amnt
     C                   EVAL      N41LCN = WkNbCredt                           Last sum of CR Numbe
     C                   EVAL      N41LCA = WkCredtAmn                          Last sum of CR Amnt

      ** Next Opening Balance.

     C                   SELECT

      ** If the postings and shadow postings could be re-extracted,
      ** the next opening balance is the closing balance of the last MT940.
      ** So, the next opening balance does not change.

     C                   WHEN      N41RPL = 'Y'                                 Re-extract postings
     C                             AND N41RAS = 'Y'                             Re-extract shadows

      ** If the postings and shadow postings could not be re-extracted,
      ** the next opening balance is the closing balance.

     C                   WHEN      N41RPL <> 'Y'                                Re-extract postings
     C                             AND N41RAS <> 'Y'                            Re-extract shadows

     C                   IF        WkPrjAvail = 'Y'
     C                   EVAL      N41LCB = WkPrjLedger                         Next Opening balance
     C                   ELSE
     C                   EVAL      N41LCB = WkClosLDBL + LDBL                   Next Opening balance
     C                   ENDIF

      ** If the postings could not be re-extracted,
      ** but, the shadow postings could be re-extracted,
      ** the next opening balance is the Ledger balance.

     C                   WHEN      N41RPL <> 'Y'                                Re-extract postings
     C                             AND N41RAS = 'Y'                             Re-extract shadows

     C                   EVAL      N41LCB = LDBL                                Next Opening balance

      ** If the postings could be re-extracted,
      ** but, the shadow postings could not be re-extracted,
      ** the next opening balance is the Closing balance minus Ledger balance

     C                   WHEN      N41RPL = 'Y'                                 Re-extract postings
     C                             AND N41RAS <> 'Y'                            Re-extract shadows

     C                   IF        WkPrjAvail = 'Y'
     C                   EVAL      N41LCB = WkPrjLedger - LDBL                  Next Opening balance
     C                   ELSE
     C                   EVAL      N41LCB = WkClosLDBL                          Next Opening balance
     C                   ENDIF

     C                   ENDSL

     C                   UPDATE    GLNW94D0

     C                   EVAL      MsgGenDate = N41LSD                          Msg Generation Date
     C                   EVAL      MsgGenTime = N41LST                          Msg Generation Time

      *    ---------     -----
     C     @GLNW94PD     ENDSR

      *========================================================================*
      * $AuditRpt: Report issues                                               *
      *------------------------------------------------------------------------*

     C     $AuditRpt     BEGSR
      *    ---------     -----

      ** Write audit report title.

     C                   OPEN      GL001420AU
     C                   WRITE     HEADAU
     C                   WRITE     SUBTL
     C                   WRITE     DETAIL
     C                   WRITE     ENDRPT
     C                   CLOSE     GL001420AU

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

      ** Retrieve MIDAS Modules

     C                   IN        MMOD

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

      ** Key to access Account Balance Today.

     C     KeyAcntBl     KLIST
     C                   KFLD                    KeyCNUM                        Customer number
     C                   KFLD                    KeyCCY                         Currency code
     C                   KFLD                    KeyACOD                        Account code
     C                   KFLD                    KeyACSQ                        Account sequence num
     C                   KFLD                    KeyBRCA                        Branch Code - Alpha
     C     KeyAcntBg     KLIST                                                                212319
     C                   KFLD                    KeyBRCA                        Branch Code   212319
     C                   KFLD                    KeyCNUM                        Customer num  212319
     C                   KFLD                    KeyCCY                         Currency cod  212319
     C                   KFLD                    KeyACOD                        Account code  212319
     C                   KFLD                    KeyACSQ                        Account sequ  212319

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

      ** Key to access Project Nostro Balance.

     C     KeyPrjNost    KLIST
     C                   KFLD                    A7CYCD                         Currency Code
     C                   KFLD                    WkNostNumb                     Nostro Number

      ** Key to access FF Projected Balance.

     C     KeyFFProj     KLIST
     C                   KFLD                    KeyBRCA                        Branch Code - Alpha
     C                   KFLD                    KeyCNUM                        Customer number
     C                   KFLD                    KeyCCY                         Currency code
     C                   KFLD                    KeyACOD                        Account code
     C                   KFLD                    KeyACSQ                        Account sequence num

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
