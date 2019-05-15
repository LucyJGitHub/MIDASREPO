     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Hierarchy Links Enquiry')     *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100452 - Cash Management Hierarchy Links Enquiry           *
      *                                                               *
      *  Function: This module allows enquiry into Cash Management    *
      *            Hierarchy Links                                    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR676213           Date 19Nov10               *
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
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRE100452DFCF   E             WORKSTN INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
     FRECMBRL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D I_CACCID        S             24                                                       CGL029
     D I_PACCID        S             24                                                       CGL029
     D I_SACCID        S             24                                                       CGL029
     D I_IIACID        S             24                                                       CGL029
     D I_IEACID        S             24                                                       CGL029
     D I_TACCID        S             24                                                       CGL029
     D I_IACCID        S             24                                                       CGL029
     D I_EACCID        S             24                                                       CGL029
     D DDCACC          S             28                                                       CGL029
     D DDPACC          S             28                                                       CGL029
     D DDSACC          S             28                                                       CGL029
     D DDINAC          S             28                                                       CGL029
     D DDIXAC          S             28                                                       CGL029
     D DDTACC          S             28                                                       CGL029
     D DDIACC          S             28                                                       CGL029
     D DDEACC          S             28                                                       CGL029
     D I_CACD          S             10  0                                                    CGL029
     D I_RACCID        S             24                                                       CGL029
 
      * Cash Management Hierarchy Links
     D O_CMHL        E DS                  EXTNAME(RECMHLPD)
     D A_HIER                  1      9
     D A_LINK                 10     18
     D***C_ACCID                19     36                                                     CGL029
     D***P_ACCID                38     55                                                     CGL029
     D C_ACCID                19     42                                                       CGL029
     D P_ACCID                44     67                                                       CGL029
      * Zero Balancing/Sweeping Hierarchy Links
     D O_ZSHL        E DS                  EXTNAME(REZSHLPD)
     D***S_ACCID               108    125                                                     CGL029
     D***S_IIACID              246    263                                                     CGL029
     D***S_IEACID              264    281                                                     CGL029
     D S_ACCID1Temp          108    119                                                       CGL029
     D S_ACCID2Temp          282    291                                                       CGL029
     D S_ACCID3Temp          124    125                                                       CGL029
     D S_IIACID1Temp         246    257                                                       CGL029
     D S_IIACID2Temp         292    301                                                       CGL029
     D S_IIACID3Temp         262    263                                                       CGL029
     D S_IEACID1Temp         264    275                                                       CGL029
     D S_IEACID2Temp         302    311                                                       CGL029
     D S_IEACID3Temp         280    281                                                       CGL029
                                                                                              CGL029
      ** Shadow Account                                                                       CGL029
     D S_ACCID                 1     24                                                       CGL029
     D S_ACCID1                1     12                                                       CGL029
     D S_ACCID2               13     22                                                       CGL029
     D S_ACCID3               23     24                                                       CGL029
                                                                                              CGL029
      ** Income Account                                                                       CGL029
     D S_IIACID                1     24                                                       CGL029
     D S_IIACID1               1     12                                                       CGL029
     D S_IIACID2              13     22                                                       CGL029
     D S_IIACID3              23     24                                                       CGL029
                                                                                              CGL029
      ** Expense Account                                                                      CGL029
     D S_IEACID                1     24                                                       CGL029
     D S_IEACID1               1     12                                                       CGL029
     D S_IEACID2              13     22                                                       CGL029
     D S_IEACID3              23     24                                                       CGL029
                                                                                              CGL029
      * Group Account Hierarchy Links
     D O_GAHL        E DS                  EXTNAME(REGAHLPD)
     D***T_ACCID                28     45                                                     CGL029
     D***I_ACCID                46     63                                                     CGL029
     D***E_ACCID                64     81                                                     CGL029
     D T_ACCID                28     51                                                       CGL029
     D I_ACCID                52     75                                                       CGL029
     D E_ACCID                76     99                                                       CGL029
 
 
      * Hierarchy Links
     D I_HIERLINKS     S              9S 0 DIM(999)
 
 
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
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      /SPACE 5
 
 
      * Enable F8 (Next Link) and F9 (Previous Link)
 
     C     L             COMP      Last_Link_No                         08
     C     L             COMP      1                                  09
 
      * Access Hierarchy Link
 
     C                   EXSR      ACS_LINK
 
      * Convert Cash Management Member
 
     C                   EXSR      CNV_CMMEMBER
 
      * If a zero-balancing/sweeping hierarchy
      * ---------------------------------------
      * Convert Zero Balancing/Sweeping Member
 
      * If a group account hierarchy
      * ----------------------------
      * Convert Group A/c Member
 
     C     I_HTYP        IFEQ      'ZS'
     C     RECMBRK       CHAIN     RECMBRD0                           70        *
     C                   EXSR      CNV_ZSMEMBER
     C                   ELSE
     C                   EXSR      CNV_GAMEMBER
     C                   ENDIF
 
      * Access retail a/c numbers
 
     C                   EXSR      ACS_RAN
 
      * Display screen until F3, F8, F9 or F12 taken
 
     C     *INKC         DOWEQ     '0'
     C     *INKH         ANDEQ     '0'
     C     *INKI         ANDEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END
 
      * Pass back function keys taken
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
 
      * End of program
 
     C   KC
     COR KL              SETON                                        LR
 
      * Next or Previous Link
 
     C   KH
     COR KI              DO
     C   KH              ADD       1             L
     C   KI              SUB       1             L
     C                   MOVEL     I_HIERLINKS(L)I_LINK
     C                   MOVE      '0'           *INKH
     C                   MOVE      '0'           *INKI
     C                   ENDDO
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR
 
      * Write and read screen
 
     C                   TIME                    DDTIME
     C
     C     I_HTYP        IFEQ      'GA'
     C                   EXFMT     GROUPAC
     C                   ELSE
     C     ZLSTYP        IFEQ      'Z'
     C                   EXFMT     ZEROBL
     C                   ELSE
     C                   EXFMT     SWEEP
     C                   ENDIF
     C                   ENDIF
 
      ** Account Movements Enquiry
 
     C     *INKC         IFNE      '1'
     C     *INKH         ANDNE     '1'
     C     *INKI         ANDNE     '1'
     C     *INKL         ANDNE     '1'
     C                   EXSR      ACC_MOVES
     C                   MOVE      @INKC         *INKC
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      ** Account Movements Enquiry
      *****************************************************************
     C     ACC_MOVES     BEGSR
 
      * Call the Cash Management Account Movements Enquiry
 
     C                   CALL      'RE100453'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Link ID
     C                   PARM                    I_LINK            9 0
 
      * Requested Account ID
     C**********         PARM      C_ACCID       I_RACCID         18                          CGL029
     C                   PARM      C_ACCID       I_RACCID                                     CGL029
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
 
      * Error
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ENQUIRY FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
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
     C                   PARM                    I_HIER            9 0
      * Hierarchy Type
     C                   PARM                    I_HTYP            2
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM      *BLANK        I_CBRC            3
     C**********         PARM      *ZERO         I_CCUS            6 0                        CSD027
     C                   PARM      *BLANKS       I_CCUS            6                          CSD027
     C                   PARM      *BLANK        I_CCCY            3
     C**********         PARM      *ZERO         I_CACD            4 0                        CGL029
     C                   PARM      *ZERO         I_CACD                                       CGL029
     C                   PARM      *ZERO         I_CASN            2 0
 
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
      *******************************************************************                     CGL029
      /SPACE 5                                                                                CGL029
      ********************************************************************                    CGL029
      *                                                                  *                    CGL029
      * SrAccounts -  Set-up Account IDs                                 *                    CGL029
      *                                                                  *                    CGL029
      ********************************************************************                    CGL029
     C     SrAccounts    BEGSR                                                                CGL029
                                                                                              CGL029
      ** Shadow Acoount                                                                       CGL029
     C                   EVAL      S_ACCID1 = S_ACCID1Temp                                    CGL029
     C                   EVAL      S_ACCID2 = S_ACCID2Temp                                    CGL029
     C                   EVAL      S_ACCID3 = S_ACCID3Temp                                    CGL029
                                                                                              CGL029
      ** Income Acoount                                                                       CGL029
     C                   EVAL      S_IIACID1 = S_IIACID1Temp                                  CGL029
     C                   EVAL      S_IIACID2 = S_IIACID2Temp                                  CGL029
     C                   EVAL      S_IIACID3 = S_IIACID3Temp                                  CGL029
                                                                                              CGL029
      ** Expense Account                                                                      CGL029
     C                   EVAL      S_IEACID1 = S_IEACID1Temp                                  CGL029
     C                   EVAL      S_IEACID2 = S_IEACID2Temp                                  CGL029
     C                   EVAL      S_IEACID3 = S_IEACID3Temp                                  CGL029
                                                                                              CGL029
     C                   ENDSR                                                                CGL029
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Cash Management Member
      ********************************************************************
     C     CNV_CMMEMBER  BEGSR
 
     C                   CALLB     'RE100314'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Child a/c
      * Parent a/c
     C**********         PARM      C_ACCID       I_CACCID         18                          CGL029
     C**********         PARM      P_ACCID       I_PACCID         18                          CGL029
     C                   PARM      C_ACCID       I_CACCID                                     CGL029
     C                   PARM      P_ACCID       I_PACCID                                     CGL029
 
      * OUTPUTS
      * Child a/c
      * Parent a/c
     C**********         PARM                    DDCACC           22                          CGL029
     C**********         PARM                    DDPACC           22                          CGL029
     C                   PARM                    DDCACC                                       CGL029
     C                   PARM                    DDPACC                                       CGL029
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN CASH MANAGEMENT MEMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Zero Balancing/Sweeping Member
      ********************************************************************
     C     CNV_ZSMEMBER  BEGSR
 
     C                   EXSR      SrAccounts                                                 CGL029
                                                                                              CGL029
     C                   CALLB     'RE100315'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Child Currency
     C                   PARM      CLCCCY        I_CCCY            3
      * Edit code
     C                   PARM      'J'           I_ECODE           1
      * Date format
     C                   PARM      'A'           I_DATFMT          1
      * Sweep Type
     C                   PARM      ZLSTYP        I_STYP            1
      * Sweeping Frequency
      * Sweeping Day
      * Last Sweep Date
      * Next Sweep Date
     C                   PARM      ZLSFRQ        I_SFRQ            1
     C                   PARM      ZLSDAY        I_SDAY            2 0
     C                   PARM      ZLLSDT        I_LSDT            5 0
     C                   PARM      ZLNSDT        I_NSDT            5 0
      * Sweep Capitalized Interest
      * Sweep Cleared Balance on Association Date
      * Zero Balance - Net or Gross
     C                   PARM      ZLSCPI        I_SCPI            1
     C                   PARM      ZLSCBD        I_SCBD            1
     C                   PARM      ZLZBNG        I_ZBNG            1
      * Target Balance
     C                   PARM      ZLTGBL        I_TGBL           15 0
      * Reverse Sweep
     C                   PARM      ZLRVSW        I_RVSW            1
      * Shadow a/c
     C**********         PARM      S_ACCID       I_SACCID         18                          CGL029
     C                   PARM      S_ACCID       I_SACCID                                     CGL029
      * Internal Interest Interest Income Account
     C**********         PARM      S_IIACID      I_IIACID         18                          CGL029
     C                   PARM      S_IIACID      I_IIACID                                     CGL029
      * Internal Interest Expense Account
     C**********         PARM      S_IEACID      I_IEACID         18                          CGL029
     C                   PARM      S_IEACID      I_IEACID                                     CGL029
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM      ZLMINB        I_MINB           15 0
     C                   PARM      ZLMINL        I_MINL           15 0
     C                   PARM      ZLMAXB        I_MAXB           15 0
     C                   PARM      ZLMAXL        I_MAXL           15 0
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM      ZLMDVD        I_MDVD           15 0
     C                   PARM      ZLMDCD        I_MDCD            3 0
      * Floor Limit for Top
      * Floor Limit for Sweep
     C                   PARM      ZLFLFT        I_FLFT           15 0
     C                   PARM      ZLFLFS        I_FLFS           15 0
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Sweep Type
     C                   PARM                    DDSTYP           12
      * Sweeping Frequency
      * Sweeping Day
      * Last Sweep Date
      * Next Sweep Date
     C                   PARM                    DDSFRQ           30
     C                   PARM                    DDSDAY            2
     C                   PARM                    DDLSDT            7
     C                   PARM                    DDNSDT            7
      * Sweep Capitalized Interest
      * Sweep Cleared Balance on Association Date
      * Zero Balance - Net or Gross
     C                   PARM                    DDSCPI            3
     C                   PARM                    DDSCBD            3
     C                   PARM                    DDZBNG            5
      * Target Balance
     C                   PARM                    DDTGBL           22
      * Reverse Sweep
     C                   PARM                    DDRVSW            3
      * Shadow a/c
     C**********         PARM                    DDSACC           22                          CGL029
     C                   PARM                    DDSACC                                       CGL029
      * Internal Interest Income Account
     C**********         PARM                    DDINAC           22                          CGL029
     C                   PARM                    DDINAC                                       CGL029
      * Internal Interest Expense Account
     C**********         PARM                    DDEXAC           22                          CGL029
     C                   PARM                    DDEXAC                                       CGL029
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM                    DDMINB           22
     C                   PARM                    DDMINL           22
     C                   PARM                    DDMAXB           22
     C                   PARM                    DDMAXL           22
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM                    DDMDVD           22
     C                   PARM                    DDMDCD            5
      * Floor Limit for Top
      * Floor Limit for Sweep
     C                   PARM                    DDFLFT           22
     C                   PARM                    DDFLFS           22
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN ZERO BAL/SWEEPING MEMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Group A/c Member
      ********************************************************************
     C     CNV_GAMEMBER  BEGSR
 
     C                   CALLB     'RE100316'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Child Currency
     C                   PARM      CLCCCY        I_CCCY            3
      * Edit code
     C                   PARM      'J'           I_ECODE           1
 
      * Balance Available for Inter Company Overdraft
      * Inter Company Threshold Balance
     C                   PARM      GLBAIC        I_BAIC            1
     C                   PARM      GLICTB        I_ICTB           15 0
      * Transaction A/c
      * (Interest) Income A/c
      * (Interest) Expense A/c
     C**********         PARM      T_ACCID       I_TACCID         18                          CGL029
     C**********         PARM      I_ACCID       I_IACCID         18                          CGL029
     C**********         PARM      E_ACCID       I_EACCID         18                          CGL029
     C                   PARM      T_ACCID       I_TACCID                                     CGL029
     C                   PARM      I_ACCID       I_IACCID                                     CGL029
     C                   PARM      E_ACCID       I_EACCID                                     CGL029
 
      * OUTPUTS
 
      * Balance Available for Inter Company Overdraft
      * Inter Company Threshold Balance
     C                   PARM                    DDBAIC            3
     C                   PARM                    DDICTB           22
      * Transaction A/c
      * (Interest) Income A/c
      * (Interest) Expense A/c
     C**********         PARM                    DDTACC           22                          CGL029
     C**********         PARM                    DDIACC           22                          CGL029
     C**********         PARM                    DDEACC           22                          CGL029
     C                   PARM                    DDTACC                                       CGL029
     C                   PARM                    DDIACC                                       CGL029
     C                   PARM                    DDEACC                                       CGL029
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN GROUP A/C MEMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *****************************************************************
      * Access retail a/c numbers
      *****************************************************************
     C     ACS_RAN       BEGSR
 
      * Child a/c
     C                   MOVEL     C_ACCID       ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDCRAN
     C                   MOVEL     A_ANAM        DDCANM
      * Parent a/c
     C                   MOVEL     P_ACCID       ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDPRAN
     C                   MOVEL     A_ANAM        DDPANM
 
     C     I_HTYP        IFEQ      'ZS'
      * Shadow a/c
     C                   MOVEL     S_ACCID       ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDSRAN
      * Internal Interest Debit a/c
     C                   MOVEL     S_IIACID      ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDINRN
      * Internal Interest Credit a/c
     C                   MOVEL     S_IEACID      ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDEXRN
     C                   ENDIF
 
     C     I_HTYP        IFEQ      'GA'
      * Transaction a/c
     C                   MOVEL     T_ACCID       ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDTRAN
      * Interest income a/c
     C                   MOVEL     I_ACCID       ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDIRAN
      * Interest expense a/c
     C                   MOVEL     E_ACCID       ACCID
     C                   EXSR      ACS_ACCNT
     C                   MOVEL     A_ACNO        DDERAN
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
     C  N60              MOVEL     ACNO          A_ACNO           10
     C  N60              MOVEL     ANAM          A_ANAM           20
     C   60              MOVEL     *BLANK        A_ACNO
     C   60              MOVEL     *BLANK        A_ANAM
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *****************************************************************
      * ZASNMS - SEND A MESSAGE
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   CALL      'Y2SNMGC'                            0909    *
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      'REUSRMSG'    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Type
      * Hierarchy Description
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HISN           10
     C                   PARM                    I_HTYP            2
     C                   PARM                    I_DESC           50
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Hierarchy Links
     C                   PARM                    I_HIERLINKS
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Initialize program name
 
     C                   MOVEL     'RE100452 '   DDPGM
 
      * Set up standard screen fields.
 
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Determine last link number
 
     C                   Z-ADD     1             L                 3 0
     C     *ZERO         LOOKUP    I_HIERLINKS(L)                         99
     C     L             SUB       1             Last_Link_No      3 0
 
      * Determine current link number
 
     C                   Z-ADD     1             L
     C     I_LINK        LOOKUP    I_HIERLINKS(L)                         99
     C     *IN99         IFEQ      '0'
     C                   EVAL      X_ERMS = 'BAD LINK'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     RECMBRK       KLIST
     C                   KFLD                    I_HIER
     C                   KFLD                    I_LINK
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
