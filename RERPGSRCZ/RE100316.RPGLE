     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Group A/c Hierarchy Member Field Conv')       *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100316 - Group A/c Hierarch Member Field Conversion        *
      *                                                               *
      *  Function:  This program converts certain fields in the       *
      *             'front end' group a/c hierarchy member record     *
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
 
     D I_TACCID        S             24                                                       CGL029
     D I_IACCID        S             24                                                       CGL029
     D I_EACCID        S             24                                                       CGL029
     D BlankAC         S             24                                                       CGL029
     D DDTACC          S             28                                                       CGL029
     D DDIACC          S             28                                                       CGL029
     D DDEACC          S             28                                                       CGL029
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
 
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
 
 
      /SPACE 5
 
      * Edit balance available for inter company overdraft
 
     C     I_BAIC        IFEQ      'Y'
     C                   EVAL      DDBAIC = 'YES'
     C                   ELSE
     C                   EVAL      DDBAIC = 'NO '
     C                   ENDIF
 
      * Access currency details
 
     C                   MOVEL     I_CCCY        CCY
     C                   EXSR      ACS_CURR
 
      * Edit inter company threshold balance
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      I_ICTB        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21Edit    DDICTB
 
      * Edit Transaction a/c
 
     C     I_TACCID      IFNE      BlankAC
     C                   MOVEL     I_TACCID      ACCID
     C                   MOVE      CUS           WrkCUS            6
     C**********         MOVE      ACD           WrkACD            4                          CGL029
     C                   MOVE      ACD           WrkACD                                       CGL029
     C                   MOVE      ASN           WrkASN            2
     C                   EVAL      DDTACC = BRC  +  '-'  +  WrkCUS   +  '-'
     C                                      +  CCY  +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
     C                   ELSE
     C                   EVAL      DDTACC = *BLANK
     C                   ENDIF
 
      * Edit (Interest) Income a/c
 
     C     I_IACCID      IFNE      BlankAC
     C                   MOVEL     I_IACCID      ACCID
     C                   MOVE      CUS           WrkCUS
     C                   MOVE      ACD           WrkACD
     C                   MOVE      ASN           WrkASN
     C                   EVAL      DDIACC = BRC  +  '-'  +  WrkCUS   +  '-'
     C                                      +  CCY  +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
     C                   ELSE
     C                   EVAL      DDIACC = *BLANK
     C                   ENDIF
 
      * Edit (Interest) Expense a/c
 
     C     I_EACCID      IFNE      BlankAC
     C                   MOVEL     I_EACCID      ACCID
     C                   MOVE      CUS           WrkCUS
     C                   MOVE      ACD           WrkACD
     C                   MOVE      ASN           WrkASN
     C                   EVAL      DDEACC = BRC  +  '-'  +  WrkCUS   +  '-'
     C                                      +  CCY  +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
     C                   ELSE
     C                   EVAL      DDEACC = *BLANK
     C                   ENDIF
 
 
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
 
      * Balance Available for Inter Company Overdraft
      * Inter Company Threshold Balance
     C                   PARM                    I_BAIC            1
     C                   PARM                    I_ICTB           15 0
      * Transaction A/c
      * (Interest) Income A/c
      * (Interest) Expense A/c
     C**********         PARM                    I_TACCID         18                          CGL029
     C**********         PARM                    I_IACCID         18                          CGL029
     C**********         PARM                    I_EACCID         18                          CGL029
     C                   PARM                    I_TACCID                                     CGL029
     C                   PARM                    I_IACCID                                     CGL029
     C                   PARM                    I_EACCID                                     CGL029
 
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
