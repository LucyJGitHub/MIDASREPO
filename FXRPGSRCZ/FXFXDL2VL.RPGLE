     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deals Transaction Extension - Validation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange ILE Module                          *
      *                                                               *
      *  FXFXDL2VL - FX Deals Transaction Extension - Validation      *
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
      *  CER009 - Puma II Upgrade to FM2.1                            *
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
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
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

     D RegData       E DS                  EXTNAME(FXFXRXPD)
      ** Regional Data in File Format

     D OKExtFlg      E DS                  EXTNAME(FXEFXIT1PD)
      ** FX Deals Transaction Extension File Error Definition

     D ValidFXDLEx   E DS                  EXTNAME(FXVFXIT1PD)
      ** FX Deals Transaction Valid Extension File

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PIdx            S              3P 0
      ** Index for arrays of of error message ids etc

     D PWIdx           S              3P 0
      ** Index for arrays of of warning message ids etc

     D PAction         S              1A
      ** Entry Parameters

     D I               S              3S 0
      ** Other variables

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

     C                   Exsr      SrInit

      ** Validate Motivation of Operation

     C                   Exsr      SrValdMOOP

      ** Validate Type of Product

     C                   Exsr      SrValdTPPR

      ** Validate Personalisation of Operation

     C                   Exsr      SrValdPEPR

      ** Validate Partial Operation

     C                   Exsr      SrValdGLPA

      ** Validate Operation with Third Party Funds

     C                   Exsr      SrValdTPFD

     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValdMOOP - Validate Motivation of Operation                *
      *                                                               *
      *****************************************************************
     C     SrValdMOOP    Begsr

     C                   Exsr      SrResetErrs

     C                   CallB     'FXVMOOP'
     C                   Parm                    RetCodeOut
     C                   Parm                    DDTMOOP
     C                   Parm                    PVMOOP

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C                   Exsr      SrUpdatErrs

      ** Use the return code's value to set the field's OK flag

     C                   CallB     'ZASETOKFLG'
     C                   Parm                    PMOOPOK
     C                   Parm                    RetCodeOut
     C                   Parm                    WarnGlobal

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValdTPPR - Validate Type of Product                        *
      *                                                               *
      *****************************************************************
     C     SrValdTPPR    Begsr

     C                   Exsr      SrResetErrs

     C                   CallB     'FXVTPPR'
     C                   Parm                    RetCodeOut
     C                   Parm                    DDTTPPR
     C                   Parm                    PVTPPR

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C                   Exsr      SrUpdatErrs

      ** Use the return code's value to set the field's OK flag

     C                   CallB     'ZASETOKFLG'
     C                   Parm                    PTPPROK
     C                   Parm                    RetCodeOut
     C                   Parm                    WarnGlobal

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValdPEPR - Validate Personalisation of Operation           *
      *                                                               *
      *****************************************************************
     C     SrValdPEPR    Begsr

     C                   Exsr      SrResetErrs

     C                   CallB     'FXVPEPR'
     C                   Parm                    RetCodeOut
     C                   Parm                    DDTPEPR
     C                   Parm                    PVPEPR

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C                   Exsr      SrUpdatErrs

      ** Use the return code's value to set the field's OK flag

     C                   CallB     'ZASETOKFLG'
     C                   Parm                    PPEPROK
     C                   Parm                    RetCodeOut
     C                   Parm                    WarnGlobal

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValdGLPA - Validate Partial Operation                      *
      *                                                               *
      *****************************************************************
     C     SrValdGLPA    Begsr

     C                   Exsr      SrResetErrs

     C                   CallB     'FXVGLPA'
     C                   Parm                    RetCodeOut
     C                   Parm                    DDTGLPA
     C                   Parm                    PVGLPA

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C                   Exsr      SrUpdatErrs

      ** Use the return code's value to set the field's OK flag

     C                   CallB     'ZASETOKFLG'
     C                   Parm                    PGLPAOK
     C                   Parm                    RetCodeOut
     C                   Parm                    WarnGlobal

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValdTPFD - Validate Operation with Third Party Funds       *
      *                                                               *
      *****************************************************************
     C     SrValdTPFD    Begsr

     C                   Exsr      SrResetErrs

     C                   CallB     'FXVTPFD'
     C                   Parm                    RetCodeOut
     C                   Parm                    DDTTPFD
     C                   Parm                    PVTPFD

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C                   Exsr      SrUpdatErrs

      ** Use the return code's value to set the field's OK flag

     C                   CallB     'ZASETOKFLG'
     C                   Parm                    PTPFDOK
     C                   Parm                    RetCodeOut
     C                   Parm                    WarnGlobal

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrResetErrs - Reset error information that is received back  *
      *                from each validation module                    *
      *                                                               *
      *****************************************************************
     C     SrResetErrs   Begsr

     C                   Eval      RetCodeOut = *blank

      ** Reset error & warning fields/message IDs/message data (arrays)

     C                   Eval      FldNamXAr = *blank
     C                   Eval      MsgIDXAr  = *blank
     C                   Eval      MsgDtaXAr = *blank
     C                   Eval      WFldNmXAr = *blank
     C                   Eval      WMsgIDXAr = *blank
     C                   Eval      WMsgDtXAr = *blank

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdatErrs - Update error information with that received    *
      *                back from each validation module               *
      *                                                               *
      *****************************************************************
     C     SrUpdatErrs   Begsr

      ** Update error fields/message IDs/message data (arrays)

     C                   Z-Add     1             I
     C     *blank        Lookup    FldNameArr(I)                          99
     C                   If        *IN99 = *ON
     C                   Movea     FldNamXAr     FlDNameArr(I)
     C                   Movea     MsgIDXAr      MsgIdArr(I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(I)
     C                   Endif

      ** Set Error Index

     C                   Z-Add     1             I
     C     *blank        Lookup    FldNameArr(I)                          99
     C     I             Sub       1             PIdx

      ** Update warning fields/message IDs/message data (arrays)

     C                   Z-Add     1             I
     C     *blank        Lookup    WFldNamArr(I)                          99
     C                   If        *IN99 = *ON
     C                   Movea     WFldNmXAr     WFldNamArr(I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(I)
     C                   Movea     WMsgDtXAr     WMsgDtaArr(I)
     C                   Endif

      ** Set Warning Index

     C                   Z-Add     1             I
     C     *blank        Lookup    WFldNamArr(I)                          99
     C     I             Sub       1             PWIdx

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     SrInit        Begsr

     C                   Clear                   ValidFXDLEx

     C                   Eval      PMOOPOK = 'Y'
     C                   Eval      PTPPROK = 'Y'
     C                   Eval      PPEPROK = 'Y'
     C                   Eval      PGLPAOK = 'Y'
     C                   Eval      PTPFDOK = 'Y'

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
     C                   Parm                    PAction
     C                   Parm                    RegData
     C                   Parm                    OKExtFlg

     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr

     C                   Parm                    PIdx

     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr

     C                   Parm                    PWIdx

     C                   Parm                    ValidFXDLEx

      ** Initialise program name

     C                   Eval      DBPGM = 'FXFXDL2VL'

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
** CPY@
(c) Finastra International Systems Ltd. 2020
