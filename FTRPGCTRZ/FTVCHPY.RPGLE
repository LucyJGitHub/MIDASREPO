     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate total charges <= payment amount')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVCHPY  - Validate Total Charges <= Payment Amount          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT157             Date 29Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 08Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *           (Recompile)                                         *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **********************************************************************
      /EJECT                                                               *
      **********************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D*TranInThir****E*DS*****             EXTNAME(FTOPY4PD)                    CFT014
     D TranInFour    E DS                  EXTNAME(FTOPY6PD)                    CFT014
 
      * Flags to indicate whether transaction fields are valid
     D*OKFlagsDS*****E*DS*****             EXTNAME(FTEOPY3PD)                   CFT014
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY4PD)                   CFT014
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
                                                                                CFT009
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                    CFT009
      * External DS for Funds Transfer details                                  CFT009
                                                                                CFT009
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CFT009
      ** First DS for access programs, short data structure                     CFT009
 
     D D#DTA           DS           256
     D  D#FCCY                 1      3
     D  D#FAMT                 4     11P 0
     D  D#TCCY                12     14
     D  D#TAMT                15     22P 0
     D  D#IMDIN               23     23
     D  D#IRATE               24     36P 8
     D  D#OMDIN               23     23
     D  D#ORATE               24     36P 8
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D C#ACTN          S              8
     D C#RTCD          S              7
 
     D WDATE           S              5  0
     D WTLCHG          S             13  0
 
     D ZalignOK        S              1
     D ZFIELD          S             16
     D ZADIG           S              2  0
     D ZADEC1          S              1  0
     D ZADEC2          S              2  0
     D ZMDIX           S              1
     D ZMDI1           S              1
     D ZMDI2           S              1
 
      **  Data Structure for input/output parameters
     D/COPY FTCPYSRC,FT0010D001
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
      *
     C                   Eval      RetCodeIn = *BlankS
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      Idx = 0
 
      * Validate
     C                   Exsr      VTOTCHG
 
 
      ** If an error was found, set the return code appropriately
     C                   If        OKChcd = 'N' or
     C                             OKCqcd = 'N' or
     C                             OKCstd = 'N' or
     C                             OKMscd = 'N' or
     C                             OKSpcd = 'N' and
     C                             OKTrcd = 'N' and
     C                             OKTxcd = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
 
     C                   RETURN
      ******************************************************************
      /EJECT                                                           *
     C******************************************************************
     C* VEUXCHK - VALIDATION TOTAL CHARGES <= PAYMENT AMOUNT           *
     C******************************************************************
 
     C     VTOTCHG       BEGSR
 
      ** If CFT009 is on, set up the exchange rate to use.                      CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
      ** Access Funds Transfer details via access program                       CFT009
      **  (database error handling done in access program)                      CFT009
                                                                                CFT009
     C                   CALL      'AOFTFRR0'                                   CFT009
     C                   Parm      '*DBERR'      @RTCD                          CFT009
     C                   Parm      '*FIRST'      @OPTN                          CFT009
     C     SDFTFR        Parm      SDFTFR        DSFDY                          CFT009
                                                                                CFT009
     C     *LIKE         Define    @RATE         Rate_to_use                    CFT009
                                                                                CFT009
     C                   If        CHTRCY = 'Y'                                 CFT009
     C                   Eval      Rate_to_use = @RATE                          CFT009
     C                   Else                                                   CFT009
     C                   Eval      Rate_to_use = O2XRTE                         CFT009
     C                   EndIf                                                  CFT009
     C                   EndIf                                                  CFT009
 
      * If EMU FT Enhancement is switched on then set work date.
     C                   If        @CEU006 = 'Y'
 
     C                   If        SADDC = 'A'
     C                   Eval      WDATE = @SLDT
     C                   Else
     C                   Eval      WDATE = @PVDT
     C                   End
 
     C                   End
 
      *  Transfer Commission Charge
     C                   If        @TRCD <> 0
 
     C                   If        @CEU006 = 'Y'
     C                             AND @CFT009 = 'N'                            CFT009
 
     C* If EMU FT Enhancement is switched on then call FT0010
     C                   Clear                   P#0010
     C                   Eval      P#FRCY = @CCCY
     C                   Eval      P#FRAM = @TRCD
     C                   Eval      P#FRDT = WDATE
     C                   Eval      P#TOCY = @RCCY
     C                   Eval      P#TODT = WDATE
     C                   Exsr      SRFT10
 
     C                   Eval      @TRCM =  P#TOAM
 
     C                   Else
      *
     C                   Clear                   D#DTA
     C                   Eval      D#FAMT = @TRCD
     C                   Eval      D#FCCY = @CCCY
     C                   Eval      D#TCCY = @RCCY
 
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @TRCD         PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @TRCM                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
                                                                                CFT009
     C                   CALL      'AOCCYCV0'
     C                   Parm      *BLANKS       C#RTCD
     C                   Parm      '*F*T*SPT'    C#ACTN
     C     D#DTA         Parm                    D#DTA
 
     C                   If        C#RTCD <> *Blanks
     C                   Move      'FTVCHPY'     DBPGM
     C                   Move      'AOCCYCV0'    DBFILE
     C                   Eval      DBASE = 2
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
      * Set Valid Fields
     C                   Eval      @TRCM =  D#TAMT
                                                                                CFT009
     C                   EndIf                                                  CFT009
                                                                                CFT009
     C                   End
 
     C                   Else                                                   CFT009
     C                   Eval      @TRCM = 0                                    CFT009
     C                   End
 
     C                   Eval       WTLCHG = @TRCM
 
 
      *  Telex Charges
     C                   If        @TXCD <> 0
 
     C                   If        @CEU006 = 'Y'
     C                             AND @CFT009 = 'N'                            CFT009
 
     C* If EMU FT Enhancement is switched on then call FT0010
     C                   Clear                   P#0010
 
     C                   Movel     'FTVCHPY  '   P#PMSQ
 
     C                   Eval      P#FRCY = @CCCY
     C                   Eval      P#FRAM = @TXCD
     C                   Eval      P#FRDT = WDATE
     C                   Eval      P#TOCY = @RCCY
     C                   Eval      P#TODT = WDATE
     C                   Exsr      SRFT10
 
      * Set Valid Fields
     C                   Eval      @TXCH = P#TOAM
 
     C                   Else
      *
     C                   Clear                   D#DTA
     C                   Eval      D#FAMT = @TXCD
     C                   Eval      D#FCCY = @CCCY
     C                   Eval      D#TCCY = @RCCY
 
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @TXCD         PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @TXCH                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
                                                                                CFT009
     C                   CALL      'AOCCYCV0'
     C                   Parm      *BLANKS       C#RTCD
     C                   Parm      '*F*T*SPT'    C#ACTN
     C     D#DTA         Parm                    D#DTA
 
     C                   If        C#RTCD <> *Blanks
     C                   Move      'FTVCHPY'     DBPGM
     C                   Move      'AOCCYCV0'    DBFILE
     C                   Eval      DBASE = 2
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
      * Set Valid Fields
     C                   Eval      @TXCH = D#TAMT
     C                   End
                                                                                CFT009
     C                   EndIf                                                  CFT009
                                                                                CFT009
 
     C                   Else                                                   CFT009
     C                   Eval      @TXCH = 0                                    CFT009
     C                   End
 
     C                   Eval       WTLCHG = WTLCHG + @TXCH
 
      *  Cheque Charges
     C                   If        @CQCD <> 0
 
     C                   If        @CEU006 = 'Y'
     C                             AND @CFT009 = 'N'                            CFT009
 
     C* If EMU FT Enhancement is switched on then call FT0010
     C                   Clear                   P#0010
     C                   Eval      P#FRCY = @CCCY
     C                   Eval      P#FRAM = @CQCD
     C                   Eval      P#FRDT = WDATE
     C                   Eval      P#TOCY = @RCCY
     C                   Eval      P#TODT = WDATE
     C                   Exsr      SRFT10
 
      * Set Valid Fields
     C                   Eval      @CQCH = P#TOAM
     C*
     C                   Else
      *
     C                   Clear                   D#DTA
     C                   Eval      D#FAMT = @CQCD
     C                   Eval      D#FCCY = @CCCY
     C                   Eval      D#TCCY = @RCCY
                                                                                CFT009
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @CQCD         PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @CQCH                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
 
     C                   CALL      'AOCCYCV0'
     C                   Parm      *BLANKS       C#RTCD
     C                   Parm      '*F*T*SPT'    C#ACTN
     C     D#DTA         Parm                    D#DTA
 
     C                   If        C#RTCD <> *Blanks
     C                   Move      'FTVCHPY'     DBPGM
     C                   Move      'AOCCYCV0'    DBFILE
     C                   Eval      DBASE = 3
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
      * Set Valid Fields
     C                   Eval      @CQCH = D#TAMT
     C                   End
                                                                                CFT009
     C                   EndIf                                                  CFT009
 
     C                   Else                                                   CFT009
     C                   Eval      @CQCH = 0                                    CFT009
     C                   End
 
     C                   Eval       WTLCHG = WTLCHG + @CQCH
 
      *  Costs Abroad
     C                   If        @CSTD <> 0
 
     C                   If        @CEU006 = 'Y'
     C                             AND @CFT009 = 'N'                            CFT009
 
     C* If EMU FT Enhancement is switched on then call FT0010
     C                   Clear                   P#0010
     C                   Eval      P#FRCY = @CCCY
     C                   Eval      P#FRAM = @CSTD
     C                   Eval      P#FRDT = WDATE
     C                   Eval      P#TOCY = @RCCY
     C                   Eval      P#TODT = WDATE
     C                   Exsr      SRFT10
 
      * Set Valid Fields
     C                   Eval      @CSTA = P#TOAM
     C*
     C                   Else
 
     C                   Clear                   D#DTA
     C                   Eval      D#FAMT = @CSTD
     C                   Eval      D#FCCY = @CCCY
     C                   Eval      D#TCCY = @RCCY
                                                                                CFT009
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @CSTD         PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @CSTA                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
 
     C                   CALL      'AOCCYCV0'
     C                   Parm      *BLANKS       C#RTCD
     C                   Parm      '*F*T*SPT'    C#ACTN
     C     D#DTA         Parm                    D#DTA
 
     C                   If        C#RTCD <> *Blanks
     C                   Move      'FTVCHPY'     DBPGM
     C                   Move      'AOCCYCV0'    DBFILE
     C                   Eval      DBASE = 5
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
      * Set Valid Fields
     C                   Eval      @CSTA = D#TAMT
     C                   End
                                                                                CFT009
     C                   EndIf                                                  CFT009
 
     C                   Else                                                   CFT009
     C                   Eval      @CSTA = 0                                    CFT009
     C                   End
 
     C                   Eval       WTLCHG = WTLCHG + @CSTA
 
 
      *  SWIFT Priority Charge
     C                   If        @SPCD <> 0
 
     C                   If        @CEU006 = 'Y'
     C                             AND @CFT009 = 'N'                            CFT009
 
     C* If EMU FT Enhancement is switched on then call FT0010
     C                   Clear                   P#0010
     C                   Eval      P#FRCY = @CCCY
     C                   Eval      P#FRAM = @SPCD
     C                   Eval      P#FRDT = WDATE
     C                   Eval      P#TOCY = @RCCY
     C                   Eval      P#TODT = WDATE
     C                   Exsr      SRFT10
 
      * Set Valid Fields
     C                   Eval      @SPCH = P#TOAM
 
     C                   Else
 
     C                   Clear                   D#DTA
     C                   Eval      D#FAMT = @SPCD
     C                   Eval      D#FCCY = @CCCY
     C                   Eval      D#TCCY = @RCCY
                                                                                CFT009
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @SPCD         PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @SPCH                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
 
     C                   CALL      'AOCCYCV0'
     C                   Parm      *BLANKS       C#RTCD
     C                   Parm      '*F*T*SPT'    C#ACTN
     C     D#DTA         Parm                    D#DTA
 
     C                   If        C#RTCD <> *Blanks
     C                   Move      'FTVCHPY'     DBPGM
     C                   Move      'AOCCYCV0'    DBFILE
     C                   Eval      DBASE = 6
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
      * Set Valid Fields
     C                   Eval      @SPCH = D#TAMT
     C                   End
                                                                                CFT009
     C                   EndIf                                                  CFT009
 
     C                   Else                                                   CFT009
     C                   Eval      @SPCH = 0                                    CFT009
     C                   End
 
     C                   Eval       WTLCHG = WTLCHG + @SPCH
 
      *  Miscellaneous Charge
     C                   If        @MSCD <> 0
 
     C                   If        @CEU006 = 'Y'
     C                             AND @CFT009 = 'N'                            CFT009
 
     C* If EMU FT Enhancement is switched on then call FT0010
     C                   Clear                   P#0010
     C                   Eval      P#FRCY = @CCCY
     C                   Eval      P#FRAM = @MSCD
     C                   Eval      P#FRDT = WDATE
     C                   Eval      P#TOCY = @RCCY
     C                   Eval      P#TODT = WDATE
     C                   Exsr      SRFT10
 
      * Set Valid Fields
     C                   Eval      @MSCH = P#TOAM
 
     C                   Else
 
     C                   Clear                   D#DTA
     C                   Eval      D#FAMT = @MSCD
     C                   Eval      D#FCCY = @CCCY
     C                   Eval      D#TCCY = @RCCY
                                                                                CFT009
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @MSCD         PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @MSCH                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
 
     C                   CALL      'AOCCYCV0'
     C                   Parm      *BLANKS       C#RTCD
     C                   Parm      '*F*T*SPT'    C#ACTN
     C     D#DTA         Parm                    D#DTA
 
     C                   If        C#RTCD <> *Blanks
     C                   Move      'FTVCHPY'     DBPGM
     C                   Move      'AOCCYCV0'    DBFILE
     C                   Eval      DBASE = 7
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
      * Set Valid Fields
     C                   Eval      @MSCH = D#TAMT
     C                   End
                                                                                CFT009
     C                   EndIf                                                  CFT009
 
     C                   Else                                                   CFT009
     C                   Eval      @MSCH = 0                                    CFT009
     C                   End
 
     C                   Eval       WTLCHG = WTLCHG + @MSCH
 
     C** FX/Change Commission
     C                   If        @CHCD <> 0 and
     C                             @01494 = 'Y'
 
     C                   If        @CEU006 = 'Y'
     C                             AND @CFT009 = 'N'                            CFT009
 
     C* If EMU FT Enhancement is switched on then call FT0010
     C                   Clear                   P#0010
     C                   Eval      P#FRCY = @CCCY
     C                   Eval      P#FRAM = @CHCD
     C                   Eval      P#FRDT = WDATE
     C                   Eval      P#TOCY = @RCCY
     C                   Eval      P#TODT = WDATE
     C                   Exsr      SRFT10
 
      * Set Valid Fields
     C                   Eval      @CHCM = P#TOAM
 
     C                   Else
 
     C                   Clear                   D#DTA
     C                   Eval      D#FAMT = @CHCD
     C                   Eval      D#FCCY = @CCCY
     C                   Eval      D#TCCY = @RCCY
                                                                                CFT009
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @CHCD         PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @CHCM                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
 
     C                   CALL      'AOCCYCV0'
     C                   Parm      *BLANKS       C#RTCD
     C                   Parm      '*F*T*SPT'    C#ACTN
     C     D#DTA         Parm                    D#DTA
 
     C                   If        C#RTCD <> *Blanks
     C                   Move      'FTVCHPY'     DBPGM
     C                   Move      'AOCCYCV0'    DBFILE
     C                   Eval      DBASE = 8
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
      * Set Valid Fields
     C                   Eval      @CHCM = D#TAMT
 
     C                   End
                                                                                CFT009
     C                   EndIf                                                  CFT009
 
     C                   Else                                                   CFT009
     C                   Eval      @CHCM = 0                                    CFT009
     C                   End
 
     C                   Eval       WTLCHG = WTLCHG + @CHCM
                                                                                CFT009
      *  If CFT009 is on, calculate swift standard and miscellaneous            CFT009
      *  charge                                                                 CFT009
                                                                                CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C                   IF        @SSCD <> 0                                   CFT009
                                                                                CFT009
     C                   CLEAR                   D#DTA                          CFT009
     C                   EVAL      D#FAMT = @SSCD                               CFT009
     C                   EVAL      D#FCCY = @CCCY                               CFT009
     C                   EVAL      D#TCCY = @RCCY                               CFT009
 
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @SSCD         PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @SSCH                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
                                                                                CFT009
     C                   CALL      'AOCCYCV0'                                   CFT009
     C                   PARM      *BLANKS       C#RTCD                         CFT009
     C                   PARM      '*F*T*SPT'    C#ACTN                         CFT009
     C     D#DTA         PARM                    D#DTA                          CFT009
                                                                                CFT009
     C                   IF        C#RTCD <> *BLANKS                            CFT009
     C                   MOVE      'FTVCHPY'     DBPGM                          CFT009
     C                   MOVE      'AOCCYCV0'    DBFILE                         CFT009
     C                   EVAL      DBASE = 12                                   CFT009
     C                   MOVEL     '*CALL'       DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Set Valid Fields                                                        CFT009
     C                   EVAL      @SSCH = D#TAMT                               CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
     C                   Eval      @SSCH = 0                                    CFT009
     C                   EndIf                                                  CFT009
                                                                                CFT009
     C                   EVAL       WTLCHG = WTLCHG + @SSCH                     CFT009
                                                                                CFT009
     C                   IF        @MI1CD <> 0                                  CFT009
                                                                                CFT009
     C                   CLEAR                   D#DTA                          CFT009
     C                   EVAL      D#FAMT = @MI1CD                              CFT009
     C                   EVAL      D#FCCY = @CCCY                               CFT009
     C                   EVAL      D#TCCY = @RCCY                               CFT009
 
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @MI1CD        PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @M1CH                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
                                                                                CFT009
     C                   CALL      'AOCCYCV0'                                   CFT009
     C                   PARM      *BLANKS       C#RTCD                         CFT009
     C                   PARM      '*F*T*SPT'    C#ACTN                         CFT009
     C     D#DTA         PARM                    D#DTA                          CFT009
                                                                                CFT009
     C                   IF        C#RTCD <> *BLANKS                            CFT009
     C                   MOVE      'FTVCHPY'     DBPGM                          CFT009
     C                   MOVE      'AOCCYCV0'    DBFILE                         CFT009
     C                   EVAL      DBASE = 13                                   CFT009
     C                   MOVEL     '*CALL'       DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Set Valid Fields                                                        CFT009
     C                   EVAL      @M1CH = D#TAMT                               CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
     C                   Eval      @M1CH = 0                                    CFT009
     C                   EndIf                                                  CFT009
                                                                                CFT009
     C                   EVAL       WTLCHG = WTLCHG + @M1CH                     CFT009
                                                                                CFT009
     C                   IF        @MI2CD <> 0                                  CFT009
                                                                                CFT009
     C                   CLEAR                   D#DTA                          CFT009
     C                   EVAL      D#FAMT = @MI2CD                              CFT009
     C                   EVAL      D#FCCY = @CCCY                               CFT009
     C                   EVAL      D#TCCY = @RCCY                               CFT009
 
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @MI2CD        PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @M2CH                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
                                                                                CFT009
     C                   CALL      'AOCCYCV0'                                   CFT009
     C                   PARM      *BLANKS       C#RTCD                         CFT009
     C                   PARM      '*F*T*SPT'    C#ACTN                         CFT009
     C     D#DTA         PARM                    D#DTA                          CFT009
                                                                                CFT009
     C                   IF        C#RTCD <> *BLANKS                            CFT009
     C                   MOVE      'FTVCHPY'     DBPGM                          CFT009
     C                   MOVE      'AOCCYCV0'    DBFILE                         CFT009
     C                   EVAL      DBASE = 14                                   CFT009
     C                   MOVEL     '*CALL'       DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Set Valid Fields                                                        CFT009
     C                   EVAL      @M2CH = D#TAMT                               CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
     C                   Eval      @M2CH = 0                                    CFT009
     C                   EndIf                                                  CFT009
                                                                                CFT009
     C                   EVAL       WTLCHG = WTLCHG + @M2CH                     CFT009
                                                                                CFT009
     C                   IF        @MI3CD <> 0                                  CFT009
                                                                                CFT009
     C                   CLEAR                   D#DTA                          CFT009
     C                   EVAL      D#FAMT = @MI3CD                              CFT009
     C                   EVAL      D#FCCY = @CCCY                               CFT009
     C                   EVAL      D#TCCY = @RCCY                               CFT009
 
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @MI3CD        PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @M3CH                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
                                                                                CFT009
     C                   CALL      'AOCCYCV0'                                   CFT009
     C                   PARM      *BLANKS       C#RTCD                         CFT009
     C                   PARM      '*F*T*SPT'    C#ACTN                         CFT009
     C     D#DTA         PARM                    D#DTA                          CFT009
                                                                                CFT009
     C                   IF        C#RTCD <> *BLANKS                            CFT009
     C                   MOVE      'FTVCHPY'     DBPGM                          CFT009
     C                   MOVE      'AOCCYCV0'    DBFILE                         CFT009
     C                   EVAL      DBASE = 15                                   CFT009
     C                   MOVEL     '*CALL'       DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Set Valid Fields                                                        CFT009
     C                   EVAL      @M3CH = D#TAMT                               CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
     C                   Eval      @M3CH = 0                                    CFT009
     C                   EndIf                                                  CFT009
                                                                                CFT009
     C                   EVAL       WTLCHG = WTLCHG + @M3CH                     CFT009
                                                                                CFT009
     C                   IF        @MI4CD <> 0                                  CFT009
                                                                                CFT009
     C                   CLEAR                   D#DTA                          CFT009
     C                   EVAL      D#FAMT = @MI4CD                              CFT009
     C                   EVAL      D#FCCY = @CCCY                               CFT009
     C                   EVAL      D#TCCY = @RCCY                               CFT009
 
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @MI4CD        PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @M4CH                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
                                                                                CFT009
     C                   CALL      'AOCCYCV0'                                   CFT009
     C                   PARM      *BLANKS       C#RTCD                         CFT009
     C                   PARM      '*F*T*SPT'    C#ACTN                         CFT009
     C     D#DTA         PARM                    D#DTA                          CFT009
                                                                                CFT009
     C                   IF        C#RTCD <> *BLANKS                            CFT009
     C                   MOVE      'FTVCHPY'     DBPGM                          CFT009
     C                   MOVE      'AOCCYCV0'    DBFILE                         CFT009
     C                   EVAL      DBASE = 16                                   CFT009
     C                   MOVEL     '*CALL'       DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Set Valid Fields                                                        CFT009
     C                   EVAL      @M4CH = D#TAMT                               CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
     C                   Eval      @M4CH = 0                                    CFT009
     C                   EndIf                                                  CFT009
                                                                                CFT009
     C                   EVAL       WTLCHG = WTLCHG + @M4CH                     CFT009
                                                                                CFT009
     C                   IF        @MI5CD <> 0                                  CFT009
                                                                                CFT009
     C                   CLEAR                   D#DTA                          CFT009
     C                   EVAL      D#FAMT = @MI5CD                              CFT009
     C                   EVAL      D#FCCY = @CCCY                               CFT009
     C                   EVAL      D#TCCY = @RCCY                               CFT009
 
      ** Change to use FTCALCLEV, if CFT009 is turned on.                       CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   CALLB     'FTCALCLEV'                                  CFT009
     C                   PARM      *BLANKS       PRet_Code        10            CFT009
     C                   PARM      @MI5CD        PCharge_Amt      13 0          CFT009
     C                   PARM      SPCCY         PPay_Ccy          3            CFT009
     C                   PARM      SSMCY         PSettle_Ccy       3            CFT009
     C                   PARM      @CCCY         PCharge_Ccy       3            CFT009
     C                   PARM      @RCCY         PLev_Ccy          3            CFT009
     C                   PARM      Rate_to_use   PExch_Rate       13 8          CFT009
     C                   PARM      *Zeros        PLev_Charge      13 0          CFT009
     C                   PARM      *Blanks       PLev_Charge_F    16            CFT009
                                                                                CFT009
     C                   Z-Add     PLev_Charge   @M5CH                          CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
                                                                                CFT009
     C                   CALL      'AOCCYCV0'                                   CFT009
     C                   PARM      *BLANKS       C#RTCD                         CFT009
     C                   PARM      '*F*T*SPT'    C#ACTN                         CFT009
     C     D#DTA         PARM                    D#DTA                          CFT009
                                                                                CFT009
     C                   IF        C#RTCD <> *BLANKS                            CFT009
     C                   MOVE      'FTVCHPY'     DBPGM                          CFT009
     C                   MOVE      'AOCCYCV0'    DBFILE                         CFT009
     C                   EVAL      DBASE = 17                                   CFT009
     C                   MOVEL     '*CALL'       DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Set Valid Fields                                                        CFT009
     C                   EVAL      @M5CH = D#TAMT                               CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
     C                   Eval      @M5CH = 0                                    CFT009
     C                   EndIf                                                  CFT009
                                                                                CFT009
     C                   EVAL       WTLCHG = WTLCHG + @M5CH                     CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * If Charge currency vat = 0 set levied currency vat to 0                 CFT009
     C                   If        @VATD = 0                                    CFT009
     C                   Eval      @VATT = 0                                    CFT009
     C                   EndIf                                                  CFT009
 
      * Inlcude V.A.T. amount if V.A.T. processing allowed
     C                   If        @VATP = 'Y' and
     C                             @VATD <> 0
 
     C                   If        @CEU006 = 'Y'
     C                             AND @CFT009 = 'N'                            CFT009
 
     C* If EMU FT Enhancement is switched on then call FT0010
     C                   Clear                   P#0010
     C                   Eval      P#FRCY = @CCCY
     C                   Eval      P#FRAM = @VATD
     C                   Eval      P#FRDT = WDATE
     C                   Eval      P#TOCY = @RCCY
     C                   Eval      P#TODT = WDATE
     C                   Exsr      SRFT10
 
      * Set Valid Fields
     C                   Eval      @VATT =  P#TOAM
 
     C                   Else
 
     C                   Clear                   D#DTA
     C                   Eval      D#FAMT = @VATD
     C                   Eval      D#FCCY = @CCCY
     C                   Eval      D#TCCY = @RCCY
 
      *                                                                         CFT009
      * Calculate levied VAT separately if CFT009 is on.                        CFT009
      *                                                                         CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   EVAL      @VATT = 0                                    CFT009
      * Transfer commission                                                     CFT009
                                                                                CFT009
     C                   IF        SVAT1 = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @TRCM                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Telex                                                                   CFT009
                                                                                CFT009
     C                   IF        SVAT2 = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @TXCH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Cheque                                                                  CFT009
                                                                                CFT009
     C                   IF        SVAT3 = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @CQCH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Costs                                                                   CFT009
                                                                                CFT009
     C                   IF        SVAT4 = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @CSTA                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * SWIFT priority                                                          CFT009
                                                                                CFT009
     C                   IF        SVAT5 = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @SPCH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Miscellaneous                                                           CFT009
                                                                                CFT009
     C                   IF        SVAT6 = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @MSCH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Fx/Change commission                                                    CFT009
                                                                                CFT009
     C                   IF        SVAT7 = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @CHCM                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Miscellaneous 1                                                         CFT009
                                                                                CFT009
     C                   IF        VAT9  = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @M1CH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Miscellaneous 2                                                         CFT009
                                                                                CFT009
     C                   IF        VAT10 = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @M2CH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Miscellaneous 3                                                         CFT009
                                                                                CFT009
     C                   IF        VAT11 = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @M3CH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Miscellaneous 4                                                         CFT009
                                                                                CFT009
     C                   IF        VAT12 = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @M4CH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Miscellaneous 5                                                         CFT009
                                                                                CFT009
     C                   IF        VAT13 = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @M5CH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * SWIFT standard                                                          CFT009
                                                                                CFT009
     C                   IF        VAT14 = 'Y'                                  CFT009
     C                   EVAL      @VATT = @VATT + @SSCH                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * V.A.T. amount = total x V.A.T. rate.                                    CFT009
                                                                                CFT009
     C                   Eval(H)   @VATT = @VATT * @VATR                        CFT009
                                                                                CFT009
     C                   Else                                                   CFT009
 
     C                   CALL      'AOCCYCV0'
     C                   Parm      *BLANKS       C#RTCD
     C                   Parm      '*F*T*SPT'    C#ACTN
     C     D#DTA         Parm                    D#DTA
 
     C                   If        C#RTCD <> *Blanks
     C                   Move      'FTVCHPY'     DBPGM
     C                   Move      'AOCCYCV0'    DBFILE
     C                   Eval      DBASE = 10
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
      * Set Valid Fields
     C                   Eval      @VATT =  D#TAMT
     C                   End
                                                                                CFT009
     C                   EndIf                                                  CFT009
 
     C                   End
 
     C                   Eval       WTLCHG = WTLCHG + @VATT
     C                   Eval       @TOTCHG = WTLCHG                            CFT014
 
      *  Check that total charges do not exceed payment amount if the
      *  add/deduct indicator is 'D' and 'Charges To The Debit Of' has
      *  not been entered.
     C                   If        SADDC = 'D' and
     C                             @CDRT = *Blanks
 
      *  Check if total charges are greater than the payment value
     C                   If         WTLCHG > @PYAM
      * Send error to screen
     C                   Add       1             Idx
     C                   Movel     'WTLCHG'      FldNamXAr(Idx)
     C                   Movel     'MMA1095'     MsgIdXAr(Idx)
 
      *  Reverse image the Charge fields with amounts in them
     C                   If        @TRCM <> 0
     C                   Move      'N'           OKTrcd
     C                   Movel     'STRCD'       FldNamXAr(Idx)
     C                   End
 
     C                   If        @TXCH <> 0
     C                   Move      'N'           OKTxcd
     C                   Movel     'STXCD'       FldNamXAr(Idx)
     C                   End
 
     C                   If        @CQCH <> 0
     C                   Move      'N'           OKCqcd
     C                   Movel     'SCQCD'       FldNamXAr(Idx)
     C                   End
 
     C                   If        @CSTA <> 0
     C                   Move      'N'           OKCstd
     C                   Movel     'SCSTD'       FldNamXAr(Idx)
     C                   End
 
     C                   If        @SPCH <> 0
     C                   Move      'N'           OKSpcd
     C                   Movel     'SSPCD'       FldNamXAr(Idx)
     C                   End
 
     C                   If        @MSCH <> 0
     C                   Move      'N'           OKMscd
     C                   Movel     'SMSCD'       FldNamXAr(Idx)
     C                   End
 
     C                   If        @CHCM <> 0 and
     C                             @01494 = 'Y'
     C                   Move      'N'           OKChcd
     C                   Movel     'SCHCD'       FldNamXAr(Idx)
     C                   End
                                                                                CFT009
      * For CFT009 only, SWIFT standard and miscellaneous charges 1-5           CFT009
                                                                                CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
                                                                                CFT009
     C                   IF        @SSCH <> 0                                   CFT009
     C                   MOVE      'N'           OKSTCD                         CFT009
     C                   MOVEL     'STCD'        FLDNAMXAR(IDX)                 CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @M1CH <> 0                                   CFT009
     C                   MOVE      'N'           OKM1CD                         CFT009
     C                   MOVEL     'M1CD'        FLDNAMXAR(IDX)                 CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @M2CH <> 0                                   CFT009
     C                   MOVE      'N'           OKM2CD                         CFT009
     C                   MOVEL     'M2CD'        FLDNAMXAR(IDX)                 CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @M3CH <> 0                                   CFT009
     C                   MOVE      'N'           OKM3CD                         CFT009
     C                   MOVEL     'M3CD'        FLDNAMXAR(IDX)                 CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @M4CH <> 0                                   CFT009
     C                   MOVE      'N'           OKM4CD                         CFT009
     C                   MOVEL     'M4CD'        FLDNAMXAR(IDX)                 CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @M5CH <> 0                                   CFT009
     C                   MOVE      'N'           OKM5CD                         CFT009
     C                   MOVEL     'M5CD'        FLDNAMXAR(IDX)                 CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
 
     C                   End
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF VALIDATION                                             *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*  SRFT10   : Calculates Currency Amounts for EMU               *
     C*****************************************************************
     CSR   SRFT10        BEGSR
     C*
     C                   CALL      'FT0010'
     C                   Parm                    P#0010
 
      *  Check if database error occurred
     C                   If        P#RTCD <> *Blanks
     C                   Move      'FTVCHPY'     DBPGM
     C                   Move      'FT0010'      DBFILE
     C                   Eval      DBASE = 11
     C                   Movel     P#TOCY        DBKEY
     C                   Exsr      *PSSR
     C                   End
      *
     CSR                 ENDSR
     C*****************************************************************
     C* END OF SRFT10                                                 *
     C*****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInPrim
     C***********        Parm                    TranInThir                     CFT014
     C                   Parm                    TranInFour                     CFT014
 
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
                                                                                CFT009
      *  Extra rate required for FTCALCLEV                                      CFT009
     C                   Parm                    O2XRTE           13 8          CFT009
 
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
