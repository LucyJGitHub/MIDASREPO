     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD058089
/*STD *  RPGSQLBND                                                    *                     MD058089
/*EXI *  TEXT('Midas SM Check if file has moved between releases')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM0259 - Check if file has been moved between releases       *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD058089           Date 01Sep21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP016 *CREATE     Date 01Apr03               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD058089 - Deliverable Data Split for SM and UP              *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP016 - Add implementation software to core.                *
      *                                                               *
      *****************************************************************
      *
      * File containing list of non-referenced fields
     F*SMMTOTPD* IF   E             DISK                                                    MD058089
      *
     D Recursive       S              1
     D SMMTOT        E DS                  EXTNAME(SMMTOJW0)                                MD058089
      *
     C     *ENTRY        PLIST
     C                   PARM                    FileName         10
     C                   PARM                    Type             10
     C                   PARM                    Found             1
      *
     C                   MOVE      'N'           Found
      *
      * Read first record;
     C*****1****         SETLL     SMMTOTD0                                                 MD058089
     C**********         READ      SMMTOTD0                               99                MD058089
     C/EXEC SQL                                                                             MD058089
     C+ declare ACursor insensitive scroll cursor for                                       MD058089
     C+ select * from SMMTOJW0                                                              MD058089
     C+ order by MLNAME, MLTYPE                                                             MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
     C/EXEC SQL                                                                             MD058089
     C+ open ACursor                                                                        MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
     C/EXEC SQL                                                                             MD058089
     C+ fetch next from ACursor into :SMMTOT                                                MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
     C******IN99         IFEQ      *ON                                                      MD058089
     C     SQLCODE       IFEQ      100                                                      MD058089
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   DOU       *IN99 = *ON
     C                             or SQLCODE = 100                                         MD058089
      *
     C     MLNAME        IFEQ      FileName
     C     MLTYPE        ANDEQ     Type
     C                   MOVE      'Y'           Found
     C                   SETON                                        99
     C                   ENDIF
      *
     C**********         READ      SMMTOTD0                               99                MD058089
     C/EXEC SQL                                                                             MD058089
     C+ fetch next from ACursor into :SMMTOT                                                MD058089
     C/END-EXEC                                                                             MD058089
      *
     C                   ENDDO
      *
     C/EXEC SQL                                                                             MD058089
     C+ close ACursor                                                                       MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
