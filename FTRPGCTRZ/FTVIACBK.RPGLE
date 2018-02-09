     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP account with bank')               *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIACBK - Validate Account with Bank                        *
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
      *  Prev Amend No. 261791             Date 19Aug14               *
      *                 MD000091           Date 07May13               *
      *                 CFT120             Date 28Sep12               *
      *                 AR851079           Date 22Oct12               *
      *                 AR750736           Date 22Oct12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247142             Date 31May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 240689             Date 13Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG4581            Date 20Oct04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  261791 - Issue an error message to indicate that the entered *
      *           account is a closed account.                        *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  AR851079 - Blocked debit account is debited in a FT          *
      *             transaction sent via API. Modified the validation *
      *             in AR750737 so that transactions sent via API will*
      *             be properly validated. (Child: AR851080)          *
      *  AR750736 - Blocked debit account is debited in a FT          *
      *             transaction. An error message will be displayed   *
      *             when a blocked debit account is about to be       *
      *             debited in a FT transaction. (Child: AR750737)    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning.                  *
      *           Apply fixs 232151 and 210654. Annotated as 240689   *
      *  232151 - DBASE error when inserting an inactive account.     *
      *  210654 - Check status of account.                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  240689 - Applied fix 210654 + additional changes by 232151.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4581- Check for block debits/credits                      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
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
     D*YA3******       S              1    DIM(18)                                            CGL029
     D YA3             S              1    DIM(24)                                            CGL029
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** Externally described DS for Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      ** Externally described DS for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CGL029
      ** DS for Access Objects - long data structure                                          CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *
      ** DS for Database Error on Accounts file
     D*ACKYDS***       DS            18                                                       CGL029
     D ACKYDS          DS                                                                     CGL029
     D**KACNUM**               1      6  0                                                    CSD027
     D  KACNUM                 1      6                                                       CSD027
     D  KACCCY                 7      9
     D  KACCD                 10     19  0                                                    CGL029
     D  KACSQ                 20     21  0                                                    CGL029
     D  KBRCA                 22     24                                                       CGL029
     D**KACCD***              10     13  0                                                    CGL029
     D**KACSQ***              14     15  0                                                    CGL029
     D**KBRCA***              16     18                                                       CGL029
      *
      ** Define full account to be passed for FT IMM update
     D*IMACNT***       DS            18                                                       CGL029
     D IMACNT          DS                                                                     CGL029
     D**IMCNUM**               1      6  0                                                    CSD027
     D  IMCNUM                 1      6                                                       CSD027
     D  IMCCY                  7      9
     D  IMACOD                10     19  0                                                    CGL029
     D  IMACSQ                20     21  0                                                    CGL029
     D  IMBRCA                22     24                                                       CGL029
     D**IMACOD**              10     13  0                                                    CGL029
     D**IMACSQ**              14     15  0                                                    CGL029
     D**IMBRCA**              16     18                                                       CGL029
      *
      ** Fields needed in setting default pay value date
     D PPYFLDS         DS
     D  CNUMPY                 1      6
     D  CCYPY                  7      9
     D  ACODPY                10     19                                                       CGL029
     D  ACSQPY                20     21                                                       CGL029
     D  BRCAPY                22     24                                                       CGL029
     D**ACODPY**              10     12                                                       CGL029
     D**ACSQPY**              13     15                                                       CGL029
     D**BRCAPY**              16     18                                                       CGL029
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
                                                                                              CGL029
      ** Fields redefined by CGL029.                                                          CGL029
     D PACBDS          S             24A                                                      CGL029
     D PACCN           S             10A                                                      CGL029
     D WA4             S             10A                                                      CGL029
     D WAcBnk          S             21A                                                      CGL029
     D ACODSV          S             10P 0                                                    CGL029
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
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
     C                   EVAL      Idx = 0
     C**********         MOVEL     *Blanks       WAcBnk           15                          CGL029
     C                   MOVE      *BLANKS       WAcBnk                                       CGL029
     C                   Eval      WFldNmXAr = *Blanks                                        240689
     C                   Eval      WMsgIDXAr  = *Blanks                                       240689
     C                   Eval      WMsgDtXAr = *Blanks                                        240689
     C                   Eval      WIx = 0                                                    240689
     C                   BITOFF    '01234567'    WRETB             1                          240689
      *
      ** Initialise output parameters.
      *
     C                   MOVE      *Blank        PAtyp4            1
     C                   MOVE      *Blank        PAcSt4            1
     C                   Z-ADD     *Zeros        PDAcO4            5 0
     C**********         MOVEL     *Blanks       PACBDS           18                          CGL029
     C                   MOVE      *BLANKS       PACBDS                                       CGL029
      *
      ** Initialise variables for update of Valid File fields.
      *
     C                   MOVE      *Blank        WACBT             1
      *
      ** Validate Account with Bank
      *
     C                   EXSR      SRValAcBnk
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKACBK = 'N' or
     C                             OKACBB = 'N'
      *
     C                   EVAL      RetCodeIn = 'ERROR'
      *
     C                   ENDIF
      *
     C                   IF        OKACBK <> 'N'
     C                   MOVE      DDACBK        IPACBK
     C                   MOVE      WACBT         IPACBT
     C                   ENDIF
      *
     C                   IF        OKACBB <> 'N'
     C                   MOVE      DDACBB        IPACBB
     C                   IF        BGMBIN <> 'Y' and
     C                             BJSBRC <> *BLANKS and
     C                             WACBT = 'P'
     C                   MOVE      BJSBRC        IPACBB
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALACBNK - Account with Bank Validation                    *
      *                                                               *
      *****************************************************************
      *
     C     SRValAcBnk    BEGSR
      *
      ** If ? found in DDACBB, call access program.
      *
     C     '?'           SCAN      DDACBB                                 18
      *
     C                   IF        *IN18 = *On and
     C                             PMode <> '*FRONT'
 
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      '?'           PBRCD             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      ** If selection is made, move value to display field.
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     A8BRCD        DDACBB
     C                   ELSE
     C                   MOVE      *BLANKS       DDACBB
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     DDACBK        WAcBnk
     C                   MOVE      DDACBB        WAcBnk
      *
      ** Check that DDACBK field does not contain '?'- error if it does.
      *
     C                   MOVE      '0'           *IN18
     C     '?'           SCAN      DDACBK                                 18
      *
     C                   IF        *IN18 = *On
      *
     C                   IF        PMode = '*FRONT'
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0124'     MsgIdXAr(Idx)
     C**********         MOVEL     DDACBK        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDACBK))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDACBK)                   MD000091
     C                   GOTO      ESRValAcBnk
     C                   ENDIF
      *
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0001'     MsgIdXAr(Idx)
     C                   GOTO      ESRValAcBnk
     C                   ENDIF
      *
      ** Field is mandatory if beneficiary is a Name and Address
      ** Customer number, Shortname or SWIFT Address.  Otherwise,
      ** it is optional.
      *
     C                   IF        WAcBnk = *Blanks
      *
     C                   If        IPBNCT = 'A' or
     C                             IPBNCT = 'C' or
     C                             IPBNCT = 'S'
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0002'     MsgIdXAr(Idx)
     C                   EndIf
      *
     C                   GOTO      GA400
     C                   ENDIF
      *
      ** There must be no embedded spaces in the field.
      *
     C                   MOVEL     *Blanks       YA3
     C                   MOVEA     WAcBnk        YA3(1)
     C                   MOVEA     '00'          *In(88)
     C                   Z-ADD     1             I1                3 0
      *
     C                   DOU       *IN89 = *On or
     C                             I1 > 21                                                    CGL029
     C**********                   I1 > 15                                                    CGL029
     C                   If        YA3(I1) = *Blanks
     C                   MOVE      *On           *In88
     C                   Else
     C                   If        *IN88 = *On
     C                   MOVE      *On           *In89
     C                   EndIf
     C                   EndIf
     C                   ADD       1             I1
     C                   ENDDO
      *
     C                   IF        *IN89 = *On
      *
     C*****              If        OKRCCO <> 'Y' and                            CFT014
     C                   If        OKRCO1 <> 'Y' and                            CFT014
     C                             POkRcCo <> 'Y'
      *
      ** The retail account must be in settle currency.
      *
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0003'     MsgIdXAr(Idx)
     C                   MOVE      'Y'           POkRcCo
     C                   EndIf
      *
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0004'     MsgIdXAr(Idx)
     C                   GOTO      GA400
     C                   ENDIF
      *
      ** Determine if the pay currency entered was valid.
      ** (If no pay currency entered, this depends on validity of
      ** settle currency entered). Indicator 87 on if invalid.
      *
     C                   MOVE      '0'           *IN87
      *
     C                   IF        DDPCCY <> *Blanks
      *
      ** Error in payment currency
      *
     C                   If        OKPCCY = 'N'
     C                   MOVE      *On           *IN87
     C                   EndIf
      *
     C                   ELSE
      *
      ** Error in settle currency
      *
     C                   If        DDSMCY = 'N'
     C                   MOVE      *On           *IN87
     C                   EndIf
      *
     C                   ENDIF
      *
      ** Check if less than 2 characters were entered - invalid
      *
     C                   IF        YA3(2) = *Blanks
      *
     C*****              If        OKRCCO <> 'Y' and                            CFT014
     C                   If        OKRCO1 <> 'Y' and                            CFT014
     C                             POkRcCo <> 'Y'
      *
      ** The retail account must be in settle currency.
      *
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0003'     MsgIdXAr(Idx)
     C                   MOVE      'Y'           POkRcCo
     C                   EndIf
      *
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0004'     MsgIdXAr(Idx)
     C                   GOTO      GA400
     C                   ENDIF
      *
      ** Check if exactly 2 characters were entered; If so check that
      ** they are numeric & if ther are and the pay ccy entered was
      ** valid, validate this field as being a nostro - must be on
      ** Table file
      *
     C                   IF        YA3(3) = *Blanks
      *
     C                   MOVEA     YA3(1)        WA2               2
     C                   TESTN                   WA2                  01
      *
     C                   IF        *In01 = *Off
      *
     C*****              If        OKRCCO <> 'Y' and                            CFT014
     C                   If        OKRCO1 <> 'Y' and                            CFT014
     C                             POkRcCo <> 'Y'
      *
      ** The retail account must be in settle currency.
      *
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0003'     MsgIdXAr(Idx)
     C                   MOVE      'Y'           POkRcCo
     C                   EndIf
      *
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0004'     MsgIdXAr(Idx)
     C                   GOTO      GA400
     C                   ENDIF
      *
     C                   IF        *IN87 <> *On
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      *Blanks       PCUST             6
     C                   PARM      DDPCCY        PCYCD             3
     C**********         PARM      *Blanks       PACCN             4                          CGL029
     C                   PARM      *BLANKS       PACCN                                        CGL029
     C                   PARM      *Blanks       PACSN             2
     C                   PARM      WA2           PNONB             2
     C                   PARM      *Blanks       PBRCD             3
     C                   PARM      *Blanks       PCSSN            10
     C                   PARM      *Blanks       PPNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   IF        PRTCD <> *Blanks
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0005'     MsgIdXAr(Idx)
     C                   GOTO      GA400
     C                   ENDIF
      *
     C                   MOVE      A7ACCD        ACOD
     C                   MOVE      A7ACSN        ACSQ
     C                   MOVE      A7CUST        CNUM
     C                   MOVE      A7BRCD        BRCA
     C                   MOVEL     'N'           WACBT
      *
      ** Store fields for key to ACCNT
      *
     C**********         Z-ADD     CNUM          CNUMSV            6 0                        CSD027
     C                   MOVE      CNUM          CNUMSV            6                          CSD027
     C                   MOVEL     DDPCCY        CCYSV             3
     C**********         Z-ADD     ACOD          ACODSV            4 0                        CGL029
     C                   Z-ADD     ACOD          ACODSV                                       CGL029
     C                   Z-ADD     ACSQ          ACSQSV            2 0
     C                   MOVE      BRCA          BRCASV            3
     C                   GOTO      GA400
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if less than 10 characters were entered - invalid
      *
     C                   IF        YA3(10) = *Blanks
      *
     C*****              If        OKRCCO <> 'Y' and                            CFT014
     C                   If        OKRCO1 <> 'Y' and                            CFT014
     C                             POkRcCo <> 'Y'
      *
      ** The retail account must be in settle currency.
      *
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0003'     MsgIdXAr(Idx)
     C                   MOVE      'Y'           POkRcCo
     C                   EndIf
      *
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0004'     MsgIdXAr(Idx)
     C                   GOTO      GA400
     C                   ENDIF
      *
      ** If Retail module is present & Retail A/c Nos. are used:
      ** Chech if exactly 10 characters were entered & then if these
      ** were numeric; If so validate it as
      ** being a live Retail Account - must be in ACNUMA file;
      ** also A/c must be in pay ccy (If this was valid)
      *
     C                   IF        BGRTBN = 'Y'
      *
     C                   IF        YA3(11) = *Blanks
     C                   MOVEA     YA3(1)        WA10             10
     C                   TESTN                   WA10                 01
      *
     C                   IF        *IN01 = *Off
      *
     C*****              If        OKRCCO <> 'Y' and                            CFT014
     C                   If        OKRCO1 <> 'Y' and                            CFT014
     C                             POkRcCo <> 'Y'
      *
      ** The retail account must be in settle currency.
      *
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0003'     MsgIdXAr(Idx)
     C                   MOVE      'Y'           POkRcCo
     C                   EndIf
      *
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0004'     MsgIdXAr(Idx)
     C                   GOTO      GA400
     C                   ENDIF
      *
     C                   MOVE      WA10          ACNO
     C     ACNO          CHAIN     ACNUMA                             89
      *
     C                   IF        *In89 = *On or
     C                             RECI <> 'D'
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0006'     MsgIdXAr(Idx)
     C                   GOTO      GA400
     C                   Else                                                                BUG4581
      *                                                                                     AR750736
      ** Check for block debits on account                                                  AR750736
      *                                                                                     AR750736
     C     DDADDC        IFEQ      'D'                                                      AR851079
     C                   TESTB     '2'           RETB                     52                AR750736
     C     *IN52         IFEQ      '1'                                                      AR750736
     C                   MOVE      'N'           OKACBK                                     AR750736
     C                   ADD       1             Idx                                        AR750736
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)                             AR750736
     C                   MOVEL     'FTM7120'     MsgIdXAr(Idx)                              AR750736
     C                   ENDIF                                                              AR750736
     C                   ENDIF                                                              AR750736
      * Check for block credits on account                                                   BUG4581
     C                   TESTB     '3'           RETB                     51                 BUG4581
     C                   If        *in51 = *ON                                               BUG4581
     C                   Move      'N'           OKACBK                                      BUG4581
     C                   Add       1             Idx                                         BUG4581
     C                   Movel     'DDACBK'      FldNamXAr(Idx)                              BUG4581
     C                   Movel     'FTM0019'     MsgIdXAr(Idx)                               BUG4581
     C                   End                                                                 BUG4581
     C                   ENDIF
      *
      ** If Retail Accounts not allowed, Display error message
      *
     C                   IF        BMRANR <> 'Y'
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0007'     MsgIdXAr(Idx)
     C                   GOTO      GA400
     C                   ENDIF
      *
     C                   IF        *IN87 <> *On and
     C                             CCY <> DDPCCY
      *
     C*****              If        OKRCCO <> 'Y' and                            CFT014
     C                   If        OKRCO1 <> 'Y' and                            CFT014
     C                             POkRcCo <> 'Y'
      *
      ** The retail account must be in settle currency.
      *
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0003'     MsgIdXAr(Idx)
     C                   MOVE      'Y'           POkRcCo
     C                   EndIf
      *
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0008'     MsgIdXAr(Idx)
     C                   GOTO      GA400
     C                   ENDIF
      *
     C                   MOVEL     'R'           WACBT
     C                   GOTO      GA400
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if less than 12 characters were entered - invalid
      **                    15 characters if multi-branched
      *
     C**********         IF        YA3(12) = *Blanks and                                      CGL029
     C                   IF        YA3(18) = *BLANKS AND                                      CGL029
     C                             BGMBIN <> 'Y' or
     C**********                   YA3(15) = *Blanks and                                      CGL029
     C                             YA3(21) = *BLANKS AND                                      CGL029
     C                             BGMBIN = 'Y'
      *
     C*****              If        OKRCCO <> 'Y' and                            CFT014
     C                   If        OKRCO1 <> 'Y' and                            CFT014
     C                             POkRcCo <> 'Y'
      *
      ** The retail account must be in settle currency.
      *
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0003'     MsgIdXAr(Idx)
     C                   MOVE      'Y'           POkRcCo
     C                   EndIf
      *
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0004'     MsgIdXAr(Idx)
     C                   GOTO      GA400
     C                   ENDIF
      *
      ** 12 Characters were entered. Check if these
      ** were numeric; If so & the pay ccy entered was valid,
      ** validate this field as being a live full account - must be
      ** on ACCNT file.
      *
      *                                                                                       CSD027
      * Need to check that positions 7 to 18 of YA3 are numeric, not positions 1 to 12.       CSD027
      * Positions 7 to 18 will be the account code and account sequence number if a           CSD027
      * partial A/C number was entered.                                                       CSD027
      *                                                                                       CSD027
     C************       MOVEA     YA3(1)        WA12             12                          CSD027
     C                   MOVEA     YA3(7)        WA12             12                          CSD027
     C                   TESTN                   WA12                 01
      *
     C                   IF        *In01 = *Off
      *
     C*****              If        OKRCCO <> 'Y' and                            CFT014
     C                   If        OKRCO1 <> 'Y' and                            CFT014
     C                             POkRcCo <> 'Y'
      *
      ** The retail account must be in settle currency.
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0003'     MsgIdXAr(Idx)
     C                   MOVE      'Y'           POkRcCo
     C                   EndIf
      *
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0004'     MsgIdXAr(Idx)
     C                   GOTO      GA400
     C                   ENDIF
      *
     C                   IF        *IN87 <> *On
     C                   MOVEA     YA3(1)        WA6               6
     C**********         MOVEA     YA3(7)        WA4               4                          CGL029
     C**********         MOVEA     YA3(11)       WA2                                          CGL029
     C                   MOVEA     YA3(7)        WA4                                          CGL029
     C                   MOVEA     YA3(17)       WA2                                          CGL029
     C                   MOVE      WA6           KACNUM
     C                   MOVEL     DDPCCY        KACCCY
     C                   MOVE      WA4           KACCD
     C                   MOVE      WA2           KACSQ
      *
     C                   If        BGMBIN <> 'Y'
     C                   MOVE      BJSBRC        KBRCA
     C                   Else
     C                   MOVE      DDACBB        KBRCA
     C                   EndIf
      *
      ** Read Account Detail
     C     KAcKey        CHAIN     ACCNT                              89
      *
     C                   If        *In89 = *On or
     C                             RECI <> 'D'
     C                   MOVE      'N'           OKACBK
     C                   MOVE      'N'           OKACBB
     C                   ADD       1             Idx
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0009'     MsgIdXAr(Idx)
     C                   GOTO      GA400
     C                   Else
      *                                                                                     AR750736
      ** Check for block debits on account                                                  AR750736
      *                                                                                     AR750736
     C     DDADDC        IFEQ      'D'                                                      AR851079
     C                   TESTB     '2'           RETB                     52                AR750736
     C     *IN52         IFEQ      '1'                                                      AR750736
     C                   MOVE      'N'           OKACBK                                     AR750736
     C                   ADD       1             Idx                                        AR750736
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)                             AR750736
     C                   MOVEL     'FTM7120'     MsgIdXAr(Idx)                              AR750736
     C                   ENDIF                                                              AR750736
     C                   ENDIF                                                              AR750736
      * Check for block credits on account                                                   BUG4581
     C                   TESTB     '3'           RETB                     51                 BUG4581
     C                   If        *in51 = *ON                                               BUG4581
     C                   Move      'N'           OKACBK                                      BUG4581
     C                   Add       1             Idx                                         BUG4581
     C                   Movel     'DDACBK'      FldNamXAr(Idx)                              BUG4581
     C                   Movel     'FTM0019'     MsgIdXAr(Idx)                               BUG4581
     C                   End                                                                 BUG4581
     C                   MOVEL     'P'           WACBT
     C                   EndIf
      *
     C                   ENDIF
      *
      *          *****     ***
     C     GA400         TAG
      *          *****     ***
      *
      ** If a valid account has been entered store the account type and
      ** the date the account was opened.
      *
     C                   IF        OKACBK = 'Y'
     C                   IF        WACBT = 'N' or
     C                             WACBT = 'R' or
     C                             WACBT = 'P'
      *
      ** For a Nostro first access the ACCNT record.
      *
     C                   If        WACBT = 'N'
     C                   EXSR      SRAccChn
     C                   EndIf
      *                                                                                     AR750736
      ** Check for block debits on account                                                  AR750736
      *                                                                                     AR750736
     C     DDADDC        IFEQ      'D'                                                      AR851079
     C                   TESTB     '2'           RETB                     52                AR750736
     C     *IN52         IFEQ      '1'                                                      AR750736
     C                   MOVE      'N'           OKACBK                                     AR750736
     C                   ADD       1             Idx                                        AR750736
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)                             AR750736
     C                   MOVEL     'FTM7120'     MsgIdXAr(Idx)                              AR750736
     C                   ENDIF                                                              AR750736
     C                   ENDIF                                                              AR750736
      *
      * Check for block credits on account                                                   BUG4581
     C                   TESTB     '3'           RETB                     51                 BUG4581
     C                   If        *in51 = *ON                                               BUG4581
     C                   Move      'N'           OKACBK                                      BUG4581
     C                   Add       1             Idx                                         BUG4581
     C                   Movel     'DDACBK'      FldNamXAr(Idx)                              BUG4581
     C                   Movel     'FTM0019'     MsgIdXAr(Idx)                               BUG4581
     C                   End                                                                 BUG4581
      *                                                                                      BUG4581
     C                   MOVE      ATYP          PAtyp4
     C                   MOVE      ACST          PAcSt4
     C                   Z-ADD     DACO          PDAcO4
      *
      ** Store full account details for FT Transaction Status File
      ** record update.
      *
     C**********         Z-ADD     CNUM          IMCNUM                                       CSD027
     C                   EVAL      IMCNUM = CNUM                                              CSD027
     C                   MOVE      CCY           IMCCY
     C                   Z-ADD     ACOD          IMACOD
     C                   Z-ADD     ACSQ          IMACSQ
     C                   MOVE      BRCA          IMBRCA
     C                   MOVEL     IMACNT        PACBDS
      *
      ** Also save fields needed to set default pay value date
      *
     C                   MOVEL     CNUM          CNUMPY
     C                   MOVEL     CCY           CCYPY
     C                   MOVEL     ACOD          ACODPY
     C                   MOVEL     ACSQ          ACSQPY
     C                   MOVEL     BRCA          BRCAPY
      *                                                                                       240689
      ** Check Status of Account                                                              240689
      *                                                                                       240689
     C                   MOVE      RETB          WRETB                                        240689
      *                                                                                       240689
      ** Bankrupt/Liquidated                                                                  240689
      *                                                                                       240689
     C                   TESTB     '6'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   MOVE      'N'           OKACBK                                       240689
     C                   MOVE      'N'           OKACBB                                       240689
     C                   ADD       1             Idx                                          240689
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)                               240689
     C                   MOVEL     'FTM0015'     MsgIdXAr(Idx)                                240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bad Debt                                                                             240689
      *                                                                                       240689
     C                   TESTB     '7'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   MOVE      'N'           OKACBK                                       240689
     C                   MOVE      'N'           OKACBB                                       240689
     C                   ADD       1             Idx                                          240689
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)                               240689
     C                   MOVEL     'FTM0016'     MsgIdXAr(Idx)                                240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Inactive                                                                             240689
      *                                                                                       240689
     C                   TESTB     '4'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C*****              MOVE      'N'           OKACBK                                       240689
     C*****              MOVE      'N'           OKACBB                                       240689
     C     OKACBK        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKACBK                                       240689
     C                   ENDIF                                                                240689
     C     OKACBB        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKACBB                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'DDACBK'      WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0017'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Referred Credit                                                                      240689
      *                                                                                       240689
     C                   TESTB     '1'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKACBK                                       240689
     C**********         MOVE      'N'           OKACBB                                       240689
     C     OKACBK        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKACBK                                       240689
     C                   ENDIF                                                                240689
     C     OKACBB        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKACBB                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'DDACBK'      WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0020'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *
     C                   ENDIF
     C                   ENDIF
      *
     C*****              If        OKRCCO <> 'Y' and                            CFT014
     C                   If        OKRCO1 <> 'Y' and                            CFT014
     C                             POkRcCo <> 'Y'
      *
      ** The retail account must be in settle currency.
      *
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0003'     MsgIdXAr(Idx)
     C                   MOVE      'Y'           POkRcCo
     C                   EndIf
      *
     C     ESRValAcBnk   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACCCHN - Access the ACCNT record for a nostro              *
      *                                                               *
      *****************************************************************
      *
     C     SRAccChn      BEGSR
      *
     C**********         Z-ADD     CNumSv        KACNUM                                       CSD027
     C                   EVAL      KACNUM = CNumSv                                            CSD027
     C                   MOVE      CcySv         KACCCY
     C                   Z-ADD     ACodSv        KACCD
     C                   Z-ADD     AcSqSv        KACSQ
     C                   MOVE      BrCASv        KBRCA
      *
      ** Read Account Detail
      *
     C     KAcKey        CHAIN     ACCNT                              89
      *
     C**********         IF        *In89 = *On or                                             261791
     C**********                   RECI <> 'D'                                                261791
     C                   IF        *In89 = *On                                                261791
     C                   MOVE      'FTVIACBNK'   DBPGM
     C                   MOVE      'ACCNT'       DBFILE
     C                   MOVEL     '47'          DBASE
     C                   MOVEL     ACKYDS        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       261791
     C                   IF        RECI <> 'D'                                                261791
     C                   MOVE      'N'           OKACBK                                       261791
     C                   ADD       1             Idx                                          261791
     C                   MOVEL     'DDACBK'      FldNamXAr(Idx)                               261791
     C                   MOVEL     'MMA0377'     MsgIdXAr(Idx)                                261791
     C                   ENDIF                                                                261791
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
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Work flag for error '041'
     C                   PARM                    POkRcCo           1
      *
      ** STANDING DATA
      ** =============
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
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtXAr                                    240689
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** A/c with Bank's Account Type
     C                   PARM                    PAtyp4
      *
      ** A/c with Bank's Account Status
     C                   PARM                    PAcSt4
      *
      ** A/c with Bank's Date Account Opened
     C                   PARM                    PDAcO4
      *
      ** Account with Bank's full account
     C                   PARM                    PACBDS
      *
      ** Account needed to set Payment Value Date
     C                   PARM                    PPYFLDS
      *
     C     KAcKey        KLIST
     C**********         KFLD                    KACNUM            6 0                        CSD027
     C                   KFLD                    KACNUM            6                          CSD027
     C                   KFLD                    KACCCY            3
     C**********         KFLD                    KACCD             4 0                        CGL029
     C                   KFLD                    KACCD                                        CGL029
     C                   KFLD                    KACSQ             2 0
     C                   KFLD                    KBRCA             3
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
