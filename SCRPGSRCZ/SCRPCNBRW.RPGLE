     H DEBUG
     H COPYRIGHT('(c) Misys Internatinal Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data Replication Configurator Browse')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCRPCNBRW - Data Replication Configurator Browse             *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            One displays a list of physical files for          *
      *            selection, and the other picks off the selection   *
      *            made                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Data Replication Configurator Display File - Browse
     FSCRPCNBRDFCF   E             WORKSTN
     F                                     SFILE(SCRPCNBS0:WkRRN)
 
      ** Data Replication File Definition Retrieval Index
     FSCFDTLL1  IF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCFDTLD0:SCFDTLD1)
 
      ** Data Replication File Definition Keyed on PF and Repl Flag
     FSCFDTLL3  IF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCFDTLD0:SCFDTLD3)
 
      ** Data Replication File Definition Keyed on PF and Batch Num
     FSCFDTLL4  IF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCFDTLD0:SCFDTLD4)
 
      ** Data Replication File Definition Keyed on PF and Freq of Upd
     FSCFDTLL5  IF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     RENAME(SCFDTLD0:SCFDTLD5)
 
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
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WkRRN           S              5  0
     D WkCNT           S              3  0
     D WkEOF           S              1
 
     D PActCde         S              1
     D PPhyFil         S             10
     D PBldSfl         S              1
     D PRdSfl          S              1
     D PErrMsg         S              7
     D POpSel          S              1
     D PPhySel         S             10
     D PINKC           S              1
     D PINKL           S              1
     D PRetCode        S              7
     D POptn           S              7
     D OptSelected     S              1
 
      ** Key Fields
     D KPFILE          S             10A
     D KREPFL          S              1A
     D KBATNO          S              1A
     D KFREQU          S              1A
 
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
 
      ** Initialisation
 
     C                   EXSR      SRInit
 
      ** Build Sub-File
 
     C                   IF        PBldSfl = 'Y'
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
      * SRBldSFL - Build Subfile                                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     SRReadRec, SRFmtDtl, SRChkOptn                     *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
 
     C                   OPEN      SCFDTLL1
     C                   OPEN      SCFDTLL3
     C                   OPEN      SCFDTLL4
     C                   OPEN      SCFDTLL5
 
      ** Initialise subfile relative record number.
 
     C                   Z-ADD     0             WkRRN
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
 
     C                   EVAL      *IN87 = *On
     C                   WRITE     SCRPCNBC0
     C                   EVAL      *IN87 = *Off
 
      **  Write the select screen footer to the screen.
 
     C                   TIME                    #0TIME
     C                   WRITE     SCRPCNBF0
 
      **  Set file pointer on key displayed on screen.
 
     C                   SELECT
     C                   WHEN      #0REPL <> *Blanks
     C     #0REPL        SETLL     SCFDTLL3
 
     C                   WHEN      #0PFILE <> *Blanks
     C     #0PFILE       SETLL     SCFDTLL1
 
     C                   WHEN      #0BATNO <> *Blanks
     C     #0BATNO       SETLL     SCFDTLL4
 
     C                   WHEN      #0FREQU <> *BLANKS
     C     #0FREQU       SETLL     SCFDTLL5
 
     C                   OTHER
     C     *LOVAL        SETLL     SCFDTLL1
     C                   ENDSL
 
      ** Read a valid Replication record
 
     C                   EXSR      SRReadRec
 
      **  If no records exist - set up an error message.
      **  and terminate
 
     C                   IF        WkEOF = 'Y'
     C                   EVAL      PErrMsg = 'DRC0001'
     C                   EXSR      SRClose
     C                   RETURN
     C                   ENDIF
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN88 = *On
 
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
 
     C                   DOW       *IN88 = *On or OptSelected <> 'Y'
 
      ** Initialise count of records written to subfile page.
 
     C                   Z-ADD     0             WkCNT
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       WkEOF <> 'Y' and WkCNT < 14
 
      ** Increment the subfile record no. and records written fields.
 
     C                   EVAL      WkRRN = WkRRN +1
     C                   EVAL      WkCNT = WkCNT +1
 
      ** Format Data Replication Details for output
 
     C                   EXSR      SRFmtDtl
 
      ** Write the details to the subfile.
 
     C                   EVAL      PActCde = *Blanks
     C                   Z-ADD     WkRRN         #0SFRN
     C                   EVAL      #0SEL = *Blanks
     C                   WRITE     SCRPCNBS0
 
      ** Read a record
 
     C                   EXSR      SRReadRec
     C                   ENDDO
 
      ** Write the subfile control record to the screen to display
      ** the subfile.
 
     C                   WRITE     SCRPCNBC0
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
 
     C                   READ      SCRPCNBC0                              89
 
      ** If F3, bypass further processing.
 
     C                   IF        *INKC = *On
     C                   EVAL      PINKC = '1'
     C                   EVAL      *INLR = *On
     C                   EXSR      SRClose
     C                   RETURN
     C                   ENDIF
 
      **  If F12, bypass further processing.
 
     C                   IF        *INKL = *On
     C                   EVAL      PINKL = '1'
     C                   CLEAR                   SCRPCNBC0
     C                   EXSR      SRClose
     C                   RETURN
     C                   ENDIF
 
      ** If Rollup/rolldown was not pressed
 
     C                   IF        *IN88 <> *On
 
     C                   EXSR      SRChkOptn
 
      ** If no option has been selected, process selection fields
 
     C                   IF        OptSelected <> 'Y'
     C                   SELECT
     C                   WHEN      #0REPL <> *Blanks
     C*                  EVAL      KPFILE = '*LOVAL'
     C*                  EVAL      KREPFL = #0REPL
     C     #0REPL        SETLL     SCFDTLL3
 
     C                   WHEN      #0PFILE <> *Blanks
     C     #0PFILE       SETLL     SCFDTLL1
 
     C                   WHEN      #0BATNO <> *Blanks
     C*                  EVAL      KPFILE = '*LOVAL'
     C*                  EVAL      KBATNO = #0BATNO
     C     #0BATNO       SETLL     SCFDTLL4
 
     C                   WHEN      #0FREQU <> *BLANKS
     C*                  EVAL      KPFILE = '*LOVAL'
     C*                  EVAL      KFREQU = #0FREQU
     C     #0FREQU       SETLL     SCFDTLL5
 
     C                   OTHER
     C     *LOVAL        SETLL     SCFDTLL1
     C                   ENDSL
 
     C                   EXSR      SRReadRec
     C                   IF        WkEof <> 'Y'
     C                   Z-ADD     0             WkRRN
     C                   EVAL      *IN87 = *On
     C                   WRITE     SCRPCNBC0
     C                   EVAL      *IN87 = *Off
     C                   ENDIF
 
      ** Write message sub-file for error messages
 
     C                   WRITE     SCRPCNBC1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EXSR      SRClose
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdSflR - Read Subfile Record                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
     C     SRRdSflR      BEGSR
 
      ** Read the subfile for selected records
      ** Only process those for which the option field is blank.
 
     C                   DOU       *IN89 = *On  or #0SEL <> *Blanks
     C                   READC     SCRPCNBS0                              89
     C                   ENDDO
 
      **  Return the selected Replication details and option
 
     C                   IF        *IN89 = *Off and #0SEL <> *Blanks
 
     C                   IF        #0SEL <> 'A' and #0SEL <> 'C' and
     C                             #0SEL <> 'D' and #0SEL <> 'E'
     C                   EVAL      POpsel = 'E'
     C                   EVAL      PPhySel = #0PHYF
     C                   ELSE
     C                   EVAL      POpSel = #0SEL
     C                   EVAL      PPhySel = #0PHYF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFmtDtl - Format Replication fields for Output               *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
     C     SRFmtDtl      BEGSR
 
      ** Replication Flag
 
     C                   EVAL      #0RPFL = FDRPLF
 
      ** Physical File
 
     C                   EVAL      #0PHYF = FDPHYF
 
      ** Batch Number
 
     C                   EVAL      #0BATN = FDBATN
 
      ** Frequency of Update
 
     C                   EVAL      #0FREQ = FDFREQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRReadRec - Read a reocord in subfile                         *
      *                                                               *
      * Called by:  SRBldSfl                                          *
      *                                                               *
      * Calls:      None                                              *
      *                                                               *
      *****************************************************************
     C     SRReadRec     BEGSR
 
      ** Read the file initially - if WkEOF is set on then the end of
      ** the file has been reached.  Read until a valid record is
      ** found or until no more records exist.
 
      ** Read the file.
 
     C                   SELECT
     C                   WHEN      #0REPL <> *Blanks
     C                   READ      SCFDTLL3                               86
 
     C                   WHEN      #0PFILE <> *Blanks
     C                   READ      SCFDTLL1                               86
 
     C                   WHEN      #0BATNO <> *Blanks
     C                   READ      SCFDTLL4                               86
 
     C                   WHEN      #0FREQU <> *BLANKS
     C                   READ      SCFDTLL5                               86
 
     C                   OTHER
     C                   READ      SCFDTLL1                               86
     C                   ENDSL
 
      ** End of File
 
     C                   IF        *IN86 = *On
     C                   EVAL      WkEOF = 'Y'
     C                   ELSE
     C                   EVAL      WKEOF = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRChkOpt - Subroutine to check if an option was selected     *
      *                                                               *
      *  Called by: SRBldSfl                                          *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRChkOptn     BEGSR
 
     C                   DOU       *IN89 = *On or #0SEL <> *Blanks
     C                   READC     SCRPCNBS0                              89
     C                   ENDDO
 
      ** Activate SFLNXTCHG for the record to be read in SRRdSfl
 
     C                   IF        *IN89 = *Off
     C                   EVAL      *IN85 = *On
     C                   UPDATE    SCRPCNBS0
     C                   EVAL      *IN85 = *Off
     C                   WRITE     SCRPCNBC0
     C                   EVAL      OptSelected = 'Y'
     C                   ELSE
     C                   EVAL      OptSelected = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRClose - Close all files                                     *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
     C     SRClose       BEGSR
 
     C                   CLOSE     SCFDTLL1
     C                   CLOSE     SCFDTLL3
     C                   CLOSE     SCFDTLL4
     C                   CLOSE     SCFDTLL5
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit - Initialisation                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Clear Outputs
 
     C                   EVAL      PErrMsg = *Blanks
     C                   EVAL      POpSel = *Blanks
     C                   EVAL      PPhySel = *Blanks
     C                   EVAL      PINKC = '0'
     C                   EVAL      PINKL = '0'
     C                   EVAL      #0REPL  = *BLANKS
     C                   EVAL      #0PFILE = *BLANKS
     C                   EVAL      #0BATN = *BLANKS
     C                   EVAL      #0FREQ = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
 
     C                   PARM                    RetCodeIn
 
      ** Action Code
 
     C                   PARM                    PActCde
 
      ** Physical File
 
     C                   PARM                    PPhyFil
 
      ** Build Subfile
 
     C                   PARM                    PBldSfl
 
      ** Read Subfile record
 
     C                   PARM                    PRdSfl
 
      ** Output parameters
 
     C                   PARM                    PErrMsg
 
      ** Option Selected
 
     C                   PARM                    POpSel
 
      ** Physical File Selected
 
     C                   PARM                    PPhySel
 
      * Command Keys
 
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SCRPCNBRW'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRetCode
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #0USER = PSUSER
     C                   EVAL      #0DATE = BJMRDT
     C                   EVAL      #0WSID = PSJOBNAME
     C                   EVAL      #MsgFile = 'UTMSGF'
     C                   EVAL      #1PGMQ   = '*'
 
      ** Key Lists
      *
     C*    KFDTL3        KLIST
     C*                  KFLD                    KPFILE
     C*                  KFLD                    KREPFL
      *
     C*    KFDTL4        KLIST
     C*                  KFLD                    KPFILE
     C*                  KFLD                    KBATNO
      *
     C*    KFDTL5        KLIST
     C*                  KFLD                    KPFILE
     C*                  KFLD                    KFREQU
 
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
(c) Misys International Banking Systems Ltd. 2001
