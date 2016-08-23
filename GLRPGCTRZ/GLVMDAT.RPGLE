     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Next Date')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVMDAT - Validate Next Date                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
 
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D FldNamXAr       S             10A   DIM(XArrayMax)
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
     D WFldNmXAr       S             10A   DIM(XArrayMax)
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D DDCEDN          S              5  0
 
      ** Entry Parameters
 
     D DDMDATOK        S              1A
     D DDMDAT          S              6A
     D SMDATN          S              5  0
     D TOTSET          S              2  0
     D MAINT           S              7A
     D BJDFIN          S              1
     D BJRDNB          S              5  0
     D DDTPRD          S              1A
 
      ** ZDATE1 Parameters
 
     D ZERR            S              7
     D ZDATE           S              6  0
     D ZDATFM          S              1
     D ZDAYNO          S              5  0
 
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
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   EVAL      DDMDATOK = 'Y'
 
      ** Next Date must be non-blank for an account (existing or new)
 
     C                   IF        DDMDAT = *BLANKS AND
     C                             MAINT <> '*DFT' AND
     C                             TOTSET > 1
 
     C                   EVAL      DDMDATOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMDAT    '
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0316'
     C                   ENDIF
 
      ** Next Date must be a valid date on or after run date, when non-blank
 
     C                   IF        DDMDAT <> *BlANKS
     C                   MOVEL     DDMDAT        ZDATE
 02  C                   CALL      'ZDATE1'
 02  C                   PARM                    ZERR
 02  C                   PARM                    ZDATE
 02  C                   PARM      BJDFIN        ZDATFM
 02  C                   PARM      0             ZDAYNO
 
     C                   IF        ZERR <> *BLANKS OR
     C                             ZDAYNO < BJRDNB
     C                   EVAL      DDMDATOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMDAT    '
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0317'
     C                   ENDIF
 
     C                   Z-ADD     ZDAYNO        SMDATN
     C                   ENDIF
 
      ** Next Date must be non-blank for a Term a/c
 
     C                   IF        MAINT = '*EXIST' OR
     C                             MAINT = '*NEW'
 
     C                   IF        DDMDAT = *BLANKS AND
     C                             DDTPRD = 'T'
 
     C                   EVAL      DDMDATOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMDAT    '
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0368'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Return Error
 
     C                   IF        DDMDATOK = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
 
     C                   PARM                    DDMDAT
     C                   PARM                    TOTSET
     C                   PARM                    MAINT
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    DDTPRD
 
      ** OUTPUTS
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
 
     C                   PARM                    DDMDATOK
     C                   PARM                    SMDATN
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
