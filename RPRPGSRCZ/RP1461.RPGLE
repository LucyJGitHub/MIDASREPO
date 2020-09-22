     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Retail Accounts                 - take on')   *
      *****************************************************************
      *                                                               *
      *  Private Banking Module                                       *
      *                                                               *
      *  RP1461 - Retail Accounts take on.                            *
      *                                                               *
      *  Function:    This module updates Retail Accounts             *
      *            Replication Indicator field so that record would   *
      *            be processed by Meridian Replication functions,    *
      *            for take on purpose.                               *
      *                                                               *
      *  Component of: RPC1461 - Retail Accounts take on.             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 206100             Date 27Jun02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 198158             Date 24Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  206100 - "Gateway to PB" : Transactions, Portfolios not sent *
      *           Remove GEMS 198158 !                                *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  198158 - If error avoid Transactions transfer for customer PM*
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
 
      **  GL Account Master Details.
     FACCNT     UF   E           K Disk
     F                                     Infsr(*Pssr)
     F                                     Commit
 
      **  PB Retail Accounts take on report.
     FRP1461P1  O    E             Printer Infds(Spool1)
     F                                     Infsr(*Pssr)
     F                                     Usropn
 
      **  PB Retail Accounts take on audit report.
     FRP1461AU  O    E             PRINTER Infds(SpoolU)
     F                                     Infsr(*Pssr)
     F                                     Usropn
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  70  -  Redisplay screen.                                     *
      *                                                               *
      *  81  -  End of file CLINTCB.                                  *
      *  82  -  End of file ACCNT.                                    *
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
      *       * 61   62   63   64   65   66   67   68   69   xx *     *
      *       * 71   72   73   74   75   76   77   78   79   80 *     *
      *       * xx   xx   83   84   85   86   87   88   89   90 *     *
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
      *  #Report - Subroutine to print details of processed record.   *
      *  #Rcfp1  - Subroutine to register the P1 Printer File via RCF *
      *  #Rcfau  - Subroutine to register the AU Printer File via RCF *
      *  #Audit  - Subroutine to Output Audit report.                 *
      *  #Init   - Initialization subroutine.                         *
      *  *Pssr   - Program exception error routine                    *
      *  *inzsr  - Program Initialization routine.                    *
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
 
      **  Array containing Copyright statement.
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
 
      **  Array containing narratives.
     D ArrNarr         S             80    Dim(3) Ctdata Perrcd(1)
 
      **  Array used to align all amounts on decimal point.
     D ARR_Amount      S              1    Dim(25)
 
      **  File Information Data Structure for printer file RP1461P1.
     D Spool1          DS
     D  Sfile1                83     92
     D  Sfnum1               123    124B 0
     D  Oflln1               188    189B 0
     D  Prtln1               367    368B 0
 
      **  File Information Data Structure for printer file RP1461AU.
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
 
      **  External data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      **  Customer Selection Data Area.
     D RPCust        E DS                  Extname(RPCUST) DTAARA(RPCUST)
 
      **  External data structure for Account Officer Details.
     D Sdacof        E DS                  Extname(SDACOFPD)
 
      **  External data structure for Branch Details.
     D Sdbrch        E DS                  Extname(SDBRCHPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
 
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
 
      **  Field used to position to first Account for customer.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6A                                                      CSD027
 
      **  Work Field used to open P1 printer file only once.
     D W_OpenP1        S              1A
 
      **  Work Field used to change value of field ACCNTAB/REPI.
     D W_REPI          S              2  0
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **  Length passed to formatting procedure RPPrCenter.
     D W_Length        S              3P 0
 
      **  Work field used to condition run of take on.
     D W_Takeon        S              1A
 
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
      ****Process*only*Customers**whose*Portfolio*Management*Details*exist      198158
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
 
      **  Define key list to access to Account Master Details.
     C     K_GLAccn      Klist
     C                   Kfld                    K_CustNum
 
      **  Set up Key list to access to Account Master Details.
     C                   Move      BBCUST        K_CustNum
 
      **  Position on first Account.
     C     K_GLAccn      Setll     ACCNT
     C     K_GLAccn      Reade     ACCNT                                  82
 
      **  Do while Accounts to be processed for required selection.
     C     *in82         Doweq     False                                        Begin Do_W_N82
 
      **  Process only live retail accounts.
     C     RECI          Ifeq      'D'                                          Begin RECI
     C     ATYP          Andeq     'R'
 
      **  Update Replication Indicator field.
     C                   Testn                   REPI                 77
 
      **  If Replication Indicator is numeric.
     C     *in77         Ifeq      True                                         Begin *in77
     C                   Move      REPI          W_REPI
     C                   Add       1             W_REPI
 
      **  If Replication Indicator is not numeric.
     C                   Else                                                   Else *in77
     C                   Eval      W_REPI = 1
 
     C                   Endif                                                  End *in77
     C                   Move      W_REPI        REPI
 
      **  Update Account Master Details file record.
     C                   Update    ACCNTABF
 
      **  Print Retail Account informations on report.
     C                   Exsr      #Report
 
     C                   Endif                                                  End RECI
 
      **  Read next Retail Account record.
     C     K_GLAccn      Reade     ACCNT                                  82
 
     C                   Enddo                                                  End Do_W_N82
 
     C                   Endif                                                  End W_Takeon
 
      **  Read next Customer.
     C                   Read      SDCUSTPD                               81
 
     C                   Enddo                                                  End Do_W_N81
 
      **  Close Customer Master Details file.
     C                   Close     SDCUSTPD
 
      **  Commit.
     C                   COMMIT
 
      **  If at least one line has been printed.
     C     RCOUNT        Ifgt      0                                            Begin RCOUNT
 
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
 
      **  Close Retail Accounts take on Report printer file.
     C                   Close     RP1461P1
 
     C                   Endif                                                  End RCOUNT
 
      **  Print Audit Report.
     C                   Exsr      #Audit
 
      **  End Program and Return.
     C                   Return
 
      /Eject
      *****************************************************************
      /Title SR/#Report
      *****************************************************************
      *                                                               *
      *  #Report - Subroutine to print details of processed record.   *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     #Report       Begsr                                                  ** #Report SR **
 
      **  Insure Audit Report Spool File was recorded by RCF.
     C     W_OpenP1      Ifeq      *blank                                       Begin W_OpenP1
     C                   Eval      W_OpenP1 = 'Y'
     C                   Open      RP1461P1
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
     C                   Move      CNUM          P1CNUM                         Customer number
     C                   Eval      P1CCY  = CCY                                 Currency code
     C                   Move      ACOD          P1ACOD                         Account code
     C                   Move      ACSQ          P1ACSQ                         Account sequence
     C                   Eval      P1BRCA = BRCA                                Branch code
 
      **  Retrieve currency number of decimal places.
     C                   Callb     'AOCURRR0'
     C                   Parm      *blank        P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   Parm      CCY           P_Curr                         I:Key field
     C     Sdcurr        Parm      Sdcurr        Dssdy                          O:Format
 
      **  If currency does not exist, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDCURRPD'                          ***************
     C                   Eval      Dbase  = 01                                  * Db Error 01 *
     C                   Eval      Dbkey  = CCY                                 ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
 
      **  Format Cleared Balance.
     C                   Eval      Zfld15 = CLBL
     C                   Eval      Zdecs  = A6NBDP
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
     C                   Movea     ARR_Amount(1) P1CLBL                         Cleared balance
 
      **  Format Ledger Balance.
     C                   Eval      Zfld15 = LDBL
     C                   Eval      Zdecs  = A6NBDP
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
     C                   Movea     ARR_Amount(1) P1LDBL                         Ledger balance
 
      **  Check that sufficient lines remain for the Format. If not,
      **  write out the Main Headings on a new page.
     C                   Eval      Rqdln1 = 2
     C                   Eval      Difln1 = Oflln1 - Prtln1
     C     Difln1        Ifle      Rqdln1                                       Begin Difln1
 
      **  If end of page, print relevant record format.
     C     RCOUNT        Ifgt      0                                            Begin RCOUNT
     C                   Write     ENDPAG1
 
     C                   Endif                                                  End RCOUNT
 
     C                   Write     HEADP1
 
     C                   Endif                                                  End Difln1
 
      ** Write record details.
     C                   Write     DETAIL1
     C                   Eval      RCOUNT = RCOUNT + 1
 
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
     C                   Eval      CSRetnCode = 'ZSRP1461P1'
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
     C                   Eval      CSRetnCode = 'ZSRP1461AU'
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
     C                   Open      RP1461AU                             99
 
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
     C     RCOUNT        Ifeq      0                                            Begin RCOUNT
     C                   Write     NODTLS
 
     C                   Endif                                                  End RCOUNT
 
     C                   Endif                                                  End *inu7
 
      **  Close Audit Report printer file.
     C                   Close     RP1461AU
 
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
     C                   Eval      Dbase  = 02                                  * Db Error 02 *
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
     C**********         CALL      'AOBRCHR0'                                                 CGL029
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
     C                   Eval      Dbase  = 03                                  * Db Error 03 *
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
     C                   Reset                   RCOUNT
 
      **  Open Audit Report printer file.
     C                   Open      RP1461AU                             99
 
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
     C                   Eval      Dbase  = 04                                  * Db Error 04 *
     C                   Eval      Dbkey  = '*FIRST'                            ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End P_Rtcd
 
     C                   Endsr
     C/Eject
      *****************************************************************
**Ctdata Cpy@
(c) Finastra International Limited 2001
**Ctdata ArrNarr
All Customers Account Officer
is responsible for
Main Customer Branch
