     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Zero Balancing/Sweeping Member Field Conv')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100315 - Zero Balancing/Sweeping Member Field Conversion   *
      *                                                               *
      *  Function:  This program converts certain fields in the       *
      *             'front end' zero balancing/sweeping member record *
      *             from file to screen format.                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D #_FREQ          S              1    DIM(13) CTDATA PERRCD(1)
     D #_FREQN         S             30    DIM(13) CTDATA PERRCD(1)
 
     D I_SACCID        S             24                                                       CGL029
     D I_IIACID        S             24                                                       CGL029
     D I_IEACID        S             24                                                       CGL029
     D DDSACC          S             28                                                       CGL029
     D DDINAC          S             28                                                       CGL029
     D DDEXAC          S             28                                                       CGL029
     D BlankAC         S             24                                                       CGL029
     D WrkACD          S             10                                                       CGL029
 
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
 
 
     D                 DS
     D ZOUT21                  1     21
     D ZOUT21Sign             21     21
     D ZOUT21Edit              1     22
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
 
 
      /SPACE 5
 
      * Edit sweep type
 
     C     I_STYP        IFEQ      'Z'
     C                   EVAL      DDSTYP = 'ZERO BALANCE'
     C                   ELSE
     C                   EVAL      DDSTYP = 'SWEEP'
     C                   ENDIF
 
      * Edit sweeping frequency
 
     C                   Z-ADD     1             X                 2 0
     C     I_SFRQ        LOOKUP    #_FREQ(X)                              99
     C                   MOVEL     #_FREQN(X)    DDSFRQ
 
      * Edit sweeping day
 
     C     I_SDAY        IFNE      *ZERO
     C                   MOVE      I_SDAY        DDSDAY
     C                   ELSE
     C                   MOVE      *BLANK        DDSDAY
     C                   ENDIF
 
      * Edit last sweep date
 
     C     I_LSDT        IFNE      *ZERO
     C                   Z-ADD     I_LSDT        ZDAYNO
     C                   EXSR      ZDATE2
     C     I_DATFMT      IFEQ      'N'
     C                   MOVEL     ZDATEN        DDLSDT
     C                   ELSE
     C                   MOVEL     ZADATE        DDLSDT
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANK        DDLSDT
     C                   ENDIF
 
      * Edit next sweep date
 
     C     I_NSDT        IFNE      *ZERO
     C                   Z-ADD     I_NSDT        ZDAYNO
     C                   EXSR      ZDATE2
     C     I_DATFMT      IFEQ      'N'
     C                   MOVEL     ZDATEN        DDNSDT
     C                   ELSE
     C                   MOVEL     ZADATE        DDNSDT
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANK        DDNSDT
     C                   ENDIF
 
      * Edit sweep capitalized interest
 
     C     I_SCPI        IFEQ      'Y'
     C                   EVAL      DDSCPI = 'YES'
     C                   ELSE
     C                   EVAL      DDSCPI = 'NO '
     C                   ENDIF
 
      * Edit sweep cleared balance on association date
 
     C     I_SCBD        IFEQ      'Y'
     C                   EVAL      DDSCBD = 'YES'
     C                   ELSE
     C                   EVAL      DDSCBD = 'NO '
     C                   ENDIF
 
      * Edit zero balance - net or gross
 
     C     I_ZBNG        IFEQ      'N'
     C                   EVAL      DDZBNG = 'NET  '
     C                   ELSE
     C                   EVAL      DDZBNG = 'GROSS'
     C                   ENDIF
 
      * Access currency details
 
     C                   MOVEL     I_CCCY        CCY
     C                   EXSR      ACS_CURR
 
      * Edit target balance
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      I_TGBL        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    DDTGBL
 
      * Edit reverse sweep
 
     C     I_RVSW        IFEQ      'Y'
     C                   EVAL      DDRVSW = 'YES'
     C                   ELSE
     C                   EVAL      DDRVSW = 'NO '
     C                   ENDIF
 
      * Edit Shadow account
 
     C     I_SACCID      IFNE      BlankAC
     C                   MOVEL     I_SACCID      ACCID
     C                   MOVE      CUS           WrkCUS            6
     C**********         MOVE      ACD           WrkACD            4                          CGL029
     C                   MOVE      ACD           WrkACD                                       CGL029
     C                   MOVE      ASN           WrkASN            2
     C                   EVAL      DDSACC = BRC  +  '-'  +  WrkCUS   +  '-'
     C                                      +  CCY  +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
     C                   ELSE
     C                   EVAL      DDSACC = *BLANK
     C                   ENDIF
 
      * Edit Interest Income Account
 
     C     I_IIACID      IFNE      BlankAC
     C                   MOVEL     I_IIACID      ACCID
     C                   MOVE      CUS           WrkCUS            6
     C**********         MOVE      ACD           WrkACD            4                          CGL029
     C                   MOVE      ACD           WrkACD                                       CGL029
     C                   MOVE      ASN           WrkASN            2
     C                   EVAL      DDINAC = BRC  +  '-'  +  WrkCUS   +  '-'
     C                                      +  CCY  +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
     C                   ELSE
     C                   EVAL      DDINAC = *BLANK
     C                   ENDIF
 
      * Edit Interest Expense Account
 
     C     I_IEACID      IFNE      BlankAC
     C                   MOVEL     I_IEACID      ACCID
     C                   MOVE      CUS           WrkCUS            6
     C**********         MOVE      ACD           WrkACD            4                          CGL029
     C                   MOVE      ACD           WrkACD                                       CGL029
     C                   MOVE      ASN           WrkASN            2
     C                   EVAL      DDEXAC = BRC  +  '-'  +  WrkCUS   +  '-'
     C                                      +  CCY  +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
     C                   ELSE
     C                   EVAL      DDEXAC = *BLANK
     C                   ENDIF
 
      * Edit minimum balance
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      I_MINB        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    DDMINB
 
      * Edit minimum level
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      I_MINL        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    DDMINL
 
      * Edit maximum balance
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      I_MAXB        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    DDMAXB
 
      * Edit maximum level
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      I_MAXL        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    DDMAXL
 
      * Edit maximum debit value in a day
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      I_MDVD        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDMDVD
 
      * Edit maximum debit count in a day
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      I_MDCD        ZFLD15
     C                   Z-ADD     0             ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDMDCD
 
      * Edit floor limit for top
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      I_FLFT        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDFLFT
 
      * Edit floor limit for sweep
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      I_FLFS        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        DDFLFS
 
 
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
      /SPACE 5
      ********************************************************************
      * Convert a day number into a date
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *********************************************************************
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
     C     I_ECODE       IFEQ      'J'
     C     ZOUT21Sign    IFEQ      '-'
     C                   MOVE      'CR'          ZOUT21Edit
     C                   ELSE
     C                   MOVE      '  '          ZOUT21Edit
     C                   ENDIF
     C                   ENDIF
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
      * Date format
     C                   PARM                    I_DATFMT          1
      * Sweep Type
     C                   PARM                    I_STYP            1
      * Sweeping Frequency
      * Sweeping Day
      * Last Sweep Date
      * Next Sweep Date
     C                   PARM                    I_SFRQ            1
     C                   PARM                    I_SDAY            2 0
     C                   PARM                    I_LSDT            5 0
     C                   PARM                    I_NSDT            5 0
      * Sweep Capitalized Interest
      * Sweep Cleared Balance on Association Date
      * Zero Balance - Net or Gross
     C                   PARM                    I_SCPI            1
     C                   PARM                    I_SCBD            1
     C                   PARM                    I_ZBNG            1
      * Target Balance
     C                   PARM                    I_TGBL           15 0
      * Reverse Sweep
     C                   PARM                    I_RVSW            1
      * Shadow a/c
     C**********         PARM                    I_SACCID         18                          CGL029
     C                   PARM                    I_SACCID                                     CGL029
      * Internal Interest Income Account
     C**********         PARM                    I_IIACID         18                          CGL029
     C                   PARM                    I_IIACID                                     CGL029
      * Internal Interest Expense Account
     C**********         PARM                    I_IEACID         18                          CGL029
     C                   PARM                    I_IEACID                                     CGL029
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM                    I_MINB           15 0
     C                   PARM                    I_MINL           15 0
     C                   PARM                    I_MAXB           15 0
     C                   PARM                    I_MAXL           15 0
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM                    I_MDVD           15 0
     C                   PARM                    I_MDCD            3 0
      * Floor Limit for Top
      * Floor Limit for Sweep
     C                   PARM                    I_FLFT           15 0
     C                   PARM                    I_FLFS           15 0
 
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
 
 
      * Blank A/c
     C**********         Z-ADD     *ZERO         CUS                                          CSD027
     C                   EVAL      CUS = *BLANKS                                              CSD027
     C                   Z-ADD     *ZERO         ACD
     C                   Z-ADD     *ZERO         ASN
     C**********         MOVEL     ACCID         BlankAC          18                          CGL029
     C                   MOVEL     ACCID         BlankAC                                      CGL029
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** FREQ
 
D
W
F
S
M
R
T
Q
X
Y
B
L
** FREQ NARRATIVE
 
DAILY
WEEKLY
FORTNIGHTLY
SEMI-MONTHLY
MONTHLY
SIX DAYS BEFORE END OF MONTH
BIMONTHLY
QUARTERLY
SIX MONTHLY
YEARLY
LAST WORKING DAY OF MONTH
LAST CALENDAR DAY OF MONTH
