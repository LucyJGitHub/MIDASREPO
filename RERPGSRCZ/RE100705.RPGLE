     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Balances Purge')              *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100705 - Cash Management Balances Purge                    *
      *                                                               *
      *  Function: This module purges value date balances on          *
      *            zero balancing accounts.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 232111             Date 25Feb13               *
      *                 AR676213           Date 19Nov10               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 216421             Date 06Apr03               *
      *                 215675             Date 10Mar03               *
      *                 213569             Date 10Feb03               *
      *                 214360             Date 03Feb03               *
      *                 213196             Date 21Jan03               *
      *                 212904  *REWRITE   Date 14Jan03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  232111 - Balance purge is incomplete if previous balance     *
      *           purge request was not executed.  Amended program    *
      *           to include in the purge amount the historic balance *
      *           of the day after the last purge request date.       *
      *         - Applied for AR976539. (Child:AR976540)              *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216421 - External tops are back-valued                       *
      *  215675 - Sweep is not stopped when account is inactive       *
      *  213569 - Charges errors                                      *
      *           Generate charges for external tops/sweeps           *
      *  214360 - Cash Management Deferred Posting                    *
      *  213196 - Holidays are not checked for top/sweeps             *
      *  212904 - Balance purge errors                                *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRECMPRL0  UP   E           K DISK    INFSR(*PSSR)
     FRECMLCHPD IF   E           K DISK    INFSR(*PSSR)
     FRECMPRL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMPRD0:RECMPRD3)
     F                                     PREFIX(P_)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     FRECMBRL1  IF   E           K DISK    INFSR(*PSSR)
     FREHISL    IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(REHISPPF)
     F                                     PREFIX(B_)
     FREICSLPD  O  A E           K DISK    INFSR(*PSSR)
     FRE100705P1O    E             PRINTER INFSR(*PSSR) USROPN
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
 
 
      * Account Status
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
 
 
     D                 DS
     D I_ChildSTAT             1     26
     D I_ChildSTATX            1      5                                         215675
     D*I_ChildSTATX************1      4                                         215675
     D                 DS
     D I_ParentSTAT            1     26
     D I_ParentSTATX           1      5                                         215675
     D*I_ParentSTATX***********1      4                                         215675
 
 
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
 
      * Last Parent Account ID
     D                 DS
     D*L_PACCID*               1     18                                                       CGL029
     D L_PACCID                1     24                                                       CGL029
     D L_PBRC                  1      3
     D*L_PCUS***               4      9S 0                                                    CSD027
     D L_PCUS                  4      9A                                                      CSD027
     D L_PCCY                 10     12
     D*L_PACD***              13     16S 0                                                    CGL029
     D*L_PASN***              17     18S 0                                                    CGL029
     D L_PACD                 13     22S 0                                                    CGL029
     D L_PASN                 23     24S 0                                                    CGL029
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** A/C Code Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      ** File Information Data Structure for RE100705P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
     IRECMPRD0
     I                                          PRHIER        L2
     I                                          PRLINK        L1
 
 
      /SPACE 5
 
      * Access Hierarchy Detail
 
     C   L2              EXSR      ACS_HIER
 
      * Access Hierarchy Link
 
     C   L1              EXSR      ACS_LINK
 
      * Record read
 
     C     No_Hierarchy  IFEQ      'Y'
     C     No_Link       OREQ      'Y'
     C                   MOVEL     'N'           Record_Read       1
     C                   ELSE
     C                   MOVEL     'Y'           Record_Read
     C                   ENDIF
 
      * Processed
 
     C                   MOVEL     'Y'           PRPROC
     C                   EXCEPT    URECMPRD0
 
      * Process link
 
     CL1   Record_Read   IFEQ      'Y'
     CL1                 EXSR      PROC_LINK
     CL1                 ENDIF
 
      *  Produce end of report
 
     CLR                 MOVEL     '*END   '     X_OPTN
     CLR                 EXSR      ZEROBAL_EG
     CLR                 EXSR      END_OF_REP
     CLR                 CLOSE     RE100705P1
 
      * Log event
      * =========
     CLR   I_TOPACS      IFEQ      'Y'
     CLR   EntriesGen    ANDEQ     'Y'
     CLR                 EXSR      LOGEVENT
     CLR                 ENDIF
      /SPACE 5
      *****************************************************************
      * Process link
      *****************************************************************
     C     PROC_LINK     BEGSR
 
      * Set child a/c details
 
     C                   EXSR      SET_CHILD
 
      * If this is a Top A/c and the desination is defined
 
     C     CLCCAT        IFEQ      'T'
     C     ZDDEST        ANDNE     *BLANK
 
      *   Determine destination a/c
      *   (This sets the parent a/c details to that of the destination a/c)
 
     C                   EXSR      DET_DESTAC
 
     C                   ELSE
 
      * Set parent a/c details
 
     C                   EXSR      SET_PARENT
     C                   ENDIF
 
      * Initialize fields
 
     C                   Z-SUB     1             I_NASN
 
      * If exceptions, log them, otherwise
      *  Purge value dated balances
 
     C                   SELECT
     C*****I_ChildSTATX**WHENNE    'NNNN'                                       215675
     C     I_ChildSTATX  WHENNE    'NNNNN'                                      215675
     C                   MOVEL     I_ChildSTAT   AccountSTAT
     C                   EXSR      LOG_CMX
     C*****I_ParentSTATX*WHENNE    'NNNN'                                       215675
     C     I_ParentSTATX WHENNE    'NNNNN'                                      215675
     C                   MOVEL     I_ParentSTAT  AccountSTAT
     C                   EXSR      LOG_CMX
     C                   OTHER
     C                   EXSR      PURGE
     C                   ENDSL
 
      * Commit
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Set child a/c details
      ********************************************************************
     C     SET_CHILD     BEGSR
 
     C                   MOVEL     CLCBRC        BRC
     C                   MOVEL     CLCCUS        CUS
     C                   MOVEL     CLCCCY        CCY
     C                   MOVEL     CLCACD        ACD
     C                   MOVEL     CLCASN        ASN
 
      * Access a/c and a/c code details:
 
     C                   MOVEL     'CHILD '      AcType
     C                   EXSR      ACS_ACCNT
     C                   EXSR      ACS_ACOD
 
      * Determine A/c Status
 
     C                   EXSR      DET_AC_STATUS
 
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   MOVEL     CLCBRC        I_CBRC
     C**********         Z-ADD     CLCCUS        I_CCUS                                       CSD027
     C                   EVAL      I_CCUS =      CLCCUS                                       CSD027
     C                   MOVEL     CLCCCY        I_CCCY
     C                   Z-ADD     CLCACD        I_CACD
     C                   Z-ADD     CLCASN        I_CASN
      * Child retail no.
      * Child a/c name
      * Child a/c profit centre
      * Child a/c account section
     C                   Z-ADD     ACNO          I_CRNO
     C                   MOVEL     ANAM          I_CANM
     C                   MOVEL     PRFC          I_CPRF
     C                   MOVEL     A5ACSC        I_CACS
      * Child a/c status
     C                   MOVEL     AccountSTAT   I_ChildSTAT
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Set parent a/c details
      ********************************************************************
     C     SET_PARENT    BEGSR
 
     C                   MOVEL     CLPBRC        BRC
     C                   MOVEL     CLPCUS        CUS
     C                   MOVEL     CLPCCY        CCY
     C                   MOVEL     CLPACD        ACD
     C                   MOVEL     CLPASN        ASN
 
      * If a new parent a/c
      * Access a/c and a/c code details:
 
     C     ACCID         IFNE      L_PACCID
 
     C                   MOVEL     'PARENT'      AcType
     C                   EXSR      ACS_ACCNT
     C                   EXSR      ACS_ACOD
 
      * Determine A/c Status
 
     C                   EXSR      DET_AC_STATUS
 
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   MOVEL     CLPBRC        I_PBRC
     C**********         Z-ADD     CLPCUS        I_PCUS                                       CSD027
     C                   EVAL      I_PCUS =      CLPCUS                                       CSD027
     C                   MOVEL     CLPCCY        I_PCCY
     C                   Z-ADD     CLPACD        I_PACD
     C                   Z-ADD     CLPASN        I_PASN
      * Parent retail no.
      * Parent a/c name
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   Z-ADD     ACNO          I_PRNO
     C                   MOVEL     ANAM          I_PANM
     C                   MOVEL     PRFC          I_PPRF
     C                   MOVEL     A5ACSC        I_PACS
     C                   MOVEL     A5ACTY        I_PATY
      * Parent a/c status
     C                   MOVEL     AccountSTAT   I_ParentSTAT
      * Parent Account Narrative
     C                   MOVEL     ZLPNAR        I_PNAR
 
     C                   MOVEL     ACCID         L_PACCID
 
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *****************************************************************
      * Purge value dated balances
      *****************************************************************
     C     PURGE         BEGSR
 
      * If new currency, access currency
 
     C     CLCCCY        IFNE      L_CCY
     C                   MOVEL     CLCCCY        L_CCY             3
     C                   EXSR      ACS_CURR
     C                   ENDIF
 
      * Zeroize posting total
 
     C                   Z-ADD     0             POST_TOTAL       15 0
 
      * Report the source account
 
     C                   EXSR      REP_SACCNT
 
      * If maximum debit or maximum credit are zero, there is no maximum
 
     C     PRMAXD        IFEQ      *ZERO
     C                   Z-ADD     *HIVAL        PRMAXD
     C                   ENDIF
     C     PRMAXC        IFEQ      *ZERO
     C                   Z-ADD     *HIVAL        PRMAXC
     C                   ENDIF
 
      * Determine 'Purge From Date'
 
     C                   EXSR      DET_PRGFRMDAT
      *                                                                                       212904
      *    If purging  from Link Date and cleared balance on association date is swept,       212904
      *    include previous balance to post_total so the swept balance is excluded from       212904
      *    the purge.                                                                         212904
      *                                                                                       212904
     C                   Move      'N'           W_SCBD            1                          212904
      *                                                                                       212904
     C     PurgFrLnkDt   Ifeq      'Y'                                                        212904
     C     ZLSCBD        Andeq     'Y'                                                        212904
     C     PurgFrLnkDt   Oreq      'N'                                                        232111
     C     REHISLKF      SETLL     REHISPPF                                                   212904
     C     REHISLK       READPE    REHISPPF                               60    *             212904
     C     *IN60         Ifeq      *Off                                                       212904
     C                   Sub       B_HISB        POST_TOTAL                                   212904
     C                   Z-add     B_HISB        W_HISB           15 0                        212904
     C                   Move      'Y'           W_SCBD            1                          212904
     C                   Endif                                                                212904
     C                   Endif                                                                212904
 
      * Read first child a/c balance
 
     C     REHISLKF      SETLL     REHISPPF
     C     REHISLK       READE     REHISPPF                               60    *
 
      * Do until more more child a/c balances are read
 
     C     *IN60         DOWEQ     '0'
 
      * Report balance
 
     C                   EXSR      REP_BALANCE
 
      * Accumulate posting total
 
     C                   SUB       B_DMVT        POST_TOTAL       15 0          212904
     C                   ADD       B_CMVT        POST_TOTAL       15 0          212904
     C*******************SUB       B_HISB        POST_TOTAL       15 0          212904
 
      * Read next child a/c balance
 
     C     REHISLK       READE     REHISPPF                               60    *
 
     C                   ENDDO
 
      * Balance purge entry generation
      * Report posting total
 
     C     POST_TOTAL    IFNE      0
     C                   EXSR      PURGE_EG
     C                   EXSR      REP_POSTTOTAL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Report the source account
      ********************************************************************
     C     REP_SACCNT    BEGSR
 
      * Show retail a/c numbers
 
     C     I_CRNO        COMP      0                                  3535      *
 
      * Edit maximum debit and maximum credit
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      PRMAXD        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_MAXD
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      PRMAXC        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_MAXC
 
     C                   Z-ADD     3             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     SOURCE
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Report balance
      ********************************************************************
     C     REP_BALANCE   BEGSR
 
      * Edit history date
 
     C                   Z-ADD     B_HISD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_HISD
 
      * Edit history balance
 
     C     B_HISB        IFGT      0
     C                   Z-ADD     B_HISB        w_AMT            15 0
     C                   MOVEL     'DR'          R_BDC
     C                   ELSE
     C                   Z-SUB     B_HISB        w_AMT
     C                   MOVEL     'CR'          R_BDC
     C                   ENDIF
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      w_AMT         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_HISB
                                                                                212904
      * Edit movement                                                           212904
                                                                                212904
     C     B_DMVT        SUB       B_CMVT        w_AMT                          212904
                                                                                212904
     C* if purging from link date and cleared belance was swept,                212904
     C* do not include swept balance in report.                                 212904
     C     W_SCBD        IFEQ      'Y'                                          212904
     C                   Add       W_HISB        w_AMT                          212904
     C                   Move      'N'           W_SCBD                         212904
     C                   Endif                                                  212904
     C*                                                                         212904
     C     w_AMT         IFGT      0                                            212904
     C                   MOVEL     'DR'          R_MDC                          212904
     C                   ELSE                                                   212904
     C                   Z-SUB     w_AMT         w_AMT                          212904
     C                   MOVEL     'CR'          R_MDC                          212904
     C                   ENDIF                                                  212904
                                                                                212904
     C                   MOVE      *ZERO         ZFIELD                         212904
     C                   MOVE      w_AMT         ZFIELD                         212904
     C                   EXSR      ZEDIT                                        212904
     C                   MOVE      ZFIELD        R_MOVE                         212904
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     BALANCE
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Report posting total
      ********************************************************************
     C     REP_POSTTOTAL BEGSR
 
      * Edit posting total
      * and  posting total dr/cr indicator
 
     C     POST_TOTAL    IFGT      0
     C                   Z-ADD     POST_TOTAL    w_AMT            15 0
     C                   MOVEL     'DR'          R_TDC
     C                   ELSE
     C                   Z-SUB     POST_TOTAL    w_AMT
     C                   MOVEL     'CR'          R_TDC
     C                   ENDIF
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      w_AMT         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_TOT
 
     C                   Z-ADD     3             CHLINE            3 0
     C                   EXSR      PAG
     C     O_EntriesGen  COMP      'Y'                                    45
     C                   WRITE     POSTTOTAL
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Balance purge entry generation
      ********************************************************************
     C     PURGE_EG      BEGSR
 
      * Ensure maximum credit/debit is not exceeded
 
     C     POST_TOTAL    IFGT      0
     C                   Z-ADD     POST_TOTAL    w_AMT
     C     w_AMT         IFGT      PRMAXD
     C                   Z-ADD     PRMAXD        POST_TOTAL
     C                   ENDIF
     C                   ELSE
     C                   Z-SUB     POST_TOTAL    w_AMT
     C     w_AMT         IFGT      PRMAXC
     C                   Z-SUB     PRMAXC        POST_TOTAL
     C                   ENDIF
     C                   ENDIF
 
      * Posting Amount
      * Child A/c Debit/Credit ind
 
     C     POST_TOTAL    IFGT      0
     C                   Z-ADD     POST_TOTAL    I_PSTA
     C                   MOVEL     'D'           I_CADC
     C                   ELSE
     C                   Z-SUB     POST_TOTAL    I_PSTA
     C                   MOVEL     'C'           I_CADC
     C                   ENDIF
 
      * Value date
     C                   Z-ADD     BJRDNB        I_VALD
 
      * Sweep Description
     C                   EVAL      I_SDES = 'ZERO BALANCE'
 
      * Sweep Type
     C                   MOVEL     'Z'           I_STYP
 
      * Target Balance
     C                   MOVEL     'N'           I_TBAL
 
      * Cleared Bal Sweep on Assoc Date
     C                   MOVEL     'N'           I_CBSA
 
      * Entry generation
     C                   EXSR      ZEROBAL_EG
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Zero balancing entry generation
      ********************************************************************
     C     ZEROBAL_EG    BEGSR
 
     C                   CALLB     'RE100608'
 
      * Return code
      * Error Message
      * Option
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
     C                   PARM                    X_OPTN
 
      * INPUTS
      * Mode
     C                   PARM      'PUR'         I_MODE            3
      * Time
     C                   PARM      ReqTIME       I_TIME            6
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Branch                                                        213569
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
     C                   PARM      CDBRCA        I_BRCA            3            213569
      * Link ID
     C                   PARM      CLLINK        I_LINK            9 0
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
     C                   PARM      CLCCAT        I_CCAT            1
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
     C                   PARM      CLLEVL        I_LEVL            2 0
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
     C                   PARM      ZLCNAR        I_CNAR           30
     C                   PARM                    I_PNAR           30
      * Sweep/Top
     C                   PARM      'B'           I_SWP_TOP         1
      * Sweeping Holiday Convention                                             213196
     C                   PARM      ZDSHOC        I_SHOC            1            213196
      * Floor Limit for Top
      * Floor Limit for Sweep
      * Transaction Type - Top
      * Transaction Type - Sweep
     C                   PARM      ZLFLFT        I_FLFT           15 0
     C                   PARM      ZLFLFS        I_FLFS           15 0
     C                   PARM      ZDTYPT        I_TYPT            5
     C                   PARM      ZDTYPS        I_TYPS            5
 
      * Maximum Debit Value/Debit Count in a Day Exceeded
     C                   PARM      'N'           I_Max_Dr_Excd     1
      * Destination
      * Destination Type
      * Sender's Correspondent
      * Receiver's Correspondent
      * MT202 Cover Message Required
      * MT103 Value Date Offset
     C                   PARM      ZDDEST        I_DEST           18
     C                   PARM      ZDDSTT        I_DSTT            1
     C                   PARM      ZDSNDC        I_SNDC            2
     C                   PARM      ZDRCVC        I_RCVC           11
     C                   PARM      ZDMCMR        I_MCMR            1
     C                   PARM      ZDMVDO        I_MVDO            1
      * MT101 Charges
      * MT101 Charges Account
      * MT101 Charges Amount
      * MT101 Instruction Code
      * MT103 Charges
      * MT103 Charges Account
      * MT103 Charges Amount
      * MT103 Instruction Code
      * MT103 Bank Operation Code
     C                   PARM      ZDCHG1        I_CHG1            3
     C**********         PARM      ZDCAC1        I_CAC1           18                          CGL029
     C                   PARM      ZDCAC1        I_CAC1           24                          CGL029
     C                   PARM      ZDCAM1        I_CAM1           15 0
     C                   PARM      ZDICD1        I_ICD1            4
     C                   PARM      ZDCHG3        I_CHG3            3
     C**********         PARM      ZDCAC3        I_CAC3           18                          CGL029
     C                   PARM      ZDCAC3        I_CAC3           24                          CGL029
     C                   PARM      ZDCAM3        I_CAM3           15 0
     C                   PARM      ZDICD3        I_ICD3            4
     C                   PARM      ZDBOCD        I_BOCD            4
      * External Account 1
      * External Account 2
      * External Account 3
      * External Account 4
      * External Account 5
     C                   PARM      ZDEXA1        I_EXA1           35
     C                   PARM      ZDEXA2        I_EXA2           35
     C                   PARM      ZDEXA3        I_EXA3           35
     C                   PARM      ZDEXA4        I_EXA4           35
     C                   PARM      ZDEXA5        I_EXA5           35
      * Top a/c Sweep Type                                                      214360
      * Deferred Posting                                                        216421
      * Deferred Posting Zero Narrative                                         216421
     C                   PARM      *BLANK        I_TAST            1            214360
     C                   PARM      *BLANK        I_DEFP            1            216421
     C                   PARM      *BLANK        I_DEFZ            1            216421
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
     C                   PARM      *ZERO         I_TopBalance     15 0
     C                   PARM      99999999999999I_TopOverDft     15 0
      * Entries generated
     C                   PARM      'N'           O_EntriesGen      1
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN ENTRY GENERATION'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     O_EntriesGen  IFEQ      'Y'
     C                   MOVEL     'Y'           EntriesGen        1
     C                   ENDIF
 
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
      * Determine 'Purge From Date'
      ********************************************************************
     C     DET_PRGFRMDAT BEGSR
                                                                                              212904
     C                   MOVEL     'Y'           PurgFrLnkDt       1                          212904
 
      * Find last link date of the link from link changes history
 
     C                   MOVEL     'L'           LinkUnLink
     C                   Z-ADD     *HIVAL        PurgFromDate
     C     RECMLCHK      SETLL     RECMLCHPD
     C     RECMLCHKP     READPE    RECMLCHPD                              60
     C     *IN60         IFEQ      *OFF
     C                   Z-ADD     LCLUDT        PurgFromDate
     C                   ELSE
     C                   Z-ADD     CDDEFR        PurgFromDate
     C                   ENDIF
 
      * Find last purge date of the link from balance purge requested file
 
     C                   Z-ADD     BJRDNB        ReqDate
     C     RECMPRK       SETLL     RECMPRD3
     C     RECMPRKP      READPE    RECMPRD3                               60
     C     *IN60         IFEQ      *OFF
     C     P_PRRDAT      ADD       1             PurgFromDate
     C                   Move      'N'           PurgFrLnkDt                                  212904
     C                   ENDIF
 
      * Purge From date can't be prior to the back-value date
 
     C     PurgFromDate  IFLT      BackValuDate
     C                   Z-ADD     BackValuDate  PurgFromDate
     C                   Move      'N'           PurgFrLnkDt                                  212904
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
     C     *IN60         IFEQ      '1'
     C                   EVAL      X_ERMS = 'BAD ' + AcType + ' A/C:'
     C                                      + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access A/c code
      ********************************************************************
     C     ACS_ACOD      BEGSR
 
     C                   MOVEL     ACOD          X_ACCD
     C                   CALLB     'ZAACSACOD'
     C**********         PARM                    X_ACCD            4                          CGL029
     C                   PARM                    X_ACCD           10                          CGL029
     C                   PARM                    SDACOD
 
      * Database error if a/c code not found
 
     C     A5ACCD        IFEQ      *BLANK
     C                   EVAL      X_ERMS = 'BAD A/C CODE:' + X_ACCD
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
     C                   PARM      CLCCCY        CCY               3
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
     C                   PARM      PRHIER        I_HIER            9 0
      * Hierarchy Type
     C                   PARM      *BLANK        I_HTYP            2
 
     C                   PARM                    O_CMHD
     C                   PARM                    O_ZSHD
     C                   PARM                    O_GAHD
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'BAD HIERARCHY DETAIL:' + A_HIER
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Record if no record found
 
     C     X_RTCD        IFEQ      '*NOREC'
     C                   EVAL      No_Hierarchy = 'Y'
     C                   ELSE
     C                   EVAL      No_Hierarchy = 'N'
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
     C                   PARM      PRHIER        I_HIER            9 0
      * Hierarchy Type
     C                   PARM      'ZS'          I_HTYP            2
      * Link ID
     C                   PARM      PRLINK        I_LINK            9 0
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
 
     C                   PARM                    O_CMHL
     C                   PARM                    O_ZSHL
     C                   PARM                    O_GAHL
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'BAD HIERARCHY LINK:' +
     C                                       A_HIER + A_LINK
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Record if no record found
 
     C     X_RTCD        IFEQ      '*NOREC'
     C                   EVAL      No_Link = 'Y'
     C                   ELSE
     C                   EVAL      No_Link = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Determine A/c Status
      ********************************************************************
     C     DET_AC_STATUS BEGSR
 
      * Initialise
     C                   MOVE      'N'           Closed
     C                   MOVE      'N'           BlockZBSW
     C                   MOVE      'N'           ReferDR
     C                   MOVE      'N'           ReferCR
     C                   MOVE      'N'           BlockDR
     C                   MOVE      'N'           BlockCR
     C                   MOVE      'N'           Inactive                       215675
     C                   MOVE      'N'           Bankrpt
     C                   MOVE      'N'           Baddebt
 
     C     RECI          IFNE      'D'
     C                   MOVE      'Y'           Closed
     C                   ENDIF
      * Sweeping Blocked?
     C     RECMBRK       CHAIN     RECMBRD0                           99        *
     C  N99              MOVE      'Y'           BlockZBSW
      * Test
     C                   TESTB     '0'           RETB                     99
     C   99              MOVE      'Y'           ReferDR
     C                   TESTB     '1'           RETB                     99
     C   99              MOVE      'Y'           ReferCR
     C                   TESTB     '2'           RETB                     99
     C   99              MOVE      'Y'           BlockDR
     C                   TESTB     '3'           RETB                     99
     C   99              MOVE      'Y'           BlockCR
     C                   TESTB     '4'           RETB                     99    215675
     C   99              MOVE      'Y'           Inactive                       215675
     C                   TESTB     '6'           RETB                     99
     C   99              MOVE      'Y'           Bankrpt
     C                   TESTB     '7'           RETB                     99
     C   99              MOVE      'Y'           Baddebt
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Log cash management exceptions
      ********************************************************************
     C     LOG_CMX       BEGSR
 
     C     ZLSTYP        IFEQ      'Z'
     C                   EVAL      I_EXCP = 'ZERO BALANCING NOT DONE.'
     C                   ELSE
     C                   EVAL      I_EXCP = 'SWEEPING NOT DONE.'
     C                   ENDIF
 
     C     Closed        IFEQ      'Y'
     C                   EVAL      I_REAS =  AcType + ' account is CLOSED.'
     C                   ENDIF
     C     Bankrpt       IFEQ      'Y'
     C                   EVAL      I_REAS = AcType + ' account is BANKRUPT.'
     C                   ENDIF
     C     Baddebt       IFEQ      'Y'
     C                   EVAL      I_REAS = AcType + ' account is BAD-DEBT.'
     C                   ENDIF
     C     BlockZBSW     IFEQ      'Y'
     C                   EVAL      I_REAS = AcType + ' account is BLOCKED.'
     C                   ENDIF
     C     Inactive      IFEQ      'Y'                                          215675
     C                   EVAL      I_REAS = AcType + ' account is INACTIVE.'    215675
     C                   ENDIF                                                  215675
 
      * Write to the cash management exception file
 
     C                   EXSR      WRT_CMX
 
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
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
      * Link ID
     C                   PARM      CLLINK        I_LINK            9 0
      * Exception
      * Reason
     C                   PARM                    I_EXCP           60
     C                   PARM                    I_REAS           60
      * Zero Balancing/Sweeping Entry
      * Original Entry
     C                   PARM      *BLANK        I_ZSEN           60
     C                   PARM      *BLANK        I_OREN          330
      * Mode
      * Time
     C                   PARM                    I_MODE            3
     C                   PARM      ReqTIME       I_TIME            6
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN WRITE TO RECMEXPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      *  Determine destination a/c
      ********************************************************************
     C     DET_DESTAC    BEGSR
 
     C                   CALLB     'REZDESTAC'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Hierarchy ID
      * Child currency
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CLCCCY        I_CCCY            3
      * Destination
      * Destination Type
      * Sender's Correspondent
     C                   PARM      ZDDEST        I_SDEST          18
     C                   PARM      ZDDSTT        I_SDSTT           1
     C                   PARM      ZDSNDC        I_SSNDC           2
 
      * OUTPUTS
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    O_PBRC            3
     C**********         PARM                    O_PCUS            6 0                        CSD027
     C                   PARM                    O_PCUS            6                          CSD027
     C                   PARM                    O_PCCY            3
     C**********         PARM                    O_PACD            4 0                        CGL029
     C                   PARM                    O_PACD           10 0                        CGL029
     C                   PARM                    O_PASN            2 0
      * Parent retail no.
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   PARM                    O_PRNO           10 0
     C                   PARM                    O_PPRF            4
     C                   PARM                    O_PACS            2
     C                   PARM                    O_PATY            1
      * Parent a/c status
     C                   PARM                    O_ParentSTAT     26
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix                3 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     Ix            ORGT      0
     C                   EVAL      X_ERMS = 'ERROR IN DESTINATION A/C:'
     C                                      + ZDDEST + ZDDSTT
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   MOVEL     O_PBRC        I_PBRC
     C**********         Z-ADD     O_PCUS        I_PCUS                                       CSD027
     C                   EVAL      I_PCUS =      O_PCUS                                       CSD027
     C                   MOVEL     O_PCCY        I_PCCY
     C                   Z-ADD     O_PACD        I_PACD
     C                   Z-ADD     O_PASN        I_PASN
      * Parent retail no.
      * Parent a/c name
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   Z-ADD     O_PRNO        I_PRNO
     C                   MOVEL     *BLANK        I_PANM
     C                   MOVEL     O_PPRF        I_PPRF
     C                   MOVEL     O_PACS        I_PACS
     C                   MOVEL     O_PATY        I_PATY
      * Parent a/c status
     C                   MOVEL     O_ParentSTAT  I_ParentSTAT
      * Parent Account Narrative
     C                   MOVEL     ZDENAR        I_PNAR
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Log an event
      ********************************************************************
     C     LOGEVENT      BEGSR
 
      * 'Cash management input cycle sweeping - executed for time &1'
     C                   EVAL      #MSGID = 'RE75427 '
     C                   EVAL      #MSGDT = %subst(ReqTIME :1:2) + ':' +
     C                                      %subst(ReqTIME :3:2) + ':' +
     C                                      %subst(ReqTIME :5:2)
 
      * Get the message details
 
     C                   CALLB     'ZAMSGRTVMS'
     C                   PARM      *BLANK        ReturnCode       10
     C                   PARM      *BLANK        CompMsg        3000
     C                   PARM                    #MSGID
     C                   PARM                    #MSGDT
     C                   PARM      'GBREUSRMSG'  #MSGF
     C                   PARM      '*LIBL  '     #MSGFL
     C                   PARM      '0'           Level             1
 
      * Write an INFORMATION record to the input cycle sweeps log file
 
     C                   Z-ADD     PSRunDate     ILDATE
     C                   TIME                    CurTIME           6 0
     C                   Z-ADD     CurTIME       ILTIME
     C                   MOVE      'I'           ILTYPE
     C                   MOVEL     CompMsg       ILNARR
     C                   MOVEL     PSJobName     ILJBNM
     C                   MOVEL     PSUser        ILJBUS
     C                   MOVEL     PSJobNo       ILJBNO
     C                   WRITE     REICSLD0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * INPUTS
      * Top Accounts
     C                   PARM                    I_TOPACS          1
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Clear data structures
 
     C                   CLEAR                   O_CMHD
     C                   CLEAR                   O_ZSHD
     C                   CLEAR                   O_GAHD
     C                   CLEAR                   O_CMHL
     C                   CLEAR                   O_ZSHL
     C                   CLEAR                   O_GAHL
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * Open files
     C                   OPEN      RE100705P1
 
      * Register P1 printer file with RCF
     C                   EXSR      RCFP1
 
      * Determine the back value date
 
     C     BJRDNB        SUB       BJBVPD        BackValuDate      5 0
 
      * Define
 
     C                   MOVE      No_Hierarchy  No_Hierarchy      1
     C                   MOVE      No_Link       No_Link           1
 
      * Request Time
 
     C                   MOVEL     '000000'      ReqTIME           6
 
      * key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     RECMLCHK      KLIST
     C                   KFLD                    PRHIER
     C                   KFLD                    PRLINK
     C                   KFLD                    LinkUnLink        1
     C                   KFLD                    PurgFromDate      5 0
     C     RECMLCHKP     KLIST
     C                   KFLD                    PRHIER
     C                   KFLD                    PRLINK
     C                   KFLD                    LinkUnLink
     C     RECMPRK       KLIST
     C                   KFLD                    PRHIER
     C                   KFLD                    PRLINK
     C                   KFLD                    ReqDate           5 0
     C     RECMPRKP      KLIST
     C                   KFLD                    PRHIER
     C                   KFLD                    PRLINK
     C     RECMBRK       KLIST
     C                   KFLD                    CDHIER
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C     REHISLKF      KLIST
     C                   KFLD                    CLCBRC
     C                   KFLD                    CLCCUS
     C                   KFLD                    CLCCCY
     C                   KFLD                    CLCACD
     C                   KFLD                    CLCASN
     C                   KFLD                    PurgFromDate
     C     REHISLK       KLIST
     C                   KFLD                    CLCBRC
     C                   KFLD                    CLCCUS
     C                   KFLD                    CLCCCY
     C                   KFLD                    CLCACD
     C                   KFLD                    CLCASN
     C     LINKK         KLIST
     C                   KFLD                    CDHIER
     C                   KFLD                    CLLINK
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
     ORECMPRD0  E            URECMPRD0
     O                       PRPROC
