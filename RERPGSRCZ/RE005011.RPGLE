     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('MIDAS RE Monthly W/h Tax File Update')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE005011 - Midas RE Monthly Withholding Tax File Update      *
      *                                                               *
      *  Function:  This program will reset the monthly figure.       *
      *  (COB)                                                        *
      *                                                               *
      *  Called By: RE005011 - Monthly Withholding Tax Update         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CGL165  *CREATE    Date 23Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax                                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *         U7+U8    Set on if Database error occurs              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     FREAWTXPD  UF   E           K DISK
      *
      ** Accumulated Withholding Tax File    Retrieval Index
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /EJECT
      ****************************************************************
     D PSDS           SDS
      *
      **  Program Status Data Structure
      *
      **                   Program name
     D  @PGM                   1     10
      *
      **                   Workstation ID
     D  @JOB                 244    253
      *
      **                   User ID
     D  @USER                254    263
      *
     D LDA            UDS           256
      *
      **  Local data area for data base errors.
      *
      **  Group level field of the foll. other fields
     D  DBLOT                134    177
      *
      **  Name of database file in error
     D  DBFILE               134    141
      *
      **  Key value causing database error
     D  DBKEY                142    167
      *
      **  Name of program causing database error
     D  DBPGM                168    175
      *
      **  Number of database error
     D  DBASE                176    177
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**  MIDAS Bank Details
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D**  Short data structure for access programs
     D*
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Index to subroutines                                         *
      *                                                               *
      *            MAIN   - Main Processing                           *
      *            FIRST  - Initialisation                            *
      *            PROC   - Detail Processing                         *
      *            LAST   - Final Processing                          *
      *            DBERR  - Database Error Handling : Terminates prog *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            MAIN   - Main Processing                           *
      *                                                               *
      * CALLS      FIRST  - Initial Processing                        *
      *            PROC   - Detail Processing                         *
      *            LAST   - Final Processing                          *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing
      *
     C                   EXSR      FIRST
      *
      ** Detail processing
      *
     C                   EXSR      PROC
      *
      **  Final Processing
      *
     C                   EXSR      LAST
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            FIRST  - Initialize                                *
      *                                                               *
      * CALLS      DBERR  - Database Error Handling                   *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing                           *
      *                                                               *
      *****************************************************************
     C     FIRST         BEGSR                                                  ** FIRST  **
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialization of LDA
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANK        DBLOT
     C                   OUT       LDA
      *
      ** Move program name
     C                   MOVEL     @PGM          DBPGM
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '001'         DBASE                          * * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                          *  DBERR 001  *
     C                   MOVEL     'SDBANKPD'    DBFILE                         * * * * * * * *
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            PROC   - Detail Processing of file                 *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing                           *
      *                                                               *
      *****************************************************************
     C     PROC          BEGSR                                                  ** PROC   **
      *
     C                   SETOFF                                       11
     C                   READ      REAWTXPD                               11
      *
     C     *IN11         DOWEQ     '0'
      *
      ** RESET MONTHLY FIGURE.
      *
     C                   Z-ADD     0             TMTXA
     C                   Z-ADD     0             TMTXL
      *
      ** Update the record
      *
     C                   UPDATE    REAWTXD0
      *
      ** Get next record
      *
     C                   READ      REAWTXPD                               11
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            LAST   - Terminate                                 *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing                           *
      *                                                               *
      *****************************************************************
     C     LAST          BEGSR                                                  ** LAST   **
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            *PSSR  -                                           *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR                                                  ** *PSSR  **
      *
     C                   DUMP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            INFSR  -                                           *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *****************************************************************
     C     INFSR         BEGSR                                                  ** INFSR  **
      *
     C                   DUMP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            DBERR  - Database Error Handling : Terminates prog *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  FIRST  - Fetching fields from Alternate Cust. Mast *
      *                                                               *
      *****************************************************************
     C     DBERR         BEGSR                                                  ** DBERR  **
      *
     C                   MOVEL     @PGM          DBPGM
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2015
