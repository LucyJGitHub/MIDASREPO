     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans BoE Validation')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LECLIPVAL1 - LE Customer Loans BOE Validations               *
      *                                                               *
      *  Function:  This will handle the validation of the loan       *
      *               type and final maturity date                    *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD044880           Date 15Jan18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD044880 - BOE Switched On Testing and Fixing                *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
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
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** Transaction Details in screen format
     D NwCLIPScnFmt  E DS                  EXTNAME(LECLEXPD)
 
      ** Transaction Details OK indicators
     D OKFlags       E DS                  EXTNAME(LEECLIPX0)
 
      **
     D NwCLIPFilFmt  E DS                  EXTNAME(LEVCLIPX0)
 
     D/COPY QWINDSRC,LECLIPDTA
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters
 
     D PActn           S              1
     D PZErr           S              7
     D PZDateA         S              6
     D PZDayNo         S              5  0
     D PRtCd           S              7
     D POptn           S              7
     D BJDFIN          S              1
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
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
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SRINIT
      *
      ** validate loan type if entered
      *
     C                   IF        LLNTPX <> *Blanks AND
     C                             LLNTPX <> '1'     AND
     C                             LLNTPX <> '2'     AND
     C                             LLNTPX <> '4'     AND
     C                             LLNTPX <> '6'     AND
     C                             LLNTPX <> '9'
     C
     C                   EVAL      Idx             = Idx + 1
     C**********         EVAL      MsgIdArr   (Idx) = 'BYM0043'                             MD044880
     C                   EVAL      MsgIdArr   (Idx) = '5049098'                             MD044880
     C                   EVAL      FldNameArr (Idx) = 'LLNTPX'
     C                   EVAL      ReturnCode      = 'Error'
     C
     C                   ENDIF
     C
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LLNTPOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *
      ** Validate final maturity date if entered
      *
     C                   IF        LFMATX <> *Blanks
      *
      ** convert final maturity date to Midas day number
      *
     C                   MOVEL     LFMATX        PZDateA
     C                   TESTN                   PZDateA              7778
     C
     C                   IF        *IN77 ='1' OR
     C                             *IN78 ='1'
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateA
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PZErr
     C
     C                   IF        PZErr = 'Y'
     C
     C                   EVAL      Idx             = Idx + 1
     C**********         EVAL      MsgIdArr   (Idx) = 'BYM0120'                             MD044880
     C                   EVAL      MsgIdArr   (Idx) = '5049099'                             MD044880
     C                   EVAL      FldNameArr (Idx) = 'LFMATX'
     C                   EVAL      ReturnCode      = 'Error'
     C
     C                   ELSE
     C
     C                   IF        PZDayNo < BYMDTE
     C
     C                   EVAL      Idx             = Idx + 1
     C**********         EVAL      MsgIdArr   (Idx) = 'BYM0121'                             MD044880
     C                   EVAL      MsgIdArr   (Idx) = '5049100'                             MD044880
     C                   EVAL      FldNameArr (Idx) = 'LFMATX'
     C                   EVAL      ReturnCode      = 'Error'
     C
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    LFMATOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C
     C                   IF        Idx = *Zeros
     C                   EVAL      LVLNTP = LLNTPX
     C                   EVAL      LVFMAT = LFMATX
     C                   ENDIF
     C
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
     C                   CLEAR                   Idx
     C                   CLEAR                   ReturnCode
      *
      ** Default loan type field to 9=Others if not entered
      *
     C                   IF        LLNTPX = *BLANK
     C                   EVAL      LLNTPX = '9'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
     C                   PARM                    PActn
     C                   PARM                    Data
     C                   PARM                    NwCLIPScnFmt
     C                   PARM                    BJDFIN
     C                   PARM                    OKFlags
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM                    WIdx
      *
      ** Valid Transaction details layout (DS) from/to caller
      *
     C                   PARM                    NwCLIPFilFmt
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
