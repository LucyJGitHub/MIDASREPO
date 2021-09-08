     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Code of Deliberating Entity')        *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEVDECD - Validate Code of Deliberating Entity               *
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
     D IRFXTB        E DS                  EXTNAME(IRFXTBPD)
      ** Midas Internal table

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D LITDECD         S              3A
      ** Screen input field

     D POkDECD         S              1A
      ** Ok indicator

     D Prtcd           S              7A
     D Poptn           S              7A
     D Pcod            S              3A
     D Pkey            S             24A

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

     C                   Eval      POkDECD = 'Y'

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
      *  SrMain - Validate Code of Deliberating Entity                *
      *                                                               *
      *****************************************************************

     C     SrMain        Begsr

      ** If field is blank, initialise
      ** field with default value

     C                   If        LITDECD = *BLANKS

     C                   Eval      XIdx = XIdx + 1
     C                   Eval      FldNamXArr(XIdx) = 'LITDECD'
     C                   Eval      MsgIdXArr(XIdx)  = 'ITL2004'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      PokDECD = 'N'

     C                   Else

     C                   Movel     LITDECD       Pkey

     C                   Call      'AOFXTBR0'
     C                   Parm      *BLANKS       Prtcd
     C                   Parm      '*KEY   '     Poptn
     C                   Parm      'CDE'         Pcod
     C                   Parm                    Pkey
     C     IRFXTB        Parm      IRFXTB        DSFDY

     C                   If        Prtcd <> *BLANKS

     C                   Eval      XIdx = XIdx + 1
     C                   Eval      FldNamXArr(XIdx) = 'LITDECD'
     C                   Eval      MsgIdXArr(XIdx)  = 'ITL2009'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      PokDECD = 'N'

     C                   Else

     C                   Movel     Pkey          LITDECD

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

     C                   Parm                    LITDECD

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

     C                   Parm                    POkDECD

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
