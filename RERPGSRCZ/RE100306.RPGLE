     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Group A/c Hierarchy Member Validation')       *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100306 - Group A/c Hierarch Member Validation              *
      *                                                               *
      *  Function:  This program validates the 'front end'            *
      *             group a/c hierarchy member.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD000091           Date 14May13               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 216482             Date 23Apr02               *
      *                 CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216482 - Allow inc/exp account to belong to a diff branch    *
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
 
     D I_TACCID        S             24                                                       CGL029
     D I_IACCID        S             24                                                       CGL029
     D I_EACCID        S             24                                                       CGL029
     D BlankAC         S             24                                                       CGL029
 
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
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
 
 
      /SPACE 5
 
      * Clear outputs
 
     C                   Z-ADD     *ZERO         O_ICTB
 
      * Access currency details
 
     C                   MOVEL     I_CCCY        CCY
     C                   EXSR      ACS_CURR
 
      * Validate Balance Available for Inter Company Overdraft
 
     C                   EXSR      VAL_BAIC
 
      * Validate Inter Company Threshold Balance
 
     C                   EXSR      VAL_ICTB
 
      * Validate Transaction A/c
 
     C                   EXSR      VAL_TACCID
 
      * Validate (Interest) Income A/c
 
     C                   EXSR      VAL_IACCID
 
      * Validate (Interest) Expense A/c
 
     C                   EXSR      VAL_EACCID
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Validate Balance Available for Inter Company Overdraft
      ********************************************************************
     C     VAL_BAIC      BEGSR
 
      * 'Balance Available for Inter Company Overdraft must be Y or N'
 
     C     I_SBAIC       IFNE      'Y'
     C     I_SBAIC       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'GMBAIC   '   FldNameArr(Ix)
     C                   MOVEL     'RE75320'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Inter Company Threshold Balance
      ********************************************************************
     C     VAL_ICTB      BEGSR
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      I_SICTB       ZFLD17
     C     15            SUB       A6NBDP        ZSDIG
     C                   Z-ADD     A6NBDP        ZSDEC
     C                   EXSR      ZASIGN
 
      * 'Invalid Inter Company Threshold Balance'
     C     ZAsignOK      IFEQ      'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'GMICTB   '   FldNameArr(Ix)
     C                   MOVEL     'RE75321'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   MOVE      ZOUT15        O_ICTB
     C     ZFSIGN        IFNE      '-'
     C                   Z-SUB     O_ICTB        O_ICTB
     C                   END
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Transaction A/c
      ********************************************************************
     C     VAL_TACCID    BEGSR
 
      * 'Invalid TRANSACTION Account.'
 
     C                   MOVEL     I_TACCID      ACCID
     C     ACCID         IFNE      BlankAC
     C                   EXSR      ACS_ACCNT
     C     *IN60         IFEQ      '1'
     C     RECI          ORNE      'D'
     C*****BRCA**********ORNE      I_CBRC                                       216482
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'TACCID   '   FldNameArr(Ix)
     C                   MOVEL     'RE75322'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate (Interest) Income A/c
      ********************************************************************
     C     VAL_IACCID    BEGSR
 
      * 'Invalid INCOME Account.'
 
     C                   MOVEL     I_IACCID      ACCID
     C     ACCID         IFNE      BlankAC
     C                   EXSR      ACS_ACCNT
     C     *IN60         IFEQ      '1'
     C     RECI          ORNE      'D'
     C*****BRCA**********ORNE      I_CBRC                                       216482
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'IACCID   '   FldNameArr(Ix)
     C                   MOVEL     'RE75323'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate (Interest) Expense A/c
      ********************************************************************
     C     VAL_EACCID    BEGSR
 
      * 'Invalid EXPENSE Account.'
 
     C                   MOVEL     I_EACCID      ACCID
     C     ACCID         IFNE      BlankAC
     C                   EXSR      ACS_ACCNT
     C     *IN60         IFEQ      '1'
     C     RECI          ORNE      'D'
     C*****BRCA**********ORNE      I_CBRC                                       216482
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'EACCID   '   FldNameArr(Ix)
     C                   MOVEL     'RE75324'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
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
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate & right align signed numeric field
      ********************************************************************
     C     ZASIGN        BEGSR
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASIGNok          1
     C                   PARM                    ZFLD17           17
     C                   PARM                    ZSDIG             2 0
     C                   PARM                    ZSDEC             1 0
     C                   PARM                    ZSDCSP            1            156689
     C                   PARM                    ZOUT15           15
     C                   PARM                    ZFSIGN            1
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
      * Link ID
      * Child Branch
      * Child Currency
     C                   PARM                    I_LINK            9 0
     C                   PARM                    I_CBRC            3
     C                   PARM                    I_CCCY            3
 
      * Balance Available for Inter Company Overdraft
      * Inter Company Threshold Balance
     C                   PARM                    I_SBAIC           1
     C                   PARM                    I_SICTB          22
 
      * Transaction A/c
      * (Interest) Income A/c
      * (Interest) Expense A/c
     C**********         PARM                    I_TACCID         18                          CGL029
     C**********         PARM                    I_IACCID         18                          CGL029
     C**********         PARM                    I_EACCID         18                          CGL029
     C                   PARM                    I_TACCID                                     CGL029
     C                   PARM                    I_IACCID                                     CGL029
     C                   PARM                    I_EACCID                                     CGL029
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Inter Company Threshold Balance
     C                   PARM                    O_ICTB           15 0
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
      * Blank A/c
     C**********         Z-ADD     *ZERO         CUS                                          CSD027
     C                   EVAL      CUS =         *BLANKS                                      CSD027
     C                   Z-ADD     *ZERO         ACD
     C                   Z-ADD     *ZERO         ASN
     C**********         MOVEL     ACCID         BlankAC          18                          CGL029
     C                   MOVEL     ACCID         BlankAC                                      CGL029
 
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
