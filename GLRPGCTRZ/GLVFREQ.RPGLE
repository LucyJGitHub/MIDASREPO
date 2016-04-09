     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Rollover Frequency Period')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVFREQ - Validate Rollover Frequency Period                 *
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
     D CURSET          S              2P 0
     D DDFREQOK        S              1A
     D DDFREQ          S              1A
     D DDEVNT          S              1A
     D DDTPRD          S              1A
 
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
     C                   EVAL      DDFREQOK = 'Y'
 
      ** Rollover Frequency must be M, Q, X or Y (when non-blank)
 
     C                   IF        DDFREQ <> *BlANKS AND
     C                             DDFREQ <> 'M' AND
     C                             DDFREQ <> 'Q' AND
     C                             DDFREQ <> 'X' AND
     C                             DDFREQ <> 'Y'
 
     C                   EVAL      DDFREQOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDFREQ' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0402'
     C                   ENDIF
 
      ** Rollover Frequency must be blank for the termination period
 
     C                   IF        DDFREQ <> *BlANKS AND
     C                             DDEVNT = 'Z'
 
     C                   EVAL      DDFREQOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDFREQ' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0322'
     C                   ENDIF
 
      ** Rollover Frequency must be blank for a Notice a/c
 
     C                   IF        DDFREQ <> *BlANKS AND
     C                             DDTPRD = 'N' AND
     C                             Idx = 0
 
     C                   EVAL      DDFREQOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDFREQ' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0364'
     C                   ENDIF
 
      ** Return Error
 
     C                   IF        DDFREQOK = 'N'
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
 
     C                   PARM                    DDFREQ
     C                   PARM                    DDEVNT
     C                   PARM                    CURSET
     C                   PARM                    DDTPRD
 
      ** OUTPUTS
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
     C                   PARM                    DDFREQOK
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
