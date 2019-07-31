
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate CRS Type')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVTYPE - Validate CRS Customer Type                         *
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
     C                   MOVE      'Y'           DDTYPEOK
     C                   EVAL      DDTYPD = *BLANKS

     C                   IF        DDTYPE <> ' ' AND
     C                             DDTYPE <> 'F' AND
     C                             DDTYPE <> 'N' AND
     C                             DDTYPE <> 'P' AND
     C                             DDTYPE <> 'J' AND
     C                             DDTYPE <> 'O'

     C                   MOVE      'N'           DDTYPEOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTYPE'      FldNamXAr(Idx)
     C                   MOVEL     'USS0612'     MsgIdXAr(Idx)

     C                   ELSE

     C                   IF        DDTYPE = 'F'
     C                   EVAL      DDTYPD = 'Financial +
     C                                      Institution'
     C                   ENDIF

     C                   IF        DDTYPE = 'N'
     C                   EVAL      DDTYPD = 'Non-financial +
     C                                      Entity'
     C                   ENDIF

     C                   IF        DDTYPE = 'P'
     C                   EVAL      DDTYPD = 'Physical Person'
     C                   ENDIF

     C                   IF        DDTYPE = 'J'
     C                   EVAL      DDTYPD = 'Joint Account'
     C                   ENDIF

     C                   IF        DDTYPE = 'O'
     C                   EVAL      DDTYPD = 'Other'
     C                   ENDIF

     C                   EVAL      DFCSTY = DDTYPE
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

      ** CRS Customer Type
     C                   PARM                    DDTYPE            1
     C                   PARM                    DDTYPD           29

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** CRS Customer Type - OK
     C                   PARM                    DDTYPEOK          1
     C                   PARM                    DFCSTY            1

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
