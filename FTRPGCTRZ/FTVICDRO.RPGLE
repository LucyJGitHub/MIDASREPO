     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP charges to the debit of a/c')     *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVICDRO - Validate Charges to the Debit of A/c              *
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
      *  Last Amend No. MD047884           Date 25Sep17               *      
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CFT157             Date 29Aug14               *
      *                 MD000091           Date 07May13               *
      *                 AR1095997          Date 20Mar13               *
      *                 CFT120             Date 28Sep12               *
      *                 CFT145             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247142             Date 31May07               *
      *                 247375             Date 04May07               *
      *                 242926             Date 13Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240689             Date 13Jul06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187056             Date 01Dec00               *
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD047884 - Error in IPAY insert when Add/Deduct Charges      *
      *             Indicator is Add and Charges to the Debit of A/c  *
      *             is blocked debit.                                 *      
      *  MD046248 - Finastra Rebranding                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1095997 - 45032686 Record not found or is marked as        *
      *              deleted (Field: Charges to the Debit of A/c) is  *
      *              encountered if Nostro is used in the said field. *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CFT145 - FT IN/OP - Charges to the Debit of Account          *
      *           Validation                                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning. Same fix 240689. *
      *           Apply fixes 232151 and 210654.                      *
      *  232151 - DBASE error when inserting an inactive account.     *
      *  210654 - Check status of Account.                            *
      *  247375 - Add Validation of Retail or Nostro + Branch in CDRO *
      *  242926 - Error if alpha customer number in partial account   *
      *  240689 - Check status of Account. Applied fix 210654.        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  187056 - IP and OP do not recalculate screen charges if      *
      *           'Charges to the Debit of a/c' has been changed      *
      *           from blank to non-blank.                            *
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
      ** GL Accounts file
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      *
      ** Retail Accounts file
     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMABF)
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
      ***Incoming*Payments*Lvl*2*Scrn*1/2*details*from*incoming*transaction     CFT014
      ***-*screen*format***********************************************         CFT014
     D*NwIP3ScnFmt***E DS                  EXTNAME(FTIPY3PD)                    CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     D NwIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)                    CFT014
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ***Incoming*Payments*Lvl*2*Scrn*1*error*indicators***************         CFT014
     D*FTEIPY2****   E DS                  EXTNAME(FTEIPY2PD)                   CFT014
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT014
     D FTEIPY4       E DS                  EXTNAME(FTEIPY4PD)                   CFT014
      *
      ** Externally described DS for Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      ** External DS for Currency details                                                     CFT120
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CFT120
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
      *
     D/COPY WNCPYSRC,FTH00523
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                       CFT120
      ** External data structure for access programs (Long)                                   CFT120
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CFT120
      *
      ** DS for Charges to the DR of A/c
     D*WCCDRO***       DS            12                                                       CGL029
     D WCCDRO          DS                                                                     CGL029
     D  WNOSTRO                1      2
     D  WRETAIL                3     10
     D  WPARTIAL              17     18                                                       CGL029
     D**WPARTIAL              11     12                                                       CGL029
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *                                                                                       240689
     D WIx             S              3P 0                                                    240689
      *                                                                                       240689
      ** Index for arrays of warning message ids etc                                          240689
      *
      ** Work variable for Charges to the DR of A/c
     D*WDCDRO***       S             12S 0                                                    CGL029
     D*WDCDRO***       S             18S 0                                             CGL029 CSD027
     D WDCDRO          S             18A                                                      CSD027
                                                                                              CGL029
      ** Fields redefined by CGL029                                                           CGL029
     D ACCS            S             12A                                                      CGL029
     D KACCD           S             10P 0                                                    CGL029
     D PACCN           S             10A                                                      CGL029
     D Ccy             S              3A                                                      CFT120
     D CFT120          S              1A                                                      CFT120
     D LWRC            C                   'abcdefghijklmnopqrstuvwxyz'                       CFT120
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
     D CHACDrBlck      S              1A                                                    MD047884
      *
      ** +--------------------------------------+
      ** ¦ /COPYs                               ¦
      ** ¦ ======                               ¦
      ** +--------------------------------------+
      *
      /COPY FTCPYSRC,SFTVALCSLE
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
      *
     C                   Z-ADD     0             IDx
     C*****              Z-ADD     0             WDCDRO                                       CSD027
     C                   EVAL      WDCDRO = *blanks                                           CSD027
     C                   Z-ADD     0             WY                                           187056
     C                   Eval      WFldNmXAr = *Blanks                                        240689
     C                   Eval      WMsgIDXAr  = *Blanks                                       240689
     C                   Eval      WMsgDtXAr = *Blanks                                        240689
     C                   Eval      WIx = 0                                                    240689
     C                   BITOFF    '01234567'    WRETB             1                          240689
      *                                                                                       CFT120
      ** Set valid value to blanks                                                            CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   Eval      IPCDRC = *Blanks                                           CFT120
     C                   Eval      DDCDRO = %Xlate(LWRC: ALPHAB: DDCDRO)                      CFT120
     C                   ENDIF                                                                CFT120
      *
      ** Validate Charges to the Debit of A/c.
      *
     C                   EXSR      SRValCDRO
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKCDRO = 'N' OR OKCDBR = 'N'
     C                             OR   OKCDRC =  'N' AND CFT120 = 'Y'                        CFT120
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        OKCDRO <> 'N' AND OKCDBR <> 'N'
     C                             AND CFT120 = 'N'                                           CFT120
     C                             OR  OKCDRO <> 'N' AND OKCDBR <> 'N'                        CFT120
     C                             AND  OKCDRC <> 'N' AND CFT120 = 'Y'                        CFT120
      *
     C*****              Z-ADD     WDCDRO        IPCDRO                                       CSD027
     C                   EVAL      IPCDRO = WDCDRO                                            CSD027
     C                   MOVEL     DDCDBR        IPCDBR
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      IPCDRC = DDCDRC                                            CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   SELECT
     C     WY            WHENEQ    3
     C                   MOVEL     'N'           IPCDRT
     C     WY            WHENEQ    11
     C                   MOVEL     'R'           IPCDRT
     C*****WY            WHENEQ    13                                                         CGL029
     C     WY            WHENEQ    19                                                         CGL029
     C                   MOVEL     'P'           IPCDRT
     C                   OTHER                                                                187056
     C                   MOVE      *BLANK        IPCDRT                                       187056
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValCDRO - Validate Charges to the Debit of A/c             *
      *                                                               *
      *****************************************************************
      *
     C     SRValCDRO     BEGSR
      *
      ** Charges to the Debit of A/c is optional.
      ** 3 formats are acceptable - Nostro, Retail A/c, A/c No.
      *
      ** If blank and branch entered error
      *
     C     DDCDRO        IFEQ      *BLANKS
     C     DDCDBR        ANDNE     *BLANKS
     C                   MOVEL     'N'           OKCDRO
     C                   MOVEL     'N'           OKCDBR
     C                   ADD       1             IDx
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)
     C**********         MOVEL     DDCDRO        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDRO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDCDRO)                   MD000091
     C                   MOVEL     'FTM2056'     MsgIDxAr(IDx)
     C                   GOTO      EXCDRO
     C                   ENDIF
      *
      ** Field is optional, exit if blank
      *
     C     DDCDRO        IFEQ      *BLANKS
     C     CFT120        ANDEQ     'N'                                                        CFT120
     C     DDCDRO        OREQ      *BLANKS                                                    CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C     DDCDRC        ANDEQ     *BLANKS                                                    CFT120
     C                   GOTO      EXCDRO
     C                   ENDIF
      *
      *                                                                                       CFT120
      ** Currency entered but no CDRO                                                         CFT120
     C                   IF        DDCDRC   <> *BLANKS  AND                                   CFT120
     C                             DDCDRO   =  *BLANKS  AND                                   CFT120
     C                             CFT120   =  'Y'                                            CFT120
     C                   EVAL      OkCdro = 'N'                                               CFT120
     C                   EVAL      OkCdrc = 'N'                                               CFT120
     C                   EVAL      Idx = Idx + 1                                              CFT120
     C                   EVAL      FldNamXAr(Idx) = 'DDCDRO'                                  CFT120
     C                   EVAL      MsgIdXAr(Idx) = 'FTM7100'                                  CFT120
     C                   GOTO      EXCDRO                                                     CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
      ** Currency entered but invalid currency                                                CFT120
                                                                                              CFT120
     C                   IF        DDCDRC  <> *BLANKS AND CFT120 = 'Y'                        CFT120
      *                                                                                       CFT120
      ** If entered, Charges currency must be valid on the system                             CFT120
     C                   CALL      'AOCURRR0'                                                 CFT120
     C                   PARM      *Blanks       PRtcd                                        CFT120
     C                   PARM      '*KEY'        POptn                                        CFT120
     C                   PARM      DDCDRC        Ccy                                          CFT120
     C     SDCURR        PARM      SDCURR        DSSDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        PRtcd <> *BLANKS                                           CFT120
     C                   EVAL      OkCdro = 'N'                                               CFT120
     C                   EVAL      OkCdrc = 'N'                                               CFT120
     C                   EVAL      Idx = Idx + 1                                              CFT120
     C                   EVAL      FldNamXAr(Idx) = 'DDCDRC'                                  CFT120
     C                   EVAL      MsgIdXAr(Idx) = 'FTM3255'                                  CFT120
     C                   GOTO      EXCDRO                                                     CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   EVAL      WCCDRO = DDCDRO
      *
     C                   IF        WPARTIAL <> *BLANKS
     C*****              TESTN                   WCCDRO               01                      242926
     C                   EVAL      *IN01 = *ON                                                242926
     C                   ELSE
     C                   IF        WRETAIL <> *BLANKS
     C                   MOVEL     WCCDRO        W10              10
     C                   TESTN                   W10                  01
     C                   ELSE
     C                   IF        WNOSTRO <> *BLANKS
     C                   MOVEL     WCCDRO        W02               2
     C                   TESTN                   W02                  01
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Determine the number of digits in the field
      ** Check first two characters are numeric and rest is blank
      *
     C                   MOVEL     *BLANKS       W_Fld            35
     C                   MOVEL     DDCDRO        W_Fld
     C*****DIGITS        CHECK     W_Fld         WY                3 0    90                  242926
     C     ALPHAN        CHECK     W_Fld         WY                3 0    90                  242926
      *
      ** 2, 10 and 12 digits allowed
      *
     C     *IN90         IFEQ      '1'
     C     WY            ANDEQ     3
     C     *IN90         OREQ      '1'
     C     WY            ANDEQ     11
     C     *IN90         OREQ      '1'
     C*****WY***         ANDEQ     13                                                         CGL029
     C     WY            ANDEQ     19                                                         CGL029
     C     DDCDBR        ANDNE     *BLANKS
     C     BGMBIN        ANDEQ     'Y'
     C     *IN90         OREQ      '1'
     C*****WY***         ANDEQ     13                                                         CGL029
     C     WY            ANDEQ     19                                                         CGL029
     C     BGMBIN        ANDNE     'Y'
     C                   MOVEL     '0'           *IN90
     C                   ENDIF
      *
      ** Field is invalid format
      *
     C     *IN90         IFEQ      '1'
     C     *IN01         OREQ      '0'
     C                   MOVEL     'N'           OKCDRO
     C                   MOVEL     'N'           OKCDBR
     C                   ADD       1             IDx
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)
     C**********         MOVEL     DDCDRO        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDRO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDCDRO)                   MD000091
     C                   MOVEL     'FTM2057'     MsgIDxAr(IDx)
     C                   GOTO      EXCDRO
     C                   ENDIF
      *
     C                   MOVEL     DDCDRO        WDCDRO
      *
      ** If 10 digits and Retail accounts not used error
      *
     C     BMRANR        IFNE      'Y'
     C     WY            ANDEQ     11
     C     DDCDBR        ANDEQ     *BLANKS
     C                   MOVEL     'N'           OKCDRO
     C                   MOVEL     'N'           OKCDBR
     C                   ADD       1             IDx
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)
     C**********         MOVEL     DDCDRO        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDRO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDCDRO)                   MD000091
     C                   MOVEL     'FTM2058'     MsgIDxAr(IDx)
     C                   GOTO      EXCDRO
     C                   ENDIF
      *
      ** Check if a 2 digit Nostro code has been entered - based on
      ** no. of blanks found in field
      *
     C     WY            IFEQ      3
     C     DDCDBR        ANDEQ     *BLANKS
      *
      ** Validate Nostro Code
      *
     C                   MOVEL     DDCDRO        WNosN             2
      *                                                                                       CFT120
     C                   IF        DDCDRC  =  *BLANKS AND CFT120 ='Y'                         CFT120
     C                             OR CFT120 = 'N'                                            CFT120
     C                   EVAL      PCYCD   =  BJCYCD                                          CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      PCYCD   =  DDCDRC                                          CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM      '*KEY   '     POptn             7
     C                   PARM      *BLANKS       PCUST             6
     C**********         PARM      BJCYCD        PCYCD             3                          CFT120
     C                   PARM                    PCYCD             3                          CFT120
     C**********         PARM      *BLANKS       PACCN             4                          CGL029
     C                   PARM      *BLANKS       PACCN                                        CGL029
     C                   PARM      *BLANKS       PACSN             2
     C                   PARM      WNosN         PNONB             2
     C                   PARM      *BLANKS       PBRCD             3
     C                   PARM      *BLANKS       PCSSN            10
     C                   PARM      *BLANKS       PPNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
      ** If error on call
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     DDCDRO        DBKey
     C                   MOVEL     'SDNOSTPD'    DBFile
     C                   Z-ADD     001           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If not found error
      *
     C     PRtcd         IFNE      *BLANKS
     C                   MOVEL     'N'           OKCDRO
     C                   MOVEL     'N'           OKCDBR
     C                   IF        DDCDRC <> *BLANKS AND CFT120 = 'Y'                         CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             IDx
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)
     C**********         MOVEL     DDCDRO        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDRO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDCDRO)                   MD000091
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVEL     'FTM7101'     MsgIDxAr(IDx)                                CFT120
     C                   ELSE                                                                 CFT120
     C                   MOVEL     'FTM2059'     MsgIDxAr(IDx)
     C                   ENDIF                                                                CFT120
      *
     C                   GOTO      EXCDRO
     C                   ENDIF
      *
      ** Set up ACCNTAB fields
      *
     C                   MOVE      A7ACCD        ACOD
     C                   MOVE      A7ACSN        ACSQ
     C                   MOVE      A7CUST        CNUM
     C                   MOVE      A7CYCD        CCY
     C                   MOVE      A7BRCD        BRCA
     C                   MOVE      A7CUST        WWCDCN            6                          CFT145
      *
      ** Access Full Account Details for later validation
      *
     C                   MOVEL     A7CYCD        KACCCY            3
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVEL     A7CYCD        KACYCD                                       CFT120
     C                   ELSE                                                              AR1095997
     C                   MOVEL     KACCCY        KACYCD                                    AR1095997
     C                   ENDIF                                                                CFT120
     C**********         Z-ADD     CNUM          KACNUM                                       CSD027
     C                   EVAL      KACNUM = CNUM                                              CSD027
     C                   Z-ADD     ACOD          KACCD
     C                   Z-ADD     ACSQ          KACSQ
     C                   MOVE      BRCA          KBRCA
      *
     C     KAckey        CHAIN     ACCNTABF                           90
      *
     C     *IN90         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   MOVEL     'N'           OKCDRO
     C                   IF        DDCDRC <> *BLANKS AND CFT120 = 'Y'                         CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             IDx
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVEL     'FTM7101'     MsgIDxAr(IDx)                                CFT120
     C                   ELSE                                                                 CFT120
     C                   MOVEL     'MEM5004'     MsgIDxAr(IDx)
     C                   ENDIF                                                                CFT120
     C                   GOTO      EXCDRO
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check for Retail Account No. being entered
      ** only if Debit Customer reference is not entered OR
      ** multibranching is not active.
      *
     C     WY            IFEQ      11
     C     DDCDBR        ANDEQ     *BLANKS
      *
     C                   MOVEL     DDCDRO        WReNo            10 0
     C     WReNo         CHAIN     ACNUMA                             90
      *
     C     *IN90         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   MOVEL     'N'           OKCDRO
     C                   MOVEL     'N'           OKCDBR
     C                   ADD       1             IDx
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)
     C**********         MOVEL     DDCDRO        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDRO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDCDRO)                   MD000091
     C                   MOVEL     'FTM2060'     MsgIDxAr(IDx)
     C                   GOTO      EXCDRO
     C                   ELSE                                                                 CFT145
     C                   MOVEL     CNUM          WWCDCN            6                          CFT145
      *                                                                                       CFT120
      ** If charges currency not same as currency of account specified                        CFT120
     C                   IF        DDCDRC <> *BLANKS AND                                      CFT120
     C                             CCY    <> DDCDRC AND CFT120 = 'Y'                          CFT120
      *                                                                                       CFT120
      ** Send error to screen                                                                 CFT120
     C                   MOVE      'N'           OKCdro                                       CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ADD       1             Idx                                          CFT120
     C                   MOVEL     'DDCDRC'      FldNamXAr(Idx)                               CFT120
     C                   MOVEL     'FTM7104'     MsgIdXAr(Idx)                                CFT120
     C                   GOTO      EXCDRO                                                     CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   ENDIF
      *
      ** A/C Currency must be base currency
      **    if Charges to the DR Of Currency is not used                                      CFT120
      *
     C                   IF        DDCDRC = *BLANKS AND CFT120 = 'Y'                          CFT120
     C                             OR CFT120 = 'N'                                            CFT120
     C     CCY           IFNE      BJCYCD
     C                   MOVEL     'N'           OKCDRO
     C                   MOVEL     'N'           OKCDBR
     C                   ADD       1             IDx
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)
     C**********         MOVEL     DDCDRO        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDRO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDCDRO)                   MD000091
     C                   MOVEL     'FTM2061'     MsgIDxAr(IDx)
     C                   GOTO      EXCDRO
     C                   ENDIF
     C                   ENDIF                                                                CFT120
      *
     C                   ENDIF
      *
      ** Validate for G/L Account No.
      ** If 12 digits when combined with base currency must exist
      ** on PF/ACCNTAB
      *
     C*****WY            IFEQ      13                                                         CGL029
     C     WY            IFEQ      19                                                         CGL029
     C*****DDCDBR        ORNE      *BLANKS                                                    247375
     C     DDCDBR        ANDNE     *BLANKS                                                    247375
      *
     C**********         MOVEL     DDCDRO        KACNUM            6 0                        CSD027
     C                   MOVEL     DDCDRO        KACNUM            6                          CSD027
     C                   MOVEL     DDCDRO        WWCDCN            6                          CFT145
     C**********         MOVE      DDCDRO        ACCS              6                          CGL029
     C**********         MOVEL     ACCS          KACCD             4 0                        CGL029
     C                   MOVE      DDCDRO        ACCS                                         CGL029
     C                   MOVEL     ACCS          KACCD                                        CGL029
     C                   MOVE      ACCS          KACSQ             2 0
      *                                                                                       CFT120
     C                   IF        DDCDRC  =  *BLANKS AND CFT120 = 'Y'                        CFT120
     C                             OR CFT120 = 'N'                                            CFT120
     C                   EVAL      KACYCD = BJCYCD                                            CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      KACYCD  =  DDCDRC                                          CFT120
     C                   ENDIF                                                                CFT120
      *
      ** If multibranched use screen branch else use branch passed
      *
     C     BGMBIN        IFEQ      'Y'
     C                   MOVEL     DDCDBR        KBRCA             3
     C                   ELSE
     C                   MOVEL     BJSBRC        KBRCA
     C                   ENDIF
      *
     C     KAckey        KLIST
     C                   KFLD                    KACNUM
     C**********         KFLD                    BJCYCD                                       CFT120
     C                   KFLD                    KACYCD                                       CFT120
     C                   KFLD                    KACCD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
     C     *LIKE         DEFINE    BJCYCD        KACYCD                                       CFT120
      *
     C     KAckey        CHAIN     ACCNTABF                           90
      *
     C     *IN90         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   MOVEL     'N'           OKCDRO
     C                   MOVEL     'N'           OKCDBR
     C                   IF        DDCDRC <> *BLANKS AND CFT120 = 'Y'                         CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             IDx
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)
     C*****DDCDRO        CAT(P)    DDCDBR        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDRO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDCDRO)                   MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDBR))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = %TRIM(MsgDtaXAr(IDx))                   MD000091
     C                                            + LenStr +%TRIM(DDCDBR)                   MD000091
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVEL     'FTM7103'     MsgIDxAr(IDx)                                CFT120
     C                   ELSE                                                                 CFT120
     C                   MOVEL     'FTM2062'     MsgIDxAr(IDx)
     C                   ENDIF                                                                CFT120
      *
      ** Highlight branch if entered
      *
     C     DDCDBR        IFNE      *BLANK
     C                   MOVEL     'N'           OKCDBR
     C                   ENDIF
      *
     C                   GOTO      EXCDRO
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       247375
      ** If 'Charges to the Debit of A/c' is Retail or Nostro and                             247375
      ** 'Charges Branch' is not blank, issue error message                                   247375
      *                                                                                       247375
     C                   IF        WY = 3 and DDCDBR <> *BLANKS                               247375
     C                   MOVEL     'N'           OKCDRO                                       247375
     C                   MOVEL     'N'           OKCDBR                                       247375
     C                   ADD       1             IDx                                          247375
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)                               247375
     C**********         MOVEL     DDCDRO        MsgDtaXAr(IDx)                      247375 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDRO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDCDRO)                   MD000091
     C                   MOVEL     'FTM2629'     MsgIDxAr(IDx)                                247375
     C                   GOTO      EXCDRO                                                     247375
     C                   ENDIF                                                                247375
      *                                                                                       247375
     C                   IF        WY = 11 and DDCDBR <> *BLANKS                              247375
     C                   MOVEL     'N'           OKCDRO                                       247375
     C                   MOVEL     'N'           OKCDBR                                       247375
     C                   ADD       1             IDx                                          247375
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)                               247375
     C**********         MOVEL     DDCDRO        MsgDtaXAr(IDx)                      247375 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDRO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDCDRO)                   MD000091
     C                   MOVEL     'FTM2630'     MsgIDxAr(IDx)                                247375
     C                   GOTO      EXCDRO                                                     247375
     C                   ENDIF                                                                247375
      *
      ** If 'Charges To The Debit Of is entered then
      ** check if date is in the future and if the account is
      ** closing today
      *
     C     IPADDC        IFEQ      'A'
     C                   Z-ADD     IPSLDT        WDate             5 0
     C                   ELSE
     C                   Z-ADD     IPPVDT        WDate
     C                   ENDIF
      *
     C     WDate         IFGT      BJRDNB
     C     ACST          ANDEQ     'C'
     C                   MOVEL     'N'           OKCDRO
     C                   MOVEL     'N'           OKCDBR
     C                   IF        DDCDRC <> *BLANKS AND CFT120 = 'Y'                         CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             IDx
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)
     C**********         MOVEL     DDCDRO        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDRO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDCDRO)                   MD000091
     C                   MOVEL     'FTM2063'     MsgIDxAr(IDx)
     C                   ENDIF
      *
      ** Check not past backvalue period
      *
     C     WDate         IFLT      BJBVPD
     C                   MOVEL     'N'           OKCDRO
     C                   MOVEL     'N'           OKCDBR
     C                   IF        DDCDRC <> *BLANKS AND CFT120 = 'Y'                         CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             IDx
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)
     C**********         MOVEL     DDCDRO        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDRO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDCDRO)                   MD000091
     C                   MOVEL     'FTM2064'     MsgIDxAr(IDx)
     C                   ENDIF
      *
      ** For Retail accounts only, check that the
      ** earlier of the two value dates is not before the Backvalue
      ** Limit Date nor before the account was opened
      *
     C     ATYP          IFEQ      'R'
      *
     C     WDate         IFLT      DACO
     C                   MOVEL     'N'           OKCDRO
     C                   MOVEL     'N'           OKCDBR
     C                   IF        DDCDRC <> *BLANKS AND CFT120 = 'Y'                         CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             IDx
     C                   MOVEL     'DDCDRO'      FldNamXAR(IDx)
     C**********         MOVEL     DDCDRO        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCDRO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDCDRO)                   MD000091
     C                   MOVEL     'FTM2065'     MsgIDxAr(IDx)
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       240689
      ** Check Status of Account                                                              240689
      *                                                                                       240689
     C     DDCDRO        IFNE      *BLANKS                                                    240689
     C     OKCDRO        ANDNE     'N'                                                        240689
      *                                                                                       240689
     C                   MOVE      RETB          WRETB                                        240689
      *                                                                                       240689
      ** Blocked Debit                                                                        240689
      *                                                                                       240689
     C                   EVAL      CHACDrBlck = ' '                                         MD047884
     C                   TESTB     '2'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   EVAL      CHACDrBlck = 'Y'                                         MD047884
     C/COPY WNCPYSRC,FTH00524
     C**********         MOVE      'N'           OKCDRO                              240689 MD047884
     C**********         IF        DDCDRC <> *BLANKS AND CFT120 = 'Y'                CFT120 MD047884
     C**********         MOVE      'N'           OKCdrc                              CFT120 MD047884
     C**********         ENDIF                                                       CFT120 MD047884
     C**********         ADD       1             Idx                                 240689 MD047884
     C**********         MOVEL     'DDCDRO'      FldNamXAr(Idx)                      240689 MD047884
     C**********         MOVEL     'FTM0014'     MsgIdXAr(Idx)                       240689 MD047884
     C/COPY WNCPYSRC,FTH00525
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bankrupt/Liquidated                                                                  240689
      *                                                                                       240689
     C                   TESTB     '6'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   MOVE      'N'           OKCDRO                                       240689
     C                   IF        DDCDRC <> *Blanks AND CFT120 = 'Y'                         CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             Idx                                          240689
     C                   MOVEL     'DDCDRO'      FldNamXAr(Idx)                               240689
     C                   MOVEL     'FTM0015'     MsgIdXAr(Idx)                                240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bad Debt                                                                             240689
      *                                                                                       240689
     C                   TESTB     '7'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   MOVE      'N'           OKCDRO                                       240689
     C                   IF        DDCDRC <> *Blanks AND CFT120 = 'Y'                         CFT120
     C                   MOVE      'N'           OKCdrc                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ADD       1             Idx                                          240689
     C                   MOVEL     'DDCDRO'      FldNamXAr(Idx)                               240689
     C                   MOVEL     'FTM0016'     MsgIdXAr(Idx)                                240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Inactive                                                                             240689
      *                                                                                       240689
     C                   TESTB     '4'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKCDRO                                       240689
     C     OKCDRO        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKCDRO                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'DDCDRO'      WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0017'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Referred Debit                                                                       240689
      *                                                                                       240689
     C                   TESTB     '0'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKCDRO                                       240689
     C     OKCDRO        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKCDRO                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'DDCDRO'      WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0018'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
     C                   ENDIF                                                                240689
      *                                                                                       CFT145
      ** Additional validation CDRO                                                           CFT145
      *                                                                                       CFT145
     C                   IF        OKCdro = 'Y' AND                                           CFT145
     C                             DDCDRO <> *blanks                                          CFT145
      *                                                                                       CFT145
     C                   SELECT                                                               CFT145
     C                   WHEN      IPACBT =  'R'                                              CFT145
     C                   MOVEL     IPACBK        WReNo                                        CFT145
     C     WReNo         CHAIN     ACNUMA                                                     CFT145
     C                   IF        %Found(ACNUMA)                                             CFT145
     C                   MOVEL     CNUM          WWODCN            6                          CFT145
     C                   ENDIF                                                                CFT145
      *                                                                                       CFT145
     C                   WHEN      IPACBT =  'P'                                              CFT145
     C                   MOVEL     IPACBK        WWODCN            6                          CFT145
      *                                                                                       CFT145
     C                   WHEN      IPACBT =  'N'                                              CFT145
     C                   MOVEL     IPACBK        WNosN             2                          CFT145
     C                   EVAL      PCYCD   =  IPPCCY                                          CFT145
      *                                                                                       CFT145
     C                   CALLB     'AONOSTR0'                                                 CFT145
     C                   PARM      *BLANKS       PRtcd             7                          CFT145
     C                   PARM      '*KEY   '     POptn             7                          CFT145
     C                   PARM      *BLANKS       PCUST             6                          CFT145
     C                   PARM                    PCYCD             3                          CFT145
     C                   PARM      *BLANKS       PACCN                                        CFT145
     C                   PARM      *BLANKS       PACSN             2                          CFT145
     C                   PARM      WNosN         PNONB             2                          CFT145
     C                   PARM      *BLANKS       PBRCD             3                          CFT145
     C                   PARM      *BLANKS       PCSSN            10                          CFT145
     C                   PARM      *BLANKS       PPNOI             1                          CFT145
     C     SDNOST        PARM      SDNOST        DSFDY                                        CFT145
      *                                                                                       CFT145
      ** If found                                                                             CFT145
      *                                                                                       CFT145
     C     PRtcd         IFEQ      *BLANKS                                                    CFT145
     C                   MOVEL     A7CUST        WWODCN            6                          CFT145
     C                   ENDIF                                                                CFT145
      *                                                                                       CFT145
     C                   WHEN      IPBNCT =  'R'                                              CFT145
     C                   MOVEL     IPBNC1        WReNo                                        CFT145
     C     WReNo         CHAIN     ACNUMA                                                     CFT145
     C                   IF        %Found(ACNUMA)                                             CFT145
     C                   MOVEL     CNUM          WWODCN            6                          CFT145
     C                   ENDIF                                                                CFT145
      *                                                                                       CFT145
     C                   WHEN      IPBNCT =  'P'                                              CFT145
     C                   MOVEL     IPBNC1        WWODCN            6                          CFT145
      *                                                                                       CFT145
     C                   WHEN      IPBNCT =  'N'                                              CFT145
     C                   MOVEL     IPBNC1        WNosN             2                          CFT145
     C                   EVAL      PCYCD   =  IPPCCY                                          CFT145
      *                                                                                       CFT145
     C                   CALLB     'AONOSTR0'                                                 CFT145
     C                   PARM      *BLANKS       PRtcd             7                          CFT145
     C                   PARM      '*KEY   '     POptn             7                          CFT145
     C                   PARM      *BLANKS       PCUST             6                          CFT145
     C                   PARM                    PCYCD             3                          CFT145
     C                   PARM      *BLANKS       PACCN                                        CFT145
     C                   PARM      *BLANKS       PACSN             2                          CFT145
     C                   PARM      WNosN         PNONB             2                          CFT145
     C                   PARM      *BLANKS       PBRCD             3                          CFT145
     C                   PARM      *BLANKS       PCSSN            10                          CFT145
     C                   PARM      *BLANKS       PPNOI             1                          CFT145
     C     SDNOST        PARM      SDNOST        DSFDY                                        CFT145
      *                                                                                       CFT145
      ** If found                                                                             CFT145
      *                                                                                       CFT145
     C     PRtcd         IFEQ      *BLANKS                                                    CFT145
     C                   MOVEL     A7CUST        WWODCN            6                          CFT145
     C                   ENDIF                                                                CFT145
      *                                                                                       CFT145
     C                   ENDSL                                                                CFT145
      *                                                                                       CFT145
      ** Warning - if Ordering Bank or Customer is not customer of CDRO account               CFT145
      *                                                                                       CFT145
     C                   IF        WWCDCN <> WWODCN                                           CFT145
     C                   MOVE      'W'           OKCdro                                       CFT145
     C                   ADD       1             WIx                                          CFT145
     C                   MOVEL     'DDCDRO'      WFldNmXAr(WIx)                               CFT145
     C                   MOVEL     'FTX0024'     WMsgIdXAr(WIx)                               CFT145
     C                   ENDIF                                                                CFT145
     C                   ENDIF                                                                CFT145
      *
     C     EXCDRO        ENDSR
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
      ***Incoming*Payments*Lvl*2*Scrn*1/2*details*from*incoming*transaction     CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP3ScnFmt                    CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP5ScnFmt                    CFT014
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
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN            1
      *
      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN            1
      *
      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDxAr
     C                   PARM                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtXAr                                    240689
      *
      ***Incoming*Payments*Lvl*2*Scrn*1*error*indicators***************         CFT014
     C*****              PARM                    FTEIPY2                        CFT014
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT014
     C                   PARM                    FTEIPY4                        CFT014
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
     C                   PARM                    CHACDrBlck                                 MD047884
     C/COPY WNCPYSRC,FTH00526
      *                                                                                       CFT120
      ** Access SAR details file to determine if CFT120 enhancement is                        CFT120
      ** switched on.                                                                         CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      '*BLANKS'     @RTCD                                        CFT120
     C                   PARM      '*VERIFY'     @OPTN                                        CFT120
     C                   PARM      'CFT120'      @SARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')                CFT120
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT120
     C                   Z-ADD     1             DBASE                                        CFT120
     C                   MOVEL     'CFT120'      DBKEY                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   MOVEL     'Y'           CFT120                                       CFT120
     C                   ELSE                                                                 CFT120
     C                   MOVEL     'N'           CFT120                                       CFT120
     C                   ENDIF                                                                CFT120
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
