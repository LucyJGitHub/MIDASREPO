     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB Get Funds Transfer full settlement A/C')   *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  RP1431 - Get Funds Transfer full settlement account          *
      *                                                               *
      *  Function: this module allows to get full settlement          *
      *            account from A/C with Bank or Customer.            *
      *                                                               *
      *  Component of: RP1431 - Get FT full settlement account        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG15105C          Date 06Nov07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG15105A          Date 25Oct07               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG15105C - Missing Process for SWIFT 2007 (Reopen)          *
      *  BUG15105A - Missing Process for SWIFT 2007 (Reopen)          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  77  -  Resulting indicator on CHECKR operation.              *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *                  *************************                    *
      *                  ** INDICATORS NOT USED **                    *
      *                  *************************                    *
      *                                                               *
      *       ***************************************************     *
      *       * 01   02   03   04   05   06   07   08   09   10 *     *
      *       * 11   12   13   14   15   16   17   18   19   20 *     *
      *       * 21   22   23   24   25   26   27   28   29   30 *     *
      *       * 31   32   33   34   35   36   37   38   39   40 *     *
      *       * 41   42   43   44   45   46   47   48   49   50 *     *
      *       * 51   52   53   54   55   56   57   58   59   60 *     *
      *       * 61   62   63   64   65   66   67   68   69   70 *     *
      *       * 71   72   73   74   75   76   xx   78   79   80 *     *
      *       * 81   82   83   84   85   86   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   98   99      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  #Nostro  - Access to Nostro Details.                         *
      *  #Account - Access to Master Account Details.                 *
      *  *Pssr    - Program exception error routine.                  *
      *  *Inzsr   - Program Initialisation routine.                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /Eject
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Midas Local Data Area for database error reporting; based on
      **  external file.
     D Lda           E DS           256    Extname(LDA) Dtaara(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  Array containing Copyright statement.
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      **  External Data structure for Run Date Informations.
     D RUNDAT        E DS                  Extname(RUNDAT) Dtaara
 
      **  Data structure used to split Ordering Bank or Ordering Customer.
     D***W_Ordering      DS            18                                                     CGL029
     D*W_Ordering***   DS            24                                             CGL029 BUG15105A
     D W_Ordering      DS            35                                                    BUG15105A
     D  W_Nostro1             01     02
     D  W_Dummy               03     12
     D  W_Currency            01     03
     D  W_Nostro2             04     05
     D  W_RetNumber           01     10
     D  W_CustNumber1         01     06
     D***W_AccCode1            07     10                                                      CGL029
     D***W_AccSeq1             11     12                                                      CGL029
     D***W_BranchCode1         13     15                                                      CGL029
     D  W_AccCode1            07     16                                                       CGL029
     D  W_AccSeq1             17     18                                                       CGL029
     D  W_BranchCode1         19     21                                                       CGL029
     D  W_CustNumber2         01     06
     D  W_Currency2           07     09
     D***W_AccCode2            10     13                                                      CGL029
     D***W_AccSeq2             14     15                                                      CGL029
     D***W_BranchCode2         16     18                                                      CGL029
     D  W_AccCode2            10     19                                                       CGL029
     D  W_AccSeq2             20     21                                                       CGL029
     D  W_BranchCode2         22     24                                                       CGL029
 
      **  Data structure used to set up DBKEY when access to
      **  Account Master Details File fails.
     D***W_DbKey         DS            18                                                     CGL029
     D W_DbKey         DS            24                                                       CGL029
     D
     D  W_DbBranch            01     03
     D  W_DbCustomer          04     09
     D  W_DbCurrency          10     12
     D***W_DbAccCode           13     16                                                      CGL029
     D***W_DbAccSequ           17     18                                                      CGL029
     D  W_DbAccCode           13     22                                                       CGL029
     D  W_DbAccSequ           23     24                                                       CGL029
     D  W_DbRetailNum         01     10
 
      **  Data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      **  Data structure for Nostro Details.
     D Sdnost        E DS                  Extname(SDNOSTPD)
 
      **  Data structure for Account Details.
     D Accnt         E DS                  Extname(ACCNTAB)
 
      **  First DS for access programs, long data structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
      **  Second DS for access programs, short data structure.
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **------------------- Start of parameters ---------------------**
      **  ------
      **  Inputs
      **  ------
      **  Transaction branch.
     D P_OrderingCust  S             35A
      **  Transaction branch.
     D P_OrderingBank  S             35A
      **  -------
      **  Outputs
      **  -------
      **  Branch Code.
     D P_BranchCode    S              3A
      **  Customer Number.
     D*P_CustNumber    S              6S 0                                                    CSD027
     D P_CustNumber    S              6A                                                      CSD027
      **  Currency.
     D P_Currency      S              3A
      **  Account Code.
     D***P_AccountCode   S              4S 0                                                  CGL029
     D P_AccountCode   S             10S 0                                                    CGL029
      **  Account Sequence.
     D P_AccountSeq    S              2S 0
      **  Return Code.
     D P_ReturnCode    S             10A
      **------------- End of parameters for ZAGETSETAC --------------**
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Customer Number.
     D P_Cust          S              6A
      **  Currency.
     D P_Ccy           S              3A
      **  Account Code.
     D***P_Code          S              4A                                                    CGL029
     D P_Code          S             10A                                                      CGL029
      **  Account Sequence.
     D P_Sequ          S              2A
      ** Nostro Number.
     D P_Nonb          S              2A
      **  Branch Code.
     D P_Brca          S              3A
      **  Customer Shortname.
     D P_Cssn          S             10A
      **  Prime Nostro Indicator.
     D P_Pnoi          S              1A
      **  Retail Number.
     D P_Retl          S             10A
      **  IBAN                                                                             BUG15105A
     D P_IBAN          S             34A                                                   BUG15105A
      ** ---------- End of fields used by access programs -----------**
 
      **  Work field used to determine account length.
     D W_AccLength     S              2  0
 
      **  True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /Eject
      *****************************************************************
     C     Start         Tag
 
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *inzsr is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
 
      **  If neither Ordering Customer nor Ordering Bank are filled.
     C     P_OrderingBankIfeq      *blanks                                      Begin P_OrderingBank
     C     P_OrderingCustAndeq     *blanks
     C                   Eval      P_ReturnCode = '*Error'
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End P_OrderingBank
 
      **-------------------------------------------------------------**
      **  If Ordering Bank is not blanks, Account must be got from   **
      **  Ordering Customer.                                         **
      **-------------------------------------------------------------**
 
     C     P_OrderingBankIfeq      *blanks                                      Begin P_OrderingBank
     C                   Eval      W_Ordering = P_OrderingCust
 
     C                   Eval      W_AccLength = 35
     C     ' '           Checkr    P_OrderingCustW_AccLength              77
                                                                                           BUG15105A
      ** Check if IBAN                                                                     BUG15105A
     C                   Exsr      #IBAN                                                   BUG15105A
     C                   If        P_Rtcd <> *Blanks                                       BUG15105A
 
     C                   Select                                                 Begin Select
 
     C*****W_AccLength   Wheneq    18                                           Full Account  CGL029
     C     W_AccLength   Wheneq    24                                                         CGL029
     C     AGMBIN        Andeq     'Y'                                          Multi-branch
     C                   Eval      P_Retl = *Blanks
     C                   Eval      P_Cust = W_CustNumber2
     C                   Eval      P_Ccy  = W_Currency2
     C                   Eval      P_Code = W_AccCode2
     C                   Eval      P_Sequ = W_AccSeq2
     C                   Eval      P_Brca = W_BranchCode2
 
     C*****W_AccLength   Wheneq    15                                           Full Account  CGL029
     C     W_AccLength   Wheneq    21                                                         CGL029
     C     AGMBIN        Andeq     'N'                                          Single-branch
     C                   Eval      P_Retl = *Blanks
     C                   Eval      P_Cust = W_CustNumber2
     C                   Eval      P_Ccy  = W_Currency2
     C                   Eval      P_Code = W_AccCode2
     C                   Eval      P_Sequ = W_AccSeq2
     C                   Eval      P_Brca = BJSBRC
 
     C*****W_AccLength   Wheneq    15                                           Partial AccounCGL029
     C     W_AccLength   Wheneq    21                                                         CGL029
     C     AGMBIN        Andeq     'Y'                                          Multi-branch
     C                   Eval      P_Retl = *Blanks
     C                   Eval      P_Cust = W_CustNumber1
     C                   Eval      P_Ccy  = P_Currency
     C                   Eval      P_Code = W_AccCode1
     C                   Eval      P_Sequ = W_AccSeq1
     C                   Eval      P_Brca = W_BranchCode1
 
     C*****W_AccLength   Wheneq    12                                           Partial AccounCGL029
     C     W_AccLength   Wheneq    18                                                         CGL029
     C     AGMBIN        Andeq     'N'                                          Single branch
     C                   Eval      P_Retl = *Blanks
     C                   Eval      P_Cust = W_CustNumber1
     C                   Eval      P_Ccy  = P_Currency
     C                   Eval      P_Code = W_AccCode1
     C                   Eval      P_Sequ = W_AccSeq1
     C                   Eval      P_Brca = BJSBRC
 
     C     W_AccLength   Wheneq    10                                           Retail Number
     C                   Eval      P_Retl = W_RetNumber
     C                   Eval      P_Cust = *blanks
     C                   Eval      P_Ccy  = *blanks
     C                   Eval      P_Code = *blanks
     C                   Eval      P_Sequ = *blanks
     C                   Eval      P_Brca = *blanks
 
     C     W_AccLength   Wheneq    5                                            Nostro Number
     C                   Eval      P_Retl = *Blanks
     C                   Eval      P_Cust = *Blanks
     C                   Eval      P_Ccy  = *Blanks
     C                   Eval      P_Code = *Blanks
     C                   Eval      P_Sequ = *Blanks
     C                   Eval      P_Brca = *Blanks
     C                   Eval      P_Ccy  = W_Currency
     C                   Eval      P_Nonb = W_Nostro2
 
      **  Get Nostro Details.
     C                   Exsr      #Nostro
 
     C                   Eval      P_Cust = A7CUST
     C                   Eval      P_Ccy  = A7CYCD
     C                   Eval      P_Code = A7ACCD
     C                   Move      A7ACSN        P_Sequ
     C                   Eval      P_Brca = A7BRCD
 
     C     W_AccLength   Wheneq    2                                            Nostro Number
     C                   Eval      P_Retl = *Blanks
     C                   Eval      P_Cust = *Blanks
     C                   Eval      P_Ccy  = *Blanks
     C                   Eval      P_Code = *Blanks
     C                   Eval      P_Sequ = *Blanks
     C                   Eval      P_Brca = *Blanks
     C                   Eval      P_Ccy  = P_Currency
     C                   Eval      P_Nonb = W_Nostro1
 
      **  Get Nostro Details.
     C                   Exsr      #Nostro
 
     C                   Eval      P_Cust = A7CUST
     C                   Eval      P_Ccy  = A7CYCD
     C                   Eval      P_Code = A7ACCD
     C                   Move      A7ACSN        P_Sequ
     C                   Eval      P_Brca = A7BRCD
 
      **  If wrong setup of Ordering Customer.
     C                   Other                                                  Error
 
     C     *Lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbkey  = *blanks
     C                   Eval      Dbfile = '*Param'                            ***************
     C                   Eval      Dbkey  = P_OrderingCust                      * Db Error 01 *
     C                   Eval      Dbase  = 01                                  ***************
     C                   Out       Lda
     C                   Eval       P_ReturnCode =  '*OrderCust'
     C                   Exsr      *Pssr
 
     C                   Endsl                                                  End Select
 
     C                   EndIf                                                             BUG15105C
     C                   Goto      @Account
 
      **-------------------------------------------------------------**
      **  Else, Account must be got from Ordering Bank.               *
      **-------------------------------------------------------------**
 
      **********                                                                 BUG15105A BUG15105C
     C**********         EndIf                                                   BUG15105A BUG15105C
     C                   Endif                                                  End P_OrderingBank
 
     C                   Eval      W_Ordering = P_OrderingBank
     C                   Eval      W_AccLength = 35
     C     ' '           Checkr    P_OrderingBankW_AccLength              77
 
     C                   Select                                                 Begin Select
 
     C*****W_AccLength   Wheneq    18                                           Full Account  CGL029
     C     W_AccLength   Wheneq    24                                                         CGL029
     C     AGMBIN        Andeq     'Y'                                          Multi-branch
     C                   Eval      P_Retl = *Blanks
     C                   Eval      P_Cust = W_CustNumber2
     C                   Eval      P_Ccy  = W_Currency2
     C                   Eval      P_Code = W_AccCode2
     C                   Eval      P_Sequ = W_AccSeq2
     C                   Eval      P_Brca = W_BranchCode2
 
     C*****W_AccLength   Wheneq    15                                           Full Account  CGL029
     C     W_AccLength   Wheneq    21                                                         CGL029
     C     AGMBIN        Andeq     'N'                                          Single-branch
     C                   Eval      P_Retl = *Blanks
     C                   Eval      P_Cust = W_CustNumber2
     C                   Eval      P_Ccy  = W_Currency2
     C                   Eval      P_Code = W_AccCode2
     C                   Eval      P_Sequ = W_AccSeq2
     C                   Eval      P_Brca = BJSBRC
 
     C*****W_AccLength   Wheneq    15                                           Partial AccounCGL029
     C     W_AccLength   Wheneq    21                                                         CGL029
     C     AGMBIN        Andeq     'Y'                                          Multi-branch
     C                   Eval      P_Retl = *Blanks
     C                   Eval      P_Cust = W_CustNumber1
     C                   Eval      P_Ccy  = P_Currency
     C                   Eval      P_Code = W_AccCode1
     C                   Eval      P_Sequ = W_AccSeq1
     C                   Eval      P_Brca = W_BranchCode1
 
     C*****W_AccLength   Wheneq    12                                           Partial AccounCGL029
     C     W_AccLength   Wheneq    18                                                         CGL029
     C     AGMBIN        Andeq     'N'                                          Single branch
     C                   Eval      P_Retl = *Blanks
     C                   Eval      P_Cust = W_CustNumber1
     C                   Eval      P_Ccy  = P_Currency
     C                   Eval      P_Code = W_AccCode1
     C                   Eval      P_Sequ = W_AccSeq1
     C                   Eval      P_Brca = BJSBRC
 
     C     W_AccLength   Wheneq    10                                           Retail Number
     C                   Eval      P_Retl = W_RetNumber
     C                   Eval      P_Cust = *blanks
     C                   Eval      P_Ccy  = *blanks
     C                   Eval      P_Code = *blanks
     C                   Eval      P_Sequ = *blanks
     C                   Eval      P_Brca = *blanks
 
     C     W_AccLength   Wheneq    5                                            Nostro Number
     C                   Eval      P_Retl = *Blanks
     C                   Eval      P_Cust = *Blanks
     C                   Eval      P_Ccy  = *Blanks
     C                   Eval      P_Code = *Blanks
     C                   Eval      P_Sequ = *Blanks
     C                   Eval      P_Brca = *Blanks
     C                   Eval      P_Ccy  = W_Currency
     C                   Eval      P_Nonb = W_Nostro2
 
      **  Get Nostro Details.
     C                   Exsr      #Nostro
 
     C                   Eval      P_Cust = A7CUST
     C                   Eval      P_Ccy  = A7CYCD
     C                   Eval      P_Code = A7ACCD
     C                   Move      A7ACSN        P_Sequ
     C                   Eval      P_Brca = A7BRCD
 
     C     W_AccLength   Wheneq    2                                            Nostro Number
     C                   Eval      P_Retl = *Blanks
     C                   Eval      P_Cust = *Blanks
     C                   Eval      P_Ccy  = *Blanks
     C                   Eval      P_Code = *Blanks
     C                   Eval      P_Sequ = *Blanks
     C                   Eval      P_Brca = *Blanks
     C                   Eval      P_Ccy  = P_Currency
     C                   Eval      P_Nonb = W_Nostro1
 
      **  Get Nostro Details.
     C                   Exsr      #Nostro
 
     C                   Eval      P_Cust = A7CUST
     C                   Eval      P_Ccy  = A7CYCD
     C                   Eval      P_Code = A7ACCD
     C                   Move      A7ACSN        P_Sequ
     C                   Eval      P_Brca = A7BRCD
 
      **  If wrong setup of Ordering Customer.
     C                   Other                                                  Error
 
     C     *Lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbkey  = *blanks
     C                   Eval      Dbfile = '*Param'                            ***************
     C                   Eval      Dbkey  = P_OrderingBank                      * Db Error 01 *
     C                   Eval      Dbase  = 02                                  ***************
     C                   Out       Lda
     C                   Eval       P_ReturnCode =  '*OrderBank'
     C                   Exsr      *Pssr
 
     C                   Endsl                                                  End Select
 
     C     @Account      TAG
 
      **  Access to Account Master Details File.
     C                   Exsr      #Account
 
      **  Setup Output fields
     C                   Eval      P_BranchCode = BRCA
     C                   Eval      P_CustNumber = CNUM
     C                   Eval      P_AccountCode = ACOD
     C                   Eval      P_AccountSeq = ACSQ
 
      **  Exit from program.
     C                   Eval      *inlr = True
     C                   Return
      /Eject
      *****************************************************************
      *                                                               *
      *  #Nostro - Access to Nostro Details.                          *
      *                                                               *
      *  Called By: Main processing.                                 *
      *                                                               *
      *  Calls     : *Pssr                                            *
      *                                                               *
      *****************************************************************
     C     #Nostro       Begsr                                                  ** #Nostro SR **
 
      **  Access Nostro Details.
     C                   Call      'AONOSTR0'
     C                   Parm      *blanks       P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   Parm      *blanks       P_Cust                         I:Customer No
     C                   Parm                    P_Ccy                          I:Currency
     C                   Parm      *blanks       P_Code                         I:A/c Code
     C                   Parm      *blanks       P_Sequ                         I:A/c Seq
     C                   Parm                    P_Nonb                         I:Nostro No
     C                   Parm      *blanks       P_Brca                         I:Branch Code
     C                   Parm      *blanks       P_Cssn                         I:Cust Shortname
     C                   Parm      *blanks       P_Pnoi                         I:Prime Nost In
     C     Sdnost        Parm      Sdnost        Dsfdy                          O:Format
 
      **  If no record found in SDNOSTPD, handle Database Error.
     C     P_RTCD        Ifne      *blanks                                      Begin P_RTCD
     C     *Lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDNOSTPD'                          ***************
     C     P_Ccy         Cat       P_Nonb:0      Dbkey                          * Db Error 03 *
     C                   Eval      Dbase  = 03                                  ***************
     C                   Out       Lda
     C                   Eval       P_ReturnCode =  P_Rtcd
     C                   Exsr      *Pssr
      *
     C                   Endif                                                  End P_RTCD
 
     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      *  #Account - Access to Master Account Details.                 *
      *                                                               *
      *  Called By : Main processing.                                 *
      *                                                               *
      *  Calls     : *Pssr                                            *
      *                                                               *
      *****************************************************************
     C     #Account      Begsr                                                  ** #Account SR **
      *
     C                   Call      'AOACCTR0'
     C                   Parm      *blanks       P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   Parm                    P_Retl                         I:Retail Number
     C                   Parm                    P_Cust                         I:Customer
     C                   Parm                    P_Ccy                          I:Currency
     C                   Parm                    P_Code                         I:Account Code
     C                   Parm                    P_Sequ                         I:Account Sequence
     C                   Parm                    P_Brca                         I:Branch
     C     Accnt         Parm      Accnt         Dssdy                          O:ACCNTAB format
 
      **  If no record was found in ACCNTAB, handle Database Error.
     C     P_Rtcd        Ifne      *BLANKS                                      Begin P_Rtcd
     C                   Eval      W_DbKey = *blanks
 
      **  If access by Retail Number.
     C     P_Retl        Ifne      *blanks                                      Begin P_RetailNum
     C                   Eval      W_DbRetailNum = P_Retl
 
     C                   Else                                                   Else P_Retl
     C                   Move      P_Cust        W_DbCustomer
     C                   Eval      W_DbCurrency = P_Ccy
     C                   Move      P_Code        W_DbAccCode
     C                   Move      P_Sequ        W_DbAccSequ
     C                   Eval      W_DbBranch = P_Brca
 
     C                   Endif                                                  End P_Retl
 
     C     *Lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'ACCNTAB'                           ***************
     C                   Eval      Dbkey  = W_DbKey                             * Db Error 04 *
     C                   Eval      Dbase  = 04                                  ***************
     C                   Out       Lda
     C                   Eval       P_ReturnCode =  P_Rtcd
     C                   Exsr      *Pssr
      *
     C                   Endif                                                  End P_RTCD
      *
     C                   Endsr
      /Eject
      *****************************************************************                    BUG15105A
      *                                                               *                    BUG15105A
      *  #IBAN   - Access to IBAN Details.                            *                    BUG15105A
      *                                                               *                    BUG15105A
      *  Called By: Main processing.                                  *                    BUG15105A
      *                                                               *                    BUG15105A
      *  Calls     : *Pssr                                            *                    BUG15105A
      *                                                               *                    BUG15105A
      *****************************************************************                    BUG15105A
     C     #IBAN         Begsr                                                             BUG15105A
                                                                                           BUG15105A
     C                   Eval      P_IBAN = W_Ordering                                     BUG15105A
      **  Access IBAN Details                                                              BUG15105A
     C                   Call      'AOIBANR4'                                              BUG15105A
     C                   Parm      *blanks       P_Rtcd                                    BUG15105A
     C                   Parm      '*KEY   '     P_Optn                                    BUG15105A
     C**********         Parm      *blanks       P_Cust                          BUG15105A BUG15105C
     C                   Parm                    P_IBAN                                    BUG15105A
     C     Accnt         Parm      Accnt         Dssdy                                     BUG15105A
                                                                                           BUG15105A
     C                   If        P_Rtcd = *Blanks                                        BUG15105A
     C                   Eval      P_Retl = *Blanks                                        BUG15105A
     C                   Move      CNUM          P_Cust                                    BUG15105A
     C                   Eval      P_Ccy  = CCY                                            BUG15105A
     C**********         Move      ACNO          P_Code                          BUG15105A BUG15105C
     C                   Move      ACOD          P_Code                                    BUG15105C
     C                   Move      ACSQ          P_Sequ                                    BUG15105A
     C                   Eval      P_Brca = BRCA                                           BUG15105A
     C                   EndIf                                                             BUG15105A
                                                                                           BUG15105A
     C                   Endsr                                                             BUG15105A
      /Eject                                                                               BUG15105A
      *****************************************************************
      *                                                               *
      * *Pssr  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     *Pssr         Begsr
 
     C     W_RunBefore   Ifeq      *Blank                                       Begin W_RunBefore
 
     C     *Lock         In        Lda
     C     Dbpgm         Ifeq      *Blanks                                      Begin Dbpgm
     C                   Eval      Dbpgm = PSProcName
     C                   Out       Lda
 
     C                   Endif                                                  End Dbpgm
 
     C                   Move      'Y'           W_RunBefore
     C                   Dump
 
     C                   Endif                                                  End W_RunBefore
 
     C                   Seton                                        U7U8LR
     C                   Return
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/*Inzsr
      *****************************************************************
      *                                                               *
      *  *Inzsr  - Program Initialization routine.                    *
      *                                                               *
      *  Called By: Implicitly on program activation.                 *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *Inzsr        Begsr                                                  ** *Inzsr SR **
 
     C     *Entry        Plist
      **  ------
      **  Inputs
      **  ------
      **  Ordering Customer.
     C                   Parm                    P_OrderingCust
      **  Ordering Bank
     C                   Parm                    P_OrderingBank
      **  --------------
      **  Inputs/Outputs
      **  --------------
      **  Currency.
     C                   Parm                    P_Currency
      **  -------
      **  Outputs
      **  -------
      ** Branch Code.
     C                   Parm                    P_BranchCode
      **  Customer Number.
     C                   Parm                    P_CustNumber
      **  Account Code.
     C                   Parm                    P_AccountCode
      **  Account Sequence.
     C                   Parm                    P_AccountSeq
      **  Return Code.
     C                   Parm                    P_ReturnCode
 
      **  Access Bank details by using access program.
     C                   Call      'AOBANKR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*FIRST '     P_optn
     C     Sdbank        Parm      Sdbank        Dssdy
 
      **  If Bank details do not exist, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDBANKPD'                          ***************
     C                   Eval      Dbase  = 05                                  * Db Error 05 *
     C                   Eval      Dbkey  = '*first'                            ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
      **  Read RUNDAT Data Area to get Multi-branching Indicator.
     C                   In        RUNDAT
 
     C                   Endsr
     C/Eject
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
