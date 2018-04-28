     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Retail Entries Report')       *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100717 - Cash Management Retail Entries Update             *
      *                                                               *
      *  Function:  This program updates entries generated on retail  *
      *             capitalization and accrual if they are against    *
      *             accounts in group account hierarchies.            *
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
      *                 CGL029             Date 01Sep03               *
      *                 218393             Date 10Jun03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR676213 - Apply fix 250766                                  *
      *  250766 - REC103664 failed with CPF5004 in RE100717P1         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  218393 - GA unlink errors (CRE008 fix)                       *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FGEICL0    UP   E           K DISK    INFSR(*PSSR)
     FGEICZZ    UF   E             DISK    INFSR(*PSSR)
     FREGAHLJ2  IF   E           K DISK    INFSR(*PSSR)
     FREGAHDL0  IF   E           K DISK    INFSR(*PSSR)
     FREGAHLJ3  IF   E           K DISK    INFSR(*PSSR)                                       218393
     F                                     RENAME(REGAHLD0:REGAHLDU)
     FREZSHLJ5  IF   E           K DISK    INFSR(*PSSR)
     FREZSHLJ6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REZSHLD0:REZSHLDU)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(M2_)
     FRE100717P1O    E             PRINTER INFSR(*PSSR)  USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
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
 
 
0076 D INT             S             15  0 DIM(1)
0077 D DEC             S              3  0 DIM(1)
 
 
     D OTRF            DS
     D**CNUM****               1      6  0                                                    CSD027
     D  CNUM                   1      6A                                                      CSD027
     D  ACSQ                   7      8  0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** A/C Code Details
     D M2_SDACOD     E DS                  EXTNAME(SDACODPD)
     D                                     PREFIX(M2_)
      ** A/C Code Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      ** File Information Data Structure for RE100717P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
     IAPOSTPDF      01
     I
     I              BRCA                        XBRCA
     I              CNUM                        XCNUM
     I              CCY                         XCCY
     I              ACOD                        XACOD
     I              ACSQ                        XACSQ
     I                                          ORBR          L4
     I                                          TRCCY         L3
     I                                          FACO          L2
     I                                          OTRF          L1
     IREGAHLDU      02                                                                        218393
     I              LCHIER                      CLHIER                                        218393
     I              LCLINK                      CLLINK                                        218393
     I              LCCBRC                      CLCBRC                                        218393
     I              LCCCUS                      CLCCUS                                        218393
     I              LCCCCY                      CLCCCY                                        218393
     I              LCCACD                      CLCACD                                        218393
     I              LCCASN                      CLCASN                                        218393
     I              LCCCAT                      CLCCAT                                        218393
     I              LCPBRC                      CLPBRC                                        218393
     I              LCPCUS                      CLPCUS                                        218393
     I              LCPCCY                      CLPCCY                                        218393
     I              LCPACD                      CLPACD                                        218393
     I              LCPASN                      CLPASN                                        218393
     I              LCLEVL                      CLLEVL                                        218393
 
     IREZSHLDU      03
     I              LCHIER                      CLHIER
     I              LCLINK                      CLLINK
     I              LCCBRC                      CLCBRC
     I              LCCCUS                      CLCCUS
     I              LCCCCY                      CLCCCY
     I              LCCACD                      CLCACD
     I              LCCASN                      CLCASN
     I              LCCCAT                      CLCCAT
     I              LCPBRC                      CLPBRC
     I              LCPCUS                      CLPCUS
     I              LCPCCY                      CLPCCY
     I              LCPACD                      CLPACD
     I              LCPASN                      CLPASN
     I              LCLEVL                      CLLEVL
     I*
      * On change of branch
      *   Access branch
      *   Produce 'end of report' and close printer file if previously open
      *   Open printer file
      *   Register P1 printer file with RCF
 
     C   L4              EXSR      ACS_BRCH
     C   L4P1Open        IFEQ      'Y'
     C                   EXSR      END_OF_REP
     C                   CLOSE     RE100717P1
     C                   ENDIF
     C   L4              OPEN      RE100717P1
     C   L4              EXSR      RCFP1
     C   L4              MOVE      'Y'           P1Open            1
 
      * On change of currency
      *   Access currency
      *   Trigger page change
 
     C   L3              EXSR      ACS_CURR
     C   L3              Z-ADD     99            LINENO
 
      * On change of a/c code
      *   Access a/c code
 
     C   L2              MOVEL     FACO          ACCD
     C   L2              EXSR      ACS_ACOD
 
      * Report entry
      * ------------
 
     C                   EXSR      REP_ENTRY
 
 
      * At end of data:
      * If printer file not open
      *   Open printer file
      *   Register P1 printer file with RCF
      * Produce end of report
      * Close printer file
 
     CLR   P1Open        IFNE      'Y'
     CLR                 OPEN      RE100717P1
     CLR                 EXSR      RCFP1
     CLR                 ENDIF
     CLR                 EXSR      END_OF_REP
     CLR                 CLOSE     RE100717P1
     CLR                 EXSR      UPD_TRAIL
      /SPACE 5
      ********************************************************************
      * Report entry
      ********************************************************************
     C     REP_ENTRY     BEGSR
 
      * Space
     C     *INL1         IFEQ      '1'
     C                   Z-ADD     2             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     SPACE2
     C                   ENDIF
 
     C                   MOVEL     XCNUM         XCNUMA            6
     C**********         MOVEL     XACOD         XACODA            4                          CGL029
     C                   MOVEL     XACOD         XACODA           10                          CGL029
     C                   MOVEL     XACSQ         XACSQA            2
     C                   EVAL      XACCID = XBRCA + '-' + XCNUMA + '-' +
     C                                      XCCY  + '-' + XACODA + '-' +
     C                                      XACSQA
 
     C                   MOVE      OTST          R_NARR
 
     C                   MOVE      ACNO          R_ACNO
     C     R_ACNO        COMP      0                                  3636      *
 
      * Edit posting date of entry
 
     C                   Z-ADD     PSTD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_PSTD
 
      * Edit value date of entry
 
     C                   Z-ADD     VALD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_VALD
 
      * Edit posting amount of entry
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      PSTA          ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_PSTA
 
      * Edit posting dr/cr indicator
 
     C     DRCR          IFEQ      0
     C                   MOVEL     'DR'          R_DRCR
     C                   ELSE
     C                   MOVEL     'CR'          R_DRCR
     C                   ENDIF
 
      * Determine action
 
     C*******************EXSR      DET_ACTN
     C                   If        TRST = 'G ' OR
     C                             TRST = 'GZ'
     C                   EXSR      DET_ACTN_GA
     C                   Else
     C                   EXSR      DET_ACTN_ZS
     C                   Endif
 
     C**********         Z-ADD     1             CHLINE            3 0                        250766
     C                   Z-ADD     2             CHLINE            3 0                        250766
     C                   EXSR      PAG
     C                   WRITE     ENTRY
 
      * Report 'movement to' entry
 
     C                   IF        %SUBST(R_ACTN:1:3) = 'MOV'
 
     C                   MOVEL     XCNUM         XCNUMA            6
     C**********         MOVEL     XACOD         XACODA            4                          CGL029
     C                   MOVEL     XACOD         XACODA                                       CGL029
     C                   MOVEL     XACSQ         XACSQA            2
     C                   EVAL      XACCID = XBRCA + '-' + XCNUMA + '-' +
     C                                      XCCY  + '-' + XACODA + '-' +
     C                                      XACSQA
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     M2ENTRY
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * End of Report
      ********************************************************************
     C     END_OF_REP    BEGSR
 
      * Output count of errors and 'end of report'
 
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
      * Access a branch
      ********************************************************************
     C     ACS_BRCH      BEGSR
 
     C                   CALLB     'ZAACSBRCH'
     C                   PARM                    ORBR
     C                   PARM                    SDBRCH
 
      * Database error if branch not found
 
     C     A8BRCD        IFEQ      *BLANK
     C                   EVAL      X_ERMS = 'BAD BRANCH CODE:' + ORBR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Access a currency
      ********************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'ZAACSCURR'
     C                   PARM                    TRCCY
     C                   PARM                    SDCURR
 
      * Database error if currency not found
 
     C     A6CYCD        IFEQ      *BLANK
     C                   EVAL      X_ERMS = 'BAD CCY CODE:' + TRCCY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Access A/c code
      ********************************************************************
     C     ACS_ACOD      BEGSR
 
     C                   CALLB     'ZAACSACOD'
     C**********         PARM                    ACCD              4                          CGL029
     C                   PARM                    ACCD             10                          CGL029
     C                   PARM                    SDACOD
 
      * Database error if a/c code not found
 
     C     A5ACCD        IFEQ      *BLANK
     C                   EVAL      X_ERMS = 'BAD A/C CODE:' + ACCD
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C**********         MOVEL     A5ACCD        ACOD              4 0                        CGL029
     C                   MOVEL     A5ACCD        ACOD             10 0                        CGL029
 
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
     C                   PARM      ORBR          PEnty
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
      * Determine action  - Group Accounts
      ********************************************************************
     C     DET_ACTN_GA   BEGSR
 
      * Access hierarchy link
 
     C     ACCNTK        CHAIN     REGAHLJ2                           99
     C     *IN99         IFEQ      '1'
     C     ACCNTK        CHAIN     REGAHLJ3                           99                      218393
     C     *IN99         IFEQ      '1'                                                        218393
     C                   MOVEL     '?????'       R_ACTN
     C                   GOTO      E_DET_ACTN
     C                   ENDIF
     C                   ENDIF                                                                218393
 
     C                   MOVEL     *BLANK        R_ACTN
     C                   MOVE      CLCCAT        R_ACTN
 
      * Delete all accruals on top account if top is off balance sheet
      * Delete all accruals on level a/cs
      * Delete all accruals on sub accounts if top is on balance sheet
 
     C     R_NARR        IFEQ      'DIAC'
     C     R_NARR        OREQ      'DIAD'
     C     R_NARR        OREQ      'CIAD'
     C     R_NARR        OREQ      'CIAC'
 
     C     CLHIER        CHAIN     REGAHDD0                           99        *
 
     C                   SELECT
     C     CLCCAT        WHENEQ    'T'
     C     GDTOPB        IFNE      'Y'
     C                   MOVEL     'DEL*'        R_ACTN
     C                   ENDIF
     C     CLCCAT        WHENEQ    'L'
     C                   MOVEL     'DEL*'        R_ACTN
     C     CLCCAT        WHENEQ    'S'
     C     GDTOPB        IFEQ      'Y'
     C                   MOVEL     'DEL*'        R_ACTN
     C                   ENDIF
     C                   ENDSL
 
     C                   IF        %SUBST(R_ACTN:1:3) = 'DEL'
     C                   DELETE    APOSTPDF
     C                   ADD       1             CNT_DEL           5 0
     C                   ADD       PSTA          AMT_DEL          17 0
     C                   ENDIF
 
     C                   ENDIF
 
      * If contra of interest capitalized
      * and level or sub a/c
      * Move entry to internal income/expense a/c
 
     C     R_NARR        IFEQ      'CAPC'
     C     R_NARR        OREQ      'CAPD'
     C     CLCCAT        IFEQ      'L'
     C     CLCCAT        OREQ      'S'
 
     C                   MOVEL     'MOV'         R_ACTN
 
      * Move capitalized credit interest contra to internal expense a/c
     C                   MOVEL     GLEBRC        BRC
     C                   MOVEL     GLECUS        CUS
     C                   MOVEL     GLECCY        CCY
     C                   MOVEL     GLEACD        ACD
     C                   MOVEL     GLEASN        ASN
 
     C     R_NARR        IFEQ      'CAPC'
     C     ACCID         ANDNE     BlankAC
     C                   EXSR      MOV_CAP
     C                   ENDIF
 
      * Move capitalized debit interest contra to internal income a/c
     C                   MOVEL     GLIBRC        BRC
     C                   MOVEL     GLICUS        CUS
     C                   MOVEL     GLICCY        CCY
     C                   MOVEL     GLIACD        ACD
     C                   MOVEL     GLIASN        ASN
 
     C     R_NARR        IFEQ      'CAPD'
     C     ACCID         ANDNE     BlankAC
     C                   EXSR      MOV_CAP
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
                                                                                              218393
      * If witholding tax                                                                     218393
      * and top account                                                                       218393
      * Move entry to transaction account                                                     218393
                                                                                              218393
     C     R_NARR        IFEQ      'WTAX'                                                     218393
     C     CLCCAT        ANDEQ     'T'                                                        218393
                                                                                              218393
     C                   MOVEL     'MOV'         R_ACTN                                       218393
                                                                                              218393
      * Move witholding tax to transaction account                                            218393
     C                   MOVEL     GLTBRC        BRC                                          218393
     C                   MOVEL     GLTCUS        CUS                                          218393
     C                   MOVEL     GLTCCY        CCY                                          218393
     C                   MOVEL     GLTACD        ACD                                          218393
     C                   MOVEL     GLTASN        ASN                                          218393
                                                                                              218393
     C     ACCID         IFNE      BlankAC                                                    218393
     C                   EXSR      MOV_CAP                                                    218393
     C                   ENDIF                                                                218393
                                                                                              218393
     C                   ENDIF                                                                218393
 
     C     E_DET_ACTN    ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Determine action  Zero Balancing
      ********************************************************************
     C     DET_ACTN_ZS   BEGSR
 
      * Access hierarchy link
 
     C     ACCNTK        CHAIN     REZSHLJ5                           99
     C     *IN99         IFEQ      '1'
     C     ACCNTK        CHAIN     REZSHLJ6                           99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '?????'       R_ACTN
     C                   GOTO      E_DET_ACZS
     C                   ENDIF
     C                   ENDIF
 
      * If shadow account defined,
     C                   MOVEL     ZLSBRC        BRC
     C                   MOVEL     ZLSCUS        CUS
     C                   MOVEL     ZLSCCY        CCY
     C                   MOVEL     ZLSACD        ACD
     C                   MOVEL     ZLSASN        ASN
 
     C     ACCID         IFEQ      BlankAC
     C                   MOVEL     '?????'       R_ACTN
     C                   GOTO      E_DET_ACZS
     C                   ENDIF
 
     C                   MOVEL     *BLANK        R_ACTN
     C                   MOVE      CLCCAT        R_ACTN
 
      * Delete all accruals on level a/cs
      * Delete all accruals on sub accounts if top is on balance sheet
 
     C     R_NARR        IFEQ      'CIAD'
     C     R_NARR        OREQ      'CIAC'
 
     C     CLCCAT        IFEQ      'L'
     C     CLCCAT        OREQ      'S'
     C                   MOVEL     'DEL*'        R_ACTN
     C                   ENDIF
 
     C                   IF        %SUBST(R_ACTN:1:3) = 'DEL'
     C                   DELETE    APOSTPDF
     C                   ADD       1             CNT_DEL           5 0
     C                   ADD       PSTA          AMT_DEL          17 0
     C                   ENDIF
 
     C                   ENDIF
 
      * If contra of interest capitalized
      * and level or sub a/c
      * Move entry to internal income/expense a/c
 
     C     R_NARR        IFEQ      'CAPC'
     C     R_NARR        OREQ      'CAPD'
     C     CLCCAT        IFEQ      'L'
     C     CLCCAT        OREQ      'S'
 
     C                   MOVEL     'MOV'         R_ACTN
 
      * Move capitalized credit interest contra to internal expense a/c
     C                   MOVEL     ZLEBRC        BRC
     C                   MOVEL     ZLECUS        CUS
     C                   MOVEL     ZLECCY        CCY
     C                   MOVEL     ZLEACD        ACD
     C                   MOVEL     ZLEASN        ASN
 
     C     R_NARR        IFEQ      'CAPC'
     C     ACCID         ANDNE     BlankAC
     C                   EXSR      MOV_CAP
     C                   ENDIF
 
      * Move capitalized debit interest contra to internal income a/c
     C                   MOVEL     ZLIBRC        BRC
     C                   MOVEL     ZLICUS        CUS
     C                   MOVEL     ZLICCY        CCY
     C                   MOVEL     ZLIACD        ACD
     C                   MOVEL     ZLIASN        ASN
 
     C     R_NARR        IFEQ      'CAPD'
     C     ACCID         ANDNE     BlankAC
     C                   EXSR      MOV_CAP
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     E_DET_ACZS    ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Move capitalized interest contra to internal expense/income a/c
      ********************************************************************
     C     MOV_CAP       BEGSR
 
      * Access MOVE TO a/c and a/c code details:
 
     C                   EXSR      ACS_M2ACCNT
     C                   EXSR      ACS_M2ACOD
 
      * Customer, currency, a/c code and a/c seq.
      * Retail a/c no.
     C                   MOVEL     CUS           XCNUM
     C                   MOVEL     CCY           XCCY
     C                   MOVEL     ACD           XACOD
     C                   MOVEL     ASN           XACSQ
     C                   Z-ADD     M2_ACNO       ACNO
      * Branch
     C                   MOVEL     BRC           XBRCA
      * Retail indicator
      * A/c type
     C                   MOVEL     'R'           ATYP
     C                   Z-ADD     1             RIND
      * Profit centre
      * Account section
     C                   MOVEL     M2_PRFC       PRFC
     C                   MOVEL     M2_A5ACSC     ACSC
 
      * Transaction sub-type = 'UPDATED'
     C                   MOVEL     'UP'          TRST
 
      * Update existing entry
 
     C                   EXCEPT    U_GEICL0
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Access MOVE TO a/c details
      ********************************************************************
     C     ACS_M2ACCNT   BEGSR
 
     C     M2ACCNTK      CHAIN     ACCNTABF                           60        *
     C     *IN60         IFEQ      '1'
     C                   EVAL      X_ERMS = 'BAD A/C:'
     C                                      + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access MOVE TO A/c code
      ********************************************************************
     C     ACS_M2ACOD    BEGSR
 
     C                   MOVEL     ACD           X_ACCD
     C                   CALLB     'ZAACSACOD'
     C**********         PARM                    X_ACCD            4                          CGL029
     C                   PARM                    X_ACCD           10                          CGL029
     C                   PARM                    M2_SDACOD
 
      * Database error if a/c code not found
 
     C     M2_A5ACCD     IFEQ      *BLANK
     C                   EVAL      X_ERMS = 'BAD A/C CODE:' + X_ACCD
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Update GEICZZ Trailer
      ********************************************************************
     C     UPD_TRAIL     BEGSR
 
     C     1             CHAIN     APOSTZZF                           99
     C                   SUB       CNT_DEL       NORE1
0511 C                   MOVE      AMT_DEL       ZZAMT
0511 C                   Z-SUB     ZZAMT         ZZAMT
0510 C                   Z-ADD     HRWN          ZZTOTI
0511 C                   Z-ADD     HRDC          ZZTOTD
0512 C                   EXSR      GLZADD
0514 C                   Z-ADD     ZZTOTI        HRWN
0515 C                   Z-ADD     ZZTOTD        HRDC
     C                   UPDATE    APOSTZZF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *******************************************************************
0519 C* SUBROUTINE TO ADD AN AMOUNT (ZZAMT) TO THE TOTAL (ZZTOTI,ZZTOTD)
0520 C*   IND '99' IS SET BY AN OVERFLOW ERROR
0521 C*
0522 CSR   GLZADD        BEGSR                                                  *** GLZADD ****
0523 C*
0524 CSR                 Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
0525 CSR 91              GOTO      ZZAEND                                       AMT = 0.BYPASS
0526 C*
0527 C* SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
0528 CSR                 Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
0529 CSR                 MOVE      ZZAMT         ZZAMTD            3 0          DECIMAL FIELD
0530 C* BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
0531 C*
0532 CSR                 EXSR      GLZSUM
0533 CSR   ZZAEND        ENDSR                                                  ** ZZAEND TAG *
0518 C********************************************************************
0534 C*
0546 C* SUBROUTINE TO CARRY OUT THE ADDITION FOR SUBROUTINES -
0547 C*                        GLZADD, GLZSUB, GLZCMP.
0548 C*          PARAMETERS PASSED -
0549 C*                     I/P ZZAMTI ZZAMTD
0550 C*                     O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
0551 C*
0552 CSR   GLZSUM        BEGSR                                                  *** GLZSUM ****
0553 C*
0554 CSR                 Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
0555 CSR                 Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
0556 CSR                 SETOFF                                       919293
0557 CSR                 SETOFF                                       949599
0558 C*
0559 C*    DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG
0560 CSR   ZZAMTI        COMP      0                                    9293
0561 CSR 93ZZAMTD        COMP      0                                    9293
0562 CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
0563 C*
0564 C*    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.
0565 CSR   ZZTOTI        COMP      0                                    9193
0566 CSR 93ZZTOTD        COMP      0                                    9193
0567 C*
0568 C*    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
0569 CSR 93              Z-ADD     ZZAMTI        ZZTOTI
0570 CSR 93              Z-ADD     ZZAMTD        ZZTOTD
0571 CSR 93              GOTO      ZZSEND                                       ZERO BYPASS
0572 C*    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     CSR 91
0573 CANN92
     CORN91
0574 CAN 92              GOTO      ZZOFPS
0575 C*
0576 CSR   ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
0577 CSR   ZZWK2         COMP      999                                93        '93' = CARRY
0578 CSRN93ZZWK2         COMP      -999                                 93        INTO INTEGER.
0579 C*
     CSR 93
0580 CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     CSR 93
0581 CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
0582 CSR 93ZZTOTI        ADD       ZZWK3         ZZWK3
0583 CSRN93ZZTOTI        ADD       ZZAMTI        ZZWK3
0584 C*
0585 C* IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED
0586 CSRN92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
0587 CSR 92ZZWK3         COMP      ZZTOTI                             99         NEGATIVE
0588 CSRN99              Z-ADD     ZZWK2         ZZTOTD
0589 CSRN99              Z-ADD     ZZWK3         ZZTOTI
0590 C*
0591 C* IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
0592 CSR 99              Z-ADD     0             ZZAMT            15 3
0593 CSR                 GOTO      ZZSEND
0594 C*
0595 C* THE 'SIGNS' ARE DIFFERENT
0596 CSR   ZZOFPS        TAG                                                    ** ZZOFPS TAG**
0597 C* IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT
0598 C*
0599 CSR 92              Z-SUB     ZZAMTI        ZZAMTI           15 0
0600 CSR 92              Z-SUB     ZZAMTD        ZZAMTD            3 0
0601 C*
0602 C* IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
0603 C*
0604 CSR 91              Z-SUB     ZZTOTI        ZZTOTI
0605 CSR 91              Z-SUB     ZZTOTD        ZZTOTD
0606 C* BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
0607 C*
0608 CSR   ZZTOTI        COMP      ZZAMTI                             93  95
0609 CSR 95ZZTOTD        COMP      ZZAMTD                             93  95
0610 C*
0611 C* IF ZZTOT EQ. ZZAMT RETURN ZERO.
0612 CSR 95              Z-ADD     0             ZZTOTI
0613 CSR 95              Z-ADD     0             ZZTOTD
0614 CSR 95              GOTO      ZZSEND
0615 C*
0616 C* IF ZZTOT GT. ZZAMT.
0617 CSR 93ZZAMTD        COMP      ZZTOTD                             94
     CSR 93
0618 CAN 94ZZTOTI        SUB       1             ZZTOTI
     CSR 93
0619 CAN 94ZZTOTD        ADD       1000          ZZWK2
0620 CSR 93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     CSR 93
0621 CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     CSR 93
0622 CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
0624 C*
0625 C* IF ZZAMT GT. ZZTOT.
0626 CSRN93ZZTOTD        COMP      ZZAMTD                             94
     CSRN93
0627 CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     CSRN93
0628 CAN 94ZZAMTD        ADD       1000          ZZWK2
     CSRN93
0629 CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     CSRN93
0630 CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     CSRN93
0631 CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     CSRN93
0632 CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
0633 C*
0634 C* REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE
0635 CSR                 SETOFF                                       94
     CSR 93
0636 CAN 91
     CORN93
0637 CAN 92              SETON                                        94
0638 CSR 94              Z-SUB     ZZTOTI        ZZTOTI
0639 CSR 94              Z-SUB     ZZTOTD        ZZTOTD
0640 C**
0641 C**   RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
0642 CSR 92              Z-SUB     ZZAMTI        ZZAMTI
0643 CSR 92              Z-SUB     ZZAMTD        ZZAMTD
0644 CSR   ZZSEND        TAG                                                    ** ZZSEND TAG *
0645 C**
0646 C**   IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
0647 CSR                 SETOFF                                       96
0648 CSR   ZZTOTD        COMP      0                                      91
0649 CSR 91ZZTOTI        COMP      0                                    96
0650 CSR 96              MOVE      '.000-'       ZZNEGD            5
0651 CSR                 ENDSR                                                    ** ENDSR **
0652 C********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * Blank A/c
     C**********         Z-ADD     *ZERO         CUS                                          CSD027
     C                   EVAL      CUS = *BLANKS                                              CSD027
     C                   Z-ADD     *ZERO         ACD
     C                   Z-ADD     *ZERO         ASN
     C**********         MOVEL     ACCID         BlankAC          18                          CGL029
     C                   MOVEL     ACCID         BlankAC          24                          CGL029
 
      * key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    A6CYCD
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    A8BRCD
     C     M2ACCNTK      KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
     OAPOSTPDF  E            U_GEICL0
     O                       XCNUM
     O                       XCCY
     O                       XACOD
     O                       XACSQ
     O                       ACNO
     O                       XBRCA
     O                       ATYP
     O                       RIND
     O                       PRFC
     O                       ACSC
     O                       TRST
