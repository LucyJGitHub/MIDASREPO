     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas MA Split archive contents for colln')
/*OVRF*: OVRDBF ODBUILD  MAOPTDPD                                   : *   S01382
      *****************************************************************
      *                                                               *
      *  Midas - Microfiche/Optical Disk Archiving Module             *
      *                                                               *
      *  MA0600 - SPLIT ARCHIVE CONTENTS FOR COLLATION                *
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
      *                 S01382             Date 31Jul92               *
      *                  E29281            Date 23Oct91               *
      *                     LN1100   DATE - 17JAN90                   *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  BUG5869 - For archiving from outq, assign entity details as  *
      *            held by RCF; for archiving on request, report name *
      *            should include suffix.                             *
      *     S01382 - OPTICAL DISK DEVELOPMENT                         *  *
      *     E29281 - OUTPUT '1*$*$' TO THE OPTICAL DISK HEADER RECORD *  *
      *     LN1100 - WRITE CORRECT KEY TO THE COLLATION               *
      *                DETAIL FILE MACDTLPD                           *
      *                                                               *
      *****************************************************************
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
      * FUNCTION OF INDICATORS
      *
      *      U7,U8 Database Error
      *   10       EOF on MAMWRKL0 or MAOWRKL0
      *   11       Microfiche Processing
      *   12       Write Bureau Header Record
      *   13       Write Collation Header Record
      *   15       EOF on MAAWRKPD
      *   17       File access error on MAARCHL1 or FCREFXL1
      *   20       Valid Collation Frequency
      *   50       Chain fail on MAOHDRL0                                 S01382
      *
      *****************************************************************
     FMAMWKYL0  IF   E           K DISK
     FMAOWKYL0  IF   E           K DISK
      *
     FMAAWKYPD  IF   E             DISK
      *
     F*FCRSFXL1* IF   E           K DISK                                                    MD055265
     FMAARCHL1  IF   E           K DISK
      *
     FMACHDRPD  O    E             DISK
     FMACDTLPD  O    E             DISK
     FMAFICDPD  O    E             DISK
     F***********MAOPTDPDO   E                    DISK                    S01382
     FODBUILD   IF A E             DISK    USROPN                               S01382
     F                                     RENAME(MAOPTDD0:ODBUILD0)            S01382
     FMAOHDRL0  UF   E           K DISK                                         S01382
     F/EJECT
     D FRQ             S              1    DIM(12) CTDATA PERRCD(12)            COLLATE FREQ.
     D @CPY            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D FICH          E DS                  EXTNAME(MAFICHPD)
      ** Microfiche Header Record layout
      *
     D FICD          E DS                  EXTNAME(MAFICDPD)                    S01382
     D***********OPTH      E DSMAOPTHPD                                   S01382
      ***Optical*Disk*Header*Record*layout                                S01382
      *
     D***********OPTD      E DSMAOPTDPD                                   S01382
     D DSOPTD        E DS                  EXTNAME(ODBUILD)                     S01382
     D  ODCCHR       E                     EXTFLD(MACCHR)                       S01382
     D  OPTD         E                     EXTFLD(ODRDTL)                       S01382
      ** Optical Disk Detail Record layout
      *
     D AWRK            DS           133
      ** Report Detail Line (MAAWKYPD)  data-structure
      *
     D  FCFC                   1      1
     D  REST                   2    133
     D  REST1                  2      2
     D  @@CLSC                 3     22
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
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      **  EXTERNAL DS FOR Module Status
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D IHEAD           DS                                                       S01382
      ** Internal header record data structure                            S01382
      *                                                                   S01382
     D  HEADER                 1    198                                         S01382
     D  OUTPUT                 1      4                                         S01382
     D  REPORT                 5     14                                         S01382
     D  PRTFNM                54     63                                         S01382
      *                                                                   S01382
     D                 DS                                                       S01382
      * Data structure for copy file                                      S01382
     D  PCMD                   1    148                                         S01382
     D                                     DIM(2) CTDATA PERRCD(1)                               S01
     D  @TOMBR                47     56                                         S01382
     D FCRSFX        E DS                  EXTNAME(FCRSFJW0)                                MD055265
     IMAMWRKD0
     I              EDARID                      EFARID
     I              EDRNAM                      EFRNAM
     I              EDRQSQ                      EFRQSQ
     I              EDRSFX                      EFRSFX
     I              EDFRCD                      EFFRCD
     I              EDLRCD                      EFLRCD
     IODBUILD0                                                                  S01382
     I              MACCHR                      ODCCHR                          S01382
     I              ODRDTL                      OPTD                            S01382
      *                                                                   S01382
     C                   MOVEA     @CPY          @BIS             80
      /EJECT
      *
      * Key for the FCRSFXL1 file
      *
     C     RSFXK         KLIST
     C                   KFLD                    EFRNAM
     C                   KFLD                    EFRSFX
      *
      ** Define MIDAS data areas, LDA and RUNDAT
      *
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      * Setup work fields
      *
     C     *LIKE         DEFINE    @@CLSC        HRCLSC                                        LN110
     C     *LIKE         DEFINE    EFARID        ##ARID
     C     *LIKE         DEFINE    EFRSFX        ##RSFX
     C                   MOVE      *BLANKS       ##ARID
     C                   MOVE      *BLANKS       ##RSFX
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
     C                   MOVE      *BLANKS       LDA
     C***********          MOVE 'MA0600'  DBPGM                           S01382
     C                   MOVEL     'MA0600'      DBPGM                                         S0138
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
      ** Call program 'AOMMODR0' to access the Module Status
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       RTCD              7
     C                   PARM      '*FIRST '     OPTN              7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      /EJECT
      *
      * Check for errors
      *
     C     RTCD          IFNE      *BLANKS
     C     *LOCK         IN        LDA                                                         S0138
     C                   MOVE      'SDMMODPD'    DBFILE                         ************
     C                   MOVE      OPTN          DBKEY                          * DBERR 01 *
     C                   Z-ADD     1             DBASE                          ************
     C                   OUT       LDA                                                         S0138
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
      *
      * Process Microfiche requests
      *
     C     BGMFIC        CASEQ     'Y'           SREAD                    11
     C                   END
      *
      * Process Optical Disk requests
      *
     C                   MOVEA     '00'          *IN(10)                        *In 10 & 11
     C                   MOVE      *BLANKS       ##ARID                                        S0138
      *
     C     BGOPDK        CASEQ     'Y'           SREAD
     C                   END
      *                                                                   S01382
      * Close PF/ODBUILD at end of program                                S01382
     C                   CLOSE     ODBUILD                                                     S0138
      * End Of Pgm
     C                   MOVE      '1'           *INLR
      *
      ***********************************************************
      /EJECT
      ***********************************************************
      *
      * SREAD -  Process Microfiche and/or Optical Disk  requests
      *=========
      *      called by :  Mainline processing
      *
      *      calls     :  COLL   - Collate REPORT details
      *                   ARCG   - Archive REPORT details
      *
      ***********************************************************
      *
     C     SREAD         BEGSR
      *
      ***
      * Read ( Microfiche   ) work records untill E.O.F reached
      *      ( Optical Disk )
      *
     C     *IN10         DOUEQ     '1'
      *
      * ( Microfiche   )
     C     *IN11         IFEQ      '1'
     C                   READ      MAMWRKD0                             1010
      * ( Optical Disk )
     C                   ELSE
     C                   READ      MAOWRKD0                             1010
      *                                                                   S01382
      * On change of Archive ID or at end of file                         S01382
     C     EFARID        IFNE      ##ARID                                                      S0138
     C     ##ARID        ANDNE     *BLANKS                                                     S0138
     C     *IN10         OREQ      '1'                                                         S0138
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
      *                                                                   S01382
     C                   END
      *
      ***
      * Archive/Collate REPORT details for each work record read
      ***
      *         =====================
     C     *IN10         IFEQ      '0'
      *         =====================
      *
      * Set up RRN for the chain to Archive Work File (MAAWRKPD)
      *
     C     EFFRCD        SUB       1             @@RRN            15 0
     C                   Z-ADD     0             @PAGE             4 0
     C                   MOVEA     '00'          *IN(12)                        *IN12 *IN13
      /EJECT
      *
      ***
      * Access Archive Description
      *
     C     EFARID        IFNE      ##ARID
     C                   MOVE      EFARID        ##ARID
     C     EFARID        CHAIN     MAARCHL1                           1717
     C     *IN17         IFEQ      '1'
     C     *LOCK         IN        LDA                                                         S0138
     C                   MOVE      'MAARCHL1'    DBFILE                         ************
     C                   MOVEL     EFARID        DBKEY                          * DBERR 02 *
     C                   Z-ADD     2             DBASE                          ************
     C                   OUT       LDA                                                         S0138
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
     C                   END
      *
      ***
      * Access Report Description
      *
     C     EFRSFX        IFNE      ##RSFX
     C                   MOVE      EFRSFX        ##RSFX
     C*****RSFXK         CHAIN     FCRSFXL1                           1717                  MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRSFX                                                                        MD055265
     C+ from FCRSFJW0                                                                       MD055265
     C+ where DYRNAM = :EFRNAM and DYRSFX = :EFRSFX                                         MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                         17                  MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                          17                  MD055265
     C                   ENDIF                                                              MD055265
                                                                                            MD055265
     C     *IN17         IFEQ      '1'
     C     *LOCK         IN        LDA                                                         S0138
     C                   MOVE      'FCRSFXL1'    DBFILE                         ************
     C                   MOVEL     EFRNAM        #WRK20           20            * DBERR 03 *
     C                   MOVE      EFRSFX        #WRK20                         ************
     C                   MOVEL     #WRK20        DBKEY
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA                                                         S0138
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
     C                   END
      *                                                                   S01382
      * Initialise Archived to Optical Disk flag                          S01382
      *                                                                   S01382
     C                   MOVE      'N'           @ARCOD            1                           S0138
      *
      ***
      * Position Archive Work File to the first record
      *  with a Control Character (FCFC) equal to '1'.
      *
     C     FCFC          DOUEQ     '1'
     C     *IN15         OREQ      '1'
      *
     C                   ADD       1             @@RRN
     C     @@RRN         CHAIN     MAAWKYPD                           1515
     C                   END
      /EJECT
      *
      ***
      * READ 'Archive Work File' untill EOF, or last record for
      *  the REPORT has been read.
      *
     C     EFLRCD        DOWGE     @@RRN
     C     *IN15         ANDEQ     '0'
      *
      *
      * Save Archive/Collate indicator for each page read.
      *
      * NOTE : The page will be collated, if the first char
      *        fo the first line is a valid Collation Frequency
      *        and this Report has a collation flag set to 'Y'.
      *
     C     FCFC          IFEQ      '1'
     C                   MOVE      ' '           A@C
      *
     C     DYCOLT        IFEQ      'Y'
      *
     C                   Z-ADD     1             I                 2 0
     C     REST1         LOOKUP    FRQ(I)                                 20
      *
     C     *IN20         IFEQ      '1'
     C                   MOVE      REST1         A@C               1
     C                   END
      *
     C                   ADD       1             @PAGE
     C                   END
     C                   END
      *
      ****
      * Process REPORT details .....
      * ...Collate
     C     A@C           CASNE     ' '           COLL
      * ...Archive
     C                   CAS                     ARCH
     C                   END
      *
      ***
      * Read next 'Archive Work File' record
      *
     C                   ADD       1             @@RRN
      *
     C     EFLRCD        IFGE      @@RRN
     C     @@RRN         CHAIN     MAAWKYPD                           1515
     C                   END
      *
      * DOU end (EOF, MAAWRKPD)
      *
     C                   END
      *                                                                   S01382
      * If processing request to archive to Optical Disk                  S01382
     C     @ARCOD        IFEQ      'Y'                                                         S0138
      *                                                                   S01382
      * If record found on LF/MAOHDRL0 AND Archived Today flag not 'Y',   S01382
      * update Archived Today flag to 'Y'                                 S01382
     C     *IN50         IFEQ      '0'                                                         S0138
     C     @ATDAY        ANDNE     'Y'                                                         S0138
     C                   MOVE      'Y'           ATODAY                                        S0138
     C                   UPDATE    MAOHDRD0                                                    S0138
     C                   END                                                                   S0138
     C                   END                                                                   S0138
      *                                                                   S01382
      * IF end (*in10=0)
      *             =================
     C                   END
      *             =================
      * DOU end (*in10 ueq 1)
      *
     C                   END
      *
     C                   ENDSR
      ***********************************************************
      /EJECT
      ***********************************************************
      *
      * COLL  -  Collate REPORT details.
      *          Write REPORT header/detail to the Collation files
      *
      *      called by :  SREAD
      *
      ***********************************************************
      *
     C     COLL          BEGSR
      *********
      * Write COLLATION HEADER file record
      *  for the ARCH-ID/REPORT/SEQ/PRTF.
      *
     C     *IN13         IFEQ      '0'
     C                   MOVE      '1'           *IN13
      *
      * Setup Collation File output fields
      *
     C                   MOVE      EFARID        CLARID
     C                   MOVE      FRQ(I)        CLCFRQ
     C                   MOVE      @@CLSC        CLCLSC
     C                   MOVE      @@CLSC        HRCLSC                                        LN110
     C                   MOVE      EFRNAM        CLRNAM
     C                   MOVE      EFRQSQ        EDRQSQ
     C                   MOVE      EFRSFX        CLRSFX
     C                   MOVE      @@DATA        CLCRDT
     C                   Z-ADD     @PAGE         CLCRPG
     C                   MOVE      *BLANKS       CLFMTP
     C                   Z-ADD     0             CLPLEN
     C                   Z-ADD     0             CLLPI
      * ( Optical Disk )
     C     *IN11         IFEQ      '0'
     C                   MOVE      EFFMTP        CLFMTP
     C                   MOVE      EFPLEN        CLPLEN
     C                   MOVE      EFLPI         CLLPI
     C                   END
      *
      * Write Collation Work File HEADER
      *
     C                   WRITE     MACHDRD0
     C                   END
      *********
      * Write Collation Work File DETAILS
      *
      * Write the Collation Sort Code stored from the header above        LN1100
     C*********            MOVE @@CLSC    CLCLSC                          LN1100
     C                   MOVE      HRCLSC        CLCLSC                                        LN110
     C                   MOVE      FCFC          CLCCHR
     C                   MOVEL     REST          CLRDTL
      *
     C                   WRITE     MACDTLD0
      *
     C                   ENDSR
      ***********************************************************
      /EJECT
      ***********************************************************
      *
      * ARCH  -  Archive REPORT details.
      *    Write REPORT SPLF information to the M/O-Buro Header
      *    Write REPORT details to the M/O-Buro Details File
      *
      *      called by :  SREAD
      *
      ***********************************************************
      *
     C     ARCH          BEGSR
      *
      *********
      * Write Microfich/Optical-Disk Buro HEADER file record
      *  for the ARCH-ID/REPORT/SEQ/PRTF.
      *
     C     *IN12         IFEQ      '0'
     C                   MOVE      '1'           *IN12
      *
      * Write HEADER
      *
      * ( Microfiche   )
     C     *IN11         IFEQ      '1'
     C                   MOVE      EFARID        MAARID
     C                   MOVE      EFRNAM        MARNAM
     C                   MOVEL     EAADSC        MAADSC
     C                   MOVE      EADEPT        MADEPT
     C                   MOVE      EFRSFX        MARSFX
     C                   MOVE      @@DATA        MAADAT
     C                   Z-ADD     @@DATN        MAMDAT
     C                   MOVEL     DYPFTX        MAPFTX
      *
     C***********          MOVE *BLANKS   OPTD                            S01382
     C***********          MOVELFICH      OPTD                            S01382
     C                   MOVE      *BLANKS       FICD                                          S0138
     C                   MOVEL     FICH          FICD                                          S0138
     C                   WRITE     MAFICDD0
      * ( Optical Disk )
     C                   ELSE
      *
     C***********          MOVE EFARID    M1ARID                          S01382
     C***********          MOVE EFRNAM    M1RNAM                          S01382
     C***********          MOVELEAADSC    M1ADSC                          S01382
     C***********          MOVE EADEPT    M1DEPT                          S01382
     C***********          MOVE EFRSFX    M1RSFX                          S01382
     C***********          MOVE @@DATA    M1ADAT                          S01382
     C***********          Z-ADD@@DATN    M1MDAT                          S01382
     C***********          MOVE EFFMTP    M1FMTP                          S01382
     C***********          MOVE EFPLEN    M1PLEN                          S01382
     C***********          MOVE EFLPI     M1LPI                           S01382
     C***********          MOVELDYPFTX    M1PFTX                          S01382
      ***********                                                         S01382
     C***********          MOVE *BLANKS   OPTD                            S01382
     C***********          MOVELOPTH      OPTD                            S01382
     C***********          WRITEMAOPTDD0                                  S01382
      *                                                                   S01382
      * Access LF/MAOHDRL0 to determine if a header has already been      S01382
      * produced                                                          S01382
     C                   MOVEL     EFRQSQ        OHDRK             9                           S0138
     C                   MOVE      EFSPFN        OHDRK                                         S0138
      *                                                                   S01382
     C     OHDRK         CHAIN     MAOHDRL0                           50                       S0138
      *                                                                   S01382
      * Set Archived to Optical Disk flag to 'Y'                          S01382
     C                   MOVE      'Y'           @ARCOD                                        S0138
      *                                                                   S01382
      * If no header exists, call MA0640 to create one                    S01382
     C     *IN50         IFEQ      '1'                                                         S0138
     C                   MOVE      *BLANKS       IHEAD                                         S0138
     C                   MOVE      'RCFR'        OUTPUT                                        S0138
     C**********           MOVE EFRNAM    REPORT                                      S01382 BUG5869
     C                   MOVE      EFRSFX        REPORT
     C                   MOVE      EFRSFX        PRTFNM                                        S0138
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
     C                   MOVE      ' '           @ATDAY            1                           S0138
     C                   ELSE                                                                  S0138
     C                   MOVE      ATODAY        @ATDAY                                        S0138
     C                   END                                                                   S0138
      *                                                                   S01382
      * If header has been produced by MA0640                             S01382
      * OR header already existed on PF/MAOHDRPD and Archive Today flag   S01382
      * not equal to 'Y'                                                  S01382
     C     *IN50         IFEQ      '1'                                                         S0138
     C     *IN50         OREQ      '0'                                                         S0138
     C     @ATDAY        ANDNE     'Y'                                                         S0138
      *                                                                   S01382
      * Write header to temporary file PF/ODBUILD                         S01382
     C                   MOVE      '*'           ODCCHR                                        S0138
     C                   MOVE      *BLANKS       OPTD                                          S0138
     C                   MOVEL     IHEAD         OPTD                                          S0138
     C                   WRITE     ODBUILD0                                                    S0138
     C                   MOVE      'Y'           RECOUT                                        S0138
     C                   END                                                                   S0138
      *                                                                   S01382
      * IF end (*in11)
     C                   END
      * IF end (*in12 = 0)
     C                   END
      /EJECT
      *
      *********
      * Setup DETAIL output fields
      * Write Microfich/Optical-Disk Buro DETAILS File records
      * NB. Only write Optical Disk records if report has not already     S01382
      *     been archived today                                           S01382
     C     *IN11         IFEQ      '1'                                                         S0138
     C     *IN11         OREQ      '0'                                                         S0138
     C     @ATDAY        ANDNE     'Y'                                                         S0138
      *
     C***********          MOVE FCFC      MACCHR                          S01382
     C***********          MOVELREST      MARDTL                          S01382
      *
      * ( Microfiche   )
      *
     C     *IN11         IFEQ      '1'
     C                   MOVE      FCFC          MACCHR                                        S0138
     C                   MOVEL     REST          MARDTL                                        S0138
     C                   WRITE     MAFICDD0
      * ( Optical Disk )
     C                   ELSE
     C***********          MOVE *BLANKS   F00021                          S01382
     C                   MOVE      *BLANKS       OPTD                                          S0138
     C                   MOVE      FCFC          ODCCHR                                        S0138
     C                   MOVEL     REST          OPTD                                          S0138
     C***********          WRITEMAOPTDD0                                  S01382
     C                   WRITE     ODBUILD0                                                    S0138
     C                   MOVE      'Y'           RECOUT                                        S0138
     C                   END
     C                   END                                                                   S0138
      *
     C                   ENDSR
      ***********************************************************
**CTDATA PCMD
CPYF FROMFILE(ODBUILD) TOFILE(MAOPTDPD) TOMBR(          ) MBROPT(*REPLACE)S01382
CLRPFM FILE(ODBUILD)                                                      S01382
**CTDATA FRQ
ABDYZ1234567
**CTDATA @CPY
(c) Finastra International Limited 2001
