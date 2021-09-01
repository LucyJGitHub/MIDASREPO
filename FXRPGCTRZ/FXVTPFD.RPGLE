     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validation of Opn w/ 3rd Party Funds')        *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange ILE Module                          *
      *                                                               *
      *  FXVTPFD - Validation of Operation with Third Party Funds     *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2020                 *
      *                                                               *
      *  Last Amend No. LUC139             Date 15Jan21               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

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

     D PRetCodeIn      S             10A
     D Idx             S              3P 0 INZ(0)
     D PTPFD           S              1A
     D P#TPFD          S              1S 0
      ** Entry Parameters

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Main Routine

     C                   Exsr      SrMain

      ** Return

     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMain - Main Routine                                        *
      *                                                               *
      *****************************************************************
     C     SrMain        Begsr

      ** Set default value if blank

     C                   If        PTPFD = *blank
     C                   Eval      PTPFD = '0'
     C                   Eval      P#TPFD = 0
     C                   Else

     C                   If        PTPFD <> '0'
     C                             And PTPFD <> '1'
     C                   Eval      PRetCodeIn = 'Error'
     C                   Eval      FldNamXAr(1) = 'DDTTPFD   '
     C                   Eval      MsgIdXAr(1) = 'ITF8205'
     C                   Else
     C                   Movel     PTPFD         P#TPFD
     C                   EndIf

     C                   EndIf

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *Inzsr - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *Inzsr        Begsr

      ** Get parameters from calling program

     C     *Entry        Plist
     C                   Parm                    PRetCodeIn
     C                   Parm                    PTPFD
     C                   Parm                    P#TPFD

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

      ** Initialise program name

     C                   Eval      DBPGM = 'FXVTPFD'

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using Exsr.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK                                           *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** CPY@
(c) Finastra International Systems Ltd. 2020
