     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX CLS Pay-in Schedule Retrieve Detail Rcd')
      *****************************************************************
      *                                                               *
      *  Midas - API Wrapper Project                                  *
      *                                                               *
      *  FXCLSPR2 - CLS Pay-in Schedules Retrieve Detail Record       *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG5671            Date 31Jan05               *
      *                 BUG2952            Date 16Dec04               *
      *                 CAP084  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG5671- Add Sequence number to detail record                *
      *  BUG2952- Time can legitimately be blank                      *
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
 
      ** CLS Pay-in Schedule Detail file in Screen Format
     D CurTrCLSP     E DS                  EXTNAME(FXCLSPDPD)
     D                                     PREFIX(@)
 
      ** CLS Pay-in Schedule Detail file in File Format
     D CLSPFilFmt    E DS                  EXTNAME(FXCLSPSD)
 
      ** Error indicators for CLS Pay-in Schedule Detail
     D OKTrCLSP      E DS                  EXTNAME(FXECLSPDPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameters
     D AuthComp        S              1A
     D PFwdBck         S              1A
     D PCcy_In         S              3A
     D PNost_In        S              2A
     D PVDat_In        S              6A
     D PSeq_In         S              2A
     D PTime_In        S              4A
      *PAmt_In*********S             18A                                                     BUG5671
     D PDSeq_In        S              2A                                                     BUG5671
     D Buffer          S           6000A
     D APIRetc         S              1A
 
      ** Parameters for FXCLSPRE2
     D WRdFwd          S              1A
     D WRdBck          S              1A
     D WErrMsg         S              7A
     D WCcyRed         S              3A
     D WNostRed        S              2A
     D WVDatRed        S              6A
     D WSeqRed         S              2A
     D WTimeRed        S              4A
      *WAmtRed*********S             18A                                                    BUG5671
     D WDSeqRed        S              2A                                                    BUG5671
 
      ** Parameter for FXCLSPRT2
     D RespMode        S              1A
     D Idx             S              3P 0
 
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
     C                   PARM                    PVDat_In
     C                   PARM                    PSeq_In
     C                   PARM                    PTime_In
      *******************PARM                    PAmt_In                                     BUG5671
     C                   PARM                    PDSeq_In                                    BUG5671
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
     C                   EXSR      SrRE2
     C                   ELSE
     C                   EVAL      WCcyRed = PCcy_In
     C                   EVAL      WNostRed = PNost_In
     C                   EVAL      WVDatRed = PVDat_In
     C                   EVAL      WSeqRed = PSeq_In
     C                   EVAL      WTimeRed = PTime_In
      *******************EVAL      WAmtRed = PAmt_In                                         BUG5671
     C                   EVAL      WDSeqRed = PDSeq_In                                       BUG5671
     C                   EVAL      WErrMsg = *BLANKS
     C                   ENDIF
 
      ** If deal read and no error returned, retrieve deal details
 
     C                   IF        WErrMsg = *BLANKS AND
     C                             WCcyRed <> *BLANKS AND
     C                             WNostRed <> *BLANKS AND
     C                             WVDatRed <> *BLANKS AND
     C                             WSeqRed <> *BLANKS AND
     ******************************WTimeRed <> *BLANKS AND                                   BUG2952
     C                             WDSeqRed <> *BLANKS                                       BUG5671
      *****************************WAmtRed <> *BLANKS                                        BUG5671
 
     C                   EXSR      SrRT2
 
      ** Convert to screeen format, if there are no errors in FXCLSPRT2
 
     C                   IF        Idx = 0
     C                   EXSR      SrCV2
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WErrMsg <> *BLANKS
     C                   ADD       1             Idx
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
      *  SrRE2 - Read Forwards or Backwards Through the File          *
      *****************************************************************
     C     SrRE2         BEGSR
 
     C                   CALLB     'FXCLSPRE2'
      ** Input parameters:
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    ActionCode
     C                   PARM                    PCcy_In
     C                   PARM                    PNost_In
     C                   PARM                    PVDat_In
     C                   PARM                    PSeq_In
     C                   PARM                    PTime_In
      *******************PARM                    PAmt_In                                    BUG5671
     C                   PARM                    PDSeq_In                                   BUG5671
     C                   PARM                    WRdFwd
     C                   PARM                    WRdBck
      ** Output Parameters:
     C                   PARM      *BLANKS       WErrMsg
     C                   PARM                    WCcyRed
     C                   PARM                    WNostRed
     C                   PARM                    WVDatRed
     C                   PARM                    WSeqRed
     C                   PARM                    WTimeRed
      *******************PARM                    WAmtRed                                    BUG5671
     C                   PARM                    WDSeqRed                                   BUG5671
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRT2 - Retrieve Deal Details                                *
      *****************************************************************
     C     SrRT2         BEGSR
 
     C                   CALLB     'FXCLSPRT2'
      ** Input parameters:
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'S'           RespMode
     C                   PARM                    ActionCode
     C                   PARM                    WCcyRed
     C                   PARM                    WNostRed
     C                   PARM                    WVDatRed
     C                   PARM                    WSeqRed
     C                   PARM                    WTimeRed
      *******************PARM                    WAmtRed                                    BUG5671
     C                   PARM                    WDSeqRed                                   BUG5671
      ** Output parameters:
     C                   PARM                    CLSPFilFmt
     C                   PARM                    OKTrCLSP
     C                   PARM      *ZERO         Idx
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCV2 - Convert File Format to Screen Format                 *
      *****************************************************************
     C     SrCV2         BEGSR
 
     C                   CALLB     'FXCLSPCV2'
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
(c) Finastra International Limited 2003
