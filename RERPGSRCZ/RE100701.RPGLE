     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Zero-Balancing Stops Entry Merge')            *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100701 - Zero Balancing Stops Entry Merge                  *
      *                                                               *
      *  Function:  This program extracts postings/extension records  *
      *             for released or deleted zero balancing stops      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. BUG28077           Date 26Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CRE008  *CREATE    Date 04Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG28077 - Parent account code field was not updated to 10S. *
      *             (Recompile)                                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FREZSTDL1  UF   E           K DISK    INFSR(*PSSR)
     FREZSTIL0  UF   E           K DISK    INFSR(*PSSR)
     FGLPSTTL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:GLPSTTD0)
     FGLPSTZSL0 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLAPZSD0: GLPSTZSD0)
 
     FGECXPD    O  A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:GECXF)
     FGLAPSTZS  O  A E           K DISK    INFSR(*PSSR)
 
      * Zero-Balancing Stops Entry Merge - Audit
     FRE100701AUO    E             PRINTER
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
 
 
      ** File Information Data Structure for RE100701AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - short data structure
 
 
      /SPACE 5
 
      * Read all stops released or deleted today
 
     C                   READ      REZSTDD0                               60
 
     C     *IN60         DOWEQ     *OFF
 
      * Delete the stop details record
 
     C                   DELETE    REZSTDD0
 
      * Increment counts
 
     C     ZDDELD        IFEQ      'Y'
     C                   ADD       1             SDCOUNT
     C                   ELSE
     C                   ADD       1             SRCOUNT
     C                   ENDIF
 
      * Read all items for a stop released or deleted today
 
     C                   EXSR      READ_ITEMS
 
      * Read next stop released or deleted today
 
     C                   READ      REZSTDD0                               60
     C                   ENDDO
 
      * Write Audit Report
 
     C                   EXSR      AUDIT
 
     C                   SETON                                        LR
     C                   RETURN
 
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Read all items for a stop released or deleted today
      ********************************************************************
     C     READ_ITEMS    BEGSR
 
      * For each stop released or deleted today, access related item(s)
 
     C     STOPK         SETLL     REZSTID0
     C     STOPK         READE     REZSTID0                               60
 
      * For each item
 
     C     *IN60         DOWEQ     *OFF
 
      * Delete the item record
 
     C                   DELETE    REZSTID0
 
      * Get 'posting in transit'
      * (If no record is found, it's a database error)
 
     C     POSTK         CHAIN     GLPSTTD0                           60
     C     *IN60         IFEQ      *ON
     C                   MOVE      ZIXRFN        WERMS
     C                   EVAL      X_ERMS = 'No GLPSTTPD for ' + %TRIML(WERMS)
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Delete 'posting in transit'
 
     C                   DELETE    GLPSTTD0
 
      * Get 'posting in transit' extension
      * (If no record is found, it's a database error)
 
     C     POSTK         CHAIN     GLPSTZSD0                          60
     C     *IN60         IFEQ      *ON
     C                   MOVE      ZIXRFN        WERMS
     C                   EVAL      X_ERMS = 'No GLPSTZSPD for ' + %TRIML(WERMS)
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Delete 'posting in transit' extension
 
     C                   DELETE    GLPSTZSD0
 
      * If stop is NOT a deletion
      *  Write the posting to the generated entries file
      *  If it is the destination account that is defined on the extension
      *  this is the source entry and it should be ignored in zero balancing
 
     C     ZDDELD        IFNE      'Y'
     C                   Z-ADD     BJRDNB        PSTD
     C     AZASDA        IFEQ      'D'
     C                   EVAL      OTRF = IgnoreEveryRun
     C                   ENDIF
     C                   WRITE     GECXF
     C                   ADD       1             PCOUNT
     C                   ENDIF
 
      * If stop is NOT a deletion
      *   Write the extension to the extension file
 
     C     ZDDELD        IFNE      'Y'
     C                   WRITE     GLAPZSD0
     C                   ENDIF
 
      * Read the next item
 
     C     STOPK         READE     REZSTID0                               60
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
 
     C                   Z-ADD     0             SDCOUNT           9 0
     C                   Z-ADD     0             SRCOUNT           9 0
     C                   Z-ADD     0             PCOUNT            9 0
 
     C                   MOVEL     *BLANKS       WERMS            10
 
     C                   MOVEL     'ZS '         ZSRFI             3
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Ignore every run code
 
     C                   MOVEL     *BLANK        IgnoreEveryRun   15
     C                   EVAL      IgnoreEveryRun = '*IGNORE'
 
 
      * Key to Stopped Items file (from stops released today file)
     C     STOPK         KLIST
     C                   KFLD                    ZDHIER
     C                   KFLD                    ZDLINK
     C                   KFLD                    ZDPRCD
     C                   KFLD                    ZDSTPN
 
      * Key to related postings/extensions.
     C     POSTK         KLIST
     C                   KFLD                    ZSRFI
     C                   KFLD                    ZIXRFN
      *
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
