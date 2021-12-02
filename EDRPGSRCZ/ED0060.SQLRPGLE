     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058071
/*STD *  RPGSQLBND                                                    *                     MD058071
/*EXI *  TEXT('Midas ED Extract journal entries within comit')
      *****************************************************************
      *                                                               *
      *  Midas  -  Midas Export Data Module                           *
      *                                                               *
      *  ED0060 -  Extract journal entries within commit cycles       *
      *                                                               *
      *  Function: This program will access all new (ie since last    *
      *            call of this program) commits and write out all    *
      *            journal entries within the same commitment cycle.  *
      *                                                               *
      *  Called By: EDC0050 - Batch Sender                            *
      *                                                               *
      *  Calls:     AOBANKR0                                          *
      *             AOMEXPR0                                          *
      *             ED0065                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058071           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 113417             Date 28Jan97               *
      *                 104193             Date 05Jun96               *
      *                 101973             DATE 31JAN96               *
      *                 101971             DATE 17JUL95               *
      *                 S01493 *CREATE     DATE 16MAY94               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058071 - Deliverable Data Split for Export Data            *
      *  MD046248 - Finastra Rebranding                               *
      *  113417 - Recompile over changed EDDFTFL1.                    *
      *  104193 - Extend the file/member processing filter to include *
      *           the originating program name.                       *
      *  101973 - Phase V Modifications:                              *
      *            Amended module title.                              *
      *            Correct deletion of journal entries after special  *
      *            processing programs by handling it within those    *
      *            programs.  In order to preserve clarity, not all   *
      *            reworked code has been commented out & reinserted. *
      *  101971 - Phase II Modifications                              *
      *  S01493 - Midas Export Data Module.                           *
      *                                                               *
      *****************************************************************
     FEDOLDJL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(QJORDJE:EDOLDJD1)
     F                                     COMMIT
      * Old journal entries by commitment cycle
      *
     FEDNEWJL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(QJORDJE:EDNEWJD1)
      * New journal entries by commitment cycle
      *
     FEDNEWJL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(QJORDJE:EDNEWJD2)
      * New journal entries (selected on entry type = 'CM' OR 'RB')
      *
     F*EDDFTFL1* IF   E           K DISK    INFSR(*PSSR)                                    MD058071
      * Midas Drip Feed Transfer Files by Filename
      *
     FEDJRNEPD  O    E           K DISK    USROPN
     F                                     RENAME(QJORDJE:EDJRNED0)
     F                                     INFSR(*PSSR)
      * Journal entries to be exported
      * NOTE - This is a multi-membered file
      *
     FEDSAVEPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      * Batches created for export via DTA
      *
     FEDDFAUPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      * Audit file
      *
     FED0060AU  O    E             PRINTER USROPN
      * Audit report for program errors
      *
     F/EJECT
      *****************************************************************
      *                     INDICATOR USAGE                           *
      *                     ---------------                           *
      *                                                               *
      *   01      Record not found on LF/EDNEWJL2                     *
      *   02      Record not found on LF/EDOLDJL1                     *
      *   03      Record not found on LF/EDNEWJL1                     *
      *   07      Write to EDDFAUPD                                   *
      *   21      Full batch                                          *
      *   22      Access LF/EDDFTFL1                                  *
      *   23      Header record on PF/EDJRNEPD not yet written        *
      *   U7      Job Switch 7                                        *
      *   U8      Job Switch 8                                        *
      *   LR      Exit program                                        *
      *                                                               *
      *****************************************************************
      *                     INDEX OF SUBROUTINES                      *
      *                     --------------------                      *
      *                                                               *
      *   MAIN   - Main processing (Not a SR)                         *
      *   #INIT  - Initial Processing                                 *
      *   #CMTCY - Commit Cycles processing
      *   #CLRNW - Clear journal entries with no Commit ID            *
      *   #WSAVE - Write to List of Batches to Transfer               *
      *   #WDFAU - Write to Drip Feed Audit File                      *
      *   *PSSR  - Error handling SR                                  *
      *                                                               *
      *****************************************************************
     D/EJECT
      *
     D CPYR@#          DS
      ** Data Structure for Compilation - Copyright Insertion
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
     D WKFLDS          DS
      ** Data Structure zoned work fields
     D  WSEQNO                 1     10  0
      *
     D*KDFTF******DS                                                      104193
      ***Data*Structure*LF/EDDFTFL1*Key*******                            104193
     D****************************************1  10 UFILE                 104193
     D***************************************11  20 UMMBR                 104193
     D PSDS           SDS
      ** Program Status
     D  WSID                 244    253
     D  USRID                254    263
     D  WDATE                276    281
     D  WTIME                282    287
      *                                                                   101971
     D LDA             DS           256
      *
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      *
     D  DBLOT                134    183
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Bank Details
      *
     D SDMEXP        E DS                  EXTNAME(SDMEXPPD)
      ** Midas Export Data ICD
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Midas Access Object Short Data Structure
     D EDDFTF        E DS                  EXTNAME(EDDFTJW0)                                MD058071
      *
     D                 DS                                                       101971
      ** Data Structure for Journal record data parameter                 101971
     D  DATA1                  1    125                                         101971
     D  JOENTL                 1      5  0                                      101971
     D  JOSEQN                 6     15  0                                      101971
     D  JOCODE                16     16                                         101971
     D  JOENTT                17     18                                         101971
     D  JODATE                19     24                                         101971
     D  JOTIME                25     30  0                                      101971
     D  JOJOB                 31     40                                         101971
     D  JOUSER                41     50                                         101971
     D  JONBR                 51     56  0                                      101971
     D  JOPGM                 57     66                                         101971
     D  JOOBJ                 67     76                                         101971
     D  JOLIB                 77     86                                         101971
     D  JOMBR                 87     96                                         101971
     D  JOCTRR                97    106  0                                      101971
     D  JOFLAG               107    107                                         101971
     D  JOCCID               108    117  0                                      101971
     D  JORES                118    125                                         101971
      ** Copyright Statement
      *
     I/EJECT
     I*  Rename COMMIT ID field
     I*
     IEDNEWJD2
     I              JOENTT                      UCMTID
     C/EJECT
      *****************************************************************
      *
     C                   EXSR      #INIT
      *
      *** MAIN PROCESSING
      *** ===============
      *
      ** Access the records from LF/EDNEWJL2. Each record read is a
      ** commitment cycle completion - either a COMMIT or a ROLLBACK.
      *
     C                   Z-ADD     PSEQNO        WSEQNO
     C     WSEQNO        SETLL     EDNEWJD2
     C                   READ      EDNEWJD2                               01
      *
     C                   SETOFF                                       21
     C     *IN01         DOWEQ     *OFF
     C     *IN21         ANDEQ     *OFF
      *
      ** Save the journal sequence number of the end of the commit
      ** cycle being processed.  This is to allow ED0060, (when
      ** next called), to start looking for new commit cycle completions
      ** from the first unprocessed one.  (EDC0050 increments this before
      ** updating the data area).
      *
     C                   Z-ADD     JOSEQN        PSEQNO
      *
      ** Commit cycle processing
      *
     C                   EXSR      #CMTCY
      *
      ***  If maximum no. of records has been reached then only
      ***  continue writing to end of commitment cycle
      *
     C     UPCNT         IFGE      E7DFMR
     C     JOENTT        ANDEQ     'CM'
     C                   SETON                                        21
     C                   ELSE
      *
     C                   READ      EDNEWJD2                               01
     C                   ENDIF
      *
     C                   ENDDO
      *
      *** If End of File, set PEOF to 'Y' to stop an unneccesary call
      *** of this program.
      *
     C     *IN01         IFEQ      *ON
     C                   MOVEL     'Y'           PEOF
     C                   ENDIF
      *
      *
      *** Clear unwanted Journal Entries
      *
     C                   EXSR      #CLRNW
      *
      *** If records were written then a batch really exists .....
      *
     C***********UPCNT     IFGT *ZERO                                     101971
     C     UPCNT         IFGT      1                                                           10197
      *
      *** Write to List of batches for transfer file
      *
     C                   EXSR      #WSAVE
      *
      *** Write to Audit file
      *
     C                   EXSR      #WDFAU
      *
     C                   MOVEL     'Y'           PRW
     C                   ENDIF
      *
      *** End Program
      *
     C                   CLOSE     EDJRNEPD
     C                   SETON                                            LR
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE : #CMTCY  - Commitment cycle transaction          *
      *                                                               *
      *  CALLED BY  : Main                                            *
      *                                                               *
      *  CALLS      : -                                               *
      *                                                               *
      *****************************************************************
      *
     C     #CMTCY        BEGSR                                                  ** #CMTCY **
      *
      ** Read each journal entry. If it has this commit id, write it to
      ** PF/EDJRNEPD (overridden to a different member in calling pgm).
      *
      **  OLD journal entries
      *
     C     JOCCID        CHAIN     EDOLDJL1                           02
      *
     C     *IN02         DOWEQ     '0'                                          B1
      *
      ***  If this journal entry was from a file and the commit cycle
      ***  was successful, (rather than a rollback) then ....
      *
     C     JOOBJ         IFNE      *BLANKS                                      B2
     C     UCMTID        ANDEQ     'CM'
      *
      *****Set*up*key*for*file*and*member*name******                      104193
      *
     C*********************MOVEL*BLANKS   UFILE                           104193
     C*********************MOVELJOOBJ     UFILE                           104193
     C*********************MOVEL*BLANKS   UMMBR                           104193
     C*********************MOVELJOMBR     UMMBR                           104193
      *                                                                   104193
      *** Set up key for file member and originating program name         104193
      *                                                                   104193
     C                   MOVEL     *BLANKS       FILMBR                                        10419
     C                   MOVEL     JOOBJ         FILMBR                                        10419
     C                   MOVE      JOMBR         FILMBR                                        10419
     C                   MOVEL     JOPGM         UPROG            10                           10419
      *                                                                   104193
     C*****KDFTF         CHAIN     EDDFTFL1                           22              10419 MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :EDDFTF                                                                        MD058071
     C+ from EDDFTJW0                                                                       MD058071
     C+ where EGTRFN = :FILMBR and EGORPR = :UPROG and EGEXFL = 'Y'                         MD058071
     C/END-EXEC                                                                             MD058071
      *                                                                   104193
      *** Set up key for file and originating program name                104193
      *                                                                   104193
     C******IN22         IFEQ      *ON                                                10419 MD058071
     C     SQLCODE       IFEQ      100                                                10419 MD058071
     C                   MOVEL     *BLANKS       FILMBR                                        10419
     C                   MOVEL     JOOBJ         FILMBR                                        10419
     C*****KDFTF         CHAIN     EDDFTFL1                           22              10419 MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :EDDFTF                                                                        MD058071
     C+ from EDDFTJW0                                                                       MD058071
     C+ where EGTRFN = :FILMBR and EGORPR = :UPROG and EGEXFL = 'Y'                         MD058071
     C/END-EXEC                                                                             MD058071
     C                   ENDIF                                                                 10419
      *                                                                   104193
      *** If above fails then locate file member and no originating       104193
      *** program name                                                    104193
      *                                                                   104193
     C******IN22         IFEQ      *ON                                                10419 MD058071
     C     SQLCODE       IFEQ      100                                                10419 MD058071
     C                   MOVE      JOMBR         FILMBR                                        10419
     C                   MOVEL     *BLANKS       UPROG                                         10419
      *                                                                   104193
      *
     C*****KDFTF         CHAIN     EDDFTFL1                           22                    MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :EDDFTF                                                                        MD058071
     C+ from EDDFTJW0                                                                       MD058071
     C+ where EGTRFN = :FILMBR and EGORPR = :UPROG and EGEXFL = 'Y'                         MD058071
     C/END-EXEC                                                                             MD058071
     C                   ENDIF                                                                 10419
      *
      ***  If member not found then see if DTA has not specified a
      ***  particular member.
      *
     C******IN22         IFEQ      *ON                                                10419 MD058071
     C     SQLCODE       IFEQ      100                                                10419 MD058071
     C*********************MOVEL*BLANKS   UMMBR                           104193
     C                   MOVEL     *BLANKS       FILMBR                                        10419
     C                   MOVEL     JOOBJ         FILMBR                                        10419
     C*****KDFTF         CHAIN     EDDFTFL1                           22                    MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :EDDFTF                                                                        MD058071
     C+ from EDDFTJW0                                                                       MD058071
     C+ where EGTRFN = :FILMBR and EGORPR = :UPROG and EGEXFL = 'Y'                         MD058071
     C/END-EXEC                                                                             MD058071
     C                   ENDIF                                                  E3
      *
      *** If this record is for a wanted file then copy the record
      *** to PF/EDJRNEPD
      *
     C******IN22         IFEQ      *OFF                                         B3          MD058071
     C     SQLCODE       IFEQ      0                                                  10419 MD058071
      *
     C     *IN23         IFEQ      *OFF                                         B4
     C                   CALL      'ED0065'
     C                   PARM                    URETC             1
      *
     C     URETC         IFNE      *BLANK                                       B5
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE                          ***************
     C                   MOVEL     'ED0065  '    DBFILE                         * DB ERROR 05 *
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   MOVEL     PBTCH         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF                                                  E5
      *
     C                   ADD       1             UPCNT
     C                   OPEN      EDJRNEPD
     C                   SETON                                        23
     C                   ENDIF                                                  E4
      *
      ** Check to see whether a special processing program exists for     101971
      ** this file.                                                       101971
      *                                                                   101971
     C     EGSPPP        IFEQ      *BLANK                                       B4             10197
      *                                                                   101971
      ** If not then write the record to the output file ......           101971
      *                                                                   101971
     C                   WRITE     EDJRNED0
     C                   ADD       1             UPCNT
      *                                                                   101973
      *** .... and delete the entry on PF/EDOLDJPD as it is no longer     101973
      *** needed.                                                         101973
      *                                                                   101973
     C                   DELETE    EDOLDJL1                                                    10197
      *                                                                   101971
     C                   ELSE                                                   X4             10197
      *                                                                   101971
     C                   UNLOCK    EDOLDJL1                                                    10197
     C                   CALL      EGSPPP                                                      10197
     C                   PARM                    DATA1                                         10197
     C                   PARM                    JOESD                                         10197
     C                   PARM      'O'           SRCF              1                           10197
     C                   PARM                    CDFILE            8                           10197
     C                   PARM                    CDBKEY           10                           10197
     C                   PARM                    WRTCD1            1                           10197
     C                   PARM                    RECCNT            5 0                         10197
      *                                                                   101971
     C     WRTCD1        IFNE      *BLANKS                                      B5             10197
     C                   Z-ADD     7             DBASE                          ***************10197
     C                   MOVEL     CDFILE        DBFILE                         * DB ERROR 07  10197
     C                   MOVEL     EGSPPP        DBKEY                          ***************10197
     C                   MOVE      CDBKEY        DBKEY                                         10197
     C                   OUT       LDA                                                         10197
     C                   EXSR      *PSSR                                                       10197
     C                   ENDIF                                                  E5             10197
      *                                                                   101971
      **  Increment the record count with the number of records added     101971
      **   by the special processing program.                             101971
      *                                                                   101971
     C                   ADD       RECCNT        UPCNT                                         10197
      *                                                                   101971
      ****Re-access*the*record**********                           101971 101973
     C***********JOCCID****CHAINEDOLDJL1             02            101971 101973
      *                                                                   101971
     C                   ENDIF                                                  E4             10197
      *                                                                   101971
     C                   ELSE                                                   X3             10197
      *                                                                   101973
      *** This removes journal entries which are for files which are not  101973
      *** required by DTA.                                                101973
      *                                                                   101973
     C                   DELETE    EDOLDJL1                                                    10197
      *                                                                   101973
     C                   ENDIF                                                  E3
      *                                                                   101973
     C                   ELSE                                                   X2             10197
      *                                                                   101973
      *** This removes journal entries from Rollbacks and the like        101973
      *                                                                   101973
     C                   DELETE    EDOLDJL1                                                    10197
      *                                                                   101973
     C                   ENDIF                                                  E2
      *
      ****Delete*the*journal*entry*on*PF/EDOLDJPD*-*it*is*no*longer*needed101973
      ****(This*removes*journal*entries*for*Rollbacks*as*well*as*Commits.)101973
      ********************************************************************101973
     C***********          DELETEDOLDJL1                                  101973
      *
      *** Read next journal entry from this commit group
      *** CHAIN is required because the file pointer may have been        101973
      *** changed in a Special Processing Program.                        101973
      *
     C***********JOCCID    READEEDOLDJL1                 02               101973
     C     JOCCID        CHAIN     EDOLDJL1                           02                       10197
      *                                                                   101973
     C                   ENDDO                                                  E1
      *
      **  NEW journal entries
      *
     C     JOCCID        CHAIN     EDNEWJL1                           03
     C     *IN03         DOWEQ     '0'                                          B1
      *
      ***  If this journal entry was from a file and the commit cycle
      ***  was successful, (rather than a rollback) then ....
      *
     C     JOOBJ         IFNE      *BLANKS                                      B2
     C     UCMTID        ANDEQ     'CM'
      *
      *****Set*up*key*for*file*and*member*name*****                       104193
      *                                                                   104193
      ***  Set up key for file, member and originating program name       104193
      *
     C*********************MOVELJOOBJ     UFILE                           104193
     C*********************MOVELJOMBR     UMMBR                           104193
     C                   MOVEL     *BLANKS       FILMBR                                        10419
     C                   MOVEL     JOOBJ         FILMBR                                        10419
     C                   MOVE      JOMBR         FILMBR                                        10419
     C                   MOVEL     JOPGM         UPROG                                         10419
      *                                                                   104193
     C*****KDFTF         CHAIN     EDDFTFL1                           22              10419 MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :EDDFTF                                                                        MD058071
     C+ from EDDFTJW0                                                                       MD058071
     C+ where EGTRFN = :FILMBR and EGORPR = :UPROG and EGEXFL = 'Y'                         MD058071
     C/END-EXEC                                                                             MD058071
      *                                                                   104193
      *** Set up key for file and originating program name                104193
      *                                                                   104193
     C******IN22         IFEQ      *ON                                                10419 MD058071
     C     SQLCODE       IFEQ      100                                                10419 MD058071
     C                   MOVEL     *BLANKS       FILMBR                                        10419
     C                   MOVEL     JOOBJ         FILMBR                                        10419
     C*****KDFTF         CHAIN     EDDFTFL1                           22              10419 MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :EDDFTF                                                                        MD058071
     C+ from EDDFTJW0                                                                       MD058071
     C+ where EGTRFN = :FILMBR and EGORPR = :UPROG and EGEXFL = 'Y'                         MD058071
     C/END-EXEC                                                                             MD058071
     C                   ENDIF                                                                 10419
      *                                                                   104193
      *** If above fails then locate file member and no originating       104193
      *** program name                                                    104193
      *                                                                   104193
     C******IN22         IFEQ      *ON                                                10419 MD058071
     C     SQLCODE       IFEQ      100                                                10419 MD058071
     C                   MOVE      JOMBR         FILMBR                                        10419
     C                   MOVEL     *BLANKS       UPROG                                         10419
      *
     C*****KDFTF         CHAIN     EDDFTFL1                           22                    MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :EDDFTF                                                                        MD058071
     C+ from EDDFTJW0                                                                       MD058071
     C+ where EGTRFN = :FILMBR and EGORPR = :UPROG and EGEXFL = 'Y'                         MD058071
     C/END-EXEC                                                                             MD058071
     C                   ENDIF                                                                 10419
      *
      ***  If member not found then see if DTA has not specified a
      ***  particular member.
      *
     C******IN22         IFEQ      *ON                                                10419 MD058071
     C     SQLCODE       IFEQ      100                                                10419 MD058071
     C*********************MOVEL*BLANKS   UMMBR                           104193
     C                   MOVEL     *BLANKS       FILMBR                                        10419
     C                   MOVEL     JOOBJ         FILMBR                                        10419
     C*****KDFTF         CHAIN     EDDFTFL1                           22                    MD058071
     C/EXEC SQL                                                                             MD058071
     C+ SELECT *                                                                            MD058071
     C+ into :EDDFTF                                                                        MD058071
     C+ from EDDFTJW0                                                                       MD058071
     C+ where EGTRFN = :FILMBR and EGORPR = :UPROG and EGEXFL = 'Y'                         MD058071
     C/END-EXEC                                                                             MD058071
     C                   ENDIF                                                  E3
      *
      *** If this record is for a wanted file then copy the record
      *** to PF/EDJRNEPD
      *
     C******IN22         IFEQ      *OFF                                         B3          MD058071
     C     SQLCODE       IFEQ      0                                                  10419 MD058071
     C     *IN23         IFEQ      *OFF                                         B4
     C                   CALL      'ED0065'
     C                   PARM                    URETC             1
      *
     C     URETC         IFNE      *BLANK                                       B5
     C     *LOCK         IN        LDA
     C                   Z-ADD     6             DBASE                          ***************
     C                   MOVEL     'ED0065  '    DBFILE                         * DB ERROR 06 *
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   MOVEL     PBTCH         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF                                                  E5
      *
     C                   OPEN      EDJRNEPD
     C                   ADD       1             UPCNT
     C                   SETON                                        23
     C                   ENDIF                                                  E4
      *
      ** Check to see whether a special processing program exists for     101971
      ** this file.                                                       101971
      *                                                                   101971
     C     EGSPPP        IFEQ      *BLANK                                       B4             10197
      *                                                                   101971
      ** If not then write the record to the output file ......           101971
      *                                                                   101971
     C                   WRITE     EDJRNED0
     C                   ADD       1             UPCNT
      *                                                                   101973
      *** .... and delete the entry on PF/EDNEWJPD as it is no longer     101973
      *** needed.                                                         101973
      *                                                                   101973
     C                   DELETE    EDNEWJL1                                                    10197
      *                                                                   101971
     C                   ELSE                                                   X4             10197
      *                                                                   101971
     C                   UNLOCK    EDNEWJL1                                                    10197
     C                   CALL      EGSPPP                                                      10197
     C                   PARM                    DATA1                                         10197
     C                   PARM                    JOESD                                         10197
     C                   PARM      'N'           SRCF                                          10197
     C                   PARM                    CDFILE                                        10197
     C                   PARM                    CDBKEY                                        10197
     C                   PARM                    WRTCD1                                        10197
     C                   PARM                    RECCNT                                        10197
      *                                                                   101971
     C     WRTCD1        IFNE      *BLANKS                                      B5             10197
     C                   Z-ADD     8             DBASE                          ***************10197
     C                   MOVEL     CDFILE        DBFILE                         * DB ERROR 08  10197
     C                   MOVEL     EGSPPP        DBKEY                          ***************10197
     C                   MOVE      CDBKEY        DBKEY                                         10197
     C                   OUT       LDA                                                         10197
     C                   EXSR      *PSSR                                                       10197
     C                   ENDIF                                                  E5             10197
      *                                                                   101971
      **  Increment the record count with the number of records added     101971
      **   by the special processing program.                             101971
      *                                                                   101971
     C                   ADD       RECCNT        UPCNT                                         10197
      *                                                                   101971
      ****Re-access*the*record**********                           101971 101973
     C********** JOCCID    CHAINEDNEWJL1             02            101971 101973
      *                                                                   101971
     C                   ENDIF                                                  E4             10197
      *                                                                   101971
     C                   ELSE                                                   X3             10197
      *                                                                   101973
      *** This removes journal entries which are for files which are not  101973
      *** required by DTA.                                                101973
      *                                                                   101973
     C                   DELETE    EDNEWJL1                                                    10197
      *
     C                   ENDIF                                                  E3
      *
     C                   ELSE                                                   X2             10197
      *                                                                   101973
      *** This removes journal entries from Rollbacks and the like        101973
      *                                                                   101973
     C                   DELETE    EDNEWJL1                                                    10197
      *                                                                   101973
     C                   ENDIF                                                  E2
      *
      ****Delete*the*journal*entry*on*PF/EDNEWJPD*-*it*is*no*longer*needed101973
      ****(This*removes*journal*entries*for*Rollbacks*as*well*as*Commits.)101973
      ********************************************************************101973
     C**********           DELETEDNEWJL1                                  101973
      *
      *** Read next journal entry from this commit group
      *** CHAIN is required because the file pointer may have been        101973
      *** changed in a Special Processing Program.                        101973
      *
     C***********JOCCID    READEEDNEWJL1                 03               101973
     C     JOCCID        CHAIN     EDNEWJL1                           03                       10197
      *                                                                   101973
     C                   ENDDO                                                  E1
      *
     C     CMTCY9        ENDSR                                                  ** CMTCY9 **
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE : #CLRNW - Delete journal items without Commits   *
      *                                                               *
      *  CALLED BY  : Main                                            *
      *                                                               *
      *  CALLS      : -                                               *
      *                                                               *
      *****************************************************************
      *
     C     #CLRNW        BEGSR                                                  ** #CLRNW **
      *
      ***  If Journal entry has no Commit ID then delete it now
      *
     C     *LOVAL        SETLL     EDNEWJL1
     C                   READ      EDNEWJL1                               03
      *
     C     *IN03         DOWEQ     *OFF
     C     JOCCID        IFEQ      *ZERO
     C                   DELETE    EDNEWJL1
     C                   ENDIF
      *
     C                   READ      EDNEWJL1                               03
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE : #WSAVE - Write to List of Batches to Transfer   *
      *                                                               *
      *  CALLED BY  : Main                                            *
      *                                                               *
      *  CALLS      : -                                               *
      *                                                               *
      *****************************************************************
      *
     C     #WSAVE        BEGSR                                                  ** #WSAVE **
      *
      *** Write to List of Batches
      *
     C                   MOVEL     PSVLIB        EFLIBR
     C                   MOVEL     '/'           EFSEP1
     C                   MOVEL     'EDJRNEPD'    EFFILE
     C                   MOVEL     '.'           EFSEP2
     C                   MOVEL     PBTCH         EFMEMB
      *
     C                   WRITE     EDSAVED0                             06
      *
     C     *IN06         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE                          ***************
     C                   MOVEL     'EDSAVEPD'    DBFILE                         * DB ERROR 03 *
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   MOVEL     PBTCH         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     #WRSA9        ENDSR                                                  ** #WRSA9 **
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE : WRDFAU - Write to Audit File.                   *
      *                                                               *
      *  CALLED BY  : Main                                            *
      *                                                               *
      *  CALLS      : -                                               *
      *                                                               *
      *****************************************************************
      *
      *** Write to Audit file
      *
     C     #WDFAU        BEGSR                                                  ** #WDFAU **
      *
     C                   MOVEL     PBTCH         EEBTCH
     C                   MOVEL     'S'           EEBAST
     C                   TIME                    EECRET
     C                   MOVEL     BJMRDT        EECRED
     C                   Z-ADD     0             EEDELT
     C                   MOVEL     *BLANKS       EEDELD
     C                   MOVE      '0'           EEAUDR                                        10197
     C                   WRITE     EDDFAUD0                             07
      *
     C     *IN07         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     4             DBASE                          ***************
     C                   MOVEL     'EDDFAUPD'    DBFILE                         * DB ERROR 04 *
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   MOVEL     PBTCH         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     #WRAU9        ENDSR                                                  ** #WRAU9 **
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE : INIT - Initial Processing                       *
      *                                                               *
      *  CALLED BY  : Main                                            *
      *                                                               *
      *  CALLS      : -                                               *
      *                                                               *
      *****************************************************************
      *
     C     #INIT         BEGSR                                                  ** #INIT  **
      *
      **  Program entry
      *
     C     *ENTRY        PLIST
     C                   PARM                    PBTCH            10
     C                   PARM                    PSEQNO           10 0
     C                   PARM                    PSVLIB            7
     C                   PARM                    PRW               1
     C                   PARM                    PEOF              1
      *
      *** Copyright Statement.
      *
     C                   MOVEA     CPY@          ACT@             80
      *
      *** Declarations and initialisations
      *
     C     *LIKE         DEFINE    JONBR         UNBR
     C     *LIKE         DEFINE    JOSEQN        USEQN
     C     *LIKE         DEFINE    E7DFMR        UPCNT
     C                   Z-ADD     0             UPCNT
     C                   MOVEL     'N'           PRW
     C                   MOVEL     'N'           PEOF
      *
      ** PREPARE LDA
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANK        DBLOT
     C                   MOVEL     'ED0060'      DBPGM
     C                   OUT       LDA
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *
     C                   MOVEL     '*FIRST'      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      *** Access ICD
      *
     C                   CALL      'AOMEXPR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMEXP        PARM      SDMEXP        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE                          ***************
     C                   MOVEL     'SDMEXPPD'    DBFILE                         * DB ERROR 02 *
     C                   MOVEL     '*FIRST'      DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                   104193
      *** Define composite key to allow access to EDDFTFPD using a        104193
      *** combination of file member and originating program name         104193
      *                                                                   104193
     C     KDFTF         KLIST                                                                 10419
     C                   KFLD                    FILMBR           20                           10419
     C                   KFLD                    UPROG                                         10419
      *                                                                   104193
     C     #INIT9        ENDSR                                                  ** #INIT9 **
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SUBROUTINE : *PSSR  - Error Handling Subroutine              *
      *                                                               *
      *  CALLED BY  : This routine is called if there are any program *
      *               or file errors.                                 *
      *                                                               *
      *  CALLS      : -                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR  **
      *
      ** Ensure this routine is only performed once
      *
     C     WPSSR         IFEQ      *BLANK
     C                   MOVEL     'Y'           WPSSR             1
      *
      ** Set on Error Indicators, U7 and U8 and LR.
      *
     C                   SETON                                        U7U8LR
      *
      **  Print audit report ED0060AU
      *
     C                   OPEN      ED0060AU
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
     C                   CLOSE     ED0060AU
      *
      **  Dump program and return.
      *
     C                   DUMP
     C                   RETURN
      *
     C                   END
      *
     C     #PSSR9        ENDSR                                                  ** #PSSR9 **
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
