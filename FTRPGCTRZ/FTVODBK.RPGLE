     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate order bank')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVODBK  - Validate Ordering Bank                            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD052577           Date 17Jan19               *
      *  Prev Amend No. 259576             Date 02Apr14               *
      *                 MD021318           Date 26Jul13               *
      *                 MD039547           Date 20Sep16               *
      *                 MD046248           Date 27Oct17               *
      *                 MD037223           Date 20Jul17               *
      *                 MD019914           Date 10Apr13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 247142             Date 31May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 240689             Date 12Jul06               *
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
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 15Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052577 - Cannot insert Outgoing Payment due to false block *
      *             Dr error                                          *
      *  259576 - Remove warning message for Inactive accounts.       *
      *           Applied for MD-26109                                *
      *  MD021318 - OPAY allowed input of account with block debit    *
      *           - Fix is to condition CSD089 overridable error      *
      *             changes when input is from HATS screen            *
      *  MD039547 - Referred account is not properly validated.       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037223 - Retrieve DACO for all types of account to be used *
      *             in validation.                                    *
      *  MD019914 - Serious midas error occured                       *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning.                  *
      *           Apply fixes 232151 and 210654. Same fix with 240689.*
      *  232151 - DBASE error when inserting an inactive account.     *
      *  210654 - Check status of Account.                            *
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
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. (Recompiled)            *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
 
     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMAF)
 
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
      *                                                                                       240689
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     240689
      *                                                                                       240689
      ** Array of fields with Warning.                                                        240689
      *                                                                                       240689
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        240689
      *                                                                                       240689
      ** Array of Warning message IDs                                                         240689
      *                                                                                       240689
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)                      240689
      *                                                                                       240689
      ** Array of Warning message data.                                                       240689
      *                                                                                       240689
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      * External DS for Midas modules details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
 
      ** External data structure for Nostro customer number
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External data structure for Nostro customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Data structure redefining Account key fields
     D**********       DS            18                                                       CGL029
     D                 DS                                                                     CGL029
     D*K#CNUM***               1      6  0                                                    CSD027
     D K#CNUM                  1      6                                                       CSD027
     D WCNUMA                  1      6
     D K#CCY                   7      9
     D K#ACOD                 10     19  0                                                    CGL029
     D K#ACSQ                 20     21  0                                                    CGL029
     D K#BRCA                 22     24                                                       CGL029
     D AKEYF                   1     24                                                       CGL029
     D*K#ACOD***              10     13  0                                                    CGL029
     D*K#ACSQ***              14     15  0                                                    CGL029
     D*K#BRCA***              16     18                                                       CGL029
     D*AKEYF****               1     18                                                       CGL029
 
      * Data structure redefining Ordering Bank details
     D*SORBKDS**       DS            12                                                       CGL029
     D SORBKDS         DS                                                                     CGL029
     D  ORNS                   1      2
     D  ORNM                   1      6
     D  ORRT                   1     10
     D  ORCD                   7     16                                                       CGL029
     D  ORSQ                  17     18                                                       CGL029
     D**ORCD****               7     10                                                       CGL029
     D**ORSQ****              11     12                                                       CGL029
 
     D  OR02R                  3     12
     D  OR10R                 11     12
 
      *  Define full account to be passed for FT IMM update
     D*#ORBDS***       DS            18                                                       CGL029
     D #ORBDS          DS                                                                     CGL029
     D**IMCNUM**               1      6  0                                                    CSD027
     D  IMCNUM                 1      6                                                       CSD027
     D  IMCYY                  7      9
     D  IMACOD                10     19  0                                                    CGL029
     D  IMACSQ                20     21  0                                                    CGL029
     D  IMBRCA                22     24                                                       CGL029
     D**IMACOD**              10     13  0                                                    CGL029
     D**IMACSQ**              14     15  0                                                    CGL029
     D**IMBRCA**              16     18                                                       CGL029
      *
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
      *                                                                                       240689
     D WIx             S              3P 0                                                    240689
      *                                                                                       240689
      ** Index for arrays of warning message ids etc.                                         240689
      *                                                                                       240689
 
     D*C#ACCD***       S              4                                                       CGL029
     D C#ACCD          S             10                                                       CGL029
     D C#ACSN          S              2
     D C#BRCA          S              3
     D C#CSSN          S             10
     D C#CUST          S              6
     D C#CYCD          S              3
     D C#KEY1          S             10
     D C#KYST          S              7
     D C#NONB          S              2
     D C#OPTN          S              7
     D C#PNOI          S              1
     D C#RTCD          S              7
 
     D WNUMA           S              6
     D WNUML           S              7P 0
     D*WCODA****       S              4                                                       CGL029
     D*WCODL****       S              5  0                                                    CGL029
     D WCODA           S             10                                                       CGL029
     D WCODL           S             11  0                                                    CGL029
     D WRETA           S             10
     D WRETL           S             11  0
     D WSEQA           S              2
     D WSEQL           S              3  0
     D PMode           S              6A                                                    MD021318
 
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
     C                   Eval      WFldNmXAr = *Blanks                                        240689
     C                   Eval      WMsgIDXAr  = *Blanks                                       240689
     C                   Eval      WMsgDtaXAr = *Blanks                                       240689
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0                                                    240689
 
      * Order Customer
      *
     C                   Exsr      VORDBNK
 
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKOrbk = 'N' or
     C                             OKOrbb = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
      *
     C                   RETURN
      ******************************************************************
      /EJECT
     C******************************************************************
     C* VORDBNK - VALIDATION OF ORDERING BANK                          *
      ******************************************************************
     C*
     C     VORDBNK       BEGSR
 
     C                   Eval      SORBKDS = SORBK
 
      * Check for entry of '?'
     C                   Eval      *IN90 = *Off
     C     '?'           Scan      SORBK                                  90
 
      * If '?' found....
     C                   If        *IN90 = *On
      * Send error to screen
     C                   Move      'N'           OKOrbk
     C                   Add       1             Idx
     C                   Movel     'SORBK'       FldNamXAr(Idx)
     C                   Movel     'MMA0963'     MsgIdXAr(Idx)
     C                   End
 
     C                   BITOFF    '01234567'    WRETB             1                          240689
     C**********         If        OKOrbk = 'Y'                                             MD039547
     C                   If        OKOrbk <> 'N'                                            MD039547
 
     C                   Eval      @ORBT = *Blank
     C                   Eval      @ACST4 = *Blank
     C                   Eval      @OBOPN = 0
 
     C                   If        SORBK = *Blanks
 
      * If Blank and Ordering Customer is type A, C or S error
 
     C                   If        @ORCT = 'A' or
     C                             @ORCT = 'C' or
     C                             @ORCT = 'S'
      * Send error to screen
     C                   Move      'N'           OKOrbk
     C                   Move      'N'           OKOrbb
     C                   Add       1             Idx
     C                   Movel     'SORBK'       FldNamXAr(Idx)
     C                   Movel     'MMA0964'     MsgIdXAr(Idx)
     C                   End
 
     C                   Eval      @ORBT = *Blanks
 
     C                   Else
     C**********         If        OKOrbk = 'Y'                                             MD039547
     C                   If        OKOrbk <> 'N'                                            MD039547
 
     C* If less than 3 char have been entered could be a NOSTRO
     C                   If        OR02R = *Blanks and
     C                             SORBB = *Blanks
     C                   Exsr      VNOSTRO
 
     C                   Else
     C* If less than 11 char have been entered could be a RETAIL
     C                   If        OR10R = *Blanks and
     C                             SORBB = *Blanks
     C                   Exsr      VRETAIL
 
     C                   Else
      * Validate for Partial account
     C                   Exsr      VPARTIAL
 
     C                   End
     C                   End
     C                   End
     C                   End
     C                   End
 
      * If a valid account has been entered,
      * store full account details for FT Transaction Status File
      * record update.
     C**********         If        OKOrbk = 'Y'                                             MD039547
     C                   If        OKOrbk <> 'N'                                            MD039547
 
     C                   If        @ORBT = 'N' or
     C                             @ORBT = 'R' or
     C                             @ORBT = 'P'
     C                   Eval      IMCNUM = K#CNUM
     C                   Eval      IMCYY = @CCY
     C                   Eval      IMACOD = K#ACOD
     C                   Eval      IMACSQ = K#ACSQ
     C                   Eval      IMBRCA = K#BRCA
     C                   Eval      @ORBDS = #ORBDS
     C                   End
      *
      * If MT202 keyword exists in field 1 of Ordering Customer then the
      * Ordering Bank must have an account whose customer is a bank.
      *
      * ONLY required if SORC2/3/4 blank
      *
     C                   If        SORC1 = 'MT202' and
     C                             SORC2 = *Blanks
 
     C                   If        @ORBT = 'N' or
     C                             @ORBT = 'R' or
     C                             @ORBT = 'P'
      *
     C                   CALLB     'AOCUSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      WCNUMA        C#KEY1
     C                   Parm      *Blanks       C#KYST
     C     SDCUST        Parm      SDCUST        DSSDY
      *
     C                   If        C#RTCD <> *Blanks
     C                   Exsr      *PSSR
     C                   Else
      *
      * Check the bank/non-bank indicator.
      * and customer not part of the branch network
      *
     C                   If        BBBNBI <> 'Y' and
     C                             BBBSIN = *Blanks
      * Send error to screen
     C                   Move      'N'           OKOrbk
     C                   Move      'N'           OKOrbb
     C                   Add       1             Idx
     C                   Movel     'SORBK'       FldNamXAr(Idx)
     C                   Movel     'MMA0969'     MsgIdXAr(Idx)
     C                   End
     C                   End
      *
     C                   End
     C                   End
      *
     C                   End
 
      * If Ordering Bank entered and Ordering Customer an
      * account then error.
      *
     C                   If        OKOrbk = 'Y' and
     C                             OKOrc1 = 'Y' and
     C                             @ORBT <> *Blanks
      *
      * If Ordering Customer not Address, Customer or SWIFT error
      *
     C                   If        @ORCT <> 'A' and
     C                             @ORCT <> 'S' and
     C                             @ORCT <> 'C'
      *
      * Send error to screen
     C                   Move      'N'           OKOrbk
     C                   Move      'N'           OKOrbb
     C                   Add       1             Idx
     C                   Movel     'SORBK'       FldNamXAr(Idx)
     C                   Movel     'FTM2352'     MsgIdXAr(Idx)
      *
     C                   End
     C                   End
      *                                                                                       240689
      ** Check Status of Account                                                              240689
      *                                                                                       240689
     C*****OKOrbk        IFEQ      'Y'                                               240689 MD039547
     C     OKOrbk        IFNE      'N'                                                      MD039547
      *                                                                                       240689
      ** Blocked Debit                                                                        210654
     C                   TESTB     '2'           WRETB                    48                  210654
     C     *IN48         IFEQ      '1'                                                        210654
     C**********         MOVE      'N'           OKOrbk                                210654 CSD089
     C**********         MOVE      'N'           OKOrbb                                210654 CSD089
     C**********         ADD       1             Idx                                   210654 CSD089
     C**********         MOVEL     'SORBK'       FldNamXAr(Idx)                        210654 CSD089
     C**********         MOVEL     'FTM0014'     MsgIdXAr(Idx)                         210654 CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   MOVE      'N'           OKOrbk                                     MD021318
     C                   MOVE      'N'           OKOrbb                                     MD021318
     C                   ADD       1             Idx                                        MD021318
     C                   MOVEL     'SORBK'       FldNamXAr(Idx)                             MD021318
     C                   MOVEL     'FTM0014'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   MOVE      'W'           OKOrbk                                       CSD089
     C                   MOVE      'W'           OKOrbb                                       CSD089
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SORBK'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0014'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   ENDIF                                                                210654
      *                                                                                       210654
      ** Bankrupt/Liquidated                                                                  240689
      *                                                                                       240689
     C                   TESTB     '6'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKOrbk                                240689 CSD089
     C**********         MOVE      'N'           OKOrbb                                240689 CSD089
     C**********         ADD       1             Idx                                   240689 CSD089
     C**********         MOVEL     'SORBK'       FldNamXAr(Idx)                        240689 CSD089
     C**********         MOVEL     'FTM0015'     MsgIdXAr(Idx)                         240689 CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   MOVE      'N'           OKOrbk                                     MD021318
     C                   MOVE      'N'           OKOrbb                                     MD021318
     C                   ADD       1             Idx                                        MD021318
     C                   MOVEL     'SORBK'       FldNamXAr(Idx)                             MD021318
     C                   MOVEL     'FTM0015'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   MOVE      'W'           OKOrbk                                       CSD089
     C                   MOVE      'W'           OKOrbb                                       CSD089
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SORBK'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0015'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bad Debt                                                                             240689
      *                                                                                       240689
     C                   TESTB     '7'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKOrbk                                240689 CSD089
     C**********         MOVE      'N'           OKOrbb                                240689 CSD089
     C**********         ADD       1             Idx                                   240689 CSD089
     C**********         MOVEL     'SORBK'       FldNamXAr(Idx)                        240689 CSD089
     C**********         MOVEL     'FTM0016'     MsgIdXAr(Idx)                         240689 CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   MOVE      'N'           OKOrbk                                     MD021318
     C                   MOVE      'N'           OKOrbb                                     MD021318
     C                   ADD       1             Idx                                        MD021318
     C                   MOVEL     'SORBK'       FldNamXAr(Idx)                             MD021318
     C                   MOVEL     'FTM0016'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   MOVE      'W'           OKOrbk                                       CSD089
     C                   MOVE      'W'           OKOrbb                                       CSD089
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SORBK'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0016'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Inactive                                                                             240689
      *                                                                                       240689
     C**********         TESTB     '4'           WRETB                    48           240689 259576
     C******IN48         IFEQ      '1'                                                 240689 259576
     C**********         MOVE      'N'           OKOrbk                                       240689
     C**********         MOVE      'N'           OKOrbb                                       240689
     C*****OKOrbk        IFNE      'N'                                                 240689 259576
     C**********         MOVE      'W'           OKOrbk                                240689 259576
     C**********         ENDIF                                                         240689 259576
     C*****OKOrbb        IFNE      'N'                                                 240689 259576
     C**********         MOVE      'W'           OKOrbb                                240689 259576
     C**********         ENDIF                                                         240689 259576
     C**********         ADD       1             WIx                                   240689 259576
     C**********         MOVEL     'SORBK'       WFldNmXAr(WIx)                        240689 259576
     C**********         MOVEL     'FTM0017'     WMsgIdXAr(WIx)                        240689 259576
     C**********         ENDIF                                                         240689 259576
      *                                                                                       240689
      ** Referred Debit                                                                       240689
      *                                                                                       240689
     C                   TESTB     '0'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKOrbk                                       240689
     C**********         MOVE      'N'           OKOrbb                                       240689
     C     OKOrbk        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKOrbk                                       240689
     C                   ENDIF                                                                240689
     C     OKOrbb        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKOrbb                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'SORBK'       WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0018'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
     C                   ENDIF                                                                240689
      *
     C                   ENDSR
     C*
     C************************************************************
     C* END OF ORDERING BANK VALIDATION
     C************************************************************
     C/EJECT
     C******************************************************************
     C* VNOSTRO - VALIDATION OF NOSTRO                                 *
      ******************************************************************
     C*
     C     VNOSTRO       BEGSR
 
     C                   CALLB     'AONOSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      *Blanks       C#CUST
     C                   Parm      SSMCY         C#CYCD
     C                   Parm      *Blanks       C#ACCD
     C                   Parm      *Blanks       C#ACSN
     C                   Parm      ORNS          C#NONB
     C                   Parm      *Blanks       C#BRCA
     C                   Parm      *Blanks       C#CSSN
     C                   Parm      *Blanks       C#PNOI
     C     SDNOST        Parm      SDNOST        DSFDY
 
     C                   If        C#RTCD = *Blanks
      * Move new SYNON field names to old field names
     C                   Move      A7CUST        K#CNUM
     C                   Move      A7ACCD        K#ACOD
     C                   Move      A7ACSN        K#ACSQ
     C                   Move      A7BRCD        K#BRCA
     C                   Else
      * Send error to screen
     C                   Move      'N'           OKOrbk
     C                   Move      'N'           OKOrbb
     C                   Add       1             Idx
     C                   Movel     'SORBK'       FldNamXAr(Idx)
     C                   Movel     'MMA0965'     MsgIdXAr(Idx)
     C                   End
 
     C**********         If        OKOrbk = 'Y'                                             MD039547
     C                   If        OKOrbk <> 'N'                                            MD039547
     C                   Eval      @ORBT = 'N'
 
      * Find if retail
     C                   Eval      K#CCY = SSMCY
     C                   Eval      @CCY = SSMCY
      * Read Account
     C     AKEY          CHAIN     ACCNTABF                           90
     C                   If        *IN90 = *On or
     C                             RECI <> 'D'
     C                   Move      'FTVODBK'     DBPGM
     C                   Move      'ACCNT  '     DBFILE
     C                   Eval      DBASE = 14
     C                   Movel     AKEYF         DBKEY
     C                   Exsr      *PSSR
     C                   Else                                                                BUG4581
      **Check*for*block*debits*on*account******************************             BUG4581 MD039547
     C                   MOVE      RETB          WRETB                                        240689
     C**********         TESTB     '2'           RETB                     51        BUG4581 MD039547
     C**********         If        *in51 = *ON                                      BUG4581 MD039547
     C**********         Move      'N'           OKOrbk                               BUG4581 CSD089
     C**********         Add       1             Idx                                  BUG4581 CSD089
     C**********         Movel     'SORBK'       FldNamXAr(Idx)                       BUG4581 CSD089
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                        BUG4581 CSD089
     C**********         Move      'W'           OKOrbk                              CSD089 MD039547
     C**********         Add       1             WIx                                 CSD089 MD039547
     C**********         Movel     'SORBK'       WFldNmXAr(WIx)                      CSD089 MD039547
     C**********         Movel     'FTM0014'     WMsgIdXAr(WIx)                      CSD089 MD039547
     C**********         End                                                        BUG4581 MD039547
     C                   End
 
     C                   Eval      @ACST4 = ACST
 
     C**********         If        ATYP = 'R'                                               MD037223
     C                   Eval      @OBOPN = DACO
     C**********         End                                                                MD037223
     C                   End
 
     C                   ENDSR
     C************************************************************
     C* END OF NOSTRO VALIDATION
     C************************************************************
     C/EJECT
     C******************************************************************
     C* VRETAIL - VALIDATION OF RETAIL ACCOUNT                         *
      ******************************************************************
 
     C     VRETAIL       BEGSR
 
     C                   Movel     ORRT          WRETL
     C                   Movel     WRETL         WRETA
     C                   If        ORRT = WRETA
     C                   Move      ORRT          ACNO
     C     ACNO          Chain     ACNUMAF                            90
     C                   Eval      @CCY = CCY
     C                   End
 
      * Check to see if retail account number is allowed
 
     C                   If        BMRANR = 'N'
      * Send error to screen
     C                   Move      'N'           OKOrbk
     C                   Move      'N'           OKOrbb
     C                   Add       1             Idx
     C                   Movel     'SORBK'       FldNamXAr(Idx)
     C                   Movel     'MMA0943'     MsgIdXAr(Idx)
 
     C                   Else
     C                   If        ORRT <> WRETA or
     C                             RECI <> 'D'  or
     C                             *IN90 = *On
      * Send error to screen
     C                   Move      'N'           OKOrbk
     C                   Move      'N'           OKOrbb
     C                   Add       1             Idx
     C                   Movel     'SORBK'       FldNamXAr(Idx)
     C                   Movel     'MMA0966'     MsgIdXAr(Idx)
     C                   End
     C                   End
 
     C**********         If        OKOrbk = 'Y'                                             MD039547
     C                   If        OKOrbk <> 'N'                                            MD039547
     C                   MOVE      RETB          WRETB                                        240689
      **Check*for*block*debits*on*account******************************             BUG4581 MD039547
     C**********         TESTB     '2'           RETB                     51        BUG4581 MD039547
     C**********         If        *in51 = *ON                                      BUG4581 MD039547
     C**********         Move      'N'           OKOrbk                               BUG4581 CSD089
     C**********         Add       1             Idx                                  BUG4581 CSD089
     C**********         Movel     'SORBK'       FldNamXAr(Idx)                       BUG4581 CSD089
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                        BUG4581 CSD089
     C**********         IF         Pmode = '*SIN  '                               MD021318 MD052577
     C**********         Move      'N'           OKOrbk                            MD021318 MD052577
     C**********         Add       1             Idx                               MD021318 MD052577
     C**********         Movel     'SORBK'       FldNamXAr(Idx)                    MD021318 MD052577
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                     MD021318 MD052577
     C**********         ELSE                                                      MD021318 MD052577
     C**********         Move      'W'           OKOrbk                              CSD089 MD039547
     C**********         Add       1             WIx                                 CSD089 MD039547
     C**********         Movel     'SORBK'       WFldNmXAr(WIx)                      CSD089 MD039547
     C**********         Movel     'FTM0014'     WMsgIdXAr(WIx)                      CSD089 MD039547
     C**********         ENDIF                                                     MD021318 MD052577
     C**********         End                                                        BUG4581 MD039547
 
     C                   If        @CCY <> SSMCY
      * Send error to screen
     C                   Move      'N'           OKOrbk
     C                   Move      'N'           OKOrbb
     C                   Add       1             Idx
     C                   Movel     'SORBK'       FldNamXAr(Idx)
     C                   Movel     'MMA0967'     MsgIdXAr(Idx)
     C                   End
     C                   End
 
     C                   If        OKOrbk = 'Y'
     C                             OR OKOrbk = 'W'                                          MD019914
 
     C                   Eval      K#CNUM = CNUM
     C                   Eval      K#CCY= @CCY
     C                   Eval      K#ACOD = ACOD
     C                   Eval      K#ACSQ = ACSQ
     C                   Eval      K#BRCA = BRCA
 
     C                   Eval      @ORBT = 'R'
     C                   Eval      @ACST4 = ACST
 
     C**********         If        ATYP = 'R'                                               MD037223
     C                   Eval      @OBOPN = DACO
     C**********         End                                                                MD037223
     C                   End
 
     C                   ENDSR
     C************************************************************
     C* END OF RETAIL ACCOUNT VALIDATION
     C************************************************************
     C/EJECT
     C*****************************************************************
     C*  VPARTIAL - PARTIAL ACCOUNT VALIDATION
     C*****************************************************************
     C*
     C     VPARTIAL      BEGSR
 
     C***********        Movel     ORNM          WNUML                                        CSD027
     C***********        Movel     WNUML         WNUMA                                        CSD027
     C                   Movel     ORCD          WCODL
     C                   Movel     WCODL         WCODA
     C                   Movel     ORSQ          WSEQL
     C                   Movel     WSEQL         WSEQA
 
     C***********        If        ORNM = WNUMA and                                           CSD027
     C***********                  ORCD = WCODA and                                           CSD027
     C                   IF        ORCD = WCODA and                                           CSD027
     C                             ORSQ = WSEQA
     C                   Move      ORNM          K#CNUM
     C                   Eval      K#CCY = SSMCY
     C                   Eval      @CCY = SSMCY
     C                   Move      ORCD          K#ACOD
     C                   Move      ORSQ          K#ACSQ
 
     C                   If        @MBIN = 'Y'
     C                   Eval      K#BRCA = SORBB
     C                   Else
     C                   Eval      K#BRCA = BJSBRC
     C                   Eval      SORBB = BJSBRC
     C                   End
 
     C     AKEY          CHAIN     ACCNTABF                           90
     C                   End
 
     C***********        If        ORNM <> WNUMA or                                          CSD027
     C***********                  ORCD <> WCODA or                                          CSD027
     C                   If        ORCD <> WCODA or                                          CSD027
     C                             ORSQ <> WSEQA or
     C                             *IN90 = *On  or
     C                             RECI <> 'D'
      * Send error to screen
     C                   Move      'N'           OKOrbk
     C                   Move      'N'           OKOrbb
     C                   Add       1             Idx
     C                   Movel     'SORBK'       FldNamXAr(Idx)
     C                   Movel     'MMA0968'     MsgIdXAr(Idx)
     C                   End
      *
     C                   If        OKOrbk = 'Y' and
     C                             OKOrbb = 'Y'
      **Check*for*block*debits*on*account******************************             BUG4581 MD039547
     C**********         TESTB     '2'           RETB                     51        BUG4581 MD039547
     C**********         If        *in51 = *ON                                      BUG4581 MD039547
     C**********         Move      'N'           OKOrbk                               BUG4581 CSD089
     C**********         Add       1             Idx                                  BUG4581 CSD089
     C**********         Movel     'SORBK'       FldNamXAr(Idx)                       BUG4581 CSD089
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                        BUG4581 CSD089
     C**********         IF         Pmode = '*SIN  '                               MD021318 MD052577
     C**********         Move      'N'           OKOrbk                            MD021318 MD052577
     C**********         Add       1             Idx                               MD021318 MD052577
     C**********         Movel     'SORBK'       FldNamXAr(Idx)                    MD021318 MD052577
     C**********         Movel     'FTM0014'     MsgIdXAr(Idx)                     MD021318 MD052577
     C**********         ELSE                                                      MD021318 MD052577
     C**********         Move      'W'           OKOrbk                              CSD089 MD039547
     C**********         Add       1             WIx                                 CSD089 MD039547
     C**********         Movel     'SORBK'       WFldNmXAr(WIx)                      CSD089 MD039547
     C**********         Movel     'FTM0014'     WMsgIdXAr(WIx)                      CSD089 MD039547
     C**********         ENDIF                                                     MD021318 MD052577
     C**********         End                                                        BUG4581 MD039547
     C                   Eval      @ORBT = 'P'
     C                   Eval      @ACST4 = ACST
     C                   MOVE      RETB          WRETB                                        240689
      *
     C**********         If        ATYP = 'R'                                               MD037223
     C                   Eval      @OBOPN = DACO
     C**********         End                                                                MD037223
     C                   End
     C*
     C                   ENDSR
     C*
     C************************************************************
     C* END OF PARTIAL ADDRESS VALIDATION
     C************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      ** Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInPrim
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtaXAr                                   240689
 
      ** OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      ** Screen Input Function                                                              MD021318
     C                   PARM                    PMode                                      MD021318
 
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Read SDRETLPD for retail details
      *  (database error handling done in access program)
      * Only if RETAIL switched on.
     C                   If        BGRTBN = 'Y'
     C                   CALLB     'AORETLR0'
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDRETL        Parm      SDRETL        DSFDY
     C                   End
 
      * Key list for account validation
     C     AKEY          KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#CCY
     C                   KFLD                    K#ACOD
     C                   KFLD                    K#ACSQ
     C                   KFLD                    K#BRCA
     C*
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
