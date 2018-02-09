     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Shadow Account Entry Generation')             *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100609 - Shadow Account Entry Generation                   *
      *                                                               *
      *  Function:  This program is given a child and shadow a/c and  *
      *             basic posting details. It then writes entries to  *
      *             GECMPD (with extension details written to GLAPSTZS)
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FGECXPD    O    E             DISK    INFSR(*PSSR) USROPN
     F                                     PREFIX(E_)
     F                                     COMMIT
     FGLAPSTZS  O    E             DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
     FRE100609P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Account ID
     D                 DS
     D*ACCID****               1     18                                                       CGL029
     D ACCID                   1     24                                                       CGL029
     D BRC                     1      3
     D*CUS******               4      9S 0                                                    CSD027
     D CUS                     4      9A                                                      CSD027
     D CCY                    10     12
     D*ACD******              13     16S 0                                                    CGL029
     D*ASN******              17     18S 0                                                    CGL029
     D ACD                    13     22S 0                                                    CGL029
     D ASN                    23     24S 0                                                    CGL029
 
 
      * Last Account ID
     D                 DS
     D*L_ACCID**               1     18                                                       CGL029
     D L_ACCID                 1     24                                                       CGL029
     D L_BRC                   1      3
     D*L_CUS****               4      9S 0                                                    CSD027
     D L_CUS                   4      9A                                                      CSD027
     D L_CCY                  10     12
     D*L_ACD****              13     16S 0                                                    CGL029
     D*L_ASN****              17     18S 0                                                    CGL029
     D L_ACD                  13     22S 0                                                    CGL029
     D L_ASN                  23     24S 0                                                    CGL029
 
 
      * Output Entry
     D O_ENTRY       E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(E_)
 
 
     D #_INF           S             70    DIM(5)  CTDATA PERRCD(1)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      ** File Information Data Structure for RE100609P1
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
     C                   CLOSE     RE100609P1
     C                   CLOSE     GECXPD
     C                   CLOSE     GLAPSTZS
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
 
      * If new source a/c,
      *   report source a/c
 
     C     ACCID         IFNE      L_ACCID
     C                   EXSR      REP_SACCNT
     C                   MOVEL     ACCID         L_ACCID
     C                   ENDIF
 
      * Get Next Available Ref. No.
      * Write SHADOW extension record
      * Write SHADOW entry
 
     C                   EXSR      GET_APNA
     C                   EXSR      WRT_SEXTSN
     C                   EXSR      WRT_SENTRY
 
      * Report entry
 
     C                   EXSR      REP_ENTRY
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Write SHADOW Extension record
      ********************************************************************
     C     WRT_SEXTSN    BEGSR
 
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
     C                   MOVEL     *BLANK        AZASDA
      * Contra posting amount
     C                   Z-ADD     I_PSTA        AZCAMT
      * Sweep Type
     C                   MOVEL     *BLANK        AZSTYP
      * Top/Sweep
     C                   MOVEL     *BLANK        AZTPSW
      * Target Balance
     C                   MOVEL     'N'           AZTBAL
      * Shadow Entry
     C                   MOVEL     'Y'           AZSHAD
      * Mode of Origin
     C                   MOVEL     I_MODE        AZMODO
      * Date Generated
     C                   Z-ADD     BJRDNB        AZDATG
      * Sequence Number
     C                   MOVEL     *ZERO         AZSNUM
 
     C                   WRITE     GLAPZSD0
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write SHADOW Entry
      ********************************************************************
     C     WRT_SENTRY    BEGSR
 
      * Clear output entry
 
     C                   CLEAR                   O_ENTRY
      * Record ID
     C                   MOVEL     'P'           E_RECI
 
      * Customer, currency, a/c code and a/c seq.
     C                   MOVEL     I_SCUS        E_CNUM
     C                   MOVEL     I_SCCY        E_CCY
     C                   MOVEL     I_SACD        E_ACOD
     C                   MOVEL     I_SASN        E_ACSQ
      * Retail a/c no.
     C                   MOVEL     I_SRNO        E_ACNO
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
     C                   MOVEL     'SUMMARY'     E_PNAR
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
     C                   MOVEL     I_SBRC        E_BRCA
      * Retail indicator
     C                   Z-ADD     1             E_RIND
      * A/c type
     C                   MOVEL     'R'           E_ATYP
      * A/c type
     C                   BITOFF    '01234567'    E_PRIN
      * Profit centre
     C                   MOVEL     I_SPRF        E_PRFC
      * Account section
     C                   MOVEL     I_SACS        E_ACSC
      * Original transaction sub-type
     C                   MOVEL     *BLANK        E_OTST
     C                   MOVEL     I_LINK        E_OTST
      * Original transaction type
     C                   MOVEL     *BLANK        E_OTTP
     C                   MOVEL     I_HIER        E_OTTP
      * Original amount
     C                   Z-ADD     *ZERO         E_ORAMT
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
      * Child retail no.
      * Child a/c profit centre
      * Child a/c account section
     C                   PARM                    I_CRNO           10 0
     C                   PARM                    I_CPRF            4
     C                   PARM                    I_CACS            2
      * Level
     C                   PARM                    I_LEVL            2 0
      * Shadow branch
      * Shadow customer
      * Shadow currency
      * Shadow a/c code
      * Shadow a/c seq.
     C                   PARM                    I_SBRC            3
     C**********         PARM                    I_SCUS            6 0                        CSD027
     C                   PARM                    I_SCUS            6                          CSD027
     C                   PARM                    I_SCCY            3
     C**********         PARM                    I_SACD            4 0                        CGL029
     C                   PARM                    I_SACD           10 0                        CGL029
     C                   PARM                    I_SASN            2 0
      * Shadow retail no.
      * Shadow a/c profit centre
      * Shadow a/c account section
     C                   PARM                    I_SRNO           10 0
     C                   PARM                    I_SPRF            4
     C                   PARM                    I_SACS            2
      * Transaction Type - Top
      * Transaction Type - Sweep
     C                   PARM                    I_TYPT            5
     C                   PARM                    I_TYPS            5
      * Posting amount
      * Child A/c Debit/Credit ind
      * Value date
     C                   PARM                    I_PSTA           13 0
     C                   PARM                    I_CADC            1
     C                   PARM                    I_VALD            5 0
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * Open files
     C                   OPEN      RE100609P1
     C                   OPEN      GECXPD
     C                   OPEN      GLAPSTZS
 
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
