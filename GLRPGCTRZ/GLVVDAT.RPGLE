     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Period Start Date')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVVDAT - Validate Period Start Date                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG27484 *CREATE   Date 21Apr10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27484 - Error validation for period and penalty details   *
      *             is not working when AMAD is entered via SOAP      *
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
 
      ** Entry Parameters
 
     D DDVDATOK        S              1
     D DDVDAT          S              6
     D MAINT           S              7
     D BJDFIN          S              1
     D BJRDNB          S              5  0
     D CURSET          S              2  0
 
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
     C                   EVAL      DDVDATOK = 'Y'
 
      ** Period start date must not be blank
 
     C                   IF        DDVDAT = *BLANKS
     C                   EVAL      DDVDATOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDVDAT' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0453'
     C                   ENDIF
 
      ** Period start date must be a valid date
 
     C                   IF        DDVDAT <> *BLANKS
     C                   MOVEL     DDVDAT        ZDATE
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR
     C                   PARM                    ZDATE
     C                   PARM      BJDFIN        ZDATFM
     C                   PARM      0             ZDAYNO
 
     C                   IF        ZERR <> *BLANKS
     C                   EVAL      DDVDATOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDVDAT' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0454'
     C                   ELSE
 
      ** Period start date must be equal to the run date
 
     C                   IF        ZDAYNO <> BJRDNB
     C                             AND MAINT = '*NEW'
     C                             AND CURSET = 1
     C                   EVAL      DDVDATOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDVDAT' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0455'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Return Error
 
     C                   IF        DDVDATOK = 'N'
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
 
     C                   PARM                    DDVDAT
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    MAINT
     C                   PARM                    CURSET
 
      ** Output
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
 
     C                   PARM                    DDVDATOK
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
