     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Days and Months in Period')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVNUMB - Validate Number of Days and Month in Period        *
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
     D DDNDPDOK        S              1A
     D DDNDPD          S              3A
     D DDNMPDOK        S              1A
     D DDNMPD          S              2A
     D DDEVNT          S              1A
     D DDFREQ          S              1A
 
      ** ZALIGN Parameters
 
     D ZRTN            S              7A
     D ZFIELD          S             16A
     D ZADEC           S              1  0
     D ZADIG           S              2  0
     D ZAFLD           S             16A
 
      ** ZSEDIT Parameters
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1A
     D ZOUT21          S             21A
     D ZAFLD1          S             16A
 
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
     C                   EVAL      DDNDPDOK ='Y'
     C                   EVAL      DDNMPDOK ='Y'
 
      ** Number of Days
      ** Period Days must be numeric, when non-blank
 
     C                   IF        DDEVNT = 'A' AND
     C                             DDEVNT < 'Z'
 
     C                   IF        DDNDPD <> *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDNDPD        ZFIELD
     C                   Z-ADD     3             ZADIG
     C                   Z-ADD     0             ZADEC
 
     C                   EXSR      SRNEDIT
 
     C                   IF        ZRTN <> *BLANKS
     C                   EVAL      DDNDPDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNDPD' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0318'
     C                   ELSE
     C                   MOVE      ZAFLD1        DDNDPD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Period Days must be blank for the termination period
 
     C                   IF        DDEVNT = 'Z' AND
     C                             DDNDPD <> *BLANKS
     C                   EVAL      DDNDPDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNDPD' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0319'
     C                   ENDIF
 
      ** Number of Months
      ** Period Months must be blank when Period Days or Frequency are
      ** non-blank
 
     C                   IF        DDEVNT = 'A' AND
     C                             DDEVNT < 'Z'
 
     C                   IF        DDNMPD <> *BLANKS
 
     C                   IF        DDNDPD <> *BLANKS OR
     C                             DDFREQ <> *BLANKS
     C                   EVAL      DDNMPDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNMPD' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0421'
     C                   ENDIF
 
      ** Period Months must be numeric, when non-blank
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDNMPD        ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
 
     C                   EXSR      SRNEDIT
 
     C                   IF        ZRTN <> *BLANKS
     C                   EVAL      DDNMPDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNMPD' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0422'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     ** Period Months must be blank for the termination period
 
     C                   IF        DDEVNT = 'Z' AND
     C                             DDNMPD <> *BLANKS
     C                   EVAL      DDNMPDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNMPD' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0423'
     C                   ENDIF
     C
 
     ** One of Period Days and Roll Frequency and Period months
     ** must be non-blank
 
     C                   IF        Idx = 0
     C                   IF        DDEVNT <> 'Z' AND
     C                             DDNMPD = *BLANKS AND
     C                             DDNDPD = *BLANKS AND
     C                             DDFREQ = *BLANKS
     C                   EVAL      DDNDPDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNDPD' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0424'
     C                   ENDIF
 
     ** One of Period Days and Roll Frequency must be blank
 
     C                   IF        DDFREQ <> *BLANKS AND
     C                             DDNDPD <> *BLANKS
     C                   EVAL      DDNDPDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNDPD' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0366'
     C                   ENDIF
     C                   ENDIF
 
      ** Return Error
 
     C                   IF        DDNDPDOK = 'N' OR
     C                             DDNMPDOK = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRNEDIT - Standard Routine to Check and Format                *
      *****************************************************************
     C     SRNEDIT       BEGSR
 
     C                   MOVE      ZFIELD        ZAFLD1
     C                   MOVE      *BLANKS       ZAFLD
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   PARM                    ZAFLD
 
     C                   IF        ZRTN = *BLANKS
     C                   MOVE      ZAFLD         ZFLD15
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM      ZADEC         ZDECS
     C                   PARM      '3'           ZECODE
     C                   PARM                    ZOUT21
     C     16            SUBST     ZOUT21:5      ZAFLD1
     C                   ENDIF
 
     C                   ENDSR
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
 
     C                   PARM                    DDNDPD
     C                   PARM                    DDNMPD
     C                   PARM                    DDEVNT
     C                   PARM                    DDFREQ
     C                   PARM                    CURSET
 
      ** OUTPUTS
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
     C                   PARM                    DDNDPDOK
     C                   PARM                    DDNMPDOK
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
