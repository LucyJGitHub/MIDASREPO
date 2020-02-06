     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Construct a CM Hierarchy Chain')              *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100604 - Construct a Cash Management Hierarchy Chain       *
      *                                                               *
      *  Function:  This program constructs a chain of accounts from  *
      *             a supplie link up to the top of the hierarchy.    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR679670           Date 26Nov10               *
      *                 AR676213           Date 19Nov10               *
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
      *  AR679670 - Apply fix 255837                                  *
      *  255837 - Fix overdraft validation.  Updated cleared balance  *
      *           not returned.  Set on LR indicator so that eveytime *
      *           program is executed, it will access the accounts    *
      *           file to obtain the latest details.                  *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D X_CACD          S             10  0                                                    CGL029
     D X_ACCD          S             10                                                       CGL029
     D I_PACD          S             10  0                                                    CGL029
 
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
 
      ** 'Last' Chain Arrays
     D***L_GLAI*         S             18    DIM(99)                                          CGL029
     D L_GLAI          S             24    DIM(99)                                            CGL029
     D L_RAN           S             10    DIM(99)
     D L_AST           S              1    DIM(99)
     D L_PC            S              4    DIM(99)
     D L_ASC           S              2    DIM(99)
     D L_ODFT          S             15S 0 DIM(99)
     D L_BAIC          S              1    DIM(99)
     D L_ICTB          S             15S 0 DIM(99)
 
 
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
 
 
      * Cash Management Hierarchy Links
     D RECMHL        E DS                  EXTNAME(RECMHLPD)
      * Zero Balancing/Sweeping Hierarchy Links
     D REZSHL        E DS                  EXTNAME(REZSHLPD)
      * Group A/c Hierarchy Links
     D REGAHL        E DS                  EXTNAME(REGAHLPD)
 
 
      * A/C Code Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        O_GLAI
     C                   MOVEL     *BLANK        O_RAN
     C                   MOVEL     *BLANK        O_AST
     C                   MOVEL     *BLANK        O_PC
     C                   MOVEL     *BLANK        O_ASC
     C                   MOVEL     *BLANK        O_ODFT
     C                   MOVEL     *BLANK        O_BAIC
     C                   MOVEL     *BLANK        O_ICTB
     C                   Z-ADD     *ZERO         O_CNTCH
 
      * If parent passed in,
      * then the top of the hierarchy has been reached
 
     C     I_PBRC        IFEQ      *BLANK
     C*****I_PCUS        ANDEQ     *ZERO                                                      CSD027
     C     I_PCUS        ANDEQ     *BLANKS                                                    CSD027
     C     I_PCCY        ANDEQ     *BLANK
     C     I_PACD        ANDEQ     *ZERO
     C     I_PASN        ANDEQ     *ZERO
     C                   MOVEL     '*TOP'        X_RTCD
     C                   RETURN
     C                   ENDIF
 
      * Starting parent a/c ID
 
     C                   MOVEL     I_PBRC        BRC
     C                   MOVEL     I_PCUS        CUS
     C                   MOVEL     I_PCCY        CCY
     C                   MOVEL     I_PACD        ACD
     C                   MOVEL     I_PASN        ASN
 
      * If starting parent a/c ID = last parent a/c ID
      * then return 'last' chains
 
     C     ACCID         IFEQ      L_ACCID
     C                   MOVEL     L_GLAI        O_GLAI
     C                   MOVEL     L_RAN         O_RAN
     C                   MOVEL     L_AST         O_AST
     C                   MOVEL     L_PC          O_PC
     C                   MOVEL     L_ASC         O_ASC
     C                   MOVEL     L_ODFT        O_ODFT
     C                   MOVEL     L_BAIC        O_BAIC
     C                   MOVEL     L_ICTB        O_ICTB
     C                   Z-ADD     L_CNTCH       O_CNTCH
     C                   RETURN
     C                   ENDIF
 
      * Access hierarchy link record for starting parent a/c
 
     C                   MOVEL     I_HIER        X_HIER
     C                   MOVEL     I_HTYP        X_HTYP
 
     C                   EXSR      ACS_LINK
 
      * If a/c not found on the hierarchy link, it is an error
 
     C     X_RTCD        IFEQ      '*NOREC'
     C                   EVAL      X_ERMS = 'BAD A/C LINK:' + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set last parent a/c ID = starting parent a/c ID
 
     C                   MOVEL     ACCID         L_ACCID
 
      * Do until no more hierarchy link records found
 
     C                   Z-ADD     *ZERO         C                 2 0
     C     X_RTCD        DOUEQ     '*NOREC'
 
      * Access a/c details for starting parent a/c
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
     C   60              MOVEL     'C'           RECI
 
      * Access a/c code
 
     C                   EXSR      ACS_ACOD
 
      * Update chain
 
     C                   ADD       1             C
     C                   EXSR      UPD_CHAIN
 
      * Last parent a/c ID read
 
     C                   MOVEL     CLPBRC        BRC
     C                   MOVEL     CLPCUS        CUS
     C                   MOVEL     CLPCCY        CCY
     C                   MOVEL     CLPACD        ACD
     C                   MOVEL     CLPASN        ASN
 
      * Access hierarchy link record for last parent a/c ID read
 
     C                   EXSR      ACS_LINK
 
     C                   ENDDO
 
      * Update 'last' details
 
     C                   MOVEL     O_GLAI        L_GLAI
     C                   MOVEL     O_RAN         L_RAN
     C                   MOVEL     O_AST         L_AST
     C                   MOVEL     O_PC          L_PC
     C                   MOVEL     O_ASC         L_ASC
     C                   MOVEL     O_ODFT        L_ODFT
     C                   MOVEL     O_BAIC        L_BAIC
     C                   MOVEL     O_ICTB        L_ICTB
     C                   Z-ADD     O_CNTCH       L_CNTCH           2 0
 
     C                   MOVE      '1'           *INLR                                        255837
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Access hierarchy link records
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
     C                   PARM                    X_HIER            9 0
      * Hierarchy Type
     C                   PARM                    X_HTYP            2
      * Link ID
     C                   PARM      *ZERO         X_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      BRC           X_CBRC            3
     C**********         PARM      CUS           X_CCUS            6 0                        CSD027
     C                   PARM      CUS           X_CCUS            6                          CSD027
     C                   PARM      CCY           X_CCCY            3
     C**********         PARM      ACD           X_CACD            4 0                        CGL029
     C                   PARM      ACD           X_CACD                                       CGL029
     C                   PARM      ASN           X_CASN            2 0
 
     C                   PARM                    RECMHL
     C                   PARM                    REZSHL
     C                   PARM                    REGAHL
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
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
      * Update chain
      ********************************************************************
     C     UPD_CHAIN     BEGSR
 
     C                   MOVEL     ACCID         O_GLAI(C)
     C                   MOVEL     ACNO          O_RAN(C)
     C                   MOVEL     RECI          O_AST(C)
     C                   MOVEL     PRFC          O_PC(C)
     C                   MOVEL     A5ACSC        O_ASC(C)
     C                   Z-ADD     ODLN          O_ODFT(C)
     C     I_HTYP        IFEQ      'GA'
     C                   MOVEL     GLBAIC        O_BAIC(C)
     C                   MOVEL     GLICTB        O_ICTB(C)
     C                   ENDIF
 
     C                   ADD       1             O_CNTCH
 
     C                   ENDSR
      ********************************************************************
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
      * Hierarchy ID
     C                   PARM                    I_HIER            9 0
      * Hierarchy Type
     C                   PARM                    I_HTYP            2
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
