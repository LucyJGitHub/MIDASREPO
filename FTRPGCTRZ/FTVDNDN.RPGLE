     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate destination')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVDNDN  - Validate Destination                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSW218             Date 19Mar18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD037223           Date 20Jul17               *
      *                 MD021276           Date 31Jul13               *
      *                 CFT120             Date 28Sep12               *
      *                 AR750736           Date 22Oct12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 260987A            Date 16Jul09               *
      *                 260862             Date 26Jun09               *
      *                 CSD089             Date 07Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 255286A            Date 21Jul08               *
      *                 255286             Date 07Jul08               *
      *                 247142             Date 01Jun07               *
      *                 GBO008             Date 24Aug06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 241255             Date 05Apr07               *
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
      * Midas Release 4.01.02 ----------------------------------------*
      *                 205679             Date 22Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 195342             Date 07Sep01               *
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
      *  CSW218 - SWIFT Changes 2018                                  *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037223 - Retrieve DACO for all types of account to be used *
      *             in validation.                                    *
      *  MD021276 - A Serious Midas Error occured when complete       *
      *             button is clicked for OPAY                        *
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
      *  260987A - The presence of '1' in position 8 on Customer      *
      *            SWIFT denotes that this is not a SWIFT address.    *
      *  260862 - Block Debit and Block Credit on nostro account does *
      *           not work. Ensure that an error message will be dis- *
      *           played when the Nostro account used is tagged as    *
      *           Block Credit.                                       *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  255286A- Allow lowercase characters on input.                *
      *  255286 - Allow lowercase characters on input                 *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning.                  *
      *           Apply fixes 232151 and 210654. Annotated as 240689. *
      *  232151 - DBASE error when inserting an inactive account.     *
      *  210654 - Check status of Account.                            *
      *  GBO008 - Settlement Type 13 in FT Outgoing Payment Maint.    *
      *         - Added core hooks: FTVDNDND01, FTVDNDNC01,           *
      *           FTVDNDNC02, FTVDNDNC03, FTVDNDNC04, FTVDNDNC05,     *
      *           FTVDNDNC06, FTVDNDNC07.                             *
      *  241255 - If entry for Destination is a Shortname, also check *
      *           if it is a SWIFT ID.                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240689 - Applied fix 210654 + additional changes by 232151.  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4581- Check for blocked debits/credits                    *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  205679 - Prevent database error in AOCUSTR0.                 *
      *  195342 - *Blank was move to Destination when it is not a     *
      *           SWIFT.  Fix is to move BBCUST to Destination        *
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
 
      /COPY FTCPYSRC,SFTVALCSLE
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      * Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      * Array of error message data.
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
 
      * Address line Swift character check array
     D TST             S              1A   DIM(35)
 
      ** Array of valid swift characters
     D*SWCH*****       S              1    DIM(47) CTDATA PERRCD(47)                          255286
     D SWCH            S              1    DIM(73) CTDATA PERRCD(73)                          255286
 
      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      * External DS for Midas modules details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
 
      ** Midas Counterparty NOSTROS
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
 
      ** Midas BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
 
      ** External data structure for Nostro customer number
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
     D  NLOC                  29     31
 
      ** External data structure for Nostro customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DESTAN          DS           140
     D  #SDST1                 1     35
     D  #SDST2                36     70
     D  #SDST3                71    105
     D  #SDST4               106    140
 
     D  DRET                   1     10
     D  DCUS                   1     10
     D  NCUR                   1      3
     D  DNOS                   1      5
     D  DNUM                   1      6
     D  NNUM                   4      5
     D  DSCY                   7      9
     D  DCOD                  10     19                                                       CGL029
     D  DSEQ                  20     21                                                       CGL029
     D  DBRC                  22     24                                                       CGL029
     D**DCOD****              10     13                                                       CGL029
     D**DSEQ****              14     15                                                       CGL029
     D**DBRC****              16     18                                                       CGL029
 
     D  D05R                   6    140
     D  D06R                   7    140
     D  D10R                  11    140
     D  D15R                  22    140                                                       CGL029
     D  D18R                  25    140                                                       CGL029
     D**D15R****              16    140                                                       CGL029
     D**D18R****              19    140                                                       CGL029
 
      * Data structure redefining address fields
     DADDRSS           DS           175
     D ADCHK1                  1     35
     D ADCHK2                 36     70
     D ADCHK3                 71    105
     D ADCHK4                106    140
     D ADCHK5                141    175
 
      * Data structure redefining Account key fields
     D**********       DS            18                                                       CGL029
     D                 DS            24                                                       CGL029
     D*K#CNUM***               1      6  0                                                    CSD027
     D K#CNUM                  1      6                                                       CSD027
     D WCNUMA                  1      6
     D K#CCY                   7      9
     D K#ACOD                 10     19  0                                                    CGL029
     D WACODA                 10     19                                                       CGL029
     D K#ACSQ                 20     21  0                                                    CGL029
     D WACSQA                 20     21                                                       CGL029
     D K#BRCA                 22     24                                                       CGL029
     D AKEYF                   1     24                                                       CGL029
     D*K#ACOD***              10     13  0                                                    CGL029
     D*WACODA***              10     13                                                       CGL029
     D*K#ACSQ***              14     15  0                                                    CGL029
     D*WACSQA***              14     15                                                       CGL029
     D*K#BRCA***              16     18                                                       CGL029
     D*AKEYF****               1     18                                                       CGL029
 
      *  Define full account to be passed for FT IMM update
     D***#DSTDS*          DS            18                                                    CGL029
     D#DSTDS           DS            24                                                       CGL029
     D*IMCNUM***               1      6  0                                                    CSD027
     D IMCNUM                  1      6                                                       CSD027
     D IMCCY                   7      9
     D IMACOD                 10     19  0                                                    CGL029
     D IMACSQ                 20     21  0                                                    CGL029
     D IMBRCA                 22     24                                                       CGL029
     D*IMACOD***              10     13  0                                                    CGL029
     D*IMACSQ***              14     15  0                                                    CGL029
     D*IMBRCA***              16     18                                                       CGL029
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
 
     D K#ACNO          S                   LIKE(ACNO)
     D WFLD            S                   LIKE(ADCHK1)
     D WNCURR          S              3
     D WNUMA           S              6
     D*WNUML****       S              7P 0                                                    CSD027
     D WNUML           S              7A                                                      CSD027
     D WRETA           S             10
     D WRETL           S             11P 0
     D R               S              2  0
     D CLSWTK          S             18                                                       CGL029
 
      * This prog only
     D ##CSID          S              1
     D SwiftOK         S              1
 
     D WSId19          S              1A                                                      CSW218
     D CSW218          S              1A                                                      CSW218
     D PRtCd           S              7A                                                      CSW218
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
 
      * Order Customer
     C                   Exsr      VDESTIN
 
      * If an error was found, set the return code appropriately
     C                   If        OKDst1 = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD089
     C                   If        OKDst1 = 'W'                                               CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   End                                                                  CSD089
     C                   End
 
      * RETURN
 
     C                   RETURN
      ******************************************************************
      /EJECT
     C******************************************************************
     C* VDESTIN - VALIDATION OF DESTINATION                            *
      ******************************************************************
     C*
     C     VDESTIN       BEGSR
 
      * Set up DESTAN data structure
     C                   Eval      #SDST1 = SDST1
     C                   Eval      #SDST2 = SDST2
     C                   Eval      #SDST3 = SDST3
     C                   Eval      #SDST4 = SDST4
 
      * Check for entry of '?'
 
     C                   Eval      *IN90 = *Off
     C     '?'           Scan      #SDST1                                 90
 
      * If '?' found....
     C                   If        *IN90 = *On
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0947'     MsgIdXAr(Idx)
     C                   End
 
     C                   If        OKDst1 = 'Y'
     C                   Eval      @DSTT = *Blank
     C                   Eval      @ACST1 = *Blank
     C                   Eval      @DSOPN = 0
 
      * If not entered move NOSTRO of pay currency
     C                   If        SPCCY <> *Blanks
     C                   Eval      WNCURR = SPCCY
     C                   Else
     C                   Eval      WNCURR = SSMCY
     C                   End
 
      * If settlement type 13 Destination must be NOSTRO.
     C                   If        SSTTP = '13' and
     C                             D05R <> *Blank
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0946'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
      * No errors
     C                   BITOFF    '01234567'    WRETB             1                          240689
     C                   If        OKDst1 = 'Y'
 
      * If more than 5 char have been entered cannot be a NOSTRO
     C                   If        D05R = *Blanks
     C                   Exsr      VNOSTRO
 
     C                   Else
      * If more than 6 char have been entered cannot be a CUST NUMBER
     C                   If        D06R = *Blanks
     C                   Exsr      VDESNUM
 
     C                   Else
      * If more than 10 char have been entered cannot be a RETAIL NO.
     C                   If        D10R = *Blanks
     C                   Exsr      VDESRET
 
     C                   Else
      * Therefore maybe is a full account
     C                   Exsr      VDESACC
     C                   End
 
     C                   End
     C                   End
     C                   End
      *                                                                                       240689
      ** Check Status of Account                                                              240689
      *                                                                                       240689
     C     OKDst1        IFEQ      'Y'                                                        240689
      *                                                                                     AR750736
      ** Blocked Debit                                                                      AR750736
      *                                                                                     AR750736
     C     SADDC         IFEQ      'D'                                                      AR750736
     C                   TESTB     '2'           WRETB                    52                AR750736
     C     *IN52         IFEQ      '1'                                                      AR750736
     C                   MOVE      'W'           OKDst1                                     AR750736
     C                   ADD       1             WIx                                        AR750736
     C                   MOVEL     'SDST1'       WFldNmXAr(WIx)                             AR750736
     C                   MOVEL     'FTM7120'     WMsgIdXAr(WIx)                             AR750736
     C                   ENDIF                                                              AR750736
     C                   ENDIF                                                              AR750736
      *                                                                                       260862
      ** Blocked Credit                                                                       260862
      *                                                                                       260862
     C                   TESTB     '3'           WRETB                    51                  260862
     C     *IN51         IFEQ      '1'                                                        260862
     C**********         MOVE      'N'           OKDst1                                260862 CSD089
     C**********         ADD       1             Idx                                   260862 CSD089
     C**********         MOVEL     'SDST1'       FldNamXAr(Idx)                        260862 CSD089
     C**********         MOVEL     'FTM0019'     MsgIdXAr(Idx)                         260862 CSD089
     C                   Move      'W'           OKDst1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SDST1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'FTM0019'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                                260862
      *                                                                                       240689
      ** Bankrupt/Liquidated                                                                  240689
      *                                                                                       240689
     C                   TESTB     '6'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKDst1                                240689 CSD089
     C**********         ADD       1             Idx                                   240689 CSD089
     C**********         MOVEL     'SDST1'       FldNamXAr(Idx)                        240689 CSD089
     C**********         MOVEL     'FTM0015'     MsgIdXAr(Idx)                         240689 CSD089
     C                   MOVE      'W'           OKDst1                                       CSD089
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SDST1'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0015'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bad Debt                                                                             240689
      *                                                                                       240689
     C                   TESTB     '7'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKDst1                                240689 CSD089
     C**********         ADD       1             Idx                                   240689 CSD089
     C**********         MOVEL     'SDST1'       FldNamXAr(Idx)                        240689 CSD089
     C**********         MOVEL     'FTM0016'     MsgIdXAr(Idx)                         240689 CSD089
     C                   MOVE      'W'           OKDst1                                       CSD089
     C                   ADD       1             WIx                                          CSD089
     C                   MOVEL     'SDST1'       WFldNmXAr(WIx)                               CSD089
     C                   MOVEL     'FTM0016'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Inactive                                                                             240689
      *                                                                                       240689
     C                   TESTB     '4'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C*****              MOVE      'N'           OKDst1                                       240689
     C     OKDst1        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKDst1                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'SDST1'       WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0017'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Referred Credit                                                                      240689
      *                                                                                       240689
     C                   TESTB     '1'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C*****              MOVE      'N'           OKDst1                                       240689
     C     OKDst1        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKDst1                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'SDST1'       WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0020'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
     C                   ENDIF                                                                240689
 
     C                   If        OKDst1 = 'Y'
     C                   Exsr      VDESEND
     C                   Endif
 
      * Set Screen fields
     C                   Eval      SDST1 = #SDST1
     C                   Eval      SDST2 = #SDST2
     C                   Eval      SDST3 = #SDST3
     C                   Eval      SDST4 = #SDST4
 
     C                   If        OKDst1 = 'Y'
 
      * Set up @DSTDS
     C                   If        @DSTT = 'F' or
     C                             @DSTT = 'R' or
     C                             @DSTT = 'G'
     C                   Eval      IMCNUM = K#CNUM
     C                   Eval      IMCCY = @CCY
     C                   Eval      IMACOD = K#ACOD
     C                   Eval      IMACSQ = K#ACSQ
     C                   Eval      IMBRCA = K#BRCA
     C                   Eval      @DSTDS = #DSTDS
     C                   End
 
     C                   End
 
     C                   ENDSR
     C************************************************************
     C* END OF DESTINATION VALIDATION
     C************************************************************
     C/EJECT
     C******************************************************************
     C* VNOSTRO - VALIDATION OF NOSTRO                                 *
      ******************************************************************
 
     C     VNOSTRO       BEGSR
 
     C                   CALLB     'AONOSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      *Blanks       C#CUST
     C                   Parm      NCUR          C#CYCD
     C                   Parm      *Blanks       C#ACCD
     C                   Parm      *Blanks       C#ACSN
     C                   Parm      NNUM          C#NONB
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
     C                   Eval      *IN90 = *On
     C                   End
 
      * If settlement type 13 Destination must be NOSTRO.
     C                   If        SSTTP = '13' and
     C                             *IN90 = *On
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0946'     MsgIdXAr(Idx)
     C                   End
 
      * No Errors
     C                   If        OKDst1 = 'Y'
 
      * Not a NOSTRO but maybe the name
     C                   If        *IN90 = *On
     C                   Exsr      VDESNAM
 
     C                   Else
      * Is a NOSTRO
      * Find if RETAIL
     C                   Movel     DNOS          K#CCY
      * Read Account
     C     AKEY          CHAIN     ACCNTABF                           90
     C                   If        *IN90 = *On or
     C                             RECI <> 'D'
     C**********         Move      'FTVDNDN'     DBPGM                                      MD021276
     C**********         Move      'ACCNT  '     DBFILE                                     MD021276
     C**********         Eval      DBASE = 14                                               MD021276
     C**********         Movel     AKEYF         DBKEY                                      MD021276
     C**********         Exsr      *PSSR                                                    MD021276
     C                   Move      'N'           OKDst1                                     MD021276
     C                   Add       1             Idx                                        MD021276
     C                   Movel     'SDST1'       FldNamXAr(Idx)                             MD021276
     C                   Movel     '5045989'     MsgIdXAr(Idx)                              MD021276
     C                   ELSE                                                                 240689
     C     SSNCO         IFEQ      *BLANK                                                     240689
     C                   MOVE      RETB          WRETB                                        240689
     C                   ENDIF                                                                240689
     C                   End
 
     C                   Eval      @CCY = K#CCY
     C                   Eval      @ACST1 = ACST
 
     C**********         If        ATYP = 'R'                                               MD037223
     C                   Eval      @DSOPN = DACO
     C**********         End                                                                MD037223
 
      * If Sender's Correspondent is blank curr must equal pay curr
     C                   If        SSNCO = *Blank and
     C                             NCUR <> WNCURR
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0955'     MsgIdXAr(Idx)
 
     C                   Else
     C                   Eval      @DSTT = 'F'
     C                   End
 
     C                   End
     C                   End
 
     C                   ENDSR
     C************************************************************
     C* END OF NOSTRO VALIDATION
     C************************************************************
     C/EJECT
     C******************************************************************
     C* VDESNUM - VALIDATION OF CUSTOMER NUMBER                        *
      ******************************************************************
     C*
     C     VDESNUM       BEGSR
 
     C**********         Movel     DNUM          WNUML                                        CSD027
     C**********         Movel     WNUML         WNUMA                                        CSD027
 
     C**********         If        DNUM = WNUMA                                               CSD027
     C                   Move      DNUM          K#CNUM
     C                   Move      DNUM          WCNUMA                                       CSD027
 
     C                   CALLB     'AOCUSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      WCNUMA        C#KEY1
     C                   Parm      *Blanks       C#KYST
     C     SDCUST        Parm      SDCUST        DSSDY
 
     C**********         End                                                                  CSD027
 
     C**********         If        DNUM <> WNUMA or                                           CSD027
     C**********                   C#RTCD <> *Blanks or                                       CSD027
     C**********                   C#KYST <> '*CNUM  '                                        CSD027
     C                   If        C#RTCD <> *Blanks or                                       CSD027
     C**********                   C#KYST <> ' *CNUM  '                                       CSD027
     C                             C#KYST <> '*CNUM  '                                        CSD027
 
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0948'     MsgIdXAr(Idx)
 
     C                   Else
     C                   Eval      @DSTT = 'C'
      * Move new SYNON field names to old field names
     C                   MOVE      BBCUST        K#CNUM
     C                   MOVE      BBCSID        CSID             12
     C                   MOVE      BBCSSN        CSNM             10
 
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF CUSTOMER NUMBER VALIDATION
     C*****************************************************************
     C/EJECT
     C******************************************************************
     C* VDESRET - VALIDATION OF RETAIL ACCOUNT NUMBER                  *
      ******************************************************************
     C*
     C     VDESRET       BEGSR
 
     C                   Movel     DRET          WRETL
     C                   Movel     WRETL         WRETA
     C                   If        DCUS = WRETA
 
      * Check to see whether a retail account number is allowed
     C                   If        BMRANR = 'N'
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0943'     MsgIdXAr(Idx)
     C                   Endif
 
      * No Errors
     C                   If        OKDst1 = 'Y'
     C                   Move      DRET          K#ACNO
     C     K#ACNO        CHAIN     ACNUMAF                            90
 
      * Error if not found or RECI <> D
     C                   If        *in90 = *ON or
     C                             RECI <> 'D'
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0949'     MsgIdXAr(Idx)
     C                   End
 
     C                   Eval      @CCY = CCY
     C                   End
 
      * No Errors
     C                   If        OKDst1 = 'Y'
     C     SSNCO         IFEQ      *BLANKS                                                    240689
     C                   MOVE      RETB          WRETB                                        240689
     C                   ENDIF                                                                240689
      **Check*for*block*credits*on*account*****************************               BUG4581 260862
     C*******            TESTB     '3'           RETB                     51          BUG4581 260862
     C*******            If        *in51 = *ON                                        BUG4581 260862
     C*******            Move      'N'           OKDst1                               BUG4581 260862
     C*******            Add       1             Idx                                  BUG4581 260862
     C*******            Movel     'SDST1'       FldNamXAr(Idx)                       BUG4581 260862
     C*******            Movel     'FTM0019'     MsgIdXAr(Idx)                        BUG4581 260862
     C*******            End                                                          BUG4581 260862
 
      * Store value for use with sender's correspondent check
     C                   Eval      @COCYY = @CCY
 
      * If sender's correspondent is blank curr must equal pay curr.
     C                   If        SPCCY = *Blanks
     C                   Eval      SPCCY = SSMCY
     C                   End
 
     C                   If        SSNCO = *Blanks and
     C                             @CCY <> SPCCY
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0950'     MsgIdXAr(Idx)
     C                   End
 
     C                   End
 
     C                   If        OKDst1 = 'Y'
 
     C                   Eval      K#CNUM = CNUM
     C                   Eval      K#CCY= @CCY
     C                   Eval      K#ACOD = ACOD
     C                   Eval      K#ACSQ = ACSQ
     C                   Eval      K#BRCA = BRCA
 
     C                   Eval      @DSTT = 'R'
     C                   Eval      @ACST1 = ACST
 
     C**********         If        ATYP = 'R'                                               MD037223
     C                   Eval      @DSOPN = DACO
 
     C**********         End                                                                MD037223
 
     C                   End
 
     C                   Else
     C                   Exsr      VDESNAM
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF RETAIL NUMBER VALIDATION
     C*****************************************************************
     C/EJECT
     C******************************************************************
     C* VDESRET - VALIDATION OF NAME                                   *
      ******************************************************************
 
     C     VDESNAM       BEGSR
 
      * CHECK IF NAME
     C                   Move      DCUS          CSNM
 
     C                   CALLB     'AOCUSTR0'
     C                   Parm      *BLANKS       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      CSNM          C#KEY1
     C                   Parm      *BLANKS       C#KYST
     C     SDCUST        Parm      SDCUST        DSSDY
 
     C                   If        C#RTCD <> *Blanks or
     C**********                   C#KYST <> '*CSHT  '                                        241255
     C                             C#KYST = '*CSHT  '                                         241255
 
      * Check that it is not a SWIFT address
     C**********         Movel     #SDST1        CLSWTK           12                          CGL029
     C                   Movel     #SDST1        CLSWTK                                       CGL029
     C                   Movea     *IN(31)       ##002             2
 
     C                   Exsr      SWIFT
 
     C                   If        ##CSID = 'Y' and
     C                             *IN31 = *OFF and
     C                             *IN32 = *OFF
     C                   Eval      SwiftOK = 'Y'
     C                   Eval      @DSTT = 'S'
     C                   Else
     C                   Eval      SwiftOK = 'N'
     C                   End
 
     C                   Movea     ##002         *IN(31)
     C                   If        SwiftOK = 'N'
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
c    C                   Movel     'MMA0951'     MsgIdXAr(Idx)
     C                   End
 
     C                   Else
     C* Move new SYNON field names to old field names
     C                   Move      BBCUST        CNUM
     C                   Move      BBCUST        K#CNUM                                       195342
     C                   Move      BBCSID        CSID             12
     C                   Move      BBCSSN        CSNM             10
 
     C                   Eval      DESTAN = *Blanks
     C                   Movel     K#CNUM        DESTAN
     C                   Eval      @DSTT = 'C'
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF NAME VALIDATION
     C*****************************************************************
     C/EJECT
     C******************************************************************
     C* VDESACC - VALIDATION FULL ACCOUNT                              *
      ******************************************************************
 
     C     VDESACC       BEGSR
 
      * Check that it is not a SWIFT address
      *
     C                   Movel     #SDST1        CLSWTK
     C                   Movea     *IN(31)       ##002
      *
     C                   Exsr      SWIFT
 
     C                   If        ##CSID = 'Y' and
     C                             *IN31 = *Off and
     C                             *IN32 = *Off or
 
      * If Swift Id not found, allow it and display warning message.
     C                             ##CSID = 'Y' and
     C                             *IN32 = *On
     C                   If        *in32 = *on                                                205679
     C                   Movel     '*NFND'       @SWIIND
     C                   Endif                                                                205679
     C                   Eval      SwiftOK = 'Y'
     C                   Eval      @DSTT = 'S'
     C                   Movea     ##002         *IN(31)
 
     C                   Else
     C                   Movea     ##002         *IN(31)
 
      * If 18 chars have been entered and multi branched ,
      * or 15 long and single branch , is a full account.
     C                   If        @MBIN = 'Y'    and
     C                             D18R = *Blanks or
     C                             @MBIN = 'N'    and
     C                             D15R = *Blanks
     C                   Movel     DNUM          WNUML
     C                   Movel     WNUML         WNUMA
     C**********         Movel     DCOD          CODL              5 0                        CGL029
     C**********         Movel     CODL          CODA              4                          CGL029
     C                   MOVEL     DCOD          CODL             11 0                        CGL029
     C                   MOVEL     CODL          CODA             10                          CGL029
     C                   Movel     DSEQ          SEQL              3 0
     C                   Movel     SEQL          SEQA              2
 
     C                   If        DNUM = WNUMA and
     C                             DCOD = CODA and
     C                             DSEQ = SEQA
     C                   Move      DNUM          K#CNUM
     C                   Eval      @CCY = DSCY
     C                   Eval      K#CCY = DSCY
     C                   Move      DCOD          K#ACOD
     C                   Move      DSEQ          K#ACSQ
     C                   If        @MBIN = 'Y'
     C                   Eval      K#BRCA = DBRC
     C                   Else
     C                   Eval      K#BRCA = BJSBRC
     C                   End
     C     AKEY          CHAIN     ACCNTABF                           90
     C                   End
 
     C                   If        DNUM <> WNUMA or
     C                             DCOD <> CODA or
     C                             DSEQ <> SEQA or
     C                             RECI <> 'D' or
     C                             *IN90 = '1'
 
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0952'     MsgIdXAr(Idx)
 
     C                   Else
      **Check*for*block*credits*on*account*****************************               BUG4581 260862
     C*******            TESTB     '3'           RETB                     51          BUG4581 260862
     C*******            If        *in51 = *ON                                        BUG4581 260862
     C*******            Move      'N'           OKDst1                               BUG4581 260862
     C*******            Add       1             Idx                                  BUG4581 260862
     C*******            Movel     'SDST1'       FldNamXAr(Idx)                       BUG4581 260862
     C*******            Movel     'FTM0019'     MsgIdXAr(Idx)                        BUG4581 260862
     C*******            End                                                          BUG4581 260862
 
      * If sender's correspondent is blank curr must equal pay curr.
     C                   If        SPCCY = *Blanks
     C                   Eval      SPCCY = SSMCY
     C                   End
 
     C                   If        SSNCO = *Blanks and
     C                             @CCY <> SPCCY
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDST1'       FldNamXAr(Idx)
     C                   Movel     'MMA0953'     MsgIdXAr(Idx)
     C                   End
      *
     C                   If        OKDst1 = 'Y'
     C     SSNCO         IFEQ      *BLANKS                                                    240689
     C                   MOVE      RETB          WRETB                                        240689
     C                   ENDIF                                                                240689
     C                   Eval      @DSTT = 'G'
     C                   Eval      @ACST1 = ACST
     C**********         If        ATYP = 'R'                                               MD037223
     C                   Eval      @DSOPN = DACO
 
     C**********         End                                                                MD037223
     C                   End
 
     C                   End
     C                   End
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF FULL ACCOUNT VALIDATION
     C*****************************************************************
     C/EJECT
     C******************************************************************
     C* VDESEND - ADDRESS VALIDATION                                   *
      ******************************************************************
 
     C     VDESEND       BEGSR
 
      * If nothing else must be an address
                                                                                              CSW218
     C                   IF        CSW218 = 'N'                                               CSW218
     C                   Eval      WCSID8 = *Blanks                                          260987A
     C     1             SUBST     #SDST1:8      WCSID8            1                         260987A
     C**********         If        @DSTT = *Blanks                                           260987A
     C                   If        @DSTT = *Blanks or                                        260987A
     C                             WCSID8 = '1' and                                          260987A
     C                             @DSTT = 'S'                                               260987A
     C                   Eval      @DSTT = 'A'
     C                   End
                                                                                              CSW218
     C                   ELSE                                                                 CSW218
      ** SWIFT2018 is ON                                                                      CSW218
      ** Check BIC address Extra Info field position 19                                       CSW218
      ** If equal to 'N', set BIC address as not connected                                    CSW218
                                                                                              CSW218
     C                   EVAL      WSId19 = *BLANKS                                           CSW218
     C                   EVAL      WSId19 = %SUBST(BDXINF:19:1)                               CSW218
                                                                                              CSW218
     C                   IF        @DSTT = *BLANKS OR                                         CSW218
     C                             WSId19 = 'N' AND @DSTT = 'S'                               CSW218
     C                   EVAL      @DSTT = 'A'                                                CSW218
     C                   ENDIF                                                                CSW218
     C                   ENDIF                                                                CSW218
 
      * Extra validation of address fields
     C                   If        @DSTT = 'A'
     C                   Movea     '0000'        *IN(91)
 
     C                   Eval      ADDRSS = *Blanks
     C                   Eval      ADCHK1 = #SDST1
     C                   Eval      ADCHK2 = #SDST2
     C                   Eval      ADCHK3 = #SDST3
     C                   Eval      ADCHK4 = #SDST4
 
     C                   Exsr      ADCHK
 
      * Depending on the indicators highlight the field in error
      * and output the error message
     C                   If        *IN92 = *On or
     C                             *IN93 = *On
      * Send error to screen
     C                   Move      'N'           OKDst1
     C                   Add       1             Idx
     C                   Movel     'SDDST1'      FldNamXAr(Idx)
     C                   Movel     'MMA0937'     MsgIdXAr(Idx)
     C                   End
     C
     C                   End
 
      * If destination is a NOSTRO set pay location to nostro location
      * Else use system location
     C                   If        @DSTT = 'G' or
     C                             @DSTT = 'R'
     C                   CALLB     'AONOSTR0'
     C                   Parm      *BLANKS       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm      WCNUMA        C#CUST
     C                   Parm      @CCY          C#CYCD
     C                   Parm      WACODA        C#ACCD
     C                   Parm      WACSQA        C#ACSN
     C                   Parm      *BLANKS       C#NONB
     C                   Parm      K#BRCA        C#BRCA
     C                   Parm      *BLANKS       C#CSSN
     C                   Parm      *BLANKS       C#PNOI
     C     SDNOST        Parm      SDNOST        DSFDY
 
     C                   If        C#RTCD = *Blanks
     C                   Eval      @PLOC = NLOC
     C                   Eval      @NOWRK = 'N'
     C                   End
 
     C                   Else
     C                   If        @DSTT = 'F'
     C                   Eval      @PLOC = NLOC
     C                   Eval      @NOWRK = 'N'
     C                   Else
     C                   Eval      @PLOC = BJSLCD
     C                   Eval      @NOWRK = 'S'
     C                   End
     C                   End
 
     C                   ENDSR
     C************************************************************
     C* END OF ACCOUNT NUMBER VALIDATION
     C************************************************************
     C/EJECT
     C*****************************************************************
     C*  ADCHK SUBROUTINE - TO VALIDATE ADDRESS FIELDS
     C*****************************************************************
     C*
     C     ADCHK         BEGSR
 
     C* There should be no embedded spaces
 
     C                   If        ADCHK1 = *Blanks  and
     C                             ADCHK2 <> *Blanks or
 
     C                             ADCHK1 = *Blanks  and
     C                             ADCHK3 <> *Blanks or
 
     C                             ADCHK1 = *Blanks  and
     C                             ADCHK4 <> *Blanks or
 
     C                             ADCHK1 = *Blanks  and
     C                             ADCHK5 <> *Blanks or
 
     C                             ADCHK2 = *Blanks  and
     C                             ADCHK3 <> *Blanks or
 
     C                             ADCHK2 = *Blanks  and
     C                             ADCHK4 <> *Blanks or
 
     C                             ADCHK2 = *Blanks  and
     C                             ADCHK5 <> *Blanks or
 
     C                             ADCHK3 = *Blanks  and
     C                             ADCHK4 <> *Blanks or
 
     C                             ADCHK3 = *Blanks  and
     C                             ADCHK5 <> *Blanks or
 
     C                             ADCHK4 = *Blanks  and
     C                             ADCHK5 <> *Blanks
 
     C                   Eval      *IN92 = *ON
     C                   End
 
     C** Check for non-valid Swift characters
 
     C                   If        ADCHK1 <> *Blanks
     C                   Eval      WFLD = ADCHK1
     C                   Exsr      SWSET
 
     C                   If        *IN94 = *Off
      * Send error to screen
     C**********         Move      'N'           OKDst1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SDST1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA0938'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKDst1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SDST1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA0938'     WMsgIdXAr(WIx)                               CSD089
     C                   End
     C                   End
 
     C                   If        ADCHK2 <> *Blanks
     C                   Eval      WFLD = ADCHK2
     C                   Exsr      SWSET
 
     C                   If        *IN94 = *Off
      * Send error to screen
     C**********         Move      'N'           OKDst1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SDST1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA0939'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKDst1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SDST1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA0939'     WMsgIdXAr(WIx)                               CSD089
     C                   End
     C                   End
 
     C                   If        ADCHK3 <> *Blanks
     C                   Eval      WFLD = ADCHK3
     C                   Exsr      SWSET
 
     C                   If        *IN94 = *Off
      * Send error to screen
     C**********         Move      'N'           OKDst1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SDST1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA0940'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKDst1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SDST1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA0940'     WMsgIdXAr(WIx)                               CSD089
     C                   End
     C                   End
 
     C                   If        ADCHK4 <> *Blanks
     C                   Eval      WFLD = ADCHK4
     C                   Exsr      SWSET
 
     C                   If        *IN94 = *Off
      * Send error to screen
     C**********         Move      'N'           OKDst1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SDST1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA0941'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKDst1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SDST1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA0941'     WMsgIdXAr(WIx)                               CSD089
     C                   End
     C                   End
 
     C                   If        ADCHK5 <> *Blanks
     C                   Eval      WFLD = ADCHK5
     C                   Exsr      SWSET
 
     C                   If        *IN94 = *Off
      * Send error to screen
     C**********         Move      'N'           OKDst1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SDST1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA0942'     MsgIdXAr(Idx)                                CSD089
     C                   Move      'W'           OKDst1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SDST1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA0942'     WMsgIdXAr(WIx)                               CSD089
     C                   End
     C                   End
 
     C                   ENDSR
     C*
     C************************************************************
     C* END OF ADDRESS VALIDATION
     C************************************************************
     C/EJECT
     C************************************************************
     C* SUBROUTINE SWSET CHECK FOR VALID SWIFT CHARACTER USED
     C************************************************************
 
     C     SWSET         BEGSR
 
     C                   Eval      R = 1
     C                   Eval      *IN94 = *On
 
     C                   If        WFLD <> *Blanks
     C                   Movea     WFLD          TST
     C                   Eval      R = 1
      * check each character until invalid found
     C                   DOW       R <= 35 and
     C                             *IN94 = *On
      * Validate if not blank
     C                   If        TST(R) <> *Blanks
     C     TST(R)        LOOKUP    SWCH                                   94
     C                   End
 
     C                   Eval      R = R + 1
     C                   End
     C                   End
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C/COPY FTCPYSRC,SFTSWFTCLE
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
 
      * OK Flags
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
      *                                                                                       CSW218
      ** Check if Swift 2018 Changes is installed.                                            CSW218
      *                                                                                       CSW218
     C                   CALL      'SWIF2018'                                                 CSW218
     C                   PARM      *BLANKS       PRtCd                                        CSW218
      *                                                                                       CSW218
     C     PRtCd         IFEQ      'CSW2018'                                                  CSW218
     C                   EVAL      CSW218 = 'Y'                                               CSW218
     C                   ELSE                                                                 CSW218
     C                   EVAL      CSW218 = 'N'                                               CSW218
     C                   ENDIF                                                                CSW218
 
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
**  SWCH  - Array of valid Swift characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890/-?:().,'+abcdefghijklmnopqrstuvwxyz                     255286
