     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas MA Collation control')
/*OVRF*: OVRDBF ODBUILD  MAOPTDPD                                   : *   S01382
      *****************************************************************
      *                                                               *
      *  Midas - Microfiche/Optical Disk Archiving Module             *
      *                                                               *
      *  MA0620 - COLLATION CONTROL (ARCHIVE COLLATION REPORTS)       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG5869            Date 21Mar05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01382             Date 05Aug92               *
      *                 E29281             Date 23Oct91               *
      *                     S00000   DATE - ddmmmyy                   *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  BUG5869 - For archiving from outq, assign entity details as  *
      *            held by RCF; for archiving on request, report name *
      *            should include suffix.                             *
      *     S01382 - OPTICAL DISK DEVELOPMENT                         *  *
      *     E29281 - OUTPUT '1*$*$' TO THE OPTICAL DISK HEADER RECORD *
      *                                                               *
      *****************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
      *****************************************************************
      *
      * Read all records on the Collation Work file (MACWRKL1)
      *  and archive all records with the Collation Frequency
      *  equal to one of the frequencies on the EDDFLG data
      *  area (= FRQ array).
      *
      * Delete all archived collation records selected for
      *  archiving.
      *
      *****************************************************************
      *
      * FUNCTION OF INDICATORS
      * ========================
      *
      *      U7,U8 Database Error
      *   01       Collation Header Record
      *   02       Collation Detail Record
      *   10       Collation Frequencies due for processing today
      *   20       Write Bureau Header Record
      *   50       EOF on MACWKYL1 file
      *   51       End of records on MACWKYL1 for this frequency
      *   55       No record on MAARCHL1 file
      *   56       No record on FCRSFXL1, or MARCOLL1 file
      *   59       Database, File access error
      *
      *****************************************************************
      /EJECT
     FMACWRKL1  UF   E           K DISK
      *
     F*FCRSFXL1* IF   E           K DISK                                                    MD055265
     FMARCOLL1  IF   E           K DISK
     FMAARCHL1  IF   E           K DISK
      *
     FMAFICDPD  O    E             DISK
     F***********MAOPTDPDO   E                    DISK                    S01382
     FODBUILD   IF A E             DISK    USROPN                               S01382
     F                                     RENAME(MAOPTDD0:ODBUILD0)            S01382
      * Collation Frequencies - Today's selections
     D @CPY            S             80    DIM(1) CTDATA PERRCD(1)
     D FICH          E DS                  EXTNAME(MAFICHPD)
     D FICD          E DS                  EXTNAME(MAFICDPD)                    S01382
      /EJECT
      *FICH      E DSMAFICHPD
      ** Microfiche Header Record layout
      *
     D***********OPTH      E DSMAOPTHPD                                   S01382
      ***Optical*Disk*Header*Record*layout                                S01382
      *
     D***********OPTD      E DSMAOPTDPD                                   S01382
     D DSOPTD        E DS                  EXTNAME(ODBUILD)                     S01382
     D  ODCCHR       E                     EXTFLD(MACCHR)                       S01382
     D  OPTD         E                     EXTFLD(ODRDTL)                       S01382
      ** Optical Disk Detail Record layout
      *
     D EDDFLG          DS             7
      * Collation Frequencies data area
      *
     D  FRQ                    1      7
     D                                     DIM(7)
      *
     D RUNDAT          DS            13
      ** MIDAS Run Date data area
      *
     D  @@DATA                 1      7
     D  @@DATN                 8     10P 0
      *
     D LDA            UDS           256
      ** Standard MIDAS Data Area fields
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D                 DS
      ** Data structuse for DB Error KEY File output
      *
      ** MACWRKL0/L1 key
     D  CWRK                   1     21
      ** MARCOLL1 key
     D  RCOL                  12     32
      *
     D  CLARID                 1     10
     D  CLCFRQ                11     11
      *
     D  CLRNAM                12     21
     D  CLRSFX                22     31
      *
     D  ##CFRQ                32     32
      *                                                                   S01382
     D IHEAD           DS                                                       S01382
      ** Internal header record data structure                            S01382
      *                                                                   S01382
     D  HEADER                 1    198                                         S01382
     D  OUTPUT                 1      4                                         S01382
     D  REPORT                 5     14                                         S01382
     D  JOBNAM                25     34                                         S01382
     D  PRTFNM                54     63                                         S01382
      *                                                                   S01382
     D                 DS                                                       S01382
      * Data structure for copy file                                      S01382
     D  PCMD                   1    148                                         S01382
     D                                     DIM(2) CTDATA PERRCD(1)                               S01
     D  @TOMBR                47     56                                         S01382
     D FCRSFX        E DS                  EXTNAME(FCRSFJW0)                                MD055265
      * Copyright statement
     IMACHDRD0      01
     IMACDTLD0      02
     IODBUILD0                                                                  S01382
     I              MACCHR                      ODCCHR                          S01382
     I              ODRDTL                      OPTD                            S01382
      *
     C                   MOVEA     @CPY          @BIS             80
      /EJECT
      *
      * Collation Work file
      *
     C     CWRKK         KLIST
     C                   KFLD                    CLARID
     C                   KFLD                    CLCFRQ
     C                   KFLD                    CLRNAM
     C                   KFLD                    CLRSFX
      *
      * Collation Work file (short key)
      *
     C     CWRKSK        KLIST
     C                   KFLD                    CLARID
     C                   KFLD                    CLCFRQ
      *
      * Reports for collation & SUFFIXES
      *
     C     RCOLK         KLIST
     C                   KFLD                    CLRNAM
     C                   KFLD                    CLRSFX
      *
      ** Define MIDAS data areas, LDA, EDDFLG and RUNDAT
      *
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  EDDFLG
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        EDDFLG
     C                   IN        RUNDAT
      *******
      * Define/Initialize key & work Fields
      *
     C                   MOVE      *BLANKS       LDA
     C***********          MOVE 'MA0620'  DBPGM                           S01382
     C                   MOVEL     'MA0620'      DBPGM                                         S0138
     C                   MOVE      ' '           RECOUT            1                           S0138
      *                                                                   S01382
      * Open PF/ODBUILD under user control                                S01382
     C                   OPEN      ODBUILD                                                     S0138
      *                                                                   S01382
      * Dummy chain to PF/ODBUILD to allow input specs to be coded for    S01382
      * renaming of field on file                                         S01382
      *                                                                   S01382
     C     1             CHAIN     ODBUILD0                           60                       S0138
      *
     C                   MOVE      *BLANKS       CLARID
     C                   MOVE      *BLANKS       CLCFRQ
     C                   MOVE      *BLANKS       ##CFRQ
     C                   MOVE      *BLANKS       CLRSFX
      *
     C     *LIKE         DEFINE    CLARID        ##ARID
     C     *LIKE         DEFINE    CLRSFX        ##RSFX
     C                   MOVE      *BLANKS       ##ARID
     C                   MOVE      *BLANKS       ##RSFX
      *
      * Setup Bureau Header output fields
      *
     C                   MOVE      *ALL'\'       FICH
     C                   MOVE      '*HDR*'       MARTP5
     C                   MOVE      @@DATA        MAADAT
     C                   Z-ADD     @@DATN        MAMDAT
      *
     C***********          MOVE *ALL'\'   OPTH                            S01382
     C***********          MOVE '*HDR*'   M1RTP5                          E29281
     C***********          MOVE '1*$*$'   M1RTP5                    E29281S01382
     C***********          MOVE @@DATA    M1ADAT                          S01382
     C***********          Z-ADD@@DATN    M1MDAT                          S01382
      *
      **********************************************************
      /EJECT
      **********************************************************
      *                                                        *
      *   M A I N L I N E    P R O C E S S I N G               *
      *                                                        *
      **********************************************************
      *
      *******
      * Read all Collation Work file records to E.O.F
      *
     C     *IN50         DOUEQ     '1'
      *
      * Set file pointer to next Archive-ID/Frequency to be archived
      *
     C     CWRKSK        SETGT     MACWRKL1
      *
      * Read the Collation Work record
      *
     C                   MOVEA     '00'          *IN(01)
     C                   READ      MACWRKL1                             5950
      * File error ??
     C     *IN59         IFEQ      '1'
     C     *LOCK         IN        LDA                                                         S0138
     C                   MOVE      'MACWRKL1'    DBFILE
     C                   MOVEL     CWRK          DBKEY
     C                   Z-ADD     1             DBASE                           *************
     C                   OUT       LDA                                           ************* S0138
     C                   SETON                                        U7U8LR     * DB err 01 *
     C                   RETURN                                                  *************
     C                   END
      *                                                                   S01382
      * On change of Archive ID or at end of file                         S01382
     C     CLARID        IFNE      ##ARID                                                      S0138
     C     ##ARID        ANDNE     *BLANKS                                                     S0138
     C     *IN50         OREQ      '1'                                                         S0138
      *                                                                   S01382
      * If archiving to Optical Disk                                      S01382
     C     EAMEDM        IFEQ      'O'                                                         S0138
     C     EAMEDM        OREQ      'B'                                                         S0138
      *                                                                   S01382
      * If records have been output to PF/ODBUILD                         S01382
     C     RECOUT        IFEQ      'Y'                                                         S0138
      *                                                                   S01382
      * Close and open PF/ODBUILD to ensure that all records are          S01382
      * written to PF/ODBUILD before the copy to PF/MAOPTDPD              S01382
     C                   CLOSE     ODBUILD                                                     S0138
     C                   OPEN      ODBUILD                                                     S0138
      *                                                                   S01382
      * Copy records from PF/ODBUILD to the member for the Archive ID     S01382
      * just processed, in PF/MAOPTDPD                                    S01382
     C                   MOVE      *BLANKS       QCMD             74                           S0138
     C                   MOVEL     ##ARID        @TOMBR                                        S0138
     C                   MOVEA     PCMD(1)       QCMD                                          S0138
      *                                                                   S01382
     C                   CALL      'QCMDEXC'                                                   S0138
     C                   PARM                    QCMD                                          S0138
     C                   PARM      74            QLNGTH           15 5                         S0138
      *                                                                   S01382
      * Close PF/ODBUILD to free member ready for the CLRPFM              S01382
     C                   CLOSE     ODBUILD                                                     S0138
      *                                                                   S01382
      * Clear PF/ODBUILD                                                  S01382
     C                   MOVE      *BLANKS       QCMD                                          S0138
     C                   MOVEA     PCMD(2)       QCMD                                          S0138
      *                                                                   S01382
     C                   CALL      'QCMDEXC'                                                   S0138
     C                   PARM                    QCMD                                          S0138
     C                   PARM      74            QLNGTH           15 5                         S0138
      *                                                                   S01382
      * Reopen PF/ODBUILD                                                 S01382
     C                   OPEN      ODBUILD                                                     S0138
     C                   MOVE      ' '           RECOUT                                        S0138
     C                   END                                                                   S0138
     C                   END                                                                   S0138
     C                   END                                                                   S0138
      *
      * Check for E.O.F
      *
     C     *IN50         IFEQ      '0'
      *
      * At change of Archive ID, access Archiving information
      *
     C     CLARID        IFNE      ##ARID
     C                   MOVE      CLARID        ##ARID
     C                   MOVE      '1'           *IN20
      *
     C     CLARID        CHAIN     MAARCHL1                           5559
      * DB error ??
     C     *IN55         IFEQ      '1'
     C     *IN59         OREQ      '1'
     C     *LOCK         IN        LDA                                                         S0138
     C                   MOVE      'MAARCHL1'    DBFILE
     C                   MOVEL     CLARID        DBKEY
     C                   Z-ADD     2             DBASE                           *************
     C                   OUT       LDA                                           ************* S0138
     C                   SETON                                        U7U8LR     * DB err 02 *
     C                   RETURN                                                  *************
     C                   END
     C                   END
      *
      * Check, if Frequency read is to be processed today
      *
     C     CLCFRQ        IFNE      ##CFRQ
     C                   MOVE      CLCFRQ        ##CFRQ
     C                   MOVE      '1'           *IN20
      *
     C                   Z-ADD     1             I                 1 0
     C     CLCFRQ        LOOKUP    FRQ(I)                                 10
     C                   END
      *
      * Archive All reports for this frequency
      *
     C     *IN10         IFEQ      '1'
     C                   EXSR      SARCH
     C                   ELSE
     C     CWRKSK        SETGT     MACWRKL1
     C                   END
      *
      * end IF (E.O.F)
     C                   END
      *
      * end DO (E.O.F)
     C                   END
      **********************************************************
      *                                                                   S01382
      * Close PF/ODBUILD at end of program                                S01382
     C                   CLOSE     ODBUILD                                                     S0138
      *
      * End Of Pgm
     C                   MOVE      '1'           *INLR
      *
      ***********************************************************
      /EJECT
      ***********************************************************
      *
      * SARCH -  Read Collation Reports for the frequency
      *=========
      *      called by :  Mainline processing
      *
      *      calls     :  SDET - write Bureau Header/Details for
      *                          the Freq/Report
      *                   SDLT - Delete all Collation Work File Records for
      *                          the Archive ID/Frequency/Report processed.
      ***********************************************************
      *
     C     SARCH         BEGSR
      *
     C                   MOVE      '0'           *IN51
      *
      * Read (MACWRKL1) work records untill ALL records for
      *  the frequency are read.
      *
      *         =====================
     C     *IN51         DOUEQ     '1'
      *         =====================
      *
      * Access SUFFIXES & 'Reports For Collation' File (MARCOLL1)
      *  for each Report read
      *
     C     CLRSFX        IFNE      ##RSFX
     C                   MOVE      CLRSFX        ##RSFX
     C                   MOVE      '1'           *IN20
      *
     C*****RCOLK         CHAIN     FCRSFXL1                           5659                  MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRSFX                                                                        MD055265
     C+ from FCRSFJW0                                                                       MD055265
     C+ where DYRNAM = :CLRNAM and DYRSFX = :CLRSFX                                         MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       5659                  MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                          56                  MD055265
     C                   ENDIF                                                              MD055265
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055265
     C                   SETON                                          59                  MD055265
     C                   ENDIF                                                              MD055265
                                                                                            MD055265
      * DB error ??
     C     *IN56         IFEQ      '1'
     C     *IN59         OREQ      '1'
     C     *LOCK         IN        LDA                                                         S0138
     C                   MOVE      'FCRSFXL1'    DBFILE
     C                   MOVEL     RCOL          DBKEY
     C                   Z-ADD     3             DBASE                           *************
     C                   OUT       LDA                                           ************* S0138
     C                   SETON                                        U7U8LR     * DB err 03 *
     C                   RETURN                                                  *************
     C                   END
      *
     C     RCOLK         CHAIN     MARCOLL1                           5656
      *
     C     *IN56         IFEQ      '0'
     C                   MOVEL     D4CRDS        DYPFTX
     C                   END
      *
     C                   END
      *
      ******
      * SDET  -  Write Bureau Header & Detail records for
      *           the Archive-ID/Frequency/Report using the
      *           details from the Collation Work File (MACWRKL1)
      *
     C                   EXSR      SDET
      *
      ********
      *  Read next Collation Work File (MACWRKL1) record
      *  for the Archive-ID/Frequency
      *
     C                   MOVEA     '00'          *IN(01)
     C     CWRKSK        READE     MACWRKL1                             5951
      * File error ??
     C     *IN59         IFEQ      '1'
     C     *LOCK         IN        LDA                                                         S0138
     C                   MOVE      'MACWRKL1'    DBFILE
     C                   MOVEL     CWRK          DBKEY
     C                   Z-ADD     4             DBASE                           *************
     C                   OUT       LDA                                           ************* S0138
     C                   SETON                                        U7U8LR     * DB err 04 *
     C                   RETURN                                                  *************
     C                   END
      *
      * end DO (*in51)
      *         =====================
     C                   END
      *         =====================
      *
     C                   ENDSR
      *
      ***********************************************************
      /EJECT
      ***********************************************************
      *
      * SDET  -  Write Bureau Header & Detail records for
      *           the Archive ID., Frequency and Report.
      *
      *      called by :  SARCH
      *
      ***********************************************************
      *
     C     SDET          BEGSR
      *
      * Write a Bureau HEADER record
      *
     C     *IN20         IFEQ      '1'
     C                   MOVE      '0'           *IN20
      *
      * ( Microfiche   )
     C     EAMEDM        IFEQ      'M'
     C     EAMEDM        OREQ      'B'                                                         S0138
     C                   MOVE      CLARID        MAARID
     C                   MOVE      CLRNAM        MARNAM
     C                   MOVE      CLRSFX        MARSFX
      *
     C                   MOVE      @@DATA        MAADAT
     C                   Z-ADD     @@DATN        MAMDAT
     C                   MOVEL     EAADSC        MAADSC
     C                   MOVE      EADEPT        MADEPT
     C                   MOVEL     DYPFTX        MAPFTX
      *
     C***********          MOVE *BLANKS   OPTD                            S01382
     C***********          MOVELFICH      OPTD                            S01382
     C                   MOVE      *BLANKS       FICD                                          S0138
     C                   MOVEL     FICH          FICD                                          S0138
     C                   WRITE     MAFICDD0
     C                   END                                                                   S0138
      *                                                                   S01382
      * ( Optical Disk )
     C***********          ELSE                                           S01382
      ***********                                                         S01382
     C***********          MOVE CLARID    M1ARID                          S01382
     C***********          MOVE CLRNAM    M1RNAM                          S01382
     C***********          MOVE CLRSFX    M1RSFX                          S01382
      ***********                                                         S01382
     C***********          MOVE CLFMTP    M1FMTP                          S01382
     C***********          MOVE CLPLEN    M1PLEN                          S01382
     C***********          MOVE CLLPI     M1LPI                           S01382
      ***********                                                         S01382
     C***********          MOVE @@DATA    M1ADAT                          S01382
     C***********          Z-ADD@@DATN    M1MDAT                          S01382
     C***********          MOVELEAADSC    M1ADSC                          S01382
     C***********          MOVE EADEPT    M1DEPT                          S01382
     C***********          MOVELDYPFTX    M1PFTX                          S01382
     C***********          MOVELOPTH      OPTD                            S01382
     C***********          WRITEMAOPTDD0                                  S01382
      *                                                                   S01382
     C     EAMEDM        IFEQ      'O'                                                         S0138
     C     EAMEDM        OREQ      'B'                                                         S0138
      *                                                                   S01382
      * Call MA0640 to create header record                               S01382
     C                   MOVE      *BLANKS       IHEAD                                         S0138
     C                   MOVE      'COLL'        OUTPUT                                        S0138
     C**********           MOVE CLRNAM    REPORT                                      S01382 BUG5869
     C                   MOVE      CLRSFX        REPORT
     C                   MOVE      CLRSFX        PRTFNM                                        S0138
     C     *IN56         IFEQ      '0'                                                         S0138
     C                   MOVE      D4CORP        JOBNAM                                        S0138
     C                   END                                                                   S0138
      *                                                                   S01382
     C                   OUT       LDA                                                         S0138
     C                   CALL      'MA0640'                                                    S0138
     C                   PARM                    IHEAD                                         S0138
     C                   PARM                    @RUN              1                           S0138
     C     *LOCK         IN        LDA                                                         S0138
      *                                                                   S01382
      * If error has occurred in called program, exit this program        S01382
     C     @RUN          IFNE      ' '                                                         S0138
     C                   DUMP                                                                  S0138
     C                   SETON                                        U7U8LR                   S0138
     C                   RETURN                                                                S0138
     C                   END                                                                   S0138
      *                                                                   S01382
     C                   MOVE      '*'           ODCCHR                                        S0138
     C                   MOVE      *BLANKS       OPTD                                          S0138
     C                   MOVEL     IHEAD         OPTD                                          S0138
     C                   WRITE     ODBUILD0                                                    S0138
     C                   MOVE      'Y'           RECOUT                                        S0138
     C                   END
      *
     C                   END
      *
      ******
      * Delete Processed Collation record
      *
     C     *IN01         IFEQ      '1'
     C                   DELETE    MACHDRD0                             59
      * File error ??
     C     *IN59         IFEQ      '1'
     C     *LOCK         IN        LDA                                                         S0138
     C                   MOVE      'MACHDRD0'    DBFILE
     C                   MOVEL     CWRK          DBKEY
     C                   Z-ADD     5             DBASE                           *************
     C                   OUT       LDA                                           ************* S0138
     C                   SETON                                        U7U8LR     * DB err 05 *
     C                   RETURN                                                  *************
     C                   END
      * (*in01 End)
     C                   END
      /EJECT
      *
     C     *IN02         IFEQ      '1'
      *
      * Setup DETAIL output fields
      * Write Microfich/Optical-Disk Bureau DETAILS File records
      *
     C***********          MOVE CLCCHR    MACCHR                          S01382
     C***********          MOVE CLRDTL    MARDTL                          S01382
     C***********          MOVE *BLANKS   F00021                          S01382
      *
      * ( Microfiche   )
      *
     C     EAMEDM        IFEQ      'M'
     C     EAMEDM        OREQ      'B'                                                         S0138
     C                   MOVE      CLCCHR        MACCHR                                        S0138
     C                   MOVE      CLRDTL        MARDTL                                        S0138
     C                   WRITE     MAFICDD0
     C                   END                                                                   S0138
      * ( Optical Disk )
     C***********          ELSE                                           S01382
     C***********          WRITEMAOPTDD0                                  S01382
     C     EAMEDM        IFEQ      'O'                                                         S0138
     C     EAMEDM        OREQ      'B'                                                         S0138
     C                   MOVE      *BLANKS       OPTD                                          S0138
     C                   MOVE      CLCCHR        ODCCHR                                        S0138
     C                   MOVEL     CLRDTL        OPTD                                          S0138
     C                   WRITE     ODBUILD0                                                    S0138
     C                   MOVE      'Y'           RECOUT                                        S0138
     C                   END
      *
      * Delete Processed Collation record
      *
     C                   DELETE    MACDTLD0                             59
      * File error ??
     C     *IN59         IFEQ      '1'
     C     *LOCK         IN        LDA                                                         S0138
     C                   MOVE      'MACDTLD0'    DBFILE
     C                   MOVEL     CWRK          DBKEY
     C                   Z-ADD     6             DBASE                           *************
     C                   OUT       LDA                                           ************* S0138
     C                   SETON                                        U7U8LR     * DB err 06 *
     C                   RETURN                                                  *************
     C                   END
      *
      * (*in02 End)
     C                   END
      *
     C                   ENDSR
      ***********************************************************
      /EJECT
**CTDATA PCMD
CPYF FROMFILE(ODBUILD) TOFILE(MAOPTDPD) TOMBR(          ) MBROPT(*ADD    )            S01382 BUG5869
CLRPFM FILE(ODBUILD)                                                      S01382
**CTDATA @CPY
(c) Finastra International Limited 2001
