     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM Interest Rates Details Browser Module')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  FDINTRBRW - Interest Rates Details - Browse                  *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *            - will build and display a sub-file of valid       *
      *              interest rates which the user is authorised      *
      *              to view.                                         *
      *            - picks off the interest rate that the user        *
      *              has selected.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CAP058  *CREATE    Date 13Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP058 - Full API for Money Market Interest Rates            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFDINTRBDF CF   E             WORKSTN
     F                                     SFILE(FDINTRS0:@@RRN)
     F                                     SFILE(FDINTRS1:@@RRN)
     F                                     SFILE(FDINTRS2:@@RRN)
 
      ** Interest Rates Transaction Details File - by Currency, Period type and Period
     FFDINTRLL  IF   E           K DISK    INFSR(*PSSR)
 
      ** Interest Rates Transaction Details File - by Front Office Id and Ccy (Borrow)
     FFDINTRL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FDINTRP0:INTRBRW)
 
      ** Interest Rates Transaction Details File - by Front Office Id.
     FFDINTRL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FDINTRP0:INTRLND)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      *      FUNCTION OF INDICATORS                                   *
      *                                                               *
      *       95  Subfile Next Change                                 *
      *       96  End of File                                         *
      *       97  Subfile Clear                                       *
      *       98  Rollup                                              *
      *       99  Read error                                          *
      *       LR  End of Program                                      *
      *                                                               *
      *       KC  Function Key - F13 (Program Exit)                   *
      *       KK  Function Key - F11 (Toggle)                         *
      *       KL  Function Key - F12 (Cancel)                         *
      *       KP  Function Key - F15 (Browse Records)                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      SUBROUTINE DESCRIPTION                                   *
      *                                                               *
      *      *INZSR        - Program Initilisation                    *
      *      SrINIT        - Initialisation                           *
      *      SrBLDSFL0     - Build Sub-File by Currency and Period    *
      *                      Date Order                               *
      *      SrBLDSFL1     - Build Sub-File by Front Office Id        *
      *                      (Borrow)                                 *
      *      SrBLDSFL2     - Build Sub-File by Front Office Id        *
      *                      (Lending)                                *
      *      SrRDSFL       - Read Sub-File processing                 *
      *      SrFMTDET      - Format Interest Rate Details for Output  *
      *      SrFMTRAT      - Format Borrow/Lend Rate to Screen Format *
      *      SrFDINTR      - Read a Valid Interest Rate Record from   *
      *                      file                                     *
      *      SrCHKAUT      - Authority Validation processing          *
      *      *PSSR         - Standard Error Subroutine                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      PROCEDURES AND PROGRAMS CALLED                           *
      *                                                               *
      *      AOBANKR0      - Access Object for Bank Details           *
      *      ZA0920        - Format Amount for Output                 *
      *      ZVACTU        - Validate Authority                       *
      *                                                               *
      *****************************************************************
 
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
 
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             96     96
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Indicator Array
     DIndicatorP       S               *   INZ(%ADDR(*IN))
 
      ** Subfile indicator (N,B,L)
     D WSUBF           S              1A
 
      ** Valid Record indicator
     D ValidRec        S              1A
 
      ** Input Parameter (Build and Read Subfile indicator)
     D PBDSFL          S              1A
     D PRDSFL          S              1A
 
      ** Output Parameter (Error Message Id, Option Selected and Currency Selected)
     D PERRMS          S              7A
     D POPSEL          S              1A
     D PCCY            S              3A
 
      ** Function Keys (included in the output parameters)
     D PINKC           S              1A
     D PINKL           S              1A
 
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
 
      ** Initialization
 
     C                   EXSR      SrINIT
 
      ** Build Sub-file
 
     C     PBDSFL        IFEQ      'Y'
 
     C     *INKK         DOUEQ     FALSE
 
      ** Build initial subfile (Normal) screen
 
     C     WSUBF         CASEQ     'N'           SrBLDSFL0
 
      ** Build subfile by Front Office Id (Borrow)
 
     C     WSUBF         CASEQ     'B'           SrBLDSFL1
 
      ** Build subfile by Front Office Id (Lend)
 
     C     WSUBF         CASEQ     'L'           SrBLDSFL2
     C                   ENDCS
 
      ** F11, switch to appropriate subfile screens
 
     C     *INKK         IFEQ      TRUE
     C                   SELECT
     C                   WHEN      WSUBF = 'N'
     C                   EVAL      WSUBF = 'B'
     C                   WHEN      WSUBF = 'B'
     C                   EVAL      WSUBF = 'L'
     C                   WHEN      WSUBF = 'L'
     C                   EVAL      WSUBF = 'N'
     C                   ENDSL
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDIF
 
      ** READ Subfile Record
 
     C     PRDSFL        IFEQ      'Y'
     C                   EXSR      SrRDSFL
     C                   ENDIF
 
      ** Return to calling program
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrINIT - Initialisation processing                           *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** Clear subfile fields
 
     C                   CLEAR                   FDINTRS0
     C                   CLEAR                   FDINTRS1
     C                   CLEAR                   FDINTRS2
 
      ** Set subfile indicator to 'N' for the first pass
      ** (N=Normal, B=Front Office Id (Borrow), L= Front Office Id (Lend))
 
     C     PBDSFL        IFEQ      'Y'
     C                   EVAL      WSUBF = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBLDSFL0 - Build Sub-File by Currency and Period Date Order  *
      *                                                               *
      *****************************************************************
     C     SrBLDSFL0     BEGSR
 
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
 
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SrCHAUT
     C                   ENDIF
 
      ** Initialise subfile relative record number.
 
     C                   Z-ADD     0             @@RRN             5 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   MOVE      '1'           *IN97
     C                   WRITE     FDINTRC0
     C                   MOVE      '0'           *IN97
 
      ** Write header and footer to the screen
 
     C                   WRITE     FDINTRH0
     C                   WRITE     FDINTRF0
 
      ** Set file pointer on key displayed on screen.
 
     C     *LOVAL        SETLL     FDINTRLL
 
      ** Read a Valid Interest Rate
 
     C                   EXSR      SrRDINTR
 
      ** If no records exist - set up an error message.
 
     C     EndOfFile     IFEQ      TRUE
     C                   EVAL      PERRMS = 'FDM0600'
     C                   RETURN
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   MOVE      '1'           *IN98
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is taken.
 
     C     EndOfFile     DOWEQ     FALSE
     C     *IN98         ANDEQ     TRUE
 
      ** Initialise count of records written to subfile page.
 
     C                   Z-ADD     0             @@CNT             3 0
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C     EndOfFile     DOWEQ     FALSE
     C     @@CNT         ANDLT     16
 
      ** Increment the subfile record no. and records written fields.
 
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
 
      ** Format interest rates for output
 
     C                   EXSR      SrFMTDET
 
      ** Write the interest rate details to the subfile.
 
     C                   EVAL      DDSELT = *BLANK
     C                   Z-ADD     @@RRN         DDRLRN
     C                   WRITE     FDINTRS0
 
      ** Read next valid interest rate
 
     C                   EXSR      SrRDINTR
     C                   ENDDO
 
      ** Write the subfile control record to the screen to display
      ** the subfile.
 
     C                   WRITE     FDINTRC0
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
 
     C                   READ      FDINTRC0                               99
 
      ** If F3, bypass further processing.
 
     C     *INKC         IFEQ      TRUE
     C                   EVAL      PINKC = TRUE
     C                   EVAL      *INLR = TRUE
     C                   RETURN
     C                   ENDIF
 
      ** If F12, bypass further processing.
 
     C     *INKL         IFEQ      TRUE
     C                   EVAL      PINKL = TRUE
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBLDSFL1 - Build Sub-File by Front Office Id (Borrow)        *
      *                                                               *
      *****************************************************************
     C     SrBLDSFL1     BEGSR
 
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
 
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SrCHAUT
     C                   ENDIF
 
      ** Initialise subfile relative record number.
 
     C                   Z-ADD     0             @@RRN             5 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   MOVE      '1'           *IN97
     C                   WRITE     FDINTRC1
     C                   MOVE      '0'           *IN97
 
      ** Write header and footer to the screen
 
     C                   WRITE     FDINTRH0
     C                   WRITE     FDINTRF0
 
      ** Set file pointer on key displayed on screen.
 
     C     *LOVAL        SETLL     FDINTRL0
 
      ** Read a Valid Interest Rate
 
     C                   EXSR      SrRDINTR
 
      ** If no records exist - set up an error message.
 
     C     EndOfFile     IFEQ      TRUE
     C                   EVAL      PERRMS = 'FDM0600'
     C                   RETURN
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   MOVE      '1'           *IN98
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
 
     C     EndOfFile     DOWEQ     FALSE
     C     *IN98         ANDEQ     TRUE
 
      ** Initialise count of records written to subfile page.
 
     C                   Z-ADD     0             @@CNT
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C     EndOfFile     DOWEQ     FALSE
     C     @@CNT         ANDLT     16
 
      ** Increment the subfile record no. and records written fields.
 
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
 
      ** Format interest rates for output
 
     C                   EXSR      SrFMTDET
 
      ** Write the interest rate details to the subfile.
 
     C                   EVAL      DDSELT = *BLANK
     C                   Z-ADD     @@RRN         DDRLRN
     C                   WRITE     FDINTRS1
 
      ** Read next valid interest rate
 
     C                   EXSR      SrRDINTR
     C                   ENDDO
 
      ** Write the subfile control record to the screen to display
      ** the subfile.
 
     C                   WRITE     FDINTRC1
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
 
     C                   READ      FDINTRC1                               99
 
      ** If F3, bypass further processing.
 
     C     *INKC         IFEQ      TRUE
     C                   EVAL      PINKC = TRUE
     C                   EVAL      *INLR = TRUE
     C                   RETURN
     C                   ENDIF
 
      ** If F12, bypass further processing.
 
     C     *INKL         IFEQ      TRUE
     C                   EVAL      PINKL = TRUE
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBLDSFL2 - Build Sub-File by Front Office Id (Lend)          *
      *                                                               *
      *****************************************************************
     C     SrBLDSFL2     BEGSR
 
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
 
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SrCHAUT
     C                   ENDIF
 
      ** Initialise subfile relative record number.
 
     C                   Z-ADD     0             @@RRN             5 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   MOVE      '1'           *IN97
     C                   WRITE     FDINTRC2
     C                   MOVE      '0'           *IN97
 
      ** Write header and footer to the screen
 
     C                   WRITE     FDINTRH0
     C                   WRITE     FDINTRF0
 
      ** Set file pointer on key displayed on screen.
 
     C     *LOVAL        SETLL     FDINTRL1
 
      ** Read a Valid Interest Rate
 
     C                   EXSR      SrRDINTR
 
      ** If no records exist - set up an error message.
 
     C     EndOfFile     IFEQ      TRUE
     C                   EVAL      PERRMS = 'FDM0600'
     C                   RETURN
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   MOVE      '1'           *IN98
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is taken.
 
     C     EndOfFile     DOWEQ     FALSE
     C     *IN98         ANDEQ     TRUE
 
      ** Initialise count of records written to subfile page.
 
     C                   Z-ADD     0             @@CNT
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C     EndOfFile     DOWEQ     FALSE
     C     @@CNT         ANDLT     16
 
      ** Increment the subfile record no. and records written fields.
 
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
 
      ** Format interest rates for output
 
     C                   EXSR      SrFMTDET
 
      ** Write the interest rate details to the subfile.
 
     C                   EVAL      DDSELT = *BLANK
     C                   Z-ADD     @@RRN         DDRLRN
     C                   WRITE     FDINTRS2
 
      ** Read next valid interest rate
 
     C                   EXSR      SrRDINTR
     C                   ENDDO
 
      ** Write the subfile control record to the screen to display
      ** the subfile.
 
     C                   WRITE     FDINTRC2
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
 
     C                   READ      FDINTRC2                               99
 
      ** If F3, bypass further processing.
 
     C     *INKC         IFEQ      TRUE
     C                   EVAL      PINKC = TRUE
     C                   EVAL      *INLR = TRUE
     C                   RETURN
     C                   ENDIF
 
      ** If F12, bypass further processing.
 
     C     *INKL         IFEQ      TRUE
     C                   EVAL      PINKL = TRUE
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRDSFL - Read Sub-File processing                           *
      *                                                               *
      *****************************************************************
     C     SrRDSFL       BEGSR
 
      ** Read the subfile for selected records
      ** Only process those for which the option field is  blank.
 
     C                   DOU       (*IN99 = TRUE) OR (DDSELT <> *BLANK)
     C                   SELECT
     C                   WHEN      WSUBF = 'N'
     C                   READC     FDINTRS0                               99
     C                   WHEN      WSUBF = 'B'
     C                   READC     FDINTRS1                               99
     C                   WHEN      WSUBF = 'L'
     C                   READC     FDINTRS2                               99
     C                   ENDSL
     C                   ENDDO
 
      ** Return the selected interest rate and action
 
 
     C                   IF        (*IN99 <> TRUE) AND (DDSELT <> *BLANK)
     C                   EVAL      POPSEL = DDSELT
     C                   EVAL      PCCY  = DDCCY
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFMTDET - Format Interest Rate Details for Output to SFile  *
      *                                                               *
      *****************************************************************
     C     SrFMTDET      BEGSR
 
      ** Clear subfile fields
 
     C                   CLEAR                   FDINTRS0
     C                   CLEAR                   FDINTRS1
     C                   CLEAR                   FDINTRS2
 
      ** Format interest rate details, Currency
 
     C                   EVAL      DDCCY = WCCY
 
      ** Format Overnight Borrow rate
 
     C                   IF        WOBRWR <> *ZERO
     C                   MOVE      WOBRWR        WAMTNUM
     C                   Z-ADD     7             WNODEC
     C                   EXSR      SrFMTRAT
     C                   MOVE      WAMTCHR       DDOBRW
     C                   ENDIF
 
      ** Format Tommorow/Next Borrow rate
 
     C                   IF        WNBRWR <> *ZERO
     C                   MOVE      WNBRWR        WAMTNUM
     C                   Z-ADD     7             WNODEC
     C                   EXSR      SrFMTRAT
     C                   MOVE      WAMTCHR       DDNBRW
     C                   ENDIF
 
      ** Format Overnight Lending rate
 
     C                   IF        WOLNDR <> *ZERO
     C                   MOVE      WOLNDR        WAMTNUM
     C                   Z-ADD     7             WNODEC
     C                   EXSR      SrFMTRAT
     C                   MOVE      WAMTCHR       DDOLND
     C                   ENDIF
 
      ** Format Tommorow/Next Lending rate
 
     C                   IF        WNLNDR <> *ZERO
     C                   MOVE      WNLNDR        WAMTNUM
     C                   Z-ADD     7             WNODEC
     C                   EXSR      SrFMTRAT
     C                   MOVE      WAMTCHR       DDNLND
     C                   ENDIF
 
 
      ** Front Office Id (Borrow/Lend)
 
     C                   EVAL      DDBOFR = WBOFRNT
     C                   EVAL      DDLEFR = WLEFRNT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFMTRAT - Format Borrow/Lend Rate to Screen Format          *
      *                                                               *
      *****************************************************************
     C     SrFMTRAT      BEGSR
 
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        WRTCD            10
     C                   PARM                    WAMTNUM          13 0
     C                   PARM                    WNODEC            1 0
     C                   PARM      '.'           WSEPA             1
     C                   PARM      *BLANK        WAMTCHR          14
 
      ** Error calling module
 
     C                   IF        WRTCD <> *BLANK
     C                   EVAL      DBFILE = *BLANK
     C                   EVAL      DBFILE = 'ZA0290'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = *BLANK
     C                   EVAL      DBKEY = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDINTR - Read a Valid Interest Rate Record from file       *
      *                                                               *
      *****************************************************************
     C     SrRDINTR      BEGSR
 
      ** Reset End of File and skip record indicator
 
     C                   EVAL      EndOfFile = FALSE
     C                   EVAL      ValidRec = 'N'
 
      ** Read the file initially - if EOF is set on then the end of
      ** the file has been reached.  Read until a valid record is
      ** found or until no more records exist.
 
     C                   DOU       (EndOfFile = TRUE) OR (ValidRec = 'Y')
 
      ** Read the file
 
     C                   SELECT
     C     WSUBF         WHENEQ    'N'
     C                   READ      FDINTRLL                               96
     C     WSUBF         WHENEQ    'B'
     C                   READ      FDINTRL0                               96
     C     WSUBF         WHENEQ    'L'
     C                   READ      FDINTRL1                               96
     C                   ENDSL
 
      ** Valid interest rate has been read
 
     C                   IF        (*IN96 = FALSE) AND (HWDLTF = *BLANK)
     C                             AND (HWTPRD = 'D')
     C                   IF        (HWPRD = 1) OR (HWPRD = 2)
 
      ** Overnight
 
     C                   IF        (HWPRD = 1)
     C                   EVAL      WCCY = HWCCY
     C                   EVAL      WBOFRNT = HWBOFR
     C                   EVAL      WLEFRNT = HWLEFR
     C                   EVAL      WOBRWR = HWBRRT
     C                   EVAL      WOLNDR = HWLDRT
     C                   ENDIF
 
      ** Tomorrow/Next
 
     C                   IF        (HWPRD = 2) AND (WCCY = HWCCY)
     C                   EVAL      WNBRWR = HWBRRT
     C                   EVAL      WNLNDR = HWLDRT
     C                   EVAL      ValidRec = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKAUT - Authority Validation processing                   *
      *                                                               *
      *****************************************************************
     C     SrCHAUT       BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    WERR              1 0
 
      ** Return error message
 
     C     WERR          IFEQ      1
     C                   MOVEL     'FXM0292'     PERRMS
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
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
 
      ** Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PBDSFL
     C                   PARM                    PRDSFL
     C                   PARM                    PERRMS
     C                   PARM                    POPSEL
     C                   PARM                    PCCY
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
      ** Initialize program name
 
     C     *LOCK         IN        LDA
     C                   MOVEL     'FDINTRBRW'   DBPGM
     C                   OUT       LDA
 
      ** Define other workfields used
 
     C     *LIKE         DEFINE    HWCCY         WCCY
     C     *LIKE         DEFINE    HWBOFR        WBOFRNT
     C     *LIKE         DEFINE    HWLEFR        WLEFRNT
     C     *LIKE         DEFINE    HWBRRT        WOBRWR
     C     *LIKE         DEFINE    HWBRRT        WNBRWR
     C     *LIKE         DEFINE    HWLDRT        WOLNDR
     C     *LIKE         DEFINE    HWLDRT        WNLNDR
 
      ** Move workstation ID to screen field.
 
     C                   MOVEL     PsJobName     DDWSID
     C                   MOVEL     PsUser        DDUSER
 
      ** Access bank detail
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
