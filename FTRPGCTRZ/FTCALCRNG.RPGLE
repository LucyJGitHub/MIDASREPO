     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Calc. charge ranges and change amount')       *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  CalcRanges  FEES AND CHARGES: CALCULATE RANGES FOR           *
      *              CHARGE CODE                                      *
      *                                                               *
      *  Function:  Given the Payment Amount and the relevant         *
      *             Charge Code, this module will calculate the       *
      *             default ranges.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 217973             Date 17Nov12               *
      *                 CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG433             Date 05Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 29Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  217973 - Incorrect fee amount. Correctly use M/D indicator   *
      *           for conversion from base ccy to other ccy.          *
      *         - Applied for AR1023847 (Child: AR1023849)            *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * FT Payment Charge Definition
     FFTPCHGL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *       80  CHAIN indicator                                     *
      *                                                               *
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
 
      ** Array holding Chargeable Amount on each Tier
 
      ** Charge calculation arrays - Start amounts for each tier
      **                           - End amounts for each tier
      **                           - Rate for each tier
      **                           - Pro-Mile charge of each tier
      **                           - Minimum charge for each tier
      **                           - Maximum charge for each tier
      **                           - Charge for this tier
      **                           - Amount charged in this tier
     D StartArr        S             13P 0 DIM(11)
     D EndArr          S             13P 0 DIM(11)
     D RateArr         S             13P 8 DIM(11)
     D ProArr          S             13P 8 DIM(11)
     D MinArr          S             13P 0 DIM(11)
     D MaxArr          S             13P 0 DIM(11)
     D TierCharge      S             13P 0 DIM(11)
     D TierAmount      S             13P 0 DIM(11)
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Funds Transfer ICD
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      *                                                                                       CFT120
      ** Externally described DS for SAR details                                              CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
                                                                                              CFT120
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Other entry parameters
     D ChargeCode      S                   LIKE(PYCHCD)
     D P_ChargeCode    S                   LIKE(PYCHCD)
     D STP             S              1A
     D P_STP           S                   Like(STP)
     D*P_ChargesDR     S             12                                                       CGL029
     D P_ChargesDR     S             18                                                       CGL029
     D P_ADDC          S              1
     D P_ChgDRCcy      S              3                                                       CFT120
     D CFT120          S              1A                                                      CFT120
     D PTierCharge     S             13A   DIM(11)
     D PTierAmount     S             13A   DIM(11)
     D ADDC            S                   LIKE(P_ADDC)
     D ChargesDR       S                   LIKE(P_ChargesDR)
 
      ** Payment amount details
     D PayAmt          S             13P 0
     D P_PayAmt        S                   Like(PayAmt)
     D PayCcy          S              3A
     D P_PayCcy        S                   Like(PayCcy)
     D PayCcyDP        S                   LIKE(A6NBDP)
     D PayCcyMD        S                   LIKE(A6MDIN)
     D PaySpotRate     S                   LIKE(A6SPRT)
 
      * Settlement Currency Details
     D P_SettCcy       S                   Like(PayCcy)
     D P_SettAmt       S                   Like(PayAmt)
     D SettAmt         S                   Like(PayAmt)
     D SettCcy         S                   Like(PayCcy)
     D SettCcyDP       S                   LIKE(A6NBDP)
     D SettCcyMD       S                   LIKE(A6MDIN)
     D SettSpotRate    S                   LIKE(A6SPRT)
 
      ** Charge Currency details
     D ChgExch         S             13P 8
     D P_ChgExch       S                   Like(ChgExch)
     D ChgCcy          S              3A
     D P_ChgCcy        S                   Like(ChgCcy)
     D ChgCcyDP        S                   LIKE(A6NBDP)
     D ChgCcyMD        S                   LIKE(A6MDIN)
     D ChgSpotRate     S                   LIKE(A6SPRT)
 
      ** Other Transaction Currency details
     D OFileCcy        S              3A
     D OFileSpotRate   S                   LIKE(A6SPRT)
     D OFileCcyDP      S                   LIKE(A6NBDP)
     D OFileCcyMD      S                   LIKE(A6MDIN)
 
      * Reference Currency Details
     D ReferenceCcy    S                   LIKE(PayCcy)
     D ReferenceAmt    S                   LIKE(PayAmt)
     D ReferenceDP     S                   LIKE(A6NBDP)
     D ReferenceMD     S                   LIKE(A6MDIN)
     D ReferenceSpot   S                   Like(ChgExch)
 
      * Other currency details
     D OtherTransCcy   S                   LIKE(PayCcy)
     D OtherTransAmt   S                   LIKE(PayAmt)
     D OtherTransDP    S                   LIKE(A6NBDP)
     D OtherTransMD    S                   LIKE(A6MDIN)
     D OtherTransSpot  S                   Like(ChgExch)
 
      * Base Currency Details
     D BaseCcy         S                   LIKE(PayCcy)
     D BaseCcyDP       S                   LIKE(A6NBDP)
     D BaseCcyMD       S                   LIKE(A6MDIN)
     D BaseCcyAmt      S                   LIKE(PayAmt)
      *                                                                                       CFT120
      ** Charges to DR of Currency details                                                    CFT120
      *                                                                                       CFT120
     D ChgDRCcy        S                   LIKE(P_ChgDRCcy)                                   CFT120
     D ChgDRCcyDP      S                   LIKE(A6NBDP)                                       CFT120
     D ChgDRCcyMD      S                   LIKE(A6MDIN)                                       CFT120
     D ChgDRSpotRate   S                   LIKE(A6SPRT)                                       CFT120
 
      ** Work fields for charge calculation
     D TotInChgCcy     S             13P 0
 
      ** Parameters for ZRATE
     D ZRATE1          S             13P 8
     D ZRATE2          S             13P 8
     D ZMDI1           S              1A
     D ZMDI2           S              1A
     D ZRATEX          S             13P 8
     D ZMDIX           S              1A
 
     D ChgableAmt      S             13P 0
      *
     D ReferenceRange  S              5
     D WorkRange       S              5
 
     D Conv_Rate       S                   Like(ZRATEX)
 
     D TransRate       S                   LIKE(A6SPRT)
 
     D CurrType        S              1
     D WorkCcy         S                   Like(PayCcy)
 
     D/COPY FTCPYSRC,FT0010D001
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
      *
      ** Initialise
     C                   EXSR      InitProc
 
      * Determine charge currency.
     C                   Exsr      SRChgCcy
 
     C                   If        ReferenceCcy   =  OFileCcy
     C                   Eval      WorkRange      = 'OTHER'
     C                   Else
     C                   Eval      WorkRange      = 'BASE '
     C                   ENDIF
 
     C                   Exsr      FillRanges
 
     C                   Exsr      CalcPayAmt
 
      *                                                                                       CFT120
      ** Access SAR details file to determine if CFT120 enhancement is                        CFT120
      ** switched on.                                                                         CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      '*BLANKS'     @RTCD             7                          CFT120
     C                   PARM      '*VERIFY'     @OPTN             7                          CFT120
     C                   PARM      'CFT120'      @SARD             6                          CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')                CFT120
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT120
     C                   Z-ADD     4             DBASE                                        CFT120
     C                   MOVEL     'CFT120'      DBKEY                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   MOVEL     'Y'           CFT120                                       CFT120
     C                   ELSE                                                                 CFT120
     C                   MOVEL     'N'           CFT120                                       CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   RETURN
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * InitProc - Obtain charge definition details and initialise         *
      **********************************************************************
     C     InitProc      BEGSR
      *
      * If nothing to calculate, return
      *
     C                   IF        P_PayAmt <= 0
     C                   RETURN
     C                   ENDIF
      *
      * Enusre that we do not change passed parameters
      *
     C                   EVAL      PayCcy     = P_PayCcy
     C                   EVAL      PayAmt     = P_PayAmt
     C                   EVAL      ChgCcy     = P_ChgCcy
     C                   EVAL      ChgExch    = P_ChgExch
     C                   EVAL      STP        = P_STP
     C                   EVAL      ChargeCode = P_ChargeCode
     C                   EVAL      SettCcy    = P_SettCcy
     C                   EVAL      SettAmt    = P_SettAmt
     C                   EVAL      ChargesDR  = P_ChargesDR
     C                   EVAL      ADDC       = P_ADDC
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      ChgDRCcy  = P_ChgDRCcy                                     CFT120
     C                   ENDIF                                                                CFT120
 
     C                   EVAL      ChgAbleAmt = 0
      * ---------------------------------------------------------------
      ** Access Charge Definition file
     C     ChargeCode    CHAIN     FTPCHGL0                           80
      *
      ** Database error
      *
     C                   IF        *IN80  = *On
     C                   EVAL      DBFile = 'FTPCHGPD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKey  = ChargeCode
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set 'Other File Currency' OFileCcy
     C                   If        OTHCCY    <> *Blanks
     C                   Eval      OFileCcy  =  OTHCCY
     C                   Else
     C                   Eval      OFileCcy  =  *Blanks
     C                   Endif
 
      * ---------------------------------------------------------------
      ** Get Funds Transfer ICD
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY
      *
      * Database error
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDFTFRPD'    DBFILE
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF
      * ---------------------------------------------------------------
      ** Reset arrays, work fields
      *
     C                   CLEAR                   StartArr
     C                   CLEAR                   EndArr
     C                   CLEAR                   RateArr
     C                   CLEAR                   ProArr
     C                   CLEAR                   MinArr
     C                   CLEAR                   MaxArr
     C                   CLEAR                   TierCharge
     C                   CLEAR                   TierAmount
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRChgCcy - Determine Charge Currency from parameters passed
      *****************************************************************
     C     SRChgCcy      Begsr
 
      * If Charges to the debit of account entered USE BASE CCY AS CHARGE CCY
     C                   If        ChargesDR   <> '000000000000' And
     C                             ChargesDR <> *Blanks
     C                   If        ChgDRCcy <> *Blanks                                        CFT120
     C                             and CFT120 = 'Y'                                           CFT120
     C                   Eval      ReferenceCcy  = ChgDRCcy                                   CFT120
     C                   Else                                                                 CFT120
     C                   Eval      ReferenceCcy  = BaseCcy
     C                   Endif                                                                CFT120
     C                   Exsr      CDRORefAmt
 
 
      * Else if Charges Add Deduct Indicator = 'D' use PAY CCY
     C                   Else
 
     C                   IF        ADDC = 'D'
     C                   Eval      ReferenceCcy   = PayCcy
     C                   Eval      ReferenceAmt   = PayAmt
 
      * Else Add Deduct indicator = 'A', use SETTLE CCY
     C                   Else
     C                   Eval      ReferenceCcy   = SettCcy
     C                   Eval      ReferenceAmt   = SettAmt
 
     C                   Endif
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * CDRORefAmt   Determine Reference Amount when CDRO <> *Blanks
      *****************************************************************
     C     CDRORefAmt    Begsr
 
     C                   If        ChgDRCcy      <> *Blanks                                   CFT120
     C                             AND CFT120 = 'Y'                                           CFT120
     C                   ExSr      CDRORefCcy                                                 CFT120
     C                   Else                                                                 CFT120
     C                   If        ADDC          = 'A'
 
     C                   If        SettCcy       = BaseCcy
     C                   Eval      ReferenceAmt  = SettAmt
     C                   Endif
 
     C                   If        SettCcy <> BaseCcy
     C                   If        CHTRCY = 'Y' AND PayCcy = BaseCcy
     C                   Eval      ReferenceAmt  = PayAmt
     C                   Else
 
      * Get currency definitions
     C                   Eval      WorkCcy = SettCcy
     C                   Eval      CurrType = 'S'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy = BaseCcy
     C                   Eval      CurrType = 'B'
     C                   Exsr      GetCcyDef
 
      * Convert Settlement amount to base using currenct spot rate.
     C                   Eval      ZAMTCI = SettAmt
     C                   Eval      ZCCYI  = SettCcy
     C                   Eval      ZCCYO  = BaseCcy
     C                   Eval      ZCDPI  = SettCcyDP
     C                   Eval      ZCDPO  = BaseCcyDP
 
     C                   Eval      ZRate1 = SettSpotRate
     C                   Eval      ZMDI1  = SettCcyMD
     C                   Eval      ZRate2 = 1
     C                   Eval      ZMDI2  = BaseCcyMD
 
     C                   Exsr      SRConvCcy
 
     C                   Eval      ReferenceAmt  = ZAMTCO
 
     C                   Endif
     C                   Endif
     C                   Endif
 
     C                   If        ADDC = 'D'
     C                   If        PayCcy = BaseCcy
     C                   Eval      ReferenceAmt  = P_PayAmt
     C                   Endif
 
     C                   If        PayCcy <> BaseCcy
     C                   IF        CHTRCY = 'Y' AND SettCcy = BaseCcy
     C                   Eval      ReferenceAmt  = SettAmt
     C                   Else
      * Get currency definitions
     C                   Eval      WorkCcy = PayCcy
     C                   Eval      CurrType = 'P'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy = BaseCcy
     C                   Eval      CurrType = 'B'
     C                   Exsr      GetCcyDef
 
      * Convert Payment Amount to Base Ccy using current spot rate
     C                   Eval      ZAMTCI = PayAmt
     C                   Eval      ZCCYI  = PayCcy
     C                   Eval      ZCCYO  = BaseCcy
     C                   Eval      ZCDPI  = PayCcyDP
     C                   Eval      ZCDPO  = BaseCcyDP
 
     C                   Eval      ZRate1 = PaySpotRate
     C                   Eval      ZMDI1  = PayCcyMD
     C                   Eval      ZRate2 = 1
     C                   Eval      ZMDI2  = BaseCcyMD
 
     C                   Exsr      SRConvCcy
     C                   Eval      ReferenceAmt  = ZAMTCO
 
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif                                                                CFT120
 
     C                   Endsr
      *****************************************************************
      /EJECT                                                                                  CFT120
      *****************************************************************                       CFT120
      ** CDRORefCcy  Determine Reference Amount when CDRO <> *Blanks                          CFT120
      **             and Charges to DR of Currency <> *Blanks                                 CFT120
      *****************************************************************                       CFT120
     C     CDRORefCcy    Begsr                                                                CFT120
      *                                                                                       CFT120
     C                   If        ADDC          = 'A'                                        CFT120
      *                                                                                       CFT120
     C                   If        SettCcy       = ChgDRCcy                                   CFT120
     C                   Eval      ReferenceAmt  = SettAmt                                    CFT120
     C                   Endif                                                                CFT120
                                                                                              CFT120
     C                   If        SettCcy <> ChgDRCcy                                        CFT120
     C                   If        CHTRCY = 'Y' AND PayCcy = ChgDRCcy                         CFT120
     C                   Eval      ReferenceAmt  = PayAmt                                     CFT120
     C                   Else                                                                 CFT120
      *                                                                                       CFT120
      ** Get currency definitions                                                             CFT120
      *                                                                                       CFT120
     C                   Eval      WorkCcy = SettCcy                                          CFT120
     C                   Eval      CurrType = 'S'                                             CFT120
     C                   Exsr      GetCcyDef                                                  CFT120
      *                                                                                       CFT120
     C                   Eval      WorkCcy = ChgDRCcy                                         CFT120
     C                   Eval      CurrType = 'X'                                             CFT120
     C                   Exsr      GetCcyDef                                                  CFT120
      *                                                                                       CFT120
      ** Convert Settlement amount to base using currenct spot rate.                          CFT120
      *                                                                                       CFT120
     C                   Eval      ZAMTCI = SettAmt                                           CFT120
     C                   Eval      ZCCYI  = SettCcy                                           CFT120
     C                   Eval      ZCCYO  = ChgDRCcy                                          CFT120
     C                   Eval      ZCDPI  = SettCcyDP                                         CFT120
     C                   Eval      ZCDPO  = ChgDRCcyDP                                        CFT120
      *                                                                                       CFT120
     C                   Eval      ZRate1 = SettSpotRate                                      CFT120
     C                   Eval      ZMDI1  = SettCcyMD                                         CFT120
     C                   Eval      ZRate2 = ChgDRSpotRate                                     CFT120
     C                   Eval      ZMDI2  = ChgDRCcyMD                                        CFT120
      *                                                                                       CFT120
     C                   Exsr      SRConvCcy                                                  CFT120
      *                                                                                       CFT120
     C                   Eval      ReferenceAmt  = ZAMTCO                                     CFT120
      *                                                                                       CFT120
     C                   Endif                                                                CFT120
     C                   Endif                                                                CFT120
     C                   Endif                                                                CFT120
      *                                                                                       CFT120
     C                   If        ADDC = 'D'                                                 CFT120
     C                   If        PayCcy = ChgDRCcy                                          CFT120
     C                   Eval      ReferenceAmt  = P_PayAmt                                   CFT120
     C                   Endif                                                                CFT120
      *                                                                                       CFT120
     C                   If        PayCcy <> BaseCcy                                          CFT120
     C                   IF        CHTRCY = 'Y' AND SettCcy = ChgDRCcy                        CFT120
     C                   Eval      ReferenceAmt  = SettAmt                                    CFT120
     C                   Else                                                                 CFT120
      *                                                                                       CFT120
      ** Get currency definitions                                                             CFT120
      *                                                                                       CFT120
     C                   Eval      WorkCcy = PayCcy                                           CFT120
     C                   Eval      CurrType = 'P'                                             CFT120
     C                   Exsr      GetCcyDef                                                  CFT120
      *                                                                                       CFT120
     C                   Eval      WorkCcy = ChgDRCcy                                         CFT120
     C                   Eval      CurrType = 'X'                                             CFT120
     C                   Exsr      GetCcyDef                                                  CFT120
      *                                                                                       CFT120
      ** Convert Payment Amount to Base Ccy using current spot rate                           CFT120
      *                                                                                       CFT120
     C                   Eval      ZAMTCI = PayAmt                                            CFT120
     C                   Eval      ZCCYI  = PayCcy                                            CFT120
     C                   Eval      ZCCYO  = ChgDRCcy                                          CFT120
     C                   Eval      ZCDPI  = PayCcyDP                                          CFT120
     C                   Eval      ZCDPO  = ChgDRCcyDP                                        CFT120
      *                                                                                       CFT120
     C                   Eval      ZRate1 = PaySpotRate                                       CFT120
     C                   Eval      ZMDI1  = PayCcyMD                                          CFT120
     C                   Eval      ZRate2 = ChgDRSpotRate                                     CFT120
     C                   Eval      ZMDI2  = ChgDRCcyMD                                        CFT120
      *                                                                                       CFT120
     C                   Exsr      SRConvCcy                                                  CFT120
     C                   Eval      ReferenceAmt  = ZAMTCO                                     CFT120
      *                                                                                       CFT120
     C                   Endif                                                                CFT120
     C                   Endif                                                                CFT120
     C                   Endif                                                                CFT120
      *                                                                                       CFT120
     C                   Endsr                                                                CFT120
      /EJECT
      *****************************************************************
      * GetCcyDef - Get currency definitions
      *****************************************************************
     C     GetCcyDef     Begsr
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    WorkCcy
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
      * Database error
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   EVAL      DBASE  = 3
     C                   MOVEL     WorkCcy       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Select
     C                   When      CurrType        = 'R'
     C                   EVAL      ReferenceDP     = A6NBDP
     C                   EVAL      ReferenceMD     = A6MDIN
     C                   EVAL      ReferenceSpot   = A6SPRT
 
     C                   When      CurrType        = 'B'
     C                   Eval      BaseCcy         = BJCYCD
     C                   EVAL      BaseCcyDP       = A6NBDP
     C                   EVAL      BaseCcyMD       = A6MDEX
 
     C                   When      CurrType        = 'P'
     C                   EVAL      PayCcyDP        = A6NBDP
     C                   EVAL      PayCcyMD        = A6MDIN
     C                   EVAL      PaySpotRate     = A6SPRT
 
     C                   When      CurrType        = 'S'
     C                   EVAL      SettCcyDP       = A6NBDP
     C                   EVAL      SettCcyMD       = A6MDIN
     C                   EVAL      SettSpotRate    = A6SPRT
 
     C                   When      CurrType        = 'C'
     C                   EVAL      ChgCcyDP        = A6NBDP
     C                   EVAL      ChgCcyMD        = A6MDIN
     C                   EVAL      ChgSpotRate     = A6SPRT
 
     C                   When      CurrType        = 'T'
     C                   EVAL      OtherTransDP    = A6NBDP
     C                   EVAL      OtherTransMD    = A6MDIN
     C                   EVAL      OtherTransSpot  = A6SPRT
 
     C                   When      CurrType        = 'F'
     C                   EVAL      OFileCcyDP      = A6NBDP
     C                   EVAL      OFileCcyMD      = A6MDIN
     C                   EVAL      OFileSpotRate   = A6SPRT
 
     C                   When      CurrType        = 'X'                                      CFT120
     C                             And CFT120      = 'Y'                                      CFT120
     C                   EVAL      ChgDRCcyDP      = A6NBDP                                   CFT120
     C                   EVAL      ChgDRCcyMD      = A6MDIN                                   CFT120
     C                   EVAL      ChgDRSpotRate   = A6SPRT                                   CFT120
     C                   Endsl
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * FillRanges - Fill Range Values                                     *
      **********************************************************************
     C     FillRanges    Begsr
 
      *
      * Convert tier amounts for range values.
      *
     C                   Select
 
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
      * 1.
     C                   When      WorkRange = 'BASE '    And
     C                             ChgCcy    = BaseCcy
 
     C                   Eval      WorkCcy   = BaseCcy
     C                   Eval      CurrType  = 'B'
     C                   Exsr      GetCcyDef
 
     C                   Eval      ZEXCH     = 1
     C                   Eval      ZCCYI     = BaseCcy
     C                   Eval      ZCCYO     = BaseCcy
     C                   Eval      ZMD       = BaseCcyMD
     C                   Eval      ZCDPI     = BaseCcyDP
     C                   Eval      ZCDPO     = BaseCcyDP
 
     C                   Exsr      #CvtRange
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
      * 2.
     C                   When      WorkRange = 'BASE '    And
     C                             CHTRCY    = 'Y'        And
     C                             SettCcy   = BaseCcy    And
     C                             PayCcy    = ChgCcy     Or
     C                             WorkRange = 'BASE '    And
     C                             CHTRCY    = 'Y'        And
     C                             SettCcy   = ChgCcy     And
     C                             PayCcy    = BaseCcy
 
      * Fill in charge calculation array by converting base details to charge
      *  currency using transaction rate.
 
     C                   Eval      WorkCcy   = BaseCcy
     C                   Eval      CurrType  = 'B'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy   = ChgCcy
     C                   Eval      CurrType  = 'C'
     C                   Exsr      GetCcyDef
 
     C                   Eval      ZCCYI     = BaseCcy
     C                   Eval      ZCCYO     = ChgCcy
     C                   Eval      ZCDPI     = BaseCcyDP
     C                   Eval      ZCDPO     = ChgCcyDP
     C                   Eval      ZRATE1  = 1
 
     C                   Eval      ZRATE2  = ChgExch
 
     C                   Eval      ZMDI1   = BaseCcyMD
     C                   Eval      ZMDI2   = ChgCcyMD
     C                   Eval      ZCDPI   = BaseCcyDP
     C                   Eval      ZCDPO   = ChgCcyDP
 
     C                   Exsr      SrZxRate
 
     C                   Exsr      #CvtRange
 
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 
      * 3.
      * All other cases where WORKRANGE = Base, fill ranges by converting
      *  base details to charge currency
 
     C                   When      WorkRange   = 'BASE '
 
     C                   Eval      WorkCcy     = BaseCcy
     C                   Eval      CurrType    = 'B'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy     = ChgCcy
     C                   Eval      CurrType    = 'C'
     C                   Exsr      GetCcyDef
 
     C                   Eval      ZEXCH       = ChgSpotRate
     C**********         Eval      ZMD         = BaseCcyMD                                    217973
     C                   IF        ChgCcyMD    = 'M'                                          217973
     C                   EVAL      ZMD         = 'D'                                          217973
     C                   ELSE                                                                 217973
     C                   EVAL      ZMD         = 'M'                                          217973
     C                   ENDIF                                                                217973
     C                   Eval      ZCCYI       = BaseCcy
     C                   Eval      ZCCYO       = ChgCcy
     C                   Eval      ZCDPI       = BaseCcyDP
     C                   Eval      ZCDPO       = ChgCcyDP
 
     C                   Exsr      #CvtRange
 
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 
      * 1(a).
      * WorkRate = OTHER.  ie the other currency has been filled in the
      *  payment charge definition file.
 
      * Other currency and charge currency are the same.  Do not convert.
      *  Fill the other array.
 
     C                   When      WorkRange = 'OTHER' AND
     C                             ChgCcy    = OFileCcy
 
     C                   Eval      WorkCcy   = OFileCcy
     C                   Eval      CurrType  = 'F'
     C                   Exsr      GetCcyDef
 
     C                   Eval      ZEXCH     = 1
     C                   Eval      ZMD       = OFileCcyMD
     C                   Eval      ZCCYI     = OFileCcy
     C                   Eval      ZCCYO     = OFileCcy
     C                   Eval      ZCDPI     = OFileCcyDP
     C                   Eval      ZCDPO     = OFileCcyDP
     C                   Exsr      OthRange
 
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 
      * 2(a).
      * If transaction rates are used and file currency is the same as settlement
      *  or pay currencies, convert to the settment or pay details.
 
     C                   When      WorkRange  = 'OTHER'    And
     C                             CHTRCY     = 'Y'        And
     C                             SettCcy    = OFileCcy   And
     C                             PayCcy     = ChgCcy     Or
     C                             WorkRange  = 'OTHER'    And
     C                             CHTRCY     = 'Y'        And
     C                             SettCcy    = ChgCcy     And
     C                             PayCcy     = OFileCcy
 
      * Get Currency Details
     C                   Eval      WorkCcy   = OFileCcy
     C                   Eval      CurrType  = 'F'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy   = ChgCcy
     C                   Eval      CurrType  = 'C'
     C                   Exsr      GetCcyDef
 
      * Convert the other file details to charge currency using transaction rate
     C                   Eval      ZEXCH     = ChgExch
 
     C                   Eval      ZMD       = OFileCcyMD
     C                   Eval      ZCCYI     = OFileCcy
     C                   Eval      ZCCYO     = ChgCcy
     C                   Eval      ZCDPI     = OFileCcyDP
     C                   Eval      ZCDPO     = ChgCcyDP
     C                   Exsr      OthRange
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 
      * 3(a).
      * Transaction Rates are used.  File currency is either settlement or pay currency
      *  but charge currency is not pay or settle currency.
 
     C                   When      WorkRange  =  'OTHER'    And
     C                             CHTRCY     =  'Y'        And
     C                             SettCcy    =  OFileCcy   And
     C                             PayCcy     <> ChgCcy     Or
     C                             WorkRange  =  'OTHER'    And
     C                             CHTRCY     =  'Y'        And
     C                             SettCcy    <> ChgCcy     And
     C                             PayCcy     = OFileCcy
 
      * Determine Other Currency
     C                   If        SettCcy       = OFileCcy
     C                   Eval      OtherTransCcy = PayCcy
     C                   Else
     C                   Eval      OtherTransCcy = SettCcy
     C                   Endif
 
      * Get currency details
     C                   Eval      WorkCcy   = OFileCcy
     C                   Eval      CurrType  = 'F'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy   = OtherTransCcy
     C                   Eval      CurrType  = 'T'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy   = ChgCcy
     C                   Eval      CurrType  = 'C'
     C                   Exsr      GetCcyDef
 
      * Fill the charge ranges by converting the file details to the other transaction
      *  details at the TRANSACTION rate and the to charge currency at SPOT rate.
 
 
      * Get cross rate betweeh OtherTransCcy and ChgCcy
     C                   Eval      ZCCYI   = OFileCcy
     C                   Eval      ZCCYO   = OtherTransCcy
     C                   Eval      ZRATE1  = ChgExch
     C                   Eval      ZRATE2  = OtherTransSpot
     C                   Eval      ZMDI1   = OFileCcyMD
     C                   Eval      ZMDI2   = OtherTransMD
     C                   Eval      ZCDPI   = OFileCcyDP
     C                   Eval      ZCDPO   = OtherTransDP
 
      * The Rate returned forms ZRATE2 ...... Discard rate keep mult div ind.
     C                   Exsr      SRZxRate
 
      * Now convert from other (FILE) currency to charge currency using transaction
      *  rate ZRATE1 and calcualted cross rate.
 
     C                   Eval      ZCCYI   = OtherTransCcy
     C                   Eval      ZCCYO   = ChgCcy
 
     C                   Eval      ZRATE1  = ChgExch
 
     C                   Eval      ZRATE2  = ChgSpotRate
     C                   Eval      ZMDI1   = ZMDIX
     C                   Eval      ZMDI2   = ChgCcyMD
     C                   Eval      ZCDPI   = OtherTransDP
     C                   Eval      ZCDPO   = ChgCcyDP
 
     C                   Exsr      SRZxRate
 
     C                   Exsr      OthRange
 
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 
      * 4(a).
      * All case where WorkRange = 'OTHER'.
 
     C                   When      WorkRange  =  'OTHER'
 
     C                   Eval      WorkCcy   = OFileCcy
     C                   Eval      CurrType  = 'F'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy   = ChgCcy
     C                   Eval      CurrType  = 'C'
     C                   Exsr      GetCcyDef
 
      * Convert Other File details to Charge currency at SPOT.
 
     C                   Eval      ZCCYI      = OFileCcy
     C                   Eval      ZCCYO      = ChgCcy
     C                   Eval      ZRATE1     = OFileSpotRate
     C                   Eval      ZRATE2     = ChgSpotRate
     C                   Eval      ZMDI1      = OFileCcyMD
     C                   Eval      ZMDI2      = ChgCcyMD
     C                   Eval      ZCDPI      = OFileCcyDP
     C                   Eval      ZCDPO      = ChgCcyDP
 
     C                   Exsr      SRZxRate
 
     C                   Exsr      OthRange
 
     C                   Endsl
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * #CvtRange - Convert Ranges from Base currency to Charge Currency   *
      **********************************************************************
     C     #CvtRange     Begsr
 
      * Now convert base currency ranges to charge currency
     C                   IF        STP = 'Y'
 
      * If STP but no STP values, fill with manual values
     C                   IF        SSBC01 = 0 And
     C                             SSBC01 = 0 And
     C                             SSEC01 = 0 And
     C                             SMIB01 = 0 And
     C                             SMAB01 = 0 And
     C                             SRAT01 = 0 And
     C                             SPMB01 = 0 And
     C                             SSBC02 = 0 And
     C                             SSEC02 = 0 And
     C                             SMIB02 = 0 And
     C                             SMAB02 = 0 And
     C                             SRAT02 = 0 And
     C                             SPMB02 = 0 And
     C                             SSBC03 = 0 And
     C                             SSEC03 = 0 And
     C                             SMIB03 = 0 And
     C                             SMAB03 = 0 And
     C                             SRAT03 = 0 And
     C                             SPMB03 = 0 And
     C                             SSBC04 = 0 And
     C                             SSEC04 = 0 And
     C                             SMIB04 = 0 And
     C                             SMAB04 = 0 And
     C                             SRAT04 = 0 And
     C                             SPMB04 = 0 And
     C                             SSBC05 = 0 And
     C                             SSEC05 = 0 And
     C                             SMIB05 = 0 And
     C                             SMAB05 = 0 And
     C                             SRAT05 = 0 And
     C                             SPMB05 = 0 And
     C                             SSBC06 = 0 And
     C                             SSEC06 = 0 And
     C                             SMIB06 = 0 And
     C                             SMAB06 = 0 And
     C                             SRAT06 = 0 And
     C                             SPMB06 = 0 And
     C                             SSBC07 = 0 And
     C                             SSEC07 = 0 And
     C                             SMIB07 = 0 And
     C                             SMAB07 = 0 And
     C                             SRAT07 = 0 And
     C                             SPMB07 = 0 And
     C                             SSBC08 = 0 And
     C                             SSEC08 = 0 And
     C                             SMIB08 = 0 And
     C                             SMAB08 = 0 And
     C                             SRAT08 = 0 And
     C                             SPMB08 = 0 And
     C                             SSBC09 = 0 And
     C                             SSEC09 = 0 And
     C                             SMIB09 = 0 And
     C                             SMAB09 = 0 And
     C                             SRAT09 = 0 And
     C                             SPMB09 = 0 And
     C                             SSBC10 = 0 And
     C                             SSEC10 = 0 And
     C                             SMIB10 = 0 And
     C                             SMAB10 = 0 And
     C                             SRAT10 = 0 And
     C                             SPMB10 = 0 And
     C                             SORBC  = 0 And
     C                             SOPMAB = 0 And
     C                             SOMIBC = 0 And
     C                             SOMABC = 0
 
     C                   Exsr      FillMANBase
 
     C                   Else
      * Some STP values found
     C                   Exsr      FillSTPBase
     C                   Endif
 
      * MANUAL
     C                   ELSE
 
     C                   Exsr      FillMANBase
      *
     C                   ENDIF
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * FillMANBase - Fill MAN Base Ccy Array                              *
      **********************************************************************
     C     FillMANBase   Begsr
 
      * Range 1
     C                   EVAL      ZAMTCI      = SABC01
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(1) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = EABC01
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(1)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MIBC01
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(1)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MXBC01
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(1)  = ZAMTCO
 
     C                   EVAL      RateArr(1)  = RATE01
     C                   EVAL      ProArr(1)   = PMBC01
 
      * Range 2
     C                   EVAL      ZAMTCI      = SABC02
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(2) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = EABC02
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(2)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MIBC02
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(2)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MXBC02
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(2)  = ZAMTCO
 
     C                   EVAL      RateArr(2)  = RATE02
     C                   EVAL      ProArr(2)   = PMBC02
 
      * Rate 3
     C                   EVAL      ZAMTCI      = SABC03
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(3) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = EABC03
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(3)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MIBC03
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(3)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MXBC03
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(3)  = ZAMTCO
 
     C                   EVAL      RateArr(3)  = RATE03
     C                   EVAL      ProArr(3)   = PMBC03
 
      * Rate 4
     C                   EVAL      ZAMTCI      = SABC04
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(4) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = EABC04
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(4)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MIBC04
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(4)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MXBC04
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(4)  = ZAMTCO
 
     C                   EVAL      RateArr(4)  = RATE04
     C                   EVAL      ProArr(4)   = PMBC04
 
      * Rate 5
     C                   EVAL      ZAMTCI      = SABC05
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(5) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = EABC05
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(5)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MIBC05
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(5)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MXBC05
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(5)  = ZAMTCO
 
     C                   EVAL      RateArr(5)  = RATE05
     C                   EVAL      ProArr(5)   = PMBC05
 
      * Rate 6
     C                   EVAL      ZAMTCI      = SABC06
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(6) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = EABC06
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(6)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MIBC06
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(6)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MXBC06
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(6)  = ZAMTCO
 
     C                   EVAL      RateArr(6)  = RATE06
     C                   EVAL      ProArr(6)   = PMBC06
 
      * Rate 7
     C                   EVAL      ZAMTCI      = SABC07
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(7) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = EABC07
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(7)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MIBC07
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(7)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MXBC07
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(7)  = ZAMTCO
 
     C                   EVAL      RateArr(7)  = RATE07
     C                   EVAL      ProArr(7)   = PMBC07
      *
      * Rate 8
     C                   EVAL      ZAMTCI      = SABC08
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(8) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = EABC08
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(8)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MIBC08
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(8)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MXBC08
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(8)  = ZAMTCO
 
     C                   EVAL      RateArr(8)  = RATE08
     C                   EVAL      ProArr(8)   = PMBC08
 
      * Range 9
     C                   EVAL      ZAMTCI      = SABC09
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(9) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = EABC09
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(9)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MIBC09
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(9)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MXBC09
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(9)  = ZAMTCO
 
     C                   EVAL      RateArr(9)  = RATE09
     C                   EVAL      ProArr(9)   = PMBC09
 
      * Range 10
     C                   EVAL      ZAMTCI      = SABC10
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(10) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = EABC10
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(10)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MIBC10
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(10)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MXBC10
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(10)  = ZAMTCO
 
     C                   EVAL      RateArr(10)  = RATE10
     C                   EVAL      ProArr(10)   = PMBC10
      *
      * Range OB
     C                   EVAL      StartArr(11) = *Zeros
     C                   EVAL      EndArr(11)   = *Zeros
     C                   EVAL      RateArr(11)  = ORBC
     C                   EVAL      ProArr(11)   = OPMAB
 
     C                   EVAL      ZAMTCI      = OMIBC
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(11)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = OMABC
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(11)  = ZAMTCO
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * FillSTPBase - Fill STP Base Ccy Array                              *
      **********************************************************************
     C     FillSTPBase   Begsr
 
      * Range 1
     C                   EVAL      ZAMTCI      = SSBC01
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(1) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSEC01
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(1)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMIB01
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(1)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAB01
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(1)   = ZAMTCO
 
     C                   EVAL      RateArr(1)  = SRAT01
     C                   EVAL      ProArr(1)   = SPMB01
 
      * Range 2
     C                   EVAL      ZAMTCI      = SSBC02
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(2) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSEC02
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(2)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMIB02
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(2)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAB02
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(2)   = ZAMTCO
      *
     C                   EVAL      RateArr(2)  = SRAT02
     C                   EVAL      ProArr(2)   = SPMB02
 
      * Range 3
     C                   EVAL      ZAMTCI      = SSBC03
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(3) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSEC03
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(3)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMIB03
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(3)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAB03
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(3)   = ZAMTCO
 
     C                   EVAL      RateArr(3)  = SRAT03
     C                   EVAL      ProArr(3)   = SPMB03
 
      * Range 4
     C                   EVAL      ZAMTCI      = SSBC04
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(4) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSEC04
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(4)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMIB04
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(4)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAB04
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(4)   = ZAMTCO
 
     C                   EVAL      RateArr(4)  = SRAT04
     C                   EVAL      ProArr(4)   = SPMB04
 
      * Range 5
     C                   EVAL      ZAMTCI      = SSBC05
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(5) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSEC05
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(5)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMIB05
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(5)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAB05
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(5)   = ZAMTCO
 
     C                   EVAL      RateArr(5)  = SRAT05
     C                   EVAL      ProArr(5)   = SPMB05
 
      * Range 6
     C                   EVAL      ZAMTCI      = SSBC06
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(6) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSEC06
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(6)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMIB06
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(6)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAB06
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(6)   = ZAMTCO
 
     C                   EVAL      RateArr(6)  = SRAT06
     C                   EVAL      ProArr(6)   = SPMB06
 
      * Range 7
     C                   EVAL      ZAMTCI      = SSBC07
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(7) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSEC07
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(7)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMIB07
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(7)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAB07
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(7)   = ZAMTCO
 
     C                   EVAL      RateArr(7)  = SRAT07
     C                   EVAL      ProArr(7)   = SPMB07
 
      * Range 8
     C                   EVAL      ZAMTCI      = SSBC08
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(8) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSEC08
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(8)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMIB08
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(8)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAB08
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(8)   = ZAMTCO
 
     C                   EVAL      RateArr(8)  = SRAT08
     C                   EVAL      ProArr(8)   = SPMB08
 
      * Range 9
     C                   EVAL      ZAMTCI      = SSBC09
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(9) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSEC09
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(9)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMIB09
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(9)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAB09
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(9)   = ZAMTCO
 
     C                   EVAL      RateArr(9)  = SRAT09
     C                   EVAL      ProArr(9)   = SPMB09
 
      * Range 10
     C                   EVAL      ZAMTCI       = SSBC10
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(10) = ZAMTCO
 
     C                   EVAL      ZAMTCI       = SSEC10
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(10)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMIB10
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(10)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAB10
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(10)  = ZAMTCO
 
     C                   EVAL      RateArr(10)  = SRAT10
     C                   EVAL      ProArr(10)   = SPMB10
 
     C                   EVAL      StartArr(11) = *Zeros
     C                   EVAL      EndArr(11)   = *Zeros
     C                   EVAL      RateArr(11)  = SORBC
     C                   EVAL      ProArr(11)   = SOPMAB
 
     C                   EVAL      ZAMTCI      = SOMIBC
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(11)  = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SOMABC
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(11)  = ZAMTCO
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * OthRange - Load charge calculation arrays for 'Other' Ccy tiers    *
      **********************************************************************
     C     OthRange      BEGSR
 
     C                   IF        STP = 'Y'
      * If STP requested but no STP values, use manual values.
     C                   If        SSOC01 = 0 And
     C                             SEOC01 = 0 And
     C                             SRAT01 = 0 And
     C                             SMIO01 = 0 And
     C                             SMAC01 = 0 And
     C                             SSOC02 = 0 And
     C                             SEOC02 = 0 And
     C                             SRAT02 = 0 And
     C                             SMIO02 = 0 And
     C                             SMAC02 = 0 And
     C                             SSOC03 = 0 And
     C                             SEOC03 = 0 And
     C                             SRAT03 = 0 And
     C                             SMIO03 = 0 And
     C                             SMAC03 = 0 And
     C                             SSOC04 = 0 And
     C                             SEOC04 = 0 And
     C                             SRAT04 = 0 And
     C                             SMIO04 = 0 And
     C                             SMAC04 = 0 And
     C                             SSOC05 = 0 And
     C                             SEOC05 = 0 And
     C                             SRAT05 = 0 And
     C                             SMIO05 = 0 And
     C                             SMAC05 = 0 And
     C                             SSOC06 = 0 And
     C                             SEOC06 = 0 And
     C                             SRAT06 = 0 And
     C                             SMIO06 = 0 And
     C                             SMAC06 = 0 And
     C                             SSOC07 = 0 And
     C                             SEOC07 = 0 And
     C                             SRAT07 = 0 And
     C                             SMIO07 = 0 And
     C                             SMAC07 = 0 And
     C                             SSOC08 = 0 And
     C                             SEOC08 = 0 And
     C                             SRAT08 = 0 And
     C                             SMIO08 = 0 And
     C                             SMAC08 = 0 And
     C                             SSOC09 = 0 And
     C                             SEOC09 = 0 And
     C                             SRAT09 = 0 And
     C                             SMIO09 = 0 And
     C                             SMAC09 = 0 And
     C                             SSOC10 = 0 And
     C                             SEOC10 = 0 And
     C                             SRAT10 = 0 And
     C                             SMIO10 = 0 And
     C                             SMAC10 = 0 And
     C                             SORBC  = 0 And
     C                             SOMIOC = 0 And
     C                             SOMAOC = 0
 
     C                   Exsr      FillMANOther
 
     C                   Else
 
     C                   Exsr      FillSTPOther
     C                   Endif
 
     C                   ELSE
 
     C                   Exsr      FillMANOther
 
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      **********************************************************************
      * FillMANOther - Fill MAN Other Ccy Array                            *
      **********************************************************************
     C     FillMANOther  Begsr
 
     C                   EVAL      ZAMTCI      = STOC01
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(1) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = ENOC01
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(1)   = ZAMTCO
 
     C                   EVAL      RateArr(1)  = RATE01
 
     C                   EVAL      ZAMTCI      = MIOC01
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(1)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MAOC01
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(1)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = STOC02
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(2) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = ENOC02
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(2)   = ZAMTCO
 
     C                   EVAL      RateArr(2)  = RATE02
 
     C                   EVAL      ZAMTCI      = MIOC02
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(2)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MAOC02
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(2)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = STOC03
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(3) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = ENOC03
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(3)   = ZAMTCO
 
     C                   EVAL      RateArr(3)  = RATE03
 
     C                   EVAL      ZAMTCI      = MIOC03
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(3)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MAOC03
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(3)   = ZAMTCO
      *
     C                   EVAL      ZAMTCI      = STOC04
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(4) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = ENOC04
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(4)   = ZAMTCO
 
     C                   EVAL      RateArr(4)  = RATE04
 
     C                   EVAL      ZAMTCI      = MIOC04
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(4)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MAOC04
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(4)   = ZAMTCO
      *
     C                   EVAL      ZAMTCI      = STOC05
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(5) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = ENOC05
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(5)   = ZAMTCO
 
     C                   EVAL      RateArr(5)  = RATE05
 
     C                   EVAL      ZAMTCI      = MIOC05
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(5)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MAOC05
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(5)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = STOC06
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(6) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = ENOC06
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(6)   = ZAMTCO
 
     C                   EVAL      RateArr(6)  = RATE06
 
     C                   EVAL      ZAMTCI      = MIOC06
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(6)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MAOC06
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(6)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = STOC07
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(7) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = ENOC07
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(7)   = ZAMTCO
 
     C                   EVAL      RateArr(7)  = RATE07
 
     C                   EVAL      ZAMTCI      = MIOC07
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(7)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MAOC07
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(7)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = STOC08
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(8) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = ENOC08
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(8)   = ZAMTCO
 
     C                   EVAL      RateArr(8)  = RATE08
 
     C                   EVAL      ZAMTCI      = MIOC08
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(8)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MAOC08
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(8)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = STOC09
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(9) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = ENOC09
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(9)   = ZAMTCO
 
     C                   EVAL      RateArr(9)  = RATE09
 
     C                   EVAL      ZAMTCI      = MIOC09
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(9)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = MAOC09
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(9)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      =  STOC10
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(10) = ZAMTCO
 
     C                   EVAL      ZAMTCI      =  ENOC10
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(10)   = ZAMTCO
 
     C                   EVAL      RateArr(10)  = RATE10
 
     C                   EVAL      ZAMTCI      =  MIOC10
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(10)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      =  MAOC10
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(10)   = ZAMTCO
 
     C                   EVAL      StartArr(11) = *Zeros
     C                   EVAL      EndArr(11)   = *Zeros
 
     C                   EVAL      RateArr(11)  = ORBC
 
     C                   EVAL      ZAMTCI      =  OMIOC
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(11)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      =  OMAOC
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(11)   = ZAMTCO
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * FillSTPOther - Fill STP Other Ccy Array                            *
      **********************************************************************
     C     FillSTPOther  Begsr
 
     C                   EVAL      ZAMTCI      = SSOC01
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(1) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SEOC01
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(1)   = ZAMTCO
 
     C                   EVAL      RateArr(1)  = SRAT01
 
     C                   EVAL      ZAMTCI      = SMIO01
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(1)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAC01
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(1)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSOC02
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(2) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSOC02
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(2)   = SEOC02
 
     C                   EVAL      RateArr(2)  = SRAT02
 
     C                   EVAL      ZAMTCI      = SMIO02
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(2)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAC02
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(2)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSOC03
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(3) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SEOC03
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(3)   = ZAMTCO
 
     C                   EVAL      RateArr(3)  = SRAT03
 
     C                   EVAL      ZAMTCI      = SMIO03
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(3)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAC03
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(3)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSOC04
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(4) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SEOC04
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(4)   = ZAMTCO
 
     C                   EVAL      RateArr(4)  = SRAT04
 
     C                   EVAL      ZAMTCI      = SMIO04
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(4)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAC04
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(4)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSOC05
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(5) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SEOC05
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(5)   = ZAMTCO
 
     C                   EVAL      RateArr(5)  = SRAT05
 
     C                   EVAL      ZAMTCI      = SMIO05
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(5)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAC05
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(5)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSOC06
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(6) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SEOC06
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(6)   = ZAMTCO
 
     C                   EVAL      RateArr(6)  = SRAT06
 
     C                   EVAL      ZAMTCI      = SMIO06
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(6)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAC06
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(6)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSOC07
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(7) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SEOC07
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(7)   = ZAMTCO
 
     C                   EVAL      RateArr(7)  = SRAT07
 
     C                   EVAL      ZAMTCI      = SMIO07
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(7)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAC07
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(7)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSOC08
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(8) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SEOC08
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(8)   = ZAMTCO
 
     C                   EVAL      RateArr(8)  = SRAT08
 
     C                   EVAL      ZAMTCI      = SMIO08
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(8)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAC08
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(8)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SSOC09
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(9) = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SEOC09
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(9)   = ZAMTCO
 
     C                   EVAL      RateArr(9)  = SRAT09
 
     C                   EVAL      ZAMTCI      = SMIO09
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(9)   = ZAMTCO
 
     C                   EVAL      ZAMTCI      = SMAC09
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(9)   = ZAMTCO
 
     C                   EVAL      ZAMTCI       = SSOC10
     C                   Exsr      SRConvert
     C                   EVAL      StartArr(10) = ZAMTCO
 
     C                   EVAL      ZAMTCI       = SEOC10
     C                   Exsr      SRConvert
     C                   EVAL      EndArr(10)   = ZAMTCO
 
     C                   EVAL      RateArr(10)  = SRAT10
 
     C                   EVAL      ZAMTCI       = SMIO10
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(10)   = ZAMTCO
 
     C                   EVAL      ZAMTCI       = SMAC10
     C                   Exsr      SRConvert
     C                   EVAL      MaxArr(10)   = ZAMTCO
 
     C                   EVAL      StartArr(11) = *Zeros
     C                   EVAL      EndArr(11)   = *Zeros
 
     C                   EVAL      RateArr(11)  = SORBC
 
     C                   EVAL      ZAMTCI       = SOMIOC
     C                   Exsr      SRConvert
     C                   EVAL      MinArr(11)   = ZAMTCO
 
     C                   EVAL      ZAMTCI       = SOMAOC
     C                   Exsr      SRConvert
     c                   EVAL      MaxArr(11)   = ZAMTCO
      *
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * ConvToChgCcy - Convert an amount from Base/Other currency to       *
      *                Charges Currency.                                   *
      **********************************************************************
     C     ConvToChgCcy  BEGSR
 
 
     C                   Exsr      SRZxRate
 
     C                   CALLB     'ZCONVZ1'     Convert
 
     C                   If        CHGCCY = P_SettCcy
     C                   Eval      ZAMTCO = P_SettAmt
     C                   Endif
 
     C                   If        ChgCcy = P_PayCcy
     C                   Eval      ZAMTCO = P_PayAmt
     C                   Endif
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * SRConvert - Call ZCONVZ1                                           *
      **********************************************************************
     C     SRConvert     Begsr
 
     C                   CallB     'ZCONVZ1'     Convert
 
     C                   If        ZAMTCO > 9999999999999
     C                   Eval      ZAMTCO = 9999999999999
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * Calculate Pay Amount
      *****************************************************************
     C     CalcPayAmt    Begsr
 
     C                   Select
 
      * Reference currency and charge currency are the same
     C                   When      ReferenceCcy = ChgCcy
     C                   Eval      PayAmt       = ReferenceAmt
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 
      * Transaction rates are used and reference and charge currencies are equal
      *  to pay and settle currencies.
 
     C                   When      CHTRCY  = 'Y'          And
     C                             SettCcy = ReferenceCcy And
     C                             PayCcy  = ChgCcy       Or
     C                             CHTRCY  = 'Y'          And
     C                             SettCcy = ChgCcy       And
     C                             PayCcy  = ReferenceCcy
 
     C                   Eval      WorkCcy   = ReferenceCcy
     C                   Eval      CurrType  = 'R'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy   = ChgCcy
     C                   Eval      CurrType  = 'C'
     C                   Exsr      GetCcyDef
 
      * Convert reference amount to charge currency using transaction rates
 
     C                   EVAL      ZAMTCI  = ReferenceAmt
     C                   EVAL      ZAMTCO  = *Zeros
 
     C                   EVAL      ZCCYI   = ReferenceCcy
     C                   EVAL      ZCDPI   = ReferenceDP
     C                   EVAL      ZMDI1   = ReferenceMD
     C                   EVAL      ZRATE1  = ChgExch
 
     C                   EVAL      ZRATE2  = ChgSpotRate
 
     C                   EVAL      ZCCYO   = ChgCcy
     C                   EVAL      ZCDPO   = ChgCcyDP
     C                   EVAL      ZMDI2   = ChgCcyMD
 
     C                   If        ReferenceCcy = BaseCcy AND
     C                             BaseCcy      = PayCcy
     C                   Eval      ZRATE2       = 1
     C                   Else
     C                   If        ReferenceCcy = BaseCcy AND
     C                             BaseCcy      = SettCcy
     C                   Eval      ZRATE1       = 1
     C                   Endif
     C                   Endif
 
     C                   Exsr      ConvToChgCcy
 
     C                   Eval      PayAmt = ZAMTCO
 
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 
      * Transaction rates are used and reference currency is either settlement
      *  or pay currencues but the charge currency is not equal to pay or settle
      *  currency, convert to the other transaction currency using TRANSACTION rate
      *  and then to charge currency using spot rate.
 
     C                   When      CHTRCY  =  'Y'          And
     C                             SettCcy =  ReferenceCcy And
     C                             PayCcy  <> ChgCcy       Or
     C                             CHTRCY  =  'Y'          And
     C                             SettCcy <> ChgCcy       And
     C                             PayCcy  =  ReferenceCcy
 
      * Determine OTHER transaction currency
     C                   If        SettCcy = ReferenceCcy
     C                   Eval      OtherTransCcy = PayCcy
     C                   Eval      OtherTransAmt = PayAmt
     C                   Else
     C                   Eval      OtherTransCcy = SettCcy
     C                   Eval      OtherTransAmt = SettAmt
     C                   Endif
 
      * Get Currency Definitions
     C                   Eval      WorkCcy   = ReferenceCcy
     C                   Eval      CurrType  = 'R'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy   = OtherTransCcy
     C                   Eval      CurrType  = 'T'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy   = ChgCcy
     C                   Eval      CurrType  = 'C'
     C                   Exsr      GetCcyDef
 
 
      * Use TRANSACTION RATE.  Call SrZxRate to get mult / div indicator ONLY.
      *  Override rate with transaction rate. (ZRATE1).
 
     C                   Eval      ZCCYI   = OtherTransCcy
     C                   Eval      ZCCYO   = ChgCcy
      * Use rate found from previous conversion
     C                   Eval      ZRATE1  = OtherTransSpot
     C                   Eval      ZRATE2  = ChgSpotRate
     C                   Eval      ZMDI1   = OtherTransMD
     C                   Eval      ZMDI2   = ChgCcyMD
     C                   Eval      ZCDPI   = OtherTransDP
     C                   Eval      ZCDPO   = ChgCcyDP
 
     C                   Eval      ZAMTCI = OtherTransAmt
     C                   Exsr      ConvToChgCcy
     C                   Eval      PayAmt = ZAMTCO
 
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 
      * Transaction rates are used.  Charge currency is either pay or settle ccy
      *  but the reference currency is not.  Convert from reference currency to
      *  Other currency using SPOT rate and then from Other Ccy to Charge using
      *  transaction rate
 
     C                   When      CHTRCY  =  'Y'          And
     C                             SettCcy =  ChgCcy       And
     C                             PayCcy  <> ReferenceCcy Or
     C                             CHTRCY  =  'Y'          And
     C                             SettCcy <> ReferenceCcy And
     C                             PayCcy  =  ChgCcy
 
      * Determine OTHER transaction currency
     C                   If        SettCcy = ReferenceCcy
     C                   Eval      OtherTransCcy = PayCcy
     C                   Else
     C                   Eval      OtherTransCcy = SettCcy
     C                   Endif
 
      * Get Currency Definitions
     C                   Eval      WorkCcy   = ReferenceCcy
     C                   Eval      CurrType  = 'R'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy   = OtherTransCcy
     C                   Eval      CurrType  = 'T'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy   = ChgCcy
     C                   Eval      CurrType  = 'C'
     C                   Exsr      GetCcyDef
 
      * Convert from reference to other using SPOT rate
 
     C                   Eval      ZCCYI   = ReferenceCcy
     C                   Eval      ZCCYO   = OtherTransCcy
      * Use TRANSACTION RATE
     C                   Eval      ZRATE1  = ReferenceSpot
     C                   Eval      ZRATE2  = OtherTransSpot
     C                   Eval      ZMDI1   = ReferenceMD
     C                   Eval      ZMDI2   = OtherTransMD
     C                   Eval      ZCDPI   = ReferenceDP
     C                   Eval      ZCDPO   = OtherTransDP
     C                   Exsr      SRZxRate
 
     C                   Eval      ZCCYI   = OtherTransCcy
     C                   Eval      ZCCYO   = ChgCcy
 
      * Use Transaction Rate
     C                   Eval      ZRATE1  = CHGEXCH
 
     C                   Eval      ZRATE2  = ChgSpotRate
     C                   Eval      ZMDI1   = OtherTransMD
     C                   Eval      ZMDI2   = ChgCcyMD
     C                   Eval      ZCDPI   = OtherTransDP
     C                   Eval      ZCDPO   = ChgCcyDP
 
     C                   Exsr      SRZxRate
     C                   Exsr      ConvToChgCcy
     C                   Eval      PayAmt = ZAMTCO
 
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 
     C                   Other
 
      * Convert from reference to charge
 
      * Get Currency Definitions
     C                   Eval      WorkCcy   = ReferenceCcy
     C                   Eval      CurrType  = 'R'
     C                   Exsr      GetCcyDef
 
     C                   Eval      WorkCcy   = ChgCcy
     C                   Eval      CurrType  = 'C'
     C                   Exsr      GetCcyDef
 
     C                   Eval      ZRATE1  = ReferenceSpot
     C                   Eval      ZRATE2  = ChgSpotRate
     C                   Eval      ZMDI1   = ReferenceMD
     C                   Eval      ZMDI2   = ChgCcyMD
     C                   Eval      ZCDPI   = ReferenceDP
     C                   Eval      ZCDPO   = ChgCcyDP
 
     C                   Eval      ZAMTCI  = ReferenceAmt
     C                   Eval      ZCCYI   = ReferenceCcy
     C                   Eval      ZCCYO   = ChgCcy
 
     C                   Exsr      ConvToChgCcy
 
     C                   Eval      PayAmt = ZAMTCO
     C                   EndSl
      * =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 
     C                   Eval      P_PayAmt = Payamt
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * Convert Currency
      *****************************************************************
     C     SRConvCcy     Begsr
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
      *
     C                   EVAL      ZEXCH = ZRATEX
 
     C                   EVAL      ZMD   = ZMDIX
      *
      *
     C                   CALLB     'ZCONVZ1'     Convert
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRZxRate - Call ZXRATE
      *****************************************************************
     C     SRZxRate      Begsr
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
      *
     C                   EVAL      ZEXCH = ZRATEX
 
     C                   EVAL      ZMD   = ZMDIX
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Entry parameters:
     C     *ENTRY        PLIST
      *
      * INPUTS:
      ** Return Code (10A)
      ** Payment Amount (13,0)
      ** Payment Currency (3A)
      ** Charges Currency (3A)
      ** Exchange Rate from transaction (13,8)
      ** STP flag (1A)
      ** Payment Charge Code (5A)
      ** Charges to the DR of Currency (3A)                                                   CFT120
      *                                                                                       CFT120
     C                   PARM                    RetCodeIn
     C                   PARM                    P_PayAmt
     C                   PARM                    P_PayCcy
     C                   PARM                    P_SettCcy
     C                   PARM                    P_ChgCcy
     C                   PARM                    P_ChgExch
     C                   PARM                    P_STP
     C                   PARM                    P_ChargeCode
     C                   PARM                    P_SettAmt
     C                   PARM                    P_ChargesDR
     C                   PARM                    P_ADDC
     C                   PARM                    P_ChgDRCcy                                   CFT120
      *
      * OUTPUTS:
      ** Total Charge (13,0)
      ** Chargeable Amount (13,0)
      ** Charge per Tier (11 x 13A)
      ** Amount being charged by Tier (11 x 13A)
     C                   PARM                    TotInChgCcy
     C                   PARM                    ChgableAmt
     C                   PARM                    StartArr
     C                   PARM                    Endarr
     C                   PARM                    RateArr
     C                   PARM                    ProArr
     C                   PARM                    MinArr
     C                   PARM                    MaxArr
      *
      ** Move workstation ID to screen field, initialise program name
     C                   MOVEL     'CALCRANGE'   DBPGM
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   EVAL      DBASE  = 9
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Eval      BaseCcy = BJCYCD
 
      *
      * PLIST for ZCONVZ1
     C     Convert       PLIST
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
      *
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
(c) Finastra International Limited 2001
