     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Cleared Balance Update Split Copy Data')      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0349T2 - Midas GL Cleared Balance Update Split Copy Data   *
      *                                                               *
      *  Function:  This program will copy a block of records from    *
      *             the old driver LF/SACPO to a member in the        *
      *             new driver PF/GLCBUSPD.                           *
      *                                                               *
      *  Called By: GLC0349T2                                         *
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
     FSACPO     IF   F  620    24AIDISK    INFSR(*PSSR)
     F                                     KEYLOC(2)
      *
     FGLCBUSPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCBUF:DRIVEF)
     F                                     COMMIT
      *
     FGLCBUIPD  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCBUFI:INDEXF)
     F                                     COMMIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     50 - Indicator for dummy read of GLCBUSPD                 *
      *     80 - READ indicator for GLCBUIPD                          *
      *     81 - READ indicator for SACPO                             *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *
      ** Local data area for database error details
      *
     D LDA           E DS           256    EXTNAME(LDA)
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D DSKEY           DS
     D  KCNUM                  1      6
     D  KCCY                   7      9
     D  KACOD                 10     19  0
     D  KACSQ                 20     21  0
     D  KBRCA                 22     24
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     IINDEXF
      *
      ** Rename fields for GLCBUIPD format
      *
     I              RECI                        WRECI
     I              CNUM                        WCNUM
     I              CCY                         WCCY
     I              ACODQQ                      WACODQ
     I              ACSQ                        WACSQ
     I              BRCA                        WBRCA
     I              LDBL                        WLDBL
     I              CLBL                        WCLBL
     I              ACOD                        WACOD
      *
     ISACPO     NS  01    1 CP
     I                                  1    1  RECI
     I                                  2    7  CNUM
     I                                  8   10  CCY
     I                                 11   14 0ACODQQ
     I                                 15   16 0ACSQ
     I                                103  105  BRCA
     I                                590  599 0ACOD
     I          NS
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    RECTOT            7 0
     C                   PARM                    RTCODE            3
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
      ** Check the Index file and set the file pointer to the next
      ** driver record to be copied accordingly.
      *
     C                   READ      INDEXF                                 80
      *
     C     *IN80         IFEQ      '1'
     C     *LOVAL        SETLL     SACPO
     C                   ELSE
     C                   MOVE      WCNUM         KCNUM
     C                   MOVE      WCCY          KCCY
     C                   Z-ADD     WACOD         KACOD
     C                   Z-ADD     WACSQ         KACSQ
     C                   MOVE      WBRCA         KBRCA
     C     DSKEY         SETGT     SACPO
     C                   ENDIF
      *
      ** Copy records to the new driver file until the limit
      ** specified in the input parameter (RECTOT) is reached.
      *
     C     TOT           DOUEQ     RECTOT
     C     *IN81         OREQ      '1'
      *
     C     *IN01         DOUEQ     *ON
     C     *IN81         OREQ      *ON
     C                   READ      SACPO                                  81
     C                   ENDDO
      *
     C     *IN81         IFEQ      '0'
      *
      ** Only write Driver File record on change of key value
      *
     C     CNUM          IFNE      SVCNUM
     C     CCY           ORNE      SVCCY
     C     ACOD          ORNE      SVACOD
     C     ACSQ          ORNE      SVACSQ
     C     BRCA          ORNE      SVBRCA
     C                   WRITE     DRIVEF
      *
      ** Setup saved key values
      *
     C                   MOVE      CNUM          SVCNUM
     C                   MOVE      CCY           SVCCY
     C                   Z-ADD     ACOD          SVACOD
     C                   Z-ADD     ACSQ          SVACSQ
     C                   MOVE      BRCA          SVBRCA
     C                   ENDIF
      *
      ** Increment record count
      *
     C                   ADD       1             TOT
     C                   ENDIF
     C                   ENDDO
      *
      ** Set up fields for Index file with data from last record
      ** written.
      *
     C                   MOVE      RECI          WRECI
     C                   MOVE      CNUM          WCNUM
     C                   MOVE      CCY           WCCY
     C                   Z-ADD     ACODQQ        WACODQ
     C                   Z-ADD     ACSQ          WACSQ
     C                   MOVE      BRCA          WBRCA
     C                   Z-ADD     LDBL          WLDBL
     C                   Z-ADD     CLBL          WCLBL
     C                   Z-ADD     ACOD          WACOD
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
      ** If end of file on SACPO set return code to notify server
      *
     C     *IN81         IFEQ      '1'
     C     TOT           IFEQ      0
     C                   MOVE      'NRF'         RTCODE
     C                   ELSE
     C                   MOVE      'EOF'         RTCODE
     C                   ENDIF
     C                   ENDIF
      *
     C                   SETON                                        LR
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
     C                   KFLD                    KCNUM             6
     C                   KFLD                    KCCY              3
     C                   KFLD                    KACOD            10 0
     C                   KFLD                    KACSQ             2 0
     C                   KFLD                    KBRCA             3
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Define Save Fields
      *
     C     *LIKE         DEFINE    CNUM          SVCNUM
     C     *LIKE         DEFINE    CCY           SVCCY
     C     *LIKE         DEFINE    ACOD          SVACOD
     C     *LIKE         DEFINE    ACSQ          SVACSQ
     C     *LIKE         DEFINE    BRCA          SVBRCA
      *
      ** Dummy READ to GLCBUSPD for compilation purpose
      *
     C     *IN50         IFEQ      '1'
     C                   READ      DRIVEF                                 50
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
