     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Customer Positions              - take on')
      *****************************************************************
      *                                                               *
      *  Private Banking Module                                       *
      *                                                               *
      *  RP1452 - Customer Positions take on.                         *
      *                                                               *
      *  Function:    This module updates Customer Positions          *
      *            Replication Indicator field so that record would   *
      *            be processed by Meridian Replication functions,    *
      *            for take on purpose.                               *
      *                                                               *
      *  Component of: RPC1452 - Customer Positions take on.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 206164             Date 09Jul02               *
      *                 206100             Date 27Jun02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 198158             Date 24Oct01               *
      *                 196860             Date 24Oct01               *
      *                 193035             Date 24Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 20Mar00               *
      *                                                               *
      *---------------------------------------------------------------*
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  206164 - Invalid set-up of Cumex indicator                   *
      *  206100 - "Gateway to PB" : Transactions, Portfolios not sent *
      *           Remove GEMS 198158 !                                *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  198158 - If error avoid Transactions transfer for customer PM*
      *  196860 - Avoid multi-threading pb in TMS, reset first the    *
      *           position and update position afterwards             *
      *  193035 - Set Clean Position Flag to 'Y' only if rupture on   *
      *           combination Customer/Security/PTFR                  *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *           Midas/TOF interface.                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  SD Customer Master Details.
     FSDCUSTPD  IF   E             Disk
     F                                     Infsr(*Pssr)
 
      **  SE Customer Positions.
     FSECDEPL1  UF   E           K Disk
     F                                     Infsr(*Pssr)
     F                                     Commit
 
      **  RP Depot Generation for Take-on
     FRPDPMVL1  UF A E           K Disk
     F                                     Infsr(*Pssr)
     F                                     Commit
 
      **  SE Trades Details
     FTRADCU    UF   E           K Disk    Prefix(TRAD_)
     F                                     Infsr(*Pssr)
     F                                     Commit
 
      **  SE Securities.
     FSECTY     IF   E           K Disk    Prefix(SECTY_)
     F                                     Infsr(*Pssr)
 
      **  SE Customer Positions
     FCPOSN     IF   E           K Disk    Prefix(CPOSN_)
     F                                     Infsr(*Pssr)
 
      **  PB Customer Positions take on report.
     FRP1452P1  O    E             Printer Infds(Spool1)
     F                                     Infsr(*Pssr)
     F                                     Usropn
 
      **  PB Customer Positions take on report.
     FRP1452P2  O    E             Printer Infds(Spool2)
     F                                     Infsr(*Pssr)
     F                                     Usropn
 
      **  PB Customer Positions take on audit report.
     FRP1452AU  O    E             PRINTER Infds(SpoolU)
     F                                     Infsr(*Pssr)
     F                                     Usropn
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  60  -  Test BIT 0 of TACI.                                   *
      *  61  -  Test BIT 1 of TACI.                                   *
      *  62  -  Test REPI numeric field                               *
      *                                                               *
      *  70  -  Redisplay screen.                                     *
      *                                                               *
      *  81  -  End of file SDCUSTPD.                                 *
      *  82  -  End of file SECDEPL1.                                 *
      *  83  -  Access to SECTY failed.                               *
      *  84  -  Access to CPOSN failed.                               *
      *  85  -  End of file TRADCU.                                   *
      *  86  -  Access to RPDPMVL1 failed.                            *
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
      *       * 51   52   53   54   55   56   57   58   59   xx *     *
      *       * xx   xx   63   64   65   66   67   68   69   xx *     *
      *       * 71   72   73   74   75   76   77   78   79   80 *     *
      *       * xx   xx   xx   xx   xx   xx   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   98   99      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /Space 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  #PosByCus - Subroutine to build Take-On by SE Customer Pos.  *
      *  #OutTrade - Subroutine to send outstanding trades.           *
      *  #GenTrans - Subroutine to generate record in Take-on File.   *
      *  #AvPrice  - Subroutine to calculate Average Price.           *
      *  #Report1  - Subroutine to print details of processed record. *
      *  #Report2  - Subroutine to print details of processed record. *
      *  #Rcfp1    - Subrout. to register the P1 Printer File via RCF *
      *  #Rcfau    - Subrout. to register the AU Printer File via RCF *
      *  #Audit    - Subroutine to Output Audit report.               *
      *  #Init     - Initialization subroutine.                       *
      *  *Pssr     - Program exception error routine                  *
      *  *inzsr    - Program Initialization routine.                  *
      *                                                               *
      *****************************************************************
 
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
 
      **  Array used to align all amounts on decimal point.
     D ARR_Amount      S              1    Dim(25)
 
      **  Array containing narratives.
     D ArrNarr         S             80    Dim(3) Ctdata Perrcd(1)
 
      ** Array for manipulating decimal positions
     D POWER8          S              8  4 Dim(8) Ctdata Perrcd(1)
 
      **  Array containing Copyright statement.
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      **  File Information Data Structure for printer file RP1452P1.
     D Spool1          DS
     D  Sfile1                83     92
     D  Sfnum1               123    124B 0
     D  Oflln1               188    189B 0
     D  Prtln1               367    368B 0
 
      **  File Information Data Structure for printer file RP1452P2.
     D Spool2          DS
     D  Sfile2                83     92
     D  Sfnum2               123    124B 0
     D  Oflln2               188    189B 0
     D  Prtln2               367    368B 0
 
      **  File Information Data Structure for printer file RP1452AU.
     D Spoolu          DS
     D  Sfileu                83     92
     D  Sfnumu               123    124B 0
 
      **  External Data structure for Local data area (database error details).
     D LDA           E DS           256    Extname(LDA) Dtaara(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  Customer Selection Data Area.
     D RPCust        E DS                  Extname(RPCUST) DTAARA(RPCUST)
 
      **  External data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      **  External data structure for Account Officer Details.
     D Sdacof        E DS                  Extname(SDACOFPD)
 
      **  External data structure for Branch Details.
     D Sdbrch        E DS                  Extname(SDBRCHPD)
     D SdbrchDFAC    E                     Extfld(QQDFAC)                                     CGL029
 
      **  External data structure for Midas Module Details.
     D Sdmmod        E DS                  Extname(SDMMODPD)
 
      **  External data structure for Currency Details.
     D Sdcurr        E DS                  Extname(SDCURRPD)
 
      **  Data structure for access programs, long data structure.
     D Dssdy         E DS                  Extname(DSSDY)
 
      **  Data structure for access programs, short data structure.
     D Dsfdy         E DS                  Extname(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Account Officer.
     D P_Acoc          S              2A
      **  Branch Code.
     D P_Brch          S              3A
      **  Customer.
     D P_Cust          S             10A
      **  Currency.
     D P_Curr          S              3A
      ** ---------- End of fields used by access programs -----------**
 
      **  True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Fields used to check that sufficient lines remain for the
      **  printer file record format.
     D Difln1          S              2  0
     D Rqdln1          S              2  0
     D Difln2          S              2  0
     D Rqdln2          S              2  0
 
      **  Fields used for the rupture in file SECDEPL1
     D W_PortRefer     S              4A
     D WW_PortRefer    S              4A
 
      **  Fields used to access to RPDPMVL1
     D K_PortRefer     S              4A
 
     D W_PosDate       S              5P 0
     D*W_Depot**       S              6S 0                                                    CSD027
     D W_Depot         S              6A                                                      CSD027
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **  Work Field used to open P1, P2 printer file only once.
     D W_OpenP1        S              1A
     D W_OpenP2        S              1A
 
      **  Length passed to formatting procedure RPPrCenter.
     D W_Length        S              3P 0
 
      **  Work field used to condition run of take on.
     D W_Takeon        S              1A
 
      **  Work Field used to change value of field TRADSDF/REPI.
     D W_REPI          S              2  0
 
      **  Work field used to retrieve Nominal (Amount, Currency and Decimal Places)
     D W_Nominal       S             11S 0
     D W_Nominal_Curr  S              3A
     D W_Currency_Dec  S              1S 0
 
      **  Work field used for rupture in SECDEPL1
     D W_Branch        S              3A
     D WW_Branch       S              3A
     D*W_CustNum*      S              6S 0                                                    CSD027
     D*WW_CustNum*     S              6S 0                                                    CSD027
     D W_CustNum       S              6A                                                      CSD027
     D WW_CustNum      S              6A                                                      CSD027
     D W_Security      S             10A
     D WW_Security     S             10A
     D W_Type          S              2A
 
      **  Work field used for rupture in TRADCU
     D W_Customer      S              6S 0
 
      **  Data Structure to setup Dberr on CPOSND
     D DB_Cpos         DS
     D  K_BranchCode           1      3A
     D  K_Security             4     13A
     D**K_CustNum             14     19S 0                                                    CSD027
     D  K_CustNum             14     19A                                                      CSD027
 
      **  Data Structure to setup Narrative Field
     D D_Narr          DS
     D  D_DPNR                 1     35
     D  D_Text                 1     35
     D  D_Branch               9     11
     D  D_Security            13     22
     D**D_CustNum             24     29  0                                                    CSD027
     D  D_CustNum             24     29                                                       CSD027
     D  D_Type                34     35
 
      **  Work field used to setup Narrative
     D W_Narrative     C                   CONST('TAKE ON xxx xxxxxxxxxx xxxx-
     D                                     xx    xx')
 
      ** +--------------------------------------+
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+
 
      ** Pull in prototype for RPPrCenter procedure.
      /COPY RPCPYSRC,RPFMTPPC
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
     C     Start         Tag
 
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      *                                                               *
      *****************************************************************
 
      **  Perform initialization subroutine as program remains in memory.
     C                   Exsr      #Init
 
      **  Read first Customer.
     C                   Read      SDCUSTPD                               81
 
      **  Do while Customers to be processed for required selection.
     C     *in81         Doweq     False                                        Begin Do_W_N81
     C                   Eval      W_Takeon = 'Y'
 
      **  If Customer is not a Private Banking customer, that
      **  means this take on program is running within the scope
      **  of Gateway to Private Banking. So, insure that so a take
      **  on will only run for Portfolio Management customers.
     C     BBPRBA        Ifne      'Y'                                          Begin BBPRBA
     C     BBACOC        Oreq      *Blanks
     C                   Eval      W_Takeon = 'N'
 
      ****If*Portfolio*Management*module*is*installed.                          198158
     C*****BGPFMG        Ifeq      'Y'                                          198158Begin BGPFMG
     C*****BBACOC        Andne     *Blanks                                      198158
     C**********         CallB     'AOPLCSR0'                                   198158
     C**********         Parm      *blanks       P_Rtcd                         198158
     C**********         Parm      '*KEY    '    P_Optn                         198158
     C**********         Parm      BBCUST        P_Cust                         198158
     C**********         Parm                    Dsfdy                          198158
      **********                                                                198158
      ****Process*only*Customers**whose*Portfolio*Management*Details*exist.     198158
     C*****P_Rtcd        Ifeq      *blanks                                      198158Begin P_Rtcd
     C**********         Eval      W_Takeon = 'Y'                               198158
      **********                                                                198158
     C**********         Endif                                                  198158End P_Rtcd
      **********                                                                198158
     C**********         Endif                                                  198158End BGPFMG
                                                                                              206100
      **  If Portfolio Management module is installed.                                        206100
     C     BGPFMG        Ifeq      'Y'                                                        206100
     C     BBACOC        Andne     *Blanks                                                    206100
     C                   CallB     'AOPLCSR0'                                                 206100
     C                   Parm      *blanks       P_Rtcd                                       206100
     C                   Parm      '*KEY    '    P_Optn                                       206100
     C                   Parm      BBCUST        P_Cust                                       206100
     C                   Parm                    Dsfdy                                        206100
                                                                                              206100
      **  Process only Customers  whose Portfolio Management Details exist.                   206100
     C     P_Rtcd        Ifeq      *blanks                                                    206100
     C                   Eval      W_Takeon = 'Y'                                             206100
                                                                                              206100
     C                   Endif                                                                206100
                                                                                              206100
     C                   Endif                                                                206100
 
     C                   Endif                                                  End BBPRBA
 
      **  If take on processing has to run for current customer.
     C     W_Takeon      Ifeq      'Y'                                          Begin W_Takeon
     C                   Exsr      #PosByCus
     C                   Endif                                                  End W_Takeon
 
      **  Read next Customer.
     C                   Read      SDCUSTPD                               81
 
     C                   Enddo                                                  End Do_W_N81
 
      **  Close Customer Master Details file.
     C                   Close     SDCUSTPD
 
      **  Commit.
     C                   COMMIT
 
      **  If at least one line has been printed.
     C     RCOUNT1       Ifgt      0                                            Begin RCOUNT1
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 2
     C                   Eval      Difln1 = Oflln1 - Prtln1
     C     Difln1        Ifle      Rqdln1                                       Begin Difln1
 
     C                   Write     HEADP1
 
     C                   Endif                                                  End Difln1
 
      **  Write out Trailer Format.
     C                   Write     ENDPAG1
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 4
     C                   Eval      Difln1 = Oflln1 - Prtln1
     C     Difln1        Ifle      Rqdln1                                       Begin Difln1
 
     C                   Write     HEADP1
 
     C                   Endif                                                  End Difln1
 
     C                   Write     TRAILP1
 
      **  Close Customer Positions take on Report printer file.
     C                   Close     RP1452P1
     C                   Endif                                                  End RCOUNT1
 
      **  If at least one line has been printed.
     C     RCOUNT2       Ifgt      0                                            Begin RCOUNT2
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln2 = 2
     C                   Eval      Difln2 = Oflln2 - Prtln2
     C     Difln2        Ifle      Rqdln2                                       Begin Difln2
 
     C                   Write     HEADP2
 
     C                   Endif                                                  End Difln2
 
      **  Write out Trailer Format.
     C                   Write     ENDPAG2
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln2 = 4
     C                   Eval      Difln2 = Oflln2 - Prtln2
     C     Difln2        Ifle      Rqdln2                                       Begin Difln2
 
     C                   Write     HEADP2
 
     C                   Endif                                                  End Difln2
 
     C                   Write     TRAILP2
 
      **  Close Customer Positions take on Report printer file.
     C                   Close     RP1452P2
     C                   Endif                                                  End RCOUNT2
 
      **  Print Audit Report.
     C                   Exsr      #Audit
 
      **  End Program and Return.
     C                   Eval      *inlr = True
     C                   Return
 
      /Eject
      *****************************************************************
      /Title SR/#PosByCus
      *****************************************************************
      *                                                               *
      *  #PosByCus - Subroutine to build SE Positions By portfolio    *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     #GenTrans  #OutTrade                              *
      *                                                               *
      *****************************************************************
 
     C     #PosByCus     Begsr                                                  ** #PosByCus SR **
 
      **  Define key list to access to SE Client Depot Positions file.
     C     K_SECustPos   Klist
     C                   Kfld                    K_CustNum
 
      **  Set up Key list to access to Customer Positions file.
     C                   Move      BBCUST        K_CustNum
 
     C**********         Eval      W_CustNum   = *Zeros                                       CSD027
     C**********         Eval      WW_CustNum   = *Zeros                                      CSD027
     C                   Eval      W_CustNum   = *Blanks                                      CSD027
     C                   Eval      WW_CustNum   = *Blanks                                     CSD027
     C                   Eval      W_Customer  = *Zeros
     C                   Eval      W_Nominal   = *Zeros
     C                   Eval      W_Type      = *Blanks
     C                   Eval      W_Security  = *Blanks
     C                   Eval      WW_Security  = *Blanks
     C                   Eval      W_Branch    = *Blanks
     C                   Eval      WW_Branch    = *Blanks
     C                   Eval      W_PortRefer = *Blanks
     C                   Eval      WW_PortRefer = *Blanks
 
      **  Position on first Customer Position.
     C     K_SECustPos   Setll     SECDEPL1
     C     K_SECustPos   Reade     SECDEPL1                               82
 
      **  Do while Customer Positions to be processed for required selection.
     C     *in82         Doweq     False                                        Begin Do_W_N82
     C     RECI          Ifeq      'D'                                          Begin Live Record
 
      **  Setup Working fields
     C                   Eval      W_CustNum   = CDCN
     C                   Eval      W_Branch    = CDPA
     C                   Eval      W_PortRefer = PTFR
     C                   Eval      W_PosDate =  DDTE
     C                   Eval      W_Depot   =  CDPT
 
     C     CDSN          Ifne      W_Security                                   Begin <> Security
     C                   Eval      W_Security  = CDSN
     C                   Eval      K_Security  = W_Security
 
      **  Retrieve the Security Details (Nominal, Currency, Decimal Places...)
     C     K_Security    Chain     SECTY                              83
 
      **  If Security does not exist, handle database error.
     C     *in83         Ifeq      True                                         Begin *in83
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SECTYD'                            ***************
     C                   Eval      Dbase  = 01                                  * Db Error 01 *
     C                   Eval      Dbkey  = K_Security                          ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
     C                   Endif                                                  End  *in83
      *
     C     SECTY_NMCY    Ifne      W_Nominal_Curr                               Begin <> Currency
     C                   Eval      W_Nominal_Curr = SECTY_NMCY
     C                   Eval      P_Curr = SECTY_NMCY
 
      **  Access to Currency Details, by using access object.
     C                   Callb     'AOCURRR0'
     C                   Parm      *blank        P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   Parm                    P_Curr            3            I:Key field
     C     Sdcurr        Parm      Sdcurr        Dssdy                          O:Format
 
      **  If currency does not exist, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDCURRPD'                          ***************
     C                   Eval      Dbase  = 02                                  * Db Error 02 *
     C                   Eval      Dbkey  = P_Curr                              ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
     C                   Endif                                                  End  P_Rtcd
      ** Nominal Decimal Place
     C                   Eval      W_Currency_Dec = A6NBDP
     C                   Endif                                                  End <> Currency
     C                   Endif                                                  End <> Security
 
     C                   If        DDTE > SECTY_LCPN                            Begin Process
     C                             AND CECN <> 0
     C                             OR  CDNV <> 0
 
      **  First Record of rupture Set Clean Postion flag to 'Y'
      ****Only*combination*Customer/Security/PTFR/Branch                        193035
      **  Only combination Customer/Security/PTFR                               193035
 
     C                   Eval      RPCLPO = ' '
     C     CDCN          Ifne      WW_CustNum                                   Begin Rupture
     C     CDSN          Orne      WW_Security
     C     PTFR          Orne      WW_PortRefer
     C*****CDPA*         Orne      WW_Branch                                    193035
     C                   Eval      RPCLPO = 'Y'
     C                   Eval      WW_CustNum   = CDCN
     C                   Eval      WW_Security = CDSN
     C                   Eval      WW_PortRefer = PTFR
     C                   Eval      WW_Branch = CDPA
     C                   Endif                                                  End Rupture
 
      **  If Value Date Position lower than 0
      **  Generate a "WI" transaction with Nominal and all relevant information
     C     CDNV          Ifgt      0                                            Begin Value Date > 0
     C                   Eval      W_Nominal =  CDNV
 
      **  If Position Date greater than Last coupon date and Ex-coupon <> 0
      **  Substract cum-ex position from Nominal
     C                   If        DDTE > SECTY_LCPN
     C                             AND CECN <> 0
     C                   Eval      W_Nominal =  CDNV - CECN
     C                   Endif
 
     C                   Eval      W_Type    =  'WI'
     C                   Exsr      #GenTrans
     C                   Endif                                                  End Value Date > 0
 
      **  If Value Date Position greater than 0
      **  Generate a "WO" transaction with Nominal and all relevant information
     C     CDNV          Iflt      0                                            Begin Value Date < 0
     C                   Eval      W_Nominal =  CDNV
 
      **  If Position Date greater than Last coupon date and Ex-coupon <> 0
      **  Substract cum-ex position from Nominal
     C                   If        DDTE > SECTY_LCPN
     C                             AND CECN <> 0
     C                   Eval      W_Nominal =  CDNV - CECN
     C                   Endif
 
     C                   Eval      W_Type    =  'WO'
     C                   Exsr      #GenTrans
     C                   Endif                                                  End Value Date < 0
 
      **  If Ex-coupon different than zeros, setup cum-ex flag
     C                   Eval      RPCUME =  *Blanks
     C                   If        DDTE > SECTY_LCPN                            Begin Cum-ex flag
     C                             AND CECN <> 0
 
     C**********         Eval      RPCUME =  'Y'                                              206164
     C                   Eval      RPCUME =  'X'                                              206164
 
      **  If Ex-coupon greater than 0
      **  Generate a "WI" transaction
     C                   If        CECN > *Zeros                                Begin ex-coupon > 0
     C                   Eval      W_Nominal =  CECN
     C                   Eval      W_Type    =  'WI'
     C                   Exsr      #GenTrans
     C                   Endif                                                  End ex-coupon > 0
 
      **  If Ex-coupon lower than 0
      **  Generate a "WO" transaction
     C                   If        CECN < *Zeros                                Begin ex-coupon < 0
     C                   Eval      W_Nominal =  CECN
     C                   Eval      W_Type    =  'WO'
     C                   Exsr      #GenTrans
     C                   Endif                                                  End ex-coupon < 0
     C                   Endif                                                  End Cum-ex flag
     C                   Endif                                                  End Process
 
     C                   Endif                                                  End Live Record
 
      **  Read next SE Customer Positions record.
     C     K_SECustPos   Reade     SECDEPL1                               82
 
     C                   Enddo                                                  End Do_W_N82
 
     C                   if        (Run  = '2' and RPCLPO = ' ')                196860
      **  Send all outstanding trades for related customer
     C                   Exsr      #OutTrade
     C                   endif                                                  196860
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#OutTrade
      *****************************************************************
      *                                                               *
      *  #OutTrade - Subroutine to send all outstanting trades        *
      *              for related customer                             *
      *                                                               *
      *  Called By: #PosByCust                                        *
      *                                                               *
      *  Calls:     #GenTrans                                         *
      *                                                               *
      *****************************************************************
 
     C     #OutTrade     Begsr                                                  ** #OutTrade SR **
 
      **  Define key list to access to SE Trades (By Customer) file.
     C     K_TradeCust   Klist
     C                   Kfld                    K_CustNum
 
      **  Position on first Customer Trade.
     C     K_TradeCust   Setll     TRADCU
     C     K_TradeCust   Reade     TRADCU                                 85
 
      **  Do while Customer Positions to be processed for required selection.
     C     *in85         Doweq     False                                        Begin Do_W_N85
     C     TRAD_RECI     Ifeq      'D'                                          Begin Live Record
 
      **  Setup working fields
     C                   Eval      W_CustNum   = TRAD_TCNR
     C                   Eval      W_Branch    = TRAD_TDBA
     C                   Eval      W_PortRefer = TRAD_PTFR
     C                   Eval      W_PosDate   =  TRAD_TDVD
     C                   Eval      W_Depot     =  *zeros
 
      **  Test Bit 0 and 1 for value date
     C                   Testb     '0'           TRAD_TACI            60        Test Bit 0
     C                   Testb     '1'           TRAD_TACI            61        Test Bit 1
 
     C     *in60         Ifeq      False                                        Test Bit
     C     *in61         Oreq      False
 
     C                   Eval      K_Security  =  TRAD_TDSS
     C                   Eval      K_Portrefer =  TRAD_PTFR
 
      **  Define key list to access to SE Trades (By Customer) file.
     C     K_Takeon      Klist
     C                   Kfld                    K_CustNum
     C                   Kfld                    K_Security
     C                   Kfld                    K_Portrefer
 
      **  Access LF/RPDPMVL1 with Customer/Security/Portfolio
 
     C     K_Takeon      Setll     RPDPMVL1
     C     K_Takeon      Reade     RPDPMVL1                               86
 
     C     *in86         Ifeq      True                                         Begin *in86
 
     C     TRAD_TDSS     Ifne      W_Security                                   Begin <> Security
     C                   Eval      W_Security  = TRAD_TDSS
     C                   Eval      K_Security  = W_Security
 
      **  Retrieve the Security Details (Nominal, Currency, Decimal Places...)
     C     K_Security    Chain     SECTY                              83
 
      **  If Security does not exist, handle database error.
     C     *in83         Ifeq      True                                         Begin *in83
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SECTYD'                            ***************
     C                   Eval      Dbase  = 03                                  * Db Error 03 *
     C                   Eval      Dbkey  = K_Security                          ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
     C                   Endif                                                  End  *in83
      *
     C     SECTY_NMCY    Ifne      W_Nominal_Curr                               Begin <> Currency
     C                   Eval      W_Nominal_Curr = SECTY_NMCY
     C                   Eval      P_Curr = SECTY_NMCY
 
      **  Access to Currency Details, by using access object.
     C                   Callb     'AOCURRR0'
     C                   Parm      *blank        P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   Parm                    P_Curr            3            I:Key field
     C     Sdcurr        Parm      Sdcurr        Dssdy                          O:Format
 
      **  If currency does not exist, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDCURRPD'                          ***************
     C                   Eval      Dbase  = 04                                  * Db Error 04 *
     C                   Eval      Dbkey  = P_Curr                              ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
     C                   Endif                                                  End  P_Rtcd
      ** Nominal Decimal Place
     C                   Eval      W_Currency_Dec = A6NBDP
     C                   Endif                                                  End <> Currency
     C                   Endif                                                  End <> Security
 
     C                   Eval      W_Nominal = *Zeros
     C                   Eval      W_Type    =  'WI'
     C                   Eval      RPCLPO    =  'Y'
     C                   Eval      RPCUME =  *Blanks
     C                   Exsr      #GenTrans
     C                   Endif                                                  End *in86
 
      ** Start the replication process for the selected trade
     C                   Testn                   TRAD_REPI            62
 
      **  If Replication Indicator is numeric.
     C     *in62         Ifeq      True                                         Begin *in62
     C                   Move      TRAD_REPI     W_REPI
     C                   Add       1             W_REPI
 
      **  If Replication Indicator is not numeric.
     C                   Else                                                   Else *in62
     C                   Eval      W_REPI = 1
 
     C                   Endif                                                  End *in62
     C                   Move      W_REPI        TRAD_REPI
 
      **  Update SE Trades file record.
     C                   Update    TRADSDF
 
      **  Print Oustanding Trades informations on report.
     C                   Exsr      #Report2
     C                   Endif                                                  End Test Bit
     C                   Endif                                                  End Live Record
 
      **  Read next SE Customer Trade.
     C     K_TradeCust   Reade     TRADCU                                 85
 
     C                   Enddo                                                  End Do_W_N85
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#GenTrans
      *****************************************************************
      *                                                               *
      *  #GenTrans - Subroutine to generate a new Depot Reference     *
      *              in the new file interface RPDPMVPD.              *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #GenTrans     Begsr                                                  ** #Gentrans SR **
      *
     C                   Eval      RPDPSS = W_Security                          Security
     C                   Eval      RPDPRN = *Blanks                             Reference
     C                   Eval      RPDPMV = W_Type                              Movement Type
     C                   Eval      RPCDPA = W_Branch                            Branch
      *
     C**********         Z-Add     0             RPDPID                                       CSD027
     C                   Eval      RPDPID = *Blanks                                           CSD027
     C                   Z-Add     0             RPDPMD
     C**********         Z-Add     0             RPDPOD                                       CSD027
     C                   Eval      RPDPOD = *Blanks                                           CSD027
     C                   Z-Add     0             RPDPDO
      *
     C     W_Type        Ifeq      'WI'
     C**********         Z-Add     W_Depot       RPDPID                         In Depot      CSD027
     C                   Eval      RPDPID = W_Depot                             In Depot      CSD027
     C                   Z-Add     W_PosDate     RPDPMD                         Mov. Date In
     C                   Endif
      *
     C     W_Type        Ifeq      'WO'
     C**********         Z-Add     W_Depot       RPDPOD                         Out Depot     CSD027
     C                   Eval      RPDPOD = W_Depot                             Out Depot     CSD027
     C                   Z-Add     W_PosDate     RPDPDO                         Move. Date Out
     C                   Endif
      *
     C**********         Z-Add     W_CustNum     RPDPBN                       Beneficial Cust CSD027
     C                   Eval      RPDPBN = W_CustNum                           Beneficial Cu CSD027
      *
     C     W_Nominal     Iflt      *zeros
     C                   Z-Sub     W_Nominal     W_Nominal
     C                   Endif
      *
     C                   Eval      RPDPNA = W_Nominal                           Nominal Amount
     C                   Eval      RPNMCY = W_Nominal_Curr                      Nominal Ccy
     C                   Eval      RPNMDP = SECTY_NMDP                          Nominal Dec Places
      *
     C                   Eval      D_Text = W_Narrative
     C                   Eval      D_Branch = W_Branch
     C                   Eval      D_Security = W_Security
     C                   Eval      D_CustNum = W_CustNum
     C                   Eval      D_Type = W_Type
     C                   Eval      RPDPNR = D_DPNR                              Narrative
      *
      *** Market Price on depot is setuped with Customer Average Price
      *
      ***  AP Numerator (Value Date)
      ***  -------------------------  =  Average Price
      ***    Nominal (Value Date)
 
     C                   Z-Add     *zeros        RPMKTP
     C     W_Nominal     Ifne      *zeros
      **  Define key list to access to SE Customer positions file.
     C     K_Position    Klist
     C                   Kfld                    K_BranchCode
     C                   Kfld                    K_Security
     C                   Kfld                    K_CustNum
      *
     C                   Eval      K_BranchCode = W_Branch
      *
      *** Access LF/CPOSN to retrieve AP Numerator (Value Date)
 
     C     K_Position    Chain     CPOSN                              84
 
      **  If Security does not exist, handle database error.
     C     *in84         Ifeq      True                                         Begin *in84
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'CPOSND'                            ***************
     C                   Eval      Dbase  = 05                                  * Db Error 05 *
     C                   Eval      Dbkey  = DB_Cpos                             ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
     C                   Endif                                                  End  *in84
      *
     C                   Z-Add     W_Nominal     ZNOML                          Nominal
     C                   Z-Add     CPOSN_CSPV    ZAPNC                          Ap numerator
     C                   Z-Add     W_Currency_DecZCDP                           Ccy dec. places
     C                   Exsr      #AvPrice
     C                   Z-Add     ZPRC          RPMKTP                         Market Price
     C                   Endif
      *
     C                   Eval      RPCHTP = 'I'                                 Last Change Type
     C                   Eval      RPDCHC = *Blanks                             Charge Code
     C                   Eval      RPDCCE = *Blanks                             Charge Currency
     C                   Eval      RPDCHA = *Zeros                              Charge Amount
     C                   Eval      RPDCSE = *Zeros                              Charge Settl. Type
     C                   Eval      RPDCAT = *Blanks                             Charge Account
      *
     C                   Eval      RPDPVD = W_PosDate                           Posting Date
      *
     C                   Eval      RPPTFR = W_PortRefer                         Portfolio Ref.
      *
     C                   Eval      RPTAKE = 'Y'                                 Take on Falg
      *
      ***  Write depot movements details
      *
     C                   if        (Run  = '1' and RPCLPO = 'Y')                196860
     C                   WRITE     RPDPMVD0
     C                   endif                                                  196860
                                                                                196860
     C                   if        (Run  = '2' and RPCLPO = ' ')                196860
     C                   WRITE     RPDPMVD0                                     196860
     C                   endif                                                  196860
                                                                                196860
     C                   Eval      RPCLPO =  ' '
     C                   Eval      RPCUME =  ' '
 
      **  Print Customer Position informations on report.
     C                   Exsr      #Report1
 
     C                   Endsr
      *
 
      /Eject
      *****************************************************************
      /Title SR/#AvPrice
      *****************************************************************
      *                                                               *
      *  #AvPrice - Subroutine to calculate Average Price.            *
      *             This subroutine based on Standard SR/ZAVPR        *
      *                                                               *
      *  Called By: #GenTrans                                         *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #AvPrice      Begsr                                                  ** #AvPrice SR **
 
      *
      *** Define fields
      *
     C                   Z-Add     ZPRC          ZPRC             16 9
     C                   Z-Add     ZAPNC         ZAPNC            15 0
     C                   Z-Add     ZWK150        ZWK150           15 0
     C                   Z-Add     ZDF154        ZDF154           15 4
     C                   Z-Add     ZNOML         ZNOML            15 0
     C                   Z-Add     DC            DC                1 0
     C                   Z-Add     ZCDP          ZCDP              1 0
      *
      *** Put AP Numerator into Nominal ccy dec pls
      *
     C     5             Add       ZCDP          DC                1 0
     C                   Sub       SECTY_NMDP    DC
     C     DC            Iflt      5
     C     ZAPNC         Div       POWER8(DC)    ZAPNC
     C                   Endif
      *
      *** Price basis 'P'
      *
     C     SECTY_SPBS    Ifeq      'P'
     C                   Mult      100           ZAPNC
     C                   Endif
      *
     C     ZAPNC         Div(H)    ZNOML         ZPRC
      *
      *** Prevent High Order Truncation
      *
     C     ZPRC          Mult(H)   ZNOML         ZWK150
     C     ZAPNC         Sub       ZWK150        ZWK150
     C     ZWK150        Div(H)    ZNOML         ZDF154
      *
      *** Calculate price and adjust figures (if needed).
      *
     C     DC            Ifge      5
     C     ZPRC          Div(H)    POWER8(DC)    ZPRC
     C     ZDF154        Div(H)    POWER8(DC)    ZDF154
     C                   Endif
      *
     C                   Add       ZDF154        ZPRC
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#Report1
      *****************************************************************
      *                                                               *
      *  #Report1 - Subroutine to print details of processed record.  *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #Report1      Begsr                                                  ** #Report1 SR **
 
      **  Insure Audit Report Spool File was recorded by RCF.
     C     W_OpenP1      Ifeq      *blank                                       Begin W_OpenP1
     C                   Eval      W_OpenP1 = 'Y'
     C                   Open      RP1452P1
     C                   Exsr      #RCFP1
 
      **-------------  Set up Report sub-heading fields -------------**
 
      **  If Account Officer Reference was selected.
     C     CSAcofCode    Ifne      *blanks                                      Begin CSAcofCode
     C                   Eval      P1ACOF = AUACOF
 
     C                   Else                                                   Else CSAcofCode
 
      **  If customer range was selected.
     C     CSFromCust    Ifne      'ALL'                                        Begin CSFromCust
     C                   Eval      P1CUSB = CSFromCust
     C                   Eval      P1CUSA = CSToCust
     C                   Endif                                                  End CSFromCust
     C                   Endif                                                  End CSAcofCode
 
      **  If Main Customer Branch was selected.
     C     CSMainBrch    Ifne      'ALL'                                        Begin CSMainBrch
     C                   Eval      P1BRCH = AUBRCH
     C                   Endif                                                  End CSMainBrch
 
      **  Force header format printing.
     C                   Eval      Prtln1 =  Oflln1
     C                   Endif                                                  End W_OpenP1
 
      **  Set up report printer file fields.
     C                   Eval      P1CSBA = W_Branch                            Branch code
     C                   Eval      P1CSSC = W_Security                          Security shortname
     C                   Move      W_CustNum     P1CSCN                         Customer number
 
      **  Set up Value Date.
     C                   Callb     'ZDATE2'
     C                   Parm      W_PosDate     Zdayno            5 0          I:Midas day number
     C                   Parm                    Zdatfm            1            I:Date format ind.
     C                   Parm                    Zdate             6 0          O:Date
     C                   Parm                    Zadate            7            O:Date as DDMMMYY
 
     C                   Eval      P1CSDA = Zadate                              Value date
     C                   Eval      P1TYPE = W_Type                              Movement Type
 
     C                   Eval      Zfld15 = W_Nominal
     C                   Eval      Zdecs  = SECTY_NMDP
     C                   Eval      Zecode = 'J'
 
     C                   Callb     'ZSEDIT'
     C                   Parm                    Zfld15           15 0          I:Numeric field
     C                   Parm                    Zdecs             1 0          I:No of decimals
     C                   Parm                    Zecode            1            I:Edit code
     C                   Parm                    Zout21           21            O:Function field
 
     C                   Eval      ARR_Amount = *blanks
 
      **  See to it that amounts would be aligned on decimal point.
     C     Zdecs         Ifeq      0                                            Begin Zdecs
     C                   Eval      A = 1
 
     C                   Else                                                   Else Zdecs
     C     Zdecs         Add       2             A                 1 0
 
     C                   Endif                                                  End Zdecs
     C                   Movea     Zout21        ARR_Amount(A)
     C                   Movea     ARR_Amount(1) P1CSNT                         Nominal amount
 
     C                   Eval      P1NMCY = W_Nominal_Curr                      Nominal currency
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 2
     C                   Eval      Difln1 = Oflln1 - Prtln1
     C     Difln1        Ifle      Rqdln1                                       Begin Difln1
 
      **  If end of page, print relevant record format.
     C     RCOUNT1       Ifgt      0                                            Begin RCOUNT1
     C                   Write     ENDPAG1
     C                   Endif                                                  End RCOUNT1
 
     C                   Write     HEADP1
     C                   Endif                                                  End Difln1
 
      ** Write record details.
     C                   Write     DETAIL1
     C                   Eval      RCOUNT1 = RCOUNT1 + 1
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#Report2
      *****************************************************************
      *                                                               *
      *  #Report2 - Subroutine to print details of processed record.  *
      *                                                               *
      *  Called By: #OutTrade                                         *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #Report2      Begsr                                                  ** #Report2 SR **
 
      **  Insure Audit Report Spool File was recorded by RCF.
     C     W_OpenP2      Ifeq      *blank                                       Begin W_OpenP2
     C                   Eval      W_OpenP2 = 'Y'
     C                   Open      RP1452P2
     C                   Exsr      #RCFP2
 
      **-------------  Set up Report sub-heading fields -------------**
 
      **  If Account Officer Reference was selected.
     C     CSAcofCode    Ifne      *blanks                                      Begin CSAcofCode
     C                   Eval      P2ACOF = AUACOF
 
     C                   Else                                                   Else CSAcofCode
 
      **  If customer range was selected.
     C     CSFromCust    Ifne      'ALL'                                        Begin CSFromCust
     C                   Eval      P2CUSB = CSFromCust
     C                   Eval      P2CUSA = CSToCust
 
     C                   Endif                                                  End CSFromCust
 
     C                   Endif                                                  End CSAcofCode
 
      **  If Main Customer Branch was selected.
     C     CSMainBrch    Ifne      'ALL'                                        Begin CSMainBrch
     C                   Eval      P2BRCH = AUBRCH
     C                   Endif                                                  End CSMainBrch
 
      **  Force header format printing.
     C                   Eval      Prtln2 =  Oflln2
     C                   Endif                                                  End W_OpenP2
 
      **  Set up report printer file fields.
     C                   Eval      P2TDRF = TRAD_TDRF                           Trade reference
     C                   Eval      P2TDSS = TRAD_TDSS                           Security shortname
     C                   Move      TRAD_TCNR     P2TCNR                         Counterpart Cust No.
     C                   Eval      P2TDTP = TRAD_TDTP                           Trade type
     C                   Eval      P2TNMC = TRAD_TNMC                           Nominal currency
 
      **  Format nominal amount.
     C                   Eval      Zfld15 = TRAD_NOML
     C                   Eval      Zdecs  = TRAD_TNMD
     C                   Eval      Zecode = 'J'
 
     C                   Callb     'ZSEDIT'
     C                   Parm                    Zfld15           15 0          I:Numeric field
     C                   Parm                    Zdecs             1 0          I:No of decimals
     C                   Parm                    Zecode            1            I:Edit code
     C                   Parm                    Zout21           21            O:Function field
 
     C                   Eval      ARR_Amount = *blanks
 
      **  See to it that amounts would be aligned on decimal point.
     C     Zdecs         Ifeq      0                                            Begin Zdecs
     C                   Eval      A = 1
 
     C                   Else                                                   Else Zdecs
     C     Zdecs         Add       2             A                 1 0
 
     C                   Endif                                                  End Zdecs
     C                   Movea     Zout21        ARR_Amount(A)
     C                   Movea     ARR_Amount(1) P2NOML                         Amount
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln2 = 2
     C                   Eval      Difln2 = Oflln2 - Prtln2
     C     Difln2        Ifle      Rqdln2                                       Begin Difln2
 
      **  If end of page, print relevant record format.
     C     RCOUNT2       Ifgt      0                                            Begin RCOUNT2
     C                   Write     ENDPAG2
     C                   Endif                                                  End RCOUNT2
 
     C                   Write     HEADP2
     C                   Endif                                                  End Difln2
 
      ** Write record details.
     C                   Write     DETAIL2
     C                   Eval      RCOUNT2 = RCOUNT2 + 1
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#Rcfp1
      *****************************************************************
      *                                                               *
      *  #Rcfp1  - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     pgm ZSFILE                                        *
      *                                                               *
      *****************************************************************
 
     C     #Rcfp1        Begsr                                                  ** #Rcfp1 SR **
 
      **  Ensure Report Spool File recorded by RCF.
 
     C                   Eval      Zsnum1 = Sfnum1
     C                   Move      Sfnum1        Zsnum1
 
     C                   Call      'ZSFILE'
     C                   Parm      *Blanks       Seq               5
     C                   Parm                    Senty             3
     C                   Parm                    Sfile1
     C                   Parm                    Zsnum1            6 0
     C                   Parm                    Zserr             1
 
      **  If any Error occurred during ZSFILE processing, then return to the
      **  Calling Program.
     C     Zserr         Ifeq      'Y'                                          Begin Zserr
     C     *lock         In        RPCust
     C                   Eval      CSRetnCode = 'ZSRP1452P1'
     C                   Out       RPCust
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
     C                   Endif                                                  End Zserr
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#Rcfp2
      *****************************************************************
      *                                                               *
      *  #Rcfp2  - Subroutine to register the P2 Printer File via RCF *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     pgm ZSFILE                                        *
      *                                                               *
      *****************************************************************
 
     C     #Rcfp2        Begsr                                                  ** #Rcfp2 SR **
 
      **  Ensure Report Spool File recorded by RCF.
 
     C                   Eval      Zsnum2 = Sfnum2
     C                   Move      Sfnum2        Zsnum2
 
     C                   Call      'ZSFILE'
     C                   Parm      *Blanks       Seq               5
     C                   Parm                    Senty             3
     C                   Parm                    Sfile2
     C                   Parm                    Zsnum2            6 0
     C                   Parm                    Zserr             1
 
      **  If any Error occurred during ZSFILE processing, then return to the
      **  Calling Program.
     C     Zserr         Ifeq      'Y'                                          Begin Zserr
     C     *lock         In        RPCust
     C                   Eval      CSRetnCode = 'ZSRP1452P2'
     C                   Out       RPCust
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
     C                   Endif                                                  End Zserr
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#Rcfau
      *****************************************************************
      *                                                               *
      *  #Rcfau  - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *  Called by: #Audit                                            *
      *                                                               *
      *  Calls:     ZSFILE                                            *
      *                                                               *
      *****************************************************************
 
     C     #Rcfau        Begsr                                                  ** #Rcfau SR **
 
      **  Ensure Audit Spool File recorded by RCF.
     C                   move      Sfnumu        Zsnumu
 
     C                   Call      'ZSFILE'
     C                   Parm      *Blanks       Seq
     C                   Parm      *Blanks       Senty
     C                   Parm                    Sfileu
     C                   Parm                    Zsnumu            6 0
     C                   Parm      *Blank        Zserr
 
      **  If Error occurs during ZSFILE processing, then return to the
      **  Calling Program.
     C     Zserr         Ifeq      'Y'                                          Begin Zserr
     C     *lock         In        RPCust
     C                   Eval      CSRetnCode = 'ZSRP1452AU'
     C                   Out       RPCust
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
 
     C                   Endif                                                  End Zserr
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#Audit
      *****************************************************************
      *                                                               *
      *  #Audit - Subroutine to output Audit report.                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #Audit        Begsr                                                  ** #Audit SR **
 
      **  Open Audit Report printer file.
     C                   Open      RP1452AU                             99
 
      **  Ensure Audit Report Spool File Recorded by RCF.
     C                   Exsr      #Rcfau
 
      **  Output Report Header and File Controls.
     C                   Write     HEADAU
     C                   Write     CONTROL
 
      **  If there is a DB Error, output the DB Error Information.
     C     *inu7         Ifeq      *on                                          Begin *inu7
     C                   Write     DBERROR
 
     C                   Else                                                   Else *inu7
 
      **  Or, if no records read, output "No Details" message.
     C     RCOUNT1       Ifeq      0                                            Begin RCOUNT
     C     RCOUNT2       Andeq     0
     C                   Write     NODTLS
 
     C                   Endif                                                  End RCOUNT
 
     C                   Endif                                                  End *inu7
 
      **  Close Audit Report printer file.
     C                   Close     RP1452AU
 
     C                   Endsr
 
      /Eject
      *****************************************************************
      /Title SR/#Init
      *****************************************************************
      *                                                               *
      *  *Init - Initialization subroutine.                           *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #Init         Begsr                                                  ** #Init SR **
 
      **  Reset Printer files indicators.
     C                   Movea     '000'         *in(71)
 
      **  Get Customer Selection Details from data area.
     C                   In        RPCust
 
      **----------  Set up Audit Report sub-heading fields ----------**
 
      **  If Account Officer Reference was selected.
     C     CSAcofCode    Ifne      *blanks                                      Begin CSAcofCode
 
      **  Access to Account Officer Details, by using Access Object
      **  to get Account Officer Name.
     C                   Call      'AOACOFR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY   '     P_Optn
     C                   Parm      CSAcofCode    P_Acoc
     C     Sdacof        Parm      Sdacof        Dssdy
 
      **  If no record found, handle database error.
     C     P_Rtcd        Ifne      *Blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDACOFPD'                          ***************
     C                   Eval      Dbase  = 06                                  * Db Error 06 *
     C                   Eval      Dbkey  = P_Acoc                              ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
     C                   Endif                                                  End P_Rtcd
 
     C                   Eval      AUACOF = %Trim(ArrNarr(1)) + ' ' +
     C                                      AZACOC + ' ' + %Trim(AZACON) +
     C                                      ' ' + ArrNarr(2)
     C                   Eval      W_Length = 132
     C                   Eval      AUACOF = RPPrCenter(AUACOF:W_Length)
     C                   Eval      *in72  = True
 
     C                   Else                                                   Else CSAcofCode
 
      **  If customer range was selected.
     C     CSFromCust    Ifne      'ALL'                                        Begin CSFromCust
     C                   Eval      AUCUSB = CSFromCust
     C                   Eval      AUCUSA = CSToCust
     C                   Eval      *in71  = True
     C                   Endif                                                  End CSFromCust
     C                   Endif                                                  End CSAcofCode
 
      **  If Main Customer Branch was selected.
     C     CSMainBrch    Ifne      'ALL'                                        Begin CSMainBrch
 
      **  Access to Branch Details, by ujsing Access Object,
      **  to get Branch name.
     C**********         Call      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*KEY   '     P_Optn
     C                   Parm      CSMainBrch    P_Brch
     C     Sdbrch        Parm      Sdbrch        Dssdy
 
      **  If no record found, handle database error.
     C     P_Rtcd        Ifne      *Blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDBRCHPD'                          ***************
     C                   Eval      Dbase  = 07                                  * Db Error 07 *
     C                   Eval      Dbkey  = P_Brch                              ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
     C                   Endif                                                  End P_Rtcd
 
     C                   Eval      AUBRCH = %Trim(ArrNarr(3)) + ' ' + CSMainBrch
     C                                      + ' ' + A8BRNM
     C                   Eval      W_Length = 132
     C                   Eval      AUBRCH = RPPrCenter(AUBRCH:W_Length)
     C                   Eval      *in73  = True
     C                   Endif                                                  End CSMainBrch
 
      **  Open Customer Master Details file.
     C                   Open      SDCUSTPD                             99
 
      **  Reset work fields.
     C                   Reset                   W_OpenP1
     C                   Reset                   W_OpenP2
     C                   Reset                   RCOUNT1
     C                   Reset                   RCOUNT2
 
     C                   Endsr
      /Eject
      *****************************************************************
      /Title SR/*Pssr
      *****************************************************************
      *                                                               *
      * *Pssr  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
 
     C     *Pssr         Begsr                                                  ** *Pssr SR **
 
     C     W_RunBefore   Ifne      'Y'                                          Begin W_RunBefore
     C                   Eval      W_RunBefore = 'Y'
 
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
 
     C                   Dump
     C                   Callb     'DBERRCTL'
 
      **  Ouput Audit Report.
     C                   Exsr      #Audit
 
     C                   Endif                                                  End W_RunBefore
 
     C                   Eval      *inlr = True
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
 
     C     *Inzsr        Begsr                                                  ** *Inzsr SR **
                                                                                196860
     C     *entry        plist                                                  196860
     C                   Parm                    Run               1            196860
 
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
     C                   Eval      Dbase  = 09                                  * Db Error 09 *
     C                   Eval      Dbkey  = '*first'                            ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
      **  Check if Portfolio Management Module is installed.
     C                   Callb     'AOMMODR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*FIRST'      P_Optn
     C     Sdmmod        Parm      Sdmmod        Dsfdy
 
      **  If Midas Module Details were not found, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDMMODPD'                          ***************
     C                   Eval      Dbase  = 08                                  * Db Error 08 *
     C                   Eval      Dbkey  = '*FIRST'                            ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
     C                   Endif                                                  End P_Rtcd
 
     C                   Endsr
     C/Eject
      *****************************************************************
**Ctdata ArrNarr
All Customers Account Officer
is responsible for
Main Customer Branch
**Ctdata POWER8
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
**Ctdata Cpy@
(c) Misys International Banking Systems Ltd. 2001
