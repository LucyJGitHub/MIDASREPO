     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Zero Balancing Shadow Accounting')            *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100611 - Zero Balancing Shadow Accounting                  *
      *                                                               *
      *  Function:  This program does the shadow accounting for a     *
      *             given zero balancing child account.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR976539           Date 25Feb13               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 03Mar10               *
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
      *  AR976539 - Purge request fails. CAP204 should be reversed.   *
      *             (Child:AR976540)                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CAP204 - Retail Account Transfer                             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FGLACBTL0  IF   E           K DISK    INFSR(*PSSR)
     FRECMLCL3  IF   E           K DISK    INFSR(*PSSR)
     F***ACPO1**   IF   F  400    18AIDISK    KEYLOC(2)                                       CGL029
     F***ACPO1     IF   F  400    24AIDISK    KEYLOC(2)                                CGL029 CAP204
     F***GLACPML0  IF   F  400    24AIDISK    KEYLOC(2)                              CAP204 AR976539
     FACPO1     IF   F  620    24AIDISK    KEYLOC(2)                                        AR976539
     FRE100611P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D I_CACD          S             10  0                                                    CGL029
     D I_SACD          S             10  0                                                    CGL029
 
      * Key to A/c Posting file
     D                 DS
     D***ACPOK**                 1     18                                                     CGL029
     D ACPOK                   1     24                                                       CGL029
     D**CUS*****               1      6  0                                                    CSD027
     D  CUS                    1      6A                                                      CSD027
     D  CCY                    7      9
     D***ACD****               10     13  0                                                   CGL029
     D***ASN****               14     15  0                                                   CGL029
     D***BRC****               16     18                                                      CGL029
     D  ACD                   10     19  0                                                    CGL029
     D  ASN                   20     21  0                                                    CGL029
     D  BRC                   22     24                                                       CGL029
 
 
      * Input Entry
     D I_ENTRY       E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(E_)
 
 
     D #_INF           S             70    DIM(5)  CTDATA PERRCD(1)
     D #_PCMODE        S              3    DIM(2)  CTDATA PERRCD(1)
     D #_PCSPOS        S              7    DIM(2)  CTDATA PERRCD(1)
 
 
     D                 DS
     D INFTXT                  1     34
     D INFLNK                 15     24
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      ** File Information Data Structure for RE100611P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
     I***ACPO1     NS                                                                         CAP204
     I***GLACPML0  NS                                                                CAP204 AR976539
     I**********                        1  400  INREC                                       AR976539
     IACPO1     NS                                                                          AR976539
     I                                  1  620  INREC                                       AR976539
 
 
      * If end requested
      *  Call shadow account entry generation in 'end' mode
      *  Produce end of report
      *  Close files
      *  Do last return
 
     C     X_OPTN        IFEQ      '*END   '
     C     PgmEnded      IFNE      'Y'
     C                   EXSR      SHADOW_EG
     C                   EXSR      END_OF_REP
     C                   CLOSE     RE100611P1
     C                   MOVEL     'Y'           PgmEnded          1
     C                   ENDIF
     C                   RETURN
     C                   ENDIF
 
      * Source a/c ID ( = Child a/c ID)
 
     C                   MOVEL     I_CBRC        BRC
     C                   MOVEL     I_CCUS        CUS
     C                   MOVEL     I_CCCY        CCY
     C                   MOVEL     I_CACD        ACD
     C                   MOVEL     I_CASN        ASN
 
      * If new currency, access currency
 
     C     CCY           IFNE      L_CCY
     C                   MOVEL     CCY           L_CCY             3
     C                   EXSR      ACS_CURR
     C                   ENDIF
 
      * Zeroize count of entries processed
      * and initialize 'a/c reported' indicator
 
     C                   Z-ADD     0             CE                5 0
     C                   MOVEL     'N'           AC_Reported       1
 
      * If mode = daily, or daily post capitalization
      *   Access opening ledger and cleared balance for child a/c
 
     C     I_MODE        IFEQ      '1  '
     C     I_MODE        OREQ      '1PC'
     C     GLACBLK       CHAIN     GLACBLF                            60        *
     C     *IN60         IFEQ      '0'
     C                   Z-ADD     LDBL          I_CLDBL
     C                   Z-ADD     CLBL          I_CCLBL
     C                   ENDIF
     C                   ENDIF
 
      * If mode = daily post
      * and the account's opening cleared balance <> 0
      *   Check if linked today
      *   If so, post the cleared balance value today
      *          and report the source account
 
     C                   MOVEL     'N'           CLBLPost          1
     C     I_MODE        IFEQ      '1  '
     C     I_CCLBL       ANDNE     *ZERO
     C     RECMLCK       CHAIN     RECMLCL3                           60        *
     C     *IN60         IFEQ      '0'
     C                   EXSR      POST_CLBL
     C                   MOVEL     'Y'           CLBLPost
     C                   EXSR      REP_SACCNT
     C                   ENDIF
     C                   ENDIF
 
      * Read first child a/c entry
 
     C*****ACPOK         SETLL     ACPO1                                                      CAP204
     C*****ACPOK         SETLL     GLACPML0                                          CAP204 AR976539
     C     ACPOK         SETLL     ACPO1                                                    AR976539
 
     C                   EXSR      READ_ENTRY
     C  N60              Z-ADD     E_VALD        VALD              5 0
 
 
      * Do until more more child a/c entries are read
 
     C     *IN60         DOWEQ     '0'
 
      * If the source of entry is NOT CM
      * and its value date is prior to or equal to the event control date
 
     C     E_SPOS        IFNE      '  GE-CX'
     C     E_VALD        ANDLE     I_EvtCtlDat
 
      * Select entries for this mode (interest entries in post
      * capitalization modes, other entries in pre capitalization modes)
 
     C     I_MODE        LOOKUP    #_PCMODE                               98
     C     E_SPOS        LOOKUP    #_PCSPOS                               99
     C                   MOVEA     *IN(98)       Ind9899           2
     C     Ind9899       IFEQ      '00'
     C     Ind9899       OREQ      '11'
 
      * If a/c not reported yet
      *  Report source account
 
     C     AC_Reported   IFNE      'Y'
     C                   EXSR      REP_SACCNT
     C                   ENDIF
 
      * On change of value date
      *  Do net shadow account entry generation
      *  Report date total
 
     C     E_VALD        IFNE      VALD
 
     C                   EXSR      NET_EG
     C                   EXSR      REP_DATTOT
 
      * Next value date
 
     C                   Z-ADD     E_VALD        VALD
     C                   ENDIF
 
      * Accumulate value date totals
 
     C     E_DRCR        IFEQ      0
     C                   ADD       E_PSTA        TOTAL
     C                   ELSE
     C                   SUB       E_PSTA        TOTAL
     C                   ENDIF
 
      * Report Entry
 
     C                   EXSR      REP_ENTRY
 
      * Increment count of entries processed
 
     C                   ADD       1             CE
 
     C                   ENDIF
     C                   ENDIF
 
      * Read next child a/c entry
 
     C                   EXSR      READ_ENTRY
 
     C                   ENDDO
 
      * If entries processed
      *   Do net shadow account entry generation
      *   Report date total
 
     C     CE            IFNE      0
     C                   EXSR      NET_EG
     C                   EXSR      REP_DATTOT
     C                   ENDIF
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Read an entry
      ********************************************************************
     C     READ_ENTRY    BEGSR
 
     C*****ACPOK         READE     ACPO1                                  60    *             CAP204
     C*****ACPOK         READE     GLACPML0                               60    *    CAP204 AR976539
     C     ACPOK         READE     ACPO1                                  60                AR976539
     C  N60              MOVEL     INREC         I_ENTRY
     C     *IN60         DOWEQ     '0'
     C     E_RECI        ANDNE     'P'
     C*****ACPOK         READE     ACPO1                                  60    *             CAP204
     C*****ACPOK         READE     GLACPML0                               60    *    CAP204 AR976539
     C     ACPOK         READE     ACPO1                                  60                AR976539
     C  N60              MOVEL     INREC         I_ENTRY
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Post the cleared balance value today
      ********************************************************************
     C     POST_CLBL     BEGSR
 
      * Posting Amount
      * Child A/c Debit/Credit ind
 
     C     I_CCLBL       IFGT      0
     C                   Z-ADD     I_CCLBL       I_PSTA
     C                   MOVEL     'D'           I_CADC
     C                   ELSE
     C                   Z-SUB     I_CCLBL       I_PSTA
     C                   MOVEL     'C'           I_CADC
     C                   ENDIF
 
      * Value date
     C                   Z-ADD     BJRDNB        I_VALD
 
      * Entry generation
     C                   EXSR      SHADOW_EG
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Net shadow account entry generation
      ********************************************************************
     C     NET_EG        BEGSR
 
      * Posting Amount
      * Child A/c Debit/Credit ind
 
     C     TOTAL         IFGT      0
     C                   Z-ADD     TOTAL         I_PSTA
     C                   MOVEL     'D'           I_CADC
     C                   ELSE
     C                   Z-SUB     TOTAL         I_PSTA
     C                   MOVEL     'C'           I_CADC
     C                   ENDIF
 
      * Value date
     C                   Z-ADD     VALD          I_VALD
 
      * Entry generation
     C     TOTAL         IFNE      0
     C                   EXSR      SHADOW_EG
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Shadow account entry generation
      ********************************************************************
     C     SHADOW_EG     BEGSR
 
     C                   CALLB     'RE100609'
 
      * Return code
      * Error Message
      * Option
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
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
     C                   PARM                    I_CACD                                       CGL029
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
     C                   PARM                    I_SACD                                       CGL029
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
 
      * Show retail a/c numbers
 
     C     I_CRNO        COMP      0                                  3535      *
 
      * Edit ledger balance
      * and  ledger balance dr/cr indicator
 
     C     I_CLDBL       IFGT      0
     C                   Z-ADD     I_CLDBL       w_AMT            15 0
     C                   MOVEL     'DR'          R_LDRCR
     C                   ELSE
     C                   Z-SUB     I_CLDBL       w_AMT
     C                   MOVEL     'CR'          R_LDRCR
     C                   ENDIF
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      w_AMT         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_LDBL
 
      * Edit cleared balance
      * and  cleared balance dr/cr indicator
 
     C     I_CCLBL       IFGT      0
     C                   Z-ADD     I_CCLBL       w_AMT
     C                   MOVEL     'DR'          R_CDRCR
     C                   ELSE
     C                   Z-SUB     I_CCLBL       w_AMT
     C                   MOVEL     'CR'          R_CDRCR
     C                   ENDIF
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      w_AMT         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_CLBL
 
     C     CLBLPost      COMP      'Y'                                    40    *
 
     C                   Z-ADD     4             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     SOURCE
 
     C                   MOVEL     'Y'           AC_Reported
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Report entry
      ********************************************************************
     C     REP_ENTRY     BEGSR
 
      * Edit information text
 
     C     E_XRFI        IFEQ      'ZS '
     C                   MOVEL     E_OTST        INFLNK
     C                   ELSE
     C                   MOVEL     *BLANK        INFLNK
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
      * Report date total
      ********************************************************************
     C     REP_DATTOT    BEGSR
 
      * Edit posting total
      * and  posting total dr/cr indicator
 
     C     TOTAL         IFGT      0
     C                   Z-ADD     TOTAL         w_AMT
     C                   MOVEL     'CR'          R_TDC
     C                   ELSE
     C                   Z-SUB     TOTAL         w_AMT
     C                   MOVEL     'DR'          R_TDC
     C                   ENDIF
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      w_AMT         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_TOT
 
     C                   Z-ADD     3             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     NDATTOT
 
      * Zeroize total
 
     C                   Z-ADD     *ZERO         TOTAL            15 0
 
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
     C                   PARM                    I_CACD                                       CGL029
     C                   PARM                    I_CASN            2 0
      * Child retail no.
      * Child a/c profit centre
      * Child a/c account section
     C                   PARM                    I_CRNO           10 0
     C                   PARM                    I_CPRF            4
     C                   PARM                    I_CACS            2
      * Child Ledger Balance
      * Child Cleared Balance
     C                   PARM                    I_CLDBL          15 0
     C                   PARM                    I_CCLBL          15 0
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
     C                   PARM                    I_SACD                                       CGL029
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
 
      * Event Control date
     C                   PARM                    I_EvtCtlDat       5 0
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * Open files
     C                   OPEN      RE100611P1
 
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
 
      * Key lists
 
     C     GLACBLK       KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     RECMLCK       KLIST
     C                   KFLD                    I_HIER
     C                   KFLD                    I_CBRC
     C                   KFLD                    I_CCUS
     C                   KFLD                    I_CCCY
     C                   KFLD                    I_CACD
     C                   KFLD                    I_CASN
 
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
** #_PCMODE
1PC
5PC
** #_PCSPOS
  GE-IC
  GE-SF
