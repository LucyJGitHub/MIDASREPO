     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP sender')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVISNDR - Validate Sender                                   *
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
      *  Last Amend No. 259576             Date 02Apr14               *
      *  Prev Amend No. MD034521A          Date 14Sep15               *
      *                 MD039547           Date 20Sep16               *
      *                 MD046248           Date 27Oct17               *
      *                 261791             Date 19Aug14               *
      *                 262272             Date 20Dec12               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255286             Date 07Jul08               *
      *                 247142             Date 31May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241002             Date 18Jul06               *
      *                 240689             Date 13Jul06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 234355             Date 12Jul05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4581            Date 20Oct04               *
      *                 CLE025             Date 20Oct03               *
      *                 BG2756             Date 19May04               *
      *                 TDA006             Date 16Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008             Date 19Feb02               *
      *                 220322             Date 05Aug03               *
      *                 210796             Date 22Nov02               *
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
      *  259576 - Remove warning message for Inactive accounts.       *
      *           Applied for MD-26109                                *
      *  MD034521A - Error handling of Blocked account is not the     *
      *              same across the modules                          *
      *  MD039547 - Referred account is not properly validated.       *
      *  MD046248 - Finastra Rebranding                               *
      *  261791 - Issue an error message to indicate that the entered *
      *           account is a closed account.                        *
      *  262272 - Issue an error message when a closed Nostro account *
      *           is used in the Sender's field instead of ending in  *
      *           database error.                                     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255286 - Allow lowercase characters on input                 *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning.                  *
      *           Apply fixes 232151 and 210654.                      *
      *  232151 - DBASE error when inserting an inactive account.     *
      *  210654 - Check status of account.                            *
      *  241002 - Cannot amend Booking branch. Applied fix 227458.    *
      *           This fix is already catered by 234355.              *
      *  227458 - Do not override booking branch.  Applied part of    *
      *           217973.                                             *
      *  240689 - Applied fix 210654 + additional changes by 232151.  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  234355 - Problem of FT Booking Branch default.               *
      *           Introduce WRKFLD/W0BRCA for Booking Branch instead  *
      *           of FLD/IPBRCA from PF/FTVIPAYPD, so as not to over- *
      *           write the Payment Booking Branch.                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4581- Check for block debits/credits                      *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BG2756 - Dbase error in FTVISNDR as nostro branch is not set *
      *           due to bad fix 220322 which used booking branch of  *
      *           transaction instead of branch of nostro             *
      *  TDA006 - Correct 10-digit full account processing.           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *  220322 - Branch should not be blanks as key for Accounts.    *
      *  210796 - Extend Our a/c at Nostro field. Recompile.          *
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
      *                                                                                       240689
      ** Incoming Payments Lvl 1 Scrn file 2 details from                                     240689
      ** Incoming transaction - screen format                                                 240689
     D NwIP1AScnFmt  E DS                  EXTNAME(FTIPY1APD)                                 240689
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** External DS for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** External DS for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
                                                                                              CRE008
      ** Externally described DS for SAR details                                              CRE008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE008
     D SLCD          E                     EXTFLD(LCD)                                        CRE008
      *
      ** DS for access programs - Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Data Structure for Database Error on Account file
     D***ACKYDS*         DS            18                                                     CGL029
     D ACKYDS          DS                                                                     CGL029
     D**KACNUM**               1      6  0                                                    CSD027
     D  KACNUM                 1      6                                                       CSD027
     D  KACCCY                 7      9
     D***KACCD**               10     13  0                                                   CGL029
     D***KACSQ**               14     15  0                                                   CGL029
     D***KBRCA**               16     18                                                      CGL029
     D  KACCD                 10     19  0                                                    CGL029
     D  KACSQ                 20     21  0                                                    CGL029
     D  KBRCA                 22     24                                                       CGL029
      *
      ** Define full account to be passed for FT IMM update
     D***IMACNT*         DS            18                                                     CGL029
     D IMACNT          DS                                                                     CGL029
     D**IMCNUM**               1      6  0                                                    CSD027
     D  IMCNUM                 1      6                                                       CSD027
     D  IMCCY                  7      9
     D***IMACOD**              10     13  0                                                   CGL029
     D***IMACSQ**              14     15  0                                                   CGL029
     D***IMBRCA**              16     18                                                      CGL029
     D  IMACOD                10     19  0                                                    CGL029
     D  IMACSQ                20     21  0                                                    CGL029
     D  IMBRCA                22     24                                                       CGL029
      *
      ** Data structure redefining address fields
     D                 DS
     D Address                 1    140
     D  AdChk1                 1     35
     D  AdChk2                36     70
     D  AdChk3                71    105
     D  AdChk4               106    140
      *
     D                 DS
     D Sender                  1    140
     D  W0SND1                 1     35
     D  W0SND2                36     70
     D  W0SND3                71    105
     D  W0SND4               106    140
      *
      ** Controlling variables for entry validation.
     D  ##140                  1    140
     D  ##129                 12    140
     D  WA04                   5    140
     D  WA05                   6    140
     D  WA06                   7    140
     D  WA09                  10    140
     D  WA10                  11    140
     D**WA15****              16    140                                                       TDA006
     D**WA18****              19    140                                                       TDA006
     D  WA15                  22    140                                                       TDA006
     D  WA18                  25    140                                                       TDA006
      *
      ** Full Account
     D***W18****                1     18                                                      CGL029
     D***W15****                1     15                                                      CGL029
     D  W18                    1     24                                                       CGL029
     D  W15                    1     21                                                       CGL029
      *
      ** SWIFT
     D  ##011                  1     11
      *
      ** Nostro Combination
     D  WA3                    1      3
     D  WA2                    4      5
      *
      ** Customer Number
     D  WA6                    1      6
     D  WA7                    7     10                                                       CSD027
      *
      ** Retail Number
     D  WA10#                  1     10
      *
      ** Customer Address
     D**WA20                  16     35                                                       TDA006
     D**WA17                  19     35                                                       TDA006
     D  WA20                  22     35                                                       TDA006
     D  WA17                  25     35                                                       TDA006
      *
     D Wfld            S             35    DIM(1)
     D***YA3****         S              1    DIM(18)                                          CGL029
     D YA3             S              1    DIM(24)                                            CGL029
     D WTst            S              1    DIM(35)
     D*SWCH*****       S              1    DIM(47) CTDATA PERRCD(47)                          255286
     D SWCH            S              1    DIM(73) CTDATA PERRCD(73)                          255286
     D ##CSID          S              1
      *
      ** General constant fields
     D/COPY FTCPYSRC,SFTVALCSLE
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
     D WIdx            S              3P 0                                                    CRE008
                                                                                              CRE008
      ** Parameters used for call to RE101901                                                 CRE008
     D PRetCode        S              7                                                       CRE008
     D PInBranch       S              3                                                       CRE008
     D*PInCust**       S              6  0                                             CRE008 CSD027
     D PInCust         S              6                                                       CSD027
     D PInCurr         S              3                                                       CRE008
     D***PInACode        S              4  0                                           CRE008 CGL029
     D PInACode        S             10  0                                                    CGL029
     D PInASeqN        S              2  0                                                    CRE008
     D PSetAmnt        S             15  0                                                    CRE008
     D POutBranch      S              3                                                       CRE008
     D*POutCust*       S              6  0                                             CRE008 CSD027
     D POutCust        S              6                                                       CSD027
     D POutCurr        S              3                                                       CRE008
     D***POutACode       S              4  0                                           CRE008 CGL029
     D POutACode       S             10  0                                                    CGL029
     D POutASeqN       S              2  0                                                    CRE008
     D POutRetNo       S             10  0                                                    CRE008
                                                                                              CRE008
     D***WkACodeC        S              4                                              CRE008 CGL029
     D WkACodeC        S             10                                                       CGL029
     D WkASeqNC        S              2                                                       CRE008
     D WkCustC         S              6                                                       CRE008
     D WkRetNoC        S             10                                                       CRE008
                                                                                              CRE008
     D CRE008          S              1                                                       CRE008
                                                                                              CRE008
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
      ** Initialise output parameters.
      *
      ** Account type,subtype,date account opened
     C                   MOVE      *Blank        PAtyp1            1
     C                   MOVEL     *Blank        PAcSt1            1
     C                   Z-ADD     *Zeros        PDAcO1            5 0
     C                   MOVE      *BLANKS       PSNDCSID                       CFT014
     C                   MOVE      *BLANKS       PSNDCOLC                       CFT014
      *
      ** Sender currency
     C                   MOVEL     *Blanks       PSendrCcy         3
      *
      ** Full account
     C**********         MOVEL     *Blanks       PSNDDS           18                          CGL029
     C                   MOVEL     *Blanks       PSNDDS           24                          CGL029
      *
      ** Initialise work variables.
      *
     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0                                                   CRE008
     C                   MOVE      *Zeros        I1                3 0
     C                   MOVE      *Zeros        J1                3 0
     C**********         MOVE      *Blanks       W0ACOD            4 0                        CGL029
     C                   MOVE      *Blanks       W0ACOD           10 0                        CGL029
     C                   MOVE      *Blanks       W0ACSQ            2 0
     C**********         MOVE      *Blanks       W0CNUM            6 0                        CSD027
     C                   MOVE      *Blanks       W0CNUM            6                          CSD027
     C                   MOVE      *Blanks       W0BRCA            3                          234355
     C                   MOVE      *Blanks       W0SND1
     C                   MOVE      *Blanks       W0SND2
     C                   MOVE      *Blanks       W0SND3
     C                   MOVE      *Blanks       W0SND4
     C                   MOVE      *Blanks       WSNTP             1
     C                   Eval      WFldNmXAr = *Blanks                                        240689
     C                   Eval      WMsgIDXAr  = *Blanks                                       240689
     C                   Eval      WMsgDtXAr = *Blanks                                        240689
     C                   BITOFF    '01234567'    WRETB             1                          240689
      *
      ** Validate Sender
      *
     C                   EXSR      SRValSender
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKSND1 = 'N' or
     C                             OKSND2 = 'N' or
     C                             OKSND3 = 'N' or
     C                             OKSND4 = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ELSE
     C                   MOVE      DDSND1        IPSND1
     C                   MOVE      DDSND2        IPSND2
     C                   MOVE      DDSND3        IPSND3
     C                   MOVE      DDSND4        IPSND4
     C                   MOVE      WSNTP         IPSNTP
     C                   ENDIF
                                                                                              CRE008
      ** If warning was found, set the return code appropriately                              CRE008
     C                   IF        OKSND1 = 'W' or                                            CRE008
     C                             OKSMAM = 'W'                                               CRE008
     C                   EVAL      RetCodeIn = 'WARN'                                         CRE008
     C                   ENDIF                                                                CRE008
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSENDER - Sender Validation                              *
      *                                                               *
      *****************************************************************
     C     SRValSender   BEGSR
      *
      ** Set data structure details
     C                   MOVEL     DDSND1        W0SND1
     C                   MOVEL     DDSND2        W0SND2
     C                   MOVEL     DDSND3        W0SND3
     C                   MOVEL     DDSND4        W0SND4
      *
      ** Some entry must be made to one of the Sender fields
      *
     C                   IF        DDSND1 = *Blanks and
     C                             DDSND2 = *Blanks and
     C                             DDSND3 = *Blanks and
     C                             DDSND4 = *Blanks
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0059'     MsgIdXAr(Idx)
     C                   GOTO      ESRValSender
     C                   ENDIF
      *
      ** Check that first field of Sender does not contain '?'
      *
     C                   MOVE      *Off          *In01
     C     '?'           SCAN      DDSND1                                 01
      *
     C                   IF        *In01 = *On
      *
      ** Entry is invalid in *CTL function if it contains '?'.
      *
     C                   IF        PMODE = '*FRONT'
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0078'     MsgIdXAr(Idx)
     C                   GOTO      ESRValSender
     C                   ELSE
      *
      ** Standing Data enquiry processing is not allowed for
      ** this field.
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0060'     MsgIdXAr(Idx)
     C                   GOTO      ESRValSender
     C                   ENDIF
     C                   ENDIF
      *
      ** Any entry to Sender fields 2,3 or 4 implied that the whole
      ** is an address, which needs additional validation.
      ** also chech whether more than (fifteen/eighteen if multibranch)
      ** have been entered in line one
      *
     C                   IF        WA17 <> *BLANKS and
     C                             BGMBIN = 'Y' or
     C                             WA20 <> *BLANKS and
     C                             BGMBIN <> 'Y' or
     C                             DDSND2 <> *BLANKS or
     C                             DDSND3 <> *BLANKS or
     C                             DDSND4 <> *BLANKS
     C                   MOVEL     'A'           WSNTP
     C                   EXSR      SRVAddress
     C                   GOTO      ESRValSender
     C                   ENDIF
      *
      ** Check for SWIFT Address
      *
     C                   EXSR      SRVSWIFT
      *
     C                   IF        WSNTP = 'S'
     C                   GOTO      ESRValSender
     C                   ENDIF
      *
      ** If more than 5 char have been entered cannot be a NOSTRO
     C                   IF        WA05 = *Blanks
      *
     C                   EXSR      SRVNostro
      *
     C                   ELSE
      *
      ** If more than 6 char have been entered cannot be CUST NUMBER
     C                   If        WA06 = *Blanks
      *
     C                   EXSR      SRVCust
      *
     C                   Else
      *
      ** If more than 10 char have been entered cannot be RETAIL No.
     C                   If        WA10 = *Blanks
     C                   EXSR      SRVRetail
     C                   Else
      *
      ** Therefore maybe is a full Account
     C                   If        WA18 = *Blanks and
     C                             BGMBIN = 'Y' or
     C                             WA15 = *Blanks and
     C                             BGMBIN <> 'Y'
     C                   EXSR      SRVFulAcc
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   ENDIF
      *
     C     ESRValSender  ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVADDRESS - Validate Address                                *
      *                                                               *
      *****************************************************************
     C     SRVAddress    BEGSR
      *
     C                   MOVE      *Blanks       Address
     C                   MOVEL     DDSND1        AdChk1
     C                   MOVEL     DDSND2        AdChk2
     C                   MOVEL     DDSND3        AdChk3
     C                   MOVEL     DDSND4        AdChk4
      *
      ** There should be no embedded spaces
      *
     C                   IF        AdChk1 = *Blanks and
     C                             AdChk2 <> *Blanks or
     C                             AdChk1 = *Blanks and
     C                             AdChk3 <> *Blanks or
     C                             AdChk1 = *Blanks and
     C                             AdChk4 <> *Blanks or
      *
     C                             AdChk2 = *Blanks and
     C                             AdChk3 <> *Blanks or
     C                             AdChk2 = *Blanks and
     C                             AdChk4 <> *Blanks or
      *
     C                             AdChk3 = *Blanks and
     C                             AdChk4 <> *Blanks
      *
     C                   MOVE      'N'           OKSND1
     C                   MOVE      'N'           OKSND2
     C                   MOVE      'N'           OKSND3
     C                   MOVE      'N'           OKSND4
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0067'     MsgIdXAr(Idx)
      *
     C                   ENDIF
      *
      ** Check for non-valid SWIFT characters
      *
     C                   IF        AdChk1 <> *Blanks
     C                   MOVEA     *Blanks       Wfld
     C                   MOVE      AdChk1        Wfld
     C                   EXSR      SRSWSET
     C                   If        WError = 'Y'
     C                   MOVE      'N'           OKSND1
     C                   MOVE      'N'           OKSND2
     C                   MOVE      'N'           OKSND3
     C                   MOVE      'N'           OKSND4
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0068'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C                   IF        AdChk2 <> *Blanks
     C                   MOVEA     *Blanks       Wfld
     C                   MOVE      AdChk2        Wfld
     C                   EXSR      SRSWSET
     C                   If        WError = 'Y'
     C                   MOVE      'N'           OKSND2
     C                   MOVE      'N'           OKSND1
     C                   MOVE      'N'           OKSND3
     C                   MOVE      'N'           OKSND4
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND2'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0069'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C                   IF        AdChk3 <> *Blanks
     C                   MOVEA     *Blanks       Wfld
     C                   MOVE      AdChk3        Wfld
     C                   EXSR      SRSWSET
     C                   If        WError = 'Y'
     C                   MOVE      'N'           OKSND3
     C                   MOVE      'N'           OKSND2
     C                   MOVE      'N'           OKSND1
     C                   MOVE      'N'           OKSND4
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND3'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0070'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C                   IF        AdChk4 <> *Blanks
     C                   MOVEA     *Blanks       Wfld
     C                   MOVE      AdChk4        Wfld
     C                   EXSR      SRSWSET
     C                   If        WError = 'Y'
     C                   MOVE      'N'           OKSND4
     C                   MOVE      'N'           OKSND3
     C                   MOVE      'N'           OKSND2
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND4'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0071'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSWIFT - Validate SWIFT Address                            *
      *                                                               *
      *****************************************************************
     C     SRVSWIFT      BEGSR
      *
     C                   IF        ##140 <> *Blanks and
     C                             ##129 = *Blanks
      *
      ** Call SWIFT subroutine to check address
      *
     C                   MOVEL     *Blanks       CLSWTK           12
     C                   MOVEL     ##011         CLSWTK
      *
     C                   EXSR      SWIFT
      *
      ** No SWIFT address record but format is valid
      *
     C                   IF        ##CSID = 'Y'
      *
     C                   If        ##CSID = 'Y' and
     C                             *In31 = *On or
     C                             *In32 = *On and
     C                             *In31 = *Off
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTM2356'     MsgIdXAr(Idx)
     C                   Else
     C                   MOVEL     'S'           WSNTP
     C                   MOVEL     ##011         PSNDCSID                       CFT014
     C                   EndIf
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
      *  SRVNOSTRO - Validate Nostro                                  *
      *                                                               *
      *****************************************************************
     C     SRVNostro     BEGSR
      *
      ** Entry is less than 5 characters, validate as a short name
      *
     C                   IF        WA04 = *Blanks
     C                   EXSR      SRGA100
     C                   ELSE
      *
      ** Otherwise, entry is 5 characters; validate it as a Nostro
      ** and must be in table file.
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *Blanks       PRtCd             7
     C                   PARM      '*KEY   '     POptn             7
     C                   PARM      *Blanks       PCust             6
     C                   PARM      WA3           PCyCd             3
     C**********         PARM      *Blanks       PAccn             4                          CGL029
     C                   PARM      *Blanks       PAccn            10                          CGL029
     C                   PARM      *Blanks       PAcSn             2
     C                   PARM      WA2           PNoNb             2
     C                   PARM      *Blanks       PBrCd             3
     C                   PARM      *Blanks       PCsSn            10
     C                   PARM      *Blanks       PPNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   If        PRtCd <> *Blanks
      *
      ** Entry is not a valid Nostro Identifier.
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0061'     MsgIdXAr(Idx)
      *
      ** Can be a shortname
     C                   EXSR      SRGA100
      *
     C                   Else
      *
     C                   MOVE      A7ACCD        W0ACOD
     C                   MOVE      A7ACSN        W0ACSQ
     C                   MOVE      A7CUST        W0CNUM
     C**********         MOVE      A7BRCD        IPBRCA                                       234355
     C                   MOVE      A7BRCD        W0BRCA                                       234355
     C                   MOVEL     WA3           PSendrCcy
     C                   MOVEL     'F'           WSNTP
      *
      ** Store fields for key to ACCNT
      *
     C**********         Z-ADD     W0CNUM        CNumSv            6 0                        CSD027
     C                   MOVE      W0CNUM        CNumSv            6                          CSD027
     C                   MOVEL     DDSND1        CcySv             3
     C**********         Z-ADD     W0ACOD        ACodSv            4 0                        CGL029
     C                   Z-ADD     W0ACOD        ACodSv           10 0                        CGL029
     C                   Z-ADD     W0ACSQ        AcSqSv            2 0
     C**********         MOVE      IPBRCA        BrCASv            3                          220322
     C*******************MOVE      DDBRCA        BrCASv            3                   220322 BG2756
     C**********         MOVE      IPBRCA        BrCASv            3                   BG2756 234355
     C                   MOVE      W0BRCA        BrCASv            3                          234355
      *
     C                   EXSR      SRGA200
      *
     C                   EndIf
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCUST - Validate Customer                                  *
      *                                                               *
      *****************************************************************
     C     SRVCust       BEGSR
      *
      ** Entry is exactly 6 characters, If numeric validate it as
      ** a live customer and must be in CLINT file.  Otherwise,
      ** validate as short name.
      *
     C**********         TESTN                   WA6                  01                      CSD027
      *
     C**********         IF        *In01 = *Off                                               CSD027
      *
      ** Can be a Short name
     C**********         EXSR      SRGA100                                                    CSD027
      *
     C**********         ELSE                                                                 CSD027
      *
      ** Validate as customer
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WA6           PKey1            10
     C                   PARM      *Blank        PKyST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C**********         IF        PRtCd <> *Blanks or                                        CSD027
     C**********                   PKyST <> '*CNUM  '                                         CSD027
     C                   IF        PRtCd <> *Blanks                                           CSD027
     C                   IF        WA7   =  *Blanks                                           CSD027
      *
      ** Entry is not a valid customer number.
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0062'     MsgIdXAr(Idx)
     C                   ELSE                                                                 CSD027
      *
      ** Can be a short name
     C                   EXSR      SRGA100
     C                   ENDIF                                                                CSD027
      *
     C                   ELSE
      *
      ** Entry is a valid customer.
     C                   MOVEL     BBCUST        DDSND1
     C**********         MOVE      BBBRCD        IPBRCA                                       234355
     C                   MOVE      BBBRCD        W0BRCA                                       234355
     C                   MOVEL     BBCSID        PSNDCSID                       CFT014
     C                   MOVEL     BBCOLC        PSNDCOLC                       CFT014
     C                   MOVEL     'C'           WSNTP
      *
     C                   ENDIF
     C**********         ENDIF                                                                CSD027
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVRETAIL - Validate Retail Number                           *
      *                                                               *
      *****************************************************************
     C     SRVRetail     BEGSR
      *
      ** Entry is less than 10 Characters, can be a short name.
      ** Otherwise a Retail number.
      *
     C                   IF        WA09 = *Blanks
     C                   EXSR      SRGA100
     C                   ELSE
      *
      ** Entry is exactly 10 Characters and Retail A/c Nos. are used.
      ** If these were numeric; validate it as a live Retail A/c and
      ** must be in ACNUMA file.  Otherwise validate it as short name.
      *
     C                   IF        BGRTBN = 'Y'
      *
     C                   TESTN                   WA10#                01
      *
     C                   If        *IN01 = *Off
      *
      ** Can be a shortname
     C                   EXSR      SRGA100
      *
     C                   Else
     C                   MOVE      WA10#         WN10             10 0
     C                   MOVE      WN10          ACNO
     C     ACNO          CHAIN     ACNUMA                             89
     C                   IF        *In89 = *On or
     C                             RECI <> 'D'
      *
      ** Entry is not a valid Retail Account
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0063'     MsgIdXAr(Idx)
      *
      ** Can be a shortname
     C                   EXSR      SRGA100
     C                   Else
      **Check*for*block*debits*on*account******************************             BUG4581 MD039547
     C**********         TESTB     '2'           RETB                     51        BUG4581 MD039547
     C**********         If        *in51 = *ON                                      BUG4581 MD039547
     C/COPY WNCPYSRC,FTH00537
     C**********         Move      'N'           OKSND1                            BUG4581  MD039547
     C**********         Add       1             Idx                               BUG4581  MD039547
     C**********         Movel     'DDSND1'      FldNamXAr(Idx)                    BUG4581  MD039547
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                     BUG4581  MD039547
     C/COPY WNCPYSRC,FTH00538
     C**********         End                                                        BUG4581 MD039547
      *
     C                   If        BMRANR <> 'Y'
      *
      ** Retail Account not allowed
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0064'     MsgIdXAr(Idx)
     C                   Else
     C                   MOVEL     CCY           PSendrCcy
     C                   MOVEL     'R'           WSNTP
     C                   EXSR      SRGA200
                                                                                              CRE008
      ** If CRE008 is on, sender retail account is valid and settlement amount is valid       CRE008
      ** Check the overdraft limit for the retail account                                     CRE008
                                                                                              CRE008
     C                   IF        CRE008 = 'Y' and OKSMAM = 'Y'                              CRE008
     C                   EXSR      SRODLChk                                                   CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   EndIf
     C                   EndIf
     C                   EndIf
      *
     C                   ELSE
      *
      ** Otherwise validate as shortname
     C                   EXSR      SRGA100
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
      *  SRVFULLACC - Validate Full Account                           *
      *                                                               *
      *****************************************************************
     C     SRVFulAcc     BEGSR
      *
      ** There must be no embedded space in positions 11 to 15
      ** or positions 11 to 18 for multibranched
      *
     C                   IF        BGMBIN <> 'Y'
     C                   MOVEA     W15           YA3(1)
     C                   ELSE
     C                   MOVEA     W18           YA3(1)
     C                   ENDIF
      *
     C                   MOVEA     '00'          *In(88)
     C                   EVAL      I1 = 11
      *
     C                   IF        BGMBIN <> 'Y'
     C                   EVAL      J1 = 15
     C                   ELSE
     C                   EVAL      J1 = 18
     C                   ENDIF
      *
     C                   DOU       *In89 = *On or
     C                             I1 > J1
      *
     C                   If        YA3(I1) = *Blanks
     C                   MOVE      *On           *In88
     C                   Else
     C                   If        *In88 = *On
     C                   MOVE      *On           *In89
     C                   EndIf
     C                   EndIf
      *
     C                   EVAL      I1 = I1 + 1
      *
     C                   ENDDO
      *
     C                   IF        *In89 = *On
      *
      ** The entry is not a valid customer shortname.
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0065'     MsgIdXAr(Idx)
     C                   GOTO      ESRVFulAcc
     C                   ENDIF
      *
      ** If there are any embedded spaced in positions 1 to 10,It can
      ** only be a short-name & should be validated as such but is
      ** invalid if entry is > 10 characters
      *
     C                   MOVEA     '00'          *In(88)
     C                   EVAL      I1 = 1
      *
     C                   DOU       *In89 = *On or
     C                             I1 > 10
      *
     C                   If        YA3(I1) = *Blanks
     C                   MOVE      *On           *In88
     C                   Else
     C                   If        *In88 = *On
     C                   MOVE      *On           *In89
     C                   EndIf
     C                   EndIf
      *
     C                   EVAL      I1 = I1 + 1
      *
     C                   ENDDO
      *
     C                   IF        *In89 = *On
      *
      ** The entry is not a valid customer shortname.
     C                   If        YA3(11) <> *Blank
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0065'     MsgIdXAr(Idx)
     C                   GOTO      ESRVFulAcc
     C                   Else
      *
      ** The entry is in a valid customer shortname format
     C                   EXSR      SRGA100
     C                   EndIf
      *
     C                   ENDIF
      *
      ** If less than 15 characters were entered, the field is invalid
      ** or less than 18 if multi-branch
      *
     C**********         IF        YA3(15) = *Blanks and                                      CGL029
     C                   IF        YA3(21) = *Blanks and                                      CGL029
     C                             BGMBIN <> 'Y' or
     C**********                   YA3(18) = *Blanks and                                      CGL029
     C                             YA3(24) = *Blanks and                                      CGL029
     C                             BGMBIN = 'Y'
      *
      ** The entry is not a valid customer shortname.
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0065'     MsgIdXAr(Idx)
     C                   GOTO      ESRVFulAcc
     C                   ENDIF
      *
      ** Exactly 18 characters entered for multi-branch else
      ** exactly 15 characters entered; they must be in the format
      ** 999999XXX999999
      *
     C                   MOVEA     YA3(1)        W1A6              6
     C********           TESTN                   W1A6                 01                      CSD027
      *
     C********           IF        *IN01 = *Off                                               CSD027
      *
      ** The entry is not a valid customer shortname.
     C********           MOVE      'N'           OKSND1                                       CSD027
     C********           ADD       1             Idx                                          CSD027
     C********           MOVEL     'DDSND1'      FldNamXAr(Idx)                               CSD027
     C********           MOVEL     'FTA0065'     MsgIdXAr(Idx)                                CSD027
     C********           GOTO      ESRVFulAcc                                                 CSD027
     C********           ENDIF                                                                CSD027
      *
     C********           MOVEA     YA3(10)       W1A6                                         CSD027
     C********           TESTN                   W1A6                 02                      CSD027
     C                   MOVEA     YA3(10)       W1A10            10                          CSD027
     C                   TESTN                   W1A10                02                      CSD027
      *
     C                   IF        *IN02 = *Off
      *
      ** The entry is not a valid customer shortname.
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0065'     MsgIdXAr(Idx)
     C                   GOTO      ESRVFulAcc
     C                   ENDIF
      *
      ** Validate the field as being a live full account - it must be
      ** on ACCNT file.
      *
     C                   MOVEA     YA3(1)        W1A6
     C**********         MOVEA     YA3(10)       W1A4              4                          CGL029
     C**********         MOVEA     YA3(14)       W1A2              2                          CGL029
     C                   MOVEA     YA3(10)       W1A4             10                          CGL029
     C                   MOVEA     YA3(20)       W1A2              2                          CGL029
     C                   MOVE      W1A6          KACNUM
     C                   MOVEA     YA3(7)        KACCCY
     C                   MOVE      W1A4          KACCD
     C                   MOVE      W1A2          KACSQ
      *
     C                   IF        BGMBIN <> 'Y'
     C                   MOVE      BJSBRC        KBRCA
     C                   ELSE
     C**********         MOVEA     YA3(16)       KBRCA                                        CGL029
     C                   MOVEA     YA3(22)       KBRCA                                        CGL029
     C                   ENDIF
      *
      ** Read Account Detail
     C     KAcKey        CHAIN     ACCNT                              89
      *
     C                   IF        *In89 = *On or
     C                             RECI <> 'D'
      *
      ** The entry is not a valid account identifier.
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0066'     MsgIdXAr(Idx)
     C                   GOTO      ESRVFulAcc
     C                   ELSE
      * Check for block debits on account                                                    BUG4581
     C                   TESTB     '2'           RETB                     51                 BUG4581
     C                   If        *in51 = *ON                                               BUG4581
     C/COPY WNCPYSRC,FTH00539
     C**********         Move      'N'           OKSND1                            BUG4581 MD034521A
     C**********         Add       1             Idx                               BUG4581 MD034521A
     C**********         Movel     'DDSND1'      FldNamXAr(Idx)                    BUG4581 MD034521A
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                     BUG4581 MD034521A
     C                   Move      'W'           OKSND1                                    MD034521A
     C                   Add       1             WIdx                                      MD034521A
     C                   Eval      WFldNmXAr(WIdx) = 'DDSND1'                              MD034521A
     C                   Eval      WMsgIdXAr(WIdx) = 'FTM0014'                             MD034521A
     C/COPY WNCPYSRC,FTH00540
     C                   End                                                                 BUG4581
     C                   MOVEL     CCY           PSendrCcy
     C                   MOVEL     'G'           WSNTP
     C                   EXSR      SRGA200
      *
     C                   ENDIF
      *
     C     ESRVFulAcc    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGA100 - Validate entry as a valid short name               *
      *                                                               *
      *****************************************************************
     C     SRGA100       BEGSR
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDSND1        PKey1            10
     C                   PARM      *Blanks       PKyST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtCd <> *Blanks or
     C                             PKyST <> '*CSHT'
      *
      ** Entry is invalid shortname.
      *
     C                   If        OKSND1 = 'Y'
     C                   MOVE      'N'           OKSND1
     C                   ADD       1             Idx
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0065'     MsgIdXAr(Idx)
     C                   EndIf
      *
     C                   ELSE
      *
      ** Otherwise, entry is a valid shortname. Move the customer
      ** number to sender field for proper display.
      *
     C                   MOVEL     *Blanks       DDSND1
     C                   MOVEL     BBCUST        DDSND1
     C**********         MOVE      BBBRCD        IPBRCA                                       234355
     C                   MOVE      BBBRCD        W0BRCA                                       234355
     C                   MOVEL     BBCSID        PSNDCSID                       CFT014
     C                   MOVEL     BBCOLC        PSNDCOLC                       CFT014
     C                   MOVEL     'C'           WSNTP
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGA200 - Store the Account Type and Date Account was opened.*
      *                                                               *
      *****************************************************************
     C     SRGA200       BEGSR
      *
      ** If a valid Account has been entered store the account type and
      ** the date the account was opened
      *
     C**********         IF        OKSND1 ='Y'                                              MD039547
     C                   IF        OKSND1 <> 'N'                                            MD039547
      *
     C                   IF        WSNTP = 'F' or
     C                             WSNTP = 'R' or
     C                             WSNTP = 'G'
      *
      ** For a Nostro first access the ACCNT record
     C                   If        WSNTP= 'F'
     C                   EXSR      SRAccChn
     C                   EndIf
      * Check for block debits on account                                                    BUG4581
     C                   TESTB     '2'           RETB                     51                 BUG4581
     C                   If        *in51 = *ON                                               BUG4581
     C/COPY WNCPYSRC,FTH00541
     C**********         Move      'N'           OKSND1                            BUG4581 MD034521A
     C**********         Add       1             Idx                               BUG4581 MD034521A
     C**********         Movel     'DDSND1'      FldNamXAr(Idx)                    BUG4581 MD034521A
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                     BUG4581 MD034521A
     C                   Move      'W'           OKSND1                                    MD034521A
     C                   Add       1             WIdx                                      MD034521A
     C                   Eval      WFldNmXAr(WIdx) = 'DDSND1'                              MD034521A
     C                   Eval      WMsgIdXAr(WIdx) = 'FTM0014'                             MD034521A
     C/COPY WNCPYSRC,FTH00542
     C                   End                                                                 BUG4581
      *
     C                   MOVE      ATYP          PAtyp1
     C                   MOVE      ACST          PAcSt1
     C                   Z-ADD     DACO          PDAcO1
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
     C                   MOVEL     IMACNT        PSNDDS
      *                                                                                       240689
      ** Check Status of Account                                                              240689
      *                                                                                       240689
     C     DDRCO1        IFEQ      *BLANKS                                                    240689
      *                                                                                       240689
     C                   MOVE      RETB          WRETB                                        240689
      *                                                                                       240689
      ***Blocked*Debit*************************************************              240689 MD039547
     C**********         TESTB     '2'           WRETB                    48         240689 MD039547
     C******IN48         IFEQ      '1'                                               240689 MD039547
     C/COPY WNCPYSRC,FTH00543
     C**********         MOVE      'N'           OKSnd1                              240689 MD039547
     C**********         ADD       1             Idx                                 240689 MD039547
     C**********         MOVEL     'DDSND1'      FldNamXAr(Idx)                      240689 MD039547
     C**********         MOVEL     'FTM0014'     MsgIdXAr(Idx)                       240689 MD039547
     C/COPY WNCPYSRC,FTH00544
     C**********         ENDIF                                                       240689 MD039547
      *                                                                                       240689
      ** Bankrupt/Liquidated                                                                  240689
     C                   TESTB     '6'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   MOVE      'N'           OKSnd1                                       240689
     C                   ADD       1             Idx                                          240689
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)                               240689
     C                   MOVEL     'FTM0015'     MsgIdXAr(Idx)                                240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bad Debt                                                                             240689
     C                   TESTB     '7'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   MOVE      'N'           OKSnd1                                       240689
     C                   ADD       1             Idx                                          240689
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)                               240689
     C                   MOVEL     'FTM0016'     MsgIdXAr(Idx)                                240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Inactive                                                                             240689
     C**********         TESTB     '4'           WRETB                    48           240689 259576
     C******IN48         IFEQ      '1'                                                 240689 259576
     C**********         MOVE      'N'           OKSnd1                                       240689
     C*****OKSnd1        IFNE      'N'                                                 240689 259576
     C**********         MOVE      'W'           OKSnd1                                240689 259576
     C**********         ENDIF                                                         240689 259576
     C**********         ADD       1             WIdx                                  240689 259576
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDSND1'                          240689 259576
     C**********         EVAL      WMsgIDXAr(WIdx) = 'FTM0017'                         240689 259576
     C**********         ENDIF                                                         240689 259576
      *                                                                                       240689
      ** Referred Debit                                                                       240689
     C                   TESTB     '0'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKSnd1                                       240689
     C     OKSnd1        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKSnd1                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIdx                                         240689
     C                   EVAL      WFldNmXAr(WIdx) = 'DDSND1'                                 240689
     C                   EVAL      WMsgIDXAr(WIdx) = 'FTM0018'                                240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
     C                   ENDIF                                                                240689
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
     C**********         IF        *In89 = *On or                                             261791
     C**********                   RECI <> 'D'                                                261791
     C                   IF        *In89 = *On                                                261791
     C**********         MOVE      'FTVISENDER'  DBPGM                                        262272
     C**********         MOVE      'ACCNT'       DBFILE                                       262272
     C**********         MOVEL     '47'          DBASE                                        262272
     C**********         MOVEL     ACKYDS        DBKEY                                        262272
     C**********         EXSR      *PSSR                                                      262272
     C                   MOVE      'N'           OKSND1                                       262272
     C                   ADD       1             Idx                                          262272
     C                   MOVEL     'DDSND1'      FldNamXAr(Idx)                               262272
     C                   MOVEL     '45045850'    MsgIdXAr(Idx)                                262272
     C                   ENDIF
      *                                                                                       261791
     C                   IF        RECI <> 'D'                                                261791
     C                   MOVE      'N'           OKSND1                                       261791
     C                   ADD       1             Idx                                          261791
     C                   MOVEL     'DDSDN1'      FldNamXAr(Idx)                               261791
     C                   MOVEL     'MMA0377'     MsgIdXAr(Idx)                                261791
     C                   ENDIF                                                                261791
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSWSET - Check for valid SWIFT Character used.              *
      *                                                               *
      *****************************************************************
     C     SRSWSET       BEGSR
      *
     C                   MOVE      *BLANK        WError            1
     C                   MOVE      *On           *In94
      *
     C                   IF        Wfld(1) <> *BLANK
      *
     C                   Z-ADD     1             Qx                5 0
     C                   MOVEA     *Blanks       WTst
     C                   MOVEA     Wfld          WTst
      *
     C                   DOW       Qx <= 35
      *
     C                   IF        WTst(Qx) <> ' '
     C     WTst(Qx)      LOOKUP    SWCH                                   94
     C                   If        *In94 = *Off
     C                   MOVE      'Y'           WError
     C                   GOTO      ESRSWSET
     C                   EndIf
     C                   ENDIF
      *
     C                   ADD       1             Qx
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C     ESRSWSET      ENDSR
      *
      *****************************************************************
      /EJECT                                                                                  CRE008
      *****************************************************************                       CRE008
      *                                                               *                       CRE008
      *  SRODLChk - Overdraft Limit Check                             *                       CRE008
      *                                                               *                       CRE008
      *****************************************************************                       CRE008
                                                                                              CRE008
     C     SRODLChk      BEGSR                                                                CRE008
                                                                                              CRE008
     C                   EVAL      PInBranch = IMBRCA                                         CRE008
     C                   EVAL      PInCust   = IMCNUM                                         CRE008
     C                   EVAL      PInCurr   = IMCCY                                          CRE008
     C                   EVAL      PInACode  = IMACOD                                         CRE008
     C                   EVAL      PInASeqN  = IMACSQ                                         CRE008
     C                   Z-ADD     IPSMAM        PSetAmnt                                     CRE008
                                                                                              CRE008
     C                   CALLB     'RE101901'                                                 CRE008
                                                                                              CRE008
      ** Return Code                                                                          CRE008
                                                                                              CRE008
     C                   PARM      *BLANKS       PRetCode                                     CRE008
                                                                                              CRE008
      ** Input parameters                                                                     CRE008
      ** ----------------                                                                     CRE008
                                                                                              CRE008
      ** Branch Code                                                                          CRE008
      ** Customer                                                                             CRE008
      ** Account Code                                                                         CRE008
      ** Account Sequence                                                                     CRE008
      ** Settlement Amount (Debit Amount)                                                     CRE008
                                                                                              CRE008
     C                   PARM                    PInBranch                                    CRE008
     C                   PARM                    PInCust                                      CRE008
     C                   PARM                    PInCurr                                      CRE008
     C                   PARM                    PInACode                                     CRE008
     C                   PARM                    PInASeqN                                     CRE008
     C                   PARM                    PSetAmnt                                     CRE008
                                                                                              CRE008
      ** Ouput parameters                                                                     CRE008
      ** ----------------                                                                     CRE008
                                                                                              CRE008
      ** Branch                                                                               CRE008
      ** Customer                                                                             CRE008
      ** Account Code                                                                         CRE008
      ** Account Sequence                                                                     CRE008
      ** Retail Account No. of account in error                                               CRE008
                                                                                              CRE008
     C                   PARM                    POutBranch                                   CRE008
     C                   PARM                    POutCust                                     CRE008
     C                   PARM                    POutCurr                                     CRE008
     C                   PARM                    POutACode                                    CRE008
     C                   PARM                    POutASeqN                                    CRE008
     C                   PARM                    POutRetNo                                    CRE008
                                                                                              CRE008
     C                   IF        PRetCode <> *BLANKS and PRetCode <> '*ODLMTX'              CRE008
     C                   EVAL      DBPGM = 'RE101901'                                         CRE008
     C                   EXSR      *PSSR                                                      CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   IF        PRetCode = '*ODLMTX'                                       CRE008
     C                   EVAL      OKSND1 = 'W'                                               CRE008
     C                   EVAL      OKSMAM = 'W'                                               CRE008
     C                   EVAL      WIdx = WIdx + 1                                            CRE008
     C                   EVAL      WMsgIDXAr(WIdx) = 'FTA0131'                                CRE008
     C                   EVAL      WFldNmXAr(WIdx) = 'SSMAM'                                  CRE008
     C                   MOVE      POutCust      WkCustC                                      CRE008
     C                   MOVE      POutACode     WkACodeC                                     CRE008
     C                   MOVE      POutASeqN     WkASeqNC                                     CRE008
     C                   MOVE      POutRetNo     WkRetNoC                                     CRE008
                                                                                              CRE008
     C                   IF        POutRetNo = 0                                              CRE008
     C                   EVAL      WMsgDtXAr(WIdx) = POutBranch + '-' + WkCustC               CRE008
     C                              + '-' + POutCurr + '-' + WkACodeC                         CRE008
     C                              + '-' + WkASeqNC                                          CRE008
     C                   ELSE                                                                 CRE008
     C                   EVAL      WMsgDtXAr(WIdx) = POutBranch + '-' + WkCustC               CRE008
     C                              + '-' + POutCurr + '-' + WkACodeC                         CRE008
     C                              + '-' + WkASeqNC + '/' + WkRetNoC                         CRE008
     C                   ENDIF                                                                CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   ENDSR                                                                CRE008
      *****************************************************************                       CRE008
      /EJECT
     C/COPY FTCPYSRC,SFTSWFTCLE
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
      *                                                                                       240689
      ** Incoming Payments Lvl 1 Scrn file 2 details from                                     240689
      ** Incoming transactions - screen format                                                240689
     C                   PARM                    NwIP1AScnFmt                                 240689
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMode             6
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Multi-Branching Indicator
     C                   PARM                    BGMBIN            1
      *
      ** SDMMOD - Retail Banking Indicator
     C                   PARM                    BGRTBN            1
      *
      ** SDMMOD - Dealing Foreign Exchange
     C                   PARM                    BGDLFX            1
      *
      ** SDMMOD - Dealing Money Market
     C                   PARM                    BGDLMM            1
      *
      ** SDRETL - Retail Account required ?
     C                   PARM                    BMRANR            1
      *
      ** SDBANK - Banks Detail
     C                   PARM                    BJSBRC            3
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                              CRE008
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE008
     C                   PARM                    WFldNmXAr                                    CRE008
     C                   PARM                    WMsgIDXAr                                    CRE008
     C                   PARM                    WMsgDtXAr                                    CRE008
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Sender Currency
     C                   PARM                    PSendrCcy
      *
      ** Sender's Account Type
     C                   PARM                    PAtyp1
      *
      ** Sender's Account Status
     C                   PARM                    PAcSt1
      *
      ** Sender's Date Account Opened
     C                   PARM                    PDAcO1
      *
      ** Sender's Full account
     C                   PARM                    PSNDDS
      *                                                                         CFT014
      ** Sender's SWIFT ID                                                      CFT014
     C                   PARM                    PSNDCSID         12            CFT014
      *                                                                         CFT014
      ** Sender's Country of location                                           CFT014
     C                   PARM                    PSNDCOLC          2            CFT014
      *
                                                                                              CRE008
      ** Access SCSARDPD to determint if CRE008 is installed                                  CRE008
                                                                                              CRE008
     C                   EVAL      CRE008 = 'N'                                               CRE008
     C                   CALLB     'AOSARDR0'                                                 CRE008
     C                   PARM      *BLANKS       PRTCD             7                          CRE008
     C                   PARM      '*VERIFY'     POPTN             7                          CRE008
     C                   PARM      'CRE008'      PSARD             6                          CRE008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE008
                                                                                              CRE008
      ** An NRF (No Record Found) return code is valid.                                       CRE008
      ** Issue database error only for error return codes.                                    CRE008
                                                                                              CRE008
     C                   IF        PRTCD <> *BLANKS AND                                       CRE008
     C                             PRTCD <> '*NRF   '                                         CRE008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE008
     C                   EVAL      DBASE = 48                                                 CRE008
     C                   EVAL      DBKEY = 'CRE008'                                           CRE008
     C                   EXSR      *PSSR                                                      CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   IF        PRTCD = *BLANKS                                            CRE008
     C                   EVAL      CRE008 = 'Y'                                               CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C/COPY WNCPYSRC,FTH00545
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
**  SWCH
ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890/-?:().,'+abcdefghijklmnopqrstuvwxyz                     255286
