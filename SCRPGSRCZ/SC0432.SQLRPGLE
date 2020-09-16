     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC Inactive Switchable features')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC0432 - Inactive Switchable features                        *
      *                                                               *
      *  Function:  This program reads through switchable features    *
      *             file SCSARDPD to determine which features have    *
      *             been correctly switched on using passwords.       *
      *                                                               *
      *  Called By: SC3010M                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSC010  *CREATE    Date 17May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC010 - Switchable features enhancments.                    *
      *                                                               *
      *****************************************************************
      *
     F*SCSARDL0* IF   E           K DISK                                                    MD055681
      * Switchable features held on file                              *
      *
     F*SCSARJL1* IF   E           K DISK                                                    MD055681
      * All core and non-core switchable features                     *
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
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
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D SCSARS        E DS                  EXTNAME(SCSRSJW0)                                MD055681
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Set up copyright parameter
      *
     C     *ENTRY        PLIST
     C                   PARM                    @RETRN            7
     C                   PARM                    PASSON            1
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Check if there are any remaining inactive features first
      *
     C     @RETRN        IFEQ      'Check'
     C                   EXSR      INACHK
     C                   EXSR      EXIT
     C                   ENDIF
     C                   Z-ADD     0             ERRCNT            3 0
     C                   EXSR      INACHK
     C*
     C** If some features are inactive, display warning
     C*
     C     *IN66         IFEQ      *ON
     C                   CALL      'SC0432W0'
     C                   PARM      'Warning'     @RTCD             7
     C                   PARM                    KEYP              2
     C                   PARM                    ABSARN            6
     C                   PARM                    ABSARD           50
     C*
     C** User presses F3
     C*
     C     KEYP          IFEQ      '03'
     C                   EXSR      EXIT
     C                   ENDIF
     C******LOVAL        SETLL     SCSARDL0                                                 MD055681
     C**********         READ      SCSARDL0                               89                MD055681
     C/EXEC SQL                                                                             MD055681
     C+ declare ACursor insensitive scroll cursor for                                       MD055681
     C+ select * from SCSRDJW0                                                              MD055681
     C+ order by SARN                                                                       MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ open ACursor                                                                        MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from ACursor into :SCSARD                                                MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C*
     C******IN89         DOWEQ     '0'                                                      MD055681
     C                   DOW       SQLCODE = 0                                              MD055681
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C**********         PARM                    ABSARN            6                        MD055681
     C                   PARM      SARN          ABSARN            6                        MD055681
     C                   MOVE      *BLANKS       ACTFLG            8
     C*
     C** Set up a flag to distinguish active from inactive features
     C*
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Active'      ACTFLG
     C                   ELSE
     C                   MOVEL     'Inactive'    ACTFLG
     C                   ENDIF
     C*
     C** If the feature is inactive, display it
     C*
     C     ACTFLG        IFEQ      'Inactive'
     C     ERRCNT        ADD       1             ERRCNT
     C                   CALL      'SC0432W0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM                    KEYP              2
     C**********         PARM                    ABSARN            6                        MD055681
     C                   PARM                    SARN              6                        MD055681
     C**********         PARM                    ABSARD           50                        MD055681
     C                   PARM                    SARD                                       MD055681
     C                   ENDIF
     C*
     C** User presses F3
     C*
     C     KEYP          IFEQ      '03'
     C                   EXSR      EXIT
     C                   ENDIF
      *
     C**********         READ      SCSARDL0                               89                MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from ACursor into :SCSARD                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   ENDDO
     C/EXEC SQL                                                                             MD055681
     C+ close ACursor                                                                       MD055681
     C/END-EXEC                                                                             MD055681
     C                   ENDIF
      *
     C                   EXSR      EXIT
      /EJECT
      *****************************************************************
      *                                                               *
      *  EXIT   - Subroutine to END PROGRAM                           *
      *                                                               *
      *****************************************************************
     C     EXIT          BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  INACHK - Inactive features check                             *
      *                                                               *
      *****************************************************************
     C     INACHK        BEGSR
     C******LOVAL        SETLL     SCSARDL0                                                 MD055681
     C                   Z-ADD     0             ERRCNT            3 0
     C**********         READ      SCSARDL0                               73                MD055681
     C/EXEC SQL                                                                             MD055681
     C+ declare BCursor insensitive scroll cursor for                                       MD055681
     C+ select * from SCSRDJW0                                                              MD055681
     C+ order by SARN                                                                       MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ open BCursor                                                                        MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from BCursor into :SCSARD                                                MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C******IN73         DOWEQ     '0'                                                      MD055681
     C                   DOW       SQLCODE = 0                                              MD055681
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C**********         PARM                    ABSARN            6                        MD055681
     C                   PARM      SARN          ABSARN            6                        MD055681
     C                   MOVE      *BLANKS       ACTFLG            8
     C*
     C*  Set up a flag to distinguish active from inactive features
     C*
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Active'      ACTFLG
     C                   ELSE
     C                   MOVEL     'Inactive'    ACTFLG
     C                   ENDIF
     C*
     C* If the PASSWD feature has not been switched on, all non-core
     C* switchable features on SCSARDPD will appear inactive.
     C* This code prevents this:
     C*
     C     PASSON        IFEQ      'N'
     C     ACTFLG        ANDEQ     'Inactive'
     C*****ABSARN        CHAIN     SCSARJL1                           75                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARS                                                                        MD055681
     C+ from SCSRSJW0                                                                       MD055681
     C+ where AXSARN = :ABSARN                                                              MD055681
     C/END-EXEC                                                                             MD055681
     C     AXMNTB        IFEQ      'B'
     C                   MOVEL(P)  'Active  '    ACTFLG
     C                   ENDIF
     C                   ENDIF
     C*
     C* If the feature is inactive, display it
     C*
     C     ACTFLG        IFEQ      'Inactive'
     C     ERRCNT        ADD       1             ERRCNT
     C                   LEAVE
     C                   ENDIF
     C**********         READ      SCSARDL0                               73                MD055681
     C/EXEC SQL                                                                             MD055681
     C+ fetch next from BCursor into :SCSARD                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   ENDDO
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ close BCursor                                                                       MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C     ERRCNT        IFGT      0
     C* *IN66 = Inactive features present
     C                   MOVE      *ON           *IN66
     C     @RETRN        IFEQ      'Check'
     C                   MOVEL(P)  'Errors'      @RETRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
