     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Daily Journal Split Copy Data')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0340T2 - Midas GL Daily Journal Task Split Copy Data       *
      *                                                               *
      *  Function:  This program will copy a block of records from    *
      *             the old driver LF/SACBL to a member in the        *
      *             new driver PF/GYDLYPPD.                           *
      *                                                               *
      *  Called By: GLC0340T2                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1097218          Date 05Apr13               *
      *  Prev Amend No. CGL120   *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1097218 - GLC0720 seq 10001 failed Out of Balance          *
      *  CGL120 - GL COB Components Task Split                        *
      *                                                               *
      *****************************************************************
      *
     FSACBL     IF   E           K DISK    INFSR(*PSSR)
      *
     F***ACJND**   IF   F  620    25AIDISK    INFSR(*PSSR)                                 AR1097218
     FACJND     IF   F  620    29AIDISK    INFSR(*PSSR)                                    AR1097218
     F                                     KEYLOC(2)
      *
     FGLDLYPPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLDLYF:DRIVEF)
     F                                     USROPN
     F                                     COMMIT
      *
     FGLDLYIPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLDLYFI:INDEXF)
     F                                     COMMIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     01 - ACJND record                                         *
      *     50 - Indicator for dummy read of GLDLYPPD                 *
      *     80 - READ indicator for GLDLYIPD                          *
      *     81 - READ indicator for SACBL                             *
      *     82 - READ indicator for ACJND                             *
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
     D SACBLK          DS
      *
      ** SACBL Key Fields
      *
     D  SABRCA                 1      3
     D  SACCY                  4      6
     D  SAACOD                 7     16  0
     D  SARIND                17     17  0
     D  SACNUM                18     23
     D  SAACSQ                24     25  0
      *
     D ACJNDK          DS
      *
      ** ACJND Key Fields
      *
     D  PBRCA                  1      3
     D  PCCY                   4      6
     D  PACOD                  7     16  0
     D  PRIND                 17     17  0
     D  PCNUM                 18     23
     D  PACSQ                 24     25  0
      *
     D KEYDS           DS
     D  KBRCA                  1      3
     D  KCCY                   4      6
     D  KACOD                  7     16  0
     D  KRIND                 17     17  0
     D  KCNUM                 18     23
     D  KACSQ                 24     25  0
      *
     D KPRDS           DS                                                                  AR1097218
     D  BRCAK                  1      3                                                    AR1097218
     D  CCYK                   4      6                                                    AR1097218
     D  ACODK                  7     16  0                                                 AR1097218
     D  RINDK                 17     17  0                                                 AR1097218
     D  CNUMK                 18     23                                                    AR1097218
     D  ACSQK                 24     25  0                                                 AR1097218
     D  KPRFC                 26     29                                                    AR1097218
      *                                                                                    AR1097218
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     IABEXAGF
      *
      ** Rename fields for SACBL format
      *
     I              RECI                        SARECI
     I              BRCA                        SABRCA
     I              CCY                         SACCY
     I              ACODQQ                      SAACDQ
     I              RIND                        SARIND
     I              CNUM                        SACNUM
     I              ACSQ                        SAACSQ
     I              CRBL                        SACRBL
     I              DRBL                        SADRBL
     I              ZZ004                       SAZZ04
     I              ACOD                        SAACOD
      *
     IINDEXF
      *
      ** Rename fields for GLDLYIPD format
      *
     I              RECI                        WRECI
     I              BRCA                        WBRCA
     I              CCY                         WCCY
     I              ACODQQ                      WACODQ
     I              RIND                        WRIND
     I              CNUM                        WCNUM
     I              ACSQ                        WACSQ
     I              CRBL                        WCRBL
     I              DRBL                        WDRBL
     I              ZZ004                       WZZ004
     I              ACOD                        WACOD
      *
     IACJND     NS  01
     I                                  1    1  PRECI
     I                                  2    7  PCNUM
     I                                  8   10  PCCY
     I                                 15   16 0PACSQ
     I                                103  105  PBRCA
     I                                106  106 0PRIND
     I                                131  134  PPRFC
     I                                590  599 0PACOD
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    RECTOT            7 0
     C                   PARM                    RTCODE            3
      *
     C                   OPEN      GLDLYPPD
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
     C     *START        SETLL     GLDLYIPD
     C                   READ      GLDLYIPD                               80
      *
     C     *IN80         IFEQ      '1'
     C     *LOVAL        SETLL     ACJND
     C                   ELSE
     C                   MOVE      WBRCA         KBRCA
     C                   MOVE      WCCY          KCCY
     C                   Z-ADD     WACOD         KACOD
     C                   Z-ADD     WRIND         KRIND
     C                   MOVE      WCNUM         KCNUM
     C                   Z-ADD     WACSQ         KACSQ
     C                   MOVEL     KEYDS         KPRDS                                     AR1097218
     C                   MOVE      PRFC          KPRFC                                     AR1097218
     C     KEYDS         SETLL     ACJND
     C                   ENDIF
      *
     C                   READ      ACJND                                  82
      *
     C     PRECI         DOWNE     'P'
     C     *IN82         ANDNE     *ON
     C                   READ      ACJND                                  82
     C                   ENDDO
      *
      ** Copy records to the new driver file until the limit
      ** specified in the input parameter (RECTOT) is reached.
      *
     C     *IN82         DOWNE     '1'
     C                   MOVE      PBRCA         KBRCA
     C                   MOVE      PCCY          KCCY
     C                   Z-ADD     PACOD         KACOD
     C                   Z-ADD     PRIND         KRIND
     C                   MOVE      PCNUM         KCNUM
     C                   Z-ADD     PACSQ         KACSQ
     C     KEY           CHAIN     ABEXAGF                            81
      *
      ** Process when record found on both SACBL and ACJND files
      *
     C     *IN81         IFEQ      *OFF
      *
     C                   MOVE      SARECI        RECI
     C                   MOVE      SABRCA        BRCA
     C                   MOVE      SACCY         CCY
     C                   Z-ADD     SAACDQ        ACODQQ
     C                   MOVE      SARIND        RIND
     C                   MOVE      SACNUM        CNUM
     C                   Z-ADD     SAACSQ        ACSQ
     C                   MOVE      SACRBL        CRBL
     C                   MOVE      SADRBL        DRBL
     C                   MOVE      SAZZ04        ZZ004
     C                   Z-ADD     SAACOD        ACOD
     C                   MOVEL     PPRFC         PRFC
     C                   WRITE     DRIVEF
     C                   ADD       1             TOT
      *
     C                   MOVE      SABRCA        SBRCA             3
     C                   MOVE      SACCY         SCCY              3
      *
     C                   MOVE      BRCA          KBRCA
     C                   MOVE      CCY           KCCY
     C                   Z-ADD     ACOD          KACOD
     C                   Z-ADD     RIND          KRIND
     C                   MOVE      CNUM          KCNUM
     C                   Z-ADD     ACSQ          KACSQ
     C                   MOVEL     KEYDS         KPRDS                                     AR1097218
     C                   MOVE      PRFC          KPRFC                                     AR1097218
      *
      ** Write all Profit Centre records that not blank
      *
     C                   EXSR      SRPRFC
     C     KEYDS         SETGT     ACJND
      *
     C                   READ      ACJND                                  82
     C     PRECI         DOWNE     'P'
     C     *IN82         ANDNE     *ON
     C                   READ      ACJND                                  82
     C                   ENDDO
      *
      ** *IN81 is *ON
      *
     C                   ELSE
      *
     C                   MOVEL     'X'           RECI
     C                   MOVEL     PBRCA         BRCA
     C                   MOVEL     PCCY          CCY
     C                   Z-ADD     *ZERO         ACODQQ
     C                   Z-ADD     PRIND         RIND
     C                   MOVEL     PCNUM         CNUM
     C                   Z-ADD     PACSQ         ACSQ
     C                   Z-ADD     *ZERO         CRBL
     C                   Z-ADD     *ZERO         DRBL
     C                   MOVEL     *BLANKS       ZZ004
     C                   Z-ADD     PACOD         ACOD
     C                   MOVEL     PPRFC         PRFC
     C                   WRITE     DRIVEF
     C                   ADD       1             TOT
      *
     C                   MOVE      PBRCA         SBRCA             3
     C                   MOVE      PCCY          SCCY              3
      *
     C                   MOVE      PBRCA         KBRCA
     C                   MOVE      PCCY          KCCY
     C                   Z-ADD     PACOD         KACOD
     C                   Z-ADD     PRIND         KRIND
     C                   MOVE      PCNUM         KCNUM
     C                   Z-ADD     PACSQ         KACSQ
     C                   MOVEL     KEYDS         KPRDS                                     AR1097218
     C                   MOVE      PPRFC         KPRFC                                     AR1097218
      *
      ** Write all Profit Centre records that are not blank
      *
     C                   EXSR      SRPRFC
     C     KEYDS         SETGT     ACJND
      *
     C                   READ      ACJND                                  82
     C     PRECI         DOWNE     'P'
     C     *IN82         ANDNE     *ON
     C                   READ      ACJND                                  82
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Keep going after record limit if still same combination of key
      *
     C     PBRCA         IFNE      SBRCA
     C     PCCY          ORNE      SCCY
     C     TOT           IFGE      RECTOT
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Set up fields for Index file with data from last record
      ** written.
      *
     C                   MOVE      SARECI        WRECI
     C                   MOVE      PBRCA         WBRCA
     C                   MOVE      PCCY          WCCY
     C                   Z-ADD     SAACDQ        WACODQ
     C                   MOVE      PRIND         WRIND
     C                   MOVE      PCNUM         WCNUM
     C                   Z-ADD     PACSQ         WACSQ
     C                   MOVE      SACRBL        WCRBL
     C                   MOVE      SADRBL        WDRBL
     C                   MOVE      SAZZ04        WZZ004
     C                   Z-ADD     PACOD         WACOD
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
     C                   CLOSE     GLDLYPPD
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
      ** If end of file on SACBL set return code to notify server
      *
     C     *IN82         IFEQ      '1'
     C     TOT           IFEQ      0
     C                   MOVE      'NRF'         RTCODE
     C                   ELSE
     C                   MOVE      'EOF'         RTCODE
     C                   ENDIF
     C                   ENDIF
      *
     C     RTCODE        IFEQ      'NRF'
     C     RTCODE        OREQ      'EOF'
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
      ** KLIST for setting file pointer to next record to be copied
      ** first key field is *none for RECI of header file format in logical
      *
     C     KEY           KLIST
     C                   KFLD                    KBRCA             3
     C                   KFLD                    KCCY              3
     C                   KFLD                    KACOD            10 0
     C                   KFLD                    KRIND             1 0
     C                   KFLD                    KCNUM             6
     C                   KFLD                    KACSQ             2 0
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Dummy READ to GLDLYPPD for compilation purpose
      *
     C     *IN50         IFEQ      '1'
     C                   READ      GLDLYPPD                               50
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
      * SR/SRPRFC Write all non blank profit centres                  *
      *                                                               *
      * Called by: MAIN PROCESSING                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     SRPRFC        BEGSR
     C                   MOVEL     PRFC          SPRFC
      *
      ** Check if end of this key combination
      *
     C     *IN83         DOUEQ     *ON
      *
      ** Not end of this key combination:
      ** Check if PRFC is not blank and different from previous
      *
     C     PPRFC         IFNE      SPRFC
      *
      ** PRFC is not blank and is different from previous: write to driver file
      *
     C                   MOVEL     PPRFC         PRFC
     C                   WRITE     DRIVEF
     C                   ADD       1             TOT
     C                   ENDIF
      *
     C                   MOVE      PPRFC         SPRFC             4
     C                   MOVE      PPRFC         KPRFC                                     AR1097218
     C     KPRDS         SETGT     ACJND                                                   AR1097218
     C     KEYDS         READE     ACJND                                9083
     C                   ENDDO
     C                   ENDSR
