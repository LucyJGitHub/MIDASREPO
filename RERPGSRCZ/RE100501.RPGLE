     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Hierarchy List')              *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100501  - Cash Management Hierarchy List                   *
      *                                                               *
      *  Function: This module lists the Cash Management Hierarchies  *
      *            in the system. Runs on I/C upon request and in COB *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 214360             Date 03Feb03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  214360 - Cash Management Deferred Posting                    *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of File for RECMHDL0/L1                     *
      *    12         Chain fail to files                             *
      *    13         Program Failure                                 *
      *    14         Record Locked                                   *
      *    15         Update Error                                    *
      *    37         By Branch                                       *
      *    40         Zero Balance Sweep Type                         *
      *    43         Sweeping Frequency (M, T, Q, X or Y)            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT      - Initialisation                                  *
      * SRPROC      - Detail Processing                               *
      * SRSYSLEV    - Single Level Detail Processing                  *
      * SRALLBRCH   - All Branch Detail Processing                    *
      * SRSNGBRCH   - Single Branch Detail Processing                 *
      * SRPDETL     - Print Hierarchy Details                         *
      * SRPGADETL   - Print Group Account Details                     *
      * SRPZSDETL   - Print Zero Balancing/Sweeping Details           *
      * SRLINKS     - Print Hierarchy Links                           *
      * SRPLINK     - Print Link                                      *
      * SRPGALINK   - Print Group Account Link                        *
      * SRPZSLINK   - Print Zero Balancing/Sweeping Link              *
      * SRRCFP1     - Detail Spool File Recorded by RCF               *
      * SRRCFAU     - Audit  Spool File Recorded by RCF               *
      * SRBUILDARR  - Build Arrays                                    *
      * SRCHKLIN    - Checks for Printer File Overflow Condition      *
      * SRFILLKEYP1 - Fill in Key to Access RECMHLTPD from Own Child  *
      *               Details                                         *
      * SRFILLKEYP2 - Fill in Key to Access RECMHLTPD  from RECMHLL0  *
      *               Parent Details.                                 *
      * SRFILLKEYC1 - Fill in Key to Access RECMHLL0 from             *
      *               RECMHTLPD Parent Details                        *
      * SRFILLKEYC2 - Fill in Key to Access RECMHLL0 from             *
      *               RECMHLL0 Parent Details                         *
      * SRAUDIT     - Subroutine to Output Audit Report               *
      *                                                               *
      * *INZSR - Initialise                                           *
      * *PSSR  - Error Processing                                     *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** RE Cash Management Hierarchy Details - by Hierarchy ID
     FRECMHDL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Cash Management Hierarchy Details - by Branch & Hierarchy ID
     FRECMHDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHDD0:RECMHDP0)
 
      ** RE Cash Management Hierarchy Links - by Child
     FRECMHLL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RE Cash Management Hierarchy Links Temporary - by Parent
     FRECMHLTPD UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(T_)
 
      ** RE Cash Management Hierarchy Links - by GLAI chain
     FRECMHLL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:RECMHLGL)
 
      ** Live Zero Balancing/Sweeping Header Extension
     FRELZSHXPD IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F_)
 
      ** GL Account Master Details
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
 
      ** RE Cash Management Hierarchy List
     FRE100501AUO    E             PRINTER
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** RE Cash Management Hierarchy List
     FRE100501P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D I_CACCID        S             24                                                       CGL029
     D I_PACCID        S             24                                                       CGL029
     D I_SACCID        S             24                                                       CGL029
     D I_IIACID        S             24                                                       CGL029
     D I_IEACID        S             24                                                       CGL029
     D I_TACCID        S             24                                                       CGL029
     D I_IACCID        S             24                                                       CGL029
     D I_EACCID        S             24                                                       CGL029
     D I_C1ACCID       S             24                                                       CGL029
     D I_C3ACCID       S             24                                                       CGL029
     D DDCACC          S             28                                                       CGL029
     D DDPACC          S             28                                                       CGL029
     D DDSACC          S             28                                                       CGL029
     D DDINAC          S             28                                                       CGL029
     D DDEXAC          S             28                                                       CGL029
     D DDTACC          S             28                                                       CGL029
     D DDIACC          S             28                                                       CGL029
     D DDEACC          S             28                                                       CGL029
     D DDC1ACC         S             28                                                       CGL029
     D DDC3ACC         S             28                                                       CGL029
 
      ** Array for link parents
     D***ArrParent       S             18    DIM(1000)                                        CGL029
     D ArrParent       S             24    DIM(1000)                                          CGL029
      ** Array - number of children
     D ArrNumChild     S              3S 0 DIM(1000)
      ** Array - child count
     D ArrChildCnt     S              3S 0 DIM(1000)
 
 
      ** Externally described DS CM Hierarchy Details
     D O_CMHD        E DS                  EXTNAME(RECMHDPD)
      ** Externally described DS for Zero Balancing/Sweeping Details
     D O_ZSHD        E DS                  EXTNAME(REZSHDPD)
      ** Externally described DS for Group Account Details
     D O_GAHD        E DS                  EXTNAME(REGAHDPD)
      ** Externally described DS CM Hierarchy Links
     D O_CMHL        E DS                  EXTNAME(RECMHLPD)
     D  Z_CLPBRC     E                     EXTFLD(CLPBRC)
     D  Z_CLPCUS     E                     EXTFLD(CLPCUS)
     D  Z_CLPCCY     E                     EXTFLD(CLPCCY)
     D  Z_CLPACD     E                     EXTFLD(CLPACD)
     D  Z_CLPASN     E                     EXTFLD(CLPASN)
     D***C_ACCID                19     36                                                     CGL029
     D***P_ACCID                38     55                                                     CGL029
     D C_ACCID                19     42                                                       CGL029
     D P_ACCID                44     67                                                       CGL029
      ** Externally described DS for Zero Balancing/Sweeping Links
     D O_ZSHL        E DS                  EXTNAME(REZSHLPD)
     D***S_ACCID               108    125                                                     CGL029
     D***S_IIACID              246    263                                                     CGL029
     D***S_IEACID              264    281                                                     CGL029
     D S_ACCID1Temp          108    119                                                       CGL029
     D S_ACCID2Temp          282    291                                                       CGL029
     D S_ACCID3Temp          124    125                                                       CGL029
     D S_IIACID1Temp         246    257                                                       CGL029
     D S_IIACID2Temp         292    301                                                       CGL029
     D S_IIACID3Temp         262    263                                                       CGL029
     D S_IEACID1Temp         264    275                                                       CGL029
     D S_IEACID2Temp         302    311                                                       CGL029
     D S_IEACID3Temp         280    281                                                       CGL029
                                                                                              CGL029
      ** Shadow Account                                                                       CGL029
     D                 DS                                                                     CGL029
     D S_ACCID                 1     24                                                       CGL029
     D S_ACCID1                1     12                                                       CGL029
     D S_ACCID2               13     22                                                       CGL029
     D S_ACCID3               23     24                                                       CGL029
                                                                                              CGL029
      ** Income Account                                                                       CGL029
     D                 DS                                                                     CGL029
     D S_IIACID                1     24                                                       CGL029
     D S_IIACID1               1     12                                                       CGL029
     D S_IIACID2              13     22                                                       CGL029
     D S_IIACID3              23     24                                                       CGL029
                                                                                              CGL029
      ** Expense Account                                                                      CGL029
     D                 DS                                                                     CGL029
     D S_IEACID                1     24                                                       CGL029
     D S_IEACID1               1     12                                                       CGL029
     D S_IEACID2              13     22                                                       CGL029
     D S_IEACID3              23     24                                                       CGL029
                                                                                              CGL029
      ** Externally described DS for Group Account Links
     D O_GAHL        E DS                  EXTNAME(REGAHLPD)
     D***T_ACCID                28     45                                                     CGL029
     D***I_ACCID                46     63                                                     CGL029
     D***E_ACCID                64     81                                                     CGL029
     D T_ACCID                28     51                                                       CGL029
     D I_ACCID                52     75                                                       CGL029
     D E_ACCID                76     99                                                       CGL029
 
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** File Information Data Structure for RE100501P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for RE100501AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
 
     D PChild          DS
     D  T_CLCBRC               1      3
     D**T_CLCCUS               4      9  0                                                    CSD027
     D  T_CLCCUS               4      9                                                       CSD027
     D  T_CLCCCY              10     12
     D***T_CLCACD              13     16  0                                                   CGL029
     D***T_CLCASN              17     18  0                                                   CGL029
     D  T_CLCACD              13     22  0                                                    CGL029
     D  T_CLCASN              23     24  0                                                    CGL029
 
     D PParent         DS
     D  T_CLPBRC               1      3
     D**T_CLPCUS               4      9  0                                                    CSD027
     D  T_CLPCUS               4      9                                                       CSD027
     D  T_CLPCCY              10     12
     D***T_CLPACD              13     16  0                                                   CGL029
     D***T_CLPASN              17     18  0                                                   CGL029
     D  T_CLPACD              13     22  0                                                    CGL029
     D  T_CLPASN              23     24  0                                                    CGL029
 
     D CParent         DS
     D  CLPBRC                 1      3
     D**CLPCUS**               4      9  0                                                    CSD027
     D  CLPCUS                 4      9                                                       CSD027
     D  CLPCCY                10     12
     D***CLPACD*               13     16  0                                                   CGL029
     D***CLPASN*               17     18  0                                                   CGL029
     D  CLPACD                13     22  0                                                    CGL029
     D  CLPASN                23     24  0                                                    CGL029
 
 
      * Account ID
     D                 DS
     D***ACCID**                 1     18                                                     CGL029
     D ACCID                   1     24                                                       CGL029
     D BRC                     1      3
     D*CUS******               4      9S 0                                                    CSD027
     D CUS                     4      9                                                       CSD027
     D CCY                    10     12
     D***ACD****                13     16S 0                                                  CGL029
     D***ASN****                17     18S 0                                                  CGL029
     D ACD                    13     22S 0                                                    CGL029
     D ASN                    23     24S 0                                                    CGL029
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6P 0
     D ZSnumU          S              6P 0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Parameters for RE100601
     D I_HIER          S              9  0
     D I_HTYP          S              2
     D I_LINK          S              9  0
 
      ** Parameters for RE100601
     D I_CBRC          S              3
     D*I_CCUS***       S              6  0                                                    CSD027
     D I_CCUS          S              6                                                       CSD027
     D I_CCCY          S              3
     D***I_CACD*         S              4  0                                                  CGL029
     D I_CACD          S             10  0                                                    CGL029
     D I_CASN          S              2  0
 
 
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
     D PReptNam        S             10
 
     D WHead1          S             16
     D WLine1          S             16
     D WHead2          S             18
     D WLine2          S             18
 
 
      ** Fields used to define Key List for RECMHLTPD
     D KPHier          S              9S 0
     D KPPbrc          S              3A
     D*KPPcus***       S              6S 0                                                    CSD027
     D KPPcus          S              6A                                                      CSD027
     D KPPccy          S              3A
     D***KPPacd*         S              4S 0                                                  CGL029
     D KPPacd          S             10S 0                                                    CGL029
     D KPPasn          S              2S 0
     D KPCbrc          S              3A
     D*KPCcus***       S              6S 0                                                    CSD027
     D KPCcus          S              6A                                                      CSD027
     D KPCccy          S              3A
     D***KPCacd*         S              4S 0                                                  CGL029
     D KPCacd          S             10S 0                                                    CGL029
     D KPCasn          S              2S 0
 
      ** Fields used to define Key List for RECMHLL0
     D KCHier          S              9S 0
     D KCPbrc          S              3A
     D KCPcus          S              6S 0
     D KCPccy          S              3A
     D***KCPacd*         S              4S 0                                                  CGL029
     D KCPacd          S             10S 0                                                    CGL029
     D KCPasn          S              2S 0
     D KCCbrc          S              3A
     D*KCCcus***       S              6S 0                                                    CSD027
     D KCCcus          S              6A                                                      CSD027
     D KCCccy          S              3A
     D***KCCacd*         S              4S 0                                                  CGL029
     D KCCacd          S             10S 0                                                    CGL029
     D KCCasn          S              2S 0
 
      ** Fields used to define Key List for RECMHDL0
     D KBRCA           S              3
 
     D WParent         S             18A
     D WAcno           S             10A
     D ChildCount      S              3S 0
     D WChildCount     S              3S 0
     D RTOTAL          S              4S 0
     D X               S              2S 0
     D Y               S              2S 0
 
     D WBRCA           S              3
     D PCCY            S              3
     D WTCUS           S              6
     D***WTACD**         S              4                                                     CGL029
     D WTASN           S              2
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRPROC
 
     C                   IF        RTOTAL = 0
     C                   EXSR      SRAUDIT
     C                   ENDIF
 
     C                   EVAL      *INLR = *On
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Initialisation
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** RCF Processing for printer file
 
     C                   EXSR      SRRCFAU
 
      ** Report work fields
 
     C                   EVAL      RqdLn1  = 0
     C                   EVAL      DifLn1  = 0
     C                   EVAL      RTOTAL  = 0
     C                   EVAL      PrtLn1  = 0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Detail Processing
      *****************************************************************
     C     SRPROC        BEGSR
 
      **  Process report according to level requested:
 
     C                   SELECT
 
      ** System Level
 
     C     Plevel        WHENEQ    'S'
     C                   EXSR      SRSYSLEV
 
      ** All Branch
 
     C     Plevel        WHENEQ    'B'
     C     PEnty         AndEq     'ALL'
     C                   EXSR      SRALLBRCH
 
      ** Single Branch
 
     C     Plevel        WHENEQ    'B'
     C     PEnty         ANDNE     'ALL'
     C                   EXSR      SRSNGBRCH
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Single Level Detail Processing
      *****************************************************************
     C     SRSYSLEV      BEGSR
 
     C                   EVAL      *IN37 = *OFF
 
      ** RCF processing for printer file
 
     C                   CLOSE     RE100501P1
     C                   OPEN      RE100501P1
     C                   EXSR      SRRCFP1
 
     C     *LOVAL        SETLL     RECMHDL0
 
      ** Read Cash Management Hierarchy Details
 
     C                   READ      RECMHDL0                               01
 
     C                   DOW       *IN01 = *OFF
 
     C                   EXSR      SRPDETL
 
     C                   READ      RECMHDL0                               01
 
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 8
     C                   EXSR      SRCHKLIN
 
     C                   IF        RTOTAL <> 0
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   CLOSE     RE100501P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * All Branch Detail Processing
      *****************************************************************
     C     SRALLBRCH     BEGSR
 
     C                   EVAL      *IN37 = *ON
 
     C     *LOVAL        SETLL     RECMHDL1
 
      ** Open printer file and enroll to RCF
 
     C                   CLOSE     RE100501P1
     C                   OPEN      RE100501P1
     C                   EXSR      SRRCFP1
 
      ** Read Cash Management Hierarchy Details
 
     C                   READ      RECMHDL1                               01
 
     C                   DOW       *IN01 = *OFF
 
     C                   EXSR      SRPDETL
 
     C                   EVAL      WBRCA = CDBRCA
 
     C                   READ      RECMHDL1                               01
 
      ** Generate a new P1 on change of branch
 
     C                   IF        CDBRCA <> WBRCA and *IN01 = *OFF
     C                   WRITE     TRAILP1
     C                   CLOSE     RE100501P1
     C                   OPEN      RE100501P1
     C                   EXSR      SRRCFP1
     C                   ENDIF
 
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 8
     C                   EXSR      SRCHKLIN
 
     C                   IF        RTOTAL <> 0
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   CLOSE     RE100501P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Single Branch Detail Processing
      *****************************************************************
     C     SRSNGBRCH     BEGSR
 
     C                   EVAL      *IN37 = *ON
     C                   EVAL      KBRCA = PEnty
 
 
     C     KMHDL0        SETLL     RECMHDL1
 
      ** Open printer file and enroll to RCF
 
     C                   CLOSE     RE100501P1
     C                   OPEN      RE100501P1
     C                   EXSR      SRRCFP1
 
      ** Read Cash Management Hierarchy Details
 
     C     KMHDL0        READE     RECMHDL1                               01
 
     C                   DOW       *IN01 = *OFF
 
     C                   EXSR      SRPDETL
 
     C     KMHDL0        READE     RECMHDL1                               01
 
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 8
     C                   EXSR      SRCHKLIN
 
     C                   IF        RTOTAL <> 0
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   CLOSE     RE100501P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Print Hierarchy Details
      *****************************************************************
     C     SRPDETL       BEGSR
 
      ** Convert Cash Management Header
 
     C                   EXSR      CNV_CMHEADER
 
      ** Put hierarchy details to printer fields
 
      ** Print Header
 
     C                   WRITE     HEADP1
 
      ** Print Hierarchy Details
 
     C                   WRITE     CMHD
 
      ** Access hierarchy detail group detail record
 
     C                   MOVEL     CDHTYP        I_HTYP
     C                   EXSR      ACS_HIER
 
      * Print Group Account Details
      * OR
      * Print Zero Balancing/Sweeping Details
 
     C                   IF        CDHTYP = 'GA'
     C                   EXSR      SRPGADETL
     C                   ELSE
     C                   EXSR      SRPZSDETL
     C                   ENDIF
 
      ** Setup and print Hierarchy Links
 
     C                   EXSR      SRLINKS
 
      ** Accumulate no. of detail records
 
     C                   EVAL      RTOTAL = RTOTAL + 1
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Print Group Account Details
      *****************************************************************
     C     SRPGADETL     BEGSR
 
      ** Convert Group A/c Header
 
     C                   EXSR      CNV_GAHEADER
 
      ** Print Group Account Details
 
     C                   WRITE     GAHD
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Print Zero Balancing/Sweeping Details
      *****************************************************************
     C     SRPZSDETL     BEGSR
 
      ** Convert Zero Balancing/Sweeping Header
 
     C                   EXSR      CNV_ZSHEADER
 
      ** Print Zero Balancing/Sweeping Details
 
     C                   WRITE     ZSHD
     C     ZDDEST        IFNE      *BLANK
     C                   WRITE     ZSHDX
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Print Hierarchy Links
      *****************************************************************
     C     SRLINKS       BEGSR
 
      ** Build array of parents, number of children and child count
 
     C                   EXSR      SRBUILDARR
 
      ** Find Top Account and print to report (first record is top account)
 
     C     CDHIER        SETLL     RECMHLTPD
     C     CDHIER        READE     RECMHLTPD                              60
     C                   IF        *IN60 = *OFF and
     C                             T_CLCCAT = 'T'
     C                   EXSR      SRPLINK
     C                   EVAL      T_CLPROC = 'Y'
     C                   EVAL      WChildCount = 1
     C                   UPDATE    RECMHLD1
     C                   ELSE
     C                   MOVEL     CDHIER        DBKEY
     C                   EVAL      X_ERMS = 'MISSING TOP ACCOUNT:' + DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Find child of current child account
 
     C                   EXSR      SRFILLKEYP1
 
     C     KCMHLT        SETLL     RECMHLTPD
     C                   READ      RECMHLTPD                              60
 
     C                   DOW       *IN60 = *OFF and
     C                             CDHIER  = T_CLHIER  and
     C                             WChildCount < ChildCount
 
      ** Print if not yet processed
 
     C                   IF        T_CLPROC <> 'Y'
     C                   EXSR      SRPLINK
     C                   EVAL      T_CLPROC = 'Y'
     C                   UPDATE    RECMHLD1
     C                   EVAL      WChildCount = WChildCount + 1
     C                   EVAL      X = 1
 
      ** Keep count of children already processed for this parent
 
     C     PParent       LOOKUP    ArrParent(X)                           61
     C                   IF        *IN61 = *ON
     C                   ADD       1             ArrChildCnt(X)
     C                   ENDIF
 
      ** Record already processed, read next record and set
 
     C                   ELSE
     C                   READ      RECMHLTPD                              60
     C                   EXSR      SRFILLKEYP1
     C                   ITER
     C                   ENDIF
 
      ** If Child account is a sub-account, check if all children for parent have all
      ** been processed, therefore access next parent record
 
     C                   IF        T_CLCCAT = 'S'
 
     C                   EVAL      X = 1
     C     PParent       LOOKUP    ArrParent(X)                           61
     C                   IF        *IN61 = *ON
     C                   IF        ArrNumChild(X) <> ArrChildCnt(X)
     C                   READ      RECMHLTPD                              60
     C                   ITER
     C                   ELSE
 
      ** Get parent of current parent
 
     C                   EXSR      SRFILLKEYC1
     C     KCMHL0        CHAIN     RECMHLL0
     C                   IF        %FOUND(RECMHLL0)
     C                   EVAL      X = 1
     C     CParent       LOOKUP    ArrParent(X)                           61
     C                   DOW       ArrNumChild(X) = ArrChildCnt(X) and
     C                             CLCCAT <> 'T'
     C                   EXSR      SRFILLKEYC2
     C     KCMHL0        CHAIN     RECMHLL0
     C                   EVAL      X = 1
     C     CParent       LOOKUP    ArrParent(X)                           61
     C                   ENDDO
 
     C                   EXSR      SRFILLKEYP2
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Else, Child is not a sub-account, read on using current child as parent
 
     C                   ELSE
     C                   EXSR      SRFILLKEYP1
 
     C                   ENDIF
 
     C     KCMHLT        SETLL     RECMHLTPD
     C                   READ      RECMHLTPD                              60
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Print Link
      *****************************************************************
     C     SRPLINK       BEGSR
 
      ** Check for overflow
 
     C                   Z-ADD     1             RqdLn1
     C                   IF        CDHTYP = 'GA'
     C                   ADD       5             RqdLn1
     C                   ELSE
     C                   ADD       15            RqdLn1
     C                   ENDIF
 
     C                   EXSR      SRCHKLIN
 
      * Convert Cash Management Member
 
     C                   EXSR      CNV_CMMEMBER
 
      * Child a/c
 
     C                   MOVEL     PChild        ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDCRAN           10
 
      ** Indent account information depending on the level of the account in the hierarchy
 
     C                   CLEAR                   RDLINK
 
     C                   IF        T_CLLEVL >= 1
     C                   MOVEL     '----'        RDLINK
 
     C                   IF        T_CLLEVL >= 2
     C                   EVAL      Y = 2
 
     C                   DOW       Y <= T_CLLEVL
     C     RDLINK        CAT       '--':0        RDLINK
     C                   EVAL      Y = Y + 1
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDIF
 
      ** Add GL account number
 
     C     RDLINK        CAT       DDCACC:0      RDLINK
 
      ** Add RE account number
 
     C     RDLINK        CAT       DDCRAN:5      RDLINK
 
      ** Print link
 
     C                   WRITE     CMHL
 
      ** Access hierarchy link
 
     C                   MOVEL     CDHTYP        I_HTYP
     C                   EXSR      ACS_LINK
 
      * Print Group Account Link
      * OR
      * Print Zero Balancing/Sweeping Link
 
     C                   IF        CDHTYP = 'GA'
     C                   EXSR      SRPGALINK
     C                   ELSE
     C                   EXSR      SRPZSLINK
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Print Group Account Link
      *****************************************************************
     C     SRPGALINK     BEGSR
 
      * Convert Group A/c Member
 
     C                   EXSR      CNV_GAMEMBER
 
      * Transaction a/c
     C                   MOVEL     T_ACCID       ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDTRAN
      * Interest income a/c
     C                   MOVEL     I_ACCID       ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDIRAN
      * Interest expense a/c
     C                   MOVEL     E_ACCID       ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDERAN
 
      ** Print Group Account Link
 
     C                   WRITE     GAHL
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Print Zero Balancing/Sweeping Link
      *****************************************************************
     C     SRPZSLINK     BEGSR
 
      * Convert Zero Balancing/Sweeping Member
 
     C                   EXSR      CNV_ZSMEMBER
      * Shadow a/c
     C                   MOVEL     S_ACCID       ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDSRAN
      * Internal Interest Income Account
     C                   MOVEL     S_IIACID      ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDINRN
      * Internal Interest Expense Account
     C                   MOVEL     S_IEACID      ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDEXRN
 
      ** Print Zero Balancing/Sweeping Link
 
     C     ZLSTYP        IFEQ      'Z'
     C                   WRITE     ZSHLZ
     C                   ELSE
     C                   WRITE     ZSHLS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Detail Spool File Recorded by RCF
      *****************************************************************
     C     SRRCFP1       BEGSR
 
     C                   Z-ADD     PSFNUM1       ZSnum
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSerr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Detail Spool File Recorded by RCF
      *****************************************************************
     C     SRRCFAU       BEGSR
 
     C                   Z-ADD     PSFNUMU       ZSnum
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSerr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Build Arrays
      *****************************************************************
     C     SRBUILDARR    BEGSR
 
      ** Build array of parents, number of children and child count
 
     C                   CLEAR                   ArrParent
     C                   CLEAR                   ArrNumChild
     C                   CLEAR                   ArrChildCnt
     C                   EVAL      X = 0
 
     C     CDHIER        SETLL     RECMHLTPD
     C                   READ      RECMHLTPD                              60
     C                   DOW       *IN60  = *OFF and
     C                             CDHIER = T_CLHIER
 
      ** Ignore blank parent (top account)
 
     C                   IF        T_CLCCAT = 'T'
     C                   READ      RECMHLTPD                              60
     C                   ITER
     C                   ENDIF
 
     C                   IF        PParent = WParent
 
      ** If parent already stored, accumulate number of children
 
     C                   ADD       1             ArrNumChild(X)
     C                   READ      RECMHLTPD                              60
     C                   ITER
 
     C                   ELSE
 
      ** Store new parent in array + start count of number of children
 
     C                   EVAL      X = X + 1
     C                   EVAL      ArrParent(X) = PParent
     C                   EVAL      ArrNumChild(X) = 1
     C                   EVAL      WParent = PParent
     C                   ENDIF
 
     C                   READ      RECMHLTPD                              60
 
     C                   ENDDO
 
      ** Determine number of chilren for this hierachy
      ** Add 1 to represent top account
 
     C                   Z-ADD     0             ChildCount
     C                   XFOOT     ArrNumChild   ChildCount
     C                   ADD       1             ChildCount
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Checks for Printer File Overflow Condition
      *****************************************************************
     C     SRCHKLIN      BEGSR
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
 
      ** If not EOF, print continuation line
 
     C                   IF        *IN01 = *OFF
     C                   WRITE     CMHDCONT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Fill in Key to Access RECMHLTPD from Own Child Details
      *****************************************************************
     C     SRFILLKEYP1   BEGSR
 
     C                   EVAL      KPHIER  =  CDHIER
     C                   EVAL      KPPbrc  =  T_CLCBRC
     C                   EVAL      KPPcus  =  T_CLCCUS
     C                   EVAL      KPPccy  =  T_CLCCCY
     C                   EVAL      KPPacd  =  T_CLCACD
     C                   EVAL      KPPasn  =  T_CLCASN
     C                   EVAL      KPCbrc  =  *BLANKS
     C**********         EVAL      KPCcus  =  0                                               CSD027
     C                   EVAL      KPCcus  =  *BLANKS                                         CSD027
     C                   EVAL      KPCccy  =  *BLANKS
     C                   EVAL      KPCacd  =  0
     C                   EVAL      KPCasn  =  0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Fill in Key to Access RECMHLTPD from RECMHLL0 Parent details
      *****************************************************************
     C     SRFILLKEYP2   BEGSR
 
     C                   EVAL      KPHIER  =  CDHIER
     C                   EVAL      KPPbrc  =  CLPBRC
     C                   EVAL      KPPcus  =  CLPCUS
     C                   EVAL      KPPccy  =  CLPCCY
     C                   EVAL      KPPacd  =  CLPACD
     C                   EVAL      KPPasn  =  CLPASN
     C                   EVAL      KPCbrc  =  *BLANKS
     C**********         EVAL      KPCcus  =  0                                               CSD027
     C                   EVAL      KPCcus  =  *BLANKS                                         CSD027
     C                   EVAL      KPCccy  =  *BLANKS
     C                   EVAL      KPCacd  =  0
     C                   EVAL      KPCasn  =  0
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Fill in Key to Access RECMHLL0 from RECMHTLPD Parent Details
      *****************************************************************
     C     SRFILLKEYC1   BEGSR
 
     C                   EVAL      KCHIER  =  CDHIER
     C                   EVAL      KCCbrc  =  T_CLPBRC
     C                   EVAL      KCCcus  =  T_CLPCUS
     C                   EVAL      KCCccy  =  T_CLPCCY
     C                   EVAL      KCCacd  =  T_CLPACD
     C                   EVAL      KCCasn  =  T_CLPASN
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Fill in Key to Access RECMHLL0 from RECMHLL0 Parent Details
      *****************************************************************
     C     SRFILLKEYC2   BEGSR
 
     C                   EVAL      KCHIER  =  CDHIER
     C                   EVAL      KCCbrc  =  CLPBRC
     C                   EVAL      KCCcus  =  CLPCUS
     C                   EVAL      KCCccy  =  CLPCCY
     C                   EVAL      KCCacd  =  CLPACD
     C                   EVAL      KCCasn  =  CLPASN
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Subroutine to Output Audit Report
      *****************************************************************
     C     SRAUDIT       BEGSR
 
      ** Output Report Header and File Controls
 
     C                   WRITE     HEADAU
 
      ** Output "No Details" message
 
     C                   WRITE     NODTLS
 
      ** End program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Access Hierarchy Detail
      *****************************************************************
     C     ACS_HIER      BEGSR
 
     C                   CALLB     'RE100601'
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Option
     C                   PARM      '*EXCLCM'     X_OPTN
      * Hierarchy ID
     C                   PARM      CDHIER        I_HIER
      * Hierarchy Type
     C                   PARM                    I_HTYP
 
     C                   PARM                    O_CMHD
     C                   PARM                    O_ZSHD
     C                   PARM                    O_GAHD
 
      * Database error if record not found
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     X_RTCD        OREQ      '*NOREC'
     C                   MOVEL     CDHIER        DBKEY
     C                   EVAL      X_ERMS = 'BAD HIERARCHY DETAIL:' + DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Access Hierarchy Link
      *****************************************************************
     C     ACS_LINK      BEGSR
 
     C                   CALLB     'RE100602'
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Option
     C                   PARM      '*EXCLCM'     X_OPTN
      * Hierarchy ID
     C                   PARM      CDHIER        I_HIER
      * Hierarchy Type
     C                   PARM                    I_HTYP
      * Link ID
     C                   PARM      T_CLLINK      I_LINK
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      T_CLCBRC      I_CBRC
     C                   PARM      T_CLCCUS      I_CCUS
     C                   PARM      T_CLCCCY      I_CCCY
     C                   PARM      T_CLCACD      I_CACD
     C                   PARM      T_CLCASN      I_CASN
 
     C                   PARM                    O_CMHL
     C                   PARM                    O_ZSHL
     C                   PARM                    O_GAHL
 
      ** Database error if record not found
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     X_RTCD        OREQ      '*NOREC'
     C                   MOVEL     T_CLLINK      DBKEY
     C                   EVAL      X_ERMS = 'BAD HIERARCHY LINK:' + DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************                     CGL029
      /SPACE 5                                                                                CGL029
      ********************************************************************                    CGL029
      *                                                                  *                    CGL029
      * SrAccounts -  Set-up Account IDs                                 *                    CGL029
      *                                                                  *                    CGL029
      ********************************************************************                    CGL029
     C     SrAccounts    BEGSR                                                                CGL029
                                                                                              CGL029
      ** Shadow Acoount                                                                       CGL029
     C                   EVAL      S_ACCID1 = S_ACCID1Temp                                    CGL029
     C                   EVAL      S_ACCID2 = S_ACCID2Temp                                    CGL029
     C                   EVAL      S_ACCID3 = S_ACCID3Temp                                    CGL029
                                                                                              CGL029
      ** Income Acoount                                                                       CGL029
     C                   EVAL      S_IIACID1 = S_IIACID1Temp                                  CGL029
     C                   EVAL      S_IIACID2 = S_IIACID2Temp                                  CGL029
     C                   EVAL      S_IIACID3 = S_IIACID3Temp                                  CGL029
                                                                                              CGL029
      ** Expense Account                                                                      CGL029
     C                   EVAL      S_IEACID1 = S_IEACID1Temp                                  CGL029
     C                   EVAL      S_IEACID2 = S_IEACID2Temp                                  CGL029
     C                   EVAL      S_IEACID3 = S_IEACID3Temp                                  CGL029
                                                                                              CGL029
     C                   ENDSR                                                                CGL029
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Cash Management Header
      ********************************************************************
     C     CNV_CMHEADER  BEGSR
 
     C                   CALLB     'RE100311'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
 
      * INPUTS
 
      * Date format
     C                   PARM      'A'           I_DATFMT          1
      * Date Effective From
      * Review Date
      * Last Change Date
     C                   PARM      CDDEFR        I_DEFR            5 0
     C                   PARM      CDRVDT        I_RVDT            5 0
     C                   PARM      CDLCDT        I_LCDT            5 0
 
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Date Effective From
      * Review Date
      * Last Change Date
     C                   PARM                    DDDEFR            7
     C                   PARM                    DDRVDT            7
     C                   PARM                    DDLCDT            7
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN CASH MANAGEMENT HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Zero Balancing/Sweeping Header
      ********************************************************************
     C     CNV_ZSHEADER  BEGSR
 
      * Get currency of top a/c
 
     C     I_HIER        SETLL     RECMHLGL
     C     I_HIER        READE     RECMHLGL                               60
 
     C                   CALLB     'RE100312'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      * INPUTS
      * Child Currency
     C                   PARM      CLCCCY        I_CCCY            3
      * Edit code
     C                   PARM      *BLANK        I_ECODE           1
 
      * Input Cycle Sweeping Frequency
      * Input Cycle Sweeping Indicators
     C                   PARM      ZDICSF        I_ICSF           48
     C                   PARM      ZDICSI        I_ICSI           12
 
      * Sweeping Holiday Convention
     C                   PARM      ZDSHOC        I_SHOC            1
 
      * Check For Cover on Top A/c
     C                   PARM      ZDCHKC        I_CHKC            1
 
      * External
      * Master Account
      * External Fwd Value Sweeping
      * External Account 1                                                      214360
     C                   PARM      ZDEXTL        I_EXTL            1
     C                   PARM      ZDMAST        I_MAST            1
     C                   PARM      ZDEFVS        I_EFVS            1
     C                   PARM      ZDEXA1        I_EXA1           35            214360
 
      * MT202 Cover Message Required
     C                   PARM      ZDMCMR        I_MCMR            1
 
      * MT101 Charges Account
      * MT101 Charges Amount
     C**********         PARM      ZDCAC1        I_C1ACCID        18                          CGL029
     C                   PARM      ZDCAC1        I_C1ACCID                                    CGL029
     C                   PARM      ZDCAM1        I_CAM1           15 0
 
      * MT103 Charges Account
      * MT103 Charges Amount
     C**********         PARM      ZDCAC3        I_C3ACCID        18                          CGL029
     C                   PARM      ZDCAC3        I_C3ACCID                                    CGL029
     C                   PARM      ZDCAM3        I_CAM3           15 0
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM      ZDDEFP        I_DEFP            1            214360
     C                   PARM      ZDDEFZ        I_DEFZ            1            214360
 
      * OUTPUTS
 
      * Input Cycle Sweeping Frequency
      * Input Cycle Sweeping Indicators
     C                   PARM                    DDICSF           59
     C                   PARM                    DDICSI           48
 
      * Sweeping Holiday Convention
     C                   PARM                    DDSHOC            7
 
      * Check For Cover on Top A/c
     C                   PARM                    DDCHKC            3
 
      * External
      * Master Account
      * External Fwd Value Sweeping
      * External Account 1                                                      214360
     C                   PARM                    DDEXTL            3
     C                   PARM                    DDMAST            3
     C                   PARM                    DDEFVS            3
     C                   PARM                    DDEXA11          25            214360
     C                   PARM                    DDEXA12          10            214360
 
      * MT202 Cover Message Required
     C                   PARM                    DDMCMR            3
 
      * MT101 Charges Account
      * MT101 Charges Amount
     C**********         PARM                    DDC1ACC          22                          CGL029
     C                   PARM                    DDC1ACC                                      CGL029
     C                   PARM                    DDCAM1           17
 
      * MT103 Charges Account
      * MT103 Charges Amount
     C**********         PARM                    DDC3ACC          22                          CGL029
     C                   PARM                    DDC3ACC                                      CGL029
     C                   PARM                    DDCAM3           17
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM                    DDDEFP            3            214360
     C                   PARM                    DDDEFZ            3            214360
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN ZERO BAL/SWEEPING HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Group A/c Header
      ********************************************************************
     C     CNV_GAHEADER  BEGSR
 
     C                   CALLB     'RE100313'
 
      * Return code
      * Error Message
     C                   PARM      *BLANKS       X_RTCD
     C                   PARM      *BLANKS       X_ERMS
      * INPUTS
 
      * Top on Balance Sheet
      * Link Effective At Last Capitalization Date
      * Unlink Effective At Last Capitalization Date
     C                   PARM      GDTOPB        I_TOPB            1
     C                   PARM      GDLELC        I_LELC            1
     C                   PARM      GDUELC        I_UELC            1
 
      * OUTPUTS
 
      * Top on Balance Sheet
      * Link Effective At Last Capitalization Date
      * Unlink Effective At Last Capitalization Date
     C                   PARM                    DDTOPB            3
     C                   PARM                    DDLELC            3
     C                   PARM                    DDUELC            3
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN GROUP A/C HEADER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Cash Management Member
      ********************************************************************
     C     CNV_CMMEMBER  BEGSR
 
     C                   CALLB     'RE100314'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Child a/c
      * Parent a/c
     C**********         PARM      PChild        I_CACCID         18                          CGL029
     C**********         PARM      PParent       I_PACCID         18                          CGL029
     C                   PARM      PChild        I_CACCID                                     CGL029
     C                   PARM      PParent       I_PACCID                                     CGL029
 
      * OUTPUTS
      * Child a/c
      * Parent a/c
     C**********         PARM                    DDCACC           22                          CGL029
     C**********         PARM                    DDPACC           22                          CGL029
     C                   PARM                    DDCACC                                       CGL029
     C                   PARM                    DDPACC                                       CGL029
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN CASH MANAGEMENT MEMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Zero Balancing/Sweeping Member
      ********************************************************************
     C     CNV_ZSMEMBER  BEGSR
 
     C                   EXSR      SrAccounts                                                 CGL029
                                                                                              CGL029
     C                   CALLB     'RE100315'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Child Currency
     C                   PARM      T_CLCCCY      I_CCCY            3
      * Edit code
     C                   PARM      'J'           I_ECODE           1
      * Date format
     C                   PARM      'A'           I_DATFMT          1
      * Sweep Type
     C                   PARM      ZLSTYP        I_STYP            1
      * Sweeping Frequency
      * Sweeping Day
      * Last Sweep Date
      * Next Sweep Date
     C                   PARM      ZLSFRQ        I_SFRQ            1
     C                   PARM      ZLSDAY        I_SDAY            2 0
     C                   PARM      ZLLSDT        I_LSDT            5 0
     C                   PARM      ZLNSDT        I_NSDT            5 0
      * Sweep Capitalized Interest
      * Sweep Cleared Balance on Association Date
      * Zero Balance - Net or Gross
     C                   PARM      ZLSCPI        I_SCPI            1
     C                   PARM      ZLSCBD        I_SCBD            1
     C                   PARM      ZLZBNG        I_ZBNG            1
      * Target Balance
     C                   PARM      ZLTGBL        I_TGBL           15 0
      * Reverse Sweep
     C                   PARM      ZLRVSW        I_RVSW            1
      * Shadow a/c
     C**********         PARM      S_ACCID       I_SACCID         18                          CGL029
     C                   PARM      S_ACCID       I_SACCID                                     CGL029
      * Internal Interest Income Account
     C**********         PARM      S_IIACID      I_IIACID         18                          CGL029
     C                   PARM      S_IIACID      I_IIACID                                     CGL029
      * Internal Interest Expense Account
     C**********         PARM      S_IEACID      I_IEACID         18                          CGL029
     C                   PARM      S_IEACID      I_IEACID                                     CGL029
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM      ZLMINB        I_MINB           15 0
     C                   PARM      ZLMINL        I_MINL           15 0
     C                   PARM      ZLMAXB        I_MAXB           15 0
     C                   PARM      ZLMAXL        I_MAXL           15 0
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM      ZLMDVD        I_MDVD           15 0
     C                   PARM      ZLMDCD        I_MDCD            3 0
      * Floor Limit for Top
      * Floor Limit for Sweep
     C                   PARM      ZLFLFT        I_FLFT           15 0
     C                   PARM      ZLFLFS        I_FLFS           15 0
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Sweep Type
     C                   PARM                    DDSTYP           12
      * Sweeping Frequency
      * Sweeping Day
      * Last Sweep Date
      * Next Sweep Date
     C                   PARM                    DDSFRQ           30
     C                   PARM                    DDSDAY            2
     C                   PARM                    DDLSDT            7
     C                   PARM                    DDNSDT            7
      * Sweep Capitalized Interest
      * Sweep Cleared Balance on Association Date
      * Zero Balance - Net or Gross
     C                   PARM                    DDSCPI            3
     C                   PARM                    DDSCBD            3
     C                   PARM                    DDZBNG            5
      * Target Balance
     C                   PARM                    DDTGBL           22
      * Reverse Sweep
     C                   PARM                    DDRVSW            3
      * Shadow a/c
     C**********         PARM                    DDSACC           22                          CGL029
     C                   PARM                    DDSACC                                       CGL029
      * Internal Interest Income Account
     C**********         PARM                    DDINAC           22                          CGL029
     C                   PARM                    DDINAC                                       CGL029
      * Internal Interest Expense Account
     C**********         PARM                    DDEXAC           22                          CGL029
     C                   PARM                    DDEXAC                                       CGL029
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM                    DDMINB           22
     C                   PARM                    DDMINL           22
     C                   PARM                    DDMAXB           22
     C                   PARM                    DDMAXL           22
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM                    DDMDVD           22
     C                   PARM                    DDMDCD            5
      * Floor Limit for Top
      * Floor Limit for Sweep
     C                   PARM                    DDFLFT           22
     C                   PARM                    DDFLFS           22
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN ZERO BAL/SWEEPING MEMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Group A/c Member
      ********************************************************************
     C     CNV_GAMEMBER  BEGSR
 
     C                   CALLB     'RE100316'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Child Currency
     C                   PARM      T_CLCCCY      I_CCCY            3
      * Edit code
     C                   PARM      'J'           I_ECODE           1
 
      * Balance Available for Inter Company Overdraft
      * Inter Company Threshold Balance
     C                   PARM      GLBAIC        I_BAIC            1
     C                   PARM      GLICTB        I_ICTB           15 0
      * Transaction A/c
      * (Interest) Income A/c
      * (Interest) Expense A/c
     C**********         PARM      T_ACCID       I_TACCID         18                          CGL029
     C**********         PARM      I_ACCID       I_IACCID         18                          CGL029
     C**********         PARM      E_ACCID       I_EACCID         18                          CGL029
     C                   PARM      T_ACCID       I_TACCID                                     CGL029
     C                   PARM      I_ACCID       I_IACCID                                     CGL029
     C                   PARM      E_ACCID       I_EACCID                                     CGL029
 
      * OUTPUTS
 
      * Balance Available for Inter Company Overdraft
      * Inter Company Threshold Balance
     C                   PARM                    DDBAIC            3
     C                   PARM                    DDICTB           22
      * Transaction A/c
      * (Interest) Income A/c
      * (Interest) Expense A/c
     C**********         PARM                    DDTACC           22                          CGL029
     C**********         PARM                    DDIACC           22                          CGL029
     C**********         PARM                    DDEACC           22                          CGL029
     C                   PARM                    DDTACC                                       CGL029
     C                   PARM                    DDIACC                                       CGL029
     C                   PARM                    DDEACC                                       CGL029
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN GROUP A/C MEMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           99        *
     C  N99              MOVEL     ACNO          A_ACNO           10
     C   99              MOVEL     *BLANK        A_ACNO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR - Program Initialisation Routine
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOBANKR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key list for RECMHLTPD
 
     C     KCMHLT        KLIST
     C                   KFLD                    KPHIER
     C                   KFLD                    KPPbrc
     C                   KFLD                    KPPcus
     C                   KFLD                    KPPccy
     C                   KFLD                    KPPacd
     C                   KFLD                    KPPasn
     C                   KFLD                    KPCbrc
     C                   KFLD                    KPCcus
     C                   KFLD                    KPCccy
     C                   KFLD                    KPCacd
     C                   KFLD                    KPCasn
 
      ** Key list for RECMHLL0
 
     C     KCMHL0        KLIST
     C                   KFLD                    KCHIER
     C                   KFLD                    KCCbrc
     C                   KFLD                    KCCcus
     C                   KFLD                    KCCccy
     C                   KFLD                    KCCacd
     C                   KFLD                    KCCasn
 
      ** Key list for RECMHDL0
 
     C     KMHDL0        KLIST
     C                   KFLD                    KBRCA
 
      * key list for ACCNT
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
 
     C                   ENDSR
      *****************************************************************
      /COPY ZACPYSRC,RECMPSSR
