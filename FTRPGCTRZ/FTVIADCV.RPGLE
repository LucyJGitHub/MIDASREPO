     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP advice charge')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIADCV - Validate Advice Charge                            *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CFT157             Date 29Aug14               *
      *  Prev Amend No. MD000091           Date 03May13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 242926             Date 13Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG433             Date 05Dec05               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 06May06               *
      *                 CGL029             Date 01Sep03               *
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
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  242926 - Error in recalculation of Commission               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Change Customer Number to alpha.                    *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
     FFTPCHGL0  IF   E           K DISK                                         CFT009
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
      *                                                                         CFT009
      ** The following /COPY line includes the definitions for error and        CFT009
      ** warning message arrays.                                                CFT009
      *                                                                         CFT009
      /COPY ZACPYSRC,ERR_ARRAYS                                                 CFT009
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
      *                                                                         CFT009
      *                                                                         CFT009
      ** Work array for warning message Ids                                     CFT009
     D WPrvWarnAr      S                   Dim(ArrayMax)                        CFT009
     D                                     Like(WMsgIDArr)                      CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     D NWIP1SCNFMT   E DS                  EXTNAME(FTIPY1PD)                    CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     D*NwIP4ScnFmt***E DS                  EXTNAME(FTIPY4PD)                    CFT014
     D NwIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)                    CFT014
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *                                                                         CFT009
      ** Incoming Payments (additional details) for file update                 CFT009
     D NWIP2FILFMT   E DS                  EXTNAME(FTVIPY2PD)                   CFT009
                                                                                CFT009
      ** Valid Incoming Payments Extension File (default)                       CFT009
     D DEFVALIDX     E DS                  EXTNAME(FTVIPY2PD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
                                                                                CFT009
      * Valid Payments layout (default)                                         CFT009
     D DEFVALID      E DS                  EXTNAME(FTVIPAYPD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
                                                                                CFT009
      *  Transaction details file parameter for FT000652                        CFT009
     D TRNDET          DS          3000                                         CFT009
                                                                                CFT009
      *  Transaction details extension file parameter for FT000652              CFT009
     D TRNEXT          DS          3000                                         CFT009
      *
      ***Incoming*Payments*Lvl*2*Scrn*2*error*indicators***************         CFT014
     D*FTEIPY3****   E DS                  EXTNAME(FTEIPY3PD)                   CFT014
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT014
     D FTEIPY4       E DS                  EXTNAME(FTEIPY4PD)                   CFT014
                                                                                CFT009
      ** External data structure for currency codes                             CFT009
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    CFT009
                                                                                CFT009
      ** External data structure for access programs (short)                    CFT009
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CFT009
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
                                                                                CFT009
      ** Index for arrays of warning message ids etc                            CFT009
     D WIX             S              3P 0                                      CFT009
                                                                                CFT009
      ** Flags for warning message processing                                   CFT009
     D WFTF3203        S              1                                         CFT009
     D WFTF3202        S              1                                         CFT009
                                                                                CFT009
      * Parameter for FT000940                                                  CFT009
     D P#PYCD          S                   LIKE(PYCHCD)                         CFT009
                                                                                CFT009
      ** Parameters for FT000652                                                CFT009
     D MRTCD           S             10                                         CFT009
     D TRNTYP          S              2                                         CFT009
     D CHGCDE          S              5                                         CFT009
     D INKC            S              1                                         CFT009
                                                                                CFT009
      ** Parameters for FT000981                                                CFT009
     D WRTCD           S             10A                                        CFT009
     D PAYAMT          S             13P 0                                      CFT009
     D PAYCCY          S              3A                                        CFT009
     D SMCCY           S              3A                                        CFT009
     D CHGCCY          S              3A                                        CFT009
     D CHGEXC          S             13P 8                                      CFT009
     D STP             S              1A                                        CFT009
     D SETAMT          S             13P 0                                      CFT009
     D*PCDRO****       S             12S 0                                             CFT009 CGL029
     D*PCDRO****       S             18S 0                                             CGL029 CSD027
     D PCDRO           S             18A                                                      CSD027
     D PADDC           S              1A                                        CFT009
     D TOTCHG          S             13P 0                                      CFT009
     D CHGAMT          S             13P 0                                      CFT009
     D PTIERC          S             13A   DIM(11)                              CFT009
     D PTIERA          S             13A   DIM(11)                              CFT009
     D P_ChgDRCcy      S              3A                                                      CFT120
                                                                                CFT009
      * Parameters for AOCURRR0                                                 CFT009
     D C#CURR          S              3                                         CFT009
     D C#OPTN          S              7                                         CFT009
     D C#RTCD          S              7                                         CFT009
      *
      ** Error message array
     D WMsgArr         S             20    DIM(1) CTDATA PERRCD(1)
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
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
      ** Initialise variables for update of Valid File fields.
     C                   Z-ADD     0             WAdCd            11 0
     C                   Z-ADD     0             WDUM8            11 0
     C                   Z-ADD     0             WVATT            11 0
     C                   Z-ADD     0             IPADCH
     C                   Z-ADD     0             IPDUMA4
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
     C                   EVAL      WFLDNMXAR = *BLANKS                          CFT009
     C                   EVAL      WMSGIDXAR  = *BLANKS                         CFT009
     C                   EVAL      WMSGDTXAR = *BLANKS                          CFT009
     C                   EVAL      WIX = 0                                      CFT009
     C                   MOVEL     *Blanks       WVCHG            20
                                                                                CFT009
      * If CFT009 is on, validate advice charge code                            CFT009
                                                                                CFT009
     C                   IF        CFT009 = 'Y' AND ADCDE <> *BLANKS            CFT009
     C                   EXSR      VADCODE                                      CFT009
                                                                                CFT009
      * If charge code is not the same as default, warning                      CFT009
      * Before putting out warning check array WPrvWarnAr for message           CFT009
      * FTF3202 to determine if warning has already been displayed.             CFT009
     C                   IF        ADCDE = D#I2ADCD                             CFT009
     C                   EVAL      WFTF3202 = *BLANKS                           CFT009
     C                   ENDIF                                                  CFT009
     C                   IF        WFTF3202 <> 'Y'                              CFT009
     C                   Z-ADD     1             X                 3 0          CFT009
     C     'FTF3202'     LOOKUP    WPrvWarnAr(X)                          99    CFT009
     C                   IF        *IN99 = *ON                                  CFT009
     C                   EVAL      WFTF3202 = 'Y'                               CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'                 CFT009
     C                   IF        ADCDE <> D#I2ADCD                            CFT009
     C                             AND OKADCDE <> 'N' AND CFT009 = 'Y'          CFT009
     C                             AND WFTF3202 <> 'Y'                          CFT009
     C                   MOVE      'W'           OKADCDE                        CFT009
     C                   ADD       1             WIX                            CFT009
     C                   MOVEL     'ADCDE'       WFLDNMXAR(WIX)                 CFT009
     C                   MOVEL     'FTF3202'     WMSGIDXAR(WIX)                 CFT009
     C                   EVAL      RETCODEIN = 'ERROR'                          CFT009
     C                   EVAL      WFTF3202 = 'Y'                               CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Validate Advice Charge and V.A.T
      *
     C                   EXSR      SRValAdChVAT
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
      * If charge amount is not the same as default, warning                    CFT009
      * Before putting out warning check array WPrvWarnAr for message           CFT009
      * FTF3203 to determine if warning has already been displayed.             CFT009
     C                   IF        WADCD = D#IPDUMA4                            CFT009
     C                   EVAL      WFTF3203 = *BLANKS                           CFT009
     C                   ENDIF                                                  CFT009
     C                   IF        WFTF3203 <> 'Y'                              CFT009
     C                   Z-ADD     1             X                 3 0          CFT009
     C     'FTF3203'     LOOKUP    WPrvWarnAr(X)                          99    CFT009
     C                   IF        *IN99 = *ON                                  CFT009
     C                   EVAL      WFTF3203 = 'Y'                               CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'                 CFT009
     C                   IF        WADCD <> D#IPDUMA4                           CFT009
     C                             AND OKADCD <> 'N' AND CFT009 = 'Y'           CFT009
     C                             AND WFTF3203 <> 'Y'                          CFT009
     C                   MOVE      'W'           OKADCD                         CFT009
     C                   ADD       1             WIX                            CFT009
     C                   MOVEL     'DDADCD'      WFLDNMXAR(WIX)                 CFT009
     C                   MOVEL     'FTF3203'     WMSGIDXAR(WIX)                 CFT009
     C                   EVAL      RETCODEIN = 'ERROR'                          CFT009
     C                   EVAL      WFTF3203 = 'Y'                               CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKADCD = 'N' or
     C                             OKVAT4 = 'N'
     C                             OR CFT009 = 'Y' AND OKADCDE = 'N'            CFT009
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        OKADCD <> 'N'
     C                   MOVE      WAdCd         IPDUMA4
     C                   ADD       WDUM8         IPINDUM8
     C                   ENDIF
      *
     C                   IF        OKVAT4 <> 'N'
     C                   MOVE      DDVAT4        IPINVAT4
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
     C                   IF        OKADCDE <> 'N' AND CFT009 = 'Y'              CFT009
     C                   MOVE      ADCDE         I2ADCD                         CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALADCHVAT - Validate Advice Charge and V.A.T              *
      *                                                               *
      *****************************************************************
     C     SRValAdChVAT  BEGSR
      *
     C                   EXSR      SRValAdCh
      *
      ** Calculate V.A.T charge amounts if V.A.T processing Allowed
      *
     C                   IF        S01499 = 'Y'
     C                             AND CFT009 ='N' OR CFT010 = 'Y'              CFT009
     C                   EXSR      SRValVAT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALADCH - Validate Advice Charges                          *
      *                                                               *
      *****************************************************************
     C     SRValAdCh     BEGSR
      *
      ** Advice Charge is optional.
      ** If entered must be valid for charge currency details
      *
     C                   IF        DDADCD <> *Blanks
                                                                                CFT009
      * ? processing - Charge enquiry                                           CFT009
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
                                                                                CFT009
     C     '?'           SCAN      DDADCD                                       CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
                                                                                CFT009
     C                   IF        OKADCDE = 'N' OR ADCDE = *BLANKS             CFT009
     C                   MOVE      'N'           OKADCD                         CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'DDADCD'      FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTF3206'     MSGIDXAR(IDX)                  CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
     C                   EVAL      TRNDET = NWIPFILFMT                          CFT009
     C                   EVAL      TRNEXT = NWIP2FILFMT                         CFT009
                                                                                CFT009
     C                   CALLB     'FT000652'                                   CFT009
     C                   PARM      *BLANKS       MRTCD                          CFT009
     C                   PARM                    TRNDET                         CFT009
     C                   PARM                    TRNEXT                         CFT009
     C                   PARM      'IN'          TRNTYP                         CFT009
     C                   PARM      ADCDE         CHGCDE                         CFT009
     C                   PARM                    INKC                           CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
      *
     C     11            SUB       PINBDP        ZADig
     C                   Z-ADD     PINBDP        ZADec
     C                   MOVEL     *Blanks       ZField
     C                   MOVEL     DDADCD        ZField
      *
      ** Validate Amount as numeric with correct d.p.
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOk          1
     C                   PARM                    ZField           16
     C                   PARM                    ZADec             1 0
     C                   PARM                    ZADig             2 0
      *
     C                   If        ZAlignOk <> 'Y'
     C                   MOVE      'N'           OKADCD
     C                   ADD       1             IDx
     C                   MOVEL     'DDADCD'      FldNamXAr(IDx)
     C                   MOVEL     'FTM2104'     MsgIdXAr(IDx)
     C*****DDADCD        CAT(P)    PICCY         MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDADCD))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDADCD)                   MD000091
     C                   EVAL      BLen = %Len(%Trim(PICCY))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(PICCY)                    MD000091
     C                   Else
     C                   MOVE      ZField        WAdCd
      *
      ** Format amount for screen
     C                   Z-ADD     WAdCd         P0AMTW
     C                   Z-ADD     PINBDP        P0QECN
     C                   EXSR      SRFmtAmt
     C                   MOVE      P0AMTD        DDADCD
     C                   EndIf
                                                                                CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
      * If charge code <> blank and charge amount = blank, recalculate          CFT009
      * charge amount                                                           CFT009
     C******             IF        CFT009 = 'Y' AND ADCDE <> *BLANKS            CFT009        242926
     C******                       AND OKADCDE <> 'N' AND DDADCD = *BLANKS      CFT009        242926
     C******                       OR DDCDRO <> *BLANKS AND OKCDRO <> 'N'       CFT009        242926
     C******                       AND ADCDE <> *BLANKS                         CFT009        242926
     C******                       OR PCDROCHG = 'Y' AND ADCDE <> *BLANKS       CFT009        242926
     C                   IF        CFT009 = 'Y' AND ADCDE <> *BLANKS                          242926
     C                             AND OKADCDE <> 'N' AND DDADCD = *BLANKS                    242926
     C                             OR DDCDRO <> *BLANKS AND OKCDRO <> 'N'                     242926
     C                             AND ADCDE <> *BLANKS AND OKADCDE <> 'N'                    242926
     C                             OR PCDROCHG = 'Y' AND ADCDE <> *BLANKS                     242926
     C                             AND OKADCDE <> 'N'                                         242926
                                                                                CFT009
     C                   CALLB     'AOCURRR0'                                   CFT009
     C                   PARM      *Blanks       C#RTCD                         CFT009
     C                   PARM      '*KEY   '     C#OPTN                         CFT009
     C                   PARM      PICCY         C#CURR                         CFT009
     C     SDCURR        PARM      *BLANKS       DSSDY                          CFT009
                                                                                CFT009
     C                   EVAL      CHGEXC = A6SPRT                              CFT009
                                                                                CFT009
      * If use transaction exchange rate, add it in                             CFT009
     C                   IF        CHTRCY = 'Y'                                 CFT009
     C                   IF        PICCY = IPSMCY AND POCCY = IPPCCY            CFT009
     C                             OR POCCY = IPSMCY AND PICCY = IPPCCY         CFT009
     C                   EVAL      CHGEXC = I2XRTE                              CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   CALLB     'FT000981'                                   CFT009
      * OUTPUTS:                                                                CFT009
      *                                                                         CFT009
      ** Return Code (10A)                                                      CFT009
      ** Payment Amount (13,0)                                                  CFT009
      ** Payment Currency (3A)                                                  CFT009
      ** Charges Currency (3A)                                                  CFT009
      ** Exchange Rate from transaction (13,8)                                  CFT009
      ** STP flag (1A)                                                          CFT009
      ** Payment Charge Code (5A)                                               CFT009
      ** Settle Amount (13,0)                                                   CFT009
      ** Charges to debit of account (12A)                                      CFT009
      ** Add deduct indicator (1A)                                              CFT009
      ** Charges to the DR of Currency (3A)                                                   CFT120
     C                   PARM      *BLANKS       WRTCD                          CFT009
     C                   PARM      IPPYAM        PAYAMT                         CFT009
     C                   PARM      IPPCCY        PAYCCY                         CFT009
     C                   PARM      IPSMCY        SMCCY                          CFT009
     C                   PARM      PICCY         CHGCCY                         CFT009
     C                   PARM                    CHGEXC                         CFT009
     C                   PARM      'M'           STP                            CFT009
     C                   PARM      ADCDE         CHGCDE                         CFT009
     C                   PARM      IPSMAM        SETAMT                         CFT009
     C                   PARM      IPCDRO        PCDRO                          CFT009
     C                   PARM      IPADDC        PADDC                          CFT009
     C                   PARM      IPCDRC        P_ChgDRCcy                                   CFT120
      *                                                                         CFT009
      * RETURNS:                                                                CFT009
      ** Total Charge (13,0)                                                    CFT009
      ** Chargeable Amount (13,0)                                               CFT009
      ** Charge per Tier (11 x 13A)                                             CFT009
      ** Amount being charged by Tier (11 x 13A)                                CFT009
     C                   PARM                    TOTCHG                         CFT009
     C                   PARM                    CHGAMT                         CFT009
     C                   PARM                    PTIERC                         CFT009
     C                   PARM                    PTIERA                         CFT009
      *                                                                         CFT009
      * Reset warning indicators                                                CFT009
     C                   EVAL      WFTF3203 = *BLANKS                           CFT009
     C                   EVAL      WFTF3202 = *BLANKS                           CFT009
                                                                                CFT009
     C                   EVAL      WADCD = TOTCHG                               CFT009
                                                                                CFT009
     C                   Z-ADD     TOTCHG        P0AMTW                         CFT009
     C                   Z-ADD     PINBDP        P0QECN                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      P0AMTD        DDADCD                         CFT009
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALVAT - Validate V.A.T                                    *
      *                                                               *
      *****************************************************************
     C     SRValVAT      BEGSR
      *
     C                   MOVEL     WMsgArr(1)    WVCHG
 
      *  If CFT010 on, flag is 'Y'                                              CFT009
      *
     C                   IF        DDVAT4 = *Blanks
 
     C                   IF        CFT010 = 'Y'                                 CFT009
     C                   MOVEL     'Y'           DDVAT4                         CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     PVATT         DDVAT4
     C                   ENDIF                                                  CFT009
 
     C                   ELSE
     C                   If        DDVAT4 <> 'Y' and
     C                             DDVAT4 <> 'N'
     C                   MOVE      'N'           OKVAT4
     C                   ADD       1             IDx
     C                   MOVEL     'DDVAT4'      FldNamXAr(IDx)
     C                   MOVEL     'FTM2524'     MsgIdXAr(IDx)
     C*****DDVAT4        CAT       WVCHG         MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVAT4))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVAT4)                   MD000091
     C                   EVAL      BLen = %Len(%Trim(WVCHG))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(WVCHG)                    MD000091
     C                   EndIf
     C                   ENDIF
      *
      * Do vat calculation on charge totals not single charges                  CFT009
      * this now performed in program FTIPAY4VL.                                CFT009
      *                                                                         CFT009
     C                   IF        DDVAT4 = 'Y'
     C*****WAdCd*********MULT(H)   PVATR         WTVATD           13 0          CFT009
     C*****IPADCH********MULT(H)   PVATR         WTVATT           13 0          CFT009
     C*******************ADD       WTVATD        WDUM8                          CFT009
     C*******************ADD       WTVATT        WVATT                          CFT009
     C                   ADD       WAdCd         WDUM8                          CFT009
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT009
      ************************************************************              CFT009
      * VADCODE - VALIDATION OF CHEQUE CHARGE CODE                              CFT009
      ************************************************************              CFT009
      *                                                                         CFT009
     C     VADCODE       BEGSR                                                  CFT009
                                                                                CFT009
      * ? processing                                                            CFT009
                                                                                CFT009
     C     '?'           SCAN      ADCDE                                        CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
                                                                                CFT009
     C                   CALLB     'FT000940'                                   CFT009
     C                   PARM      *BLANKS       P#PYCD                         CFT009
                                                                                CFT009
     C                   IF        P#PYCD <> *BLANKS                            CFT009
     C                   EVAL      ADCDE = P#PYCD                               CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Check if charge code exists in payment charge definition file           CFT009
                                                                                CFT009
     C     ADCDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        NOT %FOUND                                   CFT009
     C                   MOVE      'N'           OKADCDE                        CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'ADCDE'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTF3278'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFMTAMT - Format amount for display                         *
      *                                                               *
      *****************************************************************
     C     SRFmtAmt      BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *Blanks       P0RETC           10
     C                   PARM                    P0AMTW           13 0
     C                   PARM                    P0QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *Blanks       P0AMTD           14
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
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP5ScnFmt                    CFT014
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Input Charge Currency
     C                   PARM                    PICCY             3
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY             3            CFT009
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP            1 0
      *
      ** STANDING DATA
      ** =============
      *
      ** VAT Default Flag
     C                   PARM                    PVATT             1
      *
      ** VAT Rate
     C                   PARM                    PVATR             5 4
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499            1
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C                   PARM                    CFT010            1            CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
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
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *                                                                         CFT009
      ** Previous warning messages array                                        CFT009
     C                   PARM                    WPrvWarnAr                     CFT009
      *                                                                         CFT009
      ** Warning message work fields                                            CFT009
     C                   PARM                    WFTF3202                       CFT009
     C                   PARM                    WFTF3203                       CFT009
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
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
(c) Misys International Banking Systems Ltd. 2001
** WMsgArr
Advice charge
