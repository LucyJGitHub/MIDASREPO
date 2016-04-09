     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Zero Balancing/Sweeping Entry Generation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100608 - Zero Balancing/Sweeping Entry Generation          *
      *                                                               *
      *  Function:  This program is given a child and parent a/c and  *
      *             basic posting details. It then writes entries to  *
      *             GECMPD (with extension details written to GLAPSTZS)
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 216421             Date 06Apr03               *
      *                 215675             Date 10Mar03               *
      *                 215205             Date 24Feb03               *
      *                 212904             Date 14Jan03               *
      *                 213569             Date 10Feb03               *
      *                 214360             Date 03Feb03               *
      *                 213196             Date 21Jan03               *
      *                 213572             Date 07Jan03               *
      *                 212367             Date 10Dec02               *
      *                 211629             Date 04Dec02               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216421 - External tops are back-valued                       *
      *  215675 - Sweep is not stopped when account is inactive       *
      *  215205 - Holiday checking for zero balancing                 *
      *  212904 - Balance purge errors                                *
      *  213569 - Charges errors                                      *
      *           Generate charges for external tops/sweeps           *
      *  214360 - Cash Management Deferred Posting                    *
      *  213196 - Holidays are not checked for top/sweeps             *
      *  213572 - Posting narrative wrong on nostro/vostro            *
      *  212367 - Various reporting errors                            *
      *  211629 - Narratives mixed up in top and sub a/cs             *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FREICSDL6  IF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)                         213569
     F                                     PREFIX(A_)                           213569
     FCBAICDL1  IF   E           K DISK    INFSR(*PSSR)                         213196
     FGECXPD    O    E             DISK    INFSR(*PSSR) USROPN
     F                                     PREFIX(E_)
     F                                     COMMIT
     FGLAPSTZS  O    E             DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
     FRE100608P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
     D/COPY FTCPYSRC,FT0010D001                                                 213569
      *****************************************************************
 
 
      ** Chain Arrays
     D*I_GLAI***       S             18    DIM(99)                                            CGL029
     D I_GLAI          S             24    DIM(99)                                            CGL029
     D I_RAN           S             10    DIM(99)
     D I_AST           S              1    DIM(99)
     D I_PC            S              4    DIM(99)
     D I_ASC           S              2    DIM(99)
     D I_ODFT          S             15S 0 DIM(99)
     D I_BAIC          S              1    DIM(99)
     D I_ICTB          S             15S 0 DIM(99)
      ** Chain Arrays
     D*O_GLAI***       S             18    DIM(99)                                            CGL029
     D O_GLAI          S             24    DIM(99)                                            CGL029
     D O_RAN           S             10    DIM(99)
     D O_AST           S              1    DIM(99)
     D O_PC            S              4    DIM(99)
     D O_ASC           S              2    DIM(99)
     D O_ODFT          S             15S 0 DIM(99)
     D O_BAIC          S              1    DIM(99)
     D O_ICTB          S             15S 0 DIM(99)
 
 
     D                 DS
     D AccountSTAT             1     26
     D*AccountSTATX************1      4                                         215675
     D AccountSTATX            1      5                                         215675
     D Closed                  1      1
     D Bankrpt                 2      2
     D Baddebt                 3      3
     D BlockZBSW               4      4
     D Inactive                5      5                                         215675
     D ReferDR                11     11
     D ReferCR                12     12
     D BlockDR                13     13
     D BlockCR                14     14
     D AcType                 21     26
 
 
      * Account ID
     D                 DS
     D***ACCID**                 1     18                                                     CGL029
     D ACCID                   1     24                                                       CGL029
     D BRC                     1      3
     D*CUS******               4      9S 0                                                    CSD027
     D CUS                     4      9A                                                      CSD027
     D CCY                    10     12
     D***ACD****                13     16S 0                                                  CGL029
     D***ASN****                17     18S 0                                                  CGL029
     D ACD                    13     22S 0                                                    CGL029
     D ASN                    23     24S 0                                                    CGL029
 
 
      * Last Account ID
     D                 DS
     D***L_ACCID                 1     18                                                     CGL029
     D L_ACCID                 1     24                                                       CGL029
     D L_BRC                   1      3
     D*L_CUS****               4      9S 0                                                    CSD027
     D L_CUS                   4      9A                                                      CSD027
     D L_CCY                  10     12
     D***L_ACD**                13     16S 0                                                  CGL029
     D***L_ASN**                17     18S 0                                                  CGL029
     D L_ACD                  13     22S 0                                                    CGL029
     D L_ASN                  23     24S 0                                                    CGL029
 
                                                                                213569
      *  DEBIT Charge Account                                                   213569
     D***@DRChAcct       DS            18                                              213569 CGL029
     D @DRChAcct       DS            24                                                       CGL029
     D  @DrChBRCA              1      3                                         213569
     D**@DrChCNUM              4      9  0                                             213569 CSD027
     D  @DrChCNUM              4      9A                                                      CSD027
     D  @DrChCCY              10     12                                         213569
     D***@DrChACOD             13     16  0                                            213569 CGL029
     D***@DrChACSQ             17     18  0                                            213569 CGL029
     D  @DrChACOD             13     22  0                                                    CGL029
     D  @DrChACSQ             23     24  0                                                    CGL029
                                                                                213569
     D  @DrChACNO      S             10  0                                      213569
     D  @DrChPRFC      S              4                                         213569
     D  @DrChACSC      S              2                                         213569
     D  @DrChATYP      S              1                                         213569
     D  @DrChgAmt      S             13  0                                      213569
                                                                                213569
      *  CREDIT Charge Account                                                  213569
     D***@CRChAcct       DS            18                                              213569 CGL029
     D @CRChAcct       DS            24                                                       CGL029
     D  @CrChBRCA              1      3                                         213569
     D**@CrChCNUM              4      9  0                                             213569 CSD027
     D  @CrChCNUM              4      9A                                                      CSD027
     D  @CrChCCY              10     12                                         213569
     D***@CrChACOD             13     16  0                                            213569 CGL029
     D***@CrChACSQ             17     18  0                                            213569 CGL029
     D  @CrChACOD             13     22  0                                                    CGL029
     D  @CrChACSQ             23     24  0                                                    CGL029
                                                                                213569
     D  @CrChACNO      S             10  0                                      213569
     D  @CrChPRFC      S              4                                         213569
     D  @CrChACSC      S              2                                         213569
     D  @CrChATYP      S              1                                         213569
     D  @CrChgAmt      S             13  0                                      213569
                                                                                213569
 
      * Output Entry
     D O_ENTRY       E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(E_)
      * Replication Entry
     D I_RENTRY      E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(ER_)
 
 
      * Output Extension Record
     D O_EXTSN       E DS                  EXTNAME(GLAPSTZS)
     D MT94XField86          142    531
 
 
     D #_INF           S             70    DIM(7)  CTDATA PERRCD(1)
     D I_XRFN          S             10    DIM(6)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCMAN        E DS                  EXTNAME(SDCMANPD)                    213569
      ** External DS for cash management details                                213569
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                    213569
      ** Branch Details                                                         213569
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)                    213569
      ** Account Code Details                                                   213569
     D C_SDCURR      E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(C_)
     D P_SDCURR      E DS                  EXTNAME(SDCURRPD)
     D                                     PREFIX(P_)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)                       213569
      ** Second DS for access programs                                          213569
 
 
      ** File Information Data Structure for RE100608P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
      * If end requested
      *  Produce end of report
      *  Close files
      *  Do last return
 
     C     X_OPTN        IFEQ      '*END   '
     C     PgmEnded      IFNE      'Y'
     C                   EXSR      END_OF_REP
     C                   CLOSE     RE100608P1
     C                   CLOSE     GECXPD
     C                   CLOSE     GLAPSTZS
     C                   MOVEL     'Y'           PgmEnded          1
     C                   ENDIF
     C                   RETURN
     C                   ENDIF
 
      * Ignore this run code
 
     C                   MOVEL     *BLANK        IgnoreThisRun    15
     C     I_CADC        IFEQ      'C'
     C                   EVAL      IgnoreThisRun = '*IGNORE' + I_MODE
     C                                             + 'S'
     C                   ELSE
     C                   EVAL      IgnoreThisRun = '*IGNORE' + I_MODE
     C                                             + 'T'
     C                   ENDIF
 
      * Initialize 'entries generated' indicator
 
     C                   MOVEL     'N'           O_EntriesGen
 
      * Source a/c ID ( = Child a/c ID)
 
     C                   MOVEL     I_CBRC        BRC
     C                   MOVEL     I_CCUS        CUS
     C                   MOVEL     I_CCCY        CCY
     C                   MOVEL     I_CACD        ACD
     C                   MOVEL     I_CASN        ASN
 
      * If new currency, access child a/c currency
 
     C     I_CCCY        IFNE      L_CCCY
     C                   MOVEL     I_CCCY        L_CCCY            3
     C                   MOVEL     I_CCCY        CCY
     C                   EXSR      ACS_CURR
     C                   MOVEL     SDCURR        C_SDCURR
     C                   ENDIF
 
      * If new currency, access parent a/c currency
 
     C     I_PCCY        IFNE      L_PCCY
     C                   MOVEL     I_PCCY        L_PCCY            3
     C                   MOVEL     I_PCCY        CCY
     C                   EXSR      ACS_CURR
     C                   MOVEL     SDCURR        P_SDCURR
     C                   ENDIF
 
      * If sweeping only to be done and posting is a top,
      * ignore the posting
 
     C     I_SWP_TOP     IFEQ      'S'
     C     I_CADC        ANDEQ     'C'
     C                   RETURN
     C                   ENDIF
 
      * If topping only to be done and posting is a sweep,
      * ignore the posting
 
     C     I_SWP_TOP     IFEQ      'T'
     C     I_CADC        ANDEQ     'D'
     C                   RETURN
     C                   ENDIF
 
      * Check for posting block
 
     C                   EXSR      CHK4BLOCK
 
      * Check for posting referral
 
     C                   EXSR      CHK4REFER
 
      * Entries generated = 'Yes'
 
     C                   MOVEL     'Y'           O_EntriesGen
 
      * Update top a/c balance
      * (Posting to top a/c occurs at level 1. The top a/c is the parent)
 
     C     I_LEVL        IFEQ      1
     C     I_CADC        IFEQ      'C'
     C                   ADD       I_PSTA        I_TopBalance
     C                   ELSE
     C                   SUB       I_PSTA        I_TopBalance
     C                   ENDIF
     C                   ENDIF
 
      * Shadow Post Entries?
      * (Supress shadow posting if it's a top - i.e. a credit -to a top a/c)
 
     C     I_MODE        IFEQ      'I/C'
     C     I_CCAT        IFEQ      'T'
     C     I_CADC        ANDEQ     'C'
     C                   MOVEL     'N'           ShadowPost        1
     C                   ELSE
     C                   MOVEL     'Y'           ShadowPost
     C                   ENDIF
     C                   ENDIF
     C     I_MODE        IFNE      'I/C'                                        214360
     C     I_CCAT        ANDEQ     'T'                                          214360
     C     I_CADC        IFEQ      'C'                                          214360
     C                   MOVEL     'N'           ShadowPost                     214360
     C                   ELSE                                                   214360
     C                   MOVEL     'O'           ShadowPost                     214360
     C                   ENDIF                                                  214360
     C                   ENDIF                                                  214360
 
      * Count of entries
      * Extension Ref. Nos.
     C                   Z-ADD     0             C                 2 0
     C                   MOVEL     *BLANK        I_XRFN
 
      * If new source a/c,
      *   report source a/c
 
     C     ACCID         IFNE      L_ACCID
     C                   EXSR      REP_SACCNT
     C                   MOVEL     ACCID         L_ACCID
     C                   ENDIF
 
      * Convert posting amount into contra amount
 
     C                   EXSR      CONVERT
     C*                                                                         213569
     C* Determine Charges details (some details will be needed in parent        213569
     C* posting                                                                 213569
                                                                                213569
     C     I_CCAT        IFEQ      'T'                                          213569
     C     I_CADC        IFEQ      'C'                                          213569
     C     I_CAM1        ANDGT     0                                            213569
     C     I_CADC        OREQ      'D'                                          213569
     C     I_CAM3        ANDGT     0                                            213569
     C                   EXSR      GET_ChgDet                                   213569
     C                   ENDIF                                                  213569
     C                   ENDIF                                                  213569
 
      * Increment sequence number
 
     C                   ADD       1             I_NASN
 
      * Determine if CHILD a/c posting is to a group a/c hierarchy
 
     C                   MOVEL     I_CBRC        I_BRC
     C                   MOVEL     I_CCUS        I_CUS
     C                   MOVEL     I_CCCY        I_CCY
     C                   MOVEL     I_CACD        I_ACD
     C                   MOVEL     I_CASN        I_ASN
     C                   MOVEL     I_CRNO        I_RNO
     C                   MOVEL     I_CPRF        I_PRF
     C                   MOVEL     I_CACS        I_ACS
     C                   MOVEL     'R'           I_ATY
     C                   EXSR      DET_POSTGAH
 
      * If entry is due for deletion by RE100714
      *  Set A/c in Group A/c Hierarchy = 'N'
      *  so that replication up the hierarchy is not done here.
 
     C     I_TBAL        IFEQ      'Y'
     C     I_TAST        ANDNE     'Z'                                          214360
     C     I_Max_Dr_Excd OREQ      'Y'
     C                   MOVE      'N'           O_AcInGAH
     C                   ENDIF
 
      * Get Next Available Ref. No.
 
     C                   EXSR      GET_APNA
 
      * Determine posting narrative
 
     C                   MOVEL     'CHILD '      AcType            6
     C                   EXSR      DET_PNAR
     C/COPY WNCPYSRC,RE100608C1
 
      * Write CHILD extension record
      * Write CHILD entry
 
     C                   EXSR      WRT_CEXTSN
     C                   EXSR      WRT_CENTRY
 
     C                   ADD       1             C
     C                   MOVEL     O_XRFN        I_XRFN(C)
 
      * Shadow post entry in input cycle
 
     C     I_MODE        IFEQ      'I/C'
     C     ShadowPost    ANDEQ     'Y'
     C                   EXSR      SHP_ENTRY
     C                   ENDIF
 
      * If posting to a group a/c hierachy a/c in COB
      *  Do group account entry generation (up the hierarchy)
 
     C     I_MODE        IFNE      'I/C'
     C     I_MODE        ANDNE     'PUR'                                        212904
     C     I_CCAT        ANDNE     'T'                                          214360
     C     O_AcInGAH     ANDEQ     'Y'
     C                   EXSR      GROUPAC_EG
     C                   ENDIF
 
      * Report entry
 
     C                   EXSR      REP_ENTRY
 
      **If*mode*=*purge*value date balances,                                    212904
      **generate*the*child entry only.                                          212904
      *******************                                                       212904
     C*****I_MODE********IFEQ      'PUR'                                        212904
     C*******************RETURN                                                 212904
     C*******************ENDIF                                                  212904
 
      * Determine if PARENT a/c posting is to a group a/c hierarchy
 
     C                   MOVEL     I_PBRC        I_BRC
     C                   MOVEL     I_PCUS        I_CUS
     C                   MOVEL     I_PCCY        I_CCY
     C                   MOVEL     I_PACD        I_ACD
     C                   MOVEL     I_PASN        I_ASN
     C                   MOVEL     I_PRNO        I_RNO
     C                   MOVEL     I_PPRF        I_PRF
     C                   MOVEL     I_PACS        I_ACS
     C                   MOVEL     I_PATY        I_ATY
     C                   EXSR      DET_POSTGAH
 
      * Get Next Available Ref. No.
 
     C                   EXSR      GET_APNA
 
      * Determine posting narrative
 
     C                   MOVEL     'PARENT'      AcType
     C                   EXSR      DET_PNAR
     C/COPY WNCPYSRC,RE100608C1
 
      * Write PARENT extension record
      * Write PARENT entry
 
     C                   EXSR      WRT_PEXTSN
     C                   EXSR      WRT_PENTRY
 
     C                   ADD       1             C
     C                   MOVEL     O_XRFN        I_XRFN(C)
 
      * Shadow post entry in input cycle
 
     C     I_MODE        IFEQ      'I/C'
     C     ShadowPost    ANDEQ     'Y'
     C                   EXSR      SHP_ENTRY
     C                   ENDIF
 
      * If posting to a group a/c hierachy a/c in COB
      *  Do group account entry generation (up the hierarchy)
 
     C     I_MODE        IFNE      'I/C'
     C     I_MODE        ANDNE     'PUR'                                        212904
     C     I_CCAT        ANDNE     'T'                                          214360
     C     O_AcInGAH     ANDEQ     'Y'
     C                   EXSR      GROUPAC_EG
     C                   ENDIF
 
      * Report entry
 
     C                   EXSR      REP_ENTRY
                                                                                213569
      * Generate charges if entries are for top account and charges are due     213569
                                                                                213569
     C     I_CCAT        IFEQ      'T'                                          213569
     C     I_CADC        IFEQ      'C'                                          213569
     C     I_CAM1        ANDGT     0                                            213569
     C     I_CADC        OREQ      'D'                                          213569
     C     I_CAM3        ANDGT     0                                            213569
     C                   EXSR      GEN_CHARGES                                  213569
     C                   ENDIF                                                  213569
     C                   ENDIF                                                  213569
 
      * If running in input cycle
      * or COB top a/c zero-balancing/sweeping                                  214360
      ***Adjust*value*date*(if*posting*to*a*top*a/c)                            216421
      *  Write to input cycle zero balancing/sweeping files
 
     C     I_MODE        IFEQ      'I/C'
     C     I_MODE        ORNE      'I/C'                                        214360
     C     I_CCAT        ANDEQ     'T'                                          214360
     C*****I_CCAT********IFEQ      'T'                                          216421
     C*******************EXSR      ADJ_VALD                                     216421
     C*******************ENDIF                                                  216421
     C                   EXSR      WRT_ICS
     C                   ENDIF
 
     C                   RETURN
 
      /SPACE 5
     C/COPY WNCPYSRC,RE100608C2
      /SPACE 5
      ********************************************************************
      * Determine if Posting To Group A/c Hierarchy
      ********************************************************************
     C     DET_POSTGAH   BEGSR
 
     C                   CALLB     'RE100614'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Branch
      * Customer
      * Currency
      * A/c code
      * A/c seq.
     C                   PARM                    I_BRC             3
     C**********         PARM                    I_CUS             6 0                        CSD027
     C                   PARM                    I_CUS             6                          CSD027
     C                   PARM                    I_CCY             3
     C**********         PARM                    I_ACD             4 0                        CGL029
     C                   PARM                    I_ACD            10 0                        CGL029
     C                   PARM                    I_ASN             2 0
      * Retail no.
      * A/c profit centre
      * A/c account section
      * A/c account type
     C                   PARM                    I_RNO            10 0
     C                   PARM                    I_PRF             4
     C                   PARM                    I_ACS             2
     C                   PARM                    I_ATY             1
 
      * OUTPUTS
      * A/c in Group A/c Hierarchy?
     C                   PARM                    O_AcInGAH         1
      * Group A/c Hierarchy A/c Category
     C                   PARM                    O_GCAT            1
      * Replication Hierarchy ID
      * Replication Hierarchy Shortname
     C                   PARM                    O_RHIER           9 0
     C                   PARM                    O_RHISN          10
      * Replication Link ID
     C                   PARM                    O_RLINK           9 0
      * Replication Branch
      * Replication Customer
      * Replication Currency
      * Replication A/c code
      * Replication A/c seq.
     C                   PARM                    O_RBRC            3
     C**********         PARM                    O_RCUS            6 0                        CSD027
     C                   PARM                    O_RCUS            6                          CSD027
     C                   PARM                    O_RCCY            3
     C**********         PARM                    O_RACD            4 0                        CGL029
     C                   PARM                    O_RACD           10 0                        CGL029
     C                   PARM                    O_RASN            2 0
      * Replication A/c Category
     C                   PARM                    O_RCAT            1
      * Replication retail no.
      * Replication a/c profit centre
      * Replication a/c account section
      * Replication a/c account type
     C                   PARM                    O_RRNO           10 0
     C                   PARM                    O_RPRF            4
     C                   PARM                    O_RACS            2
     C                   PARM                    O_RATY            1
      * Replication Source level
     C                   PARM                    O_RLEVL           2 0
 
      * CHAINS FOR:
      * GL Account ID
      * Retail A/c No.
      * A/c Status
      * Profit Centre
      * A/c Section
      * Overdraft
      * Balance Available for I/C Overdraft
      * I/C Threshold Balance
     C                   PARM                    O_GLAI
     C                   PARM                    O_RAN
     C                   PARM                    O_AST
     C                   PARM                    O_PC
     C                   PARM                    O_ASC
     C                   PARM                    O_ODFT
     C                   PARM                    O_BAIC
     C                   PARM                    O_ICTB
      * Count in chain
     C                   PARM                    O_CNTCH           2 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN DETERMINING IF ' +
     C                                      'POSTING TO GROUP A/C ' +
     C                                      'HIERARCHY'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write CHILD Extension record
      ********************************************************************
     C     WRT_CEXTSN    BEGSR
 
      * Clear output extension record
 
     C                   CLEAR                   O_EXTSN
 
      * Ext.File Ref.ID
     C                   MOVEL     I_XRFI        AZXRFI
      * Ext.File Ref.No.
     C                   MOVEL     O_XRFN        AZXRFN
      * Account branch
      * Account customer
      * Account currency
      * Account a/c code
      * Account a/c seq.
     C                   MOVEL     I_PBRC        AZABRC
     C                   MOVEL     I_PCUS        AZACUS
     C                   MOVEL     I_PCCY        AZACCY
     C                   MOVEL     I_PACD        AZAACD
     C                   MOVEL     I_PASN        AZAASN
      * Account retail no.
     C                   MOVEL     I_PRNO        AZARNO
      * A/c is source or destination
     C                   MOVEL     'D'           AZASDA
      * Contra posting amount
     C                   Z-ADD     ContraAMT     AZCAMT
      * Sweep Type
     C                   MOVEL     I_STYP        AZSTYP
     C     I_DEFZ        IFEQ      'Y'                                          216421
     C                   MOVEL     'Z'           AZSTYP                         216421
     C                   ENDIF                                                  216421
      * Top/Sweep
     C     I_CADC        IFEQ      'C'
     C                   MOVEL     'T'           AZTPSW
     C                   ELSE
     C                   MOVEL     'S'           AZTPSW
     C                   ENDIF
      * Target Balance
     C                   MOVEL     I_TBAL        AZTBAL
      * Cleared Bal Sweep on Assoc Date
     C                   MOVEL     I_CBSA        AZCBSA
      * Shadow Entry
     C                   MOVEL     'N'           AZSHAD
      * Mode of Origin
     C                   MOVEL     I_MODE        AZMODO
      * Date Generated
     C                   Z-ADD     BJRDNB        AZDATG
      * Sequence Number
     C                   MOVEL     I_NASN        AZSNUM
 
      * MT94X Field 61 - 6
     C     I_STYP        IFEQ      'Z'
     C     I_DEFZ        OREQ      'Y'                                          216421
     C                   MOVEL     'NCMZ'        AZF616
     C                   ELSE
     C     I_CADC        IFEQ      'C'
     C                   MOVEL     'NCMT'        AZF616
     C                   ELSE
     C                   MOVEL     'NCMS'        AZF616
     C                   ENDIF
     C                   ENDIF
      * MT94X Field 61 - 7
     C     I_CNAR        IFEQ      'CMX'                                        211629
     C                   MOVEL     'NONREF'      AZF617                         211629
     C                   ELSE                                                   211629
     C                   MOVEL     I_CNAR        AZF617                         211629
     C                   ENDIF                                                  211629
     C*****I_PNAR********IFEQ      'CMX'                                        211629
     C*******************MOVEL     'NONREF'      AZF617                         211629
     C*******************ELSE                                                   211629
     C*******************MOVEL     I_PNAR        AZF617                         211629
     C*******************ENDIF                                                  211629
      * MT94X Field 61 - 9
      * If top a/c use external a/c name, else use parent a/c name
     C     I_CCAT        IFEQ      'T'
     C                   MOVEL     I_EXA2        AZF619
     C                   ELSE
     C                   MOVEL     I_PANM        AZF619
     C                   ENDIF
      * Other account
      * If top a/c use external a/c no, else use parent a/c no
     C     I_CCAT        IFEQ      'T'                                          211629
     C                   EVAL      W_OTHA = %subst(I_EXA1: 2 : 34)              211629
     C                   ELSE                                                   211629
     C                   MOVEL     *BLANK        W_OTHA           25            211629
     C                   MOVEL     I_PRNO        W_OTHA                         211629
     C                   ENDIF                                                  211629
     C*******************MOVEL     *BLANK        W_OTHA           25            211629
     C*****I_CCAT********IFEQ      'T'                                          211629
     C*******************EVAL      W_OTHA = %subst(I_EXA1: 2 : 34)              211629
     C*******************ELSE                                                   211629
     C*****I_PRNO********IFNE      *ZERO                                        211629
     C*******************MOVEL     I_PRNO        W_OTHA                         211629
     C*******************ELSE                                                   211629
     C*******************MOVE      I_PCUS        WrkCUS            6            211629
     C*******************MOVE      I_PACD        WrkACD            4            211629
     C*******************MOVE      I_PASN        WrkASN            2            211629
     C*******************EVAL      W_OTHA = I_PBRC + '-' + WrkCUS + '-'         211629
     C*******************                   + I_PCCY + '-' + WrkACD +           211629
     C*******************                   '-'  +  WrkASN                      211629
     C*******************ENDIF                                                  211629
     C*******************ENDIF                                                  211629
 
      * MT94X Field 86 = CMx + oth account + Customer ref + oth account name
 
     C     I_STYP        IFEQ      'Z'
     C     I_DEFZ        OREQ      'Y'                                          216421
     C                   EVAL      MT94XField86 = 'CMZ'
     C                   ELSE
     C     I_CADC        IFEQ      'C'
     C                   EVAL      MT94XField86 = 'CMT'
     C                   ELSE
     C                   EVAL      MT94XField86 = 'CMS'
     C                   ENDIF
     C                   ENDIF
     C                   CAT       '/':0         MT94XField86
     C                   CAT       W_OTHA:0      MT94XField86
     C                   IF        %Subst(AZF617 : 1 : 7) <> 'NONREF'
     C                   CAT       '/':0         MT94XField86
     C                   CAT       AZF617:0      MT94XField86
     C                   ENDIF
     C                   CAT       '/':0         MT94XField86
     C                   CAT       AZF619:0      MT94XField86
 
     C                   WRITE     GLAPZSD0
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write CHILD Entry
 
      * NOTES on GECXPD fields:
      * -----------------------
      * RECI is set to 'D' if the entry is due for deletion by RE100714.
      * Bit '7' of PRIN is set on to signify the entry has been replicated
      * up the group account hierarchy.
      * OTRF controls whether an entry is to be excluded from zero balancing
      * or sweeping. It can be excluded from a particular mode or all modes.
      * OTST stores the link ID of the account generating the entry.
      * OTTP stores the hierarchy ID of the account generating the entry.
 
      ********************************************************************
     C     WRT_CENTRY    BEGSR
 
      * Clear output entry
 
     C                   CLEAR                   O_ENTRY
      * Record ID
     C                   MOVEL     'P'           E_RECI
     C     I_TBAL        IFEQ      'Y'
     C     I_TAST        ANDNE     'Z'                                          214360
     C     I_Max_Dr_Excd OREQ      'Y'
     C                   MOVEL     'D'           E_RECI
     C                   ENDIF
 
      * Customer, currency, a/c code and a/c seq.
      * Retail a/c no.
     C     O_GCAT        IFEQ      ' '
     C     O_GCAT        OREQ      'S'
     C                   MOVEL     I_CCUS        E_CNUM
     C                   MOVEL     I_CCCY        E_CCY
     C                   MOVEL     I_CACD        E_ACOD
     C                   MOVEL     I_CASN        E_ACSQ
     C                   MOVEL     I_CRNO        E_ACNO
     C                   ELSE
     C                   MOVEL     O_RCUS        E_CNUM
     C                   MOVEL     O_RCCY        E_CCY
     C                   MOVEL     O_RACD        E_ACOD
     C                   MOVEL     O_RASN        E_ACSQ
     C                   MOVEL     O_RRNO        E_ACNO
     C                   ENDIF
      * Posting Date
     C                   Z-ADD     BJRDNB        E_PSTD
      * Value Date
     C                   Z-ADD     I_VALD        E_VALD
      * Transaction Type
     C     I_CADC        IFEQ      'C'
     C                   MOVEL     I_TYPT        E_TRAT
     C                   ELSE
     C                   MOVEL     I_TYPS        E_TRAT
     C                   ENDIF
      * Posting Narrative
     C                   MOVEL     PostNarrative E_PNAR
      * Posting Amount
     C                   Z-ADD     I_PSTA        E_PSTA
      * DR/CR indicator
     C     I_CADC        IFEQ      'C'
     C                   Z-ADD     1             E_DRCR
     C                   ELSE
     C                   Z-ADD     0             E_DRCR
     C                   ENDIF
      * Source of Posting
     C                   MOVE      'GE-CX'       E_SPOS
      * Branch
     C     O_GCAT        IFEQ      ' '
     C     O_GCAT        OREQ      'S'
     C                   MOVEL     I_CBRC        E_BRCA
     C                   ELSE
     C                   MOVEL     O_RBRC        E_BRCA
     C                   ENDIF
      * Retail indicator
      * A/c type
     C     O_GCAT        IFEQ      ' '
     C     O_GCAT        OREQ      'S'
     C                   MOVEL     'R'           E_ATYP
     C                   ELSE
     C                   MOVEL     O_RATY        E_ATYP
     C                   ENDIF
     C     E_ATYP        IFEQ      'R'
     C                   Z-ADD     1             E_RIND
     C                   ENDIF
      * Posting indicators
     C                   BITOFF    '01234567'    E_PRIN
      * Replicated
     C     I_MODE        IFNE      'I/C'
     C     I_MODE        ANDNE     'PUR'                                        212904
     C     I_CCAT        ANDNE     'T'                                          214360
     C     O_AcInGAH     ANDEQ     'Y'
     C                   BITON     '7'           E_PRIN
     C                   ENDIF
      * Profit centre
      * Account section
     C     O_GCAT        IFEQ      ' '
     C     O_GCAT        OREQ      'S'
     C                   MOVEL     I_CPRF        E_PRFC
     C                   MOVEL     I_CACS        E_ACSC
     C                   ELSE
     C                   MOVEL     O_RPRF        E_PRFC
     C                   MOVEL     O_RACS        E_ACSC
     C                   ENDIF
      * Original transaction reference
     C     I_TBAL        IFEQ      'Y'
     C     I_TAST        ANDNE     'Z'                                          214360
     C     I_TBAL        ORNE      'Y'                                          214360
     C     I_TAST        ANDEQ     'Z'                                          214360
     C     I_CBSA        OREQ      'Y'
     C     I_MODE        OREQ      'PUR'
     C                   EVAL      E_OTRF = IgnoreEveryRun
     C                   ELSE
     C     I_ZBNG        IFEQ      'G'
     C                   EVAL      E_OTRF = IgnoreThisRun
     C                   ENDIF
     C                   ENDIF
      * Original transaction sub-type
     C                   MOVEL     I_LINK        E_OTST
      * Original transaction type
     C                   MOVEL     I_HIER        E_OTTP
      * Ext.Fil Ref.ID
     C                   MOVEL     AZXRFI        E_XRFI
      * Ext.Fil Ref.No.
     C                   Z-ADD     AZXRFN        E_XRFN
      * Transaction Sub-type
     C                   MOVEL     I_LEVL        E_TRST
 
     C                   WRITE     APOSTPDF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write PARENT Extension record
      ********************************************************************
     C     WRT_PEXTSN    BEGSR
 
      * Clear output extension record
 
     C                   CLEAR                   O_EXTSN
     C                   Move      'N'           WSWPBEN           1            213569
 
      * Ext.File Ref.ID
     C                   MOVEL     I_XRFI        AZXRFI
      * Ext.File Ref.No.
     C                   MOVEL     O_XRFN        AZXRFN
      * Account branch
      * Account customer
      * Account currency
      * Account a/c code
      * Account a/c seq.
     C                   MOVEL     I_CBRC        AZABRC
     C                   MOVEL     I_CCUS        AZACUS
     C                   MOVEL     I_CCCY        AZACCY
     C                   MOVEL     I_CACD        AZAACD
     C                   MOVEL     I_CASN        AZAASN
      * Account retail no.
     C                   MOVEL     I_CRNO        AZARNO
      * A/c is source or destination
     C                   MOVEL     'S'           AZASDA
      * Contra posting amount
     C                   Z-ADD     I_PSTA        AZCAMT
     C* Deduct charges if Sweep and BEN  and no charge account                  213569
     C                   If        I_CADC <> 'C' And I_CHG3 = 'BEN'             213569
     C                             And I_CAC3 =  *blank                         213569
     C                   Sub       HChgAmt       AZCAMT                         213569
     C                   Move      'Y'           WSWPBEN                        213569
     C                   Endif                                                  213569
      * Sweep Type
     C                   MOVEL     I_STYP        AZSTYP
     C     I_DEFZ        IFEQ      'Y'                                          216421
     C                   MOVEL     'Z'           AZSTYP                         216421
     C                   ENDIF                                                  216421
      * Top/Sweep
     C     I_CADC        IFEQ      'C'
     C                   MOVEL     'T'           AZTPSW
     C                   ELSE
     C                   MOVEL     'S'           AZTPSW
     C                   ENDIF
      * Target Balance
     C                   MOVEL     I_TBAL        AZTBAL
      * Cleared Bal Sweep on Assoc Date
     C                   MOVEL     I_CBSA        AZCBSA
      * Shadow Entry
     C                   MOVEL     'N'           AZSHAD
      * Mode of Origin
     C                   MOVEL     I_MODE        AZMODO
      * Date Generated
     C                   Z-ADD     BJRDNB        AZDATG
      * Sequence Number
     C                   MOVEL     I_NASN        AZSNUM
 
      * MT94X Field 61 - 6
     C     I_STYP        IFEQ      'Z'
     C     I_DEFZ        OREQ      'Y'                                          216421
     C                   MOVEL     'NCMZ'        AZF616
     C                   ELSE
     C     I_CADC        IFEQ      'C'
     C                   MOVEL     'NCMT'        AZF616
     C                   ELSE
     C                   MOVEL     'NCMS'        AZF616
     C                   ENDIF
     C                   ENDIF
      * MT94X Field 61 - 7
     C     I_PNAR        IFEQ      'CMX'                                        211629
     C                   MOVEL     'NONREF'      AZF617                         211629
     C                   ELSE                                                   211629
     C                   MOVEL     I_PNAR        AZF617                         211629
     C                   ENDIF                                                  211629
     C*****I_CNAR********IFEQ      'CMX'                                        211629
     C*******************MOVEL     'NONREF'      AZF617                         211629
     C*******************ELSE                                                   211629
     C*******************MOVEL     I_CNAR        AZF617                         211629
     C*******************ENDIF                                                  211629
      * MT94X Field 61 - 9
     C                   MOVEL     I_CANM        AZF619
      * Other account
      * = child a/c no
     C                   MOVEL     *BLANK        W_OTHA           25
     C                   MOVEL     I_CRNO        W_OTHA
 
      * MT94X Field 86 = CMx + oth account + Customer ref + oth account name
 
     C     I_STYP        IFEQ      'Z'
     C     I_DEFZ        OREQ      'Y'                                          216421
     C                   EVAL      MT94XField86 = 'CMZ'
     C                   ELSE
     C     I_CADC        IFEQ      'C'
     C                   EVAL      MT94XField86 = 'CMT'
     C                   ELSE
     C                   EVAL      MT94XField86 = 'CMS'
     C                   ENDIF
     C                   ENDIF
     C                   CAT       '/':0         MT94XField86
     C                   CAT       W_OTHA:0      MT94XField86
     C                   IF        %Subst(AZF617 : 1 : 7) <> 'NONREF'
     C                   CAT       '/':0         MT94XField86
     C                   CAT       AZF617:0      MT94XField86
     C                   ENDIF
     C                   CAT       '/':0         MT94XField86
     C                   CAT       AZF619:0      MT94XField86
 
     C                   WRITE     GLAPZSD0
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write PARENT Entry
      * (Refer to notes at top of subroutine Write CHILD Entry).
      ********************************************************************
     C     WRT_PENTRY    BEGSR
 
      * Clear output entry
 
     C                   CLEAR                   O_ENTRY
      * Record ID
     C                   MOVEL     'P'           E_RECI
     C     I_TBAL        IFEQ      'Y'
     C     I_TAST        ANDNE     'Z'                                          214360
     C     I_Max_Dr_Excd OREQ      'Y'
     C                   MOVEL     'D'           E_RECI
     C                   ENDIF
 
      * Customer, currency, a/c code and a/c seq.
      * Retail a/c no.
     C     O_GCAT        IFEQ      ' '
     C     O_GCAT        OREQ      'S'
     C                   MOVEL     I_PCUS        E_CNUM
     C                   MOVEL     I_PCCY        E_CCY
     C                   MOVEL     I_PACD        E_ACOD
     C                   MOVEL     I_PASN        E_ACSQ
     C                   MOVEL     I_PRNO        E_ACNO
     C                   ELSE
     C                   MOVEL     O_RCUS        E_CNUM
     C                   MOVEL     O_RCCY        E_CCY
     C                   MOVEL     O_RACD        E_ACOD
     C                   MOVEL     O_RASN        E_ACSQ
     C                   MOVEL     O_RRNO        E_ACNO
     C                   ENDIF
      * Posting Date
     C                   Z-ADD     BJRDNB        E_PSTD
      * Value Date
     C                   Z-ADD     I_VALD        E_VALD
      * Transaction Type
     C     I_CADC        IFEQ      'C'
     C                   MOVEL     I_TYPS        E_TRAT
     C                   ELSE
     C                   MOVEL     I_TYPT        E_TRAT
     C                   ENDIF
      * Posting Narrative
     C                   MOVEL     PostNarrative E_PNAR
      * Posting Amount
     C                   Z-ADD     ContraAMT     E_PSTA
     C* Deduct charges if Sweep and BEN  and no charge account                  213569
     C                   If        I_CADC <> 'C' And I_CHG3 = 'BEN'             213569
     C                             And I_CAC3 =  *blank                         213569
     C                   Sub       HChgAmt       E_PSTA                         213569
     C                   Endif                                                  213569
      * DR/CR indicator
     C     I_CADC        IFEQ      'C'
     C                   Z-ADD     0             E_DRCR
     C                   ELSE
     C                   Z-ADD     1             E_DRCR
     C                   ENDIF
      * Source of Posting
     C                   MOVE      'GE-CX'       E_SPOS
      * Branch
     C     O_GCAT        IFEQ      ' '
     C     O_GCAT        OREQ      'S'
     C                   MOVEL     I_PBRC        E_BRCA
     C                   ELSE
     C                   MOVEL     O_RBRC        E_BRCA
     C                   ENDIF
      * Retail indicator
      * A/c type
     C     O_GCAT        IFEQ      ' '
     C     O_GCAT        OREQ      'S'
     C                   MOVEL     I_PATY        E_ATYP
     C                   ELSE
     C                   MOVEL     O_RATY        E_ATYP
     C                   ENDIF
     C     E_ATYP        IFEQ      'R'
     C                   Z-ADD     1             E_RIND
     C                   ENDIF
      * Posting indicators
     C                   BITOFF    '01234567'    E_PRIN
      * Replicated
     C     I_MODE        IFNE      'I/C'
     C     I_MODE        ANDNE     'PUR'                                        212904
     C     I_CCAT        ANDNE     'T'                                          214360
     C     O_AcInGAH     ANDEQ     'Y'
     C                   BITON     '7'           E_PRIN
     C                   ENDIF
      * Profit centre
      * Account section
     C     O_GCAT        IFEQ      ' '
     C     O_GCAT        OREQ      'S'
     C                   MOVEL     I_PPRF        E_PRFC
     C                   MOVEL     I_PACS        E_ACSC
     C                   ELSE
     C                   MOVEL     O_RPRF        E_PRFC
     C                   MOVEL     O_RACS        E_ACSC
     C                   ENDIF
      * Origional transaction reference
     C     I_TBAL        IFEQ      'Y'
     C     I_TAST        ANDNE     'Z'                                          214360
     C     I_Max_Dr_Excd OREQ      'Y'
     C                   EVAL      E_OTRF = IgnoreEveryRun
     C                   ENDIF
      * Original transaction sub-type
     C                   MOVEL     I_LINK        E_OTST
      * Original transaction type
     C                   MOVEL     I_HIER        E_OTTP
      * Ext.Fil Ref.ID
     C                   MOVEL     AZXRFI        E_XRFI
      * Ext.Fil Ref.No.
     C                   Z-ADD     AZXRFN        E_XRFN
      * Transaction Sub-type
     C                   MOVEL     I_LEVL        E_TRST
 
     C                   WRITE     APOSTPDF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Get Next Available Ref. No.
      ********************************************************************
     C     GET_APNA      BEGSR
 
      * Get next number
     C                   CALLB     'ZAGETAPNA'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Ext.File Ref.ID
     C                   PARM      'ZS '         I_XRFI            3
      * OUTPUTS
      * Ext.File Ref.No.
     C                   PARM      *ZERO         O_XRFN           10 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'NO NEXT NUMBER (APNA)'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Group account entry generation
      ********************************************************************
     C     GROUPAC_EG    BEGSR
 
     C                   CALLB     'RE100606'
 
      * Return code
      * Error Message
      * Option
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
     C                   PARM                    X_OPTN
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE
      * Entry To Replicate
     C                   PARM      O_ENTRY       I_RENTRY
      * Hierarchy ID
      * Hierarchy Shortname
     C                   PARM      O_RHIER       I_RHIER           9 0
     C                   PARM      O_RHISN       I_RHISN          10
      * Link ID
     C                   PARM      O_RLINK       I_RLINK           9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      O_RBRC        I_RBRC            3
     C**********         PARM      O_RCUS        I_RCUS            6 0                        CSD027
     C                   PARM      O_RCUS        I_RCUS            6                          CSD027
     C                   PARM      O_RCCY        I_RCCY            3
     C**********         PARM      O_RACD        I_RACD            4 0                        CGL029
     C                   PARM      O_RACD        I_RACD           10 0                        CGL029
     C                   PARM      O_RASN        I_RASN            2 0
      * Child A/c Category
     C                   PARM      O_RCAT        I_RCAT            1
      * Child retail no.
     C                   PARM      O_RRNO        I_RRNO           10 0
      * Source level
     C                   PARM      O_RLEVL       I_RLEVL           2 0
      * CHAINS FOR:
      * GL Account ID
      * Retail A/c No.
      * A/c Status
      * Profit Centre
      * A/c Section
      * Overdraft
      * Balance Available for I/C Overdraft
      * I/C Threshold Balance
     C                   PARM      O_GLAI        I_GLAI
     C                   PARM      O_RAN         I_RAN
     C                   PARM      O_AST         I_AST
     C                   PARM      O_PC          I_PC
     C                   PARM      O_ASC         I_ASC
     C                   PARM      O_ODFT        I_ODFT
     C                   PARM      O_BAIC        I_BAIC
     C                   PARM      O_ICTB        I_ICTB
      * Count in chain
     C                   PARM      O_CNTCH       I_CNTCH           2 0
      * Link/Unlink
     C                   PARM      *BLANK        I_LKUL            1
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN GROUP A/C ' +
     C                                      'ENTRY GENERATION'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      **Adjust*value*date (if input cycle posting to a top a/c)                 216421
      ********************************************************************
     C*****ADJ_VALD******BEGSR                                                  216421
      *******************                                                       216421
      **If*a*top*(credit) to the top a/c, value date = today             101    216421
      **If*a*sweep*(debit) from the top a/c, value date = today + offset 103    216421
      *******************                                                       216421
     C*****I_CADC********IFEQ      'C'                                          216421
     C*******************Z-ADD     BJRDNB        I_VALD                         216421
     C*******************ELSE                                                   216421
     C*******************Z-ADD     *ZERO         ZNRDYS                         216421
     C*******************MOVE      I_MVDO        ZNRDYS                         216421
     C*******************CALLB     'ZFWDT'                                      216421
     C*******************PARM      BJRDNB        ZDAYNO            5 0          216421
     C*******************PARM                    ZNRDYS            2 0          216421
     C*******************PARM      *ZERO         ZDYNBR            5 0          216421
     C*******************PARM      BJLCCY        ZCCY              3            216421
     C*******************PARM      BJSLCD        ZLOC              3            216421
     C*******************Z-ADD     ZDYNBR        I_VALD                         216421
     C*******************ENDIF                                                  216421
      *******************                                                       216421
     C*******************ENDSR                                                  216421
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Check for posting block
      ********************************************************************
     C     CHK4BLOCK     BEGSR
 
     C                   EVAL      I_EXCP = 'ENTRY NOT POSTED.'
 
      **If*input*cycle*sweeping*on*the*top*account                              213196
      * If sweeping on the top account                                          213196
      * or zero balancing on the top account in input cycle                     216421
      * and there is an unmatched 101 on this link
      *    Write to the cash management exception file
      *    and ignore the posting
 
     C*****I_MODE********IFEQ******'I/C'                                        213196
     C     I_STYP        IFEQ      'S'                                          213196
     C     I_CCAT        ANDEQ     'T'
     C     I_STYP        OREQ      'Z'                                          216421
     C     I_CCAT        ANDEQ     'T'                                          216421
     C     I_MODE        ANDEQ     'I/C'                                        216421
     C     I_HIER        CHAIN     REICSDL6                           99
     C     *IN99         IFEQ      '0'
     C                   EVAL      I_REAS = 'AN UNMATCHED 101 EXISTS.'
     C                   EXSR      SET_ZSEN
     C                   EXSR      WRT_CMX
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      * If level of posting generation is just below top a/c (i.e. level 1)
      * and the posting is a top
      *    If ultimate debit to top a/c will cause its balance to be below
      *    its overdraft limit
      *      Write to the cash management exception file
      *      and ignore the posting
 
     C     I_LEVL        IFEQ      1
     C     I_CADC        ANDEQ     'C'
     C     I_TopBalance  ADD       I_PSTA        W_TopBalance     15 0
     C     W_TopBalance  IFGT      I_TopOverDft
     C                   EVAL      I_REAS = 'NO COVER ON TOP ACCOUNT.'
     C                   EXSR      SET_ZSEN
     C                   EXSR      WRT_CMX
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      * If floor limit for top > posting amount and posting is a top,
      *    Write to the cash management exception file
      *    and ignore the posting
 
     C     I_FLFT        IFGT      I_PSTA
     C     I_CADC        ANDEQ     'C'
     C                   EVAL      I_REAS = 'FLOOR LIMIT FOR TOP EXCEEDED.'
     C                   EXSR      SET_ZSEN
     C                   EXSR      WRT_CMX
     C                   RETURN
     C                   ENDIF
 
      * If floor limit for sweep > posting amount and posting is a sweep,
      *    Write to the cash management exception file
      *    and ignore the posting
 
     C     I_FLFS        IFGT      I_PSTA
     C     I_CADC        ANDEQ     'D'
     C                   EVAL      I_REAS = 'FLOOR LIMIT FOR SWEEP EXCEEDED.'
     C                   EXSR      SET_ZSEN
     C                   EXSR      WRT_CMX
     C                   RETURN
     C                   ENDIF
      * Child a/c
     C                   MOVEL     I_ChildSTAT   AccountSTAT
 
      * If block debits on the child account and this is a debit
      *    Write to the cash management exception file
      *    and ignore the posting
 
     C     BlockDR       IFEQ      'Y'
     C     I_CADC        ANDEQ     'D'
     C                   EVAL      I_REAS = 'CHILD ACCOUNT HAS BLOCK DEBITS.'
     C                   EXSR      SET_ZSEN
     C                   EXSR      WRT_CMX
     C                   RETURN
     C                   ENDIF
 
      * If block credits on the child account and this is a credit
      *    Write to the cash management exception file
      *    and ignore the posting
 
     C     BlockCR       IFEQ      'Y'
     C     I_CADC        ANDEQ     'C'
     C                   EVAL      I_REAS = 'CHILD ACCOUNT HAS BLOCK CREDITS.'
     C                   EXSR      SET_ZSEN
     C                   EXSR      WRT_CMX
     C                   RETURN
     C                   ENDIF
      * Parent a/c
     C                   MOVEL     I_ParentSTAT  AccountSTAT
 
      * If block debits on the parent account and this is a debit
      *    Write to the cash management exception file
      *    and ignore the posting
 
     C     BlockDR       IFEQ      'Y'
     C     I_CADC        ANDEQ     'C'
     C                   EVAL      I_REAS = 'PARENT ACCOUNT HAS BLOCK DEBITS.'
     C                   EXSR      SET_ZSEN
     C                   EXSR      WRT_CMX
     C                   RETURN
     C                   ENDIF
 
      * If block credits on the parent account and this is a credit
      *    Write to the cash management exception file
      *    and ignore the posting
 
     C     BlockCR       IFEQ      'Y'
     C     I_CADC        ANDEQ     'D'
     C                   EVAL      I_REAS = 'PARENT ACCOUNT HAS BLOCK CREDITS.'
     C                   EXSR      SET_ZSEN
     C                   EXSR      WRT_CMX
     C                   RETURN
     C                   ENDIF
                                                                                213196
      * Check if today is a working day in the account currency                 213196
                                                                                213196
     C                   Exsr      Det_WrkDay                                   213196
                                                                                213196
      * If today is NOT a working day in the account currency                   213196
      * Determine if a holiday exception has occurred                           213196
                                                                                213196
     C                   If        Ac_Ccy_WrkDay = 'N'                          213196
     C                   MOVEL     'N'           Holiday_Exc       1            213196
      * If EXCLUDE holidays,                                                    213196
      * An exception occurs for all top/sweeps & zero balancing in i/p cycle    213196
     C     I_SHOC        IFEQ      'E'                                          213196
     C     I_STYP        IFEQ      'S'                                          213196
     C     I_STYP        OREQ      'Z'                                          213196
     C     I_MODE        ANDEQ     'I/C'                                        213196
     C     I_STYP        OREQ      'Z'                                          213196
     C     I_CCAT        ANDEQ     'T'                                          213196
     C     I_TBAL        ANDEQ     'Y'                                          213196
     C                   MOVEL     'Y'           Holiday_Exc                    213196
     C                   ENDIF                                                  213196
     C                   ELSE                                                   213196
      * If INCLUDE holidays, and if a 101 is about to be generated              213196
      * An exception occurs for all top/sweeps & zero balancing in i/p cycle    213196
     C     I_CCAT        IFEQ      'T'                                          213196
     C     I_CADC        ANDEQ     'C'                                          213196
     C     I_STYP        IFEQ      'S'                                          213196
     C     I_STYP        OREQ      'Z'                                          213196
     C     I_MODE        ANDEQ     'I/C'                                        213196
     C                   MOVEL     'Y'           Holiday_Exc                    213196
     C                   ENDIF                                                  213196
     C                   ENDIF                                                  213196
     C                   ENDIF                                                  213196
                                                                                213196
      * If a holiday exception has occurred                                     213196
      *    Write to the cash management exception file                          213196
      *    and ignore the posting                                               213196
                                                                                213196
     C     Holiday_Exc   IFEQ      'Y'                                          213196
     C                   EVAL      I_REAS = 'HOLIDAY IN ACCOUNT CURRENCY.'      213196
     C                   EXSR      SET_ZSEN                                     213196
     C                   EXSR      WRT_CMX                                      213196
     C                   RETURN                                                 213196
     C                   ENDIF                                                  213196
     C                   ENDIF                                                  213196
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Check for posting referral
      ********************************************************************
     C     CHK4REFER     BEGSR
 
     C                   EVAL      I_EXCP = 'ENTRY POSTED BUT REFERRAL NEEDED.'
      * Child a/c
     C                   MOVEL     I_ChildSTAT   AccountSTAT
 
      * If refer debits on the child account and this is a debit
      *    Write to the cash management exception file
 
     C     ReferDR       IFEQ      'Y'
     C     I_CADC        ANDEQ     'D'
     C                   EVAL      I_REAS = 'CHILD ACCOUNT HAS REFER DEBITS.'
     C                   EXSR      SET_ZSEN
     C                   EXSR      WRT_CMX
     C                   ENDIF
 
      * If refer credits on the child account and this is a credit
      *    Write to the cash management exception file
 
     C     ReferCR       IFEQ      'Y'
     C     I_CADC        ANDEQ     'C'
     C                   EVAL      I_REAS = 'CHILD ACCOUNT HAS REFER CREDITS.'
     C                   EXSR      SET_ZSEN
     C                   EXSR      WRT_CMX
     C                   ENDIF
      * Parent a/c
     C                   MOVEL     I_ParentSTAT  AccountSTAT
 
      * If refer debits on the parent account and this is a debit
      *    Write to the cash management exception file
 
     C     ReferDR       IFEQ      'Y'
     C     I_CADC        ANDEQ     'C'
     C                   EVAL      I_REAS = 'PARENT ACCOUNT HAS REFER DEBITS.'
     C                   EXSR      SET_ZSEN
     C                   EXSR      WRT_CMX
     C                   ENDIF
 
      * If refer credits on the parent account and this is a credit
      *    Write to the cash management exception file
 
     C     ReferCR       IFEQ      'Y'
     C     I_CADC        ANDEQ     'D'
     C                   EVAL      I_REAS = 'PARENT ACCOUNT HAS REFER CREDITS.'
     C                   EXSR      SET_ZSEN
     C                   EXSR      WRT_CMX
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Set zero balancing/sweeping entry details
      ********************************************************************
     C     SET_ZSEN      BEGSR
 
      * Edit value date of entry
 
     C                   Z-ADD     I_VALD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_VALD
 
      * Edit posting amount of entry
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      I_PSTA        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_PSTA
 
      * Exception entry details
 
     C                   EVAL      I_ZSEN = R_VALD + ' ' + R_PSTA
     C                                      + '  ' + I_CADC + '   ' + I_SDES
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write to the cash management exception file
      ********************************************************************
     C     WRT_CMX       BEGSR
 
     C                   CALLB     'REWRTCMX'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Hierarchy ID
      * Hierarchy Shortname
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HISN           10
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Exception
      * Reason
     C                   PARM                    I_EXCP           60
     C                   PARM                    I_REAS           60
      * Zero Balancing/Sweeping Entry
      * Original Entry
     C                   PARM                    I_ZSEN           60
     C                   PARM      *BLANK        I_OREN          330
      * Mode
      * Time
     C                   PARM                    I_MODE            3
     C                   PARM                    I_TIME            6
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN WRITE TO RECMEXPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Report source a/c
      ********************************************************************
     C     REP_SACCNT    BEGSR
 
      * Show retail a/c numbers
 
     C     I_CRNO        COMP      0                                  3535      *
 
     C                   Z-ADD     4             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     SOURCE
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Report entry
      ********************************************************************
     C     REP_ENTRY     BEGSR
 
      * Space
     C     C             IFEQ      1
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     SPACE
     C                   ENDIF
                                                                                212367
      * Show retail a/c numbers                                                 212367
     C     E_ACNO        COMP      0                                  3636      212367
 
      * Edit value date of entry
 
     C                   Z-ADD     E_VALD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_VALD
 
      * Edit posting amount of entry
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      E_PSTA        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_PSTA
 
      * Edit posting dr/cr indicator
 
     C     E_DRCR        IFEQ      0
     C                   MOVEL     'DR'          R_DRCR
     C                   ELSE
     C                   MOVEL     'CR'          R_DRCR
     C                   ENDIF
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     ENTRY
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * End of Report
      ********************************************************************
     C     END_OF_REP    BEGSR
 
      * Output 'end of report'
 
     C                   Z-ADD     3             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ENDOFREP
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
      * Set time
     C                   TIME                    R_TIME
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   WRITE     PAGEHEAD
     C     6             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Access a currency
      ********************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'ZAACSCURR'
     C                   PARM                    CCY               3
     C                   PARM                    SDCURR
 
      * Database error if currency not found
 
     C     A6CYCD        IFEQ      *BLANK
     C                   EVAL      X_ERMS = 'BAD CCY CODE:' + CCY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a day number into a date
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      'M'           ZDFIN             1
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Edit an amount
      ********************************************************************
     C     ZEDIT         BEGSR
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Determine posting narrative
      ********************************************************************
     C     DET_PNAR      BEGSR
 
     C     AcType        IFEQ      'CHILD '                                     211629
     C                   MOVEL     I_CNAR        PostNarrative    30            211629
     C     I_CCAT        IFEQ      'T'                                          211629
     C                   EVAL      W_OTHA = %subst(I_EXA1: 2 : 34)              211629
     C                   ELSE                                                   211629
     C                   MOVEL     *BLANK        W_OTHA                         211629
     C                   MOVEL     I_PRNO        W_OTHA                         211629
     C                   ENDIF                                                  211629
     C                   ELSE                                                   211629
     C     I_CCAT        IFEQ      'T'                                          213572
     C                   MOVEL     *BLANK        PostNarrative                  213572
     C                   MOVEL     'CMX'         PostNarrative                  213572
     C                   ELSE                                                   213572
     C                   MOVEL     I_PNAR        PostNarrative                  211629
     C                   ENDIF                                                  213572
     C                   MOVEL     *BLANK        W_OTHA                         211629
     C                   MOVEL     I_CRNO        W_OTHA                         211629
     C                   ENDIF                                                  211629
                                                                                211629
     C     PostNarrative IFEQ      'CMX         '                               211629
     C     I_STYP        IFEQ      'Z'                                          211629
     C     I_DEFZ        OREQ      'Y'                                          216421
     C                   EVAL      PostNarrative = 'CMZ ' + W_OTHA              211629
     C                   ELSE                                                   211629
     C     I_CADC        IFEQ      'C'                                          211629
     C                   EVAL      PostNarrative = 'CMT ' + W_OTHA              211629
     C                   ELSE                                                   211629
     C                   EVAL      PostNarrative = 'CMS ' + W_OTHA              211629
     C                   ENDIF                                                  211629
     C                   ENDIF                                                  211629
     C                   ENDIF                                                  211629
     C*****AcType********IFEQ      'CHILD '                                     211629
     C*******************MOVEL     I_PRNO        RetailACNO       10            211629
     C*******************MOVEL     I_PNAR        PostNarrative    30            211629
     C*******************ELSE                                                   211629
     C*******************MOVEL     I_CRNO        RetailACNO                     211629
     C*******************MOVEL     I_CNAR        PostNarrative                  211629
     C*******************ENDIF                                                  211629
      *******************                                                       211629
     C*****PostNarrative IFEQ      'CMX         '                               211629
     C*****PostNarrative OREQ      *BLANK                                       211629
     C*****I_STYP********IFEQ      'Z'                                          211629
     C*******************EVAL      PostNarrative = 'CMZ ' + RetailACNO          211629
     C*******************ELSE                                                   211629
     C*****I_CADC********IFEQ      'C'                                          211629
     C*******************EVAL      PostNarrative = 'CMT ' + RetailACNO          211629
     C*******************ELSE                                                   211629
     C*******************EVAL      PostNarrative = 'CMS ' + RetailACNO          211629
     C*******************ENDIF                                                  211629
     C*******************ENDIF                                                  211629
     C*******************ENDIF                                                  211629
      * Association
     C     I_MODE        IFEQ      'ASC'
     C                   MOVE      'ASC'         PostNarrative
     C                   ENDIF
      * Target Balance                                                          214360
     C     I_TBAL        IFEQ      'Y'                                          214360
     C                   MOVE      'TAR'         PostNarrative                  214360
     C                   ENDIF                                                  214360
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Posting Amount into Contra Amount
      ********************************************************************
     C     CONVERT       BEGSR
 
     C                   Z-ADD     I_PSTA        ContraAMT        13 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Write to input cycle zero balancing/sweeping files
      ********************************************************************
     C     WRT_ICS       BEGSR
                                                                                216421
     C                   MOVEL     I_STYP        I_STYP_ICS                     216421
     C     I_DEFZ        IFEQ      'Y'                                          216421
     C                   MOVEL     'Z'           I_STYP_ICS                     216421
     C                   ENDIF                                                  216421
 
     C                   CALLB     'REWRTICS'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Hierarchy ID
      * Hierarchy Shortname
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HISN           10
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM                    I_CBRC            3
     C**********         PARM                    I_CCUS            6 0                        CSD027
     C                   PARM                    I_CCUS            6                          CSD027
     C                   PARM                    I_CCCY            3
     C**********         PARM                    I_CACD            4 0                        CGL029
     C                   PARM                    I_CACD           10 0                        CGL029
     C                   PARM                    I_CASN            2 0
      * Child A/c Category
     C                   PARM                    I_CCAT            1
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    I_PBRC            3
     C**********         PARM                    I_PCUS            6 0                        CSD027
     C                   PARM                    I_PCUS            6                          CSD027
     C                   PARM                    I_PCCY            3
     C**********         PARM                    I_PACD            4 0                        CGL029
     C                   PARM                    I_PACD           10 0                        CGL029
     C                   PARM                    I_PASN            2 0
      * Child Account Narrative
      * Parent Account Narrative
     C                   PARM                    I_CNAR           30
     C                   PARM                    I_PNAR           30
      * Destination
      * Destination Type
      * Sender's Correspondent
      * Receiver's Correspondent
      * MT202 Cover Message Required
      * MT103 Value Date Offset
     C                   PARM                    I_DEST           18
     C                   PARM                    I_DSTT            1
     C                   PARM                    I_SNDC            2
     C                   PARM                    I_RCVC           11
     C                   PARM                    I_MCMR            1
     C                   PARM                    I_MVDO            1
      * MT101 Charges
      * MT101 Charges Account
      * MT101 Charges Amount
      * MT101 Instruction Code
      * MT103 Charges
      * MT103 Charges Account
      * MT103 Charges Amount
      * MT103 Instruction Code
      * MT103 Bank Operation Code
     C                   PARM                    I_CHG1            3
     C**********         PARM                    I_CAC1           18                          CGL029
     C                   PARM                    I_CAC1           24                          CGL029
     C                   PARM                    I_CAM1           15 0
     C                   PARM                    I_ICD1            4
     C                   PARM                    I_CHG3            3
     C**********         PARM                    I_CAC3           18                          CGL029
     C                   PARM                    I_CAC3           24                          CGL029
     C                   PARM                    I_CAM3           15 0
     C                   PARM                    I_ICD3            4
     C                   PARM                    I_BOCD            4
      * External Account 1
      * External Account 2
      * External Account 3
      * External Account 4
      * External Account 5
     C                   PARM                    I_EXA1           35
     C                   PARM                    I_EXA2           35
     C                   PARM                    I_EXA3           35
     C                   PARM                    I_EXA4           35
     C                   PARM                    I_EXA5           35
      * Shadow Posted
     C                   PARM      ShadowPost    I_SPTD            1
      * Incoming Msg SWIFT Reference
     C                   PARM      *Blank        I_SMSR           16
     C                   PARM      *Blank        I_SMIR           28
      * Incoming Msg Sender and Amount
     C                   PARM      *Blank        I_SNDR           11
     C                   PARM      0             I_SAMT           15 0
      * Reply MT103 Reference
      * Reply MT103 Amount
      * Reply MT103 Action
     C                   PARM      *Blank        I_R3RF           16
     C                   PARM      0             I_R3AM           15 0
     C                   PARM      *blank        I_R3AC            7
      * Next Available Seq No.
     C                   PARM                    I_NASN            2 0
      * Posting amount
      * Child A/c Debit/Credit ind
      * Value date
      * Sweep Description
      * Sweep Type     (Z or S)
     C                   PARM                    I_PSTA           13 0
     C                   PARM                    I_CADC            1
     C                   PARM                    I_VALD            5 0
     C                   PARM                    I_SDES           30
     C                   PARM                    I_STYP_ICS        1            216421
     C*******************PARM                    I_STYP            1            216421
 
      * Extension Reference Numbers
     C                   PARM                    I_XRFN
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN WRITE TO REICSDPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Shadow post entry
      ********************************************************************
     C     SHP_ENTRY     BEGSR
 
     C                   CALLB     'RE100605'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Entry
     C                   PARM                    O_ENTRY
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN SHADOW POST ENTRY'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Register P1 printer file with RCF
      ********************************************************************
     C     RCFP1         BEGSR
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5                                                                  213569
      ********************************************************************      213569
      * Generate Charges                                                        213569
      ********************************************************************      213569
     C     GEN_CHARGES   BEGSR                                                  213569
                                                                                213569
      * Get Next Available Ref. No.                                             213569
                                                                                213569
     C                   EXSR      GET_APNA                                     213569
                                                                                213569
      * Write CREDIT Charge extension record                                    213569
      * Write CREDIT Charge entry                                               213569
                                                                                213569
     C                   Exsr      WRT_CrChEXTSN                                213569
     C                   Exsr      WRT_CrChENTRY                                213569
                                                                                213569
     C                   ADD       1             C                              213569
     C                   MOVEL     O_XRFN        I_XRFN(C)                      213569
                                                                                213569
      * Report entry                                                            213569
                                                                                213569
     C                   EXSR      REP_ENTRY                                    213569
                                                                                213569
     C*  Do not do debit charging if Sweeping  and BEN as the charge amount     213569
     C*  would have been deducted already from the nostro.                      213569
                                                                                213569
     C                   If        WSWPBEN  = 'Y'                               213569
     C                   Goto      EndGENCHG                                    213569
     C                   Endif                                                  213569
                                                                                213569
      * Determine if DEBIT charge a/c posting is to a group a/c hierarchy       213569
                                                                                213569
     C                   MOVEL     @DrChBRCA     I_BRC                          213569
     C                   MOVEL     @DrChCNUM     I_CUS                          213569
     C                   MOVEL     @DrChCCY      I_CCY                          213569
     C                   MOVEL     @DrChACOD     I_ACD                          213569
     C                   MOVEL     @DrChACSQ     I_ASN                          213569
     C                   MOVEL     @DrChACNO     I_RNO                          213569
     C                   MOVEL     @DrChPRFC     I_PRF                          213569
     C                   MOVEL     @DrChACSC     I_ACS                          213569
     C                   MOVEL     @DrChATYP     I_ATY                          213569
     C                   EXSR      DET_POSTGAH                                  213569
                                                                                213569
      * Get Next Available Ref. No.                                             213569
                                                                                213569
     C                   EXSR      GET_APNA                                     213569
                                                                                213569
     C                   EVAL      AcType = 'CHARGE'                            213569
     C                   EVAL      PostNarrative = 'Trf Charges T/S/ZB'         213569
     C/COPY WNCPYSRC,RE100608C1                                                 213569
                                                                                213569
      * Write DEBIT Charge extension record                                     213569
      * Write DEBIT Charge entry                                                213569
                                                                                213569
     C                   Exsr      WRT_DrChEXTSN                                213569
     C                   Exsr      WRT_DrChENTRY                                213569
                                                                                213569
     C                   ADD       1             C                              213569
     C                   MOVEL     O_XRFN        I_XRFN(C)                      213569
                                                                                213569
      * Shadow post entry in input cycle                                        213569
                                                                                213569
     C     I_MODE        IFEQ      'I/C'                                        213569
     C     ShadowPost    ANDEQ     'Y'                                          213569
     C                   EXSR      SHP_ENTRY                                    213569
     C                   Endif                                                  213569
                                                                                213569
      * If posting to a group a/c hierachy a/c in COB                           213569
      *  Do group account entry generation (up the hierarchy)                   213569
                                                                                213569
     C     I_MODE        IFNE      'I/C'                                        213569
     C     I_MODE        ANDNE     'PUR'                                        212904
     C     I_CCAT        ANDNE     'T'                                          213569
     C     O_AcInGAH     ANDEQ     'Y'                                          213569
     C                   EXSR      GROUPAC_EG                                   213569
     C                   ENDIF                                                  213569
                                                                                213569
      * Report entry                                                            213569
                                                                                213569
     C                   EXSR      REP_ENTRY                                    213569
                                                                                213569
     C     ENDGENCHG     ENDSR                                                  213569
     C********************************************************************      213569
      /SPACE 5                                                                  213569
      ********************************************************************      213569
      * Determine Credit Charge Account (Charge Income Account)                 213569
      ********************************************************************      213569
     C     DET_CRChAcct  BEGSR                                                  213569
                                                                                213569
      * Branch is debit charge account branch                                   213569
     C     O_GCAT        IFEQ      ' '                                          213569
     C     O_GCAT        OREQ      'S'                                          213569
     C                   MOVEL     @DrChBRCA     @CrChBRCA                      213569
     C                   ELSE                                                   213569
     C                   MOVEL     O_RBRC        @CrChBRCA                      213569
     C                   ENDIF                                                  213569
                                                                                213569
      * Access branch details                                                   213569
     C                   CALLB     'ZAACSBRCH'                                  213569
     C                   PARM      @CrChBRCA     PBRCA             3            213569
     C                   PARM                    SDBRCH                         213569
      * Error                                                                   213569
     C                   IF        A8BRCD = *blank                              213569
     C                   EVAL      X_ERMS = 'BAD HIERARCHY BRANCH ' +           213569
     C                                      ' CODE ' + PBRCA                    213569
     C                   EXSR      *PSSR                                        213569
     C                   Endif                                                  213569
                                                                                213569
      * Customer is Branch Internal Customer Number                             213569
     C                   Movel     A8BICN        @CrChCNUM                      213569
      * Currency is debit charge currency                                       213569
     C                   Movel     @DrChCCY      @CrChCCY                       213569
      * Account code is from ICD                                                213569
     C                   Movel     CMCHAC        @CrChACOD                      213569
      * Account sequence is always 01                                           213569
     C                   z-add     1             @CrChACSQ                      213569
                                                                                213569
      * Retail account number                                                   213569
      * Profit centre                                                           213569
     C                   z-add     0             @CrChACNO                      213569
     C                   Movel     CMCHPC        @CrChPRFC                      213569
                                                                                213569
      * Access account code details                                             213569
     C                   MOVEL     @CrChACOD     X_ACCD                         213569
     C                   CALLB     'ZAACSACOD'                                  213569
     C**********         PARM                    X_ACCD            4                   213569 CGL029
     C                   PARM                    X_ACCD           10                          CGL029
     C                   PARM                    SDACOD                         213569
      * Error                                                                   213569
     C                   IF        A5ACCD = *blank                              213569
     C                   EVAL      X_ERMS = 'BAD CHARGE INCOME ACCOUNT' +       213569
     C                                      ' CODE ' + X_ACCD                   213569
     C                   EXSR      *PSSR                                        213569
     C                   Endif                                                  213569
      * Account section                                                         213569
      * Account type                                                            213569
     C                   MOVEL     A5ACSC        @CrChACSC                      213569
     C                   MOVEL     A5ACTY        @CrChATYP                      213569
                                                                                213569
     C                   ENDSR                                                  213569
      ********************************************************************      213569
      /SPACE 5                                                                  213569
      ********************************************************************      213569
      * Determine Debit Charge Account                                          213569
      ********************************************************************      213569
     C     DET_DRChAcct  BEGSR                                                  213569
                                                                                213569
      * For TOPS, Debit Charge Account is set to:                               213569
      *  MT101 Charge Account, if defined, else                                 213569
      *  Top Account                                                            213569
     C                   If        I_CADC = 'C'                                 213569
     C                   If        I_CAC1 <> *Blank                             213569
     C                   Eval      @DrChAcct = I_CAC1                           213569
     C                   Else                                                   213569
     C                   Eval      @DrChBRCA = I_CBRC                           213569
     C                   Eval      @DrChCNUM = I_CCUS                           213569
     C                   Eval      @DrChCCY  = I_CCCY                           213569
     C                   Eval      @DrChACOD = I_CACD                           213569
     C                   Eval      @DrChACSQ = I_CASN                           213569
     C                   Endif                                                  213569
     C                   Endif                                                  213569
                                                                                213569
      * For SWEEPS, Debit Charge Account is set to:                             213569
      *  If OUR and MT103 Charge Account is present, MT103 Charge Account       213569
      *  If OUR and MT103 Charge Account is not present, Top Account            213569
      *  If SHA and MT103 Charge Account is present, MT103 Charge Account       213569
      *  If SHA and MT103 Charge Account is not present, Top Account            213569
      *  If BEN and MT103 Charge Account is present, MT103 Charge Account       213569
      *  If BEN and MT103 Charge Account is not present, Destination account    213569
                                                                                213569
     C                   If        I_CADC <> 'C'                                213569
     C                   SELECT                                                 213569
     C                   When      I_CAC3 <> *Blank                             213569
     C                   Eval      @DrChAcct = I_CAC3                           213569
     C                   When      I_CHG3 = 'OUR' OR                            213569
     C                             I_CHG3 = 'SHA'                               213569
     C                   Eval      @DrChBRCA = I_CBRC                           213569
     C                   Eval      @DrChCNUM = I_CCUS                           213569
     C                   Eval      @DrChCCY  = I_CCCY                           213569
     C                   Eval      @DrChACOD = I_CACD                           213569
     C                   Eval      @DrChACSQ = I_CASN                           213569
     C                   When      I_CHG3 = 'BEN'                               213569
     C                   Eval      @DrChBRCA = I_PBRC                           213569
     C                   Eval      @DrChCNUM = I_PCUS                           213569
     C                   Eval      @DrChCCY  = I_PCCY                           213569
     C                   Eval      @DrChACOD = I_PACD                           213569
     C                   Eval      @DrChACSQ = I_PASN                           213569
     C                   Endsl                                                  213569
     C                   Endif                                                  213569
                                                                                213569
      * Access debit charge account                                             213569
                                                                                213569
     C     KChgaccnt     Chain     ACCNTABF                           60        213569
     C                   IF        *IN60 = *ON  Or A_RECI <> 'D'                213569
     C                   EVAL      X_ERMS = 'INVALID DEBIT CHARGE ACCOUNT:'     213569
     C                                      + @DrChAcct                         213569
     C                   EXSR      *PSSR                                        213569
     C                   Endif                                                  213569
                                                                                213569
      * Retail account number                                                   213569
      * Profit centre                                                           213569
     C                   z-add     A_ACNO        @DrChACNO                      213569
     C                   Movel     A_PRFC        @DrChPRFC                      213569
                                                                                213569
      * Access account code details                                             213569
     C                   MOVEL     @DrChACOD     X_ACCD                         213569
     C                   CALLB     'ZAACSACOD'                                  213569
     C**********         PARM                    X_ACCD            4                   213569 CGL029
     C                   PARM                    X_ACCD                                       CGL029
     C                   PARM                    SDACOD                         213569
      * Error                                                                   213569
     C                   IF        A5ACCD = *blank                              213569
     C                   EVAL      X_ERMS = 'BAD DEBIT CHARGE ACCOUNT' +        213569
     C                                      ' CODE ' + X_ACCD                   213569
     C                   EXSR      *PSSR                                        213569
     C                   Endif                                                  213569
      * Account section                                                         213569
      * Account type                                                            213569
     C                   MOVEL     A5ACSC        @DrChACSC                      213569
     C                   MOVEL     A5ACTY        @DrChATYP                      213569
                                                                                213569
     C                   ENDSR                                                  213569
      ********************************************************************      213569
      * Get Charges Details                                                     213569
      ********************************************************************      213569
     C     GET_ChgDet    BEGSR                                                  213569
      *                                                                         213569
      * Determine DEBIT Charge Account                                          213569
     C                   Exsr      DET_DRChAcct                                 213569
                                                                                213569
      * Determine CREDIT Charge Account (Charge Income Account)                 213569
     C                   Exsr      DET_CRChAcct                                 213569
                                                                                213569
      * Now, determine Charge Amount in Charge Account Currency                 213569
     C                   If        I_CADC = 'C'                                 213569
     C                   Z-ADD     I_CAM1        CChgAmt          13 0          213569
     C                   Else                                                   213569
     C                   Z-ADD     I_CAM3        CChgAmt                        213569
     C                   Endif                                                  213569
     C                                                                          213569
     C                   Z-ADD     CChgAmt       HChgAmt          13 0          213569
     C                                                                          213569
      * Convert charge amount to hierarchy currency if necessary.               213569
      * (This happens when the MT101/3 Charge account is defined and it         213569
      * is in a different currency than that of the hierarchy's)                213569
     C                   If        @DrChCcy <> I_CCCY                           213569
     C                   CLEAR                   P#0010                         213569
     C                   MOVEL     @DrChCcy      P#FRCY                         213569
     C                   Z-ADD     CChgAmt       P#FRAM                         213569
     C                   MOVEL     I_CCCY        P#TOCY                         213569
                                                                                213569
     C                   CALL      'FT0010'                                     213569
     C                   PARM                    P#0010                         213569
                                                                                213569
     C                   If        P#RTCD <> *blanks                            213569
     C                   EVAL      X_ERMS = 'ERROR IN CALLING FT0010 '          213569
     C                   EXSR      *PSSR                                        213569
     C                   Else                                                   213569
     C                   Z-add     P#TOAM        HChgAmt                        213569
     C                   ENDIF                                                  213569
                                                                                213569
     C                   ENDIF                                                  213569
                                                                                213569
     C                   ENDSR                                                  213569
      ********************************************************************      213569
      /SPACE 5                                                                  213569
      ********************************************************************      213569
      * Write CREDIT charge extension record                                    213569
      ********************************************************************      213569
     C     WRT_CrChEXTSN Begsr                                                  213569
                                                                                213569
      * Clear output extension record                                           213569
     C                   CLEAR                   O_EXTSN                        213569
      * Ext.File Ref.ID                                                         213569
     C                   MOVEL     I_XRFI        AZXRFI                         213569
      * Ext.File Ref.No.                                                        213569
     C                   MOVEL     O_XRFN        AZXRFN                         213569
      * Credit Account is Charge Income                                         213569
     C                   MOVEL     @CrChBRCA     AZABRC                         213569
     C                   MOVEL     @CrChCNUM     AZACUS                         213569
     C                   MOVEL     @CrChCCY      AZACCY                         213569
     C                   MOVEL     @CrChACOD     AZAACD                         213569
     C                   MOVEL     @CrChACSQ     AZAASN                         213569
      * Account retail no.                                                      213569
     C                   MOVEL     @CrChACNO     AZARNO                         213569
      * A/c is source or destination                                            213569
     C                   MOVEL     *Blank        AZASDA                         213569
      * Contra posting amount                                                   213569
     C                   Z-ADD     CChgAmt       AZCAMT                         213569
      * Sweep Type                                                              213569
     C                   MOVEL     I_STYP        AZSTYP                         213569
     C     I_DEFZ        IFEQ      'Y'                                          216421
     C                   MOVEL     'Z'           AZSTYP                         216421
     C                   ENDIF                                                  216421
      * Top/Sweep                                                               213569
     C                   MOVEL     *Blank        AZTPSW                         213569
      * Target Balance                                                          213569
     C                   MOVEL     'N'           AZTBAL                         213569
      * Cleared Bal Sweep on Assoc Date                                         213569
     C                   MOVEL     'N'           AZCBSA                         213569
      * Shadow Entry                                                            213569
     C                   MOVEL     'N'           AZSHAD                         213569
      * Mode of Origin                                                          213569
     C                   MOVEL     I_MODE        AZMODO                         213569
      * Date Generated                                                          213569
     C                   Z-ADD     BJRDNB        AZDATG                         213569
      * Sequence Number                                                         213569
     C                   Z-Add     I_NASN        AZSNUM                         213569
      * MT94X Field 61 - 6                                                      213569
     C                   Eval      AZF616 = *blank                              213569
      * MT94X Field 61 - 7                                                      213569
     C                   Eval      AZF617 = *blank                              213569
      * MT94X Field 61 - 8                                                      213569
     C                   Eval      AZF618 = *Blank                              213569
      * MT94X Field 61 - 9                                                      213569
     C                   Eval      AZF619 = *Blank                              213569
      * MT94X Field 86 - 1                                                      213569
     C                   Eval      AZF861 = *blank                              213569
      * MT94X Field 86 - 2                                                      213569
     C                   Eval      AZF862 = *blank                              213569
      * MT94X Field 86 - 3                                                      213569
     C                   Eval      AZF863 = *blank                              213569
      * MT94X Field 86 - 4                                                      213569
     C                   Eval      AZF864 = *blank                              213569
      * MT94X Field 86 - 5                                                      213569
     C                   Eval      AZF865 = *blank                              213569
      * MT94X Field 86 - 6                                                      213569
     C                   Eval      AZF866 = *blank                              213569
                                                                                213569
     C                   WRITE     GLAPZSD0                                     213569
                                                                                213569
     C                   Endsr                                                  213569
      ********************************************************************      213569
      /SPACE 5                                                                  213569
      ********************************************************************      213569
      * Write CREDIT charge entry                                               213569
      ********************************************************************      213569
     C     WRT_CrChENTRY Begsr                                                  213569
                                                                                213569
      * Clear output entry                                                      213569
                                                                                213569
     C                   CLEAR                   O_ENTRY                        213569
      * Record ID                                                               213569
     C                   MOVEL     'P'           E_RECI                         213569
      * Credit Account                                                          213569
     C                   MOVEL     @CrChCNUM     E_CNUM                         213569
     C                   MOVEL     @CrChCCY      E_CCY                          213569
     C                   MOVEL     @CrChACOD     E_ACOD                         213569
     C                   MOVEL     @CrChACSQ     E_ACSQ                         213569
     C                   Z-add     @CrChACNO     E_ACNO                         213569
      * Posting Date                                                            213569
     C                   Z-ADD     BJRDNB        E_PSTD                         213569
      * Value Date                                                              213569
     C                   Z-ADD     BJRDNB        E_VALD                         213569
      * Transaction Type                                                        213569
     C                   MOVEL     *blanks       E_TRAT                         213569
      * Posting Narrative                                                       213569
     C                   Eval      E_PNAR = 'Trf Charges T/S/ZB'                213569
      * Posting Amount                                                          213569
     C                   Z-ADD     CChgAmt       E_PSTA                         213569
      * DR/CR indicator                                                         213569
     C                   Z-ADD     1             E_DRCR                         213569
      * Source of Posting                                                       213569
     C                   MOVE      'GE-CX'       E_SPOS                         213569
      * Branch                                                                  213569
     C                   MOVEL     @CrChBRCA     E_BRCA                         213569
                                                                                213569
      * Retail indicator                                                        213569
      * A/c type                                                                213569
     C                   Z-ADD     0             E_RIND                         213569
     C                   MOVEL     @CrChATYP     E_ATYP                         213569
      * Posting indicators                                                      213569
     C                   BITOFF    '01234567'    E_PRIN                         213569
      * Profit centre                                                           213569
      * Account section                                                         213569
     C                   MOVEL     @CrChPRFC     E_PRFC                         213569
     C                   MOVEL     @CrChACSC     E_ACSC                         213569
      * Original transaction sub-type                                           213569
     C                   MOVEL     I_LINK        E_OTST                         213569
      * Original transaction type                                               213569
     C                   MOVEL     I_HIER        E_OTTP                         213569
      * Ext.Fil Ref.ID                                                          213569
     C                   MOVEL     AZXRFI        E_XRFI                         213569
      * Ext.Fil Ref.No.                                                         213569
     C                   Z-ADD     AZXRFN        E_XRFN                         213569
      * Transaction Sub-type                                                    213569
     C                   MOVEL     I_LEVL        E_TRST                         213569
                                                                                213569
     C                   WRITE     APOSTPDF                                     213569
                                                                                213569
     C                   Endsr                                                  213569
     C********************************************************************      213569
      /SPACE 5                                                                  213569
      ********************************************************************      213569
      * Write DEBIT Charge Extension Record                                     213569
      ********************************************************************      213569
     C     WRT_DrChEXTSN BEGSR                                                  213569
                                                                                213569
      * Clear output extension record                                           213569
     C                   CLEAR                   O_EXTSN                        213569
      * Ext.File Ref.ID                                                         213569
     C                   MOVEL     I_XRFI        AZXRFI                         213569
      * Ext.File Ref.No.                                                        213569
     C                   MOVEL     O_XRFN        AZXRFN                         213569
      * Debit Account                                                           213569
     C                   MOVEL     @DrChBRCA     AZABRC                         213569
     C                   MOVEL     @DrChCNUM     AZACUS                         213569
     C                   MOVEL     @DrChCCY      AZACCY                         213569
     C                   MOVEL     @DrChACOD     AZAACD                         213569
     C                   MOVEL     @DrChACSQ     AZAASN                         213569
      * Account retail no.                                                      213569
     C                   Z-add     @DrChACNO     AZARNO                         213569
      * A/c is source or destination                                            213569
     C                   MOVEL     *Blank        AZASDA                         213569
      * Contra posting amount                                                   213569
     C                   If        @DrChCCY = I_CCCY                            213569
     C                   Z-ADD     HChgAmt       AZCAMT                         213569
     C                   Else                                                   213569
     C                   Z-ADD     CChgAmt       AZCAMT                         213569
     C                   Endif                                                  213569
      * Sweep Type                                                              213569
     C                   MOVEL     I_STYP        AZSTYP                         213569
     C     I_DEFZ        IFEQ      'Y'                                          216421
     C                   MOVEL     'Z'           AZSTYP                         216421
     C                   ENDIF                                                  216421
      * Top/Sweep                                                               213569
     C     I_CADC        IFEQ      'C'                                          213569
     C                   MOVEL     'T'           AZTPSW                         213569
     C                   ELSE                                                   213569
     C                   MOVEL     'S'           AZTPSW                         213569
     C                   ENDIF                                                  213569
      * Target Balance                                                          213569
     C                   MOVEL     'N'           AZTBAL                         213569
      * Cleared Bal Sweep on Assoc Date                                         213569
     C                   MOVEL     'N'           AZCBSA                         213569
      * Shadow Entry                                                            213569
     C                   MOVEL     'N'           AZSHAD                         213569
      * Mode of Origin                                                          213569
     C                   MOVEL     I_MODE        AZMODO                         213569
      * Date Generated                                                          213569
     C                   Z-ADD     BJRDNB        AZDATG                         213569
      * Sequence Number                                                         213569
     C                   MOVEL     I_NASN        AZSNUM                         213569
      * MT94X Field 61 - 6                                                      213569
     C                   Eval      AZF616 = *blank                              213569
      * MT94X Field 61 - 7                                                      213569
     C                   Eval      AZF617 = *blank                              213569
      * MT94X Field 61 - 8                                                      213569
     C                   Eval      AZF618 = *Blank                              213569
      * MT94X Field 61 - 9                                                      213569
     C                   Eval      AZF619 = *Blank                              213569
      * MT94X Field 86 - 1                                                      213569
     C                   Eval      AZF861 = *blank                              213569
      * MT94X Field 86 - 2                                                      213569
     C                   Eval      AZF862 = *blank                              213569
      * MT94X Field 86 - 3                                                      213569
     C                   Eval      AZF863 = *blank                              213569
      * MT94X Field 86 - 4                                                      213569
     C                   Eval      AZF864 = *blank                              213569
      * MT94X Field 86 - 5                                                      213569
     C                   Eval      AZF865 = *blank                              213569
      * MT94X Field 86 - 6                                                      213569
     C                   Eval      AZF866 = *blank                              213569
                                                                                213569
     C                   WRITE     GLAPZSD0                                     213569
                                                                                213569
     C                   Endsr                                                  213569
      ********************************************************************      213569
      /SPACE 5                                                                  213569
      ********************************************************************      213569
      * Write DEBIT Charge entry                                                213569
      ********************************************************************      213569
     C     WRT_DrChENTRY Begsr                                                  213569
                                                                                213569
      * Clear output entry                                                      213569
                                                                                213569
     C                   CLEAR                   O_ENTRY                        213569
      * Record ID                                                               213569
     C                   MOVEL     'P'           E_RECI                         213569
                                                                                213569
      * Debit Account                                                           213569
     C     O_GCAT        IFEQ      ' '                                          213569
     C     O_GCAT        OREQ      'S'                                          213569
     C                   MOVEL     @DrChCNUM     E_CNUM                         213569
     C                   MOVEL     @DrChCCY      E_CCY                          213569
     C                   MOVEL     @DrChACOD     E_ACOD                         213569
     C                   MOVEL     @DrChACSQ     E_ACSQ                         213569
     C                   Z-add     @DrChACNO     E_ACNO                         213569
     C                   ELSE                                                   213569
     C                   MOVEL     O_RCUS        E_CNUM                         213569
     C                   MOVEL     O_RCCY        E_CCY                          213569
     C                   MOVEL     O_RACD        E_ACOD                         213569
     C                   MOVEL     O_RASN        E_ACSQ                         213569
     C                   MOVEL     O_RRNO        E_ACNO                         213569
     C                   ENDIF                                                  213569
      * Posting Date                                                            213569
     C                   Z-ADD     BJRDNB        E_PSTD                         213569
      * Value Date                                                              213569
     C                   Z-ADD     I_VALD        E_VALD                         213569
      * Transaction Type                                                        213569
     C     I_CADC        IFEQ      'C'                                          213569
     C                   MOVEL     I_TYPT        E_TRAT                         213569
     C                   ELSE                                                   213569
     C                   MOVEL     I_TYPS        E_TRAT                         213569
     C                   ENDIF                                                  213569
      * Posting Narrative                                                       213569
     C                   Eval      E_PNAR = 'Trf Charges T/S/ZB'                213569
      * Posting Amount                                                          213569
     C                   If        @DrChCCY = I_CCCY                            213569
     C                   Z-ADD     HChgAmt       E_PSTA                         213569
     C                   Else                                                   213569
     C                   Z-ADD     CChgAmt       E_PSTA                         213569
     C                   Endif                                                  213569
      * DR/CR indicator                                                         213569
     C                   Z-ADD     0             E_DRCR                         213569
      * Source of Posting                                                       213569
     C                   MOVE      'GE-CX'       E_SPOS                         213569
      * Branch                                                                  213569
     C     O_GCAT        IFEQ      ' '                                          213569
     C     O_GCAT        OREQ      'S'                                          213569
     C                   MOVEL     @DrChBRCA     E_BRCA                         213569
     C                   ELSE                                                   213569
     C                   MOVEL     O_RBRC        E_BRCA                         213569
     C                   ENDIF                                                  213569
      * Retail indicator                                                        213569
      * A/c type                                                                213569
     C     O_GCAT        IFEQ      ' '                                          213569
     C     O_GCAT        OREQ      'S'                                          213569
     C                   MOVEL     @DrChATYP     E_ATYP                         213569
     C                   ELSE                                                   213569
     C                   MOVEL     O_RATY        E_ATYP                         213569
     C                   ENDIF                                                  213569
     C     E_ATYP        IFEQ      'R'                                          213569
     C                   Z-ADD     1             E_RIND                         213569
     C                   ENDIF                                                  213569
      * Posting indicators                                                      213569
     C                   BITOFF    '01234567'    E_PRIN                         213569
      * Replicated                                                              213569
     C     I_MODE        IFNE      'I/C'                                        213569
     C     I_MODE        ANDNE     'PUR'                                        212904
     C     I_CCAT        ANDNE     'T'                                          213569
     C     O_AcInGAH     ANDEQ     'Y'                                          213569
     C                   BITON     '7'           E_PRIN                         213569
     C                   ENDIF                                                  213569
      * Profit centre                                                           213569
      * Account section                                                         213569
     C     O_GCAT        IFEQ      ' '                                          213569
     C     O_GCAT        OREQ      'S'                                          213569
     C                   MOVEL     @DrChPRFC     E_PRFC                         213569
     C                   MOVEL     @DrChACSC     E_ACSC                         213569
     C                   ELSE                                                   213569
     C                   MOVEL     O_RPRF        E_PRFC                         213569
     C                   MOVEL     O_RACS        E_ACSC                         213569
     C                   ENDIF                                                  213569
      * Original transaction sub-type                                           213569
     C                   MOVEL     I_LINK        E_OTST                         213569
      * Original transaction type                                               213569
     C                   MOVEL     I_HIER        E_OTTP                         213569
      * Ext.Fil Ref.ID                                                          213569
     C                   MOVEL     AZXRFI        E_XRFI                         213569
      * Ext.Fil Ref.No.                                                         213569
     C                   Z-ADD     AZXRFN        E_XRFN                         213569
      * Transaction Sub-type                                                    213569
     C                   MOVEL     I_LEVL        E_TRST                         213569
                                                                                213569
     C                   WRITE     APOSTPDF                                     213569
                                                                                213569
     C                   Endsr                                                  213569
      ********************************************************************      213569
      /SPACE 5                                                                  213196
      ********************************************************************      213196
      * Det_WrkDay - Determine if today is a working day in a/c currency *      213196
      ********************************************************************      213196
     C     Det_WrkDay    BEGSR                                                  213196
                                                                                213196
      * For a top a/c in COB the effective run date is the following rundate    213196
                                                                                213196
     C     I_CCAT        IFEQ      'T'                                          213196
     C     I_MODE        ANDNE     'I/C'                                        213196
     C                   Z-ADD     ABDBRN        ZDAYNO                         213196
     C                   ELSE                                                   213196
     C                   Z-ADD     BJRDNB        ZDAYNO                         213196
     C                   ENDIF                                                  213196
                                                                                213196
     C                   CALLB     'ZCHKH'                                      213196
     C                   PARM                    ZDAYNO            5 0          213196
     C                   PARM      I_CCCY        ZCCY              3            213196
     C                   PARM      *BLANK        ZLOC              3            213196
     C                   PARM      *BLANK        ZHOLID            1            213196
     C     ZHOLID        IFEQ      'H'                                          213196
     C                   MOVEL     'N'           Ac_Ccy_WrkDay     1            213196
     C                   ELSE                                                   213196
     C                   MOVEL     'Y'           Ac_Ccy_WrkDay                  213196
     C                   ENDIF                                                  213196
                                                                                213196
     C                   ENDSR                                                  213196
      ********************************************************************      213196
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
      * Option
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
     C                   PARM                    X_OPTN
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
      * Time
     C                   PARM                    I_TIME            6
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Branch                                                        213569
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HISN           10
     C                   PARM                    I_BRCA            3            213569
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM                    I_CBRC            3
     C**********         PARM                    I_CCUS            6 0                        CSD027
     C                   PARM                    I_CCUS            6                          CSD027
     C                   PARM                    I_CCCY            3
     C**********         PARM                    I_CACD            4 0                        CGL029
     C                   PARM                    I_CACD           10 0                        CGL029
     C                   PARM                    I_CASN            2 0
      * Child A/c Category
     C                   PARM                    I_CCAT            1
      * Child retail no.
      * Child a/c name
      * Child a/c profit centre
      * Child a/c account section
     C                   PARM                    I_CRNO           10 0
     C                   PARM                    I_CANM           20
     C                   PARM                    I_CPRF            4
     C                   PARM                    I_CACS            2
      * Child a/c status
     C                   PARM                    I_ChildSTAT      26
      * Level
     C                   PARM                    I_LEVL            2 0
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    I_PBRC            3
     C**********         PARM                    I_PCUS            6 0                        CSD027
     C                   PARM                    I_PCUS            6                          CSD027
     C                   PARM                    I_PCCY            3
     C**********         PARM                    I_PACD            4 0                        CGL029
     C                   PARM                    I_PACD           10 0                        CGL029
     C                   PARM                    I_PASN            2 0
      * Parent retail no.
      * Parent a/c name
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   PARM                    I_PRNO           10 0
     C                   PARM                    I_PANM           20
     C                   PARM                    I_PPRF            4
     C                   PARM                    I_PACS            2
     C                   PARM                    I_PATY            1
      * Parent a/c status
     C                   PARM                    I_ParentSTAT     26
      * Child Account Narrative
      * Parent Account Narrative
     C                   PARM                    I_CNAR           30
     C                   PARM                    I_PNAR           30
      * Sweep/Top
     C                   PARM                    I_SWP_TOP         1
      * Sweeping Holiday Convention                                             213196
     C                   PARM                    I_SHOC            1            213196
      * Floor Limit for Top
      * Floor Limit for Sweep
      * Transaction Type - Top
      * Transaction Type - Sweep
     C                   PARM                    I_FLFT           15 0
     C                   PARM                    I_FLFS           15 0
     C                   PARM                    I_TYPT            5
     C                   PARM                    I_TYPS            5
 
      * Maximum Debit Value/Debit Count in a Day Exceeded
     C                   PARM                    I_Max_Dr_Excd     1
      * Destination
      * Destination Type
      * Sender's Correspondent
      * Receiver's Correspondent
      * MT202 Cover Message Required
      * MT103 Value Date Offset
     C                   PARM                    I_DEST           18
     C                   PARM                    I_DSTT            1
     C                   PARM                    I_SNDC            2
     C                   PARM                    I_RCVC           11
     C                   PARM                    I_MCMR            1
     C                   PARM                    I_MVDO            1
      * MT101 Charges
      * MT101 Charges Account
      * MT101 Charges Amount
      * MT101 Instruction Code
      * MT103 Charges
      * MT103 Charges Account
      * MT103 Charges Amount
      * MT103 Instruction Code
      * MT103 Bank Operation Code
     C                   PARM                    I_CHG1            3
     C**********         PARM                    I_CAC1           18                          CGL029
     C                   PARM                    I_CAC1                                       CGL029
     C                   PARM                    I_CAM1           15 0
     C                   PARM                    I_ICD1            4
     C                   PARM                    I_CHG3            3
     C**********         PARM                    I_CAC3           18                          CGL029
     C                   PARM                    I_CAC3                                       CGL029
     C                   PARM                    I_CAM3           15 0
     C                   PARM                    I_ICD3            4
     C                   PARM                    I_BOCD            4
      * External Account 1
      * External Account 2
      * External Account 3
      * External Account 4
      * External Account 5
     C                   PARM                    I_EXA1           35
     C                   PARM                    I_EXA2           35
     C                   PARM                    I_EXA3           35
     C                   PARM                    I_EXA4           35
     C                   PARM                    I_EXA5           35
      * Top a/c Sweep Type                                                      214360
      * Deferred Posting                                                        216421
      * Deferred Posting Zero Narrative                                         216421
     C                   PARM                    I_TAST            1            214360
     C                   PARM                    I_DEFP            1            216421
     C                   PARM                    I_DEFZ            1            216421
      * Next Available Seq No.
     C                   PARM                    I_NASN            2 0
      * Posting amount
      * Child A/c Debit/Credit ind
      * Value date
      * Sweep Description
      * Sweep Type     (Z or S)
      * Target Balance (Y or N)
      * Cleared Bal Sweep on Assoc Date (Y or N)
      * Zero Balancing Net or Gross (N or G)
     C                   PARM                    I_PSTA           13 0
     C                   PARM                    I_CADC            1
     C                   PARM                    I_VALD            5 0
     C                   PARM                    I_SDES           30
     C                   PARM                    I_STYP            1
     C                   PARM                    I_TBAL            1
     C                   PARM                    I_CBSA            1
     C                   PARM                    I_ZBNG            1
      * Top a/c balance
      * Top a/c overdraft
     C                   PARM                    I_TopBalance     15 0
     C                   PARM                    I_TopOverDft     15 0
      * Entries generated
     C                   PARM                    O_EntriesGen      1
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
                                                                                213569
      * Access Cash Management details                                          213569
                                                                                213569
     C                   CALLB     'AOCMANR0'                                   213569
     C                   PARM      '*DBERR  '    @RTCD             7            213569
     C                   PARM      '*FIRST  '    @OPTN             7            213569
     C     SDCMAN        PARM      SDCMAN        DSSDY                          213569
                                                                                213196
      * Get following run date                                                  213196
                                                                                213196
     C     I_MODE        IFNE      'I/C'                                        213196
     C                   MOVEL     'A.COB '      ABACOB                         213196
     C     ABACOB        CHAIN     @AICDF1                            99        213196
     C     *in99         IFEQ      '1'                                          213196
     C                   EVAL      X_ERMS = 'NO RECORD FOUND ON CBAICDL1'       213196
     C                   EXSR      *PSSR                                        213196
     C                   ENDIF                                                  213196
     C                   ENDIF                                                  213196
                                                                                213569
     C     KChgAccnt     Klist                                                  213569
     C                   Kfld                    @DrChCNUM                      213569
     C                   Kfld                    @DrChCCY                       213569
     C                   Kfld                    @DrChACOD                      213569
     C                   Kfld                    @DrChACSQ                      213569
     C                   Kfld                    @DrChBRCA                      213569
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * Open files
     C                   OPEN      RE100608P1
     C                   OPEN      GECXPD
     C                   OPEN      GLAPSTZS
 
      * Register P1 printer file with RCF
     C                   EXSR      RCFP1
 
      * Set mode narrative printed on report
 
     C                   SELECT
     C     I_MODE        WHENEQ    'PUR'
     C                   MOVEL     #_INF(1)      MODENARR
     C     I_MODE        WHENEQ    'ASC'
     C                   MOVEL     #_INF(2)      MODENARR
     C     I_MODE        WHENEQ    '1  '
     C                   MOVEL     #_INF(3)      MODENARR
     C     I_MODE        WHENEQ    '1PC'
     C                   MOVEL     #_INF(4)      MODENARR
     C     I_MODE        WHENEQ    '5  '
     C                   MOVEL     #_INF(5)      MODENARR
     C     I_MODE        WHENEQ    '5PC'
     C                   MOVEL     #_INF(6)      MODENARR
     C     I_MODE        WHENEQ    'I/C'
     C                   MOVEL     #_INF(7)      MODENARR
     C                   ENDSL
 
      * Set requested time
     C                   MOVEL     I_TIME        R_RTIME
 
      * Ignore every run code
 
     C                   MOVEL     *BLANK        IgnoreEveryRun   15
     C                   EVAL      IgnoreEveryRun = '*IGNORE'
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** #_INF
* PURGE OF VALUE DATE BALANCES *
* NEW ACCOUNT ASSOCIATIONS *
* DAILY *
* DAILY - POST CAPITALIZATION *
* ANWD *
* ANWD - POST CAPITALIZATION *
* INPUT CYCLE *
