     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management - Browse')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Date Module                                 *
      *                                                               *
      *  SDDCMTBRW - Document Management Browse                       *
      *                                                               *
      *  Function:  This module displays a list of Customer and Non-  *
      *             Account Holder Documents.                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDDCMTDBDFCF   E             WORKSTN
     F                                     SFILE(SDDCMTS1:WWRRN)
     F                                     SFILE(SDDCMTS3:WWRRN)
 
      * Document Management file - by Customer No or Naho Ref  and Code
     FSDDCMTL1  IF   E           K DISK    INFSR(*PSSR)
 
      * Document Management file - by Front Offic Id
     FSDDCMTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDDCMTD0:SDDCMTD2)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** EXTERNAL DS FOR DOCUMENT CODE DETAILS
     D SDDOCM        E DS                  EXTNAME(SDDOCMPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WCOMM           DS
     D  WCOM1                  1     64
     D  WCOM2                 65    128
     D  WCOM3                129    192
     D  WCOM4                193    256
 
     D DDACTN          S              1
     D DDREFN          S             10
     D DDCSSN          S             10
     D DDCRNM          S             20
     D DDCRTN          S             10
     D PBDSFL          S              1
     D PRDSFL          S              1
     D PERRMS          S              7
     D POPSEL          S              1
     D PCDSEL          S              2
     D PSQSEL          S              3S 0
     D PSEQN           S              3S 0
     D PINKC           S              1
     D PINKI           S              1
     D PINKE           S              1
     D PINTYP          S              1
     D PINMOD          S              1
     D WScan           S              1S 0
     D WSYST           S              8
     D WkSRef          S              1
     D WWREFF          S             10
     D WWRRN           S              5S 0
     D WWEOF           S              1
 
     D PRTCD           S              7
     D POPTN           S              7
     D PDCCD           S              2
 
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
      *
      ** Set up the customer reference to be used by the message handler
     C                   EVAL      TranRef = DDREFN
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Initialization
      *
     C                   EXSR      INIT
      *
      ** Build Sub-file
      *
     C     PBDSFL        IFEQ      'Y'
      *
      **  If First time in or subfile by Midas trade number was previously
      **  being run, then build subfile keyed on Midas trade number.
      **  Stay in loop while F11 toggle key is used.
      *
     C                   IF        WkSRef <> 'F'
     C                   EVAL      WkSRef = 'B'
     C                   ENDIF
 
     C     *INKK         DOUEQ     '0'
      *
      ** On F11, initialize position/select fields
      *
     C     *INKK         IFEQ      '1'
 
     C                   EVAL      DFFOID = *BLANK
     C                   EVAL      DFCODE = *BLANK
     C                   EVAL      DFNARR = *BLANK
     C                   EVAL      DFDREF = *BLANK
     C                   EVAL      DFSTAT = *BLANK
     C                   EVAL      DFSYST = *BLANK
     C                   EVAL      DFRQDT = *BLANK
     C                   EVAL      DFREQB = *BLANK
     C                   EVAL      DFEXDT = *BLANK
 
      ** Clear program message queue
     C                   CALL      'ZA0250'
 
     C                   ENDIF
 
     C     WkSRef        CASEQ     'B'           BLDSFL
     C     WkSRef        CASEQ     'F'           BLDSFL2
     C                   ENDCS
 
     C                   END
 
     C                   ENDIF
 
      ** Read Subfile Record
 
     C     PRDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   ENDIF
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BLDSFL  - Build Subfile                                      *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     BLDSFL        BEGSR
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             WWRRN
     C                   EVAL      WWREFF = DDREFN
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDDCMTS0
     C                   EVAL      *IN97 = *OFF
      *
      **  Set file pointer on key displayed on screen.
      *
     C                   IF        DDCODE <> *BLANKS
     C                             AND DDSEQN <> *BLANKS
     C                             AND FldNameArr(1) <> *BLANKS
     C                   EVAL      WCODE = DDCODE
     C                   MOVE      DDSEQN        PSEQN
     C                   ELSE
     C                   EVAL      WCODE = *BLANKS
     C                   EVAL      PSEQN = *ZERO
     C                   ENDIF
     C     KCDSQ         SETLL     SDDCMTD0
      *
      **  Read a Valid Document Management Detail
      *
     C                   EXSR      RDDCMT
      *
      **  set up message 'no data to display'
      *
     C                   EVAL      *IN80 = *OFF
     C     WWEOF         IFEQ      'Y'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   EVAL      *IN98 = *ON
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
     C                   Z-ADD     0             WWCNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     WWEOF         DOWNE     'Y'
     C     WWCNT         ANDLT     16
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             WWRRN
     C                   ADD       1             WWCNT
      *
      **  Format Document Management detail fields for output
      *
     C                   EXSR      FMTDCMT
      *
      **  Write the customer to the subfile.
      *
      **  If action code or customer number selected is invalid
      **  the subfile postions on the error record and rebuilds
      *
     C                   EVAL      *IN92 = *OFF
     C     WWRRN         IFNE      1
     C                   EVAL      DDOPT = *BLANK
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDREFN    '  LOOKUP    FldNameArr                             98
     C     *IN99         IFNE      '1'
     C     *IN98         ANDNE     '1'
     C                   EVAL      DDOPT = *BLANK
     C                   ELSE
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     WWRRN         DDSFRN
     C                   WRITE     SDDCMTS1
      *
      **  Read a valid Document Management Detail
      *
     C                   EXSR      RDDCMT
     C                   END
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     SDDCMTF1
      *
      **  Write the message subfile
      *
     C                   WRITE     SDDCMTM0
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C     WWCNT         IFEQ      0
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDDCMTS0
     C                   EVAL      *IN97 = *OFF
     C                   Z-ADD     1             WWRRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     C                   EVAL      *IN93 = *ON
     C                   WRITE     SDDCMTS1
     C                   EVAL      *IN93 = *OFF
     C                   WRITE     SDDCMTS0
     C                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDDCMTS0
     C                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDDCMTS0                               99
      *
      ** Clear any messages before processing user input
      *
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
      *
      **  If F3, bypass further processing.
      *
     C                   IF        *INKC = '1'
     C                   EVAL      PINKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      ** If F5, Refresh screen details
      *
     C                   IF        *INKE = '1'
     C                   EVAL      DFCODE = *BLANK
     C                   EVAL      DFNARR = *BLANK
     C                   EVAL      DFDREF = *BLANK
     C                   EVAL      DFSTAT = *BLANK
     C                   EVAL      DFSYST = *BLANK
     C                   EVAL      DFRQDT = *BLANK
     C                   EVAL      DFREQB = *BLANK
     C                   EVAL      DFEXDT = *BLANK
     C                   EVAL      WkSRef = 'B'
     C                   EVAL      PINKE  = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  If F9, bypass further processing.
      *
     C                   IF        *INKI = '1'
     C                   EVAL      POPSEL = 'I'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
     C                   END
      *
      ** Set indicator ans flag for Midas Front Office I.D. browse key used
      *
     C                   IF        *INKK = '1'
     C                   EVAL      WkSRef = 'F'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BLDSFL2 - Build Subfile for Front Office                     *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     BLDSFL2       BEGSR
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             WWRRN
     C                   EVAL      WWREFF = DDREFN
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   EVAL      *IN97  = *ON
     C                   WRITE     SDDCMTS2
     C                   EVAL       *IN97 = *OFF
 
     C                   IF        DDCODE <> *BLANKS
     C                             AND DDSEQN <> *BLANKS
     C                             AND FldNameArr(1) <> *BLANKS
     C                   EVAL      WFOID = DDFOID
     C                   EVAL      WCODE = DDCODE
     C                   MOVE      DDSEQN        PSEQN
     C                   ELSE
     C                   EVAL      WFOID = *BLANKS
     C                   EVAL      WCODE = *BLANKS
     C                   EVAL      PSEQN = *ZERO
     C                   ENDIF
      *
      **  Set file pointer on key displayed on screen.
      *
     C     KFOSQ         SETLL     SDDCMTD2
      *
      **  Read a Valid Customer
      *
     C                   EXSR      RDDCMT
      *
      **  set up message 'no data to display'
      *
     C                   EVAL      *IN80 = *OFF
     C                   IF        WWEOF = 'Y'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   EVAL      *IN98 = *ON
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
     C                   Z-ADD     0             WWCNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     WWEOF         DOWNE     'Y'
     C     WWCNT         ANDLT     16
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             WWRRN
     C                   ADD       1             WWCNT
      *
      **  Format Document Management detail fields for output
      *
     C                   EXSR      FMTDCMT
      *
      **  Write the customer to the subfile.
      *
      **  If action code or customer number selected is invalid
      **  the subfile postions on the error record and rebuilds
      *
     C                   EVAL      *IN92 = *OFF
     C                   IF        WWRRN <> 1
     C                   EVAL      DDOPT = *BLANK
     C                   ELSE
     C     'DDACTN    '  LOOKUP    FldNameArr                             99
     C     'DDREFN    '  LOOKUP    FldNameArr                             98
     C                   IF        *IN99 <> '1'
     C                             AND *IN98 <> '1'
     C                   EVAL      DDOPT = *BLANK
     C                   ELSE
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     WWRRN         DDSFRN
     C                   WRITE     SDDCMTS3
      *
      **  Read a valid Document Management Detail
      *
     C                   EXSR      RDDCMT
     C                   END
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     SDDCMTF1
      *
      **  Write the message subfile
      *
     C                   WRITE     SDDCMTM0
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C                   IF        WWCNT = 0
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDDCMTS2
     C                   EVAL      *IN97 = *OFF
     C                   Z-ADD     1             WWRRN
     C                   Z-ADD     1             DDSFRN
      *
      **  write to the subfile with non-display set on
      *
     C                   EVAL      *IN93 = *ON
     C                   WRITE     SDDCMTS3
     C                   EVAL      *IN93 = *OFF
     C                   WRITE     SDDCMTS2
     C                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SDDCMTS2
     C                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SDDCMTS2                               99
      *
      ** Clear any messages before processing user input
      *
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
      *
      **  If F3, bypass further processing.
     C                   IF        *INKC = '1'
     C                   EVAL      PINKC = '1'
     C                   EVAL      WkSRef = 'B'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      ** If F5, Refresh screen details
     C                   IF        *INKE = '1'
     C                   EVAL      DFFOID = *BLANK
     C                   EVAL      DFCODE = *BLANK
     C                   EVAL      DFNARR = *BLANK
     C                   EVAL      DFSTAT = *BLANK
     C                   EVAL      DFSYST = *BLANK
     C                   EVAL      DFRQDT = *BLANK
     C                   EVAL      DFREQB = *BLANK
     C                   EVAL      DFEXDT = *BLANK
     C                   EVAL      WkSRef = 'F'
     C                   EVAL      PINKE  = '1'
     C                   RETURN
     C                   ENDIF
 
      **  If F9, bypass further processing.
     C                   IF        *INKI = '1'
     C                   EVAL      POPSEL = 'I'
     C                   EVAL      WkSRef = 'B'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
     C                   END
      *
      * Set indicator and flag for Midas (back) office customer number key
      *
     C                   IF        *INKK = '1'
     C                   EVAL      WkSRef = 'B'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RDSFLR  - Read Subfile Record                                *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C     WkSRef        IFEQ      'B'
     C                   READC     SDDCMTS1                               99
     C                   ENDIF
     C     WkSRef        IFEQ      'F'
     C                   READC     SDDCMTS3                               99
     C                   ENDIF
     C                   END
      *
      **  Return the selected Document Code reference and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'D'
     C     DDOPT         OREQ      'E'
     C                   EVAL      POPSEL = DDOPT
     C                   ELSE
     C                   EVAL      POPSEL = ' '
     C                   ENDIF
      *
     C                   MOVE      DDCODE        PCDSEL
     C                   MOVE      DDSEQN        PSQSEL
      *
     C                   ENDIF
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FMTDCMT - Format Document Management Details for Output      *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     FMTDCMT       BEGSR
      *
      ** Document Code and Narrative
      *
     C                   EVAL      DDCODE = DMCODE
     C                   EXSR      SRDOCM
     C                   EVAL      DDFOID = DMFOID
     C                   MOVEL     DMSEQN        DDSEQN
     C                   EVAL      DDDREF = DMDREF
     C                   MOVEL     DMCOMM        WCOMM
 
     C                   EXSR      SRSTAT
     C                   EVAL      DDSTAT = WSTAT
 
     C                   EVAL      DDSYST = *BLANKS
     C                   IF        BJRDNB > DMEXDT
     C                             AND DMEXDT > *ZERO
     C                             AND DMSTCD <> 'C'
     C                   EVAL      DDSYST = 'EXPIRED'
     C                   ELSE
     C                   IF        BJRDNB > DMREQB
     C                             AND DMREQB > *ZERO
     C                             AND DMSTCD <> 'A'
     C                             AND DMSTCD <> 'C'
     C                   EVAL      DDSYST = 'OVERDUE'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      DDRQDT = *BLANKS
     C                   IF        DMRQDT > *ZERO
     C                   EVAL      ZDAYNO = DMRQDT
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         DDRQDT
     C                   ENDIF
 
     C                   EVAL      DDREQB = *BLANKS
     C                   IF        DMREQB > *ZERO
     C                   EVAL      ZDAYNO = DMREQB
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         DDREQB
     C                   ENDIF
 
     C                   EVAL      DDEXDT = *BLANKS
     C                   IF        DMEXDT > *ZERO
     C                   EVAL      ZDAYNO = DMEXDT
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         DDEXDT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RDDCMT  - Read Document Management Details                   *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     RDDCMT        BEGSR
      *
      **  Reset End of File and skip record indicator
      *
     C                   MOVE      *BLANK        WWEOF             1
      *
      **  Read the file initially - if WWEOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     WWEOF         DOUEQ     'Y'
     C     DMCODE        ORNE      *BLANK
     C     WWERR         ANDEQ     *ZERO
 
     C                   Z-ADD     0             WWERR
 
     C                   IF        WkSref = 'B'
      *
      **  Position according to customer number
      *
     C     KCUST         KLIST
     C                   KFLD                    DDREFN
     C                   KFLD                    PINTYP
      *
     C     DFCODE        IFNE      *BLANK
     C                   MOVEL     DFCODE        WCODE             2
     C     KCODE         SETLL     SDDCMTD0                           89
     C     KCUST         READE     SDDCMTD0                               96
     C                   EVAL      DFCODE = *BLANKS
     C                   ELSE
     C     KCUST         READE     SDDCMTD0                               96
     C                   ENDIF
      *
      ** Select according to narrative
      *
     C                   EXSR      SRDOCM
 
     C                   IF        DFNARR <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    DDNARR
     C                   PARM      30            LENGTH1           3 0
     C                   PARM      1             START             3 0
     C                   PARM                    DFNARR
     C                   PARM      30            LENGTH2           3 0
     C                   PARM      '1'           TRANSLATE         1
     C                   PARM      '1'           TRIM              1
     C                   PARM      '?'           WILD              1
     C                   PARM                    RESULT            3 0
     C                   IF        RESULT < 1
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to reference
      *
     C                   IF        DFDREF <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    DMDREF
     C                   PARM      30            LENGTH1
     C                   PARM      1             START
     C                   PARM                    DFDREF
     C                   PARM      30            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to document status
      *
     C                   EXSR      SRSTAT
 
     C                   IF        DFSTAT <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    WSTAT            12
     C                   PARM      12            LENGTH1
     C                   PARM      1             START
     C                   PARM                    DFSTAT
     C                   PARM      12            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WSYST = *BLANKS
     C                   IF        BJRDNB > DMEXDT
     C                             AND DMEXDT > *ZERO
     C                             AND DMSTCD <> 'C'
     C                   EVAL      WSYST = 'EXPIRED'
     C                   ELSE
     C                   IF        BJRDNB > DMREQB
     C                             AND DMREQB > *ZERO
     C                             AND DMSTCD <> 'A'
     C                             AND DMSTCD <> 'C'
     C                   EVAL      WSYST = 'OVERDUE'
     C                   ENDIF
     C                   ENDIF
 
      *
      ** Select according to system status
      *
     C                   IF        DFSYST <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    WSYST
     C                   PARM      8             LENGTH1
     C                   PARM      1             START
     C                   PARM                    DFSYST
     C                   PARM      8             LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to Requested Date
      *
     C                   EVAL      ZDAYNO = DMRQDT
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         WRQDT             6
 
     C                   IF        DFRQDT <> *BLANK
     C                   EVAL      WScan = %SCAN (' ':DFRQDT)
     C                   IF        DFRQDT <> WRQDT
     C                             AND WScan = 0
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to Requested by Date
      *
     C                   EVAL      ZDAYNO = DMREQB
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         WREQB             6
 
     C                   IF        DFREQB <> *BLANK
     C                   EVAL      WScan = %SCAN (' ':DFREQB)
     C                   IF        DFREQB <> WREQB
     C                             AND WScan = 0
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to Expiry Date
      *
     C                   EVAL      ZDAYNO = DMEXDT
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         WEXDT             6
 
     C                   IF        DFEXDT <> *BLANK
     C                   EVAL      WScan = %SCAN (' ':DFEXDT)
     C                   IF        DFEXDT <> WEXDT
     C                             AND WScan = 0
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   IF        WkSref = 'F'
      *
      **  Position according to customer number
      *
     C                   IF        DFFOID <> *BLANK
     C                   MOVE      DFFOID        WFOID
     C     KFOID         SETLL     SDDCMTD2                           89
     C     KCUST         READE     SDDCMTD2                               96
     C                   EVAL      DFFOID = *BLANK
     C                   ELSE
     C     KCUST         READE     SDDCMTD2                               96
     C                   ENDIF
      *
      ** Select according to customer shortname mask
      *
     C                   IF        DFCODE <> *BLANK
     C                   MOVEL     DFCODE        WCODE
     C                   IF        WCODE > DMCODE
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
 
      *
      ** Select according to Document Narrative mask
      *
     C                   EXSR      SRDOCM
 
     C                   IF        DFNARR <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    DDNARR
     C                   PARM      30            LENGTH1
     C                   PARM      1             START
     C                   PARM                    DFNARR
     C                   PARM      30            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to reference
      *
     C                   IF        DFDREF <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    DMDREF
     C                   PARM      30            LENGTH1
     C                   PARM      1             START
     C                   PARM                    DFDREF
     C                   PARM      30            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to document status
      *
     C                   EXSR      SRSTAT
 
     C                   IF        DFSTAT <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    WSTAT
     C                   PARM      12            LENGTH1
     C                   PARM      1             START
     C                   PARM                    DFSTAT
     C                   PARM      12            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WSYST = *BLANKS
     C                   IF        BJRDNB > DMEXDT
     C                             AND DMEXDT > *ZERO
     C                             AND DMSTCD <> 'C'
     C                   EVAL      WSYST = 'EXPIRED'
     C                   ELSE
     C                   IF        BJRDNB > DMREQB
     C                             AND DMREQB > *ZERO
     C                             AND DMSTCD <> 'A'
     C                             AND DMSTCD <> 'C'
     C                   EVAL      WSYST = 'OVERDUE'
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to system status
      *
     C                   IF        DFSYST <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    WSYST
     C                   PARM      8             LENGTH1
     C                   PARM      1             START
     C                   PARM                    DFSYST
     C                   PARM      8             LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT
     C                   IF        RESULT < 1
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
 
      *
      ** Select according to Requested Date
      *
     C                   EVAL      ZDAYNO = DMRQDT
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         WRQDT             6
 
     C                   IF        DFRQDT <> *BLANK
     C                   EVAL      WScan = %SCAN (' ':DFRQDT)
     C                   IF        DFRQDT <> WRQDT
     C                             AND WScan = 0
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to Requested by Date
      *
     C                   EVAL      ZDAYNO = DMREQB
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         WREQB             6
 
     C                   IF        DFREQB <> *BLANK
     C                   EVAL      WScan = %SCAN (' ':DFREQB)
     C                   IF        DFREQB <> WREQB
     C                             AND WScan = 0
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Select according to Expiry Date
      *
     C                   EVAL      ZDAYNO = DMEXDT
     C                   EXSR      SRDATE2
     C                   MOVEL     ZDATE         WEXDT             6
 
     C                   IF        DFEXDT <> *BLANK
     C                   EVAL      WScan = %SCAN (' ':DFEXDT)
     C                   IF        DFEXDT <> WEXDT
     C                             AND WScan = 0
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * End of File
      *
     C                   IF        *IN96 = '1'
     C                   EVAL      WWEOF = 'Y'
     C                   ENDIF
      *
     C                   END
      *
     C     ERDDCMT       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CHAUTN  - Check for User Authority if Not Multi-branching    *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDOPT         ZACTN             1
     C                   PARM                    WWERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     WWERR         IFEQ      1
     C                   MOVEL     'FXM0292'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT    - Initialization                                     *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** CLEAR OUTPUTS
      *
     C                   EVAL      PERRMS = *BLANK
     C                   EVAL      POPSEL = *BLANK
     C                   EVAL      PCDSEL = *BLANK
     C                   EVAL      PINKC  = '0'
      *
     C                   IF        PINTYP = 'C'
     C                   EVAL      *IN60 = '1'
     C                   ELSE
     C                   EVAL      *IN60 = '0'
     C                   ENDIF
 
     C                   IF        PINMOD = 'E'
     C                   EVAL      DHEADR = 'Document Management +
     C                                      - Enquiry'
     C                   EVAL      *IN61 = '0'
     C                   ELSE
     C                   EVAL      DHEADR = 'Document Management +
     C                                      Maintenance'
     C                   EVAL      *IN61 = '1'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSTAT  - Get Status Values                                  *
      *                                                               *
      *  Called by: FMTDCMT, RDDCMT                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRSTAT        BEGSR
 
     C                   EVAL      WSTAT = *BLANKS
     C                   SELECT
     C                   WHEN      DMSTCD = 'A'
     C                   EVAL      WSTAT  = 'RECEIVED'
     C                   WHEN      DMSTCD = 'C'
     C                   EVAL      WSTAT  = 'DELETED'
     C                   WHEN      DMSTCD = 'O'
     C                   EVAL      WSTAT  = 'OUTSTANDING'
     C                   WHEN      DMSTCD = 'R'
     C                   EVAL      WSTAT  = 'REQUESTED'
     C                   WHEN      DMSTCD = 'Z'
     C                   EVAL      WSTAT  = 'REJECTED'
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDOCM  - Access Document Code File for Details              *
      *                                                               *
      *  Called by: FMTDCMT, RDDCMT                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRDOCM        BEGSR
      *
     C                   CALL      'AODOCMR2'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DMCODE        PDCCD
     C     SDDOCM        PARM      SDDOCM        DSSDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      DDNARR = ATDCNA
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDATE2 - Format a date for output                           *
      *                                                               *
      *  Called by: FMTDCMT, RDDCMT                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRDATE2       BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR  - Initial Processing                                 *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS:
     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN
     C                   PARM                    DDREFN
     C                   PARM                    DDCSSN
     C                   PARM                    DDCRNM
     C                   PARM                    DDCRTN
     C                   PARM                    PBDSFL
     C                   PARM                    PRDSFL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** OUTPUT PARAMETERS:
     C                   PARM                    PERRMS
     C                   PARM                    POPSEL
     C                   PARM                    PCDSEL
     C                   PARM                    PSQSEL
      ** COMMAND KEYS
     C                   PARM                    PINKC
     C                   PARM                    PINKI
     C                   PARM                    PINKE
     C                   PARM                    PINTYP
     C                   PARM                    PINMOD
      *
      ** Initialize program name
     C                   MOVEL     'SDDCMTBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
 
     C                   EVAL      DDOPT = *BLANKS
     C                   EVAL      DDCODE = *BLANKS
     C                   EVAL      WkSRef = ' '
     C                   MOVE      '1'           *IN94
     C                   MOVEL     '*'           DDPGMQ
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 901
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      DDMRDT = BJMRDT
     C                   ENDIF
 
     C     KCODE         KLIST
     C                   KFLD                    DDREFN
     C                   KFLD                    PINTYP
     C                   KFLD                    WCODE             2
      *
     C     KCDSQ         KLIST
     C                   KFLD                    DDREFN
     C                   KFLD                    PINTYP
     C                   KFLD                    WCODE             2
     C                   KFLD                    PSEQN
      *
     C     KFOID         KLIST
     C                   KFLD                    DDREFN
     C                   KFLD                    PINTYP
     C                   KFLD                    WFOID            20
      *
     C     KFOSQ         KLIST
     C                   KFLD                    DDREFN
     C                   KFLD                    PINTYP
     C                   KFLD                    WFOID
     C                   KFLD                    WCODE
     C                   KFLD                    PSEQN
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      *
      /EJECT
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
