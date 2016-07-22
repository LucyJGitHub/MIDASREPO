     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Details Enquiry')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDACUDENQ - Additional Customer Details Enquiry              *
      *                                                               *
      *  Function:  This is the enquiry function for                  *
      *             SD Additional Customer Details.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CGL132             Date 01May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24013           Date 15May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23518           Date 30Mar09               *
      *                 BUG22672A          Date 02Mar09               *
      *                 BUG22529           Date 10Feb09               *
      *                 BUG22672           Date 07Feb09               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15111           Date 23Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW207             Date 08Jun07               *
      *                 CSD029             Date 22Aug05               *
      *                 233468             Date 12May05               *
      *                 232543             Date 31Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *           (Recompile)                                         *
      *  CER045 - German Features - Reporting Bundesbank              *
      *  BUG24013 - Religious Affiliation Code in SDACUSPD has been   *
      *             deleted. (Recompile)                              *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG22672A - Amend Screen flow for German Taxes               *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  BUG22672 - Parameter mismatch when calling SDACUDDSP         *
      *  CER034 - German Features - New Fields and Enquiries          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15111 - An incorrect error message was displayed          *
      *             during enquiry                                    *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CSD029 - Customer Details Additional Fields                  *
      *  233468 - F9 key on Additional Customer Details Maintenance.  *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
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
      /COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
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

      ** Current Transaction Screen 5 Detail in Screen Format                                 CGL132
     D CurCustDet5   E DS                  EXTNAME(SDACU5DPD)                                 CGL132
     D                                     PREFIX(@)                                          CGL132
                                                                                              CGL132
      ** New Transaction Detail in File Format
     D NwMnFilFmt    E DS                  EXTNAME(SDVACUDPD)

      ** Error indicators
     D OKTrnDets     E DS                  EXTNAME(SDEACUDPD)
     D OKCustDets5   E DS                  EXTNAME(SDEACU5PD)                                 CGL132

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for SAR Detials
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** First DS for Access Programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access progrmas, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

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
      *                                                                                       CER034
      ** SDACU1DPD Additional Customer Details in Screen - 2 format                           CER034
     D CurCustDet2   E DS                  EXTNAME(SDACU3DPD)                                 CER034
      *                                                                                       CER034
      ** SDACU2DPD Additional Customer Details in Screen - 3 format                           CER034
     D CurCustDet3   E DS                  EXTNAME(SDACU4DPD)                                 CER034
      *                                                                                       CER034
      ** Ok indicators for Customer Details in Screen - 2 format                              CER034
     D OKCustDet2    E DS                  EXTNAME(SDEACU3PD)                                 CER034
      *                                                                                       CER034
      ** Ok indicators for Customer Details in Screen - 3 format                              CER034
     D OKCustDet3    E DS                  EXTNAME(SDEACU4PD)                                 CER034
      *                                                                                       CER034
      ** SDCUSTPD Midas SD Customer details in file format                                    CER034
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER034

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

      ** F9 Insert                                                                            233468
     D PINKI           S              1A                                                      233468
                                                                                              233468
      ** F12 Cancel
     D PINKL           S              1A

      ** Option selected
     D POPSEL          S              1A

      ** Read next browse
     D PRDNB           S              1A

      ** Read subfile
     D PRDSFL          S              1A

      ** Screen / function
     D @Scrn           S              1A

      ** Read next browse in key screen query browse subfile
     D KPRDNB          S              1A

      ** Query check in key screen customer number field
     D KEYQUERY        S              1A

      ** Mode of operation
     D MODEOFOP        S              6A

      ** Called from Customer Details or Midas menu
     D BrwQuery        S              1A

      ** Index of errors
     D Idx             S              3P 0

      ** Index of errors
     D WIdx            S              3P 0

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** Parameters for Access Objects
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A                                                      CSD029

      ** Parameters for SDACUDDSP
     D PEKYFD          S              1A
     D PEDTFD          S              1A
     D PEINKG          S              1A
     D SDCUSDcall      S              1A
     D PSDACUDENQ      S              1A
     D PCGL032         S              1A
     D PEPRTD          S              1A
     D PINKJ           S              1A                                                    BUG22672
     D PINKW           S              1A                                                    BUG23518

      ** Parameters for SDACUDBRW
     D PMultEntry      S              1A   INZ

      ** Indicator for second pass for option selected
     D P2Pass          S              1A   INZ

      ** Switchable features CGL032
     D CGL032          S              1A
     D CSD029          S              1A                                                      CSD029
     D CGL031          S              1A                                                      CSW207

      ** Index for error message
     D E               S              3  0

     D PAction         S              1A
     D PCust           S              6A
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
      ** Fields added for CER034                                                              CER034
      *                                                                                       CER034
     D CER034          S              1A                                                      CER034
     D CER038          S              1A                                                      CER034
     D CER041          S              1A                                                      CER034
     D CER047          S              1A                                                      CER034
     D CER048          S              1A                                                      CER034
     D CER045          S              1A                                                      CER045
     D WDspScrn1       S              1A                                                      CER034
     D WDspScrn2       S              1A                                                      CER034
     D WDspCCTX        S              1A                                                      CER034
     D PCallFrom       S              1A                                                      CER034
     D WPrvFlg         S              1A                                                   BUG22672A

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

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Build browse subfile record

     C                   IF        @Scrn = 'B'
     C                   EXSR      SRBldBrw
     C                   ENDIF

      ** Read next browse subfile record

     C                   IF        @Scrn = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF

      ** Do while screen: Transaction Detail Screen

     C                   Z-ADD     *ZERO         WIdx
     C                   DOW       @Scrn = 'P'
     C                   EXSR      SRScrn@p
     C                   ENDDO                                                                CER034
      *                                                                                       CER034
     C**********         IF        WDspScrn1 = 'Y' AND                              CER034 BUG22672A
     C**********                   @Scrn = 'D'                                      CER034 BUG22672A
     C**********         DOW       @Scrn = 'D'                                      CER034 BUG22672A
     C**********         EXSR      SRScrnD                                          CER034 BUG22672A
     C**********         ENDDO                                                      CER034 BUG22672A
     C**********         ENDIF                                                      CER034 BUG22672A
      **********                                                                    CER034 BUG22672A
     C**********         IF        WDspScrn2 = 'Y' AND                              CER034 BUG22672A
     C**********                   @Scrn = 'E'                                      CER034 BUG22672A
     C**********         DOW       @Scrn = 'E'                                      CER034 BUG22672A
     C**********         EXSR      SRScrnE                                          CER034 BUG22672A
     C**********         ENDDO                                                      CER034 BUG22672A
     C**********         ENDIF                                                      CER034 BUG22672A
      *                                                                                       CER034
     C**********         IF        CSD029 = 'Y'                                     CSD029 BUG22672A
     C                   IF        (CSD029 = 'Y' OR                                        BUG22672A
     C                             WPrvFlg = '1') AND @Scrn = 'S'                          BUG22672A
     C                   EXSR      SRScrn2@p                                                  CSD029
     C                   ENDIF                                                                CSD029
     C                   EXSR      SRSfDs@p
     C**********         IF        CSD029 = 'Y' AND @Scrn = 'S'                     CSD029 BUG22672A
     C**********                   OR CSD029 = 'N'                                  CSD029 BUG22672A
      *                                                                                       CER034
     C                   IF        WDspCCTX = 'Y' AND PInkL = '0' AND                         CER034
     C**********                   @Scrn <> 'T'                                     CER034 BUG22672A
     C                             @Scrn <> 'T' OR @Scrn = 'A'                             BUG22672A
      *                                                                                       CER034
     C                   IF        CGL031 = 'Y' AND CGL032 = 'Y'                              CSW207
     C                   EXSR      SRCallACTX
     C**********         EVAL      @Scrn = 'R'                                      CSD029 BUG22672A
     C                   ELSE                                                              BUG22672A
      *                                                                                    BUG22672A
     C                   IF        WDspScrn1 = 'Y'                                         BUG22672A
     C                   EVAL      @SCRN = 'D'                                             BUG22672A
     C                   ELSE                                                              BUG22672A
      *                                                                                    BUG22672A
     C                   IF        WDspScrn2 = 'Y'                                         BUG22672A
     C                   EVAL      @SCRN = 'E'                                             BUG22672A
     C                   ELSE                                                              BUG22672A
      *                                                                                    BUG22672A
     C                   EVAL      @SCRN = 'T'                                             BUG22672A
      *                                                                                    BUG22672A
     C                   ENDIF                                                             BUG22672A
      *                                                                                    BUG22672A
     C                   ENDIF                                                             BUG22672A
     C                   ENDIF                                                                CSW207
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
     C**********         ENDIF                                                      CSD029 BUG22672A
      *                                                                                    BUG22672A
     C                   IF        WDspScrn1 = 'Y' AND                                     BUG22672A
     C                             @Scrn = 'D'                                             BUG22672A
     C                   DOW       @Scrn = 'D'                                             BUG22672A
     C                   EXSR      SRScrnD                                                 BUG22672A
     C                   ENDDO                                                             BUG22672A
     C                   ENDIF                                                             BUG22672A
      *                                                                                    BUG22672A
     C                   IF        WDspScrn2 = 'Y' AND                                     BUG22672A
     C                             @Scrn = 'E'                                             BUG22672A
     C                   DOW       @Scrn = 'E'                                             BUG22672A
     C                   EXSR      SRScrnE                                                 BUG22672A
     C                   ENDDO                                                             BUG22672A
     C                   ENDIF                                                             BUG22672A
      *                                                                                    BUG22672A
     C**********         ENDDO                                                                CER034

      ** Do while screen: Detail Screen 5                                                     CGL132
                                                                                              CGL132
     C                   Z-ADD     *ZERO         WIdx                                         CGL132
     C                   DOW       @SCRN = '5'                                                CGL132
     C                   EXSR      SRScrn@5                                                   CGL132
     C                   EXSR      SRSfDs@p                                                   CGL132
     C                   ENDDO                                                                CGL132
                                                                                              CGL132
      ** Terminate program

     C                   IF        @Scrn = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF

      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSfDs@p - Set Field Status on Detail Screen
      *****************************************************************
     C     SRSfDs@p      BEGSR

      ** Disable fields on detail screen, set PEDTFD = 'N'

     C                   EVAL      PEKYFD = 'N'
     C                   EVAL      PEDTFD = 'N'

     C                   EVAL      PEPRTD  = 'N'
     C                   EVAL      PCGL032 = 'N'

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
      ** Set to 'Y' to indicate its from SDACUDENQ otherwise from SDACUDSIN
     C                   PARM      'Y'           PSDACUDENQ

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
     C                   PARM      'N'           PEINKG

      ** Protected field due to CGL032
     C                   PARM                    PEPRTD

      ** Switchable feature CGL032
     C                   PARM                    PCGL032

      ** Output Parameters :
      ** Function Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKJ                                      BUG22672
     C                   PARM      '0'           PINKW                                      BUG23518

      ** Reset Errors

     C                   MOVE      *ALL'Y'       OKTrnDets
     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIdArr   = *Blanks
     C                   EVAL      MsgDtaArr  = *Blanks
     C                   EVAL      WFldNamArr = *Blanks
     C                   EVAL      WMsgIDArr  = *Blanks
     C                   EVAL      WMsgDtaArr = *Blanks
     C                   EVAL      WDspCCTX = 'Y'                                             CER034


      ** F3 - End Program

     C     PINKC         CASEQ     '1'           SREndp

      ** F12 - Cancel on Details Screen

     C     PINKL         CASEQ     '1'           SRCanc@p

      ** Enter to Details Screen

     C                   CAS                     SRVal@p
     C                   ENDCS

     C                   IF        @Scrn = 'P' and                                            CGL132
     C                             PINKL <> '1' and PINKC <> '1'                              CGL132
     C                   EVAL      @Scrn = '5'                                                CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVal@p  - Validate Input to Details Screen
      *            (Enter is pressed)
      *****************************************************************
     C     SRVal@p       BEGSR

      ** If customer number is NOT OK
      ** Re-output screen with error message on it

     C                   IF        DDCUSTOK = 'N'
     C                   GOTO      EndSRVal@p
     C                   ENDIF

      ** If Enquire

     C                   IF        DDACTN = 'E'
      *                                                                                       CER034
     C                   IF        WDspScrn1 <> 'Y' AND WDspScrn2 <> 'Y'                      CER034

     C                   IF        PRDNB = 'Y'
     C                   EVAL      @Scrn = 'R'
     C                   ELSE
     C                   EXSR      SRInitial
     C                   ENDIF
      *                                                                                    BUG22672A
     C                   IF        CSD029 = 'Y'                                            BUG22672A
     C                   EVAL      @Scrn = 'S'                                             BUG22672A
     C                   ELSEIF    CGL031 = 'Y' AND CGL032 = 'Y'                           BUG22672A
     C                   EVAL      @Scrn = 'A'                                             BUG22672A
     C                   ENDIF                                                             BUG22672A
      *                                                                                       CER034
     C                   ELSEIF    CSD029 = 'Y'                                            BUG22672A
     C                   EVAL      @Scrn = 'S'                                             BUG22672A
      *                                                                                    BUG22672A
     C                   ELSEIF    WDspScrn1 = 'Y'                                            CER034
     C                   EVAL      @Scrn = 'D'                                                CER034
      *                                                                                       CER034
     C                   ELSEIF    WDspScrn2 = 'Y'                                            CER034
     C                   EVAL      @Scrn = 'E'                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                    BUG22672A
      ** Set Display Customer by Country of Tax Flag                                       BUG22672A
      *                                                                                    BUG22672A
     C                   IF        @DDJATP = 'I' OR @DDJATP = 'Y'                          BUG22672A
     C                   EVAL      WDspCCTX = 'Y'                                          BUG22672A
     C                   ELSE                                                              BUG22672A
     C                   EVAL      WDspCCTX = 'N'                                          BUG22672A
     C                   ENDIF                                                             BUG22672A

      ** Initialize error indicators as 'OK'

     C                   EVAL      Idx  = *ZERO
     C                   EVAL      WIdx = *ZERO
     C                   MOVE      *ALL'Y'       OKTrnDets

     C                   ENDIF

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
     C                   IF        @Scrn = '5' and                                            CGL132
     C                             PINKL <> '1' and PINKC <> '1'                              CGL132
     C                   EVAL      @Scrn = 'R'                                                CGL132
     C                   ENDIF                                                                CGL132
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
     C                   GOTO      EndSRVal@5                                                 CGL132
     C                   ENDIF                                                                CGL132
     C                   IF        PRDNB = 'Y'                                                CGL132
     C                   EVAL      @Scrn = 'R'                                                CGL132
     C                   ELSE                                                                 CGL132
     C                   EXSR      SRInitial                                                  CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C     EndSRVal@5    ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      * SRBack1st - Return to Primary Screen when F12 is pressed                              CGL132
      *****************************************************************                       CGL132
     C     SRBack1st     BEGSR                                                                CGL132
     C                   EVAL      @SCRN = 'P'                                                CGL132
     C                   ENDSR                                                                CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************
      * SRBldBrw - Build Browse Subfile
      *****************************************************************
     C     SRBldBrw      BEGSR

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
      ** Set to 'Y' to indicate its from SDACUDENQ
     C                   PARM      'Y'           PSDACUDENQ
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

      ** If error message returned from browse, send it to detail screen

     C                   IF        PERRMS <> *Blanks
     C                   EXSR      SRSndM@p
     C                   GOTO      EndSRBldBrw
     C                   ENDIF

      ** Read next browse subfile record

     C                   EVAL      PRDNB = 'Y'
     C                   EVAL      @Scrn = 'R'

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
      ** Action Code
      ** Transaction Detail Reference Pointer
      ** Build Sub-File
      ** Read Subfile Record
      ** Errors
      ** Set to 'Y' to indicate its from SDACUDENQ
      ** For Multiple Entry
      ** Indicator for second pass of option selected

     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    DDACTN
     C                   PARM                    DDCUST
     C                   PARM      *Blanks       PBDSFL
     C                   PARM      'Y'           PRDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      'Y'           PSDACUDENQ
     C                   PARM      *Blanks       PMultEntry
     C                   PARM      *Blanks       P2Pass

      ** Output Parameters :
      ** Error Message
      ** Option Selected
      ** Transaction Reference selected
      ** Command Keys

     C                   PARM      *Blanks       PERRMS
     C                   PARM      *Blanks       POPSEL
     C                   PARM      *Blanks       PCUSEL
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKI                                        233468

      ** If Transaction read from subfile

     C                   IF        PCUSEL <> *Blanks

      ** Retrieve Transaction Detail

     C                   EVAL      DDACTN = POPSEL
     C                   EVAL      DDCUST = PCUSEL

     C                   IF        DDACTN = 'E'                                             BUG15111
     C                   EXSR      SRRtvTrn
     C                   ELSE                                                               BUG15111
     C                   EVAL      DDACTNOK = 'N'                                           BUG15111
     C                   EVAL      Idx = 1                                                  BUG15111
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'                               BUG15111
     C                   EVAL      MsgIDArr(Idx) = 'SDM0137'                                BUG15111
     C                   ENDIF                                                              BUG15111

      ** Stay on browse screen if there is an error on Transaction number

     C                   IF        DDCUSTOK = 'N' or
     C                             DDACTNOK = 'N'
     C                   EVAL      @Scrn = 'B'
     C                   GOTO      EndSRRdNBrw
     C                   ENDIF

      ** Convert Transaction Detail

     C                   EXSR      SRCvtTrn
     C                   EVAL      NwMnFilFmt = CrMnFilFmt

      ** Put Transaction Detail screen

     C                   EVAL      @Scrn = 'P'
     C                   EXSR      SRSfDs@p

     C                   ELSE
     C                   EXSR      SRInitial
     C                   ENDIF

     C     EndSRRdNBrw   ENDSR
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
      ** Mode
      ** Response mode
      ** Action Code
      ** Front Office Transaction ID
      ** (Midas) Transaction number
      ** Set to 'Y' to indicate its from SDACUDENQ

     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      '      '      ModeofOp
     C                   PARM      'S'           RespMode
     C                   PARM                    DDACTN
     C                   PARM                    C_E5FRNT
     C                   PARM                    DDCUST
     C                   PARM      'Y'           PSDACUDENQ

      ** Outputs
      ** Transaction  Details in File Format
      ** OK - Action code
      ** OK - Transaction Number
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    CrMnFilFmt
     C                   PARM      *Blanks       DDACTNOK
     C                   PARM      *Blanks       DDCUSTOK
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM      0             Idx
      *                                                                                       CER034
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CER034
      *                                                                                       CER034
     C                   PARM                    WFldNamArr                                   CER034
     C                   PARM                    WMsgIDArr                                    CER034
     C                   PARM                    WMsgDtaArr                                   CER034
      *                                                                                       CER034
      ** Array index (3P0) from/to caller                                                     CER034
      *                                                                                       CER034
     C                   PARM                    WIdx                                         CER034
      *                                                                                       CER034

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCvtTrn - Put a Transaction Detail on Screen
      *****************************************************************
     C     SRCvtTrn      BEGSR

      ** Call program to fill screen fields with data from SKTranFlPD

     C                   CALLB     'SDACUDCVT'

      ** Input Parameters:
      ** Return Code
      ** Additional Customer Details File Format

     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    CrMnFilFmt

      ** Output Parameters:
      ** Additional Customer Details Screen Format
     C                   PARM                    CurTrnDets
      *                                                                                       CER034
      ** Additional Customer Details Screen 2 and 3 Format                                    CER034
      *                                                                                       CER034
     C                   PARM                    CurCustDet2                                  CER034
     C                   PARM                    CurCustDet3                                  CER034
     C                   PARM                    CurCustDet5                                  CGL132

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSndM@p - Send a Message to Detail Screen
      *****************************************************************
     C     SRSndM@p      BEGSR

      ** Add error message to array passed to detail screen

     C                   EVAL      E = 1
     C     *Blanks       LOOKUP    FldNameArr(E)                          99
     C                   EVAL      FldNameArr(E) = '*ANY'
     C                   EVAL      MsgIdArr(E)   = PERRMS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCanc@p - Cancel on Primary Screen
      *****************************************************************
     C     SRCanc@p      BEGSR
     C                   EVAL      @Scrn = 'B'
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCallACTX - Call Additional Customer Details by Country     *
      *               of Tax                                          *
      *****************************************************************
     C     SRCallACTX    BEGSR

     C                   IF        @DDJATP = 'I' OR                                        BUG22672A
     C                             @DDJATP = 'Y'                                           BUG22672A
      *                                                                                    BUG22672A
     C**********         EVAL      WDspCCTX = 'N'                                   CER034 BUG22672A
      *                                                                                       CER034
     C                   CALL      'SDCCTXSIN'
     C                   PARM                    PRtcd
     C                   PARM      DDACTN        PAction
     C                   PARM      DDCUST        PCust
      *                                                                                    BUG22672A
      ** F3 = Exit                                                                         BUG22672A
      *                                                                                    BUG22672A
     C                   PARM      '0'           PInKc                                     BUG22672A
      *                                                                                    BUG22672A
      ** F12 = Previous                                                                    BUG22672A
      *                                                                                    BUG22672A
     C                   PARM      '0'           PInKl                                     BUG22672A
      *                                                                                    BUG22672A
      ** F3 - End Program                                                                  BUG22672A
      *                                                                                    BUG22672A
     C     PInKc         CASEQ     '1'           SREndp                                    BUG22672A
      *                                                                                    BUG22672A
      ** F12 - Cancel                                                                      BUG22672A
      *                                                                                    BUG22672A
     C     PInKl         CASEQ     '1'           SRCanc@A                                  BUG22672A
      *                                                                                    BUG22672A
      ** Other                                                                             BUG22672A
      *                                                                                    BUG22672A
     C                   CAS                     SRVal@A                                   BUG22672A
      *                                                                                    BUG22672A
     C                   ENDCS                                                             BUG22672A
      *                                                                                    BUG22672A
     C                   ENDIF                                                             BUG22672A

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREndp - End Program
      *****************************************************************
     C     SREndp        BEGSR
     C                   EVAL      @Scrn = 'T'
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInitial - Go to Intial Screen
      *****************************************************************
     C     SRInitial     BEGSR

      ** Reset Read Next Browse Subfile Record (if active)

     C                   EVAL      PRDNB  = *Blanks
     C                   EVAL      DDCUST = *Blanks

      ** Blank the screens

     C                   EVAL      CurTrnDets = *Blanks

      ** If you wish to go straight to the input screen and not the subfile,
      ** replace the 'B' with a 'K' to specify the key detail screen.
      ** Browse Screen

     C                   IF        SDCUSDcall = 'B'
     C                   EVAL      @Scrn = 'B'
     C                   ELSE
     C                   EVAL      @Scrn = 'T'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSD029
      *****************************************************************                       CSD029
      *  SRScrn2@p                                                    *                       CSD029
      *****************************************************************                       CSD029
     C     SRScrn2@P     BEGSR                                                                CSD029
                                                                                              CSD029
     C                   CALLB     'SDACUD2DP'                                                CSD029
                                                                                              CSD029
      ** INPUT PARAMETERS :                                                                   CSD029
      ** Return code                                                                          CSD029
     C                   PARM                    RetCodeIn                                    CSD029
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
     C                   PARM                    PEINKG                                       CSD029
                                                                                              CSD029
      ** OUTPUT PARAMETERS :                                                                  CSD029
      ** Function Keys                                                                        CSD029
     C                   PARM                    PINKC                                        CSD029
     C                   PARM                    PINKL                                        CSD029
                                                                                              CSD029
     C                   SELECT                                                               CSD029
     C                   WHEN      PINKC = '1'                                                CSD029
     C                   EVAL      @Scrn = 'T'                                                CSD029
                                                                                              CSD029
     C                   WHEN      PINKL = '1'                                                CSD029
      *                                                                                       CER034
     C**********         IF        WDspScrn1 <> 'Y' AND                             CER034 BUG22672A
     C**********                   WDspScrn2 <> 'Y'                                 CER034 BUG22672A
      *                                                                                       CER034
     C                   EVAL      @Scrn = 'P'                                                CSD029
      **********                                                                    CER034 BUG22672A
     C**********         ELSEIF    WDspScrn2 = 'Y'                                  CER034 BUG22672A
     C**********         EVAL      @SCRN = 'E'                                      CER034 BUG22672A
      **********                                                                    CER034 BUG22672A
     C**********         ELSEIF    WDspScrn1 = 'Y'                                  CER034 BUG22672A
     C**********         EVAL      @SCRN = 'D'                                      CER034 BUG22672A
      **********                                                                    CER034 BUG22672A
     C**********         ENDIF                                                      CER034 BUG22672A
                                                                                              CSD029
     C                   OTHER                                                                CSD029
     C                   IF        WDspCCTX = 'Y'                                          BUG22672A
     C**********         EVAL      @Scrn = 'S'                                      CSD029 BUG22672A
     C                   EVAL      @SCRN = 'A'                                             BUG22672A
     C                   ELSE                                                              BUG22672A
     C                   IF        WDspScrn1 = 'Y'                                         BUG22672A
     C                   EVAL      @SCRN = 'D'                                             BUG22672A
     C                   ELSE                                                              BUG22672A
     C                   IF        WDspScrn2 = 'Y'                                         BUG22672A
     C                   EVAL      @SCRN = 'E'                                             BUG22672A
     C                   ELSE                                                              BUG22672A
     C                   EVAL      @SCRN = 'R'                                             BUG22672A
     C                   ENDIF                                                             BUG22672A
     C                   ENDIF                                                             BUG22672A
     C                   ENDIF                                                             BUG22672A
      *                                                                                    BUG22672A
     C                   ENDSL                                                                CSD029
                                                                                              CSD029
     C                   ENDSR                                                                CSD029
      *****************************************************************                       CSD029
      /EJECT
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRScrnD - Process Detail Screen 2                            *                       CER034
      *                                                               *                       CER034
      *  Called By: MAIN Processing                                   *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRScrnD       BEGSR                                                                CER034
      *                                                                                       CER034
      ** Write/Read Display Screen - Customer Details Screen 2                                CER034
      *                                                                                       CER034
     C                   CALLB     'SDACUD3DP'                                                CER034
      *                                                                                       CER034
      ** Input Parameters                                                                     CER034
      *                                                                                       CER034
      ** Return code                                                                          CER034
      *                                                                                       CER034
     C                   PARM      'SIN'         RetCodeIn                                    CER034
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
     C                   PARM      '0'           PINKH                                        CER034
     C                   PARM      '0'           PINKL                                        CER034
      *                                                                                       CER034
      ** Reset Errors                                                                         CER034
      *                                                                                       CER034
     C                   MOVE      *ALL'Y'       OKCustDet2                                   CER034
     C                   EVAL      FldNameArr = *BLANKS                                       CER034
     C                   EVAL      MsgIdArr = *BLANKS                                         CER034
     C                   EVAL      MsgDtaArr = *BLANKS                                        CER034
     C                   EVAL      WFldNamArr = *BLANKS                                       CER034
     C                   EVAL      WMsgIDArr = *BLANKS                                        CER034
     C                   EVAL      WMsgDtaArr = *BLANKS                                       CER034
     C                   EVAL      PCallFrom  = '1'                                           CER034
     C                   EVAL      WPrvFlg = *BLANKS                                       BUG22672A
      *                                                                                       CER034
      ** F3 - Client Details                                                                  CER034
      *                                                                                       CER034
     C     PINKC         CASEQ     '1'           SREndp                                       CER034
      *                                                                                       CER034
      ** F12 - Cancel on Details Screen                                                       CER034
      *                                                                                       CER034
     C     PINKL         CASEQ     '1'           SRCancD                                      CER034
      *                                                                                       CER034
      ** F8 - Authority Holders                                                               CER034
      *                                                                                       CER034
     C     PINKH         CASEQ     '1'           SRAuth                                       CER034
      *                                                                                       CER034
      ** Validate Additional Details Screen 2                                                 CER034
      *                                                                                       CER034
     C                   CAS                     SRValD                                       CER034
      *                                                                                       CER034
     C                   ENDCS                                                                CER034
      *                                                                                       CER034
     C                   IF        Idx = *ZEROS AND                                           CER034
     C                             @SCRN = 'D'                                                CER034
      *                                                                                       CER034
     C                   IF        WDspScrn2 = 'Y' AND                                        CER034
     C                             PInkL = '0'                                                CER034
     C                   EVAL      @SCRN = 'E'                                                CER034
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
      *  SRScrnE - Process Detail Screen 3                            *                       CER034
      *                                                               *                       CER034
      *  Called By: MAIN Processing                                   *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRScrnE       BEGSR                                                                CER034
      *                                                                                       CER034
      ** Write/Read Display Screen - Customer Details Screen 3                                CER034
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
     C                   PARM      'SIN'         RetCodeIn                                    CER034
      *                                                                                       CER034
      ** Current Transaction  Detail in Screen Format                                         CER034
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
      ** F3 - Client Details                                                                  CER034
      *                                                                                       CER034
     C     PINKC         CASEQ     '1'           SREndp                                       CER034
      *                                                                                       CER034
      ** F12 - Cancel on Details Screen                                                       CER034
      *                                                                                       CER034
     C     PINKL         CASEQ     '1'           SRCancE                                      CER034
      *                                                                                       CER034
      ** F8 - Authority Holders                                                               CER034
      *                                                                                       CER034
     C     PINKH         CASEQ     '1'           SRAuth                                       CER034
      *                                                                                       CER034
      ** Validate Additional Details Screen 3                                                 CER034
      *                                                                                       CER034
     C                   CAS                     SRValE                                       CER034
      *                                                                                       CER034
     C                   ENDCS                                                                CER034
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRValD - Validate Input to Additional Customer Details       *                       CER034
      *           Screen 2                                            *                       CER034
      *                                                               *                       CER034
      *  Called By: MAIN Processing                                   *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRValD        BEGSR                                                                CER034
      *                                                                                       CER034
     C                   IF        WDspScrn2 <> 'Y'                                           CER034
     C**********         EVAL      @SCRN = 'S'                                      CER034 BUG22672A
     C                   EVAL      @SCRN = 'R'                                             BUG22672A
     C                   ELSE                                                                 CER034
     C                   EVAL      @SCRN = 'E'                                                CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRValE - Validate Input to Additional Customer Details       *                       CER034
      *           Screen 2                                            *                       CER034
      *                                                               *                       CER034
      *  Called By: MAIN Processing                                   *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRValE        BEGSR                                                                CER034
      *                                                                                       CER034
     C**********         EVAL      @SCRN = 'S'                                      CER034 BUG22672A
     C                   EVAL      @SCRN = 'R'                                             BUG22672A
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRAuth - Customer-Authority Holder Details                   *                       CER034
      *                                                               *                       CER034
      *  Called By: SRScrnD, SRScrnE                                  *                       CER034
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
      *                                                                                       CER034
      ** Return code                                                                          CER034
      *                                                                                       CER034
     C                   PARM      *BLANKS       RetCodeIn                                    CER034
      *                                                                                       CER034
      ** Customer Number                                                                      CER034
      *                                                                                       CER034
     C                   PARM                    DDACTN                                       CER034
     C                   PARM                    DDCUST                                       CER034
      *                                                                                       CER034
      ** Function Keys                                                                        CER034
      *                                                                                       CER034
     C                   PARM                    PInKC                                        CER034
     C                   PARM                    PInKL                                        CER034
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
      *  SRCanAuth - Cancel on Customer/Authority Holder Details      *                       CER034
      *                                                               *                       CER034
      *  Called By: SRScrnD, SRScrnE                                  *                       CER034
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
      *  SRCancD - Cancel on Additional Customer Details Screen 2     *                       CER034
      *                                                               *                       CER034
      *  Called By: SRScrnD                                           *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRCancD       BEGSR                                                                CER034
      *                                                                                       CER034
      ** Return to Primary Details Screen                                                     CER034
      *                                                                                       CER034
     C**********         EVAL      @SCRN = 'P'                                      CER034 BUG22672A
     C                   IF        (CGL031 = 'Y' AND                                       BUG22672A
     C                             CGL032 = 'Y') AND                                       BUG22672A
     C                             (@DDJATP = 'I' OR                                       BUG22672A
     C                             @DDJATP = 'Y')                                          BUG22672A
     C                   EVAL      @SCRN = 'A'                                             BUG22672A
     C                   ELSE                                                              BUG22672A
     C                   IF        CSD029 = 'Y'                                            BUG22672A
     C                   EVAL      @SCRN = 'S'                                             BUG22672A
     C                   EVAL      WPrvFlg = '1'                                           BUG22672A
     C                   ELSE                                                              BUG22672A
     C                   EVAL      @SCRN = 'P'                                             BUG22672A
     C                   ENDIF                                                             BUG22672A
     C                   ENDIF                                                             BUG22672A
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                       CER034
      *                                                               *                       CER034
      *  SRCancE - Cancel on Additional Customer Details Screen 3     *                       CER034
      *                                                               *                       CER034
      *  Called By: SRScrnE                                           *                       CER034
      *                                                               *                       CER034
      *  Calls: None                                                  *                       CER034
      *                                                               *                       CER034
      *****************************************************************                       CER034
     C     SRCancE       BEGSR                                                                CER034
      *                                                                                       CER034
      ** Return to Additional Details Screen 2                                                CER034
      *                                                                                       CER034
     C                   IF        WDspScrn1 = 'Y'                                            CER034
     C                   EVAL      @SCRN = 'D'                                                CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
     C**********         EVAL      @SCRN = 'P'                                      CER034 BUG22672A
     C                   EVAL      @SCRN = 'A'                                             BUG22672A
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDSR                                                                CER034
      *****************************************************************                       CER034
      /EJECT                                                                                  CER034
      *****************************************************************                    BUG22672A
      *                                                               *                    BUG22672A
      *  SRCanc@A - Cancel on Additional Customer Details Screen 3    *                    BUG22672A
      *                                                               *                    BUG22672A
      *  Called By: SRScrnE                                           *                    BUG22672A
      *                                                               *                    BUG22672A
      *  Calls: None                                                  *                    BUG22672A
      *                                                               *                    BUG22672A
      *****************************************************************                    BUG22672A
     C     SRCanc@A      BEGSR                                                             BUG22672A
      *                                                                                    BUG22672A
      ** Return to Primary Details / Secondary Screen                                      BUG22672A
      *                                                                                    BUG22672A
     C                   IF        CSD029 = 'Y'                                            BUG22672A
     C                   EVAL      @SCRN = 'S'                                             BUG22672A
     C                   EVAL      WPrvFlg = '1'                                           BUG22672A
     C                   ELSE                                                              BUG22672A
     C                   EVAL      @SCRN = 'P'                                             BUG22672A
     C                   ENDIF                                                             BUG22672A
      *                                                                                    BUG22672A
     C                   ENDSR                                                             BUG22672A
      *****************************************************************                    BUG22672A
      /EJECT                                                                               BUG22672A
      *****************************************************************                    BUG22672A
      *                                                               *                    BUG22672A
      *  SRVal@A - Process Screen flow                                *                    BUG22672A
      *                                                               *                    BUG22672A
      *  Called By: SRCallACTX                                        *                    BUG22672A
      *                                                               *                    BUG22672A
      *  Calls: None                                                  *                    BUG22672A
      *                                                               *                    BUG22672A
      *****************************************************************                    BUG22672A
     C     SRVal@A       BEGSR                                                             BUG22672A
      *                                                                                    BUG22672A
      ** Set appropriate screen value                                                      BUG22672A
      *                                                                                    BUG22672A
     C                   IF        WDspScrn1 <> 'Y' AND                                    BUG22672A
     C                             WDspScrn2 <> 'Y'                                        BUG22672A
     C                   EVAL      @SCRN = 'R'                                             BUG22672A
     C                   ELSEIF    WDspScrn1 = 'Y'                                         BUG22672A
     C                   EVAL      @SCRN = 'D'                                             BUG22672A
     C                   ELSEIF    WDspScrn2 = 'Y'                                         BUG22672A
     C                   EVAL      @SCRN = 'E'                                             BUG22672A
     C                   ENDIF                                                             BUG22672A
      *                                                                                    BUG22672A
     C                   ENDSR                                                             BUG22672A
      *****************************************************************                    BUG22672A
      /EJECT                                                                               BUG22672A
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

     C                   EVAL      DBPGM = 'SDACUDENQ'

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
                                                                                              CSD029
      ** Check if CSD029 is installed                                                         CSD029
                                                                                              CSD029
     C                   CALL      'AOSARDR0'                                                 CSD029
     C                   PARM      *BLANKS       PRtcd                                        CSD029
     C                   PARM      '*VERIFY '    POptn                                        CSD029
     C                   PARM      'CSD029'      PSarD                                        CSD029
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD029
                                                                                              CSD029
     C                   IF        PRtcd = *Blanks                                            CSD029
     C                   EVAL      CSD029 = 'Y'                                               CSD029
     C                   ELSE                                                                 CSD029
     C                   EVAL      CSD029 = 'N'                                               CSD029
     C                   IF        PRtcd <> '*NRF   '                                         CSD029
     C     *LOCK         IN        LDA                                                        CSD029
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD029
     C                   EVAL      DBKEY = 'CSD029'                                           CSD029
     C                   EVAL      DBASE = 902                                                CSD029
     C                   OUT       LDA                                                        CSD029
     C                   EXSR      *PSSR                                                      CSD029
     C                   ENDIF                                                                CSD029
     C                   ENDIF                                                                CSD029
                                                                                              CSD029
     C                   IF        CSD029 = 'Y'                                               CSD029
                                                                                              CSD029
     C                   CALL      'AOSVALR0'                                                 CSD029
     C                   PARM      *BLANKS       PRtcd             7                          CSD029
     C                   PARM      @VAL01        P@OP01           20                          CSD029
     C                   PARM      *BLANKS       P@VL01          200                          CSD029
     C                   PARM      @VAL02        P@OP02           20                          CSD029
     C                   PARM      *BLANKS       P@VL02          200                          CSD029
     C                   PARM      @VAL03        P@OP03           20                          CSD029
     C                   PARM      *BLANKS       P@VL03          200                          CSD029
     C                   PARM      @VAL04        P@OP04           20                          CSD029
     C                   PARM      *BLANKS       P@VL04          200                          CSD029
     C                   PARM      @VAL05        P@OP05           20                          CSD029
     C                   PARM      *BLANKS       P@VL05          200                          CSD029
     C                   PARM      @VAL06        P@OP06           20                          CSD029
     C                   PARM      *BLANKS       P@VL06          200                          CSD029
     C                   PARM      @VAL07        P@OP07           20                          CSD029
     C                   PARM      *BLANKS       P@VL07          200                          CSD029
     C                   PARM      @VAL08        P@OP08           20                          CSD029
     C                   PARM      *BLANKS       P@VL08          200                          CSD029
     C                   PARM      @VAL09        P@OP09           20                          CSD029
     C                   PARM      *BLANKS       P@VL09          200                          CSD029
     C                   PARM      @VAL10        P@OP10           20                          CSD029
     C                   PARM      *BLANKS       P@VL10          200                          CSD029
                                                                                              CSD029
     C                   IF        PRtcd <> *Blanks  AND                                      CSD029
     C                             PRtcd <> '*NRF   '                                         CSD029
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
                                                                                              CSD029
     C                   ENDIF                                                                CSD029

      ** Check if CGL031 is installed                                                         CSW207
     C                   CALL      'AOSARDR0'                                                 CSW207
     C                   PARM      *BLANKS       PRtcd                                        CSW207
     C                   PARM      '*VERIFY '    POptn                                        CSW207
     C                   PARM      'CGL031'      PSarD                                        CSW207
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtcd = *Blanks                                            CSW207
     C                   EVAL      CGL031 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CGL031 = 'N'                                               CSW207
     C                   IF        PRtcd <> '*NRF   '                                         CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW207
     C                   EVAL      DBKEY = 'CGL031'                                           CSW207
     C                   EVAL      DBASE = 904                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Check if CGL032 is installed                                                         CSW207
     C                   CALL      'AOSARDR0'                                                 CSW207
     C                   PARM      *BLANKS       PRtcd                                        CSW207
     C                   PARM      '*VERIFY '    POptn                                        CSW207
     C                   PARM      'CGL032'      PSarD                                        CSW207
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtcd = *Blanks                                            CSW207
     C                   EVAL      CGL032 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CGL032 = 'N'                                               CSW207
     C                   IF        PRtcd <> '*NRF   '                                         CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW207
     C                   EVAL      DBKEY = 'CGL032'                                           CSW207
     C                   EVAL      DBASE = 905                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Go To Initial Screen

     C                   EVAL      SDCUSDcall = 'B'
     C                   EXSR      SRInitial
      *                                                                                       CER034
      ** Check if CER034 is installed                                                         CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY '    POptn                                        CER034
     C                   PARM      'CER034'      PSarD                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER034 = 'Y'                                               CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   EVAL      CER034 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd <> '*NRF   '                                         CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER034'                                           CER034
     C                   EVAL      DBASE = 906                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER038 is installed                                                         CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY '    POptn                                        CER034
     C                   PARM      'CER038'      PSarD                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER038 = 'Y'                                               CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   EVAL      CER038 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd <> '*NRF   '                                         CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER038'                                           CER034
     C                   EVAL      DBASE = 907                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER041 is installed                                                         CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY '    POptn                                        CER034
     C                   PARM      'CER041'      PSarD                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER041 = 'Y'                                               CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   EVAL      CER041 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd <> '*NRF   '                                         CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER041'                                           CER034
     C                   EVAL      DBASE = 908                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER047 is installed                                                         CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY '    POptn                                        CER034
     C                   PARM      'CER047'      PSarD                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER047 = 'Y'                                               CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   EVAL      CER047 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd <> '*NRF   '                                         CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER047'                                           CER034
     C                   EVAL      DBASE = 911                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER048 is installed                                                         CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY '    POptn                                        CER034
     C                   PARM      'CER048'      PSarD                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER048 = 'Y'                                               CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   EVAL      CER048 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd <> '*NRF   '                                         CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER048'                                           CER034
     C                   EVAL      DBASE = 912                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER045
      ** Check if CER045 is installed                                                         CER045
      *                                                                                       CER045
     C                   CALL      'AOSARDR0'                                                 CER045
     C                   PARM      *BLANKS       PRtcd                                        CER045
     C                   PARM      '*VERIFY '    POptn                                        CER045
     C                   PARM      'CER045'      PSarD                                        CER045
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER045
      *                                                                                       CER045
     C                   IF        PRtcd = *BLANKS                                            CER045
      *                                                                                       CER045
     C                   EVAL      CER045 = 'Y'                                               CER045
     C                   ELSE                                                                 CER045
      *                                                                                       CER045
     C                   EVAL      CER045 = 'N'                                               CER045
      *                                                                                       CER045
     C                   IF        PRtcd <> '*NRF   '                                         CER045
      *                                                                                       CER045
     C     *LOCK         IN        LDA                                                        CER045
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER045
     C                   EVAL      DBKEY = 'CER045'                                           CER045
     C                   EVAL      DBASE = 103                                                CER045
     C                   OUT       LDA                                                        CER045
     C                   EXSR      *PSSR                                                      CER045
      *                                                                                       CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER034
      ** Set Validate Flags                                                                   CER034
      *                                                                                       CER034
     C                   IF        CER047 = 'Y' OR CER048 = 'Y'                               CER034
      *                                                                                       CER034
     C                   EVAL      WDspScrn1 = 'Y'                                            CER034
     C                   ELSE                                                                 CER034
     C                   EVAL      WDspScrn1 = 'N'                                            CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C**********         IF        CER034 = 'Y' OR                                     CER034 CER045
     C**********                   CER038 = 'Y' OR                                     CER034 CER045
     C**********                   CER041 = 'Y'                                        CER034 CER045
     C                   IF        CER034 = 'Y' OR                                            CER045
     C                             CER038 = 'Y' OR                                            CER045
     C                             CER041 = 'Y' OR                                            CER045
     C                             CER045 = 'Y'                                               CER045
      *                                                                                       CER034
     C                   EVAL      WDspScrn2 = 'Y'                                            CER034
     C                   ELSE                                                                 CER034
     C                   EVAL      WDspScrn2 = 'N'                                            CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034

      ** Hook to enable non-core initial processing to be included

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
(c) Misys International Banking Systems Ltd. 2004
