      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member FTOPAY1VL                               *
      *                                                               *
      *  FTOPA1VC12 - Midas FT CALL FTVDNDN1                          *
      *                                                               *
      *  Last Amend No. HUT106  *CREATE    Date 11Sep08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT106 - Upgrade HUT012 to FBM 2.1 SP22                      *
      *           Allow FISC Bank Reference to be entered in SWIFT    *
      *           ID Field.                                           *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT106
     C                   if        HUT106 = 'Y'                                               HUT106
      *                                                                                       HUT106
     C                   CALLB     'XXVDNDN'                                                  HUT106
      * INPUTS                                                                                HUT106
      *  Return Code                                                                          HUT106
     C                   Parm                    RetCodeOut                                   HUT106
      *  Screen fields                                                                        HUT106
     C                   Parm                    TranInPrim                                   HUT106
      * OUTPUTS                                                                               HUT106
      *  Error fields/message IDs/message data (arrays) from/to caller                        HUT106
     C                   Parm                    FldNamXAr                                    HUT106
     C                   Parm                    MsgIDXAr                                     HUT106
     C                   Parm                    MsgDtaXAr                                    HUT106
     C                   Parm                    WFldNmXAr                                    HUT106
     C                   Parm                    WMsgIDXAr                                    HUT106
     C                   Parm                    WMsgDtaXAr                                   HUT106
      *  OK Flags                                                                             HUT106
     C                   Parm                    OKFlagsDS                                    HUT106
      *  Validation Work Fields                                                               HUT106
     C                   Parm                    Val@Fields                                   HUT106
      *                                                                                       HUT106
     C                   else                                                                 HUT106
      *                                                                                       HUT106
      *****************************************************************
      * End of /COPY FTOPA1VC12                                       *
      *****************************************************************
