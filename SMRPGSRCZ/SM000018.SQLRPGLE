     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Change file names on FILEMULMBR')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SM001071 - Add records to new user files                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSM010             Date 22Jun07               *
      *  Prev Amend No. CER001  *CREATE    Date 18Apr07               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSM010 - Applied by CER001.                                  *
      *  CER001 - MidasPlus 1.3 packaging.  Changes to migration.     *
      *                                                               *
      *****************************************************************
      *
     FSMZNMGPD  IF   E           K DISK
      *
     C/EXEC SQL
     C+  WHENEVER SQLERROR GO TO TAGSQLERR
     C/END-EXEC
      *
     C     *LOVAL        SETLL     SMZNMGPD
     C                   READ      SMZNMGPD
      *
     C                   DOW       NOT %EOF
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
     C                   READ      SMZNMGPD
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
