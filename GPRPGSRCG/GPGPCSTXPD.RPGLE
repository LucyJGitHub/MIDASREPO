     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Global Customer Details Trigger Program')     *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGPCSTXPD - On-Line Update of Global File GZGLCUSL          *
      *             - Trigger program for GPCUSTXPD                   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGP017             Date 06Aug12               *
      *                 AR547326           Date 07Nov12               *
      *                 CSF011             Date 12Sep11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24717           Date 14Jul09               *
      *                 CER043             Date 02Jun08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG15716           Date 18Feb08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11273           Date 28Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG5404            Date 14Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG5042            Date 30Nov04               *
      *                 BUG2724            Date 14May04               *
      *                 BUG1912 *CREATE    Date 12May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  AR547326 - Prevent CPF4293 error on file GPGLCUSLL1 by doing *
      *             an overide share no before opening it             *
      *             (Child: AR547327)                                 *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24717 - Some customers rejected in LDNI transaction       *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  BUG15716 - Increase array size to handle up to 999 branches  *
      *  BUG11273 - Attempt to write duplicate record in GPGLCUSL.    *
      *             Add GPGLCUSL.CGBRCD as new key(unique).(Recompile)*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  BUG5404- Local customer shortname added to GPGLCUSL          *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG5042- Global Industry Code and A/c officer should be used *
      *  BUG2724- Don't need to delete from GPGLCUSL just update      *
      *  BUG1912- Global Processing                                   *
      *                                                               *
      *****************************************************************
 
O    FGPGLCUSLL1UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
     FGPCUSTL0  IF   E           K DISK    INFSR(*PSSR)
     FGZSDCUSTL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FGPACOFXL0 IF   E           K DISK    INFSR(*PSSR)
     FGPINDSXL0 IF   E           K DISK    INFSR(*PSSR)
O
O    D G_GPCUSTXPD   E DS                  EXTNAME(GPCUSTXPD)
                                                                                            AR547326
     D CmdArray        S             80A   DIM(2) CTDATA PERRCD(1)                          AR547326
     D Cmd             S             80A                                                    AR547326
     D Len             S             15P 5                                                  AR547326
 
B    D*#_BR*****       S              3    DIM(99)                                          BUG15716
B    D*#_ZN*****       S             10    DIM(99)                                          BUG15716
B    D #_BR            S              3    DIM(999)                                         BUG15716
B    D #_ZN            S             10    DIM(999)                                         BUG15716
 
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
     C                   EXSR      OPENFILE                                                 AR547326
      * Move character customer field to decimal customer field for CHAIN
     C**********         MOVE      CUCUST        SCUCUST           6 0                        CSD027
     C                   MOVE      CUCUST        SCUCUST           6                          CSD027
     C                   MOVE      CUBRCD        WCUBRCD           3
O
      * Use CUGGUS to chain to GPCUSTPD to get details
O    C     CUGCUS        CHAIN     GPCUSTD0                           99
O
      * Use GPCUSTXPD key to chain to GPGLCUSLL1
O    C     K_GPCUSTXPD   CHAIN     GPGLCUSL                           98
O
O     **'Before'                                                                             BUG2724
O    C*****I#BFAF        IFEQ      'B'                                                       BUG2724
O    C**N98              DELETE    GPGLCUSL                                                  BUG2724
     C**********         MOVE      'Y'           GLOBDEL           1                         BUG2724
     C**********         ENDIF                                                               BUG2724
O
O     * 'After'
O    C                   CLEAR                   GPGLCUSL
 
     C*****GLOBDEL       IFNE      'Y'                                                       BUG2724
O    C     I#BFAF        IFNE      'B'                                                       BUG2724
      * Move GPCUSTPD fields into layout for GPGLCUSLL1
     C                   EXSR      SET_OUT_CUST
     C                   ELSE
     C                   MOVE      WCUBRCD       KYBRCA            3
     C                   MOVE      CUCUST        KYCUST            6
 
     C     K_GZSDCUST    CHAIN     GZSDCUSTL1                         96
 
      * Move GZSDCUSTPD fields into layout for GPGLCUSLL1 so that
      * when removing a local customer from a global customer,
      * i.e. a delete from GPCUSTXPD the local customer details
      * will now populate GPGLCUSL
 
     C                   EXSR      SET_OUT_LOCL
     C                   ENDIF
 
O     * Update
O    C     *IN98         IFEQ      *OFF
     C*****GLOBDEL       ANDNE     'Y'                                                       BUG2724
O    C                   UPDATE    GPGLCUSL
O    C                   ELSE
O    C                   WRITE     GPGLCUSL
O    C                   ENDIF
     C                   EXSR      CLOSEFIL                                                 AR547326
 
     C                   RETURN
 
      ********************************************************************
      * Set output fields for a global customer
      ********************************************************************
     C     SET_OUT_CUST  BEGSR
      * Get zone
     C                   Z-ADD     1             #X
     C     WCUBRCD       LOOKUP    #_BR(#X)                               97
     C                   EVAL      Zone_ID  = #_ZN(#X)
      * Branch
     C                   EVAL      CGBRCD   = WCUBRCD
      * Local Customer Number
     C                   EVAL      CGCUST   = CUCUST
     C                   MOVE      SCUCUST       CGCNUM
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
     C                   EVAL      CGZONE   = ZONE_ID
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
      * Set up local customer field                                                          BUG5404
     C                   MOVE      WCUBRCD       KYBRCA            3                         BUG5404
     C                   MOVE      CUCUST        KYCUST            6                         BUG5404
     C     K_GZSDCUST    CHAIN     GZSDCUSTL1                         96                     BUG5404
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
     C                   IF        BBDTDL>0
     C                             OR BBCLST = 'Y'                                          BUG24717
     C                   EVAL      STATUS   = 'C'
     C                   ELSE
     C                   EVAL      STATUS   = 'L'
     C                   ENDIF
      * Local Customer Shortname                                                             BUG5404
     C                   Eval      CGLCSSN = BBCSSN                                          BUG5404
B                                                                                            BUG5404
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
O    C**********         OPEN      GPGLCUSLL1                                               AR547326
 
     C     K_GPCUSTXPD   KLIST
     C                   KFLD                    WCUBRCD
     C                   KFLD                    SCUCUST
 
     C     K_GZSDCUST    KLIST
     C                   KFLD                    KYBRCA
     C                   KFLD                    KYCUST
 
     C     GPACOFXK      KLIST
     C                   KFLD                    Zone_ID
     C                   KFLD                    BBACOC
     C     GPINDSXK      KLIST
     C                   KFLD                    Zone_ID
     C                   KFLD                    BBLICD
 
     C                   MOVE      *BLANK        Zone_ID          10
 
     C                   ENDSR
      *****************************************************************                     AR547326
      * OPENFILE - Put override, no share and open input files        *                     AR547326
      *****************************************************************                     AR547326
     C     OPENFILE      BEGSR                                                              AR547326
     C                   MOVEA     CmdArray(1)   Cmd                                        AR547326
     C                   EVAL      %SUBST(Cmd:13:10) = 'GPGLCUSLL1'                         AR547326
     C                   Z-ADD     80            Len                                        AR547326
     C                   CALL      'QCMDEXC'                                                AR547326
     C                   PARM                    Cmd                                        AR547326
     C                   PARM                    Len                                        AR547326
                                                                                            AR547326
     C                   OPEN      GPGLCUSLL1                                               AR547326
                                                                                            AR547326
     C                   ENDSR                                                              AR547326
     C/SPACE 5                                                                              AR547326
      *****************************************************************                     AR547326
      * CLOSEFIL - Delete overrides and close input files             *                     AR547326
      *****************************************************************                     AR547326
     C     CLOSEFIL      BEGSR                                                              AR547326
     C                   CLOSE     GPGLCUSLL1                                               AR547326
                                                                                            AR547326
     C                   MOVEA     CmdArray(2)   Cmd                                        AR547326
     C                   EVAL      %SUBST(Cmd:13:10) = 'GPGLCUSLL1'                         AR547326
     C                   Z-ADD     80            Len                                        AR547326
     C                   CALL      'QCMDEXC'                                                AR547326
     C                   PARM                    Cmd                                        AR547326
     C                   PARM                    Len                                        AR547326
     C                   ENDSR                                                              AR547326
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
** CmdArray
OVRDBF FILE(          ) SHARE(*NO)                                                          AR547326
DLTOVR FILE(          )                                                                     AR547326
