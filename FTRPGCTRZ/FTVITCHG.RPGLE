     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP total charges')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVITCHG - Validate Total Charges                            *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD047369A          Date 24Jan18               *      
      *  Prev Amend No. MD047884           Date 25Sep17               *
      *                 MD047369           Date 30Aug17               *
      *                 MD046248           Date 27Oct17               *
      *                 CFT157             Date 29Aug14               *
      *                 MD025111           Date 10May14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16620           Date 12Mar08               *
      *                 249756             Date 19Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 213950             Date 26Feb03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD047369A - Funds transfter does not check block Dr flag on  *
      *              beneficary customer account.                     *
      *  MD047884 - Error in IPAY insert when Add/Deduct Charges      *
      *             Indicator is Add and Charges to the Debit of A/c  *
      *             is blocked debit.                                 *
      *  MD047369 - Funds transfter does not check block Dr flag on   *
      *             beneficary customer account.                      *      
      *  MD046248 - Finastra Rebranding                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  MD025111 - Incoming payment without charges is not allowed   *
      *             if the account is blocked for DR                  *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16620 - Net Settle Value Field is empty in the Charges    *
      *             Details 2 tab                                     *
      *           - After authorisation, currency in 'Charges In'     *
      *             column 2 changes                                  *
      *  249756 - PCharges are the defined default charges and should *
      *           not be recomputed based on screen fields as these   *
      *           have been previously validated on previous modules. *
      *           For this module, validate if the total charges      *
      *           is correct.                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  213950 - Database error 003 in FT module. Check if CFT009    *
      *           is on before calling FTCALCLEV.                     *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     D*NwIP4ScnFmt***E*DS*****             EXTNAME(FTIPY4PD)                    CFT009
     D NwIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)                    CFT009
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *                                                                         CFT009
      ** Incoming Payments (additional details) for file update                 CFT009
     D NWIP2FILFMT   E DS                  EXTNAME(FTVIPY2PD)                   CFT009
      *
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     D*FTEIPY3****   E DS                  EXTNAME(FTEIPY3PD)                   CFT014
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT014
     D FTEIPY4       E DS                  EXTNAME(FTEIPY4PD)                   CFT014
      *
      ** Data structure for Screen Charges Amount fields
     D*PCharges********DS           108                                         CFT009
     D**DDTRCM**************** 1     12                                         CFT009
     D**DDTXCH****************13     24                                         CFT009
     D**DDCQCH****************25     36                                         CFT009
     D**DDADCH****************37     48                                         CFT009
     D**DDTLCH****************49     60                                         CFT009
     D**DDMSCH****************61     72                                         CFT009
     D**DDCHCM****************73     84                                         CFT009
     D**DDVATT****************85     96                                         CFT009
     D**DDVATD****************97    108                                         CFT009
     D PCharges        DS           196                                         CFT009
     D  DDTRCM                 1     14                                         CFT009
     D  DDTXCH                15     28                                         CFT009
     D  DDCQCH                29     42                                         CFT009
     D  DDADCH                43     56                                         CFT009
     D  DDTLCH                57     70                                         CFT009
     D  DDMSCH                71     84                                         CFT009
     D  DDCHCM                85     98                                         CFT009
     D  DDVATT                99    112                                         CFT009
     D  DDVATD               113    126                                         CFT009
     D  M1CH                 127    140                                         CFT009
     D  M2CH                 141    154                                         CFT009
     D  M3CH                 155    168                                         CFT009
     D  M4CH                 169    182                                         CFT009
     D  M5CH                 183    196                                         CFT009
      *
      /COPY FTCPYSRC,FT0010D001
      *
     D D#DTA           DS           256
      *
      ** From Currency & amount
     D  D#FCCY                 1      3
     D  D#FAMT                 4     11P 0
      *
      ** To Currency & amount
     D  D#TCCY                12     14
     D  D#TAMT                15     22P 0
                                                                                CFT009
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                    CFT009
      ** Externally described DS for Funds Transfer ICD details                 CFT009
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    CFT009
      ** Externally described DS for Bank details                               CFT009
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CFT009
      ** DS for Access Objects - short data structure                           CFT009
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
      *
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
     D Wix             S              3P 0                                                 MD047369A
      *
      ** Error message array
     D WMsgArr         S             20    DIM(1) CTDATA PERRCD(1)
      *
      ** Network of message being processed.
     D W#NWRK          S              5
      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
     D PSard           S              6                                                       CFT120
     D CHACDrBlck      S              1A                                                    MD047884
     D BENEDrRefd      S              1A                                                   MD047369A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
     C                   Eval      WFldNmXAr = *Blanks                                     MD047369A
     C                   Eval      WMsgIDXAr  = *Blanks                                    MD047369A
     C                   Eval      WMsgDtXAr = *Blanks                                     MD047369A
     C                   Eval      WIx = 0                                                 MD047369A
      *
      ** Initialise display fields.
     C**********         EVAL      DDTRCM = *BLANKS                                           249756
     C**********         EVAL      DDTXCH = *BLANKS                                           249756
     C**********         EVAL      DDCQCH = *BLANKS                                           249756
     C**********         EVAL      DDADCH = *BLANKS                                           249756
     C**********         EVAL      DDTLCH = *BLANKS                                           249756
     C**********         EVAL      DDMSCH = *BLANKS                                           249756
     C**********         EVAL      DDCHCM = *BLANKS                                           249756
     C**********         EVAL      DDVATD = *BLANKS                                           249756
     C**********         EVAL      DDVATT = *BLANKS                                           249756
     C                   EVAL      DDTRCM = *BLANKS                                         BUG16620
     C                   EVAL      DDTXCH = *BLANKS                                         BUG16620
     C                   EVAL      DDCQCH = *BLANKS                                         BUG16620
     C                   EVAL      DDADCH = *BLANKS                                         BUG16620
     C                   EVAL      DDTLCH = *BLANKS                                         BUG16620
     C                   EVAL      DDMSCH = *BLANKS                                         BUG16620
     C                   EVAL      DDCHCM = *BLANKS                                         BUG16620
     C                   EVAL      DDVATD = *BLANKS                                         BUG16620
     C                   EVAL      DDVATT = *BLANKS                                         BUG16620
      *                                                                         CFT009
      ** Access Funds Transfer ICD details.                                     CFT009
      *                                                                         CFT009
     C                   CALL      'AOFTFRR0'                                   CFT009
     C                   PARM      *BLANKS       PRTCD             7            CFT009
     C                   PARM      '*FIRST '     POPTN             7            CFT009
     C     SDFTFR        PARM      SDFTFR        DSFDY                          CFT009
      *                                                                         CFT009
      ** Access Bank details.                                                   CFT009
      *                                                                         CFT009
     C                   CALLB     'AOBANKR0'                                   CFT009
     C                   PARM      *BLANKS       PRTCD             7            CFT009
     C                   PARM      '*FIRST '     POPTN             7            CFT009
     C     SDBANK        PARM      SDBANK        DSFDY                          CFT009
      *                                                                         CFT009
      ** Get Input Charge Currency.                                             CFT009
      *                                                                         CFT009
     C                   SELECT                                                 CFT009
      *                                                                         CFT009
     C     DDCDRO        WHENNE    *BLANKS                                                    CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C                   IF        DDCDRC = *BLANKS                                           CFT120
     C                   EVAL      PCharge_ccy = BJCYCD                                       CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      PCharge_ccy = DDCDRC                                       CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C     BTCHCY        WHENEQ    'B'                                          CFT009
     C     DDCDRO        ORNE      *BLANKS                                      CFT009
     C     CFT120        ANDEQ     'N'                                                        CFT120
     C                   MOVEL     BJCYCD        PCharge_ccy                    CFT009
      *                                                                         CFT009
     C     BTCHCY        WHENEQ    'L'                                          CFT009
     C                   MOVEL     BJLCCY        PCharge_Ccy                    CFT009
      *                                                                         CFT009
     C     BTCHCY        WHENEQ    'F'                                          CFT009
     C                   MOVEL     FCHCCY        PCharge_Ccy                    CFT009
      *                                                                         CFT009
     C     BTCHCY        WHENEQ    'C'                                          CFT009
     C     IPADDC        ANDEQ     'A'                                          CFT009
     C                   MOVEL     IPSMCY        PCharge_Ccy                    CFT009
      *                                                                         CFT009
     C                   OTHER                                                  CFT009
     C                   MOVEL     IPPCCY        PCharge_Ccy                    CFT009
      *                                                                         CFT009
     C                   ENDSL                                                  CFT009
      *
      ** Validate Total Charges
      *
     C                   EXSR      SRValTotChg
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKTRCD = 'N' or
     C                             OKTXCD = 'N' or
     C                             OKCQCD = 'N' or
     C                             OKADCD = 'N' or
     C                             OKTLCD = 'N' or
     C                             OKMSCD = 'N' or
     C                             OKCHCD = 'N'
     C                             OR OKM1CD = 'N'                              CFT009
     C                             OR OKM2CD = 'N'                              CFT009
     C                             OR OKM3CD = 'N'                              CFT009
     C                             OR OKM4CD = 'N'                              CFT009
     C                             OR OKM5CD = 'N'                              CFT009
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALTRCD - Calculate Transfer Commission Charges            *
      *                                                               *
      *****************************************************************
     C     SRCalTrCd     BEGSR
      *
     C                   IF        IPDUMA1 <> 0
      *
     C                   IF        CEU006 = 'Y'
     C                             AND CFT009 = 'N'                             CFT009
      *
      ** If EMU FT Enhancement is switched on then call FT0010
      *
     C                   CLEAR                   P#0010
     C                   MOVE      PICCY         P#FRCY
     C                   Z-ADD     IPDUMA1       P#FRAM
     C                   Z-ADD     PVDates       P#FRDT
     C                   MOVE      POCCY         P#TOCY
     C                   Z-ADD     PVDates       P#TODT
     C                   EXSR      SRFT10
     C                   Z-ADD     P#TOAM        IPTRCM
      *
     C                   ELSE
      *
     C                   CLEAR                   D#DTA
     C                   MOVE      IPDUMA1       D#FAMT
     C                   MOVEL     PICCY         D#FCCY
     C                   MOVEL     POCCY         D#TCCY
      *
      ** Change to use FTCALCLEV                                                CFT009
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN             7            CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT             8            CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA           256            CFT009
                                                                                CFT009
     C                   If        CFT009 = 'N'                                               213950
      *                                                                                       213950
     C                   CALL      'AOCCYCV0'                           9090                  213950
     C                   PARM      *Blanks       P#RTN             7                          213950
     C                   PARM      '*F*T*SPT'    P0ACT             8                          213950
     C     D#DTA         PARM      D#DTA         P#DTA           256                          213950
      *                                                                                       213950
     C                   If        *IN90 = *On or                                             213950
     C                             P#RTN <> *Blanks                                           213950
     C                   MOVEL     'FTVITCHG'    DBPGM                                        213950
     C                   MOVEL     'AOCCYCV0'    DBFILE                                       213950
     C                   MOVEL     '02'          DBASE                                        213950
     C                   MOVEL     '*CALL'       DBKEY                                        213950
     C                   EXSR      *PSSR                                                      213950
     C                   EndIf                                                                213950
      *                                                                                       213950
     C                   Z-ADD     D#TAMT        IPTRCM                                       213950
     C                   Else                                                                 213950
      *                                                                                       213950
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      IPDUMA1       PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-ADD     PLev_Charge   IPTRCM                         CFT009
      *
     C                   Endif                                                                213950
      *                                                                                       213950
     C***********        If        *IN90 = *On or                               CFT009
     C***********                  P#RTN <> *Blanks                             CFT009
     C***********        MOVEL     'FTVITOTCHG'  DBPGM                          CFT009
     C***********        MOVEL     'AOCCYCV0'    DBFILE                         CFT009
     C***********        MOVEL     '02'          DBASE                          CFT009
     C***********        MOVEL     '*CALL'       DBKEY                          CFT009
     C***********        EXSR      *PSSR                                        CFT009
     C***********        EndIf                                                  CFT009
      *
     C***********        Z-ADD     D#TAMT        IPTRCM                         CFT009
      *
     C                   ENDIF
      *
      ** Format field for Display
     C                   Z-ADD     IPTRCM        PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C**********         MOVE      PFMTOUT       DDTRCM                                       249756
     C                   MOVE      PFMTOUT       DDTRCM                                     BUG16620
      *
     C                   ENDIF
      *
     C                   Z-ADD     IPTRCM        TTLCHG           13 0
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALTXCD - Calculate Telex Charge                           *
      *                                                               *
      *****************************************************************
     C     SRCalTxCd     BEGSR
      *
     C                   IF        IPDUMA2 <> 0
      *
     C                   IF        CEU006 = 'Y'
     C                             AND CFT009 = 'N'                             CFT009
      *
      ** If EMU FT Enhancement is switched on then call FT0010
      *
     C                   CLEAR                   P#0010
     C                   MOVE      PICCY         P#FRCY
     C                   Z-ADD     IPDUMA2       P#FRAM
     C                   Z-ADD     PVDates       P#FRDT
     C                   MOVE      POCCY         P#TOCY
     C                   Z-ADD     PVDates       P#TODT
     C                   EXSR      SRFT10
     C                   Z-ADD     P#TOAM        IPTXCH
      *
     C                   ELSE
      *
     C                   CLEAR                   D#DTA
     C                   MOVE      IPDUMA2       D#FAMT
     C                   MOVEL     PICCY         D#FCCY
     C                   MOVEL     POCCY         D#TCCY
      *
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN                          CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT                          CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA                          CFT009
      *                                                                                       213950
     C     CFT009        IFEQ      'N'                                                        213950
      *                                                                                       213950
     C                   CALL      'AOCCYCV0'                           9090                  213950
     C                   PARM      *BLANKS       P#RTN             7                          213950
     C                   PARM      '*F*T*SPT'    P0ACT             8                          213950
     C     D#DTA         PARM      D#DTA         P#DTA           256                          213950
      *                                                                                       213950
     C     *IN90         IFEQ      '1'                                                        213950
     C     P#RTN         ORNE      *BLANKS                                                    213950
     C                   MOVEL     'FTVITCHG'    DBPGM                                        213950
     C                   MOVEL     'AOCCYCV0'    DBFILE                                       213950
     C                   MOVEL     '03'          DBASE                                        213950
     C                   MOVEL     '*CALL'       DBKEY                                        213950
     C                   EXSR      *PSSR                                                      213950
     C                   ENDIF                                                                213950
      *                                                                                       213950
     C                   Z-ADD     D#TAMT        IPTXCH                                       213950
     C                   ELSE                                                                 213950
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      IPDUMA2       PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-ADD     PLev_Charge   IPTXCH                         CFT009
      *                                                                                       213950
     C                   ENDIF                                                                213950
      *
     C***********        If        *IN90 = *On or                               CFT009
     C***********                  P#RTN <> *Blanks                             CFT009
     C***********        MOVEL     'FTVITOTCHG'  DBPGM                          CFT009
     C***********        MOVEL     'AOCCYCV0'    DBFILE                         CFT009
     C***********        MOVEL     '03'          DBASE                          CFT009
     C***********        MOVEL     '*CALL'       DBKEY                          CFT009
     C***********        EXSR      *PSSR                                        CFT009
     C***********        EndIf                                                  CFT009
      *
     C***********        Z-ADD     D#TAMT        IPTXCH                         CFT009
      *                                                                   CEU006
     C                   ENDIF
      *
      ** Format field for Display
     C                   Z-ADD     IPTXCH        PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C**********         MOVE      PFMTOUT       DDTXCH                                       249756
     C                   MOVE      PFMTOUT       DDTXCH                                     BUG16620
      *
     C                   ENDIF
      *
     C                   ADD       IPTXCH        TTLCHG
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALCQCD - Calculate Cheque Charge                          *
      *                                                               *
      *****************************************************************
     C     SRCalCqCd     BEGSR
      *
     C                   IF        IPDUMA3 <> 0
      *
     C                   IF        CEU006 = 'Y'
     C                             AND CFT009 = 'N'                             CFT009
      *
      ** If EMU FT Enhancement is switched on then call FT0010
      *
     C                   CLEAR                   P#0010
     C                   MOVE      PICCY         P#FRCY
     C                   Z-ADD     IPDUMA3       P#FRAM
     C                   Z-ADD     PVDates       P#FRDT
     C                   MOVE      POCCY         P#TOCY
     C                   Z-ADD     PVDates       P#TODT
     C                   EXSR      SRFT10
     C                   Z-ADD     P#TOAM        IPCQCH
      *
     C                   ELSE
      *
     C                   CLEAR                   D#DTA
     C                   MOVE      IPDUMA3       D#FAMT
     C                   MOVEL     PICCY         D#FCCY
     C                   MOVEL     POCCY         D#TCCY
      *
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN                          CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT                          CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA                          CFT009
      *                                                                                       213950
     C     CFT009        IFEQ      'N'                                                        213950
      *                                                                                       213950
     C                   CALL      'AOCCYCV0'                           9090                  213950
     C                   PARM      *BLANKS       P#RTN                                        213950
     C                   PARM      '*F*T*SPT'    P0ACT                                        213950
     C     D#DTA         PARM      D#DTA         P#DTA                                        213950
      *                                                                                       213950
     C     *IN90         IFEQ      '1'                                                        213950
     C     P#RTN         ORNE      *BLANKS                                                    213950
     C                   MOVEL     'FTVITCHG'    DBPGM                                        213950
     C                   MOVEL     'AOCCYCV0'    DBFILE                                       213950
     C                   MOVEL     '04'          DBASE                                        213950
     C                   MOVEL     '*CALL'       DBKEY                                        213950
     C                   EXSR      *PSSR                                                      213950
     C                   ENDIF                                                                213950
      *                                                                                       213950
     C                   Z-ADD     D#TAMT        IPCQCH                                       213950
     C                   ELSE                                                                 213950
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      IPDUMA3       PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-ADD     PLev_Charge   IPCQCH                         CFT009
      *                                                                                       213950
     C                   ENDIF                                                                213950
      *
     C***********        If        *IN90 = *On or                               CFT009
     C***********                  P#RTN <> *Blanks                             CFT009
     C***********        MOVEL     'FTVITOTCHG'  DBPGM                          CFT009
     C***********        MOVEL     'AOCCYCV0'    DBFILE                         CFT009
     C***********        MOVEL     '04'          DBASE                          CFT009
     C***********        MOVEL     '*CALL'       DBKEY                          CFT009
     C***********        EXSR      *PSSR                                        CFT009
     C***********        ENDIF                                                  CFT009
      *
     C***********        Z-ADD     D#TAMT        IPCQCH                         CFT009
      *
     C                   ENDIF
      *
      ** Format field for Display
     C                   Z-ADD     IPCQCH        PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C**********         MOVE      PFMTOUT       DDCQCH                                       249756
     C                   MOVE      PFMTOUT       DDCQCH                                     BUG16620
      *
     C                   ENDIF
      *
     C                   ADD       IPCQCH        TTLCHG
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALADCD - Calculate Advice Charge                          *
      *                                                               *
      *****************************************************************
     C     SRCalAdCd     BEGSR
      *
     C                   IF        IPDUMA4 <> 0
      *
     C                   IF        CEU006 = 'Y'
     C                             AND CFT009 = 'N'                             CFT009
      *
      ** If EMU FT Enhancement is switched on then call FT0010
      *
     C                   CLEAR                   P#0010
     C                   MOVE      PICCY         P#FRCY
     C                   Z-ADD     IPDUMA4       P#FRAM
     C                   Z-ADD     PVDates       P#FRDT
     C                   MOVE      POCCY         P#TOCY
     C                   Z-ADD     PVDates       P#TODT
     C                   EXSR      SRFT10
     C                   Z-ADD     P#TOAM        IPADCH
      *
     C                   ELSE
      *
     C                   CLEAR                   D#DTA
     C                   MOVE      IPDUMA4       D#FAMT
     C                   MOVEL     PICCY         D#FCCY
     C                   MOVEL     POCCY         D#TCCY
      *
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN                          CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT                          CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA                          CFT009
      *                                                                                       213950
     C     CFT009        IFEQ      'N'                                                        213950
      *                                                                                       213950
     C                   CALL      'AOCCYCV0'                           9090                  213950
     C                   PARM      *BLANKS       P#RTN                                        213950
     C                   PARM      '*F*T*SPT'    P0ACT                                        213950
     C     D#DTA         PARM      D#DTA         P#DTA                                        213950
      *                                                                                       213950
     C     *IN90         IFEQ      '1'                                                        213950
     C     P#RTN         ORNE      *BLANKS                                                    213950
     C                   MOVEL     'FTVITCHG'    DBPGM                                        213950
     C                   MOVEL     'AOCCYCV0'    DBFILE                                       213950
     C                   MOVEL     '05'          DBASE                                        213950
     C                   MOVEL     '*CALL'       DBKEY                                        213950
     C                   EXSR      *PSSR                                                      213950
     C                   ENDIF                                                                213950
      *                                                                                       213950
     C                   Z-ADD     D#TAMT        IPADCH                                       213950
     C                   ELSE                                                                 213950
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      IPDUMA4       PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-ADD     PLev_Charge   IPADCH                         CFT009
      *                                                                                       213950
     C                   ENDIF                                                                213950
      *
     C***********        If        *IN90 = *On or                               CFT009
     C***********                  P#RTN <> *Blanks                             CFT009
     C***********        MOVEL     'FTVITOTCHG'  DBPGM                          CFT009
     C***********        MOVEL     'AOCCYCV0'    DBFILE                         CFT009
     C***********        MOVEL     '05'          DBASE                          CFT009
     C***********        MOVEL     '*CALL'       DBKEY                          CFT009
     C***********        EXSR      *PSSR                                        CFT009
     C***********        EndIf                                                  CFT009
      *
     C***********        Z-ADD     D#TAMT        IPADCH                         CFT009
      *
     C                   ENDIF
      *
      ** Format field for Display
     C                   Z-ADD     IPADCH        PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C**********         MOVE      PFMTOUT       DDADCH                                       249756
     C                   MOVE      PFMTOUT       DDADCH                                     BUG16620
      *
     C                   ENDIF
      *
     C                   ADD       IPADCH        TTLCHG
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALTLCD - Calculate Telephone Charge                       *
      *                                                               *
      *****************************************************************
     C     SRCalTlCd     BEGSR
      *
     C                   IF        IPDUMA5 <> 0
      *
     C                   IF        CEU006 = 'Y'
     C                             AND CFT009 = 'N'                             CFT009
      *
      ** If EMU FT Enhancement is switched on then call FT0010
      *
     C                   CLEAR                   P#0010
     C                   MOVE      PICCY         P#FRCY
     C                   Z-ADD     IPDUMA5       P#FRAM
     C                   Z-ADD     PVDates       P#FRDT
     C                   MOVE      POCCY         P#TOCY
     C                   Z-ADD     PVDates       P#TODT
     C                   EXSR      SRFT10
     C                   Z-ADD     P#TOAM        IPTLCH
      *
     C                   ELSE
      *
     C                   CLEAR                   D#DTA
     C                   MOVE      IPDUMA5       D#FAMT
     C                   MOVEL     PICCY         D#FCCY
     C                   MOVEL     POCCY         D#TCCY
      *
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN             7            CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT             8            CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA           256            CFT009
      *                                                                                       213950
     C     CFT009        IFEQ      'N'                                                        213950
      *                                                                                       213950
     C                   CALL      'AOCCYCV0'                           9090                  213950
     C                   PARM      *BLANKS       P#RTN             7                          213950
     C                   PARM      '*F*T*SPT'    P0ACT             8                          213950
     C     D#DTA         PARM      D#DTA         P#DTA           256                          213950
      *                                                                                       213950
     C     *IN90         IFEQ      '1'                                                        213950
     C     P#RTN         ORNE      *BLANKS                                                    213950
     C                   MOVEL     'FTVITCHG'    DBPGM                                        213950
     C                   MOVEL     'AOCCYCV0'    DBFILE                                       213950
     C                   MOVEL     '06'          DBASE                                        213950
     C                   MOVEL     '*CALL'       DBKEY                                        213950
     C                   EXSR      *PSSR                                                      213950
     C                   ENDIF                                                                213950
      *                                                                                       213950
     C                   Z-ADD     D#TAMT        IPTLCH                                       213950
     C                   ELSE                                                                 213950
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      IPDUMA5       PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-ADD     PLev_Charge   IPTLCH                         CFT009
      *                                                                                       213950
     C                   ENDIF                                                                213950
      *
     C***********        If        *IN90 = *On or                               CFT009
     C***********                  P#RTN <> *Blanks                             CFT009
     C***********        MOVEL     'FTVITOTCHG'  DBPGM                          CFT009
     C***********        MOVEL     'AOCCYCV0'    DBFILE                         CFT009
     C***********        MOVEL     '06'          DBASE                          CFT009
     C***********        MOVEL     '*CALL'       DBKEY                          CFT009
     C***********        EXSR      *PSSR                                        CFT009
     C***********        EndIf                                                  CFT009
      *
     C***********        Z-ADD     D#TAMT        IPTLCH                         CFT009
      *
     C                   ENDIF
      *
      ** Format field for Display
     C                   Z-ADD     IPTLCH        PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C**********         MOVE      PFMTOUT       DDTLCH                                       249756
     C                   MOVE      PFMTOUT       DDTLCH                                     BUG16620
      *
     C                   ENDIF
      *
     C                   ADD       IPTLCH        TTLCHG
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALMSCD - Calculate Miscellaneous Charge                   *
      *                                                               *
      *****************************************************************
     C     SRCalMsCd     BEGSR
      *
     C                   IF        IPDUMA6 <> 0
      *
     C                   IF        CEU006 = 'Y'
     C                             AND CFT009 = 'N'                             CFT009
      *
      ** If EMU FT Enhancement is switched on then call FT0010
      *
     C                   CLEAR                   P#0010
      *
     C                   If        W#NWRK = 'CASHV8'
     C                   MOVEL     POCCY         P#FRCY
     C                   MOVEL     PICCY         P#TOCY
     C                   Else
     C                   MOVEL     PICCY         P#FRCY
     C                   MOVEL     POCCY         P#TOCY
     C                   EndIf
      *
     C                   Z-ADD     IPDUMA6       P#FRAM
     C                   Z-ADD     PVDates       P#FRDT
     C                   Z-ADD     PVDates       P#TODT
      *
     C                   EXSR      SRFT10
      *
     C                   If        W#NWRK = 'CASHV8'
     C                   Z-ADD     IPDUMA6       IPMSCH
     C                   Z-ADD     P#TOAM        IPDUMA6
     C                   Else
     C                   Z-ADD     P#TOAM        IPMSCH
     C                   EndIf
      *
     C                   ELSE
      *
     C                   CLEAR                   D#DTA
     C                   MOVE      IPDUMA6       D#FAMT
      *
     C                   If        W#NWRK = 'CASHV8'
     C                   MOVEL     POCCY         D#FCCY
     C                   MOVEL     PICCY         D#TCCY
     C                   Else
     C                   MOVEL     PICCY         D#FCCY
     C                   MOVEL     POCCY         D#TCCY
     C                   EndIf
      *
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN                          CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT                          CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA                          CFT009
                                                                                CFT009
     C     CFT009        IFEQ      'N'                                                        213950
      *                                                                                       213950
     C                   CALL      'AOCCYCV0'                           9090                  213950
     C                   PARM      *BLANKS       P#RTN                                        213950
     C                   PARM      '*F*T*SPT'    P0ACT                                        213950
     C     D#DTA         PARM      D#DTA         P#DTA                                        213950
      *                                                                                       213950
     C     *IN90         IFEQ      '1'                                                        213950
     C     P#RTN         ORNE      *BLANKS                                                    213950
     C                   MOVEL     'FTVITCHG'    DBPGM                                        213950
     C                   MOVEL     'AOCCYCV0'    DBFILE                                       213950
     C                   MOVEL     '07'          DBASE                                        213950
     C                   MOVEL     '*CALL'       DBKEY                                        213950
     C                   EXSR      *PSSR                                                      213950
     C                   ENDIF                                                                213950
      *                                                                                       213950
     C                   ELSE                                                                 213950
      *                                                                                       213950
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      IPDUMA6       PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
      *                                                                                       213950
     C                   ENDIF                                                                213950
                                                                                CFT009
      *
     C***********        If        *IN90 = *On or                               CFT009
     C***********                  P#RTN <> *Blanks                             CFT009
     C***********        MOVEL     'FTVITOTCHG'  DBPGM                          CFT009
     C***********        MOVEL     'AOCCYCV0'    DBFILE                         CFT009
     C***********        MOVEL     '07'          DBASE                          CFT009
     C***********        MOVEL     '*CALL'       DBKEY                          CFT009
     C***********        EXSR      *PSSR                                        CFT009
     C***********        EndIf                                                  CFT009
      *
     C                   If        W#NWRK = 'CASHV8'
      *
     C***********        Z-ADD     IPDUMA6       WRK110           11 0          CFT009
     C***********        Z-ADD     D#TAMT        IPDUMA6                        CFT009
      *                                                                                       213950
     C     CFT009        IFEQ      'N'                                                        213950
     C                   Z-ADD     IPDUMA6       WRK110           11 0                        213950
     C                   Z-ADD     D#TAMT        IPDUMA6                                      213950
     C                   ELSE                                                                 213950
     C                   Z-ADD     IPDUMA6       WRK110           11 0          CFT009
     C                   Z-ADD     PLev_Charge   IPDUMA6                        CFT009
     C                   ENDIF                                                                213950
      *                                                                                       213950
     C                   Z-ADD     WRK110        IPMSCH
      *
     C                   MOVEL     D#FCCY        WRK3              3
     C                   MOVEL     D#TCCY        D#FCCY
     C                   MOVEL     WRK3          D#TCCY
      *
     C                   Else
     C***********        Z-ADD     D#TAMT        IPMSCH                         CFT009
      *                                                                                       213950
     C     CFT009        IFEQ      'N'                                                        213950
     C                   Z-ADD     D#TAMT        IPMSCH                                       213950
     C                   ELSE                                                                 213950
     C                   Z-ADD     PLev_Charge   IPMSCH                         CFT009
     C                   ENDIF                                                                213950
      *                                                                                       213950
     C                   EndIf
      *
     C                   ENDIF
      *
      ** Format field for Display
     C                   Z-ADD     IPMSCH        PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C**********         MOVE      PFMTOUT       DDMSCH                                       249756
     C                   MOVE      PFMTOUT       DDMSCH                                     BUG16620
      *
     C                   ENDIF
      *
     C                   ADD       IPMSCH        TTLCHG
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALCHCD - Calculate FX/Change Commission                   *
      *                                                               *
      *****************************************************************
     C     SRCalChCd     BEGSR
      *
     C                   IF        IPINDUM7 <> 0 and
     C                             S01494 = 'Y'
      *
     C                   IF        CEU006 = 'Y'
     C                             AND CFT009 = 'N'                             CFT009
      *
      ** If EMU FT Enhancement is switched on then call FT0010
      *
     C                   CLEAR                   P#0010
     C                   MOVE      PICCY         P#FRCY
     C                   Z-ADD     IPINDUM7      P#FRAM
     C                   Z-ADD     PVDates       P#FRDT
     C                   MOVE      POCCY         P#TOCY
     C                   Z-ADD     PVDates       P#TODT
     C                   EXSR      SRFT10
     C                   Z-ADD     P#TOAM        IPINCHCM
      *
     C                   ELSE
      *
     C                   CLEAR                   D#DTA
     C                   MOVE      IPINDUM7      D#FAMT
     C                   MOVEL     PICCY         D#FCCY
     C                   MOVEL     POCCY         D#TCCY
      *
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN                          CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT                          CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA                          CFT009
      *                                                                                       213950
     C     CFT009        IFEQ      'N'                                                        213950
      *                                                                                       213950
     C                   CALL      'AOCCYCV0'                           9090                  213950
     C                   PARM      *BLANKS       P#RTN                                        213950
     C                   PARM      '*F*T*SPT'    P0ACT                                        213950
     C     D#DTA         PARM      D#DTA         P#DTA                                        213950
      *                                                                                       213950
     C     *IN90         IFEQ      '1'                                                        213950
     C     P#RTN         ORNE      *BLANKS                                                    213950
     C                   MOVEL     'FTVITCHG'    DBPGM                                        213950
     C                   MOVEL     'AOCCYCV0'    DBFILE                                       213950
     C                   MOVEL     '10'          DBASE                                        213950
     C                   MOVEL     '*CALL'       DBKEY                                        213950
     C                   EXSR      *PSSR                                                      213950
     C                   ENDIF                                                                213950
      *                                                                                       213950
     C                   Z-ADD     D#TAMT        IPINCHCM                                     213950
     C                   ELSE                                                                 213950
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      IPINDUM7      PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-ADD     PLev_Charge   IPINCHCM                       CFT009
      *                                                                                       213950
     C                   ENDIF                                                                213950
      *
     C***********        If        *IN90 = *On or                               CFT009
     C***********                  P#RTN <> *Blanks                             CFT009
     C***********        MOVEL     'FTVITOTCHG'  DBPGM                          CFT009
     C***********        MOVEL     'AOCCYCV0'    DBFILE                         CFT009
     C***********        MOVEL     '10'          DBASE                          CFT009
     C***********        MOVEL     '*CALL'       DBKEY                          CFT009
     C***********        EXSR      *PSSR                                        CFT009
     C***********        EndIf                                                  CFT009
      *
     C***********        Z-ADD     D#TAMT        IPINCHCM                       CFT009
      *
     C                   ENDIF
      *
      ** Format field for Display
     C                   Z-ADD     IPINCHCM      PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C**********         MOVE      PFMTOUT       DDCHCM                                       249756
     C                   MOVE      PFMTOUT       DDCHCM                                     BUG16620
      *
     C                   ENDIF
      *
     C                   ADD       IPINCHCM      TTLCHG
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALVAT - Calculate V.A.T                                   *
      *                                                               *
      *****************************************************************
     C     SRCalVAT      BEGSR
      *
      ** Inlcude V.A.T. amount if V.A.T. processing allowed
      *
     C                   IF        S01499 = 'Y' and
     C                             IPINDUM8 <> 0
     C                             AND CFT009 = 'N'                             CFT009
     C                             OR CFT010 = 'Y' AND IPINDUM8 <> 0            CFT009
      *
     C                   IF        CEU006 = 'Y'
     C                             AND CFT009 = 'N'                             CFT009
      *
      ** If EMU FT Enhancement is switched on then call FT0010
      *
     C                   CLEAR                   P#0010
     C                   MOVE      PICCY         P#FRCY
     C                   Z-ADD     IPINDUM8      P#FRAM
     C                   Z-ADD     PVDates       P#FRDT
     C                   MOVE      POCCY         P#TOCY
     C                   Z-ADD     PVDates       P#TODT
     C                   EXSR      SRFT10
     C                   Z-ADD     P#TOAM        IPINVATT
      *
     C                   ELSE
      *
     C                   CLEAR                   D#DTA
     C                   MOVE      IPINDUM8      D#FAMT
     C                   MOVEL     PICCY         D#FCCY
     C                   MOVEL     POCCY         D#TCCY
      *
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN                          CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT                          CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA                          CFT009
      *                                                                                       213950
     C     CFT009        IFEQ      'N'                                                        213950
      *                                                                                       213950
     C                   CALL      'AOCCYCV0'                           9090                  213950
     C                   PARM      *BLANKS       P#RTN                                        213950
     C                   PARM      '*F*T*SPT'    P0ACT                                        213950
     C     D#DTA         PARM      D#DTA         P#DTA                                        213950
      *                                                                                       213950
     C     *IN90         IFEQ      '1'                                                        213950
     C     P#RTN         ORNE      *BLANKS                                                    213950
     C                   MOVEL     'FTVITCHG'    DBPGM                                        213950
     C                   MOVEL     'AOCCYCV0'    DBFILE                                       213950
     C                   MOVEL     '12'          DBASE                                        213950
     C                   MOVEL     '*CALL'       DBKEY                                        213950
     C                   EXSR      *PSSR                                                      213950
     C                   ENDIF                                                                213950
      *                                                                                       213950
     C                   Z-ADD     D#TAMT        IPINVATT                                     213950
     C                   ELSE                                                                 213950
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      IPINDUM8      PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-ADD     PLev_Charge   IPINVATT                       CFT009
      *                                                                                       213950
     C                   ENDIF                                                                213950
      *
     C***********        If        *IN90 = *On or                               CFT009
     C***********                  P#RTN <> *Blanks                             CFT009
     C***********        MOVEL     'FTVITOTCHG'  DBPGM                          CFT009
     C***********        MOVEL     'AOCCYCV0'    DBFILE                         CFT009
     C***********        MOVEL     '12'          DBASE                          CFT009
     C***********        MOVEL     '*CALL'       DBKEY                          CFT009
     C***********        EXSR      *PSSR                                        CFT009
     C***********        EndIf                                                  CFT009
      *
     C***********        Z-ADD     D#TAMT        IPINVATT                       CFT009
      *
     C                   ENDIF
      *
      ** Format field for Display
      *
     C                   Z-ADD     IPINVATT      PFMTIN
     C                   Z-ADD     PONBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C**********         MOVE      PFMTOUT       DDVATT                                       249756
     C                   MOVE      PFMTOUT       DDVATT                                     BUG16620
      *
     C                   Z-ADD     IPINDUM8      PFMTIN
     C                   Z-ADD     PINBDP        PFMDEC
     C                   EXSR      SRFmtAmt
     C**********         MOVE      PFMTOUT       DDVATD                                       249756
     C                   MOVE      PFMTOUT       DDVATD                                     BUG16620
      *
     C                   ENDIF
      *
     C                   ADD       IPINVATT      TTLCHG
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALTOTCHG - Validate Total Charges                         *
      *                                                               *
      *****************************************************************
     C     SRValTotChg   BEGSR
                                                                                CFT009
      ** Set up rate to use, depending on flag from SDFTFRPD.                   CFT009
     C     *LIKE         Define    IPRATE        Rate_to_use                    CFT009
                                                                                CFT009
      *                                                                                       CFT120
      ** If the ICD charges in transaction exchange rate is 'Y'                               CFT120
      ** and charge currencies are the same as the transaction                                CFT120
      *                                                                                       CFT120
     C**********         If        CHTRCY = 'Y'                                        CFT009 CFT120
     C                   IF        (CHTRCY = 'Y' AND CFT120 = 'N')                            CFT120
     C                             OR (CFT120 = 'Y' AND PICCY = POCCY                         CFT120
     C                                 AND CHTRCY = 'Y')                                      CFT120
     C                   Eval      Rate_to_use = IPRATE                         CFT009
     C                   Else                                                   CFT009
     C                   Eval      Rate_to_use = I2XRTE                         CFT009
     C                   EndIf                                                  CFT009
      *
      ** If EMU FT Enhancement is switched on then
      *
      **  Transfer Commission Charge
     C                   EXSR      SRCalTrCd
      *
      ** Telex Charge
     C                   EXSR      SRCalTxCd
      *
      ** Cheque Charge
     C                   EXSR      SRCalCqCd
      *
      ** Advice Charge
     C                   EXSR      SRCalAdCd
      *
      ** Telephone Charge
     C                   EXSR      SRCalTlCd
      *
      ** Miscellaneous Charge
     C                   EXSR      SRCalMsCd
      *
      ** FX/Change Commission
     C                   EXSR      SRCalChCd
      *
      ** Inlcude V.A.T. amount if V.A.T. processing allowed
     C                   EXSR      SRCalVAT
      *                                                                         CFT009
      ** If CFT009 is on , sum extra charges to total charges                   CFT009
      *                                                                         CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
      * Miscellaneous charge 1                                                  CFT009
     C                   CLEAR                   D#DTA                          CFT009
     C                   MOVE      I2AMM1        D#FAMT                         CFT009
     C                   MOVEL     PICCY         D#FCCY                         CFT009
     C                   MOVEL     POCCY         D#TCCY                         CFT009
      *                                                                         CFT009
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN             7            CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT             8            CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA           256            CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      I2AMM1        PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   ADD       PLev_Charge   TTLCHG                         CFT009
                                                                                CFT009
     C***********        ADD       D#TAMT        TTLCHG                         CFT009
                                                                                CFT009
      * Miscellaneous charge 2                                                  CFT009
     C                   CLEAR                   D#DTA                          CFT009
     C                   MOVE      I2AMM2        D#FAMT                         CFT009
     C                   MOVEL     PICCY         D#FCCY                         CFT009
     C                   MOVEL     POCCY         D#TCCY                         CFT009
      *                                                                         CFT009
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN             7            CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT             8            CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA           256            CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      I2AMM2        PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   ADD       PLev_Charge   TTLCHG                         CFT009
                                                                                CFT009
     C***********        ADD       D#TAMT        TTLCHG                         CFT009
                                                                                CFT009
      * Miscellaneous charge 3                                                  CFT009
     C                   CLEAR                   D#DTA                          CFT009
     C                   MOVE      I2AMM3        D#FAMT                         CFT009
     C                   MOVEL     PICCY         D#FCCY                         CFT009
     C                   MOVEL     POCCY         D#TCCY                         CFT009
      *                                                                         CFT009
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN             7            CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT             8            CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA           256            CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      I2AMM3        PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   ADD       PLev_Charge   TTLCHG                         CFT009
                                                                                CFT009
     C***********        ADD       D#TAMT        TTLCHG                         CFT009
                                                                                CFT009
      * Miscellaneous charge 4                                                  CFT009
     C                   CLEAR                   D#DTA                          CFT009
     C                   MOVE      I2AMM4        D#FAMT                         CFT009
     C                   MOVEL     PICCY         D#FCCY                         CFT009
     C                   MOVEL     POCCY         D#TCCY                         CFT009
      *                                                                         CFT009
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN             7            CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT             8            CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA           256            CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      I2AMM4        PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   ADD       PLev_Charge   TTLCHG                         CFT009
                                                                                CFT009
     C***********        ADD       D#TAMT        TTLCHG                         CFT009
                                                                                CFT009
      * Miscellaneous charge 5                                                  CFT009
     C                   CLEAR                   D#DTA                          CFT009
     C                   MOVE      I2AMM5        D#FAMT                         CFT009
     C                   MOVEL     PICCY         D#FCCY                         CFT009
     C                   MOVEL     POCCY         D#TCCY                         CFT009
      *                                                                         CFT009
     C***********        CALL      'AOCCYCV0'                           9090    CFT009
     C***********        PARM      *Blanks       P#RTN             7            CFT009
     C***********        PARM      '*F*T*SPT'    P0ACT             8            CFT009
     C*****D#DTA*        PARM      D#DTA         P#DTA           256            CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      I2AMM5        PCharge_Amt      13 0          CFT009
     C                   PARM      IPPCCY        PPay_Ccy          3            CFT009
     C                   PARM      IPSMCY        PSettle_Ccy       3            CFT009
     C                   PARM      I2CCDE        PCharge_Ccy       3            CFT009
     C                   PARM      POCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   ADD       PLev_Charge   TTLCHG                         CFT009
                                                                                CFT009
     C***********        ADD       D#TAMT        TTLCHG                         CFT009
     C                   ENDIF                                                  CFT009
      *                                                                                     MD025111
      ** Check if Blocked Debit                                                             MD025111
      *                                                                                     MD025111
     C                   IF        BENEDrBlck  = 'Y' AND                                    MD025111
     C**********                   DDCDRO = *BLANKS  AND                           MD025111 MD047369
     C**********                   DDDTCH <> 'OUR'                                 MD025111 MD047369
     C                             DDCDRO = *BLANKS                                         MD047369
     C                                                                                      MD025111
      *                                                                                     MD025111
     C                   If        IPTRCM <> 0                                              MD025111
     C                   SETON                                        13                    MD025111
     C                   MOVE      'N'           OKTRCD                                     MD025111
     C                   ADD       1             Idx                                        MD025111
     C                   MOVEL     'DDTRCD'      FldNamXAr(Idx)                             MD025111
     C                   MOVEL     'FTM7121'     MsgIdXAr(Idx)                              MD025111
     C                   EndIf                                                              MD025111
      *                                                                                     MD025111
     C                   If        IPTXCH <> 0                                              MD025111
     C                   SETON                                        17                    MD025111
     C                   MOVE      'N'           OKTXCD                                     MD025111
     C                   ADD       1             Idx                                        MD025111
     C                   MOVEL     'DDTXCD'      FldNamXAr(Idx)                             MD025111
     C                   MOVEL     'FTM7121'     MsgIdXAr(Idx)                              MD025111
     C                   EndIf                                                              MD025111
      *                                                                                     MD025111
     C                   If        IPCQCH <> 0                                              MD025111
     C                   SETON                                        19                    MD025111
     C                   MOVE      'N'           OKCQCD                                     MD025111
     C                   ADD       1             Idx                                        MD025111
     C                   MOVEL     'DDCQCD'      FldNamXAr(Idx)                             MD025111
     C                   MOVEL     'FTM7121'     MsgIdXAr(Idx)                              MD025111
     C                   EndIf                                                              MD025111
      *                                                                                     MD025111
     C                   If        IPADCH <> 0                                              MD025111
     C                   SETON                                        21                    MD025111
     C                   MOVE      'N'           OKADCD                                     MD025111
     C                   ADD       1             Idx                                        MD025111
     C                   MOVEL     'DDADCD'      FldNamXAr(Idx)                             MD025111
     C                   MOVEL     'FTM7121'     MsgIdXAr(Idx)                              MD025111
     C                   EndIf                                                              MD025111
      *                                                                                     MD025111
     C                   If        IPTLCH <> 0                                              MD025111
     C                   SETON                                        23                    MD025111
     C                   MOVE      'N'           OKTLCD                                     MD025111
     C                   ADD       1             Idx                                        MD025111
     C                   MOVEL     'DDTLCD'      FldNamXAr(Idx)                             MD025111
     C                   MOVEL     'FTM7121'     MsgIdXAr(Idx)                              MD025111
     C                   EndIf                                                              MD025111
      *                                                                                     MD025111
     C                   If        IPMSCH <> 0                                              MD025111
     C                   SETON                                        25                    MD025111
     C                   MOVE      'N'           OKMSCD                                     MD025111
     C                   ADD       1             Idx                                        MD025111
     C                   MOVEL     'DDMSCD'      FldNamXAr(Idx)                             MD025111
     C                   MOVEL     'FTM7121'     MsgIdXAr(Idx)                              MD025111
     C                   EndIf                                                              MD025111
      *                                                                                     MD025111
     C                   If        IPINCHCM <> 0 and                                        MD025111
     C                             S01494 = 'Y'                                             MD025111
     C                   SETON                                        15                    MD025111
     C                   MOVE      'N'           OKCHCD                                     MD025111
     C                   ADD       1             Idx                                        MD025111
     C                   MOVEL     'DDCHCD'      FldNamXAr(Idx)                             MD025111
     C                   MOVEL     'FTM7121'     MsgIdXAr(Idx)                              MD025111
     C                   EndIf                                                              MD025111
      *                                                                                     MD025111
     C                   IF        I2AMM1 <> 0 AND                                          MD025111
     C                             CFT009 = 'Y'                                             MD025111
     C                   SETON                                        46                    MD025111
     C                   MOVE      'N'           OKM1CD                                     MD025111
     C                   ADD       1             IDX                                        MD025111
     C                   MOVEL     'M1CD'        FLDNAMXAR(IDX)                             MD025111
     C                   MOVEL     'FTM7121'     MSGIDXAR(IDX)                              MD025111
     C                   ENDIF                                                              MD025111
      *                                                                                     MD025111
     C                   IF        I2AMM2 <> 0 AND                                          MD025111
     C                             CFT009 = 'Y'                                             MD025111
     C                   SETON                                        48                    MD025111
     C                   MOVE      'N'           OKM2CD                                     MD025111
     C                   ADD       1             IDX                                        MD025111
     C                   MOVEL     'M2CD'        FLDNAMXAR(IDX)                             MD025111
     C                   MOVEL     'FTM7121'     MSGIDXAR(IDX)                              MD025111
     C                   ENDIF                                                              MD025111
      *                                                                                     MD025111
     C                   IF        I2AMM3 <> 0 AND                                          MD025111
     C                             CFT009 = 'Y'                                             MD025111
     C                   SETON                                        50                    MD025111
     C                   MOVE      'N'           OKM3CD                                     MD025111
     C                   ADD       1             IDX                                        MD025111
     C                   MOVEL     'M3CD'        FLDNAMXAR(IDX)                             MD025111
     C                   MOVEL     'FTM7121'     MSGIDXAR(IDX)                              MD025111
     C                   ENDIF                                                              MD025111
      *                                                                                     MD025111
     C                   IF        I2AMM4 <> 0 AND                                          MD025111
     C                             CFT009 = 'Y'                                             MD025111
     C                   SETON                                        52                    MD025111
     C                   MOVE      'N'           OKM4CD                                     MD025111
     C                   ADD       1             IDX                                        MD025111
     C                   MOVEL     'M4CD'        FLDNAMXAR(IDX)                             MD025111
     C                   MOVEL     'FTM7121'     MSGIDXAR(IDX)                              MD025111
     C                   ENDIF                                                              MD025111
      *                                                                                     MD025111
     C                   IF        I2AMM5 <> 0 AND                                          MD025111
     C                             CFT009 = 'Y'                                             MD025111
     C                   SETON                                        54                    MD025111
     C                   MOVE      'N'           OKM5CD                                     MD025111
     C                   ADD       1             IDX                                        MD025111
     C                   MOVEL     'M5CD'        FLDNAMXAR(IDX)                             MD025111
     C                   MOVEL     'FTM7121'     MSGIDXAR(IDX)                              MD025111
     C                   ENDIF                                                              MD025111
     C                   ENDIF                                                              MD025111
      *                                                                                     MD047369
      ** Check if Referred Debit                                                            MD047369
      *                                                                                     MD047369
     C**********         IF        BENEDrBlck  = 'R' AND                          MD047369 MD047369A
     C                   IF        BENEDrRefd  = 'Y' AND                                   MD047369A
     C                             DDCDRO = *BLANKS                                         MD047369
     C                                                                                      MD047369
      *                                                                                     MD047369
     C                   If        IPTRCM <> 0                                              MD047369
     C                   MOVE      'N'           OKTRCD                                     MD047369
     C**********         ADD       1             Idx                              MD047369 MD047369A
     C**********         MOVEL     'DDTRCD'      FldNamXAr(Idx)                   MD047369 MD047369A
     C**********         MOVEL     '5049015'     MsgIdXAr(Idx)                    MD047369 MD047369A
     C                   ADD       1             Wix                                       MD047369A
     C                   MOVEL     'DDTRCD'      WFldNmXAr(Wix)                            MD047369A
     C                   MOVEL     'FTM7134'     WMsgIdXAr(Wix)                            MD047369A
     C                   EndIf                                                              MD047369
      *                                                                                     MD047369
     C                   If        IPTXCH <> 0                                              MD047369
     C                   MOVE      'N'           OKTXCD                                     MD047369
     C**********         ADD       1             Idx                              MD047369 MD047369A
     C**********         MOVEL     'DDTXCD'      FldNamXAr(Idx)                   MD047369 MD047369A
     C**********         MOVEL     '5049015'     MsgIdXAr(Idx)                    MD047369 MD047369A
     C                   ADD       1             Wix                                       MD047369A
     C                   MOVEL     'DDTXCD'      WFldNmXAr(Wix)                            MD047369A
     C                   MOVEL     'FTM7134'     WMsgIdXAr(Wix)                            MD047369A
     C                   EndIf                                                              MD047369
      *                                                                                     MD047369
     C                   If        IPCQCH <> 0                                              MD047369
     C                   MOVE      'N'           OKCQCD                                     MD047369
     C**********         ADD       1             Idx                              MD047369 MD047369A
     C**********         MOVEL     'DDCQCD'      FldNamXAr(Idx)                   MD047369 MD047369A
     C**********         MOVEL     '5049015'     MsgIdXAr(Idx)                    MD047369 MD047369A
     C                   ADD       1             Wix                                       MD047369A
     C                   MOVEL     'DDCQCD'      WFldNmXAr(Wix)                            MD047369A
     C                   MOVEL     'FTM7134'     WMsgIdXAr(Wix)                            MD047369A
     C                   EndIf                                                              MD047369
      *                                                                                     MD047369
     C                   If        IPADCH <> 0                                              MD047369
     C                   MOVE      'N'           OKADCD                                     MD047369
     C**********         ADD       1             Idx                              MD047369 MD047369A
     C**********         MOVEL     'DDADCD'      FldNamXAr(Idx)                   MD047369 MD047369A
     C**********         MOVEL     '5049015'     MsgIdXAr(Idx)                    MD047369 MD047369A
     C                   ADD       1             Wix                                       MD047369A
     C                   MOVEL     'DDADCD'      WFldNmXAr(Wix)                            MD047369A
     C                   MOVEL     'FTM7134'     WMsgIdXAr(Wix)                            MD047369A
     C                   EndIf                                                              MD047369
      *                                                                                     MD047369
     C                   If        IPTLCH <> 0                                              MD047369
     C                   MOVE      'N'           OKTLCD                                     MD047369
     C**********         ADD       1             Idx                              MD047369 MD047369A
     C**********         MOVEL     'DDTLCD'      FldNamXAr(Idx)                   MD047369 MD047369A
     C**********         MOVEL     '5049015'     MsgIdXAr(Idx)                    MD047369 MD047369A
     C                   ADD       1             Wix                                       MD047369A
     C                   MOVEL     'DDTLCD'      WFldNmXAr(Wix)                            MD047369A
     C                   MOVEL     'FTM7134'     WMsgIdXAr(Wix)                            MD047369A
     C                   EndIf                                                              MD047369
      *                                                                                     MD047369
     C                   If        IPMSCH <> 0                                              MD047369
     C                   MOVE      'N'           OKMSCD                                     MD047369
     C**********         ADD       1             Idx                              MD047369 MD047369A
     C**********         MOVEL     'DDMSCD'      FldNamXAr(Idx)                   MD047369 MD047369A
     C**********         MOVEL     '5049015'     MsgIdXAr(Idx)                    MD047369 MD047369A
     C                   ADD       1             Wix                                       MD047369A
     C                   MOVEL     'DDMSCD'      WFldNmXAr(Wix)                            MD047369A
     C                   MOVEL     'FTM7134'     WMsgIdXAr(Wix)                             MD04736A
     C                   EndIf                                                              MD047369
      *                                                                                     MD047369
     C                   If        IPINCHCM <> 0 and                                        MD047369
     C                             S01494 = 'Y'                                             MD047369
     C                   MOVE      'N'           OKCHCD                                     MD047369
     C**********         ADD       1             Idx                              MD047369 MD047369A
     C**********         MOVEL     'DDCHCD'      FldNamXAr(Idx)                   MD047369 MD047369A
     C**********         MOVEL     '5049015'     MsgIdXAr(Idx)                    MD047369 MD047369A
     C                   ADD       1             Wix                                       MD047369A
     C                   MOVEL     'DDCHCD'      WFldNmXAr(Wix)                            MD047369A
     C                   MOVEL     'FTM7134'     WMsgIdXAr(Wix)                            MD047369A
     C                   EndIf                                                              MD047369
      *                                                                                     MD047369
     C                   IF        I2AMM1 <> 0 AND                                          MD047369
     C                             CFT009 = 'Y'                                             MD047369
     C                   MOVE      'N'           OKM1CD                                     MD047369
     C**********         ADD       1             IDX                              MD047369 MD047369A
     C**********         MOVEL     'M1CD'        FLDNAMXAR(IDX)                   MD047369 MD047369A
     C**********         MOVEL     '5049015'     MSGIDXAR(IDX)                    MD047369 MD047369A
     C                   ADD       1             Wix                                       MD047369A
     C                   MOVEL     'M1CD'        WFldNmXAr(Wix)                            MD047369A
     C                   MOVEL     'FTM7134'     WMsgIdXAr(Wix)                            MD047369A
     C                   ENDIF                                                              MD047369
      *                                                                                     MD047369
     C                   IF        I2AMM2 <> 0 AND                                          MD047369
     C                             CFT009 = 'Y'                                             MD047369
     C                   MOVE      'N'           OKM2CD                                     MD047369
     C**********         ADD       1             IDX                              MD047369 MD047369A
     C**********         MOVEL     'M2CD'        FLDNAMXAR(IDX)                   MD047369 MD047369A
     C**********         MOVEL     '5049015'     MSGIDXAR(IDX)                    MD047369 MD047369A
     C                   ADD       1             Wix                                       MD047369A
     C                   MOVEL     'M2CD'        WFldNmXAr(Wix)                            MD047369A
     C                   MOVEL     'FTM7134'     WMsgIdXAr(Wix)                            MD047369A
     C                   ENDIF                                                              MD047369
      *                                                                                     MD047369
     C                   IF        I2AMM3 <> 0 AND                                          MD047369
     C                             CFT009 = 'Y'                                             MD047369
     C                   MOVE      'N'           OKM3CD                                     MD047369
     C**********         ADD       1             IDX                              MD047369 MD047369A
     C**********         MOVEL     'M3CD'        FLDNAMXAR(IDX)                   MD047369 MD047369A
     C**********         MOVEL     '5049015'     MSGIDXAR(IDX)                    MD047369 MD047369A
     C                   ADD       1             Wix                                       MD047369A
     C                   MOVEL     'M3CD'        WFldNmXAr(Wix)                            MD047369A
     C                   MOVEL     'FTM7134'     WMsgIdXAr(Wix)                            MD047369A
     C                   ENDIF                                                              MD047369
      *                                                                                     MD047369
     C                   IF        I2AMM4 <> 0 AND                                          MD047369
     C                             CFT009 = 'Y'                                             MD047369
     C                   MOVE      'N'           OKM4CD                                     MD047369
     C**********         ADD       1             IDX                              MD047369 MD047369A
     C**********         MOVEL     'M4CD'        FLDNAMXAR(IDX)                   MD047369 MD047369A
     C**********         MOVEL     '5049015'     MSGIDXAR(IDX)                    MD047369 MD047369A
     C                   ADD       1             Wix                                       MD047369A
     C                   MOVEL     'M4CD'        WFldNmXAr(Wix)                            MD047369A
     C                   MOVEL     'FTM7134'     WMsgIdXAr(Wix)                            MD047369A
     C                   ENDIF                                                              MD047369
      *                                                                                     MD047369
     C                   IF        I2AMM5 <> 0 AND                                          MD047369
     C                             CFT009 = 'Y'                                             MD047369
     C                   MOVE      'N'           OKM5CD                                     MD047369
     C**********         ADD       1             IDX                              MD047369 MD047369A
     C**********         MOVEL     'M5CD'        FLDNAMXAR(IDX)                   MD047369 MD047369A
     C**********         MOVEL     '5049015'     MSGIDXAR(IDX)                    MD047369 MD047369A
     C                   ADD       1             Wix                                       MD047369A
     C                   MOVEL     'M5CD'        WFldNmXAr(Wix)                            MD047369A
     C                   MOVEL     'FTM7134'     WMsgIdXAr(Wix)                            MD047369A
     C                   ENDIF                                                              MD047369
     C                   ENDIF                                                              MD047369
      *                                                                                     MD047884
      ** Check Charges to the debit of A/C if Blocked Debit                                 MD047884
      *                                                                                     MD047884
     C                   IF        CHACDrBlck  = 'Y' AND                                    MD047884
     C                             IPADDC = 'D'                                             MD047884
     C                                                                                      MD047884
      *                                                                                     MD047884
     C                   IF        IPTRCM <> 0                                              MD047884
     C                   MOVE      'N'           OKTRCD                                     MD047884
     C                   ADD       1             Idx                                        MD047884
     C                   MOVEL     'DDTRCD'      FldNamXAr(Idx)                             MD047884
     C**********         MOVEL     '5049017'     MsgIdXAr(Idx)                    MD047884 MD047369A
     C                   MOVEL     'FTM7136'     MsgIdXAr(Idx)                             MD047369A
     C                   ENDIF                                                              MD047884
      *                                                                                     MD047884
     C                   IF        IPTXCH <> 0                                              MD047884
     C                   MOVE      'N'           OKTXCD                                     MD047884
     C                   ADD       1             Idx                                        MD047884
     C                   MOVEL     'DDTXCD'      FldNamXAr(Idx)                             MD047884
     C**********         MOVEL     '5049017'     MsgIdXAr(Idx)                    MD047884 MD047369A
     C                   MOVEL     'FTM7136'     MsgIdXAr(Idx)                             MD047369A
     C                   ENDIF                                                              MD047884
      *                                                                                     MD047884
     C                   IF        IPCQCH <> 0                                              MD047884
     C                   MOVE      'N'           OKCQCD                                     MD047884
     C                   ADD       1             Idx                                        MD047884
     C                   MOVEL     'DDCQCD'      FldNamXAr(Idx)                             MD047884
     C**********         MOVEL     '5049017'     MsgIdXAr(Idx)                    MD047884 MD047369A
     C                   MOVEL     'FTM7136'     MsgIdXAr(Idx)                             MD047369A
     C                   ENDIF                                                              MD047884
      *                                                                                     MD047884
     C                   IF        IPADCH <> 0                                              MD047884
     C                   MOVE      'N'           OKADCD                                     MD047884
     C                   ADD       1             Idx                                        MD047884
     C                   MOVEL     'DDADCD'      FldNamXAr(Idx)                             MD047884
     C**********         MOVEL     '5049017'     MsgIdXAr(Idx)                    MD047884 MD047369A
     C                   MOVEL     'FTM7136'     MsgIdXAr(Idx)                             MD047369A
     C                   ENDIF                                                              MD047884
      *                                                                                     MD047884
     C                   IF        IPTLCH <> 0                                              MD047884
     C                   MOVE      'N'           OKTLCD                                     MD047884
     C                   ADD       1             Idx                                        MD047884
     C                   MOVEL     'DDTLCD'      FldNamXAr(Idx)                             MD047884
     C**********         MOVEL     '5049017'     MsgIdXAr(Idx)                    MD047884 MD047369A
     C                   MOVEL     'FTM7136'     MsgIdXAr(Idx)                             MD047369A
     C                   ENDIF                                                              MD047884
      *                                                                                     MD047884
     C                   IF        IPMSCH <> 0                                              MD047884
     C                   MOVE      'N'           OKMSCD                                     MD047884
     C                   ADD       1             Idx                                        MD047884
     C                   MOVEL     'DDMSCD'      FldNamXAr(Idx)                             MD047884
     C**********         MOVEL     '5049017'     MsgIdXAr(Idx)                    MD047884 MD047369A
     C                   MOVEL     'FTM7136'     MsgIdXAr(Idx)                             MD047369A
     C                   ENDIF                                                              MD047884
      *                                                                                     MD047884
     C                   IF        IPINCHCM <> 0 and                                        MD047884
     C                             S01494 = 'Y'                                             MD047884
     C                   MOVE      'N'           OKCHCD                                     MD047884
     C                   ADD       1             Idx                                        MD047884
     C                   MOVEL     'DDCHCD'      FldNamXAr(Idx)                             MD047884
     C**********         MOVEL     '5049017'     MsgIdXAr(Idx)                    MD047884 MD047369A
     C                   MOVEL     'FTM7136'     MsgIdXAr(Idx)                             MD047369A
     C                   ENDIF                                                              MD047884
      *                                                                                     MD047884
     C                   IF        I2AMM1 <> 0 AND                                          MD047884
     C                             CFT009 = 'Y'                                             MD047884
     C                   MOVE      'N'           OKM1CD                                     MD047884
     C                   ADD       1             IDX                                        MD047884
     C                   MOVEL     'M1CD'        FLDNAMXAR(IDX)                             MD047884
     C**********         MOVEL     '5049017'     MsgIdXAr(Idx)                    MD047884 MD047369A
     C                   MOVEL     'FTM7136'     MSGIDXAR(IDX)                             MD047369A
     C                   ENDIF                                                              MD047884
      *                                                                                     MD047884
     C                   IF        I2AMM2 <> 0 AND                                          MD047884
     C                             CFT009 = 'Y'                                             MD047884
     C                   MOVE      'N'           OKM2CD                                     MD047884
     C                   ADD       1             IDX                                        MD047884
     C                   MOVEL     'M2CD'        FLDNAMXAR(IDX)                             MD047884
     C**********         MOVEL     '5049017'     MsgIdXAr(Idx)                    MD047884 MD047369A
     C                   MOVEL     'FTM7136'     MSGIDXAR(IDX)                             MD047369A
     C                   ENDIF                                                              MD047884
      *                                                                                     MD047884
     C                   IF        I2AMM3 <> 0 AND                                          MD047884
     C                             CFT009 = 'Y'                                             MD047884
     C                   MOVE      'N'           OKM3CD                                     MD047884
     C                   ADD       1             IDX                                        MD047884
     C                   MOVEL     'M3CD'        FLDNAMXAR(IDX)                             MD047884
     C**********         MOVEL     '5049017'     MsgIdXAr(Idx)                    MD047884 MD047369A
     C                   MOVEL     'FTM7136'     MSGIDXAR(IDX)                             MD047369A
     C                   ENDIF                                                              MD047884
      *                                                                                     MD047884
     C                   IF        I2AMM4 <> 0 AND                                          MD047884
     C                             CFT009 = 'Y'                                             MD047884
     C                   MOVE      'N'           OKM4CD                                     MD047884
     C                   ADD       1             IDX                                        MD047884
     C                   MOVEL     'M4CD'        FLDNAMXAR(IDX)                             MD047884
     C**********         MOVEL     '5049017'     MsgIdXAr(Idx)                    MD047884 MD047369A
     C                   MOVEL     'FTM7136'     MSGIDXAR(IDX)                             MD047369A
     C                   ENDIF                                                              MD047884
      *                                                                                     MD047884
     C                   IF        I2AMM5 <> 0 AND                                          MD047884
     C                             CFT009 = 'Y'                                             MD047884
     C                   MOVE      'N'           OKM5CD                                     MD047884
     C                   ADD       1             IDX                                        MD047884
     C                   MOVEL     'M5CD'        FLDNAMXAR(IDX)                             MD047884
     C**********         MOVEL     '5049017'     MsgIdXAr(Idx)                    MD047884 MD047369A
     C                   MOVEL     'FTM7136'     MSGIDXAR(IDX)                             MD047369A
     C                   ENDIF                                                              MD047884
     C                   ENDIF                                                              MD047884
      *
      ** Check that total charges do not exceed payment amount if the
      ** add/deduct indicator is 'D' and 'Charges To The Debit Of' has
      ** not been entered.
      *
     C                   IF        IPADDC = 'D' and
     C                             IPCDRT = *Blanks
      *
      ** Check if total charges are greater than the payment value
      *
     C     TTLCHG        IFGE      IPPYAM
      *
      ** Reverse image the Charge fields with amounts in them
      *
     C                   If        IPTRCM <> 0
     C                   MOVE      'N'           OKTRCD
     C                   ADD       1             Idx
     C                   MOVEL     'DDTRCD'      FldNamXAr(Idx)
     C                   MOVEL     'FTM2107'     MsgIdXAr(Idx)
     C                   EndIf
      *
     C                   If        IPTXCH <> 0
     C                   MOVE      'N'           OKTXCD
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXCD'      FldNamXAr(Idx)
     C                   MOVEL     'FTM2107'     MsgIdXAr(Idx)
     C                   EndIf
      *
     C                   If        IPCQCH <> 0
     C                   MOVE      'N'           OKCQCD
     C                   ADD       1             Idx
     C                   MOVEL     'DDCQCD'      FldNamXAr(Idx)
     C                   MOVEL     'FTM2107'     MsgIdXAr(Idx)
     C                   EndIf
      *
     C                   If        IPADCH <> 0
     C                   MOVE      'N'           OKADCD
     C                   ADD       1             Idx
     C                   MOVEL     'DDADCD'      FldNamXAr(Idx)
     C                   MOVEL     'FTM2107'     MsgIdXAr(Idx)
     C                   EndIf
      *
     C                   If        IPTLCH <> 0
     C                   MOVE      'N'           OKTLCD
     C                   ADD       1             Idx
     C                   MOVEL     'DDTLCD'      FldNamXAr(Idx)
     C                   MOVEL     'FTM2107'     MsgIdXAr(Idx)
     C                   EndIf
      *
     C                   If        IPMSCH <> 0
     C                   MOVE      'N'           OKMSCD
     C                   ADD       1             Idx
     C                   MOVEL     'DDMSCD'      FldNamXAr(Idx)
     C                   MOVEL     'FTM2107'     MsgIdXAr(Idx)
     C                   EndIf
      *
     C                   If        IPINCHCM <> 0 and
     C                             S01494 = 'Y'
     C                   MOVE      'N'           OKCHCD
     C                   ADD       1             Idx
     C                   MOVEL     'DDCHCD'      FldNamXAr(Idx)
     C                   MOVEL     'FTM2107'     MsgIdXAr(Idx)
     C                   EndIf
      *                                                                         CFT009
     C                   IF        I2AMM1 <> 0 AND                              CFT009
     C                             CFT009 = 'Y'                                 CFT009
     C                   MOVE      'N'           OKM1CD                         CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'M1CD'        FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTM2107'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   IF        I2AMM2 <> 0 AND                              CFT009
     C                             CFT009 = 'Y'                                 CFT009
     C                   MOVE      'N'           OKM2CD                         CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'M2CD'        FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTM2107'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   IF        I2AMM3 <> 0 AND                              CFT009
     C                             CFT009 = 'Y'                                 CFT009
     C                   MOVE      'N'           OKM3CD                         CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'M3CD'        FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTM2107'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   IF        I2AMM4 <> 0 AND                              CFT009
     C                             CFT009 = 'Y'                                 CFT009
     C                   MOVE      'N'           OKM4CD                         CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'M4CD'        FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTM2107'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   IF        I2AMM5 <> 0 AND                              CFT009
     C                             CFT009 = 'Y'                                 CFT009
     C                   MOVE      'N'           OKM5CD                         CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'M5CD'        FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTM2107'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFT10 - Calculates Currency Amounts for EMU                 *
      *                                                               *
      *****************************************************************
     C     SRFT10        BEGSR
      *
     C                   CALL      'FT0010'
     C                   PARM                    P#0010
      *
      ** Check if database error occurred
      *
     C                   IF        P#RTCD <> *Blanks
     C                   MOVEL     'FTVITOTCHG'  DBPGM
     C                   MOVEL     'FT0010'      DBFILE
     C                   MOVEL     '15'          DBASE
     C                   MOVEL     P#TOCY        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * SRFmtAmt - Format Amount for Display                             *
      *                                                                  *
      ********************************************************************
      *
     C     SRFmtAmt      BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        PRETC            10
     C                   PARM                    PFMTIN           13 0
     C                   PARM                    PFMDEC            1 0
     C                   PARM      '.'           PBNDCSP           1
     C                   PARM      *BLANK        PFMTOUT          14
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C***********        PARM                    NwIP4ScnFmt                    CFT009
     C                   PARM                    NwIP5ScnFmt                    CFT009
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Input Charge Currency
     C                   PARM                    PICCY             3
      *
      ** Output Charge Currency
     C                   PARM                    POCCY             3
      *
      ** Value Dates
     C                   PARM                    PVDates           5 0
      *
      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP            1 0
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP            1 0
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006            1
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494            1
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499            1
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C                   PARM                    CFT010            1            CFT009
     C                   PARM                    CHACDrBlck                                 MD047884
     C                   PARM                    BENEDrRefd                                MD047369A
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller                   MD047369A
     C                   Parm                    WFldNmXAr                                 MD047369A
     C                   Parm                    WMsgIDXAr                                 MD047369A
     C                   Parm                    WMsgDtXAr                                 MD047369A
      *
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY3                        CFT014
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT014
     C                   PARM                    FTEIPY4                        CFT014
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *                                                                         CFT009
      ** Incoming Payments (additional details) for file update                 CFT009
     C                   PARM                    NWIP2FILFMT                    CFT009
      *
      ** Charges Amount
     C                   PARM                    PCharges
     C                   PARM                    BENEDrBlck        1                        MD025111
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
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
     C                   EVAL      DBASE = 16                                                 CFT120
     C                   EXSR      *PSSR                                                      CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
** WMsgArr
FX/Change Commission
