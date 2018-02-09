     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities browse')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSBRW - Securities Browse                                *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - displays a list of Securities for selection.     *
      *            - picks off the selection made.                    *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL014             Date 20Oct03               *
      *                 CSE037             Date 29Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CSE037 - Countervalue rounding - recompile only              *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Browse screen
     FSESECSBDF CF   E             WORKSTN
     F                                     SFILE(SESECSS0:W_Rrn)
     F                                     SFILE(SESECSS1:W_Rrn)
      *
      ** Securities by security shortname
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Securities by security report name
     FSECTR     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SECTYDF:SECTYDR)
      *
      ** Securities by front office id
     FSECTYL4   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SECTYDF:SECTYDI)
      *
      ** Investment types
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
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
      **    True       logical = *ON (for indicator processing)
      **    False      logical = *OFF (for indicator processing)
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      *
      /COPY ZACPYSRC,MSGHNDDCL
      *
      ** The following /COPY line declares the arrays for processing that
      ** take place in the *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
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
      ** Arrays for screen error indicators
     D WZeroise        S              1    DIM(10) CTDATA PERRCD(10)
 
     D KeyLists        DS
     D  SWSESN
     D  SWSRPN
 
     D KeySelect       DS
     D  SWISSR
     D  SWNMCY
     D  SWSITP
     D  SWPRTP
     D  SWINCS
     D  SWISIN
     D  SWT2RF
     D  SWSTAT
 
     D KeySelInd       DS
     D  SelISSR                1      1
     D  SelNMCY                2      2
     D  SelSITP                3      3
     D  SelPRTP                4      4
     D  SelINCS                5      5
     D  SelISIN                6      6
     D  SelT2RF                7      7
     D  SelSTAT                8      8
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  NumericIn             90     90
     D  RecNotFnd             95     95
     D  EndOfFile             96     96
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
 
     D PINKC           S              1A
     D PINKL           S              1A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
 
     D BJMRDT          S              7A
     D BJSBRC          S              3A
 
     D PDBRN           S              3A
     D POpSel          S              1A
     D PErrMS          S              7A
     D PSESNSel        S             10A
     D PActn           S              1A
     D PError          S              1P 0
 
     D OptSelected     S              1A
 
     D WPrvOrd         S              1A
     D W_Cnt           S              3P 0
     D W_Rrn           S              5P 0
 
     D*SNISSR***       S              6P 0                                                    CSD027
     D SNISSR          S              6A                                                      CSD027
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
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
      ** Initialisation.
      *
     C                   EXSR      SRInit
      *
      ** Build subfile.
      *
     C                   IF        PBdSfl = 'Y'
      *
      ** If first time in or subfile by backoffice key was previously
      ** being run, then build subfile keyed on security short name.
      ** Stay in loop while F11 toggle key is used.
      *
     C                   IF        WPrvOrd <> 'F'
 
     C                   DOU       *INKK = *OFF
 
     C                   EXSR      SRBldSfl1
      *
      ** If F11, switch to subfile by front office id.
      *
     C                   IF        *INKK = *ON
     C                   EXSR      SRBldSfl2
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ELSE
      *
      ** If the subfile by front office identifier was previously
      ** being run, then build subfile keyed on front office id.
      ** Stay in loop while F11 toggle key is used.
      *
     C                   DOU       *INKK = *OFF
 
     C                   EXSR      SRBldSfl2
      *
      ** If F11, switch to subfile by security short name.
      *
     C                   IF        *INKK = *ON
     C                   EXSR      SRBldSfl1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Read subfile record.
      *
     C                   IF        PRdSfl = 'Y'
     C                   EXSR      SRRdSfl
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialisation Processing                           *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *
      ** Clear output.
      *
     C                   EVAL      PINKC = '0'
     C                   EVAL      PINKL = '0'
     C                   EVAL      PErrMs = *BLANKS
     C                   EVAL      POpSel = *BLANKS
     C                   EVAL      PSESNSel = *BLANKS
 
     C                   EVAL      OptSelected = 'N'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl1 - Build Subfile by Midas Security Reference        *
      *                                                               *
      *****************************************************************
     C     SRBldSfl1     BEGSR
      *
      ** Set flag for security shortname key used.
      *
     C                   EVAL      WPrvOrd = 'B'
      *
      ** Check for user authority to browse if not multi-branch environment.
      *
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             W_Rrn
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
      *
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SESECSC0
     C                   EVAL      *IN97 = *OFF
      *
      ** Select screen footer for the screen.
      *
     C                   WRITE     SESECSF1
      *
      ** Set record pointer to key field used.
      *
     C     SWSESN        SETLL     SECTY
      *
      ** Read a security from file.
      *
     C                   EXSR      SRRdSecs
      *
      ** If no record read, set up an error message.
      *
     C                   IF        EndOfFile = True
      *
      ** If key/select keys are  blank, display 'No Securities present.'.
      *
     C                   IF        KeyLists = *BLANKS AND
     C                             KeySelect = *BLANKS
     C                   EVAL      PErrMs = 'SEA0300'
     C                   ELSE
      *
      ** Else, display 'No Securities to display for the selection
      ** made.'.
      *
     C                   EVAL      PErrMs = 'SEA0301'
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   EVAL      *IN98 = *ON
      *
      ** While ROLLUP, build a subfile page.
      *
     C                   DOW       *IN98 = *ON  OR OptSelected <> 'Y'
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             W_Cnt
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C                   DOW       EndOfFile = False AND
     C                             W_Cnt < 14
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             W_Rrn
     C                   ADD       1             W_Cnt
      *
      ** Format fields for output.
      *
     C                   EXSR      SRFmtDet
      *
      ** Write the securities details to subfile.
      *
     C                   EVAL      SOPTN = *BLANK
     C                   Z-ADD     W_Rrn         SSFRN
     C                   WRITE     SESECSS0
      *
      ** Read next security.
      *
     C                   EXSR      SRRdSecs
 
     C                   ENDDO
      *
      ** Retrieve time for display.
      *
     C                   TIME                    STIME
      *
      ** Write and read the subfile control.
      *
     C                   EXFMT     SESECSC0
      *
      ** If F3, bypass further processing for this module.
      *
     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** If F11, bypass further processing for this loop.
      *
     C                   IF        *INKK = *ON
     C                   GOTO      ESRBldSfl1
     C                   ENDIF
      *
      ** If F12, bypass further processing this module.
      *
     C                   IF        *INKL = *ON
     C                   EVAL      PINKL = '1'
     C                   CLEAR                   SWFRNT
     C                   CLEAR                   KeyLists
     C                   CLEAR                   KeySelect
     C                   RETURN
     C                   ENDIF
      *
      ** Set record pointer if applicable.
      ** Initialise subfile before refilling.
      ** Read a security to subfile.
      *
     C                   IF        *IN98 <> *ON
      *
      ** Check if a valid option has been selected.
      *
     C                   EXSR      SRChkOption
      *
      ** No option has been selected, process key/selection fields.
      *
     C                   IF        OptSelected <> 'Y'
      *
      ** Clear message subfile and reset error indicators.
      *
     C                   CALL      'ZA0250'
 
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   MOVEA     WZeroise      *IN(60)
 
     C     SWSESN        SETLL     SECTY
 
     C                   EXSR      SRRdSecs
      *
      ** The key/selection fields refer to a record, set pointer and rebuild
      ** sub-file page.  Else, display corresponding error message.
      *
     C                   IF        EndOfFile = False
     C                   Z-ADD     0             W_Rrn
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SESECSC0
     C                   EVAL      *IN97 = *OFF
 
     C                   ELSE
 
     C                   EVAL      MsgIdArr(1) = 'SEA0301'
     C                   EVAL      FldNameArr(1) = '*ANY'
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
 
     C                   IF        SelISSR = 'N' OR SWISSR <> *BLANKS
     C                   EVAL      *IN61 = *ON
     C                   ENDIF
     C                   IF        SelNMCY = 'N' OR SWNMCY <> *BLANKS
     C                   EVAL      *IN62 = *ON
     C                   ENDIF
     C                   IF        SelSITP = 'N' OR SWSITP <> *BLANKS
     C                   EVAL      *IN63 = *ON
     C                   ENDIF
     C                   IF        SelPRTP = 'N' OR SWPRTP <> *BLANKS
     C                   EVAL      *IN64 = *ON
     C                   ENDIF
     C                   IF        SelINCS = 'N' OR SWINCS <> *BLANKS
     C                   EVAL      *IN65 = *ON
     C                   ENDIF
     C                   IF        SelISIN = 'N' OR SWISIN <> *BLANKS
     C                   EVAL      *IN66 = *ON
     C                   ENDIF
     C                   IF        SelT2RF = 'N' OR SWT2RF <> *BLANKS
     C                   EVAL      *IN67 = *ON
     C                   ENDIF
     C                   IF        SelSTAT = 'N' OR SWSTAT <> *BLANKS
     C                   EVAL      *IN68 = *ON
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Write message sub-file for error messages.
      *
     C                   WRITE     SESECSC2
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C     ESRBldSfl1    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl2 - Build Subfile by Front Office Id                 *
      *                                                               *
      *****************************************************************
     C     SRBldSfl2     BEGSR
      *
      ** Set flag for front office id key used.
      *
     C                   EVAL      WPrvOrd = 'F'
      *
      ** Check for user authority to browse if not multi-branch environment.
      *
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             W_Rrn
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
      *
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SESECSC1
     C                   EVAL      *IN97 = *OFF
      *
      ** Select screen footer for the screen.
      *
     C                   WRITE     SESECSF1
      *
      ** Set record pointer to key record used with priority to first key.
      *
     C                   SELECT
     C                   WHEN      SWFRNT <> *BLANKS
     C     SWFRNT        SETLL     SECTYL4
     C                   WHEN      SWSESN <> *BLANKS
     C     SWSESN        SETLL     SECTY
     C                   WHEN      SWSRPN <> *BLANKS
     C     SWSRPN        SETLL     SECTR
     C                   OTHER
     C     *LOVAL        SETLL     SECTYL4
     C                   ENDSL
      *
      ** Read an incoming payment from file.
      *
     C                   EXSR      SRRdSecs
      *
      ** If no record read, set up an error message.  Display
      ** 'No Securities present.'.
      *
     C                   IF        EndOfFile = True
     C                   EVAL      PErrMs = 'SEA0300'
     C                   EVAL      SSESN = *BLANKS
     C                   RETURN
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   EVAL      *IN98 = *ON
      *
      ** While ROLLUP, build a subfile page.
      *
     C                   DOW       *IN98 = *ON OR OptSelected <> 'Y'
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             W_Cnt
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C                   DOW       EndOfFile = False AND
     C                             W_Cnt < 14
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             W_Rrn
     C                   ADD       1             W_Cnt
      *
      ** Format fields for output.
      *
     C                   EXSR      SRFmtDet
      *
      ** Write the security details to subfile.
      *
     C                   EVAL      SOPTN = *BLANK
     C                   Z-ADD     W_Rrn         SSFRN
     C                   WRITE     SESECSS1
      *
      ** Read next security.
      *
     C                   EXSR      SRRdSecs
 
     C                   ENDDO
      *
      ** Retrieve time for display.
      *
     C                   TIME                    STIME
      *
      ** Write and read the subfile control.
      *
     C                   EXFMT     SESECSC1
      *
      ** If F3, bypass further processing for this module.
      *
     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** If F11, bypass further processing for this loop.
      *
     C                   IF        *INKK = *ON
     C                   GOTO      ESRBldSfl2
     C                   ENDIF
      *
      ** If F12, bypass further processing for this module.
      *
     C                   IF        *INKL = *ON
     C                   EVAL      PINKL = '1'
     C                   CLEAR                   SWFRNT
     C                   CLEAR                   KeyLists
     C                   CLEAR                   KeySelect
     C                   RETURN
     C                   ENDIF
 
     C                   EXSR      SRChkOption
      *
      ** Set record pointer if applicable.
      ** Initialise subfile before refilling.
      ** Read a security to subfile.
      *
     C                   IF        *IN98 <> *ON AND OptSelected <> 'Y'
      *
      ** Clear message subfile and reset error indicators.
      *
     C                   CALL      'ZA0250'
 
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   MOVEA     WZeroise      *IN(60)
 
     C                   SELECT
     C                   WHEN      SWFRNT <> *BLANKS
     C     SWFRNT        SETLL     SECTYL4
     C                   WHEN      SWSESN <> *BLANKS
     C     SWSESN        SETLL     SECTY
     C                   WHEN      SWSRPN <> *BLANKS
     C     SWSRPN        SETLL     SECTR
     C                   OTHER
     C     *LOVAL        SETLL     SECTYL4
     C                   ENDSL
 
     C                   EXSR      SRRdSecs
 
     C                   IF        EndOfFile = False
     C                   Z-ADD     0             W_Rrn
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SESECSC1
     C                   EVAL      *IN97 = *OFF
 
     C                   ELSE
 
     C                   EVAL      MsgIdArr(1) = 'SEA0301'
     C                   EVAL      FldNameArr(1) = '*ANY'
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
 
     C                   IF        SelISSR = 'N' OR SWISSR <> *BLANKS
     C                   EVAL      *IN61 = *ON
     C                   ENDIF
     C                   IF        SelNMCY = 'N' OR SWNMCY <> *BLANKS
     C                   EVAL      *IN62 = *ON
     C                   ENDIF
     C                   IF        SelSITP = 'N' OR SWSITP <> *BLANKS
     C                   EVAL      *IN63 = *ON
     C                   ENDIF
     C                   IF        SelPRTP = 'N' OR SWPRTP <> *BLANKS
     C                   EVAL      *IN64 = *ON
     C                   ENDIF
 
     C                   ENDIF
 
     C                   WRITE     SESECSC2
 
     C                   ENDIF
 
     C                   ENDDO
 
     C     ESRBldSfl2    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdSfl - Read Subfile Record                                *
      *                                                               *
      *****************************************************************
     C     SRRdSfl       BEGSR
      *
      ** Read the subfile for selected records.
      ** Only process those for which the option field is not blank.
      *
     C                   DOU       *IN99 = *ON OR
     C                             SOPTN <> *BLANK
 
     C                   IF        WPrvOrd <> 'F'
     C                   READC     SESECSS0                               99
     C                   ELSE
     C                   READC     SESECSS1                               99
     C                   ENDIF
 
     C                   ENDDO
      *
      ** Return the selected option and security short name.
      *
     C                   IF        *IN99 <> *ON AND
     C                             SOPTN <> *BLANK
 
     C                   IF        SOPTN = 'A' OR SOPTN = 'E' OR SOPTN = 'D'
     C                   EVAL      POpSel = SOPTN
     C                   ELSE
     C                   EVAL      POpSel = 'E'
     C                   ENDIF
 
     C                   EVAL      PSESNSel = SSESN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkAut - Check for user authority if not multi-branching   *
      *                                                               *
      *****************************************************************
     C     SRChkAut      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PActn
     C                   PARM      *ZERO         PError
      *
      ** Return error message.
      *
     C                   IF        PError = 1
     C                   EVAL      PErrMs = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdSecs - Read a Valid Security from file                   *
      *                                                               *
      *****************************************************************
     C     SRRdSecs      BEGSR
      *
      ** Read the file initially - if EndOfFile is set on, then the end of
      ** the file has been reached.  Read until a valid record is
      ** found or until no more records exist.
      *
     C                   DOU       EndOfFile = True OR
     C                             PError = *Zero
      *
      ** Read the file by back office or front office key.
      *
     C                   IF        WPrvOrd = 'B'
     C                   READ      SECTY                                  96
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      SWFRNT <> *BLANKS
     C                   READ      SECTYL4                                96
     C                   WHEN      SWSESN <> *BLANKS
     C                   READ      SECTY                                  96
     C                   WHEN      SWSRPN <> *BLANKS
     C                   READ      SECTR                                  96
     C                   OTHER
     C                   READ      SECTYL4                                96
     C                   ENDSL
 
     C                   ENDIF
 
     C                   IF        EndOfFile = False
      *
      ** If security read, check whether user can see it.
      *
     C                   IF        BJSBRC = *BLANKS
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           PActn
     C                   PARM                    PDBRN
     C                   PARM      *ZERO         PError
     C                   ENDIF
 
     C                   IF        PError = 0
      *
      ** Setup status fields for further processing.
     C                   EVAL      SSTAT = *BLANKS
 
     C                   SELECT
     C                   WHEN      RECI = 'D'
     C                   EVAL      SSTAT = 'LIVE      '
     C                   WHEN      RECI = 'M'
     C                   EVAL      SSTAT = 'MATURED   '
     C                   WHEN      RECI = 'C'
     C                   EVAL      SSTAT = 'CANCELLED '
     C                   ENDSL
 
     C     KInvTyp       CHAIN     INVTP                              95
 
     C                   IF        RecNotFnd = True
     C                   EVAL      DBKey = NMCY + SITP
     C                   EVAL      DBFile = 'INVTPD'
     C                   Z-ADD     1             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check whether record read passes selection criteria.
      *
     C                   EVAL      KeySelInd = *BLANKS
 
     C**********         TESTN                   SWISSR               90                      CSD027
      **********                                                                              CSD027
     C**********         IF        NumericIn = True OR SWISSR = *BLANKS                       CSD027
     C                   MOVEL     SWISSR        SNISSR
     C**********         ENDIF                                                                CSD027
 
     C                   SELECT
     C                   WHEN      SWISSR <> *BLANKS AND SNISSR <> ISSR OR
     C                             NumericIn = False AND SWISSR <> *BLANKS
     C                   EVAL      SelISSR = 'N'
     C                   WHEN      SWNMCY <> *BLANKS AND SWNMCY <> NMCY
     C                   EVAL      SelNMCY = 'N'
     C                   WHEN      SWSITP <> *BLANKS AND SWSITP <> SITP
     C                   EVAL      SelSITP = 'N'
     C                   WHEN      SWPRTP <> *BLANKS AND SWPRTP <> PROT
     C                   EVAL      SelPRTP = 'N'
     C                   WHEN      SWINCS <> *BLANKS AND SWINCS <> INCS
     C                   EVAL      SelINCS = 'N'
     C                   WHEN      SWISIN <> *BLANKS AND SWISIN <> ISIN
     C                   EVAL      SelISIN = 'N'
     C                   WHEN      SWT2RF <> *BLANKS AND SWT2RF <> T2RF
     C                   EVAL      SelT2RF = 'N'
     C                   WHEN      SWSTAT <> *BLANKS AND SWSTAT <> SSTAT
     C                   EVAL      SelSTAT = 'N'
     C                   ENDSL
 
     C                   IF        KeySelInd <> *BLANKS
     C                   Z-ADD     1             PError
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDet - Format Securities Details for Output to Subfile   *
      *                                                               *
      *****************************************************************
     C     SRFmtDet      BEGSR
      *
      ** Security short name.
     C                   EVAL      SSESN = SESN
      *
      ** Security report name.
     C                   EVAL      SSRPN = SRPN
      *
      ** Front office transaction id.
     C                   EVAL      SFRNT = FRNT
      *
      ** Issuer.
     C                   MOVEL     ISSR          SISSR
      *
      ** Nominal ccy.
     C                   EVAL      SNMCY = NMCY
      *
      ** Investment type.
     C                   EVAL      SSITP = SITP
      *
      ** Processing type.
     C                   EVAL      SPRTP = PROT
      *
      ** Incomplete indicator.
     C                   EVAL      SINCS = INCS
      *
      ** ISIN number.
     C                   EVAL      SISIN = ISIN
      *
      ** Telekurs.
     C                   EVAL      ST2RF = T2RF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkOption - Check if an option has been selected           *
      *                                                               *
      *****************************************************************
      *
     C     SRChkOption   BEGSR
      *
      ** Read subfile if an option has been selected.
      *
     C                   DOU       *IN99 = '1' OR SOPTN <> *BLANK
 
     C                   IF        WPrvOrd = 'B'
     C                   READC     SESECSS0                               99
     C                   ELSE
     C                   READC     SESECSS1                               99
     C                   ENDIF
 
     C                   ENDDO
      *
      ** Activate SFLNXTCHG for the record to be read in the
      ** get-next-changed operation.
      *
     C     *IN99         IFEQ      '0'
 
     C                   EVAL      *IN93 = '1'
 
     C                   IF        WPrvOrd = 'B'
     C                   UPDATE    SESECSS0
     C                   ELSE
     C                   UPDATE    SESECSS1
     C                   ENDIF
 
     C                   EVAL      *IN93 = '0'
 
     C                   IF        WPrvOrd = 'B'
     C                   WRITE     SESECSC0
     C                   ELSE
     C                   WRITE     SESECSC1
     C                   ENDIF
 
     C                   CLEAR                   SWFRNT
     C                   CLEAR                   KeyLists
     C                   CLEAR                   KeySelect
 
     C                   EVAL      OptSelected = 'Y'
 
     C                   ELSE
 
     C                   EVAL      OptSelected = 'N'
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP2
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
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Input
      ** =====
      *
     C                   PARM                    RetCodeIn
      *
      ** Key fields (file pointer)
     C                   PARM                    KeyLists
      *
      ** Selection fields (file select)
     C                   PARM                    KeySelect
      *
      ** Build subfile
     C                   PARM                    PBdSfl
      *
      ** Read subfile record
     C                   PARM                    PRdSfl
      *
      ** Standing data
      ** =============
      *
      ** SDBANK - midas rundate
     C                   PARM                    BJMRDT
      *
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - default user branch
     C                   PARM                    PDBRN
      *
      ** Output
      ** ======
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Option selected
     C                   PARM                    POpSel
      *
      ** Security selected
     C                   PARM                    PSESNSel
      *
      ** Function key enabled - F3
     C                   PARM                    PINKC
      *
      ** Function key enabled - F12
     C                   PARM                    PINKL
      *
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SDATE = BJMRDT
     C                   EVAL      SJOBNAME = PSJOBNAME
      *
     C     KInvTyp       KLIST
     C                   KFLD                    NMCY
     C                   KFLD                    SITP
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   MOVEL     '*'           SPGMQ
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
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
**  WZeroise
000000000
