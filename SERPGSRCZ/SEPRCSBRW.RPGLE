     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Prices browse function')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEPRCSBRW - SE Market Price Browse                           *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of Securities Prices  details  *
      *             for selection , the other picks off the           *
      *             selection made.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210735             Date 27Nov02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060  *CREATE    Date 03Oct00               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation on Savings Income (Recompile)              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  210735 - Recompiled due to changes in MODULE/SEPRCSBRDF.     *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * FUNCTION Securities Details File - by Security name
     FPRICEL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(PRICEDF:PRICEDFX)
 
      * FUNCTION Securities Details File - if CAC005 is on use this file
     FSEPRICL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Securities Details File - by Front Office Id.
     FPRICEL0   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(PRICEDF:PRCSFO)
 
      * FUNCTION Securities Details File - by Front Office Id, if CAC005 is on
     FSEPRICL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEPRICD0:PRICFO)
 
     FSEPRCSBRDFCF   E             WORKSTN
     F                                     SFILE(SEPRCSS1:@@RRN)
     F                                     SFILE(SEPRCSS3:@@RRN)
 
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
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *  Bank Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D*  Customer Details
 
      ** DS for Access programs, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for Access Programs, long DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D* Profit Centre Switchable Feature
     D CAC005          S              1A
 
     D INPSSN          S                   LIKE(DDPSSN )
     D INPCNM          S                   LIKE(DDPCNM )
     D INPMKT          S                   LIKE(DDPMKT )
     D INPBRA          S                   LIKE(DDPBRA )
     D INPBOK          S                   LIKE(DDPBOK )
     D INPRFC          S                   LIKE(DDPRFC )
     D INPPRT          S                   LIKE(DDPPRT )
     D INPTFR          S                   LIKE(DDPTFR )
     D @ACTN           S                   LIKE(DDACTN )
     D @PSSN           S                   LIKE(DDPSSN )
     D @PCNM           S                   LIKE(DDPCNM )
     D @PMKT           S                   LIKE(DDPMKT )
     D @PBRA           S                   LIKE(DDPBRA )
     D @PBOK           S                   LIKE(DDPBOK )
     D @PRFC           S                   LIKE(DDPRFC )
     D @PPRT           S                   LIKE(DDPPRT )
     D @PTFR           S                   LIKE(DDPTFR )
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
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
      *
      ** Initialization
      *
     C                   EXSR      SRInit
      *
      ** Build sub-file
      *
     C     @BldSfl       IFEQ      'Y'
      *
      **  If First time in or subfile by PRICEL1 key fields was previously
      **  being run, then build subfile keyed on PRICEL1 key fields.
      **  Stay in loop while F11 toggle key is used.
      *
     C     WTRAD         IFNE      'F'
     C     *INKK         DOUEQ     '0'
     C                   EXSR      SRBldSfl
      *
      **  If F11, switch to Front Office key subfile
      *
     C     *INKK         IFEQ      '1'
     C                   EXSR      SrBldSfl2
     C                   ENDIF
     C                   ENDDO
      *
     C                   ELSE
      *
      **  If the subfile by Front Office Identifier was previously
      **  being run, then build subfile keyed on Front Office ID.
      **  Stay in loop while F11 toggle key is used.
      *
     C     *INKK         DOUEQ     '0'
     C                   EXSR      SrBldSfl2
      *
      **  If F11, switch to PRICEL1 key fields subfile
      *
     C     *INKK         IFEQ      '1'
     C                   EXSR      SrBldSfl
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
      ** Read Subfile Record
      *
     C     @RdSfl        IFEQ      'Y'
     C                   EXSR      SRRdSfl
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl - SubFile Details Generation Routine                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRBldSfl      BEGSR
      *
      * Set indicator and flag for Midas (back) office trade number key used
      *
     C                   MOVE      'B'           WTRAD             1
     C                   MOVE      '0'           *IN20
      *
      ** Check for user authority to Browse if Not Multi-Branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Validate Security Shortname (For Pointer)
      *
     C                   EXSR      SRValRef
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SEPRCSS0
     C                   MOVE      '0'           *IN97
     C     CAC005        IFEQ      'Y'
     C     KEY1          SETLL     SEPRICD0
     C                   ELSE
     C     PRICEK        SETLL     PRICEDFX
     C                   ENDIF
      *
      ** Read a Valid Record
      *
     C                   EXSR      SRRdTrans
      *
      **  If no records exist - set up an error message.
      **  and terminate
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     *IN98         DOWEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     15
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format fields for output
      *
     C                   EXSR      SRFmtDet
      *
      **  Write to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
 
     C                   WRITE     SEPRCSS1
      *
      ** Read a Valid record
      *
     C                   EXSR      SRRdTrans
     C                   ENDDO
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     SEPRCSF1
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     @@CNT         IFEQ      0
     C                   MOVE      '1'           *IN97
     C                   WRITE     SEPRCSS0
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     c                   MOVE      '1'           *IN93
     C                   WRITE     SEPRCSS1
     c                   MOVE      '0'           *IN93
     C                   WRITE     SEPRCSS0
     c                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SEPRCSS0
     C                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SEPRCSS0                               99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   EVAL      *INLR = '1'
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl2 - SubFile Details Generation Routine                *
      *            By Front Office ID                                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRBldSfl2     BEGSR
      *
      * Set indicator and flag for Front Office ID key used
      *
     C                   MOVE      'F'           WTRAD
     C                   MOVE      '1'           *IN20
      *
      ** Check for user authority to Browse if Not Multi-Branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Validate security shortname (For Pointer)
      *
     C                   EXSR      SRValRef
      *
      **  Get Front Office ID
      *
 
     C     CAC005        IFEQ      'Y'
     C     KEY1          CHAIN     SEPRICD0                           89
     C                   ELSE
     C     PRICEK        CHAIN     PRICEDFX                           89
     C                   ENDIF
      *
     C                   MOVE      PRFRNT        @@FOTD           20
     C     *IN89         IFEQ      '1'
     C                   MOVE      *BLANK        @@FOTD
     C                   ENDIF
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SEPRCSS2
     C                   MOVE      '0'           *IN97
      *
     C     CAC005        IFEQ      'Y'
     C     @@FOTD        SETLL     PRICFO
     C                   ELSE
     C     @@FOTD        SETLL     PRCSFO
     C                   ENDIF
      *
      ** Read a Valid record
      *
     C                   EXSR      SRRdTrans
      *
      **  set up message 'no data to display'
      *
     C                   MOVE      *OFF          *IN80
     C     @@EOF         IFEQ      'Y'
     C                   MOVE      *ON           *IN80
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     *IN98         DOWEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     15
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format fields for output
      *
     C                   EXSR      SRFmtDet
      *
      **  Write the record to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SEPRCSS3
      *
      ** Read a Valid record
      *
     C                   EXSR      SRRdTrans
     C                   ENDDO
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     SEPRCSF1
     C     @@CNT         IFEQ      0
     C                   MOVE      '1'           *IN97
     C                   WRITE     SEPRCSS2
     c                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     c                   MOVE      '1'           *IN93
     C                   WRITE     SEPRCSS3
     c                   MOVE      '0'           *IN93
     C                   WRITE     SEPRCSS2
     c                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SEPRCSS2
     C                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SEPRCSS2                               99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   EVAL      *INLR = '1'
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdSfl - SubFile Details Generation Routine                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRdSfl       BEGSR
      *
      ** Read the subfile for selected records
      ** Only process those for which the option field is not blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C     WTRAD         IFNE      'F'
     C                   READC     SEPRCSS1                               99
     C                   ELSE
     C                   READC     SEPRCSS3                               99
     C                   END
     C                   END
      *
      **  Return the selected record and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
 
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'D'
     C                   MOVE      DDOPT         @ACTN
     C                   ELSE
     C                   MOVE      'E'           @ACTN
     C                   END
 
     C                   MOVE      DDPSSN        @PSSN
     C                   MOVE      DDPCNM        @PCNM
     C                   MOVE      DDPMKT        @PMKT
     C                   MOVE      DDPBRA        @PBRA
     C                   MOVE      DDPBOK        @PBOK
     C                   MOVE      DDPRFC        @PRFC
     C                   MOVE      DDPPRT        @PPRT
     C                   MOVE      DDPTFR        @PTFR
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtDet - Routine to change the file format transaction to   *
      *            Screen format.                                     *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:  SRCvtDat                                              *
      *                                                               *
      ******************************************************************
 
     C     SRFmtDet      BEGSR
 
     C                   MOVEL     PRFRNT        DDFODN
     C                   MOVEL     PSSN          DDPSSN
     C*****PCNM*         IFNE      *ZEROS                                                     CSD027
     C     PCNM          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     PCNM          DDPCNM
     C                   ELSE
     C                   MOVE      *BLANKS       DDPCNM
     C                   END
      *
     C                   MOVEL     PMKT          DDPMKT
     C     PBRA          IFNE      *BLANKS
     C                   MOVEL     PBRA          DDPBRA
     C                   ELSE
     C                   MOVE      *BLANKS       DDPBRA
     C                   END
     C                   MOVEL     PBOK          DDPBOK
     C                   MOVEL     PPRT          DDPPRT
     C     PTFR          IFEQ      '9997'
     C                   MOVE      FCR997        DDPTFR
     C                   ELSE
     C                   MOVEL     PTFR          DDPTFR
     C                   ENDIF
     C                   MOVEL     PRFC          DDPRFC
     C     CAC005        IFEQ      'Y'
     C                   MOVEL     PBCD          DDPBOK
     C                   ENDIF
 
      *
      **  If the record has been deleted then show this.
      *
     C     RECI          IFEQ      'R'
     C     RECI          OREQ      '*'
     C                   MOVE      '1'           *IN95
     C                   MOVE      '*'           DDTEXT
     C                   ELSE
     C                   MOVE      '0'           *IN95
     C                   MOVE      *BLANKS       DDTEXT
     C                   ENDIF
 
     C                   ENDSR
 
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdTrans- Subroutine to Retrieve a valid Record from the     *
      *            Transaction file.                                  *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRdTrans     BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     @@ERR         OREQ      *ZERO
     C
      *
      **  Read the file.
      *
      * Non-front Office ID
     C     WTRAD         IFEQ      'B'
     C     CAC005        IFEQ      'Y'
     C                   READ      SEPRICD0                               96
     C                   ELSE
     C                   READ      PRICEDFX                               96
     C                   ENDIF
     C                   ELSE
      * Front Office ID
     C     CAC005        IFEQ      'Y'
     C                   READ      PRICFO                                 96
     C                   ELSE
     C                   READ      PRCSFO                                 96
     C                   ENDIF
     C                   MOVE      RECI          RECI_PRCS         1
     C                   ENDIF
      *
      ** End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   ENDIF
      *
      ** If recd read, check whether user can see it
      *
     C                   MOVE      *ZERO         @@ERR
     C     @@EOF         IFNE      'Y'
     C     BJSBRC        IFEQ      *BLANK
     C     PPRT          ANDNE     'V'
     C     PTFR          ANDEQ     *BLANKS
     C                   CALL      'ZVBBU'
     C                   PARM                    PBRA
     C                   PARM                    @@ERR
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkAut - Subroutine to Check for user's Authority           *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SrChkAut      BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ** Return Error Message
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValRef - Validate                                           *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SrValRef      BEGSR
 
     C                   MOVEL     INPSSN        DDPSSN
      *
      **  Validate that the customer reference is numeric or blank.
      *
     C**********         TESTN                   INPCNM               98                      CSD027
     C**********         MOVE      INPCNM        @@TEST            1                          CSD027
     C**********         TESTZ                   @@TEST                   99                  CSD027
     C*****INPCNM        IFEQ      *BLANKS                                                    CSD027
     C******IN98         OREQ      '1'                                                        CSD027
     C******IN99         ANDEQ     '1'                                                        CSD027
     C                   MOVE      INPCNM        DDPCNM
      *
      * RETURN ERROR MESSAGE
      *
     C**********         ELSE                                                                 CSD027
     C**********         MOVEL     'MMA0087'     @ERRMS                                       CSD027
     C**********         RETURN                                                               CSD027
     C**********         END                                                                  CSD027
      *
     C                   MOVEL     INPMKT        DDPMKT
     C                   MOVEL     INPBRA        DDPBRA
     C                   MOVEL     INPBOK        DDPBOK
     C                   MOVEL     INPRFC        DDPRFC
     C                   MOVEL     INPPRT        DDPPRT
     C                   MOVEL     INPTFR        DDPTFR
     C                   MOVEL     INPCNM        DDPCNM
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEYC            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL(P)  BBCUST        DDPCNM
     C**********         MOVEL     BBCUST        @KPCNM            6 0                        CSD027
     C                   MOVEL     BBCUST        @KPCNM            6                          CSD027
     C                   ELSE
     C                   MOVEL     INPCNM        @KPCNM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit- Initializtion Routine                                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
      *
      ** Clear Outputs
      *
     C                   MOVE      *BLANK        @ERRMS            7
     C                   MOVE      *BLANK        @ACTN
     C                   MOVE      *BLANK        @PSSN
     C                   MOVE      *BLANK        @PCNM
     C                   MOVE      *BLANK        @PMKT
     C                   MOVE      *BLANK        @PBRA
     C                   MOVE      *BLANK        @PBOK
     C                   MOVE      *BLANK        @PRFC
     C                   MOVE      *BLANK        @PPRT
     C                   MOVE      *BLANK        @PTFR
     C                   MOVE      '0'           @INKC             1
     C                   MOVE      '0'           @INKL             1
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN80
     C                   MOVE      '0'           *IN95
 
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - Exception Errors                                      *
      *                                                               *
      * Called by: *InzSR                                             *
      *                                                               *
      * Calls:  *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SEPRCSBRW'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
      *
      **  Terminte the program
      *
     C                   EXSR      *PSSR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *InzSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS :
      * Return Code
     C                   PARM                    RetCodeIn
      * Action Code
      * Security
      * Customer Shortname
      * Market
      * Branch
      * Book
      * Profit Centre
      * Price Type
      * Portfolio Reference
     C                   PARM                    DDACTN            1
     C                   PARM                    INPSSN
     C                   PARM                    INPCNM
     C                   PARM                    INPMKT
     C                   PARM                    INPBRA
     C                   PARM                    INPBOK
     C                   PARM                    INPRFC
     C                   PARM                    INPPRT
     C                   PARM                    INPTFR
      * Build Subfile
     C                   PARM                    @BLDSFL           1
      * Read Subfile Record
     C                   PARM                    @RDSFL            1
     C                   PARM                    FCR997            4
      *
      * OUTPUT PARAMETERS :
      * Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKI             1
      ** Option Selected
     C                   PARM                    @ERRMS            7
     C                   PARM                    @ACTN
     C                   PARM                    @PSSN
     C                   PARM                    @PCNM
     C                   PARM                    @PMKT
     C                   PARM                    @PBRA
     C                   PARM                    @PBOK
     C                   PARM                    @PRFC
     C                   PARM                    @PPRT
     C                   PARM                    @PTFR
      ** ICD Information Retrieval
      ** -------------------------
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEPRCSBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
 
      * Key Lists
      * ---------
 
     C     KEY1          KLIST
     C                   KFLD                    DDPSSN
     C                   KFLD                    @KPCNM
     C                   KFLD                    DDPMKT
     C                   KFLD                    DDPBRA
     C                   KFLD                    DDPBOK
     C                   KFLD                    DDPRFC
     C                   KFLD                    DDPPRT
     C                   KFLD                    DDPTFR
 
     C     PRICEK        KLIST
     C                   KFLD                    DDPSSN
     C                   KFLD                    @KPCNM
     C                   KFLD                    DDPMKT
     C                   KFLD                    DDPBRA
     C                   KFLD                    DDPBOK
     C                   KFLD                    DDPPRT
     C                   KFLD                    DDPTFR
      *
      ** Get Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 900*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ***  Check if CAC005 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAC005'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAC005
     C                   ELSE
     C                   MOVE      'N'           CAC005
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
