     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB Task Split Create Components/Dependencies')   *
      *****************************************************************
      *                                                               *
      *  Midas  - Close of Business Processing                        *
      *                                                               *
      *  CB0101 - Task Split - Create Components/Dependencies.        *
      *                                                               *
      *  Function:  This program will duplicate the component records *
      *             for all Task Split sub-tasks where the sub-task   *
      *             component has been selected to run in the COB.    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058986           Date 11Oct21               *
      *  Prev Amend No. MD055891           Date 01Sep20               *
      *                 MD046248           Date 27Oct17               *
      *                 MD037383           Date 25May16               *
      *                 CGL120             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. 120895             Date 16Aug97               *
      *                 CCB003 *Create     Date 10Oct96               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037383 - ACCNTAB blank after COB component GLC008140 00001 *
      *             Stamp Tax (CER049) processing.                    *
      *             Rework that component to make it 'Task Split'     *
      *             compliant.                                        *
      *  CGL120 - GL COB Components Task Split                        *
      *  120895 - Correct the program name in DBPGM                   *
      *  CCB003 - COB Performance Enhancements - Task Split           *
      *                                                               *
      *****************************************************************
     F*CBCMPNLC* IF   E           K DISK    INFSR(*PSSR)                                    MD055891
     FCBCOMSL0  UF A E           K DISK    INFSR(*PSSR)
     FCBDEPSPD  O    E             DISK    INFSR(*PSSR)
     F*CBDPRLL1* IF   E           K DISK    INFSR(*PSSR)                                    MD055891
     F*CBDPRLL2* IF   E           K DISK    INFSR(*PSSR)                                    MD055891
     FCBMUTXL0  UF A E           K DISK    INFSR(*PSSR)
     FCBMUTXL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CBMEXCD0:CBMUTXD0)
     FCB0101AU  O    E             PRINTER USROPN
      ********************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D EX              S              1    DIM(100)                             Execution Parameters
      *
     D UUDS1           DS
     D  UA15A                  1      5
     D  UA11N                  1      1  0                                                        MD
     D  UA22N                  2      2  0
     D  UA35N                  3      5  0
     D  UA45N                  4      5  0
     D  UA44N                  4      4  0                                                        MD
     D  UA55N                  5      5  0
      *
     D UUERR           DS
     D  UUFLD1                 1     10
     D  UUFLD2                11     15
     D  UUFLD3                16     18
      *
     D @CURRC        E DS                  EXTNAME(CBCOMSL0)
      *
     D @OLDRC          DS           270
      *
      ** Program Status Data Structure
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External data structures for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Data Structures used by Access Programs
      *                                                                                       CGL120
     D DSFLDS          DS
     D  UUNQSV                 1      2B 0
     D  UUNQSX                 1      2
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     D                                     PREFIX(X)                                        MD055891
     D CBDPRL        E DS                  EXTNAME(CBDPRJW0)                                MD055891
      ********************************************************************
      ** Rename fields for CBMUTXL1
     ICBMUTXD0
     I              DKCOTT                      WDKCTT
     I              DKCSEQ                      WDKCEQ
     I              DKMEUN                      WDKMUN
     I              DKMECN                      WDKMCN
     I              DKMECS                      WDKMCS
      ********************************************************************
      /EJECT
      ********************************************************************
      *
      ** Initial processing
     C                   EXSR      INIT
      *
      ** Main processing
     C                   Z-ADD     256           UUNQSV
     C                   EXSR      MAIN
      *
      ** End processing
     C                   EXSR      END
      *
      ********************************************************************
      * MAIN - Main Processing
      ********************************************************************
     C     MAIN          BEGSR
      *
     C     KKEY01        KLIST
     C**********         KFLD                    DHCOTT                                     MD055891
     C**********         KFLD                    DHCSEQ                                     MD055891
     C                   KFLD                    XDHCOTT                                    MD055891
     C                   KFLD                    XDHCSEQ                                    MD055891
      *
      ** CBCMPNLC is a logical file for task split components only.
     C**********         READ      CBCMPNLC                               50                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ACursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBCMPJW0                                                              MD055891
     C+ where DHTASK = 'Y'                                                                  MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ACursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBCMPN                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   DOW       SQLCODE = 0                                              MD055891
      *
     C******IN50         DOWEQ     '0'                                                      MD055891
      *
      ** Check if component required today
     C     KKEY01        CHAIN     CBCOMSL0                           54
      *
     C     *IN54         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      DHCOTT        UUFLD1
     C                   MOVE      DHCSEQ        UUFLD2
     C                   MOVEL     'CBCOMSL0'    DBFILE                         ************
     C                   MOVEL     UUERR         DBKEY                          * DBERR 01 *
     C                   Z-ADD     1             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** The number of Task Split jobs must be at least one
     C     DHTSNO        IFEQ      0
     C     *LOCK         IN        LDA
     C                   MOVE      DHCOTT        UUFLD1
     C                   MOVE      DHCSEQ        UUFLD2
     C                   MOVEL     'CBCOMSL0'    DBFILE                         ************
     C                   MOVEL     UUERR         DBKEY                          * DBERR 08 *
     C                   Z-ADD     8             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Process if component required today
     C     DHCRQD        IFEQ      'Y'
     C                   EXSR      TODAY
     C                   ENDIF
      *
     C**********         READ      CBCMPNLC                               50                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBCMPN                                                MD055891
     C/END-EXEC                                                                             MD055891
      *
     C                   ENDDO
      *
     C/EXEC SQL                                                                             MD055891
     C+ close ACursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   ENDSR
      ********************************************************************
      * TODAY - Processing for components running today
      ********************************************************************
     C     TODAY         BEGSR
      *
      ** Save original values for future chains
     C                   MOVE      DHCOTT        SAVNAM
     C                   MOVE      DHCSEQ        SAVSEQ
     C                   MOVE      DHCPRM        SAVPRM
      *
     C                   Z-ADD     1             UCOUNT            3 0
      *
      ** Loop the number of task split jobs minus 1
     C     DHTSNO        SUB       1             UTIMES            3 0
      *
     C**********           DO   UTIMES                                                        CGL120
     C                   DO        UTIMES        I                 5 0
      *
      ** Create CBCOMSL0 record
     C                   EXSR      CRTREC
      *
      ** Create 'dependent upon' CBDEPSPD record.
     C                   EXSR      SRDEP1
      *
      ** Create 'depending upon' CBDEPSPD record.
     C                   EXSR      SRDEP2
      *
      ** Check mututally exclusive components
     C                   EXSR      SRMEXC
      *
      ** Update CBCOMSL0 record
     C                   MOVEL(P)  @CURRC        @OLDRC
     C                   EXSR      SRCOMA
     C                   MOVEL(P)  @OLDRC        @CURRC
      *
     C                   ADD       1             UCOUNT
      *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      * CRTREC - Write CBCOMSL0 record
      ********************************************************************
     C     CRTREC        BEGSR
      *
      ** Increment Component Sequence number
     C                   MOVE      DHCSEQ        UA15A
     C********** UA22N     IFEQ 0                                                           MD037383
     C     I             IFEQ      1
     C/COPY WNCPYSRC,CB0101C001
     C********** UA45N     IFEQ 1                                                             CGL120
     C     UA55N         IFLE      9
     C**********           Z-ADD1         UA22N                                               CGL120
     C     UA44N         IFEQ      0
     C                   Z-ADD     UA55N         UA22N
     C                   Z-ADD     1             UA55N
     C                   ELSE
     C                   Z-ADD     UA44N         UA11N
     C                   Z-ADD     UA55N         UA22N
     C                   Z-ADD     0             UA44N
     C                   Z-ADD     1             UA55N
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     2             UA22N
     C                   ENDIF
     C/COPY WNCPYSRC,CB0101C002
     C                   ELSE
     C                   ADD       1             UA35N
     C                   ENDIF
     C                   MOVE      UA15A         DHCSEQ
      *
      ** Change the number of outstanding dependencies
     C                   Z-ADD     1             DHCODP
      *
      ** Establish execution parameters
     C                   MOVEA(P)  SAVPRM        EX
      *
      ** Scan for the first blank
     C     ' '           SCAN      SAVPRM        #A                3 0    55
      *
     C     *IN55         IFEQ      '0'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CBCOMSL0'    DBFILE                         ************
     C                   MOVEL     SAVPRM        DBKEY                          * DBERR 02 *
     C                   Z-ADD     2             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** There may be 1 or more blanks - scan for the beginning of hex
     C     'X'           SCAN      SAVPRM:#A     #B                3 0    56
      *
     C     *IN56         IFEQ      '0'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CBCOMSL0'    DBFILE                         ************
     C                   MOVEL     SAVPRM        DBKEY                          * DBERR 03 *
     C                   Z-ADD     3             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Replace component sequence in execution parameters
     C                   ADD       2             #B
     C                   MOVEA     DHCSEQ        EX(#B)
     C                   MOVEA(P)  EX            DHCPRM
      *
      ** Write CBCOMSL0 record
     C                   WRITE     @DHREGG
      *
     C                   ENDSR
      ********************************************************************
      * SRDEP1 - Write 'dependent upon' CBDEPSPD record
      ********************************************************************
     C     SRDEP1        BEGSR
      *
      ** Use the Component Name/Sequence Number to obtain the
      ** DEPENDENT UPON component from CBDPRLL1.
      *
     C                   MOVE      '001'         UONE              3
      *
     C     KKEY02        KLIST
     C                   KFLD                    SAVNAM                         Component Name
     C                   KFLD                    SAVSEQ                         Component Sequence N
     C                   KFLD                    UONE                           Always '001'
      *
     C*****KKEY02        CHAIN     CBDPRLL1                           51                    MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBDPRL                                                                        MD055891
     C+ from CBDPRJW0                                                                       MD055891
     C+ where DIDSON = :SAVNAM and DIDSOS = :SAVSEQ and DIDRUN = :UONE                      MD055891
     C/END-EXEC                                                                             MD055891
     C                   SETOFF                                       51                    MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        51                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
      *
     C     *IN51         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      SAVNAM        UUFLD1
     C                   MOVE      SAVSEQ        UUFLD2
     C                   MOVE      UONE          UUFLD3
     C                   MOVEL     'CBDPRLL1'    DBFILE                         ************
     C                   MOVEL     UUERR         DBKEY                          * DBERR 04 *
     C                   Z-ADD     4             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      DHCSEQ        DIDSOS
     C                   MOVE      '001'         DIDRUN
      *
     C                   WRITE     CBDPRLD0
      *
     C                   ENDSR
      ********************************************************************
      * SRDEP2 - Write 'depending upon' CBDEPSPD record
      ********************************************************************
     C     SRDEP2        BEGSR
      *
      ** Use the Component Name/Sequence Number to obtain the
      ** DEPENDING UPON component from CBDPRLL2.
      *
     C     KKEY03        KLIST
     C                   KFLD                    SAVNAM                         Component Name
     C                   KFLD                    SAVSEQ                         Component Sequence N
      *
     C*****KKEY03        CHAIN     CBDPRLL2                           52                    MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBDPRL                                                                        MD055891
     C+ from CBDPRJW0                                                                       MD055891
     C+ where DIDDON = :SAVNAM and DIDDOS = :SAVSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        52                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
      *
     C     *IN52         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      SAVNAM        UUFLD1
     C                   MOVE      SAVSEQ        UUFLD2
     C                   MOVEL     'CBDPRLL2'    DBFILE                         ************
     C                   MOVEL     UUERR         DBKEY                          * DBERR 05 *
     C                   Z-ADD     5             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Increment the Unique number by 1
     C                   MOVE      DHCSEQ        DIDDOS
     C                   MOVE      UCOUNT        DIDRUN
      *
     C                   WRITE     CBDPRLD0
      *
     C                   ENDSR
      ********************************************************************
      * SRMEXC - Check for mututally exclusive component
      ********************************************************************
     C     SRMEXC        BEGSR
      *
     C     KKEY05        KLIST
     C                   KFLD                    SAVNAM
     C                   KFLD                    SAVSEQ
     C     KKEY06        KLIST
     C                   KFLD                    UCNAME
     C                   KFLD                    USEQN
     C**********           KFLD           UUNIQ                                               CGL120
     C                   KFLD                    UMECN
     C                   KFLD                    UMECS
      *                                                                                       CGL120
     C     KKEY07        KLIST
     C                   KFLD                    UCNAME
     C                   KFLD                    USEQN
      *
     C                   MOVE      SAVNAM        UCNAME
     C                   MOVE      SAVSEQ        USEQN
      *
     C     KKEY05        SETLL     CBMUTXL1
     C     KKEY05        READE     CBMUTXL1                               57
      *
     C     *IN57         DOWEQ     '0'
      *
      ** Write a new record with component on left-hand side
      ** only if record does not already exist
      *
     C                   MOVE      SAVNAM        UCNAME
     C                   MOVE      DHCSEQ        USEQN
     C**********           MOVE WDKMUN    UUNIQ                                               CGL120
     C                   MOVE      WDKMCN        UMECN
     C                   MOVE      WDKMCS        UMECS
      *                                                                                       CGL120
     C     KKEY06        CHAIN(N)  CBMUTXL0                           58
      *
      ** Load fields with renamed versions from CBMUTXL1
      *
     C     *IN58         IFEQ      '1'
     C                   MOVE      WDKCTT        DKCOTT
     C                   MOVE      DHCSEQ        DKCSEQ
     C**********           MOVE WDKMUN    DKMEUN                                              CGL120
     C                   ADD       1             UUNQSV
     C                   MOVE      UUNQSX        DKMEUN
     C                   MOVE      WDKMCN        DKMECN
     C                   MOVE      WDKMCS        DKMECS
      *
     C                   WRITE     CBMEXCD0
     C                   ENDIF
      *
      ** Write a new record with component on right hand side
      ** only if record does not already exist
      *
     C                   MOVE      WDKMCN        UCNAME
     C                   MOVE      WDKMCS        USEQN
     C**********           Z-ADD0         UUNQSV                                              CGL120
     C                   MOVE      '0'           *IN59
      *
     C                   Z-ADD     0             WKNQSV            2 0
     C     KKEY07        SETLL     CBMUTXL0
     C     KKEY07        READE(N)  CBMUTXL0                               58
      *
      ** Search for mutually exclusive record that relates to the
      ** task split component being duplicated
      *
     C     *IN58         DOWEQ     '0'
     C**********           MOVE DKMEUN    UUNQSV  20                                          CGL120
     C     DKMECN        IFEQ      SAVNAM
     C     DKMECS        ANDEQ     DHCSEQ
     C                   MOVEA     '11'          *IN(58)
     C                   ENDIF
     C     *IN58         IFEQ      '0'
     C     KKEY07        READE(N)  CBMUTXL0                               58
     C                   ENDIF
     C                   ENDDO
      *
      ** Indicator 59 denotes that no mutually exclusive record
      ** was found for the details on the right hand side of the
      ** previously written M.E. record.(at least not one where
      ** the right hand side fields were for the component being
      ** duplicated)
      *
     C     *IN59         IFEQ      '0'
     C                   MOVE      UCNAME        DKCOTT
     C                   MOVE      USEQN         DKCSEQ
     C                   ADD       1             UUNQSV
     C**********           MOVE UUNQSV    DKMEUN                                              CGL120
     C                   MOVE      UUNQSX        DKMEUN
      *                                                                                       CGL120
      ** Check that record key is unique                                                      CGL120
      *                                                                                       CGL120
     C                   MOVE      DKCOTT        UCNAME
     C                   MOVE      DKCSEQ        USEQN
     C                   MOVE      DKMEUN        UUNIQ
     C     KKEY06        CHAIN(N)  CBMUTXL0                           58
     C     *IN58         DOWEQ     *OFF
     C                   ADD       1             UUNQSV
     C                   MOVE      UUNQSX        DKMEUN
     C                   MOVE      DKMEUN        UUNIQ
     C     KKEY06        CHAIN(N)  CBMUTXL0                           58
     C                   ENDDO
      *                                                                                       CGL120
     C                   MOVE      SAVNAM        DKMECN
     C                   MOVE      DHCSEQ        DKMECS
      *
     C                   WRITE     CBMEXCD0
     C                   ENDIF
      *
     C     KKEY05        READE     CBMUTXL1                               57
      *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      * SRCOMA - Amend CBCOMSL0 record.
      ********************************************************************
     C     SRCOMA        BEGSR
      *
     C     KKEY04        KLIST
     C                   KFLD                    DIDSON
     C                   KFLD                    DIDSOS
      *
     C     KKEY04        CHAIN     CBCOMSL0                           53
      *
     C     *IN53         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      DIDSON        UUFLD1
     C                   MOVE      DIDSOS        UUFLD2
     C                   MOVEL     'CBCOMSL0'    DBFILE                         ************
     C                   MOVEL     UUERR         DBKEY                          * DBERR 06 *
     C                   Z-ADD     6             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Add 1 to value of oustanding dependencies
     C                   ADD       1             DHCODP
      *
     C                   UPDATE    @DHREGG
      *
     C                   ENDSR
      ********************************************************************
      * INIT - Initialisation
      ********************************************************************
     C     INIT          BEGSR
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
     C     *DTAARA       DEFINE                  LDA
      *
      ** Define work fields
     C     *LIKE         DEFINE    DHCOTT        SAVNAM
     C     *LIKE         DEFINE    DHCSEQ        SAVSEQ
     C     *LIKE         DEFINE    DHCOTT        UCNAME
     C     *LIKE         DEFINE    DHCSEQ        USEQN
     C     *LIKE         DEFINE    DKMEUN        UUNIQ
     C     *LIKE         DEFINE    DHCPRM        SAVPRM
     C     *LIKE         DEFINE    DKMECN        UMECN
     C     *LIKE         DEFINE    DKMECS        UMECS
      *
      ** Retrieve Bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     WOPTN         DBKEY                          * DBERR 07 *
     C                   Z-ADD     7             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,CB0101C003
      *
     C                   ENDSR
      ********************************************************************
      * END - Terminate
      ********************************************************************
     C     END           BEGSR
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
      * *PSSR - Output Audit report and End Program.
      ********************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C***********          MOVEL'RE1132'  DBPGM     P                     120895
     C                   MOVEL(P)  'CB0101'      DBPGM                                         12089
      *
     C                   OPEN      CB0101AU
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
     C                   CLOSE     CB0101AU
     C                   OUT       LDA
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
** CPY@ - Object copyright
(c) Finastra International Limited 2001
