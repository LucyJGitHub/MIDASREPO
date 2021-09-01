     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Percentage SACE')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEVSAPE - Validate Percentage SACE                           *
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
     D HH@             S             15  0 DIM(15) CTDATA PERRCD(1)

     D IRFXTB        E DS                  EXTNAME(IRFXTBPD)
      ** Midas Internal table

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D LITSAPE         S              7A
     D LITSACO         S              1A
      ** Screen input field

     D POkSAPE         S              1A
      ** Ok indicator

     D P_ALPH          S             16A
     D P_MTID          S              1A
     D P_AMT           S             15  0
     D P_ERCD          S              1  0
     D P_IDP           S              3  0
     D P_IINT          S              3  0
     D BNDCSP          S              1A
      ** Fields used in call to Module ZA0840

     D WWIDP           S              1  0
     D WWSAPE          S              6S 3

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

     C                   Eval      POkSAPE = 'Y'

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
      *  SrMain - Validate Cover SACE                                 *
      *                                                               *
      *****************************************************************

     C     SrMain        Begsr

     C                   If        LITSAPE <> *Blanks

     C                   Z-Add     3             P_IDP
     C                   Z-Add     3             P_IINT
     C                   Move      'N'           P_MTID
     C                   Move      *BLANKS       P_ALPH
     C                   Move      LITSAPE       P_ALPH

     C                   Callb     'ZA0840'
     C                   PARM                    RetCodeIn
     C                   PARM                    P_ALPH
     C                   PARM                    P_IDP
     C                   PARM                    P_IINT
     C                   PARM                    P_MTID
     C                   PARM      *Zero         P_Ercd
     C                   PARM                    P_Amt
     C                   PARM                    BNDCSP

     C                   If        P_Ercd <> 0

     C                   Eval      XIdx = XIdx + 1
     C                   Eval      FldNamXArr(XIdx) = 'LITSAPE'
     C                   Eval      MsgIdXArr(XIdx)  = 'ITL2012'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      PokSAPE = 'N'

     C                   Else

     C                   Move      P_ALPH        LITSAPE

     C     P_IDP         Add       1             WWIDP
     C     P_AMT         Div       HH@(WWIDP)    WWSAPE

     C                   If        WWSAPE > 100

     C                   Eval      XIdx = XIdx + 1
     C                   Eval      FldNamXArr(XIdx) = 'LITSAPE'
     C                   Eval      MsgIdXArr(XIdx)  = 'ITL2013'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      PokSAPE = 'N'

     C                   Endif

     C                   If        WWSAPE = 0 And LITSACO <> '0'

     C                   Eval      XIdx = XIdx + 1
     C                   Eval      FldNamXArr(XIdx) = 'LITSAPE'
     C                   Eval      MsgIdXArr(XIdx)  = 'ITL2014'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      PokSAPE = 'N'

     C                   Endif

     C                   If        WWSAPE <> 0 And LITSACO = '0'

     C                   Eval      XIdx = XIdx + 1
     C                   Eval      FldNamXArr(XIdx) = 'LITSAPE'
     C                   Eval      MsgIdXArr(XIdx)  = 'ITL2015'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      PokSAPE = 'N'

     C                   Endif

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

     C                   Parm                    LITSAPE
     C                   Parm                    WWSAPE
     C                   Parm                    LITSACO
     C                   Parm                    BNDCSP

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

     C                   Parm                    POkSAPE

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
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
**  Array of powers of 10 from 0 to 8  HH@
000000000000001
000000000000010
000000000000100
000000000001000
000000000010000
000000000100000
000000001000000
000000010000000
000000100000000
000001000000000
000010000000000
000100000000000
001000000000000
010000000000000
100000000000000
