     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP receivers correspondent')         *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIRCCO - Validate Receiver's Correspondent                 *
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
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD034521A          Date 14Sep15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD000091           Date 06May13               *
      *                 AR1083047          Date 30Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 AR572681           Date 11Oct12               *
      *                 262711             Date 02Oct12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247142             Date 31May07               *
      *                 BUG13201           Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 240689             Date 13Jul06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4581            Date 20Oct04               *
      *                 CLE025             Date 20Oct03               *
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
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD034521A - Error handling of Blocked account is not the     *
      *              same across the modules                          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1083047 - Response with '&' causes exception error in      *
      *              Benchmarking                                     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  AR572681 - IBAN validation is incorrect.  Fix is to properly *
      *             validation IBAN format                            *
      *  262711 - Issue an error message when a closed account is     *
      *           used in the receiver's correspondent field instead  *
      *           of ending in database error.                        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning.                  *
      *           Apply fixes 232151 and 210654.                      *
      *  232151 - DBASE error when inserting an inactive account.     *
      *  210654 - Check status of account.                            *
      *  BUG13201 - Error on Field Receiver's Correspondent           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240689 - Applied fix 210654 + additional changes by 232151.  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4581- Check for block debits/credits                      *
      *  CLE025 - Credit Lines (Recompile)                            *
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
      ** Chain Full Account
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      *
      ** Chain Retail Account
     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMABF)
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
      *                                                                         CFT014
      ** The following /COPY line includes definitions of constants             CFT014
      ** such as Digits, ISO characters, Alpha, and Alpha-Numeric               CFT014
      ** combination.                                                           CFT014
      *                                                                         CFT014
      /COPY FTCPYSRC,SFTVALCSLE                                                 CFT014
      *                                                                         CFT014
      /COPY FTCPYSRC,SFTADDRILE                                                 CFT014
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
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn file 2 details from                       CFT014
      ** Incoming transaction - screen format                                   CFT014
     D NwIP1AScnFmt  E DS                  EXTNAME(FTIPY1APD)                   CFT014
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** External DS for Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *                                                                         CFT014
      ** External DS for Customer details                                       CFT014
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CFT014
      *                                                                         CFT014
      ** External DS for Counterparty nostro details                            CFT014
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                    CFT014
      *                                                                         CFT014
      ** External DS for BIC Directory details                                  CFT014
     D MEBICD        E DS                  EXTNAME(MEBICDPD)                    CFT014
      *
     D/COPY WNCPYSRC,FTH00527
      ** DS for access programs - Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                         CFT014
      ** DS for access programs - Long data structure                           CFT014
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CFT014
      *                                                                         CFT014
      ** DS for accounts details                                                CFT014
     D PIBNACC       E DS                  EXTNAME(ACCNTAB) PREFIX(IBN)         CFT014
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Data Structure for Database Error on Account file
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
      *                                                                         CFT014
      ** Define receiver's correspondent data structure                         CFT014
     D WRcvCorDS       DS           175                                         CFT014
     D  WRCO1                  1     35                                         CFT014
     D  WRCO2                 36     70                                         CFT014
     D  WRCO3                 71    105                                         CFT014
     D  WRCO4                106    140                                         CFT014
     D  WRCO5                141    175                                         CFT014
     D  WRCO001001             1      1                                         CFT014
     D  WRCO001006             1      6                                         CFT014
     D  WRCO001002             1      2                                         CFT014
     D  WRCO001003             1      3                                         CFT014
     D  WRCO004005             4      5                                         CFT014
     D  WRCO002002             2      2                                         CFT014
     D  WRCO005005             5      5                                         CFT014
     D  WRCO006006             6      6                                         CFT014
     D  WRCO007009             7      9                                         CFT014
     D  WRCO001010             1     10                                         CFT014
     D  WRCO010013            10     19                                                       CGL029
     D  WRCO014015            20     21                                                       CGL029
     D  WRCO016018            22     24                                                       CGL029
     D**WRCO010013            10     13                                                CFT014 CGL029
     D**WRCO014015            14     15                                                CFT014 CGL029
     D**WRCO016018            16     18                                                CFT014 CGL029
     D  WRCO001011             1     11                                         CFT014
     D  WRCO012015            12     15                                         CFT014
     D  WRCO012018            12     18                                         CFT014
     D  WRCO003175             3    175                                         CFT014
     D  WRCO006175             6    175                                         CFT014
     D  WRCO007175             7    175                                         CFT014
     D  WRCO010175            10    175                                         CFT014
     D  WRCO011175            11    175                                         CFT014
     D  WRCO016175            22    175                                                       CGL029
     D  WRCO019175            25    175                                                       CGL029
     D**WRCO016175            16    175                                                CFT014 CGL029
     D**WRCO019175            19    175                                                CFT014 CGL029
      *                                                                         CFT014
      ** Used for SWIFT validation                                              CFT014
     D ADLINE          S              1                                         CFT014
     D ADSLON          S              1                                         CFT014
     D ##CSID          S              1                                         CFT014
     D CLSWTK          S             12                                         CFT014
      *
     D YA3             S              1    DIM(18)
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *                                                                                       240689
     D WIx             S              3P 0                                                    240689
      *                                                                                       240689
      **Index for arrays of warning messagge ids etc                                          240689
                                                                                              CGL029
      ** Fields redefined by CGL029                                                           CGL029
     D PRCCDS          S             24A                                                      CGL029
     D ACodSv          S             10P 0                                                    CGL029
     D PAccN           S             10A                                                      CGL029
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
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
      ** Initialise output parameters.
     C                   MOVE      *Blank        PATyp2            1
     C                   Z-ADD     *Zeros        PDAcO2            5 0
     C                   MOVE      *Blank        PAcSt2            1
     C**********         MOVEL     *Blanks       PRCCDS           18                          CGL029
     C                   MOVE      *BLANKS       PRCCDS                                       CGL029
     C                   MOVE      'Y'           POkRcCo           1
     C                   MOVE      *Blanks       WRCRT             1
      *
      ** Initialise work variables.
     C                   MOVE      *Zeros        I1                3 0
     C                   EVAL      Idx = 0
     C**********         MOVE      'N'           WIBNERR           1                 CFT014 AR572681
     C                   EVAL      WRCO1 = DDRCO1                               CFT014
     C                   EVAL      WRCO2 = DDRCO2                               CFT014
     C                   EVAL      WRCO3 = DDRCO3                               CFT014
     C                   EVAL      WRCO4 = DDRCO4                               CFT014
     C                   EVAL      WRCO5 = DDRCO5                               CFT014
     C                   Eval      WFldNmXAr = *Blanks                                        240689
     C                   Eval      WMsgIDXAr  = *Blanks                                       240689
     C                   Eval      WMsgDtXAr = *Blanks                                        240689
     C                   Eval      WIx = 0                                                    240689
     C                   BITOFF    '01234567'    WRETB             1                          240689
      *
      ** Validate Receiver's Correspondence
      *
     C                   EXSR      SRValRCorr
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C*****              IF        OKRCCO = 'N'                                 CFT014
     C                   IF        OKRCO1 = 'N'                                 CFT014
     C                             OR (OKRCO2 = 'N')                            CFT014
     C                             OR (OKRCO3 = 'N')                            CFT014
     C                             OR (OKRCO4 = 'N')                            CFT014
     C                             OR (OKRCO5 = 'N')                            CFT014
     C                   EVAL      RetCodeIn = 'ERROR'
     C*****              ENDIF                                                  CFT014
      *
     C*****              IF        OKRCCO <> 'N'                                CFT014
     C*****              MOVEL     DDRCCO        IPRCCO                         CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     WRCRT         IPRCRT
     C                   MOVEL     DDRCO1        IPRCCO                         CFT014
     C                   MOVEL     DDRCO1        IPINRCO1                       CFT014
     C                   MOVEL     DDRCO2        IPINRCO2                       CFT014
     C                   MOVEL     DDRCO3        IPINRCO3                       CFT014
     C                   MOVEL     DDRCO4        IPINRCO4                       CFT014
     C                   MOVEL     DDRCO5        IPINRCO5                       CFT014
     C                   MOVEL     WRCRT         IPINRCRT                       CFT014
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALRCORR - Validate Receiver's Correspondence              *
      *                                                               *
      *****************************************************************
     C     SRValRCorr    BEGSR
      *
      ** Check that DDRCCO field does not contain '?' - error if it does
      *
     C                   MOVE      '0'           *IN18
     C*****'?'           SCAN      DDRCCO                                 18    CFT014
     C     '?'           SCAN      DDRCO1                                 18    CFT014
      *
     C                   IF        *In18 = *On
      *
      ** Standing Data enquiry processing not allowed for this field.
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0048'     MsgIdXAr(Idx)
     C                   GOTO      GA300
     C                   ENDIF
      *
      ** Field must be entered if a valid Sender was & the Sender was
      ** not a Nostro, Full Account or Retail Account
     C                   IF        OKSND1 = 'Y' and
     C                             IPSNTP <> 'F' and
     C                             IPSNTP <> 'R' and
     C                             IPSNTP <> 'G' and
     C*****                        DDRCCO = *Blanks                             CFT014
     C                             WRcvCorDS = *Blanks                          CFT014
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0049'     MsgIdXAr(Idx)
     C                   GOTO      GA300
     C                   ENDIF
      *
      ** If Sender is a Nostro, Full Account or Retail Account &
      ** Receiver's correspondent is not entered, the Account must be
      ** In pay currency.
     C*****              IF        DDRCCO = *Blanks                             CFT014
     C                   IF        WRcvCorDS = *Blanks                          CFT014
      *
     C                   IF        IPSNTP = 'F' or
     C                             IPSNTP = 'R' or
     C                             IPSNTP = 'G'
      *
     C                   If        PSendrCcy <> DDSMCY
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0050'     MsgIdXAr(Idx)
     C                   GOTO      GA300
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Apart from above cases, field may be blank
      *
     C*****DDRCCO        CABEQ     *Blanks       GA300                          CFT014
     C     WRcvCorDS     CABEQ     *Blanks       GA300                          CFT014
      *                                                                         CFT014
      ** If CFT014 is off, Receiver's Correspondent should not be more          CFT014
      ** than 10 characters.                                                    CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'N'                                 CFT014
      *
      ** There must be no embedded spaces in the field
      *
     C                   MOVEL     *Blanks       YA3
     C*****              MOVEA     DDRCCO        YA3(1)                         CFT014
     C                   MOVEA     DDRCO1        YA3(1)                         CFT014
     C                   MOVEA     '00'          *IN(88)
     C                   Z-ADD     1             I1
      *
     C                   DOU       *IN89 = *On or
     C                             I1 > 10
     C                   IF        YA3(I1) = *Blanks
     C                   MOVE      *On           *IN88
     C                   ELSE
     C                   If        *IN88 = *On
     C                   MOVE      *On           *IN89
     C                   EndIf
     C                   ENDIF
     C                   ADD       1             I1
     C                   ENDDO
      *
     C                   IF        *In89 = *On
      *
      ** Entry must be: A two digit nostro number / A ten digit retail
      ** account number
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0051'     MsgIdXAr(Idx)
     C                   GOTO      GA300
     C                   ENDIF
      *
      ** Check if less than 2 characters were entered - invalid
     C                   IF        YA3(2) = *Blanks
      *
      ** Entry must be: A two digit nostro number / A ten digit retail
      ** account number
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0051'     MsgIdXAr(Idx)
     C                   GOTO      GA300
     C                   ENDIF
      *
      ** Check if exactly 2 characters were entered; If so check that
      ** they are numeric & if they are and the settle ccy entered was
      ** valid, Validate this field as being a nostro - must be on
      ** table file.
     C                   IF        YA3(3) = *Blanks
      *
     C                   TESTN                   YA3(1)               01
      *
     C                   IF        *In01 = *Off
      *
      ** Entry must be: A two digit nostro number / A ten digit retail
      ** account number
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0051'     MsgIdXAr(Idx)
     C                   GOTO      GA300
      *
     C                   ELSE
      *
     C                   MOVEA     YA3(1)        WA2A              2
     C                   IF        DDSMCY <> *Blanks and
     C                             OKSMCY <> 'N'
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *Blanks       PRtCd             7
     C                   PARM      '*KEY   '     POptn             7
     C                   PARM      *Blanks       PCust             6
     C                   PARM      DDSMCY        PCyCd             3
     C**********         PARM      *Blanks       PAccN             4                          CGL029
     C                   PARM      *BLANKS       PAccN                                        CGL029
     C                   PARM      *Blanks       PAcSN             2
     C                   PARM      WA2A          PNoNb             2
     C                   PARM      *Blanks       PBrCd             3
     C                   PARM      *Blanks       PCsSN            10
     C                   PARM      *Blanks       PPNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   IF        PRtCd <> *Blanks
      *
      ** The nostro code entered, when combined with the settle
      ** currency code, does not reference a valid nostro
      ** identifier.
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0052'     MsgIdXAr(Idx)
     C                   GOTO      GA300
     C                   ELSE
     C                   MOVE      A7ACCD        ACOD
     C                   MOVE      A7ACSN        ACSQ
     C                   MOVE      A7CUST        CNUM
     C                   MOVE      A7BRCD        BRCA
     C                   MOVEL     'N'           WRCRT
      *
      ** Store fields for key to ACCNT
     C**********         Z-ADD     CNUM          CNumSv            6 0                        CSD027
     C                   MOVE      CNUM          CNumSv            6                          CSD027
     C                   MOVEL     DDSMCY        CcySv             3
     C**********         Z-ADD     ACOD          ACodSv            4 0                        CGL029
     C                   Z-ADD     ACOD          ACodSv                                       CGL029
     C                   Z-ADD     ACSQ          AcSqSv            2 0
     C                   MOVE      BRCA          BrCASv            3
      *
     C                   GOTO      GA300
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If Retail module is present & Retail A/c Nos. are used:
      ** check if exactly 10 characters were entered & then if these
      ** were numeric; If so validate it as
      ** being a live Retail Account - must be on ACNUMA file;
      ** Also A/c must be in settle ccy (if this was valid) - If not in
      ** settle ccy, seton indicator to assign error code 041 later on.
     C                   IF        BGRTBN = 'Y'
      *
     C                   IF        YA3(10) <> *Blanks
      *
     C                   TESTN                   YA3(1)               01
      *
     C                   IF        *In01 = *Off
      *
      ** Entry must be: A two digit nostro number / A ten digit retail
      ** account number
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0051'     MsgIdXAr(Idx)
     C                   GOTO      GA300
      *
     C                   ELSE
     C                   MOVEA     YA3(1)        WA10             10
     C                   MOVE      WA10          WN10             10 0
      *
     C                   MOVE      WN10          ACNO
     C     ACNO          CHAIN     ACNUMA                             89
      *
     C                   IF        *In89 = *On or
     C                             RECI <> 'D'
      *
      ** The entry is not a valid retail account.
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0053'     MsgIdXAr(Idx)
     C                   GOTO      GA300
     C                   ELSE
      * Check for block debits on account                                                    BUG4581
     C                   TESTB     '2'           RETB                     51                 BUG4581
     C                   If        *in51 = *ON                                               BUG4581
     C/COPY WNCPYSRC,FTH00528
     C**********         Move      'N'           OKRCO1                            BUG4581 MD034521A
     C**********         Add       1             Idx                               BUG4581 MD034521A
     C**********         Movel     'DDRCO1'      FldNamXAr(Idx)                    BUG4581 MD034521A
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                     BUG4581 MD034521A
     C                   Move      'W'           OKRCO1                                    MD034521A
     C                   Add       1             WIx                                       MD034521A
     C                   Movel     'DDRCO1'      WFldNmXAr(WIx)                            MD034521A
     C                   Movel     'FTM0014'     WMsgIdXAr(WIx)                            MD034521A
     C/COPY WNCPYSRC,FTH00529
     C                   End                                                                 BUG4581
      *
      ** If Retail accounts not allowed, display error message
     C                   IF        BMRANR <> 'Y'
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0054'     MsgIdXAr(Idx)
     C                   GOTO      GA300
     C                   ELSE
      *
     C                   IF        DDSMCY <> *Blanks and
     C                             CCY <> DDSMCY
      *
      ** Set flag for error '041' later on.
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   MOVE      'N'           POkRcCo
     C                   GOTO      GA300
     C                   ELSE
     C                   MOVEL     'R'           WRCRT
     C                   GOTO      GA300
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Field has between 3 & 9 digits. This is invalid
     C*****              MOVE      'N'           OKRCCO                         CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx
     C*****              MOVEL     'DDRCCO'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0051'     MsgIdXAr(Idx)
      *                                                                         CFT014
      ** CFT014 is = 'Y'                                                        CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
     C                   EXSR      SRValRCorr2                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *
      **         *****     ***
     C     GA300         TAG
      **         *****     ***
      *
      ** If a valid Account has been entered store the account type and
      ** the date the account was opened.
      *
     C*****              IF        OKRCCO = 'Y'                                 CFT014
     C                   IF        OKRCO1 = 'Y'                                 CFT014
     C                             AND (OKRCO2 = 'Y')                           CFT014
     C                             AND (OKRCO3 = 'Y')                           CFT014
     C                             AND (OKRCO4 = 'Y')                           CFT014
     C                             AND (OKRCO5 = 'Y')                           CFT014
      *
     C                   IF        WRCRT = 'N' or
     C                             WRCRT = 'R'
     C                             OR WRCRT = 'F'                               CFT014
     C                             OR WRCRT = 'I'                               CFT014
     C                             OR WRCRT = 'G'                               CFT014
      *
      ** For a nostro first access the ACCNT record
     C                   If        WRCRT = 'N'
     C                             OR WRCRT = 'F'                               CFT014
     C                   MOVE      'Y'           WDUMP             1            CFT014
     C                   EXSR      SRAccChn
     C                   EndIf
      * Check for block debits on account                                                    BUG4581
     C                   TESTB     '2'           RETB                     51                 BUG4581
     C                   If        *in51 = *ON                                               BUG4581
     C/COPY WNCPYSRC,FTH00530
     C**********         Move      'N'           OKRCO1                            BUG4581 MD034521A
     C**********         Add       1             Idx                               BUG4581 MD034521A
     C**********         Movel     'DDRCO1'      FldNamXAr(Idx)                    BUG4581 MD034521A
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                     BUG4581 MD034521A
     C                   Move      'W'           OKRCO1                                    MD034521A
     C                   Add       1             WIx                                       MD034521A
     C                   Movel     'DDRCO1'      WFldNmXAr(WIx)                            MD034521A
     C                   Movel     'FTM0014'     WMsgIdXAr(WIx)                            MD034521A
     C/COPY WNCPYSRC,FTH00531
     C                   End                                                                 BUG4581
      *
     C                   MOVE      ATYP          PATyp2
     C                   MOVE      ACST          PAcSt2
     C                   Z-ADD     DACO          PDAcO2
      *
      ** Store full account details for FT Transaction Status File
      ** record update.
     C**********         Z-ADD     CNUM          IMCNUM                                       CSD027
     C                   EVAL      IMCNUM = CNUM                                              CSD027
     C                   MOVE      CCY           IMCCY
     C                   Z-ADD     ACOD          IMACOD
     C                   Z-ADD     ACSQ          IMACSQ
     C                   MOVE      BRCA          IMBRCA
     C                   MOVEL     IMACNT        PRCCDS
      *                                                                                       240689
      ** Check Status of Account                                                              240689
      *                                                                                       240689
     C                   MOVE      RETB          WRETB                                        240689
      *                                                                                       240689
      ** Blocked Debit                                                                        240689
      *                                                                                       240689
     C                   TESTB     '2'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C/COPY WNCPYSRC,FTH00532
     C**********         MOVE      'N'           OKRco1                             240689 MD034521A
     C**********         ADD       1             Idx                                240689 MD034521A
     C**********         MOVEL     'DDRCO1'      FldNamXAr(Idx)                     240689 MD034521A
     C**********         MOVEL     'FTM0014'     MsgIdXAr(Idx)                      240689 MD034521A
     C                   Move      'W'           OKRCO1                                    MD034521A
     C                   Add       1             WIx                                       MD034521A
     C                   Movel     'DDRCO1'      WFldNmXAr(WIx)                            MD034521A
     C                   Movel     'FTM0014'     WMsgIdXAr(WIx)                            MD034521A
     C/COPY WNCPYSRC,FTH00533
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bankrupt/Liquidated                                                                  240689
      *                                                                                       240689
     C                   TESTB     '6'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   MOVE      'N'           OKRco1                                       240689
     C                   ADD       1             Idx                                          240689
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                               240689
     C                   MOVEL     'FTM0015'     MsgIdXAr(Idx)                                240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bad Debt                                                                             240689
      *                                                                                       240689
     C                   TESTB     '7'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   MOVE      'N'           OKRco1                                       240689
     C                   ADD       1             Idx                                          240689
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                               240689
     C                   MOVEL     'FTM0016'     MsgIdXAr(Idx)                                240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Inactive                                                                             240689
      *                                                                                       240689
     C                   TESTB     '4'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKRco1                                       240689
     C     OKRco1        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKRco1                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'DDRCO1'      WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0017'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Referred Debit                                                                       240689
      *                                                                                       240689
     C                   TESTB     '0'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKRco1                                       240689
     C     OKRco1        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKRco1                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'DDRCO1'      WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0018'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRVALRCORR2- Additional validation for Receiver's            *         CFT014
      *               Correspondent.                                  *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
     C     SRValRCorr2   BEGSR                                                  CFT014
      *                                                                         CFT014
      ******************************                                            CFT014
      ** Check if an IBAN account **                                            CFT014
      ******************************                                            CFT014
      *                                                                         CFT014
     C                   IF        CFT004 = 'Y'                                 CFT014
      *                                                                         CFT014
      ** Ignore '/' if it is the first character                                CFT014
     C                   MOVE      *BLANKS       PIBAN            47            CFT014
     C                   IF        WRCO001001 = '/'                             CFT014
     C     34            SUBST     DDRCO1:2      PIBAN                          CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     DDRCO1        PIBAN                          CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   CALL      'AOIBANR3'                                   CFT014
     C                   PARM      *BLANKS       @RTCD                          CFT014
     C                   PARM                    PIBAN                          CFT014
     C                   PARM      *BLANKS       POWITH           47            CFT014
     C     P@IBAN        PARM      *BLANKS       PONOBL           34            CFT014
      *                                                                         CFT014
     C                   IF        @RTCD = *BLANKS                              CFT014
     C     2             SUBST     P@IBAN:1      WCHR02A           2            CFT014
     C     2             SUBST     P@IBAN:3      WCHR02B           2            CFT014
      *                                                                         CFT014
      ** Check if first 2 characters are alpha                                  CFT014
     C     ALPHAB        CHECK     WCHR02A       WXA               3 0          CFT014
      *                                                                         CFT014
      ** Check if second 2 characters are numeric                               CFT014
     C     DIGITS        CHECK     WCHR02B       WXB               3 0          CFT014
      *                                                                         CFT014
      ** If valid IBAN format, continue the validation                          CFT014
     C                   IF        (WXA = 0) AND (WXB = 0)                      CFT014
     C                   CALL      'AOIBANR2'                                   CFT014
     C                   PARM      *BLANKS       @RTCD                          CFT014
     C                   PARM                    P@IBAN           34            CFT014
     C     PIBNACC       PARM      *BLANKS       DSSDY                          CFT014
      *                                                                                     AR572681
     C                   IF        @RTCD <> *BLANKS                                         AR572681
     C                   EVAL      Idx = Idx + 1                                            AR572681
     C                   EVAL      FldNamXAr(Idx) = 'DDRCO1'                                AR572681
     C                   EVAL      ErrorFound = 'Y'                                         AR572681
     C                   EVAL      OKRCO1 = 'N'                                             AR572681
     C                   ENDIF                                                              AR572681
      *                                                                                     AR572681
     C                   SELECT                                                 CFT014
     C                   WHEN      @RTCD = '      1'                            CFT014
     C**********         ADD       1             Idx                                 CFT014 AR572681
     C                   MOVEL     'FTM3107'     MsgIdXAr(Idx)                  CFT014
     C**********         MOVEL     'FTM3108'     WMsgIdXAr(Idx)                      CFT014 AR572681
     C**********         MOVEL     'Y'           WIBNERR                             CFT014 AR572681
     C                   WHEN      @RTCD = '      2'                            CFT014
     C**********         ADD       1             Idx                                 CFT014 AR572681
     C                   MOVEL     'FTM3109'     MsgIdXAr(Idx)                  CFT014
     C**********         MOVEL     'FTM3110'     WMsgIdXAr(Idx)                      CFT014 AR572681
     C**********         MOVEL     'Y'           WIBNERR                             CFT014 AR572681
     C                   WHEN      @RTCD = '      3'                            CFT014
     C**********         ADD       1             Idx                                 CFT014 AR572681
     C                   MOVEL     'FTM3111'     MsgIdXAr(Idx)                  CFT014
     C**********         MOVEL     'FTM3112'     WMsgIdXAr(Idx)                      CFT014 AR572681
     C**********         MOVEL     'Y'           WIBNERR                             CFT014 AR572681
     C                   WHEN      @RTCD = '      4'                            CFT014
     C**********         ADD       1             Idx                                 CFT014 AR572681
     C                   MOVEL     'FTM3113'     MsgIdXAr(Idx)                  CFT014
     C**********         MOVEL     'FTM3114'     WMsgIdXAr(Idx)                      CFT014 AR572681
     C**********         MOVEL     'Y'           WIBNERR                             CFT014 AR572681
     C                   WHEN      @RTCD = '      5'                            CFT014
     C**********         ADD       1             Idx                                 CFT014 AR572681
     C                   MOVEL     'FTM3115'     MsgIdXAr(Idx)                  CFT014
     C**********         MOVEL     'FTM3116'     WMsgIdXAr(Idx)                      CFT014 AR572681
     C**********         MOVEL     'Y'           WIBNERR                             CFT014 AR572681
     C                   WHEN      @RTCD = '      6'                            CFT014
     C**********         MOVEL     'A'           WRCRT                               CFT014 AR572681
     C**********         GOTO      EXVALRCORR2                                       CFT014 AR572681
     C                   MOVEL     'FTM3161'     MsgIdXAr(Idx)                              AR572681
     C                   WHEN      @RTCD = *BLANKS                              CFT014
     C     '/'           CAT       P@IBAN        DDRCO1                         CFT014
     C                   MOVE      IBNATYP       ATYP                           CFT014
     C                   MOVE      IBNACST       ACST                           CFT014
     C                   Z-ADD     IBNDACO       DACO                           CFT014
     C**********         Z-ADD     IBNCNUM       CNUM                                  CFT014 CSD027
     C                   EVAL      CNUM = IBNCNUM                                             CSD027
     C                   MOVE      IBNCCY        CCY                            CFT014
     C                   Z-ADD     IBNACOD       ACOD                           CFT014
     C                   Z-ADD     IBNACSQ       ACSQ                           CFT014
     C                   MOVE      IBNBRCA       BRCA                           CFT014
     C                   MOVE      'I'           WRCRT                          CFT014
     C**********         GOTO      EXVALRCORR2                                       CFT014 AR572681
     C                   ENDSL                                                  CFT014
     C                   GOTO      EXVALRCORR2                                              AR572681
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      **********************                                                    CFT014
      ** Check if address **                                                    CFT014
      **********************                                                    CFT014
      ** Validate as an address if entry is more than 18 characters             CFT014
      ** (for multi-branch) or more than 15 characters (for single-             CFT014
      ** branch).                                                               CFT014
      *                                                                         CFT014
     C                   IF        (WRCO019175 <> *BLANKS                       CFT014
     C                              AND PMBIN = 'Y')                            CFT014
     C                             OR (WRCO016175 <> *BLANKS                    CFT014
     C                             AND PMBIN <> 'Y')                            CFT014
      *                                                                         CFT014
     C                   MOVE      *BLANKS       ADDRSS                         CFT014
     C                   MOVEL     DDRCO1        ADCHK1                         CFT014
     C                   MOVEL     DDRCO2        ADCHK2                         CFT014
     C                   MOVEL     DDRCO3        ADCHK3                         CFT014
     C                   MOVEL     DDRCO4        ADCHK4                         CFT014
     C                   MOVEL     DDRCO5        ADCHK5                         CFT014
     C                   EXSR      ADCHK                                        CFT014
      *                                                                         CFT014
      ** There should be no blank lines preceding any nonblank lines.           CFT014
     C                   IF        *IN92 = *ON                                  CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTM3117'     MsgIdXAr(Idx)                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Enties must be valid SWIFT characters                                  CFT014
     C     AD#1          IFEQ      'Y'                                          CFT014
     C                   MOVEL     'N'           OKRCO1                         CFT014
     C                   ENDIF                                                  CFT014
     C     AD#2          IFEQ      'Y'                                          CFT014
     C                   MOVEL     'N'           OKRCO2                         CFT014
     C                   ENDIF                                                  CFT014
     C     AD#3          IFEQ      'Y'                                          CFT014
     C                   MOVEL     'N'           OKRCO3                         CFT014
     C                   ENDIF                                                  CFT014
     C     AD#4          IFEQ      'Y'                                          CFT014
     C                   MOVEL     'N'           OKRCO4                         CFT014
     C                   ENDIF                                                  CFT014
     C     AD#5          IFEQ      'Y'                                          CFT014
     C                   MOVEL     'N'           OKRCO5                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** First character of the first line must be '/'                          CFT014
     C                   IF        OKRCO1 = 'Y'                                 CFT014
     C                             AND OKRCO2 = 'Y'                             CFT014
     C                             AND OKRCO3 = 'Y'                             CFT014
     C                             AND OKRCO4 = 'Y'                             CFT014
     C                             AND OKRCO5 = 'Y'                             CFT014
      *                                                                         CFT014
     C                   IF        (DDRCO1 <> *BLANKS)                          CFT014
     C                             AND (DDRCO2 <> *BLANKS)                      CFT014
     C                             AND (DDRCO3 <> *BLANKS)                      CFT014
     C                             AND (DDRCO4 <> *BLANKS)                      CFT014
     C                             AND (DDRCO5 <> *BLANKS)                      CFT014
     C                             AND WRCO001001 <> '/'                        CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTM3118'     MsgIdXAr(Idx)                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   IF        OKRCO1 = 'Y'                                 CFT014
     C                             AND (OKRCO2 = 'Y')                           CFT014
     C                             AND (OKRCO3 = 'Y')                           CFT014
     C                             AND (OKRCO4 = 'Y')                           CFT014
     C                             AND (OKRCO5 = 'Y')                           CFT014
     C                   MOVE      'A'           WRCRT                          CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      *************************                                                 CFT014
      ** Check if GL account **                                                 CFT014
      *************************                                                 CFT014
      ** If entry is more than 11 characters                                    CFT014
      *                                                                         CFT014
     C     WRCO012018    IFNE      *BLANK                                       CFT014
     C     PMBIN         ANDEQ     'Y'                                          CFT014
     C     WRCO012015    ORNE      *BLANK                                       CFT014
     C     PMBIN         ANDNE     'Y'                                          CFT014
      *                                                                         CFT014
      ** Customer number                                                        CFT014
     C**********         TESTN                   WRCO001006           88               CFT014 CSD027
     C******IN88         IFEQ      *OFF                                                CFT014 CSD027
     C**********         MOVE      'N'           OKRCO1                                CFT014 CSD027
     C**********         ADD       1             Idx                                   CFT014 CSD027
     C**********         MOVEL     'DDRCO1'      FldNamXAr(Idx)                        CFT014 CSD027
     C**********         MOVEL     'FTM3144'     MsgIdXAr(Idx)                         CFT014 CSD027
     C**********         GOTO      EXVALRCORR2                                         CFT014 CSD027
     C**********         ENDIF                                                         CFT014 CSD027
     C                   MOVE      WRCO001006    CNUMSV                         CFT014
      *                                                                         CFT014
      ** Currency                                                               CFT014
     C                   MOVE      WRCO007009    CCYSV                          CFT014
      *                                                                         CFT014
      ** Account code and Account sequence number                               CFT014
     C                   TESTN                   WRCO010013           88        CFT014
     C                   TESTN                   WRCO014015           89        CFT014
     C                   IF        (*IN88 = *OFF) OR (*IN89 = *OFF)             CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTM3144'     MsgIdXAr(Idx)                  CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
     C                   ENDIF                                                  CFT014
     C                   MOVE      WRCO010013    ACODSV                         CFT014
     C                   MOVE      WRCO014015    ACSQSV                         CFT014
      *                                                                         CFT014
      ** Branch code                                                            CFT014
     C                   IF        PMBIN = 'Y'                                  CFT014
     C                   MOVE      WRCO016018    BRCASV                         CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      BJSBRC        BRCASV                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   MOVE      'N'           WDUMP                          CFT014
     C                   EXSR      SRACCCHN                                     CFT014
     C                   IF        *IN89 = *ON                                  CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   MOVE      'N'           OKRCO2                         CFT014
     C                   MOVE      'N'           OKRCO3                         CFT014
     C                   MOVE      'N'           OKRCO4                         CFT014
     C                   MOVE      'N'           OKRCO5                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTM3145'     MsgIdXAr(Idx)                  CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   MOVE      'G'           WRCRT                          CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ***********************                                                   CFT014
      ** Check if SWIFT ID **                                                   CFT014
      ***********************                                                   CFT014
      ** If entry is 11 characters long                                         CFT014
      *                                                                         CFT014
     C                   MOVEL     *BLANKS       CLSWTK                         CFT014
     C                   MOVEL     WRCO001011    CLSWTK                         CFT014
     C                   EXSR      SWIFT                                        CFT014
      *                                                                         CFT014
     C                   IF        ##CSID = 'Y'                                 CFT014
      *                                                                         CFT014
     C                   IF        (*IN31 = *ON) OR (*IN32 = *ON)               CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTM3119'     MsgIdXAr(Idx)                  CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   MOVEL     'S'           WRCRT                          CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      *********************************                                         CFT014
      ** Check if Customer Shortname **                                         CFT014
      *********************************                                         CFT014
      ** Invalid shortname if more than 10 characters                           CFT014
      *                                                                         CFT014
     C                   IF        WRCO011175 <> *BLANKS                        CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTM3120'     MsgIdXAr(Idx)                  CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Check for embedded spaces between positions 1-10                       CFT014
     C                   MOVEL     *Blanks       YA3                            CFT014
     C                   MOVEA     DDRCO1        YA3(1)                         CFT014
     C                   MOVEA     '00'          *IN(88)                        CFT014
     C                   Z-ADD     1             I1                             CFT014
      *                                                                         CFT014
     C                   DOU       *IN89 = *On or                               CFT014
     C                             I1 > 10                                      CFT014
     C                   IF        YA3(I1) = *Blanks                            CFT014
     C                   MOVE      *On           *IN88                          CFT014
     C                   ELSE                                                   CFT014
     C                   If        *IN88 = *On                                  CFT014
     C                   MOVE      *On           *IN89                          CFT014
     C                   EndIf                                                  CFT014
     C                   ENDIF                                                  CFT014
     C                   ADD       1             I1                             CFT014
     C                   ENDDO                                                  CFT014
      *                                                                         CFT014
     C**********         TESTN                   WRCO001010               10                  CSD027
     C                   TESTN                   WRCO001010           10                      CSD027
     C**********         IF        (*IN89 = *ON)                                       CFT014 CSD027
     C**********         IF        (*IN89 = *ON) or                                  CSD027 BUG13201
     C**********                   WRCO011175 =  *BLANKS and                         CSD027 BUG13201
     C**********                   *IN10      =  '0'                                 CSD027 BUG13201
     C                   IF        (*IN89 = *ON)                                            BUG13201
      *                                                                         CFT014
     C                   CALL      'AOCUSTR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*KEY   '     POPTN                          CFT014
     C                   PARM      WRCO001010    PKEY1            10            CFT014
     C                   PARM      *BLANKS       PKYST             7            CFT014
     C     SDCUST        PARM      SDCUST        DSSDY                          CFT014
      *                                                                         CFT014
     C     PRTCD         IFEQ      *BLANKS                                      CFT014
     C     PKYST         ANDEQ     '*CSHT'                                      CFT014
     C     PRTCD         OREQ      *BLANKS                                                    CSD027
     C     PKYST         ANDEQ     '*CNUM'                                                    CSD027
     C                   MOVE      'C'           WRCRT                          CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTM3104'     MsgIdXAr(Idx)                  CFT014
     C                   ENDIF                                                  CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ****************************                                              CFT014
      ** Check if Retail number **                                              CFT014
      ****************************                                              CFT014
      ** If entry is 10 characters long                                         CFT014
      *                                                                         CFT014
     C                   IF        BGRTBN = 'Y'                                 CFT014
     C                             AND (WRCO010175 <> *BLANKS)                  CFT014
      *                                                                         CFT014
     C                   TESTN                   WRCO001010           88        CFT014
     C                   IF        *IN88 = *OFF                                 CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0006'     MsgIdXAr(Idx)                  CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   MOVE      WRCO001010    ACNO                           CFT014
     C     ACNO          CHAIN     ACNUMA                             89        CFT014
      *                                                                         CFT014
     C                   IF        *IN89 = *ON                                  CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0053'     MsgIdXAr(Idx)                  CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
     C                   ELSE                                                   CFT014
      * Check for block debits on account                                                    BUG4581
     C                   TESTB     '2'           RETB                     51                 BUG4581
     C                   If        *in51 = *ON                                               BUG4581
     C/COPY WNCPYSRC,FTH00534
     C**********         Move      'N'           OKRCO1                            BUG4581 MD034521A
     C**********         Add       1             Idx                               BUG4581 MD034521A
     C**********         Movel     'DDRCO1'      FldNamXAr(Idx)                    BUG4581 MD034521A
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                     BUG4581 MD034521A
     C                   Move      'W'           OKRCO1                                    MD034521A
     C                   Add       1             WIx                                       MD034521A
     C                   Movel     'DDRCO1'      WFldNmXAr(WIx)                            MD034521A
     C                   Movel     'FTM0014'     WMsgIdXAr(WIx)                            MD034521A
     C/COPY WNCPYSRC,FTH00535
     C                   End                                                                 BUG4581
     C                   IF        BMRANR <> 'Y'                                CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTA0054'     MsgIdXAr(Idx)                  CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
     C                   ENDIF                                                  CFT014
     C                   MOVEL     'R'           WRCRT                          CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ******************************                                            CFT014
      ** Check if Customer number **                                            CFT014
      ** or shortname             **                                                          CSD027
      ******************************                                            CFT014
      ** If entry is 6 characters long                                          CFT014
      *                                                                         CFT014
     C                   IF        WRCO007175 = *BLANKS                         CFT014
     C                             AND WRCO006006 <> *BLANK                     CFT014
      *                                                                         CFT014
     C**********         TESTN                   WRCO001006           88               CFT014 CSD027
      *                                                                         CFT014
     C**********         IF        (*IN88 = *ON)                                       CFT014 CSD027
     C                   CALL      'AOCUSTR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*KEY   '     POPTN                          CFT014
     C                   PARM      WRCO001006    PKEY1                          CFT014
     C                   PARM      *BLANKS       PKYST                          CFT014
     C     SDCUST        PARM      SDCUST        DSSDY                          CFT014
     C     PRTCD         IFEQ      *BLANKS                                      CFT014
     C*****PKYST         ANDEQ     '*CNUM'                                             CFT014 CSD027
     C                   MOVE      'C'           WRCRT                          CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTM3121'     MsgIdXAr(Idx)                  CFT014
     C                   ENDIF                                                  CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
     C**********         ENDIF                                                         CFT014 CSD027
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      *********************                                                     CFT014
      ** Check if Nostro **                                                     CFT014
      *********************                                                     CFT014
      ** If entry is 5 or 2 characters long                                     CFT014
      *                                                                         CFT014
     C                   IF        (WRCO006175 = *BLANKS                        CFT014
     C                              AND WRCO005005 <> *BLANK)                   CFT014
     C                              OR (WRCO003175 = *BLANK                     CFT014
     C                              AND WRCO002002 <> *BLANK)                   CFT014
      *                                                                         CFT014
     C                   MOVE      *BLANK        WFULLNOST         1            CFT014
      *                                                                         CFT014
     C                   IF        WRCO003175 = *BLANKS                         CFT014
     C                   MOVE      'N'           WFULLNOST                      CFT014
     C                   MOVE      WRCO001002    WNONB             2            CFT014
     C                   IF        OKSMCY = 'Y'                                 CFT014
     C                   MOVE      DDSMCY        WNONBCY           3            CFT014
     C                   ENDIF                                                  CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      'Y'           WFULLNOST                      CFT014
     C     3             SUBST     DDRCO1:1      WNONBCY                        CFT014
     C     2             SUBST     DDRCO1:4      WNONB                          CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   TESTN                   WNONB                88        CFT014
      *                                                                         CFT014
     C                   IF        *IN88 = *ON                                  CFT014
      *                                                                         CFT014
     C                   IF        WNONBCY <> *BLANKS                           CFT014
     C                   CALL      'AONOSTR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*KEY   '     POPTN                          CFT014
     C                   PARM      *BLANKS       PCUST                          CFT014
     C                   PARM      WNONBCY       PCYCD                          CFT014
     C                   PARM      *BLANKS       PACCN                          CFT014
     C                   PARM      *BLANKS       PACSN                          CFT014
     C                   PARM      WNONB         PNONB                          CFT014
     C                   PARM      *BLANKS       PBRCD                          CFT014
     C                   PARM      *BLANKS       PCSSN                          CFT014
     C                   PARM      *BLANKS       PPNOI                          CFT014
     C     SDNOST        PARM      SDNOST        DSFDY                          CFT014
     C                   IF        PRTCD <> *BLANKS                             CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   IF        WFULLNOST = 'Y'                              CFT014
     C                   MOVEL     'FTM3122'     MsgIdXAr(Idx)                  CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     'FTM2033'     MsgIdXAr(Idx)                  CFT014
     C**********         MOVEL     DDRCO1        MsgDtaXAr(IDx)                   AR1083047 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDRCO1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDRCO1)                   MD000091
     C                   ENDIF                                                  CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
     C                   ENDIF                                                  CFT014
      ** If entered only the nostro number, reformat to full nostro             CFT014
     C                   IF        WFULLNOST = 'N'                              CFT014
     C                   MOVE      WNONBCY       WRCO001003                     CFT014
     C                   MOVE      WNONB         WRCO004005                     CFT014
     C                   MOVE      WRCO1         DDRCO1                         CFT014
     C                   ENDIF                                                  CFT014
      ** Copy account info                                                      CFT014
     C                   MOVE      A7CUST        CNUMSV                         CFT014
     C                   MOVE      A7CYCD        CCYSV                          CFT014
     C                   MOVE      A7ACCD        ACODSV                         CFT014
     C                   MOVE      A7ACSN        ACSQSV                         CFT014
     C                   MOVE      A7BRCD        BRCASV                         CFT014
     C                   MOVE      'F'           WRCRT                          CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
     C                   ELSE                                                   CFT014
     C                   GOTO      EXVALRCORR2                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      **************************************                                    CFT014
      ** Revalidate as Customer shortname **                                    CFT014
      **************************************                                    CFT014
      ** If entry doesn't fall to any of the cases above, revalidate            CFT014
      ** entry as Customer shortname                                            CFT014
      *                                                                         CFT014
     C                   CALL      'AOCUSTR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*KEY   '     POPTN                          CFT014
     C                   PARM      WRCO001010    PKEY1                          CFT014
     C                   PARM      *BLANKS       PKYST                          CFT014
     C     SDCUST        PARM      SDCUST        DSSDY                          CFT014
     C     PRTCD         IFEQ      *BLANKS                                      CFT014
     C     PKYST         ANDEQ     '*CSHT'                                      CFT014
     C                   MOVE      'C'           WRCRT                          CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      'N'           OKRCO1                         CFT014
     C                   ADD       1             Idx                            CFT014
     C                   MOVEL     'DDRCO1'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'FTM3104'     MsgIdXAr(Idx)                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C     EXVALRCORR2   ENDSR                                                  CFT014
      *****************************************************************         CFT014
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACCCHN - Access the ACCNT record for a nostro              *
      *                                                               *
      *****************************************************************
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
     C     KAcKey        CHAIN     ACCNT                              89
      *
     C                   IF        WDUMP = 'Y'                                  CFT014
     C                   IF        *In89 = *On or
     C                             RECI <> 'D'
     C**********         MOVE      'FTVIRCORR'   DBPGM                                        262711
     C**********         MOVE      'ACCNT'       DBFILE                                       262711
     C**********         MOVEL     '47'          DBASE                                        262711
     C**********         MOVEL     ACKYDS        DBKEY                                        262711
     C**********         EXSR      *PSSR                                                      262711
     C                   MOVE      'N'           OKRCO1                                       262711
     C                   ADD       1             Idx                                          262711
     C                   MOVEL     'DDRC01'      FldNamXAr(Idx)                               262711
     C                   MOVEL     'FTM1524'     MsgIdXAr(Idx)                                262711
     C                   ENDIF
     C                   ENDIF                                                  CFT014
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
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn file 2 details from                       CFT014
      ** Incoming transactions - screen format                                  CFT014
     C                   PARM                    NwIP1AScnFmt                   CFT014
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMode             6
      *
      ** Sender Currency
     C                   PARM                    PSendrCcy         3
      *                                                                         CFT014
      ** FT Batch Auth. and Credit Advices                                      CFT014
     C                   PARM                    CFT004            1            CFT014
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014            1            CFT014
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Retail Banking Indicator
     C                   PARM                    BGRTBN            1
      *
      ** SDRETL - Retail Account required ?
     C                   PARM                    BMRANR            1
      *                                                                         CFT014
      ** Default branch for single-branch                                       CFT014
     C                   PARM                    BJSBRC            3            CFT014
      *                                                                         CFT014
      ** Multi-branching indicator                                              CFT014
     C                   PARM                    PMBIN             1            CFT014
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
      ** RCorr's Account Type
     C                   PARM                    PATyp2
      *
      ** RCorr's Account Status
     C                   PARM                    PAcSt2
      *
      ** RCorr's Date Account Opened
     C                   PARM                    PDAcO2
      *
      ** RCorr's Full Account
     C                   PARM                    PRCCDS
      *
      ** Work flag for error '041'
     C                   PARM                    POkRcCo
     C/COPY WNCPYSRC,FTH00536
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
      *                                                                         CFT014
      /COPY FTCPYSRC,SFTADDRSC1                                                 CFT014
      /EJECT                                                                    CFT014
      /COPY FTCPYSRC,SFTADDRCLE                                                 CFT014
      /EJECT                                                                    CFT014
      /COPY FTCPYSRC,SFTSWFTCLE                                                 CFT014
      /EJECT                                                                    CFT014
      *
**  CPY@
(c) Finastra International Limited 2001
