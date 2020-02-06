     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate CRS Sub Type')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVSTYP - Validate CRS Customer Sub Type                     *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. CGL157   *CREATE   Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************


      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE

     D/COPY ZACPYSRC,PSDS

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

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initialization

     C                   MOVE      *BLANK        ReturnCode
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      'Y'           DDSTYPOK
     C                   EVAL      DDSTYD = *BLANKS

     C                   IF        DDTYPE = ' ' AND
     C                             DDSTYP <> ' '

     C                   MOVE      'N'           DDSTYPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSTY1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0613'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDSTYP <> *BLANKS
     C                             AND (DDTYPE = 'F'
     C                             OR DDTYPE = 'P'
     C                             OR DDTYPE = 'J'
     C                             OR DDTYPE = 'O')
     C                   MOVE      'N'           DDSTYPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSTY1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0613'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   IF        DDTYPE = 'N'
     C                   IF        DDSTYP <> 'AC'
     C                             AND DDSTYP <> 'PA'
     C                             AND DDSTYP <> 'UN'
     C                             AND DDSTYP <> *BLANKS
     C                   MOVE      'N'           DDSTYPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSTY1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0613'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDSTYPOK = 'Y'
     C                   IF        DDSTYP = 'AC'
     C                   EVAL      DDSTYD = 'Active'
     C                   ENDIF

     C                   IF        DDSTYP = 'PA'
     C                   EVAL      DDSTYD = 'Passive'
     C                   ENDIF

     C                   IF        DDSTYP = 'UN'
     C                   EVAL      DDSTYD = 'Unknown'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDSTYPOK = 'Y'
     C                   EVAL      DFCSST = DDSTYP
     C                   ENDIF

      ** RETURN

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Return Code
     C                   PARM                    ReturnCode

      ** FATCA Customer Sub Type
     C                   PARM                    DDSTYP            2

      ** FATCA Customer Type
     C                   PARM                    DDTYPE            1

      ** FATCA Customer Sub Type Description
     C                   PARM                    DDSTYD           29

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Customer Sub Type - OK
     C                   PARM                    DDSTYPOK          1
     C                   PARM                    DFCSST            2

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
