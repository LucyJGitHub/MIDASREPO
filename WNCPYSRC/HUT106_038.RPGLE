      *****************************************************************                       HUT106
      *  Midas - Copy member for FTOPAYVU                             *                       HUT106
      *                                                               *                       HUT106
      *  HUT106_038 - FT Outgoing Payments validate and update        *                       HUT106
      *                                                               *                       HUT106
      *  Last Amend No. MD056457           Date 09Aug20               *                       HUT106
      *  Prev Amend No. HUT106 *CREATE     Date 09Aug20               *                       HUT106
      *                                                               *                       HUT106
      *---------------------------------------------------------------*                       HUT106
      *                                                               *                       HUT106
      *  MD056457 - FISC Code details not expanding to Customer Name  *                       HUT106
      *            on Inputs fields. Expand scope of HUT106           *                       HUT106
      *  HUT106 - Allow FISC Bank Reference to be entered in SWIFT ID *                       HUT106
      *           Field                                               *                       HUT106
      *                                                               *                       HUT106
      *****************************************************************                       HUT106
      *                                                                                       HUT106
      * If HUT106 is On and the current set-up of CNI details is blank                        HUT106
      * check if a FISC code has been entered, and if so use these details                    HUT106
      * in the CNI fields                                                                     HUT106
     C                   IF        HUT106 = 'Y' and CusIdx = 1                                HUT106
     C                             AND @RTCD <> *BLANKS                                       HUT106
     C                   MOVE      *IN55         IN55              1                          HUT106
     C                   MOVEL     SDST1         FISC_CD          12                          HUT106
     C     FISC_CD       CHAIN     SDCNSTL2                           55                      HUT106
     C                   IF        *IN55 = *OFF                                               HUT106
     C                   EVAL      DDD1SN = F_AWCPNC                                          HUT106
     C                   EVAL      DDD1NM = F_AWCPNM                                          HUT106
     C                   EVAL      DDD1TN = F_AWCNTN                                          HUT106
     C                   ENDIF                                                                HUT106
     C                   MOVE      IN55          *IN55                                        HUT106
     C                   ENDIF                                                                HUT106
      *****************************************************************                       HUT106
      * End of /COPY FTOPAYVUC4                                       *                       HUT106
      *****************************************************************                       HUT106
