     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Global T_GPPCUST Generation')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGLCSGEN - Global Customer Details Generation               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG15716           Date 18Feb08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG4521 *CREATE    Date 17NoV04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG15716 - Increase array size to handle up to 999 branches  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CSD025 - Customer De-Activation                              *
      *  BUG4521- Predeal Check Performance Enhancement               *
      *                                                               *
      *****************************************************************
 
     FGZSDCUSTL1IF   E           K DISK    INFSR(*PSSR)
     FGPCUSTL0  IF   E           K DISK    INFSR(*PSSR)
     FGPCUSTXL0 IF   E           K DISK    INFSR(*PSSR)
     FGPCUSGPD  O    E           K DISK    INFSR(*PSSR)
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FGPACOFXL0 IF   E           K DISK    INFSR(*PSSR)
     FGPINDSXL0 IF   E           K DISK    INFSR(*PSSR)
 
B    D*#_BR*****       S              3    DIM(99)                                          BUG15716
B    D*#_ZN*****       S             10    DIM(99)                                          BUG15716
B    D #_BR            S              3    DIM(999)                                         BUG15716
B    D #_ZN            S             10    DIM(999)                                         BUG15716
B
 
     ISDBRCHD0
     I              QQDFAC                      QQDFAC_X
 
      * Read through each record on the global customer file and write to GPCUSGPD
     C                   READ      GPCUSTD0                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      SET_OUT_GLOB
     C                   WRITE     GPCUSGD0
     C                   READ      GPCUSTD0                               99
     C                   ENDDO
 
      * Read through GZSDCUSTPD, check whether local customer is linked to a global
      * customer, if it isn't then write a record to GPCUSGPD
     C                   READ      SDCUSTD0                               97
     C     *IN97         DOWEQ     *OFF
     C     GPCUSTXK      CHAIN     GPCUSTXL0                          98
     C     *IN98         IFEQ      *ON
     C                   EXSR      SET_OUT_LOCL
     C                   WRITE     GPCUSGD0
     C                   ENDIF
     C                   READ      SDCUSTD0                               97
     C                   ENDDO
     C                   SETON                                        LR
     C                   RETURN
 
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set output fields for a global customer
      ********************************************************************
     C     SET_OUT_GLOB  BEGSR
 
      * Local Customer Number
     C                   EVAL      CUSCUST  = *Blanks
      * Global Customer ID
     C                   EVAL      CUSGLOB   = CUGCUS
      * Customer Shortname
     C                   EVAL      CUSCSSN   = CUCSSN
      * Cust. Name & Address 1
      * Cust. Name & Address 2
      * Cust. Name & Address 3
      * Cust. Name & Address 4
     C                   EVAL      CUSNA1    = CUCNA1
     C                   EVAL      CUSNA2    = CUCNA2
     C                   EVAL      CUSNA3    = CUCNA3
     C                   EVAL      CUSNA4    = CUCNA4
      * Customer Report Name
      * Customer Report Town
     C                   EVAL      CUSRNM    = CUCRNM
     C                   EVAL      CUSRTN    = CUCRTN
      * Branch
     C                   EVAL      CUSBRCD   = CUBRCD
      * Bank/non-bank Indicator
     C                   EVAL      CUSNBI    = CUBNBI
      * Global Industry Code
     C                   EVAL      CUSICD    = CUGICD
      * Global Account Officer Code
     C                   EVAL      CUSACO    = CUGACO
      * Country of Citizenship
      * Country of Location
     C                   EVAL      CUSCNCZ   = CUCNCZ
     C                   EVAL      CUSCOLC   = CUCOLC
      * Type of last Change
     C                   EVAL      CUSACTIVE = CUCHTP
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set output fields for a local customer
      ********************************************************************
     C     SET_OUT_LOCL  BEGSR
 
      * Get zone so that we can chain to get the industry code and account officer later
     C                   Z-ADD     1             #X
     C     BBBRCD        LOOKUP    #_BR(#X)                               98
     C                   EVAL      Zone_ID  = #_ZN(#X)
 
B     * Customer Number
     C                   EVAL      CUSCUST  = BBCUST
B     * Global Customer ID
     C                   EVAL      CUSGLOB  = BBBRCD + '-' + BBCUST
B     * Customer Shortname
     C                   EVAL      CUSCSSN  = BBCSSN
B     * Cust. Name & Address 1
B     * Cust. Name & Address 2
B     * Cust. Name & Address 3
B     * Cust. Name & Address 4
     C                   EVAL      CUSNA1   = BBCNA1
     C                   EVAL      CUSNA2   = BBCNA2
     C                   EVAL      CUSNA3   = BBCNA3
     C                   EVAL      CUSNA4   = BBCNA4
B     * Customer Report Name
B     * Customer Report Town
     C                   EVAL      CUSRNM   = BBCRNM
     C                   EVAL      CUSRTN   = BBCRTN
B     * Branch
     C                   EVAL      CUSBRCD  = BBBRCD
B     * Bank/non-bank Indicator
     C                   EVAL      CUSNBI   = BBBNBI
B     * Global Industry Code
     C                   EVAL      CUSNBI = *BLANKS                                           CGP017
     C     GPINDSXK      CHAIN     GPINDSXL0                          98
     C                   IF        *IN98 = *OFF                                               CGP017
     C                   EVAL      CUSNBI   = IDGIND
     C                   ENDIF                                                                CGP017
B     * Global Account Officer Code
     C                   EVAL      CUSACO = *BLANKS                                           CGP017
     C     GPACOFXK      CHAIN     GPACOFXL0                          98
     C                   IF        *IN98 = *OFF                                               CGP017
     C                   EVAL      CUSACO   = ACGACO
     C                   ENDIF                                                                CGP017
B     * Country of Citizenship
B     * Country of Location
     C                   EVAL      CUSCNCZ  = BBCNCZ
     C                   EVAL      CUSCOLC  = BBCOLC
B     * Type of last change
     C                   EVAL      CUSACTIVE = BBTYLC
B
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     0             #X                3 0
 
      * Read all branches
     C     *LOVAL        SETLL     SDBRCHD0
     C                   READ      SDBRCHD0                               99
 
      * For each branch
     C     *IN99         DOWEQ     *OFF
 
      * Add branch & zone to arrays
     C                   ADD       1             #X
     C                   MOVEL     A8BRCD        #_BR(#X)
     C                   MOVEL     A8ZONE        #_ZN(#X)
 
      * Read next branch
     C                   READ      SDBRCHD0                               99
     C                   ENDDO
 
     C     GPCUSTXK      KLIST
     C                   KFLD                    BBBRCD
     C                   KFLD                    BBCUST
     C     GPACOFXK      KLIST
     C                   KFLD                    Zone_ID
     C                   KFLD                    BBACOC
     C     GPINDSXK      KLIST
     C                   KFLD                    Zone_ID
     C                   KFLD                    BBLICD
 
     C                   MOVE      *BLANK        Glob_Customer     1
     C                   MOVE      *BLANK        Zone_ID          10
B
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     RunBefore     IFEQ      *BLANKS
 
     C                   MOVE      'Y'           RunBefore         1
 
     C                   DUMP
     C                   ENDIF
 
     C                   SETON                                        LRU7U8
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
