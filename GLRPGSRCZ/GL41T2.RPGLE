     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL EOD Posting Merge: Create driver records')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL41T2 - Midas GL Balances Task Split Copy Data              *
      *                                                               *
      *  Function:  This program set the from and to RRNs to process  *
      *                                                               *
      *  Called By: GLC41T2                                           *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL120  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL120 - GL COB Components Task Split                        *
      *                                                               *
      *****************************************************************
      *
     FGLACDV01  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLACPDPF:DETAILS)
      *
     FGLACPNPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLACPNF:INDEXF)
     F                                     COMMIT
      *
     FGLACPSPD  O  A E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLACPSF:DRIVEF)
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
      *     81 - READ indicator for GLACPNPD                          *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    BLKSZE            7 0
     C                   PARM                    RTCODE            3
      *
     C                   OPEN      GLACPSPD
      *
      ** Initial processing
      *
     C                   EXSR      INIT
      *
      ** Split records into new file
      *
     C                   EXSR      TSPLIT
      *
      ** End processing
      *
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
      *
      ** Read in the index file to get the last FROM and TO RRNs
      *
     C     *START        SETLL     GLACPNPD
     C                   READ      INDEXF                                 81
      *
      ** Check if index record not found
      *
     C     *IN81         IFEQ      '1'
      *
      ** Index record not found: Initialise block details
      *
     C     *LOVAL        SETLL     DETAILS
     C                   EXSR      INIBLK
      *
      ** Write index record
      *
     C                   WRITE     INDEXF
     C                   ELSE
      *
      ** Index record found: Set the block details
      *
     C                   EXSR      SETBLK
     C                   ENDIF
      *
      ** Create the Driver record
      *
     C                   WRITE     DRIVEF
      *
     C                   COMMIT
     C                   CLOSE     GLACPSPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR/INIBLK - Begin a new block                                 *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     INIBLK        BEGSR
      *
     C                   READ      DETAILS                                81
     C                   MOVE      MBBOF         GLFRFL
     C                   MOVE      MBBOLF        GLFRFM
      *
      ** Index record not found: Set FROM and TO RRNs
      *
     C                   Z-ADD     1             GLFRRN
     C                   Z-ADD     BLKSZE        GLTRRN
     C     GLTRRN        IFGE      MBBOR
     C                   Z-ADD     9999999999    GLTRRN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR/SETBLK - Set a new block                                   *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     SETBLK        BEGSR
      *
     C     GLTRRN        IFEQ      9999999999
     C     GLFRFL        SETGT     DETAILS
     C                   EXSR      INIBLK
     C                   ELSE
     C     GLFRFL        SETLL     DETAILS
     C                   READ      DETAILS                                90
      *
      ** Index record found: Set FROM and TO RRNs
      *
     C     BLKSZE        ADD       GLFRRN        GLFRRN
     C     BLKSZE        ADD       GLFRRN        GLTRRN
     C     GLTRRN        SUB       1             GLTRRN
     C                   ENDIF
      *
     C     GLTRRN        IFGE      MBBOR
     C                   Z-ADD     9999999999    GLTRRN
     C                   ENDIF
      *
      ** Update index record
      *
     C                   UPDATE    INDEXF
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
      *
      ** Check if all records processed from current file
      *
     C     GLTRRN        IFEQ      9999999999
      * All records processed from current file: Read next one
     C                   READ      DETAILS                                81
      *
      ** Check if no ACPO files found to drive task split
      *
     C     *IN81         IFEQ      *ON
      *
      ** No more ACPO files found: Set EOF and finish
      *
     C                   MOVE      'EOF'         RTCODE
     C                   ENDIF
     C                   ENDIF
      *
     C     RTCODE        IFEQ      'EOF'
     C                   SETON                                        LR
     C                   ENDIF
     C                   RETURN
      *
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
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
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
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   ROLBK
     C                   RETURN
      *
     C                   ENDSR
