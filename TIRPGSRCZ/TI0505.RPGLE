     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Display Outstanding Postings/Accruals')
      *****************************************************************
      *                                                               *
      *  Midas - TI Module                                            *
      *                                                               *
      *  TI0505 - TI Postings browse                                  *
      *                                                               *
      *  Function:  This pgm displays a list of outstanding deals     *
      *             and allows them to be posted.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG3604            Date 23Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 212558                  30Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003  *CREATE    Date 12Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3604 - Send message when F7 fails because background      *
      *            TIJRNENT is still running.                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  212558 - Use TIPOSTLB to use Branch as primary key.          *
      *  CTI003 - Midas/TI Interface CoB changes                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FTI0505DF  CF   E             WORKSTN
     F                                     SFILE(TI0505B1:@@RRN)
      * Postings File
     F*TIPOSTL0*IF***E           K DISK    INFSR(*PSSR)                                       212558
     FTIPOSTLB  IF   E           K DISK    INFSR(*PSSR)                                       212558
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------
 
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
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for bank details
     D D@CURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for concatenating account number
     D DSACNBR         DS
     D BRCA                    1      3
     D*CNUM*****               4      9  0                                                    CSD027
     D CNUM                    4      9A                                                      CSD027
     D CCY                    10     12
     D***ACOD***                13     16  0                                                  CGL029
     D***ACSQ***                17     18  0                                                  CGL029
     D ACOD                   13     22  0                                                    CGL029
     D ACSQ                   23     24  0                                                    CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
      ** Initialisation
      *
     C                   EXSR      INIT
      *
      ** Build subfile.
      *
     C                   EXSR      BLDSFL
      *
      ** Return
      *
     C                   SETON                                            LR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - Build subfile
      ********************************************************************
      *
     C     BLDSFL        BEGSR
     C     REBLD         TAG
      *
      ** Call TIC0505 to count the number of records dependent on
      ** mode.  If *IN30 is off, this is Display Unposted
      ** Transactions, else Display Accruals.
      *
     C     *IN30         IFEQ      *OFF
     C                   MOVE      'Unposted'    MODE
     C                   ELSE
     C                   MOVE      'Pending '    MODE
     C                   ENDIF
      *
     C                   CALL      'TIC0505'
     C                   PARM                    MODE              8
     C                   PARM                    NBRRCD           10 0
      *
      ** If in Display Accruals Mode, we have retrieved the number of
      ** unposted accruals - now we need the total number.
      *
     C     *IN30         IFEQ      *ON
     C                   Z-ADD     NBRRCD        D#PEN
     C                   MOVE      'Accruals'    MODE
      *
     C                   CALL      'TIC0505'
     C                   PARM                    MODE
     C                   PARM                    NBRRCD
      *
     C                   ENDIF
      *
     C                   Z-ADD     NBRRCD        D#TOT
     C                   Z-ADD     NBRRCD        @@TOT             6 0
      *
      ** Initialise subfile relative record number, and
      ** 'Position to' record number
      *
     C                   Z-ADD     0             @@RRN             4 0
     C                   Z-ADD     0             D#RRN             4 0
      *
      ** Initialise subfile page size
      *
     C                   Z-ADD     15            @@PAGE            3 0
      *
      ** Reset indicator to display 'Rollup..' message.
      *
     C                   MOVE      *OFF          *IN95
      *
      ** Reset to beginning of file, or 'position to', if requested
      *
     C                   EXSR      READP
      *
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
      *
     C                   MOVE      *ON           *IN97
     C                   WRITE     TI0505C1
     C                   MOVE      *OFF          *IN97
      *
      ** Read an outstanding deal
      *
     C                   EXSR      RDTDRF
      *
      ** Read records from the file into the subfile, one page at a
      ** time.  Repeat the process until F3 is keyed.
      ** Set on *IN98 to ensure first page is written.
      *
     C                   MOVE      *ON           *IN98
     C     *INKC         DOWEQ     *OFF
      *
      ** Only read new records if rollup is requested - do this
      ** until end of file or the subfile page is full.
      ** First initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
     C     *IN98         DOWEQ     *ON
     C     @@EOF         ANDNE     'Y'
     C     @@CNT         ANDLT     @@PAGE
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format trade fields for output
      *
     C                   EXSR      FMTTRD
      *
      ** Write the trade to the subfile.
      *
     C                   WRITE     TI0505B1
      *
      ** Read a valid Trade
      *
     C                   EXSR      RDTDRF
     C                   ENDDO
      *
      ** If End-of-file flag is on, but number of records read is
      ** less than the number in file, we have repositioned to a
      ** specific record.  Reset number of file records to the number
      ** actually read.
      *
     C     @@EOF         IFEQ      'Y'
     C     D#RRN         ANDLT     @@TOT
     C                   Z-ADD     @@RRN         @@TOT
     C                   ENDIF
      *
      ** If End-of-file flag is off, and 'Rollup..' message
      ** indicator is off, we have read exactly one page of
      ** records.  Check whether any more valid records exist.
      ** If so, set on indicator to display 'Rollup..'
      ** message, and reposition file for next read.
      *
     C     @@EOF         IFEQ      ' '
     C     *IN95         ANDEQ     *OFF
     C                   EXSR      RDTDRF
     C     @@EOF         IFEQ      ' '
     C                   MOVE      *ON           *IN95
     C**********         READP     TIPOSTL0                               96                  212558
     C                   READP     TIPOSTLB                               96                  212558
     C                   ENDIF
     C                   ENDIF
      *
      ** If Rollup was entered, increment the display position;
      ** reset Rollup indicator.
      *
     C     *IN98         IFEQ      *ON
     C                   ADD       @@CNT         D#RRN
     C                   MOVE      *OFF          *IN98
     C                   ENDIF
      *
      ** Reset enter key indicator to ensure control is kept by
      ** the program, not by the SFLCTLRCD
      *
     C                   MOVE      'Y'           ENTER             1
      *
      ** If no records, write format to display a suitable message
      ** (also disallows F7 command key, and displays an
      ** alternative command key text).
      *
     C     @@TOT         IFEQ      0
     C                   EXFMT     TI0505N1                             90
      *
     C                   ELSE
      *
      ** If there are records..
      ** Take control of subfile until valid command key entered
      ** or until new records have to be read.
      *
     C     ENTER         DOUEQ     ' '
      *
      ** Rollup
      *
     C     *IN81         IFEQ      *ON
     C                   MOVE      *OFF          *IN81
     C                   MOVE      *OFF          *IN84                                       BUG3604
      *
      ** If there are more records to add to subfile, leave
      ** display loop, and add records; otherwise reposition
      ** the RRN and display subfile.
      *
     C     @@EOF         IFNE      'Y'
     C     D#RRN         ANDEQ     @@RRN
     C     D#RRN         ANDLT     @@TOT
     C                   MOVE      ' '           ENTER
     C                   MOVE      *ON           *IN98
      *
     C                   ELSE
     C                   ADD       @@PAGE        D#RRN
      *
      ** Check whether the requested display position is
      ** greater than the number of records available.
      ** If so, reset display position to last record.
      *
     C     D#RRN         IFGT      @@TOT
     C                   Z-ADD     @@TOT         D#RRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Rolldown
      ** Reposition the RRN and display subfile.
      *
     C     *IN82         IFEQ      *ON
     C                   SUB       @@PAGE        D#RRN
     C                   MOVE      *OFF          *IN82
     C                   MOVE      *OFF          *IN84                                       BUG3604
      *
      ** If on first page, reposition to lesser of page
      ** length or file length.
      *
     C     D#RRN         IFLE      0
     C     @@TOT         IFLT      @@PAGE
     C                   Z-ADD     @@TOT         D#RRN
     C                   ELSE
     C                   Z-ADD     @@PAGE        D#RRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     ENTER         IFEQ      'Y'
     C                   CLEAR                   D#BRCH
     C                   CLEAR                   D#TYPE
     C                   CLEAR                   D#REF
      *
     C                   WRITE     TI0505F1
     C                   WRITE     TI0505C1
     C                   EXFMT     TI0505C2                             90
     C                   ENDIF
      *
      ** If a valid command key has been entered, get out of
      ** loop and process request.
      *
     C     *INKC         IFEQ      *ON
     C     *INKE         OREQ      *ON
     C     *INKG         OREQ      *ON
     C     *INKP         OREQ      *ON
     C     D#BRCH        ORNE      0
     C                   MOVE      ' '           ENTER
     C                   MOVE      *OFF          *IN84                                       BUG3604
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
      ** If F5, rebuild
      *
     C     *INKE         IFEQ      *ON
     C                   GOTO      REBLD
     C                   ENDIF
      *
      ** If F7, call TIC0340 and return? or rebuild?
      *
     C     *INKG         IFEQ      *ON
     C                   CALL      'TIC0340'
     C                   PARM      'B'           PASS              1
     C**********         PARM      ' '           PASS                                        BUG3604
     C**********         PARM      ' '           PASS                                        BUG3604
     C**********         PARM      ' '           PASS                                        BUG3604
     C**********         PARM      ' '           PASS                                        BUG3604
     C                   PARM      ' '           PASS2             1                         BUG3604
     C                   PARM      'I'           PASS3             1                         BUG3604
     C                   PARM      ' '           PASS4             1                         BUG3604
     C                   PARM      ' '           PASS5             1                         BUG3604
     C*                                                                                      BUG3604
     C** If the above call fails due to dtaara already allocated by another TIC0340.         BUG3604
     C*                                                                                      BUG3604
     C     PASS2         IFEQ      'L'                                                       BUG3604
     C                   MOVE      *ON           *IN84                                       BUG3604
     C                   ENDIF                                                               BUG3604
     C*                                                                                      BUG3604
     C**********         SETON                                            LR                 BUG3604
     C**********         RETURN                                                              BUG3604
     C                   GOTO      REBLD
     C                   ENDIF
      *
      ** If F15, toggle between Outstanding Postings display and
      ** Today's Accruals display.  Rebuild subfile.
      *
     C     *INKP         IFEQ      *ON
     C     *IN30         IFEQ      *ON
     C                   MOVE      *OFF          *IN30
     C                   ELSE
     C                   MOVE      *ON           *IN30
     C                   ENDIF
     C                   GOTO      REBLD
     C                   ENDIF
      *
      ** If 'Position to' is requested...
      *
     C     D#BRCH        IFNE      0
      *
      ** Set up Key list (Make sure that the branch is three
      ** long, left justified with a space in 4th position).
      *
     C                   CLEAR                   @@BRCH3           3 0
     C                   MOVE      D#BRCH        @@BRCH3
     C                   MOVEL     @@BRCH3       @@BRCH
     C                   MOVE      D#TYPE        @@TYPE
     C                   MOVE      D#REF         @@REF
      *
      ** Rebuild the subfile from requested position.
      *
     C                   GOTO      REBLD
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      ******************************************************************
      * FMTTRD - Format trade for output
      ******************************************************************
     C     FMTTRD        BEGSR
      *
      ** Branch
      ** Coding to cope with 3 long branch codes with
      ** trailing blanks.
      *
     C                   CLEAR                   DTIDLB
     C                   Z-ADD     0             DTIDL3            3 0
     C                   CLEAR                   DTIDL4            1
      *
     C                   MOVE      TIDLBR        DTIDL4
     C     DTIDL4        IFEQ      ' '
     C                   MOVEL     TIDLBR        DTIDL3
     C                   Z-ADD     DTIDL3        DTIDLB
     C                   ELSE
     C                   MOVE      TIDLBR        DTIDLB
     C                   ENDIF
      *
      ** Deal Type
     C                   CLEAR                   DTIDLT
     C                   MOVE      TIDLTP        DTIDLT
      *
      ** Deal Ref
     C                   CLEAR                   DTIDLR
     C                   MOVE      TIDLRF        DTIDLR
      *
      ** Deal TI Sequence
     C                   CLEAR                   DTISEQ
     C                   MOVE      TISEQN        DTISEQ
      *
      ** Format Value Date field
      **   DDMMYY if *IN32 off
      **   MMDDYY if *IN32 on.
      *
     C                   CLEAR                   VDATE
     C                   MOVE      TIVALD        DAY               2
     C                   MOVEL     TIVALD        TEMP              3
     C                   MOVE      TEMP          YEAR              2
     C                   MOVE      TIVALD        TEMP2             4 0
     C                   MOVEL     TEMP2         MNTH              2
      *
     C     *IN32         IFEQ      *OFF
     C                   MOVEL     DAY           VDATE             6
     C                   CAT       MNTH:0        VDATE
     C                   ELSE
     C                   MOVEL     MNTH          VDATE
     C                   CAT       DAY:0         VDATE
     C                   ENDIF
      *
     C                   CAT       YEAR:0        VDATE
     C                   MOVE      VDATE         D#VALD
      *
      ** TI Nominal
     C                   CLEAR                   UUCYCD
     C                   MOVE      CCY           UUCYCD
      *
      ** Get currency format
     C                   CLEAR                   #1CYCD            3
     C                   CLEAR                   WUCYNM           14
     C                   CLEAR                   WUNBDP            1 0
     C                   CLEAR                   WUNOSN           10
      *
     C                   CALL      'AOCURRR0'
     C     WUAPRC        PARM      WUAPRC        UUAPRC            7
     C                   PARM      '*KEY'        UUAPOP            7
     C                   PARM                    UUCYCD            3
     C     D@CURR        PARM      *BLANK        DSSDY
      *
      ** Assign work field to file field values.
      *
     C                   MOVEL     A6CYCD        #1CYCD
     C                   MOVEL     A6CYNM        WUCYNM
     C                   MOVEL     A6NBDP        WUNBDP
     C                   MOVEL     A6NOSN        WUNOSN
      *
      ** Format amount (short) - Standard functions
     C                   Z-ADD     TIAMNT        ULVALU           15 0
      *
     C                   CALL      'GL0135U'
     C                   PARM                    ULVALU
     C                   PARM      WUNBDP        ULDECP            1 0
     C                   PARM      '3'           ULEDIT            1
     C                   PARM      *BLANK        ULCHQP            1
     C                   PARM                    ULRSLF           23
      *
     C                   MOVE      ULRSLF        DTIAMN
      *
      ** TI Dr/Cr Indicator
     C                   CLEAR                   DTIDCI
     C                   MOVE      TIDCIN        DTIDCI
      *
      ** Account Number
     C                   CLEAR                   D#ACNB
     C                   MOVEL     DSACNBR       D#ACNB
      *
      ** Posting Status
     C                   CLEAR                   D#STS
     C     PSTS          IFEQ      'JEG'
     C                   MOVE      'Btch'        D#STS
     C                   ELSE
     C                   MOVE      'Pend'        D#STS
     C                   ENDIF
      *
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * READP  - Find first valid trade
      *****************************************************************
     C     READP         BEGSR
      *
      ** Read backwards through the  file until a valid record
      ** is found.  Records are valid dependent on which
      ** display mode is requested.
      *
      ** Reset End of File indicator
      ** Reset Valid Record indicator
      *
     C                   MOVE      *BLANK        @@EOF
     C                   MOVE      *BLANK        @@VLD
      *
      *
      ** If 'position to' not requested, reset to beginning of
      ** file, and set flag.
      *
     C     @@BRCH        IFEQ      *BLANK
     C     *LOVAL        SETLL     TIPOSTD0
     C                   MOVE      'Y'           @@VLD
     C                   ELSE
      *
      ** Otherwise, SETLL to requested position.
      *
     C     @@KEY         SETLL     TIPOSTD0                               50
      *
      ** If exact match found, set flag.
      *
     C     *IN50         IFEQ      *ON
     C                   MOVE      'Y'           @@VLD
     C                   ENDIF
     C                   ENDIF
      *
      ** If exact match not found, read backwards to find
      ** first valid record before the requested position.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@VLD         ANDNE     'Y'
      *
      ** Read the file.
     C**********         READP     TIPOSTL0                               96                  212558
     C                   READP     TIPOSTLB                               96                  212558
      *
      ** Beginning of File
      *
     C     *IN96         IFEQ      *ON
     C                   MOVEL     'Y'           @@EOF
     C     *LOVAL        SETLL     TIPOSTD0
     C                   ENDIF
      *
      ** If in 'Display Outstanding Postings' mode, then only records
      ** 'Pending Journal Entry' are valid.
     C     *IN30         IFEQ      *OFF
      *
     C     PSTS          IFEQ      'PJN'
     C     PSTS          OREQ      'PJS'
     C                   MOVE      'Y'           @@VLD
     C                   ENDIF
      *
      ** If in 'Display Accruals' mode, then all records with a sequence
      ** number greater than 900 are valid.
      *
     C                   ELSE
     C     TISEQN        IFGE      900
     C                   MOVE      'Y'           @@VLD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Read back one more record.
      *
     C**********         READP     TIPOSTL0                               96                  212558
     C                   READP     TIPOSTLB                               96                  212558
      *
      ** Beginning of File
      *
     C     *IN96         IFEQ      *ON
     C     *LOVAL        SETLL     TIPOSTD0
     C                   ENDIF
      *
      ** Reset 'position to' fields
      *
     C                   CLEAR                   @@BRCH            4
     C                   CLEAR                   @@TYPE            3
     C                   CLEAR                   @@REF            13
      *
     C     EREADP        ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * RDTDRF - Read a trade
      *****************************************************************
     C     RDTDRF        BEGSR
      *
      ** Read the file until no more records exist, or until
      ** a valid record is found.  Records are valid dependent
      ** on which display mode is requested.
      *
      ** Reset End of File indicator
      ** Reset Valid Record indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
     C                   MOVE      *BLANK        @@VLD             1
      *
     C     @@EOF         DOUEQ     'Y'
     C     @@VLD         OREQ      'Y'
      *
      ** Read the file.
     C**********         READ      TIPOSTL0                               96                  212558
     C                   READ      TIPOSTLB                               96                  212558
      *
      ** End of File
      *
     C     *IN96         IFEQ      *ON
     C                   MOVEL     'Y'           @@EOF
     C                   ENDIF
      *
      ** If in 'Display Outstanding Postings' mode, then only records
      ** 'Pending Journal Entry' are valid.
     C     *IN30         IFEQ      *OFF
      *
     C     PSTS          IFEQ      'PJN'
     C     PSTS          OREQ      'PJS'
     C                   MOVE      'Y'           @@VLD
     C                   ENDIF
      *
      ** If in 'Display Accruals' mode, then all records with a sequence
      ** number greater than 900 are valid.
      *
     C                   ELSE
     C     TISEQN        IFGE      900
     C                   MOVE      'Y'           @@VLD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     ERDTDRF       ENDSR
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Determine if Accruals listing option is active
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CTI003'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      *ON           *IN31
     C                   ENDIF
      *
      ** Clear output fields
      *
     C                   MOVE      *BLANK        @ERRMS            7
     C                   MOVE      *BLANK        @OPSEL            1
      *
      ** Define work field Access Pgm Return Code
      *
     C                   MOVEL     *BLANK        WUAPRC            7
      *
      ** Check System Date Format, DDMMYY (*IN32 off)
      *                            MMDDYY (*IN32 on).
      *
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        32
     C                   ENDIF
      *
      ** Set up key fields
      *
     C     @@KEY         KLIST
     C                   KFLD                    @@BRCH
     C                   KFLD                    @@TYPE
     C                   KFLD                    @@REF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialise program name
      *
     C                   MOVEL     'TI0505'      DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
