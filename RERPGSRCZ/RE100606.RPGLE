     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Group Account Entry Generation')              *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100606 - Group Account Entry Generation                    *
      *                                                               *
      *  Function:  This program is given a group a/c hierarchy chain *
      *             and an entry to replicate. It then replicates that*
      *             entry up the chain.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR679670           Date 26Nov10               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 217357             Date 01May03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR679670 - Component REC100816 00002 failed                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  217357 - Deleted hierarchies and links cause db errors       *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FGECXPD    O    E             DISK    INFSR(*PSSR) USROPN
     F                                     PREFIX(E_)
     F                                     COMMIT
     FGLAPSTGA  O    E             DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
     FRE100606P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D I_CACD          S             10  0                                                    CGL029
 
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
 
 
      * Entry To Replicate
     D I_ENTRY       E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(E_)
 
 
     D #_INF           S             70    DIM(5)  CTDATA PERRCD(1)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      ** File Information Data Structure for RE100606P1
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
     C                   CLOSE     RE100606P1
     C                   CLOSE     GECXPD
     C                   CLOSE     GLAPSTGA
     C                   MOVEL     'Y'           PgmEnded          1
     C                   ENDIF
     C                   RETURN
     C                   ENDIF
 
      * Child a/c ID
 
     C                   MOVEL     I_CBRC        BRC
     C                   MOVEL     I_CCUS        CUS
     C                   MOVEL     I_CCCY        CCY
     C                   MOVEL     I_CACD        ACD
     C                   MOVEL     I_CASN        ASN
 
      * If new currency, access currency
 
     C     CCY           IFNE      L_CCY
     C                   EXSR      ACS_CURR
     C                   ENDIF
                                                                                217357
      * Determine which element represents the top account                      217357
                                                                                217357
     C                   Z-ADD     1             TopAc             2 0          217357
     C     *BLANK        LOOKUP    I_GLAI(TopAc)                          99    217357
     C                   SUB       1             TopAc                          217357
 
      * Do until no more hierarchy link records found
 
     C                   Z-ADD     1             C                 2 0
 
     C     I_GLAI(C)     DOWNE     *BLANK
     C     I_AST(C)      ANDNE     'C'
 
      * On first element in chain,
      * and if new source a/c,
      *   report source a/c
 
     C     C             IFEQ      1
     C     ACCID         ANDNE     L_ACCID
     C                   EXSR      REP_SACCNT
     C                   MOVEL     ACCID         L_ACCID
     C                   ENDIF
 
      * Get Next Available Ref. No.
      * Write extension record
      * Write entry
 
     C                   EXSR      GET_APNA
     C                   EXSR      WRT_EXTSN
     C                   EXSR      WRT_ENTRY
 
      * Report entry
 
     C                   EXSR      REP_ENTRY
 
      * Advance to next element in the chain
 
     C                   ADD       1             C
 
     C                   ENDDO
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Write Extension record
      ********************************************************************
     C     WRT_EXTSN     BEGSR
 
      * Ext.File Ref.ID
     C                   MOVEL     I_XRFI        AGXRFI
      * Ext.File Ref.No.
     C                   MOVEL     O_XRFN        AGXRFN
      * Link/Unlink
     C                   MOVEL     I_LKUL        AGLKUL
      * Source branch
      * Source customer
      * Source currency
      * Source a/c code
      * Source a/c seq.
     C                   MOVEL     I_CBRC        AGSBRC
     C                   MOVEL     I_CCUS        AGSCUS
     C                   MOVEL     I_CCCY        AGSCCY
     C                   MOVEL     I_CACD        AGSACD
     C                   MOVEL     I_CASN        AGSASN
      * Source retail no.
     C                   MOVEL     I_CRNO        AGSRNO
      * Source a/c level
     C                   MOVEL     I_LEVL        AGSLVL
      * Mode of Origin
     C                   MOVEL     I_MODE        AGMODO
      * Date Generated
     C                   Z-ADD     BJRDNB        AGDATG
      * Zero Balancing/Sweeping Extension Ref No.
     C     E_XRFI        IFEQ      'ZS '
     C                   Z-ADD     E_XRFN        AGZSXR
     C                   ELSE
     C                   Z-ADD     *ZERO         AGZSXR
     C                   ENDIF
 
     C                   WRITE     GLAPGAD0
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write Entry
      ********************************************************************
     C     WRT_ENTRY     BEGSR
 
     C                   MOVEL     I_GLAI(C)     ACCID
 
      * Customer, currency, a/c code and a/c seq.
     C                   MOVEL     CUS           E_CNUM
     C                   MOVEL     CCY           E_CCY
     C                   MOVEL     ACD           E_ACOD
     C                   MOVEL     ASN           E_ACSQ
      * Retail a/c no.
     C                   MOVEL     I_RAN(C)      E_ACNO
      * Posting Date
     C                   Z-ADD     BJRDNB        E_PSTD
      * Branch
     C                   MOVEL     BRC           E_BRCA
      * Retail indicator
     C                   Z-ADD     1             E_RIND
      * A/c type
     C                   MOVEL     'R'           E_ATYP
      * A/c type
     C                   BITOFF    '01234567'    E_PRIN
      * Profit centre
     C                   MOVEL     I_PC(C)       E_PRFC
      * Account section
     C                   MOVEL     I_ASC(C)      E_ACSC
      * Original transaction sub-type
     C                   MOVEL     *BLANK        E_OTST
     C                   MOVEL     I_LINK        E_OTST
      * Original transaction type
     C                   MOVEL     *BLANK        E_OTTP
     C                   MOVEL     I_HIER        E_OTTP
      * Account subtype                                                         217357
     C     C             IFEQ      TopAc                                        217357
     C                   MOVEL     'T'           E_STYP                         217357
     C                   ELSE                                                   217357
     C                   MOVEL     'L'           E_STYP                         217357
     C                   ENDIF                                                  217357
      * Number of items
      * Charge amount
     C                   Z-ADD     *ZERO         E_NITMS
     C                   Z-ADD     *ZERO         E_CHGA
      * Original amount
     C                   Z-ADD     *ZERO         E_ORAMT
      * Ext.Fil Ref.ID
     C                   MOVEL     AGXRFI        E_XRFI
      * Ext.Fil Ref.No.
     C                   Z-ADD     AGXRFN        E_XRFN
      * Transaction Sub-type
     C                   MOVEL     I_LEVL        E_TRST
      ** Settlement date                                                                    AR679670
     C                   Z-ADD     *ZERO         E_SETDAT                                   AR679670
 
     C                   WRITE     APOSTPDF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Get Next Available Ref. No.
      ********************************************************************
     C     GET_APNA      BEGSR
 
     C                   CALLB     'ZAGETAPNA'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Ext.File Ref.ID
     C                   PARM      'GA '         I_XRFI            3
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
      * Report source a/c
      ********************************************************************
     C     REP_SACCNT    BEGSR
 
      * Show retail a/c numbers
 
     C     I_CRNO        COMP      0                                  3535      *
 
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
 
      * Space
     C     C             IFEQ      1
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     SPACE
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
      * Access a currency
      ********************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'ZAACSCURR'
     C                   PARM                    CCY
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
 
      * Return code
      * Error Message
      * Option
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
     C                   PARM                    X_OPTN
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
      * Entry To Replicate
     C                   PARM                    I_ENTRY
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
     C                   PARM                    I_CACD                                       CGL029
     C                   PARM                    I_CASN            2 0
      * Child A/c Category
     C                   PARM                    I_CCAT            1
      * Child retail no.
     C                   PARM                    I_CRNO           10 0
      * Level
     C                   PARM                    I_LEVL            2 0
      * CHAINS FOR:
      * GL Account ID
      * Retail A/c No.
      * A/c Status
      * Profit Centre
      * A/c Section
      * Overdraft
      * Balance Available for I/C Overdraft
      * I/C Threshold Balance
     C                   PARM                    I_GLAI
     C                   PARM                    I_RAN
     C                   PARM                    I_AST
     C                   PARM                    I_PC
     C                   PARM                    I_ASC
     C                   PARM                    I_ODFT
     C                   PARM                    I_BAIC
     C                   PARM                    I_ICTB
      * Count in chain
     C                   PARM                    I_CNTCH           2 0
      * Link/Unlink
     C                   PARM                    I_LKUL            1
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * Open files
     C                   OPEN      RE100606P1
     C                   OPEN      GECXPD
     C                   OPEN      GLAPSTGA
 
      * Register P1 printer file with RCF
     C                   EXSR      RCFP1
 
      * Set mode narrative printed on report
 
     C                   SELECT
     C     I_MODE        WHENEQ    '1  '
     C                   MOVEL     #_INF(1)      MODENARR
     C     I_MODE        WHENEQ    '1PC'
     C                   MOVEL     #_INF(2)      MODENARR
     C     I_MODE        WHENEQ    '5  '
     C                   MOVEL     #_INF(3)      MODENARR
     C     I_MODE        WHENEQ    '5PC'
     C                   MOVEL     #_INF(4)      MODENARR
     C     I_MODE        WHENEQ    'I/C'
     C                   MOVEL     #_INF(5)      MODENARR
     C                   ENDSL
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** #_INF
* DAILY *
* DAILY - POST CAPITALIZATION *
* ANWD *
* ANWD - POST CAPITALIZATION *
* INPUT CYCLE *
