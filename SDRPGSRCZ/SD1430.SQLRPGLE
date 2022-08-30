     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas SD Market Data Feed Mapping Code Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD1430 - MDF - Market Data Feed mapping code Maintenance     *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006  *CREATE    Date 27Sep00               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CSD006 - Midas Data Feeds                                    *
      *                                                               *
      ********************************************************************
      * INDICATORS
      * 03 - EXIT SCREEN
      * 09 - INSERT MODE
      * 10 - DELETE REQUESTED
      * 12 - CANCEL/PREVIOUS SCREEN
      * 50 - SCREEN ERR, MAPPING CODE
      * 51 - SCREEN ERR, MERIDIAN VIEW
      * 52 - SCREEN ERR, API TYPE
      * 53 - SCREEN ERR, DESCRIPTION
      * 70 - ENQUIRE/DELETE, ALL FIELDS PROTECTED
      * 71 - AMEND, MAPPING CODE FIELD PROTECTED
      * 72 - F10 DELETE ENABLED
      * 75 - SCAN EQUAL RESULT
      * 74 - TOGGLE MAINTENANCE/SELECTION MODE
      * 80 - SUBFILE CLEAR
      * 81 - SUBFILE DISPLAY, DISPLAY CONTROL AND END
      * 83 - NONDISPLAY SUBFILE DETAIL RECORD
      * 89 - CALL PROG ERRROR
      * 95 - CHAIN HI (NRF) INDICATOR
      * 96 - END OF FILE
      ********************************************************************
      *
      * FILE SPECS
      *
      ********************************************************************
      *
     FSD1430DF  CF   E             WORKSTN
     F                                     SFILE(#SBFLRCD:RRN)
     F                                     INFDS(INFDS#)
      * Display File
      *
      *
     F*SDMAPCL0* IF   E           K DISK                                                    MD058085
     F**********                           INFSR(*PSSR)                                     MD058085
      * SD Market Date Feed mapping codes: READ
      *
      *
     F*SDMAPCL1* UF A E           K DISK                                                    MD058085
     F**********                           COMMIT                                           MD058085
     F**********                           INFSR(*PSSR)                                     MD058085
     F**********                           RENAME(SDMAPCD0:SDMAPCD1)                        MD058085
      * SD Market Date Feed mapping codes: UPDATE
      *
      *
      ********************************************************************
      *
      * E SPECS
      *
      ********************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
      *
     D @FTR            S             79    DIM(5) CTDATA PERRCD(1)              FOOTER TEXT
      ** Array of Commitment Job Names                                                        CSC022
     D CMTJOB          S             10    DIM(10)
      *
      ********************************************************************
      *
      * I SPECS
      *
      ********************************************************************
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for Bank ICD record.
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Data structure for SAR detail record.                                                CSC022
      *                                                                                       CSC022
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Short Data Structure for Access Objects
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D DBERR         E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D ZMUSER          DS            17
     D  DBRN                  11     13
      * User / Branch data area
      *
     D RUNDT         E DS                  EXTNAME(RUNDAT)
     D*                                      13  13 AGMBIN
      * Rundate data area for multibranching indicator
      *
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
      *
     D*WKDBR1***     E DS                  EXTNAME(SDMAPCL0)                                MD058085
     D WKDBR1        E DS                  EXTNAME(SDMAPJW0)                                MD058085
     D                                     PREFIX(X)                                        MD058085
     D SDMAPC        E DS                  EXTNAME(SDMAPJW0)                                MD058085
      * Update by other user comparison DS
      *
     D*WKDBR2***       DS           103                                                     MD058085
     D WKDBR2          DS           104                                                     MD058085
      * Update by other user comparison DS
      *
     D WKAPIT          C                   CONST('SFBLPM')
      * Constant for validation of target API type
      *
     D SCCMT           DS           256
     D  CMTNUM                 1      3  0
     D  CMTARR                 4    103
      *
      *****************************************************************
      *                                                               *
      * MAIN   - MAIN PROCESSING                                      *
      *                                                               *
      * Calls: INIT                                                   *
      *        STUPSF                                                 *
      *        INSERT                                                 *
      *        PROCSF                                                 *
      *        EXIT                                                   *
      *                                                               *
      *****************************************************************
      *
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD            7
     C                   PARM      WKMODE        P@MODE            1
     C                   PARM      WKMAPC        P@MAPC           32
      *
     C                   MOVE      P@MODE        WKMODE            1
      *
      * Initialization
     C                   EXSR      INIT
      *
      * Main F3/F12 loop
      *
     C     *IN03         DOWNE     *ON
     C     *IN12         ANDNE     *ON
      *
      * Initialise, write and display subfile
      *
     C                   EXSR      STUPSF
      *
      * Insert processing
      *
     C                   EXSR      INSERT
      *
      * Process subfile screen
      *
     C                   EXSR      PROCSF
      *
      * End of Main F3/F12 loop
      *
     C                   ENDDO
      *
      * Exit routine
      *
     C                   EXSR      EXIT
      *
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * STUPSF - Set up screen subfile                                *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: SRSMSG                                                 *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     STUPSF        BEGSR
      *
      ** INITIALISE THE SUBFILE
      *
     C                   Z-ADD     0             RRN
     C                   Z-ADD     0             @SFREC
     C                   MOVE      *OFF          ENDFIL
      *
      ** Set screen header: Maintenance or Selection
     C     P@MODE        COMP      'M'                                    74
      *
      * Clear subfile before refilling by writing control record
      * with SFLCLR active
      *
     C                   MOVE      *ON           *IN80
     C                   WRITE     #SBFLCTL
     C                   MOVE      *OFF          *IN80
      *
      * Read a record
      *
     C******LOVAL        SETLL     SDMAPCD0                                                 MD058085
     C**********         READ      SDMAPCD0                               96                MD058085
     C/EXEC SQL                                                                             MD058085
     C+ declare ACursor insensitive scroll cursor for                                       MD058085
     C+ select * from SDMAPJW0                                                              MD058085
     C+ order by MCMAPC                                                                     MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ open ACursor                                                                        MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDMAPC                                                MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C                   setoff                                       96                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   seton                                        96                    MD058085
     C                   Endif                                                              MD058085
                                                                                            MD058085
     C                   MOVE      *IN96         ENDFIL
      *
      ** WRITE THE SUBFILE
      *
      * Initialise count
      *
     C                   Z-ADD     0             COUNT
      *
      * Write each record read to subfile until end of file
      *
     C     ENDFIL        DOWNE     *ON
      *
      * Increment counters and write to subfile
      *
     C                   ADD       1             RRN
     C                   ADD       1             COUNT
     C                   ADD       1             @SFREC
      *
     C                   MOVE      MCMAPC        DDMAPC
     C                   MOVE      MCVIEW        DDVIEW
     C                   MOVE      MCAPIT        DDAPIT
     C                   MOVE      MCDESC        DDDESC
      *
      * Once any error trapped, blank option fields
      *
     C                   MOVE      *BLANK        DDOPTN
     C     COUNT         IFEQ      @SFSAV
     C     ERROR         ANDEQ     *ON
     C                   MOVE      ERROPT        DDOPTN
     C                   ENDIF
      *
     C     COUNT         IFGT      @SFSAV
     C                   MOVE      *BLANK        DDOPTN
     C                   ENDIF
      *
     C                   WRITE     #SBFLRCD
      *
      * Read another record
      *
     C**********         READ      SDMAPCD0                               96                MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDMAPC                                                MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C                   setoff                                       96                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   seton                                        96                    MD058085
     C                   Endif                                                              MD058085
                                                                                            MD058085
     C                   MOVE      *IN96         ENDFIL
      *
     C                   ENDDO
      *
     C/EXEC SQL                                                                             MD058085
     C+ close ACursor                                                                       MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
      *
      ** DISPLAY THE SUBFILE
      *
      * Set up footer
     C                   MOVE      *BLANKS       FOOTR1
     C                   MOVE      *BLANKS       FOOTR2
     C     WKMODE        IFEQ      'M'
     C                   MOVE      @FTR(1)       FOOTR1
     C                   MOVE      @FTR(2)       FOOTR2
     C                   ELSE
     C                   MOVE      @FTR(5)       FOOTR1
     C                   MOVE      @FTR(3)       FOOTR2
     C                   ENDIF
     C                   WRITE     #FOOTER
      *
      * If count is zero, empty file, write sf record with message
      *
     C     COUNT         IFEQ      0
     C                   MOVE      *ON           *IN80
     C                   WRITE     #SBFLCTL
     C                   MOVE      *OFF          *IN80
     C                   Z-ADD     1             RRN
     C                   MOVE      *ON           *IN83
     C                   WRITE     #SBFLRCD
     C                   MOVE      *OFF          *IN83
     C                   MOVEL     'USR5571'     ZAMSID
     C                   EXSR      SRSMSG
     C                   WRITE     #MSGCTL
     C                   WRITE     #SBFLCTL
      *
      * Otherwise, write subfile record with data
      *
     C                   ELSE
     C                   WRITE     #MSGCTL
     C                   WRITE     #SBFLCTL
     C                   ENDIF
      *
      * Read screen for user selection, display from last record
      *
     C                   Z-ADD     @SFSAV        @SFREC
     C                   MOVE      *ON           *IN81
     C                   WRITE     #FOOTER
     C                   EXFMT     #SBFLCTL
     C                   MOVE      *OFF          *IN81
     C                   Z-ADD     1             @SFSAV
      *
      * Reset detail screen error indicators
      *
     C                   MOVE      *OFF          ERROR
     C                   MOVE      *BLANK        ERROPT
     C                   MOVEA     '0000'        *IN(50)
      *
      * Clear program message queue
      *
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INSERT - F9, Insert a record processing                       *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: DETAIL                                                 *
      *                                                               *
      *****************************************************************
     C     INSERT        BEGSR
      *
      * Insert processing
      *
     C     *IN09         IFEQ      *ON
      *
     C                   MOVE      'I'           DDOPTN
     C                   MOVE      'I'           SCREEN
     C                   MOVE      *BLANKS       DDMAPC
     C                   MOVE      *BLANKS       DDVIEW
     C                   MOVE      *BLANKS       DDAPIT
     C                   MOVE      *BLANKS       DDDESC
      *
     C                   EXSR      DETAIL
      *
     C                   ENDIF
      *
     C     ENDINS        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PROCSF - Read any user selections                             *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: DETAIL                                                 *
      *        SRSMSG                                                 *
      *                                                               *
      *****************************************************************
     C     PROCSF        BEGSR
      *
      * If previous or exit not selected
      *
     C     *IN03         IFEQ      *OFF
     C     *IN12         ANDEQ     *OFF
      *
      * Read next changed record
      *
     C                   READC     #SBFLRCD                               96
      *
      ** MAINTENANCE MODE
      *
     C     WKMODE        IFEQ      'M'
      *
      * For every changed record on the subfile
      *
     C     *IN96         DOWEQ     *OFF
     C     ERROR         ANDEQ     *OFF
     C     *IN05         ANDEQ     *OFF
      *
      * Store subfile position for rebuild
      *
     C     DDOPTN        IFNE      *BLANKS
     C                   Z-ADD     RRN           @SFSAV            4 0
     C                   ENDIF
      *
      * If entry is A, D or E, do detail screen processing
      *
     C     DDOPTN        IFEQ      'A'
     C     DDOPTN        OREQ      'D'
     C     DDOPTN        OREQ      'E'
      *
     C*****DDMAPC        CHAIN     SDMAPCL0                           95                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDMAPC                                                                        MD058085
     C+ from SDMAPJW0                                                                       MD058085
     C+ where MCMAPC = :DDMAPC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       95                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        95                    MD058085
     C                   ENDIF                                                              MD058085
      *
     C     *IN95         IFEQ      *OFF
     C                   MOVE      MCVIEW        DDVIEW
     C                   MOVE      MCAPIT        DDAPIT
     C                   MOVE      DDOPTN        SCREEN
     C                   ENDIF
      *
     C                   EXSR      DETAIL
      *
      * Otherwise, if option entered must be invalid
      *
     C                   ELSE
      *
     C     DDOPTN        IFNE      *BLANKS
     C                   MOVEL     'USR5572'     ZAMSID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           ERROR
     C                   MOVE      DDOPTN        ERROPT
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Read next changed record
      *
     C                   READC     #SBFLRCD                               96
      *
      * End of READC loop
     C                   ENDDO
      *
      * Adjust redisplay subfile position by number of deletions
      *
     C                   SUB       WKDELC        @SFSAV
     C     @SFSAV        IFLT      1
     C                   Z-ADD     1             @SFSAV
     C                   ENDIF
     C                   Z-ADD     0             WKDELC
      *
      *
      ** SELECTION MODE
     C                   ELSE
      *
      * Read subfile
      *
     C     *IN96         DOWEQ     *OFF
     C     ERROR         ANDEQ     *OFF
     C     *IN05         ANDEQ     *OFF
      *
      * Store subfile position for rebuild
      *
     C     DDOPTN        IFNE      *BLANKS
     C                   Z-ADD     RRN           @SFSAV            4 0
     C                   ENDIF
      *
      * If entry is 1, return selected data to calling program
      *
     C     DDOPTN        IFEQ      '1'
     C                   MOVE      DDMAPC        WKMAPC
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      * Otherwise, if option entered must be invalid
      *
     C                   ELSE
      *
     C     DDOPTN        IFNE      *BLANKS
     C                   MOVEL     'USR5574'     ZAMSID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           ERROR
     C                   MOVE      DDOPTN        ERROPT
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Read next record
      *
     C                   READC     #SBFLRCD                               96
      *
      * End of READC loop
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      * Store error user entry for redisplay
      *
     C     ERROR         IFEQ      *OFF
     C                   MOVE      *BLANKS       DDOPTN
     C                   ENDIF
      *
     C     ENDRSF        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DETAIL - Option Selected Processing                           *
      *                                                               *
      * Called by: INSERT                                             *
      *            PROCSF                                             *
      *                                                               *
      * Calls: SCINDE                                                 *
      *        VALDSR                                                 *
      *        UPDATE                                                 *
      *                                                               *
      *****************************************************************
     C     DETAIL        BEGSR
      *
      * Initialise screen conditions
      *
     C                   EXSR      SCINDE
      *
      * Display screen while no user F3/F12 or redisplay required
      *
     C                   MOVE      *ON           WKRDSP
      *
     C     *IN03         DOWEQ     *OFF
     C     *IN12         ANDEQ     *OFF
     C     WKRDSP        ANDEQ     *ON
      *
      * Set up footer
     C                   MOVE      *BLANKS       FOOTR1
     C     SCREEN        IFNE      'D'
     C                   MOVE      @FTR(3)       FOOTR2
     C                   ELSE
     C                   MOVE      @FTR(4)       FOOTR2
     C                   ENDIF
     C                   WRITE     #FOOTER
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     #DETAIL
     C                   WRITE     #FOOTER
     C                   EXFMT     #DETAIL
      *
      * Reset screen error indicators
      *
     C                   MOVE      *OFF          ERROR
     C                   MOVEA     '0000'        *IN(50)
      *
     C     SCREEN        IFEQ      'I'
     C     SCREEN        OREQ      'A'
     C     SCREEN        OREQ      'D'
     C                   EXSR      VALDSR
     C     ERROR         IFEQ      *OFF
     C                   EXSR      UPDATE
     C                   ENDIF
     C                   ENDIF
      *
      * For Enquire, return direct to select screen
      *
     C     SCREEN        IFEQ      'E'
     C                   MOVE      *OFF          WKRDSP
     C                   ENDIF
      *
      * Limit of F3/F12/redisplay loop
      *
     C                   ENDDO
      *
      * Clear program message queue
      *
     C                   CALL      'ZA0250'
      *
      * If F12 entered, stay within calling loop
      *
     C     *IN12         IFEQ      *ON
     C                   MOVE      *OFF          *IN12
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SCINDE - Set Up Screen Conditions, Detail Screen              *
      *                                                               *
      * Called by: DETAIL                                             *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SCINDE        BEGSR
      *
      * Initialise screen condition indicators
      *
     C                   MOVEA     '000'         *IN(70)
     C                   MOVE      *OFF          ERROR
      *
      * Store image of selected record
      *
     C     SCREEN        IFEQ      'A'
     C     SCREEN        OREQ      'D'
     C*****DDMAPC        CHAIN     SDMAPCL0                           95                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDMAPC                                                                        MD058085
     C+ from SDMAPJW0                                                                       MD058085
     C+ where MCMAPC = :DDMAPC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       95                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        95                    MD058085
     C                   ENDIF                                                              MD058085
     C     *IN95         IFEQ      *ON                                          ***************
     C                   MOVEL     'SDMAPCL0'    DBFILE                         *             *
     C                   MOVEL     '001'         DBASE                          * DBERROR 001 *
     C                   MOVEL     DDMAPC        DBKEY                          *             *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   eval      WKDBR1 = SDMAPC                                          MD058085
     C                   MOVE      WKDBR1        WKDBR2
     C                   ENDIF
      *
      * Conditioning of input capable fields
      *
      * Enquire, Delete: All fields are protected
      *
     C     SCREEN        IFEQ      'E'
     C     SCREEN        OREQ      'D'
     C                   MOVE      *ON           *IN70
     C                   ENDIF
      *
      * Amend: Source Code field is protected
      *
     C     SCREEN        IFEQ      'A'
     C                   MOVE      *ON           *IN71
     C                   ENDIF
      *
      * Delete: Function key (F10) enabled
      *
     C     SCREEN        IFEQ      'D'
     C                   MOVE      *ON           *IN72
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * EXIT - Exit routine                                           *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: NONE                                                   *
      *                                                               *
      *****************************************************************
     C     EXIT          BEGSR
      *
      * Return
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALDSR - Validation                                           *
      *                                                               *
      * Called by: DETAIL                                             *
      *                                                               *
      * Calls: SRSMSG                                                 *
      *                                                               *
      *****************************************************************
     C     VALDSR        BEGSR
      *
      * Reset error indicators and clear program message queue
      *
     C                   MOVE      *OFF          ERROR
     C                   MOVEA     '0000'        *IN(50)
     C                   CALL      'ZA0250'
      *
     C*****DDMAPC        CHAIN     SDMAPCL0                           95                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDMAPC                                                                        MD058085
     C+ from SDMAPJW0                                                                       MD058085
     C+ where MCMAPC = :DDMAPC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       95                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        95                    MD058085
     C                   ENDIF                                                              MD058085
      *
     C                   SELECT
      *
      * When Insert, Data Source Code must not already exist on file
     C     SCREEN        WHENEQ    'I'
     C     *IN95         ANDEQ     '0'
     C                   MOVE      *ON           ERROR
     C                   MOVE      *ON           *IN50
     C                   MOVEL     'USR5573'     ZAMSID
     C                   EXSR      SRSMSG
      *
      * General Insert and Amend validation
     C     SCREEN        WHENEQ    'I'
     C     SCREEN        OREQ      'A'
      *
      * Market Data Feed mapping code may not be blank
     C     DDMAPC        IFEQ      *BLANKS
     C                   MOVE      *ON           ERROR
     C                   MOVE      *ON           *IN50
     C                   MOVEL     'USR5583'     ZAMSID
     C                   EXSR      SRSMSG
     C                   ELSE
      *
      * Market Data Feed mapping code may not have leading blanks
     C                   MOVEL     DDMAPC        WKDTS1            1
     C     WKDTS1        IFEQ      *BLANK
     C                   MOVE      *ON           ERROR
     C                   MOVE      *ON           *IN50
     C                   MOVEL     'USR5584'     ZAMSID
     C                   EXSR      SRSMSG
     C                   ENDIF
     C                   ENDIF
      *
      *
      * Meridian view name may not be blank
     C     DDVIEW        IFEQ      *BLANKS
     C                   MOVE      *ON           ERROR
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'USR5585'     ZAMSID
     C                   EXSR      SRSMSG
     C                   ELSE
      *
      * Meridian view name may not have leading blanks
     C                   MOVEL     DDVIEW        WKDTS1            1
     C     WKDTS1        IFEQ      *BLANK
     C                   MOVE      *ON           ERROR
     C                   MOVE      *ON           *IN51
     C                   MOVEL     'USR5586'     ZAMSID
     C                   EXSR      SRSMSG
     C                   ENDIF
     C                   ENDIF
      *
      *
      * Target API type must be one of S F B L P M
     C     DDAPIT        SCAN      WKAPIT                                 75
     C     *IN75         IFEQ      *OFF
     C                   MOVE      *ON           ERROR
     C                   MOVE      *ON           *IN52
     C                   MOVEL     'USR5587'     ZAMSID
     C                   EXSR      SRSMSG
     C                   ENDIF
      *
      *
      * Description may not be blank
     C     DDDESC        IFEQ      *BLANKS
     C                   MOVE      *ON           ERROR
     C                   MOVE      *ON           *IN53
     C                   MOVEL     'USR5580'     ZAMSID
     C                   EXSR      SRSMSG
     C                   ENDIF
      *
      * Send message to request confirmation of delete
     C     SCREEN        WHENEQ    'D'
     C     *IN10         ANDEQ     *OFF
     C                   MOVE      *ON           ERROR
     C                   MOVEL     'USR5577'     ZAMSID
     C                   EXSR      SRSMSG
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATE - Update File                                          *
      *                                                               *
      * Called by: DETAIL                                             *
      *                                                               *
      * Calls: SRSMSG                                                 *
      *        *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     UPDATE        BEGSR
      *
      * Amend/Delete function unavailable, record changed by other user
      *
     C     SCREEN        IFEQ      'A'
     C     SCREEN        OREQ      'D'
     C*****DDMAPC        CHAIN     SDMAPCL0                           95                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDMAPC                                                                        MD058085
     C+ from SDMAPJW0                                                                       MD058085
     C+ where MCMAPC = :DDMAPC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       95                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        95                    MD058085
     C                   ENDIF                                                              MD058085
     C                   eval      WKDBR1 = SDMAPC                                          MD058085
     C     WKDBR1        IFNE      WKDBR2
     C     *IN95         OREQ      *ON
     C                   MOVE      *ON           ERROR
     C                   MOVEL     'USR5578'     ZAMSID
     C                   EXSR      SRSMSG
     C                   ENDIF
     C                   ENDIF
      *
      * Insert function unavailable, already added by other user
     C     SCREEN        IFEQ      'I'
     C*****DDMAPC        CHAIN     SDMAPCL0                           95                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDMAPC                                                                        MD058085
     C+ from SDMAPJW0                                                                       MD058085
     C+ where MCMAPC = :DDMAPC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       95                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        95                    MD058085
     C                   ENDIF                                                              MD058085
     C                   eval      WKDBR1 = SDMAPC                                          MD058085
     C     *IN95         IFEQ      *OFF
     C                   MOVE      *ON           ERROR
     C                   MOVEL     'USR5579'     ZAMSID
     C                   EXSR      SRSMSG
     C                   ENDIF
     C                   ENDIF
      *
      *
     C     ERROR         IFEQ      *OFF
      *
      * Insert
     C     SCREEN        IFEQ      'I'
     C                   MOVE      'D'           MCRECI
     C                   MOVE      DDMAPC        MCMAPC
     C                   MOVE      DDVIEW        MCVIEW
     C                   MOVE      DDAPIT        MCAPIT
     C                   MOVE      DDDESC        MCDESC
     C                   Z-ADD     BJRDNB        MCLCD
     C                   MOVE      'I'           MCTYLC
     C                   Z-ADD     1             MCTNLU
     C**********         WRITE     SDMAPCD1                                                 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ insert into SDMAPBTD                                                                MD058085
     C+ (                                                                                   MD058085
     C+   MCRECI                                                                            MD058085
     C+  ,MCMAPC                                                                            MD058085
     C+  ,MCVIEW                                                                            MD058085
     C+  ,MCAPIT                                                                            MD058085
     C+  ,MCDESC                                                                            MD058085
     C+  ,MCLCD                                                                             MD058085
     C+  ,MCTYLC                                                                            MD058085
     C+  ,MCTNLU                                                                            MD058085
     C+  ,MCMODE                                                                            MD058085
     C+ )                                                                                   MD058085
     C+ Values                                                                              MD058085
     C+ (                                                                                   MD058085
     C+   :MCRECI                                                                           MD058085
     C+  ,:MCMAPC                                                                           MD058085
     C+  ,:MCVIEW                                                                           MD058085
     C+  ,:MCAPIT                                                                           MD058085
     C+  ,:MCDESC                                                                           MD058085
     C+  ,:MCLCD                                                                            MD058085
     C+  ,:MCTYLC                                                                           MD058085
     C+  ,:MCTNLU                                                                           MD058085
     C+  ,'B'                                                                               MD058085
     C+ )                                                                                   MD058085
     C/END-EXEC                                                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ insert into SDMAPXTD                                                                MD058085
     C+ (                                                                                   MD058085
     C+   MCRECI                                                                            MD058085
     C+  ,MCMAPC                                                                            MD058085
     C+  ,MCVIEW                                                                            MD058085
     C+  ,MCAPIT                                                                            MD058085
     C+  ,MCDESC                                                                            MD058085
     C+  ,MCLCD                                                                             MD058085
     C+  ,MCTYLC                                                                            MD058085
     C+  ,MCTNLU                                                                            MD058085
     C+  ,MCMODE                                                                            MD058085
     C+ )                                                                                   MD058085
     C+ Values                                                                              MD058085
     C+ (                                                                                   MD058085
     C+   :MCRECI                                                                           MD058085
     C+  ,:MCMAPC                                                                           MD058085
     C+  ,:MCVIEW                                                                           MD058085
     C+  ,:MCAPIT                                                                           MD058085
     C+  ,:MCDESC                                                                           MD058085
     C+  ,:MCLCD                                                                            MD058085
     C+  ,:MCTYLC                                                                           MD058085
     C+  ,:MCTNLU                                                                           MD058085
     C+  ,'B'                                                                               MD058085
     C+ )                                                                                   MD058085
     C/END-EXEC                                                                             MD058085
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     CMTSKP        ANDEQ     'N'
     C                   COMMIT
     C                   ENDIF
     C                   ENDIF
      *
      * Amend
     C     SCREEN        IFEQ      'A'
     C*****DDMAPC        CHAIN     SDMAPCL1                           95                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDMAPC                                                                        MD058085
     C+ from SDMAPJW0                                                                       MD058085
     C+ where MCMAPC = :DDMAPC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       95                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        95                    MD058085
     C                   ENDIF                                                              MD058085
     C     *IN95         IFEQ      *ON                                          ***************
     C                   MOVEL     'SDMAPCL0'    DBFILE                         *             *
     C                   MOVEL     '003'         DBASE                          * DBERROR 003 *
     C                   MOVEL     DDMAPC        DBKEY                          *             *
     C                   EXSR      *PSSR                                        ***************
     C                   ELSE
     C                   MOVE      'D'           MCRECI
     C                   MOVE      DDMAPC        MCMAPC
     C                   MOVE      DDVIEW        MCVIEW
     C                   MOVE      DDAPIT        MCAPIT
     C                   MOVE      DDDESC        MCDESC
     C                   Z-ADD     BJRDNB        MCLCD
     C                   MOVE      'A'           MCTYLC
     C                   ADD       1             MCTNLU
     C**********         UPDATE    SDMAPCD1                                                 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ update SDMAPXTD set                                                                 MD058085
     C+   MCRECI = :MCRECI                                                                  MD058085
     C+  ,MCVIEW = :MCVIEW                                                                  MD058085
     C+  ,MCAPIT = :MCAPIT                                                                  MD058085
     C+  ,MCDESC = :MCDESC                                                                  MD058085
     C+  ,MCLCD  = :MCLCD                                                                   MD058085
     C+  ,MCTYLC = :MCTYLC                                                                  MD058085
     C+  ,MCTNLU = :MCTNLU                                                                  MD058085
     C+ where MCMAPC = :DDMAPC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     CMTSKP        ANDEQ     'N'
     C                   COMMIT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Delete
      *
     C     SCREEN        IFEQ      'D'
     C*****DDMAPC        CHAIN     SDMAPCL1                           95                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDMAPC                                                                        MD058085
     C+ from SDMAPJW0                                                                       MD058085
     C+ where MCMAPC = :DDMAPC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       95                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        95                    MD058085
     C                   ENDIF                                                              MD058085
     C     *IN95         IFEQ      *ON                                          ***************
     C                   MOVEL     'SDMAPCL1'    DBFILE                         *             *
     C                   MOVEL     '004'         DBASE                          * DBERROR 004 *
     C                   MOVEL     DDMAPC        DBKEY                          *             *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C**********         DELETE    SDMAPCL1                                                 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ delete from SDMAPCTD                                                                MD058085
     C+ where MCMAPC = :DDMAPC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ delete from SDMAPBTD                                                                MD058085
     C+ where MCMAPC = :DDMAPC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ delete from SDMAPXTD                                                                MD058085
     C+ where MCMAPC = :DDMAPC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     CMTSKP        ANDEQ     'N'
     C                   COMMIT
     C                   ENDIF
      *
      * Store deletion count to adjust subfile redisplay position
     C                   ADD       1             WKDELC            3 0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * For Amend/Delete if updates OK, return to initial screen
      *
     C     SCREEN        IFEQ      'A'
     C     SCREEN        OREQ      'D'
     C     ERROR         IFEQ      *OFF
     C                   MOVE      *OFF          WKRDSP
     C                   ENDIF
     C                   ENDIF
      *
      * For Insert, if updates OK, clear screen fields for new data
      *
     C     SCREEN        IFEQ      'I'
     C     ERROR         IFEQ      *OFF
     C                   MOVE      *BLANK        DDMAPC
     C                   MOVE      *BLANK        DDVIEW
     C                   MOVE      *BLANK        DDAPIT
     C                   MOVE      *BLANK        DDDESC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSMSG - Routine to send messages to message subfile.        *
      *                                                               *
      * Called by: (MANY)                                             *
      *                                                               *
      * Calls: NONE                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRSMSG        BEGSR
      *
      ** Send specified message from specified message file to program
      ** message queue; then clear message id and message file
      *
     C                   CALL      'ZA0350'
     C                   PARM      'SDUSRMSG'    ZAMSGF           10
     C                   PARM                    ZAMSID           10
     C                   PARM                    ZAMDTA           45
      *
     C                   CLEAR                   ZAMSID
     C                   CLEAR                   ZAMDTA
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INIT   - Program initialisation routine                       *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Check if CSD006 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSD006'      @SARD             6
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         IFNE      '*NRF '
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'SCSARDPD'    DBFILE                         *DB ERROR 001 *
     C                   MOVEL     'CSD006'      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      '*ERROR'      P@RTCD
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if CSC022 is switched ON.                                                      CSC022
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC022'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSC022
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022            1
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT
     C                   IN        SCCMT
     C                   Z-ADD     1             C                 3 0
     C                   MOVEL     'N'           CMTSKP            1
     C                   MOVEA     CMTARR        CMTJOB
     C     CMTNUM        IFGT      0
     C     C             DOWLE     CMTNUM
     C     ##JOB         IFEQ      CMTJOB(C)
     C                   MOVEL     'Y'           CMTSKP
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CSC022
     C     @RTCD         IFNE      '*NRF '
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CSC022'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Initialize subfile control fields
      *
     C                   Z-ADD     0             RRN               4 0
     C                   Z-ADD     0             RRNB              4 0
     C                   Z-ADD     0             @SFREC
     C                   Z-ADD     1             @SFSAV
     C                   Z-ADD     0             COUNT             3 0
     C                   MOVE      *OFF          ENDFIL            1
      *
      ** Initialize screen mode indicator
      *
     C                   MOVE      *BLANKS       SCREEN            1
      *
      ** Initialize error indicators
      *
     C                   MOVE      *OFF          ERROR             1
     C                   MOVE      *OFF          ERROPT            1
     C                   MOVE      *OFF          ERRSEL            1
      *
      ** Initialize detail screen redisplay indicator
      *
     C                   MOVE      *OFF          WKRDSP            1
      *
      ** Initialize work fields
     C     *LIKE         DEFINE    MCMAPC        WKMAPC
     C                   MOVE      *BLANK        WKMAPC
      *
      * Initialise LDA field.
      *
     C                   MOVEL     'SD1430'      DBPGM
      *
      * Get branch
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      * Get multibranch indicator
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT
      *
      * Set up copyright parameter
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      * Access Bank ICD for the date format.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM                    RTNCDE            7
     C                   PARM      '*FIRST'      OPTN              7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error in file SDBANKPD.
      *
     C     RTNCDE        IFNE      *BLANK                                       ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *             *
     C                   Z-ADD     2             DBASE                          * DBERROR 002 *
     C                   MOVE      *BLANKS       DBKEY                          *             *
     C                   MOVEL     'BANK'        DBKEY                          *             *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      * Convert rundate to DDMMMYY format for header output.
      *
     C                   CALL      'ZDATE2'                             89      Check File Date
     C                   PARM                    BJRDNB            5 0          Work Midas Date
     C                   PARM                    BJDFIN                         Date format fla
     C                   PARM      *ZERO         WUWCDT            6 0          Work Converted
     C                   PARM      *BLANK        DDMRDT            7            Work Alpha Date
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: INIT                                               *
      *            UPDATE                                             *
      *            EXIT                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
      *
     C     *DTAARA       DEFINE                  LDA             256
     C     *LOCK         IN        LDA
     C                   MOVEL     DBERR         LDA
     C                   OUT       LDA
      *
     C                   DUMP
     C                   SETON                                        U7U8LR
      *
     C                   CALL      'DBERRCTL'
      *
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     CMTSKP        ANDEQ     'N'
     C                   ROLBK
     C                   ENDIF
      *
     C                   END
      *
      * If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  @FTR
A=Amend D=Delete E=Enquire
F3=Exit F5=Refresh F9=Insert F12=Previous
F3=Exit F12=Previous
F3=Exit F10=Confirm F12=Previous
1=Select
