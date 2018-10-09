     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate senders correspondent')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVSNCR  - Validate Sender's Correspondent                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD039547           Date 20Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD037223           Date 20Jul17               *
      *                 MD020347           Date 08May13               *
      *                 CFT120             Date 28Sep12               *
      *                 AR750736           Date 22Oct12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 GBO008             Date 24Aug06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240689             Date 13Jul06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG4581            Date 20Oct04               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 216150             Date 20May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 200462             Date 11Jun02               *
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
      *                 CAP031  *CREATE    Date 12Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039547 - Referred account is not properly validated.       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037223 - Retrieve DACO for all types of account to be used *
      *             in validation.                                    *
      *  MD020347 - A serious midas error has occurred upon hitting   *
      *             complete button. Incorrect index was used for     *
      *             warning message ID array for FTM0019.             *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  AR750736 - Blocked debit account is debited in a FT          *
      *             transaction. An error message will be displayed   *
      *             when a blocked debit account is about to be       *
      *             debited in a FT transaction. (Child: AR750737)    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate.(Recompile)     *
      *  GBO008 - Settlement Type 13 in FT Outgoing Payment Maint.    *
      *         - Added core hooks: FTVSNCRD01, FTVSNCRC01,           *
      *           FTVSNCRC02.                                         *
      *  240689 - Applied fix 210654 + additional changes by 232151.  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4581- Check for block debits/credits                      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  216150 - Database error when inserting OP and using '?' in   *
      *           Sender's Correspondent field.  A '?' in the Sender's*
      *           Correspondent field should be invalid.              *
      *  200462 - If an incorrect nostro was entered in the sender's  *
      *           correspondent field, the user needs to sign off     *
      *           from its current session and get a completely new   *
      *           session before he can enter the correct transaction.*
      *           Reset *IN90 to '0' before calling AONOSTR0 to avoid *
      *           receiving the error message if entry was correct.   *
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
 
      /COPY WNCPYSRC,FTVSNCRD01                                                               GBO008
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      /COPY FTCPYSRC,SFTVALCSLE
 
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
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      * External DS for Midas SD Retail Details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
 
      * External data structure for Nostro customer number
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
     D  NLOC                  29     31
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DST1DS          DS            35
     D  NCUR                   1      3
     D  DSCY                   7      9
 
      *  Define full account to be passed for FT IMM update
     D*#SNCDS***       DS            18                                                       CGL029
     D #SNCDS          DS                                                                     CGL029
     D**IMCNUM**               1      6  0                                                    CSD027
     D  IMCNUM                 1      6A                                                      CSD027
     D  IMCCY                  7      9
     D  IMACOD                10     19  0                                                    CGL029
     D  IMACSQ                20     21  0                                                    CGL029
     D  IMBRCA                22     24                                                       CGL029
     D**IMACOD**              10     13  0                                                    CGL029
     D**IMACSQ**              14     15  0                                                    CGL029
     D**IMBRCA**              16     18                                                       CGL029
 
      * Sender's Correspondent
     D SSNCODS         DS
     D  SNOS                   1      2
     D  S02R                   3     10
     D  SRET                   1     10
 
      * Data structure redefining Account key fields
     D*AKEYF****       DS            18                                                       CGL029
     D AKEYF           DS                                                                     CGL029
     D**K#CNUM**               1      6  0                                                    CSD027
     D  K#CNUM                 1      6A                                                      CSD027
     D  WCNUMA                 1      6
     D  K#CCY                  7      9
     D  K#ACOD                10     19  0                                                    CGL029
     D  WACODA                10     19                                                       CGL029
     D  K#ACSQ                20     21  0                                                    CGL029
     D  WACSQA                20     21                                                       CGL029
     D  K#BRCA                22     24                                                       CGL029
     D**K#ACOD**              10     13  0                                                    CGL029
     D**WACODA**              10     13                                                       CGL029
     D**K#ACSQ**              14     15  0                                                    CGL029
     D**WACSQA**              14     15                                                       CGL029
     D**K#BRCA**              16     18                                                       CGL029
 
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
      ** Index for arrays of warning message ids etc                                          240689
 
     D K#ACNO          S                   LIKE(ACNO)
 
     D*C#ACCD***       S              4                                                       CGL029
     D C#ACCD          S             10                                                       CGL029
     D C#ACSN          S              2
     D C#BRCD          S              3
     D C#CSSN          S             10
     D C#CUST          S              6
     D C#CYCD          S              3
     D C#NONB          S              2
     D C#OPTN          S              7
     D C#PNOI          S              1
     D C#RTCD          S              7
 
     D WRETA           S             10
     D WRETL           S             11P 0
     D R               S              2  0
     D Q               S              2  0
 
      * This prog only
     D WCURR           S              5
 
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
 
      * Initialization
     C                   Eval      RetCodeIn = *BlankS
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *Blanks                                        240689
     C                   Eval      WMsgIDXAr  = *Blanks                                       240689
     C                   Eval      WMsgDtaXAr = *Blanks                                       240689
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0                                                    240689
 
      * Sender's Correspondent
     C                   Exsr      VSNDCOR
 
      * If an error was found, set the return code appropriately
     C                   If        OKSnco = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD089
     C                   If        OKSnco = 'W'                                               CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   End                                                                  CSD089
     C                   End
 
      * RETURN
 
     C                   RETURN
      ******************************************************************
      /EJECT
     C******************************************************************
     C* VSNDCOR - VALIDATION OF SENDER'S CORRESPONDENT                 *
      ******************************************************************
     C*
     C     VSNDCOR       BEGSR
 
     C                   Eval      @SNCT = *Blank
     C                   Eval      @ACST2 = *Blank
     C                   Eval      @SCOPN = 0
     C                   Eval      DST1DS = SDST1
     C                   Eval      SSNCODS = SSNCO
     C                   BITOFF    '01234567'    WRETB             1                          240689
 
     C                   If        SSNCO = *Blanks
 
      * Error if blank and destination is of type C , S or A
     C                   If        @DSTT = 'C' or
     C                             @DSTT = 'A' or
     C                             @DSTT = 'S'
      * Send error to screen
     C                   Move      'N'           OKSnco
     C                   Add       1             Idx
     C                   Movel     'SSNCO '      FldNamXAr(Idx)
     C                   Movel     'MMA0957'     MsgIdXAr(Idx)
     C                   End
 
     C                   Eval      @SNCT = *Blanks
 
     C                   Else
      * No entry allowed if Destination is Full Account, NOSTRO or
      * Retail Account No. and Pay Currency = Dest. Type Currency
     C                   If        @DSTT = 'F'    and
     C                             SPCCY = NCUR   or
     C                             @DSTT = 'R'    and
     C                             SPCCY = @COCYY or
     C                             @DSTT = 'G'    and
     C                             SPCCY = DSCY
      * Send error to screen
     C                   Move      'N'           OKSnco
     C                   Add       1             Idx
     C                   Movel     'SSNCO'       FldNamXAr(Idx)
     C                   Movel     'MMA0958'     MsgIdXAr(Idx)
     C                   End
 
      ** Check if Sender's Correspondent field contains '?'.                                  216150
      ** If it does, display error message:                                                   216150
      ** "Standing Data enquiry processing not allowed for this field."                       216150
      *                                                                                       216150
     C                   If        Idx = 0                                                    216150
     C                   Move      '0'           *IN18                                        216150
     C     '?'           Scan      SSNCO                                  18                  216150
      *                                                                                       216150
     C                   If        *In18 = *On                                                216150
     C                   Move      'N'           OKSnco                                       216150
     C                   Add       1             Idx                                          216150
     C                   Movel     'SSNCO'       FldNamXAr(Idx)                               216150
     C                   Movel     'FTM6001'     MsgIdXAr(Idx)                                216150
     C                   Endif                                                                216150
      *                                                                                       216150
     C                   Endif                                                                216150
      *                                                                                       216150
     C/COPY WNCPYSRC,FTVSNCRC01                                                               GBO008
      * If only 2 char entered must be a NOSTRO number
     C                   If        Idx = 0
 
     C                   If        S02R = *Blanks
     C                   EXSR      VNOSTRO
 
     C                   Else
     C                   Exsr      VRETAIL
     C                   End
 
     C                   End
 
      * Set pay location
     C*
     C                   If        @SNCT <> 'R' and
     C                             @SNCT <> 'N'
     C                   Eval      @PLOC = BJSLCD
     C                   Eval      @NOWRK = 'S'
     C                   End
     C                   End
 
      * If a valid account has been entered,
      * store full account details for FT Transaction Status File
      * record update.
     C**********         If        OKSnco = 'Y'                                             MD039547
     C                   If        OKSnco <> 'N'                                            MD039547
 
      * Set up @SNCDS data structure
     C                   If        @SNCT = 'N' or
     C                             @SNCT = 'R'
     C                   Eval      IMCNUM = K#CNUM
     C                   Eval      IMCCY = @CCY
     C                   Eval      IMACOD = K#ACOD
     C                   Eval      IMACSQ = K#ACSQ
     C                   Eval      IMBRCA = K#BRCA
     C                   Eval      @SNCDS = #SNCDS
      *                                                                                       240689
      ** Check Status of Account                                                              240689
      *                                                                                       240689
      ** Bankrupt/Liquidated                                                                  240689
      *                                                                                       240689
     C                   TESTB     '6'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKSnco                                240689 CSD089
     C**********         ADD       1             Idx                                   240689 CSD089
     C**********         MOVEL     'SSNCO'       FldNamXAr(Idx)                        240689 CSD089
     C**********         MOVEL     'FTM0015'     MsgIdXAr(Idx)                         240689 CSD089
     C                   MOVE      'W'           OKSnco                                       CSD089
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SSNCO'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0015'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bad Debt                                                                             240689
      *                                                                                       240689
     C                   TESTB     '7'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKSnco                                240689 CSD089
     C**********         ADD       1             Idx                                   240689 CSD089
     C**********         MOVEL     'SSNCO'       FldNamXAr(Idx)                        240689 CSD089
     C**********         MOVEL     'FTM0016'     MsgIdXAr(Idx)                         240689 CSD089
     C                   MOVE      'W'           OKSnco                                       CSD089
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SSNCO'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0016'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Inactive                                                                             240689
      *                                                                                       240689
     C                   TESTB     '4'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKSnco                                       240689
     C     OKSnco        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKSnco                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'SSNCO'       WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0017'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Referred Credit                                                                      240689
      *                                                                                       240689
     C                   TESTB     '1'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKSnco                                       240689
     C     OKSnco        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKSnco                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'SSNCO'       WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0020'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
 
     C                   End
     C                   End
 
     C                   ENDSR
     C************************************************************
     C* END OF SENDER'S CORRESPONDENT VALIDATION
     C************************************************************
     C/EJECT
     C******************************************************************
     C* VNOSTRO - VALIDATION OF NOSTRO                                 *
      ******************************************************************
 
     C     VNOSTRO       BEGSR
 
     C                   If        SPCCY = *Blanks
     C                   Eval      SPCCY = SSMCY
     C                   End
 
     C                   MOVE      '0'           *IN90                                        200462
     C                   Movel     SPCCY         WCURR
     C                   Move      SNOS          WCURR
 
     C                   CALLB     'AONOSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      *Blanks       C#CUST
     C                   Parm      SPCCY         C#CYCD
     C                   Parm      *Blanks       C#ACCD
     C                   Parm      *Blanks       C#ACSN
     C                   Parm      SNOS          C#NONB
     C                   Parm      *Blanks       C#BRCD
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
     C                   Eval      *IN90 = *On
     C                   End
 
     C                   If        *IN90 = *On
      * Send error to screen
     C                   Move      'N'           OKSnco
     C                   Add       1             Idx
     C                   Movel     'SSNCO'       FldNamXAr(Idx)
     C                   Movel     'MMA0959'     MsgIdXAr(Idx)
 
     C                   Else
     C                   Eval      @SNCT = 'N'
      * Set pay location
     C                   Eval      @PLOC = NLOC
     C                   Eval      @NOWRK = 'N'
 
     C                   If        WCURR = SDST1
     C                   Move      'N'           OKSnco
     C                   Add       1             Idx
     C                   Movel     'SSNCO'       FldNamXAr(Idx)
     C                   Movel     'MMA0960'     MsgIdXAr(Idx)
     C                   End
     C                   End
 
      * Find if Retail
     C**********         If        OKSnco = 'Y'                                             MD039547
     C                   If        OKSnco <> 'N'                                            MD039547
     C                   Eval      K#CCY = SPCCY
     C                   Eval      @CCY = SPCCY
 
      * Read Account
     C     AKEY          CHAIN     ACCNTABF                           90
     C                   If        *IN90 = *On or
     C                             RECI <> 'D'
     C                   Move      'FTVSNCR'     DBPGM
     C                   Move      'ACCNT  '     DBFILE
     C                   Eval      DBASE = 14
     C                   Movel     AKEYF         DBKEY
     C                   Exsr      *PSSR
     C                   Else                                                                BUG4581
      *                                                                                     AR750736
      ** Check for block debits on account                                                  AR750736
      *                                                                                     AR750736
     C     SADDC         IFEQ      'D'                                                      AR750736
     C                   MOVE      RETB          WRETB                                      AR750736
     C                   TESTB     '2'           RETB                     52                AR750736
     C     *IN52         IFEQ      '1'                                                      AR750736
     C                   MOVE      'W'           OKSnco                                     AR750736
     C                   ADD       1             WIx                                        AR750736
     C                   MOVEL     'SSNCO'       WFldNmXAr(WIx)                             AR750736
     C                   MOVEL     'FTM7120'     WMsgIdXAr(WIx)                             AR750736
     C                   ENDIF                                                              AR750736
     C                   ENDIF                                                              AR750736
      * Check for block credits on account                                                   BUG4581
     C                   MOVE      RETB          WRETB                                        240689
     C                   TESTB     '3'           RETB                     51                 BUG4581
     C                   If        *in51 = *ON                                               BUG4581
     C**********         Move      'N'           OKSnco                               BUG4581 CSD089
     C**********         Add       1             Idx                                  BUG4581 CSD089
     C**********         Movel     'SSNCO'       FldNamXAr(Idx)                       BUG4581 CSD089
     C**********         Movel     'FTM0019'     MsgIdXAr(Idx)                        BUG4581 CSD089
     C                   Move      'W'           OKSnco                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SSNCO'       WFldNmXAr(WIx)                               CSD089
     C**********         Movel     'FTM0019'     WMsgIdXAr(Idx)                      CSD089 MD020347
     C                   Movel     'FTM0019'     WMsgIdXAr(WIx)                             MD020347
     C                   End                                                                 BUG4581
     C                   End
 
     C                   Eval      @ACST2 = ACST
 
     C**********         If        ATYP = 'R'                                               MD037223
     C                   Eval      @SCOPN = DACO
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
     C*
     C     VRETAIL       BEGSR
 
     C                   Movel     SRET          WRETL
     C                   Movel     WRETL         WRETA
     C                   If        SRET = WRETA
     C                   Move      SRET          K#ACNO
     C     K#ACNO        Chain     ACNUMAF                            90
     C                   Eval      @CCY = CCY
     C                   End
 
      * Check to see if retail account number is allowed
 
     C                   If        BMRANR = 'N'
      * Send error to screen
     C                   Move      'N'           OKSnco
     C                   Add       1             Idx
     C                   Movel     'SSNCO'       FldNamXAr(Idx)
     C                   Movel     'MMA0943'     MsgIdXAr(Idx)
 
     C                   Else
     C                   If        SRET <> WRETA or
     C                             RECI <> 'D'  or
     C                             *IN90 = *On
      * Send error to screen
     C                   Move      'N'           OKSnco
     C                   Add       1             Idx
     C                   Movel     'SSNCO'       FldNamXAr(Idx)
     C                   Movel     'MMA0961'     MsgIdXAr(Idx)
     C                   End
     C                   End
 
     C**********         If        OKSnco = 'Y'                                             MD039547
     C                   If        OKSnco <> 'N'                                            MD039547
      *                                                                                     AR750736
      ** Check for block debits on account                                                  AR750736
      *                                                                                     AR750736
     C     SADDC         IFEQ      'D'                                                      AR750736
     C                   TESTB     '2'           RETB                     52                AR750736
     C     *IN52         IFEQ      '1'                                                      AR750736
     C                   MOVE      'W'           OKSnco                                     AR750736
     C                   ADD       1             WIx                                        AR750736
     C                   MOVEL     'SSNCO'       WFldNmXAr(WIx)                             AR750736
     C                   MOVEL     'FTM7120'     WMsgIdXAr(WIx)                             AR750736
     C                   ENDIF                                                              AR750736
     C                   ENDIF                                                              AR750736
      * Check for block credits on account                                                   BUG4581
     C                   TESTB     '3'           RETB                     51                 BUG4581
     C                   If        *in51 = *ON                                               BUG4581
     C**********         Move      'N'           OKSnco                               BUG4581 CSD089
     C**********         Add       1             Idx                                  BUG4581 CSD089
     C**********         Movel     'SSNCO'       FldNamXAr(Idx)                       BUG4581 CSD089
     C**********         Movel     'FTM0019'     MsgIdXAr(Idx)                        BUG4581 CSD089
     C                   Move      'W'           OKSnco                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SSNCO'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'FTM0019'     WMsgIdXAr(WIx)                               CSD089
     C                   End                                                                 BUG4581
 
     C                   If        SPCCY = *Blanks
     C                   Eval      SPCCY = SSMCY
     C                   End
 
     C                   If        @CCY <> SPCCY
      * Send error to screen
     C                   Move      'N'           OKSnco
     C                   Add       1             Idx
     C                   Movel     'SSNCO'       FldNamXAr(Idx)
     C                   Movel     'MMA0962'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
      *
     C**********         If        OKSnco = 'Y'                                             MD039547
     C                   If        OKSnco <> 'N'                                            MD039547
 
     C                   MOVE      RETB          WRETB                                        240689
     C                   Eval      K#CNUM = CNUM
     C                   Eval      K#CCY= @CCY
     C                   Eval      K#ACOD = ACOD
     C                   Eval      K#ACSQ = ACSQ
     C                   Eval      K#BRCA = BRCA
 
     C                   Eval      @SNCT = 'R'
     C                   Eval      @ACST2 = ACST
 
     C                   CALLB     'AONOSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      WCNUMA        C#CUST
     C                   Parm      @CCY          C#CYCD
     C                   Parm      WACODA        C#ACCD
     C                   Parm      WACSQA        C#ACSN
     C                   Parm      *Blanks       C#NONB
     C                   Parm      K#BRCA        C#BRCD
     C                   Parm      *Blanks       C#CSSN
     C                   Parm      *Blanks       C#PNOI
     C     SDNOST        Parm      SDNOST        DSFDY
 
     C                   If        C#RTCD = *Blanks
      * Set pay location
     C                   Eval      @PLOC = NLOC
     C                   Eval      @NOWRK = 'N'
     C                   End
 
     C**********         If        ATYP = 'R'                                               MD037223
     C                   Eval      @SCOPN = DACO
     C**********         End                                                                MD037223
      *
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF RETAIL ACCOUNT VALIDATION
     C*****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInPrim
 
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
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
     C/COPY WNCPYSRC,FTVSNCRC02                                                               GBO008
 
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
