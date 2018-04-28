     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual Repayments- Add'l valid. for Settl')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEMAPY2VL - Midas LE Manual Repayments - Add. Validations    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD020626           Date 26Jun13               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG5863            Date 14Feb04               *
      *                 BUG4351 (reopen)   Date 12Oct04               *
      *                 BUG3114            Date 04Aug04               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020626 - Serious Midas Error during MR Creation            *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG5863 - Index of Warning errors array (WId) should be      *
      *            reset to zero to prevent array index out of range. *
      *  BUG4351 - Index of Warning errors array WFldNmXAr should be  *
      *            different to the index for WFldNamArr.             *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CAP077 - Lending API enhancements - Manual repayments        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loans details file
     F                                     IGNORE(CLOANHHF:CLOANZ1F:CLOANCKF)
     F                                     PREFIX(CL_)
      *
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
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
     D XArrayMax       C                   CONST(40)
      ***  The maximum size of the appended error arrays
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D WFldNmXAr       S             10A   DIM(XArrayMax)
      ***  Array of Fields with warnings.
      *
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
      ***  Array of warning message IDs
      *
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ***  Array of warning message data.
      *
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      ***  File Receive Instructions
      *
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      ***  File Payment Instructions
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ***  External DS for Nostro Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ***  Midas Feature details accessed via access program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  First DS for access programs, long data structure
      *
     D ValidMaPy     E DS                  EXTNAME(LEVMAPYPD)
      ***  Valid Manual Repayment in file format
      *
     D OKFlagsDS     E DS                  EXTNAME(LEEMAPYPD)
      ***  Flags to indicate whether transaction fields are valid
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WId             S              3P 0
     D WIdx            S              3P 0                                                   BUG4351
      ***  Index for arrays of of warning message ids etc
      *
     D RespMode        S              1A
      ***  Response Mode, received as a parameter from the common header
      *
     D PassDta         DS           512
     D CLE005                  4      4A
      *
      ** +--------------------------------------+
      ** ¦ Rename fields                        ¦
      ** ¦ =============                        ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ***  Additional validation
      *    =====================
      *
      ***  Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *
      ***  Access the related loan
      *
     C                   MOVE      MRLNRF        K@LNRF
     C                   MOVE      'A'           K@RCDT
      *
     C     K@LOAN        CHAIN     CLOANCLF                           99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'CLOANCL '    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     MRLNRF        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Perform the additional validations (Warning)
      *
     C                   EXSR      SRVALA
      *
      ***  Update error information with that received back
      ***  from each validation module.
      *
     C                   EXSR      UPDATERRS
      *
      ***  Save the loan reference for warning
      *
     C**********         MOVEL     MRLNRF        SaveMRLNRF        6 0                        CLE148
     C                   MOVEL     MRLNRF        SaveMRLNRF        6                          CLE148
     C                   MOVEL     MRVDAT        SaveMRVDAT        5 0
     C                   MOVEL     MRLASN        SaveMRLASN        3 0
      *
      ***  Return
      *    ======
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRVALA - Additional validations (Warning)                    *
      *****************************************************************
     C     SRVALA        BEGSR
      *
     C                   Z-ADD     *ZEROS        ZDAYNO
      *
      ***  Check that value date is not a holiday in the deal / local CCY
      *
     C     WTYPE         IFNE      '00'
     C     WTYPE         ANDNE     '  '
      *
     C                   Z-ADD     MRVDAT        ZDAYNO
      *
      ***  Find currency to use
      *
     C     WTYPE         Ifne      '01'
     C     WTYPE         Andne     '07'
     C     WTYPE         Andne     '08'
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      BJLCCY        ZLOC
     C                   Else
     C                   Move      WTYPE         WrkSetTp          2
      *
     C     MRPTYP        IFEQ      66
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     69
     C     CLE005        OREQ      'Y'
     C     MRPTYP        ANDEQ     72
     C                   Movel     FLPONS        WrkSetNos         2
     C                   ELSE
     C                   Movel     FLRONS        WrkSetNos         2
     C                   Endif
      *
     C     CLE031        IFNE      'Y'                                                        CLE031
     C     CEU004        IFEQ      'Y'
     C     CL_SCCY       ANDNE     *BLANKS
     C                   MOVE      CL_SCCY       WrkSetCCy         3
     C                   MOVE      CL_SCCY       ZCCY
     C                   ELSE
     C                   MOVE      CL_CCY        WrkSetCcy
     C                   MOVE      CL_CCY        ZCCY              3
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      CL_CCY        ZCCY                                         CLE031
     C                   MOVE      CL_CCY        WrkSetCcy                                    CLE031
      *                                                                                       CLE031
     C     CL_PTYP       IFEQ      66                                                         CLE031
     C     CL_PTYP       OREQ      67                                                         CLE031
     C     CL_PTYP       OREQ      69                                                         CLE031
     C     CL_PTYP       OREQ      72                                                         CLE031
     C     CL_SCCY       IFNE      *BLANKS                                                    CLE031
     C                   MOVE      CL_SCCY       ZCCY                                         CLE031
     C                   MOVE      CL_SCCY       WrkSetCcy                                    CLE031
     C                   ENDIF                                                                CLE031
     C                   ELSE                                                                 CLE031
     C     CL_PSCY       IFNE      *BLANKS                                                    CLE031
     C                   MOVE      CL_PSCY       ZCCY                                         CLE031
     C                   MOVE      CL_PSCY       WrkSetCcy                                    CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *
      ***  Find Location
      *
     C                   EXSR      SRFindLoc
      *
     C                   MOVE      WrkSetLoc     ZLOC
      *
     C                   ENDIF
      *
      ***  If date is holiday send warning messages
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM      *BLANK        ZIND              1
      *
     C     WTYPE         IFEQ      '01'
     C     WTYPE         OREQ      '07'
     C     WTYPE         OREQ      '08'
      *
     C     ZIND          IFEQ      'H'
      *
     C                   MOVE      'Y'           WarningSettl
      *
     C     ZCCY          IFEQ      CL_CCY
     C                   MOVEL     'LEM0053'     WMsgIDXAr
     C                   Else
      *
     C     CEU004        IFEQ      'Y'
     C     CLE031        OREQ      'Y'                                                        CLE031
     C                   MOVEL     'LEM0101'     WMsgIDXAr
     C                   Else
     C                   MOVEL     'LEM0052'     WMsgIDXAr
     C                   Endif
      *
     C                   Endif                                                  ZCCY = CL_CCY
      *
     C                   MOVE      'N'           DDVALDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDVALD'      WFldNmXAr(WId)
     C                   ENDIF                                                  ZHIND = 'Y'
      *
     C                   ENDIF                                                  01, 07 or 08
     C                   ENDIF                                                  not 00, '  '
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRFindLoc - Find nostro Location                             *
      *****************************************************************
     C     SRfindLoc     BEGSR
      *
      ***  Initialise working variable - settlement branch location
      *
     C                   MOVE      *BLANKS       WrkSetLoc         3
      *
      ***  For type 01,02,07,08 or 12, settlement location is determined
      ***  by the nostro branch
      *
     C     WrkSetTp      IFEQ      '01'
     C     WrkSetTp      OREQ      '02'
     C     WrkSetTp      OREQ      '07'
     C     WrkSetTp      OREQ      '08'
     C     WrkSetTp      OREQ      '12'
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      WrkSetCcy     @KEYB             3
     C                   PARM      *BLANKS       @KEYC             4
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      WrkSetNos     @KEYE             2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      A7NOSN        WrkSetLoc         3
     C**********         ELSE                                                               MD020626
     C******LOCK         IN        LDA                                                      MD020626
     C**********         Z-ADD     3             DBASE                          ************MD020626
     C**********         MOVEL     'SDNOSTPD'    DBFILE                         * DBERR 03 *MD020626
     C**********         MOVEL     WrkSetCcy     DBKEY                          ************MD020626
     C**********         MOVE      WrkSetNos     DBKEY                                      MD020626
     C**********         OUT       LDA                                                      MD020626
     C**********         EXSR      *PSSR                                                    MD020626
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module.                     *
      *****************************************************************
      *
     C     RESETERRS     BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ***  Reset error & warning fields/message IDs/message data (arrays)
      *
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
                                                                                             BUG5863
      ** Reset Index of Warning errors.                                                      BUG5863
                                                                                             BUG5863
     C                   EVAL      WId = *ZERO                                               BUG5863
      *
      ***  Reset warning flags
      *
     C     SaveMRLNRF    IFNE      MRLNRF
     C     SaveMRVDAT    ORNE      MRVDAT
     C     SaveMRLASN    ORNE      MRLASN
     C                   MOVE      *BLANK        WarningSettl      1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module.                     *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      ***  Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 2 0
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      ***  Set Warning Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C*****I****         SUB       1             WId                                         BUG4351
     C     I             SUB       1             WIdx                                        BUG4351
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      ***  Response mode (1A), from source system common header
     C                   PARM                    RespMode
      ***  Valid Manual Repayment layout (DS) from/to caller
     C                   PARM                    ValidMaPy
     C                   PARM                    ##PAYF                         Payment instructions
     C                   PARM                    ##RECF                         Receive instructions
     C                   PARM                    WTYPE             2            Settlement methode
     C                   PARM                    PassDTA                        Settlement methode
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ***  Array index (3P0) from/to caller
     C************       PARM                    WId                                         BUG4351
     C                   PARM                    WIdx                                        BUG4351
      *
      ***  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEMAPY2VL'   DBPGM
     C                   OUT       LDA
      *
      ***  Define working fields
      *
      *
      ***  Access Bank details via access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  check if feature CEU004 is Activated
      *
     C                   MOVE      'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   Endif
      *                                                                                       CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ***  Determine whether program is running interactively or in batch
      ***   ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RTCD
     C                   PARM                    PMODE             1
      *
      ***  set the message file
      *
     C                   EVAL      #MsgFile = 'LERMSGF'
      *
      ***  Key list for CLOAN
      *
     C     K@LOAN        KLIST
     C**********         KFLD                    K@LNRF            6 0                       CLE148
     C                   KFLD                    K@LNRF            6                         CLE148
     C                   KFLD                    K@RCDT            1
      *
      ***  Program, module and procedure names for database error processing.
      ***  =================================================================
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
