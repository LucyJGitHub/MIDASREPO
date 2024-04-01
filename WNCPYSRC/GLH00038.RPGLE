      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL0063)                                *
      *                                                               *
      *  GLH00038 - Midas GL Statement of Account Prompt              *
      *                                                               *
      *  Last Amend No. UUC102 *CREATE  Date 16Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC102 - Upgrade of CAR UUC063 to BF Midas 2.1               *
      *           UUC063 - Balance Statement Enhancement              *
      *                                                               *
      *****************************************************************
      ** Set initial values again                                               UUC102
     C     UUC102        IFEQ      'Y'                                          UUC102
     C                   Eval      CmdTex2 = SbmArr(4)                          UUC102
     C                   Eval      CmdTex2 = %REPLACE(PSUser:CmdTex2: +         UUC102
     C                                     %SCAN('SbmJobUsrP':CmdTex2))         UUC102
     C                   Eval      SbmArr(2)= CmdTex2                           UUC102
     C                   ENDIF                                                  UUC102
