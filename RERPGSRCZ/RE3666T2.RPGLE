     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas RE Accruals Task Split Copy Data')               *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE3666T2 - RE Accruals Task Split Copy Data                  *
      *                                                               *
      *  Function:  This program set the from and to RRNs to process  *
      *                                                               *
      *  Called By: REC3666T2                                         *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE093  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE093 - Tactical COB changes REC3666                        *
      *                                                               *
      *****************************************************************
      *
     FREACRDPD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(REDRIVF:DRIVEF)
     F                                     COMMIT
      *
     FREACRIPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(REINDXF:INDEXF)
     F                                     COMMIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     80 - READ indicator for REACRIPD                          *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
 
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Program Status Data Structure
 
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    BLKSZE            7 0
     C                   PARM                    RECCNT           10 0
     C                   PARM                    RTCODE            3
 
      ** Initial processing
 
     C                   EXSR      INIT
 
      ** Split records into new file
 
     C                   EXSR      TSPLIT
 
      ** End processing
 
     C                   EXSR      END
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR/TSPLIT - Split records into new driver and index files.    *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     TSPLIT        BEGSR
 
     C                   READ      REACRIPD                               80
 
      ** Check if index record not found
 
     C     *IN80         IFEQ      '1'
 
      ** Index record not found: Set FROM and TO RRNs
 
     C                   Z-ADD     1             REFRRN
     C                   Z-ADD     BLKSZE        RETRRN
     C     RETRRN        IFGE      RECCNT
     C                   Z-ADD     9999999999    RETRRN
     C                   ENDIF
 
      ** Write index record
 
     C                   WRITE     INDEXF
 
     C                   ELSE
 
      ** Index record found: Set FROM and TO RRNs
 
     C     BLKSZE        ADD       REFRRN        REFRRN
     C     BLKSZE        ADD       REFRRN        RETRRN
     C     RETRRN        SUB       1             RETRRN
     C     RETRRN        IFGE      RECCNT
     C                   Z-ADD     9999999999    RETRRN
     C                   ENDIF
 
      ** Update index record
 
     C                   UPDATE    INDEXF
     C                   ENDIF
 
      ** Create the Driver record
 
     C                   Z-ADD     REFRRN        REFERN
     C                   Z-ADD     RETRRN        RETERN
 
     C                   WRITE     DRIVEF
 
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR/END - Exit program and return to calling program.          *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     END           BEGSR
 
     C     RETRRN        IFGE      RECCNT
     C                   MOVE      'EOF'         RTCODE
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR/INIT - Initial processing.                                 *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Set up copyright parameter
 
     C                   MOVEA     CPY@          CPY2@            80
 
      ** Define LDA
 
     C     *DTAARA       DEFINE                  LDA
 
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
 
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   ROLBK
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@ - Object copyright
(c) Finastra International Limited 2012
