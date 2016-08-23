     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Withholding Tax Calc for Thresholds')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  ZATXCLTH - Midas ZA Withholding Tax Calculation for          *
      *             Thresholds                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. AR749044           Date 04May11               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG26979           Date 22Jan10               *
      *                 BUG26839           Date 05Jan10               *
      *                 BUG26746           Date 13Nov09               *
      *                 BUG24190           Date 04Jun09               *
      *                 BUG24051           Date 28May09               *
      *                 BUG23732           Date 23Apr09               *
      *                 BUG24084           Date 25May09               *
      *                 BUG23877           Date 06May09               *
      *                 BUG23657           Date 13Apr09               *
      *                 BUG23115A          Date 02Mar09               *
      *                 BUG23009A          Date 27Feb09               *
      *                 BUG22953A          Date 25Feb09               *
      *                 BUG22911*CREATE    Date 17Feb09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR749044 - Manual interest adjustment did reverse threshold  *
      *             utilized on retail account. (Child: AR749045)     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26979 - Serious Midas error encountered while trying      *
      *             to roll-over                                      *
      *  BUG26839 - JA1_Threshold limit of the main joint customer was*
      *             utilized by the member                            *
      *  BUG26746 - EU tax for a taxable customer was computed on MM  *
      *             deal which is defined as 'Taxable No'             *
      *  BUG24190 - Incorrect computation of Portion of Threshold used*
      *  BUG24051 - Incorrect Threshold Utilisation Postings          *
      *  BUG23732 - Joint Account threshold                           *
      *  BUG24084 - Change the definiton of parameter                 *
      *  BUG23877 - Apply Thrshold When Thrshold Expiry Date is Zero  *
      *  BUG23657 - Threshold/Certificate Value date and expiry date  *
      *  BUG23115A - Limit utilisation is not updating correctly      *
      *              for both dealing and retail.                     *
      *  BUG23009A- Seconday Tax Duducted from Net Interest Amount    *
      *             in Tax Ccy                                        *
      *  BUG22953A - Secondary and Main tax not calculated on OSIC    *
      *  BUG22911 - Changes for Correct Tax Calculation               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *  ===============================                              *
      *                                                               *
      *  *INZSR         Initial processing                            *
      *  SRChkThreshld  Check for Threshold and non-taxable           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Interest Payment History File
      *
     FSDINPHL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Interest Payment History for Joint Accounts                                        BUG23732
      *                                                                                     BUG23732
     FSDINPHL3  IF   E           K DISK    INFSR(*PSSR)                                     BUG23732
     F                                     RENAME(SDINPHD0:SDINPHD3)                        BUG23732
      *****************************************************************
     F/EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,and the following
      ** named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes the definitions
      ** for error and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      *
      ** Array containing powers for Ccy conversion
      *
     D Power           S              7  3 DIM(7) CTDATA PERRCD(1)
     D CurrArr         S              3A   DIM(500)
     D NBDPArr         S              1S 0 DIM(500)
     D SPRTArr         S             13P 8 DIM(500)
     D MDINArr         S              1A   DIM(500)
      *
     D CER048          S              1A
     D PInth           S              1A
     D EWTHMD          S              1A
     D PCust           S              6A
     D PNarf           S             10A                                                    BUG26979
     D PToti           S             15P 0
     D PToto           S             15P 0
     D PUtil           S             15P 0
     D PPort           S             15P 0
     D PKey            S             10A
     D PFile           S             10A
     D***PRtrn           S             10A                                                  BUG24084
     D PRtrn           S              7A                                                    BUG24084
     D POCCY           S              3A
     D PJAMG           S              1A                                                    BUG26839
     D WCuth           S             15P 0
     D WSchk           S             15P 0
     D WToti           S             15P 0
     D WCcy            S              3A
     D Ix              S              3P 0
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
      *
     D PCcy            S              3A
      *
     D WUtil           S             15P 0
     D SUtil           S             15P 0                                                  AR749044
     D AUtil           S             15P 0                                                  AR749044
     D BaseNBDP        S              1S 0
     D BaseRate        S             13P 8
     D BaseMDIN        S              1A
     D WNBDP           S              1S 0
     D WSPRT           S             13P 8
     D WMDIN           S              1A
      *                                                                                     BUG23732
     D KJoin           S                   LIKE(TIJOIN)                                     BUG23732
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Sar Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** First DS for access programs - short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Dummy Long Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External DS for Currency Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *                                                                                     BUG23657
      ** Exemption and Certificate Dates                                                    BUG23657
     D SDTXDT          DS                                                                   BUG23657
     D   PEVDT                        5P 0                                                  BUG23657
     D   PEXDT                        5P 0                                                  BUG23657
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      **         P R O G R A M    S T A R T                           *
      *****************************************************************
      *
     C                   IF        CER048 = 'Y'
     C                   IF        PCUST <> *BLANKS AND                                     BUG26979
     C                             PNARF = *BLANKS                                          BUG26979
     C                   EXSR      SRChkThreshld
     C                   ELSE                                                               BUG26979
     C                   EXSR      SRNahoProc                                               BUG26979
     C                   ENDIF                                                              BUG26979
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON                                              BUG23732
     C                   RETURN
      *****************************************************************
      **         P R O G R A M    E N D                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkThreshld - Check for Threshold and non-taxable          *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRChkThreshld BEGSR
      *
     C                   EVAL      WSchk = *ZEROS
     C                   EVAL      WCcy = *BLANKS
     C                   EVAL      WCuth = *ZEROS
     C                   EVAL      WToti = *ZEROS
     C**********         IF        PToti < *Zero                                  BUG22953A AR749044
     C**********         EVAL      PToti = PToti * -1                             BUG22953A AR749044
     C**********         ENDIF                                                    BUG22953A AR749044
     C                   EVAL      PToto = PToti
     C                   EVAL      WUtil = *ZEROS
     C                   EVAL      SUtil = *ZEROS                                           AR749044
      *
      ** Applying Threshold, if any on Taxable Amount
      *
     C                   IF        PInth = 'T' AND EWTHMD = 'Y'
     C                             AND PEVDT <= BJRDNB                                      BUG23657
     C                             AND PEXDT >= BJRDNB                                      BUG23657
     C                             OR PInth = 'T' AND EWTHMD = 'Y'                          BUG23877
     C                             AND PEVDT <= BJRDNB AND                                  BUG23877
     C                             PEXDT = *ZEROS                                           BUG23877
      *
      ** Check for different currencies
      *
     C                   IF        POCCY <> BJCYCD
      *
      ** Convert gross interest in base currency
      *
     C                   EVAL      PCcy = POCCY
     C                   EXSR      SRCurrDetl
      *
     C                   EVAL      ZAMTF = PTOTI
     C                   EVAL      ZCCYF = POCCY
     C                   EVAL      ZCCYT = BJCYCD
     C                   EVAL      ZCDPF = WNBDP
     C                   EVAL      ZCDPT = BaseNBDP
     C                   EVAL      ZRATEF = WSPRT
     C                   EVAL      ZRATET = BaseRate
     C                   EVAL      ZMDINF = WMDIN
     C                   EVAL      ZMDINT = BaseMDIN
      *
     C                   EXSR      ZCCYCN
      *
     C                   EVAL      WTOTI  = ZAMTT
     C                   ELSE
     C                   EVAL      WTOTI  = PTOTI
     C                   ENDIF
      *
      ** Check for threshold details in interest payment history file
      *
     C     PCust         CHAIN     SDINPHL1
     C                   IF        %FOUND(SDINPHL1)
      *                                                                                     BUG23732
     C                   EVAL      PUtil = TIUTTH                                           BUG24051
     C                   EVAL      AUtil = TIGSIN                                           AR749044
      *                                                                                     BUG24051
      ** Joint Management Account Type 1 & 2                                                BUG26839
     C                   SELECT                                                             BUG26839
                                                                                            BUG26839
     C                   WHEN      PJAMG = '1'  OR                                          BUG26839
     C                             PJAMG = '2'                                              BUG26839
                                                                                            BUG26839
     C                   EVAL      WUtil = TIUTTH                                           BUG26839
     C                   EVAL      SUtil = TIGSIN                                           AR749044
     C                   EVAL      WCuth = TICUTH                                           BUG26839
                                                                                            BUG26839
      ** Joint Management Type 3                                                            BUG26839
     C                   OTHER                                                              BUG26839
                                                                                            BUG26839
     C                   IF        TIJOIN = *BLANKS                                         BUG23732
      *
     C                   EVAL      WUtil = TIUTTH
     C                   EVAL      SUtil = TIGSIN                                           AR749044
     C                   EVAL      WCuth = TICUTH
      *
      ** Check for Joint customer                                                           BUG23732
      *                                                                                     BUG23732
     C                   ELSE                                                               BUG23732
     C                   EVAL      KJoin = TIJOIN                                           BUG23732
      *                                                                                     BUG23732
     C     KJoin         SETLL     SDINPHL3                                                 BUG23732
     C     KJoin         READE     SDINPHL3                                                 BUG23732
      *                                                                                     BUG23732
     C                   DOW       NOT %EOF(SDINPHL3)                                       BUG23732
     C                   EVAL      WUtil = WUtil + TIUTTH                                   BUG23732
     C                   EVAL      SUtil = SUtil + TIGSIN                                   AR749044
     C                   EVAL      WCuth = WCuth + TICUTH                                   BUG23732
     C     KJoin         READE     SDINPHL3                                                 BUG23732
     C                   ENDDO                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDSL                                                              BUG26839
                                                                                            BUG26839
     C                   ENDIF
      *
     C                   IF        BaseNBDP > 0
     C                   EVAL      WCuth = WCuth * (10 ** BaseNBDP)
     C                   ENDIF
      *
     C                   IF        WToti > 0                                                AR749044
     C                   EVAL      WSchk = WToti + WUtil
      *
     C                   IF        WSchk <= WCuth
     C                   EVAL      PToto = *ZEROS
     C                   EVAL      PPort = WToti
     C**********         EVAL      PUtil = WUtil + WToti                                    BUG24051
     C                   EVAL      PUtil = PUtil + WToti                                    BUG24051
      *
     C                   ELSE
      *
     C                   EVAL      PToto = WSchk - WCuth
     C**********         EVAL      PPort = WCuth - WSchk                                    BUG24190
     C                   EVAL      PPort = WCuth - WUtil                                    BUG24190
     C**********         EVAL      PUtil = WCuth                                            BUG24051
     C                   EVAL      PUtil = PUtil + WToti                                    BUG24051
      *
     C                   ENDIF
                                                                                            AR749044
     C                   ELSE                                                               AR749044
      *                                                                                     AR749044
      ** Process manual/generated adjustment                                                AR749044
      *                                                                                     AR749044
     C                   EVAL      PToto = *Zero                                            AR749044
     C                   EVAL      PPort = WCuth - SUtil                                    AR749044
     C                   EVAL      PUtil = AUtil + WToti                                    AR749044
     C                   IF        SUtil > Wcuth                                            AR749044
     C                   EVAL      WSchk = WCuth - SUtil                                    AR749044
                                                                                            AR749044
     C                   IF        WSchk < WToti                                            AR749044
     C                   EVAL      PToto = WToti                                            AR749044
     C                   ELSE                                                               AR749044
     C                   EVAL      PToto = WSchk                                            AR749044
     C                   ENDIF                                                              AR749044
                                                                                            AR749044
     C                   ENDIF                                                              AR749044
                                                                                            AR749044
     C                   ENDIF                                                              AR749044
      *
      ** Convert output gross interest back into original currency
      *
     C                   IF        POCCY <> BJCYCD
      *
      ** Only actually convert if output amount is different
      *
     C                   IF        PToto = WToti
     C                   EVAL      PToto = PToti
     C                   ELSE
      *
     C                   EVAL      ZAMTF = PTOTO
     C                   EVAL      ZCCYT = POCCY
     C                   EVAL      ZCCYF = BJCYCD
     C                   EVAL      ZCDPT = WNBDP
     C                   EVAL      ZCDPF = BaseNBDP
     C                   EVAL      ZRATET = WSPRT
     C                   EVAL      ZRATEF = BaseRate
     C                   EVAL      ZMDINT = WMDIN
     C                   EVAL      ZMDINF = BaseMDIN
      *
     C                   EXSR      ZCCYCN
      *
     C                   EVAL      PTOTO  = ZAMTT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Do not tax if transaction not taxable
      *
     C**********         IF        PInth = 'N' AND EWTHMD = 'Y'                             BUG26746
     C                   IF        PInth = 'N'                                              BUG26746
     C                   EVAL      PToto = *ZEROS
     C                   EVAL      PPort = *ZEROS
      *                                                                                    BUG23115A
     C     PCust         CHAIN     SDINPHL1                                                BUG23115A
     C                   IF        %FOUND(SDINPHL1)                                        BUG23115A
     C                   EVAL      PUtil = TIUTTH                                          BUG23115A
     C                   ENDIF                                                             BUG23115A
      *                                                                                    BUG23115A
     C**********         EVAL      PUtil = WUtil                                           BUG23115A
     C                   ENDIF
      *                                                                                     BUG23732
      ** Always tax if transaction is taxable                                               BUG23732
      *                                                                                     BUG23732
     C                   IF        PInth = 'Y' AND EWTHMD = 'Y'                             BUG23732
     C                   EVAL      PPort = *ZEROS                                           BUG23732
      *                                                                                     BUG23732
     C     PCust         CHAIN     SDINPHL1                                                 BUG23732
     C                   IF        %FOUND(SDINPHL1)                                         BUG23732
     C                   EVAL      PUtil = TIUTTH                                           BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCurrDetl - Get the Currency Details                        *
      *                                                               *
      *  Called by: SRAmtConv                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCurrDetl    BEGSR
      *
     C                   EVAL      Ix = 0
     C                   EVAL      Ix = %LOOKUP(PCcy:CurrArr)
      *
     C                   IF        Ix <> *ZEROS
      *
     C                   EVAL      WNBDP = NBDPArr(Ix)
     C                   EVAL      WSPRT = SPRTArr(Ix)
     C                   EVAL      WMDIN = MDINArr(Ix)
      *
     C                   ELSE
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   EVAL      Ix = %LOOKUP(WCcy:CurrArr)
      *
     C                   EVAL      NBDPArr(Ix) = A6NBDP
     C                   EVAL      SPRTArr(Ix) = A6SPRT
     C                   EVAL      MDINArr(Ix) = A6MDIN
      *
     C                   EVAL      WNBDP = A6NBDP
     C                   EVAL      WSPRT = A6SPRT
                                                                                           BUG23009A
     C                   IF        A6MDIN = 'M'                                            BUG23009A
                                                                                           BUG23009A
     C                   EVAL      WSPRT = A6SPRT - A6TCMP                                 BUG23009A
     C                   EVAL      SPRTArr(Ix) = WSPRT                                     BUG23009A
                                                                                           BUG23009A
     C                   ENDIF                                                             BUG23009A
      *                                                                                    BUG23009A
     C                   EVAL      WMDIN = A6MDIN
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                     BUG26979
      /EJECT                                                                                BUG26979
      *****************************************************************                     BUG26979
      *                                                               *                     BUG26979
      *  SRNahoProc - Non Account Holder Processing                   *                     BUG26979
      *                                                               *                     BUG26979
      *  Called by: Main processing                                   *                     BUG26979
      *                                                               *                     BUG26979
      *  Calls: None                                                  *                     BUG26979
      *                                                               *                     BUG26979
      *****************************************************************                     BUG26979
      *                                                                                     BUG26979
     C     SRNahoProc    BEGSR                                                              BUG26979
      *                                                                                     BUG26979
     C                   EVAL      PUTIL = *ZERO                                            BUG26979
     C                   EVAL      PPORT = *ZERO                                            BUG26979
      *                                                                                     BUG26979
     C                   IF        PInth = 'N'                                              BUG26979
     C                   EVAL      PTOTO = *ZERO                                            BUG26979
     C                   ELSE                                                               BUG26979
      *                                                                                     BUG26979
     C                   IF        POCCY <> BJCYCD                                          BUG26979
      *                                                                                     BUG26979
      ** Convert gross interest in base currency                                            BUG26979
      *                                                                                     BUG26979
     C                   EVAL      PCcy = POCCY                                             BUG26979
     C                   EXSR      SRCurrDetl                                               BUG26979
      *                                                                                     BUG26979
     C**********         EVAL      ZAMTF = %ABS(PTOTI)                             BUG26979 AR749044
     C                   EVAL      ZAMTF = PTOTI                                            AR749044
     C                   EVAL      ZCCYF = POCCY                                            BUG26979
     C                   EVAL      ZCCYT = BJCYCD                                           BUG26979
     C                   EVAL      ZCDPF = WNBDP                                            BUG26979
     C                   EVAL      ZCDPT = BaseNBDP                                         BUG26979
     C                   EVAL      ZRATEF = WSPRT                                           BUG26979
     C                   EVAL      ZRATET = BaseRate                                        BUG26979
     C                   EVAL      ZMDINF = WMDIN                                           BUG26979
     C                   EVAL      ZMDINT = BaseMDIN                                        BUG26979
      *                                                                                     BUG26979
     C                   EXSR      ZCCYCN                                                   BUG26979
      *                                                                                     BUG26979
     C                   EVAL      PTOTO = ZAMTT                                            BUG26979
     C                   ELSE                                                               BUG26979
     C**********         EVAL      PTOTO = %ABS(PTOTI)                             BUG26979 AR749044
     C                   EVAL      PTOTO = PTOTI                                            AR749044
     C                   ENDIF                                                              BUG26979
     C                   ENDIF                                                              BUG26979
      *                                                                                     BUG26979
     C                   ENDSR                                                              BUG26979
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR  - Initial processing                                 *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Define parameters list
      *
     C     *ENTRY        PLIST
      *
      ** Input Parameters
      *
      *
      ** Interest Taxable
      *
     C                   PARM                    PInth
      *
      ** Threshold Method
      *
     C                   PARM                    EWTHMD
      *
      ** Gross Interest
      *
     C                   PARM                    PToti
      *
      ** Customer
      *
     C                   PARM                    PCust
      *                                                                                     BUG26979
      ** Non-account reference                                                              BUG26979
      *                                                                                     BUG26979
     C                   PARM                    PNarf                                      BUG26979
      *
      ** Original Currency
      *
     C                   PARM                    POCCY
      *                                                                                     BUG23657
      ** Exemption and Certificate Dates                                                    BUG23657
     C                   PARM                    SDTXDT                                     BUG23657
      *
      ** Joint Management Account Type                                                      BUG26839
     C                   PARM                    PJAMG                                      BUG26839
      ** Output Parameters
      *
      *
      ** Output Gross Interest
      *
     C                   PARM                    PToto
      *
      ** Utilisation up to Threshold
      *
     C                   PARM                    PUtil
      *
      ** Portion of Threshold
      *
     C                   PARM                    PPort
      *
      ** Database Error Key
      *
     C                   PARM                    PKey
      *
      ** Database Error File
      *
     C                   PARM                    PFile
      *
      ** Return Code
      *
     C                   PARM                    PRtrn
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   END
      *
      ** Test if CER048 is installed
      *
     C                   EVAL      CER048 = 'N'
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CER048'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF'
     C                   EVAL      PFile = 'SCSARDPD'
     C                   EVAL      PKey = 'CER048'
     C                   EVAL      PRtrn = 'ERROR  '
      *
     C                   ELSE
     C                   EVAL      CER048 = 'Y'
     C                   ENDIF
      *
     C                   EVAL      PCcy = BJCYCD
     C                   EXSR      SRCurrDetl
      *
     C                   EVAL      BaseNBDP = WNBDP
     C                   EVAL      BaseRate = WSPRT
     C                   EVAL      BaseMDIN = WMDIN
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
     C/EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZCCYCN_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
**  POWER
0000001
0000010
0000100
0001000
0010000
0100000
1000000
