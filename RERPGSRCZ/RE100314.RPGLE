     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Member Field Conv')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100314 - Cash Management Member Validation                 *
      *                                                               *
      *  Function:  This program converts certain fields in the       *
      *             'front end' cash management member record         *
      *             from file to screen format.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
     D I_CACCID        S             24                                                       CGL029
     D I_PACCID        S             24                                                       CGL029
     D DDCACC          S             28                                                       CGL029
     D DDPACC          S             28                                                       CGL029
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
 
 
      /SPACE 5
 
      * Edit Child account
 
     C                   MOVEL     I_CACCID      ACCID
     C                   MOVE      CUS           WrkCUS            6
     C**********         MOVE      ACD           WrkACD            4                          CGL029
     C                   MOVE      ACD           WrkACD                                       CGL029
     C                   MOVE      ASN           WrkASN            2
     C                   EVAL      DDCACC = BRC  +  '-'  +  WrkCUS   +   '-'
     C                                      +  CCY  +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
 
      * Edit Parent account
 
     C     I_PACCID      IFNE      BlankAC
     C                   MOVEL     I_PACCID      ACCID
     C                   MOVE      CUS           WrkCUS
     C                   MOVE      ACD           WrkACD
     C                   MOVE      ASN           WrkASN
     C                   EVAL      DDPACC = BRC  +  '-'  +  WrkCUS   +  '-'
     C                                      +  CCY  +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
     C                   ELSE
     C                   EVAL      DDPACC = *BLANK
     C                   ENDIF
 
 
     C                   RETURN
 
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
      * Child a/c
      * Parent a/c
     C**********         PARM                    I_CACCID         18                          CGL029
     C**********         PARM                    I_PACCID         18                          CGL029
     C                   PARM                    I_CACCID                                     CGL029
     C                   PARM                    I_PACCID                                     CGL029
 
      * OUTPUTS
      * Child a/c
      * Parent a/c
     C**********         PARM                    DDCACC           22                          CGL029
     C**********         PARM                    DDPACC           22                          CGL029
     C                   PARM                    DDCACC                                       CGL029
     C                   PARM                    DDPACC                                       CGL029
 
 
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
