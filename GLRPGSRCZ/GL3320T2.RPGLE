     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Balances Task Split Copy Data')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL3320T2 - Midas GL Balances Task Split Copy Data            *
      *                                                               *
      *  Function:  This program set the from and to RRNs to process  *
      *                                                               *
      *  Called By: GLC3320T2                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD033737           Date 17May15               *
      *  Prev Amend No. MD024120           Date 19Aug14               *
      *                 CGL120 *CREATE     Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD033737 - GLC3320T2 00009 looping during COB.               *
      *             Applied for MD034243.
      *  MD024120 - GLC3320 Performance Issues                        *
      *  CGL120 - GL COB Components Task Split                        *
      *                                                               *
      *****************************************************************
 
     FGLACBAPD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLACBAF:DRIVEF)
     F                                     COMMIT
     F                                     USROPN                                           MD024120
 
     FGLACBIPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLACBIF:INDEXF)
     F                                     COMMIT
     F                                     USROPN                                           MD024120
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     80 - READ indicator for GLACBIPD                          *
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
                                                                                            MD024120
     D SubtaskNo       S              3P 0                                                  MD024120
     D BLKSZE          S                   INZ LIKE(RECCNT)                                 MD024120
                                                                                            MD024120
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C**********         PARM                    BLKSZE            7 0                      MD024120
     C                   PARM                    SubtaskNo                                  MD024120
     C                   PARM                    RECCNT           10 0
     C**********         PARM                    RTCODE            3                        MD024120
 
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
 
     C**********         READ      GLACBIPD                               80                MD024120
     C                   OPEN      GLACBAPD                                                 MD024120
     C                   OPEN      GLACBIPD                                                 MD024120
     C     1             CHAIN     GLACBIPD                                                 MD024120
 
      ** If index record not found: Set FROM and TO RRNs
 
     C******IN80*        IFEQ      '1'                                                      MD024120
     C                   IF        NOT %FOUND(GLACBIPD)                                     MD024120
     C                   Z-ADD     1             GLFRRN
     C                   Z-ADD     BLKSZE        GLTRRN
 
     C     GLTRRN        IFGE      RECCNT
     C                   Z-ADD     9999999999    GLTRRN
     C                   ENDIF
 
      ** Write index record
 
     C                   WRITE     INDEXF
 
     C                   ELSE
 
      ** Index record found: Set FROM and TO RRNs
 
      ** Set From and To RRN to 9999999999 when total record of file                        MD033737
      **  less than the Subtask No set for the component in CBCMPNPD                        MD033737
     C                   IF        GLTRRN = 9999999999                                      MD033737
     C                   Z-ADD     9999999999    GLFRRN                                     MD033737
     C                   ELSE                                                               MD033737
     C     BLKSZE        ADD       GLFRRN        GLFRRN
     C     BLKSZE        ADD       GLFRRN        GLTRRN
     C     GLTRRN        SUB       1             GLTRRN
 
     C     GLTRRN        IFGE      RECCNT
     C                   Z-ADD     9999999999    GLTRRN
     C                   ENDIF
     C                   ENDIF                                                              MD033737
 
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
     C***********        MOVE      'EOF'         RTCODE                                     MD024120
     C                   EVAL      *INLR = *ON                                              MD024120
     C                   ENDIF
 
     C**********         SETON                                        LR                    MD024120
     C                   CLOSE     GLACBAPD                                                 MD024120
     C                   CLOSE     GLACBIPD                                                 MD024120
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
                                                                                            MD024120
      ** Distribute records evenly to subtasks                                              MD024120
                                                                                            MD024120
     C                   EVAL      BLKSZE = %DIV(RECCNT:SubtaskNo)                          MD024120
     C                   IF        BLKSZE = 0                                               MD033737
     C                   EVAL      BLKSZE = 1                                               MD033737
     C                   ELSE                                                               MD033737
     C**********         IF        %REM(BLKSZE:SubtaskNo) > 0                      MD024120 MD033737
     C                   IF        %REM(RECCNT:SubtaskNo) > 0                               MD033737
     C                   EVAL      BLKSZE = BLKSZE + 1                                      MD024120
     C                   ENDIF                                                              MD024120
     C                   ENDIF                                                              MD033737
 
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
