     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield Rates Browse')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDYRATBRW - Yield Rates Browse                               *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - displays a list of Yield Rates for selection     *
      *            - picks off the selection made                     *
      *                                                               *
      *  Component of: SDYRATSIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS008             Date 16Jun04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators:                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    11         F11 Toggle                                      *
      *    93         SFLNXTCHG                                       *
      *    96         End of File                                     *
      *    97         Subfile clear                                   *
      *    98         Roll Up                                         *
      *    99         Read Change                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine Index:                                            *
      *                                                               *
      *  *INZSR      -  Program Initialisation Routine                *
      *  SRInit      - Initialisation Processing                      *
      *  SRBldSfl1   - Build Subfile by Key Fields                    *
      *  SRBldSfl2   - Build Subfile by Front Office Id               *
      *  SRChkAut    - Check for user authority if not multi-branching*
      *  SRRdSflRc   - Read Subfile Record                            *
      *  SRRdYRat    - Read a Valid Yield Rate from file              *
      *  SRFmtDet    - Format Yield Rates Details for Output to       *
      *                Subfile                                        *
      *  SRChkOption - Check if an option has been selected           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FSDYRATBDF CF   E             WORKSTN
      ** Browse screen
     F                                     SFILE(SDYRATS0:W_Rrn)
     F                                     SFILE(SDYRATS1:W_Rrn)
 
     FSDYLDRL1  IF   E           K DISK    INFSR(*PSSR)
      ** Yield Rates by Yield Curve Name, Currency and Interest Calc. Method
 
     FSDYLDRL3  IF   E           K DISK    INFSR(*PSSR)
      ** Yield Rates by Front Office Id
     F                                     RENAME(SDYLDRD0:SDYLDRD1)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      ** Table of field numbers and names
 
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
 
      ** Data structure for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10A
     D  PDBRN                 11     13A
     D  PDPPT                 14     16A
                                                                                              CAS008
      ** External DS for SAR details                                                          CAS008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS008
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Arrays for screen error indicators
     D WZeroise        S              1    DIM(10) CTDATA PERRCD(10)
 
      ** Previous key fields
     D WPrvYLDC        S              5A
     D WPrvYCCY        S              3A
     D WPrvYICM        S              1A
     D WPrvFRNT        S             20A
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             96     96
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PINKC           S              1A
     D PINKL           S              1A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
 
     D POpSel          S              1A
     D PErrMS          S              7A
     D PYLDCSel        S              5A
     D PYCCYSel        S              3A
     D PYICMSel        S              1A
     D PYCFQSel        S              1A
     D PSPDYSel        S              2A                                                      CAS008
     D WkYCFQ          S              1A
     D WkSPDY          S              2A                                                      CAS008
     D PActn           S              1A
     D PError          S              1P 0
 
     D OptSelected     S              1A
 
     D WPrvOrd         S              1A
     D W_Cnt           S              3P 0
     D W_Rrn           S              5P 0
 
     D CAS008          S              1A                                                      CAS008
     D PSard           S              6A                                                      CAS008
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
 
      ** Initialisation.
 
     C                   EXSR      SRInit
 
      ** Build subfile.
 
     C                   IF        PBdSfl = 'Y'
 
      ** If first time in or subfile by backoffice key was previously being ran,
      ** then build subfile keyed on Yield Curve Name, Currency and Int. Calc. Method
      ** Stay in loop while F11 toggle key is used.
 
     C                   IF        WPrvOrd <> 'F'
 
     C                   DOU       *INKK = *OFF
 
     C                   EXSR      SRBldSfl1
 
      ** If F11, switch to subfile by front office id.
 
     C                   IF        *INKK = *ON
     C                   EXSR      SRBldSfl2
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ELSE
 
      ** If the subfile by front office identifier was previously
      ** being run, then build subfile keyed on front office id.
      ** Stay in loop while F11 toggle key is used.
 
     C                   DOU       *INKK = *OFF
 
     C                   EXSR      SRBldSfl2
 
      ** If F11, switch to subfile by key fields
 
     C                   IF        *INKK = *ON
     C                   EXSR      SRBldSfl1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read subfile record.
 
     C                   IF        PRdSfl = 'Y'
     C                   EXSR      SRRdSflRc
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialisation Processing                           *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Clear output.
 
     C                   EVAL      PINKC = '0'
     C                   EVAL      PINKL = '0'
     C                   EVAL      PErrMs = *BLANKS
     C                   EVAL      POpSel = *BLANKS
     C                   EVAL      PYLDCSel = *BLANKS
     C                   EVAL      PYCCYSel = *BLANKS
     C                   EVAL      PYICMSel = *BLANKS
     C                   EVAL      PYCFQSel = *BLANKS
     C                   EVAL      PSPDYSel = *BLANKS                                         CAS008
 
     C                   EVAL      OptSelected = 'N'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl1 - Build Subfile by Key Fields                      *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: SRRdYRat, SRFmtDet, SRChkOption                       *
      *                                                               *
      *****************************************************************
     C     SRBldSfl1     BEGSR
 
      ** Set flag for Back Office.
 
     C                   EVAL      WPrvOrd = 'B'
      *
      ** Check for user authority to browse if not multi-branch environment.
      *
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SRChkAut
     C                   ENDIF
 
      ** Initialise subfile relative record number.
 
     C                   Z-ADD     0             W_Rrn
 
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
 
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDYRATC0
     C                   EVAL      *IN97 = *OFF
 
      ** Select screen footer for the screen.
 
     C                   WRITE     SDYRATF1
 
      ** Set record pointer to key field used.
 
     C     *LOVAL        SETLL     SDYLDRL1
 
      ** Read a Yield Curve from file
 
     C                   EXSR      SRRdYRat
 
      ** If no record read, set up an error message.
 
     C                   IF        EndOfFile = True
     C                   EVAL      PErrMs = 'USR9193'
     C                   EVAL      #0YLDC = *BLANKS
 
     C                   RETURN
 
     C                   ENDIF
 
 
      ** Initialise previous key fields
 
     C                   EVAL      WPrvYLDC = '0'
     C                   EVAL      WPrvYCCY = '0'
     C                   EVAL      WPrvYICM = '0'
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = *ON
 
      ** While ROLLUP, build a subfile page.
 
     C                   DOW       *IN98 = *ON  OR OptSelected <> 'Y'
 
      ** Initialise count of records written to subfile page.
 
     C                   Z-ADD     0             W_Cnt
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       EndOfFile = False AND
     C                             W_Cnt < 14
 
      ** Increment the subfile record no. and records written fields on change of
      ** key fields
 
     C                   IF        WPrvYLDC <> FSYLDC OR  WPrvYCCY <> FSYCCY OR
     C                             WPrvYICM <> FSYICM
 
     C                   ADD       1             W_Rrn
     C                   ADD       1             W_Cnt
 
      ** Format fields for output.
 
     C                   EXSR      SRFmtDet
 
      ** Write the yield rates details to subfile.
 
     C                   EVAL      #0OPTN = *BLANK
     C                   Z-ADD     W_Rrn         #0SFRN
     C                   WRITE     SDYRATS0
     C                   EVAL      WPrvYLDC = FSYLDC
     C                   EVAL      WPrvYCCY = FSYCCY
     C                   EVAL      WPrvYICM = FSYICM
     C                   ENDIF
 
      ** Read next Yield Rate.
 
     C                   EXSR      SRRdYRat
 
     C                   ENDDO
 
      ** Retrieve time for display.
 
     C                   TIME                    #0TIME
 
      ** Write and read the subfile control.
 
     C                   EXFMT     SDYRATC0
 
      ** If F3, bypass further processing for this module.
 
     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F11, bypass further processing for this loop.
 
     C                   IF        *INKK = *ON
     C                   GOTO      ESRBldSfl1
     C                   ENDIF
 
      ** If F12/Enter, bypass further processing this module.
 
     C                   IF        *INKL = *ON
     C                   EVAL      PINKL = '1'
     C                   RETURN
     C                   ENDIF
 
      ** Set record pointer if applicable.
      ** Initialise subfile before refilling.
      ** Read a yield rate to subfile.
 
     C                   IF        *IN98 <> *ON
      ** Check if a valid option has been selected.
 
     C                   EXSR      SRChkOption
 
     C                   ENDIF
 
     C                   ENDDO
 
     C     ESRBldSfl1    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl2 - Build Subfile by Front Office Id                 *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: SRRdYRat, SRFmtDetl, SRChkOption                      *
      *                                                               *
      *****************************************************************
     C     SRBldSfl2     BEGSR
 
      ** Set flag for front office id key used.
 
     C                   EVAL      WPrvOrd = 'F'
 
      ** Check for user authority to browse if not multi-branch environment.
 
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SRChkAut
     C                   ENDIF
 
      ** Initialise subfile relative record number.
 
     C                   Z-ADD     0             W_Rrn
 
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
 
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDYRATC1
     C                   EVAL      *IN97 = *OFF
 
      ** Select screen footer for the screen.
 
     C                   WRITE     SDYRATF1
 
      ** Set record pointer to key record used with priority to first key.
 
     C     *LOVAL        SETLL     SDYLDRL3
 
      ** Read an incoming payment from file.
 
     C                   EXSR      SRRdYRat
 
      ** If no record read, set up an error message.  Display
      ** 'No record in the Yield Rates File'
 
     C                   IF        EndOfFile = True
     C                   EVAL      PErrMs = 'USR9193'
     C                   EVAL      #0YLDC = *BLANKS
     C                   RETURN
     C                   ENDIF
 
      ** Initialise previous key fields
 
     C                   EVAL      WPrvYLDC = '0'
     C                   EVAL      WPrvYCCY = '0'
     C                   EVAL      WPrvYICM = '0'
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = *ON
 
      ** While ROLLUP, build a subfile page.
 
     C                   DOW       *IN98 = *ON OR OptSelected <> 'Y'
 
      ** Initialise count of records written to subfile page.
 
     C                   Z-ADD     0             W_Cnt
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       EndOfFile = False AND
     C                             W_Cnt < 14
 
      ** Increment the subfile record no. and records written fields on change of
      ** key fields
 
     C                   IF        WPrvYLDC <> FSYLDC OR  WPrvYCCY <> FSYCCY OR
     C                             WPrvYICM <> FSYICM
 
     C                   ADD       1             W_Rrn
     C                   ADD       1             W_Cnt
 
      ** Format fields for output.
 
     C                   EXSR      SRFmtDet
 
      ** Write the yield rate details to subfile.
 
     C                   EVAL      #0OPTN = *BLANK
     C                   Z-ADD     W_Rrn         #0SFRN
     C                   WRITE     SDYRATS1
 
     C                   EVAL      WPrvYLDC = FSYLDC
     C                   EVAL      WPrvYCCY = FSYCCY
     C                   EVAL      WPrvYICM = FSYICM
 
     C                   ENDIF
 
      ** Read next yield rate.
 
     C                   EXSR      SRRdYRat
 
     C                   ENDDO
 
      ** Retrieve time for display.
 
     C                   TIME                    #0TIME
 
      ** Write and read the subfile control.
 
     C                   EXFMT     SDYRATC1
 
      ** If F3, bypass further processing for this module.
 
     C                   IF        *INKC = *ON
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If F11, bypass further processing for this loop.
 
     C                   IF        *INKK = *ON
     C                   GOTO      ESRBldSfl2
     C                   ENDIF
 
      ** If F12, bypass further processing for this module.
 
     C                   IF        *INKL = *ON
     C                   EVAL      PINKL = '1'
     C                   RETURN
     C                   ENDIF
 
     C                   IF        *IN98 <> *ON
     C                   EXSR      SRChkOption
     C                   ENDIF
 
     C                   ENDDO
 
     C     ESRBldSfl2    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkAut - Check for user authority if not multi-branching   *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
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
     C                   EVAL      PErrMs = 'USR9194'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdSflRc - Read Subfile Record                              *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRRdSflRc     BEGSR
      *
      ** Read the subfile for selected records.
      ** Only process those for which the option field is not blank.
      *
     C                   DOU       *IN99 = *ON OR
     C                             #0OPTN <> *BLANK
 
     C                   IF        WPrvOrd <> 'F'
     C                   READC     SDYRATS0                               99
     C                   ELSE
     C                   READC     SDYRATS1                               99
     C                   ENDIF
 
     C                   ENDDO
 
      ** Return the selected option.
 
     C                   IF        *IN99 <> *ON AND
     C                             #0OPTN <> *BLANK
 
     C                   IF        #0OPTN = 'A' OR #0OPTN = 'E' OR #0OPTN = 'D'
     C                   EVAL      POpSel = #0OPTN
     C                   ELSE
     C                   EVAL      POpSel = 'E'
     C                   ENDIF
 
     C                   EVAL      PYLDCSel = #0YLDC
     C                   EVAL      PYCCYSel = #0YCCY
     C                   EVAL      PYICMSel = #0YICM
     C                   EVAL      PYCFQSel = WkYCFQ
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   EVAL      PSPDYSel = WkSPDY                                          CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdYRat - Read a Valid Yield Rate from file                 *
      *                                                               *
      *  Called by: SRBldSfl1, SRBldSfl2                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRRdYRat      BEGSR
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
     C                   READ      SDYLDRL1                               96
     C                   ELSE
     C                   READ      SDYLDRL3                               96
     C                   ENDIF
 
     C                   IF        EndOfFile = False
 
      ** If yield rate detail record is read, check whether user can see it
 
     C                   IF        BJSBRC = *BLANKS
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           PActn
     C                   PARM                    PDBRN
     C                   PARM      *ZERO         PError
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDet - Format Yield Rates Details for Output to Subfile  *
      *                                                               *
      *  Called by: SRBldSfl1, SRBldSfl2                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRFmtDet      BEGSR
 
      ** Yield Curve Name
 
     C                   EVAL      #0YLDC = FSYLDC
 
      ** Yield Curve Currency
 
     C                   EVAL      #0YCCY = FSYCCY
 
      ** Front office transaction id.
 
     C                   EVAL      #0FRNT = FSFRNT
 
      ** Interest Calculation Method
 
     C                   EVAL      #0YICM = FSYICM
 
      ** not displayed but should be passed back to for retrieve moduel
 
     C                   EVAL      WkYCFQ = FSYCFQ
                                                                                              CAS008
      ** Spot Days                                                                            CAS008
                                                                                              CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   MOVE      FSSPDY        WkSPDY                                       CAS008
     C                   ENDIF                                                                CAS008
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkOption - Check if an option has been selected           *
      *                                                               *
      *  Called by: SRBldSfl1, SRBldSfl2                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkOption   BEGSR
 
      ** Read subfile if an option has been selected.
 
     C                   DOU       *IN99 = '1' OR #0OPTN <> *BLANK
 
     C                   IF        WPrvOrd = 'B'
     C                   READC     SDYRATS0                               99
     C                   ELSE
     C                   READC     SDYRATS1                               99
     C                   ENDIF
 
     C                   ENDDO
 
      ** Activate SFLNXTCHG for the record to be read in the
      ** get-next-changed operation.
 
     C                   IF        *IN99 = *OFF
 
     C                   EVAL      *IN93 = '1'
 
     C                   IF        WPrvOrd = 'B'
     C                   UPDATE    SDYRATS0
     C                   ELSE
     C                   UPDATE    SDYRATS1
     C                   ENDIF
 
     C                   EVAL      *IN93 = '0'
 
     C                   IF        WPrvOrd = 'B'
     C                   WRITE     SDYRATC0
     C                   ELSE
     C                   WRITE     SDYRATC1
     C                   ENDIF
 
     C                   EVAL      OptSelected = 'Y'
 
     C                   ELSE
 
     C                   EVAL      OptSelected = 'N'
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
 
      /COPY ZACPYSRC,MSGHNDDSP2
 
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
 
      ** Input:
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Build subfile
 
     C                   PARM                    PBdSfl
 
      ** Read subfile record
 
     C                   PARM                    PRdSfl
 
      ** Output:
      ** Error message
     C                   PARM                    PErrMs
 
      ** Option selected
 
     C                   PARM                    POpSel
 
      ** Yielc Curve selected
 
     C                   PARM                    PYLDCSel
 
      ** Yield Currency selected
 
     C                   PARM                    PYCCYSel
 
      ** Yield Int. Calc. Method selected
 
     C                   PARM                    PYICMSel
 
      ** Yield Compound Frequency
 
     C                   PARM                    PYCFQSel
 
      ** Spot Days                                                                            CAS008
                                                                                              CAS008
     C                   PARM                    PSPDYSel                                     CAS008
                                                                                              CAS008
      ** Function key enabled - F3
 
     C                   PARM                    PINKC
 
      ** Function key enabled - F12
 
     C                   PARM                    PINKL
 
 
      ** Initialize program name
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZERO
     C                   EVAL      DBFILE = *BLANK
     C                   EVAL      DBKEY = *BLANK
     C                   OUT       LDA
 
      ** Retrieve ZMUSER details.
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0DATE = BJMRDT
     C                   EVAL      #0JBNM = PSJOBNAME
 
      ** Initialise the fixed parameters for ZAMSGHNDLE.
 
     C                   EVAL      ModuleID     = 'SD'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
 
      ** Set up the prime and secondary message files for
      ** finding message IDs.
 
     C                   EVAL      #MsgFile     = 'SDUSRMSG'
 
      ** Message subfile control and program queue initialisation.
 
     C                   MOVEL     '*'           #2PGMQ
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS008
      ** Check if switchable feature CAS008 is switched on.                                   CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
                                                                                              CAS008
     C                   CALL      'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRtCd                                        CAS008
     C                   PARM      '*VERIFY'     POptn                                        CAS008
     C                   PARM      'CAS008'      PSard                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database error                                                                       CAS008
                                                                                              CAS008
     C                   IF        (PRtCd <> *BLANKS) AND                                     CAS008
     C                             (PRtCd <> '*NRF   ')                                       CAS008
     C                   EVAL      DBKEY = 'CAS008'                                           CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 2                                                  CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRtCd = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
 
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
