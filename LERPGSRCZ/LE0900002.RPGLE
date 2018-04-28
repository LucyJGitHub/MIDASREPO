     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE Matured Loans History Processing')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE0900002 - Midas LE Matured Loans History Processing        *
      *                                                               *
      *  Function:  This program will copy a block of records from    *
      *             the old driver LF/LEHISSL0 to a member in the     *
      *             new driver PF/LEHISUPD.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD024318           Date 13Jan14               *
      *  Prev Amend No. CLE137   *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024318 - COB Component LEC1001 00001 ends in error         *
      *  CLE137 - LE Monthly History processing                       *
      *                                                               *
      *****************************************************************
      *
     FLEHISSL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(HISTSHNF)
     F                                     IGNORE(HISTSHPF)
     F                                     IGNORE(HISTSHQF)
      *
     FLEHISUPD  UF A E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
      *
     FLEHISIPD  UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     50 - Indicator for dummy read of LEHISUPD                 *
      *     80 - READ indicator for LEHISIPD                          *
      *     81 - READ indicator for LEHISSL0                          *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      ** Array containing Copyright statement
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     ILEHISIF
      ** Rename fields for LEHISIPD format
     I              BRCA                        WBRCA
     I              CNUM                        WCNUM
     I              LNRF                        WLNRF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    RECTOT            7 0
     C                   PARM                    RTCODE            3
      *
     C                   OPEN      LEHISUPD
      *
      ** Initial processing
      *
     C     RUNONE        IFEQ      ' '
     C                   EXSR      INIT
     C                   MOVE      'Y'           RUNONE            1
     C                   ENDIF
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
     C**********         Z-ADD     1             TOT               7 0                      MD024318
     C                   Z-ADD     0             TOT               7 0                      MD024318
      *
      **  SETLL to the index file.
      *
     C     1             SETLL     LEHISIPD
      *
      ** Check the Index file and set the file pointer to the next
      ** driver record to be copied accordingly.
      *
     C                   READ      LEHISIPD                               80
      *
     C     *IN80         IFEQ      '1'
     C     *LOVAL        SETLL     HISTSHMF
     C                   ELSE
     C                   MOVE      WBRCA         KBRCA
     C                   MOVE      WCNUM         KCNUM
     C                   MOVE      WLNRF         KLNRF
     C     KEY           SETGT     HISTSHMF
     C                   ENDIF
      *
      ** Copy records to the new driver file until the limit
      ** specified in the input parameter (RECTOT) is reached.
      *
     C     *IN81         DOUEQ     '1'
      *
     C                   READ      HISTSHMF                               81
      *
     C     TOT           IFGE      RECTOT
     C                   LEAVE
     C                   ENDIF
      *
     C     *IN81         IFEQ      '0'
      *
      ** Write first record, if there is one.
      *
     C*****TOT**         IFEQ      1                                                        MD024318
     C     TOT           IFEQ      0                                                        MD024318
     C                   MOVE      'A'           RECID
      *
      ** Output Timestamp.
      *
     C                   CALL      'ZAGENTS'
     C                   PARM                    TMST             26
     C                   WRITE     LEHISUF
     C                   ENDIF
      *
     C                   ADD       1             TOT
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Write last record, if there is one.
      *
     C     TOT           IFGT      0
     C                   MOVE      'Z'           RECID
      *
      ** Output Timestamp.
      *
     C                   CALL      'ZAGENTS'
     C                   PARM                    TMST
     C                   WRITE     LEHISUF
     C                   ENDIF
      *
      ** Set up fields for Index file with data from last record
      ** written.
      *
     C                   MOVE      BRCA          WBRCA
     C                   MOVE      CNUM          WCNUM
     C                   MOVE      LNRF          WLNRF
      *
      ** If Index file is empty write new record to it, else update
      ** with details of last record written.
      *
     C     *IN80         IFEQ      '1'
     C                   WRITE     LEHISIF
     C                   ELSE
     C                   UPDATE    LEHISIF
     C                   ENDIF
      *
     C                   COMMIT
      *
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
      ** If end of file on LEHISSL0 set return code to notify server
      *
     C     *IN81         IFEQ      '1'
     C     TOT           IFEQ      0
     C                   MOVE      'NRF'         RTCODE
     C                   ELSE
     C                   MOVE      'EOF'         RTCODE
     C                   ENDIF
     C                   ENDIF
      *
     C                   CLOSE     LEHISUPD
      *
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
      ** KLIST for setting file pointer to next record to be copied
      *
     C     KEY           KLIST
     C                   KFLD                    KBRCA             3
     C                   KFLD                    KCNUM             6
     C                   KFLD                    KLNRF             6
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Dummy READ to LEHISUPD for compilation purpose
      *
     C     *IN50         IFEQ      '1'
     C                   READ      LEHISUPD                               50
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
