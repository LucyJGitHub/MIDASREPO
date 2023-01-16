     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas ME SWIFT ISO country codes report')              *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1741 - SWIFT ISO Country Codes Report                      *
      *                                                               *
      *  Function:  This program will list details of each of the     *
      *  (I/C)      ISO Country Codes that have been defined to the   *
      *             system at the time of request.                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD022777           Date 17Oct13               *
      *                 MD022111A          Date 04Sep13               *
      *                 CSW213             Date 03Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSW207             Date 07Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CFT017             Date 12Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022777 - Field "IBAN Required in MT103+" should not be     *
      *             dependent on CFT050.
      *  MD022111A - MEC1741 seq 10001 failed in Day 2 COB in I2      *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CSW207 - SWIFT 2007 Standard Changes                         *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CFT017 - Multilateral Inter-bank Exchange Fee.               *
      *  CFT014 - Straight-through Processing Phase 2 MT103 Messages  *
      *           Generation for FT.                                  *
      *                                                               *
      *****************************************************************
     F*MEISOCL1* IF   E           K DISK                                                    MD058081
     FME1741AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
     FME1741P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
     F                                     RENAME(ME1741F1:ME1741R1)
     F                                     RENAME(ME1741F2:ME1741R2)
     F                                     RENAME(ME1741F3:ME1741R3)
     F                                     RENAME(ME1741F4:ME1741R4)
     F                                     RENAME(ME1741F5:ME1741R5)
     FMEBICCL1  IF   E           K DISK
     F                                     INFSR(*PSSR)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *   60  - Read Indicator for MEISOCL1                           *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *   41  - For CFT050 and CSW213 feature                         *                       CSW213
      *       - Write new fields introduced by CSW213 in ME1741P1     *                       CSW213
      *   42  - For CFT004 feature                                    *                       CSW213
      *       - Write new fields introduced by CSW213 in ME1741P1     *                       CSW213
      *   43  - For CFT008 feature                                    *                       CSW213
      *       - Write new fields introduced by CSW213 in ME1741P1     *                       CSW213
      *   44  - SWIFTREF Country Code Indication                      *                       CSW213
      *   90  - Read indicator for MEBICCL1                           *                       CSW213
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Program Initialisation                              *
      *  SRPROC - Details Processing                                  *
      *  SRREPT - Process Report Lines                                *
      *                                                               *
      *  SP1REC - Format and Write a Detail Record to the Report      *
      *  SP2REC - Format and Write the Second Detail Record to the    *                       CSW213
      *           Report                                              *                       CSW213
      *  SP3REC - Format and Write the Third Detail Record to the     *                       CSW213
      *           Report                                              *                       CSW213
      *  SP1END - Write End of Report                                 *
      *                                                               *
      *  SRAUDT - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *  SRCFP1 - RCF Processing for P1 Report                        *
      *  SRCFAU - RCF Processing for Audit Report                     *
      *                                                               *
      *****************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Rundate
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D SPOOL1          DS
      *
      ** File Information Data Structure for M17019P1.
      *
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
      *
      ** File Information Data Structure for ME1711AU.
      *
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** SAR Details Accessed via access program                                              CFT017
      *                                                                                       CFT017
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      **  First DS for access programs, short data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External data structures for Bank Details
      *
     D MEISOC        E DS                  EXTNAME(MEISOJW0)                                MD058081
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ***  Perform Initialisation.
      *
     C                   EXSR      SRINIT
      *
      ***  Perform Detail Processing.
      *
     C                   EXSR      SRPROC
      *
      ***  Output Audit Report and End Program.
      *
     C                   EXSR      SRAUDT
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *  SRCFAU - RCF Processing for Audit Report                     *
      *  AOBANKR0 Access Program                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
     C                   MOVE      USER          RUSER
      *
      ** Receive Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ              5
      *
      ** Initialise LDA field.
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'ME1741'      DBPGM
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA
      *
      ***  Call Access Program for Bank Details - Title, Run Date and
      ***  Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Handle Database Error.
      *
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      **                           MMDDYY (*IN98 on).
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *                                                                                       CFT017
      ** Call access object to find out if switchable feature CFT017 is installed             CFT017
      *                                                                                       CFT017
     C                   MOVEL     'N'           CFT017            1
     C                   MOVEL     *OFF          *IN38
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CFT017'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CFT017
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CFT017'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CFT017
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CFT017
     C                   MOVE      *ON           *IN38
     C                   ENDIF
      *                                                                                       CFT017
     C                   ENDIF
      *                                                                                       CSW207
      ** If SWIF2007 changes is installed                                                     CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'
     C                   PARM      *BLANKS       @RTCD
      *                                                                                       CSW207
     C     @RTCD         IFEQ      'CSW2007'
     C                   MOVE      'Y'           CSW207            1
     C                   MOVE      *ON           *IN39
     C                   ELSE
     C                   MOVE      'N'           CSW207
     C                   MOVE      *OFF          *IN39
     C                   ENDIF
      *                                                                                       CSW209
      ** Check if SWIFT Changes 2009 (CSW209) is installed                                    CSW209
      *                                                                                       CSW209
     C                   CALL      'SWIF2009'
     C                   PARM      *BLANKS       @RTCD
      *                                                                                       CSW209
     C     @RTCD         IFEQ      'CSW2009'
     C                   MOVE      'Y'           CSW209            1
     C                   MOVEL     *ON           *IN40
     C                   ELSE
     C                   MOVE      'N'           CSW209
     C                   MOVEL     *OFF          *IN40
     C                   ENDIF
      *                                                                                       CSW213
      ** Call access object to find out if switchable feature CFT004 is installed             CSW213
      *                                                                                       CSW213
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSW213
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CFT004'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CSW213
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CFT004            1
     C                   MOVE      *ON           *IN42
     C                   ELSE
     C                   MOVEL     'N'           CFT004
     C                   MOVE      *OFF          *IN42
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Call access object to find out if switchable feature CFT050 is installed             CSW213
      *                                                                                       CSW213
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT050'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSW213
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CFT050'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CSW213
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CFT050            1
     C                   ELSE
     C                   MOVEL     'N'           CFT050
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Call access object to find out if switchable feature CFT008 is installed             CSW213
      *                                                                                       CSW213
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSW213
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CFT008'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CSW213
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CFT008            1
     C                   MOVE      *ON           *IN43
     C                   ELSE
     C                   MOVEL     'N'           CFT008
     C                   MOVE      *OFF          *IN43
     C                   ENDIF
      *                                                                                       CSW213
     C                   ENDIF
      *                                                                                       CSW213
      ** Check if SWIFT Changes 2013 (CSW213) is installed                                    CSW213
      *                                                                                       CSW213
     C                   CALL      'SWIF2013'
     C                   PARM      *BLANKS       @RTCD
      *                                                                                       CSW213
     C     @RTCD         IFEQ      'CSW2013'
     C                   MOVE      'Y'           CSW213            1
     C                   MOVE      *ON           *IN45
     C                   ELSE
     C                   MOVE      'N'           CSW213
     C                   ENDIF
      *                                                                                       CSW213
     C     CSW213        IFEQ      'Y'
     C     CFT050        OREQ      'Y'
     C                   MOVE      *ON           *IN41
     C                   ENDIF
      *                                                                                       CSW213
     C     *LOVAL        SETLL     MEBICCL1
     C                   READ      MEBICCL1                               90
     C     *IN90         IFEQ      *ON
     C                   MOVEL     'Y'           BEMPTY            1
     C                   ENDIF
      *
      ** Access RUNDAT for multibranching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     AGMBIN        IFEQ      'M'
     C                   MOVE      *ON           *IN37
     C                   END
      *
      ** RCF Processing for Audit File.
      *
     C                   EXSR      SRCFAU
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
      ** Register GL3300P1 to RCF
      *
     C                   CLOSE     ME1741P1
     C                   OPEN      ME1741P1
     C                   EXSR      SRCFP1
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRPROC
      *****************************************************************
      *                                                               *
      *  SRPROC - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *  SRAUDT - Produce Audit Report and End Program                *
      *  SRREPT - Process Report Lines                                *
      *  SRBRCH - Process Branch Details                              *
      *  SRCFP1 - RCF Processing for P1 Report/s                      *
      *  SP1END - Write End of Report                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
     C******LOVAL        SETLL     MEISOCL1                                                 MD058081
      *
      ** Read Bilateral Agreements Type Logical File
      *
     C**********         READ      MEISOCL1                               60                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ declare ACursor insensitive scroll cursor for                                       MD058081
     C+ select * from MEISOJW0                                                              MD058081
     C+ order by M3ISOC                                                                     MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ open ACursor                                                                        MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEISOC                                                MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
      *
      ** If end of records, generate audit reporting to report
      ** no records found.
      *
     C******IN60         IFEQ      *ON                                                      MD058081
     C     SQLCODE       IFEQ      100                                                      MD058081
     C                   EXSR      SRAUDT
     C                   ELSE
      *
     C******IN60         DOWEQ     *OFF                                                     MD058081
     C     SQLCODE       DOWEQ     0                                                        MD058081
      *
      ** RCF Processing for Printer File.
      *
     C                   ADD       1             RCOUNT            5 0
      *
      ** Process Report Lines.
      *
     C                   EXSR      SRREPT
      *
      ** Read next record.
      *
     C**********         READ      MEISOCL1                               60                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEISOC                                                MD058081
     C/END-EXEC                                                                             MD058081
      *
      ** End of Do While not End of File.
      *
     C                   ENDDO
      *
     C/EXEC SQL                                                                             MD058081
     C+ close ACursor                                                                       MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C                   ENDIF
      *
      ** Write final records and Totals to Report.
      *
     C                   EXSR      SP1END
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRREPT
      *****************************************************************
      *                                                               *
      *  SRREPT - Process Report Lines.                               *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls    :                                                   *
      *  SP1REC - Format and Write a Detail Record to the Report      *
      *                                                               *
      *****************************************************************
      *
     C     SRREPT        BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     ME1741R1
     C                   ENDIF
      *
     C                   EXSR      SP1REC
      *
     C                   Z-ADD     2             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     ME1741R1
     C                   ENDIF
      *                                                                                       CSW213
     C     *IN41         IFEQ      *ON
     C     *IN42         ANDEQ     *ON
     C                   EXSR      SP2REC
     C                   ENDIF
      *                                                                                       CSW213
     C                   Z-ADD     10            RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     ME1741R1
     C                   ENDIF
      *                                                                                       CSW213
     C     *IN41         IFEQ      *ON
     C     *IN42         ANDEQ     *ON
     C     M3IBAC        ANDNE     *BLANKS
     C                   EXSR      SP3REC
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SP1REC
      *****************************************************************
      *                                                               *
      *  SP1REC - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SP1REC        BEGSR
      *
      ** SWIFT ISO Country Code
      *
     C                   MOVE      M3ISOC        RM3SOC
      *
      ** SWIFT ISO Country Code Description
      *
     C                   MOVE      M3ISOD        RM3SOD
      *
      ** Supports Charge Transparency
      *
     C                   MOVE      M3SCHT        RM3SCH
      *                                                                                       CFT017
      ** EEA Member                                                                           CFT017
      *                                                                                       CFT017
     C     CFT017        IFEQ      'Y'
     C                   MOVE      M3EEAM        RM3EEA
     C                   ENDIF
      *                                                                                       CFT032
     C**********           MOVE M3FATF    RM3FAF                                       CFT032 CSW213
      *
     C     CSW207        IFEQ      'Y'
     C                   MOVE      M3MFID        RM3FID
     C                   MOVE      M3FATF        RM3FAF
     C                   ENDIF
      *                                                                                       CSW207
      ** Support MT205                                                                        CSW209
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     M3M205        RM3205
     C                   ENDIF
      *                                                                                       CSW209
      ** IBAN Country Code                                                                    CSW213
      *                                                                                       CSW213
     C     *IN41         IFEQ      *ON
     C     *IN42         ANDEQ     *ON
     C                   MOVE      M3IBAC        RM3IBC
     C                   ENDIF
      ** Support SEPA                                                                         CSW213
     C     *IN41         IFEQ      *ON
     C                   MOVE      M3SEPA        RM3SEP
     C                   ENDIF
      *                                                                                       CSW213
      ** Write out Detail Record.
      *
     C                   WRITE     ME1741R2
      *
     C                   ENDSR
      *                                                                                       CSW213
      *****************************************************************                       CSW213
      /TITLE SR/SP2REC                                                                        CSW213
      *****************************************************************                       CSW213
      *                                                               *                       CSW213
      *  SP2REC - Subroutine to Write second Detail record to the     *                       CSW213
      *           Report.                                             *                       CSW213
      *  Called By: SRPROC                                            *                       CSW213
      *  Calls    : None                                              *                       CSW213
      *                                                               *                       CSW213
      *****************************************************************                       CSW213
      *                                                                                       CSW213
     C     SP2REC        BEGSR
      *                                                                                       CSW213
     C                   MOVE      M3IBAR        RM3IBR
      *                                                                                    MD022111A
     C                   Z-ADD     3             RQDLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     ME1741R1
     C                   ENDIF
      *                                                                                    MD022111A
     C                   WRITE     ME1741R4
      *                                                                                       CSW213
     C                   ENDSR
      *                                                                                       CSW213
      *****************************************************************                       CSW213
      /TITLE SR/SP3REC                                                                        CSW213
      *****************************************************************                       CSW213
      *                                                               *                       CSW213
      *  SP3REC - Subroutine to Write third Detail record to the      *                       CSW213
      *           Report.                                             *                       CSW213
      *  Called By: SRPROC                                            *                       CSW213
      *  Calls    : None                                              *                       CSW213
      *                                                               *                       CSW213
      *****************************************************************                       CSW213
      *                                                                                       CSW213
     C     SP3REC        BEGSR
      *                                                                                       CSW213
     C                   MOVE      *OFF          *IN44
     C                   MOVE      *OFF          *IN90
     C     BEMPTY        IFNE      'Y'
      *                                                                                       CSW213
      ** Get Country Code Description of the country as extracted from Country Code File      CSW213
      *                                                                                       CSW213
     C     M3IBAC        CHAIN     MEBICCL1                           90
     C     *IN90         IFEQ      *OFF
     C                   MOVE      *ON           *IN44
     C                   MOVE      BCCNTY        RM3BID
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW213
      ** Third detail Record                                                                  CSW213
      *                                                                                       CSW213
     C                   MOVE      M3OCDT        RM3OCD
     C                   MOVE      M3MCDT        RM3MCD
     C                   MOVE      M3CCSP        RM3CSP
     C                   MOVE      M3CCLN        RM3CLN
     C                   MOVE      M3ICSP        RM3ICS
     C                   MOVE      M3ICLN        RM3ICL
     C                   MOVE      M3BBSP        RM3BBS
     C                   MOVE      M3BBLN        RM3BBL
     C                   MOVE      M3TILN        RM3TIN
     C                   MOVE      M3BISP        RM3BIS
     C                   MOVE      M3BILN        RM3BIL
     C                   MOVE      M3TBLN        RM3TBL
     C                   MOVE      M3BRSP        RM3BRS
     C                   MOVE      M3BRLN        RM3BRL
     C                   MOVE      M3INLN        RM3INL
     C                   MOVE      M3ACSP        RM3APS
     C                   MOVE      M3ACLN        RM3APL
      *                                                                                       CSW213
     C                   WRITE     ME1741R5
      *                                                                                       CSW213
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SP1END
      *****************************************************************
      *                                                               *
      *  SP1END - Subroutine to Write End of Report.                  *
      *                                                               *
      *  Called By: SRPROC                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SP1END        BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     ME1741R1
     C                   ENDIF
      *
      ** Write out Total Format.
      *
     C                   WRITE     ME1741R3
      *
     C                   CLOSE     ME1741P1
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRAUDT
      *****************************************************************
      *                                                               *
      *  SRAUDT - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, SRPROC, *PSSR                    *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRAUDT        BEGSR
      *
      ** Display user
      *
     C                   MOVEL     USER          RUSER
      *
     C                   WRITE     ME1741F1
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     ME1741F4
     C                   ELSE
      *
      ** If no records read, output no details to report.
      *
     C     RCOUNT        IFEQ      0
     C                   WRITE     ME1741F3
     C                   ELSE
      *
      ** Output no. of records processed.
      *
     C                   MOVEL     RCOUNT        RPROC
     C                   WRITE     ME1741F2
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   EXSR      SRAUDT
     C                   DUMP
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRCFP1
      *****************************************************************
      *                                                               *
      *  SRCFP1 - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     SRCFP1        BEGSR
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ               5
     C                   PARM                    SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *BLANKS       ZSERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRCFAU
      *****************************************************************
      *                                                               *
      *  SRCFAU - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     SRCFAU        BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ***  If Error occurs during ZSFILE processing, then return to the
      ***  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
