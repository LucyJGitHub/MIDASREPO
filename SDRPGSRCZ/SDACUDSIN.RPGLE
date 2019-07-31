     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Details Screen Input')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDACUDSIN - Additional Customer Details Screen Input         *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for SD Additional Customer Details Maintenance.   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD053719           Date 20Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER070             Date 19Aug14               *
      *                 CGL132             Date 01May13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26711           Date 10Nov09               *
      *                 BUG26637           Date 03Nov09               *
      *                 BUG25533           Date 19Aug09               *
      *                 BUG25876           Date 02Sep09               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24252           Date 10Jul09               *
      *                 BUG24346           Date 16Jun09               *
      *                 BUG24208           Date 10Jun09               *
      *                 BUG23883           Date 04May09               *
      *                 BUG24013           Date 15May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23753           Date 17Apr09               *
      *                 BUG23573           Date 30Mar09               *
      *                 BUG23518           Date 30Mar09               *
      *                 BUG23223           Date 04Mar09               *
      *                 BUG23182           Date 03Mar09               *
      *                 BUG22578A          Date 17Feb09               *
      *                 BUG22529           Date 10Feb09               *
      *                 BUG22667           Date 06Feb09               *
      *                 BUG22133           Date 20Jan09               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 250804A            Date 11Oct07               *
      *                 CSW207A            Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW207             Date 08Jun07               *
      *                 233804             Date 10Oct06               *
      *                 BUG11936           Date 21Aug06               *
      *                 CSD029             Date 22Aug05               *
      *                 237063             Date 20Nov05               *
      *                 235171             Date 08Sep05               *
      *                 234647             Date 12Jul05               *
      *                 234613             Date 12Jul05               *
      *                 234227             Date 27Jun05               *
      *                 233468             Date 12May05               *
      *                 233004             Date 12Apr05               *
      *                 232543             Date 31Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053719 - Compilation error due to fields not renamed       *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *           (Recompile)                                         *
      *  BUG26711 - Amendments made in ACUD was not saved when '?' is *
      *             used to select the valid values.                  *
      *  BUG26637 - Unable to exit to the main screen                 *
      *  BUG25533 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *             (Applied BUG24714 fix)                            *
      *  BUG24714 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *  BUG25876 - Database error when CER054 is off (Recompile)     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *  BUG24252 - Screen goes to the next page immediately after    *
      *           selecting from the pick list                        *
      *  BUG24346 - Change validation from tax ID to Identification   *
      *             type                                              *
      *  BUG24208 - IBAN GL format should be 1, 2, 3, 4, or 5         *
      *  BUG23883 - Certificate dates do not default until validation *
      *             on last screen                                    *
      *  BUG24013 - Religious Affiliation Code in SDACUSPD has been   *
      *             deleted. (Recompile)                              *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23753 - Order of screen is incorrect for insert/amend     *
      *  BUG23573 - Database error and timeout occurs when            *
      *             deleting ACUD entries                             *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG23223 - Incorrect '@Scrn' value set during Update run     *
      *  BUG23182 - Session time out occurs upon creating new Customer*
      *             and inserting Additional Customer data            *
      *  BUG22578A - Amend screen flow for German Taxes               *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  BUG22667 - Session time out occurs when entering data in     *
      *             ACUD                                              *
      *  BUG22133 - Delete option missing from selection screen       *
      *  CER034 - German Features - New Fields and Enquiries          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  250804A - Looping when pressing Enter as program cannot exit *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  233804 - Validate first screen after changing taxable status.*
      *  BUG11936 - Error message displayed when trying to select     *
      *             customer                                          *
      *  CSD029 - Customer Details Additional Fields.                 *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  235171 - Do not permit Deletion of CCTX details if Joint     *
      *           Account Type is not 'N'.                            *
      *  234647 - After customer detail by country of tax (SDCCTXSIN) *
      *           the program should return if not option ACUD.       *
      *  234613 - The action code delete is not working               *
      *  234227 - Prompt records from SDACTXPD for any action code ;  *
      *           allow deletion if Joint Account Type changes to 'N' *
      *  233468 - F9 key on Additional Customer Details Maintenance.  *
      *  233004 - Addtl Cust and Non-a/c Holder by Country of Tax     *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL032 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************


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

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+


      ** Current Transaction Detail in File Format
     D CrMnFilFmt    E DS                  EXTNAME(SDACUSPD)
     D                                     PREFIX(C_)

      ** Current Transaction  Detail in Screen Format
     D CurTrnDets    E DS                  EXTNAME(SDACUDPD)
     D                                     PREFIX(@)
      *                                                                                       CER034
      ** Current Transaction Screen 2 Detail in Screen Format                                 CER034
     D CurCustDet2   E DS                  EXTNAME(SDACU3DPD)                                 CER034
      *                                                                                       CER034
      ** Current Transaction Screen 3 Detail in Screen Format                                 CER034
     D CurCustDet3   E DS                  EXTNAME(SDACU4DPD)                                 CER034
      *
      ** Current Transaction Screen 5 Detail in Screen Format                                 CGL132
     D CurCustDet5   E DS                  EXTNAME(SDACU5DPD)                                 CGL132
     D                                     PREFIX(@)

      ** New Transaction Detail in File Format
     D NwMnFilFmt    E DS                  EXTNAME(SDVACUDPD)

      ** Previous Transaction Detail in Scrn Format
     D PrvTrnDets    E DS                  EXTNAME(SDACUDPD)
     D                                     PREFIX(@P)
      *                                                                                       CER034
      ** Previous Transaction Screen 2 Detail in Screen Format                                CER034
     D PrvCustDet2   E DS                  EXTNAME(SDACU3DPD)                                 CER034
     D                                     PREFIX(P1)                                         CER034
      *                                                                                       CER034
      ** Previous Transaction Screen 3 Detail in Screen Format                                CER034
     D PrvCustDet3   E DS                  EXTNAME(SDACU4DPD)                                 CER034
     D                                     PREFIX(P2)                                         CER034
      *
      ** Previous Transaction Screen 5 Detail In Screen Format                                CGL132
     D PrvCustDet5   E DS                  EXTNAME(SDACU5DPD)                                 CGL132
     D                                     PREFIX(@P)                                         CGL132

      ** Error indicators
     D OKTrnDets     E DS                  EXTNAME(SDEACUDPD)
     D OKCustDet2    E DS                  EXTNAME(SDEACU3PD)                                 CER034
     D OKCustDet3    E DS                  EXTNAME(SDEACU4PD)                                 CER034
     D OKCustDets5   E DS                  EXTNAME(SDEACU5PD)                                 CGL132
     D                                     PREFIX(C5)                                       MD053719

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *                                                                                       CER034
      ** External DS for Customer Details                                                     CER034
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER034

      ** First DS for Access Programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CGL132
      ** Override Database Table                                                              CGL132
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)                            CGL132
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)                            CGL132

     D SVALSCRN        DS           250                                                       CSD029
     D  DDDS01                 1     25                                                       CSD029
     D  DDDS02                26     50                                                       CSD029
     D  DDDS03                51     75                                                       CSD029
     D  DDDS04                76    100                                                       CSD029
     D  DDDS05               101    125                                                       CSD029
     D  DDDS06               126    150                                                       CSD029
     D  DDDS07               151    175                                                       CSD029
     D  DDDS08               176    200                                                       CSD029
     D  DDDS09               201    225                                                       CSD029
     D  DDDS10               226    250                                                       CSD029


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')

      ** Transaction Number
     D DDCUST          S              6A

      ** Transaction Number - OK
     D DDCUSTOK        S              1A

      ** Action Code
     D DDACTN          S              1A

      ** Action Code - OK
     D DDACTNOK        S              1A

      ** Build subfile
     D PBDSFL          S              1A

      ** Customer selected
     D PCUSEL          S              6A

      ** Work field for State Code                                                          BUG24252
     DDSQUEST          DS                                                                   BUG24252
     D WDSTCD                         2A                                                    BUG24252
     D WDRLAF                         4A                                                    BUG24252
                                                                                            BUG24252
      ** Whether position/select fields have been changed during key browse
     D KPosSelChg      S              1A

      ** error message reference
     D PERRMS          S              7A

      ** F3 Exit
     D PINKC           S              1A

      ** F7 Roll backwards
     D PINKG           S              1A

      ** F8 Roll forwards
     D PINKH           S              1A

      ** F9 Insert
     D PINKI           S              1A

      ** F12 Cancel                                                                         BUG22133
     D PINKJ           S              1A                                                    BUG22133
                                                                                            BUG22133
      ** F12 Cancel
     D PINKL           S              1A
      *                                                                                     BUG23518
      ** F22 - Close/Release                                                                BUG23518
      *                                                                                     BUG23518
     D PINKW           S              1A                                                    BUG23518

      ** Option selected
     D POPSEL          S              1A

      ** Read backwards in roll
     D PRDBCK          S              1A

      ** Read forwards in roll
     D PRDFWD          S              1A

      ** Read next browse
     D PRDNB           S              1A

      ** Read subfile
     D PRDSFL          S              1A

      **
     D PSCRED          S              6A

      ** Screen / function
     D @SCRN           S              1A

      ** Read next browse in key screen query browse subfile
     D KPRDNB          S              1A

      ** Query check in key screen customer number field
     D KEYQUERY        S              1A

      ** Mode of operation
     D MODEOFOP        S              6A

      ** Called from Customer Details or Midas menu
     D BrwQuery        S              1A

      ** Index of errors
     D E               S              3P 0
     D Idx             S              3P 0
     D Widx            S              3P 0
     D PrvN_Warn       S              3P 0

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** Parameters for Access Objects
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D CGL031          S              1A                                                      CSW207
     D CGL032          S              1A
     D CSD029          S              1A                                                      CSD029
     D PKyst           S              7A                                                      CER034
     D PKey            S             10A                                                      CER034

      ** Parameters for SDACUDDSP
     D PEKYFD          S              1A
     D PEDTFD          S              1A
     D PEINKG          S              1A
     D SDCUSDcall      S              1A
     D PSDACUDENQ      S              1A
     D PCGL032         S              1A
     D PEPRTD          S              1A

      ** Parameters for SDACUDBRW
     D PMultEntry      S              1A   INZ

      ** Indicator for second pass for option selected
     D P2Pass          S              1A

      ** Other Variables
     D WSCRN           S              1A
     D WKCUST          S              6A
     D WCCTXok         S              1A                                                      233004
     D WDDACTN         S              1A                                                      234227
     D WDelete         S              1A                                                      234227
     D WReshow         S              1A                                                      234227

     D PAction         S              1A
     D PCust           S              6A
     D PEINKH          S              1A                                                      233468
     D INSERTENQ       S              1A                                                      233468
                                                                                              CSD029
      ** Parameters for AOSVALR0                                                              CSD029
     D P@OP01          S             20A                                                      CSD029
     D P@OP02          S             20A                                                      CSD029
     D P@OP03          S             20A                                                      CSD029
     D P@OP04          S             20A                                                      CSD029
     D P@OP05          S             20A                                                      CSD029
     D P@OP06          S             20A                                                      CSD029
     D P@OP07          S             20A                                                      CSD029
     D P@OP08          S             20A                                                      CSD029
     D P@OP09          S             20A                                                      CSD029
     D P@OP10          S             20A                                                      CSD029
     D P@VL01          S            200A                                                      CSD029
     D P@VL02          S            200A                                                      CSD029
     D P@VL03          S            200A                                                      CSD029
     D P@VL04          S            200A                                                      CSD029
     D P@VL05          S            200A                                                      CSD029
     D P@VL06          S            200A                                                      CSD029
     D P@VL07          S            200A                                                      CSD029
     D P@VL08          S            200A                                                      CSD029
     D P@VL09          S            200A                                                      CSD029
     D P@VL10          S            200A                                                      CSD029
                                                                                              CSD029
     D @VAL01          C                   'AddCustDtlFl01'                                   CSD029
     D @VAL02          C                   'AddCustDtlFl02'                                   CSD029
     D @VAL03          C                   'AddCustDtlFl03'                                   CSD029
     D @VAL04          C                   'AddCustDtlFl04'                                   CSD029
     D @VAL05          C                   'AddCustDtlFl05'                                   CSD029
     D @VAL06          C                   'AddCustDtlFl06'                                   CSD029
     D @VAL07          C                   'AddCustDtlFl07'                                   CSD029
     D @VAL08          C                   'AddCustDtlFl08'                                   CSD029
     D @VAL09          C                   'AddCustDtlFl09'                                   CSD029
     D @VAL10          C                   'AddCustDtlFl10'                                   CSD029
      *                                                                                       CER034
      ** Switchable Features                                                                  CER034
     D CER034          S              1A                                                      CER034
     D CER038          S              1A                                                      CER034
     D CER041          S              1A                                                      CER034
     D CER047          S              1A                                                      CER034
     D CER048          S              1A                                                      CER034
     D CER054          S              1A                                                      CER054
     D CER045          S              1A                                                      CER045
      *                                                                                       CER034
      ** Display Screens Y/N Flag                                                             CER034
     D WDspScrn1       S              1A                                                      CER034
     D WDspScrn2       S              1A                                                      CER034
     D PCallFrom       S              1A                                                      CER034
     D WRun            S              1A   INZ('N')                                           CER034
     D WUpdFlg         S              1A                                                   BUG22578A
     D WDefault        S              1A   INZ('N')                                        BUG22578A
     D WPrvFlg         S              1A                                                   BUG22578A
     D WUpdate         S              1A                                                    BUG23223
     D DfltScrn1       S              1A                                                    BUG23883
     D*WScn1IsOk       S              1A   INZ('N')                                BUG23573 BUG23753
     D*WScn2IsOk       S              1A   INZ('N')                                BUG23573 BUG23753
                                                                                              CGL132
     D PReturn         S              7A                                                      CGL132
     D PTranID         S             10A                                                      CGL132
     D PSource         S              1A                                                      CGL132
     D PClass          S              5A                                                      CGL132
     D PRepType        S              1A                                                      CGL132
     D PTMode          S              1A                                                      CGL132
     D WMsgLen         S             15P 5 INZ(50)                                            CGL132
     D CGL132          S              1A                                                      CGL132
     D CGL133          S              1A                                                      CGL132

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

     C                   EVAL      WKCust = DDCUST

      ** Issue rollback to clear any possible updates in window functions

     C                   IF        PINKL = '1'
     C                   ROLBK
     C                   ENDIF

      ** Build browse subfile record

     C                   IF        @SCRN = 'B'
     C                   EXSR      SRBldBrw
     C                   ENDIF

      ** Read next browse subfile record

     C                   IF        @SCRN = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
                                                                                              233468
      ** Do While screen: Key Details Screen                                                  233468
                                                                                              233468
     C                   DOW       @SCRN = 'K'                                                233468
     C                   EXSR      SRScrn@K                                                   233468
     C                   ENDDO                                                                233468

     C                   IF        @SCRN = ' '
     C                   EXSR      SRRtvTrn
     C                   IF        DDACTNOK = 'N' or
     C                             DDCUSTOK = 'N'
     C                   EVAL      @SCRN = 'T'
     C                   ENDIF

      ** If action code is not insert
      **  .. Convert the Transaction details to screen format
      **  .. Go to Details screen
      **

     C                   IF        DDACTN <> 'I'
     C                   EXSR      SRCvtTrn
     C                   EVAL      NwMnFilFmt = CrMnFilFmt
     C                   EXSR      SRSfDs@p
     C                   ENDIF

      ** Clear DS parameter arrays and go to detail screen

     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   EVAL      @SCRN = 'P'
     C                   EXSR      SRSfDs@p
     C                   ENDIF
      *                                                                                    BUG22578A
      ** Set Update Flag value                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   IF        WUpdFlg = *BLANKS                                       BUG22578A
     C                   EVAL      WUpdFlg = '1'                                           BUG22578A
     C                   ELSE                                                              BUG22578A
     C                   EVAL      WUpdFlg = '2'                                           BUG22578A
     C                   ENDIF                                                             BUG22578A

      ** Do while screen: Transaction Detail Screen

     C                   Z-ADD     *ZERO         WIdx
     C                   DOW       @SCRN = 'P'
     C                   EXSR      SRScrn@p
     C                   EXSR      SRSfDs@p
     C                   ENDDO
      **********                                                                    CER034 BUG22578A
      ***Do*while*screen:*Additional*Customer*Details*Screen*-*2                    CER034 BUG22578A
      **********                                                                    CER034 BUG22578A
     C**********         IF        WDspScrn1 = 'Y'                                  CER034 BUG22578A
      **********                                                                    CER034 BUG22578A
     C**********         EVAL      WIdx = *ZEROS                                    CER034 BUG22578A
     C**********         DOW       @SCRN = 'D'                                      CER034 BUG22578A
     C**********         EXSR      SRScrn@D                                         CER034 BUG22578A
     C**********         ENDDO                                                      CER034 BUG22578A
      **********                                                                    CER034 BUG22578A
     C**********         ENDIF                                                      CER034 BUG22578A
      **********                                                                    CER034 BUG22578A
      ***Do*While*Screen:*Additional*Customer*Details*Screen*-*3                    CER034 BUG22578A
      **********                                                                    CER034 BUG22578A
     C**********         IF        WDspScrn2 = 'Y'                                  CER034 BUG22578A
      **********                                                                    CER034 BUG22578A
     C**********         EVAL      WIdx = *ZEROS                                    CER034 BUG22578A
     C**********         DOW       @SCRN = 'E'                                      CER034 BUG22578A
     C**********         EXSR      SRScrn@E                                         CER034 BUG22578A
     C**********         ENDDO                                                      CER034 BUG22578A
      **********                                                                    CER034 BUG22578A
     C**********         ENDIF                                                      CER034 BUG22578A
                                                                                              CSD029
      ** Do while screen: Secondary Detail Screen                                             CSD029
                                                                                              CSD029
     C                   Z-ADD     *ZERO         WIdx                                         CSD029
     C                   DOW       @SCRN = 'S'                                                CSD029
     C                   EXSR      SRScrn@s                                                   CSD029
     C                   EXSR      SRSfDs@p                                                   CSD029
     C                   ENDDO                                                                CSD029

      ** Do while screen: Detail Screen 5                                                     CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         WIdx                                         CGL132
     C                   DOW       @SCRN = '5'                                                CGL132
     C                   EXSR      SRScrn@5                                                   CGL132
     C                   EXSR      SRSfDs@p                                                   CGL132
     C                   ENDDO                                                                CGL132
      ** Call for Customer details by Country of Tax

     C                   IF        @SCRN = 'A'
     C                   IF        CGL031 = 'Y' AND CGL032 = 'Y'                              CSW207
     C                   EXSR      SRCallACTX
     C                   ELSE                                                                250804A
     C**********         EVAL      @SCRN = 'T'                                     250804A BUG22578A
      *                                                                                    BUG22578A
     C                   IF        WDspScrn1 = 'Y'                                         BUG22578A
     C                   EVAL      @SCRN = 'D'                                             BUG22578A
     C                   ELSE                                                              BUG22578A
      *                                                                                    BUG22578A
     C                   IF        WDspScrn2 = 'Y'                                         BUG22578A
     C                   EVAL      @SCRN = 'E'                                             BUG22578A
     C                   ELSE                                                              BUG22578A
      *                                                                                    BUG22578A
     C                   EVAL      @SCRN = 'T'                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                                CSW207
     C                   ENDIF
      *                                                                                    BUG22578A
      ** Do while screen: Additional Customer Details Screen - 2                           BUG22578A
      *                                                                                    BUG22578A
     C                   IF        WDspScrn1 = 'Y'                                         BUG22578A
      *                                                                                    BUG22578A
     C**********         EVAL      WScn1IsOk = 'N'                                 BUG23573 BUG23753
     C                   EVAL      WIdx = *ZEROS                                           BUG22578A
     C                   DOW       @SCRN = 'D'                                             BUG22578A
     C                   EXSR      SRScrn@D                                                BUG22578A
     C**********         EVAL      WScn1IsOk = 'Y'                                 BUG23573 BUG23753
     C                   ENDDO                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
      ** Do While Screen: Additional Customer Details Screen - 3                           BUG22578A
      *                                                                                    BUG22578A
     C                   IF        WDspScrn2 = 'Y'                                         BUG22578A
      *                                                                                    BUG22578A
     C**********         EVAL      WScn2IsOk = 'N'                                 BUG23573 BUG23753
     C                   EVAL      WIdx = *ZEROS                                           BUG22578A
     C                   DOW       @SCRN = 'E'                                             BUG22578A
     C                   EXSR      SRScrn@E                                                BUG22578A
     C**********         EVAL      WScn2IsOk = 'Y'                                 BUG23573 BUG23753
     C                   ENDDO                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                             BUG22578A

      ** Do File updates

     C**********         IF        WDspScrn1 = 'Y' OR                              BUG23573 BUG23753
     C**********                   WDspScrn2 = 'Y'                                 BUG23573 BUG23753
     C**********         IF        WScn1IsOk = 'Y' OR                              BUG23573 BUG23753
     C**********                   WScn2IsOk = 'Y'                                 BUG23573 BUG23753
     C**********         IF        @SCRN = 'U'                                     BUG23573 BUG23753
     C**********         EXSR      SRUpdats                                        BUG23573 BUG23753
     C**********         ENDIF                                                     BUG23573 BUG23753
     C**********         ELSE                                                      BUG23573 BUG23753
                                                                                            BUG23573
      ***Any*function*key*except*F12                                               BUG23573 BUG23753
                                                                                            BUG23573
     C**********         IF        @SCRN = 'U'                                     BUG23573 BUG23753
     C**********         EVAL      @SCRN = 'D'                                     BUG23573 BUG23753
     C**********         ENDIF                                                     BUG23573 BUG23753
     C**********         ENDIF                                                     BUG23573 BUG23753
     C**********         ELSE                                                      BUG23573 BUG23753
     C                   IF        @SCRN = 'U'
      *                                                                                     BUG23753
      ** If action is delete, show only the                                                 BUG23753
      ** primary screen and country of tax screen                                           BUG23753
      *                                                                                     BUG23753
     C                   IF        DDACTN = 'D'                                             BUG23753
     C                   EVAL      WUpdflg = '2'                                            BUG23753
     C                   ENDIF                                                              BUG23753
     C                   EXSR      SRUpdats
     C                   ENDIF
     C**********         ENDIF                                                     BUG23573 BUG23753

      ** Terminate program

     C                   IF        @SCRN = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF

      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSfDs@p - Set Field Status on Detail Screen
      *****************************************************************
     C     SRSfDs@p      BEGSR

      ** Enable/disable fields on detail screen

     C                   IF        DDACTN = 'I' or
     C                             DDACTN = 'A'

      ** Enable key fields on detail screen

     C                   EVAL      PEKYFD = 'Y'
     C                   EVAL      PEDTFD = 'Y'
     C                   EVAL      PEPRTD = 'Y'
     C                   ELSE
     C                   EVAL      PEKYFD = 'N'
     C                   EVAL      PEDTFD = 'N'
     C                   EVAL      PEPRTD = 'N'
     C                   ENDIF

      ** Check Swichable feature

     C                   SELECT
     C                   WHEN      CGL032 = 'Y' and DDACTN = 'E'
     C                   EVAL      PCGL032 = 'N'

     C                   WHEN      CGL032 = 'Y' and DDACTN = 'A'
     C                   EVAL      PCGL032 = 'Y'

     C                   WHEN      CGL032 = 'N' and
     C                             (DDACTN = 'A' or DDACTN = 'E')
     C                   EVAL      PCGL032 = 'N'
     C                   EVAL      PEPRTD = 'N'
     C                   ENDSL
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRScrn@p - Process Detail Screen
      *****************************************************************
     C     SRScrn@p      BEGSR

      ** Set function key status on screen

     C                   EVAL      @DDACTN = DDACTN
     C                   EVAL      @DDCUST = DDCUST

      ** Write/Read Display Screen - Primary Details

     C                   CALLB     'SDACUDDSP'

      ** Input Parameters :
      ** Return code
     C                   PARM      *Blanks       RetCodeIn

      ** Transaction Details in screen format
     C                   PARM                    CurTrnDets

      ** Transaction Details OK indicators
     C                   PARM                    OKTrnDets

      ** Called from customer details module or direct from Midas menu
     C                   PARM                    SDCUSDcall

      ** Set to ' ' to indicate its from SDACUDSIN otherwise from SDACUDENQ
     C                   PARM      *Blanks       PSDACUDENQ

      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Warning
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Enabled Key & Detail Fields
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
     C                   PARM      'Y'           PEINKG

      ** Protected field due to CGL032
     C                   PARM                    PEPRTD

      ** Switchable features CGL032
     C                   PARM                    PCGL032

      ** Output Parameters :
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKJ                                      BUG22133
     C                   PARM      '0'           PINKW                                      BUG23518

      ** Reset Errors

     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIdArr   = *Blanks
     C                   EVAL      MsgDtaArr  = *Blanks
     C                   EVAL      WFldNamArr = *Blanks
     C                   EVAL      WMsgIDArr  = *Blanks
     C                   EVAL      WMsgDtaArr = *Blanks

      ** F3 - End Program
     C     PINKC         CASEQ     '1'           SREndp

      ** F7 - Roll Backwards
     C     PINKG         CASEQ     '1'           SRRoll

      ** F8 - Roll Forwards
     C     PINKH         CASEQ     '1'           SRRoll

      ** F12 - Cancel on Details Screen
     C     PINKL         CASEQ     '1'           SRCanc@p

      ** Validate Input to Details Screen                                                     CSD029
     C                   CAS                     SRVal@p                                      CSD029

     C                   ENDCS
      *                                                                                     BUG22133
     C     DDACTN        IFNE      'D'                                                      BUG22133
     C     DDACTN        ANDNE     'C'                                                      BUG23518
     C     DDACTN        ANDNE     'R'                                                      BUG23518
      *                                                                                     BUG22133
     C     Idx           IFEQ      0                                                          CSD029
     C     @SCRN         ANDEQ     'P'                                                        CSD029
     C*****WDspScrn1     IFNE      'Y'                                              CER034 BUG22578A
     C*****WDspScrn2     ANDNE     'Y'                                              CER034 BUG22578A
     C     PINKG         ANDEQ     '0'                                                        CER034
     C     PINKH         ANDEQ     '0'                                                        CER034
     C                   EVAL      @SCRN = 'S'                                                CSD029
     C**********         ELSE                                                       CER034 BUG22578A
     C*****WDspScrn1     IFEQ      'Y'                                              CER034 BUG22578A
     C*****PINKG         ANDEQ     '0'                                              CER034 BUG22578A
     C*****PINKH         ANDEQ     '0'                                              CER034 BUG22578A
     C**********         EVAL      @SCRN = 'D'                                      CER034 BUG22578A
     C**********         ELSE                                                       CER034 BUG22578A
     C*****WDspScrn2     IFEQ      'Y'                                              CER034 BUG22578A
     C*****PINKG         ANDEQ     '0'                                              CER034 BUG22578A
     C*****PINKH         ANDEQ     '0'                                              CER034 BUG22578A
     C**********         EVAL      @SCRN = 'E'                                      CER034 BUG22578A
     C**********         ENDIF                                                      CER034 BUG22578A
     C**********         ENDIF                                                      CER034 BUG22578A
     C**********         ENDIF                                                      CER034 BUG22578A
      *                                                                                       CER034
     C                   ENDIF                                                                CSD029

     C                   ENDIF                                                              BUG22133
      *                                                                                     BUG22133
      ***Set*Screen*fields*accordingly*if*LF046*is*ON                             BUG22578A BUG23223
      **********                                                                  BUG22578A BUG23223
     C**********         IF        (DDACTN = 'I' OR                               BUG22578A BUG23223
     C**********                   DDACTN = 'A') AND                              BUG22578A BUG23223
     C**********                   PINKC <> '1' AND                               BUG22578A BUG23223
     C**********                   PINKL <> '1' AND                               BUG22578A BUG23223
     C**********                   PINKG <> '1' AND                               BUG22578A BUG23223
     C**********                   PINKH <> '1'                                   BUG22578A BUG23223
      **********                                                                  BUG22578A BUG23223
     C**********         IF        (WDspScrn1 = 'Y' OR                            BUG22578A BUG23223
     C**********                   WDspScrn2 = 'Y') AND                           BUG22578A BUG23223
     C**********                   Idx = *ZEROS AND                               BUG22578A BUG23223
     C**********                   WUpdFlg = '1'                                  BUG22578A BUG23223
     C**********         EVAL      @SCRN = 'U'                                    BUG22578A BUG23223
     C**********         ENDIF                                                    BUG22578A BUG23223
      **********                                                                   BUG23182 BUG23223
      ***Re*Set*screen*value*when*called*from*Customer*Maintenance                 BUG23182 BUG23223
      **********                                                                   BUG23182 BUG23223
     C**********         IF        SDCUSDcall = 'C'                                BUG23182 BUG23223
     C**********         EVAL      @SCRN = 'S'                                     BUG23182 BUG23223
     C**********         ENDIF                                                     BUG23182 BUG23223
      **********                                                                  BUG22578A BUG23223
     C**********         ENDIF                                                    BUG22578A BUG23223
      *                                                                                    BUG22578A
      ** Set Default flag when called from Customer Maintenace(Insert)                      BUG23223
      *                                                                                     BUG23223
     C                   IF        SDCUSDcall = 'C' AND                                     BUG23223
     C                             DDACTN = 'I'                                             BUG23223
     C                   EVAL      WDefault = 'Y'                                           BUG23223
     C                   ENDIF                                                              BUG23223
      *                                                                                     BUG23223
     C                   ENDSR
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRScrn@D- Process Additional Details Screen 2                *                       CER034
      *                                                               *                       CER034
      *  Called By: MAIN Processing                                   *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRScrn@D      BEGSR                                                                CER034
      *                                                                                       CER034
      ** Set function key status on screen                                                    CER034
      *                                                                                       CER034
     C                   EVAL      @DDACTN = DDACTN                                           CER034
     C                   EVAL      @DDCUST = DDCUST                                           CER034
      **********                                                                   BUG23182 BUG23223
      ***Set*Default*flag*when*called*from*Customer*Maintenace(Insert)             BUG23182 BUG23223
      **********                                                                   BUG23182 BUG23223
     C**********         IF        SDCUSDcall = 'C' AND                            BUG23182 BUG23223
     C**********                   DDACTN = 'I'                                    BUG23182 BUG23223
     C**********         EVAL      WDefault = 'Y'                                  BUG23182 BUG23223
     C**********         ENDIF                                                     BUG23182 BUG23223
      *                                                                                       CER034
      ** Default fields in case of Insert                                                     CER034
      *                                                                                       CER034
     C**********         IF        DDACTN = 'I'                                     CER034 BUG22578A
     C                   IF        WDefault = 'Y'                                          BUG22578A
      *                                                                                       CER034
     C                   IF        DDPIND = *BLANKS AND                                       CER034
     C                             CER048 = 'Y'                                               CER034
     C                   EVAL      DDPIND = 'N'                                               CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   IF        DDS24C = *BLANKS AND                                       CER034
     C                             CER047 = 'Y'                                               CER034
     C                   EVAL      DDS24C = 'N'                                               CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Write/Read Display Screen - Additional Details Screen 2                              CER034
      *                                                                                       CER034
      ** Populate Return Code to display appropriate footer                                   CER034
      *                                                                                       CER034
     C                   EVAL      RetCodeIn = 'SIN'                                          CER034
      *                                                                                       CER034
      ** Default Religious Affiliation to 'None'.                                             CER054
      *                                                                                       CER054
     C                   IF        DDACTN = 'I'                                               CER054
     C                   IF        DDRLAF = *BLANKS AND                                       CER054
     C                             CER054 = 'Y'                                               CER054
     C                   EVAL      DDRLAF = 'None'                                            CER054
     C                   ENDIF                                                                CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   CALLB     'SDACUD3DP'                                                CER034
      *                                                                                       CER034
      ** Input Parameters                                                                     CER034
      *                                                                                       CER034
      ** Return code                                                                          CER034
      *                                                                                       CER034
     C                   PARM                    RetCodeIn                                    CER034
      *                                                                                       CER034
      ** Transaction Details in screen format                                                 CER034
      *                                                                                       CER034
     C                   PARM                    CurTrnDets                                   CER034
      *                                                                                       CER034
      ** Additonal Screen 2 Details in screen format                                          CER034
      *                                                                                       CER034
     C                   PARM                    CurCustDet2                                  CER034
      *                                                                                       CER034
      ** Additonal Screen 2 OK Indicators                                                     CER034
      *                                                                                       CER034
     C                   PARM                    OKCustDet2                                   CER034
      *                                                                                       CER034
      ** Errors                                                                               CER034
      *                                                                                       CER034
     C                   PARM                    FldNameArr                                   CER034
     C                   PARM                    MsgIdArr                                     CER034
     C                   PARM                    MsgDtaArr                                    CER034
      *                                                                                       CER034
      ** Warning                                                                              CER034
      *                                                                                       CER034
     C                   PARM                    WFldNamArr                                   CER034
     C                   PARM                    WMsgIDArr                                    CER034
     C                   PARM                    WMsgDtaArr                                   CER034
      *                                                                                       CER034
      ** Enabled Key & Detail Fields                                                          CER034
      *                                                                                       CER034
     C                   PARM                    PEDTFD                                       CER034
      *                                                                                       CER034
      ** Switchable features                                                                  CER034
      *                                                                                       CER034
     C                   PARM                    CER047                                       CER034
     C                   PARM                    CER048                                       CER034
      *                                                                                       CER034
      ** Output Parameters                                                                    CER034
      *                                                                                       CER034
      ** Function Keys                                                                        CER034
      *                                                                                       CER034
     C                   PARM      '0'           PINKC                                        CER034
     C                   PARM      '0'           PInKH                                        CER034
     C                   PARM      '0'           PINKL                                        CER034
      *                                                                                       CER034
      ** Reset Errors                                                                         CER034
      *                                                                                       CER034
     C                   EVAL      OKCustDet2 = *ALL'Y'                                       CER034
     C                   EVAL      FldNameArr = *BLANKS                                       CER034
     C                   EVAL      MsgIdArr = *BLANKS                                         CER034
     C                   EVAL      MsgDtaArr = *BLANKS                                        CER034
     C                   EVAL      WFldNamArr = *BLANKS                                       CER034
     C                   EVAL      WMsgIDArr = *BLANKS                                        CER034
     C                   EVAL      WMsgDtaArr = *BLANKS                                       CER034
     C                   EVAL      PCallFrom  = '1'                                           CER034
     C                   EVAL      WPrvFlg = *BLANKS                                       BUG22578A
      *                                                                                     BUG24252
      ** Keep State code field value before validation                                      BUG24252
     C                   IF        CER054 = 'Y'                                             BUG24252
     C                   EVAL      WDSTCD = DDSTCD                                          BUG24252
     C                   EVAL      WDRLAF = DDRLAF                                          BUG24252
     C                   ENDIF                                                              BUG24252
      *                                                                                       CER034
      ** F3 - End Program                                                                     CER034
      *                                                                                       CER034
     C     PINKC         CASEQ     '1'           SREndp                                       CER034
      *                                                                                       CER034
      ** F8 - Authority Holders                                                               CER034
     C     PINKH         CASEQ     '1'           SRAuth                                       CER034
      *                                                                                       CER034
      ** F12 - Cancel on Details Screen                                                       CER034
      *                                                                                       CER034
     C     PINKL         CASEQ     '1'           SRCanc@D                                     CER034
      *                                                                                       CER034
      ** Validate Input to Details Screen                                                     CER034
      *                                                                                       CER034
     C                   CAS                     SRVal@D                                      CER034
      *                                                                                       CER034
     C                   ENDCS                                                                CER034
      *                                                                                       CER034
     C                   IF        Idx = *ZEROS AND                                           CER034
     C                             DfltScrn1 = 'N' AND                                      BUG23883
     C                             @SCRN = 'D'                                                CER034
      *                                                                                       CER034
     C                   IF        WDspScrn2 = 'Y' AND                                        CER034
     C                             PINKL = '0'                                                CER034
     C                   IF        CER054 = 'Y'                                             BUG24252
     C                             and %SCAN('?' : DSQUEST) <> 0                            BUG24252
     C                   EVAL      @SCRN = 'D'                                              BUG24252
     C                   ELSE                                                               BUG24252
     C                   EVAL      @SCRN = 'E'                                                CER034
     C                   ENDIF                                                              BUG24252
     C                   ELSEIF    PINKL = '0'                                                CER034
     C                   EVAL      @SCRN = 'S'                                                CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRCanAuth -Cancel on Customer/Authority Holder Details Screen*                       CER034
      *                                                               *                       CER034
      *  Called By: SRScrn@D                                          *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRCanAuth     BEGSR                                                                CER034
      *                                                                                       CER034
      ** Return to calling Screen                                                             CER034
      *                                                                                       CER034
     C                   IF        PCallFrom = '1'                                            CER034
     C                   EVAL      @SCRN = 'D'                                                CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
     C                   EVAL      @SCRN = 'E'                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRAuth - Customer-Authority Holder Details                   *                       CER034
      *                                                               *                       CER034
      *  Called By: SRScrn@D                                          *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRAuth        BEGSR                                                                CER034
      *                                                                                       CER034
      ** Call Customer-Authority Holder Details Screen                                        CER034
      *                                                                                       CER034
     C                   CALLB     'SDCUAHSIN'                                                CER034
      *                                                                                       CER034
      ** Input Parameters                                                                     CER034
      ** Return code                                                                          CER034
     C                   PARM      *BLANKS       RetCodeIn                                    CER034
      *                                                                                       CER034
      ** Customer Number                                                                      CER034
     C                   PARM                    DDACTN                                       CER034
     C                   PARM                    DDCUST                                       CER034
      *                                                                                       CER034
      ** Function Keys                                                                        CER034
     C                   PARM      '0'           PInKC                                        CER034
     C                   PARM      '0'           PInKL                                        CER034
      *                                                                                       CER034
      ** F3 - End Program                                                                     CER034
      *                                                                                       CER034
     C     PInKC         CASEQ     '1'           SREndP                                       CER034
      *                                                                                       CER034
      ** F12 - Cancel on Authority Holder Link Screen                                         CER034
      *                                                                                       CER034
     C     PInKL         CASEQ     '1'           SRCanAuth                                    CER034
      *                                                                                       CER034
     C                   ENDCS                                                                CER034
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRVal@D- Validate Input to Additional Customer Details 2     *                       CER034
      *                                                               *                       CER034
      *  Called By: SRScrn@D                                          *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRVal@D       BEGSR                                                                CER034
      *                                                                                       CER034
      ** If Action Code is Enquire                                                            CER034
      *                                                                                       CER034
     C                   IF        DDACTN = 'E'                                               CER034
      *                                                                                       CER034
     C                   IF        WDspScrn2 = 'Y'                                            CER034
     C                   EVAL      @SCRN = 'E'                                                CER034
     C                   ELSE                                                                 CER034
     C**********         EVAL      @SCRN = 'S'                                      CER034 BUG22578A
     C                   EVAL      @SCRN = 'B'                                             BUG22578A
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   LEAVESR                                                           BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** If Action Code is Insert/Amend                                                       CER034
      *                                                                                       CER034
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'                               CER034
      *                                                                                       CER034
      ** Store image of input screen and current number of warnings                           CER034
      *                                                                                       CER034
     C                   EVAL      PrvCustDet2 = CurCustDet2                                  CER034
     C                   Z-ADD     WIdx          PrvN_Warn                                    CER034
      *                                                                                       CER034
      ** Prior to validation, initialize error indicators as 'OK'                             CER034
      *                                                                                       CER034
     C                   EVAL      Idx  = *ZEROS                                              CER034
     C                   EVAL      WIdx = *ZEROS                                              CER034
     C                   MOVE      *ALL'Y'       OKCustDet2                                   CER034
      *                                                                                       CER034
     C                   CALLB     'SDACUD3VL'                                                CER034
      *                                                                                       CER034
      ** Inputs                                                                               CER034
      *                                                                                       CER034
      ** Response Mode                                                                        CER034
      *                                                                                       CER034
     C                   PARM      *BLANKS       RespMode                                     CER034
      *                                                                                       CER034
      ** Current Transaction Screen 2 Details                                                 CER034
      *                                                                                       CER034
     C                   PARM                    CurCustDet2                                  CER034
      *                                                                                       CER034
      ** Customer                                                                             CER034
      *                                                                                       CER034
     C                   PARM                    DDCUST                                       CER034
      *                                                                                       CER034
      ** Joint Account Type                                                                   CER034
      *                                                                                       CER034
     C                   PARM                    @DDJATP                                      CER034
      *                                                                                       CER034
      ***Tax*Identification*Number*************************************              CER043 BUG24346
      ** Identification Type                                                                BUG24346
      *                                                                                       CER034
     C**********         PARM                    @DDTINO                             CER043 BUG24346
     C                   PARM                    @DDIDTP                                    BUG24346
      *                                                                                       CER034
      ** Switchable Features                                                                  CER034
      *                                                                                       CER034
     C                   PARM                    CER047                                       CER034
     C                   PARM                    CER048                                       CER034
     C                   PARM                    CER054                                     BUG24714
      *                                                                                       CER034
      ** Outputs                                                                              CER034
      *                                                                                       CER034
      ** Transaction Details OK Inds                                                          CER034
      *                                                                                       CER034
     C                   PARM                    OKCustDet2                                   CER034
      *                                                                                       CER034
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER034
      *                                                                                       CER034
     C                   PARM                    FldNameArr                                   CER034
     C                   PARM                    MsgIDArr                                     CER034
     C                   PARM                    MsgDtaArr                                    CER034
      *                                                                                       CER034
      ** Array index (3P0) from/to caller                                                     CER034
      *                                                                                       CER034
     C                   PARM                    Idx                                          CER034
      *                                                                                       CER034
      ** Warning fields/message IDs/message data (arrays) from/to                             CER034
      ** caller                                                                               CER034
      *                                                                                       CER034
     C                   PARM                    WFldNamArr                                   CER034
     C                   PARM                    WMsgIDArr                                    CER034
     C                   PARM                    WMsgDtaArr                                   CER034
      *                                                                                       CER034
      ** Array index (3P0) from/to caller                                                     CER034
      *                                                                                       CER034
     C                   PARM                    WIdx                                         CER034
      *                                                                                       CER034
      ** Valid Transaction details layout (DS) from/to caller                                 CER034
      *                                                                                       CER034
     C                   PARM                    NwMnFilFmt                                   CER034
      *                                                                                     BUG23883
      ** Indicator to check if defaulting has occured on this screen                        BUG23883
      *                                                                                     BUG23883
     C                   PARM      'N'           DfltScrn1                                  BUG23883
      *                                                                                       CER034
      ** If errors returned                                                                   CER034
      *                                                                                       CER034
     C                   IF        Idx <> 0                                                   CER034
     C                   LEAVESR                                                              CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** If any screen defaulting or reformatting has occurred in                             CER034
      ** validation or if the number of warnings has changed,                                 CER034
      ** re-display the screen                                                                CER034
      *                                                                                       CER034
     C                   IF        CurCustDet2 <> PrvCustDet2 OR                              CER034
     C                             DfltScrn1 = 'Y' OR                                       BUG23883
     C                             WIdx <> PrvN_Warn                                          CER034
     C                   LEAVESR                                                              CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Clear any warning messages                                                           CER034
      *                                                                                       CER034
     C                   MOVE      *ALL'Y'       OKCustDet2                                   CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Continue to Additional Customer Details Screen - 3                                   CER034
      *                                                                                       CER034
     C                   IF        WDspScrn2 = 'Y'                                            CER034
      *                                                                                       CER034
     C                   EVAL      @SCRN = 'E'                                                CER034
     C                   ELSE                                                                 CER034
     C**********         EVAL      @SCRN = 'S'                                      CER034 BUG22578A
     C                   EVAL      @SCRN = 'U'                                             BUG22578A
     C                   EVAL      WUpdate = 'Y'                                            BUG23223
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRScrn@E- Process Additional Details Screen E                *                       CER034
      *                                                               *                       CER034
      *  Called By: MAIN Processing                                   *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRScrn@E      BEGSR                                                                CER034
      *                                                                                       CER034
      ** Set function key status on screen                                                    CER034
      *                                                                                       CER034
     C                   EVAL      @DDACTN = DDACTN                                           CER034
     C                   EVAL      @DDCUST = DDCUST                                           CER034
      *                                                                                       CER034
      ** Default fields in case of Insert                                                     CER034
      *                                                                                       CER034
     C**********         IF        DDACTN = 'I' AND                                 CER034 BUG22578A
     C**********                   WDspScrn2 = 'Y'                                  CER034 BUG22578A
     C                   IF        WDefault = 'Y'                                          BUG22578A
      *                                                                                       CER034
      ** Default Screen Fields depending on which feature is ON                               CER034
      *                                                                                       CER034
     C                   EXSR      SRDefVal                                                   CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Write/Read Display Screen - Additional Details Screen 3                              CER034
      *                                                                                       CER034
      ** Populate Return Code to display appropriate footer                                   CER034
      *                                                                                       CER034
     C                   EVAL      RetCodeIn = 'SIN'                                          CER034
      *                                                                                       CER034
      * Initialise new fields                                                                 CER045
      *                                                                                       CER045
     C                   IF        CER045 = 'Y' AND                                           CER045
     C                             DDACTN = 'I' AND                                           CER045
     C                             WDspScrn2 = 'Y'                                            CER045
     C                   EVAL      DDBSCC = *BLANKS                                           CER045
     C                   EVAL      DDECAC = *BLANKS                                           CER045
     C                   EVAL      DDBIST = *BLANKS                                           CER045
     C                   EVAL      DDABSK = *BLANKS                                           CER045
     C                   EVAL      DDBEXT = *BLANKS                                           CER045
     C                   EVAL      DDRIGR = *BLANKS                                           CER070
     C                   ENDIF                                                                CER045
      *                                                                                       CER045
     C                   CALLB     'SDACUD4DP'                                                CER034
      *                                                                                       CER034
      ** Input Parameters                                                                     CER034
      *                                                                                       CER034
      ** Return code                                                                          CER034
      *                                                                                       CER034
     C                   PARM                    RetCodeIn                                    CER034
      *                                                                                       CER034
      ** Transaction Details in screen format                                                 CER034
      *                                                                                       CER034
     C                   PARM                    CurTrnDets                                   CER034
      *                                                                                       CER034
      ** Additional Details 3 in screen format                                                CER034
      *                                                                                       CER034
     C                   PARM                    CurCustDet3                                  CER034
      *                                                                                       CER034
      ** Additional Screen 3 OK Indicators                                                    CER034
      *                                                                                       CER034
     C                   PARM                    OKCustDet3                                   CER034
      *                                                                                       CER034
      ** Errors                                                                               CER034
      *                                                                                       CER034
     C                   PARM                    FldNameArr                                   CER034
     C                   PARM                    MsgIdArr                                     CER034
     C                   PARM                    MsgDtaArr                                    CER034
      *                                                                                       CER034
      ** Warning                                                                              CER034
      *                                                                                       CER034
     C                   PARM                    WFldNamArr                                   CER034
     C                   PARM                    WMsgIDArr                                    CER034
     C                   PARM                    WMsgDtaArr                                   CER034
      *                                                                                       CER034
      ** Enabled Key & Detail Fields                                                          CER034
      *                                                                                       CER034
     C                   PARM                    PEDTFD                                       CER034
      *                                                                                       CER034
      ** Switchable features                                                                  CER034
      *                                                                                       CER034
     C                   PARM                    CER034                                       CER034
     C                   PARM                    CER038                                       CER034
     C                   PARM                    CER041                                       CER034
      *                                                                                       CER034
      ** Output Parameters                                                                    CER034
      *                                                                                       CER034
      ** Function Keys                                                                        CER034
      *                                                                                       CER034
     C                   PARM      '0'           PINKC                                        CER034
     C                   PARM      '0'           PINKH                                        CER034
     C                   PARM      '0'           PINKL                                        CER034
      *                                                                                       CER045
      * Pass the value of CER045                                                              CER045
      *                                                                                       CER045
     C                   PARM                    CER045                                       CER045
      *                                                                                       CER034
      ** Reset Errors                                                                         CER034
      *                                                                                       CER034
     C                   MOVE      *ALL'Y'       OKCustDet3                                   CER034
     C                   EVAL      FldNameArr = *BLANKS                                       CER034
     C                   EVAL      MsgIdArr = *BLANKS                                         CER034
     C                   EVAL      MsgDtaArr = *BLANKS                                        CER034
     C                   EVAL      WFldNamArr = *BLANKS                                       CER034
     C                   EVAL      WMsgIDArr = *BLANKS                                        CER034
     C                   EVAL      WMsgDtaArr = *BLANKS                                       CER034
     C                   EVAL      PCallFrom  = '2'                                           CER034
      *                                                                                       CER034
      ** F3 - End Program                                                                     CER034
      *                                                                                       CER034
     C     PINKC         CASEQ     '1'           SREndp                                       CER034
      *                                                                                       CER034
      ** F8 - Customer-Authority Holders                                                      CER034
      *                                                                                       CER034
     C     PINKH         CASEQ     '1'           SRAuth                                       CER034
      *                                                                                       CER034
      ** F12 - Cancel on Details Screen                                                       CER034
      *                                                                                       CER034
     C     PINKL         CASEQ     '1'           SRCanc@E                                     CER034
      *                                                                                       CER034
      ** Validate Input to Details Screen                                                     CER034
      *                                                                                       CER034
     C                   CAS                     SRVal@E                                      CER034
      *                                                                                       CER034
     C                   ENDCS                                                                CER034
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRDefVal - Default values for new Screen 4                   *                       CER034
      *                                                               *                       CER034
      *  Called By: SRScrn@E                                          *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRDefVal      BEGSR                                                                CER034
      *                                                                                       CER034
      ** Default FX Customer, If BLANKS                                                       CER034
      *                                                                                       CER034
     C                   IF        CER034 = 'Y' AND DDFXCU = *BLANKS                          CER034
     C                   EVAL      DDFXCU = 'N'                                               CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Default Staff Member, If BLANKS                                                      CER034
      *                                                                                       CER034
     C                   IF        CER034 = 'Y' AND DDSMBR = *BLANKS                          CER034
     C                   EVAL      DDSMBR = 'N'                                               CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Default Securities Customer, If BLANKS                                               CER034
      *                                                                                       CER034
     C                   IF        CER034 = 'Y' AND DDSECU = *BLANKS                          CER034
     C                   EVAL      DDSECU = 'N'                                               CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Default Language Id, If BLANKS                                                       CER034
      *                                                                                       CER034
     C                   IF        CER038 = 'Y' AND DDLNID = *BLANKS                          CER034
     C                   EVAL      DDLNID = 'GB'                                              CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Default Correspondent Type, If BLANKS                                                CER034
      *                                                                                       CER034
     C                   IF        CER038 = 'Y' AND DDCTYP = *BLANKS                          CER034
     C                   EVAL      DDCTYP = 'DEFAULT'                                         CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Default Zero Confirmation Flag, If BLANKS                                            CER034
      *                                                                                       CER034
     C                   IF        CER041 = 'Y' AND DDZCFG = *BLANKS                          CER034
     C                   EVAL      DDZCFG = 'N'                                               CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRVal@E- Validate Input to Additional Customer Details 4     *                       CER034
      *                                                               *                       CER034
      *  Called By: SRScrn@E                                          *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRVal@E       BEGSR                                                                CER034
      *                                                                                       CER034
      ** If Action Code is Enquire                                                            CER034
      *                                                                                       CER034
     C                   IF        DDACTN = 'E'                                               CER034
     C**********         EVAL      @SCRN = 'S'                                      CER034 BUG22578A
     C                   EVAL      @SCRN = 'B'                                             BUG22578A
     C                   IF        SDCUSDcall = 'C'                                         BUG24208
     C                   EVAL      @SCRN = 'T'                                              BUG24208
     C                   ENDIF                                                              BUG24208
     C                   LEAVESR                                                              CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** If Action Code is Insert/Amend                                                       CER034
      *                                                                                       CER034
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'                               CER034
      *                                                                                       CER034
      ** Store image of input screen and current number of warnings                           CER034
      *                                                                                       CER034
     C                   EVAL      PrvCustDet3 = CurCustDet3                                  CER034
     C                   Z-ADD     WIdx          PrvN_Warn                                    CER034
      *                                                                                       CER034
      ** Prior to validation, initialize error indicators as 'OK'                             CER034
     C                   EVAL      Idx  = *ZEROS                                              CER034
     C                   EVAL      WIdx = *ZEROS                                              CER034
     C                   MOVE      *ALL'Y'       OKCustDet3                                   CER034
      *                                                                                       CER034
      *                                                                                       CER034
      ** Validate New Additional Detail                                                       CER034
     C                   CALLB     'SDACUD4VL'                                                CER034
      *                                                                                       CER034
      ** Inputs                                                                               CER034
      ** Response Mode                                                                        CER034
     C                   PARM      *BLANKS       RespMode                                     CER034
      *                                                                                       CER034
      ** Current Transaction Screen 2 Details                                                 CER034
     C                   PARM                    CurCustDet3                                  CER034
      *                                                                                       CER034
      ** Customer                                                                             CER034
     C                   PARM                    DDCUST                                       CER034
      *                                                                                       CER034
      ** Switchable Features                                                                  CER034
     C                   PARM                    CER034                                       CER034
     C                   PARM                    CER038                                       CER034
     C                   PARM                    CER041                                       CER034
      *                                                                                       CER034
      ** Outputs                                                                              CER034
      ** Transaction Details OK Inds                                                          CER034
     C                   PARM                    OKCustDet3                                   CER034
      *                                                                                       CER034
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER034
     C                   PARM                    FldNameArr                                   CER034
     C                   PARM                    MsgIDArr                                     CER034
     C                   PARM                    MsgDtaArr                                    CER034
      *                                                                                       CER034
      ** Array index (3P0) from/to caller                                                     CER034
     C                   PARM                    Idx                                          CER034
      *                                                                                       CER034
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CER034
      *                                                                                       CER034
     C                   PARM                    WFldNamArr                                   CER034
     C                   PARM                    WMsgIDArr                                    CER034
     C                   PARM                    WMsgDtaArr                                   CER034
      *                                                                                       CER034
      ** Array index (3P0) from/to caller                                                     CER034
     C                   PARM                    WIdx                                         CER034
      *                                                                                       CER034
      ** Valid Transaction details layout (DS) from/to caller                                 CER034
     C                   PARM                    NwMnFilFmt                                   CER034
      *                                                                                       CER045
      * Pass the value of CER045                                                              CER045
      *                                                                                       CER045
     C                   PARM                    CER045                                       CER045
      *                                                                                       CER034
      ** If errors returned                                                                   CER034
      *                                                                                       CER034
     C                   IF        Idx <> 0                                                   CER034
     C                   LEAVESR                                                              CER034
     C**********         ELSE                                                      BUG26637 BUG26711
     C**********         EVAL      @SCRN = 'B'                                     BUG26637 BUG26711
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** If any screen defaulting or reformatting has occurred in                             CER034
      ** validation or if the number of warnings has changed,                                 CER034
      ** re-display the screen                                                                CER034
      *                                                                                       CER034
     C                   IF        CurCustDet3 <> PrvCustDet3 OR                              CER034
     C                             WIdx <> PrvN_Warn                                          CER034
     C                   LEAVESR                                                              CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER045
      * Trigger re-display of the screen showing the description for 'H' value                CER045
      *  (currently it's 'Handwerker' but can be changed since it's a multi-language ready    CER045
      *   text field)                                                                         CER045
      *                                                                                       CER045
     C                   IF        CER045 = 'Y' AND                                           CER045
     C                             OKABSK = 'Y' AND                                           CER045
     C                             DDABSK = 'H'                                               CER045
     C                   EVAL      @SCRN = 'B'                                              BUG26711
     C                   LEAVESR                                                              CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER034
      *                                                                                       CER034
      ** Clear any warning messages                                                           CER034
     C                   MOVE      *ALL'Y'       OKCustDet3                                   CER034
     C                   EVAL      FldNameArr = *BLANKS                                     BUG22667
     C                   EVAL      MsgIdArr = *BLANKS                                       BUG22667
     C                   EVAL      MsgDtaArr = *BLANKS                                      BUG22667
     C                   EVAL      WFldNamArr = *BLANKS                                     BUG22667
     C                   EVAL      WMsgIDArr = *BLANKS                                      BUG22667
     C                   EVAL      WMsgDtaArr = *BLANKS                                     BUG22667
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      *                                                                                       CER034
      ** Continue to Additional Customer Secondary Screen                                     CER034
     C**********         EVAL      @SCRN = 'S'                                      CER034 BUG22578A
     C                   EVAL      @SCRN = 'U'                                             BUG22578A
     C                   EVAL      WUpdate = 'Y'                                            BUG23223
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRCanc@D- Cancel on Additional Customer Details Screen 3     *                       CER034
      *                                                               *                       CER034
      *  Called By: SRScrn@E                                          *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRCanc@D      BEGSR                                                                CER034
      *                                                                                       CER034
      ** Return to Primary Details Screen                                                     CER034
      *                                                                                       CER034
     C**********         EVAL      @SCRN = 'P'                                      CER034 BUG22578A
     C                   IF        (CGL031 = 'Y' AND                                       BUG22578A
     C                             CGL032 = 'Y') AND                                       BUG22578A
     C                             (@DDJATP = 'I' OR                                       BUG22578A
     C                             @DDJATP = 'Y')                                          BUG22578A
     C                   EVAL      @SCRN = 'A'                                             BUG22578A
     C                   ELSE                                                              BUG22578A
     C                   IF        CSD029 = 'Y'                                            BUG22578A
     C                   EVAL      @SCRN = 'S'                                             BUG22578A
     C                   ELSE                                                              BUG22578A
     C                   EVAL      @SCRN = 'P'                                             BUG22578A
     C                   ENDIF                                                             BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   EVAL      WPrvFlg = '1'                                           BUG22578A
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                    BUG22578A
      /EJECT                                                                               BUG22578A
      *****************************************************************                    BUG22578A
      *                                                               *                    BUG22578A
      *  SRCanc@A- Cancel on Additional Customer Details Screen 3     *                    BUG22578A
      *                                                               *                    BUG22578A
      *  Called By: SRScrn@E                                          *                    BUG22578A
      *                                                               *                    BUG22578A
      *  Calls: None                                                  *                    BUG22578A
      *                                                               *                    BUG22578A
      *****************************************************************                    BUG22578A
     C     SRCanc@A      BEGSR                                                             BUG22578A
      *                                                                                    BUG22578A
      ** Return to Primary Details Screen                                                  BUG22578A
      *                                                                                    BUG22578A
     C                   IF        CSD029 = 'Y'                                             BUG23223
     C                   EVAL      @SCRN = 'S'                                              BUG23223
     C                   ELSE                                                               BUG23223
     C                   EVAL      @SCRN = 'P'                                             BUG22578A
     C                   ENDIF                                                              BUG23223
      *                                                                                    BUG22578A
     C                   ENDSR                                                             BUG22578A
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRCanc@E-  Cancel on Additional Customer Details Screen 2    *                       CER034
      *                                                               *                       CER034
      *  Called By: SRScrn@E                                          *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRCanc@E      BEGSR                                                                CER034
      *                                                                                       CER034
      ** Return to Additional Details Screen 2                                                CER034
      *                                                                                       CER034
     C                   IF        WDspScrn1 = 'Y'                                            CER034
     C                   EVAL      @SCRN = 'D'                                                CER034
     C                   ELSE                                                                 CER034
     C**********         EVAL      @SCRN = 'P'                                      CER034 BUG22578A
     C                   EVAL      @SCRN = 'A'                                             BUG22578A
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CSD029
      *                                                               *                       CER034
      *  SRCancAuth - Cancel on Customer-Authority Holder Details     *                       CER034
      *                                                               *                       CER034
      *  Called By: SRCuAuth                                          *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRCancAuth    BEGSR                                                                CER034
      *                                                                                       CER034
      ** Return to Calling Screen                                                             CER034
      *                                                                                       CER034
     C                   IF        PCallFrom = '1'                                            CER034
     C                   EVAL      @SCRN = 'D'                                                CER034
     C                   ELSE                                                                 CER034
     C                   EVAL      @SCRN = 'E'                                                CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                     BUG23223
      *                                                               *                     BUG23223
      *  SRReturn - Return to Additional Customer Details Browse      *                     BUG23223
      *                                                               *                     BUG23223
      *  Called By: SRScrn@E                                          *                     BUG23223
      *                                                               *                     BUG23223
      *  Calls: None                                                  *                     BUG23223
      *                                                               *                     BUG23223
      *****************************************************************                     BUG23223
     C     SRReturn      BEGSR                                                              BUG23223
      *                                                                                     BUG23223
     C                   IF        SDCUSDcall = 'C'                                         BUG23518
     C                   EVAL      @SCRN = 'T'                                              BUG23518
     C                   ELSE                                                               BUG23518
     C                   EVAL      @SCRN = 'R'                                              BUG23223
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23223
     C                   ENDSR                                                              BUG23223
      *****************************************************************                     BUG23223
      /EJECT                                                                                BUG23223
      *****************************************************************                       CSD029
      * SRScrn@s - Process Secondary Detail Screen                                            CSD029
      *****************************************************************                       CSD029
     C     SRScrn@s      BEGSR                                                                CSD029
                                                                                              CSD029
      ** Set function key status on screen                                                    CSD029
                                                                                              CSD029
     C                   EVAL      @DDACTN = DDACTN                                           CSD029
     C                   EVAL      @DDCUST = DDCUST                                           CSD029
                                                                                              CSD029
      ** Write/Read Display Screen - Primary Details                                          CSD029
                                                                                              CSD029
     C                   IF        CSD029 = 'Y'                                              CSW207A
     C                   CALLB     'SDACUD2DP'                                                CSD029
                                                                                              CSD029
      ** Input Parameters :                                                                   CSD029
      ** Return code                                                                          CSD029
     C                   PARM      *Blanks       RetCodeIn                                    CSD029
                                                                                              CSD029
      ** Transaction Details in screen format                                                 CSD029
     C                   PARM                    CurTrnDets                                   CSD029
                                                                                              CSD029
      ** Screen details retrieved from AOSVALPD                                               CSD029
     C                   PARM                    SVALSCRN                                     CSD029
                                                                                              CSD029
      ** Transaction Details OK indicators                                                    CSD029
     C                   PARM                    OKTrnDets                                    CSD029
                                                                                              CSD029
      ** Errors                                                                               CSD029
     C                   PARM                    FldNameArr                                   CSD029
     C                   PARM                    MsgIdArr                                     CSD029
     C                   PARM                    MsgDtaArr                                    CSD029
                                                                                              CSD029
      ** Warning                                                                              CSD029
     C                   PARM                    WFldNamArr                                   CSD029
     C                   PARM                    WMsgIDArr                                    CSD029
     C                   PARM                    WMsgDtaArr                                   CSD029
                                                                                              CSD029
      ** Enabled Key & Detail Fields                                                          CSD029
     C                   PARM                    PEKYFD                                       CSD029
     C                   PARM                    PEDTFD                                       CSD029
     C                   PARM      'Y'           PEINKG                                       CSD029
                                                                                              CSD029
      ** Output Parameters :                                                                  CSD029
      ** Function Keys                                                                        CSD029
     C                   PARM      '0'           PINKC                                        CSD029
     C                   PARM      '0'           PINKL                                        CSD029
     C**********         ENDIF                                                      CSW207A BUG22667
                                                                                              CSD029
      ** Reset Errors                                                                         CSD029
                                                                                              CSD029
     C                   MOVE      *ALL'Y'       OKTrnDets                                    CSD029
     C                   EVAL      FldNameArr = *Blanks                                       CSD029
     C                   EVAL      MsgIdArr   = *Blanks                                       CSD029
     C                   EVAL      MsgDtaArr  = *Blanks                                       CSD029
     C                   EVAL      WFldNamArr = *Blanks                                       CSD029
     C                   EVAL      WMsgIDArr  = *Blanks                                       CSD029
     C                   EVAL      WMsgDtaArr = *Blanks                                       CSD029
                                                                                              CSD029
      ** F3 - End Program                                                                     CSD029
     C     PINKC         CASEQ     '1'           SREndp                                       CSD029
                                                                                              CSD029
      ** F12 - Cancel on Details Screen                                                       CSD029
     C     PINKL         CASEQ     '1'           SRBack1st                                    CSD029
                                                                                              CSD029
      ** Validate Input to Details Screen                                                     CSD029
     C                   CAS                     SRVal@p                                      CSD029
                                                                                              CSD029
     C                   ENDCS                                                                CSD029
      *                                                                                     BUG22667
     C                   ENDIF                                                              BUG22667
      *                                                                                     BUG22667
      ** Set Screen value accordingly                                                       BUG22667
      *                                                                                     BUG22667
     C                   IF        @SCRN = 'S' AND                                          BUG22667
     C                             CSD029 = 'N'                                             BUG22667
      *
     C**********         EVAL      @SCRN = 'U'                                    BUG22667 BUG22578A
     C**********         EVAL      @SCRN = 'A'                                     BUG23182 BUG23223
     C**********         IF        SDCUSDcall = 'C'                                BUG23182 BUG23223
     C                   EVAL      @SCRN = 'U'                                              BUG23182
     C**********         ENDIF                                                     BUG23182 BUG23223
      *                                                                                    BUG22578A
     C                   ENDIF                                                              BUG22667
                                                                                              CSD029
     C     Idx           IFEQ      0                                                          CGL132
     C     @SCRN         ANDEQ     'S'                                                        CGL132
     C     PINKG         ANDEQ     '0'                                                        CGL132
     C     PINKH         ANDEQ     '0'                                                        CGL132
     C                   EVAL      @SCRN = '5'                                                CGL132
     C                   ENDIF
     C                   ENDSR                                                                CSD029
      *****************************************************************                       CSD029
      * SRBack1st - Return to Primary Screen when F12 is pressed                              CSD029
      *****************************************************************                       CSD029
     C     SRBack1st     BEGSR                                                                CSD029
                                                                                              CSD029
     C**********         IF        WDspScrn2 <> 'Y' AND WDspScrn1 <> 'Y'            CER034 BUG22578A
      *                                                                                       CER034
     C                   EVAL      @SCRN = 'P'                                                CSD029
     C**********         ELSEIF    WDspScrn2 = 'Y'                                  CER034 BUG22578A
      *                                                                                       CER034
     C**********         EVAL      @SCRN = 'E'                                      CER034 BUG22578A
     C**********         ELSEIF    WDspScrn1 = 'Y'                                  CER034 BUG22578A
      *                                                                                       CER034
     C**********         EVAL      @SCRN = 'D'                                      CER034 BUG22578A
      *                                                                                       CER034
     C**********         ENDIF                                                      CER034 BUG22578A
                                                                                              CSD029
     C                   ENDSR                                                                CSD029
      *****************************************************************                       CSD029
      /EJECT
      *****************************************************************
      * SRVal@p  - Validate Input to Details Screen
      *****************************************************************
     C     SRVal@p       BEGSR

      ** If customer number is NOT OK
      ** Re-output screen with error message on it

     C                   IF        DDCUSTOK = 'N'
     C                   GOTO      EndSRVal@p
     C                   ENDIF

      ** If Enquire

     C**********         IF        DDACTN = 'E'                                               CSD029
     C                   IF        DDACTN = 'E' AND @SCRN = 'S'                               CSD029

     C                   EVAL      WKCUST = DDCUST
     C                   IF        CGL031 = 'Y' AND CGL032 = 'Y'                              CSW207
     C                   EXSR      SRCallACTX
     C                   ENDIF                                                                CSW207
     C**********         IF        PRDNB = 'Y'                                                CGL132
     C**********         EVAL      @SCRN = 'R'                                                CGL132
     C**********         ELSE                                                                 CGL132
     C**********         EXSR      SRInitial                                                  234647
     C**********         EVAL      @SCRN = 'T'                                         234647 CGL132
     C**********         ENDIF                                                                CGL132
     C                   EVAL      @SCRN = '5'                                                CGL132
      *                                                                                    BUG22578A
      ** Re-set the screen value when LF046 is Active                                      BUG22578A
      *                                                                                    BUG22578A
     C                   IF        PInkl <> '1'                                             BUG23223
      *                                                                                     BUG23223
     C                   IF        WDspScrn1 = 'Y'                                         BUG22578A
     C                   EVAL      @SCRN = 'D'                                             BUG22578A
     C                   ELSEIF    WDspScrn2 = 'Y'                                         BUG22578A
     C                   EVAL      @SCRN = 'E'                                             BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                     BUG23223
     C                   ELSE                                                               BUG23223
      *                                                                                     BUG23223
     C                   IF        CSD029 = 'Y'                                             BUG23223
     C                   EVAL      @SCRN = 'S'                                              BUG23223
     C                   ELSE                                                               BUG23223
     C                   EVAL      @SCRN = 'P'                                              BUG23223
     C                   ENDIF                                                              BUG23223
      *                                                                                     BUG23223
     C                   ENDIF                                                              BUG23223

      ** Initialize error indicators as 'OK'

     C                   EVAL      Idx  = *ZERO
     C                   EVAL      WIdx = *ZERO
     C                   MOVE      *ALL'Y'       OKTrnDets

     C                   GOTO      EndSRVal@p
     C                   ENDIF
                                                                                            BUG22133
      ** If delete                                                                          BUG22133
                                                                                            BUG22133
     C                   IF        DDACTN = 'D'                                             BUG22133
                                                                                            BUG22133
      ** If F10 pressed, goto updates                                                       BUG22133
                                                                                            BUG22133
     C                   IF        PINKJ  = '1'                                             BUG22133
     C                   EVAL      @SCRN = 'U'                                              BUG22133
     C                   ENDIF                                                              BUG22133
     C                   GOTO      ENDSRVal@p                                               BUG22133
     C                   ENDIF                                                              BUG22133
                                                                                            BUG22133
      *                                                                                     BUG23518
      ** If Close / Release Additional Customer                                             BUG23518
      *                                                                                     BUG23518
     C                   IF        DDACTN = 'C' OR DDACTN = 'R'                             BUG23518
      *                                                                                     BUG23518
      ** If F22 pressed, goto Updates                                                       BUG23518
      *                                                                                     BUG23518
     C                   IF        PINKW  = '1'                                             BUG23518
     C                   EVAL      @SCRN = 'U'                                              BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   GOTO      ENDSRVal@p                                               BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518

      ** If Amend / Insert

     C                   IF        DDACTN = 'A' OR DDACTN = 'I'

      ** Validate Transaction Detail

      ** Store image of input screen and current number of warnings

     C                   EVAL      PrvTrnDets = CurTrnDets
     C                   Z-ADD     WIdx          PrvN_Warn

      ** Prior to validation, initialize error indicators as 'OK'

     C                   EVAL      Idx  = *ZERO
     C                   EVAL      WIdx = *ZERO
     C                   MOVE      *ALL'Y'       OKTrnDets

     C                   CALLB     'SDACUDVAL'

      ** Inputs
      ** Response mode
     C                   PARM      *Blanks       RespMode

      ** Transaction Details
     C                   PARM                    CurTrnDets

      ** Switchable feature CGL032
     C                   PARM                    CGL032

      ** Outputs
      ** Transaction Details OK inds
     C                   PARM                    OKTrnDets

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    NwMnFilFmt

      ** If errors returned

     C                   IF        Idx <> 0
     C                   GOTO      EndSRVal@p
     C                   ENDIF

      ** If any screen defaulting or reformatting has occurred in validation
      ** or if the number of warnings has changed, re-display the screen

     C                   IF        CurTrnDets <> PrvTrnDets OR
     C                             WIdx       <> PrvN_Warn
     C                   GOTO      EndSRVal@p
     C                   ENDIF

      ** Clear any warning messages

     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   ENDIF

     C     @SCRN         IFEQ      'S'                                                        CSD029
      *                                                                                    BUG22578A
     C*****CGL031        IFNE      'Y'                                            BUG22578A BUG23223
     C*****CGL032        ANDNE     'Y'                                            BUG22578A BUG23223
     C*****WDspScrn1     ANDNE     'Y'                                            BUG22578A BUG23223
     C*****WDspScrn2     ANDNE     'Y'                                            BUG22578A BUG23223
     C**********         EVAL      @SCRN = 'U'                                                CGL132
     C                   EVAL      @SCRN = '5'                                                CGL132
     C**********         ELSE                                                     BUG22578A BUG23223
     C*****CGL031        IFEQ      'Y'                                            BUG22578A BUG23223
     C*****CGL032        ANDEQ     'Y'                                            BUG22578A BUG23223
     C**********         EVAL      @SCRN = 'A'                                    BUG22578A BUG23223
     C**********         ELSE                                                     BUG22578A BUG23223
     C*****WDspScrn1     IFEQ      'Y'                                            BUG22578A BUG23223
     C**********         EVAL      @SCRN = 'D'                                    BUG22578A BUG23223
     C**********         ELSE                                                     BUG22578A BUG23223
     C*****WDspScrn2     IFEQ      'Y'                                            BUG22578A BUG23223
     C**********         EVAL      @SCRN = 'E'                                    BUG22578A BUG23223
     C**********         ENDIF                                                    BUG22578A BUG23223
     C**********         ENDIF                                                    BUG22578A BUG23223
     C**********         ENDIF                                                    BUG22578A BUG23223
     C**********         ENDIF                                                    BUG22578A BUG23223
      **********                                                                  BUG22578A BUG23223
      ***Re*Set*screen*value*when*called*from*Customer*Maintenance                 BUG23182 BUG23223
      **********                                                                   BUG23182 BUG23223
     C**********         IF        SDCUSDcall = 'C'                                BUG23182 BUG23223
      **********                                                                   BUG23182 BUG23223
     C*****CGL031        IFNE      'Y'                                             BUG23182 BUG23223
     C*****CGL032        ANDNE     'Y'                                             BUG23182 BUG23223
     C*****WDspScrn1     ANDNE     'Y'                                             BUG23182 BUG23223
     C*****WDspScrn2     ANDNE     'Y'                                             BUG23182 BUG23223
     C**********         EVAL      @SCRN = 'U'                                     BUG23182 BUG23223
     C**********         ELSE                                                      BUG23182 BUG23223
     C*****CGL031        IFEQ      'Y'                                             BUG23182 BUG23223
     C*****CGL032        ANDEQ     'Y'                                             BUG23182 BUG23223
     C**********         EVAL      @SCRN = 'A'                                     BUG23182 BUG23223
     C**********         ELSE                                                      BUG23182 BUG23223
     C*****WDspScrn1     IFEQ      'Y'                                             BUG23182 BUG23223
     C**********         EVAL      @SCRN = 'D'                                     BUG23182 BUG23223
     C**********         ELSE                                                      BUG23182 BUG23223
     C*****WDspScrn2     IFEQ      'Y'                                             BUG23182 BUG23223
     C**********         EVAL      @SCRN = 'E'                                     BUG23182 BUG23223
     C**********         ENDIF                                                     BUG23182 BUG23223
     C**********         ENDIF                                                     BUG23182 BUG23223
     C**********         ENDIF                                                     BUG23182 BUG23223
     C**********         ENDIF                                                     BUG23182 BUG23223
      **********                                                                   BUG23182 BUG23223
     C**********         ENDIF                                                     BUG23182 BUG23223
      *                                                                                     BUG23182
     C                   ENDIF                                                                CSD029

     C     EndSRVal@p    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CGL132
      * SRScrn@5 - Process Details Screen 5                                                   CGL132
      *****************************************************************                       CGL132
     C     SRScrn@5      BEGSR                                                                CGL132
                                                                                              CGL132
      ** Set function key status on screen                                                    CGL132
                                                                                              CGL132
     C                   EVAL      @DDACTN = DDACTN                                           CGL132
     C                   EVAL      @DDCUST = DDCUST                                           CGL132
                                                                                              CGL132
      ** Write/Read Display Screen - Primary Details                                          CGL132
                                                                                              CGL132
     C**********         IF        CSD029 = 'Y'                                               CGL132
     C                   CALLB     'SDACUD5DP'                                                CGL132
                                                                                              CGL132
      ** Input Parameters :                                                                   CGL132
      ** Return code                                                                          CGL132
     C                   PARM      *Blanks       RetCodeIn                                    CGL132
                                                                                              CGL132
      ** Transaction Details in screen format                                                 CGL132
     C                   PARM                    CurTrnDets                                   CGL132
                                                                                              CGL132
      ** Transaction Details in screen format                                                 CGL132
     C                   PARM                    CurCustDet5                                  CGL132
                                                                                              CGL132
      ** Transaction Details OK indicators                                                    CGL132
     C                   PARM                    OKCustDets5                                  CGL132
                                                                                              CGL132
      ** Errors                                                                               CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIdArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Warning                                                                              CGL132
     C                   PARM                    WFldNamArr                                   CGL132
     C                   PARM                    WMsgIDArr                                    CGL132
     C                   PARM                    WMsgDtaArr                                   CGL132
                                                                                              CGL132
      ** Enabled Key & Detail Fields                                                          CGL132
     C                   PARM                    PEDTFD                                       CGL132
                                                                                              CGL132
      ** Output Parameters :                                                                  CGL132
      ** Function Keys                                                                        CGL132
     C                   PARM      '0'           PINKC                                        CGL132
     C                   PARM      '0'           PINKG                                        CGL132
     C                   PARM      '0'           PINKH                                        CGL132
     C                   PARM      '0'           PINKL                                        CGL132
                                                                                              CGL132
      ** Reset Errors                                                                         CGL132
     C                   MOVE      *ALL'Y'       OKTrnDets                                    CGL132
     C                   EVAL      FldNameArr = *Blanks                                       CGL132
     C                   EVAL      MsgIdArr   = *Blanks                                       CGL132
     C                   EVAL      MsgDtaArr  = *Blanks                                       CGL132
     C                   EVAL      WFldNamArr = *Blanks                                       CGL132
     C                   EVAL      WMsgIDArr  = *Blanks                                       CGL132
     C                   EVAL      WMsgDtaArr = *Blanks                                       CGL132
                                                                                              CGL132
      ** F3 - End Program                                                                     CGL132
     C     PINKC         CASEQ     '1'           SREndp                                       CGL132
                                                                                              CGL132
      ** F12 - Cancel on Details Screen                                                       CGL132
     C     PINKL         CASEQ     '1'           SRBack1st                                    CGL132
                                                                                              CGL132
      ** Validate Input to Details Screen                                                     CGL132
     C                   CAS                     SRVal@5                                      CGL132
                                                                                              CGL132
     C                   ENDCS                                                                CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SRVal@5  - Validate Input to Details Screen 5                                         CGL132
      *****************************************************************                       CGL132
     C     SRVal@5       BEGSR                                                                CGL132
                                                                                              CGL132
      ** If customer number is NOT OK                                                         CGL132
      ** Re-output screen with error message on it                                            CGL132
                                                                                              CGL132
     C                   IF        DDCUSTOK = 'N'                                             CGL132
     C                   GOTO      EndSRVal@5                                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Initialize error indicators as 'OK'                                                  CGL132
                                                                                              CGL132
     C                   IF        DDACTN = 'E'                                               CGL132
     C                   EVAL      Idx  = *ZERO                                               CGL132
     C                   EVAL      WIdx = *ZERO                                               CGL132
     C                   MOVE      *ALL'Y'       OKCustDets5                                  CGL132
                                                                                              CGL132
     C                   IF        PRDNB = 'Y'                                                CGL132
     C                   EVAL      @SCRN = 'R'                                                CGL132
     C                   ELSE                                                                 CGL132
     C                   EXSR      SRInitial                                                  CGL132
     C                   EVAL      @SCRN = 'T'                                                CGL132
     C                   ENDIF                                                                CGL132
     C                   GOTO      EndSRVal@5                                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If Amend / Insert                                                                    CGL132
                                                                                              CGL132
     C                   IF        DDACTN = 'A' OR DDACTN = 'I'                               CGL132
                                                                                              CGL132
      ** Validate Transaction Detail                                                          CGL132
                                                                                              CGL132
      ** Store image of input screen and current number of warnings                           CGL132
                                                                                              CGL132
     C                   EVAL      PrvCustDet5 = CurCustDet5                                  CGL132
     C                   Z-ADD     WIdx          PrvN_Warn                                    CGL132
                                                                                              CGL132
      ** Prior to validation, initialize error indicators as 'OK'                             CGL132
                                                                                              CGL132
     C                   EVAL      Idx  = *ZERO                                               CGL132
     C                   EVAL      WIdx = *ZERO                                               CGL132
     C                   MOVE      *ALL'Y'       OKTrnDets                                    CGL132
                                                                                              CGL132
     C                   CALLB     'SDACUD5VL'                                                CGL132
                                                                                              CGL132
      ** Inputs                                                                               CGL132
      ** Response mode                                                                        CGL132
     C                   PARM      *Blanks       RespMode                                     CGL132
                                                                                              CGL132
      ** Transaction Details                                                                  CGL132
     C                   PARM                    CurTrnDets                                   CGL132
     C                   PARM                    CurCustDet5                                  CGL132
                                                                                              CGL132
      ** Switchable feature CGL032                                                            CGL132
     C                   PARM                    CGL032                                       CGL132
                                                                                              CGL132
      ** Outputs                                                                              CGL132
      ** Transaction Details OK inds                                                          CGL132
     C                   PARM                    OKCustDets5                                  CGL132
                                                                                              CGL132
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL132
     C                   PARM                    FldNameArr                                   CGL132
     C                   PARM                    MsgIDArr                                     CGL132
     C                   PARM                    MsgDtaArr                                    CGL132
                                                                                              CGL132
      ** Array index (3P0) from/to caller                                                     CGL132
     C                   PARM                    Idx                                          CGL132
                                                                                              CGL132
      ** Valid Transaction details layout (DS) from/to caller                                 CGL132
     C                   PARM                    NwMnFilFmt                                   CGL132
                                                                                              CGL132
      ** If errors returned                                                                   CGL132
                                                                                              CGL132
     C                   IF        Idx <> 0                                                   CGL132
     C                   GOTO      EndSRVal@5                                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If any screen defaulting or reformatting has occurred in validation                  CGL132
      ** or if the number of warnings has changed, re-display the screen                      CGL132
                                                                                              CGL132
     C                   IF        PrvCustDet5 <> CurCustDet5 OR                              CGL132
     C                             WIdx       <> PrvN_Warn                                    CGL132
     C                   GOTO      EndSRVal@5                                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Clear any warning messages                                                           CGL132
                                                                                              CGL132
     C                   MOVE      *ALL'Y'       OKCustDets5                                  CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   EVAL      @SCRN = 'U'                                                CGL132
                                                                                              CGL132
     C     EndSRVal@5    ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      *****************************************************************
      * SRRoll - Roll Backwards & Forwards through Customer File
      *****************************************************************
     C     SRRoll        BEGSR
                                                                                              233468
      ** If action is insert, control return to key screen                                    233468
                                                                                              233468
     C     DDACTN        IFEQ      'I'                                                        233468
     C                   MOVE      'Y'           INSERTENQ                                    233468
     C                   ENDIF                                                                233468

      ** Default action code to enquiry if action insert or not valid

     C                   IF        DDACTN <> 'A' and
     C                             DDACTN <> 'D'
     C                   EVAL      DDACTN = 'E'
     C                   EXSR      SRSfDs@p                                                   233468
     C                   ENDIF

      * Read next or previous record on customer file
      * according to command key taken (F7/PINKG or F8/PINKH)

     C                   IF        PINKG = '1'
     C                   EVAL      PRDFWD = *Blanks
     C                   EVAL      PRDBCK = 'Y'
     C                   ELSE
     C                   EVAL      PRDFWD = 'Y'
     C                   EVAL      PRDBCK = *Blanks
     C                   ENDIF

     C                   CALLB     'SDACUDRED'

      ** Input Parameters :
      ** Return Code
     C                   PARM      *Blanks       RetCodeIn

      ** Action Code
     C                   PARM                    DDACTN

      ** Transaction number pointer
     C                   PARM                    DDCUST

      ** Read Forwards
     C                   PARM                    PRDFWD

      ** Read Backwards
     C                   PARM                    PRDBCK

      ** Output Parameters :
      ** Error message
     C                   PARM      *Blanks       PERRMS

      ** Transaction read
     C                   PARM      *Blanks       PSCRED

      ** If error message returned from read, send it to detail screen

     C                   IF        PERRMS <> *Blanks
     C                   EXSR      SRSndM@p
     C                   GOTO      SRERoll
     C                   ENDIF

      ** If transaction read

     C                   IF        PSCRED <> *Blanks

      ** Retrieve transaction details

     C                   EVAL      DDCUST = PSCRED

     C                   EXSR      SRRtvTrn

      ** Return to previous screen if there is an error on transaction/action
     C                   IF        DDCUSTOK = 'N' or
     C                             DDACTNOK = 'N'
     C                   EVAL      @SCRN = 'B'
     C                   GOTO      SRERoll
     C                   ENDIF

      ** Convert Transaction Detail

     C                   EXSR      SRCvtTrn
     C                   EVAL      NwMnFilFmt = CrMnFilFmt

      ** Put the Transaction Detail on screen

     C                   EVAL      @SCRN = 'P'

     C                   ENDIF

     C     SRERoll       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBldBrw - Build Browse Subfile
      *****************************************************************
     C     SRBldBrw      BEGSR
                                                                                              233468
      ** Set/reset return to key screen from primary details                                  233468
                                                                                              233468
     C                   MOVE      'N'           INSERTENQ                                    233468

      ** Reset Read next browse subfile record
     C                   EVAL      PRDNB = *Blanks

      ** Build Browse subfile
     C                   CALLB     'SDACUDBRW'

      ** Input Parameters :
      ** Return Code
     C                   PARM      *Blanks       RetCodeIn

      ** Action Code
     C                   PARM                    DDACTN

      ** Transaction Detail Reference Pointer
     C                   PARM                    DDCUST

      ** Build Sub-File
     C                   PARM      'Y'           PBDSFL

      ** Read Subfile Record
     C                   PARM      *Blanks       PRDSFL

      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Set to 'Y' to indicate its from SDACUDENQ otherwise from SDACUDSIN
     C                   PARM      *Blanks       PSDACUDENQ

      ** For Multiple Entry
     C                   PARM      *Blanks       PMultEntry

      ** Indicator for second pass of option selected
     C                   PARM      *Blanks       P2Pass

      ** Output Parameters :
      ** Error Message
     C                   PARM      *Blanks       PERRMS

      ** Option Selected
     C                   PARM      *Blanks       POPSEL

      ** Transaction Reference selected
     C                   PARM      *Blanks       PCUSEL

      ** Command Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKI                                        233468


      ** If F3 taken in browse, End Program

     C                   IF        PINKC = '1'
     C                   EXSR      SREndp
     C                   GOTO      EndSRBldBrw
     C                   ENDIF
                                                                                              233468
      ** If F9 selected from browse, go to key screen                                         233468
                                                                                              233468
     C                   IF        PINKI = '1'                                                233468
     C                   EVAL      @SCRN = 'K'                                                233468
     C                   GOTO      EndSRBldBrw                                                233468
     C                   ENDIF                                                                233468

      ** If error message returned from browse, send it to detail screen

     C                   IF        PERRMS <> *Blanks
     C                   EXSR      SRSndM@p
     C                   GOTO      EndSRBldBrw
     C                   ENDIF

      ** Read next browse subfile record

     C                   EVAL      PRDNB = 'Y'
     C                   EVAL      @SCRN = 'R'
     C                   EVAL      WUpdFlg = *BLANKS                                       BUG22578A
     C                   EVAL      WUpdate = 'N'                                            BUG23223

     C     EndSRBldBrw   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdNBrw - Read Next Browse Subfile Record
      *****************************************************************
     C     SRRdNBrw      BEGSR

      ** Read Next Subfile Record

     C                   CALLB     'SDACUDBRW'

      ** Input Parameters :
      ** Return Code
     C                   PARM      *Blanks       RetCodeIn

      ** Action Code
     C                   PARM                    DDACTN

      ** Transaction Detail Reference Pointer
     C                   PARM                    DDCUST

      ** Build Sub-File
     C                   PARM      *Blanks       PBDSFL

      ** Read Subfile Record
     C                   PARM      'Y'           PRDSFL

      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Set to 'Y' to indicate its from SDACUDENQ otherwise from SDACUDSIN
     C                   PARM      *Blanks       PSDACUDENQ

      ** For Multiple Entry
     C                   PARM      *Blanks       PMultEntry

      ** Indicator for second pass of option selected
     C                   PARM      *Blanks       P2Pass

      ** Output Parameters :
      ** Error Message
     C                   PARM      *Blanks       PERRMS

      ** Option Selected
     C                   PARM      *Blanks       POPSEL

      ** Transaction Reference selected
     C                   PARM      *Blanks       PCUSEL

      ** Command Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKI                                        233468


      ** If Transaction read from subfile

     C                   IF        PCUSEL <> *Blanks

      ** Retrieve Transaction Detail

     C                   EVAL      DDACTN = POPSEL
     C                   EVAL      DDCUST = PCUSEL

     C                   EXSR      SRRtvTrn

      ** Stay on browse screen if there is an error on Transaction number

     C                   IF        DDCUSTOK = 'N' or
     C                             DDACTNOK = 'N'
     C                   EVAL      @SCRN = 'B'
     C                   GOTO      EndSRRdNBrw
     C                   ENDIF

      ** Convert Transaction Detail

     C                   EXSR      SRCvtTrn
     C                   EVAL      NwMnFilFmt = CrMnFilFmt

      ** Put Transaction Detail detail screen

     C                   EVAL      @SCRN = 'P'
     C                   EXSR      SRSfDs@p

     C                   ELSE
     C                   EXSR      SRInitial
     C                   ENDIF

     C     EndSRRdNBrw   ENDSR
      *****************************************************************                       233468
      /EJECT                                                                                  233468
      *****************************************************************                       233468
      *  SRScrn@K - Process Key Screen                                                        233468
      *****************************************************************                       233468
     C     SRScrn@K      BEGSR                                                                233468
                                                                                              233468
      ** Set action code                                                                      233468
                                                                                              233468
     C                   MOVE      'I'           @DDACTN                                      233468
     C                   MOVE      'I'           DDACTN                                       233468
     C                   EVAL      WDefault = 'Y'                                          BUG22578A
     C                   EVAL      WUpdFlg = *BLANKS                                       BUG22578A
     C                   EVAL      WUpdate = 'N'                                            BUG23223
                                                                                              233468
      ** Reset Customer Number if there are no errors                                         233468
                                                                                              233468
     C     MsgIdArr(1)   IFEQ      *BLANKS                                                    233468
     C                   MOVE      *BLANKS       @DDCUST                                      233468
     C                   MOVE      *BLANKS       DDCUST                                       233468
     C                   ENDIF                                                                233468
                                                                                              233468
      ** Set F7/F8 called from Insert mode flag                                               233468
                                                                                              233468
     C                   MOVE      'Y'           INSERTENQ                                    233468
                                                                                              233468
      ** Write/Read display screen - Key Details                                              233468
                                                                                              233468
     C                   CALLB     'SDACUD1DP'                                                233468
                                                                                              233468
      ** Input Paramaters :                                                                   233468
                                                                                              233468
      ** Return Code                                                                          233468
      ** Additional Customer Details - Screen Format                                          233468
      ** Fields in Error                                                                      233468
      ** Errors                                                                               233468
      ** Warnings                                                                             233468
      ** Enabled Key Fields                                                                   233468
      ** Enabled Detail Fields                                                                233468
      ** Enabled Function Keys                                                                233468
      ** KG = Command Key 07 = Read Previous                                                  233468
      ** KH = Comannd Key 08 = Read Next                                                      233468
                                                                                              233468
     C                   PARM      *BLANKS       RetCodeOut                                   233468
     C                   PARM                    CurTrnDets                                   233468
     C                   PARM                    OkTrnDets                                    233468
     C                   PARM                    FldNameArr                                   233468
     C                   PARM                    MsgIdArr                                     233468
     C                   PARM                    MsgDtaArr                                    233468
     C                   PARM                    WFldNamArr                                   233468
     C                   PARM                    WMsgIdArr                                    233468
     C                   PARM                    WMsgDtaArr                                   233468
     C                   PARM                    PEKYFD                                       233468
     C                   PARM                    PEDTFD                                       233468
     C                   PARM      'Y'           PEINKG                                       233468
     C                   PARM      'Y'           PEINKH                                       233468
                                                                                              233468
      ** Output Parameters :                                                                  233468
                                                                                              233468
      ** Function Keys                                                                        233468
      ** Write screen with no read indicator                                                  233468
                                                                                              233468
     C                   PARM      *OFF          PINKC                                        233468
     C                   PARM      *OFF          PINKG                                        233468
     C                   PARM      *OFF          PINKH                                        233468
     C                   PARM      *OFF          PINKL                                        233468
     C                   PARM      'N'           WriteOnly                                    233468
                                                                                              233468
      ** Reset Errors                                                                         233468
                                                                                              233468
     C                   MOVE      *ALL'Y'       OkTrnDets                                    233468
     C                   MOVEL     *BLANKS       FldNameArr                                   233468
     C                   MOVEL     *BLANKS       MsgIdArr                                     233468
     C                   MOVEL     *BLANKS       MsgDtaArr                                    233468
     C                   MOVEL     *BLANKS       WFldNamArr                                   233468
     C                   MOVEL     *BLANKS       WMsgIdArr                                    233468
     C                   MOVEL     *BLANKS       WMsgDtaArr                                   233468
                                                                                              233468
     C                   SELECT                                                               233468
                                                                                              233468
      ** F3 - End Program                                                                     233468
                                                                                              233468
     C                   WHEN      PINKC = *ON                                                233468
     C                   EXSR      SREndP                                                     233468
                                                                                              233468
      ** F7 - Roll Backwards                                                                  233468
                                                                                              233468
     C                   WHEN      PINKG = *ON                                                233468
     C                   EXSR      SRRoll                                                     233468
                                                                                              233468
      ** F8 - Roll Forwards                                                                   233468
                                                                                              233468
     C                   WHEN      PINKH = *ON                                                233468
     C                   EXSR      SRRoll                                                     233468
                                                                                              233468
      ** F12 - Cancel on Key Screen                                                           233468
                                                                                              233468
     C                   WHEN      PINKL = *ON                                                233468
     C                   EXSR      SRInitial                                                  233468
                                                                                              233468
      ** Validate input to Key screen                                                         233468
                                                                                              233468
     C                   OTHER                                                                233468
     C                   EXSR      SRVal@K                                                    233468
     C                   ENDSL                                                                233468
                                                                                              233468
     C                   ENDSR                                                                233468
      *****************************************************************                       233468
      /EJECT                                                                                  233468
      *****************************************************************                       233468
      *  SRVal@K  - Validate Input to Key screen                                              233468
      *****************************************************************                       233468
     C     SRVal@K       BEGSR                                                                233468
                                                                                              233468
     C                   EVAL      DDACTN = @DDACTN                                           233468
     C                   EVAL      DDCUST = @DDCUST                                           233468
                                                                                              233468
      ** Retrieve Additional Customer details                                                 233468
                                                                                              233468
     C                   EXSR      SRRtvTrn                                                   233468
                                                                                              233468
      ** If primary fields are NOT OK                                                         233468
      ** Re-output screen with error messages on it                                           233468
                                                                                              233468
     C     DDACTNOK      IFEQ      'N'                                                        233468
     C     DDCUSTOK      OREQ      'N'                                                        233468
     C     CER048        OREQ      'Y'                                                        CER034
     C     DDCUSTOK      ANDEQ     'W'                                                        CER034
     C                   EVAL      OKACTN = DDACTNOK                                          233468
     C                   EVAL      OKCUST = DDCUSTOK                                          233468
     C                   GOTO      EndVAL@K                                                   233468
     C                   ENDIF                                                                233468
                                                                                              233468
      ** Clear any warning messages                                                           233468
                                                                                              233468
     C                   CLEAR                   NwMnFilFmt                                   233468
     C                   CLEAR                   CrMnFilFmt                                   233468
     C                   CLEAR                   CurTrnDets                                   233468
      *                                                                                       CER034
     C                   IF        WDspScrn1 = 'Y' OR WDspScrn2 = 'Y'                         CER034
     C                   CLEAR                   CurCustDet2                                  CER034
     C                   CLEAR                   CurCustDet3                                  CER034
     C                   MOVE      *ALL'Y'       OKCustDet2                                   CER034
     C                   MOVE      *ALL'Y'       OKCustDet3                                   CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   MOVEL     DDCUST        WKCUST                                       233468
     C                   MOVE      *ALL'Y'       OkTrnDets                                    233468
     C                   MOVEL     *BLANKS       WFldNamArr                                   233468
     C                   MOVEL     *BLANKS       WMsgIdArr                                    233468
     C                   MOVEL     *BLANKS       WMsgDtaArr                                   233468
                                                                                              233468
      ** Go to Transaction Detail screen                                                      233468
                                                                                              233468
     C                   MOVEL     'P'           @SCRN                                        233468
     C                   EXSR      SRSfDs@p                                                   233468
                                                                                              233468
     C     EndVAL@K      ENDSR                                                                233468
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdNBrwOpt - Read Next Browse Subfile Record Option
      *****************************************************************
     C     SRRdNBrwOpt   BEGSR

      ** Read Next Subfile Record

     C                   CALLB     'SDACUDBRW'

      ** Input Parameters :
      ** Return Code
     C                   PARM      *Blanks       RetCodeIn
      ** Action Code
     C                   PARM                    DDACTN
      ** Transaction Detail Reference Pointer
     C                   PARM                    DDCUST
      ** Build Sub-File
     C                   PARM      *Blanks       PBDSFL
      ** Read Subfile Record
     C                   PARM      'V'           PRDSFL
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Set to 'Y' to indicate its from SDACUDENQ otherwise from SDACUDSIN
     C                   PARM      'Y'           PSDACUDENQ

      ** For Multiple Entry
     C                   PARM      *Blanks       PMultEntry

      ** Indicator for second pass of option selected
     C                   PARM                    P2Pass

      ** Output Parameters :
      ** Error Message
     C                   PARM      *Blanks       PERRMS
      ** Option Selected
     C                   PARM      *Blanks       POPSEL
      ** Transaction Reference selected
     C                   PARM      *Blanks       PCUSEL
      ** Command Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKI                                        237063

      ** If Transaction read from subfile

     C                   IF        PCUSEL <> *BLANK

      ** Retrieve Transaction Detail

     C                   EVAL      DDACTN = POPSEL
     C                   EVAL      DDCUST = PCUSEL

     C                   EXSR      SRRtvTrn
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvTrn - Retrieve Transaction Detail
      *****************************************************************
     C     SRRtvTrn      BEGSR

      ** Retrieve Transaction Detail

     C                   CALLB     'SDACUDRTV'

      ** INPUTS
      ** Return code
     C                   PARM      *Blanks       RetCodeIn

      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      '      '      ModeofOp

      ** Response mode
     C                   PARM      'S'           RespMode

      ** Action Code
     C                   PARM                    DDACTN

      ** Front Office Transaction ID
     C                   PARM                    C_E5FRNT

      ** (Midas) Transaction number
     C                   PARM                    DDCUST

      ** Set to 'Y' to indicate its from SDACUDENQ otherwise from SDACUDSIN
     C                   PARM      *Blanks       PSDACUDENQ

      ** Outputs
      ** Transaction  Details in File Format
     C                   PARM                    CrMnFilFmt

      ** OK - Action code
     C                   PARM      *Blanks       DDACTNOK

      ** OK - Transaction Number
     C                   PARM      *Blanks       DDCUSTOK

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM      0             Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller                      CER034
     C                   PARM                    WFldNamArr                                   CER034
     C                   PARM                    WMsgIDArr                                    CER034
     C                   PARM                    WMsgDtaArr                                   CER034
      *                                                                                       CER034
      ** Array index (3P0) from/to caller                                                     CER034
     C                   PARM                    WIdx                                         CER034
      *                                                                                       CER034
      *                                                                                     BUG11936
      ** Customer from screen should be blanks, if F3 was pressed on SD0010S                BUG11936
      **   else use the Customer that was selected on SD0010S                               BUG11936
      *                                                                                     BUG11936
     C                   If        DDCUSTOK = 'N'                                           BUG11936
     C                             And DDCUST = '?'                                         BUG11936
     C                   Eval      @DDCUST = *Blanks                                        BUG11936
     C                   Else                                                               BUG11936
     C                   Eval      @DDCUST = DDCUST                                         BUG11936
     C                   EndIf                                                              BUG11936
     C     EndSRRtvTrn   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCvtTrn - Put a Transaction Detail on Screen
      *****************************************************************
     C     SRCvtTrn      BEGSR

      ** Call program to fill screen fields with data from SKTranFlPD

     C                   CALLB     'SDACUDCVT'

      ** Output Parameters
      ** Return Code
     C                   PARM      *Blanks       RetCodeIn

      ** Additional Customer Details File Format
     C                   PARM                    CrMnFilFmt

      ** Output Parameters
      ** Additional Customer Details Screen Format
     C                   PARM                    CurTrnDets
      *                                                                                       CER034
      ** Additional Customer Details Screen 2 and 3 Format                                    CER034
      *                                                                                       CER034
     C                   PARM                    CurCustDet2                                  CER034
     C                   PARM                    CurCustDet3                                  CER034
     C                   PARM                    CurCustDet5                                  CGL132

      ** Reset Country of Tax Flag everytime a new transaction is loaded                      233004
                                                                                              233004
     C                   EVAL      WCCTXok = 'N'                                              233004
                                                                                              233004
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSndM@p - Send a Message to Detial Screen
      *****************************************************************
     C     SRSndM@p      BEGSR

      ** Add error message to array passed to detail screen

     C                   Z-ADD     1             E
     C     *Blanks       LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     PERRMS        MsgIdArr(E)

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSndM@K - Send a message to Key Screen
      *****************************************************************
     C     SRSndM@K      BEGSR

      ** Add error message to array passed to detail screen

     C                   EVAL      E = 1
     C     *Blanks       LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     PERRMS        MsgIdArr(E)

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCanc@p - Cancel on Primary Screen
      *****************************************************************
     C     SRCanc@p      BEGSR

      ** Return to previous screen

     C     INSERTENQ     IFEQ      'Y'                                                        233468
     C                   EVAL      DDACTN = 'I'                                               233468
     C                   EVAL      @SCRN  = 'K'                                               233468
     C                   ELSE                                                                 233468
     C                   EVAL      @SCRN  = 'B'
     C                   ENDIF                                                                233468

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUpdats - Updates
      *****************************************************************
     C     SRUpdats      BEGSR

      *                                                                                     BUG23223
      ** Retrieve the previously inserted record and set the                                BUG23223
      ** Timestamp value accordingly to prevent errors in updation                          BUG23223
      *                                                                                     BUG23223
     C                   EXSR      SRRtvTrn                                                 BUG23223
      *                                                                                     BUG23223
     C                   IF        C_E5TMST <> ACTMST                                       BUG23223
     C                   EVAL      ACTMST = C_E5TMST                                        BUG23223
     C                   ENDIF                                                              BUG23223
      *                                                                                    BUG22578A
      ** Prevent updation of History files if 'first' run                                  BUG22578A
      *                                                                                    BUG22578A
     C                   IF        (WDspScrn1 = 'Y' OR                                     BUG22578A
     C                             WDspScrn2 = 'Y') AND                                    BUG22578A
     C                             WUpdFlg = '1'                                           BUG22578A
     C                   EVAL      PRtcd = '*NOUPD'                                        BUG22578A
      *                                                                                    BUG22578A
      ***Retrieve*the*previously*inserted*record*and*set*the                      BUG22578A BUG23223
      ***Timestamp*value*accordingly*to*prevent*errors*in*updation                BUG22578A BUG23223
      **********                                                                  BUG22578A BUG23223
     C**********         EXSR      SRRtvTrn                                       BUG22578A BUG23223
     C**********         IF        C_E5TMST <> ACTMST                             BUG22578A BUG23223
     C**********         EVAL      ACTMST = C_E5TMST                              BUG22578A BUG23223
     C**********         ENDIF                                                    BUG22578A BUG23223
      *                                                                                    BUG22578A
     C                   ELSE                                                              BUG22578A
     C                   EVAL      PRtcd = *Blanks
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   EVAL      ACTYLC = DDACTN                                        234613

     C                   MOVEL     DDBSCC        ACBSCC                                       CER045
     C                   EVAL      ACECAC = DDECAC                                            CER045
     C                   MOVEL     DDBIST        ACBIST                                       CER045
     C                   EVAL      ACABSK = DDABSK                                            CER045
     C                   EVAL      ACBEXT = DDBEXT                                            CER045
                                                                                              CER045
      ** Additional Customer Details Updates

     C                   CALLB     'SDACUDUPD'
     C**********         PARM      *Blanks       PRtcd                                     BUG22578A
     C                   PARM                    PRtcd                                     BUG22578A
     C                   PARM                    NwMnFilFmt

      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise, commit the updates

     C                   IF        PRtcd <> *Blanks
     C                   ROLBK
     C                   IF        PRtcd <> '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C                   COMMIT
      *                                                                                     BUG23223
     C                   IF        DDACTN = 'I'                                             BUG23223
     C                   EVAL      DDACTN = 'A'                                             BUG23223
     C                   ENDIF                                                              BUG23223
      *                                                                                     BUG23223
     C                   ENDIF

                                                                                              CGL132
     C                   IF        CGL132 = 'Y' AND                                           CGL132
     C                             CGL133 = 'N'                                               CGL132
                                                                                              CGL132
     C                   CALL      'QCMDEXC'                                                  CGL132
     C                   PARM                    ##OV1                                        CGL132
     C                   PARM                    WMsgLen                                      CGL132
                                                                                              CGL132
     C                   CALL      'SD000732'                                                 CGL132
     C                   PARM      *BLANKS       PReturn                                      CGL132
     C                   PARM      ACCUST        PTranID                                      CGL132
     C                   PARM      'C'           PSource                                      CGL132
     C                   PARM      *BLANKS       PClass                                       CGL132
     C                   PARM      *BLANKS       PCLass                                       CGL132
     C                   PARM      ' '           PRepType                                     CGL132
     C                   PARM      'A'           PTMode                                       CGL132
                                                                                              CGL132
     C                   CALL      'QCMDEXC'                                                  CGL132
     C                   PARM                    ##OV2                                        CGL132
     C                   PARM                    WMsgLen                                      CGL132
                                                                                              CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** If update not done due to record being updated by another
      ** workstation send message to screen.

     C
     C                   IF        PRtcd = '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C
     C                   ENDIF

     C**********         IF        ACJATP = 'Y' or ACJATP = 'I'                               233004
     C**********         EVAL      WkCUST = ACCUST                                            233004
     C**********         EXSR      SRCallACTX                                                 233004
     C**********         ENDIF                                                                233004
      *                                                                                    BUG22578A
      ** Skip Processing if the Updates were run for the first time                        BUG22578A
      *                                                                                    BUG22578A
     C                   IF        WUpdFlg <> '1'                                          BUG22578A

      ** If records are still to be read from the subfile, read them

     C                   IF        PRDNB = 'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE

      ** Else, Return to Browse Subfile

     C                   EXSR      SRInitial                                                  CGL132
     C                   EVAL      @SCRN = WSCRN
     C                   ENDIF
                                                                                              233004
     C                   IF        ACJATP = 'Y' And WCCTXok <>  'Y'                           233004
     C                             Or ACJATP = 'I' And WCCTXok <> 'Y'                         233004
     C                             Or ACJATP = 'Y' And WReshow = 'Y'                          235171
     C                             Or ACJATP = 'I' And WReShow = 'Y'                          235171
     C                   EVAL      WReshow = *BLANK                                           235171
     C                   EVAL      WDelete = *BLANK                                           235171
     C                   EVAL      WkCUST = ACCUST                                            233004
     C                   IF        CGL031 = 'Y' AND CGL032 = 'Y'                              CSW207
     C                   EXSR      SRCallACTX                                                 233004
     C                   ENDIF                                                                CSW207
      *                                                                                       235171
     C                   ELSE                                                                 234227
     C                   IF        ACJATP = 'N' and C_E5JATP = 'Y'                            234227
     C                             or ACJATP = 'N' and C_E5JATP = 'I'                         234227
     C                             or WReshow = 'Y'                                           234227
      *                                                                                       235171
      *   If ReShow is *Blank OR If ReShow is 'Y' and 'Joint Account Type ='N' then permit    235171
      *     deletion of Country of Tax details.                                               235171
     C                   IF        WReshow= ' ' OR WReshow= 'N' OR                            235171
     C                             WReshow= 'Y' AND ACJATP = 'N'                              235171
     C                   EVAL      WDelete = 'Y'                                              234227
     C                   EVAL      WDDACTN = DDACTN                                           234227
     C                   EVAL      DDACTN = 'D'                                               234227
      *                                                                                       235171
     C                   ELSE                                                                 235171
      *   If User has amended 'Joint Account Type to be 'Y' or 'I' - do not permit Deletion|  235171
     C                   EVAL      WDelete = 'N'                                              235171
     C                   EVAL      WDDACTN = DDACTN                                           235171
     C                   ENDIF                                                                235171
      *                                                                                       235171
     C                   EVAL      WkCUST = ACCUST                                            234227
     C                   IF        CGL031 = 'Y' AND CGL032 = 'Y'                              CSW207
     C                   EXSR      SRCallACTX                                                 234227
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                234227
     C                   ENDIF                                                                233004
      *                                                                                    BUG22578A
     C                   ENDIF                                                             BUG22578A

     C**********         IF        SDCUSDCall = 'C'                                         BUG23182
     C**********                   And @SCRN <> 'P'                                  233804 BUG23182
     C**********         EVAL      @SCRN = 'T'                                              BUG23182
     C**********         ENDIF                                                              BUG23182
      *                                                                                    BUG22578A
      ** Set Screen fields accordingly if LF046 is ON                                      BUG22578A
      *                                                                                    BUG22578A
     C**********         IF        (WDspScrn1 = 'Y' OR                            BUG22578A BUG23223
     C**********                   WDspScrn2 = 'Y') AND                           BUG22578A BUG23223
     C**********                   WUpdFlg = '1'                                  BUG22578A BUG23223
     C                   IF        WUpdFlg = '1' OR                                         BUG23223
     C                             WUpdate = 'N'                                            BUG23223
      *                                                                                     BUG23223
     C                   IF        DDACTN = 'I' OR DDACTN = 'A' OR                          BUG23518
     C                             DDACTN = 'E'                                             BUG23518
      *                                                                                     BUG23518
     C                   SELECT                                                             BUG23223
      *                                                                                     BUG23223
     C                   WHEN      (CGL031 = 'Y' AND CGL032 = 'Y') AND                      BUG23223
     C                             (@DDJATP = 'I' OR @DDJATP = 'Y')                         BUG23223
     C                   EVAL      @SCRN = 'A'                                              BUG23223
      *                                                                                     BUG23223
     C                   WHEN      WDspScrn1 = 'Y'                                          BUG23223
     C                   EVAL      @SCRN = 'D'                                              BUG23223
      *                                                                                     BUG23223
     C                   WHEN      WDspScrn2 = 'Y'                                          BUG23223
     C                   EVAL      @SCRN = 'E'                                              BUG23223
      *                                                                                     BUG23223
     C                   OTHER                                                              BUG23223
     C                   IF        SDCUSDCall = 'C'                                         BUG23223
     C                   EVAL      @SCRN = 'T'                                              BUG23223
     C                   ELSE                                                               BUG23223
     C                   EVAL      @SCRN = 'R'                                              BUG23223
     C**********         EVAL      @SCRN = 'S'                                    BUG22578A BUG23223
     C**********         EVAL      WUpdFlg = '2'                                  BUG22578A BUG23182
     C                   ENDIF                                                             BUG22578A
      *                                                                                     BUG23182
     C                   ENDSL                                                              BUG23223
      *                                                                                     BUG23223
     C                   ELSE                                                               BUG23223
     C                   EVAL      @SCRN = 'R'                                              BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   ELSE                                                               BUG23518
      *                                                                                     BUG23223
     C                   IF        SDCUSDCall = 'C'                                         BUG23223
     C                   EVAL      @SCRN = 'T'                                              BUG23223
     C                   ELSE                                                               BUG23223
     C                   EVAL      @SCRN = 'R'                                              BUG23223
     C                   ENDIF                                                              BUG23223
      *                                                                                     BUG23223
     C                   ENDIF                                                              BUG23223
     C**********         IF        SDCUSDCall = 'C' AND                            BUG23182 BUG23223
     C**********                   @SCRN <> 'P'                                    BUG23182 BUG23223
      **********                                                                   BUG23182 BUG23223
     C**********         IF        WUpdFlg = '1'                                   BUG23182 BUG23223
     C**********         EVAL      @SCRN = 'A'                                     BUG23182 BUG23223
     C**********         ELSE                                                      BUG23182 BUG23223
     C**********         EVAL      @SCRN = 'T'                                     BUG23182 BUG23223
     C**********         ENDIF                                                     BUG23182 BUG23223
      **********                                                                   BUG23182 BUG23223
     C**********         ENDIF                                                     BUG23182 BUG23223

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREndp - End Program
      *****************************************************************
     C     SREndp        BEGSR
     C                   EVAL      @SCRN = 'T'
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInitial - Go to Initial Screen
      *****************************************************************
     C     SRInitial     BEGSR

      ** Reset Read Next Browse Subfile Record (if active)

     C                   EVAL      PRDNB  = *Blanks
     C                   EVAL      DDCUST = *Blanks
     C                   EVAL      WCCTXok = 'N'                                              CER034
     C                   EVAL      WUpdFlg = *BLANKS                                       BUG22578A

      ** Blank the screens

     C                   EVAL      CurTrnDets = *Blanks

      ** If you wish to go straight to the input screen and not the subfile,
      ** replace the 'B' with a 'K' to specify the key detail screen.
      ** Browse Screen

     C                   IF        SDCUSDcall = 'B'
     C                   EVAL      @SCRN = 'B'
     C                   EVAL      WSCRN = 'B'
     C                   ELSE
     C                   EVAL      @SCRN = 'A'
     C                   EVAL      WSCRN = 'A'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SRCallACTX    BEGSR

     C                   IF        @DDJATP = 'I' OR                                        BUG22578A
     C                             @DDJATP = 'Y'                                           BUG22578A
      *                                                                                    BUG22578A
     C                   EVAL      WKCUST = ACCUST                                            CER034
      *                                                                                       CER034
     C                   CALL      'SDCCTXSIN'
     C**********         PARM                    PRtcd                                        234227
     C                   PARM      *BLANKS       PRtcd                                        234227
     C                   PARM      DDACTN        PAction
     C                   PARM      WKCUST        PCust
      *                                                                                    BUG22578A
      ** F3 = Exit                                                                         BUG22578A
      *                                                                                    BUG22578A
     C                   PARM      '0'           PInKc                                     BUG22578A
      *                                                                                    BUG22578A
      ** F12 = Previous                                                                    BUG22578A
      *                                                                                    BUG22578A
     C                   PARM      '0'           PInKl                                     BUG22578A
      *                                                                                    BUG22578A
      ** F3 - End Program                                                                  BUG22578A
      *                                                                                    BUG22578A
     C*****PInKc         CASEQ     '1'           SREndp                           BUG22578A BUG23223
     C     PInKc         CASEQ     '1'           SRReturn                                   BUG23223
      *                                                                                    BUG22578A
      ** F12 - Cancel                                                                      BUG22578A
      *                                                                                    BUG22578A
     C     PInKl         CASEQ     '1'           SRCanc@A                                  BUG22578A
      *                                                                                    BUG22578A
     C                   ENDCS                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                             BUG22578A
                                                                                              234227
      ** Check return code if need to re-show the Customer Details by                         234227
      ** Country of Tax screen.                                                               234227
                                                                                              234227
     C                   IF        WDelete = 'Y'                                              234227
     C                   EVAL      DDACTN = WDDACTN                                           234227
                                                                                              234227
     C                   IF        PRtcd = '*RESHOW'                                          234227
     C                   EVAL      WReshow = 'Y'                                              234227
     C                   ELSE                                                                 234227
     C                   EVAL      WReshow = 'N'                                              234227
     C                   EVAL      WRun = 'Y'                                                 CER034
     C                   ENDIF                                                                234227
                                                                                              234227
     C**********         ENDIF                                                                CER034
     C                   ELSE                                                                 CER034
     C                   EVAL      WRun = 'Y'                                                 CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
                                                                                              233468
     C                   IF        DDACTN = 'I'                                               233468
     C                   EVAL      DDACTN = 'A'                                               233468
     C                   ENDIF                                                                233468
                                                                                              233004
     C                   IF        PInKl <> '1' AND                                        BUG22578A
     C                             WPrvFlg <> '1'                                          BUG22578A
     C                   EXSR      SRRtvTrn                                                   233004
     C                   EXSR      SRCvtTrn                                                   233004
      *                                                                                       CER034
      ** Prevent override of Valid File if LF046 is ON                                        CER034
      *                                                                                       CER034
     C**********         IF        WDspScrn1 <> 'Y' AND                             CER034 BUG22578A
     C**********                   WDspScrn2 <> 'Y'                                 CER034 BUG22578A
     C                   EVAL      NwMnFilFmt = CrMnFilFmt                                    233004
     C                   ENDIF                                                                CER034
      *                                                                                    BUG22578A
      ** Reset Update Flag if 'Cancel' taken on ACTX Screen                                BUG22578A
      *                                                                                    BUG22578A
     C                   IF        PInKl = '1'                                             BUG22578A
     C                   EVAL      WUpdFlg = *BLANKS                                       BUG22578A
     C                   ENDIF                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   EVAL      WCCTXok = 'Y'                                              233004
                                                                                              233004
      ** Return to Additional Customer Details screen                                         233004

     C**********         EVAL      @SCRN = 'T'                                                233004
     C                   IF        DDACTN = 'D'                                               234613
     C                   EVAL      DDACTN = ' '                                               234613
     C                   EVAL      DDCUST = '     '                                           234613
     C                   MOVE      *ALL'Y'       OKTrnDets                                    234613
     C                   EVAL      FldNameArr = *Blanks                                       234613
     C                   EVAL      MsgIdArr   = *Blanks                                       234613
     C                   EVAL      MsgDtaArr  = *Blanks                                       234613
     C                   EVAL      WFldNamArr = *Blanks                                       234613
     C                   EVAL      WMsgIDArr  = *Blanks                                       234613
     C                   EVAL      WMsgDtaArr = *Blanks                                       234613
     C                   EVAL      @SCRN = 'B'                                                234613
     C                   ELSE                                                                 234613
      *                                                                                       235171
     C**********         IF        WReshow ='N'                                     235171 BUG22578A
     C                   IF        WReshow = 'N' AND                                       BUG22578A
     C                             (PInkc <> '1' AND PInkl <> '1')                         BUG22578A
     C                   Eval      @SCRN = 'R'                                                235171
      *                                                                                       235171
     C**********         Else                                                       235171 BUG22578A
     C**********         EVAL      @SCRN = 'P'                                      233004 BUG22578A
     C                   EndIf                                                                235171
      *                                                                                       CER034
     C**********         IF        WRun = 'Y' AND                                   CER034 BUG22578A
     C**********                   (WDspScrn1 = 'Y' OR WDspScrn2 = 'Y')             CER034 BUG22578A
     C                   IF        WRun = 'Y' AND                                          BUG22578A
     C                             (PInkc <> '1' AND PInkl <> '1')                         BUG22578A
      *                                                                                       CER034
     C                   SELECT                                                            BUG22578A
      *                                                                                    BUG22578A
     C                   WHEN      WDspScrn1 = 'Y'
     C**********         EVAL      @SCRN = 'B'                                      CER034 BUG22578A
     C                   EVAL      @SCRN = 'D'                                             BUG22578A
      *                                                                                       CER034
     C                   WHEN      WDspScrn2 = 'Y'                                         BUG22578A
     C                   EVAL      @SCRN = 'E'                                             BUG22578A
      *                                                                                    BUG22578A
     C                   OTHER                                                             BUG22578A
     C                   IF        SDCUSDcall <> 'C'                                        BUG23182
     C                   EVAL      @SCRN = 'R'                                             BUG22578A
     C                   ELSE                                                               BUG23182
     C                   EVAL      @SCRN = 'T'                                              BUG23182
     C                   ENDIF                                                              BUG23182
      *                                                                                    BUG22578A
     C                   ENDSL                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   ENDIF                                                                CER034
      *                                                                                       235171
     C                   END                                                                  234613

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR

      ** Parameters
     C     *ENTRY        PLIST
      ** Inputs

      ** Customer Number
     C                   PARM                    DDCUST

      ** Action Code
     C                   PARM                    DDACTN

      ** Initialize program name
     C                   EVAL      DBPGM = 'SDACUDSIN'

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRtcd <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if CGL031 is enabled                                                           CSW207
                                                                                              CSW207
     C                   CALL      'AOSARDR0'                                                 CSW207
     C                   PARM      *Blanks       PRtcd                                        CSW207
     C                   PARM      '*VERIFY'     POptn                                        CSW207
     C                   PARM      'CGL031'      PSard                                        CSW207
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   EVAL      CGL031 = 'N'                                               CSW207
                                                                                              CSW207
     C                   IF        PRtcd = *BLANKS                                            CSW207
     C                   EVAL      CGL031 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
                                                                                              CSW207
      ** Handle Database Error.                                                               CSW207
                                                                                              CSW207
     C                   IF        PRtcd <> '*NRF   '                                         CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW207
     C                   EVAL      DBKEY = 'CGL031'                                           CSW207
     C                   EVAL      DBASE = 905                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Check if CGL032 is enabled

     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CGL032'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   EVAL      CGL032 = 'N'

     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CGL032 = 'Y'
     C                   ELSE

      ** Handle Datebase Error.

     C                   IF        PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CGL032'
     C                   EVAL      DBASE = 902
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
                                                                                              CSD029
      ** Check if CSD029 is enabled                                                           CSD029
                                                                                              CSD029
     C                   CALL      'AOSARDR0'                                                 CSD029
     C                   PARM      *Blanks       PRtcd                                        CSD029
     C                   PARM      '*VERIFY'     POptn                                        CSD029
     C                   PARM      'CSD029'      PSard                                        CSD029
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD029
                                                                                              CSD029
     C                   EVAL      CSD029 = 'N'                                               CSD029
                                                                                              CSD029
     C                   IF        PRtcd = *BLANKS                                            CSD029
     C                   EVAL      CSD029 = 'Y'                                               CSD029
                                                                                              CSD029
      ** Check SDSVALPD                                                                       CSD029
                                                                                              CSD029
     C                   CALL      'AOSVALR0'                                                 CSD029
     C                   PARM      *BLANKS       PRtcd                                        CSD029
     C                   PARM      @VAL01        P@OP01                                       CSD029
     C                   PARM      *BLANKS       P@VL01                                       CSD029
     C                   PARM      @VAL02        P@OP02                                       CSD029
     C                   PARM      *BLANKS       P@VL02                                       CSD029
     C                   PARM      @VAL03        P@OP03                                       CSD029
     C                   PARM      *BLANKS       P@VL03                                       CSD029
     C                   PARM      @VAL04        P@OP04                                       CSD029
     C                   PARM      *BLANKS       P@VL04                                       CSD029
     C                   PARM      @VAL05        P@OP05                                       CSD029
     C                   PARM      *BLANKS       P@VL05                                       CSD029
     C                   PARM      @VAL06        P@OP06                                       CSD029
     C                   PARM      *BLANKS       P@VL06                                       CSD029
     C                   PARM      @VAL07        P@OP07                                       CSD029
     C                   PARM      *BLANKS       P@VL07                                       CSD029
     C                   PARM      @VAL08        P@OP08                                       CSD029
     C                   PARM      *BLANKS       P@VL08                                       CSD029
     C                   PARM      @VAL09        P@OP09                                       CSD029
     C                   PARM      *BLANKS       P@VL09                                       CSD029
     C                   PARM      @VAL10        P@OP10                                       CSD029
     C                   PARM      *BLANKS       P@VL10                                       CSD029
     C     PRtcd         IFNE      *BLANKS                                                    CSD029
     C     PRtcd         ANDNE     '*NRF   '                                                  CSD029
     C     *LOCK         IN        LDA                                                        CSD029
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CSD029
     C                   EVAL      DBKEY = 'P@OP01'                                           CSD029
     C                   EVAL      DBASE = 903                                                CSD029
     C                   OUT       LDA                                                        CSD029
     C                   EXSR      *PSSR                                                      CSD029
     C                   ELSE                                                                 CSD029
     C                   MOVEL     P@VL01        DDDS01                                       CSD029
     C                   MOVEL     P@VL02        DDDS02                                       CSD029
     C                   MOVEL     P@VL03        DDDS03                                       CSD029
     C                   MOVEL     P@VL04        DDDS04                                       CSD029
     C                   MOVEL     P@VL05        DDDS05                                       CSD029
     C                   MOVEL     P@VL06        DDDS06                                       CSD029
     C                   MOVEL     P@VL07        DDDS07                                       CSD029
     C                   MOVEL     P@VL08        DDDS08                                       CSD029
     C                   MOVEL     P@VL09        DDDS09                                       CSD029
     C                   MOVEL     P@VL10        DDDS10                                       CSD029
     C                   ENDIF                                                                CSD029
     C                   ELSE                                                                 CSD029
                                                                                              CSD029
      ** Handle Datebase Error.                                                               CSD029
                                                                                              CSD029
     C                   IF        PRtcd <> '*NRF   '                                         CSD029
     C     *LOCK         IN        LDA                                                        CSD029
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD029
     C                   EVAL      DBKEY = 'CSD029'                                           CSD029
     C                   EVAL      DBASE = 904                                                CSD029
     C                   OUT       LDA                                                        CSD029
     C                   EXSR      *PSSR                                                      CSD029
     C                   ENDIF                                                                CSD029
     C                   ENDIF                                                                CSD029
      *                                                                                       CER034
      ** Check if CER034 is enabled                                                           CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER034'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER034 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER034 = 'Y'                                               CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
      ** Handle Datebase Error.                                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd <> '*NRF   '                                         CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER034'                                           CER034
     C                   EVAL      DBASE = 950                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER038 is enabled                                                           CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER038'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER038 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER038 = 'Y'                                               CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
      ** Handle Datebase Error.                                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd <> '*NRF   '                                         CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER038'                                           CER034
     C                   EVAL      DBASE = 951                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER041 is enabled                                                           CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER041'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER041 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER041 = 'Y'                                               CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
      ** Handle Datebase Error.                                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd <> '*NRF   '                                         CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER041'                                           CER034
     C                   EVAL      DBASE = 952                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER047 is enabled                                                           CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER047'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER047 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER047 = 'Y'                                               CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
      ** Handle Datebase Error.                                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd <> '*NRF   '                                         CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER047'                                           CER034
     C                   EVAL      DBASE = 955                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER048 is enabled                                                           CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER048'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER048 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER048 = 'Y'                                               CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
      ** Handle Datebase Error.                                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd <> '*NRF   '                                         CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER048'                                           CER034
     C                   EVAL      DBASE = 956                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER054
      ** Check if CER054 is enabled                                                           CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtcd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'N'                                               CER054
      *                                                                                       CER054
     C                   IF        PRtcd = *BLANKS                                            CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
      ** Handle Datebase Error.                                                               CER054
      *                                                                                       CER054
     C                   IF        PRtcd <> '*NRF   '                                         CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER054
     C                   EVAL      DBKEY = 'CER054'                                           CER054
     C                   EVAL      DBASE = 957                                                CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER045
      ** Check if CER045 is enabled                                                           CER045
      *                                                                                       CER045
     C                   CALL      'AOSARDR0'                                                 CER045
     C                   PARM      *BLANKS       PRtcd                                        CER045
     C                   PARM      '*VERIFY'     POptn                                        CER045
     C                   PARM      'CER045'      PSard                                        CER045
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER045
      *                                                                                       CER045
     C                   EVAL      CER045 = 'N'                                               CER045
      *                                                                                       CER045
     C                   IF        PRtcd = *BLANKS                                            CER045
      *                                                                                       CER045
     C                   EVAL      CER045 = 'Y'                                               CER045
     C                   ELSE                                                                 CER045
      *                                                                                       CER045
      ** Handle Datebase Error.                                                               CER045
      *                                                                                       CER045
     C                   IF        PRtcd <> '*NRF   '                                         CER045
     C     *LOCK         IN        LDA                                                        CER045
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER045
     C                   EVAL      DBKEY = 'CER045'                                           CER045
     C                   EVAL      DBASE = 103                                                CER045
     C                   OUT       LDA                                                        CER045
     C                   EXSR      *PSSR                                                      CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER034
      ** Set up Display Screens Flag                                                          CER034
      *                                                                                       CER034
     C                   IF        CER047 = 'Y' OR CER048 ='Y'                                CER034
     C                   EVAL      WDspScrn1 = 'Y'                                            CER034
     C                   ELSE                                                                 CER034
     C                   EVAL      WDspScrn1 = 'N'                                            CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C**********         IF        CER034 = 'Y' OR CER038 ='Y' OR                      CER034 CER045
     C**********                   CER041 = 'Y'                                        CER034 CER045
     C                   IF        CER034 = 'Y' OR CER038 ='Y' OR                             CER045
     C                             CER041 = 'Y' OR                                            CER045
     C                             CER045 = 'Y'                                               CER045
     C                   EVAL      WDspScrn2 = 'Y'                                            CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   EVAL      WDspScrn2 = 'N'                                            CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034

     C                   IF        DDCUST <> *Blanks and
     C                             DDACTN <> ' '
     C                   EVAL      WSCRN = *Blanks
     C                   EVAL      @SCRN = *Blanks

      ** Clear DS parameter arrays and go to detail screen
     C                   CLEAR                   NwMnFilFmt
     C                   CLEAR                   CrMnFilFmt
     C                   CLEAR                   CurTrnDets
     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   EVAL      SDCUSDcall = 'C'

     C                   ELSE

      ** Go To Initial Screen

     C                   EVAL      SDCUSDcall = 'B'
     C                   EXSR      SRInitial
     C                   ENDIF
      *

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDACUDS009

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
** CTDATA CPY@
(c) Finastra International Limited 2004
