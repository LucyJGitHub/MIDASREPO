     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-account Holder - Screen Input')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLSIN - Non-account Holders Screen Input                 *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Non-account Holder Details.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. MD043147           Date 03Jan17               *
      *  Prev Amend No. MD036509           Date 12Nov15               *
      *                 MD036460           Date 05Nov15               *
      *                 MD033967           Date 01Apr15               *
      *                 MD029805           Date 05Sep14               *
      *                 MD029849           Date 12Sep14               *
      *                 MD027453           Date 27Aug14               *
      *                 MD027324           Date 05Aug14               *
      *                 MD027561           Date 03Jul14               *
      *                 MD027473A          Date 18Jun14               *
      *                 MD026550           Date 02May14               *
      *                 CGL132             Date 01May13               *
      *                 CSD093             Date 01Apr13               *
      *                 AR799465           Date 07Jul11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22582           Date 22May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 235364             Date 02Sep05               *
      *                 233295             Date 29Apr05               *
      *                 233004             Date 12Apr05               *
      *                 232543             Date 31Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD043147 - US account authority holder indicia is not        *
      *             updated from insert like other US Indicia         *
      *             system values                                     *
      *  MD036509 - NAHO CRS Info Complete is validating on Enquire   *
      *  MD036460 - FATCA US Indicia update enhancements              *
      *  MD033967 - Exception 3 breached even when TIN is supplied    *
      *             in NAHO                                           *
      *  MD029805 - GIIN number validation                            *
      *  MD029849 - Issues on NAHL/NAHE with FATCA                    *
      *  MD027453 - FATCA classification Description is not updated   *
      *             automatically when setting a FATCA classification *
      *             Code. Apply Fix MD028137, MD028285, MD028285A     *
      *             and MD028786A                                     *
      *  MD027324 - US Indicia filter navigation error                *
      *  MD027561 - FATCA Classification Date is not updated to date  *
      *             when FATCA Classification was changed             *
      *  MD027473A - Unable to override US Account Authority Holder   *
      *  MD026550 - Require US TIN when Subject to Reporting is 'Y'   *
      *             for all new FATCA Customers/Non-Account Holders   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSD093 - Document Management                                 *
      *  AR799465 - "Non-Account Holders Maintenance" was shown when  *
      *             navigating to the related enquiry (Recompile)     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22582 - F3 and F12 perform the same action                *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *             (Recompile)                                       *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Standard Changes                         *
      *  236137 - Change Control for CGL031(recompiled over 233295)   *
      *  235364 - Failed component SEUCDEPTAX due to database error   *
      *           907, with missing record in SDNHTXPD.  Ensure that  *
      *           flags, needed for determining the country of tax    *
      *           display, is initialized properly for correct update *
      *           or write of record in SDNHTXPD.                     *
      *  233295 - Deletion problems on Non-account Holders.           *
      *  233004 - Addtl Cust and Non-a/c Holder by Country of Tax     *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL032 - Automatic Exchange of Information.                  *
      *                                                               *
      *****************************************************************
 
     FSDNHTXL1  IF   E           K DISK    INFSR(*PSSR)                                       233295
      ** Midas SD Non-a/c Holders by Country of Tax - Retrieve Index                          233295
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D X               S              3  0
     D #FldNameArr     S            200
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Current Non-A/C Holder in File Format
     D CrNaFilFmt    E DS                  Extname(SDNAHOPD)
     D                                     Prefix(C_)
                                                                                              CGL132
      ** Current Non-A/C Holder in File Format - FATCA details                                CGL132
     D CrFaFilFmt    E DS                  EXTNAME(SDFTNHPD)                                  CGL132
     D                                     PREFIX(C_)                                         CGL132
 
      ** Current Non-A/C Holder in Screen Format - Primary Details
     D CurNaPrim     E DS                  Extname(SDNAHLPD)
     D                                     Prefix(@)
                                                                                              CGL132
      ** Current Non-A/C Holder in Screen Format - FATCA Details                              CGL132
     D CurCuFATC     E DS                  EXTNAME(SDFTNRPD)                                  CGL132
     D                                     PREFIX(@)                                          CGL132
 
      ** New Non-A/C Holder in File Format
     D NwNaFilFmt    E DS                  Extname(SDVNAHLPD)
                                                                                              CGL132
      ** New Non-A/C Holder in File Format - FATCA Details                                    CGL132
     D NwFaFilFmt    E DS                  EXTNAME(SDVFTNHPD)                                 CGL132
 
      ** New Non-A/C Holder in Screen Format - Primary Details
     D NewNaPrim     E DS                  Extname(SDNAHLPD)
                                                                                              CGL132
      ** New Non-A/C Holder in Screen Format - FATCA details                                  CGL132
     D NewCuFATC     E DS                  EXTNAME(SDFTNRPD)                                  CGL132
 
 
      ** Previous Non-A/C Holder in Screen Format - Primary Details
     D PrvNaPrim     E DS                  Extname(SDNAHLPD)
     D                                     Prefix(@P)
                                                                                              CGL132
      ** Previous Customer in Screen Format - FATCA customer details                          CGL132
     D PrvCuFATC     E DS                  EXTNAME(SDFTNRPD)                                  CGL132
     D                                     PREFIX(@P)                                         CGL132
 
      ** Non-a/c Holder by Country of Tax - File Format                                       233295
     D NHTxFilFmt    E DS                  EXTNAME(SDNHTXPD)                                  233295
                                                                                              233295
      ** Error indicators
     D OkNaPrim      E DS                  Extname(SDENAHLPD)
     D OKFATCAdet    E DS                  EXTNAME(SDEFTNHPD)                                 CGL132
 
      ** External DS FOR BANK DETAILS
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** External DS for SAR details
     D SCSARD        E DS                  Extname(SCSARDPD)
     D  SCA_LCD      E                     Extfld(LCD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** Second DS for access progrmas, long data structure
     D DSSDY         E DS                  Extname(DSSDY)
                                                                                              CGL132
     D CrFoFilFmt      DS                                                                     CGL132
     D  WCDESC                 1     50                                                       CGL132
     D  WPDESC                51    100                                                       CGL132
     D  WWBRTH               101    105                                                       CGL132
     D  WWCBTH               106    107                                                       CGL132
     D  WWBTHT               108    142                                                       CGL132
     D  WWCNCZ               143    144                                                       CGL132
     D  WWCDOM               145    146                                                       CGL132
     D  WWACCZ               147    148                                                       CGL132
     D  WWTINO               149    173                                                       CGL132
                                                                                              CGL132
     D NewCuFOTH       DS                                                                     CGL132
     D  WCDESC1                1     50                                                       CGL132
     D  WPDESC1               51    100                                                       CGL132
     D  WNNARD1              101    106                                                       CGL132
     D  WNLARD1              107    112                                                       CGL132
     D  WNBRTH1              113    118                                                       CGL132
     D  WWCBTH1              119    120                                                       CGL132
     D  WWBTHT1              121    155                                                       CGL132
     D  WWCNCZ1              156    157                                                       CGL132
     D  WWCDOM1              158    159                                                       CGL132
     D  WWACCZ1              160    161                                                       CGL132
     D  WWTINO1              162    186                                                       CGL132
                                                                                              CGL132
     D CurCuFOTH       DS                                                                     CGL132
     D  WCDESC2                1     50                                                       CGL132
     D  WPDESC2               51    100                                                       CGL132
     D  WNBRTH2              101    106                                                       CGL132
     D  WWCBTH2              107    108                                                       CGL132
     D  WWBTHT2              109    143                                                       CGL132
     D  WWCNCZ2              144    145                                                       CGL132
     D  WWCDOM2              146    147                                                       CGL132
     D  WWACCZ2              148    149                                                       CGL132
     D  WWTINO2              150    174                                                       CGL132
 
      ** Changed Party Names Array
     D ChgNamArr       S              1    Dim(5)
 
      ** Override Database Table                                                              CGL132
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)                            CGL132
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)                            CGL132
     D ##OV3           S             50    DIM(1) CTDATA PERRCD(1)                            CGL132
     D ##OV4           S             50    DIM(1) CTDATA PERRCD(1)                            CGL132
                                                                                              CGL132
     D @opsel          S              1A   Dim(ArrayMax)
     D @nasel          S             10A   Dim(ArrayMax)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Non-A/C Holder Work Field
     D WKNAHO          S                   Like(DDNAHO)
 
     D ExtData         S            500A
 
     D Retcd           S              7A
 
     D Option          S              7A
 
     D Sardesc         S              6A
 
     D PReturn         S              7A                                                      CGL132
     D PTranID         S             10A                                                      CGL132
     D PSource         S              1A                                                      CGL132
     D PClass          S              5A   INZ(*BLANKS)                                       CGL132
     D PRepType        S              1A                                                      CGL132
     D PMode           S              1A                                                      CGL132
     D WMsgLen         S             15P 5 INZ(50)                                            CGL132
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   Inz('S')
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Parameter fields for 1DP
     D @EKYFD          S              1
     D @EDTFD          S              1
     D @EINKG          S              1
     D @EINKH          S              1
     D @EINKX          S              1                                                       CSD093
     D @INKC           S              1
     D @INKF           S              1                                                       CGL157
     D @INKG           S              1
     D @INKH           S              1
     D @INKL           S              1
     D @INKQ           S              1A                                                      CGL132
     D @INKR           S              1A                                                      CGL132
     D @INKS           S              1A                                                      CGL132
     D @INKT           S              1A                                                      CGL132
     D @INKX           S              1                                                       CSD093
 
     D @EINKJ          S              1
     D @INKJ           S              1
     D InsertEnq       S              1
 
      ** Parameter Fields for RED pgm
     D @RDFWD          S              1
     D @RDBCK          S              1
     D @ERRMS          S              7
     D @NARED          S             10
     D @RdNb           S              1
 
      ** Parameter Fields for BRW pgm
     D @BDSFL          S              1
     D @RDSFL          S              1
     D @In36           S              1
     D @IN81           S              1                                                       CGL132
     D @INKI           S              1
 
      ** Parameter Fields for RTV pgm
     D @@MODE          S              6
     D @@RSMD          S              1
 
     D CGL132          S              1                                                       CGL132
     D CGL133          S              1                                                       CGL132
     D CGL157          S              1                                                       CGL157
     D Idx             S              3  0
     D WIdx_Kval       S              3  0
     D WIdx_Pval       S              3  0
     D WIdx_Tval       S              3  0                                                    CGL132
     D PrvN_Warn       S              3  0
     D E               S              3  0
     D @SCRN           S              1
     D PRtcd           S              7
     D WNATXok         S              1                                                       233004
     D PFKey           S              2A                                                    BUG22582
                                                                                              233295
      ** Key Fields                                                                           233295
     D KNAHo           S                   LIKE(NXNAHO)                                       233295
 
     D CGL031          S              1    INZ('N')                                           CSW207
     D CGL032          S              1    INZ('N')                                           CSW207
     D PSard           S              6    INZ(*Blanks)                                       CSW207
     D CSD093          S              1A                                                      CSD093
     D PINMOD          S              1A                                                      CSD093
     D PINAHO          S             10A                                                      CSD093
     D PINTYP          S              1A                                                      CSD093
     D WFATCABRW       S              1A                                                    MD027324
     D PSelect         S              1A                                                      CGL157
     D WVAL            S              1A                                                      CGL157
     D WOption         S              1A                                                      CGL157
     D PCountry        S              2A                                                      CGL157
     D PCRSDT          S            351A                                                      CGL157
     D PWarning        S              1A                                                      CGL157
     D PAINSF          S              1A                                                    MD036460
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Issue rollback to clear any possible updates in window functions
 
     C     @INKL         IFEQ      *On
     C                   ROLBK
     C                   ENDIF
 
      ** Build browse subfile record
 
     C     @SCRN         IFEQ      'B'
     C                   EXSR      SRBldBrw
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C     @SCRN         IFEQ      'R'
     C                   EXSR      SRRdnBrw
     C                   ENDIF
                                                                                              CGL132
      ** Build browse subfile record                                                          CGL132
                                                                                              CGL132
     C     @SCRN         IFEQ      'J'                                                        CGL132
     C                   EXSR      BLDFTBRW                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Read next browse subfile record                                                      CGL132
                                                                                              CGL132
     C     @SCRN         IFEQ      'Q'                                                        CGL132
     C                   EXSR      RDNFTBRW                                                   CGL132
     C                   ENDIF                                                                CGL132
 
      ** Do While screen: Key Details Screen
 
     C                   Z-ADD     *ZERO         WIdx_KVAL
     C     @SCRN         DOWEQ     'K'
     C                   EXSR      SRScrn@K
     C                   ENDDO
 
      ** Do While screen: Primary Details Screen
 
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      SRScrn@P
     C                   ENDDO
                                                                                              CGL132
      ** Do while screen: FATCA details screen 1                                              CGL132
     C                   Z-ADD     *ZERO         WIdx_GVAL         3 0                        CGL132
     C     @SCRN         DOWEQ     'G'                                                        CGL132
     C                   EXSR      SCRN@G                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 1                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_CVAL         3 0                        CGL132
     C     @SCRN         DOWEQ     'C'                                                        CGL132
     C                   EXSR      SCRN@C                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 2                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_HVAL         3 0                        CGL132
     C     @SCRN         DOWEQ     'H'                                                        CGL132
     C                   EXSR      SCRN@H                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 3                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_LVAL         3 0                        CGL132
     C     @SCRN         DOWEQ     'L'                                                        CGL132
     C                   EXSR      SCRN@L                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 4                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_YVAL         3 0                        CGL132
     C     @SCRN         DOWEQ     'Y'                                                        CGL132
     C                   EXSR      SCRN@Y                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia comment history screen                                   CGL132
     C     @SCRN         DOWEQ     'V'                                                        CGL132
     C                   EXSR      SRUSHC                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: Exception screen                                                    CGL132
     C     @SCRN         DOWEQ     'N'                                                        CGL132
     C                   EXSR      SCRN@O                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
 
      ** Do File updates
 
     C     @SCRN         IFEQ      'U'
     C                   EXSR      SRUpdats
     C                   ENDIF
 
      ** Call Non-Account Holder details by Country of Tax
 
     C                   IF        @SCRN = 'A'
     C                   EXSR      SRCallNATX
     C                   IF        WFATCABRW <> ' ' AND                                     MD027324
     C                             CGL132 = 'Y'                                             MD027324
     C                   EVAL      @SCRN = 'J'                                              MD027324
     C                   ELSE                                                               MD027324
     C                   IF        DDACTN <> 'E'                                            BUG22582
     C                   EVAL      @SCRN = 'B'
     C                   ELSE                                                               BUG22582
     C                   EVAL      @SCRN = 'P'                                              BUG22582
     C                   ENDIF                                                              BUG22582
     C                   ENDIF                                                              MD027324
     C                   ENDIF
 
      ** Terminate program
 
     C     @SCRN         IFEQ      'T'
     C                   EVAL      *InLR = *On
     C                   ENDIF
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRCrn@K - Process Screen: Key Details
      *****************************************************************
     C     SRSCrn@K      BEGSR
 
      ** Reset Non-A/C Holder reference if there are no errors
 
     C     MsgIdArr(1)   IFEQ      *Blanks
     C                   MOVE      *BLANKS       DDNAHO
     C                   ENDIF
 
      ** Set F7/F8 called from Insert mode flag
 
     C                   MOVE      'Y'           INSERTENQ
 
      ** Write/Read display screen - Key Details
 
     C                   CALLB     'SDNAHL1DP'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return code
      ** Non-A/C Holder (In Screen format - Primary)
      ** Fields in error
      ** Errors
      ** Warnings
      ** Enabled Key Fields
      ** Enabled Detail Fields
      ** Enabled Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Comannd Key 08 = Read Next
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NewNaPrim
     C                   PARM                    OkNaPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
     C                   PARM      'Y'           @EINKG
     C                   PARM      'Y'           @EINKH
 
      ** OUTPUTS :
      ** Function Keys
      ** Write screen with no read indicator
 
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKG
     C                   PARM      *Off          @INKH
     C                   PARM      *Off          @INKL
     C                   PARM      'N'           WriteOnly
 
      ** Reset Errors ....
 
     C                   MOVE      *ALL'Y'       OkNaPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      ** F3 - End Program
 
     C     @INKC         CASEQ     *On           SREndP
 
      ** F7 - Roll Backwards
 
     C     @INKG         CASEQ     *On           SRRoll
 
      ** F8 - Roll Forwards
 
     C     @INKH         CASEQ     *On           SRRoll
 
      ** F12 - Cancel on Key Screen
 
     C     @INKL         CASEQ     *On           SRCanC@K
 
      ** Validate input to Key screen
 
     C                   CAS                     SRVal@K
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVal@K  - Validate Input to Key screen
      *****************************************************************
     C     SRVal@K       BEGSR
 
      ** Retrieve Non-A/C Holder details
 
     C                   EXSR      SRRtvNah
 
      ** If primary fields are NOT OK
      ** Re-output screen with error messages on it
 
     C     OKACTN        IFEQ      'N'
     C     OKNAHO        OREQ      'N'
     C                   GOTO      EndVAL@K
     C                   ENDIF
 
      ** If action code is not insert
      **  .. Convert the Non-A/C Holder to screen format
      **  .. Update the Non-A/C Holder in file format
      **  .. Go to Primary details screen
 
     C     DDACTN        IFNE      'I'
     C                   EXSR      SRCvtNah
     C                   MOVEL     CrNaFilFmt    NwNaFilFmt
     C                   MOVEL     'P'           @SCRN
     C                   EXSR      SRSfdS@P
     C                   GOTO      EndVAL@K
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   CLEAR                   NwNaFilFmt
     C                   CLEAR                   CrNaFilFmt
     C                   CLEAR                   NwFaFilFmt                                   CGL132
     C                   CLEAR                   CrFaFilFmt                                   CGL132
     C                   MOVEL     DDNAHO        FVNAHO                                       CGL132
     C                   IF        CGL132 = 'Y' AND                                           CGL132
     C                             DDACTN = 'I'                                               CGL132
     C                   EVAL      FVLCTP = 'I'                                               CGL132
     C                   ENDIF                                                                CGL132
     C                   MOVEL     DDNAHO        WKNAHO
     C                   CLEAR                   CurNaPrim
     C                   CLEAR                   NewNaPrim
     C                   CLEAR                   CurCuFATC                                    CGL132
     C                   CLEAR                   NewCuFATC                                    CGL132
     C                   MOVEL     WKNAHO        DDNAHO
     C                   MOVEL     'I'           DDACTN
     C                   MOVE      *ALL'Y'       OkNaPrim
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      ** Go to Primary Details screen
 
     C                   MOVEL     'P'           @SCRN
     C                   EXSR      SRSfdS@P
 
     C     EndVAL@K      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSfdS@P - Set field status on primary screen
      *****************************************************************
     C     SRSfdS@P      BEGSR
 
      ** Enable/disable fields on primary screen
 
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRScrn@P - Process primary screen
      *****************************************************************
     C     SRScrn@P      BEGSR
 
      ** Set function key status on Primary screen
 
     C                   EXSR      SRSfKeys
 
      ** Write/Read Display Screen - Primary Details
 
     C                   CALLB     'SDNAHL2DP'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return code
      ** Non-A/C Holder (In Screen format - Primary )
      ** Fields in error
      ** Errors
      ** Warnings
      ** Enabled Key & Detail fields
      ** Enabled Function keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Confirm Delete
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    NewNaPrim
     C                   PARM                    OkNaPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
     C                   PARM                    @EINKG
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKX                                       CSD093
 
      ** OUTPUTS :
      ** Function Keys
      ** Write screen with no read indicator
 
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKG
     C                   PARM      *Off          @INKH
     C                   PARM      *Off          @INKJ
     C                   PARM      *Off          @INKL
     C                   PARM      *Off          @INKX                                        CSD093
     C                   PARM      'N'           WriteOnly
 
      ** Reset errors ....
 
     C     OKNAHO        IFNE      'N'
     C                   MOVE      *ALL'Y'       OkNaPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   ENDIF
 
      ** F3 - End Program
 
     C     @INKC         CASEQ     *On           SREndP
 
      ** F7 - Roll Backwards
 
     C     @INKG         CASEQ     *On           SRRoll
 
      ** F8 - Roll Forwards
 
     C     @INKH         CASEQ     *On           SRRoll
 
      ** F12 - Cancel on Primary Screen
 
     C     @INKL         CASEQ     *On           SRCanC@P
 
      ** Validate Input to Primary Screen
 
     C                   CAS                     SRVal@P
     C                   ENDCS
                                                                                              CSD093
      ** On F23, go to Document Management, if no errors on this screen                       CSD093
     C     @INKX         IFEQ      '1'                                                        CSD093
     C     Idx           ANDEQ     0                                                          CSD093
     C                   EXSR      SRDocMan                                                   CSD093
     C                   ENDIF                                                                CSD093
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVal@P  - Validate Input to Primary screen
      *****************************************************************
     C     SRVal@P       BEGSR
 
      ** If Non-A/C Holder Reference is not OK
      ** Re-output screen with error message on it
 
     C     OKNAHO        IFEQ      'N'
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** Prior to validation, initialize error indicators as 'OK'
 
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C                   MOVE      *ALL'Y'       OkNaPrim
 
      ** If Delete
 
     C     DDACTN        IFEQ      'D'
 
      ** If F10 taken, go on to updates
 
     C     @INKJ         IFEQ      *On
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** If Enquire
 
     C     DDACTN        IFEQ      'E'
      ** If Document Management (F23) has not been selected                                   CSD093
     C     @INKX         IFEQ      '0'                                                        CSD093
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   MOVEL     'G'           @SCRN                                        CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      'A'           @SCRN
     C                   ENDIF                                                                CGL132
      ** If Document Management (F23) has been selected                                       CSD093
     C                   ELSE                                                                 CSD093
      ** Return to Primary Detail Screen after Document Management                            CSD093
     C                   MOVE      'P'           @SCRN                                        CSD093
     C                   ENDIF                                                                CSD093
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** If Insert or Amend / Change
 
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
 
      ** Validate Primary Non-A/C Holder Details
 
      ** Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewNaPrim     PrvNaPrim
     C                   Z-ADD     WIdx_PVAL     PrvN_Warn
 
 
     C                   CALLB     'SDNAHL2VL'
      **                ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Response mode
      ** Non-A/C Holder Primary Details
      ** Non-A/C Holder Extra Data
 
     C                   PARM                    RespMode
     C                   PARM                    NewNaPrim
     C                   PARM                    ExtData
 
      ** OUTPUTS :
      ** Non-A/C Holder Primary Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Valid Non-A/C Holder layout (DS) from/to caller
      ** Switchable feature CGL032
 
     C                   PARM                    OkNaPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx_PVAL
     C                   PARM                    NwNaFilFmt
 
      ** If errors returned
 
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** If the screen has changed in the course of the validation
      ** or if there are warnings which have not been displayed
      ** re-display the screen
 
     C     NewNaPrim     IFNE      PrvNaPrim
     C     WIdx_PVAL     ORNE      PrvN_Warn
     C                   GOTO      EndVAL@P
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   MOVE      *ALL'Y'       OkNaPrim
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      ** If Document Management (F23) has not been selected                                   CSD093
     C     @INKX         IFEQ      '0'                                                        CSD093
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   MOVEL     'G'           @SCRN                                        CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                CGL132
      ** If Document Management (F23) has been selected                                       CSD093
     C                   ELSE                                                                 CSD093
      ** Return to Primary Detail Screen after Document Management                            CSD093
     C                   MOVE      'P'           @SCRN                                        CSD093
     C                   EXSR      SRIfdS@K                                                   CSD093
     C                   ENDIF                                                                CSD093
 
     C                   ENDIF
 
     C     EndVAL@P      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRRoll - Roll backwards & forwards through Non-A/C Holders file
      *****************************************************************
     C     SRRoll        BEGSR
 
      ** If action is insert, control return to key screen
 
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'Y'           INSERTENQ
     C                   ENDIF
 
      ** Default action code to enquiry if action insert or not valid
 
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C                   MOVE      'E'           DDACTN
     C                   ENDIF
 
      ** Read next or previous record on Non-A/C Holder file
      ** according to command key taken (F7/@INKG OR F8/@INKH)
 
     C     @INKG         IFEQ      *On
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   ENDIF
 
     C                   CALLB     'SDNAHLRED'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return Code
      ** Action Code
      ** Non-A/C Holders Ref. Pointer
      ** Read forwards
      ** Read backwards
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDNAHO
     C                   PARM                    @RDFWD
     C                   PARM                    @RDBCK
 
      ** OUTPUTS :
      ** Error message
      ** Non-A/C Holders Ref. Read
 
     C                   PARM      *BLANK        @ERRMS
     C                   PARM      *BLANK        @NARED
 
      ** If error message returned from read, send it to detail screen
 
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SRSndM@P
     C                   GOTO      EROLL
     C                   ENDIF
 
      ** If Non-A/C Holder read
 
     C     @NARED        IFNE      *BLANK
 
      ** Retrieve Non-A/C Holder details
 
     C                   MOVEL     @NARED        DDNAHO
     C                   EXSR      SRRtvNah
 
      ** Return to browse screen if there is an error on Non-A/C Holder Reference
 
     C     OKNAHO        IFEQ      'N'
     C     OKACTN        OREQ      'N'
     C                   MOVEL     'B'           @SCRN
     C                   GOTO      EROLL
     C                   ENDIF
 
      ** Convert Non-A/C Holder
 
     C                   EXSR      SRCvtNah
     C                   MOVEL     CrNaFilFmt    NwNaFilFmt
 
      ** Put the Non-A/C Holder on the primary details screen
 
     C                   MOVEL     'P'           @SCRN
     C                   ENDIF
 
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCallNATX - Calls Non-Account Holder Details by Country of   *
      *              Tax                                              *
      *                                                               *
      *****************************************************************
     C     SRCallNATX    BEGSR
 
     C                   IF        CGL031 = 'Y' and CGL032 = 'Y'                              CSW207
     C                             or CGL132 = 'Y'                                            CGL132
     C                   CALL      'SDNATXSIN'
     C                   PARM                    PRtcd
     C                   PARM                    DDACTN
     C                   PARM                    NANAHO
     C                   PARM      *BLANKS       PFKey                                      BUG22582
     C                   ENDIF                                                                CSW207
 
      ** Return to Non-A/c Holder Details                                                     233004
                                                                                              233004
     C**********         IF        DDACTN <> 'I'                                       233295 235364
     C                   IF        DDACTN  = 'D'                                              235364
     C                             AND (CGL031 = 'Y' and CGL032 = 'Y')                        CSW207
     C                             or DDACTN  = 'D' and CGL132 = 'Y'                          CGL132
     C                   EXSR      SRRtvNah                                                   233004
     C                   EXSR      SRCvtNah                                                   233004
     C                   MOVEL     CrNaFilFmt    NwNaFilFmt                                   233004
     C                   EVAL      WNATXok = 'Y'                                              233004
     C                   ELSE                                                                 235364
     C                   IF        PFKey <> 'KL'                                            BUG22582
     C                   EXSR      SRInitial                                                  235364
     C                   MOVEA     *Blanks       @OPSEL                                       235364
     C                   MOVEA     *Blanks       @NASEL                                       235364
     C                   ELSE                                                               BUG22582
     C                   EXSR      SRRtvNah                                                 BUG22582
     C                   MOVEL     CrNaFilFmt    NwNaFilFmt                                 BUG22582
     C                   ENDIF                                                              BUG22582
     C                   ENDIF                                                                233295
                                                                                              233004
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSD093
      *****************************************************************                       CSD093
      *                                                               *                       CSD093
      * SRDocMan - Calls Document Management                          *                       CSD093
      *                                                               *                       CSD093
      *****************************************************************                       CSD093
     C     SRDocMan      BEGSR                                                                CSD093
     C                   CALL      'SDDCMTSIN'                                                CSD093
     C                   PARM      *BLANKS       RetCodeOut                                   CSD093
     C                   PARM      DDACTN        PINMOD                                       CSD093
     C                   PARM      DDNAHO        PINAHO                                       CSD093
     C                   PARM      'N'           PINTYP                                       CSD093
     C                   ENDSR                                                                CSD093
      *****************************************************************                       CSD093
      /EJECT
      *****************************************************************
      ** SRBldBrw - Build browse subfile
      *****************************************************************
     C     SRBldbrw      BEGSR
 
      ** Set/reset return to key screen from primary details
 
     C                   MOVE      'N'           INSERTENQ
 
      ** Reset Read next browse subfile record
 
     C                   MOVEL     *BLANK        @RDNB
     C                   EVAL      WFATCABRW = ' '                                          MD027324
 
      ** Build Browse subfile
 
     C                   CALLB     'SDNAHLBRW'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return Code
      ** Action Code
      ** Non-A/C Holder Ref. Pointer
      ** Build subfile
      ** Read subfile record
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDNAHO
     C                   PARM      'Y'           @BDSFL
     C                   PARM      *BLANK        @RDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *Off          @IN36
     C                   PARM                    @IN81                                        CGL132
 
      ** OUTPUTS :
      ** Error message
      ** Option Selected
      ** Non-A/C Holder Reference Selected
      ** Command Keys
 
     C                   PARM      *BLANK        @ERRMS
     C                   PARM                    @OPSEL
     C                   PARM                    @NASEL
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKI
     C                   PARM      '0'           @INKN             1                          CGL132
 
      ** If F3 taken in browse, End Program
 
     C     @INKC         IFEQ      *On
     C                   EXSR      SREndP
     C                   GOTO      EndBLDBRW
     C                   ENDIF
 
      ** If Insert (F9) selected from browse, go to key screen
 
     C     @OPSEL(1)     IFEQ      'I'
     C                   MOVEL     'K'           @SCRN
     C                   MOVE      'I'           DDACTN
     C                   GOTO      EndBLDBRW
     C                   ENDIF
                                                                                              CGL132
      * If F14 taken in browse, End Program                                                   CGL132
     C     @INKN         IFEQ      '1'                                                        CGL132
     C                   MOVEL     'J'           @SCRN                                        CGL132
     C                   GOTO      EndBLDBRW                                                  CGL132
     C                   END                                                                  CGL132
 
      ** If error message returned from browse, send it to detail screen
 
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SRSndM@P
     C                   GOTO      EndBLDBRW
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
 
     C     EndBLDBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRRdnBrw - Read next browse subfile record
      *****************************************************************
     C     SRRdnBrw      BEGSR
 
      ** Read Next Subfile Record
 
     C                   CALLB     'SDNAHLBRW'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return code
      ** Action code
      ** Non-A/C Holder Ref. pointer
      ** Build Sub-file
      ** Read Sub-file record
      ** Browse Screen
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN
     C                   PARM                    DDNAHO
     C                   PARM      *BLANK        @BDSFL
     C                   PARM      'Y'           @RDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *Off          @IN36
     C                   PARM                    @IN81                                        CGL132
 
      ** OUTPUTS :
      ** Error Message
      ** Option Selected
      ** Non-A/C Holder Ref. selected
      ** Function keys
 
     C                   PARM      *BLANK        @ERRMS
     C                   PARM                    @OPSEL
     C                   PARM                    @NASEL
     C                   PARM      *Off          @INKC
     C                   PARM      *Off          @INKI
     C                   PARM      '0'           @INKN             1                          CGL132
 
     C                   EVAL      x = 1
 
      ** Go to initial screen
 
     C                   IF        @Opsel(X) = *blanks or
     C                             @Nasel(X) = *blanks
     C                   EXSR      SRInitial
     C                   ELSE
 
      ** If Non-A/C Holder read from subfile
 
     C                   DOW       @opsel(x) <> *Blank   or
     C                             @nasel(x) <> *Blanks
 
      ** Retrieve Non-A/C Holder details
 
     C                   MOVEL     @OPSEL(x)     DDACTN
     C                   MOVEL     @NASEL(x)     DDNAHO
     C                   EVAL      Idx = x - 1
     C                   EXSR      SRRtvNah
     C                   EVAL      X = X + 1
     C                   MOVEA     FldnameArr    #fldnamearr
 
      ** Stay on browse screen if there is an error on Non-A/C Holder Reference
 
     C     OKNAHO        IFEQ      'N'
     C     OKACTN        OREQ      'N'
     C                   MOVEL     'B'           @SCRN
     C                   ITER
     C                   ENDIF
 
     C                   IF        #FldNameArr = *blanks
 
      ** Convert Non-A/C Holder details
 
     C                   EXSR      SRCvtNah
     C                   MOVEL     CrNaFilFmt    NwNaFilFmt
 
      ** Put Non-A/C Holder on key screen for Insert, primary details otherwise
 
     C     @OPSEL(1)     IFEQ      'I'
     C                   MOVEL     'K'           @SCRN
     C                   ELSE
     C                   MOVEL     'P'           @SCRN
     C                   ENDIF
     C                   EXSR      SRSfdS@P
 
     C                   Z-ADD     *ZERO         WIdx_PVAL
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      SRScrn@P
     C                   ENDDO
                                                                                              CGL132
      ** Do while screen: FATCA details screen 1                                              CGL132
     C                   Z-ADD     *ZERO         WIdx_GVAL                                    CGL132
     C     @SCRN         DOWEQ     'G'                                                        CGL132
     C                   EXSR      SCRN@G                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 1                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_CVAL                                    CGL132
     C     @SCRN         DOWEQ     'C'                                                        CGL132
     C                   EXSR      SCRN@C                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 2                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_HVAL                                    CGL132
     C     @SCRN         DOWEQ     'H'                                                        CGL132
     C                   EXSR      SCRN@H                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 3                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_LVAL                                    CGL132
     C     @SCRN         DOWEQ     'L'                                                        CGL132
     C                   EXSR      SCRN@L                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 4                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_YVAL                                    CGL132
     C     @SCRN         DOWEQ     'Y'                                                        CGL132
     C                   EXSR      SCRN@Y                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia comment history screen                                   CGL132
     C     @SCRN         DOWEQ     'V'                                                        CGL132
     C                   EXSR      SRUSHC                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: Exception screen                                                    CGL132
     C     @SCRN         DOWEQ     'N'                                                        CGL132
     C                   EXSR      SCRN@O                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
 
     C                   IF        @SCRN = 'A'
     C                   EXSR      SRCallNATX
     C                   IF        DDACTN <> 'E'                                            BUG22582
     C                   EVAL      @SCRN = 'B'
     C                   ELSE                                                               BUG22582
     C                   EVAL      @SCRN = 'P'                                              BUG22582
     C                   ENDIF                                                              BUG22582
     C                   ENDIF
 
     C                   IF        @scrn = 'U'
     C                   EXSR      SRUpdats
     C                   ENDIF
     C                   ENDIF
 
      ** Process the remaining options selected.
 
     C                   IF        @opsel(X) <> *blanks or
     C                             @nasel(X) <> *blanks
     C                   EVAL      @scrn = 'R'
     C                   ITER
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
     C     EndRDNBRW     ENDSR
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** BLDFTBRW - Build FATCA browse subfile                                                CGL132
      *****************************************************************                       CGL132
     C     BLDFTBRW      BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set/reset return to key screen from primary details                                  CGL132
                                                                                              CGL132
     C                   MOVE      'N'           INSERTENQ                                    CGL132
                                                                                              CGL132
      ** Reset Read next browse subfile record                                                CGL132
                                                                                              CGL132
     C                   MOVEL     *BLANK        @RDNB                                        CGL132
     C                   EVAL      WFATCABRW = 'Y'                                          MD027324
                                                                                              CGL132
      ** Build Browse subfile                                                                 CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNHBRW'                                                CGL132
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                                 CGL132
      ** INPUTS :                                                                             CGL132
      ** Return Code                                                                          CGL132
      ** Action Code                                                                          CGL132
      ** Non-A/C Holder Ref. Pointer                                                          CGL132
      ** Build subfile                                                                        CGL132
      ** Read subfile record                                                                  CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    DDACTN                                       CGL132
     C                   PARM                    DDNAHO                                       CGL132
     C                   PARM      'Y'           @BDSFL                                       CGL132
     C                   PARM      *BLANK        @RDSFL                                       CGL132
     C                   PARM      *Off          @IN36                                        CGL132
     C                   PARM      *BLANKS       PMODE                                      MD029849
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Error message                                                                        CGL132
      ** Option Selected                                                                      CGL132
      ** Non-A/C Holder Reference Selected                                                    CGL132
      ** Command Keys                                                                         CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        @ERRMS                                       CGL132
     C                   PARM                    @OPSEL                                       CGL132
     C                   PARM                    @NASEL                                       CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKI                                        CGL132
     C                   PARM      '0'           @INKN             1                          CGL132
                                                                                              CGL132
      ** If F3 taken in browse, End Program                                                   CGL132
                                                                                              CGL132
     C     @INKC         IFEQ      *On                                                        CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   GOTO      EndBLDFTBRW                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If Insert (F9) selected from browse, go to key screen                                CGL132
                                                                                              CGL132
     C     @OPSEL(1)     IFEQ      'I'                                                        CGL132
     C                   MOVEL     'K'           @SCRN                                        CGL132
     C                   MOVE      'I'           DDACTN                                       CGL132
     C                   GOTO      EndBLDFTBRW                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      * If F14 taken in browse, End Program                                                   CGL132
     C     @INKN         IFEQ      '1'                                                        CGL132
     C                   MOVEL     'B'           @SCRN                                        CGL132
     C                   GOTO      EndBLDFTBRW                                                CGL132
     C                   END                                                                  CGL132
                                                                                              CGL132
      ** If error message returned from browse, send it to detail screen                      CGL132
                                                                                              CGL132
     C     @ERRMS        IFNE      *BLANK                                                     CGL132
     C                   EXSR      SRSndM@P                                                   CGL132
     C                   GOTO      EndBLDFTBRW                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Read next browse subfile record                                                      CGL132
                                                                                              CGL132
     C                   MOVE      'Y'           @RDNB                                        CGL132
     C                   MOVEL     'Q'           @SCRN                                        CGL132
                                                                                              CGL132
     C     EndBLDFTBRW   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** RDNFTBRW - Read next browse subfile record                                           CGL132
      *****************************************************************                       CGL132
     C     RDNFTBRW      BEGSR                                                                CGL132
                                                                                              CGL132
      ** Read Next Subfile Record                                                             CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNHBRW'                                                CGL132
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                                 CGL132
      ** INPUTS :                                                                             CGL132
      ** Return code                                                                          CGL132
      ** Action code                                                                          CGL132
      ** Non-A/C Holder Ref. pointer                                                          CGL132
      ** Build Sub-file                                                                       CGL132
      ** Read Sub-file record                                                                 CGL132
      ** Browse Screen                                                                        CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    DDACTN                                       CGL132
     C                   PARM                    DDNAHO                                       CGL132
     C                   PARM      *BLANK        @BDSFL                                       CGL132
     C                   PARM      'Y'           @RDSFL                                       CGL132
     C                   PARM      *Off          @IN36                                        CGL132
     C                   PARM      *BLANKS       PMODE                                      MD029849
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Error Message                                                                        CGL132
      ** Option Selected                                                                      CGL132
      ** Non-A/C Holder Ref. selected                                                         CGL132
      ** Function keys                                                                        CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        @ERRMS                                       CGL132
     C                   PARM                    @OPSEL                                       CGL132
     C                   PARM                    @NASEL                                       CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKI                                        CGL132
     C                   PARM      '0'           @INKN             1                          CGL132
                                                                                              CGL132
     C                   EVAL      x = 1                                                      CGL132
                                                                                              CGL132
      ** Go to initial screen                                                                 CGL132
                                                                                              CGL132
     C                   IF        @Opsel(X) = *BLANKS or                                     CGL132
     C                             @Nasel(X) = *BLANKS                                        CGL132
     C                   EXSR      SRInitial                                                  CGL132
     C                   MOVEL     'J'           @SCRN                                        CGL132
     C                   ELSE                                                                 CGL132
                                                                                              CGL132
      ** If Non-A/C Holder read from subfile                                                  CGL132
                                                                                              CGL132
     C                   DOW       @opsel(x) <> *BLANKS  or                                   CGL132
     C                             @nasel(x) <> *BLANKs                                       CGL132
                                                                                              CGL132
      ** Retrieve Non-A/C Holder details                                                      CGL132
                                                                                              CGL132
     C                   MOVEL     @OPSEL(x)     DDACTN                                       CGL132
     C                   MOVEL     @NASEL(x)     DDNAHO                                       CGL132
     C                   EVAL      Idx = x - 1                                                CGL132
     C                   EXSR      SRRtvNah                                                   CGL132
     C                   EVAL      X = X + 1                                                  CGL132
     C                   MOVEA     FldnameArr    #fldnamearr                                  CGL132
                                                                                              CGL132
      ** Stay on browse screen if there is an error on Non-A/C Holder Reference               CGL132
                                                                                              CGL132
     C     OKNAHO        IFEQ      'N'                                                        CGL132
     C     OKACTN        OREQ      'N'                                                        CGL132
     C                   MOVEL     'J'           @SCRN                                        CGL132
     C                   ITER                                                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        #FldNameArr = *blanks                                      CGL132
                                                                                              CGL132
      ** Convert Non-A/C Holder details                                                       CGL132
                                                                                              CGL132
     C                   EXSR      SRCvtNah                                                   CGL132
     C                   MOVEL     CrNaFilFmt    NwNaFilFmt                                   CGL132
                                                                                              CGL132
      ** Put Non-A/C Holder on key screen for Insert, primary details otherwise               CGL132
                                                                                              CGL132
     C     @OPSEL(1)     IFEQ      'I'                                                        CGL132
     C                   MOVEL     'K'           @SCRN                                        CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVEL     'P'           @SCRN                                        CGL132
     C                   ENDIF                                                                CGL132
     C                   EXSR      SRSfdS@P                                                   CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         WIdx_PVAL                                    CGL132
     C     @SCRN         DOWEQ     'P'                                                        CGL132
     C                   EXSR      SRScrn@P                                                   CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: FATCA details screen 1                                              CGL132
     C                   Z-ADD     *ZERO         WIdx_GVAL                                    CGL132
     C     @SCRN         DOWEQ     'G'                                                        CGL132
     C                   EXSR      SCRN@G                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 1                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_CVAL                                    CGL132
     C     @SCRN         DOWEQ     'C'                                                        CGL132
     C                   EXSR      SCRN@C                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 2                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_HVAL                                    CGL132
     C     @SCRN         DOWEQ     'H'                                                        CGL132
     C                   EXSR      SCRN@H                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 3                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_LVAL                                    CGL132
     C     @SCRN         DOWEQ     'L'                                                        CGL132
     C                   EXSR      SCRN@L                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia screen 4                                                 CGL132
     C                   Z-ADD     *ZERO         WIdx_YVAL                                    CGL132
     C     @SCRN         DOWEQ     'Y'                                                        CGL132
     C                   EXSR      SCRN@Y                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: US Indicia comment history screen                                   CGL132
     C     @SCRN         DOWEQ     'V'                                                        CGL132
     C                   EXSR      SRUSHC                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Do while screen: Exception screen                                                    CGL132
     C     @SCRN         DOWEQ     'N'                                                        CGL132
     C                   EXSR      SCRN@O                                                     CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
                                                                                              CGL132
     C                   IF        @SCRN = 'A'                                                CGL132
     C                   EXSR      SRCallNATX                                                 CGL132
     C**********         EVAL      @SCRN = 'B'                                       CGL132 MD027324
     C                   EVAL      @SCRN = 'J'                                              MD027324
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        @scrn = 'U'                                                CGL132
     C                   EXSR      SRUpdats                                                   CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Process the remaining options selected.                                              CGL132
                                                                                              CGL132
     C                   IF        @opsel(X) <> *BLANKS or                                    CGL132
     C                             @nasel(X) <> *BLANKS                                       CGL132
     C                   EVAL      @scrn = 'Q'                                                CGL132
     C                   ITER                                                                 CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDDO                                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C     EndRDNFTBRW   ENDSR                                                                CGL132
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRRtnNah - Retrieve Non-account Holder
      *****************************************************************
     C     SRRtvNah      BEGSR
 
      ** Retrieve Non-account Holder
 
     C                   CALLB     'SDNAHLRTV'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return code
      ** Mode = '*FRONT' (Front Office transaction interface)
      ** Mode = '      ' (Not Front Office transaction interface)
      ** Response mode
      ** Action Code
      ** Front Office Transaction ID
      ** (Midas) Non-A/C Holder Reference
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      '      '      @@MODE
     C                   PARM      'S'           @@RSMD
     C                   PARM                    DDACTN
     C                   PARM                    C_NHFRNT
     C                   PARM                    DDNAHO
     C                   PARM      *Off          @IN36
 
      ** OUTPUTS :
      ** (Current) Customer in file format
      ** OK - Action code
      ** OK - Customer Reference
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    CrNaFilFmt
     C                   PARM                    CrFaFilFmt                                   CGL132
     C                   PARM                    CrFoFilFmt                                   CGL132
     C                   PARM      *BLANK        OKACTN
     C                   PARM      *BLANK        OKNAHO
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
     C                   EVAL      WCLAFlag = ' '                                           MD027561
                                                                                            MD027561
     C     EndRTVNAH     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRCvtNah - Put a Non-A/C Holder on the primary details screen
      *****************************************************************
 
     C     SRCvtNah      BEGSR
 
      ** Call program to fill screen fields with data from SDNAHOPD
 
     C                   CALLB     'SDNAHLCVT'
      **                 ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS :
      ** Return Code
      ** Non-A/C Holder file format
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrNaFilFmt
     C                   PARM                    CrFaFilFmt                                   CGL132
     C                   PARM                    CrFoFilFmt                                   CGL132
 
      ** OUTPUTS :
      ** Non-A/C Holder - screen formats
      ** Update 'Current' Customer with Customer in Screen Format
 
     C                   PARM                    NewNaPrim
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewCuFOTH                                    CGL132
 
     C                   MOVEL     NewNaPrim     CurNaPrim
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   MOVEL     NewCuFATC     CurCuFATC                                    CGL132
     C                   MOVEL     NewCuFOTH     CurCuFOTH                                    CGL132
     C                   ENDIF                                                                CGL132
 
      ** Reset Country of Tax Flag everytime a new transaction is loaded                      233004
                                                                                              233004
     C                   EVAL      WNATXok = 'N'                                              233004
                                                                                              233004
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSfKeyS - Set Function key status on screen
      *****************************************************************
     C     SRSfKeys      BEGSR
 
      ** Enable/disable function keys
 
      ** KG = Command Key 07 = Read Previous Non-A/C Holder
      ** KH = Command Key 08 = Read Next Non-A/C Holder
 
     C     @SCRN         IFEQ      'P'
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   ELSE
     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH
     C                   ENDIF
 
      ** KJ = Command Key 10 = Confirm Delete
 
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   ENDIF
                                                                                              CSD093
      ** KX = Command Key 23 = Document Management                                            CSD093
                                                                                              CSD093
     C                   IF        DDACTN <> 'I' AND CSD093 = 'Y'                             CSD093
     C                   MOVEL     'Y'           @EINKX                                       CSD093
     C                   ELSE                                                                 CSD093
     C                   MOVEL     'N'           @EINKX                                       CSD093
     C                   ENDIF                                                                CSD093
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRIfdS@K - Initialise field status on key screen
      *****************************************************************
     C     SRIfdS@K      BEGSR
 
      ** Enable Key fields on key screen
 
     C                   MOVEL     'Y'           @EDTFD
     C                   MOVEL     'Y'           @EKYFD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSndM@P - Send a message to screen
      *****************************************************************
     C     SRSndM@P      BEGSR
 
      ** Add error message to array passed to detail screen
 
     C                   Z-ADD     1             E
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
 
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRCanC@K - Cancel on Key screen
      *****************************************************************
     C     SRCanC@K      BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   MOVEL     *BLANK        @RDNB
     C                   MOVEL     'B'           @SCRN
     C                   MOVEA     *Blanks       @OPSEL
     C                   MOVEA     *Blanks       @NASEL
 
      ** If input fields are enabled
      ** Blank the screens
 
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NewNaPrim
     C                   ENDIF
 
      ** Initialize field status on Key Screen
 
     C                   EXSR      SRIfdS@K
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRCanC@P - Cancel on Primary screen
      *****************************************************************
     C     SRCanC@P      BEGSR
 
      ** Return to previous screen
 
     C     INSERTENQ     IFEQ      'Y'
     C                   MOVE      'I'           DDACTN
     C                   MOVEL     'K'           @SCRN
     C                   ELSE
     C                   IF        WFATCABRW <> ' ' AND                                     MD027324
     C                             CGL132 = 'Y'                                             MD027324
     C                   MOVEL     'J'           @SCRN                                      MD027324
     C                   ELSE                                                               MD027324
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF                                                              MD027324
     C                   ENDIF
 
     C                   ENDSR
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@G - Process FATCA details screen 1                                               CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@G        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set function key status on screen                                                    CGL132
     C                   EXSR      SrSFKEYS                                                   CGL132
                                                                                            MD028137
     C                   IF        DDACTN = 'A'                                             MD028137
     C**********                   OR DDACTN = 'I'                                 MD028137 MD028285
     C                             OR DDACTN = 'I'                                         MD028285A
     C                             AND DDCLAC <> *BLANKS                                   MD028285A
     C                             OR DDACTN = 'I'                                         MD028786A
     C                             AND DDCLAC = *BLANKS                                    MD028786A
     C                             AND WCDESC = *BLANKS                                    MD028786A
     C                   EVAL      WCDESC1 = WCDESC                                         MD028137
     C                   ENDIF                                                              MD028137
     C                                                                                     MD028786A
     C                   IF        DDACTN = 'I'                                            MD028786A
     C                             AND DDPCLA =  *BLANKS                                   MD028786A
     C                             AND WPDESC = *BLANKS                                    MD028786A
     C                   EVAL      WPDESC1 = *BLANKS                                       MD028786A
     C                   ENDIF                                                             MD028786A
                                                                                              CGL132
     C                   IF        @OPSEL(1) = 'I'                                          MD029849
     C                   EVAL      DDACTI = 'A'                                             MD029849
     C                   ENDIF                                                              MD029849
                                                                                            MD029849
      ** Write/read display - FATCA details screen 5                                          CGL132
     C                   CALLB     'SDFTNH5DP'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Return code                                                                          CGL132
      ** FATCA Customer details (In Screen format - Primary )                                 CGL132
      ** Fields in error                                                                      CGL132
      ** Errors                                                                               CGL132
      ** Warnings                                                                             CGL132
      ** Enabled Key & Detail fields                                                          CGL132
      ** Enabled Function keys                                                                CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewCuFOTH                                    CGL132
     C                   PARM                    NewNaPrim                                    CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIdArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Function Keys                                                                        CGL132
      ** Write screen with no read indicator                                                  CGL132
                                                                                              CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKL                                        CGL132
     C                   PARM      *Off          @INKR                                        CGL132
     C                   PARM      *Off          @INKS                                        CGL132
     C                   PARM      *Off          @INKT                                        CGL132
     C                   PARM      'N'           WriteOnly                                    CGL132
                                                                                              CGL132
      ** Reset errors                                                                         CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        FldNameArr                                   CGL132
     C                   MOVEL     *BLANK        MsgIdArr                                     CGL132
     C                   MOVEL     *BLANK        MsgDtaArr                                    CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKL = '1'                                                CGL132
     C                   EXSR      CANC@G                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKR = '1'                                                CGL132
     C                   EXSR      SCRN@C                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKS = '1'                                                CGL132
     C                   EXSR      SRUSHC                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKT = '1'                                                CGL132
     C                   EXSR      SCRN@O                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKC = '0' AND                                            CGL132
     C                             @INKL = '0' AND                                            CGL132
     C                             @INKR = '0' AND                                            CGL132
     C                             @INKS = '0' AND                                            CGL132
     C                             @INKT = '0'                                                CGL132
     C                   EXSR      VAL@G                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@C - Process FATCA details screen 2                                               CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@C        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set function key status on screen                                                    CGL132
     C                   EXSR      SrSFKEYS                                                   CGL132
                                                                                              CGL132
      ** Write/read display - FATCA details screen 2                                          CGL132
     C                   CALLB     'SDFTNH1DP'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Return code                                                                          CGL132
      ** FATCA Customer details (In Screen format - Primary )                                 CGL132
      ** Fields in error                                                                      CGL132
      ** Errors                                                                               CGL132
      ** Warnings                                                                             CGL132
      ** Enabled Key & Detail fields                                                          CGL132
      ** Enabled Function keys                                                                CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewNaPrim                                    CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIdArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Function Keys                                                                        CGL132
      ** Write screen with no read indicator                                                  CGL132
                                                                                              CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKL                                        CGL132
     C                   PARM      *Off          @INKQ                                        CGL132
     C                   PARM      *Off          @INKS                                        CGL132
     C                   PARM      *Off          @INKT                                        CGL132
     C                   PARM      'N'           WriteOnly                                    CGL132
                                                                                              CGL132
     C                   MOVEL     'C'           @SCRN                                        CGL132
      ** Reset errors                                                                         CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        FldNameArr                                   CGL132
     C                   MOVEL     *BLANK        MsgIdArr                                     CGL132
     C                   MOVEL     *BLANK        MsgDtaArr                                    CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKL = '1'                                                CGL132
     C                   EXSR      CANC@C                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKQ = '1'                                                CGL132
     C                   EXSR      SCRNGG                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKS = '1'                                                CGL132
     C                   EXSR      SCRNGH                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKT = '1'                                                CGL132
     C                   EXSR      SCRNGE                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKC = '0' AND                                            CGL132
     C                             @INKL = '0' AND                                            CGL132
     C                             @INKQ = '0' AND                                            CGL132
     C                             @INKS = '0' AND                                            CGL132
     C                             @INKT = '0'                                                CGL132
     C                   EXSR      VAL@C                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** On F23, go to Further Details, if there                                              CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@H - Process FATCA details screen 3                                               CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@H        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set function key status on screen                                                    CGL132
     C                   EXSR      SrSFKEYS                                                   CGL132
                                                                                              CGL132
      ** Write/read display - FATCA details screen 3                                          CGL132
     C                   CALLB     'SDFTNH2DP'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Return code                                                                          CGL132
      ** FATCA Customer details (In Screen format - Primary )                                 CGL132
      ** Fields in error                                                                      CGL132
      ** Errors                                                                               CGL132
      ** Warnings                                                                             CGL132
      ** Enabled Key & Detail fields                                                          CGL132
      ** Enabled Function keys                                                                CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewNaPrim                                    CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIdArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Function Keys                                                                        CGL132
      ** Write screen with no read indicator                                                  CGL132
                                                                                              CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKL                                        CGL132
     C                   PARM      *Off          @INKQ                                        CGL132
     C                   PARM      *Off          @INKS                                        CGL132
     C                   PARM      *Off          @INKT                                        CGL132
     C                   PARM      'N'           WriteOnly                                    CGL132
                                                                                              CGL132
      ** Reset errors                                                                         CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        FldNameArr                                   CGL132
     C                   MOVEL     *BLANK        MsgIdArr                                     CGL132
     C                   MOVEL     *BLANK        MsgDtaArr                                    CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKL = '1'                                                CGL132
     C                   EXSR      CANC@H                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKQ = '1'                                                CGL132
     C                   EXSR      SCRNGG                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKS = '1'                                                CGL132
     C                   EXSR      SCRNGH                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKT = '1'                                                CGL132
     C                   EXSR      SCRNGE                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKC = '0' AND                                            CGL132
     C                             @INKL = '0' AND                                            CGL132
     C                             @INKQ = '0' AND                                            CGL132
     C                             @INKS = '0' AND                                            CGL132
     C                             @INKT = '0'                                                CGL132
     C                   EXSR      VAL@H                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** On F23, go to Further Details, if there                                              CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@L - Process FATCA details screen 4                                               CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@L        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set function key status on screen                                                    CGL132
     C                   EXSR      SrSFKEYS                                                   CGL132
                                                                                              CGL132
      ** Write/read display - FATCA details screen 3                                          CGL132
     C                   CALLB     'SDFTNH3DP'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Return code                                                                          CGL132
      ** FATCA Customer details (In Screen format - Primary )                                 CGL132
      ** Fields in error                                                                      CGL132
      ** Errors                                                                               CGL132
      ** Warnings                                                                             CGL132
      ** Enabled Key & Detail fields                                                          CGL132
      ** Enabled Function keys                                                                CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewNaPrim                                    CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIdArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Function Keys                                                                        CGL132
      ** Write screen with no read indicator                                                  CGL132
                                                                                              CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKL                                        CGL132
     C                   PARM      *Off          @INKQ                                        CGL132
     C                   PARM      *Off          @INKS                                        CGL132
     C                   PARM      *Off          @INKT                                        CGL132
     C                   PARM      'N'           WriteOnly                                    CGL132
                                                                                              CGL132
      ** Reset errors                                                                         CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        FldNameArr                                   CGL132
     C                   MOVEL     *BLANK        MsgIdArr                                     CGL132
     C                   MOVEL     *BLANK        MsgDtaArr                                    CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKL = '1'                                                CGL132
     C                   EXSR      CANC@L                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKQ = '1'                                                CGL132
     C                   EXSR      SCRNGG                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKS = '1'                                                CGL132
     C                   EXSR      SCRNGH                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKT = '1'                                                CGL132
     C                   EXSR      SCRNGE                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKC = '0' AND                                            CGL132
     C                             @INKL = '0' AND                                            CGL132
     C                             @INKQ = '0' AND                                            CGL132
     C                             @INKS = '0' AND                                            CGL132
     C                             @INKT = '0'                                                CGL132
     C                   EXSR      VAL@L                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** On F23, go to Further Details, if there                                              CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@Y - Process FATCA details screen 4                                               CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@Y        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set function key status on screen                                                    CGL132
     C                   EXSR      SrSFKEYS                                                   CGL132
                                                                                              CGL132
      ** Write/read display - FATCA details screen 4                                          CGL132
     C                   CALLB     'SDFTNH4DP'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Return code                                                                          CGL132
      ** FATCA Customer details (In Screen format - Primary )                                 CGL132
      ** Fields in error                                                                      CGL132
      ** Errors                                                                               CGL132
      ** Warnings                                                                             CGL132
      ** Enabled Key & Detail fields                                                          CGL132
      ** Enabled Function keys                                                                CGL132
                                                                                              CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewNaPrim                                    CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIdArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** Function Keys                                                                        CGL132
      ** Write screen with no read indicator                                                  CGL132
                                                                                              CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKL                                        CGL132
     C                   PARM      *Off          @INKQ                                        CGL132
     C                   PARM      *Off          @INKS                                        CGL132
     C                   PARM      *Off          @INKT                                        CGL132
     C                   PARM      'N'           WriteOnly                                    CGL132
                                                                                              CGL132
      ** Reset errors                                                                         CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        FldNameArr                                   CGL132
     C                   MOVEL     *BLANK        MsgIdArr                                     CGL132
     C                   MOVEL     *BLANK        MsgDtaArr                                    CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKL = '1'                                                CGL132
     C                   EXSR      CANC@Y                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKQ = '1'                                                CGL132
     C                   EXSR      SCRNGG                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKS = '1'                                                CGL132
     C                   EXSR      SCRNGH                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKT = '1'                                                CGL132
     C                   EXSR      SCRNGE                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKC = '0' AND                                            CGL132
     C                             @INKL = '0' AND                                            CGL132
     C                             @INKQ = '0' AND                                            CGL132
     C                             @INKS = '0' AND                                            CGL132
     C                             @INKT = '0'                                                CGL132
     C                   EXSR      VAL@Y                                                      CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** On F23, go to Further Details, if there                                              CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SCRN@O - Display Exception screen                                                     CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRN@O        BEGSR                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNHEDP'                                                CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    NewNaPrim                                    CGL132
     C                   PARM      *Off          @INKC                                        CGL132
     C                   PARM      *Off          @INKQ                                        CGL132
     C                   PARM      *Off          @INKR                                        CGL132
     C                   PARM      *Off          @INKS                                        CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKQ = '1'                                                CGL132
     C                   EXSR      SCRNGG                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKR = '1'                                                CGL132
     C                   EXSR      SCRN@C                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKS = '1'                                                CGL132
     C                   EXSR      SCRNGH                                                     CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SRUSHC - US Indicia Comment History                                                   CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SRUSHC        BEGSR                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH3BW'                                                CGL132
     C                   PARM      *BLANK        RetCodeOut                                   CGL132
     C                   PARM                    NwNaFilFmt                                   CGL132
     C                   PARM      '0'           @INKC                                        CGL132
     C                   PARM      '0'           @INKQ                                        CGL132
     C                   PARM      '0'           @INKR                                        CGL132
     C                   PARM      '0'           @INKT                                        CGL132
                                                                                              CGL132
     C                   IF        @INKC = '1'                                                CGL132
     C                   EXSR      SREndP                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKQ = '1'                                                CGL132
     C                   EXSR      SCRNGG                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKR = '1'                                                CGL132
     C                   EXSR      SCRN@C                                                     CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        @INKT = '1'                                                CGL132
     C                   EXSR      SCRNGE                                                     CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * VAL@G - Validate FATCA details 1                                                      CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     VAL@G         BEGSR                                                                CGL132
                                                                                              CGL132
      ** If Amend / Insert                                                                  MD036509
     C                   IF        DDACTN = 'A' OR DDACTN = 'I'                             MD036509
                                                                                            MD036509
     C                   Z-ADD     *ZERO         Idx                                          CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
                                                                                              CGL132
     C                   MOVEL     NewCuFATC     PrvCuFATC                                    CGL132
     C                   Z-ADD     WIdx_GVAL     PrvG_Warn         3 0                        CGL132
     C                   Z-ADD     *ZERO         WIdx_GVAL                                    CGL132
     C                   EVAL      FVNAHO = DDNAHL                                            CGL132
     C                   EVAL      FVLCTP = DDACTI                                            CGL132
     C                   EVAL      FVUTIN = DDUTIN                                          MD033967
     C                   EVAL      PAINSF = DDACTN                                          MD036460
     C                   IF        DDACTN = 'I'                                             MD043147
     C                   EVAL      PAINSF = 'Y'                                             MD043147
     C                   ENDIF                                                              MD043147
                                                                                              CGL132
     C                   CALLB     'SDFTNH5VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
     C                   PARM                    CrFoFilFmt                                   CGL132
     C                   PARM                    NwNaFilFmt                                   CGL132
     C                   PARM      DDCRDT        P_CRDT            8                        MD026550
     C                   PARM                    WCLAFlag          1                        MD027561
     C                   PARM                    PAINSF                                     MD036460
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_GVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If the screen has changed in the course of the validation                            CGL132
      ** or if there are warnings which have not been displayed                               CGL132
      ** re-display the screen                                                                CGL132
                                                                                              CGL132
     C     NewCuFATC     IFNE      PrvCuFATC                                                  CGL132
     C     WIdx_GVAL     ORNE      PrvG_Warn                                                  CGL132
     C     WIdx_GVAL     ANDNE     0                                                        MD028285
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Clear any warning messages                                                           CGL132
                                                                                              CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Validate US indicia and return error if found                                        CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         WIdx_CVAL                                    CGL132
     C                   Z-ADD     *ZERO         WIdx_HVAL                                    CGL132
     C                   Z-ADD     *ZERO         WIdx_LVAL                                    CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH1VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_CVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   Z-ADD     1             E                 3 0                        CGL132
     C     *BLANK        LOOKUP    FldNameArr(E)                          99                  CGL132
     C                   MOVEL     '*ANY'        FldNameArr(E)                                CGL132
     C                   MOVEL     'USS0397'     MsgIdArr(E)                                  CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH2VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_HVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   Z-ADD     1             E                                            CGL132
     C     *BLANK        LOOKUP    FldNameArr(E)                          99                  CGL132
     C                   MOVEL     '*ANY'        FldNameArr(E)                                CGL132
     C                   MOVEL     'USS0397'     MsgIdArr(E)                                  CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH3VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_LVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   Z-ADD     1             E                                            CGL132
     C     *BLANK        LOOKUP    FldNameArr(E)                          99                  CGL132
     C                   MOVEL     '*ANY'        FldNameArr(E)                                CGL132
     C                   MOVEL     'USS0397'     MsgIdArr(E)                                  CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH4VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_TVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   Z-ADD     1             E                                            CGL132
     C     *BLANK        LOOKUP    FldNameArr(E)                          99                  CGL132
     C                   MOVEL     '*ANY'        FldNameArr(E)                                CGL132
     C                   MOVEL     'USS0397'     MsgIdArr(E)                                  CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDIF                                                              MD036509
                                                                                            MD036509
     C     DDACTN        IFEQ      'E'                                                        CGL132
     C                   MOVE      'A'           @SCRN                                        CGL132
     C                   GOTO      EndVAL@G                                                   CGL132
     C                   END                                                                  CGL132
      *                                                                                       CGL132
      *                                                                                       CGL132
      * If Action Code is I or A go to Update                                                 CGL132
      *                                                                                       CGL132
     C     DDACTN        IFEQ      'I'                                                        CGL132
     C     DDACTN        OREQ      'A'                                                        CGL132
     C                   MOVEL     'U'           @SCRN                                        CGL132
     C                   ELSE                                                                 CGL132
     C                   IF        WFATCABRW <> ' ' AND                                     MD027324
     C                             CGL132 = 'Y'                                             MD027324
     C                   MOVEL     'J'           @SCRN                                      MD027324
     C                   ELSE                                                               MD027324
     C                   MOVEL     'B'           @SCRN                                        CGL132
     C                   ENDIF                                                              MD027324
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
                                                                                              CGL132
     C     EndVAL@G      ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * VAL@C - Validate FATCA details 2                                                      CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     VAL@C         BEGSR                                                                CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         Idx                                          CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
                                                                                              CGL132
     C                   MOVEL     NewCuFATC     PrvCuFATC                                    CGL132
     C                   Z-ADD     WIdx_CVAL     PrvC_Warn         3 0                        CGL132
     C                   Z-ADD     *ZERO         WIdx_CVAL                                    CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH1VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_CVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EndVAL@C                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If the screen has changed in the course of the validation                            CGL132
      ** or if there are warnings which have not been displayed                               CGL132
      ** re-display the screen                                                                CGL132
                                                                                              CGL132
     C     NewCuFATC     IFNE      PrvCuFATC                                                  CGL132
     C     WIdx_CVAL     ORNE      PrvC_Warn                                                  CGL132
     C                   GOTO      EndVAL@C                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Clear any warning messages                                                           CGL132
                                                                                              CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
     C                   MOVEL     'H'           @SCRN                                        CGL132
                                                                                              CGL132
     C     EndVAL@C      ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * VAL@H - Validate FATCA details 3                                                      CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     VAL@H         BEGSR                                                                CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         Idx                                          CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
                                                                                              CGL132
     C                   MOVEL     NewCuFATC     PrvCuFATC                                    CGL132
     C                   Z-ADD     WIdx_HVAL     PrvH_Warn         3 0                        CGL132
     C                   Z-ADD     *ZERO         WIdx_HVAL                                    CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH2VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_HVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EndVAL@H                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If the screen has changed in the course of the validation                            CGL132
      ** or if there are warnings which have not been displayed                               CGL132
      ** re-display the screen                                                                CGL132
                                                                                              CGL132
     C     NewCuFATC     IFNE      PrvCuFATC                                                  CGL132
     C     WIdx_HVAL     ORNE      PrvH_Warn                                                  CGL132
     C                   GOTO      EndVAL@H                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Clear any warning messages                                                           CGL132
                                                                                              CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
                                                                                              CGL132
      ** If displaying Further Details, return to secondary details                           CGL132
      ** screen, Otherwise move on to message detail screen                                   CGL132
                                                                                              CGL132
     C                   MOVEL     'L'           @SCRN                                        CGL132
                                                                                              CGL132
     C     EndVAL@H      ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * VAL@L - Validate FATCA details 4                                                      CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     VAL@L         BEGSR                                                                CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         Idx                                          CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
                                                                                              CGL132
     C                   MOVEL     NewCuFATC     PrvCuFATC                                    CGL132
     C                   Z-ADD     WIdx_LVAL     PrvL_Warn         3 0                        CGL132
     C                   Z-ADD     *ZERO         WIdx_LVAL                                    CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH3VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_LVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EndVAL@L                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If the screen has changed in the course of the validation                            CGL132
      ** or if there are warnings which have not been displayed                               CGL132
      ** re-display the screen                                                                CGL132
                                                                                              CGL132
     C     NewCuFATC     IFNE      PrvCuFATC                                                  CGL132
     C     WIdx_LVAL     ORNE      PrvL_Warn                                                  CGL132
     C                   GOTO      EndVAL@L                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Clear any warning messages                                                           CGL132
                                                                                              CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
                                                                                              CGL132
      ** If displaying Further Details, return to secondary details                           CGL132
      ** screen, Otherwise move on to message detail screen                                   CGL132
                                                                                              CGL132
     C                   MOVEL     'Y'           @SCRN                                        CGL132
                                                                                              CGL132
     C     EndVAL@L      ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * VAL@Y - Validate US Indicia details 4                                                 CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     VAL@Y         BEGSR                                                                CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         Idx                                          CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
                                                                                              CGL132
     C                   MOVEL     NewCuFATC     PrvCuFATC                                    CGL132
     C                   Z-ADD     WIdx_YVAL     PrvY_Warn         3 0                        CGL132
     C                   Z-ADD     *ZERO         WIdx_YVAL                                    CGL132
                                                                                              CGL132
     C                   CALLB     'SDFTNH4VL'                                                CGL132
                                                                                              CGL132
      ** INPUTS :                                                                             CGL132
      ** Response mode                                                                        CGL132
      ** FATCA customer details                                                               CGL132
      ** FATCA customer details (old)                                                         CGL132
                                                                                              CGL132
     C                   PARM                    RespMode                                     CGL132
     C                   PARM                    NewCuFATC                                    CGL132
     C                   PARM                    CurCuFATC                                    CGL132
                                                                                              CGL132
      ** OUTPUTS :                                                                            CGL132
      ** FATCA Customer Details OK inds                                                       CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
      ** Valid FATCA Customer layout (DS) from/to caller                                      CGL132
                                                                                              CGL132
     C                   PARM                    OkFATCAdet                                   CGL132
                                                                                              CGL132
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    WIdx_TVAL                                    CGL132
                                                                                              CGL132
      ** Valid FATCA file layout (DS) to/from caller                                          CGL132
     C                   PARM                    NwFaFilFmt                                   CGL132
                                                                                              CGL132
      ** If there are errors, redisplay FATCA details screen                                  CGL132
                                                                                              CGL132
     C     Idx           IFNE      0                                                          CGL132
     C                   GOTO      EndVAL@Y                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If the screen has changed in the course of the validation                            CGL132
      ** or if there are warnings which have not been displayed                               CGL132
      ** re-display the screen                                                                CGL132
                                                                                              CGL132
     C     NewCuFATC     IFNE      PrvCuFATC                                                  CGL132
     C     WIdx_YVAL     ORNE      PrvY_Warn                                                  CGL132
     C                   GOTO      EndVAL@Y                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Clear any warning messages                                                           CGL132
                                                                                              CGL132
     C                   MOVE      *ALL'Y'       OkFATCAdet                                   CGL132
     C                   MOVEL     *BLANK        WFldNamArr                                   CGL132
     C                   MOVEL     *BLANK        WMsgIdArr                                    CGL132
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CGL132
                                                                                              CGL132
                                                                                              CGL132
      ** If displaying Further Details, return to secondary details                           CGL132
      ** screen, Otherwise move on to message detail screen                                   CGL132
                                                                                              CGL132
     C                   MOVEL     'G'           @SCRN                                        CGL132
                                                                                              CGL132
     C     EndVAL@Y      ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * SCRNGE - Exception screen                                     *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRNGE        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to Exception screen                                                               CGL132
     C                   MOVEL     'N'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * SCRNGH - US Indicia comment history screen                    *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRNGH        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to US Indicia comment history screen                                              CGL132
     C                   MOVEL     'V'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * SCRNGG - FATCA detail screen 1                                *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCRNGG        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to FATCA detail screen 1                                                          CGL132
     C                   MOVEL     'G'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * CANC@G - Cancel on FATCA detail screen 1                      *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     CANC@G        BEGSR                                                                CGL132
                                                                                              CGL132
     C                   MOVEL     'P'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * CANC@C - Cancel on FATCA detail screen 2                      *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     CANC@C        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to FATCA detail screen 1                                                          CGL132
     C                   MOVEL     'G'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * CANC@H - Cancel on FATCA detail screen 3                      *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     CANC@H        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to FATCA detail screen 2                                                          CGL132
     C                   MOVEL     'C'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * CANC@L - Cancel on FATCA detail screen 3                      *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     CANC@L        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to FATCA detail screen 3                                                          CGL132
     C                   MOVEL     'H'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * CANC@Y - Cancel on FATCA detail screen 4                      *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     CANC@Y        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to FATCA detail screen 3                                                          CGL132
     C                   MOVEL     'L'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      *                                                               *                       CGL132
      * CANC@O - Cancel on Exception screen                           *                       CGL132
      *                                                               *                       CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     CANC@O        BEGSR                                                                CGL132
                                                                                              CGL132
      ** Go to FATCA detail screen                                                            CGL132
     C                   MOVEL     'G'           @SCRN                                        CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRUpdatS - Updates
      *****************************************************************
     C     SRUpdatS      BEGSR
 
      ** Update valid customer: Non-A/C Holders Reference
 
     C                   MOVEL     DDNAHO        NANAHO
     C                   MOVEL     DDACTN        NACHTP
     C                   MOVEL     PSUser        NALUSR                                       CGL132
 
     C                   MOVEL     *BLANK        @RTCD
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   EVAL      FVNAHO = DDNAHO                                            CGL132
     C**********         EVAL      FVGIIN = DDGIIN                                   CGL132 MD029805
     C                   EVAL      FVUTIN = DDUTIN                                            CGL132
     C                   EVAL      FVHMSV = C_FNHMSV                                          CGL132
     C                   EVAL      FVHMSD = C_FNHMSD                                          CGL132
     C                   EVAL      FVHMST = C_FNHMST                                          CGL132
     C                   EVAL      FVMCSV = C_FNMCSV                                          CGL132
     C                   EVAL      FVMCSD = C_FNMCSD                                          CGL132
     C                   EVAL      FVMCST = C_FNMCST                                          CGL132
     C                   EVAL      FVRPSV = C_FNRPSV                                          CGL132
     C                   EVAL      FVRPSD = C_FNRPSD                                          CGL132
     C                   EVAL      FVRPST = C_FNRPST                                          CGL132
     C                   EVAL      FVCISV = C_FNCISV                                          CGL132
     C                   EVAL      FVCISD = C_FNCISD                                          CGL132
     C                   EVAL      FVCIST = C_FNCIST                                          CGL132
     C                   EVAL      FVCBSV = C_FNCBSV                                          CGL132
     C                   EVAL      FVCBSD = C_FNCBSD                                          CGL132
     C                   EVAL      FVCBST = C_FNCBST                                          CGL132
     C                   EVAL      FVCDSV = C_FNCDSV                                          CGL132
     C                   EVAL      FVCDSD = C_FNCDSD                                          CGL132
     C                   EVAL      FVCDST = C_FNCDST                                          CGL132
     C                   EVAL      FVGCSV = C_FNGCSV                                          CGL132
     C                   EVAL      FVGCSD = C_FNGCSD                                          CGL132
     C                   EVAL      FVGCST = C_FNGCST                                          CGL132
     C                   EVAL      FVIDSV = C_FNIDSV                                          CGL132
     C                   EVAL      FVIDSD = C_FNIDSD                                          CGL132
     C                   EVAL      FVIDST = C_FNIDST                                          CGL132
     C                   EVAL      FVJASV = C_FNJASV                                          CGL132
     C                   EVAL      FVJASD = C_FNJASD                                          CGL132
     C                   EVAL      FVJAST = C_FNJAST                                          CGL132
     C                   EVAL      FVTESV = C_FNTESV                                          CGL132
     C                   EVAL      FVTESD = C_FNTESD                                          CGL132
     C                   EVAL      FVTEST = C_FNTEST                                          CGL132
     C                   EVAL      FVTXSV = C_FNTXSV                                          CGL132
     C                   EVAL      FVTXSD = C_FNTXSD                                          CGL132
     C                   EVAL      FVTXST = C_FNTXST                                          CGL132
     C                   EVAL      FVAUSV = C_FNAUSV                                       MD027473A
     C                   EVAL      FVAUSD = C_FNAUSD                                       MD027473A
     C                   EVAL      FVAUST = C_FNAUST                                       MD027473A
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
 
      ** Non-account Holder updates
 
     C                   CALLB     'SDNAHLUPD'
     C                   PARM                    @RTCD
     C                   PARM                    NwNaFilFmt
     C                   PARM                    NwFaFilFmt                                   CGL132
 
      ** Non-a/c Holder by Country of Tax updates.                                            233295
                                                                                              233295
     C                   IF        @RTCD = *BLANKS AND                                        233295
     C                             DDACTN = 'D'                                               233295
                                                                                              233295
     C                   EVAL      KNAHo = DDNAHO                                             233295
     C     KNAHo         SETLL     SDNHTXL1                                                   233295
     C     KNAHo         READE     SDNHTXL1                                                   233295
                                                                                              233295
     C                   DOW       NOT %EOF(SDNHTXL1)                                         233295
                                                                                              233295
     C                   CALLB     'SDNATXUPD'                                                233295
     C                   PARM      *BLANKS       RetCodeOut                                   233295
     C                   PARM                    DDACTN                                       233295
     C                   PARM                    NHTxFilFmt                                   233295
                                                                                              233295
     C                   IF        RetCodeOut <> *BLANKS                                      233295
     C                   EVAL      @RTCD = '*ERROR '                                          233295
     C                   LEAVE                                                                233295
     C                   ENDIF                                                                233295
                                                                                              233295
     C     KNAHo         READE     SDNHTXL1                                                   233295
     C                   ENDDO                                                                233295
                                                                                              233295
     C                   ENDIF                                                                233295
                                                                                              233295
      ** If there were any errors in the Update fucntions, Rollback any
      ** updates and end this program. otherwise, Commit the updates
 
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Commit
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANKS                                            CGL132
     C                             AND CGL132 ='Y'                                            CGL132
     C                             AND CGL133 ='N'                                            CGL132
                                                                                              CGL132
     C                   CALL      'QCMDEXC'                                                  CGL132
     C                   PARM                    ##OV1                                        CGL132
     C                   PARM                    WMsgLen                                      CGL132
                                                                                              CGL132
     C                   CALL      'QCMDEXC'                                                  CGL132
     C                   PARM                    ##OV3                                        CGL132
     C                   PARM                    WMsgLen                                      CGL132
                                                                                              CGL132
     C                   CALL      'SD000732'                                                 CGL132
     C                   PARM      *BLANKS       PReturn                                      CGL132
     C                   PARM      NANAHO        PTranID                                      CGL132
     C                   PARM      'N'           PSource                                      CGL132
     C                   PARM                    PClass                                       CGL132
     C                   PARM                    PClass                                       CGL132
     C                   PARM      ' '           PRepType                                     CGL132
     C                   PARM      'A'           PMode                                        CGL132
                                                                                              CGL132
     C                   CALL      'QCMDEXC'                                                  CGL132
     C                   PARM                    ##OV2                                        CGL132
     C                   PARM                    WMsgLen                                      CGL132
                                                                                              CGL132
     C                   CALL      'QCMDEXC'                                                  CGL132
     C                   PARM                    ##OV4                                        CGL132
     C                   PARM                    WMsgLen                                      CGL132
                                                                                              CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C**********         EXSR      SRCallNATX                                                 233004
 
      ** If records are still to be read from the subfile, read them
 
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
 
      ** ELSE, return to insert key screen or browse subfile
 
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'K'           @SCRN
     C                   ELSE
     C                   IF        WFATCABRW <> ' ' AND                                     MD027324
     C                             CGL132 = 'Y'                                             MD027324
     C                   MOVEL     'J'           @SCRN                                      MD027324
     C                   ELSE                                                               MD027324
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF                                                              MD027324
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WNATXok = 'N'                                              233004
     C                             AND DDACTN <> 'D'                                          233295
     C                   EXSR      SRCallNATX                                                 233004
     C                   IF        DDACTN <> 'I'                                              233295
     C                             AND DDACTN <> *BLANK                                       235364
     C                   EVAL      @SCRN = 'P'                                                233004
     C                   ENDIF                                                                233295
     C                   ENDIF                                                                233004
                                                                                              233004
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SREndP - End Program
      *****************************************************************
     C     SREndP        BEGSR
 
     C                   MOVEL     'T'           @SCRN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRInitial - Go To Initial Screen
      *****************************************************************
     C     SRInitial     BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   MOVEL     *BLANK        @RDNB
 
      ** Blank the screens
 
     C                   MOVEL     *BLANK        NewNaPrim
 
      ** Browse Screen
 
     C                   IF        WFATCABRW <> ' ' AND                                     MD027324
     C                             CGL132 = 'Y'                                             MD027324
     C                   MOVEL     'J'           @SCRN                                      MD027324
     C                   ELSE                                                               MD027324
     C                   MOVEL     'B'           @SCRN
     C                   ENDIF                                                              MD027324
 
      ** Initialize field status on Key Screen
 
     C                   EXSR      SRIfdS@K
 
     C                   EVAL      WNATXok = 'N'                                              233295
                                                                                              233295
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   MOVEL     'SDNAHLSIN'   DBPGM
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     Retcd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     Option        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check SAR's CGL031/CGL032 if available                                               CSW027
                                                                                              CSW027
     C                   CALL      'AOSARDR0'                                                 CSW027
     C                   PARM      *Blanks       Retcd                                        CSW027
     C                   PARM      '*VERIFY'     Option                                       CSW027
     C                   PARM      'CGL031'      PSard                                        CSW027
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW027
                                                                                              CSW027
     C                   IF        Retcd <> *Blanks                                           CSW027
     C                   IF        Retcd <> '*NRF'                                            CSW027
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSW027
     C                   MOVEL     '902'         DBASE                                        CSW027
     C                   MOVEL     PSard         DBKEY                                        CSW027
     C                   EXSR      *PSSR                                                      CSW027
     C                   ENDIF                                                                CSW027
     C                   ELSE                                                                 CSW027
     C                   EVAL      CGL031 = 'Y'                                               CSW027
     C                   ENDIF                                                                CSW027
                                                                                              CSW027
     C                   CALL      'AOSARDR0'                                                 CSW027
     C                   PARM      *Blanks       Retcd                                        CSW027
     C                   PARM      '*VERIFY'     Option                                       CSW027
     C                   PARM      'CGL032'      PSard                                        CSW027
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW027
                                                                                              CSW027
     C                   IF        Retcd <> *Blanks                                           CSW027
     C                   IF        Retcd <> '*NRF'                                            CSW027
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSW027
     C                   MOVEL     '903'         DBASE                                        CSW027
     C                   MOVEL     PSard         DBKEY                                        CSW027
     C                   EXSR      *PSSR                                                      CSW027
     C                   ENDIF                                                                CSW027
     C                   ELSE                                                                 CSW027
     C                   EVAL      CGL032 = 'Y'                                               CSW027
     C                   ENDIF                                                                CSW027
                                                                                              CSW027
                                                                                              CSD093
      ** Check whether CSD093 is available                                                    CSD093
                                                                                              CSD093
     C                   CALL      'AOSARDR0'                                                 CSD093
     C                   PARM      *Blanks       Retcd                                        CSD093
     C                   PARM      '*VERIFY'     Option                                       CSD093
     C                   PARM      'CSD093'      PSard                                        CSD093
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD093
                                                                                              CSD093
     C                   IF        Retcd <> *Blanks                                           CSD093
     C                   IF        Retcd <> '*NRF'                                            CSD093
     C                   MOVEL     'SCSARDPD'    Dbfile                                       CSD093
     C                   MOVEL     '905'         Dbase                                        CSD093
     C                   MOVEL     PSard         Dbkey                                        CSD093
     C                   EXSR      *PSSR                                                      CSD093
     C                   ENDIF                                                                CSD093
     C                   EVAL      CSD093 = 'N'                                               CSD093
     C                   ELSE                                                                 CSD093
     C                   EVAL      CSD093 = 'Y'                                               CSD093
     C                   ENDIF                                                                CSD093
      ** Check if CGL132 is on                                                                CGL132
                                                                                              CGL132
     C                   EVAL      @IN81 = '0'                                                CGL132
     C                   CALL      'AOSARDR0'                                                 CGL132
     C                   PARM      *Blanks       Retcd                                        CGL132
     C                   PARM      '*VERIFY'     Option                                       CGL132
     C                   PARM      'CGL132'      PSard                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C                   IF        Retcd <> *Blanks                                           CGL132
     C                   IF        Retcd <> '*NRF'                                            CGL132
     C                   MOVEL     'SCSARDPD'    Dbfile                                       CGL132
     C                   MOVEL     '904'         Dbase                                        CGL132
     C                   MOVEL     PSard         Dbkey                                        CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ENDIF                                                                CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      CGL132 = 'Y'                                               CGL132
     C                   EVAL      @IN81 = '1'                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Check if CGL133 is on                                                                CGL132
                                                                                              CGL132
     C                   CALL      'AOSARDR0'                                                 CGL132
     C                   PARM      *Blanks       Retcd                                        CGL132
     C                   PARM      '*VERIFY'     Option                                       CGL132
     C                   PARM      'CGL133'      PSard                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C                   EVAL      CGL133 = 'N'                                               CGL132
     C                   IF        Retcd <> *Blanks                                           CGL132
     C                   IF        Retcd <> '*NRF'                                            CGL132
     C                   MOVEL     'SCSARDPD'    Dbfile                                       CGL132
     C                   MOVEL     '911'         Dbase                                        CGL132
     C                   MOVEL     PSard         Dbkey                                        CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ENDIF                                                                CGL132
     C                   ELSE                                                                 CGL132
     C                   EVAL      CGL133 = 'Y'                                               CGL132
     C                   ENDIF                                                                CGL132
     C                   EVAL      WFATCABRW = ' '                                          MD027324
      ** Go to initial screen
 
     C                   EXSR      SRInitial
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
** ##OV1
OVRDBF FILE(SDNAHOL0) TOFILE(SDNAHOL0) SHARE(*NO)
** ##OV2
DLTOVR FILE(SDNAHOL0)
** ##OV3
OVRDBF FILE(SDFTNHL0) TOFILE(SDFTNHL0) SHARE(*NO)
** ##OV4
DLTOVR FILE(SDFTNHL0)
