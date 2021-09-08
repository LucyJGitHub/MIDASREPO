     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validation of Type of Product')               *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange ILE Module                          *
      *                                                               *
      *  FXVTPPR - Validation of Type of Product                      *
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

     D IRFXTB        E DS                  EXTNAME(IRFXTBPD)
      ** Get the data structure passed from calling program

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for access programs

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for access programs

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRetCodeIn      S             10A
     D Idx             S              3P 0 INZ(0)
     D PTPPR           S              6A
     D P#TPPR          S              6S 0
      ** Entry Parameters

     D ZARetcode       S              1A
     D ZAField         S             16A
     D ZADec           S              1P 0
     D ZADig           S              2P 0
      ** Other variables

     D POS1            S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D FIELD           S              3A
     D PKEY            S             24A

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

     C                   Movel     PTPPR         POS1

     C                   If        POS1 = '?'
     C                   Eval      PKEY = *blank
     C                   Eval      PKEY = POS1

     C                   Call      'AOFXTBR0'
     C                   Parm      '*BLANKS'     PRTCD
     C                   Parm      '*KEY   '     POPTN
     C                   Parm      'BAL'         FIELD
     C                   Parm                    PKEY
     C     IRFXTB        Parm      IRFXTB        DSFDY

     C                   If        PRTCD <> *blank
     C                   Eval      PRetCodeIn = 'Error'
     C                   Eval      FldNamXAr(1) = 'DDTTPPR   '
     C                   Eval      MsgIdXAr(1) = 'ITF8202'
     C                   Else

     C                   Movel     PKEY          PTPPR
     C                   Movel     PKEY          P#TPPR

     C                   EndIf

     C                   Else

      ** Set default value if blank

     C                   If        PTPPR = *blank
     C                   Eval      PTPPR = '999999'
     C                   Eval      P#TPPR = 999999
     C                   Else

      ** Determine if the value of PTPPR is numeric

     C                   Eval      ZAField = *blank
     C                   Move      PTPPR         ZAField
     C                   Eval      ZADec = 0
     C                   Eval      ZADig = 6
     C                   Exsr      SrZALG

      ** If not valid, set the error message

     C                   If        ZARetcode <> 'Y'
     C                   Eval      PRetCodeIn = 'Error'
     C                   Eval      FldNamXAr(1) = 'DDTTPPR   '
     C                   Eval      MsgIdXAr(1) = 'ITF8209'
     C                   Else

     C                   Move      ZAField       PTPPR

     C                   Call      'AOFXTBR0'
     C                   Parm      '*BLANKS'     PRTCD
     C                   Parm      '*VERIFY'     POPTN
     C                   Parm      'BAL'         FIELD
     C                   Parm      PTPPR         PKEY
     C     IRFXTB        Parm      IRFXTB        DSFDY

     C                   If        PRTCD <> *blank
     C                   Eval      PRetCodeIn = 'Error'
     C                   Eval      FldNamXAr(1) = 'DDTTPPR   '
     C                   Eval      MsgIdXAr(1) = 'ITF8202'
     C                   Else

     C                   Movel     PKEY          PTPPR
     C                   Movel     PKEY          P#TPPR

     C                   EndIf

     C                   EndIf

     C                   EndIf

     C                   EndIf

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZALG - Call ZALIGN Program                                 *
      *                                                               *
      *****************************************************************
     C     SrZALG        Begsr

     C                   CallB     'ZALIGN'
     C                   Parm      *blank        ZARetcode
     C                   Parm                    ZAField
     C                   Parm                    ZADec
     C                   Parm                    ZADig

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
     C                   Parm                    PTPPR
     C                   Parm                    P#TPPR

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

      ** Initialise program name

     C                   Eval      DBPGM = 'FXVTPPR'

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
