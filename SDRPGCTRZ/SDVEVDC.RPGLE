     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Evidence')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVEVDC - Validate Evidence                                  *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

      ** Document Management file
     FSDDCMTL1  IF   E           K DISK    INFSR(*PSSR)

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

     D DDEVD1          S              2A
     D DDEVD2          S              2A
     D DDEVD3          S              2A
     D DDEVD4          S              2A
     D DDEVD5          S              2A
     D DDEVS1          S              3S 0
     D DDEVS2          S              3S 0
     D DDEVS3          S              3S 0
     D DDEVS4          S              3S 0
     D DDEVS5          S              3S 0
     D DFEVD1          S              2A
     D DFEVD2          S              2A
     D DFEVD3          S              2A
     D DFEVD4          S              2A
     D DFEVD5          S              2A
     D DFEVS1          S              3S 0
     D DFEVS2          S              3S 0
     D DFEVS3          S              3S 0
     D DFEVS4          S              3S 0
     D DFEVS5          S              3S 0
     D DDEVD1OK        S              1A
     D DDEVD2OK        S              1A
     D DDEVD3OK        S              1A
     D DDEVD4OK        S              1A
     D DDEVD5OK        S              1A
     D WERR            S              1A
     D DDCUNA          S             10A
     D DDRTYP          S              1A
     D KDCUNA          S             10A
     D KDRTYP          S              1A
     D KDEVDD          S              2A
     D KDEVSS          S              3S 0

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
     C                   MOVE      'Y'           DDEVD1OK
     C                   MOVE      'Y'           DDEVD2OK
     C                   MOVE      'Y'           DDEVD3OK
     C                   MOVE      'Y'           DDEVD4OK
     C                   MOVE      'Y'           DDEVD5OK
     C                   MOVE      *BLANK        KDCUNA
     C                   MOVEL     DDCUNA        KDCUNA
     C                   MOVE      DDRTYP        KDRTYP

     C                   IF        DDEVD1 = *BLANKS
     C                   IF        DDEVD2 <> *BLANKS OR
     C                             DDEVD3 <> *BLANKS OR
     C                             DDEVD4 <> *BLANKS OR
     C                             DDEVD5 <> *BLANKS
     C                   MOVE      'N'           DDEVD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDEVD2 = *BLANKS
     C                   IF        DDEVD3 <> *BLANKS OR
     C                             DDEVD4 <> *BLANKS OR
     C                             DDEVD5 <> *BLANKS
     C                   MOVE      'N'           DDEVD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDEVD3 = *BLANKS
     C                   IF        DDEVD4 <> *BLANKS OR
     C                             DDEVD5 <> *BLANKS
     C                   MOVE      'N'           DDEVD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDEVD4 = *BLANKS
     C                   IF        DDEVD5 <> *BLANKS
     C                   MOVE      'N'           DDEVD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0211'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDEVD1 <> *BLANKS
     C                   MOVE      DDEVD1        KDEVDD
     C                   MOVE      DDEVS1        KDEVSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFEVD1 = DDEVD1
     C                   EVAL      DFEVS1 = DDEVS1
     C                   ELSE

     C                   MOVE      'N'           DDEVD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   ELSE

     C                   MOVE      'N'           DDEVD1OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD1'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDEVD2 <> *BLANKS
     C                   MOVE      DDEVD2        KDEVDD
     C                   MOVE      DDEVS2        KDEVSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFEVD2 = DDEVD2
     C                   EVAL      DFEVS2 = DDEVS2
     C                   ELSE

     C                   MOVE      'N'           DDEVD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   ELSE

     C                   MOVE      'N'           DDEVD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDEVD3 <> *BLANKS
     C                   MOVE      DDEVD3        KDEVDD
     C                   MOVE      DDEVS3        KDEVSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFEVD3 = DDEVD3
     C                   EVAL      DFEVS3 = DDEVS3
     C                   ELSE

     C                   MOVE      'N'           DDEVD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   ELSE

     C                   MOVE      'N'           DDEVD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDEVD4 <> *BLANKS
     C                   MOVE      DDEVD4        KDEVDD
     C                   MOVE      DDEVS4        KDEVSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFEVD4 = DDEVD4
     C                   EVAL      DFEVS4 = DDEVS4
     C                   ELSE

     C                   MOVE      'N'           DDEVD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   ELSE

     C                   MOVE      'N'           DDEVD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDEVD5 <> *BLANKS
     C                   MOVE      DDEVD5        KDEVDD
     C                   MOVE      DDEVS5        KDEVSS
     C     KDCMT         CHAIN     SDDCMTL1
     C                   IF        %FOUND(SDDCMTL1)
     C                   IF        DMSTCD = 'A'
     C                   EVAL      DFEVD5 = DDEVD5
     C                   EVAL      DFEVS5 = DDEVS5
     C                   ELSE

     C                   MOVE      'N'           DDEVD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0258'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   ELSE

     C                   MOVE      'N'           DDEVD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0257'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDEVD2 <> '  '
     C                   IF        DDEVD1 = DDEVD2 AND
     C                             DDEVS1 = DDEVS2
     C                   MOVE      'N'           DDEVD2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDEVD3 <> '  '
     C                   IF        DDEVD1 = DDEVD3 AND
     C                             DDEVS1 = DDEVS3 OR
     C                             DDEVD2 = DDEVD3 AND
     C                             DDEVS2 = DDEVS3
     C                   MOVE      'N'           DDEVD3OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDEVD4 <> '  '
     C                   IF        DDEVD1 = DDEVD4 AND
     C                             DDEVS1 = DDEVS4 OR
     C                             DDEVD2 = DDEVD4 AND
     C                             DDEVS2 = DDEVS4 OR
     C                             DDEVD3 = DDEVD4 AND
     C                             DDEVS3 = DDEVS4
     C                   MOVE      'N'           DDEVD4OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDEVD5 <> '  '
     C                   IF        DDEVD1 = DDEVD5 AND
     C                             DDEVS1 = DDEVS5 OR
     C                             DDEVD2 = DDEVD5 AND
     C                             DDEVS2 = DDEVS5 OR
     C                             DDEVD3 = DDEVD5 AND
     C                             DDEVS3 = DDEVS5 OR
     C                             DDEVD4 = DDEVD5 AND
     C                             DDEVS4 = DDEVS5
     C                   MOVE      'N'           DDEVD5OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDEVD5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0259'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   ELSE

     C                   EVAL      WERR = 'N'
     C                   IF        DDEVD1 <> *BLANKS
     C                   MOVE      'N'           DDEVD1OK
     C                   EVAL      WERR = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        Idx = 0
     C                   EVAL      DFEVD1 = DDEVD1
     C                   EVAL      DFEVD2 = DDEVD2
     C                   EVAL      DFEVD3 = DDEVD3
     C                   EVAL      DFEVD4 = DDEVD4
     C                   EVAL      DFEVD5 = DDEVD5
     C                   EVAL      DFEVS1 = DDEVS1
     C                   EVAL      DFEVS2 = DDEVS2
     C                   EVAL      DFEVS3 = DDEVS3
     C                   EVAL      DFEVS4 = DDEVS4
     C                   EVAL      DFEVS5 = DDEVS5
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

      ** Customer/Non account holder
     C                   PARM                    DDCUNA
     C                   PARM                    DDRTYP

      ** Evidence
     C                   PARM                    DDEVD1
     C                   PARM                    DDEVS1
     C                   PARM                    DDEVD2
     C                   PARM                    DDEVS2
     C                   PARM                    DDEVD3
     C                   PARM                    DDEVS3
     C                   PARM                    DDEVD4
     C                   PARM                    DDEVS4
     C                   PARM                    DDEVD5
     C                   PARM                    DDEVS5

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Evidence - OK
     C                   PARM                    DDEVD1OK
     C                   PARM                    DDEVD2OK
     C                   PARM                    DDEVD3OK
     C                   PARM                    DDEVD4OK
     C                   PARM                    DDEVD5OK

     C                   PARM                    DFEVD1
     C                   PARM                    DFEVS1
     C                   PARM                    DFEVD2
     C                   PARM                    DFEVS2
     C                   PARM                    DFEVD3
     C                   PARM                    DFEVS3
     C                   PARM                    DFEVD4
     C                   PARM                    DFEVS4
     C                   PARM                    DFEVD5
     C                   PARM                    DFEVS5

     C     KDCMT         KLIST
     C                   KFLD                    KDCUNA
     C                   KFLD                    KDRTYP
     C                   KFLD                    KDEVDD
     C                   KFLD                    KDEVSS

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2015
