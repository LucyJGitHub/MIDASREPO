     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Review Detail Validation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDACRV1VL - Account Review Details Validation                *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD092  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** Account Review Details in screen format
     D CrARScnFmt    E DS                  EXTNAME(SDACRFPD)
 
      ** Account Review OK indicators
     D OKACRVFlag    E DS                  EXTNAME(SDEACRVPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
     D ValidFATCA    E DS                  EXTNAME(SDVACRVPD)
      ** Valid Customer Details layout
 
      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     D I               S              3P 0
     D RespMode        S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D WRTCD           S              7A
     D WOPTN           S              7A
     D WRunDay         S                   LIKE(BJRDNB)
     D WDCOMP          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Validate Account Review Purpose
     C                   EXSR      SrVPURP
 
      ** Validate Account Review Scheduled Date
     C                   EXSR      SrVSCDT
 
      ** Validate Account Review Complete Flag
     C                   EXSR      SrVARCF
 
      ** Validate Account Review Frequency and
      ** Account Review Next Schedule Date
     C                   EXSR      SrVARFR
 
      ** Validate Account Review Actual Date
     C                   EXSR      SrVACDT
 
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrVPURP - Validate Account Review Purpose                     *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: RESETERRS, UPDATERRS                                   *
      *                                                               *
      *****************************************************************
 
     C     SrVPURP       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Account Review Purpose
 
     C                   CALLB     'SDVPURP'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Account Review Purpose
     C                   PARM                    DDPUR1
     C                   PARM                    DDPUR2
     C                   PARM                    DDPUR3
     C                   PARM                    DDPUR4
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Account Review Purpose - OK
     C                   PARM                    DDPURPOK
     C                   PARM                    AVPURP
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrVSCDT - Validate Account Review Scheduled Date              *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls:  RESETERRS, UPDATERRS                                  *
      *                                                               *
      *****************************************************************
 
     C     SrVSCDT       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Account Review Scheduled Date
 
     C                   CALLB     'SDVSCHDT'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Account Review Scheduled Date
     C                   PARM                    DDSCDF
     C                   PARM                    DDACTN
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** Account Review Scheduled Date - OK
     C                   PARM                    DDSCDTOK
     C                   PARM                    AVSCDT
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrVACDT - Validate Account Review Actual Date                 *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: RESETERRS, UPDATERRS                                   *
      *                                                               *
      *****************************************************************
 
     C     SrVACDT       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Account Review Actual Date
 
     C                   CALLB     'SDVACDT'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Account Review Actual Date
     C                   PARM                    DDACDF
     C                   PARM                    DDACTM
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    DDCOMP
     C                   PARM                    WDCOMP
     C                   PARM                    Idx
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Account Review Actual Date - OK
     C                   PARM                    DDACDTOK
 
      ** Account Review Actual Time - OK
     C                   PARM                    DDACTMOK
     C                   PARM                    AVACDT
     C                   PARM                    AVACTM
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrVARCF - Validate Account Review Complete Flag               *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: RESETERRS, UPDATERRS                                   *
      *                                                               *
      *****************************************************************
 
     C     SrVARCF       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Account Review Complete Flag
 
     C                   CALLB     'SDVARCF'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Account Review Complete Flag
     C                   PARM                    DDCOMP
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Account Review Complete Flag - OK
     C                   PARM                    DDCOMPOK
     C                   PARM                    AVCOMP
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrVARFR - Validate Account Review Frequency                   *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: RESETERRS, UPDATERRS                                   *
      *                                                               *
      *****************************************************************
 
     C     SrVARFR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Account Review Frequency and
      ** Account Review Next Schedule Date
 
     C                   CALLB     'SDVARFR'
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeOut
 
      ** Account Review Frequency
     C                   PARM                    DDACRF
 
      ** Account Review Next Schedule Date
     C                   PARM                    DDNSDF
 
      ** Account Review Complete
     C                   PARM                    DDCOMP
     C                   PARM                    WDCOMP
     C                   PARM                    BJDFIN
     C                   PARM                    BJCYCD
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    BJRDNB
 
     C                   PARM                    AVSCDT
     C                   PARM                    DDSCDTOK
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** Account Review Frequency - OK
     C                   PARM                    DDACRFOK
 
      ** Account Review Next Schedule Date - OK
     C                   PARM                    DDNSDTOK
 
     C                   PARM                    AVACRF
     C                   PARM                    AVNSDT
 
      ** Update error info with that returned from the validation mod
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      * Called By: SrVPURP, SrVSCDT, SrVACDT, SrVARCF, SrVARFR        *
      *            SrVACDT                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      WFldNmXAr = *BLANK
     C                   EVAL      WMsgIDXAr = *BLANK
     C                   EVAL      WMsgDtXAr = *BLANK
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *                                                               *
      * Called By: SrVPURP, SrVSCDT, SrVACDT, SrVARCF, SrVARFR        *
      *            SrVACDT                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
      ** Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: *PSSR, SRERR                                           *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
 
      ** Response mode
     C                   PARM                    RespMode
 
      ** Account Review Details
     C                   PARM                    CrARScnFmt
     C                   PARM                    WDCOMP
 
      ** OUTPUTS
     C                   PARM                    OKACRVFlag
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      ** Valid Account Review details layout (DS) from/to caller
     C                   PARM                    ValidFATCA
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        WRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   MOVE      '001'         DBASE
     C                   EVAL      DBKEY = WOPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WRunDay = BJRDNB
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRERR         BEGSR
 
     C                   EVAL      DBPGM = 'SDACRV1VL'
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   DUMP
 
      **  Terminate the program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
