     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal Funding Deals Browse')               *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDBRW - Internal Funding Deals Browse                    *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of deals for selection,        *
      *             the other picks off the selection made.           *
      *                                                               *
      *  Component of: ABFUNDSIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL019             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End Of File  (used by read)                     *
      *    02         Record not Found  (used by chain)               *
      *    96         Subfile End                                     *
      *    97         Subfile Clear                                   *
      *    98         Use for subfile manipulation (RollUp)           *
      *    99         No Subfile Change record                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRBldSfl   - Build subfile                                   *
      *  SRBldSfl1  - Build subfile keyed on deal number              *
      *  SRBldSfl2  - Build subfile keyed on front office id          *
      *  SRRdSflR   - Read Subfile Record                             *
      *  SRChkAut   - Check for user authority if not multi branching *
      *  SRFmtDeal1 - Format deal fields for output (deal)            *
      *  SRFmtDeal2 - Format deal fields for output (associated deal) *
      *  SRRdDeal   - Read a Valid Deal                               *
      *  SRValDln   - Validate deal number                            *
      *  SRFmtAmt   - Format maount for display                       *
      *  SRCvtDate  - Convert date from YYYYMMDD to DDMMYY (or MMDDYY)*
      *  SRFmtEdtAmt- Format edited amount                            *
      *  SRZAlign   - Validate numeric fields                         *
      *  SRInit     - Initialisation of variables used.               *
      *                                                               *
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
 
     FABFUNDBRDFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(ABFUNDBRS1:WkSRRN)
     F                                     SFILE(ABFUNDBRS2:WkSRRN)
     FABFUNDL0  IF   E           K DISK    INFSR(*PSSR)
     FABFUNDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDELDP0:MMDELDX0)
 
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
      **    False      logical = *off (for indicator processing)
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
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
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
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
     D  RecNotFnd             02     02
     D  SFleEnd               96     96
     D  SFleClr               97     97
     D  RollUp                98     98
     D  NoSflChgRec           99     99
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PDealNum        S              6A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PErrMs          S              7A
     D POpSel          S              1A
     D PDlSel          S              6A
     D PExit           S              1A
     D PCancel         S              1A
     D PBJSBRC         S              3A
     D PBJDFIN         S              1A
     D PBJMRDT         S              7A
     D PBKOBUV         S              1A
     D PBNDCSP         S              1A
     D PBNTHSP         S              1A
 
      ** Parameters for program ZVACTU, ZA0920, ZA0770, ZA1020,
      ** ZVACTBU, and ZVOBU
     D PErr            S              1  0
     D PAmtIn          S             13  0
     D PAmtOut         S             14A
     D PDateOut        S              6  0
     D PInAmt          S             15  0
     D PNoOfDecPl      S              1  0
     D PNoOfChar       S              2  0
     D PCcyDecPl       S              1  0
     D PDspAmt         S             21A
 
      ** Parameters for ZALIGN
     D PZAlignOk       S              1A
     D PZField         S             16A
     D PZADEC          S              1P 0
     D PZADIG          S              2P 0
 
      ** Work Variables
     D WkSRRN          S              5  0
     D WkCnt           S              3  0
     D WToggleFlag     S              1A
     D WDlNo           S              6  0
     D WkDLNO          S              6A
     D WkOPTN          S              1A
     D WFntOfcId       S             20A
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initialisation
 
     C                   EXSR      SRInit
 
      ** Build subfile.
 
     C                   IF        PBdSfl = 'Y'
 
     C                   EXSR      SRBldSfl
 
     C                   ENDIF
 
      ** Read Subfile Record
 
     C                   IF        PRdSfl = 'Y'
     C                   EXSR      SRRdSflR
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl - Build Subfile                                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
 
      ** If First time in or subfile by Midas deal number was previously
      ** being run, then build subfile keyed on Midas deal number.
      ** Stay in loop while F11 toggle key is used.
 
     C                   IF        WToggleFlag = 'B'
     C                   DOU       *INKK = '0'
     C                   EXSR      SRBldSfl1
 
      ** If F11, switch to Front Office Deal subfile
 
     C                   IF        *INKK = '1'
     C                   EXSR      SRBldSfl2
     C                   ENDIF
     C                   ENDDO
 
     C                   ELSE
 
      ** If the subfile by Front Office Identifier was previously
      ** being run, then build subfile keyed on Front Office ID.
      ** Stay in loop while F11 toggle key is used.
 
     C                   DOU       *INKK = '0'
     C                   EXSR      SRBldSfl2
 
      ** If F11, switch to Midas Deal Number subfile
 
     C                   IF        *INKK = '1'
     C                   EXSR      SRBldSfl1
     C                   ENDIF
 
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl1 - Build Subfile by Deal Number                      *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRBldSfl1     BEGSR
 
     C                   EVAL      EndOfFile = False
     C                   EVAL      RecNotFnd = False
     C                   EVAL      SFleEnd = False
 
      ** Set WToggleFlag to 'B' for Midas (back) office deal number key used
 
     C                   EVAL      WToggleFlag = 'B'
 
      ** Check for user Authority to Browse if not multi-branching
 
     C                   IF        PBJSBRC <> *Blanks
     C                   EXSR      SRChkAut
     C                   ENDIF
 
      ** Validate deal number (for pointer).
 
     C                   IF        WDlNo = 0
     C                   EXSR      SRValDln
     C                   ENDIF
 
      ** Initialise subfile relative record number.
 
     C                   EVAL      WkSRRN = 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   EVAL      SFleClr = True
     C                   WRITE     ABFUNDBRC1
     C                   EVAL      SFleClr = False
 
      ** Write the select screen footer to the screen.
 
     C                   WRITE     ABFUNDBRF0
 
      ** Set file pointer to start of file
 
     C     WDlNo         SETLL     ABFUNDL0
 
      ** Read a Valid Deal
 
     C                   EXSR      SRRdDeal
 
      ** If no records exist - set up an error message.
      ** Set up an error message and terminate.
 
     C                   IF        EndOfFile = True
     C                   EVAL      PErrMs = 'MMM1007'
     C                   RETURN
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      RollUp = True
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
 
     C                   DOW       #1OPTN = *BLANK AND RollUp = True
 
      ** Initialise count of records written to subfile page.
 
     C                   EVAL      WkCnt = 0
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       EndOfFile = FALSE AND WkCnt < 14
 
      ** Increment the subfile record no. and records written fields.
 
     C                   EVAL      WkSRRN = WkSRRN + 1
     C                   EVAL      WkCnt = WkCnt + 1
 
      ** Move front office ID to variable to be pointer to
      ** subfile2 if user press F11
 
     C                   IF        WKCnt = 1
     C                   EVAL      WFntOfcId = HKFRNT
     C                   ENDIF
 
      ** Format Deal fields for output.
 
     C                   EXSR      SRFmtDeal1
 
      ** Write the deal to the subfile.
 
     C                   EVAL      #1OPTN = *BLANK
     C                   Z-ADD     WkSRRN        #1SFRN
     C                   WRITE     ABFUNDBRS1
 
      ** Read a valid deal
 
     C                   EXSR      SRRdDeal
 
      ** If EndOfFile seton SFleEnd
 
     C                   IF        EndOfFile = True
     C                   EVAL      SFleEnd = True
     C                   ENDIF
 
     C                   ENDDO
 
      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.
 
     C                   EXFMT     ABFUNDBRC1
 
      ** If F3, bypass further processing.
 
     C                   IF        *INKC = *ON
     C                   EVAL      PExit = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F11, bypass further processing.
 
     C                   IF        *INKK = *ON
     C                   GOTO      ESRBldSfl1
     C                   ENDIF
 
      ** If F12, bypass further processing.
 
     C                   IF        *INKL = *ON
     C                   EVAL      PCancel = '1'
     C                   CLEAR                   PDealNum
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
 
     C     ESRBldSfl1    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl2 - Build Subfile by Front Office ID                  *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRBldSfl2     BEGSR
 
     C                   EVAL      EndOfFile = False
     C                   EVAL      RecNotFnd = False
     C                   EVAL      SFleEnd = False
 
      ** Set WToggleFlag to 'B' for Midas (back) office deal number key used
 
     C                   EVAL      WToggleFlag = 'F'
 
      ** Check for user Authority to Browse if not multi-branching
 
     C                   IF        PBJSBRC <> *Blanks
     C                   EXSR      SRChkAut
     C                   ENDIF
 
      ** Initialise subfile relative record number.
 
     C                   EVAL      WkSRRN = 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   EVAL      SFleClr = True
     C                   WRITE     ABFUNDBRC2
     C                   EVAL      SFleClr = False
 
      ** Write the select screen footer to the screen.
 
     C                   WRITE     ABFUNDBRF0
 
      ** Set file pointer to start of file
 
     C     WFntOfcId     SETLL     ABFUNDL1
 
      ** Read a Valid Deal
 
     C                   EXSR      SRRdDeal
 
      ** If no records exist - set up an error message.
      ** Set up an error message and terminate.
 
     C                   IF        EndOfFile = True
     C                   EVAL      PErrMs = 'MMM1007'
     C                   RETURN
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      RollUp = True
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
 
     C                   DOW       #2OPTN = *BLANK AND RollUp = True
 
      ** Initialise count of records written to subfile page.
 
     C                   EVAL      WkCnt = 0
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       EndOfFile <> True AND WkCnt < 14
 
      ** Increment the subfile record no. and records written fields.
 
     C                   EVAL      WkSRRN = WkSRRN + 1
     C                   EVAL      WkCnt = WkCnt + 1
 
      ** Move deal number to variable to be pointer to
      ** subfile1 if user press F11
 
     C                   IF        WKCnt = 1
     C                   EVAL      WDlNo = HKDN38
     C                   ENDIF
 
      ** Format Deal fields for output.
 
     C                   EXSR      SRFmtDeal2
 
      ** Write the deal to the subfile.
 
     C                   EVAL      #2OPTN = *BLANK
     C                   Z-ADD     WkSRRN        #2SFRN
     C                   WRITE     ABFUNDBRS2
 
      ** Read a valid deal
 
     C                   EXSR      SRRdDeal
 
      ** If EndOfFile seton SFleEnd
 
     C                   IF        EndOfFile = True
     C                   EVAL      SFleEnd = True
     C                   ENDIF
 
     C                   ENDDO
 
      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.
 
     C                   EXFMT     ABFUNDBRC2
 
      ** If F3, bypass further processing.
 
     C                   IF        *INKC = *ON
     C                   EVAL      PExit = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F11, bypass further processing.
 
     C                   IF        *INKK = *ON
     C                   GOTO      ESRBldSfl2
     C                   ENDIF
 
      ** If F12, bypass further processing.
 
     C                   IF        *INKL = *ON
     C                   EVAL      PCancel = '1'
     C                   CLEAR                   PDealNum
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
 
     C     ESRBldSfl2    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdSflR - Read Subfile Record                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRRdSflR      BEGSR
 
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
 
     C                   DOU       NoSflChgRec = True OR WkOPTN <> *Blanks
     C                   IF        WToggleFlag <> 'F'
     C                   READC     ABFUNDBRS1                             99
     C                   EVAL      WkOPTN = #1OPTN
     C                   EVAL      WkDLNO = #1DLNO
     C                   ELSE
     C                   READC     ABFUNDBRS2                             99
     C                   EVAL      WkOPTN = #2OPTN
     C                   EVAL      WkDLNO = #2DLNO
     C                   ENDIF
     C                   ENDDO
 
      ** Return the selected deal number and option
 
     C                   IF        NoSflChgRec <> True AND WkOPTN <> *BLANK
 
     C                   IF        WkOPTN = 'A' OR WkOPTN = 'D'
     C                   EVAL      POPSEL = WkOPTN
     C                   ELSE
     C                   EVAL      POPSEL = 'E'
     C                   ENDIF
 
     C                   EVAL      PDLSEL = WkDLNO
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkAut - Check for user authority if not multi-branching    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRChkAut      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ActionCode
     C                   PARM      *ZERO         PErr
 
      ** Return error message
 
     C                   IF        PErr = 1
     C                   EVAL      PErrMs = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFmtDeal1 - Format deal fields for output (for subfile 1)
      *****************************************************************
     C     SRFmtDeal1    BEGSR
 
      ** Deal number
 
     C                   MOVE      HKDN38        #1DLNO
 
      ** Deal type
 
     C                   EVAL      #1DTP1 = HKMTYP
 
      ** Deal currency.
 
     C                   EVAL      #1CCY = HKCCY
 
      ** Deal amount.
 
     C                   IF        HKAMNP < 0
     C                   Z-SUB     HKAMNP        PInAmt
     C                   ELSE
     C                   Z-ADD     HKAMNP        PInAmt
     C                   ENDIF
     C                   Z-ADD     17            PNoOfChar
     C                   Z-ADD     HKCYDP        PCcyDecpl
     C                   EXSR      SRFmtEdAmt
     C                   MOVE      PDspAmt       #1AMNP
 
      ** Value date
 
     C                   Z-ADD     HKVDYY        @YEAR
     C                   Z-ADD     HKVDMM        @MNTH
     C                   Z-ADD     HKVDDD        @DAY
     C                   IF        @DATE <> *ZEROS
     C                   EXSR      SRCvtDate
     C                   MOVE      PDateOut      #1VDAT
     C                   ELSE
     C                   MOVE      *BLANKS       #1VDAT
     C                   ENDIF
 
      ** Maturity date.
 
     C                   Z-ADD     HKMDYY        @YEAR
     C                   Z-ADD     HKMDMM        @MNTH
     C                   Z-ADD     HKMDDD        @DAY
     C                   IF        @DATE <> *ZEROS
 
     C                   IF        HKNTCE = -999
     C                   EXSR      SRCvtDate
     C                   MOVE      PDateOut      #1MDAT
     C                   ELSE
     C                   MOVE      *BLANKS       #1MDAT
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        HKNTCE = *ZEROS
     C                   MOVE      *BLANKS       #1MDAT
     C                   MOVE      'CALL  '      #1MDAT
     C                   ELSE
     C                   MOVE      *BLANKS       #1MDAT
     C                   Z-ADD     HKNTCE        PAmtIn
     C                   Z-ADD     0             PNoOfDecPl
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmtOut       #1MDAT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Deal Sub-type
 
     C                   EVAL      #1STP1 = HKSTYP
 
      ** Book Code
 
     C                   EVAL      #1BOK1 = HKBOKC
 
      ** Branch Code
 
     C                   EVAL      #1BRC1 = HKBRCA
 
      ** Deal status
 
     C                   EVAL      #1STAT = HKDDLT
 
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * SRFmtDeal2 - Format deal fields for output (for subfile 2)
      *****************************************************************
     C     SRFmtDeal2    BEGSR
 
      ** Front Office Deal number
 
     C                   MOVE      HKFRNT        #2FODN
 
      ** Deal number
 
     C                   MOVE      HKDN38        #2DLNO
 
      ** Deal type
 
     C                   EVAL      #2DTP1 = HKMTYP
 
      ** Deal currency.
 
     C                   EVAL      #2CCY = HKCCY
 
      ** Deal amount.
 
     C                   IF        HKAMNP < 0
     C                   Z-SUB     HKAMNP        PInAmt
     C                   ELSE
     C                   Z-ADD     HKAMNP        PInAmt
     C                   ENDIF
     C                   Z-ADD     17            PNoOfChar
     C                   Z-ADD     HKCYDP        PCcyDecpl
     C                   EXSR      SRFmtEdAmt
     C                   MOVE      PDspAmt       #2AMNP
 
      ** Value date
 
     C                   Z-ADD     HKVDYY        @YEAR
     C                   Z-ADD     HKVDMM        @MNTH
     C                   Z-ADD     HKVDDD        @DAY
     C                   IF        @DATE <> *ZEROS
     C                   EXSR      SRCvtDate
     C                   MOVE      PDateOut      #2VDAT
     C                   ELSE
     C                   MOVE      *BLANKS       #2VDAT
     C                   ENDIF
 
      ** Maturity date.
 
     C                   Z-ADD     HKMDYY        @YEAR
     C                   Z-ADD     HKMDMM        @MNTH
     C                   Z-ADD     HKMDDD        @DAY
     C                   IF        @DATE <> *ZEROS
 
     C                   IF        HKNTCE = -999
     C                   EXSR      SRCvtDate
     C                   MOVE      PDateOut      #2MDAT
     C                   ELSE
     C                   MOVE      *BLANKS       #2MDAT
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        HKNTCE = *ZEROS
     C                   MOVE      *BLANKS       #2MDAT
     C                   MOVE      'CALL  '      #2MDAT
     C                   ELSE
     C                   MOVE      *BLANKS       #2MDAT
     C                   Z-ADD     HKNTCE        PAmtIn
     C                   Z-ADD     0             PNoOfDecPl
     C                   EXSR      SRFmtAmt
     C                   MOVE      PAmtOut       #2MDAT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Deal status
 
     C                   EVAL      #2STAT = HKDDLT
 
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * SRRdDeal - Read a deal
      *****************************************************************
     C     SRRdDeal      BEGSR
 
      ** Reset End of File indicator
 
     C                   EVAL      EndOfFile = False
 
      ** Read the file initially - if EndOfFile is set on then the end of
      ** the file has been reached.  Read until a valid record is
      ** found or until no more records exist.
 
     C                   DOU       EndOfFile = True OR HKDLTF = *BLANKS
     C                             AND PErr  = *ZERO  AND HKDSTS = 'A'
 
      ** Read the file.
 
     C                   IF        WToggleFlag = 'B'
     C                   READ      ABFUNDL0                               01
     C                   ELSE
     C                   READ      ABFUNDL1                               01
     C                   ENDIF
 
      ** If deal read, check whether user can see it
 
     C                   IF        EndOfFile = False
     C                   IF        PBJSBRC = *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ActionCode
     C                   PARM                    HKBRCA
     C                   PARM      *ZERO         PErr
     C                   IF        PBKOBUV = 'Y' AND PErr = *ZERO
     C                   CALL      'ZVOBU'
     C                   PARM                    HKORBR
     C                   PARM      *ZERO         PErr
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C     ERDDEL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValDln - Validate deal number pointer
      *****************************************************************
     C     SRValDln      BEGSR
 
      ** Validate that the deal number is numeric or blank.
 
     C                   IF        PDealNum <> *BLANKS
 
     C                   MOVE      *Blanks       PZField
     C                   MOVE      PDealNum      PZField
     C                   Z-ADD     0             PZADEC
     C                   Z-ADD     6             PZADIG
     C                   EXSR      SRZAlign
 
     C                   IF        PZAlignOk = 'N'
 
      ** RETURN ERROR MESSAGE
 
     C                   MOVEL     'MMM0162'     PErrMs
     C                   RETURN
     C                   ELSE
 
      ** Set up the deal number as a numeric field.
 
     C                   MOVE      PZField       WDlNo
     C                   ENDIF
 
     C                   ELSE
 
      ** Move zeroes to the pointer.
 
     C                   EVAL      WDlNo = *ZEROS
 
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * SRFmtAmt - Format amount for display                          *
      *****************************************************************
     C     SRFmtAmt      BEGSR
 
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    PAmtIn
     C                   PARM                    PNoOfDecPl
     C                   PARM                    PBNDCSP
     C                   PARM      *BLANK        PAmtOut
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCvtDate - Convert date from YYYYMMDD to DDMMYY (or MMDDYY)  *
      *****************************************************************
     C     SRCvtDate     BEGSR
 
     C                   CALLB     'ZA0770'
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    @DATE
     C                   PARM                    PBJDFIN
     C                   PARM      *ZERO         PDateOut
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFmtEdAmt - Format edited amount                             *
      *****************************************************************
     C     SRFmtEdAmt    BEGSR
 
     C                   CALLB     'ZA1020'
     C                   PARM                    PInAmt
     C                   PARM                    PNoOfChar
     C                   PARM                    PCcyDecPl
     C                   PARM                    PBNDCSP
     C                   PARM                    PBNTHSP
     C                   PARM      *BLANKS       PDspAmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAlign - Validate numeric fields                           *
      *                                                               *
      *****************************************************************
 
     C     SRZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZAlignOk
     C                   PARM                    PZField
     C                   PARM                    PZADEC
     C                   PARM                    PZADIG
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation of variables used.                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Clear Outputs
 
     C                   EVAL      WkOPTN = *Blanks
     C                   EVAL      #1OPTN = *Blanks
     C                   EVAL      #2OPTN = *Blanks
     C                   EVAL      PErrms = *Blanks
     C                   EVAL      POpSel = *Blanks
     C                   EVAL      PExit = '0'
     C                   EVAL      PCancel = '0'
     C                   EVAL      EndOfFile = False
     C                   EVAL      RecNotFnd = False
     C                   EVAL      SFleEnd = False
     C                   EVAL      WDlNo = 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
      ** Return Code
      ** Deal Number Pointer
      ** Build Sub-file
      ** Read subfile record
 
     C                   PARM                    RetCodeIn
     C                   PARM                    PDealNum
     C                   PARM                    PBdSfl
     C                   PARM                    PRdSfl
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    PBJSBRC
     C                   PARM                    PBJDFIN
     C                   PARM                    PBJMRDT
 
      ** SDGELRPD
      ** ========
 
     C                   PARM                    PBKOBUV
 
      ** SDDEALPD
      ** ========
 
     C                   PARM                    PBNDCSP
     C                   PARM                    PBNTHSP
 
      ** Output Parameters
      ** =================
      ** Error Message
      ** Option Selected
      ** Deal Number Selected
 
     C                   PARM                    PErrMs
     C                   PARM                    POpSel
     C                   PARM                    PDlSel
 
      ** Command Keys
 
     C                   PARM                    PExit
     C                   PARM                    PCancel
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1WSID = PsJobName
     C                   EVAL      #1USER = PSUser
     C                   EVAL      #1RUNA = PBJMRDT
     C                   EVAL      #2WSID = PsJobName
     C                   EVAL      #2USER = PSUser
     C                   EVAL      #2RUNA = PBJMRDT
 
      ** Set WToggleFlag to back office.
 
     C                   EVAL      WToggleFlag = 'B'
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
