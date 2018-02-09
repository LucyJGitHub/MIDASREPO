     H***DEBUG                                                                  192099
     H DEBUG FIXNBR(*INPUTPACKED)                                               192099
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB extract end of day postings')              *
      *****************************************************************
      *                                                               *
      *  Private Banking Module                                       *
      *                                                               *
      *  RP1403 - Extract End of Day Private Banking Retail Postings  *
      *                                                               *
      *  Function:  This program copies End of Day Retail Postings    *
      *             from EODPOPD to RPEODPPD for Private Banking      *
      *             customers only.                                   *
      *                                                               *
      *  (phase(s)) Close of Business.                                *
      *                                                               *
      *  Component of: RP1403 - Extract COB PB Postings.              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1026202          Date 15Oct12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 222414             Date 05Jun12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247095             Date 26Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL020             Date 12Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CPB005             Date 09May02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 192099             Date 19Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1026202 - PBS Compatibility with BankFusion Midas 2.00     *
      *              Interface "Account Transfer" in real time        *
      *              (Child:AR1026203)                                *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  222414 - Generate the posting with transaction type          *
      *           92051 for coupon, 92052 for dividend, 92053 for     *
      *           maturity to allow Tof performance split.            *
      *           Split is done in SE2450. (GEMS 209743)              *
      *           Applied for AR983495 (Child: AR983496)              *
      *  247095 - Send Dealing interim interest in case of reversal.  *
      *           Applied fix 224549.                                 *
      *         - Lending Reversal of Interest ans Repayment should   *
      *           also be sent to ToF. Applied fix 223314.            *
      *         - In addition to Retail accouts, transfer GL account  *
      *           postings for account codes designated for transfer  *
      *           to TOF and customer is for a valid portfolio.       *
      *           Patterned fix CPB004.                               *
      *         - Completed the above fixes since all were not coded. *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information (Recompile)                             *
      *  CPB005 - US Withholding Tax on Deposits generated during the *
      *           Midas COB + Midas/TOF Interface. Current interface  *
      *           excludes all postings with a source 'GE-DL'. If the *
      *           switchable feature CPB005 is on, this is amended to *
      *           detect the witholding tax postings, and send them   *
      *           to TOF even if the source is 'GE-DL'.               *
      *  192099 - Avoid Decimal Data Error                            *
      *  CPB002 - Meridian DBA Middleware Replication Customisation.  *
      *           Midas/TOF interface.                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **  SD Customer Master Details.
     FSDCUSTPD  IF   E           K Disk
     F                                     Infsr(*Pssr)
 
      **  GL End of day Retail Accounts Postings.
     FEODPOL1   IF   E           K Disk
     F                                     Infsr(*Pssr)
 
     F/COPY WNCPYSRC,RP1403F001
      **  PM Portfolio Definition                                                             247095
     FPMPORTLL  IF   E           K DISK    INFSR(*PSSR)                                       247095
                                                                                              247095
      **  Reversal Lending Transactions                                                       247095
     FPMLOANPD  IF   E           K Disk    Infsr(*Pssr)                                       247095
     F                                     Prefix(X_)                                         247095
      **  PB C.O.B. Postings Details.
     FRPEODPPD  O    E           K Disk    Rename(APOSTPDF:RPEODPD0)
     F                                     Infsr(*Pssr)
 
      **  PB Extracted Retail Postings audit report.
     FRP1403AU  O    E             Printer Infds(SpoolU)
     F                                     Infsr(*Pssr)
 
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *                                                               *
      *  81  -  End of file SDCUSTPD.                                 *
      *  82  -  End of file EODPOL1.
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
      *  #Rcfau  - Subroutine to register the AU Printer File via RCF *
      *  #Audit  - Subroutine to output Audit report.                 *
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
 
      **  Table containing Foreign Exchange and Money Market Deal Types.
     D TabDealTypes    S              2    Dim(40) Ctdata Perrcd(40)
 
      **  External Data structure for Local data area (database error details).
     D LDA           E DS           256    Extname(LDA) Dtaara(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      **  File Information Data Structure for printer file RP1403AU.
     D Spoolu          DS
     D  Sfileu                83     92
     D  Sfnumu               123    124B 0
 
      **  External data structure for Bank Details.
     D Sdbank        E DS                  Extname(SDBANKPD)
 
      **  External data structure for Account Code Details.                                   247095
     D Sdacod        E DS                  Extname(SDACODPD)                                  247095
                                                                                              247095
      **  Data structure for access programs, short data structure.
     D Dsfdy         E DS                  Extname(DSfDY)
 
      **  Data structure for access programs, long data structure.
     D Dssdy         E DS                  Extname(DSSDY)
                                                                                              CPB005
      **  Data structure for SAR  Details                                                     CPB005
     D SCSARD        E DS                  Extname(SCSARDPD)                                  CPB005
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** --------- Start of fields used by access programs ----------**
      **  Return code.
     D P_RtCd          S              7A
      **  Option.
     D P_Optn          S              7A
      **  Currency.
     D P_Curr          S              3A
      **  Account Code.                                                                       247095
     D P_Acod          S             10A                                                      247095
      **  US Withholding tax/deposits.                                                        CPB005
     D CPB005          S              1A                                                      CPB005
     D/COPY WNCPYSRC,RPH00001
     D P_sard          S              6A                                                      CPB005
                                                                                              247095
     D REVID           S              1A                                                      247095
     D PNAR01          S              4A                                                      247095
     D PNAR02          S             11A                                                      247095
     D LNRFAA          S              6A                                                      247095
     D ACODAA          S              4A                                                      247095
      ** ---------- End of fields used by access programs -----------**
 
      **  True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      **  Field used to position to first End of Day Retail Posting for customer.
     D*K_CustNum       S              6  0                                                    CSD027
     D K_CustNum       S              6                                                       CSD027
 
      **  Source of Posting.
     D W_SPOS6         S              6A
 
      **  Deal Type.
     D W_DealType      S              2A
 
      **  Payment Type.
     D W_PaymentType   S              2A
 
      **  Trade Reference.
     D W_TradeRef      S              6A
 
      **  Work Field used to produce only one dump.
     D W_RunBefore     S              1A
 
      **  Work Field used for the feature CPB004.                                             247095
     D WPB004          S              1A                                                      247095
     D/COPY WNCPYSRC,RPH00002
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
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *inzsr is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************
 
      **  Process only Private Banking Customers by using OPNQRYF
      **  with selection request SDCUSTPD/BBPRBA = 'Y'.
     C                   Read      SDCUSTPD                               81
 
      **  Do while Private Banking Customers to be processed.
     C     *in81         Doweq     False                                        Begin Do_W_81
 
      ****Define*Key*List*to*access*to*End*of*Day*Retail*Postings.*****                       247095
      *                                                                                       247095
      **  Define Key List to access to End of Day Retail Postings                             247095
      **  and General Ledger Postings.                                                        247095
      *                                                                                       247095
     C     K_EODRPost    Klist
     C                   Kfld                    K_CustNum
     C                   Move      BBCUST        K_CustNum
 
      ****Position*to*first*End*of*Day*retail*posting*for*customer.****                       247095
      *                                                                                       247095
      **  Position to first End of Day retail posting for customer                            247095
      **  and General Ledger Posting.                                                         247095
      *                                                                                       247095
     C     K_EODRPost    Setll     EODPOL1
     C     K_EODRPost    Reade     EODPOL1                                82
 
      ****Do*while*End*of*Day*retail*postings*to*be*processed.*********                       247095
      *                                                                                       247095
      **  Do while End of Day retail postings to be processed                                 247095
      **  and General Ledger Postings.                                                        247095
      *                                                                                       247095
     C     *in82         Doweq     False                                        Begin Do_W_82
 
      **  Set off indicator used to condition posting extract.
     C                   Eval      *in77 = False
     C                   Eval      *in76 = False                                              247095
      *                                                                                       247095
      ** Access Account Code details.                                                         247095
      *                                                                                       247095
     C                   Move      ACOD          P_Acod                                       247095
     C                   CALL      'AOACODR0'                                                 247095
     C                   PARM      *BLANKS       P_Rtcd                                       247095
     C                   PARM      '*KEY   '     P_Optn                                       247095
     C                   PARM                    P_Acod                                       247095
     C     SDACOD        PARM      SDACOD        Dssdy                                        247095
      *                                                                                       247095
      ** If CPB004 "Account Closing" is not present.                                          247095
      *                                                                                       247095
     C     WPB004        Ifne      'Y'                                                        247095
      *                                                                                       247095
      ** Omit if it is a General Ledger posting.                                              247095
      *                                                                                       247095
     C                   If        A5ACTY = 'G'                                               247095
     C                   Eval      *in76 = True                                               247095
     C                   Endif                                                                247095
      *                                                                                       247095
      ** CPB004 "Account Closing" is present.                                                 247095
      *                                                                                       247095
     C                   Else                                                                 247095
      *                                                                                       247095
      ** Must be transfered if it is a Retail Account.                                        247095
      *                                                                                       247095
     C                   If        A5ACTY = 'R'                                               247095
     C                             And A5TRAN = 'Y'                                           247095
     C                   Eval      *in76 = False                                              247095
     C                   Else                                                                 247095
     C                   Eval      *in76 = True                                               247095
     C                   EndIf                                                                247095
      *                                                                                       247095
      ** Will be maybe transfered if...                                                       247095
      *                                                                                       247095
     C                   If        A5ACTY = 'G'                                               247095
     C                             And A5TRAN = 'Y'                                           247095
      *                                                                                       247095
      ** And if it is a valid portfolio                                                       247095
      *                                                                                       247095
     C                   Move      CNUM          W_Cnum                                       247095
      *                                                                                       247095
      ** And if the 4 last positions of OTRF is numeric                                       247095
      ** or blank.                                                                            247095
      *                                                                                       247095
     C                   Move      OTRF          W_Ptfr                                       247095
     C                   Move      '00000'       @@TEST1           5                          247095
     C                   Movel     W_Ptfr        @@TEST1                                      247095
     C                   TESTN                   @@TEST1              91                      247095
     C     W_Ptfr        IFNE      *BLANKS                                                    247095
     C     *IN91         ANDEQ     '1'                                                        247095
                                                                                              247095
     C     WWPORT        Chain     PMPORTLL                           90                      247095
      *                                                                                       247095
      ** If found ...                                                                         247095
      *                                                                                       247095
     C     *IN90         IfEq      *Off                                                       247095
     C*****TRAT          Andeq     *zero                                               247095 222414
     C                   Eval      *in76 = False                                              247095
                                                                                              247095
     C     TRAT          Ifeq      *zero                                                      222414
     C     TRST          IfEq      'PS'                                                       247095
     C                   z-add     98001         TRAT                                         247095
     C                   Else                                                                 247095
     C                   z-add     98002         TRAT                                         247095
     C                   EndIf                                                                247095
     C                   ENDIF                                                                222414
      *                                                                                       247095
      ** Not found ...                                                                        247095
      *                                                                                       247095
     C                   EndIf                                                                247095
                                                                                              247095
     C                   EndIf                                                                247095
     C                   EndIf                                                                247095
                                                                                              247095
     C                   EndIf                                                                247095
 
      **  Omit batch items
     C                   Eval      W_Spos6 = SPOS
     C                   Testn                   W_Spos6              77
     C/COPY WNCPYSRC,RPH00003
 
     C                   Select                                                 Begin Select
 
      **  Omit if Foreign Exchange or Money Market Deals.
     C     SPOS          Wheneq    '  GE-DL'                                    Dealing
      **                                                                                      CPB005
     C     CPB005        Ifeq      'N'                                                        CPB005
     C     CPB005        Oreq      'Y'                                                        CPB005
     C     TRAT          Andne     98100                                                      CPB005
     C                   Eval      W_DealType = OTTP
     C     W_DealType    Lookup    TabDealTypes                           77
     C                   Endif                                                                CPB005
      *                                                                                       247095
      ** Sent Reversal of Interest in case of reversal                                        247095
      *                                                                                       247095
     C                   Eval      REVID = %Subst(PNAR:30:1)                                  247095
     C                   Eval      PNAR01 = %Subst(PNAR:8:4)                                  247095
      *                                                                                       247095
     C     REVID         Ifeq      '*'                                                        247095
     C     PNAR01        Andeq     'INT '                                                     247095
      *                                                                                       247095
     C                   Eval      TRAT = 92000                                               247095
      *                                                                                       247095
      ** Reverse Sign and set Value Date to Posting Date                                      247095
      *                                                                                       247095
     C                   Eval      VALD = PSTD                                                247095
     C                   Eval      *in77 = False                                              247095
     C                   Endif                                                                247095
 
      **  Omit if Fund Transfer Incoming or Outgoing Payments.
     C     SPOS          Wheneq    '  GE-FT'                                    Funds Transfer
     C                   Eval      W_PaymentType = OTTP
     C     W_PaymentType Ifeq      'OP'                                         Begin W_PaymentType
     C     W_PaymentType Oreq      'IN'
     C                   Eval      *in77 = True
 
     C                   End                                                    End W_PaymentType
 
      **  Omit if Lending.
     C     SPOS          Wheneq    '  GE-LE'                                    Lending
     C                   Eval      *in77 = True
      *                                                                                       247095
      ** Sent Reversal of Interest and/or Repayment                                           247095
      *                                                                                       247095
     C                   Eval      REVID = %Subst(PNAR:30:1)                                  247095
     C                   Eval      PNAR01 = %Subst(PNAR:8:4)                                  247095
     C                   Eval      PNAR02 = %Subst(PNAR:8:11)                                 247095
     C                   Eval      LNRFAA = %Subst(PNAR:1:6)                                  247095
      *                                                                                       247095
     C     REVID         Ifeq      '*'                                                        247095
      *                                                                                       247095
     C     PNAR01        Ifeq      'INT '                                                     247095
     C     PNAR02        Oreq      'LOAN REPAY '                                              247095
      *                                                                                       247095
      ** Retrieve Account Code on loan file.                                                  247095
      *                                                                                       247095
     C**********         MOVEL     LNRFAA        NNLNRF            6 0                 247095 CLE148
     C*****NNLNRF        Chain     PMLOANPD                           69               247095 CLE148
     C     LNRFAA        CHAIN     PMLOANPD                           69                      CLE148
     C     *IN69         Ifeq      *Off                                                       247095
     C                   Eval      ACODAA = %subst(X_OMDA:7:4)                                247095
     C                   MOVEL     ACODAA        ACOD                                         247095
     C                   Eval      TRAT = 92020                                               247095
      *                                                                                       247095
      ** Reverse Sign and set Value Date to Posting Date                                      247095
      *                                                                                       247095
     C                   Z-SUB     PSTA          PSTA                                         247095
     C                   Eval      VALD = PSTD                                                247095
     C                   Eval      *in77 = False                                              247095
     C                   Eval      *in76 = False                                              247095
     C                   Endif                                                                247095
     C                   Endif                                                                247095
     C                   Endif                                                                247095
 
      **  Omit if Securities Trading coming from Trades Settlement.
     C     SPOS          Wheneq    '  GE-ST'                                    Securities Trading
     C     TRAT          Andne     92299
     C     TRAT          Andne     98101
     C     TRAT          Andne     98102
     C     TRAT          Andne     98103
     C                   Eval      W_TradeRef = OTRF
     C     W_TradeRef    Ifne      '000000'                                     Begin W_TradeRef
     C                   Eval      *in77 = True
 
     C                   End                                                    End W_TradeRef
 
      **  Omit if Interest Postings.
     C     SPOS          Wheneq    '  GE-IC'                                    Interests
     C     TRAT          Andne     91050
     C                   Eval      *in77 = True
 
      ** Omit if Account Transfer Postings                                                 AR1026202
     C     SPOS          WHENEQ    '  GE-TX'                                               AR1026202
     C                   EVAL      *IN77 = TRUE                                            AR1026202
                                                                                           AR1026202
     C                   Endsl                                                  End Select
 
      **  If End of Day posting has to be extracted.
     C     *in77         Ifeq      False                                        Begin *in77
     C     *in76         Andeq     False                                                      247095
     C                   Write     RPEODPD0
     C                   Eval      RCOUNT = RCOUNT + 1
 
     C                   End                                                    End *in77
 
      **  Read next End of Day retail posting for customer.
     C     K_EODRPost    Reade     EODPOL1                                82
 
     C                   Enddo                                                  End DO_W_82
     C/COPY WNCPYSRC,RP1403C001
 
      **  Read next Private Banking Cusqtomer.
     C                   Read      SDCUSTPD                               81
 
     C                   Enddo                                                  End DO_W_81
 
      **  Print Audit Report.
     C                   Exsr      #Audit
 
      **  Exit from program.
     C                   Eval      *inlr = True
     C                   Return
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
      *
     C     #Rcfau        Begsr                                                  ** #Rcfau SR **
 
      **  Ensure Audit Spool File recorded by RCF.
     C                   move      Sfnumu        Zsnumu
 
     C                   Call      'ZSFILE'
     C                   Parm      *Blanks       Seq               5
     C                   Parm      *Blanks       Senty             3
     C                   Parm                    Sfileu
     C                   Parm                    Zsnumu            6 0
     C                   Parm      *Blank        Zserr             1
 
      **  If Error occurs during ZSFILE processing, then return to the
      **  Calling Program.
     C     Zserr         Ifeq      'Y'                                          Begin Zserr
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
     C                   Eval      *inlr = True
     C                   Return
      *
     C                   Endif                                                  End Zserr
      *
     C                   Endsr
      *
      /Eject
      *****************************************************************
      /Title SR/#Audit
      *****************************************************************
      *                                                               *
      *  #Audit  - Subroutine to output Audit report.                 *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #Audit        Begsr                                                  ** #Audit SR **
 
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
     C/COPY WNCPYSRC,RP1403C002
     C                   Write     NODTLS
 
     C                   Endif                                                  End RCOUNT
 
     C                   Endif                                                  End *inu7
 
     C                   Endsr
      *
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
      *
     C     *Pssr         Begsr                                                  ** *Pssr SR **
 
     C     W_RunBefore   Ifne      'Y'                                          Begin W_RunBefore
     C                   Eval      W_RunBefore = 'Y'
 
     C                   Eval      *inu7 = True
     C                   Eval      *inu8 = True
 
     C                   Dump
 
     C                   Endif                                                  End W_RunBefore
 
      **  Ouput Audit Report.
     C                   Exsr      #Audit
 
     C                   Eval      *inlr = True
     C                   Return
 
     C                   Endsr
      *
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
 
      **  Access Bank details by using access program.
     C                   Callb     'AOBANKR0'
     C                   Parm      *blanks       P_Rtcd
     C                   Parm      '*FIRST '     P_optn
     C     Sdbank        Parm      Sdbank        Dssdy
 
      **  If Bank details do not exist, handle database error.
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDBANKPD'                          ***************
     C                   Eval      Dbase  = 02                                  * Db Error 02 *
     C                   Eval      Dbkey  = '*first'                            ***************
     C                   Out       LDA
     C                   Exsr      *Pssr
 
     C                   Endif                                                  End  P_Rtcd
      *                                                                                       247095
      ** Access Bank details by using access program.                                         247095
      *                                                                                       247095
     C                   Eval      WPB004 = 'N'                                               247095
     C                   Callb     'AOSARDR0'                                                 247095
     C                   Parm      *blanks       P_Rtcd            7                          247095
     C                   Parm      '*VERIFY'     P_optn            7                          247095
     C                   Parm      'CPB004'      P_Sard            6                          247095
     C     Scsard        Parm      Scsard        Dsfdy                                        247095
      *                                                                                       247095
      ** If any error occurred when checking feature.                                         247095
      *                                                                                       247095
     C     P_Rtcd        Ifne      *blanks                                                    247095
     C     P_Rtcd        andne     '*NRF   '                                                  247095
     C     *lock         In        Lda                                                        247095
     C                   Eval      Dbpgm  = PSProcName                                        247095
     C                   Eval      Dbfile = 'SCSARDPD'                          **************247095
     C                   Eval      Dbase  = 03                                  * Db Error 03 247095
     C                   Eval      Dbkey  = P_Sard                              **************247095
     C                   Out       LDA                                                        247095
     C                   Exsr      *Pssr                                                      247095
                                                                                              247095
     C                   Endif                                                                247095
      *                                                                                       247095
      ** If feature is installed.                                                             247095
      *                                                                                       247095
     C     P_Rtcd        Ifeq      *blanks                                                    247095
     C                   Eval      WPB004 = 'Y'                                               247095
                                                                                              247095
     C                   Endif                                                                247095
      *                                                                                       247095
      ** Define KLIST to access PMPORTLL.                                                     247095
      *                                                                                       247095
     C     WWPORT        KList                                                                247095
     C                   KFld                    W_Cnum            6                          247095
     C                   KFld                    W_Ptfr            4                          247095
 
      **  Access SAR details via access program                                               CPB005
     C                   Callb     'AOSARDR0'                                                 CPB005
     C                   Parm      *blanks       P_Rtcd                                       CPB005
     C                   Parm      '*KEY   '     P_optn                                       CPB005
     C                   Parm      'CPB005'      P_sard                                       CPB005
     C     Scsard        Parm      Scsard        Dsfdy                                        CPB005
                                                                                              CPB005
     C     P_Rtcd        Ifeq      *blanks                                      Begin P_Rtcd  CPB005
     C                   Eval      CPB005   = 'Y'                                             CPB005
     C                   Else                                                   Else  P_Rtcd  CPB005
     C                   Eval      CPB005   = 'N'                                             CPB005
     C                   Endif                                                  End   P_Rtcd  CPB005
                                                                                              CPB005
     C/COPY WNCPYSRC,RP1403C003
     C                   Endsr
     C/Eject
      *****************************************************************
**Ctdata Cpy@
(c) Finastra International Limited 2001
**Ctdata TabDealTypes
FPFSCXPISIOPOTSWIPITTDTILNCICDCLDL
