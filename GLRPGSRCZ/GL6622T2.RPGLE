     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Balances Task Split Copy Data')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL6622T2 - Midas GL GLACNTQD Task Split Copy Data            *
      *                                                               *
      *  Function:  This program set the from and to RRNs to process  *
      *                                                               *
      *  Called By: GLC6622T2                                         *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD040278 *CREATE   Date 18Aug16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD040278 - Stamp Tax A/C Keys (GLC008131) is not task split. *
      *             Complete rework of the component to allow task    *
      *             split.                                            *
      *                                                               *
      *****************************************************************
 
     FGLACDRPD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLACDRF:DRIVEF)
     F                                     COMMIT
     F                                     USROPN
 
     FGLACIXPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLACIXF:INDEXF)
     F                                     COMMIT
     F                                     USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     80 - READ indicator for GLACDRPD                          *
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
 
     D SubtaskNo       S              3P 0
     D BLKSZE          S                   INZ LIKE(RECCNT)
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    SubtaskNo
     C                   PARM                    RECCNT           10 0
 
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
 
     C                   OPEN      GLACDRPD
     C                   OPEN      GLACIXPD
     C     1             CHAIN     GLACIXPD
 
      ** If index record not found: Set FROM and TO RRNs
 
     C                   IF        NOT %FOUND(GLACIXPD)
     C                   Z-ADD     1             GLFRRN
     C                   Z-ADD     BLKSZE        GLTRRN
 
     C     GLTRRN        IFGE      RECCNT
     C                   Z-ADD     9999999999    GLTRRN
     C                   ENDIF
 
      ** Write index record
 
     C                   WRITE     INDEXF
 
     C                   ELSE
 
 
      ** Index record found: Set FROM and TO RRNs
 
      ** Set From and To RRN to 9999999999 when total record of file
      **  less than the Subtask No set for the component in CBCMPNPD
     C                   IF        GLTRRN = 9999999999
     C                   Z-ADD     9999999999    GLFRRN
     C                   ELSE
     C     BLKSZE        ADD       GLFRRN        GLFRRN
     C     BLKSZE        ADD       GLFRRN        GLTRRN
     C     GLTRRN        SUB       1             GLTRRN
 
     C     GLTRRN        IFGE      RECCNT
     C                   Z-ADD     9999999999    GLTRRN
     C                   ENDIF
     C                   ENDIF
 
      ** Update index record
 
     C                   UPDATE    INDEXF
     C                   ENDIF
 
      ** Create the Driver record
 
     C                   Z-ADD     GLFRRN        GLFERN
     C                   Z-ADD     GLTRRN        GLTERN
 
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
 
      ** If total eq RECCNT found on file: EOF
 
     C     GLTRRN        IFGE      RECCNT
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   CLOSE     GLACDRPD
     C                   CLOSE     GLACIXPD
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
 
      ** Distribute records evenly to subtasks
 
     C                   EVAL      BLKSZE = %DIV(RECCNT:SubtaskNo)
     C                   IF        BLKSZE = 0
     C                   EVAL      BLKSZE = 1
     C                   ELSE
     C                   IF        %REM(RECCNT:SubtaskNo) > 0
     C                   EVAL      BLKSZE = BLKSZE + 1
     C                   ENDIF
     C                   ENDIF
 
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
