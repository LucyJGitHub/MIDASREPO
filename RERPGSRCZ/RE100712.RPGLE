     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Group A/c Link/Unlink Replication')           *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100712 - Group A/c Link/Unlink Replication                 *
      *                                                               *
      *  Function:  This program replicates postings and balances     *
      *             up the group a/c hierarchy when links or unlinks  *
      *             have occurred.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR676213           Date 19Nov10               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 214360             Date 03Feb03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  214360 - Cash Management Deferred Posting                    *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRECMLCL0  IP   E           K DISK    INFSR(*PSSR)
     FPMHPOSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(E_)
     FGECXL0    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:GECXF)
     F                                     PREFIX(E_)
     FGLAPSGAL0 IF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AC_)
     FRE100712P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Cash Management Hierarchy Details
     D O_CMHD        E DS                  EXTNAME(RECMHDPD)
      * Zero Balancing/Sweeping Hierarchy Details
     D O_ZSHD        E DS                  EXTNAME(REZSHDPD)
      * Group Account Hierarchy Details
     D O_GAHD        E DS                  EXTNAME(REGAHDPD)
 
 
      * Cash Management Hierarchy Links
     D O_CMHL        E DS                  EXTNAME(RECMHLPD)
     D A_HIER                  1      9
     D A_LINK                 10     18
      * Zero Balancing/Sweeping Hierarchy Links
     D O_ZSHL        E DS                  EXTNAME(REZSHLPD)
      * Group Account Hierarchy Links
     D O_GAHL        E DS                  EXTNAME(REGAHLPD)
 
 
      ** Chain Arrays
     D***I_GLAI*         S             18    DIM(99)                                          CGL029
     D I_GLAI          S             24    DIM(99)                                            CGL029
     D I_RAN           S             10    DIM(99)
     D I_AST           S              1    DIM(99)
     D I_PC            S              4    DIM(99)
     D I_ASC           S              2    DIM(99)
     D I_ODFT          S             15S 0 DIM(99)
     D I_BAIC          S              1    DIM(99)
     D I_ICTB          S             15S 0 DIM(99)
      ** Chain Arrays
     D***O_GLAI*         S             18    DIM(99)                                          CGL029
     D O_GLAI          S             24    DIM(99)                                            CGL029
     D O_RAN           S             10    DIM(99)
     D O_AST           S              1    DIM(99)
     D O_PC            S              4    DIM(99)
     D O_ASC           S              2    DIM(99)
     D O_ODFT          S             15S 0 DIM(99)
     D O_BAIC          S              1    DIM(99)
     D O_ICTB          S             15S 0 DIM(99)
 
 
      ** Entry To Replicate
     D I_ENTRY       E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(E_)
     D A_XRFI                317    319
     D A_XRFN                320    329
 
 
      ** Account ID
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
 
 
     D #_INF           S             70    DIM(2)  CTDATA PERRCD(1)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCMAN        E DS                  EXTNAME(SDCMANPD)
      ** External DS for cash management details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** External DS for RETAIL details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs
 
 
      ** File Information Data Structure for RE100712P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
     IRECMLCD0      01
     I              LCHIER                      CLHIER        L1
     I              LCLINK                      CLLINK
     I              LCCBRC                      CLCBRC
     I              LCCCUS                      CLCCUS
     I              LCCCCY                      CLCCCY
     I              LCCACD                      CLCACD
     I              LCCASN                      CLCASN
 
      * Access Hierarchy Detail
 
     C   L1              EXSR      ACS_HIER
 
      * Access Hierarchy Link
 
     C                   EXSR      ACS_LINK
 
      * Access child a/c details
 
 
     C                   MOVEL     CLCBRC        BRC
     C                   MOVEL     CLCCUS        CUS
     C                   MOVEL     CLCCCY        CCY
     C                   MOVEL     CLCACD        ACD
     C                   MOVEL     CLCASN        ASN
 
     C                   EXSR      ACS_ACCNT
 
      * If new currency, access currency
 
     C     CCY           IFNE      L_CCY
     C                   MOVEL     CCY           L_CCY             3
     C                   EXSR      ACS_CURR
     C                   ENDIF
 
      * Zeroize count of entries processed
 
     C                   Z-ADD     0             CE                5 0
 
      * Zeroize total movements
      * Zeroize total replicated
 
     C                   Z-ADD     0             TOT_MOVS         17 0
     C                   Z-ADD     0             TOT_REPL         17 0
 
      * If a/c is open
 
     C     AC_RECI       IFEQ      'D'
 
      * Construct a CM Hierarchy Chain
 
     C                   EXSR      CON_HCHN
 
      * If not a top a/c
 
     C     X_RTCD        IFNE      '*TOP'
 
      * Apply historic postings up the hierarchy since the link/unlink date
 
     C                   EXSR      APY_HPOST
 
      * Apply today's unlink postings up the hierarchy
 
     C                   EXSR      APY_TUPOST
 
      * Apply outstanding balance up the hierarchy
 
     C                   EXSR      APY_OSBAL
 
      * Report total replicated
 
     C                   EXSR      REP_TOTALR
 
     C                   ENDIF
     C                   ENDIF
 
 
     C                   COMMIT
 
      * Produce end of report
 
     CLR                 MOVEL     '*END   '     X_OPTN
     CLR                 EXSR      GROUPAC_EG
     CLR                 EXSR      END_OF_REP
 
      /SPACE 5
      ********************************************************************
      * Apply historic postings up the hierarchy since the link/unlink date
      ********************************************************************
     C     APY_HPOST     BEGSR
 
      * Read first child a/c entry
 
     C     PMHPOSKF      SETLL     PMHPOSL1
     C                   CLEAR                   I_ENTRY
     C     PMHPOSKP      READE     PMHPOSL1                               60    *
 
 
      * Do until more more child a/c entries are read
 
     C     *IN60         DOWEQ     '0'
 
      * If no entries processed yet
      *  Report source account
 
     C     CE            IFEQ      0
     C                   EXSR      REP_SACCNT
     C                   ENDIF
 
      * Add to total movements
 
     C     E_DRCR        IFEQ      0
     C                   ADD       E_PSTA        TOT_MOVS
     C                   ELSE
     C                   SUB       E_PSTA        TOT_MOVS
     C                   ENDIF
 
      * Adjust value date of entry if 'Accrue on Ledger Balance'
 
     C     BMCBAI        IFNE      'Y'
     C     E_VALD        IFGE      LCLUDT
     C                   Z-ADD     E_PSTD        E_VALD
     C                   ELSE
     C                   Z-ADD     LCLUDT        E_VALD
     C                   ENDIF
     C                   ENDIF
 
      * Reverse DR/CR ind if mode = unlink
 
     C     I_LUMODE      IFEQ      'U'
     C     E_DRCR        IFEQ      0
     C                   Z-ADD     1             E_DRCR
     C                   ELSE
     C                   Z-ADD     0             E_DRCR
     C                   ENDIF
     C                   ENDIF
 
      * Source of Posting
     C                   MOVE      '  GE-CX'     E_SPOS
 
      * Report entry as NOT an unlink
 
     C                   MOVE      ' '           R_LKUL
 
      * Report Entry
 
     C                   EXSR      REP_ENTRY
 
      * Add to total replicaed
 
     C     E_DRCR        IFEQ      0
     C                   ADD       E_PSTA        TOT_REPL
     C                   ELSE
     C                   SUB       E_PSTA        TOT_REPL
     C                   ENDIF
 
      *  Do group account entry generation (up the hierarchy)
 
     C                   EXSR      GROUPAC_EG
 
      * Increment count of entries processed
 
     C                   ADD       1             CE
 
      * Read next child a/c entry
 
     C                   CLEAR                   I_ENTRY
     C     PMHPOSKP      READE     PMHPOSL1                               60    *
 
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Apply today's unlink postings up the hierarchy
      ********************************************************************
     C     APY_TUPOST    BEGSR
 
      * Read first child a/c entry
 
     C     GECXK         SETLL     GECXL0
     C     GECXK         READE     GECXL0                                 60    *
 
 
      * Do until more more child a/c entries are read
 
     C     *IN60         DOWEQ     '0'
 
      * Only process entry if it is an UNLINK entry
 
     C     GLAPSGAK      CHAIN     GLAPGAD0                           60
     C     *IN60         IFEQ      '1'
     C                   EVAL      X_ERMS = 'NO EXTENSION FOR ENTRY:'
     C                                       + A_XRFI + A_XRFN
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     AGLKUL        IFEQ      'U'
 
      * If no entries processed yet
      *  Report source account
 
     C     CE            IFEQ      0
     C                   EXSR      REP_SACCNT
     C                   ENDIF
 
      * Adjust value date of entry if 'Accrue on Ledger Balance'
 
     C     BMCBAI        IFNE      'Y'
     C     E_VALD        IFGE      LCLUDT
     C                   Z-ADD     E_PSTD        E_VALD
     C                   ELSE
     C                   Z-ADD     LCLUDT        E_VALD
     C                   ENDIF
     C                   ENDIF
 
      * Reverse DR/CR ind if mode = unlink
 
     C     I_LUMODE      IFEQ      'U'
     C     E_DRCR        IFEQ      0
     C                   Z-ADD     1             E_DRCR
     C                   ELSE
     C                   Z-ADD     0             E_DRCR
     C                   ENDIF
     C                   ENDIF
 
      * Source of Posting
     C                   MOVE      '  GE-CX'     E_SPOS
 
      * Report entry as an unlink
 
     C                   MOVE      'U'           R_LKUL
 
      * Report Entry
 
     C                   EXSR      REP_ENTRY
 
      * Add to total replicaed
 
     C     E_DRCR        IFEQ      0
     C                   ADD       E_PSTA        TOT_REPL
     C                   ELSE
     C                   SUB       E_PSTA        TOT_REPL
     C                   ENDIF
 
      *  Do group account entry generation (up the hierarchy)
 
     C                   EXSR      GROUPAC_EG
 
      * Increment count of entries processed
 
     C                   ADD       1             CE
 
     C                   ENDIF
 
      * Read next child a/c entry
 
     C     GECXK         READE     GECXL0                                 60    *
 
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Apply outstanding balance up the hierarchy
      ********************************************************************
     C     APY_OSBAL     BEGSR
 
      * Calculate brought forward balance
 
     C     AC_LDBL       SUB       TOT_MOVS      BAL_BF           13 0
 
      * If the brought forward balance is NOT zero
      *   Replicate it
 
     C     BAL_BF        IFNE      *ZERO
 
      * If no entries processed yet
      *  Report source account
 
     C     CE            IFEQ      0
     C                   EXSR      REP_SACCNT
     C                   ENDIF
 
     C                   CLEAR                   I_ENTRY
      * Record ID
     C                   MOVEL     'P'           E_RECI
      * Value Date
     C                   Z-ADD     LCLUDT        E_VALD
      * Transaction type
     C                   MOVEL     CMGATT        E_TRAT
      * Posting Narrative
     C                   EVAL      E_PNAR = 'B/F BALANCE'
      * Posting Amount
      * DR/CR indicator
     C     BAL_BF        IFLT      *ZERO
     C                   Z-SUB     BAL_BF        E_PSTA
     C                   Z-ADD     1             E_DRCR
     C                   ELSE
     C                   Z-ADD     BAL_BF        E_PSTA
     C                   Z-ADD     0             E_DRCR
     C                   ENDIF
 
      * Reverse DR/CR ind if mode = unlink
 
     C     I_LUMODE      IFEQ      'U'
     C     E_DRCR        IFEQ      0
     C                   Z-ADD     1             E_DRCR
     C                   ELSE
     C                   Z-ADD     0             E_DRCR
     C                   ENDIF
     C                   ENDIF
 
      * Source of Posting
     C                   MOVE      '  GE-CX'     E_SPOS
 
      * Report entry as NOT an unlink
 
     C                   MOVE      ' '           R_LKUL
 
      * Report Entry
 
     C                   EXSR      REP_ENTRY
 
      * Add to total replicaed
 
     C     E_DRCR        IFEQ      0
     C                   ADD       E_PSTA        TOT_REPL
     C                   ELSE
     C                   SUB       E_PSTA        TOT_REPL
     C                   ENDIF
 
      *  Do group account entry generation (up the hierarchy)
 
     C                   EXSR      GROUPAC_EG
 
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Construct a CM Hierarchy Chain
      ********************************************************************
     C     CON_HCHN      BEGSR
 
     C                   CALLB     'RE100604'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Hierarchy ID
     C                   PARM      CLHIER        I_HIER            9 0
      * Hierarchy Type
     C                   PARM      'GA'          I_HTYP            2
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM      CLPBRC        I_PBRC            3
     C**********         PARM      CLPCUS        I_PCUS            6 0                        CSD027
     C                   PARM      CLPCUS        I_PCUS            6                          CSD027
     C                   PARM      CLPCCY        I_PCCY            3
     C**********         PARM      CLPACD        I_PACD            4 0                        CGL029
     C                   PARM      CLPACD        I_PACD           10 0                        CGL029
     C                   PARM      CLPASN        I_PASN            2 0
 
      * OUTPUTS
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
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
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
     C                   PARM                    I_MODE            3
      * Entry To Replicate
     C                   PARM                    I_ENTRY
      * Hierarchy ID
      * Hierarchy Shortname
     C                   PARM      CLHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
      * Link ID
     C                   PARM      CLLINK        I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      CLCBRC        I_CBRC
     C                   PARM      CLCCUS        I_CCUS
     C                   PARM      CLCCCY        I_CCCY
     C                   PARM      CLCACD        I_CACD
     C                   PARM      CLCASN        I_CASN
      * Child A/c Category
     C                   PARM      CLCCAT        I_CCAT            1
      * Child retail no.
     C                   PARM      AC_ACNO       I_CRNO           10 0
      * Source level
     C                   PARM      CLLEVL        I_LEVL            2 0
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
     C                   PARM      I_LUMODE      I_LKUL            1
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Report source a/c
      ********************************************************************
     C     REP_SACCNT    BEGSR
 
      * Show retail a/c number
 
     C     AC_ACNO       COMP      0                                  3535      *
 
     C                   Z-ADD     3             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     SOURCE
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Report entry
      ********************************************************************
     C     REP_ENTRY     BEGSR
 
      * Edit Link Id, if required
 
     C     R_LKUL        IFEQ      'U'
     C                   MOVEL     E_OTST        R_LINK
     C                   ELSE
     C                   MOVEL     *BLANK        R_LINK
     C                   ENDIF
 
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
      /SPACE 5
      ********************************************************************
      * Report total replicated
      ********************************************************************
     C     REP_TOTALR    BEGSR
 
      * Edit total replicated
      * and  total replicated dr/cr indicator
 
     C     TOT_REPL      IFGT      0
     C                   Z-ADD     TOT_REPL      w_AMT            15 0
     C                   MOVEL     'DR'          R_TDRCR
     C                   ELSE
     C                   Z-SUB     TOT_REPL      w_AMT
     C                   MOVEL     'CR'          R_TDRCR
     C                   ENDIF
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      w_AMT         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_TOTALR
 
     C                   Z-ADD     2             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     TOTALR
 
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
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
     C     *IN60         IFEQ      '1'
     C                   EVAL      X_ERMS = 'BAD A/C:' + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
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
      * Access Hierarchy Detail
      ********************************************************************
     C     ACS_HIER      BEGSR
 
     C                   CALLB     'RE100601'
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Option
     C                   PARM      '*ALL   '     X_OPTN            7
      * Hierarchy ID
     C                   PARM      CLHIER        I_HIER            9 0
      * Hierarchy Type
     C                   PARM      *BLANK        I_HTYP            2
 
     C                   PARM                    O_CMHD
     C                   PARM                    O_ZSHD
     C                   PARM                    O_GAHD
 
      * End if error occurred in module
      * or if no record found
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     X_RTCD        OREQ      '*NOREC'
     C                   EVAL      X_ERMS = 'BAD HIERARCHY DETAIL:' + A_HIER
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access Hierarchy Link
      ********************************************************************
     C     ACS_LINK      BEGSR
 
     C                   CALLB     'RE100602'
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Option
     C                   PARM      '*ALL   '     X_OPTN            7
      * Hierarchy ID
     C                   PARM      CLHIER        I_HIER            9 0
      * Hierarchy Type
     C                   PARM      CDHTYP        I_HTYP            2
      * Link ID
     C                   PARM      CLLINK        I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      CLCBRC        I_CBRC            3
     C**********         PARM      CLCCUS        I_CCUS            6 0                        CSD027
     C                   PARM      CLCCUS        I_CCUS            6                          CSD027
     C                   PARM      CLCCCY        I_CCCY            3
     C**********         PARM      CLCACD        I_CACD            4 0                        CGL029
     C                   PARM      CLCACD        I_CACD           10 0                        CGL029
     C                   PARM      CLCASN        I_CASN            2 0
 
     C                   PARM                    O_CMHL
     C                   PARM                    O_ZSHL
     C                   PARM                    O_GAHL
 
      * End if error occurred in module
      * or if no record found
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     X_RTCD        OREQ      '*NOREC'
     C                   EVAL      X_ERMS = 'BAD HIERARCHY LINK:' +
     C                                       A_HIER + A_LINK
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
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
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * INPUTS
      * Link/Unlink Mode
     C                   PARM                    I_LUMODE          1
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Access Cash Management Details
 
     C                   CALLB     'AOCMANR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDCMAN        PARM      SDCMAN        DSSDY
 
      * Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOCMANR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *  Access Retail Details
 
     C                   CALL      'AORETLR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * Register P1 printer file with RCF
     C                   EXSR      RCFP1
 
      * Set mode narrative printed on report
 
     C                   SELECT
     C     I_LUMODE      WHENEQ    'U'
     C                   MOVEL     #_INF(1)      MODENARR
     C     I_LUMODE      WHENEQ    'L'
     C                   MOVEL     #_INF(2)      MODENARR
     C                   ENDSL
 
      * Clear data structures
 
     C                   CLEAR                   O_CMHD
     C                   CLEAR                   O_ZSHD
     C                   CLEAR                   O_GAHD
     C                   CLEAR                   O_CMHL
     C                   CLEAR                   O_ZSHL
     C                   CLEAR                   O_GAHL
 
      * Key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
 
     C     PMHPOSKF      KLIST
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    LCLUDT
     C     PMHPOSKP      KLIST
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C     GECXK         KLIST
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C     GLAPSGAK      KLIST
     C                   KFLD                    E_XRFI
     C                   KFLD                    E_XRFN
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** INF
* UNLINKS *
* LINKS *
