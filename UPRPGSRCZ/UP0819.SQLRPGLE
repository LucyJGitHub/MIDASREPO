     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas UP Reset unique number values')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP0819 - Reset unique number values                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055891           Date 01Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CUP004 *CREATE     Date 06Apr98               *
      *                                                               *
      *****************************************************************
      *                                                               *
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
     F*CBMDCNL1* UF   E           K DISK                                                    MD055891
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      *
     D                 DS
     D  UNQNO                  1      2  0
     D  UNQNOA                 1      2
     D CBMDCN        E DS                  EXTNAME(CBMDCJW0)                                MD055891
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
     C     COMP          KLIST
     C                   KFLD                    DJCOTT
     C                   KFLD                    DJCSEQ
      *
     C                   Z-ADD     1             UNQNO
      *
     C******LOVAL        SETLL     CBMDCNL1                                                 MD055891
      *
     C**********         READ      CBMDCNL1                             6920                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ACursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBMDCJW0                                                              MD055891
     C+ order by DJCOTT, DJCSEQ, DJMCUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ACursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMDCN                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C******IN69         IFEQ      *ON                                                      MD055891
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        U7U8
     C                   DUMP
     C                   GOTO      ENDPGM
      *
     C                   ELSE
     C                   MOVEL     DJCOTT        COTT             10
     C                   MOVEL     DJCSEQ        CSEQ              5
     C                   ENDIF
      *
     C******IN20         DOWEQ     '0'                                                      MD055891
     C                   DOW       SQLCODE = 0                                              MD055891
      *
     C     DJMCUN        IFNE      UNQNOA
     C**********         MOVEL     UNQNOA        DJMCUN                                     MD055891
     C**********         UPDATE    @DJREGN                                                  MD055891
     C                   If        DJMODE = 'C'                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBMDCCTD set DJMCUN = :UNQNOA                                                MD055891
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBMDCXTD set DJMCUN = :UNQNOA                                                MD055891
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   ENDIF                                                              MD055891
     C                   If        DJMODE = 'B'                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBMDCBTD set DJMCUN = :UNQNOA                                                MD055891
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBMDCXTD set DJMCUN = :UNQNOA                                                MD055891
     C+ where DJCOTT = :DJCOTT and DJCSEQ = :DJCSEQ and DJMCUN = :DJMCUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *
     C                   ADD       1             UNQNO
     C***********        READ      CBMDCNL1                             6920                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMDCN                                                MD055891
     C/END-EXEC                                                                             MD055891
     C******IN69         IFEQ      *ON                                                      MD055891
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        U7U8
     C                   DUMP
     C                   GOTO      ENDPGM
      *
     C                   ELSE
     C     DJCOTT        IFNE      COTT
     C     DJCSEQ        ORNE      CSEQ
     C                   Z-ADD     1             UNQNO
     C                   MOVEL     DJCOTT        COTT
     C                   MOVEL     DJCSEQ        CSEQ
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
