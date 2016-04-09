     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Determine if Posting To Grp A/c Hierarchy')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100614 - Determine if Posting To Group A/c Hierarchy       *
      *                                                               *
      *  Function:  This program is given a zero balancing/sweeping   *
      *             a/c. It determines whether that a/c exists in a   *
      *             group a/c hierarchy. If so, and the a/c is a top  *
      *             or level a/c, the transaction a/c is recovered.   *
      *             Finally, the chain for the group a/c hierarchy    *
      *             a/c to post to is determined.                     *
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
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FREGAHLJ2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAHLD0:REGAHLDJ2)
     FREGAHLJ0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAHLD0:REGAHLDJ0)
     FRECMHDL0  IF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D I_PACD          S             10  0                                                    CGL029
     D I_ACD           S             10  0                                                    CGL029
     D O_RACD          S             10  0                                                    CGL029
     D X_ACCD          S             10                                                       CGL029
 
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
 
 
      * A/C Code Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
 
      * Clear outputs
 
     C                   MOVEL     'N'           O_AcInGAH
     C                   MOVEL     *BLANK        O_GCAT
 
     C                   Z-ADD     *ZERO         O_RHIER
     C                   MOVEL     *BLANK        O_RHISN
 
     C                   Z-ADD     *ZERO         O_RLINK
 
     C                   MOVEL     *BLANK        O_RBRC
     C**********         Z-ADD     *ZERO         O_RCUS                                       CSD027
     C                   EVAL      O_RCUS = *BLANKS                                           CSD027
     C                   MOVEL     *BLANK        O_RCCY
     C                   Z-ADD     *ZERO         O_RACD
     C                   Z-ADD     *ZERO         O_RASN
 
     C                   MOVEL     *BLANK        O_RCAT
 
     C                   Z-ADD     *ZERO         O_RRNO
     C                   MOVEL     *BLANK        O_RPRF
     C                   MOVEL     *BLANK        O_RACS
     C                   MOVEL     *BLANK        O_RATY
 
     C                   Z-ADD     *ZERO         O_RLEVL
 
     C                   MOVEL     *BLANK        O_GLAI
     C                   MOVEL     *BLANK        O_RAN
     C                   MOVEL     *BLANK        O_AST
     C                   MOVEL     *BLANK        O_PC
     C                   MOVEL     *BLANK        O_ASC
     C                   Z-ADD     *ZERO         O_ODFT
     C                   MOVEL     *BLANK        O_BAIC
     C                   Z-ADD     *ZERO         O_ICTB
     C                   Z-ADD     *ZERO         O_CNTCH
 
      * A/c ID
 
     C                   MOVEL     I_BRC         BRC
     C                   MOVEL     I_CUS         CUS
     C                   MOVEL     I_CCY         CCY
     C                   MOVEL     I_ACD         ACD
     C                   MOVEL     I_ASN         ASN
 
      * Determine if a/c is any a/c in a group a/c hierarchy
 
     C     ACCNTK        CHAIN     REGAHLJ2                           60
 
      * If a/c is NOT in a group a/c hierarchy
      * then return
 
     C     *IN60         IFEQ      '1'
     C                   RETURN
     C                   ENDIF
 
     C                   MOVEL     'Y'           O_AcInGAH
     C                   MOVEL     CLCCAT        O_GCAT
 
      * If a/c is a TOP or LEVEL a/c
 
     C     CLCCAT        IFEQ      'T'
     C     CLCCAT        OREQ      'L'
 
      * Transaction a/c of top or level a/c
 
     C                   MOVEL     GLTBRC        BRC
     C                   MOVEL     GLTCUS        CUS
     C                   MOVEL     GLTCCY        CCY
     C                   MOVEL     GLTACD        ACD
     C                   MOVEL     GLTASN        ASN
 
      * Access transaction a/c as a sub a/c from a group a/c hierarchy
 
     C     ACCNTK        CHAIN     REGAHLJ0                           60
 
      * If the transaction a/c is NOT a sub a/c in a group a/c hierarchy
      * then it's a database error
 
     C     *IN60         IFEQ      '1'
     C                   EVAL      X_ERMS = 'TRANSACTION A/C MISSING FROM' +
     C                                      ' GROUP A/C HIERARCHY:' + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Access a/c details
     C                   MOVEL     'TRANSACTION' AcType           11
     C                   EXSR      ACS_ACCNT
 
      * Access A/c code
     C                   EXSR      ACS_ACOD
 
      * Replication retail no.
      * Replication a/c profit centre
      * Replication a/c account section
      * Replication a/c account type
     C                   Z-ADD     ACNO          O_RRNO
     C                   MOVEL     PRFC          O_RPRF
     C                   MOVEL     A5ACSC        O_RACS
     C                   MOVEL     A5ACTY        O_RATY
 
      * Otherwise, a/c is a SUB a/c
 
     C                   ELSE
 
      * Replication retail no.
      * Replication a/c profit centre
      * Replication a/c account section
      * Replication a/c account type
     C                   Z-ADD     I_RNO         O_RRNO
     C                   MOVEL     I_PRF         O_RPRF
     C                   MOVEL     I_ACS         O_RACS
     C                   MOVEL     I_ATY         O_RATY
 
     C                   ENDIF
 
      * Access hierarchy details
 
     C                   EXSR      ACS_HIER
 
      * Replication Hierarchy ID
      * Replication Hierarchy Shortname
     C                   MOVEL     CLHIER        O_RHIER
     C                   MOVEL     CDHISN        O_RHISN
 
      * Replication Link ID
     C                   MOVEL     CLLINK        O_RLINK
 
      * Replication Branch
      * Replication Customer
      * Replication Currency
      * Replication A/c code
      * Replication A/c seq.
     C                   MOVEL     CLCBRC        O_RBRC
     C                   MOVEL     CLCCUS        O_RCUS
     C                   MOVEL     CLCCCY        O_RCCY
     C                   MOVEL     CLCACD        O_RACD
     C                   MOVEL     CLCASN        O_RASN
 
      * Replication A/c Category
     C                   MOVEL     CLCCAT        O_RCAT
 
      * Replication Source level
     C                   MOVEL     CLLEVL        O_RLEVL
 
      * Construct a CM Hierarchy Chain
 
     C                   EXSR      CON_HCHN
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
 
      * If a/c is not found or is closed
      * then it's a database error
 
     C     *IN60         IFEQ      '1'
     C     RECI          ORNE      'D'
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
      * Access hierarchy details
      ********************************************************************
     C     ACS_HIER      BEGSR
 
     C     CLHIER        CHAIN     RECMHDD0                           60        *
 
      * If hierarchy is not found
      * then it's a database error
 
     C     *IN60         IFEQ      '1'
     C                   MOVE      CLHIER        WERMS             9
     C                   EVAL      X_ERMS = 'BAD HIERARCHY:' + WERMS
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
     C                   EVAL      X_ERMS = 'CONSTRUCT A CM ' +
     C                                      'HIERACHY CHAIN FAILED'
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
 
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
 
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
     C                   PARM                    I_ACD                                        CGL029
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
     C                   PARM                    O_RACD                                       CGL029
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
 
      * key lists
 
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
