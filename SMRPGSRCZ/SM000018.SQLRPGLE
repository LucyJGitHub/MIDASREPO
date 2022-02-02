     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Change file names on FILEMULMBR')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SM001071 - Add records to new user files                     *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD058089           Date 01Sep21               *
      *  Prev Amend No. MD046248           Date 05Feb18               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSM010             Date 22Jun07               *
      *                 CER001  *CREATE    Date 18Apr07               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058089 - Deliverable Data Split for SM and UP              *
      *  MD046248 - Finastra Rebranding                               *
      *  CSM010 - Applied by CER001.                                  *
      *  CER001 - MidasPlus 1.3 packaging.  Changes to migration.     *
      *                                                               *
      *****************************************************************
      *
     F*SMZNMGPD* IF   E           K DISK                                                    MD058089
      *
     D SMZNMG        E DS                  EXTNAME(SMZNMJW0)                                MD058089
     C/EXEC SQL
     C+  WHENEVER SQLERROR GO TO TAGSQLERR
     C/END-EXEC
      *
     C******LOVAL        SETLL     SMZNMGPD                                                 MD058089
     C**********         READ      SMZNMGPD                                                 MD058089
     C/EXEC SQL                                                                             MD058089
     C+ declare ACursor insensitive scroll cursor for                                       MD058089
     C+ select * from SMZNMJW0                                                              MD058089
     C+ order by ZNOBJ, ZNTYPE                                                              MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
     C/EXEC SQL                                                                             MD058089
     C+ open ACursor                                                                        MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
     C/EXEC SQL                                                                             MD058089
     C+ fetch next from ACursor into :SMZNMG                                                MD058089
     C/END-EXEC                                                                             MD058089
                                                                                            MD058089
      *
     C**********         DOW       NOT %EOF                                                 MD058089
     C                   DOW       SQLCODE = 0                                              MD058089
     C                   IF        ZNNOBJ <> *blanks
      * Delete existing records (if any) from user files.
     C/EXEC SQL
     C+ update FILEMULMBR set MBFILE = :ZNNOBJ
     C+ where MBFILE = :ZNOBJ
     C/END-EXEC
     C/EXEC SQL
     C+ update FILEMBR set MBFILE = :ZNNOBJ
     C+ where MBFILE = :ZNOBJ
     C/END-EXEC
     C                   ENDIF
     C**********         READ      SMZNMGPD                                                 MD058089
     C/EXEC SQL                                                                             MD058089
     C+ fetch next from ACursor into :SMZNMG                                                MD058089
     C/END-EXEC                                                                             MD058089
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C     TAGSQLERR     TAG
      *
     C                   EXSR      *PSSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
