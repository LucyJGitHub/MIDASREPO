     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate miscellaneous charge 3')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVIMCCH03 - Validate Miscellaneous Charge 3                 *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT157             Date 29Aug14               *
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
      *                 CSD027             Date 16May06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *CREATE    Date 13Jan01               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
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
      *                                                               *
      *****************************************************************
 
     FFTPCHGL0  IF   E           K DISK
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
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
 
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
      *
      *
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NWIP1SCNFMT   E DS                  EXTNAME(FTIPY1PD)
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     D NwIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)
 
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     D FTEIPY4       E DS                  EXTNAME(FTEIPY4PD)
      *
      ** Incoming Payments for file update - file format
     D NWIPFILFMT    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments (additional details) for file update
     D NWIP2FILFMT   E DS                  EXTNAME(FTVIPY2PD)
 
      ** Valid Incoming Payments Extension File (default)
     D DEFVALIDX     E DS                  EXTNAME(FTVIPY2PD)
     D                                     PREFIX(D#)
 
      * Valid Payments layout (default)
     D DEFVALID      E DS                  EXTNAME(FTVIPAYPD)
     D                                     PREFIX(D#)
 
      ** External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      *  Transaction details file parameter for FT000652
     D TRNDET          DS          3000
 
      *  Transaction details extension file parameter for FT000652
     D TRNEXT          DS          3000
      *
      ** Data structure for Screen Charges Amount fields
     D PCHARGES        DS           196
     D  DDTRCM                 1     14
     D  DDTXCH                15     28
     D  DDCQCH                29     42
     D  DDADCH                43     56
     D  DDTLCH                57     70
     D  DDMSCH                71     84
     D  DDCHCM                85     98
     D  DDVATT                99    112
     D  DDVATD               113    126
     D  M1CH                 127    140
     D  M2CH                 141    154
     D  M3CH                 155    168
     D  M4CH                 169    182
     D  M5CH                 183    196
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D IDX             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIX             S              3P 0
 
      ** Flags for warning message processing
     D WFTF3173        S              1
     D WFTF3186        S              1
 
     D ZALIGNOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
 
     D C#CURR          S              3
     D C#OPTN          S              7
     D C#RTCD          S              7
 
      * Parameter for FT000940
     D P#PYCD          S                   LIKE(PYCHCD)
 
      ** Parameters for FT000652
     D MRTCD           S             10
     D TRNTYP          S              2
     D CHGCDE          S              5
     D INKC            S              1
 
      ** Parameters for FT000981
     D WRTCD           S             10A
     D PAYAMT          S             13P 0
     D PAYCCY          S              3A
     D SMCCY           S              3A
     D CHGCCY          S              3A
     D CHGEXC          S             13P 8
     D STP             S              1A
     D SETAMT          S             13P 0
     D*PCDRO****       S             12S 0                                                    CGL029
     D*PCDRO****       S             18S 0                                             CGL029 CSD027
     D PCDRO           S             18A                                                      CSD027
     D PADDC           S              1A
     D TOTCHG          S             13P 0
     D CHGAMT          S             13P 0
     D PTIERC          S             13A   DIM(11)
     D PTIERA          S             13A   DIM(11)
     D P_ChgDRCcy      S              3A                                                      CFT120
 
      * Parameters for AOCCYCV0
     D D#DTA           DS           256
     D  D#FCCY                 1      3
     D  D#FAMT                 4     11P 0
     D  D#TCCY                12     14
     D  D#TAMT                15     22P 0
     D  D#IMDIN               23     23
     D  D#IRATE               24     36P 8
     D  D#OMDIN               23     23
     D  D#ORATE               24     36P 8
     D C#ACTN          S              8
 
      ** Work variables
     D WMSCD3          S             13  0
     D WDUM8           S             11  0
 
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
 
      ** Initialization
      *
     C                   EVAL      RETCODEIN = *BLANKS
     C                   EVAL      FLDNAMXAR = *BLANKS
     C                   EVAL      MSGIDXAR  = *BLANKS
     C                   EVAL      MSGDTAXAR = *BLANKS
     C                   EVAL      WFLDNMXAR = *BLANKS
     C                   EVAL      WMSGIDXAR  = *BLANKS
     C                   EVAL      WMSGDTXAR = *BLANKS
     C                   EVAL      WIX = 0
     C                   EVAL      IDX = 0
 
      ** Initialise variables for update of Valid File fields.
 
     C                   Z-ADD     0             WMSCD3
     C                   Z-ADD     0             WDUM8
     C                   Z-ADD     0             I2AMM3
     C                   EVAL      M3CH = *BLANKS
 
      * Validate
     C                   EXSR      VMISC03
 
      * If charge amount is not the same as default, warning
      * Before putting out warning check array WPrvWarnAr for message
      * FTF3173 to determine if warning has already been displayed.
     C                   IF        WMSCD3 = D#I2MSC03
     C                   EVAL      WFTF3173 = *BLANKS
     C                   ENDIF
     C                   IF        WFTF3173 <> 'Y'
     C                   Z-ADD     1             X                 3 0
     C     'FTF3173'     LOOKUP    WPrvWarnAr(X)                          99
     C                   IF        *IN99 = *ON
     C                   EVAL      WFTF3173 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   IF        WMSCD3 <> D#I2MSC03
     C                             AND OKM3CD <> 'N' AND CFT009 = 'Y'
     C                             AND WFTF3173 <> 'Y'
     C                   MOVE      'W'           OKM3CD
     C                   ADD       1             WIX
     C                   MOVEL     'M3CD'        WFLDNMXAR(WIX)
     C                   MOVEL     'FTF3173'     WMSGIDXAR(WIX)
     C                   EVAL      RETCODEIN = 'Error'
     C                   EVAL      WFTF3173 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKM3CD = 'N' OR OKM3CDE = 'N'
     C                             OR OKVAT11 = 'N'
     C                   EVAL      RETCODEIN = 'Error'
     C                   ENDIF
      *
     C                   IF        OKM3CD <> 'N'
     C                   ADD       WDUM8         IPINDUM8
     C                   ENDIF
      *
     C                   IF        OKVAT11 <> 'N'
     C                   MOVE      VAT11         I2VTM3
     C                   ENDIF
      *
     C                   IF        OKM3CDE <> 'N'
     C                   MOVE      M3CDE         I2M3CD
     C                   ENDIF
 
      * RETURN
 
     C                   RETURN
      *****************************************************************
      /EJECT
      ************************************************************
      * VMISC03 - VALIDATION OF MISCELLANEOUS CHARGE 3
      ************************************************************
      *
     C     VMISC03       BEGSR
 
      * Validate miscellaneous charge code 3
 
     C                   IF        M3CDE <> *BLANKS
     C                   EXSR      VM3CODE
     C                   ENDIF
 
      * If charge code is not the same as default, warning
      * Before putting out warning check array WPrvWarnAr for message
      * FTF3186 to determine if warning has already been displayed.
     C                   IF        M3CDE = D#I2M3CD
     C                   EVAL      WFTF3186 = *BLANKS
     C                   ENDIF
     C                   IF        WFTF3186 <> 'Y'
     C                   Z-ADD     1             X                 3 0
     C     'FTF3186'     LOOKUP    WPrvWarnAr(X)                          99
     C                   IF        *IN99 = *ON
     C                   EVAL      WFTF3186 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   IF        M3CDE <> D#I2M3CD
     C                             AND OKM3CDE <> 'N'
     C                             AND WFTF3186 <> 'Y'
     C                   MOVE      'W'           OKM3CDE
     C                   ADD       1             WIX
     C                   MOVEL     'M3CDE'       WFLDNMXAR(WIX)
     C                   MOVEL     'FTF3186'     WMSGIDXAR(WIX)
     C                   EVAL      RETCODEIN = 'Error'
     C                   EVAL      WFTF3186 = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      *  Miscellaneous Charge 3
      *  ----------------------
      *  Miscellaneous Charge 3 is optional.
      *  If entered must be valid for charge currency details
 
     C                   IF        M3CD <> *BLANKS
 
      * ? processing - Charge enquiry
 
     C     '?'           SCAN      M3CD
 
     C                   IF        %FOUND
 
     C                   IF        OKM3CDE = 'N' OR M3CDE = *BLANKS
     C                   MOVE      'N'           OKM3CD
     C                   ADD       1             IDX
     C                   MOVEL     'M3CD'        FLDNAMXAR(IDX)
     C                   MOVEL     'FTF3206'     MSGIDXAR(IDX)
     C                   ELSE
 
     C                   EVAL      TRNDET = NWIPFILFMT
     C                   EVAL      TRNEXT = NWIP2FILFMT
 
     C                   CALLB     'FT000652'
     C                   PARM      *BLANKS       MRTCD
     C                   PARM                    TRNDET
     C                   PARM                    TRNEXT
     C                   PARM      'IN'          TRNTYP
     C                   PARM      M3CDE         CHGCDE
     C                   PARM                    INKC
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE(P)   M3CD          ZFIELD
     C                   EVAL      ZADIG = 11 - PINBDP
     C                   EVAL      ZADEC = PINBDP
 
      * Validate amount as numeric with correct d.p.
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNOK = 'N'
      * Send error to screen
     C                   MOVE      'N'           OKM3CD
     C                   ADD       1             IDX
     C                   MOVEL     'M3CD'        FLDNAMXAR(IDX)
     C                   MOVEL     'FTF3264'     MSGIDXAR(IDX)
 
     C                   ELSE
 
      * Format amount for screen
 
     C                   MOVE      ZFIELD        WMSCD3
     C                   MOVE      ZFIELD        I2MSC03
 
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = WMSCD3
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY
 
      ** Set up rate to use, depending on flag from SDFTFRPD.
     C     *LIKE         Define    IPRATE        Rate_to_use
 
     C                   If        CHTRCY = 'Y'
     C                   Eval      Rate_to_use = I2XRTE
     C                   Else
     C                   Eval      Rate_to_use = IPRATE
     C                   EndIf
 
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      WMSCD3        PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C                   PARM      I2CCDE        PCharge_Ccy       3
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16
 
     C                   MOVE      PLev_Charge   @@AMTW
     C                   EVAL      I2AMM3 = PLev_Charge
 
     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M3CH
 
     C                   MOVE      WMSCD3        @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M3CD
     C                   ENDIF
 
     C                   ENDIF
      *
      * If charge code <> blank and charge amount = blank, recalculate
      * charge amount
     C*****              IF        M3CDE <> *BLANKS AND OKM3CDE <> 'N'                        242926
     C*****                        AND M3CD = *BLANKS OR                                      242926
     C*****                        DDCDRO <> *BLANKS AND OKCDRO <> 'N'                        242926
     C*****                        AND M3CDE <> *BLANKS                                       242926
     C*****                        OR PCDROCHG = 'Y' AND M3CDE <> *BLANKS                     242926
      *                                                                                       242926
      *  Do not recalculate unless charge code is valid.                                      242926
      *                                                                                       242926
     C                   IF        M3CDE <> *BLANKS AND OKM3CDE <> 'N'                        242926
     C                             AND M3CD = *BLANKS OR                                      242926
     C                             DDCDRO <> *BLANKS AND OKCDRO <> 'N'                        242926
     C                             AND M3CDE <> *BLANKS AND OKM3CDE <> 'N'                    242926
     C                             OR PCDROCHG = 'Y' AND M3CDE <> *BLANKS                     242926
     C                             AND OKM3CDE <> 'N'                                         242926
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM      '*KEY   '     C#OPTN
     C                   PARM      PICCY         C#CURR
     C     SDCURR        PARM      *BLANKS       DSSDY
 
     C                   EVAL      CHGEXC = A6SPRT
 
      * If use transaction exchange rate, add it in
     C                   IF        CHTRCY = 'Y'
     C                   IF        PICCY = IPSMCY AND POCCY = IPPCCY
     C                             OR POCCY = IPSMCY AND PICCY = IPPCCY
     C                   EVAL      CHGEXC = I2XRTE
     C                   ENDIF
     C                   ENDIF
 
     C                   CALLB     'FT000981'
      * OUTPUTS:
      *
      ** Return Code (10A)
      ** Payment Amount (13,0)
      ** Payment Currency (3A)
      ** Charges Currency (3A)
      ** Exchange Rate from transaction (13,8)
      ** STP flag (1A)
      ** Payment Charge Code (5A)
      ** Settle Amount (13,0)
      ** Charges to debit of account (12A)
      ** Add deduct indicator (1A)
      ** Charges to the DR of Currency (3A)                                                   CFT120
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      IPPYAM        PAYAMT
     C                   PARM      IPPCCY        PAYCCY
     C                   PARM      IPSMCY        SMCCY
     C                   PARM      PICCY         CHGCCY
     C                   PARM                    CHGEXC
     C                   PARM      'M'           STP
     C                   PARM      M3CDE         CHGCDE
     C                   PARM      IPSMAM        SETAMT
     C                   PARM      IPCDRO        PCDRO
     C                   PARM      IPADDC        PADDC
     C                   PARM      IPCDRC        P_ChgDRCcy                                   CFT120
      *
      * RETURNS:
      ** Total Charge (13,0)
      ** Chargeable Amount (13,0)
      ** Charge per Tier (11 x 13A)
      ** Amount being charged by Tier (11 x 13A)
     C                   PARM                    TOTCHG
     C                   PARM                    CHGAMT
     C                   PARM                    PTIERC
     C                   PARM                    PTIERA
      *
      * Reset warning indicators
     C                   EVAL      WFTF3173 = *BLANKS
     C                   EVAL      WFTF3186 = *BLANKS
 
     C                   EVAL      WMSCD3 = TOTCHG
     C                   EVAL      I2AMM3 = TOTCHG
 
     C                   Z-ADD     TOTCHG        @@AMTW
     C                   Z-ADD     PINBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M3CD
 
     C                   CLEAR                   D#DTA
     C                   EVAL      D#FAMT = WMSCD3
     C                   EVAL      D#TCCY = POCCY
     C                   EVAL      D#FCCY = PICCY
 
      ** Set up rate to use, depending on flag from SDFTFRPD.
     C     *LIKE         Define    IPRATE        Rate_to_use
 
     C                   If        CHTRCY = 'Y'
     C                   Eval      Rate_to_use = I2XRTE
     C                   Else
     C                   Eval      Rate_to_use = IPRATE
     C                   EndIf
 
     C                   CALLB     'FTCALCLEV'
     C                   PARM      *BLANKS       PRet_Code        10
     C                   PARM      WMSCD3        PCharge_Amt      13 0
     C                   PARM      IPPCCY        PPay_Ccy          3
     C                   PARM      IPSMCY        PSettle_Ccy       3
     C                   PARM      I2CCDE        PCharge_Ccy       3
     C                   PARM      POCCY         PLev_Ccy          3
     C                   PARM      Rate_to_use   PExch_Rate       13 8
     C                   PARM      *Zeros        PLev_Charge      13 0
     C                   PARM      *Blanks       PLev_Charge_F    16
 
     C                   MOVE      PLev_Charge   @@AMTW
     C                   EVAL      I2AMM3 = PLev_Charge
 
     C                   Z-ADD     PONBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        M3CH
 
 
     C                   ENDIF
      *
      ** Calculate V.A.T charge amounts if V.A.T processing Allowed
      *
     C                   IF        CFT010 = 'Y'
     C                   EXSR      SRVALVAT
     C                   ENDIF
 
     C                   ENDSR
     C************************************************************
     C* END MISCELLANEOUS CHARGE 3 VALIDATION
     C************************************************************
      /EJECT
      ************************************************************
      * SRVALVAT - VALIDATE VAT
      ************************************************************
     C     SRVALVAT      BEGSR
 
      *  If CFT010 on, flag is 'Y'
      *
     C                   IF        VAT11 = *BLANKS
     C                   MOVEL     'Y'           VAT11
     C                   ELSE
     C                   IF        VAT11 <> 'Y' and VAT11 <> 'N'
     C                   MOVE      'N'           OKVAT11
     C                   ADD       1             IDX
     C                   MOVEL     'VAT11'       FLDNAMXAR(IDX)
     C                   MOVEL     'MMA1094'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
      *
      * Don't calc vat on individual charges - now vat calc is
      * done on total charges in FTVITCHG
     C                   IF        VAT11 = 'Y'
     C                   ADD       WMSCD3        WDUM8
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      ************************************************************
      * VM3CODE - VALIDATION OF MISCELLANEOUS CHARGE 3 CODE
      ************************************************************
      *
     C     VM3CODE       BEGSR
 
      * ? processing
 
     C     '?'           SCAN      M3CDE
 
     C                   IF        %FOUND
 
     C                   CALLB     'FT000940'
     C                   PARM      *BLANKS       P#PYCD
 
     C                   IF        P#PYCD <> *BLANKS
     C                   EVAL      M3CDE = P#PYCD
     C                   ENDIF
 
     C                   ENDIF
 
      * Check if charge code exists in payment charge definition file
 
     C     M3CDE         CHAIN     FTPCHGL0
 
     C                   IF        NOT %FOUND
     C                   MOVE      'N'           OKM3CDE
     C                   ADD       1             IDX
     C                   MOVEL     'M3CDE'       FLDNAMXAR(IDX)
     C                   MOVEL     'FTF3263'     MSGIDXAR(IDX)
     C                   ENDIF
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
     C*
     C     *ENTRY        PLIST
 
      * INPUTS
      *  Return Code
     C                   PARM                    RETCODEIN
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NWIP1SCNFMT
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NWIP5SCNFMT
      *
      ** Input Charge Currency
     C                   PARM                    PICCY             3
      *
      ** Output Charge Currency
     C                   PARM                    POCCY             3
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP            1 0
      *
      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP            1 0
      *
      ** STANDING DATA
      ** =============
      *
      ** VAT Rate
     C                   PARM                    PVATR             5 4
      *
      ** SDFTFR - Charges calculated in transaction ccy
     C                   PARM                    CHTRCY            1
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Fees & Charges
     C                   PARM                    CFT009            1
     C                   PARM                    CFT010            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
     C                   PARM                    WFLDNMXAR
     C                   PARM                    WMSGIDXAR
     C                   PARM                    WMSGDTXAR
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NWIPFILFMT
      *
      ** Incoming Payments (additional details) for file update
     C                   PARM                    NWIP2FILFMT
      *  Saved default charges
     C                   PARM                    DEFVALID
     C                   PARM                    DEFVALIDX
      *
      ** Charges Amount
     C                   PARM                    PCHARGES
      *
      ** Charges to the debit of - field changed (Y or blank)
     C                   PARM                    PCDROCHG          1
      *
      ** Previous warning messages array
     C                   PARM                    WPrvWarnAr
      *
      ** Warning message work fields
     C                   PARM                    WFTF3186
     C                   PARM                    WFTF3173
 
      *
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
