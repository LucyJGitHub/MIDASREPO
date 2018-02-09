     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GO Update Historic Head-Office Exchange Rats')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOUPDHHOX  - Update Historic Head-Office Exchange Rates      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGP010   *CREATE   Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPCURRL0  IF   E           K DISK    INFSR(*PSSR)
     FGPHHOXL0  UF A E           K DISK    INFSR(*PSSR)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Branch Details
     D GZSDBRCH      E DS                  EXTNAME(GZSDBRCHPD)
     D                                     PREFIX(B_)
      * Currency Details
     D GPCURR        E DS                  EXTNAME(GPCURRPD)
     D                                     PREFIX(C_)
 
 
 
      * Update global historic head-office exchange rates
      * with rates on global currency file
 
     C     *LOVAL        SETLL     GPCURRD0
     C                   READ      GPCURRD0                               99
     C     *IN99         DOWEQ     *OFF
 
     C                   MOVEL     GCSPRT        C_GCSPRT         20 9
     C                   MOVEL     GCMDIN        C_GCMDIN          1
 
     C     GPHHOXK       CHAIN     GPHHOXL0                           99
     C   99              WRITE     GPHHOXD0
     C  N99              MOVEL     C_GCSPRT      GCSPRT
     C  N99              MOVEL     C_GCMDIN      GCMDIN
     C  N99              UPDATE    GPHHOXD0
 
     C                   READ      GPCURRD0                               99
     C                   ENDDO
 
     C                   SETON                                        LR
     C                   RETURN
      /SPACE 5
      **********************************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'M'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * *INZSR - Initial Processing
      **********************************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Convert current run date to month and year
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
 
     C                   MOVE      ZDATE         GCYR
     C                   MOVEL     ZDATE         GCMTH
 
     C     GPHHOXK       KLIST
     C                   KFLD                    GCYR
     C                   KFLD                    GCMTH
     C                   KFLD                    GCCYCD
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
