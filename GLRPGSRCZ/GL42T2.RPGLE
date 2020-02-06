     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL EOD Posting Merge: Create driver records')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL42T2 - Midas GL EOD Postings Merge: Create driver records  *
      *                                                               *
      *  Function:  This program set the from and to RRNs to process  *
      *                                                               *
      *  Called By: GLC42T2                                           *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL120 *CREATE     Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL120 - GL COB Components Task Split                        *
      *                                                               *
      *****************************************************************
 
     FGLEODPPD  O  A E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLEODPF:DRIVEF)
     F                                     COMMIT
     F                                     USROPN
 
     FGLEODIPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLEODIF:INDEXF)
     F                                     COMMIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     81 - READ indicator for GLEODIPD                          *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
 
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
     C                   PARM                    BLKSZE            7 0
     C                   PARM                    RECCNT           10 0
     C                   PARM                    RTCODE            3
 
     C                   OPEN      GLEODPPD
 
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
 
      ** Read in the index file to get the last FROM and TO RRNs
 
     C     *START        SETLL     GLEODIPD
     C                   READ      GLEODIPD                               81
 
      ** If index record not found: Set FROM and TO RRNs
 
     C     *IN81         IFEQ      '1'
 
     C                   Z-ADD     1             GLFRRN
     C                   Z-ADD     BLKSZE        GLTRRN
 
     C     GLTRRN        IFGT      RECCNT
     C                   Z-ADD     RECCNT        GLTRRN
     C                   ENDIF
 
      ** Write index record
 
     C                   WRITE     INDEXF
 
     C                   ELSE
 
      ** Index record found: Set FROM and TO RRNs
 
     C     BLKSZE        ADD       GLFRRN        GLFRRN
     C     BLKSZE        ADD       GLFRRN        GLTRRN
     C     GLTRRN        SUB       1             GLTRRN
 
     C     GLTRRN        IFGT      RECCNT
     C                   Z-ADD     RECCNT        GLTRRN
     C                   ENDIF
 
      ** Update index record
 
     C                   UPDATE    INDEXF
     C                   ENDIF
 
      ** Create the Driver record
 
     C                   Z-ADD     GLFRRN        GLFERN
     C                   Z-ADD     GLTRRN        GLTERN
 
     C                   WRITE     DRIVEF
 
     C                   COMMIT
     C                   CLOSE     GLEODPPD
 
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
 
      ** If total eq RECCNT found on file: EOF
 
     C     GLTRRN        IFEQ      RECCNT
     C                   MOVE      'EOF'         RTCODE
     C                   ENDIF
 
     C     RTCODE        IFEQ      'EOF'
     C                   SETON                                        LR
     C                   ENDIF
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
