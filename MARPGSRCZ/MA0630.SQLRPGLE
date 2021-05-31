     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas MA Archiving audit/exceptions report')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Microfiche/Optical Disk Archiving Module
     F*                                                               *
     F*  MA0630 - ARCHIVING AUDIT REPORT                              *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*      LTD. 1990, 1991                                          *
     F*                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 083764             Date 26Sep95               *
      *                 062963             Date 24Jan94               *
     F*                 056401             DATE 21JAN94               *
     F*                 S01382             DATE 07AUG92               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
     F*  083764 - Use system-defined line counter to determine if     *
     F*           new page required for 'End of Report'               *
     F*  062963 - Ensure that overflow will not occur when doing      *
     F*           a write to file MA0630P1 at lines 22900 & 43000.    *
     F*  056401 - Remove OVRDBF as MAOPTFPD will be residing in       *
     F*           the DP library.                                     *
     F*  S01382 - OPTICAL DISK DEVELOPMENT                            *
     F*           PRODUCE ARCHIVE AUDIT REPORT IN ARCHIVE ID          *
     F*           SEQUENCE AND ALPHABETICALLY IN REPORT SEQUENCE      *
     F*                                                               *
     F*****************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
/****F*:*OVRDBF*MAOPTFPD*MAOPTDPD*************************:*****S01382*   056401
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  FUNCTION OF INDICATORS                                       *
     F********01  MAFICDD0 READ                                       *   S01382
     F********02  MAOPTDD0 READ                                       *   S01382
     F********10  UNSUCCESSFUL READ TO MABUROL0                       *   S01382
     F*       10  UNSUCCESSFUL READ TO MAFICDL0                       *   S01382
     F*       11  UNSUCCESSFUL READ TO MAOPTFPD                       *   S01382
     F*       15  UNSUCCESSFUL CHAIN OF MAARCHL2                      *
     F*       16  UNSUCCESSFUL CHAIN OF MAREPTL1                      *   S01382
     F*       20  UNSUCCESSFUL READ TO MAEXPYL1                       *
     F*       50  FIRST CYCLE *IN50 OFF                               *   S01382
     F*                                                               *
     F*                                                               *
     F*****************************************************************
     F***MABUROL0IF  E           K        DISK                            S01382
     FMAFICDL0  IF   E           K DISK                                         S01382
     FMAOPTFPD  IF   E             DISK                                         S01382
     F*FCREPTL1* IF   E           K DISK                                         S01382     MD055265
     FMAARCHL3  IF   E           K DISK
     FMAEXPYL1  IF   E           K DISK
     FMA0630P1  O    E             PRINTER INFDS(SPOOL1)
     FMA0630P2  O    E             PRINTER INFDS(SPOOL2)
     FMA0630AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D***MAFICDD0    01                                                   S01382
     D***MAOPTDD0    02                                                   S01382
      *
     D LDA             DS           256
      *    STANDARD LOCAL DATA AREA FIELDS
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D SPOOL1          DS
      ** SPOOL INFORMATION DATA STRUCTURE FOR ZSFILE
      *
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  LINE1                367    368B 0
     D SPOOL2          DS
      ** SPOOL INFORMATION DATA STRUCTURE FOR ZSFILE
      *
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  LINE2                367    368B 0
      *
     D SPOOLU          DS
      ** SPOOL INFORMATION DATA STRUCTURE FOR ZSFILE - AU REPORT
      *
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  EXTERNAL DS FOR BANK DETAILS
      *
     D HMFICH        E DS                  EXTNAME(MAFICHPD)
      **  EXTERNAL DS FOR MICROFICHE HEADER
      *
     D***HODISK    E DSMAOPTHPD                                           S01382
      *****  EXTERNAL DS FOR OPTICAL DISK HEADER                          S01382
      *
     D DETDS           DS
      **** DATA STRUCTURE FOR MICROFICHE/OPTICAL DISK DETAIL              S01382
      * DATA STRUCTURE FOR MICROFICHE                                     S01382
      *
     D  MACCHR                 1      1
     D  MARDTL                 2    133
     D  F00021               134    154
     D DETOD           DS                                                       S01382
      * DATA STRUCTURE FOR OPTICAL DISK                                   S01382
     D  ODRDTL                 2    199                                         S01382
     D  HEADER                 2      5                                         S01382
     D  ARHEAD                 2     11                                         S01382
     D  REPORT                 7     16                                         S01382
     D  PRTFNM                81     90                                         S01382
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D FCREPT        E DS                  EXTNAME(FCREPJW0)                                MD055265
      *
     C                   MOVEA     CPY@          BIS@             80
     C/EJECT
      *
      *  ACCESS LDA
      *
     C     *DTAARA       DEFINE                  LDA
     C                   MOVE      *BLANKS       @SEQN             5
      *
      *
      *
     C     KARCH         KLIST
     C                   KFLD                    EAMEDM
     C                   KFLD                    MAARID
      *
      * READ SDBANKL1 VIA ACCESS PROGRAM AOBANKR0
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       RTCD              7
     C                   PARM      '*FIRST '     OPTN              7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * IF NO RECORD FOUND ON SDBANKL1,WRITE DATABASE ERROR REPORT
      *
     C     RTCD          IFNE      *BLANKS
      *
      * MOVE REPORT NAME AND SPOOL FILE NR TO ZSFILE'S @REP,@SFL
      *
     C                   OPEN      MA0630AU
     C                   MOVE      SFILEU        @REP
     C                   Z-ADD     SFNUMU        @SFL              6 0
     C                   EXSR      SUBZSF
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MA0630'      DBPGM                          ************
     C                   MOVE      'SDBANKPD'    DBFILE                         * DBERR 001*
     C                   MOVEL     OPTN          DBKEY                          ************
     C                   Z-ADD     1             DBASE
     C                   SETON                                        U7U8LR
     C                   OUT       LDA
     C                   WRITE     AU
     C                   RETURN
     C                   END
      *
      * MOVE AUDIT REPORT NAME AND SPOOL FILE NBR TO ZSFILE'S @REP,@SFL
      *
     C                   MOVE      SFILE1        @REP
     C                   Z-ADD     SFNUM1        @SFN
     C                   EXSR      SUBZSF
      ***********                                                         S01382
      **READ*RECORDS ON MABUROL0 UNTIL EOF                                S01382
      ***********                                                         S01382
     C************IN10     DOUEQ'1'                                       S01382
      ***********                                                         S01382
     C***********          SETOF                     010210               S01382
     C***********          READ MABUROL0                 10               S01382
      ***********                                                         S01382
      **IF*RECORD FOUND AND IF *IN01 IS ON,MICROFICHE DISK IS PRESENT     S01382
      ***********           IF *IN01 IS OFF OPTICAL DISK IS PRESENT       S01382
      ***********                                                         S01382
     C************IN10     IFEQ '0'                                       S01382
      ***********                                                         S01382
     C************IN01     IFEQ '1'                                       S01382
     C***********          MOVE 'M'       EAMEDM                          S01382
     C***********          MOVELDETDS     HMFICH                          S01382
     C***********          ELSE                                           S01382
     C***********          MOVE 'O'       EAMEDM                          S01382
     C***********          MOVELDETDS     HODISK                          S01382
     C***********          MOVE M1ARID    MAARID                          S01382
     C***********          MOVE M1PFTX    MAPFTX                          S01382
     C***********          MOVE M1RNAM    MARNAM                          S01382
     C***********          MOVE M1RSFX    MARSFX                          S01382
     C***********          END                                            S01382
      ***********                                                         S01382
      **CHAIN*MAARCHL3 USING KARCH(MEDIUM(EAMEDM) AND ARCHIVE ID(MAARID)) S01382
      ***AS*KEY**                                                         S01382
      ***********                                                         S01382
     C***********KARCH     CHAINMAARCHL3             15                   S01382
     C***********          END                                            S01382
      ***********                                                         S01382
      **WRITE*ARCHIVING AUDIT REPORT(SUBP1)                               S01382
      ***********                                                         S01382
     C***********          EXSR SUBP1                                     S01382
      ***********                                                         S01382
     C***********          END                                            S01382
      *                                                                   S01382
      * WRITE HEADINGS ON ARCHIVE AUDIT - FOR FIRST CYCLE                 S01382
      *                                                                   S01382
     C     *IN50         IFEQ      '0'                                                         S0138
     C                   EXSR      SUBP1                                                       S0138
     C                   MOVE      '1'           *IN50                                         S0138
     C                   END                                                                   S0138
      *                                                                   S01382
      * MICROFICHE AUDIT                                                  S01382
      * ----------------                                                  S01382
     C                   EXSR      WMICRO                                                      S0138
      *                                                                   S01382
      * OPTICAL DISK AUDIT                                                S01382
      * ------------------                                                S01382
     C                   EXSR      WOPTIC                                                      S0138
      *                                                                   S01382
      * WRITE NO DETAILS IF NO RECORDS FOUND                              S01382
      *                                                                   S01382
     C                   EXSR      SUBP11                                                      S0138
      *
      * MOVE EXCEPTIONS REPORT NAME AND SPOOL FILE NBR TO ZSFILE'S @REP,@SFL
      *
     C                   MOVE      SFILE2        @REP
     C                   Z-ADD     SFNUM2        @SFN
     C                   EXSR      SUBZSF
      *
      * READ RECORDS FROM MAEXPTL1 AND
      * WRITE ARCHIVING EXCEPTION REPORT(SUBP2)
      *
     C     *IN20         DOUEQ     '1'
     C                   READ      MAEXPYL1                               20
     C                   EXSR      SUBP2
     C                   END
      *
     C                   SETON                                        LR
      *                                                                   S01382
     C***********LINEP2    IFLE 0                                  S01382 083764
     C     LINE2         IFGT      56                                                          08376
     C                   WRITE     HEADP2                                                      S0138
     C***********          Z-ADD45        LINEP2  20               S01382 083764
     C                   END                                                                   S0138
     C                   WRITE     ENDP2
      *                                                                   S01382
     C***********LINEP1    IFLE 0                                  S01382 062963
     C***********LINEP1    IFLE 3                                  062963 083764
     C     LINE1         IFGT      56                                                          08376
     C                   WRITE     HEADP1                                                      S0138
     C***********          Z-ADD47        LINEP1  20               S01382 083764
     C                   END                                                                   S0138
     C                   WRITE     ENDP1
      *
      **********************************************************************
      /EJECT
      ******************************************************************  S01382
      * WMICRO -WRITES TO ARCHIVE AUDIT REPORT FOR MICROFICHE          *  S01382
      *         CALLED BY MAINLINE                                     *  S01382
      *                                                                *  S01382
      ******************************************************************  S01382
      *                                                                   S01382
     C     WMICRO        BEGSR                                                                 S0138
      *                                                                   S01382
      * PROCESS RECORDS ON MAFICDL0 UNTIL EOF                             S01382
      *                                                                   S01382
     C                   READ      MAFICDL0                               10                   S0138
      *                                                                   S01382
     C     *IN10         DOWEQ     '0'                                          B1             S0138
     C                   MOVEL     DETDS         HMFICH                                        S0138
      *                                                                   S01382
      * CHAIN MAARCHL3 USING KARCH(MEDIUM(EAMEDM) AND ARCHIVE ID(MAARID)) S01382
      * AS KEY. CHECK IF MEDIUM 'M' OR 'B'. THIS WILL PICK UP THE OUTQ    S01382
      * FOR THE ARCHIVE ID.                                               S01382
      *                                                                   S01382
     C                   MOVEL     'M'           EAMEDM                                        S0138
     C     KARCH         CHAIN     MAARCHL3                           15                       S0138
      *                                                                   S01382
     C     *IN15         IFEQ      '1'                                                         S0138
     C                   MOVEL     'B'           EAMEDM                                        S0138
     C     KARCH         CHAIN     MAARCHL3                           15                       S0138
     C                   END                                                                   S0138
      *                                                                   S01382
      * WRITE ARCHIVING AUDIT REPORT(SUBP1)                               S01382
      *                                                                   S01382
     C                   EXSR      SUBP1                                                       S0138
      *                                                                   S01382
      * READ NEXT RECORD                                                  S01382
      *                                                                   S01382
     C                   READ      MAFICDL0                               10                   S0138
     C                   END                                                    E1             S0138
      *                                                                   S01382
     C                   ENDSR                                                                 S0138
      *                                                                   S01382
      ******************************************************************  S01382
      /EJECT                                                              S01382
      ******************************************************************  S01382
      * WOPTIC -WRITES TO ARCHIVE AUDIT REPORT FOR OPTICAL DISK        *  S01382
      *         CALLED BY MAINLINE                                     *  S01382
      *                                                                *  S01382
      ******************************************************************  S01382
      *                                                                   S01382
     C     WOPTIC        BEGSR                                                                 S0138
      *                                                                   S01382
      * READ MAOPTFPF                                                     S01382
      *                                                                   S01382
     C                   READ      MAOPTFPD                               11                   S0138
      *                                                                   S01382
      * IF A RECORD EXISTS AND DETAILS HAVE BEEN ALREADY PRINTED          S01382
      * (FOR MICROFICHE), THEN RESET LINE NUMBER TO SKIP TO TOP OF PAGE   S01382
      *                                                                   S01382
     C     *IN11         IFEQ      '0'                                                         S0138
     C     LP1           ANDEQ     'D'                                                         S0138
     C                   Z-ADD     0             LINEP1                                        S0138
     C                   END                                                                   S0138
      *                                                                   S01382
      * PROCESS RECORDS ON MAOPTFPD UNTIL EOF                             S01382
      *                                                                   S01382
     C     *IN11         DOWEQ     '0'                                          B1             S0138
      *                                                                   S01382
      * IF RECORD IS A 'BREAK' RECORD, IT WILL ONLY HAVE THE ARCHIVE ID   S01382
      * SO SAVE IT AND READ NEXT RECORD UNDER THIS ARCHIVE ID             S01382
      *                                                                   S01382
     C     HEADER        IFNE      '*$*$'                                       B*2            S0138
     C                   MOVEL     ARHEAD        MAARID                                        S0138
      *                                                                   S01382
     C                   ELSE                                                   X*2            S0138
      *                                                                   S01382
      * PROCESS THE DETAIL RECORD FOR ARCHIVE ID ALREADY FOUND IN 'BREAK' S01382
      * RECORD                                                            S01382
      *                                                                   S01382
     C                   MOVEL     REPORT        MARNAM                         REPORT NAME    S0138
     C                   MOVEL     PRTFNM        MARSFX                         PRINT FILE NAMES0138
      *                                                                   S01382
      * OBTAIN DESCRIPTION OF REPORT                                      S01382
      *                                                                   S01382
     C*****REPORT        CHAIN     FCREPTL1                           16              S0138 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT                                                                        MD055265
     C+ from FCREPJW0                                                                       MD055265
     C+ where DXRNAM = :REPORT                                                              MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       16                    MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                        16                    MD055265
     C                   ENDIF                                                              MD055265
     C     *IN16         IFEQ      '0'                                          B***4          S0138
     C                   MOVEL     DXRDSC        MAPFTX                         DESCRIPTION    S0138
     C                   ELSE                                                                  S0138
     C                   MOVEL     *BLANKS       MAPFTX                                        S0138
     C                   END                                                    E***4          S0138
      *                                                                   S01382
      * CHAIN MAARCHL3 USING KARCH(MEDIUM(EAMEDM) AND ARCHIVE ID(MAARID)) S01382
      * AS KEY. CHECK IF MEDIUM 'O' OR 'B'. THIS WILL PICK UP THE OUTQ    S01382
      * FOR THE ARCHIVE ID.                                               S01382
      *                                                                   S01382
     C                   MOVEL     'O'           EAMEDM                                        S0138
     C     KARCH         CHAIN     MAARCHL3                           15                       S0138
      *                                                                   S01382
     C     *IN15         IFEQ      '1'                                                         S0138
     C                   MOVEL     'B'           EAMEDM                                        S0138
     C     KARCH         CHAIN     MAARCHL3                           15                       S0138
     C                   END                                                                   S0138
      *                                                                   S01382
      * WRITE ARCHIVING AUDIT REPORT(SUBP1)                               S01382
      *                                                                   S01382
     C                   EXSR      SUBP1                                                       S0138
      *                                                                   S01382
     C                   END                                                    E*2            S0138
      *                                                                   S01382
      * READ NEXT RECORD                                                  S01382
      *                                                                   S01382
     C                   READ      MAOPTFPD                               11                   S0138
     C                   END                                                    E1             S0138
      *                                                                   S01382
     C                   ENDSR                                                                 S0138
      *                                                                   S01382
      ******************************************************************  S01382
      /EJECT
      ******************************************************************
      * SUBZSF -CALLES ZSFILE WITH PARAMETERS                          *
      *         CALLED BY MAINLINE                                     *
      *                                                                *
      ******************************************************************
      *
     C     SUBZSF        BEGSR
      *
      * CALL ZSFILE WITH PARAMETERS.THE FIRST,SECOND AND FIFTH OF THESE
      * ARE BLANK
      *
     C                   MOVE      *BLANKS       @ENT              3
     C                   MOVE      *BLANKS       @ERR              1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    @SEQN             5
     C                   PARM                    @ENT              3
     C                   PARM                    @REP             10
     C                   PARM                    @SFN              6 0
     C                   PARM                    @ERR              1
      *
      * IF ERROR EXIT PROGRAM
      *
     C     @ERR          IFNE      *BLANKS
     C                   SETON                                        LR
     C                   RETURN
     C                   END
     C                   ENDSR
      *
      ******************************************************************
      /EJECT
      ******************************************************************
      * SUBP1  -PRINTS ARCHIVING AUDIT REPORT                          *
      *         CALLED BY MAINLINE                                     *
      *                                                                *
      ******************************************************************
      *
     C     SUBP1         BEGSR
      *                                                                   S01382
      * IF FIRST CYCLE                                                    S01382
      *                                                                   S01382
     C     *IN50         IFEQ      '0'                                                         S0138
     C                   WRITE     HEADP1                                                      S0138
     C                   Z-ADD     47            LINEP1            2 0                         S0138
      *                                                                   S01382
      * OTHERWISE PRINT DETAILS                                           S01382
      *                                                                   S01382
     C                   ELSE                                                                  S0138
      *
      * OVERFLOW HANDLING
      *
     C     LINEP1        IFLE      0
     C                   WRITE     HEADP1
     C                   Z-ADD     47            LINEP1            2 0
     C                   END
      ************                                                        S01382
      ****IF*RECORD FOUND ON MABUROL0,WRITE 'DETAIL'REPORT                S01382
      ************                                                        S01382
     C************IN10     IFEQ '0'                                       S01382
      ***********                                                         S01382
     C***********          WRITEDETP1                                     S01382
     C***********          SUB  1         LINEP1                          S01382
     C***********          MOVE 'D'       LP1     1                       S01382
     C***********                                                         S01382
     C***********          ELSE                                           S01382
      ***********                                                         S01382
      *STRIP FOLLOWING CODING AS IT IS NOW DONE IN SUBP11                 S01382
      *IF*NO*RECORDS FOUND ON MABUROL0 WRITE 'NO-DETAIL'REPORT            S01382
      ***********                                                         S01382
     C***********LP1       IFEQ ' '                                       S01382
     C***********          WRITENORP1                                     S01382
     C***********          END                                            S01382
     C***********          END                                            S01382
      *                                                                   S01382
      * WRITE A BLANK LINE IF THE ARCHIVE ID HAS CHANGED                  S01382
      *                                                                   S01382
     C     MAARID        IFNE      @ARID                                                       S0138
     C                   WRITE     BLNK1                                                       S0138
     C                   SUB       1             LINEP1                                        S0138
     C                   END                                                                   S0138
     C*                                                                   062963
     C** Overflow handling.                                               062963
     C*                                                                   062963
     C     LINEP1        IFLE      0                                                           06296
     C                   WRITE     HEADP1                                                      06296
     C                   Z-ADD     47            LINEP1            2 0                         06296
     C                   END                                                                   06296
      *                                                                   S01382
      * WRITE THE DETAIL LINE                                             S01382
      *                                                                   S01382
     C                   WRITE     DETP1                                                       S0138
     C                   SUB       1             LINEP1                                        S0138
     C                   MOVE      'D'           LP1               1                           S0138
      *                                                                   S01382
      * SAVE ARCHIVE ID                                                   S01382
      *                                                                   S01382
     C                   MOVEL     MAARID        @ARID            10                           S0138
      *
     C                   END
      *
     C                   ENDSR
      *
      ******************************************************************
      /EJECT
      ******************************************************************  S01382
      * SUBP11 -PRINTS ARCHIVING AUDIT REPORT - NO DETAILS             *  S01382
      *         CALLED BY MAINLINE                                     *  S01382
      *                                                                *  S01382
      ******************************************************************  S01382
      *                                                                   S01382
     C     SUBP11        BEGSR                                                                 S0138
      *                                                                   S01382
      *IF NO RECORDS FOUND ON MAFICDL0 OR MAOPTFPD WRITE 'NO-DETAIL'REPORTS01382
      *                                                                   S01382
     C     *IN50         IFEQ      '1'                                                         S0138
     C     LP1           IFEQ      ' '                                                         S0138
     C                   WRITE     NORP1                                                       S0138
     C                   END                                                                   S0138
     C                   END                                                                   S0138
      *                                                                   S01382
     C                   ENDSR                                                                 S0138
      *                                                                   S01382
      ******************************************************************  S01382
      /EJECT
      ******************************************************************
      * SUBP2  -PRINTS ARCHIVING EXCEPTION REPORT                      *
      *         CALLED BY MAINLINE                                     *
      *                                                                *
      ******************************************************************
      *
     C     SUBP2         BEGSR
      *
      *OVERFLOW HANDLING
      *
     C     LINEP2        IFLE      0
     C                   WRITE     HEADP2
     C                   Z-ADD     45            LINEP2            2 0
     C                   END
      *
      *IF RECORD FOUND ON MAEXPTL1,WRITE 'DETAIL'REPORT
      *
     C     *IN20         IFEQ      '0'
      *
     C                   WRITE     DETP2
     C                   SUB       1             LINEP2
     C                   MOVE      'D'           LP2               1
      *
     C                   ELSE
      *
      *IF NO RECORDS FOUND, WRITE 'NO-DETAIL'REPORT
      *
     C     LP2           IFEQ      ' '
     C                   WRITE     NORP2
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      ******************************************************************
      /EJECT
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
