     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/collars/floors browse')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCACFBRW - Caps/Collars/Floors Browse                       *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One displays a list of Caps/Collars/Floors deals  *
      *             for selection; the other picks off the selection  *
      *             made.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209386             Date 09Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  209386 - Wrong Message Ids                                   *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    70         For TESTN opcode                                *
      *    71         For TESTZ opcode                                *
      *    84         IRCACFBRDF: SFLNXTCHG                           *
      *    85         IRCACFBRDF: Display/reverse image Status field  *
      *    86         IRCACFBRDF: SFLEND                              *
      *    87         IRCACFBRDF: SFLCLR                              *
      *    88         IRCACFBRDF: ROLLUP                              *
      *    89         End of file for READ/READC of Subfile           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrBldSfl - Build Subfile by Deal Number                      *
      *  SrBldSfl2 - Build Subfile by Front Office Identifier         *
      *  SrChAutN - Check for User Authority if Not Multi-Branching   *
      *  SRChkOptn - Check if an Option was Selected                  *
      *  SrFmtDeal - Format Deal fields for output                    *
      *  SrRdDeal - Read a Valid Deal                                 *
      *  SrRdSflR - Read Subfile Record                               *
      *  SrRtvTxt - Retrieve Text from Message File                   *                       CIR008
      *  SrValKey - Validate Key/Pointer Fields                       *
      *  SrZA1020 - Format Edited Amount                              *
      *  SrZDATE2 - Convert Midas day to DDMMMYY format               *
      *  SrInit - Initialise Output Parameters                        *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Browse display file
     FIRCACFBRDFCF   E             WORKSTN
     F                                     SFILE(IRCACFBS0:@@RRN)
     F                                     SFILE(IRCACFBS1:@@RRN)
 
      ** Caps/Collars/Floors deals - keyed on Deal Number and Deal Type
     FDLCACFL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Caps/Collars/Floors deals - keyed on Deal Tupe and Deal Number
     FDLCACFL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDGF:DLCACFD1)
                                                                                              CIR008
      ** Caps/Collars/Floors deals for Authorisation -                                        CIR008
      ** keyed on Deal Number and Deal Type                                                   CIR008
     FDLCACFL2  IF   E           K DISK    INFSR(*PSSR)                                       CIR008
     F                                     RENAME(DEALSDGF:DLCACFD2)                          CIR008
                                                                                              CIR008
      ** Caps/Collars/Floors deals for Authorisation -                                        CIR008
      ** keyed on Deal Type and Deal Number                                                   CIR008
     FDLCACFL3  IF   E           K DISK    INFSR(*PSSR)                                       CIR008
     F                                     RENAME(DEALSDGF:DLCACFD3)                          CIR008
 
      ** FRA/IRS deals by Front Office ID
     FIRFRAL0   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDGF:DEALSFOID)
                                                                                              CIR008
      ** FRA/IRS deals for Authorisation - by Front Office ID                                 CIR008
     FIRFRAL1   IF   E           K DISK    INFSR(*PSSR)                                       CIR008
     F                                     RENAME(DEALSDGF:DEALSFOL1)                         CIR008
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for General ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for General ledger details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  ACCDBK       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WAmt15d0        S             15P 0
     D WChar21         S             21A
     D WCount          S              3P 0
     D WDate6N         S              6P 0
     D WDate7A         S              7A
     D WDateFmt        S              1A
     D WDlno           S              6P 0
     D WDTyp           S              2A
     D WEof            S              1A
     D WError          S              1P 0
     D WFoid           S             20A
     D WKey            S              1A
     D WMDay           S              5P 0
     D WMsgf           S             10A
     D WMsgID          S              7A
     D WMsgTxt         S             80A
     D WNbdp           S              1P 0
     D WNumChar        S              2P 0
     D WSelection      S              1A
     D WTest           S              1A
     D ZACTN           S              1A
 
     D KDeal           S              6P 0
     D PActn           S              1A
     D PDlno           S              6A
     D PDTyp           S              2A
     D PBldSfl         S              1A
     D PRdSfl          S              1A
     D PErrMsg         S              7A
     D POptSel         S              1A
     D PDlnoSel        S              6A
     D @INKC           S              1A
     D @INKL           S              1A
     D @@RRN           S              5P 0
                                                                                              CIR008
      ** Switchable Feature Parameter                                                         CIR008
     D CIR008          S              1A                                                      CIR008
                                                                                              CIR008
      ** Parameter for SDRTVTXT                                                               CIR008
     D PMsgDNb         S              7A                                                      CIR008
     D PMsgNm          S             10A                                                      CIR008
     D PMsgTxt         S             80A                                                      CIR008
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Clear outputs
 
     C                   EXSR      SrInit
 
      ** Build subfile
 
     C                   IF        PBldSfl = 'Y'
 
      ** If First time in, or subfile by Deal number was previously
      ** being run, then build subfile keyed on Deal number.
 
     C                   IF        WKey <> 'F'
     C                   EVAL      WKey = 'B'
     C                   ENDIF
 
      ** Stay in loop while F11 toggle key is used.
 
     C                   DOU       *INKK = *OFF
 
      ** Initialise position fields
 
     C                   IF        *INKK = *ON
     C                   EVAL      *INKK = *OFF
     C                   EVAL      #0DEAL = *BLANKS
     C                   EVAL      #0TYPE = *BLANKS
     C                   EVAL      #1FRNT = *BLANKS
     C                   EVAL      #1DEAL = *BLANKS
     C                   EVAL      #1TYPE = *BLANKS
     C                   ENDIF
 
     C     WKey          CASEQ     'B'           SrBldSfl
     C     WKey          CASEQ     'F'           SrBldSfl2
     C                   ENDCS
 
     C                   ENDDO
 
     C                   ENDIF
 
      ** Read subfile record
 
     C                   IF        PRdSfl = 'Y'
     C                   EXSR      SrRdSflR
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrBldSfl - Build Subfile by Deal Number                       *
      *****************************************************************
     C     SrBldSfl      BEGSR
 
      ** Set indicator and flag for Midas (back) office deal number key used
 
     C                   EVAL      WKey = 'B'
 
      ** Check for user authority to Browse, if not multi-branching
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      SrChAutN
     C                   ENDIF
 
      ** Validate key/pointer fields
 
     C                   EXSR      SrValKey
 
      ** Initialise subfile relative record number
 
     C                   EVAL      @@RRN = *ZERO
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active
 
     C                   EVAL      *IN87 = *ON
     C                   WRITE     IRCACFBC0
     C                   EVAL      *IN87 = *OFF
 
      ** Write footer to the screen
 
     C                   WRITE     IRCACFBF0
 
      ** Set file pointer on key displayed on screen
                                                                                              CIR008
      ** If CIR008 is installed and Action Code = 'X', use new files                          CIR008
      ** DLCACFL2/DLCACFL3 to select deals with status = 'C' (complete)                       CIR008
      ** or 'R' (requires re-authorisation)                                                   CIR008
                                                                                              CIR008
     C                   IF        PActn = 'X' AND CIR008 = 'Y'                               CIR008
                                                                                              CIR008
     C                   SELECT                                                               CIR008
     C                   WHEN      #0DEAL <> *BLANKS                                          CIR008
     C                   MOVE      #0DEAL        KDeal                                        CIR008
     C     KDeal         SETLL     DLCACFL2                                                   CIR008
     C                   WHEN      #0TYPE <> *BLANKS                                          CIR008
     C     #0TYPE        SETLL     DLCACFL3                                                   CIR008
     C                   OTHER                                                                CIR008
     C     KeyDeal       SETLL     DLCACFL2                                                   CIR008
     C                   ENDSL                                                                CIR008
                                                                                              CIR008
     C                   ELSE                                                                 CIR008
 
     C                   SELECT
     C                   WHEN      #0DEAL <> *BLANKS
     C                   MOVE      #0DEAL        KDeal
     C     KDeal         SETLL     DLCACFL0
     C                   WHEN      #0TYPE <> *BLANKS
     C     #0TYPE        SETLL     DLCACFL1
     C                   OTHER
     C     KeyDeal       SETLL     DLCACFL0
     C                   ENDSL
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
 
      ** Read a valid deal
 
     C                   EXSR      SrRdDeal
 
      ** If no records exist, set up 'no data to display' message
      ** and terminate
 
     C                   IF        WEof = 'Y'
     C                   EVAL      PErrMsg = 'MMM1007'
     C                   RETURN
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop
 
     C                   EVAL      *IN88 = *ON
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
 
     C                   DOW       (*IN88 = *ON OR
     C                             WSelection <> 'Y') AND
     C                             *INKK = *OFF
 
      ** Initialise count of records written to subfile page
 
     C                   EVAL      WCount = *ZERO
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       WEof <> 'Y' AND
     C                             WCount < 14
 
      ** Increment the subfile record no. and records written fields
 
     C                   ADD       1             @@RRN
     C                   ADD       1             WCount
 
      ** Format deal fields for output
 
     C                   EXSR      SrFmtDeal
 
      ** Write the deal to the subfile
 
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      #0SFRN = @@RRN
     C                   WRITE     IRCACFBS0
 
      ** Read a valid deal
 
     C                   EXSR      SrRdDeal
     C                   ENDDO
 
      ** Write the subfile control record to display the subfile
 
     C                   WRITE     IRCACFBC0
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
 
     C                   READ      IRCACFBC0                              89
 
      ** If F3 pressed, bypass further processing
 
     C                   IF        *INKC = *ON
     C                   EVAL      @INKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F12 pressed, bypass further processing
 
     C                   IF        *INKL = *ON
     C                   EVAL      @INKL = '1'
     C                   RETURN
     C                   ENDIF
 
      ** If Rollup/rolldown was not pressed
 
     C                   IF        *IN88 <> *ON
     C                   EXSR      SRChkOptn
 
      ** If no option has been selected, process position fields
 
     C                   IF        WSelection <> 'Y'
                                                                                              CIR008
      ** If CIR008 is installed and Action Code = 'X', use new files                          CIR008
      ** DLCACFL2/DLCACFL3 to select deals with status = 'C' (complete)                       CIR008
      ** or 'R' (requires re-authorisation)                                                   CIR008
                                                                                              CIR008
     C                   IF        PActn = 'X' AND CIR008 = 'Y'                               CIR008
                                                                                              CIR008
     C                   SELECT                                                               CIR008
     C                   WHEN      #0DEAL <> *BLANKS                                          CIR008
     C                   MOVE      #0DEAL        KDeal                                        CIR008
     C     KDeal         SETLL     DLCACFL2                                                   CIR008
     C                   WHEN      #0TYPE <> *BLANKS                                          CIR008
     C     #0TYPE        SETLL     DLCACFL3                                                   CIR008
     C                   OTHER                                                                CIR008
     C     *LOVAL        SETLL     DLCACFL2                                                   CIR008
     C                   ENDSL                                                                CIR008
                                                                                              CIR008
     C                   ELSE                                                                 CIR008
 
     C                   SELECT
     C                   WHEN      #0DEAL <> *Blanks
     C                   MOVE      #0DEAL        KDeal
     C     KDeal         SETLL     DLCACFL0
     C                   WHEN      #0TYPE <> *Blanks
     C     #0TYPE        SETLL     DLCACFL1
     C                   OTHER
     C     *LOVAL        SETLL     DLCACFL0
     C                   ENDSL
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
 
     C                   EXSR      SrRdDeal
     C                   IF        WEof <> 'Y'
     C                   EVAL      @@RRN = *ZERO
     C                   EVAL      *IN87 = *ON
     C                   WRITE     IRCACFBC0
     C                   EVAL      *IN87 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** Set indicator and flag for Midas Front Office I.D. key used
 
     C                   IF        *INKK = *ON
     C                   EVAL      WKey = 'F'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrBldSfl2 - Build Subfile by Front Office Identifier          *
      *****************************************************************
     C     SrBldSfl2     BEGSR
 
      ** Set flag and indicator for Front Office ID key used
 
     C                   EVAL      WKey = 'F'
 
      ** Check for user authority to Browse, if not multi-branching
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      SrChAutN
     C                   ENDIF
 
      ** Validate key/pointer fields
 
     C                   EXSR      SrValKey
 
      ** Get Front office ID
                                                                                              CIR008
      ** If CIR008 is installed and Action Code = 'X', use new files                          CIR008
      ** IRFRAL1/DLCACFL2/DLCACFL3 to select deals with status = 'C'                          CIR008
      ** (complete) or 'R' (requires re-authorisation)                                        CIR008
                                                                                              CIR008
     C                   IF        PActn = 'X' AND CIR008 = 'Y'                               CIR008
                                                                                              CIR008
     C                   SELECT                                                               CIR008
     C                   WHEN      #1FRNT <> *BLANKS                                          CIR008
     C     #1FRNT        SETLL     IRFRAL1                                                    CIR008
     C                   WHEN      #1DEAL <> *BLANKS                                          CIR008
     C                   MOVE      #1DEAL        KDeal                                        CIR008
     C     KDeal         SETLL     DLCACFL2                                                   CIR008
     C                   WHEN      #1TYPE <> *BLANKS                                          CIR008
     C     #1TYPE        SETLL     DLCACFL3                                                   CIR008
     C                   OTHER                                                                CIR008
     C     *LOVAL        SETLL     IRFRAL1                                                    CIR008
     C                   ENDSL                                                                CIR008
                                                                                              CIR008
     C                   ELSE                                                                 CIR008
 
     C                   SELECT
     C                   WHEN      #1FRNT <> *BLANKS
     C     #1FRNT        SETLL     IRFRAL0
     C                   WHEN      #1DEAL <> *BLANKS
     C                   MOVE      #1DEAL        KDeal
     C     KDeal         SETLL     DLCACFL0
     C                   WHEN      #1TYPE <> *BLANKS
     C     #1TYPE        SETLL     DLCACFL1
     C                   OTHER
     C     *LOVAL        SETLL     IRFRAL0
     C                   ENDSL
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
 
      ** Read a valid deal
 
     C                   EXSR      SrRdDeal
 
     C                   EVAL      WFoid = FRNT
     C                   IF        WEof = 'Y'
     C                   EVAL      WFoid = *BLANKS
     C                   ENDIF
 
      ** Initialise subfile relative record number
 
     C                   EVAL      @@RRN = 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active
 
     C                   EVAL      *IN87 = *ON
     C                   WRITE     IRCACFBC1
     C                   EVAL      *IN87 = *OFF
 
      ** Write footer to the screen
 
     C                   WRITE     IRCACFBF0
 
      ** Set file pointer on key displayed on screen
 
     C                   IF        PActn = 'X' AND CIR008 = 'Y'                               CIR008
     C     WFoid         SETLL     IRFRAL1                                                    CIR008
     C                   ELSE                                                                 CIR008
     C     WFoid         SETLL     IRFRAL0
     C                   ENDIF                                                                CIR008
 
      ** Read a valid deal
 
     C                   EXSR      SrRdDeal
 
      ** If no records exist, set up 'no data to display' message
      ** and terminate
 
     C                   IF        WEof = 'Y'
     C                   EVAL      PErrMsg = 'MMM1007'
     C                   RETURN
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop
 
     C                   EVAL      *IN88 = *ON
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
 
     C                   DOW       (*IN88 = *ON OR
     C                             WSelection <> 'Y') AND
     C                             *INKK = *OFF
 
      ** Initialise count of records written to subfile page
 
     C                   EVAL      WCount = 0
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       WEof <> 'Y' and
     C                             WCount <  14
 
      ** Increment the subfile record number
      ** and records written fields
 
     C                   EVAL      @@RRN = @@RRN + 1
     C                   EVAL      WCount = WCount + 1
 
      ** Format deal fields for output
 
     C                   EXSR      SrFmtDeal
 
      ** Write the deal to the subfile
 
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      #0SFRN = @@RRN
     C                   WRITE     IRCACFBS1
 
      ** Read a valid deal
 
     C                   EXSR      SrRdDeal
     C                   ENDDO
 
      ** Write the subfile control record to display the subfile
 
     C                   WRITE     IRCACFBC1
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required
 
     C                   READ      IRCACFBC1                              89
 
      ** If F3 pressed, bypass further processing
 
     C                   IF        *INKC = *ON
     C                   EVAL      @INKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F12 pressed, bypass further processing
 
     C                   IF        *INKL = *ON
     C                   EVAL      @INKL = '1'
     C                   RETURN
     C                   ENDIF
 
      ** If Rollup/rolldown was not pressed
 
     C                   IF        *IN88 <> *ON
     C                   EXSR      SRChkOptn
 
      ** If no option has been selected, process position fields
 
     C                   IF        WSelection <> 'Y'
                                                                                              CIR008
      ** If CIR008 is installed and Action Code = 'X', use new files                          CIR008
      ** IRFRAL1/DLCACFL2/DLCACFL3 to select deals with status = 'C'                          CIR008
      ** (complete) or 'R' (requires re-authorisation)                                        CIR008
                                                                                              CIR008
     C                   IF        PActn = 'X' AND CIR008 = 'Y'                               CIR008
                                                                                              CIR008
     C                   SELECT                                                               CIR008
     C                   WHEN      #1FRNT <> *BLANKS                                          CIR008
     C     #1FRNT        SETLL     IRFRAL1                                                    CIR008
     C                   WHEN      #1DEAL <> *BLANKS                                          CIR008
     C                   MOVE      #1DEAL        KDeal                                        CIR008
     C     KDeal         SETLL     DLCACFL2                                                   CIR008
     C                   WHEN      #1TYPE <> *BLANKS                                          CIR008
     C     #1TYPE        SETLL     DLCACFL3                                                   CIR008
     C                   OTHER                                                                CIR008
     C     *LOVAL        SETLL     IRFRAL1                                                    CIR008
     C                   ENDSL                                                                CIR008
                                                                                              CIR008
     C                   ELSE                                                                 CIR008
 
     C                   SELECT
     C                   WHEN      #1FRNT <> *Blanks
     C     #1FRNT        SETLL     IRFRAL0
     C                   WHEN      #1DEAL <> *Blanks
     C                   MOVE      #1DEAL        KDeal
     C     KDeal         SETLL     DLCACFL0
     C                   WHEN      #1TYPE <> *Blanks
     C     #1TYPE        SETLL     DLCACFL1
     C                   OTHER
     C     *LOVAL        SETLL     IRFRAL0
     C                   ENDSL
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
 
     C                   EXSR      SrRdDeal
     C                   IF        WEof <> 'Y'
     C                   EVAL      @@RRN = *ZERO
     C                   EVAL      *IN87 = *ON
     C                   WRITE     IRCACFBC1
     C                   EVAL      *IN87 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** Set indicator and flag for Midas back ofc Deal Number key used
 
     C                   IF        *INKK = *ON
     C                   EVAL      WKey = 'B'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrRdSflR - Read Subfile Record                                *
      *****************************************************************
     C     SrRdSflR      BEGSR
 
      ** Read the subfile for selected records
      ** Only process those for which the option field is blank.
 
     C                   DOU       *IN89 = *ON OR
     C                             #0ACTN <> *BLANK
 
     C                   IF        WKey = 'F'
     C                   READC     IRCACFBS1                              89
     C                   ELSE
     C                   READC     IRCACFBS0                              89
     C                   ENDIF
 
     C                   ENDDO
 
      ** Return the selected deal number and option
 
     C                   IF        *IN89 <> *ON AND
     C                             #0ACTN <> *BLANK
 
     C                   IF        #0ACTN = 'A' OR #0ACTN = 'R'
     C                             OR (#0ACTN = 'X' AND CIR008 = 'Y')                         CIR008
     C                   EVAL      POptSel = #0ACTN
     C                   ELSE
     C                   EVAL      POptSel = 'E'
     C                   ENDIF
 
     C                   EVAL      PDlnoSel = #0DLNO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrFmtDeal - Format Deal fields for output                     *
      *****************************************************************
     C     SrFmtDeal     BEGSR
 
      ** Deal number
 
     C                   MOVE      DLNO          #0DLNO
 
      ** Deal type
 
     C                   EVAL      #0DTYP = DTYP
 
      ** Front Office ID
 
     C                   EVAL      #0FOID = FRNT
 
      ** Currency
 
     C                   EVAL      #0CCY = UCUCY
 
      ** Amount
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    UCUCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        UPAMT < *ZERO
     C                   Z-SUB     UPAMT         WAmt15d0
     C                   ELSE
     C                   Z-ADD     UPAMT         WAmt15d0
     C                   ENDIF
     C                   EVAL      WNbdp = A6NBDP
     C                   EVAL      WNumChar = 17
 
     C                   EXSR      SrZA1020
     C                   MOVE      WChar21       #0AMNT
 
      ** Value date
 
     C                   EVAL      WMDay = VDAT
     C                   IF        WMDay <> *ZERO
     C                   EXSR      SrZDATE2
     C                   MOVE      WDate6N       #0VDAT
     C                   ELSE
     C                   EVAL      #0VDAT = *BLANKS
     C                   ENDIF
 
      ** Maturity date
 
     C                   EVAL      WMDay = MDAT
     C                   IF        WMDay <> *ZERO
     C                   EXSR      SrZDATE2
     C                   MOVE      WDate6N       #0MDAT
     C                   ELSE
     C                   EVAL      #0MDAT = *BLANKS
     C                   ENDIF
 
      ** Customer number
 
     C                   MOVE      CNUM          #0CNUM
 
      ** Status
 
     C                   IF        RECI = 'R'
     C                   EVAL      *IN85 = *ON
     C                   EVAL      WMsgf = 'ZZGBMSGF'
     C                   EVAL      WMsgID = 'ZZM1614'
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    WMsgID
     C                   PARM                    WMsgf
     C                   PARM                    WMsgTxt
 
     C                   EVAL      #0TEXT = WMsgTxt
     C                   ELSE
     C                   EVAL      *IN85 = *OFF
     C                   EVAL      #0TEXT = *BLANKS
     C                   ENDIF
                                                                                              CIR008
      ** If deal is not deleted and CIR008 is installed,                                      CIR008
      ** set up other types of deal status                                                    CIR008
                                                                                              CIR008
     C                   IF        RECI <> 'R' AND CIR008 = 'Y'                               CIR008
     C                   EVAL      PMsgDNb = *BLANKS                                          CIR008
                                                                                              CIR008
     C                   SELECT                                                               CIR008
     C                   WHEN      FIDSTS = 'C'                                               CIR008
     C**********         EVAL      PMsgDNb = 'ZZN9633'                                 CIR008 209386
     C                   EVAL      PMsgDNb = 'APA2058'                                        209386
     C                   WHEN      FIDSTS = 'A'                                               CIR008
     C**********         EVAL      PMsgDNb = 'ZZN9634'                                 CIR008 209386
     C                   EVAL      PMsgDNb = 'APA2059'                                        209386
     C                   WHEN      FIDSTS = 'R'                                               CIR008
     C**********         EVAL      PMsgDNb = 'ZZN9637'                                 CIR008 209386
     C                   EVAL      PMsgDNb = 'APA2062'                                        209386
     C                   WHEN      FIDSTS = 'M'                                               CIR008
     C**********         EVAL      PMsgDNb = 'ZZN9636'                                 CIR008 209386
     C                   EVAL      PMsgDNb = 'APA2061'                                        209386
     C                   ENDSL                                                                CIR008
                                                                                              CIR008
     C                   IF        PMsgDNb <> *BLANKS                                         CIR008
     C                   EVAL      *IN85 = *ON                                                CIR008
     C                   EXSR      SrRtvTxt                                                   CIR008
     C                   EVAL      #0TEXT = PMsgTxt                                           CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      *IN85 = *OFF                                               CIR008
     C                   EVAL      #0TEXT = *BLANKS                                           CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrRdDeal - Read a Valid Deal                                  *
      *****************************************************************
     C     SrRdDeal      BEGSR
 
      ** Reset end of file and skip record indicator
 
     C                   EVAL      WEof = *BLANK
 
      ** Read the file initially - if WEof is set on then the end of
      ** the file has been reached. Read until a valid record is
      ** found or until no more records exist.
 
     C                   DOU       WEof = 'Y' OR
     C                             WError = *ZERO AND
     C                             (DTYP = 'RR' OR DTYP = 'RP' OR
     C                             DTYP = 'RF')
 
      ** Read the file
                                                                                              CIR008
      ** If CIR008 is installed and Action Code = 'X', read new files                         CIR008
      ** DLCACFL2/DLCACFL3 to select deals with status = 'C' (complete)                       CIR008
      ** or 'R' (requires re-authorisation)                                                   CIR008
                                                                                              CIR008
     C                   IF        PActn = 'X' AND CIR008 = 'Y'                               CIR008
                                                                                              CIR008
     C                   IF        WKey = 'B'                                                 CIR008
     C                   SELECT                                                               CIR008
     C                   WHEN      #0DEAL <> *BLANKS                                          CIR008
     C                   READ      DLCACFL2                               86                  CIR008
     C                   WHEN      #0TYPE <> *BLANKS                                          CIR008
     C                   READ      DLCACFL3                               86                  CIR008
     C                   OTHER                                                                CIR008
     C                   READ      DLCACFL2                               86                  CIR008
     C                   ENDSL                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        WKey = 'F'                                                 CIR008
     C                   SELECT                                                               CIR008
     C                   WHEN      #1FRNT <> *BLANKS                                          CIR008
     C                   READ      IRFRAL1                                86                  CIR008
     C                   WHEN      #1DEAL <> *BLANKS                                          CIR008
     C                   READ      DLCACFL2                               86                  CIR008
     C                   WHEN      #1TYPE <> *BLANKS                                          CIR008
     C                   READ      DLCACFL3                               86                  CIR008
     C                   OTHER                                                                CIR008
     C                   READ      IRFRAL1                                86                  CIR008
     C                   ENDSL                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   ELSE                                                                 CIR008
 
     C                   IF        WKey = 'B'
     C                   SELECT
     C                   WHEN      #0DEAL <> *BLANKS
     C                   READ      DLCACFL0                               86
     C                   WHEN      #0TYPE <> *BLANKS
     C                   READ      DLCACFL1                               86
     C                   OTHER
     C                   READ      DLCACFL0                               86
     C                   ENDSL
     C                   ENDIF
 
     C                   IF        WKey = 'F'
     C                   SELECT
     C                   WHEN      #1FRNT <> *BLANKS
     C                   READ      IRFRAL0                                86
     C                   WHEN      #1DEAL <> *BLANKS
     C                   READ      DLCACFL0                               86
     C                   WHEN      #1TYPE <> *BLANKS
     C                   READ      DLCACFL1                               86
     C                   OTHER
     C                   READ      IRFRAL0                                86
     C                   ENDSL
     C                   ENDIF
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
 
      ** End of file
 
     C                   IF        *IN86 = *ON
     C                   EVAL      WEof = 'Y'
     C                   ENDIF
 
      ** If deal read, check whether user can see it
 
     C                   IF        WEof <> 'Y'
     C                   IF        BJSBRC = *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    WError
     C                   IF        BKOBUV = 'Y' AND WError = *ZERO
     C                   CALL      'ZVOBU'
     C                   PARM                    ORBR
     C                   PARM                    WError
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrChAutN - Check for User Authority if Not Multi-Branching    *
      *****************************************************************
     C     SrChAutN      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    WError
 
      ** Return error message
 
     C                   IF        WError = 1
     C                   EVAL      PErrMsg = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrValKey - Validate Key/Pointer Fields                        *
      *****************************************************************
     C     SrValKey      BEGSR
 
      ** Validate that the deal number is numeric or blank
 
     C                   TESTN                   PDlno                70
     C                   MOVE      PDlno         WTest
     C                   TESTZ                   WTest                    71
 
     C                   IF        PDlno = *BLANKS OR
     C                             *IN70 = *ON AND *IN71 = *ON
     C                   MOVE      PDlno         WDlno
     C                   ELSE
     C                   EVAL      PErrMsg = 'MMA0087'
     C                   RETURN
     C                   ENDIF
 
      ** Validate that the deal type is Caps/Collars/Floors or blank
 
     C                   IF        PDTyp = *BLANKS OR
     C                             PDTyp = 'RR' OR PDTyp = 'RP' OR
     C                             PDTyp = 'RF'
     C                   EVAL      WDTyp = PDTyp
     C                   ELSE
     C                   EVAL      PErrMsg = 'MMA0775'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRChkOptn - Check if an Option was Selected                   *
      *****************************************************************
     C     SRChkOptn     BEGSR
 
     C                   DOU       *IN89 = *ON OR
     C                             #0ACTN <> *BLANKS
     C                   IF        WKey = 'B'
     C                   READC     IRCACFBS0                              89
     C                   ENDIF
     C                   IF        WKey = 'F'
     C                   READC     IRCACFBS1                              89
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        *IN89 = *ON
     C                   EVAL      WSelection = 'N'
 
      ** Activate SFLNXTCHG for the record to be read in SrRdDeal
 
     C                   ELSE
     C                   EVAL      WSelection = 'Y'
     C                   EVAL      *IN84 = *ON
 
     C                   IF        WKey = 'B'
     C                   UPDATE    IRCACFBS0
     C                   ELSE
     C                   UPDATE    IRCACFBS1
     C                   ENDIF
 
     C                   EVAL      *IN84 = *OFF
 
     C                   IF        WKey = 'B'
     C                   WRITE     IRCACFBC0
     C                   ELSE
     C                   WRITE     IRCACFBC1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrZA1020 - Format Edited Amount                               *
      *****************************************************************
     C     SrZA1020      BEGSR
 
     C                   CALLB     'ZA1020'
     C                   PARM                    WAmt15d0
     C                   PARM                    WNumChar
     C                   PARM                    WNbdp
     C                   PARM                    BNDCSP
     C                   PARM                    BNTHSP
     C                   PARM      *BLANKS       WChar21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrZDATE2 - Convert Midas day to DDMMMYY format                *
      *****************************************************************
     C     SrZDATE2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    WMDay
     C                   PARM                    WDateFmt
     C                   PARM                    WDate6N
     C                   PARM                    WDate7A
 
     C                   ENDSR
      *****************************************************************                       CIR008
      /EJECT                                                                                  CIR008
      *****************************************************************                       CIR008
      * SrRtvTxt - Retrieve Text from Message File                    *                       CIR008
      *****************************************************************                       CIR008
     C     SrRtvTxt      BEGSR                                                                CIR008
                                                                                              CIR008
     C                   CALL      'SDRTVTXT'                                                 CIR008
     C                   PARM                    PMsgDNb                                      CIR008
     C                   PARM      'ZZGBMSGF'    PMsgNm                                       CIR008
     C                   PARM      *BLANKS       PMsgTxt                                      CIR008
                                                                                              CIR008
     C                   ENDSR                                                                CIR008
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrInit - Initialise Output Parameters                         *
      *****************************************************************
     C     SrInit        BEGSR
 
     C                   EVAL      PErrMsg = *BLANKS
     C                   EVAL      POptSel = *BLANKS
     C                   EVAL      PDlnoSel = *BLANK
     C                   EVAL      @INKC = '0'
     C                   EVAL      @INKL = '0'
     C                   EVAL      *INKK = *OFF
     C                   EVAL      #0DEAL = *BLANKS
     C                   EVAL      #0TYPE = *BLANKS
     C                   EVAL      #1FRNT = *BLANKS
     C                   EVAL      #1DEAL = *BLANKS
     C                   EVAL      #1TYPE = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry parameters
 
     C     *ENTRY        PLIST
 
      ** Input parameters:
      **    Return code
      **    Action code
      **    Deal number pointer
      **    Deal type pointer
      **    Build subfile
      **    Read subfile record
      **    CIR008 Switchable feature                                                         CIR008
     C                   PARM                    RetCodeIn
     C                   PARM                    PActn
     C                   PARM                    PDlno
     C                   PARM                    PDTyp
     C                   PARM                    PBldSfl
     C                   PARM                    PRdSfl
     C                   PARM                    CIR008                                       CIR008
 
      ** Output parameters:
      **    Error message
      **    Option selected
      **    Deal number selected
      **    Command keys
     C                   PARM                    PErrMsg
     C                   PARM                    POptSel
     C                   PARM                    PDlnoSel
     C                   PARM                    @INKC
     C                   PARM                    @INKL
 
      ** Initialise variables
 
     C                   EVAL      DBPGM = 'IRCACFBRW'
     C                   EVAL      #0WID = PsJobName
     C                   EVAL      #0USER = PsUser
 
      ** Declare key lists
 
     C     KeyDeal       KLIST
     C                   KFLD                    WDlno
     C                   KFLD                    WDTyp
 
      ** Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = @OPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** General ledger details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = @OPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Dealing details
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = @OPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
