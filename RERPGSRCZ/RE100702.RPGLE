     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Rev Sweeping/Target Balancing Entry Merge')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100702 - Reverse Sweeping/Target Balancing Entry merge     *
      *                                                               *
      *  Function:  This program extracts postings/extension records  *
      *             for reverse sweeping/target balancing.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CRE008  *CREATE    Date 04Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRERSTDL0  UF   E           K DISK    INFSR(*PSSR)
     FRERSTIL0  UF   E           K DISK    INFSR(*PSSR)
     FGLPSTTL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:GLPSTTD0)
     FGLPSTZSL0 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLAPZSD0: GLPSTZSD0)
 
     FGECXPD    O  A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:GECXF)
     FGLAPSTZS  O  A E           K DISK    INFSR(*PSSR)
 
      * Reverse Sweeping/Target Balancing Entry merge Audit
     FRE100702AUO    E             PRINTER
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
 
      ** File Information Data Structure for RE100702AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - short data structure
 
 
      /SPACE 5
 
      * Read all reverse sweep/target balancing records
 
     C                   READ      RERSTDD0                               60
 
     C     *IN60         DOWEQ     *OFF
 
      * Delete the reverse sweep/target balancing details record
 
     C                   DELETE    RERSTDD0
 
      * Increment count
 
     C                   ADD       1             RTCOUNT
 
      * Read all items for a reverse sweep/target balancing
 
     C                   EXSR      READ_ITEMS
 
      * Read next reverse sweep/target balancing record
 
     C                   READ      RERSTDD0                               60
     C                   ENDDO
 
      * Write Audit Report
 
     C                   EXSR      AUDIT
 
     C                   SETON                                        LR
     C                   RETURN
 
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Read all items for a reverse sweep/target balancing
      ********************************************************************
     C     READ_ITEMS    BEGSR
 
      * For each reverse sweep/target balancing, access related item(s)
 
     C     RVTBK         SETLL     RERSTID0
     C     RVTBK         READE     RERSTID0                               60
 
      * For each item
 
     C     *IN60         DOWEQ     *OFF
 
      * Delete the item record
 
     C                   DELETE    RERSTID0
 
      * Get 'posting in transit'
      * (If no record is found, it's a database error)
 
     C     POSTK         CHAIN     GLPSTTD0                           60
     C     *IN60         IFEQ      *ON
     C                   MOVE      RIXRFN        WERMS
     C                   EVAL      X_ERMS = 'No GLPSTTPD for ' + %TRIML(WERMS)
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Delete 'posting in transit'
 
     C                   DELETE    GLPSTTD0
 
      * Write the posting to the generated entries file
 
     C                   Z-ADD     BJRDNB        PSTD
     C                   WRITE     GECXF
     C                   ADD       1             PCOUNT
 
      * Get 'posting in transit' extension
      * (If no record is found, it's a database error)
 
     C     POSTK         CHAIN     GLPSTZSD0                          60
     C     *IN60         IFEQ      *ON
     C                   MOVE      RIXRFN        WERMS
     C                   EVAL      X_ERMS = 'No GLPSTZSPD for ' + %TRIML(WERMS)
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Delete 'posting in transit' extension
 
     C                   DELETE    GLPSTZSD0
 
      * Write the extension to the extension file
 
     C                   WRITE     GLAPZSD0
 
      * Read the next item
 
     C     RVTBK         READE     RERSTID0                               60
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * AUDIT - Write Audit Report.
      ********************************************************************
     C     AUDIT         BEGSR
 
      * Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   WRITE     HEADAU
     C                   WRITE     DETAILAU
      *
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     0             RTCOUNT           9 0
     C                   Z-ADD     0             PCOUNT            9 0
 
     C                   MOVEL     *BLANKS       WERMS            10
 
     C                   MOVEL     'ZS '         ZSRFI             3
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
 
      ** Key to reversed sweeps/target balancing items for today.
     C     RVTBK         KLIST
     C                   KFLD                    RDHIER
     C                   KFLD                    RDLINK
     C                   KFLD                    RDPRCD
 
      * Key to related postings/extensions.
     C     POSTK         KLIST
     C                   KFLD                    ZSRFI
     C                   KFLD                    RIXRFN
      *
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
