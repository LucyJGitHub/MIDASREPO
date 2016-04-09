     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash management hierarchy links & unlinks')   *
/*XBIA*  OVRDBF FILE(RELCMHDLU) TOFILE(RELCMHDL0) SHARE(*NO)          *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100711 - Cash management hierarchy links & unlinks         *
      *                                                               *
      *  Function:  This program identifies what links and unlinks    *
      *             have occurred due to the take-on of the 'live'    *
      *             hierarchy detail and link files.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRECMHDL0  IP  AE           K DISK    INFSR(*PSSR)
     FRELCMHDL0 IS  AE           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHDD0:RELCMHDD0)
     FRECMHLL0  IF   E           K DISK    INFSR(*PSSR)
     FRELCMHLL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:RELCMHLD0)
     FREGAHDL0  IF   E           K DISK    INFSR(*PSSR)
     FRELGAHDL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REGAHDD0:RELGAHDD0)
     FACCNT     UF   E           K DISK    INFSR(*PSSR)
     FRELCMHDLU UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHDD0:RELCMHDUP)
     F                                     PREFIX(U_)
     FRE100711P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     FRECMLCPD  O    E           K DISK    INFSR(*PSSR)
 
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
 
 
     D                 DS
     D CLHIER                  1      9  0
     D CLLINK                 10     18  0
     D A_HIER                  1      9
     D A_LINK                 10     18
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      ** File Information Data Structure for RE100711P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
     IRECMHDD0      01
     I                                          CDHIER        L1M1
 
     IRELCMHDD0     02
     I                                          CDHIER        L1M1
 
     C                   ADD       1             Count
 
     CL1   Count         IFNE      0
     CL1                 EXSR      CHK_UNLINKS
     CL1                 EXSR      CHK_LINKS
     CL1                 ENDIF
     CL1                 Z-ADD     0             Count             5 0
 
 
      * Produce end of report
 
     CLR                 EXSR      END_OF_REP
      /SPACE 5
      ********************************************************************
      * Check for unlinks
      ********************************************************************
     C     CHK_UNLINKS   BEGSR
 
      * Reset count
 
     C                   Z-ADD     1             C                 5 0
 
      * Search for records present on the current file but not the live file
 
     C     CDHIER        SETLL     RECMHLD0
     C     CDHIER        READE     RECMHLD0                               60
     C     *IN60         DOWEQ     '0'
 
     C     RECMHLK       SETLL     RELCMHLD0                              50
 
      * If record not found on live file
      *   Access parent a/c
      *   Access (and update) child a/c
      *   Report unlink
      *   Write to the link changes file
 
     C     *in50         IFEQ      '0'
     C                   MOVEL     'UNLINK'      R_LKUL
     C                   EXSR      ACS_PARENTAC
     C                   EXSR      ACS_CHILDAC
     C                   EXSR      REP_LINK
     C                   EXSR      WRT_RECMLC
     C                   ADD       1             C
     C                   ENDIF
 
     C     CDHIER        READE     RECMHLD0                               60
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Check for links
      ********************************************************************
     C     CHK_LINKS     BEGSR
 
      * Reset count
 
     C                   Z-ADD     1             C
 
      * Search for records present on the live file but not the current file
 
     C     CDHIER        SETLL     RELCMHLD0
     C     CDHIER        READE     RELCMHLD0                              60
     C     *IN60         DOWEQ     '0'
 
     C     RECMHLK       SETLL     RECMHLD0                               50
 
      * If record not found on current file
      *   Access parent a/c
      *   Access (and update) child a/c
      *   Report link
      *   Write to the link changes file
 
     C     *in50         IFEQ      '0'
     C                   MOVEL     'LINK  '      R_LKUL
     C                   EXSR      ACS_PARENTAC
     C                   EXSR      ACS_CHILDAC
     C                   EXSR      REP_LINK
     C                   EXSR      WRT_RECMLC
     C                   ADD       1             C
     C                   ENDIF
 
     C     CDHIER        READE     RELCMHLD0                              60
     C                   ENDDO
 
      * Update 'Hierarchy Links Today' on hierarchy header
 
     C     C             IFGT      1
     C     CDHIER        CHAIN     RELCMHDUP                          60
     C  N60              MOVEL     'Y'           U_CDHLKT
     C  N60              EXCEPT    URELCMHD
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Report link
      ********************************************************************
     C     REP_LINK      BEGSR
 
      * Space
     C     C             IFEQ      1
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     SPACE
     C                   ENDIF
 
      * Show retail a/c numbers
 
     C     CLCRNO        COMP      0                                  3535      *
     C     CLPBRC        COMP      '   '                              3636      *
     C     CLPRNO        COMP      0                                  3737      *
 
      * Edit CHILD last dr/cr capitalization dates
      * Edit CHILD next dr/cr capitalization dates
 
     C     CDHTYP        IFEQ      'GA'
 
     C                   Z-ADD     LDID          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_LDID
 
     C                   Z-ADD     LCID          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_LCID
 
     C                   Z-ADD     NDID          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_NDID
 
     C                   Z-ADD     NCID          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_NCID
 
     C                   ELSE
 
     C                   MOVEL     *BLANK        R_LDID
     C                   MOVEL     *BLANK        R_LCID
     C                   MOVEL     *BLANK        R_NDID
     C                   MOVEL     *BLANK        R_NCID
 
     C                   ENDIF
 
      * Edit link/unlink date
 
     C                   Z-ADD     LCLUDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_LUDT
 
     C                   Z-ADD     2             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     LINK
 
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
      * Access parent a/c
      ********************************************************************
     C     ACS_PARENTAC  BEGSR
 
      * Get parent a/c details
 
     C                   MOVEL     CLPBRC        BRC
     C                   MOVEL     CLPCUS        CUS
     C                   MOVEL     CLPCCY        CCY
     C                   MOVEL     CLPACD        ACD
     C                   MOVEL     CLPASN        ASN
 
      * If this is not the top a/c
 
     C     CLCCAT        IFNE      'T'
 
     C                   EXSR      ACS_ACCNT
 
      * Parent a/c retail a/c number
 
     C                   Z-ADD     ACNO          CLPRNO
     C                   ELSE
     C                   Z-ADD     *ZERO         CLPRNO
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access (and update) child a/c
      ********************************************************************
     C     ACS_CHILDAC   BEGSR
 
      * Get child a/c details
 
     C                   MOVEL     CLCBRC        BRC
     C                   MOVEL     CLCCUS        CUS
     C                   MOVEL     CLCCCY        CCY
     C                   MOVEL     CLCACD        ACD
     C                   MOVEL     CLCASN        ASN
 
     C                   EXSR      ACS_ACCNT
 
      * Child a/c retail a/c number
 
     C                   Z-ADD     ACNO          CLCRNO
 
      * Default link/inlink date = today
 
     C                   Z-ADD     BJRDNB        LCLUDT
 
      * If this is a group a/c hierarchy
      * and the child a/c is open
 
     C     CDHTYP        IFEQ      'GA'
     C     RECI          ANDEQ     'D'
 
      * Access group a/c link
 
     C     REGAHDK       CHAIN     RELGAHDD0                          60
     C     *IN60         IFEQ      '1'
     C     REGAHDK       CHAIN     REGAHDD0                           60
     C                   ENDIF
 
     C     *IN60         IFEQ      '1'
     C                   EVAL      X_ERMS = 'BAD GROUP A/C DETAIL:' + A_HIER
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If an unlink and unlink is effective as at last capitalization date
      * and last dr and cr capitalization dates are the same
      * then the unlink date is the last dr capitalization date
 
     C     R_LKUL        IFEQ      'UNLINK'
     C     GDUELC        ANDEQ     'Y'
     C     LCID          ANDEQ     LDID
     C                   Z-ADD     LDID          LCLUDT
     C                   ELSE
 
      * If a link and link is effective as at last capitalization date
      * and last dr and cr capitalization dates are the same
      * then the link date is the last dr capitalization date
 
     C     R_LKUL        IFEQ      'LINK  '
     C     GDLELC        ANDEQ     'Y'
     C     LCID          ANDEQ     LDID
     C                   Z-ADD     LDID          LCLUDT
     C                   ELSE
 
      * Otherwise, the link/unlink date will equal
      * a dr and cr capitalization date of today.
 
     C                   SELECT
     C     NCID          WHENNE    0
     C     NCID          ANDLE     BJRDNB
     C                   Z-ADD     NCID          NDID
     C     NDID          WHENNE    0
     C     NDID          ANDLE     BJRDNB
     C                   Z-ADD     NDID          NCID
     C                   OTHER
     C                   Z-ADD     BJRDNB        NDID
     C                   Z-ADD     BJRDNB        NCID
     C                   ENDSL
 
     C                   Z-ADD     *ZERO         LTAC
 
      * Update ACCNT
     C                   EXCEPT    UACCNT
 
     C                   Z-ADD     NDID          LCLUDT
 
     C                   ENDIF
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
     C     *IN60         IFEQ      '1'
     C                   EVAL      X_ERMS = 'BAD A/C:'
     C                                      + ACCID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write to the link changes file
      ********************************************************************
     C     WRT_RECMLC    BEGSR
 
      * Hierarchy ID
     C                   MOVEL     CLHIER        LCHIER
      * Hierarchy Shortname
     C                   MOVEL     CDHISN        LCHISN
      * Hierarchy Type
     C                   MOVEL     CDHTYP        LCHTYP
      * Link
     C                   MOVEL     CLLINK        LCLINK
      * Child Account Branch Code
      * Child Account Customer
      * Child Account Currency
      * Child Account A/C Code
      * Child Account A/C Sequence
     C                   MOVEL     CLCBRC        LCCBRC
     C                   MOVEL     CLCCUS        LCCCUS
     C                   MOVEL     CLCCCY        LCCCCY
     C                   MOVEL     CLCACD        LCCACD
     C                   MOVEL     CLCASN        LCCASN
      * Child A/C Category
     C                   MOVEL     CLCCAT        LCCCAT
      * Parent Account Branch Code
      * Parent Account Customer
      * Parent Account Currency
      * Parent Account A/C Code
      * Parent Account A/C Sequence
     C                   MOVEL     CLPBRC        LCPBRC
     C                   MOVEL     CLPCUS        LCPCUS
     C                   MOVEL     CLPCCY        LCPCCY
     C                   MOVEL     CLPACD        LCPACD
     C                   MOVEL     CLPASN        LCPASN
      * Level
     C                   MOVEL     CLLEVL        LCLEVL
      * Link/Unlink
     C     R_LKUL        IFEQ      'LINK  '
     C                   MOVEL     'L'           LCLKUL
     C                   ELSE
     C                   MOVEL     'U'           LCLKUL
     C                   ENDIF
      * Link/Unlink Date
      * (Set earlier)
     C                   Z-ADD     LCLUDT        LCLUDT
 
     C                   WRITE     RECMLCD0
 
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
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * Register P1 printer file with RCF
     C                   EXSR      RCFP1
 
      * Key lists
 
     C     RECMHLK       KLIST
     C                   KFLD                    CLHIER
     C                   KFLD                    CLCBRC
     C                   KFLD                    CLCCUS
     C                   KFLD                    CLCCCY
     C                   KFLD                    CLCACD
     C                   KFLD                    CLCASN
     C                   KFLD                    CLPBRC
     C                   KFLD                    CLPCUS
     C                   KFLD                    CLPCCY
     C                   KFLD                    CLPACD
     C                   KFLD                    CLPASN
 
     C     REGAHDK       KLIST
     C                   KFLD                    CLHIER
 
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
     ORELCMHDUP E            URELCMHD
     O                       U_CDHLKT
     OACCNTABF  E            UACCNT
     O                       NCID
     O                       NDID
     O                       LTAC
