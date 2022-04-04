     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas XX Validates Contractual Spread and Sign')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  XXVCSPSG - Midas XX Validate FCM101 Contractual Spread Rate  *
      *             and Sign                                          *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. FCM101  *CREATE    Date 21Jan19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FCM101 - Floor Rates in LE Module                            *
      *                                                               *
      *****************************************************************

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

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Work Variable
     D WRun            S              1A

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      **
     D BChar           DS
     D   BLen                  1      2B 0
     D   LenStr                1      2
     D   MsgDtaTmp                   99

      ** Parameter variables

     D PRTCD           S              7A

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

     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      DDCNSPOK = 'Y'
     C                   EVAL      DDCNSGOK = 'Y'

      ** Validate Contractual Spread and Sign

     C                   EXSR      SRSPSG

     C                   IF        DDCNSPOK = 'N' OR
     C                             DDCNSGOK = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSPSG - Validate Contractual Spread and Sign                *
      *****************************************************************
     C     SRSPSG        BEGSR

     C                   IF        PLoanType = '63' OR
     C                             PLoanType = '65' OR
     C                             PLoanType = '67' OR
     C                             PLoanType = '80'
      *
     C                   If        PConsprd <>  *Blanks
     C                             Or PConSign <> *Blanks

     C     PConSign      Ifne      *BLANKS
     C                   Eval      DDCNSGOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   If        PModule = 'LERI  '
     C                   EVAL      FldNamXAr(Idx) = 'DDCNG2'
     C                   Else
     C                   Eval      FldNamXAr(Idx) = 'DDCNSG'
     C                   Endif

     C                   Eval      MsgIdXAr(Idx) = 'XXX0040'
     C                   Endif

     C     PConSprd      Ifne      *BLANKS
     C                   Eval      DDCNSPOK = 'N'
     C                   Eval      Idx = Idx + 1

     C                   If        PModule = 'LERI  '
     C                   EVAL      FldNamXAr(Idx) = 'DDCNS2'
     C                   Else
     C                   Eval      FldNamXAr(Idx) = 'DDCNSP'
     C                   Endif

     C                   Eval      MsgIdXAr(Idx) = 'XXX0040'
     C                   Endif

     C                   Endif
      *
     C                   ELSE

      ** Contractual Spread Rate allowed for non discount loans

     C                   IF        PConSprd <> *BLANKS

     C                   MOVE      *BLANKS       PSCRF
     C                   MOVE      PConSprd      PSCRF
     C                   Z-ADD     4             PNDIG
     C                   Z-ADD     7             PNDEC

     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM                    PSCRF            16
     C                   PARM                    PNDEC             1 0
     C                   PARM                    PNDIG             2 0
     C                   PARM      *BLANKS       PRVAL            16

     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DDCNSPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C
     C                   IF        PModule = 'LERI  '
     C                   Eval      FldNamXAr(Idx) = 'DDCNS2'
     c                   Else
     C                   Eval      FldNamXAr(Idx) = 'DDCNSP'
     C                   Endif

     C                   EVAL      MsgIdXAr(Idx) = 'XXX0031'
     C                   ELSE
     C                   MOVE      PRVAL         TMCNSP
     C                   ENDIF

     C                   ENDIF

      ** Contractual Spread Sign
      ** Default to 'A'dd when left blank

     C                   IF        PConSign = *BLANKS
     C                             and PConSprd <> *Blanks
     C                   Eval      PConSign = 'A'

     C                   ELSE

      ** P or S allowed with Base Rate Code only
     C                   IF        (PConSign = 'P' OR
     C                             PConSign = 'S') and
     C                             PBaseCode = *blank
     C                   EVAL      DDCNSGOK = 'N'
     C                   EVAL      Idx = Idx + 1

     C                   IF        PModule = 'LERI  '
     C                   Eval      FldNamXAr(Idx) = 'DDCNG2'
     C                   else
     C                   Eval      FldNamXAr(Idx) = 'DDCNSG'
     C                   Endif
     C                   EVAL      MsgIdXAr(Idx) = 'XXX0039'
     C                   ENDIF

      ** Valid values are 'A', 'S' and 'P' only

     C                   IF        (PConSign <> 'A' AND
     C                              PConSign <> 'S' AND
     C                              PConSign <> 'P')
     C                   If        PConSprd <> *Blanks
     C                   EVAL      DDCNSGOK = 'N'
     C                   EVAL      Idx = Idx + 1

     C                   IF        Pmodule = 'LERI  '
     C                   EVAL      FldNamXAr(Idx) = 'DDCNG2'
     C                   Else
     C                   Eval      FldNamXAr(Idx) = 'DDCNSG'
     C                   ENDIF

     C                   EVAL      MsgDtaTmp = 'A, S or P'
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)
     C                   EVAL      MsgIdXAr(Idx) = 'XXX0037'
     C                   Endif
     C                   ENDIF

     C                   ENDIF


      ** Contractual Spread Sign
      ** Prohibited if Contractual spread is not entered

     C                   IF        PConSign <> *BLANKS
     C                             AND PConSprd = *Blanks
     C                   EVAL      DDCNSGOK = 'N'
     C                   EVAL      Idx = Idx + 1

     C                   IF        PModule = 'LERI  '
     C                   Eval      FldNamXAr(Idx) = 'DDCNG2'
     C                   else
     C                   Eval      FldNamXAr(Idx) = 'DDCNSG'
     C                   Endif

     C                   EVAL      MsgIdXAr(Idx) = 'XXX0038'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Inputs

     C                   PARM                    RetCodeIn
     C                   PARM                    PLoanType         2
     C                   PARM                    PBaseRate        12
     C                   PARM                    PBaseCode         2
     C                   PARM                    PConSprd         12
     C                   PARM                    PConSign          1

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    TMCNSP           11 7
     C                   PARM                    PModule           6
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    Idx
     C                   PARM                    DDCNSPOK          1
     C                   PARM                    DDCNSGOK          1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************