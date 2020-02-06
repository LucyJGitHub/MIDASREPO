     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security Diary Events Browse')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDEBRW - Security Diary Events Browse                     *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - Displays a list of Security Diary Events         *
      *              for selection.                                   *
      *            - Picks off the selection made.                    *
      *                                                               *
      *  Component of: SESEDESIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    90         Use for numeric validation                      *
      *    95-96      Use for chaining to file                        *
      *    98         Use for subfile manipulation                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRVKeyIn - Validate entry on key fields.                     *
      *  SRBldSfl - Controlling subroutine for subfile building.      *
      *  SRBldSfl1 - Build Subfile by Midas Security shortname.       *
      *  SRBldSfl2 - Build Subfile by Front Office Id                 *
      *  SRRdSfl - Read Subfile Record                                *
      *  SRChkOption - Check if an option has been selected           *
      *  SRChkAut - Check for user authority if not multi-branching   *
      *  SRRdSedev - Read a valid Security Diary Events file          *
      *  SRFmtDet - Format details for output to the subfile          *
      *  SRCvtDat - Convert date to Midas runday number               *
      *  SRFmtDat - Format date for display                           *
      *  SRInit - Initialisation Processing                           *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Browse screen
     FSESEDEBRDFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SESEDEBRS0:W_Rrn)
     F                                     SFILE(SESEDEBRS1:W_Rrn)
      *
      ** Security Diary Events by Shortname, Event date, Event type
     FSEDEVL3   IF   E           K DISK    INFSR(*PSSR)
      *
      ** Security Diary Events by Front Office ID
     FSEDEVL2   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEDEVDF:SEDEVDI)
      *
      ** Security Diary Events by Event date, Shortname & Event type
     FSEDEVL5   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEDEVDF:SEDEVD5)
      *
      ** Security Diary Events by Event type, Shortname & Event date
     FSEDEVL6   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEDEVDF:SEDEVD6)
      *
      ** Security Diary Events by Event date, Event type & Shortname
     FSEDEVL7   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEDEVDF:SEDEVD7)
      *
      ** Security Diary Events by Shortname, Event type & Event date
     FSEDEVL8   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEDEVDF:SEDEVD8)
      *
      ** Securities by security shortname
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S1)
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
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  NumericI1             90     90
     D  RecNotFnd             95     95
     D  EndOfFile             96     96
      *
      ** Key-in subfile record key pointer
     D KeyLists        DS
     D  SWSDSN
     D  SWSDED
     D  SWSDET
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Parameter list for ZDATE1
     D PDateAIn        S              6A
     D PDaynoOut       S              5P 0
     D BJDFIN          S              1A
     D PErrorFlag      S              1A
      *
      ** Parameter list for ZDATE2
     D PDateNIn        S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Work parameters
     D PINKC           S              1A
     D PINKL           S              1A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D POpSel          S              1A
     D PActn           S              1A
     D PError          S              1P 0
     D PSDETSel        S              2A
     D BJSBRC          S              3A
     D PDBRN           S              3A
     D PSDEDSel        S              6A
     D PErrMS          S              7A
     D BJMRDT          S              7A
     D PSDSNSel        S             10A
      *
      ** Work variables
     D KeyFrmBRW       S              1A
     D OptSelected     S              1A
     D WPrvOrd         S              1A
     D W_Cnt           S              3P 0
     D WLCD            S              5P 0
     D W_Rrn           S              5P 0
     D WOrderOf        S              3A
      *
      ** Key fields
     D KSDSN           S             10A
     D KSDEDN          S              5P 0
     D KSDET           S              2A
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
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialisation.
      *
     C                   EXSR      SRInit
      *
      ** Build subfile.
      *
     C                   IF        PBdSfl = 'Y'
      *
      ** Validate key entry.
     C                   EXSR      SRVKeyIn
 
     C                   EXSR      SRBldSfl
 
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
      *  SRVKeyIn - Validate entry on key fields.                     *
      *                                                               *
      *****************************************************************
     C     SRVKeyIn      BEGSR
      *
      ** Validate event date entered.
      *
     C                   IF        SWSDED <> *BLANKS
 
     C                   IF        SWSDED = *ALL'9'
     C                   Z-ADD     99999         KSDEDN
     C                   ELSE
 
     C                   TESTN                   SWSDED               90
 
     C                   IF        NumericI1 = False
     C                   EVAL      PErrorFlag = 'Y'
     C                   ELSE
     C                   MOVEL     SWSDED        PDateAIn
     C                   EXSR      SRCvtDat
     C                   IF        PErrorFlag <> 'Y'
     C                   Z-ADD     PDaynoOut     KSDEDN
     C                   ENDIF
     C                   ENDIF
      *
      ** If error in event date, do not display browse screen.
      *
     C                   IF        PErrorFlag = 'Y'
     C                   IF        KeyFrmBRW <> 'Y'
     C                   EVAL      PErrMs = 'SEA0398'
     C                   RETURN
     C                   ELSE
     C                   EVAL      MsgIdArr(1)  = 'SEA0315'
     C                   EVAL      FldNameArr(1)= '*ANY'
     C                   EVAL      *IN61        = *ON
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      KSDSN = SWSDSN
     C                   EVAL      KSDET = SWSDET
     C                   EVAL      WOrderOf = *BLANKS
 
     C                   SELECT
 
     C                   WHEN      KeyLists = *BLANKS
     C                   EVAL      WOrderOf = 'SDT'
 
     C                   WHEN      SWSDSN <> *BLANKS AND SWSDED <> *BLANKS
     C                             AND SWSDET <> *BLANKS
     C                   EVAL      WOrderOf = 'SDT'
 
     C                   WHEN      SWSDSN <> *BLANKS AND SWSDED = *BLANKS
     C                             AND SWSDET = *BLANKS
     C                   EVAL      WOrderOf = 'SDT'
     C                   EVAL      KSDEDN = *LOVAL
     C                   EVAL      KSDET = *LOVAL
 
     C                   WHEN      SWSDSN <> *BLANKS AND SWSDED <> *BLANKS
     C                             AND SWSDET = *BLANKS
     C                   EVAL      WOrderOf = 'SDT'
     C                   EVAL      KSDET = *LOVAL
 
     C                   WHEN      SWSDSN <> *BLANKS AND SWSDET <> *BLANKS
     C                   EVAL      WOrderOf = 'STD'
 
     C                   WHEN      SWSDED <> *BLANKS AND SWSDET <> *BLANKS
     C                   EVAL      WOrderOf = 'DTS'
 
     C                   WHEN      SWSDED <> *BLANKS
     C                   EVAL      WOrderOf = 'DST'
 
     C                   WHEN      SWSDET <> *BLANKS
     C                   EVAL      WOrderOf = 'TSD'
 
     C                   ENDSL
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Controlling subroutine for subfile building.      *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
      *
      ** If first time in or subfile by backoffice key was previously
      ** being run, then build subfile keyed on security short name.
      ** Stay in loop while toggle key (F11) is used.
      *
     C                   IF        WPrvOrd <> 'F'
 
     C                   DOU       *INKK = *OFF
 
     C                   EXSR      SRBldSfl1
      *
      ** If F11, switch to subfile by front office id.
     C                   IF        *INKK = *ON
     C                   EXSR      SRBldSfl2
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ELSE
      *
      ** If the subfile by front office identifier was previously
      ** being run, then build subfile keyed on front office id.
      ** Stay in loop while toggle key (F11) is used.
     C                   DOU       *INKK = *OFF
 
     C                   EXSR      SRBldSfl2
      *
      ** If F11, switch to subfile by security short name.
     C                   IF        *INKK = *ON
     C                   EXSR      SRBldSfl1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl1 - Build Subfile by Midas Security shortname.       *
      *                                                               *
      *****************************************************************
     C     SRBldSfl1     BEGSR
      *
      ** Set flag for security shortname, event date and event type.
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
     C                   WRITE     SESEDEBRC0
     C                   EVAL      *IN97 = *OFF
      *
      ** Select screen footer for the screen.
      *
     C                   WRITE     SESEDEBRF0
      *
      ** Set record pointer to key field used.
      *
     C                   SELECT
     C                   WHEN      WOrderOf = 'SDT'
     C     KSedev        SETLL     SEDEVL3
     C                   WHEN      WOrderOf = 'DST'
     C     KSedev5       SETLL     SEDEVL5
     C                   WHEN      WOrderOf = 'TSD'
     C     KSedev6       SETLL     SEDEVL6
     C                   WHEN      WOrderOf = 'DTS'
     C     KSedev7       SETLL     SEDEVL7
     C                   WHEN      WOrderOf = 'STD'
     C     KSedev8       SETLL     SEDEVL8
     C                   ENDSL
      *
      ** Read a security diary events from file.
      *
     C                   EXSR      SRRdSedev
      *
      ** If no record read, set up an error message.
      *
     C                   IF        EndOfFile = True
      *
      ** If keys are blank, display 'No Security Diary Events to display.'.
     C                   IF        KeyLists = *BLANKS
     C                   EVAL      PErrMs = 'SEA0353'
     C                   ELSE
      *
      ** Else, display 'No Security Diary Events to display for the selection
      ** made.'.
     C                   EVAL      PErrMs = 'SEA0354'
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
     C                   Z-ADD     0             W_Cnt
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
     C                   DOW       EndOfFile = False AND
     C                             W_Cnt < 14
      *
      ** Increment the subfile record no. and records written fields.
     C                   ADD       1             W_Rrn
     C                   ADD       1             W_Cnt
      *
      ** Format fields for output.
     C                   EXSR      SRFmtDet
      *
      ** Write the Security Diary Events details to subfile.
     C                   EVAL      SOPTN = *BLANK
     C                   Z-ADD     W_Rrn         SSFRN
     C                   WRITE     SESEDEBRS0
      *
      ** Read next diary event.
     C                   EXSR      SRRdSedev
      *
     C                   ENDDO
      *
      ** Retrieve time for display.
     C                   TIME                    STIME
      *
      ** Write and read the subfile control.
     C                   EXFMT     SESEDEBRC0
      *
      ** If F3, bypass further processing for this module.
     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** If F11, bypass further processing for this loop.
     C                   IF        *INKK = *ON
     C                   GOTO      ESRBldSfl1
     C                   ENDIF
      *
      ** If F12, bypass further processing this module.
     C                   IF        *INKL = *ON
     C                   EVAL      PINKL = '1'
     C                   CLEAR                   KeyLists
     C                   EVAL      *IN61 = *OFF
     C                   RETURN
     C                   ENDIF
      *
      ** Set record pointer if applicable.
      ** Initialise subfile before refilling.
      ** Read a security diary events to subfile.
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
     C                   CALL      'ZA0250'
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   EVAL      *IN61 = *OFF
 
     C                   EVAL      KeyFrmBRW = 'Y'
      *
      ** Validate entry on event date.
     C                   EXSR      SRVKeyIn
 
     C                   SELECT
     C                   WHEN      WOrderOf = 'SDT'
     C     KSedev        SETLL     SEDEVL3
     C                   WHEN      WOrderOf = 'DST'
     C     KSedev5       SETLL     SEDEVL5
     C                   WHEN      WOrderOf = 'TSD'
     C     KSedev6       SETLL     SEDEVL6
     C                   WHEN      WOrderOf = 'DTS'
     C     KSedev7       SETLL     SEDEVL7
     C                   WHEN      WOrderOf = 'STD'
     C     KSedev8       SETLL     SEDEVL8
     C                   ENDSL
 
     C                   EXSR      SRRdSedev
      *
      ** The key/selection fields refer to a record, set pointer and rebuild
      ** sub-file page.  Else, display corresponding error message.
      *
     C                   IF        EndOfFile = False
     C                   Z-ADD     0             W_Rrn
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SESEDEBRC0
     C                   EVAL      *IN97 = *OFF
 
     C                   ELSE
 
     C                   EVAL      MsgIdArr(1) = 'SEA0354'
     C                   EVAL      FldNameArr(1) = '*ANY'
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
     C                   ENDIF
      *
      ** Write message sub-file for error messages.
      *
     C                   WRITE     SESEDEBRC2
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C     ESRBldSfl1    ENDSR
      *
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
     C                   WRITE     SESEDEBRC1
     C                   EVAL      *IN97 = *OFF
      *
      ** Select screen footer for the screen.
      *
     C                   WRITE     SESEDEBRF0
      *
      ** Set record pointer to key record used with priority to first key.
      *
     C                   SELECT
     C                   WHEN      SWFRNT <> *BLANKS
     C     SWFRNT        SETLL     SEDEVL2
     C                   WHEN      WOrderOf = 'SDT' AND KeyLists <> *BLANKS
     C     KSedev        SETLL     SEDEVL3
     C                   WHEN      WOrderOf = 'DST' AND KeyLists <> *BLANKS
     C     KSedev5       SETLL     SEDEVL5
     C                   WHEN      WOrderOf = 'TSD' AND KeyLists <> *BLANKS
     C     KSedev6       SETLL     SEDEVL6
     C                   WHEN      WOrderOf = 'DTS' AND KeyLists <> *BLANKS
     C     KSedev7       SETLL     SEDEVL7
     C                   WHEN      WOrderOf = 'STD' AND KeyLists <> *BLANKS
     C     KSedev8       SETLL     SEDEVL8
     C                   OTHER
     C     *LOVAL        SETLL     SEDEVL2
     C                   ENDSL
      *
      ** Read a security diary events from file.
      *
     C                   EXSR      SRRdSedev
      *
      ** If no record read, set up an error message.
      *
     C                   IF        EndOfFile = True
      *
      ** If keys are blank, display 'No Security Diary Events to display.'.
     C                   IF        KeyLists = *BLANKS
     C                   EVAL      PErrMs = 'SEA0353'
     C                   ELSE
      *
      ** Else, display 'No Security Diary Events to display for the selection
      ** made.'.
     C                   EVAL      PErrMs = 'SEA0354'
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
     C                   DOW       *IN98 = *ON OR OptSelected <> 'Y'
      *
      ** Initialise count of records written to subfile page.
     C                   Z-ADD     0             W_Cnt
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
     C                   DOW       EndOfFile = False AND
     C                             W_Cnt < 14
      *
      ** Increment the subfile record no. and records written fields.
     C                   ADD       1             W_Rrn
     C                   ADD       1             W_Cnt
      *
      ** Format fields for output.
     C                   EXSR      SRFmtDet
      *
      ** Write the security details to subfile.
     C                   EVAL      SOPTN = *BLANK
     C                   Z-ADD     W_Rrn         SSFRN
     C                   WRITE     SESEDEBRS1
      *
      ** Read next diary event.
     C                   EXSR      SRRdSedev
      *
     C                   ENDDO
      *
      ** Retrieve time for display.
     C                   TIME                    STIME
      *
      ** Write and read the subfile control.
     C                   EXFMT     SESEDEBRC1
      *
      ** If F3, bypass further processing for this module.
     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** If F11, bypass further processing for this loop.
     C                   IF        *INKK = *ON
     C                   GOTO      ESRBldSfl2
     C                   ENDIF
      *
      ** If F12, bypass further processing for this module.
     C                   IF        *INKL = *ON
     C                   EVAL      PINKL = '1'
     C                   CLEAR                   SWFRNT
     C                   CLEAR                   KeyLists
     C                   EVAL      *IN61 = *OFF
     C                   RETURN
     C                   ENDIF
 
     C                   EXSR      SRChkOption
      *
      ** Set record pointer if applicable.
      ** Initialise subfile before refilling.
      ** Read a security diary events to subfile.
      *
     C                   IF        *IN98 <> *ON AND OptSelected <> 'Y'
      *
      ** Clear message subfile and reset error indicators.
     C                   CALL      'ZA0250'
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   EVAL      *IN61 = *OFF
 
     C                   EVAL      KeyFrmBRW = 'Y'
      *
      ** Validate entry on event date.
     C                   EXSR      SRVKeyIn
 
     C                   SELECT
     C                   WHEN      SWFRNT <> *BLANKS
     C     SWFRNT        SETLL     SEDEVL2
     C                   WHEN      WOrderOf = 'SDT' AND KeyLists <> *BLANKS
     C     KSedev        SETLL     SEDEVL3
     C                   WHEN      WOrderOf = 'DST' AND KeyLists <> *BLANKS
     C     KSedev5       SETLL     SEDEVL5
     C                   WHEN      WOrderOf = 'TSD' AND KeyLists <> *BLANKS
     C     KSedev6       SETLL     SEDEVL6
     C                   WHEN      WOrderOf = 'DTS' AND KeyLists <> *BLANKS
     C     KSedev7       SETLL     SEDEVL7
     C                   WHEN      WOrderOf = 'STD' AND KeyLists <> *BLANKS
     C     KSedev8       SETLL     SEDEVL8
     C                   OTHER
     C     *LOVAL        SETLL     SEDEVL2
     C                   ENDSL
 
     C                   EXSR      SRRdSedev
 
     C                   IF        EndOfFile = False
     C                   Z-ADD     0             W_Rrn
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SESEDEBRC1
     C                   EVAL      *IN97 = *OFF
 
     C                   ELSE
 
     C                   EVAL      MsgIdArr(1) = 'SEA0354'
     C                   EVAL      FldNameArr(1) = '*ANY'
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
     C                   ENDIF
 
     C                   WRITE     SESEDEBRC2
 
     C                   ENDIF
 
     C                   ENDDO
 
     C     ESRBldSfl2    ENDSR
      *
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
     C                   READC     SESEDEBRS0                             99
     C                   ELSE
     C                   READC     SESEDEBRS1                             99
     C                   ENDIF
 
     C                   ENDDO
      *
      ** Return the selected option and security short name, Event date
      ** and Event type.
      *
     C                   IF        *IN99 <> *ON AND
     C                             SOPTN <> *BLANK
 
     C                   IF        SOPTN = 'A' OR SOPTN = 'E' OR SOPTN = 'D'
     C                   EVAL      POpSel = SOPTN
     C                   ELSE
     C                   EVAL      POpSel = 'E'
     C                   ENDIF
 
     C                   EVAL      PSDSNSel = SSDSN
     C                   EVAL      PSDEDSel = SSDED
     C                   EVAL      PSDETSel = SSDET
 
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkOption - Check if an option has been selected           *
      *                                                               *
      *****************************************************************
     C     SRChkOption   BEGSR
      *
      ** Read subfile if an option has been selected.
      *
     C                   DOU       *IN99 = *ON OR SOPTN <> *BLANK
 
     C                   IF        WPrvOrd = 'B'
     C                   READC     SESEDEBRS0                             99
     C                   ELSE
     C                   READC     SESEDEBRS1                             99
     C                   ENDIF
 
     C                   ENDDO
      *
      ** Activate SFLNXTCHG for the record to be read in the
      ** get-next-changed operation.
      *
     C                   IF        *IN99 = *OFF
 
     C                   EVAL      *IN93 = *ON
     C                   IF        WPrvOrd = 'B'
     C                   UPDATE    SESEDEBRS0
     C                   ELSE
     C                   UPDATE    SESEDEBRS1
     C                   ENDIF
     C                   EVAL      *IN93 = *OFF
 
     C                   IF        WPrvOrd = 'B'
     C                   WRITE     SESEDEBRC0
     C                   ELSE
     C                   WRITE     SESEDEBRC1
     C                   ENDIF
 
     C                   CLEAR                   SWFRNT
     C                   CLEAR                   KeyLists
 
     C                   EVAL      OptSelected = 'Y'
 
     C                   ELSE
 
     C                   EVAL      OptSelected = 'N'
 
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
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdSedev - Read a valid Security Diary Events file          *
      *                                                               *
      *****************************************************************
     C     SRRdSedev     BEGSR
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
 
     C                   SELECT
     C                   WHEN      WOrderOf = 'SDT'
     C                   READ      SEDEVL3                                96
     C                   WHEN      WOrderOf = 'DST'
     C                   READ      SEDEVL5                                96
     C                   WHEN      WOrderOf = 'TSD'
     C                   READ      SEDEVL6                                96
     C                   WHEN      WOrderOf = 'DTS'
     C                   READ      SEDEVL7                                96
     C                   WHEN      WOrderOf = 'STD'
     C                   READ      SEDEVL8                                96
     C                   ENDSL
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      SWFRNT <> *BLANKS
     C                   READ      SEDEVL2                                96
     C                   WHEN      WOrderOf = 'SDT' AND KeyLists <> *BLANKS
     C                   READ      SEDEVL3                                96
     C                   WHEN      WOrderOf = 'DST' AND KeyLists <> *BLANKS
     C                   READ      SEDEVL5                                96
     C                   WHEN      WOrderOf = 'TSD' AND KeyLists <> *BLANKS
     C                   READ      SEDEVL6                                96
     C                   WHEN      WOrderOf = 'DTS' AND KeyLists <> *BLANKS
     C                   READ      SEDEVL7                                96
     C                   WHEN      WOrderOf = 'STD' AND KeyLists <> *BLANKS
     C                   READ      SEDEVL8                                96
     C                   OTHER
     C                   READ      SEDEVL2                                96
     C                   ENDSL
 
     C                   ENDIF
 
     C                   IF        EndOfFile = False
      *
      ** If a diary event was read, check whether user can see it.
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
     C                   ENDSL
      *
      ** Get security's nominal currency and investment type
     C     SDSN          CHAIN     SECTY                              95
     C                   IF        RecNotFnd = True
     C                   EVAL      DBKey  = SDSN
     C                   EVAL      DBFile = 'SECTYD'
     C                   EVAL      DBase = 001
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Get security's processing type
     C     KCcyInvTp     CHAIN     INVTP                              95
     C                   IF        RecNotFnd = True
     C                   EVAL      DBKey  = S1NMCY + S1SITP
     C                   EVAL      DBFile = 'INVTPD'
     C                   EVAL      DBase  = 002
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      SPROT = PROT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDet - Format details for output to the subfile          *
      *                                                               *
      *****************************************************************
     C     SRFmtDet      BEGSR
      *
      ** Security shortname
     C                   EVAL      SSDSN = SDSN
      *
      ** Front office transaction number
     C                   EVAL      SFRNT = FRNT
      *
      ** Event date
     C                   IF        SDED <> 99999
     C                   Z-ADD     SDED          PDateNIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      SSDED
     C                   ELSE
     C                   MOVEL     '999999'      SSDED
     C                   ENDIF
      *
      ** Event type
     C                   EVAL      SSDET = SDET
      *
      ** Last change date
     C                   IF        LCD <> *ZEROS
     C                   Z-ADD     LCD           PDateNIn
     C                   EXSR      SRFmtDat
     C                   MOVEL     PDateOut      SLCD
     C                   ELSE
     C                   MOVEL     *BLANKS       SLCD
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtDat - Convert date to Midas runday number               *
      *                                                               *
      *****************************************************************
     C     SRCvtDat      BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateAIn
     C                   PARM      *ZERO         PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDat - Format date for display                           *
      *                                                               *
      *****************************************************************
     C     SRFmtDat      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateNIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut
 
     C                   ENDSR
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
     C                   EVAL      PSDSNSel = *BLANKS
     C                   EVAL      PSDEDSel = *BLANKS
     C                   EVAL      PSDETSel = *BLANKS
 
     C                   EVAL      OptSelected = 'N'
     C                   EVAL      KeyFrmBRW = 'N'
      *
      ** Clear message subfile and reset error indicators.
     C                   CALL      'ZA0250'
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   WRITE     SESEDEBRC2
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
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
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Key fields (file pointer)
     C                   PARM                    KeyLists
      *
      ** Build subfile
     C                   PARM                    PBdSfl
      *
      ** Read subfile record
     C                   PARM                    PRdSfl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - default user branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Option selected
     C                   PARM                    POpSel
      *
      ** Key fields selected
      **  Security shortname
      **  Event date
      **  Event type
     C                   PARM                    PSDSNSel
     C                   PARM                    PSDEDSel
     C                   PARM                    PSDETSel
      *
      ** Function keys enabled
      ** KC = Command key 03 = Exit
      ** KL = Command key 12 = Cancel
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
     C                   EVAL      SUSER = PsUser
     C                   EVAL      SWSID = PsJobName
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
     C                   MOVE      *ON           *IN97
     C                   MOVEL     '*'           SPGMQ
      *
      ** Key list for investment types details.
      *
     C     KCcyInvTp     KLIST
     C                   KFLD                    S1NMCY
     C                   KFLD                    S1SITP
      *
      ** Key lists for security diary events details.
      *
     C     KSedev        KLIST
     C                   KFLD                    KSDSN
     C                   KFLD                    KSDEDN
     C                   KFLD                    KSDET
 
     C     KSedev5       KLIST
     C                   KFLD                    KSDEDN
     C                   KFLD                    KSDSN
     C                   KFLD                    KSDET
 
     C     KSedev6       KLIST
     C                   KFLD                    KSDET
     C                   KFLD                    KSDSN
     C                   KFLD                    KSDEDN
 
     C     KSedev7       KLIST
     C                   KFLD                    KSDEDN
     C                   KFLD                    KSDET
     C                   KFLD                    KSDSN
 
     C     KSedev8       KLIST
     C                   KFLD                    KSDSN
     C                   KFLD                    KSDET
     C                   KFLD                    KSDEDN
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
