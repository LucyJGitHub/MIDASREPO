     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Global Customer Details Generation')          *
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
      *                 CSF011             Date 12Sep11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24717           Date 14Jul09               *
      *                 CER043             Date 02Jun08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG18631           Date 08May08               *
      *                 BUG16715           Date 16Apr08               *
      *                 BUG16461           Date 27Feb08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 244485             Date 14Dec06               *
      *                 BUG11273           Date 28Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG5404            Date 14Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG5042            Date 30Nov04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CSF011 - Customer Name on Inputs                             *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24717 - Some customers rejected in LDNI transaction;      *
      *             duplicate of BUG18631                             *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  BUG18631 - GPGLCUSL customer status should be updated if     *
      *             deleted date is greater than zero and closure     *
      *             status is 'Y'                                     *
      *  BUG16715 - Slow performance unable to locate an Account      *
      *  BUG16461 - Increase array size of zone to 999 to prevent     *
      *             array out of index error                          *
      *  244485 - Increase size of array  to cope with more than 99   *
      *           branches                                            *
      *  BUG11273 - Attempt to write duplicate record in GPGLCUSL.    *
      *             Add GPGLCUSL.CGBRCD as new key(unique).(Recompile)*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  BUG5404- Local customer shortname field added to GPGLCUSL    *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG5042- Global Industry Code and A/c officer should be used *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGZSDCUSTL1IP  AE           K DISK    RENAME(SDCUSTD0   : FormatZON)
     F                                     INFSR(*PSSR)
     FGPGLCUSLL1US  AE           K DISK    RENAME(GPGLCUSL   : FormatGLB)
     F                                     INFSR(*PSSR)
     FGPGLCUSL  O  A E           K DISK    RENAME(GPGLCUSL   : FormatGLBW)
     F                                     INFSR(*PSSR)
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FGPACOFXL0 IF   E           K DISK    INFSR(*PSSR)
     FGPINDSXL0 IF   E           K DISK    INFSR(*PSSR)
     FGPCUSTXL0 IF   E           K DISK    INFSR(*PSSR)
     FGPCUSTL0  IF   E           K DISK    INFSR(*PSSR)
     FGPAMADL1  UF A E           K DISK    PREFIX(H_) INFSR(*PSSR)                          BUG16715
 
B    D*#_BR*****       S              3    DIM(99)                                            244485
B    D #_BR            S              3    DIM(999)                                           244485
B    D*#_ZN*****       S             10    DIM(99)                                          BUG16461
     D #_ZN            S             10    DIM(999)                                         BUG16461
B
 
     IFormatZON     01
     I                                          BBBRCD        L1M2
     I                                          BBCUST        L1M1
     IFormatGLB     02
     I                                          CGBRCD        L1M2
     I                                          CGCNUM        L1M1
     ISDBRCHD0
     I              QQDFAC                      QQDFAC_X
 
     C     *INMR         IFEQ      *OFF
     C     *IN01         IFEQ      *ON
B    C                   EXSR      SET_OUT_FLDS
     C                   WRITE     FormatGLBW
     C                   ELSE
     C                   DELETE    FormatGLB
     C                   EXSR      DELAMAD                                                  BUG16715
     C                   ENDIF
     C                   ELSE
B    C   02              EXSR      SET_OUT_FLDS
     C   02              UPDATE    FormatGLB
     C   02              EXSR      UPDAMAD                                                  BUG16715
     C                   ENDIF
 
     C/SPACE 5
      ********************************************************************
      * Set output fields
      ********************************************************************
     C     SET_OUT_FLDS  BEGSR
 
     C                   EVAL      Glob_Customer = 'N'
     C     GPCUSTXK      CHAIN     GPCUSTXL0                          99
     C     *IN99         IFEQ      *OFF
     C     GPCUSTK       CHAIN     GPCUSTL0                           99
     C     *IN99         IFEQ      *OFF
     C                   EVAL      Glob_Customer = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      * Output either global or local (zone) customer details
 
     C                   IF        Glob_Customer = 'Y'
B    C                   EXSR      SET_OUT_GLOB
     C                   ELSE
B    C                   EXSR      SET_OUT_LOCL
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set output fields for a global customer
      ********************************************************************
     C     SET_OUT_GLOB  BEGSR
      * Zone
     C                   Z-ADD     1             #X
     C     BBBRCD        LOOKUP    #_BR(#X)                               99
     C                   EVAL      Zone_ID  = #_ZN(#X)
 
B     * Branch
     C                   EVAL      CGBRCD   = BBBRCD
B     * Local Customer Number
     C                   EVAL      CGCUST   = BBCUST
     C                   MOVE      BBCUST        CGCNUM
B     * Global Customer ID
     C                   EVAL      CGGLOB   = CUGCUS
B     * Customer Shortname
     C                   EVAL      CGCSSN   = CUCSSN
B     * Cust. Name & Address 1
B     * Cust. Name & Address 2
B     * Cust. Name & Address 3
B     * Cust. Name & Address 4
     C                   EVAL      CGNA1    = CUCNA1
     C                   EVAL      CGNA2    = CUCNA2
     C                   EVAL      CGNA3    = CUCNA3
     C                   EVAL      CGNA4    = CUCNA4
B     * Customer Report Name
B     * Customer Report Town
     C                   EVAL      CGRNM    = CUCRNM
     C                   EVAL      CGRTN    = CUCRTN
B     * Bank/non-bank Indicator
     C                   EVAL      CGNBI    = CUBNBI
B     * Global Industry Code
     C                   EVAL      CGICD    = CUGICD
B     * Global Account Officer Code
     C                   EVAL      CGACO    = CUGACO
B     * Country of Citizenship
B     * Country of Location
     C                   EVAL      CGCNCZ   = CUCNCZ
     C                   EVAL      CGCOLC   = CUCOLC
B     * Date Deleted
     C                   EVAL      CGDTDL   = CUDTDL
B     * Zone
     C                   EVAL      CGZONE   = Zone_ID
B     * SWIFT Financial Inst Ind
     C                   IF        CUSWFI = 'Y'
     C                   EVAL      CGSWFI   = 'Y'
     C                   ELSE
     C                   EVAL      CGSWFI   = 'N'
     C                   ENDIF
B     * Status
     C**********         IF        CUDTDL > 0                                               BUG18631
     C                   IF        CUDTDL > 0 OR BBCLST = 'Y'                               BUG18631
     C                   EVAL      STATUS   = 'C'
     C                   ELSE
     C                   EVAL      STATUS   = 'L'
     C                   ENDIF
      * Local Customer shortname                                                             BUG5404
     C                   Eval      CGLCSSN = BBCSSN                                          BUG5404
      *                                                                                       CER043
      ** Local Customer Report Name                                                           CER043
      *                                                                                       CER043
     C                   EVAL      CGLRNM = BBCRNM                                            CER043
      *                                                                                       CER043
      ** Local Customer Report Town                                                           CER043
      *                                                                                       CER043
     C                   EVAL      CGLRTN = BBCRTN                                            CER043
      *                                                                                       CSF011
      ** Local Customer SWIFT Id                                                              CSF011
      *                                                                                       CSF011
     C                   EVAL      CGCSID = BBCSID                                            CSF011
B
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
 
B     * Branch
     C                   EVAL      CGBRCD   = BBBRCD
B     * Customer Number
     C                   EVAL      CGCUST   = BBCUST
     C                   MOVE      BBCUST        CGCNUM
B     * Global Customer ID
     C                   EVAL      CGGLOB   = BBBRCD + '-' + BBCUST
B     * Customer Shortname
     C                   EVAL      CGCSSN   = BBCSSN
B     * Cust. Name & Address 1
B     * Cust. Name & Address 2
B     * Cust. Name & Address 3
B     * Cust. Name & Address 4
     C                   EVAL      CGNA1    = BBCNA1
     C                   EVAL      CGNA2    = BBCNA2
     C                   EVAL      CGNA3    = BBCNA3
     C                   EVAL      CGNA4    = BBCNA4
B     * Customer Report Name
B     * Customer Report Town
     C                   EVAL      CGRNM    = BBCRNM
     C                   EVAL      CGRTN    = BBCRTN
B     * Bank/non-bank Indicator
     C                   EVAL      CGNBI    = BBBNBI
B     * Global Industry Code
     C                   EVAL      CGICD = *BLANKS                                            CGP017
     C     GPINDSXK      CHAIN     GPINDSXL0                          99
     C                   IF        *IN99 = *OFF                                               CGP017
     C**********         EVAL      CGICD    = BBLICD                                         BUG5042
     C                   EVAL      CGICD    = IDGIND                                         BUG5042
     C                   ENDIF                                                                CGP017
B     * Global Account Officer Code
     C                   EVAL      CGACO = *BLANKS                                            CGP017
     C     GPACOFXK      CHAIN     GPACOFXL0                          99
     C                   IF        *IN99 = *OFF                                               CGP017
     C**********         EVAL      CGACO    = BBACOC                                         BUG5042
     C                   EVAL      CGACO    = ACGACO                                         BUG5042
     C                   ENDIF                                                                CGP017
B     * Country of Citizenship
B     * Country of Location
     C                   EVAL      CGCNCZ   = BBCNCZ
     C                   EVAL      CGCOLC   = BBCOLC
B     * Date Deleted
     C                   EVAL      CGDTDL   = BBDTDL
B     * Zone
     C                   EVAL      CGZONE   = Zone_ID
B     * SWIFT Financial Inst Ind
     C                   IF        BBSWFI = 'Y'
     C                   EVAL      CGSWFI   = 'Y'
     C                   ELSE
     C                   EVAL      CGSWFI   = 'N'
     C                   ENDIF
B     * Status
     C**********         IF        BBDTDL>0                                                 BUG18631
     C                   IF        BBDTDL > 0 OR BBCLST = 'Y'                               BUG18631
     C                   EVAL      STATUS   = 'C'
     C                   ELSE
     C                   EVAL      STATUS   = 'L'
     C                   ENDIF
      * Local Customer shortname                                                             BUG5404
     C                   Eval      CGLCSSN = BBCSSN                                          BUG5404
      *                                                                                       CER043
      ** Local Customer Report Name                                                           CER043
      *                                                                                       CER043
     C                   EVAL      CGLRNM = BBCRNM                                            CER043
      *                                                                                       CER043
      ** Local Customer Report Town                                                           CER043
      *                                                                                       CER043
     C                   EVAL      CGLRTN = BBCRTN                                            CER043
      *                                                                                       CSF011
      ** Local Customer SWIFT Id                                                              CSF011
      *                                                                                       CSF011
     C                   EVAL      CGCSID = BBCSID                                            CSF011
B
     C                   ENDSR
                                                                                            BUG16715
     C/SPACE 5                                                                              BUG16715
      ********************************************************************                  BUG16715
      * DELAMAD - Delete GPAMADL1                                                           BUG16715
      ********************************************************************                  BUG16715
     C     DELAMAD       BEGSR                                                              BUG16715
                                                                                            BUG16715
     C     GPCUSTXK      SETLL     GPAMADL1                                                 BUG16715
     C     GPCUSTXK      READE     GPAMADL1                                                 BUG16715
     C***                DOW       %FOUND(GPAMADL1)                                         BUG16715
     C                   DOW       NOT %EOF(GPAMADL1)                                       BUG16715
                                                                                            BUG16715
      * Move                                                                                BUG16715
                                                                                            BUG16715
     C                   MOVEL     *BLANK        H_CGGLOB                                   BUG16715
     C                   MOVEL     *BLANK        H_CGCSSN                                   BUG16715
     C                   MOVEL     *BLANK        H_CGRNM                                    BUG16715
     C                   MOVEL     *BLANK        H_CGRTN                                    BUG16715
     C                   MOVEL     *BLANK        H_CGICD                                    BUG16715
     C                   MOVEL     *BLANK        H_CGACO                                    BUG16715
     C                   MOVEL     *BLANK        H_CGCNCZ                                   BUG16715
     C                   MOVEL     *BLANK        H_CGCOLC                                   BUG16715
     C                   MOVEL     *BLANK        H_CGBRCD                                   BUG16715
     C                   MOVEL     *BLANK        H_CGCUST                                   BUG16715
     C                   MOVEL     *BLANK        H_CGZONE                                   BUG16715
                                                                                            BUG16715
      * Update                                                                              BUG16715
                                                                                            BUG16715
     C                   UPDATE    AMADREC                                                  BUG16715
     C     GPCUSTXK      READE     GPAMADL1                                                 BUG16715
     C                   ENDDO                                                              BUG16715
                                                                                            BUG16715
     C                   ENDSR                                                              BUG16715
                                                                                            BUG16715
     C/SPACE 5                                                                              BUG16715
      ********************************************************************                  BUG16715
      * UPDAMAD - Update GPAMADL1                                                           BUG16715
      ********************************************************************                  BUG16715
     C     UPDAMAD       BEGSR                                                              BUG16715
                                                                                            BUG16715
     C     GPCUSTXK      SETLL     GPAMADL1                                                 BUG16715
     C     GPCUSTXK      READE     GPAMADL1                                                 BUG16715
     C***                DOW       %FOUND(GPAMADL1)                                         BUG16715
     C                   DOW       NOT %EOF(GPAMADL1)                                       BUG16715
                                                                                            BUG16715
      * Move                                                                                BUG16715
                                                                                            BUG16715
     C                   MOVEL     CGGLOB        H_CGGLOB                                   BUG16715
     C                   MOVEL     CGCSSN        H_CGCSSN                                   BUG16715
     C                   MOVEL     CGRNM         H_CGRNM                                    BUG16715
     C                   MOVEL     CGRTN         H_CGRTN                                    BUG16715
     C                   MOVEL     CGICD         H_CGICD                                    BUG16715
     C                   MOVEL     CGACO         H_CGACO                                    BUG16715
     C                   MOVEL     CGCNCZ        H_CGCNCZ                                   BUG16715
     C                   MOVEL     CGCOLC        H_CGCOLC                                   BUG16715
     C                   MOVEL     CGBRCD        H_CGBRCD                                   BUG16715
     C                   MOVEL     CGCUST        H_CGCUST                                   BUG16715
     C                   MOVEL     CGZONE        H_CGZONE                                   BUG16715
                                                                                            BUG16715
      * Update                                                                              BUG16715
                                                                                            BUG16715
     C                   UPDATE    AMADREC                                                  BUG16715
     C     GPCUSTXK      READE     GPAMADL1                                                 BUG16715
     C                   ENDDO                                                              BUG16715
                                                                                            BUG16715
     C                   ENDSR                                                              BUG16715
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
     C     GPCUSTK       KLIST
     C                   KFLD                    CUGCUS
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
