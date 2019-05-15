     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Hierarchy Chn Validation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100403 - Cash Management Hierarchy Chain Validation        *
      *                                                               *
      *  Function:  This program does validation of chains within     *
      *             cash management hierarchies. In particular it     *
      *             looks for broken chains. As it does this          *
      *             validation, it sets the child a/c category and    *
      *             level on each link.                               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 14May13               *
      *                 AR676213           Date 19Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR676213 - Incorrect definition of CLGLAI field              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRELCMHDL0 IF   E           K DISK    INFSR(*PSSR)
     FRELCMHLL1 UF   E           K DISK    INFSR(*PSSR)
     FREACCHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REACCHD0:REACCHD1)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
     FRE100403AUO    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      ** File Information Data Structure for RE100403AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
      * 'Top' Account ID
     D                 DS
     D***T_ACCID                 1     18                                                     CGL029
     D T_ACCID                 1     24                                                       CGL029
     D T_PBRC                  1      3
     D*T_PCUS***               4      9S 0                                                    CSD027
     D T_PCUS                  4      9                                                       CSD027
     D T_PCCY                 10     12
     D***T_PACD*                13     16S 0                                                  CGL029
     D***T_PASN*                17     18S 0                                                  CGL029
     D T_PACD                 13     22S 0                                                    CGL029
     D T_PASN                 23     24S 0                                                    CGL029
 
 
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
 
     D***X_GLAI*         S             18    DIM(99)                                          CGL029
     D X_GLAI          S             24    DIM(99)                                            CGL029
     D X_RAN           S             10    DIM(99)
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIDArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
 
      * INTERACTIVE mode
      * Non INTERACTIVE mode
 
     C     I_MODE        IFEQ      'I'
     C                   EXSR      INTERACT
     C                   ELSE
     C                   EXSR      NON_INTERACT
     C                   ENDIF
 
 
     C                   SETON                                        LR
     C                   RETURN
      /SPACE 5
      ********************************************************************
      * Interactive mode
      ********************************************************************
     C     INTERACT      BEGSR
 
      * Read all Cash Management Hierarchy Header records
 
     C                   READ      RECMHDD0                               60
 
     C     *IN60         DOWEQ     *OFF
 
      * Read links for hierarchy
 
     C                   EXSR      READ_LINKS
 
      * NORMAL EXIT if errors detected
 
     C     Ix            IFGT      0
     C                   RETURN
     C                   ENDIF
 
      * Read next Account Hierarchy Header record
 
     C                   READ      RECMHDD0                               60
 
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Non-Interactive mode
      ********************************************************************
     C     NON_INTERACT  BEGSR
 
      * Read all Cash Management Hierarchy Header records
 
     C                   READ      RECMHDD0                               60
 
     C     *IN60         DOWEQ     *OFF
 
      * Read links for hierarchy
 
     C                   EXSR      READ_LINKS
 
      * If any errors detected
      *   Report the errors
      *   Set hierarchy status to 'ERRORS'
 
     C     Ix            IFGT      0
     C                   EXSR      REP_ERRORS
     C                   ADD       Ix            NoErrors          5 0
 
     C     CDHIER        CHAIN     REACCHD1                           60
     C  N60              MOVE      'E'           HISTAT
     C  N60              EXCEPT    U_REACCH
 
     C                   SETON                                        U7U8
     C                   ENDIF
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIDArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
 
      * Read next Account Hierarchy Header record
 
     C                   READ      RECMHDD0                               60
 
     C                   ENDDO
 
      * End of Report
 
     C                   EXSR      END_OF_REP
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Read links for hierarchy
      ********************************************************************
     C     READ_LINKS    BEGSR
 
     C     CDHIER        SETLL     RECMHLD0
     C     CDHIER        READE     RECMHLD0                               60
 
      * Store 'top' a/c ID
 
     C                   MOVEL     CLCBRC        T_PBRC
     C                   MOVEL     CLCCUS        T_PCUS
     C                   MOVEL     CLCCCY        T_PCCY
     C                   MOVEL     CLCACD        T_PACD
     C                   MOVEL     CLCASN        T_PASN
 
      * Read all links for this hierarchy
 
     C     *IN60         DOWEQ     *OFF
 
      * Determine a CM child a/c category
 
     C                   EXSR      DET_CCAT
 
      * Construct a CM Hierarchy Chain
 
     C                   EXSR      CON_HCHN
 
      *  Reverse the Sequence of the CM Hierarchy Chain
 
     C                   EXSR      RSQ_HCHN
 
      * Child a/c
 
     C                   MOVEL     CLCBRC        BRC
     C                   MOVEL     CLCCUS        CUS
     C                   MOVEL     CLCCCY        CCY
     C                   MOVEL     CLCACD        ACD
     C                   MOVEL     CLCASN        ASN
 
      * Access a/c details for the child a/c
 
     C                   EXSR      ACS_ACCNT
 
      * Put child a/c at end of chain
 
     C                   Z-ADD     1             X
     C     *BLANK        LOOKUP    X_GLAI(X)                              99
     C                   MOVEL     ACCID         X_GLAI(X)
     C                   MOVEL     ACNO          X_RAN(X)
 
      * Depending on mode and hierarchy
      * Check for broken chains
 
     C     I_MODE        IFNE      'I'
     C     I_MODE        OREQ      'I'
     C     CDHIER        ANDEQ     I_Hierarchy
     C     O_CCAT        IFNE      'T'
     C                   EXSR      CHK_BROKCHN
     C                   ENDIF
     C                   ENDIF
 
      * Update the Child A/c Category, Level,
      * GL A/c Id Chain and Retail A/c No. Chain on the RECMHLPD record
 
     C                   MOVEL     O_CCAT        CLCCAT
     C                   Z-ADD     O_CNTCH       CLLEVL
     C**********         MOVEA     X_GLAI        CLGLAI                                     AR676213
     C                   MOVEA     X_GLAI        CLGLAC                                     AR676213
     C                   MOVEA     X_RAN         CLRAN
     C                   EXCEPT    U_RECMHL
 
     C     CDHIER        READE     RECMHLD0                               60
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Determine a CM child a/c category
      ********************************************************************
     C     DET_CCAT      BEGSR
 
     C                   CALLB     'RE100603'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Hierarchy ID
     C                   PARM      CLHIER        I_HIER            9 0
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
      * Child A/c Category
     C                   PARM                    O_CCAT            1
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'CHILD A/C CATEGORY FAILED'
     C                   EXSR      *PSSR
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
     C                   PARM      CDHTYP        I_HTYP            2
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
     C                   EVAL      X_ERMS = 'CONSTRUCT A CM CHAIN FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      *  Reverse the Sequence of the CM Hierarchy Chain
      ********************************************************************
     C     RSQ_HCHN      BEGSR
 
     C                   MOVEL     *BLANK        X_GLAI
     C                   MOVEL     *BLANK        X_RAN
 
     C                   Z-ADD     1             X                 2 0
     C                   Z-ADD     1             Y                 2 0
     C     *BLANK        LOOKUP    O_GLAI(X)                              99
     C     X             DOWGT     1
     C                   SUB       1             X
     C                   MOVEL     O_GLAI(X)     X_GLAI(Y)
     C                   MOVEL     O_RAN(X)      X_RAN(Y)
     C                   ADD       1             Y
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Check For Broken Chains
      ********************************************************************
     C     CHK_BROKCHN   BEGSR
 
     C                   Z-ADD     1             X                 2 0
     C     *BLANK        LOOKUP    O_GLAI(X)                              99    *
     C                   SUB       1             X
 
      * If the last element in chain is not the 'Top' a/c
      * then this is a broken chain
      * 'Broken hierarchy chain.'
 
     C     X             IFEQ      0
     C     O_GLAI(X)     ORNE      T_ACCID                                      *
     C     Ix            IFLT      ArrayMax
     C                   ADD       1             Ix
     C                   MOVEL     'CHAIN    '   FldNameArr(Ix)
     C                   MOVEL     'RE75030'     MsgIDArr(Ix)
     C**********         MOVEL     CLLINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     CLLINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * Report Errors
      ********************************************************************
     C     REP_ERRORS    BEGSR
 
     C                   Z-ADD     1             IIx               3 0
     C     IIx           DOUGT     Ix
 
     C                   MOVEL     MsgIdArr(IIx) @MSGID            7
     C                   MOVEL     MsgDtaArr(IIx)@MSGDT           45
     C                   EXSR      ZAMSGRTVMS
     C                   EVAL      R_ERMS = CompMsg
     C                   ADD       1             IIx
 
      * Output to report
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     ERROR
 
     C                   ENDDO
 
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
      * Retrieve a message
      ********************************************************************
     C     ZAMSGRTVMS    BEGSR
     C                   CALLB     'ZAMSGRTVMS'
     C                   PARM      *BLANK        ReturnCode       10
     C                   PARM      *BLANK        CompMsg        3000
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
     C                   PARM      'REUSRMSG  '  #MsgFile         10
     C                   PARM      '*LIBL  '     #MsgFLib         10
     C                   PARM      '0'           Level             1
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Register AU printer file with RCF
      ********************************************************************
     C     RCFAU         BEGSR
 
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
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
      * Mode
     C                   PARM                    I_MODE            1
      * Hierarchy
      * Hierarchy Type
     C                   PARM                    I_Hierarchy       9 0
     C                   PARM                    I_HierType        2
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * If NOT interactive mode
      *   Open printer file
      *   Register AU printer file with RCF
 
     C     I_MODE        IFNE      'I'
     C                   OPEN      RE100403AU
     C                   EXSR      RCFAU
     C                   ENDIF
 
      * Key lists
 
     C     ACCNTK        KLIST
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
     OREACCHD1  E            U_REACCH
     O                       HISTAT
     ORECMHLD0  E            U_RECMHL
     O                       CLCCAT
     O                       CLLEVL
     O**********             CLGLAI                                                         AR676213
     O                       CLRAN
     O                       CLGLAC                                                         AR676213
