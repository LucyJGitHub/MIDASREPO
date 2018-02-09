     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Balances Task Split Copy Data')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL43T2 - Midas GL Balances Task Split Copy Data              *
      *                                                               *
      *  Called By: GLC43T2                                           *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL061A *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL061A - Statements Task Split Processing                   *
      *                                                               *
      *****************************************************************
      *
     FSTMTS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(STMTHHF)
     F                                     IGNORE(STMTZXF)
      *
     FGLSTAMPD  UF A E             DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(STAMPD0:DRIVEF)
     F                                     COMMIT
      *
     FGLSTMIPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(STAMPD0:INDEXF)
     F                                     COMMIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     50 - Indicator for dummy read of GLSTAMPD                 *
      *     80 - READ indicator for GLSTMIPD                          *
      *     81 - READ indicator for STMTS                             *
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
      ** Array containing Copyright statement
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     IINDEXF
      *
      ** Rename fields for GLSTMIPD format
      *
     I              S#BRCA                      WBRCA
     I              S#CNUM                      WCNUM
     I              S#CCY                       WCCY
     I              S#ACOD                      WACOD
     I              S#ACSQ                      WACSQ
     I              S#ATYP                      WATYP
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    RECTOT            7 0
     C                   PARM                    RTCODE            3
      *
     C                   OPEN      GLSTAMPD
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
     C                   Z-ADD     0             TOT               7 0
      *
      ** SETLL to the index file.
      *
     C     1             SETLL     GLSTMIPD
      *
      ** Check the Index file and set the file pointer to the next
      ** driver record to be copied accordingly.
      *
     C                   READ      GLSTMIPD                               80
      *
     C     *IN80         IFEQ      '1'
     C     *LOVAL        SETLL     STMTAHF
     C                   ELSE
     C                   MOVE      WBRCA         KBRCA
     C                   MOVE      WCNUM         KCNUM
     C                   MOVE      WCCY          KCCY
     C                   Z-ADD     WACOD         KACOD
     C                   Z-ADD     WACSQ         KACSQ
     C                   MOVE      WATYP         KATYP
     C     KEY           SETGT     STMTAHF
     C                   ENDIF
      *
      ** Copy records to the new driver file until the limit
      ** specified in the input parameter (RECTOT) is reached.
      *
     C     TOT           DOUEQ     RECTOT
     C     *IN81         OREQ      '1'
      *
     C                   READ      STMTAHF                                81
     C     *IN81         IFEQ      '0'
      *
      ** Set-up first record read.
      *
     C     TOT           IFEQ      0
     C                   MOVE      ATYP          S#ATYP
     C                   MOVE      BRCA          S#BRCA
     C                   MOVE      CNUM          S#CNUM
     C                   MOVE      CCY           S#CCY
     C                   Z-ADD     ACSQ          S#ACSQ
     C                   Z-ADD     ACOD          S#ACOD
     C                   ENDIF
      *
     C                   ADD       1             TOT
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Output record for driver file.
      *
     C     TOT           IFGT      0
     C                   MOVE      ATYP          E#ATYP
     C                   MOVE      BRCA          E#BRCA
     C                   MOVE      CNUM          E#CNUM
     C                   MOVE      CCY           E#CCY
     C                   Z-ADD     ACSQ          E#ACSQ
     C                   Z-ADD     ACOD          E#ACOD
     C                   WRITE     DRIVEF
     C                   ENDIF
      *
      ** Set up fields for Index file with data from last record
      ** written.
      *
     C                   MOVE      ATYP          WATYP
     C                   MOVE      BRCA          WBRCA
     C                   MOVE      CNUM          WCNUM
     C                   MOVE      CCY           WCCY
     C                   Z-ADD     ACSQ          WACSQ
     C                   Z-ADD     ACOD          WACOD
     C                   MOVE      *BLANKS       E#ATYP
     C                   MOVE      *BLANKS       E#BRCA
     C                   MOVE      *BLANKS       E#CNUM
     C                   MOVE      *BLANKS       E#CCY
     C                   Z-ADD     0             E#ACSQ
     C                   Z-ADD     0             E#ACOD
      *
      ** If Index file is empty write new record to it, else update
      ** with details of last record written.
      *
     C     *IN80         IFEQ      '1'
     C                   WRITE     INDEXF
     C                   ELSE
     C                   UPDATE    INDEXF
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
      ** If end of file on STMTS set return code to notify server
      *
     C     *IN81         IFEQ      '1'
     C     TOT           IFEQ      0
     C                   MOVE      'NRF'         RTCODE
     C                   ELSE
     C                   MOVE      'EOF'         RTCODE
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   ENDIF
      *
     C                   CLOSE     GLSTAMPD
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
      ** first key field is *none for RECI of header file format in logical
      *
     C     KEY           KLIST
     C                   KFLD                    KBRCA             3
     C                   KFLD                    KCNUM             6
     C                   KFLD                    KCCY              3
     C                   KFLD                    KACOD            10 0
     C                   KFLD                    KACSQ             2 0
     C                   KFLD                    KATYP             1
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Dummy READ to GLSTAMPD for compilation purpose
      *
     C     *IN50         IFEQ      '1'
     C                   READ      GLSTAMPD                               50
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
(c) Finastra International Limited 2012
