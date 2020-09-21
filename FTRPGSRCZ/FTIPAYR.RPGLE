     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT IPAY Retrieve a record')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYR   - FT Transaction type retrieve a record            *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD052870           Date 27Feb19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD044395           Date 08Mar17               *
      *                 MD039986           Date 10Aug16               *
      *                 AR1090283          Date 10Aug16               *
      *                 CFT157             Date 29Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255522             Date 18Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CER001             Date 25Apr05               *
      *                 BUG7029            Date 09Jun05               *
      *                 BUG4196            Date 09Sep04               *
      *                 CFT115             Date 01Jul04               *
      *                 BG1768             Date 30Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 05Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD052870 - Recompiled due to changes made by MD-50928 in     *
      *             FTIPY5PD.                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044395 - Incorrect Customer Name on Inputs details for     *
      *             valid BIC entry                                   *
      *  MD039986 - Additional codes to upgrade AR1090283.            *
      *  AR1090283 - Customer details not visible for enquire.        *
      *              (Child: AR1090284)                               *
      *            - Applied for MD-39986.                            *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *           (Recompile)                                         *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255522 - Properly populate SWIFT Reference and display it in *
      *           JAVA screen.                                        *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BUG4196- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time.      *
      *  CFT115 - Core changes for GBO015.                            *
      *         - Incoming Payments Beneficiary Validation            *
      *         - Upgrade to Midasplus                                *
      *  BG1768 - Correction to *entry Parameters                     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Thin Client API Wrappers                            *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------

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

      ** Current transaction in screen format
     D CurTrIPY1     E DS                  EXTNAME(FTIPY1PD)
     D CurTrIP1A     E DS                  EXTNAME(FTIPY1APD)
     D CurTrIPY2     E DS                  EXTNAME(FTIPY2PD)
     D CurTrIPY3     E DS                  EXTNAME(FTIPY3PD)
     D CurTrIPY4     E DS                  EXTNAME(FTIPY4PD)
     D CurTrIP4A     E DS                  EXTNAME(FTIPY4APD)
     D CurTrIPY5     E DS                  EXTNAME(FTIPY5PD)
     D CurTrIPY6     E DS                  EXTNAME(FTIPY6PD)
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 from file - screen format                             CSW209
     D CurTrIPY7     E DS                  EXTNAME(FTIPY7PD)                                  CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 from file - screen format                             CSW209
     D CurTrIPY8     E DS                  EXTNAME(FTIPY8PD)                                  CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 9 from file - screen format                             CER049
     D CurTrIPY9     E DS                  EXTNAME(FTIPY9PD)                                  CER049
      *                                                                                       CER049
     D CurTrIPY6A    E DS                  EXTNAME(FTIPY6APD)                                 CER030
     D ExtData       E DS                  EXTNAME(FTIPEXPD)
     D OKTrIPY1      E DS                  EXTNAME(FTEIPY1PD)

      ** Valid file layout
     D IPAYFilFmt    E DS                  EXTNAME(INPAYDD)
     D IPY2FilFmt    E DS                  EXTNAME(INPAYXPD)
                                                                                              CER001
      ** Externally described DS for IBLC Incoming Payments                                   CER001
     D IPAYExFilFmt  E DS                  EXTNAME(FTIPX1PD)                                  CER001
     D                                     PREFIX(CR)                                         CER001
                                                                                              CER001
     D RegData       E DS                  EXTNAME(FTIPRXPD)                                  CER001
     D                                     PREFIX(CR)                                         CER001

      ** DS for Additional Info details
     D PAddInfm        DS           196

      ** DS for Default Charge Amounts
     D PCharges        DS           196

      ** DS for Default Charge Currencies
     D PChgCcy         DS            48

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Externally described DS for General Ledger ICD details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Externally described DS for Midas Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** Externally described DS for Funds Transfer ICD details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)

      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)

      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16

      ** FT Control Data
     D PCNTRL          DS           256
     D  PGLUI                  4      4
     D  PVATT                  6      6

      ** DS for VAT details
     D PVATDS          DS
     D  PVATR                 10     12P 4

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0 INZ(*ZERO)

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(*ZERO)

      ** Entry parameters
     D Buffer          S           6000A
     D FwdBck          S              1A
     D DDPREF_In       S             15A
     D APIRetc         S              1A

      ** SARs
     D S01494          S              1A
     D S01499          S              1A
     D S01506          S              1A
     D S01508          S              1A
     D CFT003          S              1A
     D CFT004          S              1A
     D CFT014          S              1A
     D CFT009          S              1A
     D CFT010          S              1A
     D CEU006          S              1A
     D CGL009          S              1A

      ** Work variables
     D DDACTN_In       S              1A                                                      BG1768
     D PRtCd           S              7A   INZ(*BLANK)
     D POptn           S              7A   INZ(*BLANK)
     D PSard           S              7A   INZ(*BLANK)
     D PCurr           S              3A
     D ULX043          S              1A   INZ(*BLANKS)                                       CER001
     D PParmLEVEL      S              1A   INZ('1')
     D PLinkPgm        S             10A   INZ(*BLANKS)
     D PErrMs          S              7A   INZ(*BLANKS)
     D PPRefSel        S             15A   INZ(*BLANKS)
     D Ex              S              3P 0 INZ(*ZERO)
     D PResponse       S              1A   INZ('S')
     D PFTOV           S              1A
     D PRdBck          S              1A
     D PRdFwd          S              1A
     D PPRefInsert     S              1A
     D PMode           S              6A
     D PStatus         S             10A
     D PPYTP           S              2A
     D PICcy           S              3A
     D PIInCy          S              1A
     D PINbdp          S              1P 0
     D PITPSD          S              5P 0
     D POCcy           S              3A
     D POInCy          S              1A
     D PONbdp          S              1P 0
     D FOTrId          S             20A

     D PPrvCDRT        S              1A   INZ(*BLANKS)
     D*PPrvCDRO*       S             12A   INZ(*BLANKS)                                       CGL029
     D PPrvCDRO        S             18A   INZ(*BLANKS)                                       CGL029
     D PPrvCDBR        S              3A   INZ(*BLANKS)
     D PReCalc         S              1A   INZ('N')
     D PPYBR           S              3A
     D PBCDP           S              1P 0
     D PLCDP           S              1P 0
     D PLMDIn          S              1P 0
     D PLSpot          S             13P 8
     D GBO015          S             21    INZ('')                                            CFT115
                                                                                              CER001
     D PRetCodeIn      S             10                                                       CER001
     D PActn           S              1                                                       CER001
     D PFrontID        S             20                                                       CER001
     D PPayRef         S             15                                                       CER001
     D CER001          S              1                                                       CER001
                                                                                              CER001
     D PPRVCDRC        S              3A                                                      CFT120
     D CFT120          S              1A                                                      CFT120
                                                                                              CFT120
      ** Field (1000A) to receive the incoming Customer Name                                  CSF011
     D WNumDetlIn      S           1000A                                                      CSF011
                                                                                              CSF011
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CSF011
     D                                     PREFIX(AC_)                                        CSF011
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CSF011
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSF011
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CSF011
     D CusIdx          S              4S 0 INZ(1)                                             CSF011
     D CusIdx2         S              4S 0 INZ(1)                                             CSF011
     D AccLength       S              2S 0 INZ(72)                                            CSF011
     D ACusLngth       S              2S 0 INZ(52)                                            CSF011
     D NoOfCusField    S              2S 0 INZ(10)                                            CSF011
     D CusOrAcc        C                   CONST('AAAAABABBA')                                CSF011
     D W@Len           S              2S 0                                                    CSF011
     D P@TYP           S             10                                                       CSF011
     D P@Str           S             35                                                       CSF011
     D WNStr           S             35                                                       CSF011
     D P0RETL          S             10                                                       CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D W@Abc           S              1                                                       CSF011
     D W@CCY           S              3                                                       CSF011
     D W@BRC           S              3                                                       CSF011
     D AAuth           S              1                                                     MD039986
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
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029

     C                   MOVEL     DDACTN_In     DDACTN                                       BG1768

      ** If the action code is blank, set to enquire
     C                   IF        DDACTN = *BLANK
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF

     C                   SELECT
     C                   WHEN      FwdBck = 'F'
     C                   MOVEL     'Y'           PRdFwd
     C                   MOVEL     'N'           PRdBck

     C                   WHEN      FwdBck = 'B'
     C                   MOVEL     'N'           PRdFwd
     C                   MOVEL     'Y'           PRdBck

     C                   OTHER
     C                   MOVEL     'N'           PRdFwd
     C                   MOVEL     'N'           PRdBck
     C                   ENDSL

      ** Read incoming payment record using payment reference
     C                   IF        PRdFwd = 'Y' OR
     C                             PRdBck = 'Y'
     C                   EXSR      ReadIPAY
     C                   ELSE
     C                   MOVEL     DDPREF_In     PPRefSel
     C                   ENDIF

      ** Display error message if problems found when reading the
      ** incoming payment
     C                   IF        PErrMS <> *BLANKS
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      SRSndM
     C                   ENDIF

      ** Otherwise, if no error message returned then retrieve
      ** and convert record from file to screen format
     C                   IF        PErrMS = *BLANKS AND
     C                             PPRefSel <> *BLANKS

     C                   EXSR      RetrieveIPAY

     C                   IF        Idx = 0
     C                   EXSR      ConvertIPAY

      ** Do defaulting of Charges and Commission details
     C                   IF        CFT009 = 'N'
     C                   EXSR      SRCCVatL1
     C                   EXSR      SRCDefault
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Set up default charges and currencies in CurTrIPY6
     C**********         EVAL      %SUBST(CurTrIPY6:11) = PCharges                            255522
     C                   EVAL      %SUBST(CurTrIPY6:11:196) = PCharges                        255522
     C                   EVAL      WPICCY = PICCY
     C                   EVAL      WPOCCY = POCCY
                                                                                              CSF011
      ** Populate Account Details                                                             CSF011
     C                   EXSR      SrCustActN                                                 CSF011
                                                                                              CSF011

      ** Build buffer with required output
     C                   MOVE      TMST          @TimeStamp       26                         BUG4196
     C                   MOVE      *BLANKS       @NewButton        3                          CER049
     C                   EVAL      Buffer = CurTrIPY1 + CurTrIP1A +
     C                                      CurTrIPY2 + CurTrIPY3 +
     C                                      CurTrIPY4 + CurTrIP4A +
     C                                      CurTrIPY5 + CurTrIPY6 +
     C                                           GBO015 +                                     CFT115
     C                                      CurTrIPY7 + CurTrIPY8 +                           CSW209
     C                                      CurTrIPY6A +                                      CER030
     C                                      @TimeStamp +                                     BUG4196
     C                                      @NewButton +                                      CER049
     C                                      CurTrIPY9  +                                      CER049
     C                                      AAuth +                                         MD039986
     C                                      BtnPressed +                                    MD039986
     C                                      RegData    +                                      CER001
     C                                      ExtData

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCCVatL1 - Compute Charges and Commissions, and Total VAT   *
      *              Amounts based on Level 1 Details                 *
      *                                                               *
      *****************************************************************
      *
     C     SRCCVatL1     BEGSR

      ** Set up payment branch
      ** If single branch mode, use single branch code from SDBANKPD

     C                   IF        BGMBIN <> 'Y'
     C                   MOVE      BJSBRC        PPYBR
     C                   ELSE

      ** Multibrached, take originating branch if used otherwise
      ** take Booking Branch

     C                   IF        BKOBRU = 'Y'
     C                   MOVE      DDORBR        PPYBR
     C                   ELSE
     C                   MOVE      DDBRCA        PPYBR
     C                   ENDIF

     C                   ENDIF

     C                   CALLB     'FTIPAY1CH'
      *                             =========
      ** INPUT
      ** =====

      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    CurTrIPY1

      ** Incoming Payments retrieved from file - file format
     C                   PARM                    IPAYFilFmt

      ** Incoming Payments (extension) retrieved from file - file fmt
     C                   PARM                    IPY2FilFmt

      ** Incoming Payments (extension) for file update - file format
     C                   PARM                    IPY2FilFmt

      ** Charges Branch
     C                   PARM                    PPYBR

      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP

      ** Local Currency No. of Decimal Places
     C                   PARM                    PLCDP

      ** Local Currency Multiply/Divide Indicator
     C                   PARM                    PLMDIN

      ** Local Currency Spot Rate
     C                   PARM                    PLSPOT

      ** Entry Point
     C                   PARM                    PParmLevel

      ** STANDING DATA
      ** =============

      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD

      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY

      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY

      ** VAT Rate
     C                   PARM                    PVATR

      ** SWITCHABLE FEATURES
      ** ===================

      ** BLI FT Enhancements Feature
     C                   PARM                    S01494

      ** BLI VAT Processing Feature
     C                   PARM                    S01499

      ** BLI Payment Charges Enhancements
     C                   PARM                    S01506

      ** BLI Extended Payment Charges
     C                   PARM                    S01508

      ** FT Batch Authorization and Credit Advices
     C                   PARM                    CFT004

      ** STP Phase 2 MT103
     C                   PARM                    CFT014

      ** OUTPUT
      ** ======

      ** Incoming Payments for file update - file format
     C                   PARM                    IPAYFilFmt

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCDEFAULT - Defaulting of Charges and Commission            *
      *                                                               *
      *****************************************************************

     C     SRCDefault    BEGSR

     C                   CALLB     'FTIPAY3DT'
      *                             =========
      ** INPUT
      ** =====

      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    CurTrIPY1

      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    CurTrIPY5

      ** Incoming Payments (additional info) for file update
      ** - file format
     C                   PARM                    IPY2FilFmt

      ** Incoming Payments retrieved from file - file format
     C                   PARM                    IPAYFilFmt

      ** Payment Type
     C                   PARM                    PPYTP

      ** Charges Branch
     C                   PARM                    PPYBR

      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode

      ** Previous values of 'Charges to the Debit of a/c'
     C                   PARM                    PPrvCDRT
     C                   PARM                    PPrvCDRO
     C                   PARM                    PPrvCDBR
     C                   PARM                    PPrvCDRC                                     CFT120

      ** Recalcution flag.
     C                   PARM                    PReCalc

      ** STANDING DATA
      ** =============

      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD

      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY

      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY

      ** VAT Default Flag
     C                   PARM                    PVATT

      ** VAT Rate
     C                   PARM                    PVATR

      ** SWITCHABLE FEATURES
      ** ===================

      ** BLI FT Enhancements Feature
     C                   PARM                    S01494

      ** BLI VAT Processing Feature
     C                   PARM                    S01499

      ** BLI Payment Charges Enhancements
     C                   PARM                    S01506

      ** BLI Extended Payment Charges
     C                   PARM                    S01508

      ** FT Batch Authorization and Credit Advices
     C                   PARM                    CFT004

      ** MT103 Messages Generation for FT
     C                   PARM                    CFT014
      *                                                                                       CFT120
      ** FT IN/OP - Charges on DR of Account Ccy                                              CFT120
      *                                                                                       CFT120
     C                   PARM                    CFT120                                       CFT120

      ** OUTPUT
      ** ======

      ** Input Charge Currency
     C                   PARM                    PICCY

      ** Input Charge Currency In Currency Flag
     C                   PARM                    PIINCY

      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP

      ** Input Charge Currency EMU Transmission Period Start Date
     C                   PARM                    PITPSD

      ** Output Charge Currency
     C                   PARM                    POCCY

      ** Output Charge Currency In Currency Flag
     C                   PARM                    POINCY

      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP

      ** DS for Default Charge Amounts
     C                   PARM                    PCharges

      ** DS for Default Charge Currencies
     C                   PARM                    PChgCcy

      ** Incoming Payments for file update - file format
     C                   PARM                    IPAYFilFmt

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send error message to screen                        *
      *                                                               *
      *****************************************************************
      *
     C     SRSndM        BEGSR
      *
      ** If single-branching, user does not have the authority to
      ** Browse.
      *
     C     PErrMs        IFEQ      'FTA0114'
     C                   MOVE      'N'           OKACTN
     C                   ENDIF
      *
      ** Invalid Payment Reference.
      *
     C     PErrMs        IFEQ      'FTA0108'
     C                   MOVE      'N'           OKPREF
     C                   ENDIF
      *
      ** Add error message to array passed to screen.
      *
     C                   Z-ADD     1             Ex
     C     *BLANK        LOOKUP    FldNameArr(Ex)                         99
     C                   MOVEL     '*ANY'        FldNameArr(Ex)
     C                   MOVEL     PErrMs        MsgIdArr(Ex)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ReadIPAY - Read previous or next record in Incoming Payments *
      *             file                                              *
      *                                                               *
      *****************************************************************
     C     ReadIPAY      BEGSR

     C                   CALLB     'FTIPAYRED'
      *                             =========
      ** INPUT
      ** =====

      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut

      ** Payment Reference (file pointer)
     C                   PARM      DDPREF_In     DDPREF

      ** Read backwards
     C                   PARM                    PRdBck

      ** Read forwards
     C                   PARM                    PRdFwd

      ** STANDING DATA
      ** =============

      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC

      ** OUTPUT
      ** ======

      ** Error message
     C                   PARM                    PErrMs

      ** Payment Reference read
     C                   PARM                    PPrefSel

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RetrieveIPAY - Retrieve incoming payments transaction in     *
      *                 file format                                   *
      *                                                               *
      *****************************************************************
     C     RetrieveIPAY  BEGSR

     C                   CALLB     'FTIPAYRTV'
      *                             =========
      ** INPUT
      ** =====

      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut

     C                   PARM      *BLANKS       PMode

      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    PResponse

      ** Action Code
     C                   PARM                    DDACTN

      ** Front Office Transaction Id
     C                   PARM      *BLANKS       FOTrId

      ** Payment Reference
     C                   PARM      PPRefSel      DDPREF

      ** Booking Branch
     C                   PARM                    DDBRCA

      ** SWIFT Reference
     C                   PARM                    DDSWTN

      ** Entry Point
     C                   PARM                    PParmLevel

      ** Linked Program
     C                   PARM                    PLinkPgm

      ** Validate Payment Reference for Insert
     C                   PARM      'Y'           PPrefInsert

      ** STANDING DATA
      ** =============

      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN

      ** SWITCHABLE FEATURES
      ** ===================

      ** BLI FT Enhancements Feature
     C                   PARM                    S01494

      ** BLI VAT Processing Feature
     C                   PARM                    S01499

      ** FT Batch Auth and Credit Advices
     C                   PARM                    CFT003

      ** STP Phase 2 MT103
     C                   PARM                    CFT014

      ** Fees & Charges
     C                   PARM                    CFT009

      ** OUTPUT
      ** ======

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** OK Action Code
     C                   PARM                    OKACTN

      ** OK Payment Reference
     C                   PARM                    OKPREF

      ** OK Booking Branch
     C                   PARM                    OKBRCA

      ** Incoming Payments retrieved from file - file format
     C                   PARM                    IPAYFilFmt
     C                   PARM                    IPY2FilFmt

     C                   IF        ULX043 = 'Y'                                               CER001
     C                   CALLB     'FTIPAY2RV'                                                CER001
     C                   PARM      *BLANKS       PRetCodeIn                                   CER001
     C                   PARM                    PActn                                        CER001
     C                   PARM                    PFrontID                                     CER001
     C                   PARM      INPREF        PPayRef                                      CER001
     C                   PARM                    IPAYExFilFmt                                 CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ConvertIPAY - Convert Incoming Payment details from file to  *
      *                screen format                                  *
      *                                                               *
      *****************************************************************

     C     ConvertIPAY   BEGSR

     C                   CALLB     'FTIPAYCVT'
      *                             =========
      ** INPUT
      ** =====

      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut

      ** Incoming Payments retrieved from file - file format
     C                   PARM                    IPAYFilFmt
     C                   PARM                    IPY2FilFmt

      ** Action Code
     C                   PARM                    DDACTN

      ** STANDING DATA
      ** =============

      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC

      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN

      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD

      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY

      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU

      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU

      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST

      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY

      ** SDFTFR - Fixed Charge Currency
     C                   PARM                    FCHCCY

      ** SWITCHABLE FEATURES
      ** ===================

      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006

      ** BLI Funds Transfer Enhancement Feature
     C                   PARM                    S01494

      ** BLI VAT Processing Feature
     C                   PARM                    S01499

      ** Electronic Banking Interface IATs and TPPs
     C                   PARM                    CGL009

      ** STP Phase 2 MT103
     C                   PARM                    CFT014

      ** Fees & Charges
     C                   PARM                    CFT009
     C                   PARM                    CFT010

      ** OUTPUT
      ** ======

      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY1
     C                   PARM                    CurTrIP1A

      ** Incoming Payments Lvl 2 Scrn 1/1 details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY2

      ** Incoming Payments Lvl 2 Scrn 1/2 details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY3

      ** Incoming Payments Lvl 2 Scrn 2 details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY4
     C                   PARM                    CurTrIP4A

      ** Incoming Payments Lvl 2 Scrn 3 details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY5

      ** Incoming Payments Margin Info details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY6
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 details retrieved from file                           CSW209
      ** - screen format                                                                      CSW209
     C                   PARM                    CurTrIPY7                                    CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 details retrieved from file                           CSW209
      ** - screen format                                                                      CSW209
     C                   PARM                    CurTrIPY8                                    CSW209
      *                                                                                       CER030
      ** Incoming Payments Ext. Narratives retrieved from file                                CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    CurTrIPY6A                                   CER030

      ** DS for Additional Information details
     C                   PARM                    PAddInfm

      ** SWIFT Reference
     C                   PARM                    DDSWTN

      ** Sequence No.
     C                   PARM                    DDSEQNO

      ** Incoming Payment Status
     C                   PARM                    PStatus

      ** Payment Type
     C                   PARM                    PPYTP

      ** DS for Default Charge Amounts
     C                   PARM                    PCharges

      ** Input Charge Currency
     C                   PARM                    PICcy

      ** Output Charge Currency
     C                   PARM                    POCcy

      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINbdp

      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONbdp
     C                   PARM                    BtnPressed                                AR1090283

     C                   IF        ULX043 = 'Y'                                               CER001
     C                   CALLB     'FTIPAY2CT'                                                CER001
     C                   PARM      *BLANKS       PRetCodeIn                                   CER001
     C                   PARM                    IPAYExFilFmt                                 CER001
     C                   PARM                    RegData                                      CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   ENDSR
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer fields for retrieval of details                                             CSF011
                                                                                              CSF011
     C                   EVAL      %SUBST(WNumDetlIn:1:35)   = DDSND1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = DDRCO1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = DDBNC1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:106:35) = DDTRIB                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:141:35) = DDACBK                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:176:35) = DDOBK1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:211:35) = DDORC1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:246:35) = DDSNC1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:281:35) = DDINB1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:316:35) = DDCDRO                         CSF011
                                                                                              CSF011
      ** With '/' Account                                                                     CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDSND1:1:1) = '/'                                   CSF011
     C                   IF        DDSND2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:1:35) = DDSND2                           CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr = *BLANKS                                            CSF011
     C                   EVAL      WNStr = %SUBST(DDSND1:2:34)                                CSF011
     C                   EVAL      %SUBST(WNumDetlIn:1:35) = WNStr                            CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDRCO1:1:1) = '/'                                   CSF011
     C                   IF        DDRCO2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = DDRCO2                         CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr= *BLANKS                                             CSF011
     C                   EVAL      WNStr= %SUBST(DDRCO1:2:34)                                 CSF011
     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = WNStr                          CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDBNC1:1:1) = '/'                                   CSF011
     C                   IF        DDBNC2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = DDBNC2                         CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr = *BLANKS                                            CSF011
     C                   EVAL      WNStr = %SUBST(DDBNC1:2:34)                                CSF011
     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = WNStr                          CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDOBK1:1:1) = '/'                                   CSF011
     C                   IF        DDOBK2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:176:35) = DDOBK2                         CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr= *BLANKS                                             CSF011
     C                   EVAL      WNStr= %SUBST(DDOBK1:2:34)                                 CSF011
     C                   EVAL      %SUBST(WNumDetlIn:176:35) = WNStr                          CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDORC1:1:1) = '/'                                   CSF011
     C                   IF        DDORC2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:211:35) = DDORC2                         CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr = *BLANKS                                            CSF011
     C                   EVAL      WNStr = %SUBST(DDORC1:2:34)                                CSF011
     C                   EVAL      %SUBST(WNumDetlIn:211:35) = WNStr                          CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDSNC1:1:1) = '/'                                   CSF011
     C                   IF        DDSNC2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:246:35) = DDSNC2                         CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr = *BLANKS                                            CSF011
     C                   EVAL      WNStr = %SUBST(DDSNC1:2:34)                                CSF011
     C                   EVAL      %SUBST(WNumDetlIn:246:35) = WNStr                          CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDINB1:1:1) = '/'                                   CSF011
     C                   IF        DDINB2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:281:35) = DDINB2                         CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr = *BLANKS                                            CSF011
     C                   EVAL      WNStr = %SUBST(DDINB1:2:34)                                CSF011
     C                   EVAL      %SUBST(WNumDetlIn:281:35) = WNStr                          CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   DOW       CusIdx <= NoOfCusField                                     CSF011
                                                                                              CSF011
     C                   EVAL      P@Str = %SUBST(WNumDetlIn:CusIdx2:35)                      CSF011
     C                   EVAL      W@Abc = %SUBST(CusOrAcc:CusIdx:1)                          CSF011
                                                                                              CSF011
     C                   IF        P@Str <> *BLANKS                                           CSF011
                                                                                              CSF011
     C                   IF        W@Abc = 'B'                                                CSF011
     C                   EVAL      WCustomer = *BLANKS                                        CSF011
                                                                                              CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY'        @OPTN                                        CSF011
     C                   PARM                    P@Str                                        CSF011
     C                   PARM      *BLANKS       C#KYST                                       CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
     C                   CALL      'AOIBANR2'                                                 CSF011
     C                   PARM      *Blanks       @RTCD                                        CSF011
     C                   PARM                    P@Str                                        CSF011
     C                   PARM                    DSSDY                                        CSF011
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                   EVAL      ACCNT = DSSDY                                              CSF011
     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
                                                                                              CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      W@CCY = DDSMCY                                             CSF011
     C                   EVAL      W@BRC = DDORBR                                             CSF011
     C                   IF        (CusIdx = 3 AND DDPCCY <> *BLANKS)                         CSF011
     C                             OR (CusIdx = 5 AND DDPCCY <> *BLANKS)                      CSF011
     C                             OR (CusIdx = 8 AND DDPCCY <> *BLANKS)                      CSF011
     C                   EVAL      W@CCY = DDPCCY                                             CSF011
     C                   ENDIF                                                                CSF011
     C                   IF        CusIdx = 5 AND DDACBB <> *BLANKS                           CSF011
     C                   EVAL      W@BRC = DDACBB                                             CSF011
     C                   ENDIF                                                                CSF011
     C                   IF        CusIdx = 10 AND DDCDBR <> *BLANKS                          CSF011
     C                   EVAL      W@BRC = DDCDBR                                             CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
      ** Format Full GL Account                                                               CSF011
      ** Format Partial Account                                                               CSF011
      ** Format Nostro Account                                                                CSF011
                                                                                              CSF011
     C                   SELECT                                                               CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 24                                    CSF011
     C                   EVAL      P@Str = %SUBST(P@Str:22:3)                                 CSF011
     C                             + %SUBST(P@Str:1:21)                                       CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 21                                    CSF011
     C                   EVAL      P@Str = %SUBST(P@Str:19:3) +                               CSF011
     C                             %SUBST(P@Str:1:6) + W@CCY +                                CSF011
     C                             %SUBST(P@Str:7:12)                                         CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 18                                    CSF011
     C                   EVAL      P@Str = W@BRC +                                            CSF011
     C                             %SUBST(P@Str:1:6) + W@CCY +                                CSF011
     C                             %SUBST(P@Str:7:12)                                         CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 2                                     CSF011
     C                   EVAL      P@Str = W@CCY + %SUBST(P@Str:1:2)                          CSF011
                                                                                              CSF011
     C                   ENDSL                                                                CSF011
                                                                                              CSF011
     C                   CALL      'AOACCTV1'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      *BLANKS       P@TYP                                        CSF011
     C                   PARM                    P@Str                                        CSF011
     C                   PARM                    DSSDY                                        CSF011
                                                                                              CSF011
      ** Retrieve Account Details, Customer Report Name,                                      CSF011
      ** and Town, Account Name and Swift ID                                                  CSF011
                                                                                              CSF011
     C                   SELECT                                                               CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*RETAIL' OR                                       CSF011
     C                             P@TYP = '*LEDGER'                                          CSF011
     C                   EVAL      ACCNT = DSSDY                                              CSF011
     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*NOSTRO'                                          CSF011
     C                   EVAL      SDNOST = DSSDY                                             CSF011
     C                   EVAL      WCustomer = A7CUST                                         CSF011
     C                   CALL      'AOACCTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY   '     @OPTN                                        CSF011
     C                   PARM      *BLANKS       P0RETL                                       CSF011
     C                   PARM                    A7CUST                                       CSF011
     C                   PARM                    A7CYCD                                       CSF011
     C                   PARM                    A7ACCD                                       CSF011
     C                   PARM                    A7ACSN                                       CSF011
     C                   PARM                    A7BRCD                                       CSF011
     C     ACCNT         PARM                    DSSDY                                        CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*CUSTNO' OR                                       CSF011
     C                             P@TYP = '*SWIFT ' OR                                     MD044395
     C                             P@TYP = '*SHNAME'                                          CSF011
                                                                                              CSF011
     C                   EVAL      SDCUST = DSSDY                                             CSF011
     C                   EVAL      WCustomer = *BLANKS                                        CSF011
     C                   EVAL      AC_ANAM  = *BLANKS                                       MD044395
                                                                                            MD044395
     C                   IF        P@TYP = '*SWIFT '                                        MD044395
     C                             AND BBCSSN = *BLANKS                                     MD044395
     C                   EVAL      BBCSID = *BLANKS                                         MD044395
     C                   ENDIF                                                              MD044395
                                                                                            MD044395
     C                   WHEN      P@TYP = '*NRF   '                                          CSF011
     C                   EVAL      WCustomer = *BLANKS                                        CSF011
     C                   ENDSL                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF         WCustomer <> *BLANKS                                      CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY'        @OPTN                                        CSF011
     C                   PARM                    WCustomer                                    CSF011
     C                   PARM      *BLANKS       C#KYST                                       CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
     C                   ENDIF                                                                CSF011
                                                                                             CSF011A
     C                   IF         @RTCD  = *BLANKS                                         CSF011A
     C                   SELECT                                                              CSF011A
                                                                                             CSF011A
      ** Destination                                                                         CSF011A
     C                   WHEN      CusIdx = 1                                                CSF011A
     C                   EVAL      DDSNSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDSNNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDSNTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDSNAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDSNSW  = BBCSID                                          CSF011A
                                                                                             CSF011A
      ** Receivers correspondent                                                             CSF011A
     C                   WHEN      CusIdx = 2                                                CSF011A
     C                   EVAL      DDRCSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDRCNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDRCTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDRCAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDRCSW  = BBCSID                                          CSF011A
                                                                                             CSF011A
      ** Beneficiary                                                                         CSF011A
     C                   WHEN      CusIdx = 3                                                CSF011A
     C                   EVAL      DDBNSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDBNNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDBNTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDBNAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDBNSW  = BBCSID                                          CSF011A
                                                                                             CSF011A
      ** Third Reimbursement Institution                                                     CSF011A
     C                   WHEN      CusIdx = 4                                                CSF011A
     C                   EVAL      DDTRSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDTRNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDTRTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDTRAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDTRSW  = BBCSID                                          CSF011A
                                                                                             CSF011A
      ** Account with Bank                                                                   CSF011A
     C                   WHEN      CusIdx = 5                                                CSF011A
     C                   EVAL      DDABSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDABNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDABTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDABAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDABSW  = BBCSID                                          CSF011A
                                                                                             CSF011A
      ** Ordering Bank                                                                       CSF011A
     C                   WHEN      CusIdx = 6                                                CSF011A
     C                   EVAL      DDOBSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDOBNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDOBTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDOBSW  = BBCSID                                          CSF011A
                                                                                             CSF011A
      ** Ordering Customer                                                                   CSF011A
     C                   WHEN      CusIdx = 7                                                CSF011A
     C                   EVAL      DDOCSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDOCNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDOCTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDOCAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDOCSW  = BBCSID                                          CSF011A
                                                                                             CSF011A
      ** Ordering Bank                                                                       CSF011A
     C                   WHEN      CusIdx = 8                                                CSF011A
     C                   EVAL      DDSCSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDSCNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDSCTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDSCSW  = BBCSID                                          CSF011A
                                                                                             CSF011A
      ** Intermediary Bank                                                                   CSF011A
     C                   WHEN      CusIdx = 9                                                CSF011A
     C                   EVAL      DDIBSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDIBNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDIBTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDIBSW  = BBCSID                                          CSF011A
                                                                                             CSF011A
      ** Charges to the Debit of Account                                                     CSF011A
     C                   WHEN      CusIdx = 10                                               CSF011A
     C                   EVAL      DDCDSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDCDNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDCDTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDCDAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDCDSW  = BBCSID                                          CSF011A
     C                   ENDSL                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
      ** Increment counter fields                                                             CSF011
                                                                                              CSF011
     C                   IF        W@Abc = 'A'                                                CSF011
     C                   Z-ADD     AccLength     W@Len                                        CSF011
     C                   ELSE                                                                 CSF011
     C                   Z-ADD     ACusLngth     W@Len                                        CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   EVAL      CusIdx = Cusidx + 1                                        CSF011
     C                   EVAL      CusIdx2 = Cusidx2 + 35                                     CSF011
                                                                                              CSF011
     C                   ENDDO                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** INPUT
      ** =====

      ** Read forward/backward indicator
     C                   PARM                    FwdBck

      ** Payment Reference
     C                   PARM                    DDPREF_In
                                                                                              BG1768
      ** Action                                                                               BG1768
     C                   PARM                    DDACTN_In                                    BG1768

      ** OUTPUT
      ** ======

      ** Buffer
     C                   PARM                    Buffer

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray

      ** API Return Code
     C                   PARM                    APIRetc
     C                   PARM                    BtnPressed       10                       AR1090283

      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'FTUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'

      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,FTIPAYM01

      ** Access Bank details.
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access General Ledger ICD details.
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY

      ** Access Midas Modules details.
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY

      ** Access Funds Transfer ICD details.
     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDFTFR        PARM      SDFTFR        DSFDY

      ** Access SAR file to determine if S01494
      ** (BLI FT Enhancements Feature) is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01494'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           S01494
     C                   ELSE
     C                   MOVEL     'N'           S01494
     C                   ENDIF

      ** Access SAR file to determine if S01499 (BLI VAT Processing)
      ** is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01499'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           S01499
     C                   ELSE
     C                   MOVEL     'N'           S01499
     C                   ENDIF

      ** Access SAR file to determine if S01506 (BLI Payment Charges
      ** Enhancements) is installed.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01506'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           S01506
     C                   ELSE
     C                   MOVEL     'N'           S01506
     C                   ENDIF

      ** Access SAR file to determine if S01508 (BLI Extended Payment
      ** Charges) is installed.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01508'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           S01508
     C                   ELSE
     C                   MOVEL     'N'           S01508
     C                   ENDIF


      ** Access SAR file to determine if CFT003 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT003'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CFT003
     C                   ELSE
     C                   MOVEL     'N'           CFT003
     C                   ENDIF

      ** Access SAR file to determine if CFT004 (IBAN
      ** numbers) is installed.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT004'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CFT004
     C                   ELSE
     C                   MOVEL     'N'           CFT004
     C                   ENDIF


      ** Access SAR file to determine if CFT014 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT014'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CFT014
     C                   ELSE
     C                   MOVEL     'N'           CFT014
     C                   ENDIF

      ** Access SAR file to determine if CFT009 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT009'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CFT009
     C                   ELSE
     C                   MOVEL     'N'           CFT009
     C                   ENDIF

      ** Access SAR file to determine if CFT010 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT010'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CFT010
     C                   ELSE
     C                   MOVEL     'N'           CFT010
     C                   ENDIF

      ** Access SAR file to determine if CEU006 (EMU FT Settlement
      ** Currency Conversion) is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU006'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CEU006
     C                   ELSE
     C                   MOVEL     'N'           CEU006
     C                   ENDIF

      ** Access SAR file to determine if CGL009 (Electronic Banking
      ** Interface IATs and TPPs) is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CGL009'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CGL009
     C                   ELSE
     C                   MOVEL     'N'           CGL009
     C                   ENDIF

      *                                                                                       CER001
      ** Access SAR details file to determine if ULX043 is on.                                CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRtCd                                        CER001
     C                   PARM      '*VERIFY'     POptn                                        CER001
     C                   PARM      'ULX043'      PSard                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
      ** An NRF (No Record Found) return code is valid.                                       CER001
      ** Issue database error only for error return codes.                                    CER001
      *                                                                                       CER001
     C     PRTCD         IFNE      *BLANKS                                                    CER001
     C     PRTCD         ANDNE     '*NRF   '                                                  CER001
     C                   MOVEL     'ULX043'      DBKEY                                        CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   Z-ADD     002           DBASE                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        PRtCd = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'N'           ULX043                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If S01499 is installed, retrieve VAT Rate.
      ** OR if CFT010 is installed

     C                   IF        S01499 = 'Y' AND
     C                             CFT009 = 'N' OR
     C                             CFT010 = 'Y'

     C                   CALL      'AOVATR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C                   PARM                    PVATDS

     C                   ENDIF

      ** Access FT Control Data.

     C                   CALL      'FT0005'                             9090
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PCNTRL

      ** Error occurred.

     C                   IF        *IN90 OR
     C                             PRtCd <> *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'FT0005'      DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set up FT Override for GL Balances.

     C     PGLUI         IFEQ      'I'
     C                   MOVEL     'Y'           PFTOV
     C                   ELSE
     C                   MOVEL     *BLANK        PFTOV
     C                   ENDIF

      ** Access Currency details file for Base Currency details.

     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BJCYCD        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   Z-ADD     A6NBDP        PBCDP

      ** Access Currency details file for Local Currency details.

     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BJLCCY        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   Z-ADD     A6NBDP        PLCDp
     C                   IF        A6MDIN = 'M'
     C                   Z-ADD     1             PLMDIn
     C                   ELSE
     C                   Z-ADD     0             PLMDIn
     C                   ENDIF
     C                   Z-ADD     A6SPRT        PLSpot
      ***Retrieve*ZMUSER*details.                                                            BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
      *                                                                                       CFT120
      ** CFT120 - FT IN/OP - Charges to DR of Account Ccy                                     CFT120
      *                                                                                       CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRTCD                                        CFT120
     C                   PARM      '*VERIFY'     POPTN                                        CFT120
     C                   PARM      'CFT120'      PSARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
      ** An NRF (No Record Found) return code is valid.                                       CFT120
      ** Issue database error only for error return codes.                                    CFT120
      *                                                                                       CFT120
     C                   IF        PRTCD <> *BLANKS AND                                       CFT120
     C                             PRTCD <> '*NRF   '                                         CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   Z-ADD     046           DBASE                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   IF        PRTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   ENDIF                                                                CFT120

      ** Hook to enable non-core message files to be included
      /COPY WNCPYSRC,FTIPAY02

      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.

      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.

      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
