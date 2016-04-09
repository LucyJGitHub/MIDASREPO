     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Header Validation')           *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100301 - Cash Management Header Validation                 *
      *                                                               *
      *  Function:  This program validates the 'front end' cash       *
      *             management header record.                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD000091           Date 14May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CRE008   *CREATE   Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
 
 
      /SPACE 5
 
      * Clear outputs
 
     C                   Z-ADD     *ZERO         O_DEFR
     C                   Z-ADD     *ZERO         O_RVDT
     C                   Z-ADD     *ZERO         O_LCDT
 
      * Validate Hierarchy Type
 
     C                   EXSR      VAL_HTYP
 
      * Validate Main Branch
 
     C                   EXSR      VAL_BRCA
 
      * Validate Date Effective From
 
     C                   EXSR      VAL_DEFR
 
      * Validate Review Date
 
     C                   EXSR      VAL_RVDT
 
      * Validate Last Change Date
 
     C                   EXSR      VAL_LCDT
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Validate Hierarchy Type
      ********************************************************************
     C     VAL_HTYP      BEGSR
 
      * 'Hierarchy Type must be ZS or GA'
 
     C     I_SHTYP       IFNE      'ZS'
     C     I_SHTYP       ANDNE     'GA'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'HIHTYP   '   FldNameArr(Ix)
     C                   MOVEL     'RE75200'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Main Branch
      ********************************************************************
     C     VAL_BRCA      BEGSR
 
      * 'Invalid Main Branch.'
 
     C                   MOVEL     I_SBRCA       BRCH
     C                   EXSR      ACS_BRCH
     C     A8BRCD        IFEQ      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'HIBRCA   '   FldNameArr(Ix)
     C                   MOVEL     'RE75201'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Date Effective From
      ********************************************************************
     C     VAL_DEFR      BEGSR
 
      * It must be a valid date
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     I_SDEFR       ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END
 
      * If either ZALIGN and ZDATE1 errors
      * 'Invalid Date Effective From'
 
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'HIDEFR   '   FldNameArr(Ix)
     C                   MOVEL     'RE75202 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   Z-ADD     ZDAYNO        O_DEFR
     C                   END
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Review Date
      ********************************************************************
     C     VAL_RVDT      BEGSR
 
      * It must be a valid date
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     I_SRVDT       ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END
 
      * If either ZALIGN and ZDATE1 errors
      * 'Invalid Review Date'
 
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'HIRVDT   '   FldNameArr(Ix)
     C                   MOVEL     'RE75203 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   Z-ADD     ZDAYNO        O_RVDT
     C                   END
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Last Change Date
      ********************************************************************
     C     VAL_LCDT      BEGSR
 
      * It must be a valid date
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     I_SLCDT       ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   EXSR      ZDATE1
     C                   END
 
      * If either ZALIGN and ZDATE1 errors
      * 'Invalid Last Change Date'
 
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'HILCDT   '   FldNameArr(Ix)
     C                   MOVEL     'RE75204 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   Z-ADD     ZDAYNO        O_LCDT
     C                   END
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access a branch
      ********************************************************************
     C     ACS_BRCH      BEGSR
 
     C                   CALLB     'ZAACSBRCH'
     C                   PARM                    BRCH              3
     C                   PARM                    SDBRCH
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a date into a day number
      ********************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      'N'           ErrorFlag         1
     C                   ENDSR
      *********************************************************************
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
      * Hierarchy
     C                   PARM                    I_HIER            9 0
      * Hierarchy Type
      * Main Branch
     C                   PARM                    I_SHTYP           2
     C                   PARM                    I_SBRCA           3
 
      * Date Effective From
      * Review Date
      * Last Change Date
     C                   PARM                    I_SDEFR           7
     C                   PARM                    I_SRVDT           7
     C                   PARM                    I_SLCDT           7
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * Date Effective From
      * Review Date
      * Last Change Date
     C                   PARM                    O_DEFR            5 0
     C                   PARM                    O_RVDT            5 0
     C                   PARM                    O_LCDT            5 0
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
