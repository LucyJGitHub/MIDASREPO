     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Default Portfolio')                                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Default Portfolio             *
      *                                                               *
      *  SDVDFPO -Validate Default Portfolio                          *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    /COPY, Customer Portfolio Management Details amendments    *
      *    must not be applied to this source.                        *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 15May13               *
      *                 AR1096288          Date 15Mar13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1096288 - Add Default Portfolio validation to avoid        *
      *              corrupted record in PMPORTPD file                *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      ** Midas SD Portfolio management ICD retrieval
     FSDPORTL1  IF   E           K DISK
 
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
      ** External DS for Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Define work field Return Code work field
     D WURTCD          S              7
      ** Define work field PM-action
     D WUPMAC          S              8
      ** Define work field Customer Number
     D WUCUST          S              6
      ** Define work field Book Code
     D WUBKCD          S              2
      ** Define work field Portfolio Reference
     D WUPTRF          S              4
      ** Define work field Screen Portfolio Ref
     D WUSCPF          S              4
      ** Define work field File Portfolio Ref
     D WUSCPT          S              4
      ** Define work field Program
     D WUPGMN          S             10
      ** Define work field Ref Attached to 9997
     D WUR997          S              4
      ** Define work field for private Banking indicator
     D WUN4ST          S              1
      ** External DS for Midas Module flag retrieval file,
     D SDMMOD        E DS                  EXTNAME (SDMMODPD)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Work Variables
     D W0RTN           S              7A
     D DDDFPO          S              4A
     D DDCUSN          S              6A
     D DDDFPOOK        S              1A
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
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
      ** VALIDATION
 
      ** Validate Default Portfolio,
     C                   MOVEL     *BLANK        WURTCD
     C                   MOVEL     '*PMCUSTV'    WUPMAC
      ** Customer number passed in SDCUSDIVL program,
     C                   MOVEL     DDCUSN        WUCUST
     C                   MOVEL     *BLANK        WUBKCD
     C                   MOVEL     DDDFPO        WUPTRF
     C                   MOVEL     *BLANK        WUSCPF
     C                   MOVEL     *BLANK        WUSCPT
     C                   MOVEL     PSProcName    WUPGMN
      ** Call PMZ0010 - Validate Portfolio Reference*
     C                   CALL      'PMZ0010'                            90
     C     WURTCD        PARM                    WURTCD
     C     WUPMAC        PARM                    WUPMAC
     C     WUCUST        PARM                    WUCUST
     C     WUBKCD        PARM                    WUBKCD
     C     WUPTRF        PARM                    WUPTRF
     C     WUSCPF        PARM                    WUSCPF
     C     WUSCPT        PARM                    WUSCPT
     C     WUPGMN        PARM                    WUPGMN
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occurred on CALL...'
     C                   EVAL      DDDFPOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDFPO    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx) = 'PMZ0010'                               MD000091
     C                   EVAL      MsgDtaTmp = 'PMZ0010'                                    MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
                                                                                           AR1096288
      ** Send message 'Portfolio not defined for customer'                                 AR1096288
     C                   IF        WURTCD = 'PMA0001'                                      AR1096288
     C                   EVAL      DDDFPOOK = 'N'                                          AR1096288
     C                   EVAL      Idx = Idx + 1                                           AR1096288
     C                   EVAL      FldNamXAr(Idx) = 'DDDFPO    '                           AR1096288
     C                   EVAL      MsgIdXAr(Idx)  = 'PMA0001'                              AR1096288
     C**********         EVAL      MsgDtaXAr(Idx) = DDDFPO                        AR1096288 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDDFPO))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDDFPO)                   MD000091
     C                   ENDIF                                                             AR1096288
                                                                                           AR1096288
      ** Get Portfolio Management ICD fields - Portfolio Management ICD
     C                   EXSR      SORVGN
 
      ** Return Code work field is NORMAL
     C                   IF        (WURTCD = *BLANK AND
     C                              WUN4ST  <> 'Y') OR
     C                             ((WURTCD = *BLANK) AND
     C                             (WUSCPF <>*BLANK) AND
     C                             (WUSCPF <> WUR997) AND
     C                             (WUN4ST  = 'Y'))
     C                   EVAL      DDDFPO = WUSCPF
 
     C                   ELSE
 
      ** Output error message if Private Banking is switched off, or if
      ** Private Banking is switched on, and either Default Portfolio Reference
      ** is blank, or Default Portfolio Reference is the same as the reference
      ** attached to 9997 on the ICD file
     C                   IF        ((WUN4ST = 'N') OR
     C                             (WUN4ST = 'Y') AND
     C                             (DDDFPO = *BLANKS) OR
     C                             (WUN4ST = 'Y') AND
     C                             (DDDFPO = WUR997))
      ** Send message 'Default Portfolio INVALID'
     C                   EVAL      DDDFPOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDFPO    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR2888'
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SORVGN - Get Port Man ICD fields - Portfolio Management ICD   *
      *****************************************************************
     C     SORVGN        BEGSR
     C                   MOVEL     *BLANK        W0RTN
      ** Define key list
     C     KRSSO         KLIST
     C                   KFLD                    FCPORT
      ** Move fields to key list
     C                   MOVE      *BLANK        FCPORT
     C                   MOVEL     'PORT'        FCPORT
     C     KRSSO         CHAIN     @PORTL1                            90
      ** Data record not found
     C   90              MOVEL     'USR2284'     W0RTN
     C                   IF        *IN90 = *OFF
      ** Process Data record
     C                   EVAL      WUR997 = FCR997
 
     C                   ENDIF
      ** Access object to retrieve Midas module flags retrieval file SDMMODPD.
      ** Access MIDAS modules Flag retreival file
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      ** Retrieve the value of Private Banking, Flag.
     C                   EVAL      WUN4ST = BGN4ST
 
     C     SOEXIT        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Field(s) requiring validation
      ** Default Portfolio
     C                   PARM                    DDDFPO
      ** Customer Number
     C                   PARM                    DDCUSN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Default Portfolio - OK
 
     C                   PARM                    DDDFPOOK
 
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
(c) Finastra International Limited 2006
