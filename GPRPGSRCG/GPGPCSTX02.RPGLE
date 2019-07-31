     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Global Customer Details Trigger Program')     *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGPCSTX02 - On-Line Update of Global File GPCUSGPD          *
      *             - Trigger program for GPCUSTXPD                   *
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
      *                 BUG5822            Date 09Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4521 *CREATE    Date 14Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  BUG15716 - Increase array size to handle up to 999 branches  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5822- Local customer in wrong branch is deleted           *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CSD025 - Customer De-Activation                              *
      *  BUG4521- Update GPCUSGPD                                     *
      *                                                               *
      *****************************************************************
 
O    FGPCUSGL0  UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
O    FGPCUSGL1  UF A E           K DISK    RENAME(GPCUSGD0   :  GPCUSGD1)
O    F                                     INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
     F                                     PREFIX(L_)
O    FGPUTILL0  UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
     FGPCUSTL0  IF   E           K DISK    INFSR(*PSSR)
     FGZSDCUSTL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FGPACOFXL0 IF   E           K DISK    INFSR(*PSSR)
     FGPINDSXL0 IF   E           K DISK    INFSR(*PSSR)
O
O    D G_GPCUSTXPD   E DS                  EXTNAME(GPCUSTXPD)
 
B    D*#_BR*****       S              3    DIM(99)                                          BUG15716
B    D*#_ZN*****       S             10    DIM(99)                                          BUG15716
B    D #_BR            S              3    DIM(999)                                         BUG15716
B    D #_ZN            S             10    DIM(999)                                         BUG15716
     D FILETYPE        S                   LIKE(UTSRTYPE)
     D CustType        S              1A
     D CUSGLOBKEY      S             10A                                                     BUG5822
 
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
O    C                   MOVEL     I#BIMG        G_GPCUSTXPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        G_GPCUSTXPD
O    C                   ENDIF
O
O     * 'Before'
      * Move GZSDCUSTPD fields into layout for GPCUSGL1 so that
      * when removing a local customer from a global customer,
      * i.e. a delete from GPCUSTXPD, the local customer details
      * will now populate GPCUSGPD
O
O    C     I#BFAF        IFEQ      'B'
     C     K_GZSDCUST    CHAIN     GZSDCUSTL1                         96
     C                   EXSR      SET_OUT_LOCL
O    C  N96              WRITE     GPCUSGD1
O    C  N96              Eval      CustType = 'L'
     C  N96              EXSR      WRT_T_GPUTIL
O
O    C                   ELSE
O
O     * 'After' - Only update files if insert
 
O    C     I#BFAF        IFNE      'B'
     C     I#BIMG        ANDEQ     *Blanks
 
      ** Remove local customer from GPCUSGPD
O    C*****K_T_GPCUSL1   CHAIN     GPCUSGD1                           98                     BUG5822
     C**N98****          DELETE    GPCUSGD1                                                  BUG5822
      ** Set up Global customer ID as Branch, '-' and Local Customer Number                  BUG5822
     C                   Eval      CUSGLOBKEY = CUBRCD + '-' + CUCUST                        BUG5822
O    C     K_T_GPCUSL0   CHAIN     GPCUSGD0                           98                     BUG5822
     C  N98              DELETE    GPCUSGD0                                                  BUG5822
O    C  N98              Eval      CustType = 'L'
     C  N98              Eval      L_CUSGLOB = CUSGLOBKEY                                    BUG5822
     C  N98              EXSR      DLT_T_GPUTIL
 
      * Check if global customer is already on GPCUSGPD if not then
      * move GPCUSTPD fields into layout for GPCUSGL0 and add record
O    C     CUGCUS        CHAIN     GPCUSGD0                           95
     C     *IN95         IFEQ      *ON
O    C                   CLEAR                   GPCUSGD0
     C                   EXSR      SET_OUT_CUST
     C                   WRITE     GPCUSGD0
O    C                   Eval      CustType = 'G'
     C                   EXSR      WRT_T_GPUTIL
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      ********************************************************************
      * Set output fields for a global customer
      ********************************************************************
     C     SET_OUT_CUST  BEGSR
 
      * Local Customer Number
     C                   EVAL      CUSCUST  = *Blanks
      * Global Customer ID
     C                   EVAL      CUSGLOB  = CUGCUS
      * Customer Shortname
     C                   EVAL      CUSCSSN  = CUCSSN
      * Cust. Name & Address 1
      * Cust. Name & Address 2
      * Cust. Name & Address 3
      * Cust. Name & Address 4
     C                   EVAL      CUSNA1 = CUCNA1
     C                   EVAL      CUSNA2 = CUCNA2
     C                   EVAL      CUSNA3 = CUCNA3
     C                   EVAL      CUSNA4 = CUCNA4
      * Customer Report Name
      * Customer Report Town
     C                   EVAL      CUSRNM = CUCRNM
     C                   EVAL      CUSRTN = CUCRTN
      * Branch
     C                   EVAL      CUSBRCD = CUBRCD
      * Bank/non-bank Indicator
     C                   EVAL      CUSNBI = CUBNBI
      * Global Industry Code
     C                   EVAL      CUSICD = CUGICD
      * Global Account Officer Code
     C                   EVAL      CUSACO = CUGACO
      * Country of Citizenship
      * Country of Location
     C                   EVAL      CUSCNCZ = CUCNCZ
     C                   EVAL      CUSCOLC = CUCOLC
      * Type of last change
     C                   EVAL      CUSACTIVE = CUCHTP
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set output fields for a local customer
      ********************************************************************
     C     SET_OUT_LOCL  BEGSR
      * Get zone
     C                   Z-ADD     1             #X
     C     BBBRCD        LOOKUP    #_BR(#X)                               99
     C                   EVAL      Zone_ID  = #_ZN(#X)
 
B     * Customer Number
     C                   EVAL      L_CUSCUST = BBCUST
B     * Global Customer ID
     C                   EVAL      L_CUSGLOB = BBBRCD + '-' + BBCUST
B     * Customer Shortname
     C                   EVAL      L_CUSCSSN = BBCSSN
B     * Cust. Name & Address 1
B     * Cust. Name & Address 2
B     * Cust. Name & Address 3
B     * Cust. Name & Address 4
     C                   EVAL      L_CUSNA1 = BBCNA1
     C                   EVAL      L_CUSNA2 = BBCNA2
     C                   EVAL      L_CUSNA3 = BBCNA3
     C                   EVAL      L_CUSNA4 = BBCNA4
B     * Customer Report Name
B     * Customer Report Town
     C                   EVAL      L_CUSRNM = BBCRNM
     C                   EVAL      L_CUSRTN = BBCRTN
B     * Branch
     C                   EVAL      L_CUSBRCD  = BBBRCD
B     * Bank/non-bank Indicator
     C                   EVAL      L_CUSNBI   = BBBNBI
B     * Global Industry Code
     C                   EVAL      L_CUSICD = *BLANKS                                         CGP017
     C     GPINDSXK      CHAIN     GPINDSXL0                          94
     C                   IF        *IN94 = *OFF                                               CGP017
     C                   EVAL      L_CUSICD = IDGIND
     C                   ENDIF                                                                CGP017
B     * Global Account Officer Code
     C                   EVAL      L_CUSACO = *BLANKS                                         CGP017
     C     GPACOFXK      CHAIN     GPACOFXL0                          93
     C                   IF        *IN94 = *OFF                                               CGP017
     C                   EVAL      L_CUSACO = ACGACO
     C                   ENDIF                                                                CGP017
B     * Country of Citizenship
B     * Country of Location
     C                   EVAL      L_CUSCNCZ = BBCNCZ
     C                   EVAL      L_CUSCOLC = BBCOLC
B     * Date Deleted
     C                   EVAL      L_CUSACTIVE = BBTYLC
B
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Write record to T_GPUTILSR
      ********************************************************************
     C     WRT_T_GPUTIL  BEGSR
B
     C                   Eval      UTSRTYPE = 1
B
      * If it's a local customer then need to use the L_ prefixed fields
     C                   If        CustType = 'L'
B
     C                   Eval      UTSRCODE = L_CUSGLOB
     C                   Eval      UTSRNAME = L_CUSRNM + ' ' + L_CUSRTN
     C                   If        L_CUSACTIVE = 'D'
     C                   Eval      UTSRACTIVE = 'N'
     C                   Else
     C                   Eval      UTSRACTIVE = 'Y'
     C                   EndIf
B
     C                   Else
B
     C                   Eval      UTSRCODE = CUSGLOB
     C                   Eval      UTSRNAME = CUSRNM + ' ' + CUSRTN
     C                   If        CUSACTIVE = 'D'
     C                   Eval      UTSRACTIVE = 'N'
     C                   Else
     C                   Eval      UTSRACTIVE = 'Y'
     C                   EndIf
B
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
     C                   If        CustType = 'L'
     C                   Eval      KCODE = L_CUSGLOB
     C                   Else
     C                   Eval      KCODE = CUSGLOB
     C                   EndIf
 
     C                   Eval      KTYPE = FILETYPE
 
     C     KEYUTIL       CHAIN     GPUTILL0                           92
     C     *IN92         IFEQ      *OFF
O    C                   DELETE    T_GPUTILSR
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
     C                   READ      SDBRCHD0                               97
 
      * For each branch
     C     *IN97         DOWEQ     *OFF
 
      * Add branch & zone to arrays
     C                   ADD       1             #X
     C                   MOVEL     A8BRCD        #_BR(#X)
     C                   MOVEL     A8ZONE        #_ZN(#X)
 
      * Read next branch
     C                   READ      SDBRCHD0                               97
     C                   ENDDO
O
O     * Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GPCUSGL0
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GPCUSGL1
 
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GPUTILL0
 
     C*****K_T_GPCUSL1   KLIST                                                               BUG5822
     C**********         KFLD                    CUCUST                                      BUG5822
 
     C     K_T_GPCUSL0   KLIST                                                               BUG5822
     C                   KFLD                    CUSGLOBKEY                                  BUG5822
                                                                                             BUG5822
     C     *LIKE         DEFINE    UTSRTYPE      KTYPE
     C     KEYUTIL       KLIST
     C                   KFLD                    KTYPE
     C                   KFLD                    KCODE            10
 
     C     K_GZSDCUST    KLIST
     C                   KFLD                    CUBRCD
     C                   KFLD                    CUCUST
 
     C     GPACOFXK      KLIST
     C                   KFLD                    Zone_ID
     C                   KFLD                    BBACOC
 
     C     GPINDSXK      KLIST
     C                   KFLD                    Zone_ID
     C                   KFLD                    BBLICD
 
     C                   MOVE      *BLANK        Zone_ID          10
     C     *LIKE         DEFINE    UTSRTYPE      KTYPE
     C                   Z-ADD     1             FILETYPE
 
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
