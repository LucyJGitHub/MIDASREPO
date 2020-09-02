      *****************************************************************                       HUT106
      *  Midas - Copy member for FTOPAYVU                             *                       HUT106
      *                                                               *                       HUT106
      *  FTOPAYVUC4 - FT Outgoing Payments validate and update        *                       HUT106
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
      ** Check if switchable feature HUT106 is On                                             HUT106
      *                                                                                       HUT106
     C                   MOVE      'N'           HUT106            1                          HUT106
     C                   CALLB     'AOSARDR0'                                                 HUT106
     C                   PARM      *BLANKS       @RTCD                                        HUT106
     C                   PARM      '*VERIFY'     @OPTN                                        HUT106
     C                   PARM      'HUT106'      @SARD                                        HUT106
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT106
      *                                                                                       HUT106
     C                   IF        @RTCD = *BLANKS                                            HUT106
     C                   EVAL      HUT106 = 'Y'                                               HUT106
     C                   ELSE                                                                 HUT106
     C                   EVAL      HUT106 = 'N'                                               HUT106
     C                   ENDIF                                                                HUT106
      *                                                                                       HUT106
      *****************************************************************                       HUT106
      * End of /COPY FTOPAYVUC4                                       *                       HUT106
      *****************************************************************                       HUT106
