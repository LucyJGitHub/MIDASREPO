     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Zero Balancing/Sweeping Header Field Conv')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100312 - Zero Balancing/Sweeping Header Field Conversion   *
      *                                                               *
      *  Function:  This program converts certain fields in the       *
      *             'front end' zero balancing/sweeping header record *
      *             from file to screen format.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 216375             Date 10Apr03               *
      *                 214360             Date 03Feb03               *
      *                 CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216375 - Show charge accounts as retail numbers if possible  *
      *  214360 - Cash Management Deferred Posting                    *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
                                                                                216375
     FACCNT     IF   E           K DISK    INFSR(*PSSR)                         216375
     F                                     PREFIX(A_)                           216375
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D I_C1ACCID       S             24                                                       CGL029
     D I_C3ACCID       S             24                                                       CGL029
     D DDC1ACC         S             28                                                       CGL029
     D DDC3ACC         S             28                                                       CGL029
     D BlankAC         S             24                                                       CGL029
     D WrkACD          S             10                                                       CGL029
 
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
 
 
      * Input Cycle Sweeping Frequency
     D W_ICSF          DS            48
     D  W_ICSF1                1      4
     D  W_ICSF2                5      8
     D  W_ICSF3                9     12
     D  W_ICSF4               13     16
     D  W_ICSF5               17     20
     D  W_ICSF6               21     24
     D  W_ICSF7               25     28
     D  W_ICSF8               29     32
     D  W_ICSF9               33     36
     D  W_ICSF10              37     40
     D  W_ICSF11              41     44
     D  W_ICSF12              45     48
 
 
      * Input Cycle Sweeping Indicators
     D W_ICSI          DS            12
     D  W_ICSI1                1      1
     D  W_ICSI2                2      2
     D  W_ICSI3                3      3
     D  W_ICSI4                4      4
     D  W_ICSI5                5      5
     D  W_ICSI6                6      6
     D  W_ICSI7                7      7
     D  W_ICSI8                8      8
     D  W_ICSI9                9      9
     D  W_ICSI10              10     10
     D  W_ICSI11              11     11
     D  W_ICSI12              12     12
 
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
 
 
      /SPACE 5
 
 
      * Edit Input Cycle Sweeping Frequency
 
     C                   IF        I_ICSF = 'ALL' or I_ICSF = 'NEVER'
     C                   EVAL      DDICSF = I_ICSF
     C                   ELSE
     C                   EVAL      W_ICSF = I_ICSF
     C                   EVAL      DDICSF = *BLANKS
     C                   CAT       W_ICSF1:1     DDICSF
     C                   CAT       W_ICSF2:1     DDICSF
     C                   CAT       W_ICSF3:1     DDICSF
     C                   CAT       W_ICSF4:1     DDICSF
     C                   CAT       W_ICSF5:1     DDICSF
     C                   CAT       W_ICSF6:1     DDICSF
     C                   CAT       W_ICSF7:1     DDICSF
     C                   CAT       W_ICSF8:1     DDICSF
     C                   CAT       W_ICSF9:1     DDICSF
     C                   CAT       W_ICSF10:1    DDICSF
     C                   CAT       W_ICSF11:1    DDICSF
     C                   CAT       W_ICSF12:1    DDICSF
     C                   ENDIF
 
 
      * Edit Input Cycle Sweeping Indicators
 
     C                   IF        I_ICSF = 'ALL' or I_ICSF = 'NEVER'
     C                   EVAL      DDICSI = *BLANK
     C                   ELSE
     C                   EVAL      W_ICSI = I_ICSI
     C                   EVAL      DDICSI = *BLANKS
     C                   CAT       W_ICSI1:3     DDICSI
     C                   CAT       W_ICSI2:3     DDICSI
     C                   CAT       W_ICSI3:3     DDICSI
     C                   CAT       W_ICSI4:3     DDICSI
     C                   CAT       W_ICSI5:3     DDICSI
     C                   CAT       W_ICSI6:3     DDICSI
     C                   CAT       W_ICSI7:3     DDICSI
     C                   CAT       W_ICSI8:3     DDICSI
     C                   CAT       W_ICSI9:3     DDICSI
     C                   CAT       W_ICSI10:3    DDICSI
     C                   CAT       W_ICSI11:3    DDICSI
     C                   CAT       W_ICSI12:3    DDICSI
     C                   ENDIF
 
      * Edit sweeping holiday convention
 
     C     I_SHOC        IFEQ      'I'
     C                   EVAL      DDSHOC = 'INCLUDE'
     C                   ELSE
     C                   EVAL      DDSHOC = 'EXCLUDE'
     C                   ENDIF
 
      * Edit check for cover on top a/c
 
     C     I_CHKC        IFEQ      'Y'
     C                   EVAL      DDCHKC = 'YES'
     C                   ELSE
     C                   EVAL      DDCHKC = 'NO '
     C                   ENDIF
 
      * Edit external
 
     C     I_EXTL        IFEQ      'Y'
     C                   EVAL      DDEXTL = 'YES'
     C                   ELSE
     C                   EVAL      DDEXTL = 'NO '
     C                   ENDIF
 
      * Edit master account
 
     C     I_MAST        IFEQ      'Y'
     C                   EVAL      DDMAST = 'YES'
     C                   ELSE
     C                   EVAL      DDMAST = 'NO '
     C                   ENDIF
 
      * Edit external fwd value sweeping
 
     C     I_EFVS        IFEQ      'Y'
     C                   EVAL      DDEFVS = 'YES'
     C                   ELSE
     C                   EVAL      DDEFVS = 'NO '
     C                   ENDIF
                                                                                214360
      * External Account 1                                                      214360
                                                                                214360
     C                   MOVEL     I_EXA1        DDEXA11                        214360
     C                   MOVE      I_EXA1        DDEXA12                        214360
 
      * Edit MT202 cover message required
 
     C     I_MCMR        IFEQ      'Y'
     C                   EVAL      DDMCMR = 'YES'
     C                   ELSE
     C                   EVAL      DDMCMR = 'NO '
     C                   ENDIF
 
      * Access currency details
 
     C                   MOVEL     I_CCCY        CCY
     C                   EXSR      ACS_CURR
 
      * Edit MT101 Charges Account
 
     C     I_C1ACCID     IFNE      BlankAC
     C     I_C1ACCID     ANDNE     *BLANK                                       216375
     C                   MOVEL     I_C1ACCID     ACCID
     C                   EXSR      ACS_ACCNT                                    216375
     C                   IF        A_ACNO <> *ZERO                              216375
     C                   MOVEL     *BLANK        DDC1ACC                        216375
     C                   MOVEL     A_ACNO        DDC1ACC                        216375
     C                   ELSE                                                   216375
     C                   MOVE      CUS           WrkCUS            6
     C**********         MOVE      ACD           WrkACD            4                          CGL029
     C                   MOVE      ACD           WrkACD                                       CGL029
     C                   MOVE      ASN           WrkASN            2
     C                   EVAL      DDC1ACC = BRC  +  '-'  +  WrkCUS   +   '-'
     C                                      +  CCY  +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
     C                   ENDIF                                                  216375
     C                   ELSE
     C                   EVAL      DDC1ACC = *BLANK
     C                   ENDIF
 
      * Edit MT101 Charges Amount
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      I_CAM1        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDCAM1
 
      * Edit MT103 Charges Account
 
     C     I_C3ACCID     IFNE      BlankAC
     C     I_C3ACCID     ANDNE     *BLANK                                       216375
     C                   MOVEL     I_C3ACCID     ACCID
     C                   EXSR      ACS_ACCNT                                    216375
     C                   IF        A_ACNO <> *ZERO                              216375
     C                   MOVEL     *BLANK        DDC3ACC                        216375
     C                   MOVEL     A_ACNO        DDC3ACC                        216375
     C                   ELSE                                                   216375
     C                   MOVE      CUS           WrkCUS            6
     C**********         MOVE      ACD           WrkACD            4                          CGL029
     C                   MOVE      ACD           WrkACD                                       CGL029
     C                   MOVE      ASN           WrkASN            2
     C                   EVAL      DDC3ACC = BRC  +  '-'  +  WrkCUS   +   '-'
     C                                      +  CCY  +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
     C                   ENDIF                                                  216375
     C                   ELSE
     C                   EVAL      DDC3ACC = *BLANK
     C                   ENDIF
 
      * Edit MT103 Charges Amount
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      I_CAM3        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDCAM3
                                                                                214360
      * Edit deferred posting                                                   214360
                                                                                214360
     C     I_DEFP        IFEQ      'Y'                                          214360
     C                   EVAL      DDDEFP = 'YES'                               214360
     C                   ELSE                                                   214360
     C                   EVAL      DDDEFP = 'NO '                               214360
     C                   ENDIF                                                  214360
                                                                                214360
      * Edit deferred posting zero narrative                                    214360
                                                                                214360
     C     I_DEFZ        IFEQ      'Y'                                          214360
     C                   EVAL      DDDEFZ = 'YES'                               214360
     C                   ELSE                                                   214360
     C                   EVAL      DDDEFZ = 'NO '                               214360
     C                   ENDIF                                                  214360
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Access a currency
      ********************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'ZAACSCURR'
     C                   PARM                    CCY               3
     C                   PARM                    SDCURR
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5                                                                  216375
      ********************************************************************      216375
      * Access a/c details                                                      216375
      ********************************************************************      216375
     C     ACS_ACCNT     BEGSR                                                  216375
                                                                                216375
     C     ACCNTK        CHAIN     ACCNTABF                           60        216375
     C     *IN60         IFEQ      '1'                                          216375
     C                   EVAL      X_ERMS = 'BAD A/C:'                          216375
     C                                      + ACCID                             216375
     C                   EXSR      *PSSR                                        216375
     C                   ENDIF                                                  216375
                                                                                216375
     C                   ENDSR                                                  216375
      *******************************************************************       216375
      /SPACE 5
      *****************************************************************
      * Edit a signed field
      *****************************************************************
     C     ZSEDIT        BEGSR
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      I_ECODE       ZECODE            1
     C                   PARM                    ZOUT21           21
     C                   ENDSR
      *****************************************************************
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
      * Child Currency
     C                   PARM                    I_CCCY            3
      * Edit code
     C                   PARM                    I_ECODE           1
 
      * Input Cycle Sweeping Frequency
      * Input Cycle Sweeping Indicators
     C                   PARM                    I_ICSF           48
     C                   PARM                    I_ICSI           12
 
      * Sweeping Holiday Convention
     C                   PARM                    I_SHOC            1
 
      * Check For Cover on Top A/c
     C                   PARM                    I_CHKC            1
 
      * External
      * Master Account
      * External Fwd Value Sweeping
      * External Account 1                                                      214360
     C                   PARM                    I_EXTL            1
     C                   PARM                    I_MAST            1
     C                   PARM                    I_EFVS            1
     C                   PARM                    I_EXA1           35            214360
 
      * MT202 Cover Message Required
     C                   PARM                    I_MCMR            1
 
      * MT101 Charges Account
      * MT101 Charges Amount
     C**********         PARM                    I_C1ACCID        18                          CGL029
     C                   PARM                    I_C1ACCID                                    CGL029
     C                   PARM                    I_CAM1           15 0
 
      * MT103 Charges Account
      * MT103 Charges Amount
     C**********         PARM                    I_C3ACCID        18                          CGL029
     C                   PARM                    I_C3ACCID                                    CGL029
     C                   PARM                    I_CAM3           15 0
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM                    I_DEFP            1            214360
     C                   PARM                    I_DEFZ            1            214360
 
      * OUTPUTS
 
      * Input Cycle Sweeping Frequency
      * Input Cycle Sweeping Indicators
     C                   PARM                    DDICSF           59
     C                   PARM                    DDICSI           48
 
      * Sweeping Holiday Convention
     C                   PARM                    DDSHOC            7
 
      * Check For Cover on Top A/c
     C                   PARM                    DDCHKC            3
 
      * External
      * Master Account
      * External Fwd Value Sweeping
      * External Account 1                                                      214360
     C                   PARM                    DDEXTL            3
     C                   PARM                    DDMAST            3
     C                   PARM                    DDEFVS            3
     C                   PARM                    DDEXA11          25            214360
     C                   PARM                    DDEXA12          10            214360
 
      * MT202 Cover Message Required
     C                   PARM                    DDMCMR            3
 
      * MT101 Charges Account
      * MT101 Charges Amount
     C**********         PARM                    DDC1ACC          22                          CGL029
     C                   PARM                    DDC1ACC                                      CGL029
     C                   PARM                    DDCAM1           17
 
      * MT103 Charges Account
      * MT103 Charges Amount
     C**********         PARM                    DDC3ACC          22                          CGL029
     C                   PARM                    DDC3ACC                                      CGL029
     C                   PARM                    DDCAM3           17
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM                    DDDEFP            3            214360
     C                   PARM                    DDDEFZ            3            214360
 
      * Blank A/c
     C**********         Z-ADD     *ZERO         CUS                                          CSD027
     C                   EVAL      CUS =         *BLANKS                                      CSD027
     C                   Z-ADD     *ZERO         ACD
     C                   Z-ADD     *ZERO         ASN
     C**********         MOVEL     ACCID         BlankAC          18                          CGL029
     C                   MOVEL     ACCID         BlankAC                                      CGL029
                                                                                216375
      * Key lists                                                               216375
                                                                                216375
     C     ACCNTK        KLIST                                                  216375
     C                   KFLD                    CUS                            216375
     C                   KFLD                    CCY                            216375
     C                   KFLD                    ACD                            216375
     C                   KFLD                    ASN                            216375
     C                   KFLD                    BRC                            216375
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
