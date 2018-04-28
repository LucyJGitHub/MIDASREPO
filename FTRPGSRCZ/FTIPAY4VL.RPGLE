     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments validation controller 4')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY4VL - Incoming Payments Validation Controller 4        *
      *                                                               *
      *  Function: This module validates Incoming Payments Level 2    *
      *            screen 3 fields for input into the Midas           *
      *            database.                                          *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT157             Date 29Aug14               *
      *  Prev Amend No. MD025111           Date 10May14               *
      *                 257125             Date 28Sep12               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257897             Date 26Nov08               *
      *                 256256             Date 04Sep08               *
      *                 254970             Date 17Jun08               *
      *                 249756             Date 19Sep07               *
      *                 247273             Date 24Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 240689             Date 13Jul06               *
      *                 BUG2671            Date 18May04               *
      *                 CGP001             Date 09Dec03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 02Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  MD025111 - Incoming payment without charges is not allowed   *
      *             if the account is blocked for DR                  *
      *  257125 - CAR CFT120 Charge display error                     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  257897 - Prevent DB Error on mathematical ops.               *
      *           Apply client fix 250881                             *
      *  256256 - Redisplay Level 2 Screen 3 if the value of          *
      *           'Charges to the debit of a/c' has been changed      *
      *  254970 - FT level 2, screen 3 is unable to continue when     *
      *           there is a warning message.                         *
      *  249756 - Pass DS/PCharges to FTVITRCV to serve as a basis    *
      *           on defined charges.                                 *
      *  247273 - Charges to DR input does not set Charges CCY to Base*
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  240689 - Applied fix 210654 + additional changes by 232151   *
      *  BUG2671- Condition change for CFT009 on switchable features  *
      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
      *  CFT009 - Recalculate charges if charges to debit account     *
      *           has been changed.                                   *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTIPY4V001
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
      ** Work array for warning message Ids                                     CFT009
     D WPrvWarnAr      S                   Dim(ArrayMax)                        CFT009
     D                                     Like(WMsgIDArr)                      CFT009
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     D NwIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     D FTEIPY4       E DS                  EXTNAME(FTEIPY4PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments (additional details) for file update
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)
                                                                                              CFT009
      ** Valid Incoming Payments Extension File (default)                                     CFT009
     D DEFVALIDX     E DS                  EXTNAME(FTVIPY2PD)                                 CFT009
     D                                     PREFIX(D#)                                         CFT009
                                                                                              CFT009
      * Valid Payments layout (default)                                                       CFT009
     D DEFVALID      E DS                  EXTNAME(FTVIPAYPD)                                 CFT009
     D                                     PREFIX(D#)                                         CFT009
      *                                                                                       CFT009
      ** External DS for Currency details                                                     CFT009
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CFT009
      ** DS for Access Objects - short data structure                                         CFT009
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CFT009
      *                                                                                       CFT009
      ** DS for Acess Programs - long data structure                                          CFT009
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CFT009
      *                                                                                       CFT009
      ** Warning message work inds for charges screen                                         CFT009
     D PChgWarn        DS            24                                                       CFT009
     D  WFTF3176               1      1                                                       CFT009
     D  WFTF3177               2      2                                                       CFT009
     D  WFTF3178               3      3                                                       CFT009
     D  WFTF3179               4      4                                                       CFT009
     D  WFTF3202               5      5                                                       CFT009
     D  WFTF3204               6      6                                                       CFT009
     D  WFTF3182               7      7                                                       CFT009
     D  WFTF3184               8      8                                                       CFT009
     D  WFTF3185               9      9                                                       CFT009
     D  WFTF3186              10     10                                                       CFT009
     D  WFTF3187              11     11                                                       CFT009
     D  WFTF3188              12     12                                                       CFT009
     D  WFTF3158              13     13                                                       CFT009
     D  WFTF3159              14     14                                                       CFT009
     D  WFTF3160              15     15                                                       CFT009
     D  WFTF3161              16     16                                                       CFT009
     D  WFTF3203              17     17                                                       CFT009
     D  WFTF3205              18     18                                                       CFT009
     D  WFTF3164              19     19                                                       CFT009
     D  WFTF3171              20     20                                                       CFT009
     D  WFTF3172              21     21                                                       CFT009
     D  WFTF3173              22     22                                                       CFT009
     D  WFTF3174              23     23                                                       CFT009
     D  WFTF3175              24     24                                                       CFT009
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Index for update of error arrays
     D Ix              S              3  0
      *
      ** Response Mode
     D PResponse       S              1A
      *                                                                                       CFT009
      ** Access object parameters                                                             CFT009
     D PRtcd           S              1A                                                      CFT009
     D POptn           S              7A                                                      CFT009
      *
      ** Work fields used by ZXRATE                                                           247273
     D ZRATE1          S             13P 8                                                    247273
     D ZRATE2          S             13P 8                                                    247273
     D ZMDI1           S              1A                                                      247273
     D ZMDI2           S              1A                                                      247273
     D ZRATEX          S             13P 8                                                    247273
     D ZMDIX           S              1A                                                      247273
      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
                                                                                              247273
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,FTIPY4V002
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
      /COPY WNCPYSRC,FTIPY4V003
      *
      ** Charges to the Debit of A/c Validation.
      *
      /COPY WNCPYSRC,FTIPY4V004
      *
     C                   EXSR      SRCDRO
      *
      /COPY WNCPYSRC,FTIPY4V005
      *
      ** Details of Charges validation.
      *
      /COPY WNCPYSRC,FTIPY4V006
      *
     C                   EXSR      SRDETC
      *                                                                                       CFT009
      /COPY WNCPYSRC,FTIPY4V032                                                               CFT009
      *                                                                                       CFT009
      ** Determine Charge Currencies based on 'Charges to the Debit of'                       CFT009
      ** Customer.                                                                            CFT009
      *                                                                                       CFT009
      /COPY WNCPYSRC,FTIPY4V033                                                               CFT009
      *                                                                                       CFT009
     C                   IF        CFT009 = 'Y'                                               CFT009
     C                   EXSR      SRCCCY                                                     CFT009
     C                   ENDIF                                                                CFT009
      *
      /COPY WNCPYSRC,FTIPY4V007
      *
      ** Transfer Commission validation
      *
      /COPY WNCPYSRC,FTIPY4V008
      *
     C                   EXSR      SRTRCM
      *
      /COPY WNCPYSRC,FTIPY4V009
      *
      ** Telex Charge validation
      *
      /COPY WNCPYSRC,FTIPY4V010
      *
     C                   EXSR      SRTXCH
      *
      /COPY WNCPYSRC,FTIPY4V011
      *
      ** Cheque Charge validation
      *
      /COPY WNCPYSRC,FTIPY4V012
      *
     C                   EXSR      SRCQCH
      *
      /COPY WNCPYSRC,FTIPY4V013
      *
      ** Advice Charge validation
      *
      /COPY WNCPYSRC,FTIPY4V014
      *
     C                   EXSR      SRADCH
      *
      /COPY WNCPYSRC,FTIPY4V015
      *
      ** Telephone Charge validation
      *
      /COPY WNCPYSRC,FTIPY4V016
      *
     C                   EXSR      SRTLCH
      *
      /COPY WNCPYSRC,FTIPY4V017
      *
      ** Miscellaneous Charge validation
      *
      /COPY WNCPYSRC,FTIPY4V018
      *
     C                   EXSR      SRMSCH
      *
      /COPY WNCPYSRC,FTIPY4V019
      *
      ** FX/Change Commission validation
      *
      /COPY WNCPYSRC,FTIPY4V020
      *
     C                   IF        S01494 = 'Y'
     C                   EXSR      SRFXCM
     C                   ELSE
     C                   EVAL      DDCHCD = *BLANKS
     C                   EVAL      DDVAT7 = *BLANK
     C                   ENDIF
      *                                                                         CFT009
      ** Miscellaneous 1 Charge validation                                      CFT009
      *                                                                         CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   EXSR      SRMSCH1                                      CFT009
     C                   EXSR      SRMSCH2                                      CFT009
     C                   EXSR      SRMSCH3                                      CFT009
     C                   EXSR      SRMSCH4                                      CFT009
     C                   EXSR      SRMSCH5                                      CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      M1CD = *BLANKS                               CFT009
     C                   EVAL      M2CD = *BLANKS                               CFT009
     C                   EVAL      M3CD = *BLANKS                               CFT009
     C                   EVAL      M4CD = *BLANKS                               CFT009
     C                   EVAL      M5CD = *BLANKS                               CFT009
     C                   EVAL      VAT9 = *BLANK                                CFT009
     C                   EVAL      VAT10 = *BLANK                               CFT009
     C                   EVAL      VAT11 = *BLANK                               CFT009
     C                   EVAL      VAT12 = *BLANK                               CFT009
     C                   EVAL      VAT13 = *BLANK                               CFT009
     C                   ENDIF                                                  CFT009
      *
      /COPY WNCPYSRC,FTIPY4V021
      *
      ** Total Charges validation
      *
      /COPY WNCPYSRC,FTIPY4V022
      *
     C                   EXSR      SRTOTC
      *
      /COPY WNCPYSRC,FTIPY4V023
      *
      ** Update VAT Rate
      *
      /COPY WNCPYSRC,FTIPY4V024
      *
     C                   IF        S01499 = 'Y'
     C                             AND CFT009 ='N' OR CFT010 = 'Y'              CFT009
     C                   IF        IPINDUM8 <> 0 or IPINVATT <> 0
     C                   Z-ADD     PVATR         IPINVATR
     C                   ENDIF
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPY4V025
      *
      ** Receiver's Charges validation
      *
      /COPY WNCPYSRC,FTIPY4V026
      *
     C                   IF        CFT014 = 'Y'
     C                   EXSR      SRRCRM
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPY4V027
      *
      ** Sender's Charges validation
      *
      /COPY WNCPYSRC,FTIPY4V028
      *
     C                   IF        CFT014 = 'Y'
     C                   EXSR      SRSCHG
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPY4V029
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,FTIPY4V030
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCDRO - Charges to the Debit of A/c Validation              *
      *                                                               *
      *****************************************************************
     C     SRCDRO        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *----------------------------------------------------------------------------------*    247273
      ** Set PCDROCHG if the screen value has changed from the file value                     247273
      ** before the valid file value is reset in the following module                         247273
                                                                                              247273
     C**********         If        DDACTN   = 'I' Or                                   247273 249756
     C**********                   DDCDRO  <> IPCDRO                                   247273 249756
     C**********         If        DDACTN   = 'I' AND DDCDRO <> *BLANKS Or             249756 256256
     C**********         If        DDACTN   = 'I' AND DDCDRO <> IPCDRO Or              256256 257125
     C                   If        DDACTN   = 'I' AND DDCDRO <> *BLANKS Or                    257125
     C                             DDACTN   = 'A' AND DDCDRO <> IPCDRO                        249756
     C                   Eval      PCDROCHG = 'Y'                                             247273
     C                   Else                                                                 247273
     C                   Eval      PCDROCHG = *Blanks                                         247273
     C                   EndIf                                                                247273
      *----------------------------------------------------------------------------------*    247273
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVICDRO'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5SCNFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** SDBANK - Midas Run Date
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN
      *
      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN
      *
      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtXAr                                    240689
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C**********         IF        RetCodeOut <> *BLANKS                                      240689
     C                   EXSR      SRUpdatErrs
     C**********         ENDIF                                                                240689
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETC - Details of Charges Validation                       *
      *                                                               *
      *****************************************************************
     C     SRDetC        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIDTCH'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** MT103 Messages Generation for FT
     C                   PARM                    CFT014            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRCM - Transfer Commission Validation                      *
      *                                                               *
      *****************************************************************
     C     SRTRCM        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVITRCV'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Input Charge Currency
     C                   PARM                    PICCY
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP
      *
      ** STANDING DATA
      ** =============
      *
      ** VAT Default Flag
     C                   PARM                    PVATT
      *
      ** VAT Rate
     C                   PARM                    PVATR
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY                         CFT009
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010                         CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
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
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTXCH - Telex Charge Validation                             *
      *                                                               *
      *****************************************************************
      *
     C     SRTxCh        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVITXCV'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Input Charge Currency
     C                   PARM                    PICCY
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP
      *
      ** STANDING DATA
      ** =============
      *
      ** VAT Default Flag
     C                   PARM                    PVATT
      *
      ** VAT Rate
     C                   PARM                    PVATR
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C                   PARM                    CFT010            1            CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
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
     C                   PARM                    WFTF3178                       CFT009
     C                   PARM                    WFTF3160                       CFT009
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCQCH - Cheque Charge Validation                            *
      *                                                               *
      *****************************************************************
      *
     C     SRCqCh        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVICQCV'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Input Charge Currency
     C                   PARM                    PICCY
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP
      *
      ** STANDING DATA
      ** =============
      *
      ** VAT Default Flag
     C                   PARM                    PVATT
      *
      ** VAT Rate
     C                   PARM                    PVATR
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C                   PARM                    CFT010            1            CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
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
     C                   PARM                    WFTF3179                       CFT009
     C                   PARM                    WFTF3161                       CFT009
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRADCH - Advice Charge Validation                            *
      *                                                               *
      *****************************************************************
     C     SRAdCh        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIADCV'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Input Charge Currency
     C                   PARM                    PICCY
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP
      *
      ** STANDING DATA
      ** =============
      *
      ** VAT Default Flag
     C                   PARM                    PVATT
      *
      ** VAT Rate
     C                   PARM                    PVATR
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C                   PARM                    CFT010            1            CFT010
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
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
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTLCH - Telephone Charge Validation                         *
      *                                                               *
      *****************************************************************
     C     SRTlCh        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVITLCV'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Input Charge Currency
     C                   PARM                    PICCY
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP
      *
      ** STANDING DATA
      ** =============
      *
      ** VAT Default Flag
     C                   PARM                    PVATT
      *
      ** VAT Rate
     C                   PARM                    PVATR
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY                         CFT009
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C                   PARM                    CFT010            1            CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
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
     C                   PARM                    WFTF3204                       CFT009
     C                   PARM                    WFTF3205                       CFT009
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMSCH - Miscellaneous Charge Validation                     *
      *                                                               *
      *****************************************************************
     C     SRMsCh        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIMSCV'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Input Charge Currency
     C                   PARM                    PICCY
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP
      *
      ** STANDING DATA
      ** =============
      *
      ** VAT Default Flag
     C                   PARM                    PVATT
      *
      ** VAT Rate
     C                   PARM                    PVATR
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C                   PARM                    CFT010            1            CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
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
     C                   PARM                    WFTF3182                       CFT009
     C                   PARM                    WFTF3164                       CFT009
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFXCM - FX/Change Commission Validation                     *
      *                                                               *
      *****************************************************************
     C     SRFXCM        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVICHCV'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy
      *
      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD
      *
      ** Payment In Currency Indicator
     C                   PARM                    PPayInCy
      *
      ** Payment EMU Transaction Period Start Date
     C                   PARM                    PPayTPSD
      *
      ** Input Charge Currency
     C                   PARM                    PICCY
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO
      *
      ** VAT Default Flag
     C                   PARM                    PVATT
      *
      ** VAT Rate
     C                   PARM                    PVATR
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY                         CFT009
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010                         CFT010
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *                                                                         CFT009
      ** Incoming Payments (additional details) for file update                 CFT009
     C                   PARM                    NWIP2FILFMT                    CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *
      ** Value Dates
     C                   PARM                    PVDates           5 0
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *                                                                         CFT009
      ** Previous warning messages array                                        CFT009
     C                   PARM                    WPrvWarnAr                     CFT009
      *                                                                         CFT009
      ** Warning message work fields                                            CFT009
     C                   PARM                    WFTF3177                       CFT009
     C                   PARM                    WFTF3159                       CFT009
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CFT009
                                                                                CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      *  SRMSCH1- Miscellaneous 1 Charge Validation                   *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
     C     SRMSCH1       BEGSR                                                  CFT009
      *                                                                         CFT009
      ** Reset fields.                                                          CFT009
      *                                                                         CFT009
     C                   EXSR      SRRESETERRS                                  CFT009
      *                                                                         CFT009
      ** Call validation module.                                                CFT009
      *                                                                         CFT009
     C                   CALLB     'FTVIMCCH01'                                 CFT009
      *                             ==========                                  CFT009
      ** INPUT                                                                  CFT009
      ** =====                                                                  CFT009
      *                                                                         CFT009
      ** Return Code                                                            CFT009
     C                   PARM                    RETCODEOUT                     CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP5SCNFMT                    CFT009
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     C                   PARM                    PICCY                          CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *                                                                         CFT009
      ** Input Charge Currency No. of Decimal Places                            CFT009
     C                   PARM                    PINBDP                         CFT009
      *                                                                         CFT009
      ** Output Charge Currency No. of Decimal Places                           CFT009
     C                   PARM                    PONBDP                         CFT009
      *                                                                         CFT009
      ** STANDING DATA                                                          CFT009
      ** =============                                                          CFT009
      *                                                                         CFT009
      ** VAT Rate                                                               CFT009
     C                   PARM                    PVATR                          CFT009
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *                                                                         CFT009
      ** SWITCHABLE FEATURES                                                    CFT009
      ** ===================                                                    CFT009
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010            1            CFT010
      *                                                                         CFT009
      ** OUTPUT                                                                 CFT009
      ** ======                                                                 CFT009
      *                                                                         CFT009
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT009
     C                   Parm                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
      *                                                                         CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT009
     C                   PARM                    FTEIPY4                        CFT009
      *                                                                         CFT009
      ** Incoming Payments for file update - file format                        CFT009
     C                   PARM                    NWIPFILFMT                     CFT009
      *                                                                         CFT009
      ** Incoming Payments (additional details) for file update                 CFT009
     C                   PARM                    NWIP2FILFMT                    CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges Amount                                                         CFT009
     C                   PARM                    PCHARGES                       CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *                                                                         CFT009
      ** Previous warning messages array                                        CFT009
     C                   PARM                    WPrvWarnAr                     CFT009
      *                                                                         CFT009
      ** Warning message work fields                                            CFT009
     C                   PARM                    WFTF3184                       CFT009
     C                   PARM                    WFTF3171                       CFT009
      *                                                                         CFT009
      ** Update error information.                                              CFT009
      *                                                                         CFT009
     C                   IF        RETCODEOUT <> *BLANKS                        CFT009
     C                   EXSR      SRUPDATERRS                                  CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   ENDSR                                                  CFT009
      *****************************************************************         CFT009
      /EJECT                                                                    CFT009
                                                                                CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      *  SRMSCH2- Miscellaneous 2 Charge Validation                   *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
     C     SRMSCH2       BEGSR                                                  CFT009
      *                                                                         CFT009
      ** Reset fields.                                                          CFT009
      *                                                                         CFT009
     C                   EXSR      SRRESETERRS                                  CFT009
      *                                                                         CFT009
      ** Call validation module.                                                CFT009
      *                                                                         CFT009
     C                   CALLB     'FTVIMCCH02'                                 CFT009
      *                             ==========                                  CFT009
      ** INPUT                                                                  CFT009
      ** =====                                                                  CFT009
      *                                                                         CFT009
      ** Return Code                                                            CFT009
     C                   PARM                    RETCODEOUT                     CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP5SCNFMT                    CFT009
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     C                   PARM                    PICCY                          CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *                                                                         CFT009
      ** Input Charge Currency No. of Decimal Places                            CFT009
     C                   PARM                    PINBDP                         CFT009
      *                                                                         CFT009
      ** Output Charge Currency No. of Decimal Places                           CFT009
     C                   PARM                    PONBDP                         CFT009
      *                                                                         CFT009
      ** STANDING DATA                                                          CFT009
      ** =============                                                          CFT009
      *                                                                         CFT009
      ** VAT Rate                                                               CFT009
     C                   PARM                    PVATR                          CFT009
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *                                                                         CFT009
      ** SWITCHABLE FEATURES                                                    CFT009
      ** ===================                                                    CFT009
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010            1            CFT010
      *                                                                         CFT009
      ** OUTPUT                                                                 CFT009
      ** ======                                                                 CFT009
      *                                                                         CFT009
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT009
     C                   Parm                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
      *                                                                         CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT009
     C                   PARM                    FTEIPY4                        CFT009
      *                                                                         CFT009
      ** Incoming Payments for file update - file format                        CFT009
     C                   PARM                    NWIPFILFMT                     CFT009
      *                                                                         CFT009
      ** Incoming Payments (additional details) for file update                 CFT009
     C                   PARM                    NWIP2FILFMT                    CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges Amount                                                         CFT009
     C                   PARM                    PCHARGES                       CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *                                                                         CFT009
      ** Previous warning messages array                                        CFT009
     C                   PARM                    WPrvWarnAr                     CFT009
      *                                                                         CFT009
      ** Warning message work fields                                            CFT009
     C                   PARM                    WFTF3185                       CFT009
     C                   PARM                    WFTF3172                       CFT009
      *                                                                         CFT009
      ** Update error information.                                              CFT009
      *                                                                         CFT009
     C                   IF        RETCODEOUT <> *BLANKS                        CFT009
     C                   EXSR      SRUPDATERRS                                  CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   ENDSR                                                  CFT009
      *****************************************************************         CFT009
      /EJECT                                                                    CFT009
                                                                                CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      *  SRMSCH3- Miscellaneous 3 Charge Validation                   *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
     C     SRMSCH3       BEGSR                                                  CFT009
      *                                                                         CFT009
      ** Reset fields.                                                          CFT009
      *                                                                         CFT009
     C                   EXSR      SRRESETERRS                                  CFT009
      *                                                                         CFT009
      ** Call validation module.                                                CFT009
      *                                                                         CFT009
     C                   CALLB     'FTVIMCCH03'                                 CFT009
      *                             ==========                                  CFT009
      ** INPUT                                                                  CFT009
      ** =====                                                                  CFT009
      *                                                                         CFT009
      ** Return Code                                                            CFT009
     C                   PARM                    RETCODEOUT                     CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP5SCNFMT                    CFT009
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     C                   PARM                    PICCY                          CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *                                                                         CFT009
      ** Input Charge Currency No. of Decimal Places                            CFT009
     C                   PARM                    PINBDP                         CFT009
      *                                                                         CFT009
      ** Output Charge Currency No. of Decimal Places                           CFT009
     C                   PARM                    PONBDP                         CFT009
      *                                                                         CFT009
      ** STANDING DATA                                                          CFT009
      ** =============                                                          CFT009
      *                                                                         CFT009
      ** VAT Rate                                                               CFT009
     C                   PARM                    PVATR                          CFT009
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *                                                                         CFT009
      ** SWITCHABLE FEATURES                                                    CFT009
      ** ===================                                                    CFT009
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010            1            CFT010
      *                                                                         CFT009
      ** OUTPUT                                                                 CFT009
      ** ======                                                                 CFT009
      *                                                                         CFT009
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT009
     C                   Parm                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
      *                                                                         CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT009
     C                   PARM                    FTEIPY4                        CFT009
      *                                                                         CFT009
      ** Incoming Payments for file update - file format                        CFT009
     C                   PARM                    NWIPFILFMT                     CFT009
      *                                                                         CFT009
      ** Incoming Payments (additional details) for file update                 CFT009
     C                   PARM                    NWIP2FILFMT                    CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges Amount                                                         CFT009
     C                   PARM                    PCHARGES                       CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *                                                                         CFT009
      ** Previous warning messages array                                        CFT009
     C                   PARM                    WPrvWarnAr                     CFT009
      *                                                                         CFT009
      ** Warning message work fields                                            CFT009
     C                   PARM                    WFTF3186                       CFT009
     C                   PARM                    WFTF3173                       CFT009
      *                                                                         CFT009
      ** Update error information.                                              CFT009
      *                                                                         CFT009
     C                   IF        RETCODEOUT <> *BLANKS                        CFT009
     C                   EXSR      SRUPDATERRS                                  CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   ENDSR                                                  CFT009
      *****************************************************************         CFT009
      /EJECT                                                                    CFT009
                                                                                CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      *  SRMSCH4- Miscellaneous 4 Charge Validation                   *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
     C     SRMSCH4       BEGSR                                                  CFT009
      *                                                                         CFT009
      ** Reset fields.                                                          CFT009
      *                                                                         CFT009
     C                   EXSR      SRRESETERRS                                  CFT009
      *                                                                         CFT009
      ** Call validation module.                                                CFT009
      *                                                                         CFT009
     C                   CALLB     'FTVIMCCH04'                                 CFT009
      *                             ==========                                  CFT009
      ** INPUT                                                                  CFT009
      ** =====                                                                  CFT009
      *                                                                         CFT009
      ** Return Code                                                            CFT009
     C                   PARM                    RETCODEOUT                     CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP5SCNFMT                    CFT009
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     C                   PARM                    PICCY                          CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *                                                                         CFT009
      ** Input Charge Currency No. of Decimal Places                            CFT009
     C                   PARM                    PINBDP                         CFT009
      *                                                                         CFT009
      ** Output Charge Currency No. of Decimal Places                           CFT009
     C                   PARM                    PONBDP                         CFT009
      *                                                                         CFT009
      ** STANDING DATA                                                          CFT009
      ** =============                                                          CFT009
      *                                                                         CFT009
      ** VAT Rate                                                               CFT009
     C                   PARM                    PVATR                          CFT009
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *                                                                         CFT009
      ** SWITCHABLE FEATURES                                                    CFT009
      ** ===================                                                    CFT009
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010            1            CFT010
      *                                                                         CFT009
      ** OUTPUT                                                                 CFT009
      ** ======                                                                 CFT009
      *                                                                         CFT009
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT009
     C                   Parm                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
      *                                                                         CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT009
     C                   PARM                    FTEIPY4                        CFT009
      *                                                                         CFT009
      ** Incoming Payments for file update - file format                        CFT009
     C                   PARM                    NWIPFILFMT                     CFT009
      *                                                                         CFT009
      ** Incoming Payments (additional details) for file update                 CFT009
     C                   PARM                    NWIP2FILFMT                    CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges Amount                                                         CFT009
     C                   PARM                    PCHARGES                       CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *                                                                         CFT009
      ** Previous warning messages array                                        CFT009
     C                   PARM                    WPrvWarnAr                     CFT009
      *                                                                         CFT009
      ** Warning message work fields                                            CFT009
     C                   PARM                    WFTF3187                       CFT009
     C                   PARM                    WFTF3174                       CFT009
      *                                                                         CFT009
      ** Update error information.                                              CFT009
      *                                                                         CFT009
     C                   IF        RETCODEOUT <> *BLANKS                        CFT009
     C                   EXSR      SRUPDATERRS                                  CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   ENDSR                                                  CFT009
      *****************************************************************         CFT009
      /EJECT                                                                    CFT009
                                                                                CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      *  SRMSCH5- Miscellaneous 5 Charge Validation                   *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
     C     SRMSCH5       BEGSR                                                  CFT009
      *                                                                         CFT009
      ** Reset fields.                                                          CFT009
      *                                                                         CFT009
     C                   EXSR      SRRESETERRS                                  CFT009
      *                                                                         CFT009
      ** Call validation module.                                                CFT009
      *                                                                         CFT009
     C                   CALLB     'FTVIMCCH05'                                 CFT009
      *                             ==========                                  CFT009
      ** INPUT                                                                  CFT009
      ** =====                                                                  CFT009
      *                                                                         CFT009
      ** Return Code                                                            CFT009
     C                   PARM                    RETCODEOUT                     CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP1SCNFMT                    CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP5SCNFMT                    CFT009
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     C                   PARM                    PICCY                          CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *                                                                         CFT009
      ** Input Charge Currency No. of Decimal Places                            CFT009
     C                   PARM                    PINBDP                         CFT009
      *                                                                         CFT009
      ** Output Charge Currency No. of Decimal Places                           CFT009
     C                   PARM                    PONBDP                         CFT009
      *                                                                         CFT009
      ** STANDING DATA                                                          CFT009
      ** =============                                                          CFT009
      *                                                                         CFT009
      ** VAT Rate                                                               CFT009
     C                   PARM                    PVATR                          CFT009
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *                                                                         CFT009
      ** SWITCHABLE FEATURES                                                    CFT009
      ** ===================                                                    CFT009
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010            1            CFT010
      *                                                                         CFT009
      ** OUTPUT                                                                 CFT009
      ** ======                                                                 CFT009
      *                                                                         CFT009
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT009
     C                   Parm                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
      *                                                                         CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT009
     C                   PARM                    FTEIPY4                        CFT009
      *                                                                         CFT009
      ** Incoming Payments for file update - file format                        CFT009
     C                   PARM                    NWIPFILFMT                     CFT009
      *                                                                         CFT009
      ** Incoming Payments (additional details) for file update                 CFT009
     C                   PARM                    NWIP2FILFMT                    CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges Amount                                                         CFT009
     C                   PARM                    PCHARGES                       CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *                                                                         CFT009
      ** Previous warning messages array                                        CFT009
     C                   PARM                    WPrvWarnAr                     CFT009
      *                                                                         CFT009
      ** Warning message work fields                                            CFT009
     C                   PARM                    WFTF3188                       CFT009
     C                   PARM                    WFTF3175                       CFT009
      *                                                                         CFT009
      ** Update error information.                                              CFT009
      *                                                                         CFT009
     C                   IF        RETCODEOUT <> *BLANKS                        CFT009
     C                   EXSR      SRUPDATERRS                                  CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   ENDSR                                                  CFT009
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTOTC - Total Charges Validation                            *
      *                                                               *
      *****************************************************************
     C     SRTOTC        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Before call calculate vat on total charges
      *
     C                   IF        S01499 = 'Y'                                              BUG2671
     C                             AND CFT009 ='N' OR CFT010 = 'Y'                           BUG2671
     C**********         IF        IPINDUM8 <> 0                                      BUG2671 257897
     C                   IF        IPINDUM8 <> 0 and PVATR <> 0                               257897
     C     IPINDUM8      MULT(H)   PVATR         IPINDUM8
     C                   ENDIF                                                               BUG2671
     C                   ENDIF                                                               BUG2671
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVITCHG'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Input Charge Currency
     C                   PARM                    PICCY
      *
      ** Output Charge Currency
     C                   PARM                    POCCY
      *
      ** Value Dates
     C                   PARM                    PVDates
      *
      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010                         CFT010
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *                                                                         CFT009
      ** Incoming Payments (additional details) for file update                 CFT009
     C                   PARM                    NWIP2FILFMT                    CFT009
      *
      ** Charges Amount
     C                   PARM                    PCharges
     C                   PARM                    BENEDrBlck                                 MD025111
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCRM - Receiver's Charges Remitted validation              *
      *                                                               *
      *****************************************************************
     C     SRRCRM        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVIRCRM'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      ** Incoming Payments Lvl 1 details
     C                   PARM                    NwIP1ScnFmt
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      ** Left-hand side charge currency
     C                   PARM                    PICCY
      ** Right-hand side charge currency
     C                   PARM                    POCCY
      ** BLI Funds Transfer enhancement
     C                   PARM                    S01494
      ** FT VAT processing
     C                   PARM                    S01499
      *
      ************
      ** OUTPUT **
      ************
      ** Incoming Payments Valid extension file
     C                   PARM                    NwIP2FilFmt
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
      ** I/O: Previous Receiver's charges remitted input
      **      Its value is maintained in FTVIRCRM
     C                   PARM                    PPrvDDRCRM       12
      ** I/O: Previous Total charges calculated
      **      Its value is maintained in FTVIRCRM
     C                   PARM                    PPrvTOTCHG       15 0
      ** Force redisplay
     C                   PARM                    PFrcReDisplay
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCHG - Sender's Charges validation                         *
      *                                                               *
      *****************************************************************
     C     SRSCHG        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVISCHG'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      *
      ************
      ** OUTPUT **
      ************
      ** Incoming Payments Valid extension file
     C                   PARM                    NwIP2FilFmt
      ** Incoming Payments Lvl 2 Scrn 3 details
     C                   PARM                    FTEIPY4
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                       CFT009
      /EJECT                                                                                  CFT009
      *****************************************************************                       CFT009
      *                                                               *                       CFT009
      *  SRCCCY - Recalculate charges if Charge to Debit account      *                       CFT009
      *           has been changed.                                   *                       CFT009
      *                                                               *                       CFT009
      *****************************************************************                       CFT009
     C     SRCCCY        BEGSR                                                                CFT009
      *
      ** Get Input Charge Currency.
      *
     C***********        SELECT
      ***********
     C*****BTCHCY        WHENEQ    'B'
     C*****DDCDRO        ORNE      *BLANKS                                                    CFT009
     C***********        MOVEL     BJCYCD        PICCY
     C***********        EVAL      PFrcReDisplay = 'Y'                                        CFT009
      ***********
     C*****BTCHCY        WHENEQ    'L'
     C***********        MOVEL     BJLCCY        PICCY
      ***********
     C*****BTCHCY        WHENEQ    'F'
     C***********        MOVEL     FCHCCY        PICCY
      ***********
     C*****BTCHCY        WHENEQ    'C'
     C*****IPADDC        ANDEQ     'A'
     C***********        MOVEL     IPSMCY        PICCY
      ***********
     C***********        OTHER
     C***********        MOVEL     IPPCCY        PICCY
      ***********
     C***********        ENDSL
      ***********
      ***Get*Output Charge Currency.
      ***********
     C***********        SELECT
      ***********
     C*****DDCDRO        WHENNE    *BLANKS                                                    CFT009
     C***********        MOVEL     BJCYCD        POCCY
      ***********
     C*****IPADDC        WHENEQ    'A'
     C***********        MOVEL     IPSMCY        POCCY
     C*****IPSND1        IFEQ      'CASHIER'
     C*****IPPCCY        ANDEQ     BJCYCD
     C***********        MOVEL     IPPCCY        POCCY
     C***********        ENDIF
      ***********
     C***********        OTHER
     C***********        MOVEL     IPPCCY        POCCY
      ***********
     C***********        ENDSL
      ***********                                                                             CFT009
      ***Set*Input and Ouput currency to Base currency if                                     CFT009
      ***'Charges to Debit Of' customer has been changed.                                     CFT009
      ***********                                                                             CFT009
     C***********        IF        DDCDRO <> *BLANKS                                          CFT009
      ***********                                                                             CFT009
      ***Redisplay screen to show new default charges.                                        CFT009
      ***********                                                                             CFT009
     C***********        EVAL      PFrcReDisplay = 'Y'                                        CFT009
      ***Get*Base currency no. of decimal places.                                             CFT009
     C***********        CALLB     'AOCURRR0'                                                 CFT009
     C***********        PARM      *BLANK        PRtcd                                        CFT009
     C***********        PARM      '*KEY   '     POptn                                        CFT009
     C***********        PARM                    BJCYCD                                       CFT009
     C*****SDCURR        PARM      SDCURR        DSSDY                                        CFT009
      ***********                                                                             CFT009
     C*****PRTCD         IFNE      *BLANKS                                                    CFT009
     C***********        MOVEL     BJCYCD        DBKEY                                        CFT009
     C***********        MOVEL     'SDCURRPD'    DBFILE                                       CFT009
     C***********        Z-ADD     1             DBASE                                        CFT009
     C***********        EXSR      *PSSR                                                      CFT009
     C***********        ENDIF                                                                CFT009
      ***********                                                                             CFT009
      ***Set*up*input and output currency details.                                            CFT009
     C***********        EVAL      PICCY = BJCYCD                                             CFT009
     C***********        EVAL      PINBDP = A6NBDP                                            CFT009
     C***********        EVAL      POCCY = BJCYCD                                             CFT009
     C***********        EVAL      PONBDP = A6NBDP                                            CFT009
      ***********                                                                             CFT009
     C***********        ENDIF                                                                CFT009
      *                                                                                       CFT009
      ***Set*Input*and*Ouput*currency*to*Base*currency*if                              CFT009 CFT120
      ** Set Ouput currency to Base or Other currency if                                      CFT120
      ** 'Charges to Debit Of' customer has been changed.                       CFT009
      ** Input currency (from ICD setting) should never change.                               CFT120
                                                                                CFT009
     C                   IF        PCDROCHG = 'Y'                               CFT009
      *----------------------------------------------------------------------------------*    247273
      ** If Level 4 is reached and new input CDRO is validated, if CDRO had been filled and   247273
      ** was cleared, some of the original values are still kept: POCCY is still Base Ccy     247273
      ** while PICCY In Currency is the currency according to ICD (CFT009)                    247273
      ** so the default values of the Charges Out currency POCCY need to be reset (FTIPAY1DT) 247273
      ** Code has to emulate processing of Level 1 FT000980 in calculating Cross Rate I2XRTE  247273
                                                                                              247273
     C                   If        DDCDRO = *Blanks                                           247273
      ** Retrieve the charge currency                                                         247273
                                                                                              247273
     C                   Select                                                               247273
      ** Base                                                                                 247273
     C                   When      BTCHCY = 'B'                                               247273
     C                   Eval      I2CCDE = BJCYCD                                            247273
      ** Local                                                                                247273
     C                   When      BTCHCY = 'L'                                               247273
     C                   Eval      I2CCDE = BJLCCY                                            247273
      ** Charge                                                                               247273
     C                   When      BTCHCY = 'C'                                               247273
     C                   If        IPADDC = 'A'                                               247273
     C                   Eval      I2CCDE = IPSMCY                                            247273
     C                   Else                                                                 247273
     C                   Eval      I2CCDE = IPPCCY                                            247273
     C                   Endif                                                                247273
      ** Fixed                                                                                247273
     C                   When      BTCHCY = 'F'                                               247273
     C                   Eval      I2CCDE = FCHCCY                                            247273
                                                                                              247273
     C                   Endsl                                                                247273
                                                                                              247273
     C                   IF        CFT120 = 'N'                                               CFT120
     C                   Eval      PICCY = I2CCDE                                             247273
     C                   ENDIF                                                                CFT120
     C                   Eval      PXCCY = PICCY                                              247273
     C                   Exsr      SRCURR                                                     247273
     C                   Eval      PINBDP = A6NBDP                                            247273
     C                   Eval      ZRATE1 = A6SPRT                                            247273
     C                   Eval      ZMDI1  = A6MDIN                                            247273
      ** Output Charge Currency.                                                              247273
     C                   Select                                                               247273
     C                   When      IPADDC = 'A'                                               247273
     C                   Eval      POCCY = IPSMCY                                             247273
     C                   If        IPSND1 = 'CASHIER' And                                     247273
     C                             IPPCCY = BJCYCD                                            247273
     C                   Eval      POCCY = IPPCCY                                             247273
     C                   EndIf                                                                247273
     C                   Other                                                                247273
     C                   Eval      POCCY = IPPCCY                                             247273
     C                   Endsl                                                                247273
                                                                                              247273
     C                   Eval      PXCCY = POCCY                                              247273
     C                   Exsr      SRCURR                                                     247273
     C                   Eval      PONBDP = A6NBDP                                            247273
     C                   Eval      ZRATE2 = A6SPRT                                            247273
     C                   Eval      ZMDI2  = A6MDIN                                            247273
      ** Work out xrate between to and from currencies                                        247273
     C                   Eval      ZRATEX = 0                                                 247273
     C                   Eval      ZMDIX  = ' '                                               247273
                                                                                              247273
     C                   CALLB     'ZXRATE'                                                   247273
     C                   PARM                    ZRATE1                                       247273
     C                   PARM                    ZMDI1                                        247273
     C                   PARM                    ZRATE2                                       247273
     C                   PARM                    ZMDI2                                        247273
     C                   PARM                    ZRATEX                                       247273
     C                   PARM                    ZMDIX                                        247273
                                                                                              247273
     C                   Eval      I2XRTE = ZRATEX                                            247273
      ** If using exchange rate from transaction, move in the correct rate.                   247273
     C                   If        CHTRCY = 'Y'                                               247273
     C                   If        PICCY = IPSMCY AND POCCY = IPPCCY                          247273
     C                             OR POCCY = IPSMCY AND PICCY = IPPCCY                       247273
     C                   EVAL      I2XRTE = IPRATE                                            247273
     C                   Endif                                                                247273
     C                   Endif                                                                247273
                                                                                              247273
     C                   Endif                                                                247273
     C                   Eval      PFrcReDisplay = 'Y'                                        254970
     C                   Endif                                                                247273
                                                                                              247273
      ** Save charge details before the values replaced, else zero values                     247273
      ** Save charge and levied currencies, and exchange rate incase                          247273
      ** charges to the debit of field is blanked out again.                                  247273
                                                                                              247273
     C     *LIKE         DEFINE    POCCY         Saved_Lev_ccy                                247273
     C     *LIKE         DEFINE    I2CCDE        Saved_Chg_ccy                                247273
     C     *LIKE         DEFINE    I2XRTE        Saved_X_Rate                                 247273
                                                                                              247273
     C                   EVAL      Saved_Chg_ccy = I2CCDE                                     247273
     C                   EVAL      Saved_X_Rate = I2XRTE                                      247273
     C                   EVAL      Saved_Lev_ccy = POCCY                                      247273
                                                                                              247273
      *----------------------------------------------------------------------------------*    247273
                                                                                CFT009
      ** Redisplay screen to show new default charges.                          CFT009
     C**********         EVAL      PFrcReDisplay = 'Y'                                 CFT009 254970
                                                                                CFT009
      ** If charges to the debit of field is filled in, set charge ccy          CFT009
      ** to be the base currency                                                CFT009
     C                   If        DDCDRO <> *BLANKS                            CFT009
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   Eval      PFrcReDisplay = 'Y'                                        CFT120
     C                   ENDIF                                                                CFT120
                                                                                CFT009
      ** Get Base currency no. of decimal places.                               CFT009
     C                   CALLB     'AOCURRR0'                                   CFT009
     C                   PARM      *BLANK        PRtcd                          CFT009
     C                   PARM      '*KEY   '     POptn                          CFT009
     C                   PARM                    BJCYCD                         CFT009
     C     SDCURR        PARM      SDCURR        DSSDY                          CFT009
      *                                                                         CFT009
     C     PRTCD         IFNE      *BLANKS                                      CFT009
     C                   MOVEL     BJCYCD        DBKEY                          CFT009
     C                   MOVEL     'SDCURRPD'    DBFILE                         CFT009
     C                   Z-ADD     1             DBASE                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
     C                   IF        CFT120 = 'Y'                                               CFT120
      *  Set up input currency details.                                                       CFT120
     C                   EVAL      PINBDP = A6NBDP                                            CFT120
      *  Set up output currency details.                                                      CFT120
     C                   EVAL      PONBDP = A6NBDP                                            CFT120
      *                                                                                       CFT120
     C                   If        DDCDRC <> *Blanks                                          CFT120
     C                   If        OkCdrc <> 'N'                                              CFT120
      ** Get Charges to the DR of Currency exchange rate                                      CFT120
     C                   CALLB     'AOCURRR0'                                                 CFT120
     C                   PARM      *BLANK        PRtcd                                        CFT120
     C                   PARM      '*KEY   '     POptn                                        CFT120
     C                   PARM                    DDCDRC                                       CFT120
     C     SDCURR        PARM      SDCURR        DSSDY                                        CFT120
      *                                                                                       CFT120
     C     PRTCD         IFNE      *BLANKS                                                    CFT120
     C                   MOVEL     DDCDRC        DBKEY                                        CFT120
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CFT120
     C                   Z-ADD     2             DBASE                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *  Set up output currency details.                                                      CFT120
     C                   EVAL      PONBDP = A6NBDP                                            CFT120
      *  Set up exchange rate                                                                 CFT120
     C                   Eval      I2XRTE  = A6SPRT                                           CFT120
     C                   EndIf                                                                CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
                                                                                CFT009
      *----------------------------------------------------------------------------------*    247273
      ***Save*charge*and*levied*currencies,*and*exchange*rate*incase******      CFT009        247273
      ***charges*to*the*debit*of*field*is*blanked*out*again.**************      CFT009        247273
      ********************************************************************      CFT009        247273
     C******LIKE*********DEFINE****POCCY*********Saved_Lev_ccy************      CFT009        247273
     C******LIKE*********DEFINE****I2CCDE********Saved_Chg_ccy************      CFT009        247273
     C******LIKE*********DEFINE****I2XRTE********Saved_X_Rate*************      CFT009        247273
      ********************************************************************      CFT009        247273
     C*******************EVAL******Saved_Chg_ccy*=*I2CCDE*****************      CFT009        247273
     C*******************EVAL******Saved_X_Rate*=*I2XRTE******************      CFT009        247273
     C*******************EVAL******Saved_Lev_ccy*=*POCCY******************      CFT009        247273
      *----------------------------------------------------------------------------------*    247273
                                                                                CFT009
      ** Set up input and output currency details.                              CFT009
                                                                                CFT009
      *                                                                                       CFT120
      ** If Charges to the DR currency not used, use Base                                     CFT120
      *                                                                                       CFT120
     C                   IF        DDCDRC = *BLANKS AND CFT120 = 'Y' OR                       CFT120
     C                             CFT120 = 'N'                                               CFT120
      *                                                                                       CFT120
     C                   EVAL      POCCY = BJCYCD                               CFT009
     C                   IF        CFT120 = 'N'                                               CFT120
     C                   EVAL      PICCY = BJCYCD                               CFT009
     C***********        EVAL      I2CCDE = BJCYCD                              CFT009
      *----------------------------------------------------------------------------------*    247273
      *  Set up input and output currency details.                                            247273
     C                   EVAL      PINBDP = A6NBDP                                            247273
     C                   EVAL      PONBDP = A6NBDP                                            247273
      *----------------------------------------------------------------------------------*    247273
                                                                                CFT009
      ** Set up charge currency.                                                CFT009
     C                   EVAL      I2CCDE = BJCYCD                              CFT009
     C                   ENDIF                                                                CFT120
      ** Set up charges exchange rate.                                          CFT009
     C                   EVAL      I2XRTE = 1                                   CFT009
                                                                                CFT009
      *                                                                                       CFT120
      ** Else use Charges to the DR of Currency                                               CFT120
      *                                                                                       CFT120
     C                   ELSE                                                   CFT009
                                                                                CFT009
     C                   EVAL      POCCY  =  DDCDRC                                           CFT120
      *                                                                                       CFT120
      ** Set up input and output currency details.                                            CFT120
      *                                                                                       CFT120
     C                   EVAL      PINBDP = A6NBDP                                            CFT120
      *                                                                                       CFT120
     C                   If        OkCdrc <> 'N'                                              CFT120
      *                                                                                       CFT120
      ** Get Charges to the DR of Currency exchange rate                                      CFT120
      *                                                                                       CFT120
     C                   CALLB     'AOCURRR0'                                                 CFT120
     C                   PARM      *BLANK        PRtcd                                        CFT120
     C                   PARM      '*KEY   '     POptn                                        CFT120
     C                   PARM                    DDCDRC                                       CFT120
     C     SDCURR        PARM      SDCURR        DSSDY                                        CFT120
      *                                                                                       CFT120
     C     PRTCD         IFNE      *BLANKS                                                    CFT120
     C                   MOVEL     DDCDRC        DBKEY                                        CFT120
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CFT120
     C                   Z-ADD     2             DBASE                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
      ** Set up output currency details.                                                      CFT120
      *                                                                                       CFT120
     C                   EVAL      PONBDP = A6NBDP                                            CFT120
      *                                                                                       CFT120
      ** Set up exchange rate                                                                 CFT120
      *                                                                                       CFT120
     C                   Eval      I2XRTE  = A6SPRT                                           CFT120
     C                   EndIf                                                                CFT120
     C                   ENDIF                                                                CFT120
     C                   IF        CFT120 = 'N'                                               CFT120
      ** If the charges to the debit of field has been blanked, restore         CFT009
      ** the charge currency                                                    CFT009
                                                                                CFT009
     C                   EVAL      POCCY = Saved_Lev_ccy                        CFT009
     C                   EVAL      PICCY = Saved_Chg_ccy                        CFT009
     C                   EVAL      I2CCDE = Saved_Chg_ccy                       CFT009
     C                   EVAL      I2XRTE = Saved_X_Rate                        CFT009
     C                   ENDIF                                                                CFT120
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C****************** ENDIF                                                  CFT009        247273
     C                   ENDSR                                                                CFT009
      *****************************************************************                       247273
      *                                                               *                       247273
      *      SRCURR  - Routine to access the currency file            *                       247273
      *                                                               *                       247273
      *****************************************************************                       247273
     C     SRCURR        BEGSR                                                                247273
      *                                                                                       247273
     C                   CALLB     'AOCURRR0'                                                 247273
     C                   PARM      *BLANK        PRtcd                                        247273
     C                   PARM      '*KEY   '     POptn                                        247273
     C                   PARM                    PXCCY             3                          247273
     C     SDCURR        PARM      SDCURR        DSSDY                                        247273
     C                   ENDSR                                                                247273
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETERRS - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *                                                               *
      *****************************************************************
     C     SRResetErrs   BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
      *
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDATERRS - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
     C     SRUpdatErrs   BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     FldNamXar     FldNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Error Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FLDNAMEARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             IDX
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(Ix)
     C                   MOVE      *BLANKS       MSGIDARR(Ix)
     C                   MOVE      *BLANKS       MSGDTAARR(Ix)
     C                   Eval      IDX = ArrayMax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFldNamArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(Ix)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(Ix)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Warning Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFLDNAMARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             WIDX
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(Ix)
     C                   MOVE      *BLANKS       WMSGIDARR(Ix)
     C                   MOVE      *BLANKS       WMSGDTAARR(Ix)
     C                   Eval      WIDX = ArrayMax - 1
     C                   ENDIF
      *
     C                   ENDSR
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
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** Incoming Payments Lvl 1 details
     C                   PARM                    NwIP1ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP5ScnFmt
      *
      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy          1
      *
      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD          5 0
      *
      ** Payment In Currency Indicator
     C                   PARM                    PPayInCy          1
      *
      ** Payment EMU Transaction Period Start Date
     C                   PARM                    PPayTPSD          5 0
      *
      ** Input Charge Currency
     C                   PARM                    PICCY             3
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP            1 0
      *
      ** Output Charge Currency
     C                   PARM                    POCCY             3
      *
      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP            1 0
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD            3
      *
      ** SDBANK - Midas Run Date
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD            3 0
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDBANK - Local currency code
     C                   PARM                    BJLCCY            3
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN            1
      *
      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN            1
      *
      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR            1
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO            3
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** VAT Default Flag
     C                   PARM                    PVATT             1
      *
      ** VAT Rate
     C                   PARM                    PVATR             5 4
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY            1            CFT009
      *                                                                         CFT009
      ** SDFTFR - Charges currency indicator                                    CFT009
     C                   PARM                    BTCHCY            1            CFT009
      *                                                                         CFT009
      ** SDFTFR - Fixed charge currency                                         CFT009
     C                   PARM                    FCHCCY            3            CFT009
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
      *
      ** MT103 Messages Generation for FT
     C                   PARM                    CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
     C                   PARM                    CFT010            1            CFT010
      *                                                                                       CFT120
      ** FT IN/OP - Charges on DR of Account Ccy                                              CFT120
      *                                                                                       CFT120
     C                   PARM                    CFT120                                       CFT120
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    FTEIPY4
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Incoming Payments (extension) for file update - file format
     C                   PARM                    NwIP2FilFmt
      *
      ** DS for Default Charge Amounts
     C*****************  PARM                    PCharges        108            CFT009
     C                   PARM                    PCharges        196            CFT009
      *
      ** Force redisplay
     C                   PARM                    PFrcReDisplay     1
      *
      ** I/O: Previous Receiver's charges remitted input
      **      Its value is maintained in FTVIRCRM
     C                   PARM                    PPrvDDRCRM
      *
      ** I/O: Previous Total charges calculated
      **      Its value is maintained in FTVIRCRM
     C                   PARM                    PPrvTOTCHG
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *                                                                         CFT009
      ** Previous warning messages array                                        CFT009
     C                   PARM                    WPrvWarnAr                     CFT009
      *                                                                         CFT009
      ** Warning message work inds for charges screen                           CFT009
     C                   PARM                    PChgWarn                       CFT009
     C                   PARM                    BENEDrBlck        1                        MD025111
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,FTIPY4V031
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,FTH00550
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
