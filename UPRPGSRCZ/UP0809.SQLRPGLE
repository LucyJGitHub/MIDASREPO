     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas UP Reset unique number values')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP0809 - Reset unique number values                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061162           Date 30Jan24               *      
      *  Prev Amend No. MD059943           Date 16May22               *
      *                 MD058986           Date 11Oct21               *
      *                 MD055891           Date 01Sep20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CUP004 *CREATE     Date 23Mar98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD061162 - Avoid duplicate key error when deleting records   *
      *             by making sure the unique no. (DIDRUN) is unique  *
      *             whether records are logically deleted or not      *
      *  MD059943 - Update tables using the 5 fields to avoid         *
      *             duplicate key record.                             *
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP004  -  Make upgrade of DTALIB files easier               *
      *                                                               *
      *****************************************************************
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      *       20      End of file
      *       69      Read, write, update or delete fail
      *
     F*CBDPRLL1* UF   E           K DISK                                                    MD055891
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D CBDPRL        E DS                  EXTNAME(CBDPRJW0)                                MD055891
      *
      ** Array containing Copyright statement
      *
     D                 DS
     D  UNQNO                  1      3  0
     D  UNQNOA                 1      3
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
     C     COMP          KLIST
     C                   KFLD                    DIDSON
     C                   KFLD                    DIDSOS
      *
     C                   Z-ADD     1             UNQNO
      *
     C******LOVAL        SETLL     CBDPRLL1                                                 MD055891
      *
     C**********         READ      CBDPRLL1                             6920                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ACursor insensitive scroll cursor for                                       MD055891
     C**select** from CBDPRJW0                                                     MD055891 MD061162
     C+ select * from CBDPRJW1                                                              MD061162
     C+ order by DIDSON, DIDSOS, DIDRUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ACursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   SETOFF                                       2069                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        20                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 0 and SQLCODE <> 100                          MD055891
     C                   SETON                                        69                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN69         IFEQ      *ON
     C                   SETON                                        U7U8
     C                   DUMP
     C                   GOTO      ENDPGM
      *
     C                   ELSE
     C                   MOVEL     DIDSON        DSON             10
     C                   MOVEL     DIDSOS        DSOS              5
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
     C     DIDRUN        IFNE      UNQNOA
     C**********         MOVEL     UNQNOA        DIDRUN                                     MD055891
     C**********         UPDATE    @DIREGK                                                  MD055891
     C                   If        DIMODE = 'C'                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBDPRCTD set DIDRUN = :UNQNOA                                                MD055891
     C+ where DIDSON = :DIDSON and DIDSOS = :DIDSOS and DIDRUN = :DIDRUN                    MD055891
     C+   and DIDDON = :DIDDON and DIDDOS = :DIDDOS                                         MD059943
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBDPRXTD set DIDRUN = :UNQNOA                                                MD055891
     C+ where DIDSON = :DIDSON and DIDSOS = :DIDSOS and DIDRUN = :DIDRUN                    MD055891
     C+   and DIDDON = :DIDDON and DIDDOS = :DIDDOS                                         MD059943
     C/END-EXEC                                                                             MD055891
     C                   ENDIF                                                              MD055891
     C                   If        DIMODE = 'B'                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBDPRBTD set DIDRUN = :UNQNOA                                                MD055891
     C+ where DIDSON = :DIDSON and DIDSOS = :DIDSOS and DIDRUN = :DIDRUN                    MD055891
     C+   and DIDDON = :DIDDON and DIDDOS = :DIDDOS                                         MD059943
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBDPRXTD set DIDRUN = :UNQNOA                                                MD055891
     C+ where DIDSON = :DIDSON and DIDSOS = :DIDSOS and DIDRUN = :DIDRUN                    MD055891
     C+   and DIDDON = :DIDDON and DIDDOS = :DIDDOS                                         MD059943
     C/END-EXEC                                                                             MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *
     C                   ADD       1             UNQNO
     C**********         READ      CBDPRLL1                             6920                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   SETOFF                                       2069                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        20                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 0 and SQLCODE <> 100                          MD055891
     C                   SETON                                        69                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN69         IFEQ      *ON
     C                   SETON                                        U7U8
     C                   DUMP
     C                   GOTO      ENDPGM
      *
     C                   ELSE
     C     DIDSON        IFNE      DSON
     C     DIDSOS        ORNE      DSOS
     C                   Z-ADD     1             UNQNO
     C                   MOVEL     DIDSON        DSON
     C                   MOVEL     DIDSOS        DSOS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C/EXEC SQL                                                                             MD055891
     C+ close ACursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
