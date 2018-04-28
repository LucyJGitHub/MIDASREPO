     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX CLS Pay-in Schedule Retrieve Header Rcd')
      *****************************************************************
      *                                                               *
      *  Midas - API Wrapper Project                                  *
      *                                                               *
      *  FXCLSPR - CLS Pay-in Schedules Retrieve Header Record        *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG8433            Date 20Jul05               *
      *  Prev Amend No. CAP086             Date 08Jun05               *
      *                 CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG8433- Not to validate sequence no. if second pass         *
      *           (confirm complete) in FXCLSPRTV.                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CAP084 - Synchronous calling of APIs                         *
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
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
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
 
      ** CLS Pay-in Schedule Header file in Screen Format
     D CurTrCLSP     E DS                  EXTNAME(FXCLSPHPD)
     D                                     PREFIX(@)
 
      ** CLS Pay-in Schedule Header file in File Format
     D CLSPFilFmt    E DS                  EXTNAME(FXCLSPSH)
 
      ** Error indicators for CLS Pay-in Schedule Header
     D OKTrCLSP      E DS                  EXTNAME(FXECLSPHPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameters
     D AuthComp        S              1A
     D PFwdBck         S              1A
     D PCcy_In         S              3A
     D PNost_In        S              2A
     D PVDate_In       S              6A
     D PSeq_In         S              2A
     D Buffer          S           6000A
     D APIRetc         S              1A
 
      ** Parameters for FXCLSPRED
     D WRdFwd          S              1A
     D WRdBck          S              1A
     D WErrMsg         S              7A
     D WCcyRed         S              3A
     D WNostRed        S              2A
     D WVDateRed       S              6A
     D WSeqRed         S              2A
 
      ** Parameters for FXCLSPRTV
     D ModeOfOp        S              6A
     D RespMode        S              1A
     D WProfCtr        S              4A
     D WTimeDiff       S              5A
     D A6NBDP          S              1S 0
     D A7MPGT          S              1A
     D UpdateYN        S              1A                                                     BUG8433
     D WAuth           S              1A                                                      CAP086
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp
     C                   PARM                    PFwdBck
     C                   PARM                    PCcy_In
     C                   PARM                    PNost_In
     C                   PARM                    PVDate_In
     C                   PARM                    PSeq_In
     C                   PARM                    Buffer
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,FXCLSPM01
 
      ** If the action code is blank, enquire unless authorising
 
     C                   CLEAR                   CLSPFilFmt
 
     C                   IF        ActionCode = *BLANKS
     C                   IF        AuthComp = 'X'
     C                   MOVEL     'X'           ActionCode
     C                   ELSE
     C                   MOVEL     'E'           ActionCode
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PFwdBck = 'F'
     C                   MOVEL     'Y'           WRdFwd
     C                   MOVEL     'N'           WRdBck
     C                   ELSE
     C                   IF        PFwdBck = 'B'
     C                   MOVEL     'N'           WRdFwd
     C                   MOVEL     'Y'           WRdBck
     C                   ELSE
     C                   MOVEL     'N'           WRdFwd
     C                   MOVEL     'N'           WRdBck
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WRdFwd = 'Y' OR
     C                             WRdBck = 'Y'
     C                   EXSR      SrRED
     C                   ELSE
     C                   EVAL      WCcyRed = PCcy_In
     C                   EVAL      WNostRed = PNost_In
     C                   EVAL      WVDateRed = PVDate_In
     C                   EVAL      WSeqRed = PSeq_In
     C                   EVAL      WErrMsg = *BLANKS
     C                   ENDIF
 
      ** If deal read and no error returned, retrieve deal details
 
     C                   IF        WErrMsg = *BLANKS AND
     C                             WCcyRed <> *BLANKS AND
     C                             WNostRed <> *BLANKS AND
     C                             WVDateRed <> *BLANKS AND
     C                             WSeqRed <> *BLANKS
     C                   EXSR      SrRTV
 
      ** Convert to screeen format, if there are no errors in FXCLSPRTV
 
     C                   IF        Idx = 0
     C                   EXSR      SrCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WErrMsg <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'PYCCY'
     C                   EVAL      MsgIDArr(Idx) = WErrMsg
     C                   ENDIF
 
      ** Build buffer with required output, if no errors occurred
 
     C                   IF        WErrMsg <> *BLANKS OR Idx > 0 OR
     C                             RetCodeOut <> *BLANKS
     C                   EVAL      APIRetc = '0'
     C                   ELSE
     C                   EVAL      Buffer = CurTrCLSP
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRED - Read Forwards or Backwards Through the File          *
      *****************************************************************
     C     SrRED         BEGSR
 
     C                   CALLB     'FXCLSPRED'
      ** Input parameters:
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    ActionCode
     C                   PARM                    PCcy_In
     C                   PARM                    PNost_In
     C                   PARM                    PVDate_In
     C                   PARM                    PSeq_In
     C                   PARM                    WRdFwd
     C                   PARM                    WRdBck
      ** Output Parameters:
     C                   PARM                    WErrMsg
     C                   PARM                    WCcyRed
     C                   PARM                    WNostRed
     C                   PARM                    WVDateRed
     C                   PARM                    WSeqRed
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRTV - Retrieve Deal Details                                *
      *****************************************************************
     C     SrRTV         BEGSR
 
     C                   CALLB     'FXCLSPRTV'
      ** Input parameters:
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      '      '      ModeOfOp
     C                   PARM      'S'           RespMode
     C                   PARM                    ActionCode
     C                   PARM                    WCcyRed
     C                   PARM                    WNostRed
     C                   PARM                    WVDateRed
     C                   PARM                    WSeqRed
     C                   PARM      *BLANKS       WProfCtr
     C                   PARM      *BLANKS       WTimeDiff
     C                   PARM                    WAuth                                        CAP086
     C                   PARM                    UpdateYN                                    BUG8433
      ** Output parameters:
     C                   PARM                    OKTrCLSP
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      *ZERO         WIdx
     C                   PARM                    CLSPFilFmt
     C                   PARM                    A6NBDP
     C                   PARM                    A7MPGT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCVT - Convert File Format to Screen Format                 *
      *****************************************************************
     C     SrCVT         BEGSR
 
     C                   CALLB     'FXCLSPCVT'
      ** Input parameters:
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    CLSPFilFmt
      ** Output parameter:
     C                   PARM                    CurTrCLSP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
