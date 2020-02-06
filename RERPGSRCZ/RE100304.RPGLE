     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Member Validation')           *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100304 - Cash Management Member Validation                 *
      *                                                               *
      *  Function:  This program validates the 'front end' cash       *
      *             management member record.                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 14May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
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
 
     D I_CACCID        S             24                                                       CGL029
     D I_PACCID        S             24                                                       CGL029
     D BlankAC         S             24                                                       CGL029
 
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
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
 
 
      /SPACE 5
 
      * Validate Child A/c
 
     C                   EXSR      VAL_CACCID
 
      * Validate Parent A/c
 
     C                   EXSR      VAL_PACCID
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Validate Child A/c
      ********************************************************************
     C     VAL_CACCID    BEGSR
 
      * 'Invalid child account.'
 
     C                   MOVEL     I_CACCID      ACCID
     C                   EXSR      ACS_ACCNT
     C     *IN60         IFEQ      '1'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'CACCID   '   FldNameArr(Ix)
     C                   MOVEL     'RE75260'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
 
      * 'Account currency is not equal to the hierarchy currency.'
 
     C     CCY           IFNE      I_HCCY
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'CACCID   '   FldNameArr(Ix)
     C                   MOVEL     'RE75261'     MsgIDArr(Ix)
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
      * Validate Parent A/c
      ********************************************************************
     C     VAL_PACCID    BEGSR
 
      * 'Invalid parent account.'
 
     C                   MOVEL     I_PACCID      ACCID
     C     ACCID         IFNE      BlankAC
     C                   EXSR      ACS_ACCNT
     C     *IN60         IFEQ      '1'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'PACCID   '   FldNameArr(Ix)
     C                   MOVEL     'RE75262'     MsgIDArr(Ix)
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
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
 
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
      * Hierarchy Currency
     C                   PARM                    I_LINK            9 0
     C                   PARM                    I_HCCY            3
      * Child a/c
      * Parent a/c
     C**********         PARM                    I_CACCID         18                          CGL029
     C**********         PARM                    I_PACCID         18                          CGL029
     C                   PARM                    I_CACCID                                     CGL029
     C                   PARM                    I_PACCID                                     CGL029
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
      * Blank A/c
     C**********         Z-ADD     *ZERO         CUS                                          CSD027
     C                   EVAL      CUS=*BLANKS                                                CSD027
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
