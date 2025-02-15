     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Report Action File for CMPDBA *TRG')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000043 - Report Action File for UPFDTRPD                   *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK025  *CREATE    Date 30May06               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
     FUPFDTRL0  IF   E           K DISK    INFSR(*PSSR)
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
     D  HDR2                  21     24    INZ('Time')
     D  HDR3                  26     30    INZ('Event')
     D  HDR4                  32     38    INZ('Program')
      *
     D                 DS
     D KEYDTA                  1    132
     D  DTA1                  10     19
     D  DTA2                  21     21
     D  DTA2NoFile            21    132
     D  DTA3                  26     26
     D  DTA4                  32     41
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
     D TriggerNameC    C                   'Trigger name is different. Check +
     D                                     UPFDTRPD.'
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
     C     *LOVAL        SETLL     UPFDTRD0
      *
     C                   READ      UPFDTRL0                             6920
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
     C     TRACTC        IFNE      'A'
     C                   SETON                                        61
     C                   WRITE     DTL1
     C                   SETOFF                                       61
     C                   ELSE
     C                   SETON                                        62
     C                   WRITE     DTL1
     C                   SETOFF                                       62
     C                   ENDIF
      *
     C     TRACTC        DOWEQ     'A'
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
     C                   READ      UPFDTRL0                             6920
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
     C     TRACTC        IFNE      'D'
     C     TRACTC        ANDNE     'E'
     C                   SETON                                        71
     C                   WRITE     DTL2
     C                   SETOFF                                       71
     C                   ELSE
     C                   SETON                                        72
     C                   WRITE     DTL2
     C                   SETOFF                                       72
     C                   ENDIF
      *
     C                   DOW       (TRACTC = 'D' or
     C                             TRACTC = 'E') and
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
     C                   READ      UPFDTRL0                             6920
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
     C     TRACTC        IFNE      'I'
     C     TRACTC        ANDNE     'J'
     C                   SETON                                        81
     C                   WRITE     DTL3
     C                   SETOFF                                       81
     C                   ELSE
     C                   SETON                                        82
     C                   WRITE     DTL3
     C                   SETOFF                                       82
     C                   ENDIF
      *
     C                   DOW       (TRACTC = 'I' or
     C                             TRACTC = 'J') and
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
     C                   READ      UPFDTRL0                             6920
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
     C                   EXSR      UpdateDta
      *
      * Check values for first and second amended records of pair
     C                   MOVEL     TRNAM         NAM1            258
      *
      * Read next record so that values can be compared.
     C                   READ      UPFDTRL0                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     TRNAM         NAM2            258
      *
      * Compare values and write records to report.
      * Key sequence
     C     NAM1          IFNE      NAM2
     C                   MOVEL     'TRNAM'       FIELD
      * Write description of field.
     C                   EXSR      WrtFldDesc
      * Write 'before' value of field.
     C                   EVAL      KEYDTA = *blanks
     C                   MOVEL     *BLANKS       FIELD
     C                   MOVEL     *BLANKS       #VALUE
     C                   MOVEL     TriggerNameC  #VALUE
     C                   EXSR      WrtBfValue
      * Write 'after' value of field.
     C                   MOVEL     *BLANKS       #VALUE
     C                   EXSR      WrtAfValue
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * DELETE subroutine - process deleted records                   *
      *                                                               *
      *****************************************************************
     C     DELETE        BEGSR
     C                   IF        TRACTC = 'D'
     C                   EXSR      UpdateDta
     C                   ELSE
     C                   EVAL      KEYDTA = *blanks
     C                   EVAL      DTA1   = TRFILE
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
     C                   IF        TRACTC = 'I'
     C                   IF        PCompFile <> *blanks
     C                   EVAL      TRFILE = PCompFile
     C                   ENDIF
     C                   EXSR      UpdateDta
     C                   ELSE
     C                   EVAL      KEYDTA = *blanks
     C                   EVAL      DTA1 = TRFILE
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
     C                   EVAL      DTA1 = TRFILE
     C                   EVAL      DTA2 = TRTRTM
     C                   EVAL      DTA3 = TRTREV
     C                   EVAL      DTA4 = TRTRIG
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
