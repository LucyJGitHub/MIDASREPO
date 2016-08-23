     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Global Customer Details Trigger Program')     *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGPCUSTPD - On-Line Update of Global File GZGLCUSL          *
      *             - Trigger program for GPCUSTPD                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR645170           Date 07Nov12               *
      *  Prev Amend No. CSF011             Date 12Sep11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 02Jun08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG16715           Date 16Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG11273           Date 28Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR645170 - GL: Accounts is not present on file ACCNTAB but   *
      *             present in the Java Listview. Add commit to file  *
      *             so that GPAMADPD will be properly rollback when   *
      *             unsuccesfull write to PF/ACCNTAB.                 *
      *             (Child: AR645178)                                 *
      *  CSF011 - Customer Name on Inputs                             *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  BUG16715 - Slow performance unable to locate an Account      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11273 - Attempt to write duplicate record in GPGLCUSL.    *
      *             Add GPGLCUSL.CGBRCD as new key(unique).(Recompile)*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGPGLCUSLL2UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
     FGPAMADL1  UF A E           K DISK    PREFIX(H_) INFSR(*PSSR)
     F                                     COMMIT(D_COM) USROPN                             AR645170
O
     FGZSDCUSTL1IF   E           K DISK    INFSR(*PSSR)                                       CER043
                                                                                              CER043
O    D G_GPCUSTPD    E DS                  EXTNAME(GPCUSTPD)
 
     D KBRCD           S              3A                                                      CER043
     D KCUST           S              6A                                                      CER043
                                                                                              CER043
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
O    C                   MOVEL     I#BIMG        G_GPCUSTPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        G_GPCUSTPD
O    C                   ENDIF
O
      * Use CUGCUS from GPCUSTPD to get position on GPGLCUSLL2
O    C     CUGCUS        SETLL     GPGLCUSL                           99
     C     *IN99         IFEQ      *OFF
     C     CUGCUS        READE     GPGLCUSL                               98
     C     *IN98         DOWEQ     *OFF
O
O     * 'After'
     C                   EVAL      WCGBRCD = CGBRCD
     C                   EVAL      WCGZONE = CGZONE
     C                   EVAL      WCGCUST = CGCUST
O    C                   CLEAR                   GPGLCUSL
 
      * Move GPCUSTPD fields into layout for GPGLCUSLL2
     C                   EXSR      SET_OUT_CUST
 
O     * Update
O    C                   UPDATE    GPGLCUSL
     C                   EXSR      UPDAMAD                                                  BUG16715
     C     CUGCUS        READE     GPGLCUSL                               98
     C                   ENDDO
     C                   ENDIF
 
     C                   RETURN
 
      ********************************************************************
      * Set output fields for a local customer
      ********************************************************************
     C     SET_OUT_CUST  BEGSR
      * Branch
     C                   EVAL      CGBRCD   = WCGBRCD
      * Local Customer Number
     C                   EVAL      CGCUST   = WCGCUST
     C                   MOVE      WCGCUST       CGCNUM
      * Global Customer ID
     C                   EVAL      CGGLOB   = CUGCUS
      * Customer Shortname
     C                   EVAL      CGCSSN   = CUCSSN
      * Cust. Name & Address 1
      * Cust. Name & Address 2
      * Cust. Name & Address 3
      * Cust. Name & Address 4
     C                   EVAL      CGNA1    = CUCNA1
     C                   EVAL      CGNA2    = CUCNA2
     C                   EVAL      CGNA3    = CUCNA3
     C                   EVAL      CGNA4    = CUCNA4
      * Customer Report Name
      * Customer Report Town
     C                   EVAL      CGRNM    = CUCRNM
     C                   EVAL      CGRTN    = CUCRTN
      * Bank/non-bank Indicator
     C                   EVAL      CGNBI    = CUBNBI
      * Global Industry Code
     C                   EVAL      CGICD    = CUGICD
      * Global Account Officer Code
     C                   EVAL      CGACO    = CUGACO
      * Country of Citizenship
      * Country of Location
     C                   EVAL      CGCNCZ   = CUCNCZ
     C                   EVAL      CGCOLC   = CUCOLC
      * Date Deleted
     C                   EVAL      CGDTDL   = CUDTDL
      * Zone
     C                   EVAL      CGZONE   = WCGZONE
      * SWIFT Financial Inst Ind
     C                   IF        CUSWFI = 'Y'
     C                   EVAL      CGSWFI   = 'Y'
     C                   ELSE
     C                   EVAL      CGSWFI   = 'N'
     C                   ENDIF
      * Status
     C                   IF        CUDTDL > 0
     C                   EVAL      STATUS   = 'C'
     C                   ELSE
     C                   EVAL      STATUS   = 'L'
     C                   ENDIF
                                                                                              CER043
     C                   EVAL      KBRCD = CGBRCD                                             CER043
     C                   EVAL      KCUST = CGCUST                                             CER043
      *                                                                                       CER043
      ** Setup local values for GPGLCUSL fields                                               CER043
      *                                                                                       CER043
     C     KLCUST        CHAIN     GZSDCUSTL1                                                 CER043
                                                                                              CER043
     C                   IF        %FOUND(GZSDCUSTL1)                                         CER043
      *                                                                                       CER043
      ** Local Customer Shortname                                                             CER043
      *                                                                                       CER043
     C                   EVAL      CGLCSSN = BBCSSN                                           CER043
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
                                                                                              CER043
     C                   ENDIF                                                                CER043
 
     C                   ENDSR
                                                                                           BUG16715
     C/SPACE 5                                                                             BUG16715
      ********************************************************************                 BUG16715
      * UPDAMAD - Update GPAMADL1                                                          BUG16715
      ********************************************************************                 BUG16715
     C     UPDAMAD       BEGSR                                                             BUG16715
                                                                                           BUG16715
     C     K_GPAMADL1    SETLL     GPAMADL1                                                BUG16715
     C     K_GPAMADL1    READE     GPAMADL1                                                BUG16715
     C***                DOW       %FOUND(GPAMADL1)                                        BUG16715
     C                   DOW       NOT %EOF(GPAMADL1)                                      BUG16715
                                                                                           BUG16715
      * Move                                                                               BUG16715
                                                                                           BUG16715
     C                   MOVEL     CGGLOB        H_CGGLOB                                  BUG16715
     C                   MOVEL     CGCSSN        H_CGCSSN                                  BUG16715
     C                   MOVEL     CGRNM         H_CGRNM                                   BUG16715
     C                   MOVEL     CGRTN         H_CGRTN                                   BUG16715
     C                   MOVEL     CGICD         H_CGICD                                   BUG16715
     C                   MOVEL     CGACO         H_CGACO                                   BUG16715
     C                   MOVEL     CGCNCZ        H_CGCNCZ                                  BUG16715
     C                   MOVEL     CGCOLC        H_CGCOLC                                  BUG16715
     C                   MOVEL     CGBRCD        H_CGBRCD                                  BUG16715
     C                   MOVEL     CGCUST        H_CGCUST                                  BUG16715
     C                   MOVEL     CGZONE        H_CGZONE                                  BUG16715
                                                                                           BUG16715
      * Update                                                                             BUG16715
                                                                                           BUG16715
     C                   UPDATE    AMADREC                                                 BUG16715
     C     K_GPAMADL1    READE     GPAMADL1                                                BUG16715
     C                   ENDDO                                                             BUG16715
                                                                                           BUG16715
     C                   ENDSR                                                             BUG16715
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
O
O     * Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GPGLCUSLL2
     C                   OPEN      GPAMADL1                                                 AR645170
                                                                                            BUG16715
      * Key lists                                                                           BUG16715
                                                                                            BUG16715
     C     K_GPAMADL1    KLIST                                                              BUG16715
     C                   KFLD                    WCGBRCD                                    BUG16715
     C                   KFLD                    WCGCUST                                    BUG16715
 
     C     *LIKE         DEFINE    CGBRCD        WCGBRCD
     C     *LIKE         DEFINE    CGZONE        WCGZONE
     C     *LIKE         DEFINE    CGCUST        WCGCUST
 
     C     KLCUST        KLIST                                                                CER043
     C                   KFLD                    KBRCD                                        CER043
     C                   KFLD                    KCUST                                        CER043
                                                                                              CER043
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
