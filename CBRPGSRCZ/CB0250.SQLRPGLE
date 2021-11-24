     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB COB component text summary report')           *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Close of Business Processing
     F*                                                               *
     F*  CB0250 - CLOSE OF BUSINESS COMPONENT SUMMARY REPORT          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD058986           Date 11Oct21               *
      *  Prev Amend No. MD055891           Date 01Sep20               *
      *                 MD046248           Date 27Oct17               *
      *                 CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                    Date 00/00/00              *
     F*                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *                                                               *
     F*****************************************************************
     F*CBCMPNL1* IF   E           K DISK                                                    MD055891
     FCB0250P1  O    E             PRINTER
     F                                     INFDS(PRINT)
     F*
      /SPACE 2
     F********************************************************************
     F*
     F*     C  L   FUNCTION OF INDICATORS
     F*
     F*    50      READ FAIL/NO RECORDS FOUND ON CBCMPNL1
     F*
     F*       LR   LAST RECORD INDICATOR
     F*
     F*    U7&U8   DATABASE ERROR
     F*
     F*
     F*****************************************************************
     F/EJECT
     D** COPYRIGHT ARRAY
     D*
     D*****************************************************************
     D/EJECT
     D*
     D**     LOCAL DATA AREA
     D PRINT           DS
     D  LINE                 367    368B 0
     D** DATA STRUCTURE FOR LINE VARIABLE
     D*
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D** EXTERNAL DATA STRUCTURE FOR ACCESS OBJECT FORMAT
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     I** FIRST DATA STRUCTURE FOR ACCESS OBJECTS, SHORT DATA STRUCTURE
     I*
     I*****************************************************************
     I/EJECT
     C*
     C** SET UP PROGRAM NAME FOR DATABASE ERRORS
     C*
     C                   MOVEL     'CB0250  '    DBPGM
     C                   MOVE      *BLANKS       DBKEY
     C*
     C** USE ACCESS OBJECT AOBANKR0 TO
     C** RETRIEVE HEADER INFORMATION FOR REPORT
     C*
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C** IF ERROR FOUND BY ACCESS OBJECT EXIT
     C** PROGRAM VIA DATABASE ERROR SUBROUTINE
     C*
     C     P@RTCD        IFNE      *BLANKS
     C                   WRITE     RPTHDG
     C                   WRITE     SUBHDG
     C                   MOVEL     'AOBNK'       DBFILE                         ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** WRITE REPORT HEADING AND SUB- HEADING LINES
     C*
     C                   WRITE     RPTHDG
     C                   WRITE     SUBHDG
     C*
     C** READ COMPONENT DETAILS FILE
     C*
     C**********         READ      CBCMPNL1                               50                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ACursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBCMPJW0                                                              MD055891
     C+ order by DHCOTT, DHCSEQ                                                             MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ACursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBCMPN                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       50                    MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
     C                   Seton                                        50                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C*
     C** IF NO RECORD FOUND ON CBCMPNL1
     C** EXIT USING DATABASE ERROR SUBROUTINE
     C*
     C     *IN50         IFEQ      '1'
     C                   MOVEL     'CMPL1'       DBFILE                         ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** DO WHILE RECORDS FOUND ON CBCMPNL1
     C*
     C     *IN50         DOWEQ     '0'
     C*
     C** IF PRINTER IS ON LINE 56 OR BELOW START NEW PAGE
     C*
     C     LINE          IFGE      56
     C                   WRITE     RPTHDG
     C                   WRITE     SUBHDG
     C                   END
     C*
     C** WRITE DETAIL AND PARAMETER LINES UNLESS DUMMY COMPONENTS
      ** COBBEGIN or SCOBFINISH which do not require reporting                                CCB020
     C***COBBEGIN*OR*COBEND*WHICH*DO*NOT*REQUIRE*REPORTING*************                       CCB020
     C*
     C                   MOVEL     'SCOBFINI'    SCOBFI           10
     C                   MOVE      'SH'          SCOBFI
     C     DHCOTT        IFNE      'COBBEGIN'
     C********** DHCOTT    ANDNE'COBEND'                                                      CCB020
     C     DHCOTT        ANDNE     SCOBFI
     C*
     C                   WRITE     DETLIN
     C                   WRITE     PRMLIN
     C*
     C                   END
     C*
     C** READ COMPONENTS FILE CBCMPNL1 FOR NEXT RECORD
     C*
     C**********         READ      CBCMPNL1                               50                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBCMPN                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       50                    MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
     C                   Seton                                        50                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C*
     C                   END
     C*
     C** WRITE END OF REPORT LINE
     C*
     C                   WRITE     RPTEND
     C*
     C/EXEC SQL                                                                             MD055891
     C+ close ACursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   SETON                                        LR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**
     C** INDEX OF SUBROUTINES
     C**
     C** DBERR  - DATABASE ERROR HANDLING
     C**
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** DATABASE ERROR SUBROUTINE TO PERFORM DATABASE ERROR
     C** EXIT FROM PROGRAM
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     DBERR         BEGSR
     C*
     C** WRITE DATABASE ERROR ON NEW PAGE
     C*
     C                   WRITE     RPTHDG
     C                   WRITE     SUBHDG
     C*
     C** OUTPUT DATA BASE ERROR MESSAGE TO PRINTER FILE.
     C*
     C                   WRITE     DBELIN
     C*
     C** OUTPUT 'END OF REPORT' MESSAGE TO PRINTER FILE.
     C*
     C                   WRITE     RPTEND
     C*
     C** SETON INDICATORS U7 U8 LR AND RETURN TO CALLING PROGRAM
     C*
     C                   SETON                                        U7U8LR
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C********************************************************************
      /EJECT
**CTDATA CPY@
(c) Finastra International Limited 2001
