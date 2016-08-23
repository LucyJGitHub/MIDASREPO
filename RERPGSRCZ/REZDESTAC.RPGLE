     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Determine Destination Account')               *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  REZDESTAC - Determine Destination Account                    *
      *                                                               *
      *  Function:  This program is given destination a/c details and *
      *             a currency and determines the account ID.         *
      *             It also validates the details as well.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD000091           Date 14May13               *
      *  Prev Amend No. AR670009           Date 15Nov10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 215675             Date 10Mar03               *
      *                 211464             Date 03Dec02               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR670009 - Apply fix 248510                                  *
      *  248510 - Error Code RE75111 due to passing of a number to    *
      *           ZAACSACOD, which reads it as a string.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  215675 - Sweep is not stopped when account is inactive       *
      *  211464 - SWIFT address not accepted                          *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMABF)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     FRECMBRL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
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
     D L_BRC                   1      3
     D L_CUS                   4      9S 0
     D L_CCY                  10     12
     D***L_ACD**                13     16S 0                                                  CGL029
     D***L_ASN**                17     18S 0                                                  CGL029
     D L_ACD                  13     22S 0                                                    CGL029
     D L_ASN                  23     24S 0                                                    CGL029
 
 
     D DIGITS          C                   '0123456789'
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      * External DS for Nostro details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** CUSTOMER DETAILS
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** COUNTER PARTY NOSTRO
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      ** BIC DIRECTORY
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      * A/C Code Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D*X_ACCD***       S             10  0                                             CGL029 248510
     D X_ACCD          S             10                                                       248510
     D @ACCD           S             10                                                       CGL029
     D O_PACD          S             10  0                                                    CGL029
 
 
     C                   SELECT
 
      * SWIFT address
      * =============
     C     I_SDSTT       WHENEQ    'S'
 
     C                   EXSR      SWIFT
 
     C                   MOVEL     I_SSNDC       NostroCode        2
     C                   MOVEL     *BLANK        Trailing16       16
 
     C                   EXSR      NOSTRO
 
      * Nostro
      * ======
     C     I_SDSTT       WHENEQ    'N'
 
     C     2             SUBST     I_SDEST:1     NostroCode        2
     C     16            SUBST     I_SDEST:3     Trailing16       16
 
     C                   EXSR      NOSTRO
 
      * Retail account
      * ==============
     C     I_SDSTT       WHENEQ    'R'
 
     C                   EXSR      RETAIL
 
      * Other
      * =====
     C                   OTHER
 
      * 'Destination Type must be S=SWIFT, N=NOSTRO, or R=RETAIL ACCOUNT'
 
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHDSTT   '   FldNameArr(Ix)
     C                   MOVEL     'RE75110 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
 
     C                   ENDSL
 
      * Return if errors
 
     C     Ix            IFGT      0
     C                   RETURN
     C                   ENDIF
 
      * Get a/c section of a/c code
 
     C                   MOVEL     ACOD          X_ACCD
     C                   CALLB     'ZAACSACOD'
     C**********         PARM                    X_ACCD            4                          CGL029
     C                   PARM                    X_ACCD                                       CGL029
     C                   PARM                    SDACOD
 
      * Error if a/c code not found
      * 'Invalid account code for Destination Account'
 
     C     A5ACCD        IFEQ      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHDEST   '   FldNameArr(Ix)
     C                   MOVEL     'RE75111 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      * Return parent a/c details
 
     C                   MOVEL     BRCA          O_PBRC
     C                   MOVEL     CNUM          O_PCUS
     C                   MOVEL     CCY           O_PCCY
     C                   MOVEL     ACOD          O_PACD
     C                   MOVEL     ACSQ          O_PASN
     C                   MOVEL     ACNO          O_PRNO
     C                   MOVEL     PRFC          O_PPRF
     C                   MOVEL     A5ACSC        O_PACS
     C                   MOVEL     A5ACTY        O_PATY
 
      * Determine A/c Status
 
     C                   MOVEL     'PARENT'      AcType
     C                   EXSR      DET_AC_STATUS
     C                   MOVEL     AccountSTAT   O_ParentSTAT
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * SWIFT address
      ********************************************************************
     C     SWIFT         BEGSR
 
     C     8             SUBST     I_SDEST:1     W9BICC
     C     3             SUBST     I_SDEST:9     W9BICB
     C     7             SUBST     I_SDEST:12    Trailing7         7
 
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       W9RTN             7
     C                   PARM                    W9BICC            8
     C                   PARM                    W9BICB            3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       W9CUST            1
     C                   PARM      *BLANKS       W9CNST            1
     C                   PARM      *BLANKS       W9BICD            1
 
      * 'SWIFT BIC code is invalid'
 
     C     W9BICD        IFNE      'Y'
     C     W9CUST        ANDNE     'Y'                                          211464
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHDEST   '   FldNameArr(Ix)
     C                   MOVEL     'RE75112 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Trailing characters after SWIFT BIC code'
 
     C     Trailing7     IFNE      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHDEST   '   FldNameArr(Ix)
     C                   MOVEL     'RE75113 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Nostro
      ********************************************************************
     C     NOSTRO        BEGSR
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANK        @CUST             6
     C                   PARM      I_CCCY        @CYCD             3
     C**********         PARM      *BLANK        @ACCD             4                          CGL029
     C                   PARM      *BLANK        @ACCD                                        CGL029
     C                   PARM      *BLANK        @ACSN             2
     C                   PARM      NostroCode    @NONB             2
     C                   PARM      *BLANK        @BRCD             3
     C                   PARM      *BLANK        @CSSN            10
     C                   PARM      *BLANK        @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
 
      * Error on call
      * 'Invalid nostro code'
 
     C     @RTCD         IFNE      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHDEST   '   FldNameArr(Ix)
     C                   MOVEL     'RE75114 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * Trailing characters
      * 'Trailing characters after nostro code'
 
     C     Trailing16    IFNE      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHDEST   '   FldNameArr(Ix)
     C                   MOVEL     'RE75115 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      * Check nostro account is valid
 
     C                   MOVEL     A7BRCD        BRC
     C                   MOVEL     A7CUST        CUS
     C                   MOVEL     A7CYCD        CCY
     C                   MOVEL     A7ACCD        ACD
     C                   Z-ADD     A7ACSN        ASN
 
      * 'Invalid nostro account'
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
     C     *IN60         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHDEST   '   FldNameArr(Ix)
     C                   MOVEL     'RE75116 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Retail a/c
      ********************************************************************
     C     RETAIL        BEGSR
 
     C                   Z-ADD     1             #I                2 0
     C     DIGITS        CHECK     I_SDEST       #I                       90
 
      *  Valid only if 10 digits - now check rest for blanks
 
     C                   IF        *IN90 = *ON AND #I = 11
 
     C     ' '           CHECK     I_SDEST:11                             90
 
      * Account validation
 
     C                   IF        *IN90 = *OFF
 
     C     10            SUBST     I_SDEST:1     RetailNo         10
     C                   MOVEL     RetailNo      ACNO
 
      * 'Invalid retail account'
 
     C     ACNO          CHAIN     ACNUMABF                           60        *
     C     *IN60         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHDEST   '   FldNameArr(Ix)
     C                   MOVEL     'RE75117 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Invalid retail account'
 
     C                   MOVEL     BRCA          BRC
     C                   MOVEL     CNUM          CUS
     C                   MOVEL     CCY           CCY
     C                   MOVEL     ACOD          ACD
     C                   Z-ADD     ACSQ          ASN
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
     C     *IN60         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     CCY           ORNE      I_CCCY
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHDEST   '   FldNameArr(Ix)
     C                   MOVEL     'RE75117 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
 
      * 'Trailing characters after retail a/c number'
 
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHDEST   '   FldNameArr(Ix)
     C                   MOVEL     'RE75118 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      * 'Invalid retail a/c number'
 
     C                   ELSE
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHDEST   '   FldNameArr(Ix)
     C                   MOVEL     'RE75119 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
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
      * Check for Return
      ********************************************************************
     C     CHK_4RETURN   BEGSR
     C     Ix            IFEQ      ArrayMax
     C                   RETURN
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
      * Hierarchy ID
      * Child currency
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_CCCY            3
      * Destination
      * Destination Type
      * Sender's Correspondent
     C                   PARM                    I_SDEST          18
     C                   PARM                    I_SDSTT           1
     C                   PARM                    I_SSNDC           2
 
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
     C                   PARM                    O_PACD                                       CGL029
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
     C                   PARM                    Ix                3 0
 
      * Key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     RECMBRK       KLIST
     C                   KFLD                    I_HIER
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
