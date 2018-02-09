     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Determine Sweeping Schedule')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  REZSWPSCH - Determine Sweeping Schedule                      *
      *                                                               *
      *  Function:  This program is given sweeping frequency details  *
      *             and a currency and determines the next sweep date.*
      *             It also validates the details as well.            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 14May13               *
      *                 CCB020             Date 06Aug12               *
      *                 AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 216106             Date 07Apr03               *
      *                 214552             Date 03Feb03               *
      *                 213196             Date 21Jan03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CCB020 - COB Restructure - Secondary COB Infrastracture      *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  216106 - Top a/c sweep freq must be 'D' for deferred posting *
      *  214552 - Input cycle sweeping frequency                      *
      *  213196 - Holidays are not checked for top/sweeps             *
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
 
     D ZSFRQ           S              1    DIM(12) CTDATA PERRCD(12)
 
 
      ***MPHAS*Data-Area                                                               213196 CCB020
     D*MPHAS****       DS             1                                                213196 CCB020
     D**PHASE***               1      1                                                213196 CCB020
      **********                                                                       213196 CCB020
      **********                                                                       213196 CCB020
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
 
 
      /SPACE 5
 
      * Clear outputs
 
     C                   Z-ADD     *ZERO         O_SDAY
     C                   Z-ADD     *ZERO         O_NSDT
     C                   Z-ADD     *ZERO         O_FSDT
 
      * Edit input next sweep date if passed in numeric form
 
     C     I_CCAT        IFNE      'T'
     C     I_SNSDT       ANDEQ     *BLANK
     C     I_SEXTL       OREQ      'Y'                                          214552
     C     I_SMAST       ANDNE     'Y'                                          214552
     C     I_SNSDT       ANDEQ     *BLANK                                       214552
     C                   Z-ADD     I_NSDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATEN        I_SNSDT
     C                   ENDIF
 
      * Edit input sweep day if passed in numeric form
 
     C     I_CCAT        IFNE      'T'
     C     I_SSDAY       ANDEQ     *BLANK
     C     I_SEXTL       OREQ      'Y'                                          214552
     C     I_SMAST       ANDNE     'Y'                                          214552
     C     I_SSDAY       ANDEQ     *BLANK                                       214552
     C                   MOVE      I_SDAY        I_SSDAY
     C                   ENDIF
 
      * Validate Sweeping Frequency
 
     C                   EXSR      VAL_SFRQ
 
      * Validate Sweeping Day
 
     C                   EXSR      VAL_SDAY
 
      * Validate Next Sweep Date
 
     C                   EXSR      VAL_NSDT
 
      * Calculate Following Sweep Date
 
     C     I_CCAT        IFNE      'T'
     C     Ix            ANDEQ     0
     C     I_SEXTL       OREQ      'Y'                                          214552
     C     I_SMAST       ANDNE     'Y'                                          214552
     C     Ix            ANDEQ     0                                            214552
     C                   EXSR      CAL_FSDT
     C                   ENDIF
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Validate Sweeping Frequency
      ********************************************************************
     C     VAL_SFRQ      BEGSR
 
      * 'Sweeping frequency must not be present for the top account'
      * ' of non-external or master account hierarchies'                    s'  214552
 
     C     I_CCAT        IFEQ      'T'
     C     I_SEXTL       ANDNE     'Y'                                          214552
     C     I_CCAT        OREQ      'T'                                          214552
     C     I_SMAST       ANDEQ     'Y'                                          214552
     C     I_SSFRQ       IFNE      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMSFRQ   '   FldNameArr(Ix)
     C                   MOVEL     'RE75130 '    MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ELSE
 
      * 'Sweeping frequency must be D, W, F, S, M, R, T, Q, X, Y, L, or B'
 
     C     I_SSFRQ       LOOKUP    ZSFRQ                                  99
     C     *IN99         IFEQ      '0'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMSFRQ   '   FldNameArr(Ix)
     C                   MOVEL     'RE75131 '    MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
                                                                                216106
      * Sweeping frequency must be daily on top a/c if deferred posting         216106
                                                                                216106
     C     I_DEFP        IFEQ      'Y'                                          216106
     C     I_CCAT        ANDEQ     'T'                                          216106
     C     I_SSFRQ       ANDNE     'D'                                          216106
     C                   EXSR      CHK_4RETURN                                  216106
     C                   ADD       1             Ix                             216106
     C                   MOVEL     'ZMSFRQ   '   FldNameArr(Ix)                 216106
     C                   MOVEL     'RE75139 '    MsgIDArr(Ix)                   216106
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                       216106 MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF                                                  216106
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate sweeping day
      ********************************************************************
     C     VAL_SDAY      BEGSR
 
      * 'Sweeping day must not be present for the top account'
      * ' of non-external or master account hierarchies'                    s'  214552
 
     C     I_CCAT        IFEQ      'T'
     C     I_SEXTL       ANDNE     'Y'                                          214552
     C     I_CCAT        OREQ      'T'                                          214552
     C     I_SMAST       ANDEQ     'Y'                                          214552
     C     I_SSDAY       IFNE      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMSDAY   '   FldNameArr(Ix)
     C                   MOVEL     'RE75132 '    MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ELSE
 
     C     I_SSFRQ       IFEQ      'M'
     C     I_SSFRQ       OREQ      'T'
     C     I_SSFRQ       OREQ      'Q'
     C     I_SSFRQ       OREQ      'X'
     C     I_SSFRQ       OREQ      'Y'
 
      *  Default to Sweep Day Number when blank and
      *  Frequency Code is 'M', 'T', 'Q', 'X' or 'Y'
 
     C     I_SSDAY       IFEQ      *BLANK
     C     I_SSDAY       OREQ      '00'
     C     BJDFIN        IFEQ      'D'
     C     2             SUBST     I_SNSDT:1     I_SSDAY
     C                   ELSE
     C     2             SUBST     I_SNSDT:3     I_SSDAY
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     I_SSDAY       ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      2             ZADIG             2 0
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        O_SDAY
     C                   ENDIF
 
      * 'Sweeping day must range from 01-31 when entered'
 
     C     O_SDAY        IFLT      1
     C     O_SDAY        ORGT      31
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMSDAY   '   FldNameArr(Ix)
     C                   MOVEL     'RE75133 '    MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      * 'Sweeping day must be blank if frequency is not M, T, Q, X or Y'
 
     C                   ELSE
     C     I_SSDAY       IFNE      *BLANK
     C     I_SSDAY       ANDNE     '00'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMSDAY   '   FldNameArr(Ix)
     C                   MOVEL     'RE75134 '    MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Next Sweep Date
      ********************************************************************
     C     VAL_NSDT      BEGSR
 
      * 'Next sweep date must not be present for the top account'
      * ' of non-external or master account hierarchies'                    s'  214552
 
     C     I_CCAT        IFEQ      'T'
     C     I_SEXTL       ANDNE     'Y'                                          214552
     C     I_CCAT        OREQ      'T'                                          214552
     C     I_SMAST       ANDEQ     'Y'                                          214552
     C     I_SNSDT       IFNE      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMNSDT   '   FldNameArr(Ix)
     C                   MOVEL     'RE75135 '    MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ELSE
 
      * It must be a valid date
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     I_SNSDT       ZFIELD
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
      * 'Invalid Next Sweep Date'
 
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMNSDT   '   FldNameArr(Ix)
     C                   MOVEL     'RE75136 '    MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   Z-ADD     ZDAYNO        O_NSDT
     C                   END
 
      * 'Sweep Date cant be before run date'
 
     C     O_NSDT        IFGT      *ZERO
     C     O_NSDT        ANDLT     BJRDNB
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMNSDT   '   FldNameArr(Ix)
     C                   MOVEL     'RE75137 '    MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE                                                   213196
                                                                                213196
      * 'Sweep Date cant be a holiday if holidays are excluded from sweeping    213196
                                                                                213196
     C     O_NSDT        IFGT      *ZERO                                        213196
     C     I_SSHOC       ANDEQ     'E'                                          213196
     C*****PHASE         ANDEQ     'A'                                                 213196 CCB020
     C     COBST         ANDEQ     '*NO'                                                      CCB020
     C                   CALLB     'ZCHKH'                                      213196
     C                   PARM      O_NSDT        ZDAYNO            5 0          213196
     C                   PARM      I_CCCY        ZCCY              3            213196
     C                   PARM      *BLANK        ZLOC              3            213196
     C                   PARM      *BLANK        ZHOLID            1            213196
     C     ZHOLID        IFEQ      'H'                                          213196
     C                   EXSR      CHK_4RETURN                                  213196
     C                   ADD       1             Ix                             213196
     C                   MOVEL     'ZMNSDT   '   FldNameArr(Ix)                 213196
     C                   MOVEL     'RE75138 '    MsgIDArr(Ix)                   213196
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                       213196 MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF                                                  213196
     C                   ENDIF                                                  213196
     C                   ENDIF
                                                                                213196
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Calculate Following Sweep Date
      ********************************************************************
     C     CAL_FSDT      BEGSR
 
     C                   MOVE      I_SSFRQ       ZFREQ
     C                   MOVE      I_CCCY        ZCCY                           213196
     C*******************MOVE      BJLCCY        ZCCY                           213196
     C                   Z-ADD     O_NSDT        ZDAYNO
     C                   Z-ADD     O_SDAY        ZMDAY
 
     C     I_SSFRQ       IFEQ      'D'
     C     I_SSHOC       ANDEQ     'I'                                          213196
     C                   Z-ADD     BJDNWD        O_FSDT
     C                   ELSE
                                                                                213196
      * Do until following sweep date is next working day or later              213196
                                                                                213196
     C     O_FSDT        DOUGE     BJDNWD                                       213196
 
      **EXCLUDE*holidays****************************************************    213196
     C*****I_SSHOC*******IFEQ******'E'**************************************    213196
      * INCLUDE holidays when sweeping (i.e. sweep on holidays)                 213196
      * (Ignore holidays when calculating next date)                            213196
     C     I_SSHOC       IFEQ      'I'                                          213196
     C                   CALLB     'ZFRQB2'
     C                   PARM                    RetCodeIn         7
     C                   PARM                    ZFREQ             1
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM                    ZMDAY             2 0
     C                   PARM                    BJDFIN
     C                   PARM                    SDGELR
     C                   ELSE
 
      **INCLUDE*holidays****************************************************    213196
      * EXCLUDE holidays when sweeping (i.e. don't sweep on holidays)           213196
      * (take account of holidays when calculating next date)                   213196
     C                   CALLB     'ZFREQB'
     C                   PARM                    RetCodeIn
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   PARM                    ZMDAY
     C                   PARM                    BJDFIN
     C                   PARM                    SDGELR
     C                   ENDIF
 
     C                   Z-ADD     ZDAYNO        O_FSDT
 
     C                   ENDDO                                                  213196
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
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
      * Link ID
      * Child Currency
      * Child A/c Category
      * Deferred Posting                                                        216106
     C                   PARM                    I_LINK            9 0
     C                   PARM                    I_CCCY            3
     C                   PARM                    I_CCAT            1
     C                   PARM                    I_DEFP            1            216106
      * Sweeping Frequency - COB
      * Sweeping Day - COB
      * Next Sweep Date - COB
     C                   PARM                    I_SSFRQ           1
     C                   PARM                    I_SSDAY           2
     C                   PARM                    I_SNSDT           6
 
      * External                                                                214552
      * Master Account                                                          214552
     C                   PARM                    I_SEXTL           1            214552
     C                   PARM                    I_SMAST           1            214552
      * Sweeping Holiday Convention - COB
     C                   PARM                    I_SSHOC           1
      * Sweeping Day - COB     (in numeric form)
      * Next Sweep Date - COB  (in numeric form)
     C                   PARM                    I_SDAY            2 0
     C                   PARM                    I_NSDT            5 0
 
      * SDBANKPD
      * SDGELRPD
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
 
      * OUTPUTS
      * Sweeping Day - COB
      * Next Sweep Date - COB
     C                   PARM                    O_SDAY            2 0
     C                   PARM                    O_NSDT            5 0
 
      * Following Sweep Date
     C                   PARM                    O_FSDT            5 0
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      **********                                                                       213196 CCB020
      ***Read*MPHAS data-area                                                          213196 CCB020
      **********                                                                       213196 CCB020
     C******DTAARA       DEFINE                  MPHAS                                 213196 CCB020
     C**********         IN        MPHAS                                               213196 CCB020
     C                   CALL      'CBC001001'                                                CCB020
     C                   PARM      *BLANKS       COBST             4                          CCB020
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
**  ZSFRQ
DWFSMRTQXYBL
