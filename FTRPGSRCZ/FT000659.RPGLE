     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Customer notification enquiry')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FT000659 -  Maintain Payment Date Offset Codes               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 221761             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 28Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 20Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 14Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls.                *
      *  CPK014 - Release 4 Packaging -                               *
      *         - Change CALLB's to simple CALL's to prevent module   *
      *           being bound in                                      *
      *  CFT009 - Funds Transfer Fees and Charge Development          *
      *                                                               *
      *****************************************************************
 
      * Display File
     FFT000659DFCF   E             WORKSTN SFILE(FT659S1:SFLRRN) INFDS(DSPDS)
 
      * Customer notification file.
     FFTCusNL0  IF   E           K DISK
 
      * Incoming Payments Main Details File
     FINPAY     IF   E           K Disk
 
      * Incoming Payments Main Extension File (Update)
     FINPAYXL3  UF   E           K DISK    Rename(INPAYXDF:L3PD)
 
      * Request for Transfer main details file
     FFT101HL3  IF   E           K Disk
 
      * Customer Credit Transfers main details file
     FFT102HL3  IF   E           K Disk
 
      * Request for Transfers.  Update notification only
     FFT101DL5  UF   E           K DISK    Rename(FT101DD0:L4MT101)
 
      * Customer Credit Transfers.  Update notification only
     FFT102DL3  UF   E           K DISK    Rename(FT102DD0:L2MT102)
 
      * Customer Advices
     FFTCNCL0   IF   E           K Disk
 
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
     DDSPDS            DS           528
     D    SRRN               378    379B 0
 
     DMSGDS            DS
     D  Msgid                  1      7
     D  Msgf                   8     17    Inz('FTUSRMSG')
     D  Msglib                18     27    Inz('*LIBL')
     D  MsgDta                28    283    Inz(' ')
     D  MsgRel               284    288    Inz('*SAME')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for nostro codes
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** External DS for access programs, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External Data structure for account details
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)
 
      ** Multiple Occurence Data Structure to hold customer details (Sort)
     DCUSTDS           DS                  OCCURS(9999)
     D  DSCUST                             Like(WBBCUST)
     D  DSPREF                             Like(WPREF)
     D  DSAMT                              Like(WAMT)
     D  DSCCY                              Like(WCCY)
     D  DSTYPE                             Like(WTYPE)
     D  DSTrnsID                           Like(WTrnsid)
 
      * Array to sort datastructure
     DCustA            S              6    Dim(9999)  Descend
     DCustB            S              6    Dim(9999)
 
     DSCustA           S              6    Dim(9999)
     DSCustB           S              6    Dim(9999)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     DNotString        S            420
     DNotResult        S              1
     DCodeWord         S             10
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Work Variables for access object AOCUST
     D C#RTCD          S              7
     D C#OPTN          S              7
     D C#CNUM          S             10
     D C#KYST          S              7
     D*C#ACCD***       S              4                                                       CGL029
     D C#ACCD          S             10                                                       CGL029
     D C#ACSN          S              2
     D C#BRCA          S              3
     D C#CSSN          S             10
     D C#CUST          S              6
     D C#CYCD          S              3
     D C#NONB          S              2
     D C#PNOI          S              1
     D C#IBAN          S             34
     D C#Acct          S             35
 
     D ActCode         S              1
     D RtCode          S              1
     D WLink           S              1
     D Reload          S              1
 
      * Occurrence index
     D  I              S              5  0
     D  J              S                   Like(I)
     D  K              S                   Like(I)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      * Set indicators for file format read
     IINPAYXDF      20
     IFT101DD0      21
     IFT102DD0      22
 
      ** Rename Field
     IFT102HD0
     I              SINST                       SINSTX
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *  Load data from file.  Note that this puts data into a datastructure for
      *   later read and display.
     C                   Exsr      Load_Data
 
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
 
     C                   Dow       *Inkc = *Off
 
     C  N30              Write     Blk659
     C                   Write     MsgCtl
     C                   Write     FT659T1
     C                   Exfmt     FT659C1
      *
     C                   CALL      'ZA0250'
 
 
     C                   Select
      * If control record (positioner) changed, reload
     C                   When      *In60
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
 
     C                   When      *InKE or Reload = 'Y'
     C                   Eval      Reload = 'N'
     C                   Exsr      Load_Data
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
 
      * Sfldsp = 30.  ie records exist, then can process
     C                   When      *In30
     C                   Eval      @@RNC1 =  SRRN
 
     C                   If        @@RNC1 <=0
     C                   Eval      @@RNC1 = 1
     C                   Endif
 
     C                   Exsr      Prc@Sf
 
     C                   If        Reload = 'Y'
     C                   Eval      Reload = 'N'
     C                   Exsr      Load_Data
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
     C                   Endif
 
 
     C                   Endsl
 
     C                   Enddo
 
     C                   Eval      *Inlr = *On
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Load_Data - Load data from files                              *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *  Cust_Nost                                                    *
      *  Cust_Sname                                                   *
      *  Cust_IBAN                                                    *
      *  Acc_101                                                      *
      *                                                               *
      *****************************************************************
     C     Load_Data     Begsr
 
 
     C                   Clear                   CustDS
 
     C                   MoveA     *Blanks       CustA
     C                   MoveA     *Blanks       CustB
     C                   MoveA     *Blanks       SCustA
     C                   MoveA     *Blanks       SCustB
 
     C                   Eval      i = 0
     C                   Eval      j = 0
     C                   Eval      k = 0
     C                   Setoff                                       202122
 
     C     *Loval        Setll     FTCUSNL0
     C                   Read      FTCUSNL0                               40
     C                   Dow       NOT *In40
 
     C                   Eval      i = i + 1
 
      *  Move data to datastructure
     C     i             Occur     CustDS
 
     C                   Select
      * Incoming Payments
     C                   When      *In20
 
      * Save payment reference
     C                   Eval      DsPref= INPREF
 
      * Save payment type
     C                   Eval      WType = 'IN'
     C                   Eval      DsTrnsid = *Blanks
 
      * Get incoming payments main details
     C     INPREF        Chain     Inpay                              89
     C                   If        *In89
     C                   Eval      DBKey  =  InPref
     C                   Eval      DBFile = 'FT000659'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 1
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Load_Data'
     C                   Exsr      *PSSR
     C                   Endif
 
      * Save payment amount for formatting
     C                   Move      PYAM          ZFIELD
 
      * Move Currency Code
     C                   Eval      DSccy  =  PCCY
 
      * Now get customer details.  This is the BENEFICIARY customer of the incoming
      *  payment.  Fields are therefore Beneficiary or Account With Bank
 
     C                   Select
 
     C                   When      ACBT  =  'N' or BNCT = 'A'                   Nostro
      * Is beneficiary a Nostro ?
     C                   If        %Subst(BNC1:1:1) = '/'
     C                   Eval      C#CYCD  =  %Subst(BNC1:2:3)
     C                   Eval      C#NONB  =  %Subst(BNC1:5:2)
     C                   Else
     C                   Eval      C#CYCD  =  %Subst(BNC1:1:3)
     C                   Eval      C#NONB  =  %Subst(BNC1:4:2)
     C                   Endif
     C                   Exsr      Cust_Nost
     C                   If        C#Rtcd <> *Blanks
      * Then account with bank must be.
     C                   Eval      C#CYCD  =  PCCY
     C                   Eval      C#NONB  =  ACBK
     C                   Exsr      Cust_Nost
     C                   Endif
 
     C                   When      BNCT  =  'C'                                 Customer Number
     C                   Eval      DSCUST= BNC1
 
     C                   When      BNCT  =  'S'                                 Customer Shortname
     C                   Eval      C#Cnum = BNC1
     C                   Exsr      Cust_Sname
 
 
     C                   When      BNCT  =  'P' Or                              Partial GL Account
     C                             BNCT  =  'F'                                 Full GL Account
     C                   Eval      DSCUST= %Subst(BNC1:1:6)
 
     C                   When      BNCT  =  'I'                                 Iban Account
     C                   Eval      C#Iban = BNC1
     C                   Exsr      Cust_IBAN
 
     C                   Endsl
 
      * Request for Transfer Details
     C                   When      *In21
 
      * Save payment reference
     C                   Eval      DsPref = RFTID
 
      * Save payment type
     C                   Eval      WType = 'RI'
     C                   Eval      WTrnsid = Trnsid
 
      * Get incoming payments main details
     C     RftId         Chain     FT101HL3                           89
     C                   If        *In89
     C                   Eval      DBKey  =  RftId
     C                   Eval      DBFile = 'FT000659'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 7
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Load_Data'
     C                   Exsr      *PSSR
     C                   Endif
 
      * Save payment amount for formatting
     C                   Move      TRNAMT        ZFIELD
 
      * Move Currency Code
     C                   Eval      DSccy  =  PAYCCY
 
      * Now get customer details.  This is the BENEFICIARY customer of the incoming
      *  Request for Transfer.
 
     C                   Select
 
     C                   When      BENTTP =  'R'  Or                            Retail
     C                             BENTTP =  'N'  Or                            Nostro
     C                             BENTTP =  'G'                                Full GL Account
     C                   Eval      C#Acct = TBNA35
     C                   Exsr      Acc_101
 
     C                   When      BENTTP =  'C'                                Customer Number
     C                   Eval      DSCUST = TBNA35
 
     C                   When      BENTTP =  'S'                                Customer Shortname
     C                   Eval      C#Cnum = TBNA35
     C                   Exsr      Cust_Sname
 
     C                   When      BENTTP=  'I'                                 Iban Account
     C                   Eval      C#Iban = TBNA35
     C                   Exsr      Cust_IBAN
 
     C                   When      AWITTP=  'F'                                 Nostro
     C                   If        %Subst(TACA35:1:1) = '/'
     C                   Eval      C#CYCD  =  %Subst(TACA35:2:3)
     C                   Eval      C#NONB  =  %Subst(TACA35:5:2)
     C                   Else
     C                   Eval      C#CYCD  =  %Subst(TACA35:1:3)
     C                   Eval      C#NONB  =  %Subst(TACA35:4:2)
     C                   Endif
     C                   Exsr      Cust_Nost
 
     C                   When      AWITTP=  'R' Or                              Retail
     C                             AWITTP=  'G'                                 General Ledger
     C                   Eval      C#Acct = TACA35
     C                   Exsr      Acc_101
 
     C                   Endsl
 
      *
      * Customer Credit Transfers
      *
     C                   When      *In22
 
      * Save payment reference
     C                   Eval      DSPREF= CCTID
 
      * Save payment type
     C                   Eval      WType = 'BI'
     C                   Eval      WTrnsid = Trnsid
 
      * Get Customer Credit Transfer Main details
     C     CctId         Chain     FT102HL3                           89
     C                   If        *In89
     C                   Eval      DBKey  =  RftId
     C                   Eval      DBFile = 'FT000659'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 8
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Load_Data'
     C                   Exsr      *PSSR
     C                   Endif
 
      * Save payment amount for formatting
     C                   Move      CCTAMT        ZFIELD
 
      * Move Currency Code
     C                   Eval      DSccy  =  CCTCCY
 
      * Now get customer details.  This is the BENEFICIARY customer of the incoming
      *  Customer Credit Transfer.
 
     C                   Select
 
     C                   When      BENTTD =  'N' Or                             Nostro
     C                             BENTTD =  'R' Or                             Retail
     C                             BENTTD =  'G'                                Full GL Account
     C                   Eval      C#Acct = BENF1
     C                   Exsr      Acc_101
 
     C                   When      BENTTD =  'C'                                Customer Number
     C                   Eval      DSCUST = BENF1
 
     C                   When      BENTTD =  'S'                                Customer Shortname
     C                   Eval      C#Cnum = BENF1
     C                   Exsr      Cust_Sname
 
     C                   When      BENTTD=  'I'                                 Iban Account
     C                   Exsr      Cust_IBAN
 
     C                   When      AWITP =  'R' Or                              Retail
     C                             AWITP =  'G'                                 General Ledger
     C                   Eval      C#Acct = ACCI35
     C                   Exsr      Acc_101
 
     C                   When      AWITP =  'F'                                 Nostro
     C                   If        %Subst(ACCI35:1:1) = '/'
     C                   Eval      C#CYCD  =  %Subst(ACCI35:2:3)
     C                   Eval      C#NONB  =  %Subst(ACCI35:5:2)
     C                   Else
     C                   Eval      C#CYCD  =  %Subst(ACCI35:1:3)
     C                   Eval      C#NONB  =  %Subst(ACCI35:4:2)
     C                   Endif
     C                   Exsr      Cust_Nost
 
     C                   When      AWITP =  'I'                                 Iban Account
     C                   Eval      C#Iban = ACCI35
     C                   Exsr      Cust_IBAN
 
     C                   Endsl
 
     C                   Endsl
 
      * Get decimal positions of currency
     C                   CallB     'AOCURRR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm                    DSccy
     C     SDCURR        Parm      SDCURR        DSSDY
 
      *
      * The following need to be converted via ZEDIT
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   MOVE      ZFIELD        DSAMT
 
      * Save record type
     C                   Eval      DsType    = WType
     C                   Eval      DsTrnsid  = WTrnsid
 
      * Save customer number into array for later sort
     C                   MoveA     DSCUST        CustA(i)
 
     C                   Setoff                                       202122
     C                   Read      FTCusNL0                               40
     C                   Enddo
 
 
     C                   MoveA     CustA         CustB
 
     C                   SortA     CustA
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Cust_Sname : Get Customer ShortName                           *
      *                                                               *
      * Called by: Load_Data                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Cust_Sname    Begsr
 
     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm                    C#CNUM
     C                   Parm      *Blanks       C#KYST
     C     SDCUST        Parm      *Blanks       DSSDY
 
      * Database error ?
     C                   If        C#Rtcd <> *Blanks
     C                   Eval      DBKey  =  C#CNUM
     C                   Eval      DBFile = 'FT000659'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 3
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Cust_Sname'
     C                   Exsr      *PSSR
     C                   Endif
 
      * Save customer number
     C                   Eval      DsCust =  BBCUST
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Cust_Nost  : Get Customer Number from Nostro Code             *
      *                                                               *
      * Called by: Load_Data                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Cust_Nost     Begsr
 
     C                   CALLB     'AONOSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      *Blanks       C#CUST
     C                   Parm                    C#CYCD
     C                   Parm      *Blanks       C#ACCD
     C                   Parm      *Blanks       C#ACSN
     C                   Parm                    C#NONB
     C                   Parm      *Blanks       C#BRCA
     C                   Parm      *Blanks       C#CSSN
     C                   Parm      *Blanks       C#PNOI
     C     SDNOST        Parm      SDNOST        DSFDY
 
      * Save customer number
     C                   Eval      DsCust =  A7CUST
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Cust_IBAN  : Get Customer Number from IBAN Number             *
      *                                                               *
      * Called by: Load_Data                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Cust_IBAN     Begsr
 
     C                   CALLB     'AOIBANR2'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm                    C#IBAN
     C     Accnt         Parm      Accnt         DSSDY
 
      *  If error on call
     C                   If        C#RTCD <> *Blanks
     C                   Eval      DBKey  =  C#IBAN
     C                   Eval      DBFile = 'FT000659'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 4
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Cust_IBAN'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Movel     CNUM          DsCust
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Acc_101 - Determine Account for Mt101 and Mt102's             *
      *                                                               *
      * Called by: Load_Data                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Acc_101       Begsr
 
     C                   CallB     'AOACCTV1'
     C                   Parm                    C#Rtcd
     C                   Parm      *Blanks       C#Optn
     C                   Parm                    C#Acct
     C     Accnt         Parm      Accnt         DSSDY
 
 
      *  If error on call
     C                   If        C#RTCD <> *Blanks
     C                   Eval      DBKey  =  C#Acct
     C                   Eval      DBFile = 'FT000659'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 4
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Acc_101'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Movel     CNUM          DsCust
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Clr@Sf - Clear Subfile                                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr@Sf        Begsr
      * Clear Subfile
     C                   Seton                                          3031
     C                   Write     FT659C1
     C                   Setoff                                         3031
      *
      * Reset SFLRRN
     C                   Eval      Sflrrn = *Zero
     C                   Endsr
      *****************************************************************
      *                                                               *
      * Load@sf - Load subfile data                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SndMsg                                                 *
      *        Mov_Dta                                                *
      *                                                               *
      *****************************************************************
     C     Load@sf       Begsr
     C                   Setoff                                           32
 
      * If both positioner and selector entered, error message and
      *  end subroutine.  (Yes I know, I dont like tags either !)
     C                   If        CusPos  <>  *Blanks   and
     C                             CusSel  <>  *Blanks
     C                   Eval      Msgid = 'FTF3120'
     C                   Exsr      SndMsg
     C                   Goto      EndLoad
     C                   Endif
 
     C                   MoveA     CustA         SCustA
     C                   MoveA     CustB         SCustB
 
      *
      * Read Records from datastructure into subfile
      *
     C                   Eval      j = 1
     C     *Blanks       Lookup    CustA(j)                           89
     C                   Dow       j > 0 and CustA(j) <> *Blanks
     C                   Eval      k = 1
     C     CustA(j)      Lookup    CustB(k)                               89
 
     C     k             Occur     CustDs
 
     C                   If        CusPos = *Blanks    and
     C                             CusSel = *Blanks    or
     C                             CusPos = *Blanks    and
     C                             CusSel <> *Blanks   and
     C                             CusSel = DsCust     or
     C                             CusSel = *Blanks    and
     C                             CusPos <> *Blanks   and
     C                             CusPos <= DsCust
 
     C                   Eval      Sflrrn = Sflrrn + 1
 
     C                   Exsr      Mov_Dta
 
      * Clear arrays and save customer number for next occurrence
     C                   Move      *Blanks       CustA(j)
     C                   Move      *Blanks       CustB(k)
 
     C                   Write     FT659S1
 
     C                   Endif
 
     C                   Eval      j = j - 1
     C                   Enddo
 
      * Set cursor position to top of page
     C                   Eval      @@Rnc1 = 1
 
      *
      * Compare SFLRRN with 0 to see if there is anything to display
     C                   If        Sflrrn > 0
     C                   Eval      *in30 = *On
     C                   Else
     C                   Eval      Msgid = 'GEN0001'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   MoveA     SCustA        CustA
     C                   Movea     SCustB        CustB
 
     C     EndLoad       Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Mov_Dta - Move data to subfile                                *
      *                                                               *
      * Called by: Load@Sf                                            *
      *                                                               *
      * Calls: Load@Sf                                                *
      *                                                               *
      *****************************************************************
     C     Mov_Dta       Begsr
 
      *  Move data from datstructure to subfile display.  Put in selection / position
      *   conditions here.
     C                   Eval      WBBCUST =  DsCust
     C                   Eval      WPREF   =  DsPref
     C                   Eval      WAmt    =  DsAmt
     C                   Eval      Wccy    =  DsCcy
     C                   Eval      WType   =  DsType
     C                   Eval      WTrnsId =  DsTrnsId
 
     C                   Eval      C#CNum = CustA(j)
 
     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm                    C#CNUM
     C                   Parm      *Blanks       C#KYST
     C     SDCUST        Parm      *Blanks       DSSDY
 
     C                   Eval      WBBCNA1 = BBCNA1
      *
      *  Get Advice details from Customer Notification Criteria File.  If the record
      *   was written due to notification items in the message, display this instead.
      *   Notification IN = Details of Payment (DT1-4), RI = Instruction codes, BI =
      *   Sender to Receiver information.
      *
 
      *  Lookup to see if notification made.
     C                   Eval      ADVMTD = *Blanks
     C                   Eval      ADVNOT = *Blanks
     C                   Eval      NotString  = *Blanks
     C                   Eval      NotResult  = *Blanks
 
 
     C                   Select
     C                   When      WType     = 'IN'
     C     WPREF         Chain     Inpay                              87
     C                   Eval      NotString =   BBI1 + BBI2 + BBI3 + BBI4
     C                                         + BBI5 + BBI6
 
     C                   When      WType     = 'RI'
     C     WPREF         Chain     FTCusNL0                           87
     C                   Eval      NotString =   INSCA4 + INSCB4 + INSCC4
     C                                         + INSCD4 + INSCE4
 
     C                   When      WType     = 'BI'
     C     WPREF         Chain     FT102HL3                           87
     C                   Eval      NotString =   ADNLI1 + ADNLI2 + ADNLI3
     C                                         + ADNLI4 + ADNLI5
 
     C                   Endsl
 
      * Now call module to see if notification found.
     C                   CallB     'FTVNCWD'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    NotString
     C                   Parm                    NotResult
     C                   Parm                    CodeWord
 
     C                   If        NotResult = 'N'
 
     C                   If        WType = 'IN' or WType = 'BI'
     C                   Eval      WADVMTD = 'Field :72:'
     C                   Else
     C                   Eval      WADVMTD = 'Field :23:'
     C                   Endif
 
     C                   Eval      WADVNOT =  CodeWord
     C                   Else
 
     C                   Eval      CUSMER = CustA(j)
     C     CusMer        Chain     FTCNCL0                            89
     C                   Eval      WADVMTD  = ADVMTD
     C                   Eval      WADVNOT =  ADVNOT
 
     C                   Endif
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Prc@Sf  - Process Subfile                                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Prc@Sf        Begsr
 
      *
      * Read subfile for any subfile select records
     C                   Eval      *In33 = *Off
     C                   Readc     FT659S1                                33
     C                   Dow       *In33 = *Off
 
     C                   Select
      * Amend Payment
     C     Sflsel        Wheneq    'A'
     C                   Select
 
      * Incoming Payments
     C                   When      WType = 'IN'
     C                   Call      'FTC0050'
     C                   Parm      'A'           ActCode
     C                   Parm                    WPref
     C                   Parm                    RtCode
     C                   Parm      'Y'           WLink
 
     C                   When      WType = 'RI'
     C************       CallB     'FTM101SIN'                                                CPK014
     C                   Call      'FTM101SIN'                                                CPK014
     C                   Parm      *Blanks       ME1200            1
     C                   Parm      *Blanks       MsgRef            8
     C                   Parm                    MSGPRT            3
     C                   Parm                    WPref                                        222373
     C                   Parm      'A'           ActCode
 
     C                   When      WType = 'BI'
     C************       CallB     'FTM102SIN'                                                CPK014
     C                   Call      'FTM102SIN'                                                CPK014
     C                   Parm      *Blanks       ME1200            1
     C                   Parm      *Blanks       MsgRef            8
     C                   Parm                    MSGPRT            3                          222373
     C                   Parm                    WPref
     C                   Parm      'A'           ActCode
 
     C                   Endsl
 
      * Enquire on Payment
     C     Sflsel        Wheneq    'E'
     C                   Select
 
      * Incoming Payments
     C                   When      WType = 'IN'
     C                   Call      'FTC0050'
     C                   Parm      'E'           ActCode
     C                   Parm                    WPref
     C                   Parm                    RtCode
     C                   Parm      'Y'           WLink
 
     C                   When      WType = 'RI'
     C************       CallB     'FTM101SIN'                                                CPK014
     C                   Call      'FTM101SIN'                                                CPK014
     C                   Parm      *Blanks       ME1200            1
     C                   Parm      *Blanks       MsgRef            8
     C                   Parm                    MSGPRT            3                          222373
     C                   Parm                    WPref
     C                   Parm      'E'           ActCode
 
     C                   When      WType = 'BI'
     C************       CallB     'FTM102SIN'                                                CPK014
     C                   Call      'FTM102SIN'                                                CPK014
     C                   Parm      *Blanks       ME1200            1
     C                   Parm      *Blanks       MsgRef            8
     C                   Parm                    MSGPRT            3                          222373
     C                   Parm                    WPref
     C                   Parm      'E'           ActCode
     C                   Endsl
 
      * Update notification table
     C     Sflsel        Wheneq    'X'
 
      * Ensure Reload
     C                   Eval      Reload = 'Y'
 
     C                   Select
 
     C                   When      WType = 'IN'
     C     WPref         Chain     Inpayxl3                           97
     C                   Eval      CUNFLG = 'Y'
     C                   Update    L3PD
 
     C                   When      WType = 'RI'
     C     M@Key         Chain     FT101DL5                           97
     C                   Eval      CUNOFL = 'Y'
     C                   Update    L4MT101
 
     C                   When      WType = 'BI'
     C     M@Key         Chain     FT102DL3                           97
     C                   Eval      CUSTNF = 'Y'
     C                   Update    L2MT102
 
     C                   Endsl
      *
      * If subfile select != 1 then Error Message
     C                   Other
     C     SflSel        Ifne      *BLANK
     C                   Eval      *in34 = *On
     C                   Eval      MsgDta = SflSel
     C                   Eval      Msgid = 'FTM1001'
     C                   Exsr      SndMsg
     C                   Eval      *in43 = *On
     C     SflRrn        Chain     FT659S1                            44
     C                   Update    FT659S1
     C                   Endif
      *
     C                   Endsl
      *
     C     SflRrn        Chain     FT659S1                            44
     C                   Eval      *In43  = *Off
     C                   Eval      SflSel = *Blank
     C                   Update    FT659S1
 
     C                   Readc     FT659S1                                33
     C                   Enddo
     C                   Endsr
      *****************************************************************
      *                                                               *
      * SndMsg - Send Program Message                                 *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SndMsg        Begsr
      *
      * Only write message if requested
     C                   If        Msgid <> *Blanks
     C                   CallB     'AOCREPT'
     C                   Parm                    Msgid
     C                   Parm                    Msgf
     C                   Parm                    MsgLib
     C                   Parm                    MsgDta
     C                   Parm                    MsgRel
     C                   Parm                    #Pgm
     C                   PARM      *Blanks       FTMSGQ           10
     C                   PARM      *Blanks       FTMSGT            7
     C                   Endif
      *
      * Reset message Id
     C                   Reset                   Msgds
     C                   Endsr
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
 
     C                   Eval      #Pgm = PsProcPgm
 
     C     M@Key         Klist
     C                   Kfld                    Wpref
     C                   Kfld                    WTrnsId
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
