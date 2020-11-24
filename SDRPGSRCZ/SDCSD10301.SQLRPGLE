     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Initialise CSD103 Fields in SDBSRTPD')        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SDCSD10301 - Initialise CSD103 Fields in SDBSRTPD            *
      *                                                               *
      *  Function:  This program will run during Post Database        *
      *             Upgrade. It will select all existing base rates   *
      *             from SDBSRTPD. Then, it will set the              *
      *             Backward-Looking rate fields into their default   *
      *             values if they do not initially contain values    *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CSD103    *CREATE  Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************

     FSDBSRTL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Base Rate Codes File

      *****************************************************************
      /EJECT
      *****************************************************************

     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *

     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

     D RateDetails     DS
     D  BACYCD                 1      3
     D  BABSRC                 4      5

     D @RUN            S              1A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Key Fields for Base Rate File Access
     C     SDBSRTKEY     KLIST
     C                   KFLD                    BACYCD
     C                   KFLD                    BABSRC

      ** Select all existing base rates

     C/EXEC SQL
     C+ declare RateCursor insensitive scroll cursor for
     C+ select BACYCD, BABSRC
     C+ from SDBSRTPD
     C/END-EXEC
      *
     C/EXEC SQL
     C+ open RateCursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ fetch next from RateCursor into :RateDetails
     C/END-EXEC

     C                   DOW       SQLCOD <> 100

     C                   IF        SQLCODE <> 0 and
     C                             SQLCODE <> 100
     C                   EVAL      DBFILE = 'SDBSRTPD'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBPGM  = 'SMU01052'
     C                   EVAL      DBASE  = SQLCODE
     C                   EXSR      *PSSR
     C                   ENDIF

     C     SDBSRTKEY     CHAIN     SDBSRTL0
     C                   IF        %FOUND(SDBSRTL0)
     C     BABLRT        IFNE      'Y'
     C                   EVAL      BABLRT = 'N'
     C                   UPDATE    @BAREDG
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DBFILE = 'SDBSRTL0'
     C                   EVAL      DBKEY  = 'RATE NOT FOUND'
     C                   EVAL      DBPGM  = 'SMU01052'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ fetch next from RateCursor into :RateDetails
     C/END-EXEC

     C                   ENDDO

     C/EXEC SQL
     C+ close RateCursor
     C/END-EXEC

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
