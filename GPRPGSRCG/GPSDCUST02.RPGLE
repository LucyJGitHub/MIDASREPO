     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Global Customer Details Trigger Program')     *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPSDCUST02 - On-Line Update of Global File GPCUSGPD          *
      *             - Trigger program for GZSDCUSTPD                  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG15946           Date 08Feb08               *
      *                 BUG14692           Date 05Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG4521 *CREATE    Date 14Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG15946 - CLE025 intialization pgm failed                   *
      *  BUG14692 - Error on Management Customer Limits               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CSD025 - Customer De-Activation                              *
      *  BUG4521- Update File GPCUSGPD                                *
      *                                                               *
      *****************************************************************
 
O    F*GPCUSGL1* UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)                      BUG14692
O    F**********                            USROPN                                          BUG14692
                                                                                            BUG14692
O    FI_GPCUSGI1UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)                       BUG14692
O    F                                     USROPN                                           BUG14692
                                                                                            BUG14692
O    FGPUTILL0  UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FGPACOFXL0 IF   E           K DISK    INFSR(*PSSR)
     FGPINDSXL0 IF   E           K DISK    INFSR(*PSSR)
O
O    D Z_SDCUSTPD    E DS                  EXTNAME(GZSDCUSTPD)
 
B    D*#_BR****        S              3    DIM(99)                                          BUG15946
B    D*#_ZN****        S             10    DIM(99)                                          BUG15946
B    D #_BR            S              3    DIM(999)                                         BUG15946
B    D #_ZN            S             10    DIM(999)                                         BUG15946
 
     D FILETYPE        S                   LIKE(UTSRTYPE)
 
     ISDBRCHD0
     I              QQDFAC                      QQDFAC_X
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_SDCUSTPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_SDCUSTPD
O    C                   ENDIF
O
      * Use GZSDCUSTPD key to chain to GPCUSGL1
O    C*****K_GZSDCUSTL1  CHAIN     GPCUSGD0                           99                    BUG14692
O    C     K_GZSDCUSTL2  CHAIN     I_GPCUSGI1                         99                    BUG14692
O
      ** If zonal customer record is on GPCUSGPD then it is not linked to a global customer
      ** If zonal customer record is not on GPCUSGPD then we are dealing with either an insert
      ** or a customer that is linked to a global customer where any change to GZSDCUSTPD
      ** does not need to be reflected on GPCUSGPD
 
O     * 'Before'
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GPCUSGD0
O    C  N99              EXSR      DLT_T_GPUTIL
O    C                   ELSE
O
O     * 'After'
O    C                   CLEAR                   GPCUSGD0
 
      * Move GZSDCUSTPD fields into layout for GPCUSGD0
     C                   EXSR      SET_OUT_CUST
 
O     * Update if *IN99 is off as the local customer record in on GPCUSGPD
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GPCUSGD0
O    C                   EXSR      UPD_T_GPUTIL
O    C                   ELSE
      * Record is not on GPCUSGPD so either an insert or update to a customer that
      * is linked to a global customer, is insert if before image is blanks
     C     I#BIMG        IFEQ      *BLANKS
O    C                   WRITE     GPCUSGD0
O    C                   EXSR      WRT_T_GPUTIL
O    C                   ENDIF
 
O    C                   ENDIF
O    C                   ENDIF
 
     C                   RETURN
 
      ********************************************************************
      * Set output fields for a local customer
      ********************************************************************
     C     SET_OUT_CUST  BEGSR
 
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
      * Write record to T_GPUTILSR
      ********************************************************************
     C     WRT_T_GPUTIL  BEGSR
B
     C                   Eval      UTSRTYPE = 1
     C                   Eval      UTSRCODE = CUSGLOB
     C                   Eval      UTSRNAME = CUSRNM + ' ' + CUSRTN
     C                   If        CUSACTIVE = 'D'
     C                   Eval      UTSRACTIVE = 'N'
     C                   Else
     C                   Eval      UTSRACTIVE = 'Y'
     C                   EndIf
B
      * Write the record to T_GPUTILSR
     C                   WRITE     T_GPUTILSR
B
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Delete a record from T_GPUTILSR
      ********************************************************************
     C     DLT_T_GPUTIL  BEGSR
B
      * Use CUSGLOB from to get position on GPUTILL0
B
     C                   Eval      KCODE = CUSGLOB
     C                   Eval      KTYPE = FILETYPE
 
     C     KEYUTIL       CHAIN     GPUTILL0                           92
     C     *IN92         IFEQ      *OFF
O    C                   DELETE    T_GPUTILSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update a record on T_GPUTILSR
      ********************************************************************
     C     UPD_T_GPUTIL  BEGSR
B
      * Use CUSGLOB from to get position on GPUTILL0
B
     C                   Eval      KCODE = CUSGLOB
     C                   Eval      KTYPE = FILETYPE
 
     C     KEYUTIL       CHAIN     GPUTILL0                           92
     C     *IN92         IFEQ      *OFF
     C                   Eval      UTSRTYPE = 1
     C                   Eval      UTSRCODE = CUSGLOB
     C                   Eval      UTSRNAME = CUSRNM + ' ' + CUSRTN
     C                   If        CUSACTIVE = 'D'
     C                   Eval      UTSRACTIVE = 'N'
     C                   Else
     C                   Eval      UTSRACTIVE = 'Y'
     C                   EndIf
 
O    C                   UPDATE    T_GPUTILSR
     C                   ENDIF
 
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
     C                   READ      SDBRCHD0                               98
 
      * For each branch
     C     *IN98         DOWEQ     *OFF
 
      * Add branch & zone to arrays
     C                   ADD       1             #X
     C                   MOVEL     A8BRCD        #_BR(#X)
     C                   MOVEL     A8ZONE        #_ZN(#X)
 
      * Read next branch
     C                   READ      SDBRCHD0                               98
     C                   ENDDO
O
O     * Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C**********         OPEN      GPCUSGL1                                                 BUG14692
O    C                   OPEN      I_GPCUSGI1                                               BUG14692
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GPUTILL0
 
O     * Key lists
O
O    C*****K_GZSDCUSTL1  KLIST                                                              BUG14692
     C**********         KFLD                    BBCUST                                     BUG14692
O                                                                                           BUG14692
O    C     K_GZSDCUSTL2  KLIST                                                              BUG14692
     C                   KFLD                    BBBRCD                                     BUG14692
     C                   KFLD                    BBCUST                                     BUG14692
                                                                                            BUG14692
     C     GPACOFXK      KLIST
     C                   KFLD                    Zone_ID
     C                   KFLD                    BBACOC
O
     C     GPINDSXK      KLIST
     C                   KFLD                    Zone_ID
     C                   KFLD                    BBLICD
 
     C     KEYUTIL       KLIST
     C                   KFLD                    KTYPE
     C                   KFLD                    KCODE            10
 
     C     *LIKE         DEFINE    UTSRTYPE      KTYPE
     C                   Z-ADD     1             FILETYPE
 
     C                   MOVE      *BLANK        Zone_ID          10
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
