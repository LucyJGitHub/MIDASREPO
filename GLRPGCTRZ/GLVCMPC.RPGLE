     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL AMAD Validate Commission Rate Max U Bal')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCMPC - Validate Commission Rate Max U Bal                 *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2020                 *
      *                                                               *
      *  Last Amend No. LUC139  *Create    Date 22Dec20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UIC Italian returns upgrade to FM2.1                *
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
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and #MsgData, and so requires
      ** STD_D_SPEC.
      /COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------

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

     D DDTLNIT         S              7A
     D DDTCMPC         S              9A
      ** Screen input field

     D WWCMPC          S              8S 3

     D PzAlignOk       S              1A
     D PzADig          S              2P 0
     D PzADec          S              1P 0
     D PzField         S             16A
      ** Working Variables for ZALIGN

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialization

     C                   Exsr      SrInit

      ** Validate field

     C                   Exsr      SrMain

      ** Set return code and return to the calling program.

      **---------------------------------------------------------------
      ** The return code is set in the following /COPY:
      /COPY ZACPYSRC,SETRETCDE
      **---------------------------------------------------------------

     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit   - Initialisation                                    *
      *                                                               *
      *****************************************************************

     C     SrInit        Begsr

     C                   Z-Add     0             WWCMPC

      **---------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
      /COPY ZACPYSRC,FVAL_RESET
      **---------------------------------------------------------------

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMain - Validate Facility Exposure                          *
      *                                                               *
      *****************************************************************

     C     SrMain        Begsr

      **  If field is blank, initialise
      **  field with default value

     C                   If        DDTCMPC = *BLANKS
     C                   Z-Add     0             WWCMPC

     C                   Else

     C                   Move      *Blanks       PzField
     C                   Move      DDTCMPC       PzField
     C                   Z-Add     3             PzADec
     C     8             Sub       PZADec        PzADig

     C                   Callb     'ZALIGN'
     C                   Parm                    PzAlignOk
     C                   Parm                    PzField
     C                   Parm                    PzADec
     C                   Parm                    PzADig

     C                   If        PzAlignOk = 'N'
     C                   Eval      XIdx = XIdx + 1
     C                   Eval      FldNamXArr(XIdx) = 'DDTCMPC'
     C                   Eval      MsgIdXArr(XIdx)  = 'ITG7112'
     C                   Eval      ErrorFound = 'Y'
     C                   Else
     C                   Move      PzField       WWCMPC
     C                   Endif

     C                   Endif

     C                   If        DDTLNIT = *Blanks
     C                   If        WWCMPC <> 0
     C                   Eval      XIdx = XIdx + 1
     C                   Eval      FldNamXArr(XIdx) = 'DDTCMPC'
     C                   Eval      MsgIdXArr(XIdx)  = 'ITG7111'
     C                   Eval      ErrorFound = 'Y'
     C                   Endif
     C                   Endif

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *Inzsr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************

     C     *Inzsr        Begsr

     C     *Entry        Plist

      ** Return Code Error Indicator

     C                   Parm                    ReturnCode

      ** Received Parameters
      ** -------------------
      ** Screen field

     C                   Parm                    DDTLNIT
     C                   Parm                    DDTCMPC
     C                   Parm                    WWCMPC

      ** Returned parameters
      ** -------------------
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   Parm                    FldNamXArr
     C                   Parm                    MsgIDXArr
     C                   Parm                    MsgDtaXArr

     C                   Parm                    FldNamWArr
     C                   Parm                    MsgIDWArr
     C                   Parm                    MsgDtaWArr


      **---------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
**  CPY@
(c) Finastra International Systems Ltd. 2020
