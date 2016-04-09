     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Update CLEAR Header/Trailer')       *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL008145 - Update Header/Trailer of CLEARxx                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GL Items in Clearing Header
     FCLEARHH   UF A E             DISK    INFSR(*PSSR)
 
      ** Midas GL Items in Clearing Detail
     FCLEARPD   IF   E             DISK    INFSR(*PSSR)
 
      ** Midas GL Items in Clearing Trailer
     FCLEARZZ   UF A E             DISK    INFSR(*PSSR)
 
      ** Midas GL Stamp Tax Average Balance Postings Dtl
     FGLGESTPD  UF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:GLGESTPF)
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D @RUN            S              1A
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** API Validation Error Array Declarations
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** API Validation X Error Array Declarations
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Data structure for module ICD file
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      **  Short data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
 
     D W0DATA          DS           256
     D I#PT1                   1      1
     D I#PTY1                  2     36
     D I#PT2                  37     37
     D I#PTY2                 38     72
     D I#CCY                  73     75
     D O#CUST                 76     81
     D O#CYCD                 82     84
     D O#ACCD                 85     94
     D O#ACSN                 65     96
     D O#BRCD                 97     99
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C                   EXSR      SRINIT
      *
      * Read accounts until end of file
      *
     C                   READ      APOSTHHF                               75
      *
     C     *IN75         IFEQ      *ON
     C                   CLEAR                   APOSTHHF
     C                   MOVE      'H'           RECI
     C                   WRITE     APOSTHHF
     C                   END
      *
      * Read Clearpd
      *
     C                   CLEAR                   TPSTA
     C                   CLEAR                   TNORE
     C                   CLEAR                   THRDC
     C                   CLEAR                   THRWN
     C                   MOVE      *OFF          *IN75
      *
     C                   READ      APOSTPDF                               75
      *
     C     *IN75         DOWEQ     *OFF
      *
     C                   ADD       PSTA          TPSTA
     C                   ADD       1             TNORE
      *
      * Read next record
     C                   READ      APOSTPDF                               75
     C                   ENDDO
      *
      * calculate totals
     C     TPSTA         DIV       1000          THRWN
     C                   MVR                     THRDC
      *
      * Update trailer
      *
     C                   CLEAR                   APOSTZZF
      *
     C                   READ      APOSTZZF                               75
      *
     C                   MOVE      'T'           RECI
     C     2             ADD       TNORE         NORE1
     C                   Z-ADD     THRDC         HRDC
     C                   Z-ADD     THRWN         HRWN
      *
     C     *IN75         IFEQ      *ON
     C                   WRITE     APOSTZZF
     C                   ELSE
     C                   UPDATE    APOSTZZF
     C                   END
     C                   MOVE      *OFF          *IN75
      *
     C                   READ      GLGESTPF                               75
      *
     C     *IN75         DOWEQ     *OFF
      *
     C     PSTD          IFLT      VALD
     C                   DELETE    GLGESTPF
     C                   END
      *
      * Read next record
     C                   READ      GLGESTPF                               75
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
      *
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initial Processing                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'GL008145'    DBPGM
     C                   MOVEL     'AOBANKR0'    DBFILE
     C                   MOVEL     'CALL    '    DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   ELSE
     C                   MOVE      *OFF          *IN98
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   END
     C                   END
      *
     C     *LIKE         DEFINE    NORE1         TNORE
     C     *LIKE         DEFINE    HRDC          THRDC
     C     *LIKE         DEFINE    HRWN          THRWN
     C                   Z-ADD     0             TPSTA            30 0
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      ****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2010
