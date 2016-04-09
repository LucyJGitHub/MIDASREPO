     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL A/C Postings History Purge Copy Data')        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL4450T2 - Midas GL A/C Postings History Purge Copy Data     *
      *                                                               *
      *  Called By: REC4450T2                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CGL127AY *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL127AY - COB Restructure - GL COB Optimisation Phase 1     *
      *                                                               *
      *****************************************************************
      *
     FGLACHMPD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
     FGLACHDPD  UF A E             DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     COMMIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     50 - Indicator for dummy read of GLACHDPD                 *
      *     81 - READ indicator for GLACHMPD                          *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    RECTOT            7 0
     C                   PARM                    RTCODE            3
      *
     C                   OPEN      GLACHDPD
      *
     C                   EXSR      INIT
      *
      ** Split records into new file
     C                   EXSR      TSPLIT
      *
      ** End processing
     C                   EXSR      END
      *****************************************************************
      /EJECT
      *****************************************************************
      * TSPLIT - Split records into driver files                      *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     TSPLIT        BEGSR
      *
      ** Initialize record count
      *
     C                   Z-ADD     0             TOT               7 0
      *
      ** SETLL to the Master file.
      *
     C     1             SETLL     GLACHMPD                               81
      *
      ** Read until record count is GE to maximum records
      ** allowed or until EOF is reached.
      *
     C     TOT           DOUGE     RECTOT
     C     *IN81         OREQ      '1'
      *
     C                   READ      GLACHMPD                               81
      *
     C     *IN81         IFEQ      '0'
      *
      ** Set-up first record read.
      *
     C     TOT           IFEQ      0
     C                   MOVE      ACOD          S#ACOD
     C                   ENDIF
      *
      ** Add number of account historic postings to record count,
      ** then delete record.
      *
     C                   ADD       NOHP          TOT
     C                   MOVE      ACOD          W#ACOD           10
     C                   DELETE    GLACHMR0
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Setup last record read and write to driver file.
      *
     C                   MOVE      W#ACOD        E#ACOD
     C                   WRITE     GLACHDD0
     C                   COMMIT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * END - Exit program and return to calling program.             *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     END           BEGSR
      *
      ** If end of file, set return code to notify server.
      *
     C     *IN81         IFEQ      '1'
     C     TOT           IFEQ      0
     C                   MOVE      'NRF'         RTCODE
     C                   ELSE
     C                   MOVE      'EOF'         RTCODE
     C                   ENDIF
     C                   SETON                                        LR
     C                   ENDIF
      *
     C                   CLOSE     GLACHDPD
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initial processing.                                    *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Dummy READ to GLACHDPD for compilation purpose
      *
     C     *IN50         IFEQ      '1'
     C                   READ      GLACHDPD                               50
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      * Calls: None                                                   *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     *LOCK         IN        LDA
     C                   MOVEL(P)  'GL4450T2'    DBPGM
     C                   OUT       LDA
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   ROLBK
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@ - Object copyright
(c) Misys International Banking Systems Ltd. 2012
