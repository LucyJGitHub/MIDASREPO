     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Display SWIFT messages')
      *****************************************************************
      *                                                               *
      *  Midas - TI Module                                            *
      *                                                               *
      *  TI0506    - TI Display Swift Messages                        *
      *                                                               *
      *  Function:  This pgm displays all Swift messages, and allows  *
      *             their posting status to be reset.                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 213821             Date 09Jan03               *
      *                 198871             Date 08Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003  *CREATE    Date 12Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  213821 - Records are not process when updates are requested. *
      *         - Enhance subfile processing.                         *
      *  198871 - Records on MSIXI2LH are being locked, preventing    *
      *           other jobs access to the file.                      *
      *  CTI003 - Midas/TI Interface CoB changes                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FTI0506DF  CF   E             WORKSTN
     F                                     SFILE(TI0506B1:@@RRN)
      * Postings File
     FMSIXI2LH  UF   E           K DISK    INFSR(*PSSR)  INFDS(FILDTA)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D LDA           E DS           256    EXTNAME(LDA)
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for bank details
     D D@CURR        E DS                  EXTNAME(SDCURRPD)
 
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** File Information Data Structure
     D FILDTA          DS
     D D#TOT                 156    159I 0
 
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
     C     BLDSFL        BEGSR
     C     REBLD         TAG
      *
      ** Initialise control field for number of records
      *
     C                   Z-ADD     D#TOT         @@TOT             6 0
      *
      ** Initialise subfile relative record number, and
      ** 'Position to' record number
      *
     C                   Z-ADD     0             @@RRN             4 0
     C                   Z-ADD     0             D#RRN             4 0
      *
      ** Reset enter key indicator to ensure the first page
      ** is written; reset 'Roll up' message indicator; reset
      ** 'R=Reset' message indicator.
      *
     C                   MOVE      ' '           ENTER             1
     C                   MOVE      *OFF          *IN95
     C                   MOVE      *OFF          *IN34
      *
      ** Reset indicator to display 'Rollup..' message.
      *
     C                   MOVE      *OFF          *IN95
      **********                                                                              213821
      ***Reset*to*beginning*of*file*if*'position*to'*not                                      213821
      ** requested.                                                                           213821
      **********                                                                              213821
      *                                                                                       213821
      ** Keep subfile on current page if 'position to' not                                    213821
      ** requested.                                                                           213821
      *                                                                                       213821
     C     @@TRNO        IFEQ      *BLANK
     C                   EVAL      MSKEY1 = FIRSTRECPAG                                       213821
     C                   ELSE                                                                 213821
     C                   EVAL      MSKEY1 = @@TRNO                                            213821
     C                   ENDIF                                                                213821
     C     MSKEY         SETLL     MSIXI2D0                           505152                  213821
     C**** *LOVAL        SETLL     MSIXI2D0                                                   213821
     C**********         ELSE                                                                 213821
      **********                                                                              213821
      ***Otherwise,*SETLL*to*requested*position.                                              213821
      **********                                                                              213821
     C*****@@TRNO        SETLL     MSIXI2D0                           505152                  213821
      **********                                                                              213821
      ***If*exact*match*not*found,*read*backwards*to*find                                     213821
      ***first*valid*record*before*the*requested*position.                                    213821
      **********                                                                              213821
     C******IN52         IFEQ      *OFF                                                       213821
     C**********         READP     MSIXI2D0                               96                  213821
     C**********         READP     MSIXI2D0                               96                  213821
      *
      ** Beginning of File
      *
     C******IN96         IFEQ      *ON                                                        213821
     C     *IN50         IFEQ      *ON                                                        213821
     C     *LOVAL        SETLL     MSIXI2D0
     C                   ENDIF
     C**********         ENDIF                                                                213821
     C**********         ENDIF                                                                213821
      *
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
      *
     C                   MOVE      *ON           *IN97
     C                   WRITE     TI0506C1
     C                   MOVE      *OFF          *IN97
      *
      ** Read a message
      *
     C                   READ      MSIXI2D0                               96
      *
      ** Read records from the file into the subfile, one page at a
      ** time.  Repeat the process until F3 is keyed.
      ** Set on *IN98 to ensure first page is read.
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
     C     *IN96         ANDNE     *ON
     C     @@CNT         ANDLT     15
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format fields for output
      *
     C                   EXSR      FMTFLD
      *                                                                                       213821
      ** Save first record read for page                                                      213821
      *                                                                                       213821
     C                   IF        @@CNT = 1                                                  213821
     C                   EVAL      FIRSTRECPAG = DTRNO                                        213821
     C                   ENDIF                                                                213821
      *
      ** Write the trade to the subfile.
      *
     C                   WRITE     TI0506B1
      *
      ** Read a message
      *
     C                   READ      MSIXI2D0                               96
     C                   ENDDO
      *
      ** If End-of-file flag is on, but number of records read is
      ** less than the number in file, we have repositioned to a
      ** specific record.  Reset number of file records to the number
      ** actually read.
      *
     C     *IN96         IFEQ      *ON
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
     C     *IN96         IFEQ      *OFF
     C     *IN95         ANDEQ     *OFF
     C                   READ      MSIXI2D0                               96
     C     *IN96         IFEQ      *OFF
     C                   MOVE      *ON           *IN95
     C                   READP     MSIXI2D0                               96
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
     C                   MOVE      'Y'           ENTER
      *
      ** Initialise subfile page size
      *
     C                   Z-ADD     15            @@PAGE            3 0
      *                                                                                       198871
      **  Before processing the subfile, release the record lock on                           198871
      **  MSIXI2LH.                                                                           198871
     C                   UNLOCK    MSIXI2LH                                                   198871
      *
      ** If no records, write format to display a suitable message
      *
     C     D#RRN         IFEQ      0
     C                   EXFMT     TI0506N1                             90
     C                   GOTO      REBLD
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
      *
      ** If there are more records to add to subfile, leave
      ** display loop, and add records; otherwise reposition
      ** the RRN and display subfile.
      *
     C     *IN96         IFEQ      *OFF
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
     C                   CLEAR                   D#TRNO
      *
     C                   WRITE     TI0506F1
     C                   WRITE     TI0506C1
     C                   EXFMT     TI0506C2                             90
      *                                                                                       213821
      ** Check whether update is requested                                                    213821
      *                                                                                       213821
     C                   MOVEL     ' '           UPDAT             1                          213821
     C                   READC     TI0506B1                               20                  213821
     C     *IN20         DOWEQ     *OFF                                                       213821
      *                                                                                       213821
      ** Update file                                                                          213821
      *                                                                                       213821
     C     D#SEL         IFEQ      'R'                                                        213821
     C                   EVAL      MSKEY1 = DTRNO                                             213821
      *                                                                                       213821
     C     MSKEY         CHAIN     MSIXI2LH                           99                      213821
     C                   MOVEL     ' '           LSTS                                         213821
     C                   UPDATE    MSIXI2D0                                                   213821
     C                   MOVEL     'Y'           UPDAT                                        213821
     C                   ENDIF                                                                213821
      *                                                                                       213821
     C                   READC     TI0506B1                               20                  213821
     C                   ENDDO                                                                213821
     C                   ENDIF
      *
     C     *INKC         IFEQ      *ON
     C     *INKE         OREQ      *ON
     C     UPDAT         OREQ      'Y'                                                        213821
     C     D#TRNO        ORNE      *BLANKS
     C                   MOVE      ' '           ENTER
     C                   ENDIF
     C                   ENDDO
     C************       ENDIF                                                                213821
      *
      ** Reset 'position to' field
      *
     C                   CLEAR                   @@TRNO           16
      *
      ** If F5, rebuild
      *
     C     *INKE         IFEQ      *ON
     C                   GOTO      REBLD
     C                   ENDIF
      *
      ** If 'Position to' is requested...
      *
     C     D#TRNO        IFNE      *BLANKS
      *
      ** Save 'Position to' value, and clear display field.
      *
     C                   MOVE      D#TRNO        @@TRNO
     C                   CLEAR                   D#TRNO
      *
      ** Rebuild the subfile from requested position.
      *
     C                   GOTO      REBLD
      *
     C                   ENDIF
      **********                                                                              213821
      ***Check*whether*update*is*requested                                                    213821
      **********                                                                              213821
     C**********         MOVEL     ' '           UPDAT             1                          213821
     C**********         READC     TI0506B1                               20                  213821
     C******IN20         DOWEQ     *OFF                                                       213821
      **********                                                                              213821
      ***Update file                                                                          213821
      **********                                                                              213821
     C*****D#SEL         IFEQ      'R'                                                        213821
     C*****DTRNO         CHAIN     MSIXI2LH                           99                      213821
     C**********         MOVEL     ' '           LSTS                                         213821
     C**********         UPDATE    MSIXI2D0                                                   213821
     C**********         MOVEL     'Y'           UPDAT                                        213821
     C**********         ENDIF                                                                213821
      **********                                                                              213821
     C**********         READC     TI0506B1                               20                  213821
     C**********         ENDDO                                                                213821
      *
      ** If file has been updated, rebuild
      *
     C     UPDAT         IFEQ      'Y'
     C                   GOTO      REBLD
     C                   ENDIF
     C                   ENDIF                                                                213821
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      ******************************************************************
      * FMTFLD - Format trade for output
      ******************************************************************
     C     FMTFLD        BEGSR
      *
      ** Initialise display fields
      *
     C                   MOVE      *OFF          *IN33
     C                   CLEAR                   D#SEL
     C                   CLEAR                   DLSTS
     C                   CLEAR                   DTRNO
     C                   CLEAR                   DMIR
      *
      ** If status field is blank, display 'N' and do not
      ** display Select field - otherwise display both
      ** Status & Select field.  If Select field is
      ** displayed, display 'R=Reset' message.
      *
     C     LSTS          IFEQ      ' '
     C                   MOVE      'N'           DLSTS
     C                   MOVE      *ON           *IN33
     C                   ELSE
     C                   MOVE      LSTS          DLSTS
     C                   MOVE      *ON           *IN34
     C                   ENDIF
      *
      ** Transaction number
      *
     C                   MOVEL     TRNO          DTRNO
      *
      ** Message reference
      *
     C                   MOVEL     MIR           DMIR
      *
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Clear output fields
     C                   MOVE      *BLANK        @ERRMS            7
     C                   MOVE      *BLANK        @OPSEL            1
      *
      ** Define work field Access Pgm Return Code
     C                   MOVEL     *BLANK        WUAPRC            7
      *                                                                                       213821
      ** Define work field for first record page                                              213821
      *                                                                                       213821
     C     *LIKE         DEFINE    DTRNO         FIRSTRECPAG                                  213821
      *
      ** Define KLIST for MSIXI2LH access                                                     213821
     C     MSKEY         KLIST                                                                213821
     C                   KFLD                    MSKEY1           16                          213821
      *                                                                                       213821
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialise program name
     C                   MOVEL     'TI0506'      DBPGM
      *
      ** Move workstation ID to screen field.
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
