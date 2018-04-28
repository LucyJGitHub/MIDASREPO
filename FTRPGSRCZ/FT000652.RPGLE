     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Charge Calculation Enquiry')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000652  - FEES AND CHARGES: CHARGE CALCULATION ENQUIRY     *
      *                                                               *
      *  Function:  Allows the user to see a detailed breakdown       *
      *             of any charge amount shown on one of the          *
      *             following maintenance screens: Incoming Payments, *
      *             Outgoing Payments, RFTs, CCTs, Cheques to be      *
      *             Paid/Collected.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG433             Date 05Dec05               *
      *                 CDL049             Date 06Jul06               *
      *                 221761             Date 01Apr04               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 29Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Display file
     FFT000652DFCF   E             WORKSTN
 
      * FT Payment Charge Definition
     FFTPCHGL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *       KC  Exit                                                *
      *       KL  Previous                                            *
      *                                                               *
      *       20  Tiers 7-OB displayed if on                          *
      *                                                               *
      *       80  CHAIN indicator                                     *
      *                                                               *
      *       97  ROLLDOWN                                            *
      *       98  ROLLUP                                              *
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
 
      **  13-long array element full of text zeros
     D AllZeros        C                   '0000000000000'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Array for loading tiers
     D TierArr         S             98    DIM(11)
 
      **  Charge on each tier
     D TierCharge      S             13    DIM(11)
 
      **  Chargeable Amount on each tier
     D TierAmount      S             13    DIM(11)
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Funds Transfer ICD
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Outgoing Payments file/extension file
     D OutPay        E DS                  EXTNAME(OTPAYDD)  PREFIX(O_)
     D OtPayEx       E DS                  EXTNAME(OTPAYXPD) PREFIX(O_)
 
      ** Incoming Payments file/extension file
     D InPay         E DS                  EXTNAME(INPAYDD)  PREFIX(I_)
     D InPayEx       E DS                  EXTNAME(INPAYXPD) PREFIX(I_)
 
      ** Cheques for Collection files
     D CqCoC         E DS                  EXTNAME(CQCOCDD)  PREFIX(A_)
     D CqCoD         E DS                  EXTNAME(CQCODDD)  PREFIX(B_)
 
      ** Cheques to be Paid files
     D CqPaC         E DS                  EXTNAME(CQPACDD)  PREFIX(C_)
     D CqPaD         E DS                  EXTNAME(CQPADDD)  PREFIX(D_)
 
      ** Request for Transfer files
     D FT101H        E DS                  EXTNAME(FT101HPD) PREFIX(H1)
     D FT101D        E DS                  EXTNAME(FT101DPD) PREFIX(D1)
 
      ** Customer Credit Transfer files
     D FT102H        E DS                  EXTNAME(FT102HPD) PREFIX(H2)
     D FT102D        E DS                  EXTNAME(FT102DPD) PREFIX(D2)
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
      *                                                                                       CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
 
      **  DS for loading Tier names
     D TierNames       DS
     D  STIER1
     D  STIER2
     D  STIER3
     D  STIER4
     D  STIER5
     D  STIER6
 
      **  Screen fields - Record 1
     D Record1         DS
     D   SSRT01
     D   SEND01
     D   SPRO01
     D   SMIN01
     D   SMAX01
     D   SAMT01
     D   SCHG01
 
      **  Screen fields - Record 2
     D Record2         DS
     D   SSRT02
     D   SEND02
     D   SPRO02
     D   SMIN02
     D   SMAX02
     D   SAMT02
     D   SCHG02
 
      **  Screen fields - Record 3
     D Record3         DS
     D   SSRT03
     D   SEND03
     D   SPRO03
     D   SMIN03
     D   SMAX03
     D   SAMT03
     D   SCHG03
 
      **  Screen fields - Record 4
     D Record4         DS
     D   SSRT04
     D   SEND04
     D   SPRO04
     D   SMIN04
     D   SMAX04
     D   SAMT04
     D   SCHG04
 
      **  Screen fields - Record 5
     D Record5         DS
     D   SSRT05
     D   SEND05
     D   SPRO05
     D   SMIN05
     D   SMAX05
     D   SAMT05
     D   SCHG05
 
      **  Screen fields - Record 6
     D Record6         DS
     D   SSRT06
     D   SEND06
     D   SPRO06
     D   SMIN06
     D   SMAX06
     D   SAMT06
     D   SCHG06
 
      **  Work fields (screen format)
     D X@Fields        DS
     D   X@Start               1     14
     D   X@End                15     28
     D   X@Pro                29     42
     D   X@Min                43     56
     D   X@Max                57     70
     D   X@Amt                71     84
     D   X@Chg                85     98
 
      ** Work fields used by ZXRATE
     D ZRATE1          S             13P 8
     D ZRATE2          S             13P 8
     D ZMDI1           S              1A
     D ZMDI2           S              1A
     D ZRATEX          S             13P 8
     D ZMDIX           S              1A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Transaction being charged - Main details
      **                           - Extension/secondary details
     D P_TransDet      S           3000A
     D P_TransExt      S           3000A
 
      ** Entry parameters
     D P_ChargeCde     S              5A
     D P_ChargeAmt     S             13P 0
     D P_INKC          S              1A
     D P_TransType     S              2A
     D P_ChgDRCcy      S              3A                                                      CFT120
     D SetAmt          S                   Like(O_SMAM)
 
      ** Work fields used by ZEDIT
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
 
      ** Work fields (numeric) for currency conversion
     D W@Start         S                   LIKE(SABC01)
     D W@End           S                   LIKE(EABC01)
     D W@Pro           S                   LIKE(PMBC01)
     D W@Max           S                   LIKE(MXBC01)
     D W@Min           S                   LIKE(MIBC01)
 
      ** Fields from transaction
     D PayAmt          S             13P 0
     D PayCcy          S              3A
     D ChgCcy          S              3A
     D ChgCcyDP        S                   Like(A6NBDP)
     D ChgExch         S             13P 8
     D ZEXCH           S                   Like(ChgExch)
     D STP             S              1A
     D SetCcy          S              3A
     D TransRate       S                   Like(O_RATE)
     D Levied          S                   Like(ChgCcy)
     D ChgDRCcy        S                   LIKE(P_ChgDRCcy)                                   CFT120
 
     D BaseCcyDP       S                   LIKE(A6NBDP)
     D ProFlag         S              1A
     D x               S              2P 0
 
     D P_SettAmt       S                   Like(O_SMAM)
     D P_ChargesDR     S                   Like(O_CDRO)
     D P_ADDC          S                   Like(O_ADDC)
 
     D StartArr        S             13P 0 DIM(11)
     D EndArr          S             13P 0 DIM(11)
     D RateArr         S             13P 8 DIM(11)
     D ProArr          S             13P 8 DIM(11)
     D MinArr          S             13P 0 DIM(11)
     D MaxArr          S             13P 0 DIM(11)
 
     D SavStart        S                   Like(ZField)
     D SavEnd          S                   Like(ZField)
     D SavRate         S                   Like(ZField)
     D SavPro          S                   Like(ZField)
     D SavMin          S                   Like(ZField)
     D SavMax          S                   Like(ZField)
     D SavTierAmt      S                   Like(ZField)
     D SavTierChg      S                   Like(ZField)
     D Start           S              5  0
     D End             S                   Like(Start)
      *                                                                                       CFT120
      ** For switchable feature CFT120                                                        CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
     D PRTCD           S              7                                                       CFT120
     D POPTN           S              7                                                       CFT120
     D PSard           S              6                                                       CFT120
 
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
      ** Obtain charge breakdown and calculate total charge
     C                   EXSR      InitProc
      *
      ** Display Tiers 1-6, process user action
     C                   EVAL      *IN20 = *Off
     C                   EXSR      ClearScn
     C                   EXSR      Load_1to6
     C                   WRITE     FT000652F2
      *
     C                   EXFMT     FT000652F1
      *
     C                   SELECT
      *
      ** F3 - Leave this and calling program
     C                   WHEN      *INKC = *On
     C                   EVAL      P_INKC = '1'
     C                   EVAL      *INLR = *On
     C                   RETURN
      *
      ** F12 - Return to calling program
     C                   WHEN      *INKL = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
      *
      ** Rollup - Display Tiers 7-OB
     C                   WHEN      *IN98 = *On
     C                   EVAL      *IN20 = *On
     C                   EXSR      ClearScn
     C                   EXSR      Load_7toOB
     C                   WRITE     FT000652F3
      *
     C                   DOW       *INKC = *Off  AND  *IN97 = *Off and
     C                             *INKL = *Off
     C                   EXFMT     FT000652F1
      *
     C                   SELECT
      *
      ** F3 - Leave this and calling program
     C                   WHEN      *INKC = *On
     C                   EVAL      P_INKC = '1'
     C                   EVAL      *INLR = *On
     C                   RETURN
      *
      ** F12 - Return to calling program
     C                   WHEN      *INKL = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   ENDSL
      *
      **********************************************************************
      /EJECT
      **********************************************************************
      * InitProc - Initialisation                                          *
      **********************************************************************
     C     InitProc      BEGSR
      *
      ** Clear work and screen fields
     C                   CLEAR                   TierArr
     C                   CLEAR                   TierCharge
     C                   CLEAR                   TierAmount
     C                   CLEAR                   TotInChgCcy
      *
      ** Move transaction string to appropriate data structures.
      ** Determine Payment Amount and currency.
     C                   SELECT
      *
     C                   WHEN      P_TransType = 'OP'
     C                   EVAL      OutPay  = P_TransDet
     C                   EVAL      OtPayEx = P_TransExt
     C                   EVAL      PayAmt  = O_PYAM
     C                   EVAL      SetAmt  = O_SMAM
     C                   EVAL      PayCcy  = O_PCCY
     C                   EVAL      SetCcy  = O_SMCY
     C                   EVAL      ChgCcy  = O_OPCHGC
     C                   EVAL      STP     = O_OPSTPI
     C                   Eval      P_ChargesDR = O_CDRO
     C                   Eval      P_ADDC = O_ADDC
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      P_ChgDRCcy = O_OPCDRC                                      CFT120
     C                   EVAL      ChgDRCcy = O_OPCDRC                                        CFT120
     C                   ENDIF                                                                CFT120
     C                   Eval      P_SettAmt = O_SMAM
     C                   Eval      SettCcy = O_SMCY
     C                   Eval      TransRate = O_RATE
 
      *
     C                   WHEN      P_TransType = 'IN'
     C                   EVAL      InPay   = P_TransDet
     C                   EVAL      InPayEx = P_TransExt
     C                   EVAL      PayAmt  = I_PYAM
     C                   EVAL      SetAmt  = I_SMAM
     C                   EVAL      PayCcy  = I_PCCY
     C                   EVAL      SetCcy  = I_SMCY
     C                   EVAL      ChgCcy  = I_INCHGC
     C                   EVAL      STP     = I_INSTPI
     C                   Eval      P_SettAmt = I_SMAM
     C                   Eval      P_ChargesDR = I_CDRO
     C                   Eval      P_ADDC = I_ADDC
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      P_ChgDRCcy = I_INCDRC                                      CFT120
     C                   EVAL      ChgDRCcy = I_INCDRC                                        CFT120
     C                   ENDIF                                                                CFT120
     C                   Eval      SettCcy = I_SMCY
     C                   Eval      TransRate = I_RATE
      *
     C                   WHEN      P_TransType = 'CC'
     C                   EVAL      CqCoC = P_TransDet
     C                   EVAL      CqCoD = P_TransExt
     C                   EVAL      PayAmt  = A_CQAM
     C                   EVAL      PayCcy  = B_SMCY
     C                   EVAL      ChgCcy  = A_CCCHGC
     C                   EVAL      STP     = *Blank
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      P_ChgDRCcy = *Blank                                        CFT120
     C                   EVAL      ChgDRCcy = *Blank                                          CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   WHEN      P_TransType = 'CP'
     C                   EVAL      CqPaC = P_TransDet
     C                   EVAL      CqPaD = P_TransExt
     C                   EVAL      PayAmt  = D_CQAM
     C                   EVAL      PayCcy  = C_PCCY
     C                   EVAL      ChgCcy  = D_CPCHGC
     C                   EVAL      STP     = *Blank
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      P_ChgDRCcy = *Blank                                        CFT120
     C                   EVAL      ChgDRCcy = *Blank                                          CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   WHEN      P_TransType = 'RO' OR P_TransType = 'RI'
     C                   EVAL      FT101H = P_TransDet
     C                   EVAL      FT101D = P_TransExt
     C                   EVAL      PayAmt  = D1TRNAMT
     C                   EVAL      PayCcy  = D1TRNCCY
     C                   EVAL      ChgCcy  = D1M1CHGC
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      P_ChgDRCcy = *Blank                                        CFT120
     C                   EVAL      ChgDRCcy = *Blank                                          CFT120
     C                   ENDIF                                                                CFT120
     C                   IF        D1INUSER = '*STP   '
     C                   EVAL      STP = 'Y'
     C                   ELSE
     C                   EVAL      STP = *Blank
     C                   ENDIF
      *
     C                   WHEN      P_TransType = 'BO' OR P_TransType = 'BI'
     C                   EVAL      FT102H = P_TransDet
     C                   EVAL      FT102D = P_TransExt
     C                   EVAL      PayAmt  = D2CCTAMT
     C                   EVAL      PayCcy  = D2CCTCCY
     C                   EVAL      ChgCcy  = D2M2CHGC
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      P_ChgDRCcy = *Blank                                        CFT120
     C                   EVAL      ChgDRCcy = *Blank                                          CFT120
     C                   ENDIF                                                                CFT120
     C                   IF        D2INUSER = '*STP   '
     C                   EVAL      STP = 'Y'
     C                   ELSE
     C                   EVAL      STP = *Blank
     C                   ENDIF
      *
     C                   OTHER
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = P_TransType
     C                   EXSR      *PSSR
      *
     C                   ENDSL
      *
      ** Access Charge Currency details
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      ChgCcy        @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
      * Database error
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     ChgCcy        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      ZADEC = A6NBDP
     C                   Eval      ChgCcyDP = A6NBDP
 
     C                   EVAL      ChgExch = A6SPRT
 
      * Determine LEVIED currency
     C                   Select
     C                   When      P_ChargesDR <> *Zeros
     C                   IF        CFT120 = 'Y' AND P_ChargesDR <> *BLANKS                    CFT120
     C                   IF        ChgDRCcy <> *BLANKS                                        CFT120
     C                   EVAL      Levied = ChgDRCcy                                          CFT120
     C                   ELSE                                                                 CFT120
     C                   Eval      Levied = BJCYCD
     C                   ENDIF                                                                CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      Levied = BJCYCD                                            CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   When      P_Addc = 'A'
     C                   Eval      Levied = SetCcy
     C                   When      P_Addc = 'D'
     C                   Eval      Levied = PayCcy
     C                   Endsl
 
      *  If Charges in transaction currency, move in appropriate rate.
     C                   If        CHTRCY  = 'Y'
     C                   Eval      ChgExch = TransRate
     C                   Endif
 
     C                   WRITE     FT000652F0
      *
      ** Extract Tier ranges and calculate charge for each Tier
     C                   EXSR      CalcCharges
     C                   EXSR      GetRanges
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * ClearScn - Clear tier fields                                       *
      **********************************************************************
     C     ClearScn      BEGSR
      *
     C                   EVAL      Record1 = *Blanks
     C                   EVAL      Record2 = *Blanks
     C                   EVAL      Record3 = *Blanks
     C                   EVAL      Record4 = *Blanks
     C                   EVAL      Record5 = *Blanks
     C                   EVAL      Record6 = *Blanks
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * Load_1to6 - Load fields for Tiers 1 to 6
      **********************************************************************
     C     Load_1to6     BEGSR
      *
     C                   Eval      Start = 1
     C                   Eval      End   = 6
     C                   EVAL      TierNames = ' 1 2 3 4 5 6'
     C                   Exsr      MovToDsp
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      * Load_7toOB - Load fields for Tiers 7 to OB
      ********************************************************************
     C     Load_7toOB    BEGSR
      *
     C                   Eval      Start = 7
     C                   Eval      End   = 11
     C                   EVAL      TierNames = ' 7 8 910OB  '
     C                   Exsr      MovToDsp
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      **********************************************************************
      * CalcCharges - Calculate charge for each tier
      ********************************************************************
     C     CalcCharges   BEGSR
      *
     C                   CALLB     'FT000981'
      *                            ~~~~~~~~~~
     C                   PARM                    RetCodeOut
     C                   PARM                    PayAmt
     C                   PARM                    PayCcy
     C                   PARM                    SetCcy
     C                   PARM                    ChgCcy
     C                   PARM                    ChgExch
     C                   PARM                    STP
     C                   PARM                    P_ChargeCde       5
     C                   PARM                    P_SettAmt
     C                   PARM                    P_ChargesDR
     C                   PARM                    P_ADDC
     C                   PARM                    P_ChgDRCcy                                   CFT120
     C                   PARM                    TotInChgCcy      13 0
     C                   PARM                    ChgableAmt       13 0
     C                   PARM                    TierCharge
     C                   PARM                    TierAmount
      *
      * Format Chargable Amount
     C                   Move (P)  ChgAbleAmt    ZFIELD
     C                   CallB     'ZEDIT'       P@ZEDIT
     C                   Move      ZField        SCHGABL
 
      *
      * Format Total Charge
     C                   Move (P)  TotInChgCcy   ZFIELD
     C                   CallB     'ZEDIT'       P@ZEDIT
     C                   Move      ZField        STOTAL
 
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      **********************************************************************
      * GetRanges - Obtain charge ranges in Charge Currency
      **********************************************************************
     C     GetRanges     BEGSR
      *
     C     P_ChargeCde   CHAIN     FTPCHGL0                           80
      *
      ** Database error
     C                   IF        *IN80  = *On
     C                   EVAL      DBFile = 'FTPCHGPD'
     C                   EVAL      DBASE  = 3
     C                   EVAL      DBKey  =  P_ChargeCde
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Load static fields and reset array index
     C                   EVAL      x = *Zero
     C                   EVAL      SCODE = P_ChargeCde
     C                   EVAL      SCHDESC = CHDESC
     C                   EVAL      SCHGCCY = ChgCcy
      *
      ** Display 'TIERED' or 'THRESHOLD' as appropriate
     C                   IF        STP = 'Y'
      *
     C                   IF        STPCMD  = 'H'
     C                   EVAL      SBASIS  = 'THRESHOLD'
     C                   ELSE
     C                   EVAL      SBASIS  = 'TIERED'
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        CALCMD  = 'H'
     C                   EVAL      SBASIS  = 'THRESHOLD'
     C                   ELSE
     C                   EVAL      SBASIS  = 'TIERED'
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   CallB     'FTCALCRNG'
     C                   PARM                    RetCodeIn
     C                   PARM                    PayAmt
     C                   PARM                    PayCcy
     C                   PARM                    SettCcy           3
     C                   PARM                    ChgCcy
     C                   PARM                    ChgExch
     C                   PARM                    STP
     C                   PARM                    P_ChargeCde
     C                   PARM                    P_SettAmt
     C                   PARM                    P_ChargesDR
     C                   PARM                    P_ADDC
     C                   PARM                    P_ChgDRCcy                                   CFT120
     C                   PARM                    TotInChgCcy
     C                   PARM                    ChgableAmt
     C                   PARM                    StartArr
     C                   PARM                    Endarr
     C                   PARM                    RateArr
     C                   PARM                    ProArr
     C                   PARM                    MinArr
     C                   PARM                    MaxArr
 
 
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MovToDsp - Move arrays to display
      *****************************************************************
     C     MovToDsp      Begsr
 
      * Now move data to screen
     C                   DoW       Start <= End
 
      * Move charge ccy DP to ZADEC
     C                   Eval      ZADEC = ChgCcyDP
     C                   Eval      x = Start
 
     C                   Move (P)  StartArr(x)   ZFIELD
     C                   CallB     'ZEDIT'       P@ZEDIT
     C                   Eval      SavStart    = ZFIELD
 
     C                   Move (P)  EndArr(x)     ZFIELD
     C                   CallB     'ZEDIT'       P@ZEDIT
     C                   Eval      SavEnd      = ZFIELD
 
     C                   Move (P)  MinArr(x)     ZFIELD
     C                   CallB     'ZEDIT'       P@ZEDIT
     C                   Eval      SavMin      = ZFIELD
 
     C                   Move (P)  MaxArr(x)     ZFIELD
     C                   CallB     'ZEDIT'       P@ZEDIT
     C                   Eval      SavMax      = ZFIELD
 
     C                   Move (P)  TierCharge(x) ZFIELD
     C                   CallB     'ZEDIT'       P@ZEDIT
     C                   Eval      SavTierChg  = ZFIELD
 
     C                   If        TierCharge(x) <> *Zero
     C                   Move (P)  TierAmount(x) ZFIELD
     C                   If        ProArr(x) = 0
     C                   Eval      ZADEC = ChgCcyDP
     C                   Else
     C                   Eval      ZADEC = 0
     C                   Endif
 
     C                   CallB     'ZEDIT'       P@ZEDIT
     C                   Eval      SavTierAmt  = ZFIELD
     C                   Else
     C                   Eval      SavTierAmt = *Blanks
 
     C                   Endif
      * =====================================================
 
     C                   Eval      ZADEC = 8
 
     C                   Move (P)  RateArr(x)    ZFIELD
     C                   CallB     'ZEDIT'       P@ZEDIT
     C                   Eval      SavRate     = ZFIELD
 
     C                   Move (P)  ProArr(x)     ZFIELD
     C                   CallB     'ZEDIT'       P@ZEDIT
     C                   Eval      SavPro      = ZFIELD
 
     C                   Exsr      MoveToScreen
 
     C                   Eval      Start = Start + 1
 
     C                   Enddo
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * MoveToScreen
      *****************************************************************
     C     MoveToScreen  Begsr
 
     C                   Select
     C                   When      x = 1
 
     C                   Move      SavStart      SSRT01
     C                   Move      SavEnd        SEND01
     C                   If        SavRate <> '      0.00000000'
     C                   Move      SavRate       SPRO01
     C                   Else
     C                   Move      SavPro        SPRO01
     C                   Endif
     C                   Move      SavMin        SMIN01
     C                   Move      SavMax        SMAX01
     C                   Move      SavTierAmt    SAMT01
     C                   Move      SavTierCHG    Schg01
 
     C                   When      x = 2
 
     C                   Move      SavStart      SSRT02
     C                   Move      SavEnd        SEND02
     C                   If        SavRate <> '      0.00000000'
     C                   Move      SavRate       SPRO02
     C                   Else
     C                   Move      SavPro        SPRO02
     C                   Endif
     C                   Move      SavMin        SMIN02
     C                   Move      SavMax        SMAX02
     C                   Move      SavTierAmt    SAMT02
     C                   Move      SavTierCHG    Schg02
 
     C                   When      x = 3
 
     C                   Move      SavStart      SSRT03
     C                   Move      SavEnd        SEND03
     C                   If        SavRate <> '      0.00000000'
     C                   Move      SavRate       SPRO03
     C                   Else
     C                   Move      SavPro        SPRO03
     C                   Endif
     C                   Move      SavMin        SMIN03
     C                   Move      SavMax        SMAX03
     C                   Move      SavTierAmt    SAMT03
     C                   Move      SavTierCHG    Schg03
 
     C                   When      x = 4
 
     C                   Move      SavStart      SSRT04
     C                   Move      SavEnd        SEND04
     C                   If        SavRate <> '      0.00000000'
     C                   Move      SavRate       SPRO04
     C                   Else
     C                   Move      SavPro        SPRO04
     C                   Endif
     C                   Move      SavMin        SMIN04
     C                   Move      SavMax        SMAX04
     C                   Move      SavTierAmt    SAMT04
     C                   Move      SavTierCHG    Schg04
 
     C                   When      x = 5
 
     C                   Move      SavStart      SSRT05
     C                   Move      SavEnd        SEND05
     C                   If        SavRate <> '      0.00000000'
     C                   Move      SavRate       SPRO05
     C                   Else
     C                   Move      SavPro        SPRO05
     C                   Endif
     C                   Move      SavMin        SMIN05
     C                   Move      SavMax        SMAX05
     C                   Move      SavTierAmt    SAMT05
     C                   Move      SavTierCHG    Schg05
 
     C                   When      x = 6
 
     C                   Move      SavStart      SSRT06
     C                   Move      SavEnd        SEND06
     C                   If        SavRate <> '      0.00000000'
     C                   Move      SavRate       SPRO06
     C                   Else
     C                   Move      SavPro        SPRO06
     C                   Endif
     C                   Move      SavMin        SMIN06
     C                   Move      SavMax        SMAX06
     C                   Move      SavTierAmt    SAMT06
     C                   Move      SavTierCHG    Schg06
 
     C                   When      x = 7
 
     C                   Move      SavStart      SSRT01
     C                   Move      SavEnd        SEND01
     C                   If        SavRate <> '      0.00000000'
     C                   Move      SavRate       SPRO01
     C                   Else
     C                   Move      SavPro        SPRO01
     C                   Endif
     C                   Move      SavMin        SMIN01
     C                   Move      SavMax        SMAX01
     C                   Move      SavTierAmt    SAMT01
     C                   Move      SavTierCHG    Schg01
 
     C                   When      x = 8
 
     C                   Move      SavStart      SSRT02
     C                   Move      SavEnd        SEND02
     C                   If        SavRate <> '      0.00000000'
     C                   Move      SavRate       SPRO02
     C                   Else
     C                   Move      SavPro        SPRO02
     C                   Endif
     C                   Move      SavMin        SMIN02
     C                   Move      SavMax        SMAX02
     C                   Move      SavTierAmt    SAMT02
     C                   Move      SavTierCHG    Schg02
 
     C                   When      x = 9
 
     C                   Move      SavStart      SSRT03
     C                   Move      SavEnd        SEND03
     C                   If        SavRate <> '      0.00000000'
     C                   Move      SavRate       SPRO03
     C                   Else
     C                   Move      SavPro        SPRO03
     C                   Endif
     C                   Move      SavMin        SMIN03
     C                   Move      SavMax        SMAX03
     C                   Move      SavTierAmt    SAMT03
     C                   Move      SavTierCHG    Schg03
 
     C                   When      x = 10
 
     C                   Move      SavStart      SSRT04
     C                   Move      SavEnd        SEND04
     C                   If        SavRate <> '      0.00000000'
     C                   Move      SavRate       SPRO04
     C                   Else
     C                   Move      SavPro        SPRO04
     C                   Endif
     C                   Move      SavMin        SMIN04
     C                   Move      SavMax        SMAX04
     C                   Move      SavTierAmt    SAMT04
     C                   Move      SavTierCHG    Schg04
 
     C                   When      x = 11
 
     C                   Move      SavStart      SSRT05
     C                   Move      SavEnd        SEND05
     C                   If        SavRate <> '      0.00000000'
     C                   Move      SavRate       SPRO05
     C                   Else
     C                   Move      SavPro        SPRO05
     C                   Endif
     C                   Move      SavMin        SMIN05
     C                   Move      SavMax        SMAX05
     C                   Move      SavTierAmt    SAMT05
     C                   Move      SavTierCHG    Schg05
 
     C                   Move      *Blanks       SSRT05
     C                   Move      *Blanks       SEND05
 
     C                   Endsl
 
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
      ** Return Code (10A)
      ** Transaction - Main file
      ** Transaction - Extension file
      ** Transaction Type (2A)
      ** Payment Charge Code (5A)
      ** F3 key (1A)
     C                   PARM                    RetCodeIn
     C                   PARM                    P_TransDet
     C                   PARM                    P_TransExt
     C                   PARM                    P_TransType
     C                   PARM                    P_ChargeCde
     C                   PARM                    P_INKC
      *
      ** Move workstation ID to screen field, initialise program name
     C                   MOVEL     'FT000652'    DBPGM
     C                   MOVEL     PsJobName     SWID
     C                   MOVEL     PsUser        SUSER
      *
      ** Parameter list for ZEDIT
     C     P@ZEDIT       PLIST
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
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
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get details for Base Currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BJCYCD        @CCY
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
      * Database error
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     BJCYCD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Save no. of decimal places of Base Currency
     C                   EVAL      BaseCcyDP = A6NBDP
      *
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
     C                   MOVEL     '005'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *                                                                                       CFT120
      ** Check if CFT120 is switched on                                                       CFT120
      *                                                                                       CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRTCD                                        CFT120
     C                   PARM      '*VERIFY'     POPTN                                        CFT120
     C                   PARM      'CFT120'      PSARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        PRTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C                   IF        PRTCD <> '*NRF '                                           CFT120
      *                                                                                       CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 006                                                CFT120
     C                   EXSR      *PSSR                                                      CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
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
(c) Misys International Banking Systems Ltd. 2001
