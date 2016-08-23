     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE COB Zero Balancing/Sweeping & Group A/C')     *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100713 - COB Zero Balancing/Sweeping & Group A/C Replication
      *                                                               *
      *  Function:  This program does the COB zero balancing/sweeping *
      *             and group a/c replication.                        *
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
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 217028             Date 24Apr03               *
      *                 216106             Date 07Apr03               *
      *                 215675             Date 10Mar03               *
      *                 213569             Date 10Feb03               *
      *                 214360             Date 03Feb03               *
      *                 214552             Date 03Feb03               *
      *                 213196             Date 21Jan03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  217028 - Error with sweeping gross                           *
      *  216106 - Top a/c sweep freq must be 'D' for deferred posting *
      *  215675 - Sweep is not stopped when account is inactive       *
      *  213569 - Charges errors                                      *
      *           Generate charges for external tops/sweeps           *
      *  214360 - Cash Management Deferred Posting                    *
      *  214552 - Input cycle sweeping frequency                      *
      *  213196 - Holidays are not checked for top/sweeps             *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRECMHDL3  IP   E           K DISK    INFSR(*PSSR)
     FRECMHLL2  UF   E           K DISK    INFSR(*PSSR)
     FREZSHLL0  UF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     FRECMBRL1  IF   E           K DISK    INFSR(*PSSR)
     FGLAPNAPD  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D I_CACD          S             10  0                                                    CGL029
     D I_SACD          S             10  0                                                    CGL029
     D I_PACD          S             10  0                                                    CGL029
     D I_CAC1          S             24                                                       CGL029
     D I_CAC3          S             24                                                       CGL029
     D X_ACCD          S             10                                                       CGL029
     D BlankAC         S             24                                                       CGL029
 
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
     D***S_ACCID               108    125                                                     CGL029
     D S_ACCID1Temp          108    119                                                       CGL029
     D S_ACCID2Temp          282    291                                                       CGL029
     D S_ACCID3Temp          124    125                                                       CGL029
                                                                                              CGL029
      ** Shadow Account                                                                       CGL029
     D S_ACCID                 1     24                                                       CGL029
     D S_ACCID1                1     12                                                       CGL029
     D S_ACCID2               13     22                                                       CGL029
     D S_ACCID3               23     24                                                       CGL029
                                                                                              CGL029
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
     D ShadowSTAT              1     26
     D ShadowSTATX             1      5                                         215675
     D*ShadowSTATX*************1      4                                         215675
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
 
      * Last Parent Account ID
     D                 DS
     D***L_PACCID                1     18                                                     CGL029
     D L_PACCID                1     24                                                       CGL029
     D L_PBRC                  1      3
     D*L_PCUS***               4      9S 0                                                    CSD027
     D L_PCUS                  4      9A                                                      CSD027
     D L_PCCY                 10     12
     D***L_PACD*                13     16S 0                                                  CGL029
     D***L_PASN*                17     18S 0                                                  CGL029
     D L_PACD                 13     22S 0                                                    CGL029
     D L_PASN                 23     24S 0                                                    CGL029
 
 
      * Cash Management COB Control DTAARA
     D RECMCCTL      E DS                  EXTNAME(RECMCCTL)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC1       E                     EXTFLD (QQACCD)                                    CGL029
      ** External DS for RETAIL details
     D SDCMAN        E DS                  EXTNAME(SDCMANPD)
      ** External DS for cash management details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D  QQACC2       E                     EXTFLD (QQACCD)                                    CGL029
      ** A/C Code Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs
 
 
 
      * Access Hierarchy Detail
 
     C                   EXSR      ACS_HIER
 
      * If group a/c hierarchy
      * ======================
 
     C     CDHTYP        IFEQ      'GA'
 
      * Process all links in the hierarchy just read
 
     C                   EXSR      PROC_GA_LINKS
     C                   ENDIF
 
      * If zero balancing/sweeping hierarchy
      * ====================================
 
     C     CDHTYP        IFEQ      'ZS'
 
      * Determine Top a/c Balance and Overdraft
 
     C                   EXSR      DET_TOP_BLOD
 
      * Process all links in the hierarchy just read
      * (If cover is to be checked, do sweeps first then tops)
 
     C     ZDCHKC        IFEQ      'Y'
     C                   MOVEL     'S'           I_SWP_TOP
     C                   EXSR      PROC_ZS_LINKS
     C                   MOVEL     'T'           I_SWP_TOP
     C                   EXSR      PROC_ZS_LINKS
     C                   ELSE
     C                   MOVEL     'B'           I_SWP_TOP
     C                   EXSR      PROC_ZS_LINKS
     C                   ENDIF
     C                   ENDIF
 
 
      * Produce end of report
 
     CLR                 MOVEL     '*END   '     X_OPTN
     CLR                 EXSR      SHADOW
     CLR                 EXSR      ZEROBAL
     CLR                 EXSR      SWEEP
     CLR                 EXSR      GROUPAC
 
      /SPACE 5
      ********************************************************************
      * Process all links in the hierarchy just read (CDHTYP = 'ZS')
      ********************************************************************
     C     PROC_ZS_LINKS BEGSR
 
      * Access all links for the hierarchy read
 
     C     CDHIER        SETLL     RECMHLL2
     C     CDHIER        READE     RECMHLL2                               99
 
     C     *IN99         DOWEQ     '0'
 
      * Access Hierarchy Link
 
     C                   EXSR      ACS_LINK
 
      * Set child a/c details
 
     C                   EXSR      SET_CHILD
 
      * If sweeping top, or both top & sweep
      * and if a shadow a/c is defined for the zero balancing child a/c
      *   Set shadow a/c details
      *   If exceptions, log them, otherwise
      *   Do (Zero Balancing) Shadow Accounting
 
     C                   EVAL      S_ACCID1 = S_ACCID1Temp                                    CGL029
     C                   EVAL      S_ACCID2 = S_ACCID2Temp                                    CGL029
     C                   EVAL      S_ACCID3 = S_ACCID3Temp                                    CGL029
                                                                                              CGL029
     C     I_SWP_TOP     IFEQ      'T'
     C     I_SWP_TOP     OREQ      'B'
     C     ZLSTYP        IFEQ      'Z'
     C     S_ACCID       ANDNE     BlankAC
     C     S_ACCID       ANDNE     *BLANK
     C                   EXSR      SET_SHADOW
     C                   SELECT
     C*****ShadowSTATX***WHENNE    'NNNN'                                       215675
     C     ShadowSTATX   WHENNE    'NNNNN'                                      215675
     C                   MOVEL     ShadowSTAT    AccountSTAT
     C                   EXSR      LOG_CMX
     C                   OTHER
     C                   EXSR      SHADOW
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
      * If this is NOT a Top A/c
      * ========================
 
     C     CLCCAT        IFNE      'T'
 
      * LOCAL
     C                   Z-ADD     LocalFVDT     I_FVDT
     C                   Z-ADD     LocalBVDT     I_BVDT
 
      * Set parent a/c details
 
     C                   EXSR      SET_PARENT
 
      * Initialize fields
 
     C                   Z-ADD     CLNASN        I_NASN
     C                   Z-ADD     *ZERO         O_TVDR
     C                   Z-ADD     *ZERO         O_TCDR
 
      * If exceptions, log them, otherwise
      *  Do Zero Balancing
      *  or Sweeping (if next sweep date is due)
 
     C                   SELECT
 
     C*****I_ChildSTATX**WHENNE    'NNNN'                                       215675
     C     I_ChildSTATX  WHENNE    'NNNNN'                                      215675
     C                   MOVEL     I_ChildSTAT   AccountSTAT
     C                   EXSR      LOG_CMX
 
     C*****I_ParentSTATX*WHENNE    'NNNN'                                       215675
     C     I_ParentSTATX WHENNE    'NNNNN'                                      215675
     C                   MOVEL     I_ParentSTAT  AccountSTAT
     C                   EXSR      LOG_CMX
 
     C     I_MODE        WHENEQ    'ASC'
     C     ZLSTYP        IFEQ      'Z'
     C                   EXSR      ZEROBAL
     C                   ENDIF
 
     C     I_MODE        WHENEQ    '1  '
     C     ZLSCPI        ANDNE     'Y'                                          217028
     C     I_MODE        OREQ      '5  '
     C     ZLSCPI        ANDNE     'Y'                                          217028
     C     I_MODE        OREQ      '1PC'
     C     ZLSCPI        ANDEQ     'Y'
     C     I_MODE        OREQ      '5PC'
     C     ZLSCPI        ANDEQ     'Y'
     C     ZLSTYP        IFEQ      'Z'
     C                   EXSR      ZEROBAL
     C                   ELSE
     C                   EXSR      SET_SweepDate
     C     SweepDate     IFLE      EvtCtlDat
     C                   EXSR      SWEEP
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
      * Update sequence on RECMHLPD record
      * (It may have been updated in zero balancing/sweeping functions)
 
     C                   Z-ADD     I_NASN        CLNASN
     C                   EXCEPT    U_RECMHL
 
      * Access zero balancing/sweeping record
 
     C     LINKK         CHAIN     REZSHLD0                           60
 
      *  Update today's debit totals
 
     C     I_MODE        IFEQ      '1  '
     C     ZLSCPI        ANDNE     'Y'                                          217028
     C     I_MODE        OREQ      '5  '
     C     ZLSCPI        ANDNE     'Y'                                          217028
     C     I_MODE        OREQ      '1PC'                                        217028
     C     ZLSCPI        ANDEQ     'Y'                                          217028
     C     I_MODE        OREQ      '5PC'                                        217028
     C     ZLSCPI        ANDEQ     'Y'                                          217028
     C                   Z-ADD     O_TVDR        ZLTVDR
     C                   Z-ADD     O_TCDR        ZLTCDR
     C                   ENDIF
 
      * If sweeping
      * -----------
      *  If sweeping top, or both top & sweep
      *  Calculate Next Sweep Date (if next sweep date is due)
 
     C     ZLSTYP        IFEQ      'S'
     C     I_SWP_TOP     IFEQ      'T'
     C     I_SWP_TOP     OREQ      'B'
     C     I_MODE        IFEQ      '1PC'
     C     I_MODE        OREQ      '5PC'
     C     ZLNSDT        IFLE      EvtCtlDat
     C                   EXSR      CAL_NXTSWPDT
     C                   Z-ADD     ZLNSDT        ZLLSDT
     C                   Z-ADD     O_FSDT        ZLNSDT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Update REZSHLPD record
 
     C                   EXCEPT    U_REZSHL
 
     C                   ENDIF
 
 
     C                   COMMIT
 
     C     CDHIER        READE     RECMHLL2                               99
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Process all links in the hierarchy just read (CDHTYP = 'GA')
      ********************************************************************
     C     PROC_GA_LINKS BEGSR
 
     C     CDHIER        SETLL     RECMHLL2
     C     CDHIER        READE     RECMHLL2                               99
 
     C     *IN99         DOWEQ     '0'
 
      * Access Hierarchy Link
 
     C                   EXSR      ACS_LINK
 
      * Set child a/c details
 
     C                   EXSR      SET_CHILD
 
      * Group A/c Posting Replication
 
     C                   EXSR      GROUPAC
 
 
     C                   COMMIT
 
     C     CDHIER        READE     RECMHLL2                               99
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
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
     C                   EVAL      I_CCUS = CLCCUS                                            CSD027
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
      * Child last cr cap date
      * Child last dr cap date
     C                   Z-ADD     LCID          ChildLCID         5 0
     C                   Z-ADD     LDID          ChildLDID         5 0
      * Child Ledger Balance
      * Child Cleared Balance
     C                   Z-ADD     LDBL          I_CLDBL
     C                   Z-ADD     CLBL          I_CCLBL
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Set shadow a/c details
      ********************************************************************
     C     SET_SHADOW    BEGSR
 
     C                   MOVEL     ZLSBRC        BRC
     C                   MOVEL     ZLSCUS        CUS
     C                   MOVEL     ZLSCCY        CCY
     C                   MOVEL     ZLSACD        ACD
     C                   MOVEL     ZLSASN        ASN
 
      * Access a/c and a/c code details:
 
     C                   MOVEL     'SHADOW'      AcType
     C                   EXSR      ACS_ACCNT
     C                   EXSR      ACS_ACOD
 
      * Determine A/c Status
 
     C                   EXSR      DET_AC_STATUS
 
      * Shadow branch
      * Shadow customer
      * Shadow currency
      * Shadow a/c code
      * Shadow a/c seq.
     C                   MOVEL     ZLSBRC        I_SBRC
     C                   MOVEL     ZLSCUS        I_SCUS
     C                   MOVEL     ZLSCCY        I_SCCY
     C                   MOVEL     ZLSACD        I_SACD
     C                   MOVEL     ZLSASN        I_SASN
      * Shadow retail no.
      * Shadow a/c profit centre
      * Shadow a/c account section
     C                   MOVEL     ACNO          I_SRNO
     C                   MOVEL     PRFC          I_SPRF
     C                   MOVEL     A5ACSC        I_SACS
      * Shadow a/c status
     C                   MOVEL     AccountSTAT   ShadowSTAT
 
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
     C                   EVAL      I_PCUS = CLPCUS                                            CSD027
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
      * Parent last cr cap date
      * Parent last dr cap date
     C                   Z-ADD     LCID          ParentLCID        5 0
     C                   Z-ADD     LDID          ParentLDID        5 0
      * Parent Account Narrative
     C                   MOVEL     ZLPNAR        I_PNAR
 
     C                   MOVEL     ACCID         L_PACCID
 
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * (Zero Balancing) Shadow Accounting
      ********************************************************************
     C     SHADOW        BEGSR
 
     C                   CALLB     'RE100611'
 
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
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
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
     C                   PARM      CLLEVL        I_LEVL            2 0
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
     C                   PARM      ZDTYPT        I_TYPT            5
     C                   PARM      ZDTYPS        I_TYPS            5
 
      * Event Control date
     C                   PARM      EvtCtlDat     I_EvtCtlDat       5 0
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'SHADOW ACCOUNTING FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Zero Balancing
      ********************************************************************
     C     ZEROBAL       BEGSR
 
     C                   CALLB     'RE100612'
 
      * Return code
      * Error Message
      * Option
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
     C                   PARM                    X_OPTN
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
      * Time
     C                   PARM      '000000'      I_TIME            6
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
     C                   PARM                    I_CACD                                       CGL029
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
      * Child Ledger Balance
      * Child Cleared Balance
     C                   PARM                    I_CLDBL          15 0
     C                   PARM                    I_CCLBL          15 0
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
     C                   PARM                    I_PACD                                       CGL029
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
     C                   PARM                    I_SWP_TOP         1
 
      * Forward value date
      * Back value date
     C                   PARM                    I_FVDT            5 0
     C                   PARM                    I_BVDT            5 0
 
      * Sweep capitalized interest
      * Sweep cleared balance on associaton date
      * Zero Balance - Net or Gross
      * Target balance
     C                   PARM      ZLSCPI        I_SCPI            1
     C                   PARM      ZLSCBD        I_SCBD            1
     C                   PARM      ZLZBNG        I_ZBNG            1
     C                   PARM      ZLTGBL        I_TGBL           15 0
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
 
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM      ZLMDVD        I_MDVD           15 0
     C                   PARM      ZLMDCD        I_MDCD            3 0
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
     C                   PARM      ZDCAC1        I_CAC1                                       CGL029
     C                   PARM      ZDCAM1        I_CAM1           15 0
     C                   PARM      ZDICD1        I_ICD1            4
     C                   PARM      ZDCHG3        I_CHG3            3
     C**********         PARM      ZDCAC3        I_CAC3           18                          CGL029
     C                   PARM      ZDCAC3        I_CAC3                                       CGL029
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
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM      *BLANK        I_TAST            1            214360
     C                   PARM      *BLANK        I_DEFP            1            214360
     C                   PARM      *BLANK        I_DEFZ            1            214360
      * Next Available Seq No.
     C                   PARM                    I_NASN            2 0
      * Top a/c balance
      * Top a/c overdraft
     C                   PARM                    I_TopBalance     15 0
     C                   PARM                    I_TopOverDft     15 0
 
      * Event Control date
     C                   PARM      EvtCtlDat     I_EvtCtlDat       5 0
 
      * OUTPUTS
      * Today's total dr value
      * Today's total dr count
     C                   PARM      *zero         O_TVDR           15 0
     C                   PARM      *zero         O_TCDR            3 0
      * Entries Y/N                                                             214360
     C                   PARM      'N'           O_Entries         1            214360
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ZERO BALANCING FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Set Sweep Date
      ********************************************************************
     C     SET_SweepDate BEGSR
 
     C                   Z-ADD     ZLNSDT        SweepDate         5 0
 
      * Ensure sweeping is value dated after capitalized interest
 
     C     I_MODE        IFEQ      '1PC'
     C     I_MODE        OREQ      '5PC'
 
     C     ChildLCID     IFGT      ChildLDID
     C                   Z-ADD     ChildLCID     ChildIntDate      5 0
     C                   ELSE
     C                   Z-ADD     ChildLDID     ChildIntDate
     C                   ENDIF
     C     ParentLCID    IFGT      ParentLDID
     C                   Z-ADD     ParentLCID    ParentIntDate     5 0
     C                   ELSE
     C                   Z-ADD     ParentLDID    ParentIntDate
     C                   ENDIF
     C*****BMLDAI********IFEQ      'N'                                          217028
     C*******************ADD       1             ChildIntDate                   217028
     C*******************ADD       1             ParentIntDate                  217028
     C*******************ENDIF                                                  217028
 
     C     ChildIntDate  IFGT      SweepDate
     C                   Z-ADD     ChildIntDate  SweepDate
     C                   ENDIF
     C     ParentIntDate IFGT      SweepDate
     C                   Z-ADD     ParentIntDate SweepDate
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Sweeping
      ********************************************************************
     C     SWEEP         BEGSR
 
     C                   CALLB     'RE100613'
 
      * Return code
      * Error Message
      * Option
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
     C                   PARM                    X_OPTN
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
      * Time
     C                   PARM      '000000'      I_TIME            6
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
     C                   PARM                    I_CACD                                       CGL029
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
      * Child Ledger Balance
      * Child Cleared Balance
     C                   PARM                    I_CLDBL          15 0
     C                   PARM                    I_CCLBL          15 0
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
     C                   PARM                    I_PACD                                       CGL029
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
     C                   PARM                    I_SWP_TOP         1
      * Sweep capitalized interest
     C                   PARM      ZLSCPI        I_SCPI            1
 
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM      ZLMINB        I_MINB           15 0
     C                   PARM      ZLMINL        I_MINL           15 0
     C                   PARM      ZLMAXB        I_MAXB           15 0
     C                   PARM      ZLMAXL        I_MAXL           15 0
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
 
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM      ZLMDVD        I_MDVD           15 0
     C                   PARM      ZLMDCD        I_MDCD            3 0
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
     C                   PARM      ZDCAC1        I_CAC1                                       CGL029
     C                   PARM      ZDCAM1        I_CAM1           15 0
     C                   PARM      ZDICD1        I_ICD1            4
     C                   PARM      ZDCHG3        I_CHG3            3
     C**********         PARM      ZDCAC3        I_CAC3           18                          CGL029
     C                   PARM      ZDCAC3        I_CAC3                                       CGL029
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
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM      *BLANK        I_TAST            1            214360
     C                   PARM      *BLANK        I_DEFP            1            214360
     C                   PARM      *BLANK        I_DEFZ            1            214360
      * Next Available Seq No.
     C                   PARM                    I_NASN            2 0
      * Top a/c balance
      * Top a/c overdraft
     C                   PARM                    I_TopBalance     15 0
     C                   PARM                    I_TopOverDft     15 0
 
      * Sweep Date
      * Event Control date
     C                   PARM      SweepDate     I_SweepDate       5 0
     C                   PARM      EvtCtlDat     I_EvtCtlDat       5 0
 
      * OUTPUTS
      * Today's total dr value
      * Today's total dr count
     C                   PARM      *zero         O_TVDR           15 0
     C                   PARM      *zero         O_TCDR            3 0
      * Entries Y/N                                                             214360
     C                   PARM      'N'           O_Entries         1            214360
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'SWEEPING FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Group A/c Posting Replication
      ********************************************************************
     C     GROUPAC       BEGSR
 
     C                   CALLB     'RE100610'
 
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
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
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
     C                   PARM                    I_CACD                                       CGL029
     C                   PARM                    I_CASN            2 0
      * Child a/c category
     C                   PARM      CLCCAT        I_CCAT            1
      * Child retail no.
     C                   PARM                    I_CRNO           10 0
      * Child Ledger Balance
      * Child Cleared Balance
     C                   PARM                    I_CLDBL          15 0
     C                   PARM                    I_CCLBL          15 0
      * Level
     C                   PARM      CLLEVL        I_LEVL            2 0
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
     C                   PARM      CLPACD        I_PACD                                       CGL029
     C                   PARM      CLPASN        I_PASN            2 0
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'GAP RELICATION FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Calculate Next Sweep Date
      ********************************************************************
     C     CAL_NXTSWPDT  BEGSR
 
     C                   CALLB     'REZSWPSCH'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Link ID
      * Child Currency
      * Child A/c Category
      * Deferred Posting                                                        216106
     C                   PARM      CLLINK        I_LINK            9 0
     C                   PARM      CLCCCY        I_CCCY            3
     C                   PARM      CLCCAT        I_CCAT            1
     C                   PARM      ZDDEFP        I_DEFP            1            216106
      * Sweeping Frequency - COB
      * Sweeping Day - COB
      * Next Sweep Date - COB
     C                   PARM      ZLSFRQ        I_SSFRQ           1
     C                   PARM      *BLANK        I_SSDAY           2
     C                   PARM      *BLANK        I_SNSDT           6
 
      * External                                                                214552
      * Master Account                                                          214552
     C                   PARM      ZDEXTL        I_SEXTL           1            214552
     C                   PARM      ZDMAST        I_SMAST           1            214552
      * Sweeping Holiday Convention - COB
     C                   PARM      ZDSHOC        I_SSHOC           1
      * Sweeping Day - COB     (in numeric form)
      * Next Sweep Date - COB  (in numeric form)
     C                   PARM      ZLSDAY        I_SDAY            2 0
     C                   PARM      ZLNSDT        I_NSDT            5 0
 
      * SDBANKPD
      * SDGELRPD
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
 
      * OUTPUTS
      * Sweeping Day - COB
      * Next Sweep Date - COB
     C                   PARM                    O_SDAY            2 0
     C                   PARM                    O_NSDT            5 0
 
      * Following Sweep Date
     C                   PARM                    O_FSDT            5 0
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     Ix            ORNE      0
     C                   EVAL      X_ERMS = 'ERROR IN SWEEPING SCHEDULE'
     C                   EXSR      *PSSR
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
     C                   PARM                    X_ACCD                                       CGL029
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
     C                   PARM      CDHIER        I_HIER            9 0
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
     C                   PARM      '*EXCLCM'     X_OPTN            7
      * Hierarchy ID
     C                   PARM      CDHIER        I_HIER            9 0
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
     C                   PARM      CLCACD        I_CACD                                       CGL029
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
      * Determine Top a/c Balance and Overdraft
      ********************************************************************
     C     DET_TOP_BLOD  BEGSR
 
      * If check for cover on top a/c is not done
      *  then top a/c balance & overdraft are not monitored
 
     C     ZDCHKC        IFNE      'Y'
     C                   Z-ADD     *ZERO         I_TopBalance
     C                   MOVE      *ALL'9'       I_TopOverDft
     C                   ELSE
 
     C                   CALLB     'RE100615'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
      * Hierarchy ID
      * Hierarchy Shortname
     C                   PARM      CDHIER        I_HIER            9 0
     C                   PARM      CDHISN        I_HISN           10
 
      * OUTPUTS
      * Top a/c balance
      * Top a/c overdraft
     C                   PARM      *ZERO         O_TopBalance     15 0
     C                   PARM      *ZERO         O_TopOverDft     15 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN DETERMINE TOP BALANCE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     O_TopBalance  I_TopBalance
     C                   MOVE      O_TopOverDft  I_TopOverDft
 
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
 
     C     AcType        IFEQ      'SHADOW'
     C                   EVAL      I_EXCP = 'SHADOWING NOT DONE.'
     C                   ELSE
     C     ZLSTYP        IFEQ      'Z'
     C                   EVAL      I_EXCP = 'ZERO BALANCING NOT DONE.'
     C                   ELSE
     C                   EVAL      I_EXCP = 'SWEEPING NOT DONE.'
     C                   ENDIF
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
     C                   PARM      *BLANK        I_TIME            6
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN WRITE TO RECMEXPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Determine Forward and Back Days
      ********************************************************************
     C     DET_FWDBCK    BEGSR
 
     C                   CALLB     'REZFWDBCK'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
 
      * Forward value days
      * Back value days
     C                   PARM                    I_FVD             3
     C                   PARM                    I_BVD             3
 
      * SDBANKPD
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Forward value date
      * Back value date
     C                   PARM                    O_FVDate          5 0
     C                   PARM                    O_BVDate          5 0
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN FORWARD AND BACK DAYS'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Access General Ledger Details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      * Event Control Date
 
     C     BKAPDT        IFLT      BJDNWD
     C                   Z-ADD     BKAPDT        EvtCtlDat         5 0
     C                   ELSE
     C     BJDNWD        SUB       1             EvtCtlDat
     C                   ENDIF
 
      *  Access Retail Details
 
     C                   CALL      'AORETLR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY
 
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
 
      * Determine LOCAL Forward and Back Dates
 
     C                   MOVEL     CMLFVD        I_FVD
     C                   MOVEL     CMLBVD        I_BVD
     C                   EXSR      DET_FWDBCK
     C                   MOVEL     CMLFVS        LocalFVS          1
     C                   Z-ADD     O_FVDate      LocalFVDT         5 0
     C                   Z-ADD     O_BVDate      LocalBVDT         5 0
 
      * Clear data structures
 
     C                   CLEAR                   O_CMHD
     C                   CLEAR                   O_ZSHD
     C                   CLEAR                   O_GAHD
     C                   CLEAR                   O_CMHL
     C                   CLEAR                   O_ZSHL
     C                   CLEAR                   O_GAHL
 
      * Log reference numbers before updates
 
     C     *DTAARA       DEFINE                  RECMCCTL
     C     *LOCK         IN        RECMCCTL
 
     C                   Z-ADD     *ZERO         GLNARN
     C     'ZS '         SETLL     GLAPNAPF
     C     'ZS '         READE     GLAPNAPF                               99    *
     C                   MOVEL     GLNARN        CMZSSQ
 
     C                   Z-ADD     *ZERO         GLNARN
     C     'GA '         SETLL     GLAPNAPF
     C     'GA '         READE     GLAPNAPF                               99    *
     C                   MOVEL     GLNARN        CMGASQ
 
     C                   OUT       RECMCCTL
 
      * Blank A/c
     C**********         Z-ADD     *ZERO         CUS                                          CSD027
     C                   EVAL      CUS = *BLANKS                                              CSD027
     C                   Z-ADD     *ZERO         ACD
     C                   Z-ADD     *ZERO         ASN
     C**********         MOVEL     ACCID         BlankAC          18                          CGL029
     C                   MOVEL     ACCID         BlankAC                                      CGL029
 
      * Key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     RECMBRK       KLIST
     C                   KFLD                    CDHIER
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C     LINKK         KLIST
     C                   KFLD                    CDHIER
     C                   KFLD                    CLLINK
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
     ORECMHLD0  E            U_RECMHL
     O                       CLNASN
     OREZSHLD0  E            U_REZSHL
     O                       ZLLSDT
     O                       ZLNSDT
     O                       ZLTVDR
     O                       ZLTCDR
