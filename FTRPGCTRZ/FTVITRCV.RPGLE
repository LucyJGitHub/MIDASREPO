     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP transfer commission')             *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVITRCV - Validate Transfer Commission                      *
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
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT157             Date 29Aug14               *
      *                 MD000091           Date 06May13               *
      *                 CFT120             Date 28Sep12               *
      *                 AR940459           Date 30Mar12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR851832           Date 06dec11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255504             Date 31Jul08               *
      *                 255429             Date 23Jul08               *
      *                 BUG17995           Date 16Apr08               *
      *                 BUG17793           Date 09Apr08               *
      *                 242756             Date 13Apr07               *
      *                 242926             Date 13Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG433             Date 05Dec05               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 16May06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186159             Date 10Nov00               *
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  AR940459 - PAUT of IPAY did not reflect the amount of        *
      *             Transfer Commission                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR851832 - Transfer Commission amount disappears after       *
      *             authorisation                                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255504 - FT - Default commission in incoming payments is     *
      *           treated by the system as an error.                  *
      *  255429 - Transfer commission amount is not re-calculated     *
      *           when transfer amount changes                        *
      *  BUG17995 - Amended charge code but charge amt not            *
      *             re-validated (Applied fix 221236).                *
      *  BUG17793 - Incorrect tranfer commission warning message      *
      *  249756 - Compare transfer commission charge based on the     *
      *           default charge from DS/PCharges.                    *
      *  242926 - Error in recalculation of Commission               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Change Customer Number to alpha.                    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  186159 - Wrong error message sent for invalid data.          *
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
      *
      *                                                                         CFT009
      ** Work array for warning message Ids                                     CFT009
     D WPrvWarnAr      S                   Dim(ArrayMax)                        CFT009
     D                                     Like(WMsgIDArr)                      CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     D NWIP1SCNFMT   E DS                  EXTNAME(FTIPY1PD)                    CFT009
                                                                                CFT009
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
      ** Data structure for Screen Charges Amount fields                                      249756
     D PCHARGES        DS           196                                                       249756
     D  DDTRCM                 1     14                                                       249756
     D  DDTXCH                15     28                                                       249756
     D  DDCQCH                29     42                                                       249756
     D  DDADCH                43     56                                                       249756
     D  DDTLCH                57     70                                                       249756
     D  DDMSCH                71     84                                                       249756
     D  DDCHCM                85     98                                                       249756
     D  DDVATT                99    112                                                       249756
     D  DDVATD               113    126                                                       249756
     D  M1CH                 127    140                                                       249756
     D  M2CH                 141    154                                                       249756
     D  M3CH                 155    168                                                       249756
     D  M4CH                 169    182                                                       249756
     D  M5CH                 183    196                                                       249756
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
     D WFTF3158        S              1                                         CFT009
     D WFTF3176        S              1                                         CFT009
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
 
      * Parameters for AOCURRR0                                                 CFT009
     D C#CURR          S              3                                         CFT009
     D C#OPTN          S              7                                         CFT009
     D C#RTCD          S              7                                         CFT009
      *
      ** Error message array
     D WMsgArr         S             20    DIM(1) CTDATA PERRCD(1)
      *                                                                                       CFT120
      ** Charges to the DR of Currency                                                        CFT120
      *                                                                                       CFT120
     D P_ChgDRCcy      S              3A                                                      CFT120
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *                                                                                     MD000091
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
     C                   Z-ADD     0             WTrCd            11 0
     C                   Z-ADD     0             WDUM8            11 0
     C                   Z-ADD     0             WVATT            11 0
     C                   Z-ADD     0             IPTRCM
     C                   Z-ADD     0             IPDUMA1
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
     C                   EVAL      WFLDNMXAR = *BLANKS                          CFT009
     C                   EVAL      WMSGIDXAR  = *BLANKS                         CFT009
     C                   EVAL      WMSGDTXAR = *BLANKS                          CFT009
     C                   EVAL      WIX = 0                                      CFT009
     C                   MOVEL     *Blanks       WVCHG            20
 
      * If CFT009 is on, validate transfer commission charge code               CFT009
                                                                                CFT009
     C                   IF        CFT009 = 'Y' AND TRCDE <> *BLANKS            CFT009
     C                   EXSR      VTCCODE                                      CFT009
                                                                                CFT009
      * If charge code is not the same as default, warning                      CFT009
      * Before putting out warning check array WPrvWarnAr for message           CFT009
      * FTF3176 to determine if warning has already been displayed.             CFT009
     C*******************IF        TRCDE = D#I2TFCD                                  CFT009 BUG17995
     C*******************EVAL      WFTF3176 = *BLANKS                                CFT009 BUG17995
     C*******************ENDIF                                                       CFT009 BUG17995
     C*******************IF        WFTF3176 <> 'Y'                                   CFT009 BUG17995
     C*******************Z-ADD     1             X                 3 0               CFT009 BUG17995
     C*****'FTF3176'*****LOOKUP    WPrvWarnAr(X)                          99         CFT009 BUG17995
     C*******************IF        *IN99 = *ON                                       CFT009 BUG17995
     C*******************EVAL      WFTF3176 = 'Y'                                    CFT009 BUG17995
     C*******************ENDIF                                                       CFT009 BUG17995
     C*******************ENDIF                                                       CFT009 BUG17995
                                                                                CFT009
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'                 CFT009
     C                   IF        TRCDE <> D#I2TFCD                            CFT009
     C                             AND OKTRCDE <> 'N' AND CFT009 = 'Y'          CFT009
     C*****************************AND WFTF3176 <> 'Y'                               CFT009 BUG17995
     C                   MOVE      'W'           OKTRCDE                        CFT009
     C                   ADD       1             WIX                            CFT009
     C                   MOVEL     'TRCDE'       WFLDNMXAR(WIX)                 CFT009
     C                   MOVEL     'FTF3176'     WMSGIDXAR(WIX)                 CFT009
     C                   EVAL      RETCODEIN = 'ERROR'                          CFT009
     C*******************EVAL      WFTF3176 = 'Y'                                    CFT009 BUG17995
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      *
      ** Validate Transfer Commission Charge and V.A.T
      *
     C                   EXSR      SRValTrCmVAT
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
      * If charge amount is not the same as default, warning                    CFT009
      * Before putting out warning check array WPrvWarnAr for message           CFT009
      * FTF3158 to determine if warning has already been displayed.             CFT009
     C**********         IF        WTRCD = D#IPDUMA1                                   CFT009 249756
     C**********         IF        DDTRCD = DDTRCM                                   249756 BUG17995
     C**********                   OR Wtrcd2 = *ZERO AND DDTRCM = *BLANKS          BUG17793 BUG17995
     C*******************EVAL      WFTF3158 = *BLANKS                                CFT009 BUG17995
     C*******************ENDIF                                                       CFT009 BUG17995
     C*******************IF        WFTF3158 <> 'Y'                                   CFT009 BUG17995
     C*******************Z-ADD     1             X                 3 0               CFT009 BUG17995
     C*****'FTF3158'*****LOOKUP    WPrvWarnAr(X)                          99         CFT009 BUG17995
     C*******************IF        *IN99 = *ON                                       CFT009 BUG17995
     C*******************EVAL      WFTF3158 = 'Y'                                    CFT009 BUG17995
     C*******************ENDIF                                                       CFT009 BUG17995
     C*******************ENDIF                                                       CFT009 BUG17995
                                                                                CFT009
     C**********         IF        DDACTN = 'I' OR DDACTN = 'A'                        CFT009 255504
     C**********         IF        WTRCD <> D#IPDUMA1                                  CFT009 249756
     C**********         IF        DDTRCD <> DDTRCM                                    249756 255504
     C**********                   AND OKTRCD <> 'N' AND CFT009 = 'Y'                  CFT009 255504
     C*****************************AND WFTF3158 <> 'Y'                               CFT009 BUG17995
     C**********         IF        Wtrcd2 <> *ZERO AND DDTRCM <> *BLANKS             BUG17793 255504
     C**********         MOVE      'W'           OKTRCD                                CFT009 255504
     C**********         ADD       1             WIX                                   CFT009 255504
     C**********         MOVEL     'DDTRCD'      WFLDNMXAR(WIX)                        CFT009 255504
     C**********         MOVEL     'FTF3158'     WMSGIDXAR(WIX)                        CFT009 255504
     C**********         EVAL      RETCODEIN = 'ERROR'                                 CFT009 255504
     C*******************EVAL      WFTF3158 = 'Y'                                    CFT009 BUG17995
     C**********         ENDIF                                                       BUG17793 255504
     C**********         ENDIF                                                         CFT009 255504
     C**********         ENDIF                                                         CFT009 255504
     C                   ENDIF                                                  CFT009
      *
     C                   Exsr      VCODCOM                                                  BUG17995
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKTRCD = 'N' or
     C                             OKVAT1 = 'N'
     C                             OR CFT009 = 'Y' AND OKTRCDE = 'N'            CFT009
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        OKTRCD <> 'N'
     C                   MOVE      WTrCd         IPDUMA1
     C                   ADD       WDUM8         IPINDUM8
     C                   ENDIF
      *
     C                   IF        OKVAT1 <> 'N'
     C                   MOVE      DDVAT1        IPINVAT1
     C                   ADD       WVATT         IPINVATT
     C                   ENDIF
      *
     C                   IF        OKTRCDE <> 'N' AND CFT009 = 'Y'              CFT009
     C                   MOVE      TRCDE         I2TFCD                         CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALTRCMVAT - Validate Transfer Commission Charge and       *
      *                 V.A.T                                         *
      *                                                               *
      *****************************************************************
     C     SRValTrCmVAT  BEGSR
      *
     C                   EXSR      SRValTrCom
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
      *  SRVALTRCOM - Validate Transfer Commission Charge             *
      *                                                               *
      *****************************************************************
     C     SRValTrCom    BEGSR
      *
      ** Transfer Commission is optional.
      ** If entered must be valid for charge currency details
      *
     C                   IF        DDTRCD <> *Blanks
                                                                                CFT009
      * ? processing - Charge enquiry                                           CFT009
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
                                                                                CFT009
     C     '?'           SCAN      DDTRCD                                       CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
                                                                                CFT009
     C                   IF        OKTRCDE = 'N' OR TRCDE = *BLANKS             CFT009
     C                   MOVE      'N'           OKTRCD                         CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'DDTRCD'      FLDNAMXAR(IDX)                 CFT009
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
     C                   PARM      TRCDE         CHGCDE                         CFT009
     C                   PARM                    INKC                           CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
      *
     C     11            SUB       PINBDP        ZADig
     C                   Z-ADD     PINBDP        ZADec
     C                   MOVEL     *Blanks       ZField
     C                   MOVEL     DDTRCD        ZField
      *
      ** Validate Amount as numeric with correct d.p.
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOk          1
     C                   PARM                    ZField           16
     C                   PARM                    ZADec             1 0
     C                   PARM                    ZADig             2 0
      *
     C                   If        ZAlignOk <> 'Y'
     C                   MOVE      'N'           OKTRCD
     C                   ADD       1             IDx
     C                   MOVEL     'DDTRCD'      FldNamXAr(IDx)
     C***********        MOVEL     'FTM2078'     MsgIdXAr(IDx)                  186159
     C                   MOVEL     'FTM2079'     MsgIdXAr(IDx)                  186159
     C*****DDTRCD        CAT(P)    PICCY         MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDTRCD))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDTRCD)                   MD000091
     C                   EVAL      BLen = %Len(%Trim(PICCY))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(PICCY)                    MD000091
     C                   Else
     C                   MOVE      ZField        WTrCd
     C                   Z-ADD     0             Wtrcd2           11 0                      BUG17793
     C                   MOVE      ZField        Wtrcd2                                     BUG17793
      *
      ** Format amount for screen
     C                   Z-ADD     WTrCd         P0AMTW
     C                   Z-ADD     PINBDP        P0QECN
     C                   EXSR      SRFmtAmt
     C                   MOVE      P0AMTD        DDTRCD
     C                   EndIf
                                                                                CFT009
     C**********         ENDIF                                                       CFT009 AR940459
     C                   ELSE                                                               AR940459
      *                                                                         CFT009
      * If charge code <> blank and charge amount = blank, recalculate          CFT009
      * charge amount                                                           CFT009
     C*****              IF        CFT009 = 'Y' AND TRCDE <> *BLANKS            CFT009        242926
     C*****                        AND OKTRCDE <> 'N' AND DDTRCD = *BLANKS      CFT009        242926
     C*****                        OR DDCDRO <> *BLANKS AND OKCDRO <> 'N'       CFT009        242926
     C*****                        AND TRCDE <> *BLANKS                         CFT009        242926
     C*****                        OR PCDROCHG = 'Y' AND TRCDE <> *BLANKS       CFT009        242926
      *                                                                                       242926
      *  Do not recalculate unless charge code is valid.                                      242926
      *                                                                                       242926
     C                   IF        CFT009 = 'Y' AND TRCDE <> *BLANKS                          242926
     C                             AND OKTRCDE <> 'N' AND DDTRCD = *BLANKS                    242926
     C                             OR DDCDRO <> *BLANKS AND OKCDRO <> 'N'                     242926
     C                             AND TRCDE <> *BLANKS AND OKTRCDE <> 'N'                    242926
     C                             OR PCDROCHG = 'Y' AND TRCDE <> *BLANKS                     242926
     C                             AND OKTRCDE <> 'N'                                         242926
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
      *                                                                                       CFT120
     C                   PARM      *BLANKS       WRTCD                          CFT009
     C                   PARM      IPPYAM        PAYAMT                         CFT009
     C                   PARM      IPPCCY        PAYCCY                         CFT009
     C                   PARM      IPSMCY        SMCCY                          CFT009
     C                   PARM      PICCY         CHGCCY                         CFT009
     C                   PARM                    CHGEXC                         CFT009
     C                   PARM      'M'           STP                            CFT009
     C                   PARM      TRCDE         CHGCDE                         CFT009
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
     C                   EVAL      WFTF3158 = *BLANKS                           CFT009
     C                   EVAL      WFTF3176 = *BLANKS                           CFT009
                                                                                CFT009
     C                   EVAL      WTRCD = TOTCHG                               CFT009
                                                                                CFT009
     C                   Z-ADD     TOTCHG        P0AMTW                         CFT009
     C                   Z-ADD     PINBDP        P0QECN                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      P0AMTD        DDTRCD                         CFT009
      *
     C                   ENDIF
     C                   ENDIF                                                              AR940459
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
     C                   IF        DDVAT1 = *Blanks
 
     C                   IF        CFT010 = 'Y'                                 CFT009
     C                   MOVEL     'Y'           DDVAT1                         CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     PVATT         DDVAT1
     C                   ENDIF                                                  CFT009
 
     C                   ELSE
     C                   If        DDVAT1 <> 'Y' and
     C                             DDVAT1 <> 'N'
     C                   MOVE      'N'           OKVAT1
     C                   ADD       1             IDx
     C                   MOVEL     'DDVAT1'      FldNamXAr(IDx)
     C                   MOVEL     'FTM2524'     MsgIdXAr(IDx)
     C*****DDVAT1        CAT       WVCHG         MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDVAT1))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDVAT1)                   MD000091
     C                   EVAL      BLen = %Len(%Trim(WVCHG))                                MD000091
     C                   EVAL      MsgDtaXAr(Idx) = %TRIM(MsgDtaXAr(Idx))                   MD000091
     C                                            + LenStr +%TRIM(WVCHG)                    MD000091
     C                   EndIf
     C                   ENDIF
      *
     C                   Z-ADD     0             IPINDUM8
     C                   Z-ADD     0             IPINVATT
      *
      * Do vat calculation on charge totals not single charges                  CFT009
      * this now performed in program FTIPAY4VL.                                CFT009
      *                                                                         CFT009
     C                   IF        DDVAT1 = 'Y'
     C*****WTrCd*********MULT(H)   PVATR         WTVATD           13 0          CFT009
     C*****IPTRCM********MULT(H)   PVATR         WTVATT           13 0          CFT009
     C*******************ADD       WTVATD        WDUM8                          CFT009
     C*******************ADD       WTVATT        WVATT                          CFT009
     C                   ADD       WTrCd         WDUM8                          CFT009
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT                                                                    CFT009
      ************************************************************              CFT009
      * VTCCODE - VALIDATION OF TRANSFER COMMISSION CHARGE CODE                 CFT009
      ************************************************************              CFT009
      *                                                                         CFT009
     C     VTCCODE       BEGSR                                                  CFT009
                                                                                CFT009
      * ? processing                                                            CFT009
                                                                                CFT009
     C     '?'           SCAN      TRCDE                                        CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
                                                                                CFT009
     C                   CALLB     'FT000940'                                   CFT009
     C                   PARM      *BLANKS       P#PYCD                         CFT009
                                                                                CFT009
     C                   IF        P#PYCD <> *BLANKS                            CFT009
     C                   EVAL      TRCDE = P#PYCD                               CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Check if charge code exists in payment charge definition file           CFT009
                                                                                CFT009
     C     TRCDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        NOT %FOUND                                   CFT009
     C                   MOVE      'N'           OKTRCDE                        CFT009
     C                   ADD       1             IDX                            CFT009
     C                   MOVEL     'TRCDE'       FLDNAMXAR(IDX)                 CFT009
     C                   MOVEL     'FTF3250'     MSGIDXAR(IDX)                  CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
      *
      *****************************************************************
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
      ************************************************************                          BUG17995
      * VCODCOM - VALIDATION OF CHARGE CODE/COMMISSION CODE COMBINATION                     BUG17995
      ************************************************************                          BUG17995
     C     VCODCOM       begsr                                                              BUG17995
      *                                                                                     BUG17995
      ** If charge code entered                                                             BUG17995
     C     TRCDE         IFNE      *BLANKS                                                  BUG17995
      *                                                                                     BUG17995
      ** If CFT009 is on and charge code is valid                                           BUG17995
     C**********         IF        CFT009 = 'Y' AND OKTRCDE <> 'N'                 BUG17995 AR940459
     C                   IF        CFT009 = 'Y' AND OKTRCDE =  'Y'                          AR940459
      *                                                                                     BUG17995
     C                   CALLB     'AOCURRR0'                                               BUG17995
     C                   PARM      *Blanks       C#RTCD                                     BUG17995
     C                   PARM      '*KEY   '     C#OPTN                                     BUG17995
     C                   PARM      PICCY         C#CURR                                     BUG17995
     C     SDCURR        PARM      *BLANKS       DSSDY                                      BUG17995
                                                                                            BUG17995
     C                   EVAL      CHGEXC = A6SPRT                                          BUG17995
                                                                                            BUG17995
      * If use transaction exchange rate, add it in                                         BUG17995
     C                   IF        CHTRCY = 'Y'                                             BUG17995
     C                   IF        PICCY = IPSMCY AND POCCY = IPPCCY                        BUG17995
     C                             OR POCCY = IPSMCY AND PICCY = IPPCCY                     BUG17995
     C                   EVAL      CHGEXC = I2XRTE                                          BUG17995
     C                   ENDIF                                                              BUG17995
     C                   ENDIF                                                              BUG17995
                                                                                            BUG17995
     C                   CALLB     'FT000981'                                               BUG17995
      * OUTPUTS:                                                                            BUG17995
      *                                                                                     BUG17995
      ** Return Code (10A)                                                                  BUG17995
      ** Payment Amount (13,0)                                                              BUG17995
      ** Payment Currency (3A)                                                              BUG17995
      ** Charges Currency (3A)                                                              BUG17995
      ** Exchange Rate from transaction (13,8)                                              BUG17995
      ** STP flag (1A)                                                                      BUG17995
      ** Payment Charge Code (5A)                                                           BUG17995
      ** Settle Amount (13,0)                                                               BUG17995
      ***Charges*to*debit*of*account*(12A)****                                       BUG17995 CFT120
      ** Charges to debit of account (18A)                                                    CFT120
      ** Add deduct indicator (1A)                                                          BUG17995
      ** Charges to the DR of Currency (3A)                                                   CFT120
      *                                                                                       CFT120
     C                   PARM      *BLANKS       WRTCD                                      BUG17995
     C                   PARM      IPPYAM        PAYAMT                                     BUG17995
     C                   PARM      IPPCCY        PAYCCY                                     BUG17995
     C                   PARM      IPSMCY        SMCCY                                      BUG17995
     C                   PARM      PICCY         CHGCCY                                     BUG17995
     C                   PARM                    CHGEXC                                     BUG17995
     C                   PARM      'M'           STP                                        BUG17995
     C                   PARM      TRCDE         CHGCDE                                     BUG17995
     C                   PARM      IPSMAM        SETAMT                                     BUG17995
     C                   PARM      IPCDRO        PCDRO                                      BUG17995
     C                   PARM      IPADDC        PADDC                                      BUG17995
     C                   PARM      IPCDRC        P_ChgDRCcy                                   CFT120
      *                                                                                     BUG17995
      * RETURNS:                                                                            BUG17995
      ** Total Charge (13,0)                                                                BUG17995
      ** Chargeable Amount (13,0)                                                           BUG17995
      ** Charge per Tier (11 x 13A)                                                         BUG17995
      ** Amount being charged by Tier (11 x 13A)                                            BUG17995
     C                   PARM                    TOTCHG                                     BUG17995
     C                   PARM                    CHGAMT                                     BUG17995
     C                   PARM                    PTIERC                                     BUG17995
     C                   PARM                    PTIERA                                     BUG17995
      *                                                                                     BUG17995
      * Reset warning indicators                                                            BUG17995
     C                   EVAL      WFTF3158 = *BLANKS                                       BUG17995
     C                   EVAL      WFTF3176 = *BLANKS                                       BUG17995
                                                                                            BUG17995
     C                   EVAL      WTRCD = TOTCHG                                           BUG17995
                                                                                            BUG17995
     C                   Z-ADD     TOTCHG        P0AMTW                                     BUG17995
     C                   Z-ADD     PINBDP        P0QECN                                     BUG17995
     C                   EXSR      SRFMTAMT                                                 BUG17995
      *                                                                                     BUG17995
     C                   MOVEL     *BLANKS       W#DTRCD          14                        BUG17995
     C                   MOVE      P0AMTD        W#DTRCD                                    BUG17995
                                                                                            BUG17995
      ***If*amount*was*blank,*move*calculated*value*to*screen*field****              BUG17995 255429
      ** override screen field with calculated value                                          255429
     C*****DDTRCD        IFEQ      *BLANKS                                           BUG17995 255429
     C                   IF        W#DTRCD <> *BLANKS                                         255429
     C                             AND TOTCHG <> *ZEROS                                     AR851832
     C                   MOVEL     W#DTRCD       DDTRCD                                     BUG17995
     C                   ELSE                                                               BUG17995
                                                                                            BUG17995
     C                   Move(P)   DDTRCD        ZFIELD                                     BUG17995
     C                   Eval      ZADIG = 11 - PINBDP                                      BUG17995
     C                   Eval      ZADEC = PINBDP                                           BUG17995
                                                                                            BUG17995
      * Validate amount as numeric with correct d.p.                                        BUG17995
     C                   CALLB     'ZALIGN'                                                 BUG17995
     C                   Parm                    ZalignOK          1                        BUG17995
     C                   Parm                    ZFIELD           16                        BUG17995
     C                   Parm                    ZADEC             1 0                      BUG17995
     C                   Parm                    ZADIG             2 0                      BUG17995
      *                                                                                     BUG17995
     C                   If        ZalignOK = 'N'                                           BUG17995
      * Send error to screen                                                                BUG17995
     C                   Move      'N'           OKTrcd                                     BUG17995
     C                   Add       1             Idx                                        BUG17995
     C                   Movel     'DDTRCD'      FldNamXAr(Idx)                             BUG17995
     C                   Movel     'MMA1084'     MsgIdXAr(Idx)                              BUG17995
                                                                                            BUG17995
     C                   Else                                                               BUG17995
     C                   Move      ZFIELD        WTRCD                                      BUG17995
                                                                                            BUG17995
      * Format amount for screen                                                            BUG17995
     C                   Z-ADD     WTRCD         P0AMTW                                     BUG17995
     C                   Z-ADD     PINBDP        P0QECN                                     BUG17995
     C                   EXSR      SRFMTAMT                                                 BUG17995
     C                   MOVE      P0AMTD        DDTRCD                                     BUG17995
     C                   End                                                                BUG17995
                                                                                            BUG17995
     C                   ENDIF                                                              BUG17995
                                                                                            BUG17995
      ***If*default*charge*amount*does*not*equal*screen*amount,*display*error*messageBUG17995 255429
     C*****W#DTRCD       IFNE      DDTRCD                                            BUG17995 255429
     C**********         Move      'N'           OKTrcd                              BUG17995 255429
     C**********         Add       1             Idx                                 BUG17995 255429
     C**********         Movel     'DDTRCD'      FldNamXAr(Idx)                      BUG17995 255429
     C**********         Movel     'FTM7114'     MsgIdXAr(Idx)                       BUG17995 255429
     C**********         ENDIF                                                       BUG17995 255429
                                                                                            BUG17995
     C                   ENDIF                                                              BUG17995
                                                                                            BUG17995
     C                   ENDIF                                                              BUG17995
                                                                                            BUG17995
     C                   endsr                                                              BUG17995
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
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
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
     C                   PARM                    PCharges                                     249756
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *                                                                         CFT009
      ** Previous warning messages array                                        CFT009
     C                   PARM                    WPrvWarnAr                     CFT009
      *                                                                         CFT009
      ** Warning message work fields                                            CFT009
     C                   PARM                    WFTF3176                       CFT009
     C                   PARM                    WFTF3158                       CFT009
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
(c) Finastra International Limited 2001
** WMsgArr
Transfer Commission
