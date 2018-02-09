     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Determine ZB/Swep Hierarchy Relationships')   *
/*XBIA*  OVRDBF FILE(RELZSHLJ4X) TOFILE(RELZSHLJ4) SHARE(*NO)         *         213198
/********OVRDBF*FILE(RELZSHLJ1X)*TOFILE(RELZSHLJ1)*SHARE(*NO)**********         213198
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100710 - Determine Zero Balancing/Sweeping Hierarchy       *
      *             Relationships                                     *
      *                                                               *
      *  Function:  This program determines the relationships between *
      *             zero balancing/sweeping hierarchies in the 'Live' *
      *             Cash Management Hierarchy files.                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 213198             Date 11Feb03               *
      *                 214360             Date 03Feb03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  213198 - Sweeps in multi-level hierarchy not swept in COB    *
      *  214360 - Cash Management Deferred Posting                    *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     F*RELZSHLJ1IF***E***********K*DISK****INFSR(*PSSR)                         213198
     FRELZSHLJ4 IF   E           K DISK    INFSR(*PSSR)                         213198
     F                                     RENAME(REZSHLD0:REZSHLTOP)
     FRELZSHLJ0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHLD0:REZSHLSUB)
     F*RELZSHLJ1XIF**E***********K*DISK****INFSR(*PSSR)                         213198
     FRELZSHLJ4XIF   E           K DISK    INFSR(*PSSR)                         213198
     F                                     RENAME(REZSHLD0:REZSHLTOPX)
 
     FRELZSHDJ0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHDD0:REZSHDJ0)
 
     FRECMHRL0  IF   E           K DISK    INFSR(*PSSR)
     FRECMHRL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHRD0:RECMHRD1)
     FRELCMHDL0 UF   E           K DISK    INFSR(*PSSR)
     FRECMHRPD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHRD0:RECMHRO0)
     FRELZSHDPD IF   E             DISK    INFSR(*PSSR)
     F                                     INFDS(ZSHDINF)
     FRE100710AUO    E             PRINTER INFSR(*PSSR)
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
 
 
      ** File Information Data Structure for RE100710
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
 
     DZSHDINF          DS
     D NUM_RCDS              156    159I 0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
 
      * Write to Cash Management Hierarchy Relationships file
 
     C                   EXSR      WRT_CMHR
 
      * Update Cash Management Hierarchy Number of Dependencies
 
     C                   EXSR      UPD_CMHNOD
 
      * Update Cash Management Hierarchy Processing Sequence
 
     C                   EXSR      UPD_CMHPSQ
 
      * Produce audit report
 
     C                   EXSR      AUDIT
 
      * Return
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Write to Cash Management Hierarchy Relationships file
      ********************************************************************
     C     WRT_CMHR      BEGSR
 
      * Read all top a/cs in the zero balancing/sweeping hierarchies
 
     C                   READ      REZSHLTOP                              99
 
     C     *IN99         DOWEQ     *OFF
 
     C                   MOVEL     CLHIER        HRCHID
 
      * Each top a/c may be a sub a/c in one other hierarchy
 
     C     REZSHLJK      CHAIN     REZSHLSUB                          99        *
     C     *IN99         IFEQ      '0'
     C                   MOVEL     CLHIER        HRPHID
     C                   WRITE     RECMHRO0
     C                   ENDIF
 
      * Each top a/c may be a top a/c in one other hierarchy
      * It is dependent only if the other hierarchy is an external hierarchy
 
     C     REZSHLJK      SETLL     REZSHLTOPX                                   *
     C     REZSHLJK      READE     REZSHLTOPX                             99    *
     C     *IN99         DOWEQ     '0'
     C     CLHIER        IFNE      HRCHID
     C     ZDDEST        ANDNE     *BLANK
     C                   MOVEL     CLHIER        HRPHID
     C                   WRITE     RECMHRO0
     C                   ENDIF
     C     REZSHLJK      READE     REZSHLTOPX                             99    *
     C                   ENDDO
 
      * Read next top a/c
 
     C                   READ      REZSHLTOP                              99
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Cash Management Hierarchy Number of Dependencies
      ********************************************************************
     C     UPD_CMHNOD    BEGSR
 
      * Read all hierarchy relationships
 
     C                   READ      RECMHRD0                               99
 
     C     *IN99         DOWEQ     *OFF
 
      * On change of parent hierarchy
      * Update number of dependent hierarchies on the hierarchy
 
     C     COUNT         IFGT      0
     C     P_PHID        ANDNE     HRPHID
     C     P_PHID        CHAIN     RECMHDD0                           99        *
     C                   Z-ADD     COUNT         CDNODH
     C                   Z-ADD     COUNT         CDNODN
     C                   EXCEPT    URECMHNOD
     C                   Z-ADD     *ZERO         COUNT             5 0
     C                   ENDIF
 
     C                   MOVEL     HRPHID        P_PHID            9 0
 
      * Increment count of dependent hierarchies
 
     C                   ADD       1             COUNT
 
      * Read next hierarchy relationship
 
     C                   READ      RECMHRD0                               99
     C                   ENDDO
 
      * On change of parent hierarchy
      * Update number of dependent hierarchies on the hierarchy
 
     C     COUNT         IFGT      0
     C     P_PHID        CHAIN     RECMHDD0                           99        *
     C                   Z-ADD     COUNT         CDNODH
     C                   Z-ADD     COUNT         CDNODN
     C                   EXCEPT    URECMHNOD
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Cash Management Hierarchy Processing Sequence
      ********************************************************************
     C     UPD_CMHPSQ    BEGSR
 
     C                   Z-ADD     *ZERO         ProcSeq           9 0
 
      * Read all zero balancing/sweeping hierarchies
      * with number of dependent hierarchies not yet processed = zero
 
     C                   READ      REZSHDJ0                               99
 
     C     *IN99         DOWEQ     *OFF
 
      * Update processing sequence
 
     C     CDHIER        CHAIN     RECMHDD0                           99        *
     C                   ADD       1             ProcSeq
     C                   Z-ADD     ProcSeq       CDPRSQ
     C                   EXCEPT    URECMHPSQ
 
      * Reduce dependencies
 
     C     CDHIER        CHAIN     RECMHRD1                           99        *
     C     *IN99         IFEQ      '0'
     C                   DELETE    RECMHRD1                                     *
     C     HRPHID        CHAIN     RECMHDD0                           99
     C                   SUB       1             CDNODN
     C                   EXCEPT    URECMHNOD
     C                   ENDIF
 
      * Read next zero balancing/sweeping hierarchy
 
     C     *LOVAL        SETLL     REZSHDJ0
     C                   READ      REZSHDJ0                               99
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Produce Audit Report
      *****************************************************************
     C     AUDIT         BEGSR
 
      ** Ensure Detail Spool File recorded by RCF
 
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * It's an error if processing sequence doesn't
      * equal the count of Zero Balancing/Sweeping Detail records
 
     C     ProcSeq       IFNE      NUM_RCDS
     C                   SETON                                        60U8
     C                   ENDIF
 
     C                   WRITE     HEADER
     C                   WRITE     CONTROL
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Key lists
 
     C     REZSHLJK      KLIST
     C                   KFLD                    CLCCUS
     C                   KFLD                    CLCCCY
     C                   KFLD                    CLCACD
     C                   KFLD                    CLCASN
     C                   KFLD                    CLCBRC
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      ********************************************************************
     ORECMHDD0  E            URECMHNOD
     O                       CDNODH
     O                       CDNODN
     O          E            URECMHPSQ
     O                       CDPRSQ
