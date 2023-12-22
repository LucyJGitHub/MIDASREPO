     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas UP Reset unique number values')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP0814 - Reset unique number values                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD062206           Date 19Dec23               *
      *  Prev Amend No. MD059667           Date 09Mar22               *
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
      *  MD062206 - Validation of mutually exclusive is causing       *
      *             duplicate key error. Make sure unique number      *
      *             (DKMEUN) is unique whether the record is logically*
      *             delete or not.                                    *
      *  MD059667 - Inconsistent DHCMEF field in CBCMPXTD.            *
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
     F*CBMEXCL1* UF   E           K DISK                                                    MD055891
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D                 DS
     D  UNQNO                  1      2  0
     D  UNQNOA                 1      2
     D CBMEXC        E DS                  EXTNAME(CBMEXJW0)                                MD055891
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
     C     COMP          KLIST
     C                   KFLD                    DKCOTT
     C                   KFLD                    DKCSEQ
      *
     C                   Z-ADD     1             UNQNO
      *
     C******LOVAL        SETLL     CBMEXCL1                                                 MD055891
      *
     C**********         READ      CBMEXCL1                             6920                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ACursor insensitive scroll cursor for                                       MD055891
     C*+*select** from CBMEXJW0                                                    MD055891 MD062206
     C+ select * from CBMEXJW1                                                              MD062206
     C+ order by DKCOTT, DKCSEQ, DKMEUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ACursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMEXC                                                MD055891
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
     C                   MOVEL     DKCOTT        COTT             10
     C                   MOVEL     DKCSEQ        CSEQ              5
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
     C     DKMEUN        IFNE      UNQNOA
     C**********         MOVEL     UNQNOA        DKMEUN                                     MD055891
     C**********         UPDATE    @DKREGQ                                                  MD055891
     C                   If        DKMODE = 'C'                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBMEXCTD set DKMEUN = :UNQNOA                                                MD055891
     C+ where DKCOTT = :DKCOTT and DKCSEQ = :DKCSEQ and DKMEUN = :DKMEUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBMEXXTD set DKMEUN = :UNQNOA                                                MD055891
     C+ where DKCOTT = :DKCOTT and DKCSEQ = :DKCSEQ and DKMEUN = :DKMEUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   ENDIF                                                              MD055891
     C                   If        DKMODE = 'B'                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBMEXBTD set DKMEUN = :UNQNOA                                                MD055891
     C+ where DKCOTT = :DKCOTT and DKCSEQ = :DKCSEQ and DKMEUN = :DKMEUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBMEXXTD set DKMEUN = :UNQNOA                                                MD055891
     C+ where DKCOTT = :DKCOTT and DKCSEQ = :DKCSEQ and DKMEUN = :DKMEUN                    MD055891
     C/END-EXEC                                                                             MD055891
     C                   ENDIF                                                              MD055891
     C                   END
      *
     C                   ADD       1             UNQNO
     C**********         READ      CBMEXCL1                             6920                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBMEXC                                                MD055891
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
     C     DKCOTT        IFNE      COTT
     C     DKCSEQ        ORNE      CSEQ
     C                   Z-ADD     1             UNQNO
     C                   MOVEL     DKCOTT        COTT
     C                   MOVEL     DKCSEQ        CSEQ
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
      *                                                                                     MD059667
      * Finally, update CBCMPXTD.DHCMEF flag (Mut.Exclusive Comps.Flag)                     MD059667
      * for any component defined as mutually exclusive                                     MD059667
     C/EXEC SQL                                                                             MD059667
     C+ update CBCMPXTD set DHCMEF = 'Y'                                                    MD059667
     C+ where DHCMEF = 'N' and DHCOTT concat DHCSEQ in                                      MD059667
     C+ (select DKCOTT concat DKCSEQ from CBMEXCTD)                                         MD059667
     C/END-EXEC                                                                             MD059667
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
