     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD AML database customer details exporter')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000020 - AML Database Customer Details Exporter            *
      *                                                               *
      *  Function:  This module exports the details of Midas          *
      *             Customers into the AML Database.                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CGL157             Date 17Aug15               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER034             Date 06Aug08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 03Sep01               *
      *                 CSD017  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL157 - CRS Reporting (Recompile)                           *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *
      ** Customer Details Database
      *
     FSDCUSTPD  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(SDCUSTD0:CUSTOMERS)
      *
      ** Customer Details Database by Parent Customer Number
      *
     FSDCUSTL4  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Additional Customer Details Database by Customer Number
      *
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Branch Details Database by Internal Customer
      *
     FSDBRCHL5  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structure. They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      *
      ** PMode Constants
      *
     D ALL             C                   CONST('A')
     D CHANGED         C                   CONST('C')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      *
      ** Customer Details Data Structure
      *
     D CustDet       E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(CD:2)
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      *
      ** Additional Customer Details Data Structure
      *
     D AddCustDet    E DS                  EXTNAME(SDACUSPD)
     D                                     PREFIX(CA:2)
      *
      ** Account Officer Details Data Structure
      *
     D AccOffDet     E DS                  EXTNAME(SDACOFPD)
     D                                     PREFIX(AD:2)
      *
      ** Local Industry Code Details Data Structure
      *
     D LocIndCdeDet  E DS                  EXTNAME(SDINDSPD)
     D                                     PREFIX(LD:2)
      *
      ** Parent Customer Details Data Structure
      *
     D PrntDet       E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(PD:2)
     D QQDFAC2       E                     EXTFLD(QQDFAC)                                     CGL029
      *
      ** Additional Parent Customer Details Data Structure
      *
     D AddPrntDet    E DS                  EXTNAME(SDACUSPD)
     D                                     PREFIX(PA:2)
      *
      ** Branch Details Data Structure
      *
     D BrchDet       E DS                  EXTNAME(SDBRCHPD)
     D                                     PREFIX(BD:2)
     D QQDFAC3       E                     EXTFLD(QQDFAC)                                     CGL029
     D QQDTAC3       E                     EXTFLD(QQDTAC)                                     CGL029
      *
      ** Bank Details Data Structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Working Customer Details Data Structure
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Working Additional Customer Details Data Structure
      *
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      *
      ** Working Account Officer Details Data Structure
      *
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      *
      ** Working Local Industry Code Details Data Structure
      *
     D SDINDS        E DS                  EXTNAME(SDINDSPD)
      *
      ** Working Branch Details Data Structure
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFAC4       E                     EXTFLD(QQDFAC)                                     CGL029
      *
      ** Switchable Feature Details Data Structure
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Compliance Watch Configuration Data DS
      *
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
      *
      ** Short Access Object Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long Access Object Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *
      ** Program Parameter
      *
     D PMode           S              1
      *
      ** Concord Interface Development Indicator
      *
     D CCF001          S              1A   INZ('N')
      *
      ** Access Object Parameters
      *
     D PCustNo         S             10
     D PAccCde         S              2
     D PLocIndCde      S              3
     D PSARD           S              6
     D PErrInf         S              7
      *
      ** Working Variables
      *
     D WPopFlg         S              1
     D WBscFlg         S              1
     D WCurrCust       S              6
      *
      ** Customer Details Database Key
      *
     D KCustNo         S              6
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   READ      SDCUSTPD
      *
     C                   DOW       NOT %EOF(SDCUSTPD)
      *
      ** Begin Customer Details Processing
      ** =================================
      *
     C                   IF        (PMode = ALL AND
     C                             BBTYLC <> 'D') OR
     C                             (PMode = CHANGED AND
     C                             BBLCD = BJRDNB)
      *
      ** Derive the complete customer details for the Import Table.
      *
     C                   EXSR      SRGetExpInf
      *
     C                   EVAL      CustDet = SDCUST
     C                   EVAL      AddCustDet = SDACUS
     C                   EVAL      AccOffDet = SDACOF
     C                   EVAL      LocIndCdeDet = SDINDS
      *
     C                   EXSR      SRPopChk
      *
      ** Populate the AML Corp./Cust. Details Import Table.
      *
     C                   IF        WPopFlg = 'Y'
      *
     C                   IF        BBPCNB = *BLANKS
     C                   CLEAR                   PrntDet
     C                   CLEAR                   AddPrntDet
     C                   ELSE
     C                   EVAL      PCustNo = BBPCNB
     C                   EVAL      WBscFlg = 'Y'
     C                   EXSR      SRGetExtCD
     C                   EVAL      PrntDet = SDCUST
     C                   EVAL      AddPrntDet = SDACUS
     C                   ENDIF
      *
     C                   EXSR      SRPACorpDIT
      *
     C                   ELSE
      *
     C                   EXSR      SRPACustDIT
      *
     C                   ENDIF
      *
      ** Populate the Branch and Corp. DITs only if PMode = CHANGED.
      *
     C                   IF        PMode = CHANGED
      *
      ** If the current customer is a Branch Internal Customer,
      ** populate the AML Branch Details Import Table.
      *
      ** Reload the customer details.
      *
     C                   EVAL      SDCUST = CustDet
     C                   EVAL      SDACUS = AddCustDet
      *
      ** Access branch details.
      *
     C                   EVAL      KCustNo = BBCUST
     C     KCustNo       CHAIN     SDBRCHL5
      *
     C                   IF        %FOUND(SDBRCHL5)
      *
     C     KCustNo       SETLL     SDBRCHL5
     C                   READ      SDBRCHL5
      *
     C                   DOW       NOT %EOF(SDBRCHL5) AND
     C                             A8BICN = BBCUST
     C                   EVAL      BrchDet = SDBRCH
     C                   EXSR      SRPABrchDIT
     C                   READ      SDBRCHL5
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** If the current customer is a Parent Customer, populate
      ** the AML Corporate Details Import Table.
      *
      ** Move the customer details to the parent details.
      *
     C                   EVAL      PrntDet = CustDet
     C                   EVAL      AddPrntDet = AddCustDet
      *
      ** Access parent customer details.
      *
     C                   EVAL      WCurrCust = BBCUST
     C                   EVAL      KCustNo = BBCUST
     C     KCustNo       CHAIN     SDCUSTL4
      *
     C                   IF        %FOUND(SDCUSTL4)
      *
     C     KCustNo       SETLL     SDCUSTL4
     C                   READ      SDCUSTL4
      *
     C                   DOW       NOT %EOF(SDCUSTL4) AND
     C                             WCurrCust = BBPCNB
     C                   EXSR      SRPopChk
      *
     C                   IF        WPopFlg = 'Y'
     C                   EXSR      SRGetExpInf
     C                   EVAL      CustDet = SDCUST
     C                   EVAL      AddCustDet = SDACUS
     C                   EXSR      SRPACorpDIT
     C                   ENDIF
      *
     C                   READ      SDCUSTL4
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** End Customer Details Processing
      ** ===============================
      *
     C                   READ      SDCUSTPD
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = True
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetExpInf - Gets the complete and exportable customer       *
      *               information for the Corp./Cust. DIT Populator.  *
      *                                                               *
      *****************************************************************
     C     SRGetExpInf   BEGSR
      *
     C                   EVAL      PCustNo = BBCUST
     C                   EVAL      PAccCde = BBACOC
     C                   EVAL      PLocIndCde = BBLICD
      *
     C                   EXSR      SRGetExtCD
     C                   EXSR      SRGetAODet
     C                   EXSR      SRGetLICDet
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPABrchDIT - Populates the AML Brch. Details Import Table.   *
      *                                                               *
      *****************************************************************
     C     SRPABrchDIT   BEGSR
      *
      ** AML Branch Details Import Table Populator
      ** =========================================
      *
     C                   CALL      'SD000019'
      *                  --------------------
      *
      ** Input Parameters:
      *
      ** Mode
      ** Branch Details
      ** Customer Details
      ** Additional Customer Details
      *
     C                   PARM                    PMode
     C                   PARM                    BrchDet
     C                   PARM                    CustDet
     C                   PARM                    AddCustDet
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPACustDIT - Populates the AML Cust. Details Import Table.   *
      *                                                               *
      *****************************************************************
     C     SRPACustDIT   BEGSR
      *
      ** AML Customer Details Import Table Populator
      ** ===========================================
      *
     C                   CALL      'SD000022'
      *                  --------------------
      *
      ** Input Parameters:
      *
      ** Mode
      ** Customer Details
      ** Additional Customer Details
      ** Account Officer Details
      *
     C                   PARM                    PMode
     C                   PARM                    CustDet
     C                   PARM                    AddCustDet
     C                   PARM                    AccOffDet
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPACorpDIT - Populates the AML Corp. Details Import Table.   *
      *                                                               *
      *****************************************************************
     C     SRPACorpDIT   BEGSR
      *
      ** AML Corporate Details Import Table Populator
      ** ============================================
      *
     C                   CALL      'SD000021'
      *                  --------------------
      *
      ** Input Parameters:
      *
      ** Mode
      ** Customer Details
      ** Additional Customer Details
      ** Account Officer Details
      ** Local Industry Code Details
      ** Parent Customer Details
      ** Parent Customer Additional Details
      *
     C                   PARM                    PMode
     C                   PARM                    CustDet
     C                   PARM                    AddCustDet
     C                   PARM                    AccOffDet
     C                   PARM                    LocIndCdeDet
     C                   PARM                    PrntDet
     C                   PARM                    AddPrntDet
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPopChk - Checks if the AML Corporate Details Import Table   *
      *            should be populated.                               *
      *                                                               *
      *****************************************************************
     C     SRPopChk      BEGSR
      *
     C                   EVAL      WPopFlg = 'N'
      *
      ** Accepted States:
      *
      ** 1. CCF001 is disabled and the Local Industry Code is not
      **    equal to any Private Customer Industry Code.
      ** 2. CCF001 is enabled and the current customer is a Corporate
      **    Customer.
      ** 3. CCF001 is enabled and the current customer is a bank.
      *
     C                   IF        (CCF001 <> 'Y'    AND
     C                             BBLICD <> *BLANKS AND
     C                             BBLICD <> W1IND1  AND
     C                             BBLICD <> W1IND2  AND
     C                             BBLICD <> W1IND3  AND
     C                             BBLICD <> W1IND4  AND
     C                             BBLICD <> W1IND5) OR
     C                             (CCF001 = 'Y' AND
     C                             BBCRPC = 'Y') OR
     C                             (CCF001 = 'Y' AND
     C                             BBBNBI = 'Y')
     C                   EVAL      WPopFlg = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetLICDet - Gets the Local Industry Code details.           *
      *                                                               *
      *****************************************************************
     C     SRGetLICDet   BEGSR
      *
      ** Access the Local Industry Code details.
      *
     C                   CALL      'AOINDSR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PLocIndCde
     C     SDINDS        PARM      SDINDS        DSFDY
      *
     C                   IF        @RtCd <> *BLANKS
      *
     C                   IF        @RtCd = '*NRF'
     C                   CLEAR                   SDINDS
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PLocIndCde
     C                   EVAL      DBFile = 'SDINDSPD'
     C                   EVAL      DBase = 904
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetAODet - Gets the Account Officer details.                *
      *                                                               *
      *****************************************************************
     C     SRGetAODet    BEGSR
      *
      ** Access the Account Officer details.
      *
     C                   CALL      'AOACOFR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PAccCde
     C     SDACOF        PARM      SDACOF        DSFDY
      *
     C                   IF        @RtCd <> *BLANKS
      *
     C                   IF        @RtCd = '*NRF'
     C                   CLEAR                   SDACOF
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PAccCde
     C                   EVAL      DBFile = 'SDACOFPD'
     C                   EVAL      DBase = 905
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetExtCD - Gets the extended (and optionally, the basic)    *
      *              customer details.                                *
      *                                                               *
      *****************************************************************
     C     SRGetExtCD    BEGSR
      *
      ** Get the basic customer details if necessary.
      *
     C                   IF        WBscFlg = 'Y'
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PCustNo
     C                   PARM      *BLANKS       PErrInf
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        @RtCd <> *BLANKS
      *
     C                   IF        @RtCd = '*NRF'
     C                   CLEAR                   SDCUST
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 906
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      WBscFlg = 'N'
      *
     C                   ENDIF
      *
      ** Get the additional (extended) customer details.
      *
     C                   EVAL      KCustNo = PCustNo
     C     KCustNo       CHAIN     SDACUSL1
     C                   IF        NOT %FOUND(SDACUSL1)
     C                   CLEAR                   SDACUS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Subroutine                    *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameter List
      ** ==============
      *
     C     *ENTRY        PLIST
      *
      ** Input Parameter:
      *
      ** Export Mode
      *
     C                   PARM                    PMode
      *
      ** End of Parameter List
      ** =====================
      *
      ** Skip further processing if the Export Mode is invalid.
      *
     C                   IF        PMode <> ALL AND
     C                             PMode <> CHANGED
     C                   EVAL      *INLR = True
     C                   RETURN
     C                   ENDIF
      *
      ** Access Bank Details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = @Optn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 901
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access the Compliance Watch Configuration Data.
      *
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDCWCD        PARM      SDCWCD        DSSDY
      *
     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = @Optn
     C                   EVAL      DBFile = 'SDCWCDPD'
     C                   EVAL      DBase = 902
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details to see if CCF001 is enabled.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CCF001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RtCd = *BLANKS
     C                   EVAL      CCF001 = 'Y'
     C                   ELSE
      *
     C                   IF        @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PSARD
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBase = 903
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------------------------------+
      ** ¦ Program, module, and procedure        ¦
      ** ¦ names for DB error processing         ¦
      ** ¦ =============================         ¦
      ** +---------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY includes the DB error processing routines.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2002
