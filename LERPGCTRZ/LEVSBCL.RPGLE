     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Stand-By Credit Line Credit Ind')    *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEVSBCL - Validate Stand-By Credit Line Indicator            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 08Jan21               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
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

     D LITSBCL         S              1A
      ** Screen input fields

     D POkSBCL         S              1A
      ** Ok indicators

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

      ** Set return code and return to the calling program
      **---------------------------------------------------------------
      ** The return code is set in the following /COPY:
      /COPY ZACPYSRC,SETRETCDE
      **---------------------------------------------------------------

     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation                                      *
      *                                                               *
      *****************************************************************

     C     SrInit        Begsr

     C                   Eval      POkSBCL = 'Y'

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
      *  SrMain - Validate Stand-By Credit Line Indicator             *
      *                                                               *
      *****************************************************************

     C     SrMain        Begsr

      ** If field is blank, initialise
      ** field with default value

     C                   If        LITSBCL = *BLANKS

     C                   Eval      LITSBCL = '1'

     C                   Else

     C                   If        LITSBCL <> '0' and LITSBCL <> '1'

     C                   Eval      XIdx = XIdx + 1
     C                   Eval      FldNamXArr(XIdx) = 'LITSBCL'
     C                   Eval      MsgIdXArr(XIdx)  = 'ITL2001'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      PokSBCL = 'N'

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

     C                   Parm                    LITSBCL

      ** Returned parameters
      ** -------------------
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   Parm                    FldNamXArr
     C                   Parm                    MsgIDXArr
     C                   Parm                    MsgDtaXArr

     C                   Parm                    FldNamWArr
     C                   Parm                    MsgIDWArr
     C                   Parm                    MsgDtaWArr

      ** Ok Indicator

     C                   Parm                    POkSBCL

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
(c) Misys International Banking Systems Ltd. 2006
