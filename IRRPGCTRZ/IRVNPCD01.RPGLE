     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate next principal change date')         *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing ILE Module                           *
      *                                                               *
      *  IRVNPCD01 - Validate Next Principal Change Date              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 264029             Date 22Feb10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240134             Date 09Sep06               *
      *                 233467 (REOPEN)    Date 25Jul05               *
      *                 233467             Date 06Jun05               *
      *                 222373             Date 31Oct03               *
      *                 CAP043             Date 02May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP041  *CREATE    Date 07Jan02               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  264029 - Reverse fix 233467 is transferred to IRSIRSVU and   *
      *           IRCIRSVU since this is blocking the user from       *
      *           removing the principal change schedules and xNPCD.  *
      *           File DLPCSCPD is not yet updated with the removal of*
      *           dates therefore causing the error message to appear.*
      *  240134 - Pass CAP041 to IRVNPCD01.                           *
      *  233467 - REOPEN : Only check Principal Change Schedules      *
      *           which have not yet been processed.                  *
      *  233467 - If Principal Change Schedule exists, don't allow    *
      *           blanking of 'Next Principal Change Date'            *
      *  222373 - CAP043 source missed from Midasplus1 collection     *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *                                                               *
      *****************************************************************
     FDLPCSCPD  IF   E           K DISK                                                       233467
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
      *
      ** Transaction Details OK indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D POTI            S              1A
      *                                                                                       233467
      * Additional Variables to Check if Deal has Principal Change Schedule                   233467
      *                                                                                       233467
     D vDLNO           S              6A                                                      233467
     D xDLNO           S              6P 0                                                    233467
     D xPOTI           S              1A                                                      233467
 
     D CIR006          S              1A
     D***CAP043*         S              1A                                             CAP043 240134
     D CAP041          S              1A                                                      240134
 
     D WUNPCD          S              5P 0
     D WTNPCD          S              5P 0
 
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D BJDFIN          S              1A
     D ErrorFlag       S              1A
 
     D/COPY QWINDSRC,IRCIRSGDTA
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
      *                                                                                       233467
     C     DLPCSCK       KLIST                                                                233467
     C                   KFLD                    xDLNO                                        233467
     C                   KFLD                    xPOTI                                        233467
      *                                                                                       233467
     C                   MOVE      vDLNO         xDLNO                                        233467
 
      *
      ** Validate Our Next Principal Change Date
      *
     C     POTI          IFEQ      'O'
 
     C                   EXSR      SRValONPCD
 
     C                   ENDIF
 
      *
      ** Validate Their Next Principal Change Date
      *
     C     POTI          IFEQ      'T'
 
     C                   EXSR      SRValTNPCD
 
     C                   ENDIF
 
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        Idx <> 0
 
     C                   EVAL      RetCodeIn = 'ERROR'
 
     C                   ELSE
 
     C                   IF        POTI = 'O'
     C                   Z-ADD     WUNPCD        #1UNPC
 
     C                   IF        #1DTYP <> 'RX'
     C                   Z-ADD     WUNPCD        #1TNPC
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        POTI = 'T'
     C                   Z-ADD     WTNPCD        #1TNPC
     C                   ENDIF
 
     C                   ENDIF
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRValONPCD - Validation for Our Next Principal Change Date   *
      *                                                               *
      *****************************************************************
     C     SRValONPCD    BEGSR
 
     C                   Z-ADD     0             WUNPCD
 
     C                   IF        SONPCD <> *BLANKS
      *****************************************************************                CAP043 240134
      ***Error*when*CAP043*(Principal*Change*API*processing)*is*not*installed          CAP043 240134
      *****************************************************************                CAP043 240134
     C**********         IF        CAP043 <> 'Y'                                       CAP043 240134
     C**********         EVAL      OKONPCD = 'N'                                       CAP043 240134
     C**********         EVAL      Idx = Idx + 1                                       CAP043 240134
     C**********         EVAL      FldNamXAr(Idx) = 'SONPCD    '                       CAP043 240134
     C**********         EVAL      MsgIdXAr(Idx) = 'RS00070'                           CAP043 240134
     C**********         GOTO      ESRValONPCD                                         CAP043 240134
     C**********         ENDIF                                                         CAP043 240134
      *                                                                                       240134
      ** Error when CAP041 is not installed                                                   240134
      *                                                                                       240134
     C                   IF        CAP041 <> 'Y'                                              240134
     C                   EVAL      OKONPCD = 'N'                                              240134
     C                   EVAL      Idx = Idx + 1                                              240134
     C                   EVAL      FldNamXAr(Idx) = 'SONPCD    '                              240134
     C                   EVAL      MsgIdXAr(Idx) = 'RS00070'                                  240134
     C                   GOTO      ESRValONPCD                                                240134
     C                   ENDIF                                                                240134
 
     C                   TESTN                   SONPCD               01
     C                   MOVE      SONPCD        DateIn
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANKS       ErrorFlag
      *
      ** Must be a valid date
      *
     C                   IF        ErrorFlag = 'Y' or *IN01 = '0'
 
     C                   EVAL      OKONPCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SONPCD    '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00039'
 
     C                   GOTO      ESRValONPCD
 
     C                   ELSE
 
     C                   Z-ADD     DaynoOut      WUNPCD
      *
      ** Must be greater than value date AND
      ** less than or equal to maturity date.
      *
     C                   IF        WUNPCD <= #1VDAT or WUNPCD > #1MDAT
 
     C                   EVAL      OKONPCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SONPCD    '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00040'
 
     C                   GOTO      ESRValONPCD
 
     C                   ENDIF
      *
      ** Must be greater than or equal to Our Interest Accrual
      ** Control Date.
      *
     C                   IF        WUNPCD <= #1UIAC
 
     C                   IF        #1DTYP = 'RS' or
     C                             (CIR006 = 'Y' and (#1DTYP = 'RP' or
     C                             #1DTYP = 'RR' or #1DTYP = 'RF'))
 
     C                   EVAL      MsgIdXAr(Idx) = 'RS00041'
 
     C                   ELSE
 
     C                   EVAL      MsgIdXAr(Idx) = 'RS00042'
 
     C                   ENDIF
 
     C                   EVAL      OKONPCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SONPCD    '
 
     C                   GOTO      ESRValONPCD
 
     C                   ENDIF
      *
      ** Must be greater than or equal to Their Interest Accrual
      ** Control Date.
      *
     C                   IF         #1DTYP = 'RS' and WUNPCD <= #1TIAC or
     C                             (CIR006 ='Y' and WUNPCD <= #1TIAC and
     C                             (#1DTYP = 'RP' or #1DTYP = 'RR' or
     C                              #1DTYP = 'RF'))
 
     C                   EVAL      OKONPCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SONPCD    '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00043'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE                                                                 233467
                                                                                              233467
      **Validate*for*RX*Deals******************************************                233467 264029
     C**********         IF        vDLNO <> *BLANKS                                    233467 264029
     C**********         EVAL      xPOTI = 'U'                                         233467 264029
     C*****DLPCSCK       SETLL     DLPCSCD0                                            233467 264029
     C*****DLPCSCK       READE     DLPCSCD0                               99           233467 264029
     C******IN99         DOWEQ     *Off                                                233467 264029
     C*****DTPR*         ANDEQ     'Y'                                                 233467 264029
     C*****DLPCSCK       READE     DLPCSCD0                               99           233467 264029
     C**********         ENDDO                                                         233467 264029
     C**********         IF        *IN99 = *Off                                        233467 264029
     C**********         EVAL      OKONPCD = 'N'                                       233467 264029
     C**********         EVAL      Idx = Idx + 1                                       233467 264029
     C**********         EVAL      FldNamXAr(Idx) = 'SONPCD    '                       233467 264029
     C**********         EVAL      MsgIdXAr(Idx) = 'RS00061'                           233467 264029
     C**********         ENDIF                                                         233467 264029
     C**********         ENDIF                                                                264029
      *****************************************************************                233467 264029
      **Validate*for*RS*deals******************************************                233467 264029
     C**********         IF        vDLNO <> *BLANKS                                    233467 264029
     C**********         EVAL      xPOTI = ' '                                         233467 264029
     C*****DLPCSCK       SETLL     DLPCSCD0                                            233467 264029
     C*****DLPCSCK       READE     DLPCSCD0                               99           233467 264029
     C******IN99         DOWEQ     *Off                                                233467 264029
     C*****DTPR*         ANDEQ     'Y'                                                 233467 264029
     C*****DLPCSCK       READE     DLPCSCD0                               99           233467 264029
     C**********         ENDDO                                                         233467 264029
     C**********         IF        *IN99 = *Off                                        233467 264029
     C**********         EVAL      OKONPCD = 'N'                                       233467 264029
     C**********         EVAL      Idx = Idx + 1                                       233467 264029
     C**********         EVAL      FldNamXAr(Idx) = 'SONPCD    '                       233467 264029
     C**********         EVAL      MsgIdXAr(Idx) = 'RS00061'                           233467 264029
     C**********         ENDIF                                                         233467 264029
     C**********         ENDIF                                                         233467 264029
      *                                                                                       233467
     C                   ENDIF                                                                233467
 
     C     ESRValONPCD   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRValTNPCD - Validation for Their Next Principal Change Date *
      *                                                               *
      *****************************************************************
     C     SRValTNPCD    BEGSR
 
     C                   Z-ADD     0             WTNPCD
 
     C                   IF        STNPCD <> *BLANKS
      *****************************************************************                CAP043 240134
      ***Error*when*CAP043*(Principal*Change*API*processing)*is*not*installed          CAP043 240134
      *****************************************************************                CAP043 240134
     C**********         IF        CAP043 <> 'Y'                                       CAP043 240134
     C**********         EVAL      OKTNPCD = 'N'                                       CAP043 240134
     C**********         EVAL      Idx = Idx + 1                                       CAP043 240134
     C**********         EVAL      FldNamXAr(Idx) = 'STNPCD    '                       CAP043 240134
     C**********         EVAL      MsgIdXAr(Idx) = 'RS00070'                           CAP043 240134
     C**********         GOTO      ESRValTNPCD                                         CAP043 240134
     C**********         ENDIF                                                         CAP043 240134
      *                                                                                       240134
      ** Error when CAP041 is not installed                                                   240134
      *                                                                                       240134
     C                   IF        CAP041 <> 'Y'                                              240134
     C                   EVAL      OKTNPCD = 'N'                                              240134
     C                   EVAL      Idx = Idx + 1                                              240134
     C                   EVAL      FldNamXAr(Idx) = 'STNPCD    '                              240134
     C                   EVAL      MsgIdXAr(Idx) = 'RS00070'                                  240134
     C                   GOTO      ESRValTNPCD                                                240134
     C                   ENDIF                                                                240134
 
     C                   TESTN                   STNPCD               01
     C                   MOVE      STNPCD        DateIn
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANKS       ErrorFlag
      *
      ** Must be a valid date
      *
     C                   IF        ErrorFlag = 'Y' or *IN01 = '0'
 
     C                   EVAL      OKTNPCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'STNPCD    '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00044'
 
     C                   GOTO      ESRValTNPCD
 
     C                   ELSE
 
     C                   Z-ADD     DaynoOut      WTNPCD
      *
      ** Must be greater than value date AND
      ** less than or equal to maturity date.
      *
     C                   IF        WTNPCD <= #1VDAT or WTNPCD > #1MDAT
 
     C                   EVAL      OKTNPCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'STNPCD    '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00045'
 
     C                   GOTO      ESRValTNPCD
 
     C                   ENDIF
      *
      ** Must be greater than or equal to Their Interest Accrual
      ** Control Date.
      *
     C                   IF        WTNPCD <= #1TIAC
 
     C                   EVAL      OKTNPCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'STNPCD    '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00046'
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ELSE                                                                 233467
                                                                                              233467
     C**********         IF        vDLNO <> *BLANKS                                    233467 264029
     C**********         EVAL      xPOTI = 'T'                                         233467 264029
     C*****DLPCSCK       SETLL     DLPCSCD0                                            233467 264029
     C*****DLPCSCK       READE     DLPCSCD0                               99           233467 264029
     C******IN99         DOWEQ     *Off                                                233467 264029
     C*****DTPR          ANDEQ     'Y'                                                 233467 264029
     C*****DLPCSCK       READE     DLPCSCD0                               99           233467 264029
     C**********         ENDDO                                                         233467 264029
     C**********         IF        *IN99 = *Off                                        233467 264029
     C**********         EVAL      OKTNPCD = 'N'                                       233467 264029
     C**********         EVAL      Idx = Idx + 1                                       233467 264029
     C**********         EVAL      FldNamXAr(Idx) = 'STNPCD    '                       233467 264029
     C**********         EVAL      MsgIdXAr(Idx) = 'RS00062'                           233467 264029
     C**********         ENDIF                                                         233467 264029
     C**********         ENDIF                                                         233467 264029
 
     C                   ENDIF
 
     C     ESRValTNPCD   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** OTHERS
      ** ======
      *
      ** Validate 'O'ur/'T'heir/'B'oth indicator
     C                   PARM                    POTI
      *
      ** Deal number                                                                          233467
     C                   PARM                    vDLNO                                        233467
      *                                                                                       233467
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** FRA/IRS Amortisation of Caps, Collars, Floors & Individual
      ** Compounding Swaps
     C                   PARM                    CIR006
     C**********         PARM                    CAP043                                CAP043 240134
     C                   PARM                    CAP041                                       240134
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from calling programs
     C                   PARM                    Data
 
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
