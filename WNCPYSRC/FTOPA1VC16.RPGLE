      *****************************************************************
      *                                                               *
      *  Midas - FT Module                                            *
      *                                                               *
      *  FTOPAY1VC16 -                                                *
      *                                                               *
      *  (C) Copyright Midas-Kapiti International Ltd. 2018           *
      *                                                               *
      *  Last Amend No. JMI107 *CREATE     Date 14May18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI107 - JMI025 upgrade. RTS Bank Code Enhancement           *
      *                                                               *
      *****************************************************************

     C                   Else                                                                 JMI107
                                                                                              JMI107
      ** Validate                                                                             JMI107
     C                   CALLB     'XXVDNDN'                                                  JMI107
      * INPUTS                                                                                JMI107
      *  Return Code                                                                          JMI107
     C                   Parm                    RetCodeOut                                   JMI107
                                                                                              JMI107
      *  Screen fields                                                                        JMI107
     C                   Parm                    TranInPrim                                   JMI107
                                                                                              JMI107
     C                   Parm                    JMI107            1                          JMI107
                                                                                              JMI107
      * OUTPUTS                                                                               JMI107
      *  Error fields/message IDs/message data (arrays) from/to caller                        JMI107
     C                   Parm                    FldNamXAr                                    JMI107
     C                   Parm                    MsgIDXAr                                     JMI107
     C                   Parm                    MsgDtaXAr                                    JMI107
                                                                                              JMI107
     C                   Parm                    WFldNmXAr                                    JMI107
     C                   Parm                    WMsgIDXAr                                    JMI107
     C                   Parm                    WMsgDtaXAr                                   JMI107
                                                                                              JMI107
      *  OK Flags                                                                             JMI107
     C                   Parm                    OKFlagsDS                                    JMI107
                                                                                              JMI107
      *  Validation Work Fields                                                               JMI107
     C                   Parm                    Val@Fields                                   JMI107
     C                                                                                        JMI107
     C                   Endif                                                                JMI107

