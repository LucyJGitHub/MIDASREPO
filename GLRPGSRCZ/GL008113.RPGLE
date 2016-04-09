     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Merge Postings into GLGEST')        *
/*OVR *  OVRDBF FILE(GESUHH) TOFILE(GLGESTHH) SHARE(*NO)              *
/*OVR *  OVRDBF FILE(GESUPD) TOFILE(GLSTDTPD) SHARE(*NO)              *
/*OVR *  OVRDBF FILE(GESUZZ) TOFILE(GLSTTRPD) SHARE(*NO)              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL008113 - Merge Postings into GLGEST                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR821972           Date 07Sep11               *
      *  Prev Amend No. CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
/*    *  AR821972 - Stamp tax on debit interest did not generate      *
/*    *             amount in GLVCLSIN (Recompile)                    *
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
 
      ** Midas GL Stamp Tax Postings
     FGLVCPSPD  IP   E             DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:@VCPSPP)
 
      ** Midas GL Stamp Tax Average Balance Postings Dtl
     FGESUPD    O    E             DISK    INFSR(*PSSR)
 
      ** Midas GL Stamp Tax Average Balance Postings Hdr
     FGESUHH    UF A E             DISK    INFSR(*PSSR)
 
      ** Midas GL Stamp Tax Average Balance Postings Trl
     FGESUZZ    UF A E             DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D @RUN            S              1A
     D #RECS           S              9S 0
     D #HASH           S             18S 0
     D ##003N          S              3S 0
     D ##005N          S              5S 0
     D BIS@            S             80A
     D #FIRST          S              1A
 
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Main Processing
     C     #FIRST        IFNE      'Y'
     C                   EXSR      SRINIT
     C                   ENDIF
      *
      ** Output to GESUPD
      *
     C                   WRITE     APOSTPDF
      *
      ** Keep count of postings and amounts
      *
     C                   ADD       1             #RECS
     C                   ADD       PSTA          #HASH
      *
      ** If last record update trailer
      *
     CLR                 EXSR      SREND
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND - End Processing                                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SREND         BEGSR
      *
      **  If no records do not update trailer
      *
     C     #RECS         CABEQ     0             EXEND
      *
      **  Read trailer record
      *
     C     1             SETLL     APOSTZZF
     C                   READ      APOSTZZF                               90
      *
      **  If record update
      *
     C     *IN90         IFEQ      *OFF
      *
      **  Adjust trailer
      *
     C                   ADD       #RECS         NORE1
     C     *LIKE         DEFINE    HRWN          #RWN
     C     #HASH         DIV       1000          #RWN
     C                   ADD       #RWN          HRWN
     C     *LIKE         DEFINE    HRDC          #RDC
     C                   Z-ADD     #HASH         #RDC
      *
      ** Add to 5 numeric and then add file value
      *
     C                   Z-ADD     #RDC          ##005N
     C                   ADD       HRDC          ##005N
      *
      ** Add low portion to decimal and high to integers
      *
     C                   Z-ADD     ##005N        HRDC
     C     ##005N        DIV       1000          ##003N
     C                   ADD       ##003N        HRWN
      *
     C                   UPDATE    APOSTZZF
      *
     C                   ELSE
      *
      ** If no record write records
      ** Adjust trailer for header and trailer records
      *
     C                   ADD       2             #RECS
      *
      ** Adjust trailer
      *
     C                   MOVEL     'T'           RECI
     C                   Z-ADD     #RECS         NORE1
     C     #HASH         DIV       1000          HRWN
     C                   Z-ADD     #HASH         HRDC
      *
     C                   WRITE     APOSTZZF
      *
      ** Write header if necessary
      *
     C     1             CHAIN     APOSTHHF                           90
     C                   READ      APOSTZZF                               90
     C     *IN90         IFEQ      *ON
     C                   MOVEL     'H'           RECI
     C                   Z-ADD     99999         FLSZ
     C                   WRITE     APOSTHHF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EXEND         TAG
      *
     C                   ENDSR
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
      *
     C                   MOVEA     CPY@          BIS@
      *
      **  Set up LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'GL008113'    DBPGM
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA
      *
      **  Access SDBANKPD for report title
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If no record is found on sdbankpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '001'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Access SDMMODPD for modules available
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** If no record is found on sdmmodpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '002'         DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** Set initialisation complete
      *
     C                   MOVEL     'Y'           #FIRST
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
