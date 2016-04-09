     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Report Action File for CMPDBA *JOIN')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000037 - Report Action File for UPJOINPD                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK025  *CREATE    Date 30May06               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CPK025 - New utility.                                        *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file indicator
      *       37      Overflow indicator
      *       69      Read or write errors
      *       60      Amended records
      *       61      No amended records to report
      *       62      Amended records headers
      *       63      Print field description for Amend
      *       64      Print 'before' for Amend
      *       65      Print 'after' for Amend
      *       70      Deleted records
      *       71      No deleted records to report
      *       72      Deleted records headers
      *       80      Inserted records
      *       81      No inserted records to report
      *       82      Inserted records headers
      *
     FUPJOINL0  IF   E           K DISK    INFSR(*PSSR)
     FUP0799P1  O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL)
     F                                     OFLIND(*IN37)
     F                                     USROPN
      *
      /EJECT
      *
      * File information data structure for P1 file; used for page end
      *   handling
     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D  OFLLN                188    189B 0
     D  PRTLN                367    368B 0
      *
     D                 DS
     D KEYHDR                  1    132
     D  HDR1                  10     13    INZ('File')
     D  HDR2                  21     29    INZ('No. joins')
     D  HDR3                  31     34    INZ('Pos.')
     D  HDR4                  36     44    INZ('Join file')
     D  HDR5                  47     57    INZ('Jn. fm. no.')
     D  HDR6                  59     68    INZ('Join from')
     D  HDR7                  70     79    INZ('Jn. to no.')
     D  HDR8                  81     87    INZ('Join to')
     D  HDR9                  92    102    INZ('Jn. fm. fld')
     D  HDR10                104    114    INZ('Jn. to fld.')
     D  HDR11                116    128    INZ('Jn. dup. seq.')
      *
     D                 DS
     D KEYDTA                  1    132
     D  DTA1                  10     19
     D  DTA2                  21     25S 0
     D  DTA2NoFile            21    132
     D  DTA3                  31     33S 0
     D  DTA4                  36     45
     D  DTA5                  47     49S 0
     D  DTA6                  59     68
     D  DTA7                  70     72S 0
     D  DTA8                  81     90
     D  DTA9                  92    101
     D  DTA10                104    113
     D  DTA11                116    125
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      * Local data area for database error details
      * *LOCK IN LDA immediately before and OUT LDA immediately
      * after each database error handling.
      *
      *                                     134 141 DBFILE
      *        Defines:                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
     D PSDS           SDS
      *
      * Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D PCompFile       S             10
     D DTA2NoFileC     C                   'No file found to compare'
      *
     C     *ENTRY        PLIST
     C                   PARM                    HDRTXT
     C                   PARM                    PCompFile
      *
     C                   OPEN      UP0799P1
      *
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *LOVAL        SETLL     UPJOIND0
      *
     C                   READ      UPJOINL0                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If there are no records at all write 'no records'.
     C     *IN20         IFEQ      *ON
     C                   WRITE     NORECS                               69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   WRITE     TRAILP                               69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   GOTO      ENDPGM
      *
     C                   ELSE
     C                   SETON                                        60
     C                   WRITE     DTL1
     C                   SETOFF                                       60
     C                   ENDIF
      *
     C     JNACTC        IFNE      'A'
     C                   SETON                                        61
     C                   WRITE     DTL1
     C                   SETOFF                                       61
     C                   ELSE
     C                   SETON                                        62
     C                   WRITE     DTL1
     C                   SETOFF                                       62
     C                   ENDIF
      *
     C     JNACTC        DOWEQ     'A'
     C     *IN20         ANDNE     *ON
      *
      * Write headers if overflow on.
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   SETON                                        60
     C                   WRITE     DTL1
     C                   SETOFF                                       60
     C                   SETON                                        62
     C                   WRITE     DTL1
     C                   SETOFF                                       6237
     C                   ENDIF
      *
     C                   EXSR      AMEND
      *
     C                   READ      UPJOINL0                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
      *
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   SETON                                        70
     C                   WRITE     DTL2
     C                   SETOFF                                       70
      *
     C     JNACTC        IFNE      'D'
     C     JNACTC        ANDNE     'E'
     C                   SETON                                        71
     C                   WRITE     DTL2
     C                   SETOFF                                       71
     C                   ELSE
     C                   SETON                                        72
     C                   WRITE     DTL2
     C                   SETOFF                                       72
     C                   ENDIF
      *
     C                   DOW       (JNACTC = 'D' or
     C                             JNACTC = 'E') and
     C                             *IN20 <> *ON
      *
      * Write headers if overflow on.
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   SETON                                        70
     C                   WRITE     DTL2
     C                   SETOFF                                       70
     C                   SETON                                        72
     C                   WRITE     DTL2
     C                   SETOFF                                       7237
     C                   ENDIF
      *
     C                   EXSR      DELETE
      *
     C                   READ      UPJOINL0                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
      *
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   SETON                                        80
     C                   WRITE     DTL3
     C                   SETOFF                                       80
      *
     C     JNACTC        IFNE      'I'
     C     JNACTC        ANDNE     'J'
     C                   SETON                                        81
     C                   WRITE     DTL3
     C                   SETOFF                                       81
     C                   ELSE
     C                   SETON                                        82
     C                   WRITE     DTL3
     C                   SETOFF                                       82
     C                   ENDIF
      *
     C                   DOW       (JNACTC = 'I' or
     C                             JNACTC = 'J') and
     C                             *IN20 <> *ON
      *
      * Write headers if overflow on.
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   SETON                                        80
     C                   WRITE     DTL3
     C                   SETOFF                                       80
     C                   SETON                                        82
     C                   WRITE     DTL3
     C                   SETOFF                                       8237
     C                   ENDIF
      *
     C                   EXSR      INSERT
      *
     C                   READ      UPJOINL0                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
      *
     C                   WRITE     TRAILP                               69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   CLOSE     UP0799P1
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * AMEND subroutine - process amended records                    *
      *                                                               *
      *****************************************************************
     C     AMEND         BEGSR
      *
      * There are no amends for this type of comparison so the subroutine
      *  does nothing.
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * DELETE subroutine - process deleted records                   *
      *                                                               *
      *****************************************************************
     C     DELETE        BEGSR
     C                   IF        JNACTC = 'D'
     C                   EXSR      UpdateDta
     C                   ELSE
     C                   EVAL      KEYDTA = *blanks
     C                   EVAL      DTA1   = JNFILE
     C                   EVAL      DTA2NoFile = DTA2NoFileC
     C                   ENDIF
      *
     C                   WRITE     DTL2                                 69
     C     *IN69         IFEQ      *ON
     C                   SETON                                        U7U8
     C                   DUMP
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * INSERT subroutine - process inserted records                  *
      *                                                               *
      *****************************************************************
     C     INSERT        BEGSR
      *
     C                   IF        JNACTC = 'I'
     C                   IF        PCompFile <> *blanks
     C                   EVAL      JNFILE = PCompFile
     C                   ENDIF
     C                   EXSR      UpdateDta
     C                   ELSE
     C                   EVAL      KEYDTA = *blanks
     C                   EVAL      DTA1 = JNFILE
     C                   EVAL      DTA2NoFile = DTA2NoFileC
     C                   ENDIF
      *
     C                   WRITE     DTL3                                 69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * OFLOW subroutine - handle overflow for print of field details *
      *                                                               *
      *****************************************************************
     C     OFLOW         BEGSR
      *
     C     OFLLN         SUB       PRTLN         RMLN              2 0
     C     3             IFGE      RMLN
      *
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   SETON                                        60
     C                   WRITE     DTL1
     C                   SETOFF                                       60
     C                   SETON                                        62
     C                   WRITE     DTL1
     C                   SETOFF                                       62
     C                   EXSR      UpdateDta
     C                   MOVEL     *BLANKS       #VALUE
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * WrtFldDesc - Write description of the field compared          *
      *                                                               *
      *****************************************************************
     C     WrtFldDesc    BEGSR
      *
      * Find description of field.
     C                   CALL      'UPC0890'
     C                   PARM                    FIELD            10
     C                   PARM                    #FDESC           50
      * Write description of field.
     C                   MOVEL     *BLANKS       #VALUE
      * Check overflow before writing next lines.
     C                   EXSR      OFLOW
     C                   MOVEL     #FDESC        #VALUE
     C                   SETON                                        63
     C                   WRITE     DTL1                                 69
     C                   SETOFF                                       63
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     WrtFldDescE   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * WrtBfValue - Write before value of the field                  *
      *                                                               *
      *****************************************************************
     C     WrtBfValue    BEGSR
      *
     C                   SETON                                        64
     C                   WRITE     DTL1                                 69
     C                   SETOFF                                       64
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     WrtBfValueE   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * WrtAfValue - Write after value of the field                   *
      *                                                               *
      *****************************************************************
     C     WrtAfValue    BEGSR
      *
     C                   SETON                                        65
     C                   WRITE     DTL1                                 69
     C                   SETOFF                                       65
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     WrtAfValueE   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdateDta - Update key data.                                  *
      *                                                               *
      *****************************************************************
     C     UpdateDta     BEGSR
      *
     C                   EVAL      KEYDTA = *blanks
     C                   EVAL      DTA1 = JNFILE
     C                   EVAL      DTA2 = JNNSPC
     C                   EVAL      DTA3 = JNDIAL
     C                   EVAL      DTA4 = JNDNAM
     C                   EVAL      DTA5 = JNJFRM
     C                   EVAL      DTA6 = JNJFNM
     C                   EVAL      DTA7 = JNJTO
     C                   EVAL      DTA8 = JNJTNM
     C                   EVAL      DTA9 = JNJFD1
     C                   EVAL      DTA10 = JNJFD2
     C                   EVAL      DTA11 = JNJDSQ
      *
     C     UpdateDtaE    ENDSR
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
      *
      ********************************************************************
