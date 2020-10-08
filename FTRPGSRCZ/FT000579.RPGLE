     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Customer Notification Reports')               *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer module                                *
      *                                                               *
      *  FT000579   - Customer Notification Report                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 25May00               *
      *                                    Date DDMmmYY               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
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
      *  CFT009 - Funds Transfer Fees and Charge Development          *
      *                                                               *
      *****************************************************************

      * Customer Notification File
     FFTCusNL0  IF   E           K Disk

      * Incoming Payments Main Details File
     FINPAY     IF   E           K Disk

      * Request for Transfer main details file
     FFT101HL3  IF   E           K Disk

      * Customer Credit Transfers main details file
     FFT102HL3  IF   E           K Disk

      * Customer Notification
     FFTCNCL0   IF   E           K Disk

      * Printer File
     FFT000579P1O    E             Printer OflInd(*In01) Infds(DS579)
     FFT000579AUO    E             Printer OflInd(*In02) Infds(AU579)

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
     DDS579            DS
     D  SFName                83     92
     D  SFnum                123    124B 0

     DAU579            DS
     D  SFNameAU              83     92
     D  SFnumAU              123    124B 0

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

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

      ** Title array
     D @TitA           S             50    DIM(2) CTDATA
     D @TitB           S             50    DIM(2) CTDATA

      ** Multiple Occurence Data Structure to hold customer details (Sort)
     DCUSTDS           DS                  OCCURS(9999)
     D  WCUST                              Like(WBBCUST)
     D  WPREF                              Like(WINPREF)
     D  WAMTA                              Like(WAMT)
     D  WCCYA                              Like(WCCY)
     D  WNotDat                            Like(DATNOE)

      * Array to sort datastructure
     DCustA            S              6    Dim(9999)  Descend
     DCustB            S              6    Dim(9999)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      * Parameters for ZSFILE
     D  Zseq           S                   Like(@RSEQ)
     D  ZEntP1         S              3
     D  ZSName         S             10
     D  ZSNum          S              6  0
     D  ZSErr          S              1

      * Details written ?
     D  RptDtl         S              1

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

      * Occurrence
     D  I              S              5  0
     D  J              S                   Like(I)
     D  K              S                   Like(I)

     D  SavCust        S                   Like(BBCUST)

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      * Set indicators for file format read
     IINPAYXDF      30
     IFT101DD0      31
     IFT102DD0      32

      ** Rename Field
     IFT102HD0
     I              SINST                       SINSTX
      *****************************************************************
      /EJECT
      *****************************************************************
      *                     INDICATOR  USAGE                          *
      *                                                               *
      * 01 : Printer Overflow                                         *
      * 30 : Incoming Payments Record Read                            *
      * 31 : Request for Transfer Record Read                         *
      * 32 : Customer Credit Transfer Record Read                     *
      * 97 : General Chain Indicator                                  *
      * 98 : Read detail records (EOF)                                *
      * 99 : Read Header Details (EOF)                                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      * Read all customer notification records.  Determine if incoming,
      *  request for transfer or customer credit transfer.
      *  Get appropriate details from main files and print.

     C                   Read      FTCusNL0                               99
     C                   Dow       *In99 = *Off
     C                   Exsr      Mov_Dtl

     C                   Setoff                                       303132

     C                   Read      FTCusNL0                               99
     C                   Enddo

     C                   Exsr      Wrt_Rep

     C                   If        RptDtl = 'Y'
     C                   Write     Trl579
     C                   Else
     C                   Eval      *In01 = *On
     C                   Exsr      HdrOfl
     C                   Write     NoDetl
     C                   Endif

     C                   Eval      *InLR = *On

     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * HdrOfl   - Print Header Format                                *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     HdrOfl        Begsr

     C                   If        *In01
     C                   Add       1             PageNo
     C                   Write     Hdr579
     C                   Eval      *In01 = *Off
     C                   Endif

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Clr_Dtl  - Clear Detail Printer Format                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr_Dtl       Begsr

     C                   Eval      WBBCUST  = *Blanks
     C                   Eval      WBBCNA1  = *Blanks
     C                   Eval      WINPREF  = *Blanks
     C                   Eval      WAMT     = *Blanks
     C                   Eval      WCCY     = *Blanks
     C                   Eval      WADVMTD  = *Blanks
     C                   Eval      WADVNOT  = *Blanks

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Mov_Dtl  - Move Data to Printer Detail Format                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Mov_Dtl       Begsr

      *  Move data to datastructure
     C                   Add       1             i
     C     i             Occur     CustDS

     C                   Select
      * Incoming Payments
     C                   When      *In30

      * Save payment reference
     C                   Eval      WPref = INPREF

      * Save advice notified date
     C                   Eval      WNotDat = DATNOE

      * Get incoming payments main details
     C     INPREF        Chain     Inpay                              89
     C                   If        *In89
     C                   Eval      DBKey  =  InPref
     C                   Eval      DBFile = 'FT000579'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 1
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Mov_Dtl'
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif

      * Save payment amount for formatting
     C                   Move      PYAM          ZFIELD

      * Move Currency Code
     C                   Eval      WccyA  =  PCCY

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
     C                   Eval      WCUST = BNC1

     C                   When      BNCT  =  'S'                                 Customer Shortname
     C                   Eval      C#Cnum = BNC1
     C                   Exsr      Cust_Sname


     C                   When      BNCT  =  'P' Or                              Partial GL Account
     C                             BNCT  =  'F'                                 Full GL Account
     C                   Eval      WCUST = %Subst(BNC1:1:6)

     C                   When      BNCT  =  'I'                                 Iban Account
     C                   Eval      C#Iban = BNC1
     C                   Exsr      Cust_IBAN

     C                   Endsl

      * Request for Transfer Details
     C                   When      *In31

      * Save payment reference
     C                   Eval      WPref = RFTID

      * Save advice notified date
     C                   Eval      WNotDat = DTNOEN

      * Get incoming payments main details
     C     RftId         Chain     FT101HL3                           89
     C                   If        *In89
     C                   Eval      DBKey  =  RftId
     C                   Eval      DBFile = 'FT000579'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 2
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Mov_Dtl'
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif

      * Save payment amount for formatting
     C                   Move      TRNAMT        ZFIELD

      * Move Currency Code
     C                   Eval      WccyA  =  PAYCCY

      * Now get customer details.  This is the BENEFICIARY customer of the incoming
      *  Request for Transfer.

     C                   Select

     C                   When      BENTTP =  'R'  Or                            Retail
     C                             BENTTP =  'N'  Or                            Nostro
     C                             BENTTP =  'G'                                Full GL Account
     C                   Eval      C#Acct = TBNA35
     C                   Exsr      Acc_101

     C                   When      BENTTP =  'C'                                Customer Number
     C                   Eval      WCUST  = TBNA35

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
     C                   When      *In32

      * Save payment reference
     C                   Eval      WPref = CCTID

      * Save advice notified date
     C                   Eval      WNotDat = DATNNT

      * Get Customer Credit Transfer Main details
     C     CctId         Chain     FT102HL3                           89
     C                   If        *In89
     C                   Eval      DBKey  =  RftId
     C                   Eval      DBFile = 'FT000579'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 3
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Mov_Dtl'
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif

      * Save payment amount for formatting
     C                   Move      CCTAMT        ZFIELD

      * Move Currency Code
     C                   Eval      WccyA  =  CCTCCY

      * Now get customer details.  This is the BENEFICIARY customer of the incoming
      *  Request for Transfer.

     C                   Select

     C                   When      BENTTD =  'N' Or                             Nostro
     C                             BENTTD =  'R' Or                             Retail
     C                             BENTTD =  'G'                                Full GL Account
     C                   Eval      C#Acct = BENF1
     C                   Exsr      Acc_101

     C                   When      BENTTD =  'C'                                Customer Number
     C                   Eval      WCUST  = BENF1

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
     C                   Parm                    WccyA
     C     SDCURR        Parm      SDCURR        DSSDY

      *
      * The following need to be converted via ZEDIT
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   MOVE      ZFIELD        WAmtA


      * Save customer number into array for later sort
     C                   MoveA     Wcust         CustA(i)

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Cust_Sname : Get Customer ShortName                           *
      *                                                               *
      * Called by: Mov_Dtl                                            *
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
     C                   Eval      DBFile = 'FT000579'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 4
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Cust_Sname'
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif

      * Save customer number
     C                   Eval      WCust  =  BBCUST

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Cust_Nost  : Get Customer Number from Nostro Code             *
      *                                                               *
      * Called by: Mov_Dtl                                            *
      *                                                               *
      * Calls: Cust_None                                              *
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
     C                   Eval      WCust  =  A7CUST

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Cust_IBAN  : Get Customer Number from IBAN Number             *
      *                                                               *
      * Called by: Mov_Dtl                                            *
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
     C                   Eval      DBFile = 'FT000579'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 5
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Cust_IBAN'
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif

     C                   Movel     CNUM          WCust

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Acc_101 - Determine Account for Mt101 and Mt102's             *
      *                                                               *
      * Called by: Main processing                                    *
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
     C                   Eval      DBFile = 'FT000579'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 6
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = 'Acc_101'
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif

     C                   Movel     CNUM          WCust

     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Wrt_Rep - Write Report                                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Wrt_Rep       Begsr

      *
      ** Have loaded all data into the multiple occurrence data structure.
      ** Sort data structure via array.
      **
      ** Read all records in array, get data from datastructure and report.
      ** This is where any report selection take place.
      **
      *

     C                   MoveA     CustA         CustB

     C                   SortA     CustA

     C                   Eval      j = 1
     C     *Blanks       Lookup    CustA(j)                           89

     C                   Dow       j > 0

      * Clear Report Details
     C                   Exsr      Clr_dtl

      * Check overflow indicator
     C                   Exsr      HdrOfl

     C                   Eval      k = 1
     C     CustA(j)      Lookup    CustB(k)                               89

     C     k             Occur     Custds

     C                   Eval      WBBCUST  =  WCust
     C                   Eval      WINPREF  =  WPref
     C                   Eval      WAMT     =  WAmtA
     C                   Eval      WCCY     =  WCcyA

      * If change in customer, write blank line and get new customer name.
     C                   If        CustA(j) <> SavCust
     C                   Write     Blk579

     C                   Eval      C#CNum = CustA(j)

     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm                    C#CNUM
     C                   Parm      *Blanks       C#KYST
     C     SDCUST        Parm      *Blanks       DSSDY

     C                   Eval      WBBCNA1 = BBCNA1

     C                   Else

     C                   Eval      WBBCUST = *Blanks
     C                   Eval      WBBCNA1 = *Blanks

     C                   Endif

      *
      *  Get Advice details from Customer Notification Criteria File
      *
     C                   Eval      CUSMER = CustA(j)
     C     CusMer        Chain     FTCNCL0                            89
     C                   If        *In89
     C                   Eval      ADVMTD = *Blanks
     C                   Eval      ADVNOT = *Blanks
     C                   Else
     C                   Eval      WADVMTD  = ADVMTD
     C                   Eval      WADVNOT =  ADVNOT
     C                   Endif

      * Clear arrays and save customer number for next occurrence
     C                   Eval      SavCust =     CustA(j)
     C                   Move      *Blanks       CustA(j)
     C                   Move      *Blanks       CustB(k)

      * If report required = Advised today and notified date = todays date, report
      *  else do not report
     C                   If        @Report = 'O' or
     C                             @Report = 'A' and WNotDat = BJRDNB

     C                   Eval      RptDtl = 'Y'

     C                   Write     Dtl579
     C                   Endif

     C                   Sub       1             j
     C                   Enddo

     C                   Endsr
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

     C     *INZSR        BEGSR

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C     *Entry        Plist
     C                   Parm                    PARM1             1
     C                   Parm                    @RSEQ             5
     C                   Parm                    @RLEV             1
     C                   Parm                    @RENT             3
     C                   Parm                    @Report           1

      *
      ** Setup ZSFILE : List
      *
     C                   Eval      Zseq = @Rseq

     C                   Eval      ZSNum  = SFNum
     C                   Eval      ZSName = SFName

     C                   Call      'ZSFILE'
     C                   Parm                    ZSeq
     C                   Parm      *BLANKS       ZEntP1
     C                   Parm                    ZSName
     C                   Parm                    ZSNum
     C                   Parm      *BLANKS       ZSerr

     C                   If        ZSerr = 'Y'
     C                   Eval      *INU7 = *On
     C                   Eval      *INU8 = *On
     C                   Eval      *INLR = *On
     C     *Lock         In        LDA
     C                   Eval      DBPgm = 'FT000579'
     C                   Eval      DBKey = 'FT000579P1'
     C                   Eval      DBFILE = 'ZSFILE'
     C                   Eval      DBase = 7
     C                   Out       LDA
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Return
     C                   Endif

      *
      ** Setup ZSFILE : Audit
      *
     C                   Eval      Zseq = @Rseq

     C                   Eval      ZSNum  = SFNum
     C                   Eval      ZSName = SFName

     C                   Call      'ZSFILE'
     C                   Parm                    ZSeq
     C                   Parm      *BLANKS       ZEntP1
     C                   Parm                    ZSName
     C                   Parm                    ZSNum
     C                   Parm      *BLANKS       ZSerr

     C                   If        ZSerr = 'Y'
     C                   Eval      *INU7 = *On
     C                   Eval      *INU8 = *On
     C                   Eval      *INLR = *On
     C     *Lock         In        LDA
     C                   Eval      DBPgm = 'FT000579'
     C                   Eval      DBKey = 'FT000579P1'
     C                   Eval      DBFILE = 'ZSFILE'
     C                   Eval      DBase = 8
     C                   Out       LDA
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Return
     C                   Endif
      *
      ** Get Report Header and date
      *
     C                   CallB     'AOBANKR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*FIRST   '   @optn
     C     Sdbank        Parm      Sdbank        Dsfdy

     C                   If        @rtcd <> *Blanks
     C     *Lock         In        LDA
     C                   Eval      dbfile = 'SDBANKPD'
     C                   Eval      dbase = 9
     C                   Eval      dbkey = '*FIRST'
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif

      * Determine report title
     C                   If        @Report = 'O'
     C                   Eval      WTIT1 = @TitA(1)
     C                   Eval      WTIT2 = @TitB(1)
     C                   Else
     C                   Eval      WTIT1 = @TitA(2)
     C                   Eval      WTIT2 = @TitB(2)
     C                   Endif

      * Ensure header is written
     C                   Eval      *In01 = *On


     C                   ENDSR                                                  *** InzEnd ***

      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  @TitA
OUTSTANDING ADVICE NOTIFICATION BY CUSTOMER
ADVICE NOTIFICATIONS MADE TODAY
**  @TitB
-------------------------------------------
-------------------------------
